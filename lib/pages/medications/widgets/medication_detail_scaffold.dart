import 'package:past_ia/pages/medications/widgets/detail_row.dart';
import 'package:past_ia/pages/schedules/intake_logs_page.dart';
import 'package:past_ia/pages/schedules/widgets/schedule_card.dart';
import 'package:past_ia/providers/medications_provider.dart';
import 'package:past_ia/utils/format_helpers.dart';
import 'package:past_ia/widgets/custom_buttons.dart';
import 'package:past_ia/widgets/custom_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Encabezado y detalles del medicamento, junto a acciones y horarios.
class MedicationDetailScaffold extends StatelessWidget {
  final dynamic medication;
  final String medicationId;
  final String token;
  final void Function(dynamic) onEditMedication;
  final Future<void> Function(BuildContext, String) onDeleteMedication;
  final WidgetRef ref;

  const MedicationDetailScaffold({
    required this.medication,
    required this.medicationId,
    required this.token,
    required this.onEditMedication,
    required this.onDeleteMedication,
    required this.ref,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          medication.name ?? 'Detalle de medicamento',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 26),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header con icono y datos principales
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              // ignore: deprecated_member_use
                              color: Colors.blue.shade100.withOpacity(0.2),
                              blurRadius: 12,
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(18),
                        child: const Icon(
                          Icons.vaccines_rounded,
                          color: Color(0xFF1976D2),
                          size: 38,
                        ),
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              medication.name ?? 'Sin nombre',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 22,
                                color: Colors.blue.shade800,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  size: 15,
                                  color: Colors.green.shade400,
                                ),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    'Fecha de inicio: ${formatDate(medication.startDate)}',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.green.shade700,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          IconButton(
                            tooltip: 'Eliminar medicamento',
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed:
                                () => onDeleteMedication(
                                  context,
                                  medication.medicationId.toString(),
                                ),
                          ),
                          IconButton(
                            tooltip: 'Editar medicamento',
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => onEditMedication(medication),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Más detalles
                  ..._medicationDetailsList(medication),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Horarios',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Flexible(
                        child: RoundedIconButton(
                          icon: Icons.add,
                          label: 'Nuevo horario',
                          onPressed: () async {
                            final created = await CreateTimeDialog.show(
                              context,
                              token: token,
                              medicationId: medication.medicationId,
                            );
                            if (created == true) {
                              ref.invalidate(
                                medicationsDetailProvider((
                                  medicationId,
                                  token,
                                )),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (medication.schedules == null ||
                      medication.schedules!.isEmpty)
                    const Text(
                      'No hay horarios registrados.',
                      style: TextStyle(color: Colors.grey),
                    )
                  else
                    ..._orderedScheduleCards(
                      medication.schedules!,
                      token,
                      ref,
                      medicationId,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _medicationDetailsList(dynamic medication) {
    return [
      DetailRow(label: 'Dosis', value: medication.dosage ?? 'No especificada'),
      DetailRow(
        label: 'Frecuencia',
        value: 'Cada ${formatInterval(medication.interval)}',
      ),
      DetailRow(label: 'Forma', value: medication.form ?? 'No especificada'),
    ];
  }

  List<Widget> _orderedScheduleCards(
    List schedules,
    String token,
    WidgetRef ref,
    String medicationId,
  ) {
    final sorted = List.from(schedules)..sort((a, b) {
      final aTime = a.scheduledTime ?? '';
      final bTime = b.scheduledTime ?? '';
      if (aTime.length >= 5 && bTime.length >= 5) {
        return aTime.compareTo(bTime);
      }
      return 0;
    });
    return sorted
        .map<Widget>(
          (schedule) => ScheduleCard(
            schedule: schedule,
            token: token,
            onEventUpdated: () {
              ref.invalidate(medicationsDetailProvider((medicationId, token)));
            },
            showMedicationName: false,
            onTapNavigate: (context, schedule) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => IntakeLogsPage(
                        scheduleId: schedule.scheduleId!,
                        token: token,
                      ),
                ),
              );
            },
          ),
        )
        .toList();
  }
}
