import 'package:past_ia/models/user_model.dart';
import 'package:past_ia/services/auth_service.dart';
import 'package:past_ia/theme/button_styles.dart';
import 'package:past_ia/widgets/custom_circular_progress_indicator.dart';
import 'package:past_ia/widgets/text_fields/text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:past_ia/widgets/logo.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isSubmitting = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() async {
    setState(() {
      _errorMessage = null;
    });

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      // Generar un objeto de usuario
      User user = User(
        email: _emailController.text,
        password: _passwordController.text,
      );

      var response = await AuthService.login(user: user);

      if (response.statusCode == 500) {
        setState(() {
          _errorMessage =
              "Ocurrió un error en nuestros servidores, por favor intenta de nuevo más tarde";
          _isSubmitting = false;
        });
        return;
      }

      if (response.statusCode != 200) {
        setState(() {
          _errorMessage = response.message;
          _isSubmitting = false;
        });
        return;
      }

      if (response.statusCode == 200) {
        // Guardar el token en el almacenamiento local
        await AuthService.saveJwtToken(token: response.data!);

        // Navegar a la página principal
        // ignore: use_build_context_synchronously
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      }
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'El correo es obligatorio';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Correo inválido';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'La contraseña es obligatoria';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _Header(),

              const SizedBox(height: 20),

              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomTextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      labelText: 'Correo electrónico',
                      prefixIcon: FontAwesomeIcons.envelope,
                      validator: _validateEmail,
                      enabled: !_isSubmitting,
                    ),

                    const SizedBox(height: 16),

                    CustomTextFormField(
                      controller: _passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      labelText: 'Contraseña',
                      prefixIcon: Icons.lock_outline,
                      validator: _validatePassword,
                      enabled: !_isSubmitting,
                      obscureText: true,
                    ),
                    const SizedBox(height: 24),

                    if (_errorMessage != null)
                      _ErrorContainer(errorMessage: _errorMessage),

                    ElevatedButton(
                      onPressed: _isSubmitting ? null : _submit,
                      style: primaryButtonStyle(),
                      child:
                          _isSubmitting
                              ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: MyCustomLoader(),
                              )
                              : const Text(
                                'Iniciar Sesión',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/signup');
                      },
                      style: primaryButtonStyle(
                        backgroundColor: Colors.blue.shade100,
                        foregroundColor: Colors.black,
                      ),
                      child: const Text(
                        'Registrarse',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorContainer extends StatelessWidget {
  const _ErrorContainer({required String? errorMessage})
    : _errorMessage = errorMessage;

  final String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.red.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.shade300),
      ),
      child: Row(
        children: [
          // Si usas FontAwesome, reemplaza el icono por FontAwesomeIcons.circleExclamation
          Icon(Icons.error_outline, size: 20, color: Colors.red.shade700),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _errorMessage!,
              style: TextStyle(color: Colors.red.shade800, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 40),

        Logo(height: 120, width: 120, iconSize: 60),

        const SizedBox(height: 32),

        const Text(
          'PAST-IA',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 8),

        Text(
          'Inicio de sesión',
          style: TextStyle(fontSize: 20, color: Colors.grey.shade700),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
