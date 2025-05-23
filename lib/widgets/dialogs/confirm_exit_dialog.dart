import 'package:flutter/material.dart';

Future<bool?> showConfirmExitDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder:
        (context) => AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('¿Cerrar sesión?'),
          content: const Text(
            '¿Estás seguro de que deseas salir de tu cuenta?',
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          actions: [
            TextButton(
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.blue),
              ),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Salir'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        ),
  );
}
