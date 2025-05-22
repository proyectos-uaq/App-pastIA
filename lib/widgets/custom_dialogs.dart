import 'package:app_pastia/models/schedule_model.dart';
import 'package:app_pastia/services/schedule_service.dart';
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

class EditTimeDialog {
  /// Convierte un TimeOfDay a formato "HH:mm:ss"
  static String timeOfDayToHHmmss(TimeOfDay time) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return '${twoDigits(time.hour)}:${twoDigits(time.minute)}:00';
  }

  /// Muestra el diálogo y retorna [true] si se guardó, [false] si se canceló.
  static Future<bool?> show(
    BuildContext context, {
    required String token,
    required String scheduleId,
    required String initialTime, // formato "HH:mm:ss" o "HH:mm"
  }) async {
    TimeOfDay selectedTime;
    try {
      final parts = initialTime.split(":");
      selectedTime = TimeOfDay(
        hour: int.tryParse(parts[0]) ?? 0,
        minute: int.tryParse(parts[1]) ?? 0,
      );
    } catch (_) {
      selectedTime = TimeOfDay.now();
    }
    bool saving = false;

    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
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

                            final horarioFormateado = timeOfDayToHHmmss(
                              selectedTime,
                            );

                            Schedule schedule = Schedule(
                              scheduledTime: horarioFormateado,
                            );

                            var response = await ScheduleService.updateSchedule(
                              token: token,
                              scheduleId: scheduleId,
                              schedule: schedule,
                            );

                            setState(() => saving = false);

                            if (context.mounted) {
                              if (response.error == null) {
                                // Todo OK
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Horario actualizado correctamente",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                                Navigator.of(context).pop(true);
                              } else {
                                // Hubo error
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      response.error!,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    backgroundColor:
                                        response.error!.toLowerCase().contains(
                                              'token',
                                            )
                                            ? Colors.orange
                                            : Colors.red,
                                  ),
                                );
                              }
                            }
                          },
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class CreateTimeDialog {
  /// Convierte un TimeOfDay a formato "HH:mm:ss"
  static String timeOfDayToHHmmss(TimeOfDay time) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return '${twoDigits(time.hour)}:${twoDigits(time.minute)}:00';
  }

  /// Muestra el diálogo y retorna [true] si se guardó, [false] si se canceló.
  static Future<bool?> show(
    BuildContext context, {
    required String token,
    required String medicationId,
  }) async {
    TimeOfDay selectedTime = TimeOfDay.now();
    bool saving = false;

    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              title: Row(
                children: const [
                  Icon(Icons.access_time, color: Colors.green),
                  SizedBox(width: 10),
                  Text("Agregar horario"),
                ],
              ),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Hora seleccionada: ${selectedTime.format(context)}",
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.schedule, color: Colors.green),
                      label: const Text(
                        "Elegir hora",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade50,
                        foregroundColor: Colors.green.shade900,
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
                          : const Icon(Icons.add, color: Colors.white),
                  label: Text(
                    saving ? "Guardando..." : "Agregar",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
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

                            final horarioFormateado = timeOfDayToHHmmss(
                              selectedTime,
                            );

                            // Crear el objeto Schedule, ajusta los parámetros según tu modelo/backend
                            Schedule schedule = Schedule(
                              scheduledTime: horarioFormateado,
                              medicationId: medicationId,
                            );

                            print(schedule.toJson());

                            var response = await ScheduleService.createSchedule(
                              token: token,
                              schedule: schedule,
                            );

                            setState(() => saving = false);

                            if (context.mounted) {
                              if (response.error == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Horario creado correctamente",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                                Navigator.of(context).pop(true);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Ocurrio un error: ${response.message}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    backgroundColor:
                                        response.error!.toLowerCase().contains(
                                              'token',
                                            )
                                            ? Colors.orange
                                            : Colors.red,
                                  ),
                                );
                              }
                            }
                          },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
