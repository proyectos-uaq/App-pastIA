import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Formatea una fecha ISO a dd/MM/yyyy
String formatDate(String? isoDate) {
  if (isoDate == null || isoDate.isEmpty) return 'Sin fecha';
  try {
    final date = DateTime.parse(isoDate);
    return DateFormat('dd/MM/yyyy').format(date);
  } catch (_) {
    return 'Sin fecha';
  }
}

/// Formatea un intervalo tipo "HH:mm:ss" a texto amigable
String formatInterval(String? interval) {
  if (interval == null || interval.isEmpty) return 'No especificada';

  final parts = interval.split(':');
  if (parts.length != 3) return interval;

  final hours = int.tryParse(parts[0]) ?? 0;
  final minutes = int.tryParse(parts[1]) ?? 0;
  final seconds = int.tryParse(parts[2]) ?? 0;

  if (hours > 0) {
    return '$hours horas'
        '${minutes > 0 ? ' $minutes minutos' : ''}'
        '${seconds > 0 ? ' $seconds segundos' : ''}';
  } else if (minutes > 0) {
    return '$minutes minutos'
        '${seconds > 0 ? ' $seconds segundos' : ''}';
  } else {
    return '$seconds segundos';
  }
}

// Utilidad para convertir TimeOfDay a "HH:mm:ss"
String timeOfDayToHHmmss(TimeOfDay time) {
  final hour = time.hour.toString().padLeft(2, '0');
  final minute = time.minute.toString().padLeft(2, '0');
  final second = '00';
  return '$hour:$minute:$second';
}

// Para mostrar la hora amigable tipo "10:00 am"
String scheduledTimeToFriendly(String scheduledTime, BuildContext context) {
  final parts = scheduledTime.split(':');
  if (parts.length < 2) return scheduledTime;
  final hour = int.tryParse(parts[0]) ?? 0;
  final minute = int.tryParse(parts[1]) ?? 0;
  final timeOfDay = TimeOfDay(hour: hour, minute: minute);
  return timeOfDay.format(context);
}
