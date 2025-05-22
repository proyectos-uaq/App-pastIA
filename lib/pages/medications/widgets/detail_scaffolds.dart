import 'package:flutter/material.dart';

class ErrorScaffold extends StatelessWidget {
  final String message;
  const ErrorScaffold({required this.message, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade50,
      appBar: AppBar(
        title: const Text('Detalle de medicamento'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Text(
          message,
          style: const TextStyle(color: Colors.red, fontSize: 16),
        ),
      ),
    );
  }
}

class NotFoundScaffold extends StatelessWidget {
  const NotFoundScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      appBar: AppBar(
        title: const Text('Detalle de medicamento'),
        backgroundColor: Colors.blue,
      ),
      body: const Center(
        child: Text(
          "No se pudo encontrar el medicamento.",
          style: TextStyle(color: Colors.deepOrange, fontSize: 16),
        ),
      ),
    );
  }
}

class NotAvailableScaffold extends StatelessWidget {
  const NotAvailableScaffold({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Detalle de medicamento'),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: const Center(child: Text("Token no disponible.")),
    );
  }
}

class LoadingScaffold extends StatelessWidget {
  const LoadingScaffold({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Detalle de medicamento'),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: const Center(child: CircularProgressIndicator()),
    );
  }
}
