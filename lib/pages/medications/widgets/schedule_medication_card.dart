import 'package:app_pastia/models/schedule_model.dart';
import 'package:app_pastia/services/schedule_service.dart';
import 'package:app_pastia/widgets/delete_confirmation_dialog.dart';
import 'package:flutter/material.dart';

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

  // Dialogo para editar la hora
  Future<bool?> _showEditTimeDialog(BuildContext context) async {
    TimeOfDay selectedTime = TimeOfDay(
      hour: int.tryParse(schedule.scheduledTime!.split(':')[0]) ?? 0,
      minute: int.tryParse(schedule.scheduledTime!.split(':')[1]) ?? 0,
    );
    bool saving = false;

    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              title: Row(
                children: const [
                  Icon(Icons.access_time, color: Colors.blueAccent),
                  SizedBox(width: 10),
                  Text("Editar horario"),
                ],
              ),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Hora actual: ${selectedTime.format(context)}",
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.schedule, color: Colors.blue),
                      label: const Text(
                        "Elegir nueva hora",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade100,
                        foregroundColor: Colors.blue.shade900,
                      ),
                      onPressed:
                          saving
                              ? null
                              : () async {
                                final picked = await showTimePicker(
                                  context: context,
                                  initialTime: selectedTime,
                                );
                                if (picked != null) {
                                  setState(() {
                                    selectedTime = picked;
                                  });
                                }
                              },
                    ),
                  ),
                ],
              ),
              actionsAlignment: MainAxisAlignment.spaceBetween,
              actions: [
                TextButton(
                  onPressed:
                      saving ? null : () => Navigator.of(context).pop(false),
                  child: const Text(
                    "Cancelar",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                ElevatedButton.icon(
                  icon:
                      saving
                          ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                          : const Icon(Icons.save, color: Colors.white),
                  label: Text(
                    saving ? "Guardando..." : "Guardar",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed:
                      saving
                          ? null
                          : () async {
                            setState(() => saving = true);

                            final scheduledTime = timeOfDayToHHmmss(
                              selectedTime,
                            );

                            final updatedSchedule = Schedule(
                              scheduledTime: scheduledTime,
                            );

                            var response = await ScheduleService.updateSchedule(
                              scheduleId: schedule.scheduleId!,
                              schedule: updatedSchedule,
                              token: token,
                            );

                            if (response.error != null) {
                              setState(() => saving = false);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      response.error!,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                              return;
                            }

                            setState(() => saving = false);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Horario actualizado correctamente",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }

                            // ignore: use_build_context_synchronously
                            Navigator.of(context).pop(true);
                          },
                ),
              ],
            );
          },
        );
      },
    );
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
                final updated = await _showEditTimeDialog(context);
                if (updated == true && onEventUpdated != null) {
                  onEventUpdated!(); // Notifica al padre para actualizar la lista
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              tooltip: 'Eliminar horario',
              onPressed: () async {
                final confirmation = await showDeleteConfirmationDialog(
                  context,
                  title: "Eliminar horario",
                  message:
                      "¿Estás seguro de que quieres eliminar este horario?",
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
              },
            ),
          ],
        ),
      ),
    );
  }
}
