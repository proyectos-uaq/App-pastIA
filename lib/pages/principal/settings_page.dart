import 'package:app_pastia/services/auth_service.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notificationsEnabled = true;
  bool darkMode = false;
  String selectedLanguage = 'Español';
  double textScale = 1.0;

  final List<String> languages = ['Español', 'Inglés', 'Francés', 'Alemán'];

  String? username;
  String? email;

  @override
  void initState() {
    super.initState();
    _loadUserFromToken();
  }

  Future<void> _loadUserFromToken() async {
    final token = await AuthService.getJwtToken();
    final userData = AuthService.decodeJwt(token!);
    setState(() {
      username = userData?['name'] ?? 'Usuario';
      email = userData?['email'] ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Perfil
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  Text(
                    username ?? 'Cargando...',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    email ?? '',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),

            // Notificaciones
            ListTile(
              leading: const Icon(
                Icons.notifications_active,
                color: Colors.blue,
              ),
              title: const Text('Notificaciones'),
              trailing: Switch(
                value: notificationsEnabled,
                onChanged: (value) {
                  setState(() => notificationsEnabled = value);
                },
              ),
            ),
            const Divider(),

            // Modo oscuro
            ListTile(
              leading: const Icon(Icons.dark_mode, color: Colors.indigo),
              title: const Text('Modo oscuro'),
              trailing: Switch(
                value: darkMode,
                onChanged: (value) {
                  setState(() => darkMode = value);
                },
              ),
            ),
            const Divider(),

            // Idioma
            ListTile(
              leading: const Icon(Icons.language, color: Colors.green),
              title: const Text('Idioma'),
              subtitle: Text(selectedLanguage),
              trailing: DropdownButton<String>(
                value: selectedLanguage,
                items:
                    languages
                        .map(
                          (lang) =>
                              DropdownMenuItem(value: lang, child: Text(lang)),
                        )
                        .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => selectedLanguage = value);
                  }
                },
              ),
            ),
            const Divider(),

            // Tamaño de texto
            ListTile(
              leading: const Icon(Icons.format_size, color: Colors.orange),
              title: const Text('Tamaño del texto'),
              subtitle: Slider(
                value: textScale,
                min: 0.8,
                max: 1.5,
                divisions: 7,
                label: '${(textScale * 100).toStringAsFixed(0)}%',
                onChanged: (value) {
                  setState(() => textScale = value);
                },
              ),
            ),
            const Divider(),

            // Cambiar contraseña
            ListTile(
              leading: const Icon(Icons.lock, color: Colors.red),
              title: const Text('Cambiar contraseña'),
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey[400]),
              onTap: () {
                // Acción para cambiar contraseña
              },
            ),
            const Divider(),

            // Cerrar sesión
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.grey),
              title: const Text('Cerrar sesión'),
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey[400]),
              onTap: () {
                var authService = AuthService();
                authService.removeJwtToken().then((_) {
                  // ignore: use_build_context_synchronously
                  Navigator.pushReplacementNamed(context, '/login');
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
