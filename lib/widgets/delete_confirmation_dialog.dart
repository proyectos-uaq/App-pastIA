import 'package:flutter/material.dart';

/// Modal genérico para confirmación de eliminación.
///
/// Devuelve `true` si el usuario confirma, `false` si cancela o cierra.
Future<bool?> showDeleteConfirmationDialog(
  BuildContext context, {
  String title = "Eliminar",
  String message = "¿Estás seguro de que quieres eliminar este elemento?",
  String confirmText = "Eliminar",
  String cancelText = "Cancelar",
  IconData icon = Icons.delete_forever,
  Color iconColor = Colors.redAccent,
  Color confirmColor = Colors.red,
  Color cancelColor = Colors.grey,
}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Row(
          children: [
            Icon(icon, color: iconColor),
            const SizedBox(width: 10),
            Text(title),
          ],
        ),
        content: Text(message, style: const TextStyle(fontSize: 16)),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            style: TextButton.styleFrom(foregroundColor: cancelColor),
            child: Text(cancelText),
          ),
          ElevatedButton.icon(
            icon: Icon(icon, color: Colors.white),
            label: Text(confirmText),
            style: ElevatedButton.styleFrom(
              backgroundColor: confirmColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      );
    },
  );
}
