import 'package:app_pastia/models/schedule_model.dart';
import 'package:flutter/material.dart';

class ScheduleCard extends StatelessWidget {
  final Schedule schedule;

  const ScheduleCard({super.key, required this.schedule});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Icono circular con la inicial del medicamento
            CircleAvatar(
              radius: 28,
              backgroundColor: Colors.blue.shade200,
              child: Text(
                (schedule.medicationName?.isNotEmpty ?? false)
                    ? schedule.medicationName![0].toUpperCase()
                    : '?',
                style: const TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Información principal
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    schedule.medicationName ?? 'Medicamento no disponible',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Hora: ${schedule.scheduledTime}',
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  const SizedBox(height: 4),
                ],
              ),
            ),
            // Botón de acción (por ejemplo, editar)
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blueAccent),
              onPressed: () {
                // Acción de editar (puedes personalizar esto)
              },
              tooltip: 'Editar horario',
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: () {
                // Acción de eliminar (puedes personalizar esto)
              },
              tooltip: 'Eliminar horario',
            ),
          ],
        ),
      ),
    );
  }
}
