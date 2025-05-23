import 'package:flutter/material.dart';

// Este widget es un contenedor para mostrar notificaciones en la aplicación.
class NotificationContainer extends StatelessWidget {
  const NotificationContainer({
    super.key,
    required this.message,
    required this.icon,
    required this.backgroundColor,
    required this.textColor,
  });
  final String message;
  final IconData icon;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: textColor, width: 1),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: textColor),
            const SizedBox(width: 8),
            Expanded(child: Text(message, style: TextStyle(color: textColor))),
          ],
        ),
      ),
    );
  }
}
