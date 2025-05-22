import 'package:flutter/material.dart';

class ErrorScaffold extends StatelessWidget {
  final String tittle;
  final String message;
  const ErrorScaffold({required this.tittle, super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade50,
      appBar: AppBar(
        title: Text('Detalle de $tittle'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Text(message, style: TextStyle(color: Colors.red, fontSize: 16)),
      ),
    );
  }
}

class NotFoundScaffold extends StatelessWidget {
  final String tittle;
  final String message;
  const NotFoundScaffold({
    super.key,
    required this.tittle,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      appBar: AppBar(
        title: Text('Detalle de $tittle'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Text(
          message,
          style: TextStyle(color: Colors.deepOrange, fontSize: 16),
        ),
      ),
    );
  }
}

class NotAvailableScaffold extends StatelessWidget {
  final String tittle;
  final String message;
  const NotAvailableScaffold({
    super.key,
    required this.tittle,
    required this.message,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Detalle de $tittle'),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Center(child: Text(message)),
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
