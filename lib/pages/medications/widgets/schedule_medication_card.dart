import 'package:app_pastia/models/schedule_model.dart';
import 'package:flutter/material.dart';

class ScheduleMedicationCard extends StatelessWidget {
  final Schedule schedule;

  const ScheduleMedicationCard({super.key, required this.schedule});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: Colors.blue.shade100, width: 2),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Icono circular con la inicial del medicamento
            CircleAvatar(
              radius: 28,
              backgroundColor: Colors.blue.shade200,
              child: Icon(
                Icons.schedule_outlined,
                size: 28,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    schedule.scheduledTime ?? 'Hora no disponible',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
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
