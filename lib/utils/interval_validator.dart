String? intervalValidator(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Campo requerido';
  }
  final regex = RegExp(r'^\d{2,}:\d{2}:\d{2}$');
  if (!regex.hasMatch(value.trim())) {
    return 'El intervalo debe tener formato HH:MM:SS (ejemplo: 08:00:00 o 72:00:00)';
  }
  try {
    final parts = value.split(':');
    final h = int.parse(parts[0]);
    final m = int.parse(parts[1]);
    final s = int.parse(parts[2]);
    if (h < 0) return 'Las horas deben ser mayores o iguales a 0';
    if (m > 59 || m < 0 || s > 59 || s < 0) {
      return 'Minutos y segundos deben estar entre 00 y 59';
    }
  } catch (_) {
    return 'Formato inválido, usa HH:MM:SS';
  }
  return null;
}
