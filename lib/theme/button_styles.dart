import 'package:flutter/material.dart';

ButtonStyle primaryButtonStyle({
  Color backgroundColor = Colors.blue,
  Color disabledBackgroundColor = Colors.blueGrey,
  Color foregroundColor = Colors.white,
}) {
  return ElevatedButton.styleFrom(
    padding: const EdgeInsets.symmetric(vertical: 16),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    backgroundColor: backgroundColor,
    disabledBackgroundColor: disabledBackgroundColor,
    foregroundColor: foregroundColor,
  );
}
