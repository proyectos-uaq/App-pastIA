import 'package:app_pastia/widgets/notification_container.dart';
import 'package:flutter/material.dart';

class TokenMissingScaffold extends StatelessWidget {
  const TokenMissingScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'No se encontró un token de sesión. Por favor inicia sesión nuevamente.',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}

class ErrorScaffold extends StatelessWidget {
  const ErrorScaffold({super.key, required this.error});
  final String error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: NotificationContainer(
          message: error,
          icon: Icons.error_outline_outlined,
          backgroundColor: Colors.red.shade100,
          textColor: Colors.red,
        ),
      ),
    );
  }
}
