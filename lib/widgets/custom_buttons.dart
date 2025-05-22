import 'package:flutter/material.dart';

/// Botón genérico reutilizable con icono, texto y estilo redondeado.
class RoundedIconButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color? iconColor;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double borderRadius;
  final double fontSize;
  final EdgeInsetsGeometry padding;
  final Color? borderColor;
  final double borderWidth;

  const RoundedIconButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.iconColor,
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius = 50,
    this.fontSize = 16,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    this.borderColor,
    this.borderWidth = 1,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Icon(icon, color: iconColor ?? Colors.blue.shade900),
      label: Text(label, style: TextStyle(fontSize: fontSize)),
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? Colors.blue.shade100,
        foregroundColor: foregroundColor ?? Colors.blue.shade900,
        padding: padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          side: BorderSide(
            color: borderColor ?? Colors.blue.shade100,
            width: borderWidth,
          ),
        ),
        textStyle: TextStyle(fontSize: fontSize),
      ),
      onPressed: onPressed,
    );
  }
}
