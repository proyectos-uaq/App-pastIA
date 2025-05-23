import 'package:past_ia/models/schedule_model.dart';
import 'package:past_ia/services/schedule_service.dart';
import 'package:past_ia/utils/format_helpers.dart';
import 'package:past_ia/widgets/custom_dialogs.dart';
import 'package:flutter/material.dart';

class ScheduleMedicationCard extends StatelessWidget {
  final Schedule schedule;
  final String token;
  final VoidCallback? onEventUpdated;

  const ScheduleMedicationCard({
    super.key,
    required this.schedule,
    required this.token,
    this.onEventUpdated,
  });

  void _onDeleteSchedule(BuildContext context) async {
    final confirmation = await showDeleteConfirmationDialog(
      context,
      title: "Eliminar horario",
      message: "¿Estás seguro de que quieres eliminar este horario?",
      confirmText: "Eliminar",
      cancelText: "Cancelar",
      icon: Icons.delete_forever,
      iconColor: Colors.redAccent,
      confirmColor: Colors.red,
      cancelColor: Colors.blue,
    );
    if (confirmation == true) {
      // Llama a la función de eliminación
      final response = await ScheduleService.deleteSchedule(
        scheduleId: schedule.scheduleId!,
        token: token,
      );

      if (response.error != null) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              response.error!,
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Horario eliminado correctamente",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        ),
      );

      if (onEventUpdated != null) {
        onEventUpdated!(); // Notifica al padre para actualizar la lista
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.blue.shade100, width: 2),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: Colors.blue.shade200,
              child: Icon(
                Icons.schedule_outlined,
                color: Colors.blue.shade900,
                size: 30,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    // Muestra hora amigable tipo 10:00 am
                    'Hora: ${scheduledTimeToFriendly(schedule.scheduledTime!, context)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blueAccent),
              tooltip: 'Editar horario',
              onPressed: () async {
                final updated = await EditTimeDialog.show(
                  context,
                  token: token,
                  scheduleId: schedule.scheduleId!,
                  initialTime: schedule.scheduledTime!,
                );
                if (updated == true && onEventUpdated != null) {
                  onEventUpdated!(); // Notifica al padre para actualizar la lista
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              tooltip: 'Eliminar horario',
              onPressed: () => _onDeleteSchedule(context),
            ),
          ],
        ),
      ),
    );
  }
}
