import 'package:past_ia/models/schedule_model.dart';
import 'package:past_ia/services/schedule_service.dart';
import 'package:flutter/material.dart';
import 'package:past_ia/widgets/custom_circular_progress_indicator.dart';

class CreateTimeDialog {
  static String timeOfDayToHHmmss(TimeOfDay time) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return '${twoDigits(time.hour)}:${twoDigits(time.minute)}:00';
  }

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
                            child: ButtonProgressIndicator(),
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

                            Schedule schedule = Schedule(
                              scheduledTime: horarioFormateado,
                              medicationId: medicationId,
                            );

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
                                      'Ocurrió un error: ${response.message}',
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
