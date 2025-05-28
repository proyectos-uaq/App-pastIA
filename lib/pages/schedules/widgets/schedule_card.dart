import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:past_ia/models/schedule_model.dart';
import 'package:past_ia/services/schedule_service.dart';
import 'package:past_ia/utils/format_helpers.dart';
import 'package:past_ia/widgets/custom_dialogs.dart';

class ScheduleCard extends StatelessWidget {
  final Schedule schedule;
  final String token;
  final VoidCallback? onEventUpdated;
  final void Function(BuildContext context, Schedule schedule)? onTapNavigate;
  final bool showMedicationName;

  const ScheduleCard({
    super.key,
    required this.schedule,
    required this.token,
    this.onEventUpdated,
    this.onTapNavigate,
    this.showMedicationName = true, // Por defecto muestra el nombre
  });

  Future<void> _onDeleteSchedule(BuildContext context) async {
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
        onEventUpdated!();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      color: Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap:
            onTapNavigate != null
                ? () => onTapNavigate!(context, schedule)
                : null,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(12),
                child: Icon(
                  FontAwesomeIcons.bell,
                  color: Colors.blue,
                  size: 30,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showMedicationName)
                      Text(
                        schedule.medicationName ?? 'Medicamento no disponible',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    if (showMedicationName) const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 25,
                          color: Colors.blue.shade900,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Hora: ${scheduledTimeToFriendly(schedule.scheduledTime!, context)}',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.blue.shade900,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                  ],
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                        onEventUpdated!();
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
            ],
          ),
        ),
      ),
    );
  }
}
