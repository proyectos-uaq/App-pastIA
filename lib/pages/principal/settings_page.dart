import 'package:app_pastia/providers/providers.dart';
import 'package:app_pastia/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
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
    final textScale = ref.watch(textScaleProvider);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Perfil con círculo de color
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Círculo de color
                  Container(
                    width: 48,
                    height: 48,
                    margin: const EdgeInsets.only(right: 16),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,
                    ),
                    child: Center(
                      child: Text(
                        username != null && username!.isNotEmpty
                            ? username![0].toUpperCase()
                            : '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Datos
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        username ?? 'Cargando...',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        email ?? '',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Tamaño de texto
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 0),
              title: const Row(
                children: [
                  Icon(Icons.format_size, color: Colors.orange),
                  SizedBox(width: 10),
                  Text('Tamaño de texto'),
                ],
              ),
              subtitle: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Colors.orange,
                  // ignore: deprecated_member_use
                  inactiveTrackColor: Colors.orange.withOpacity(0.3),
                  thumbColor: Colors.orange,
                  // ignore: deprecated_member_use
                  overlayColor: Colors.orange.withOpacity(0.15),
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 12,
                  ),
                  trackHeight: 4,
                  valueIndicatorColor: Colors.orange,
                ),
                child: Slider(
                  value: textScale,
                  min: 0.8,
                  max: 1.5,
                  divisions: 7,
                  label: '${(textScale * 100).toStringAsFixed(0)}%',
                  onChanged: (value) {
                    ref.read(textScaleProvider.notifier).state = value;
                  },
                ),
              ),
            ),
            const Divider(),

            // Cambiar contraseña
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 0),
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
              contentPadding: const EdgeInsets.symmetric(horizontal: 0),
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
