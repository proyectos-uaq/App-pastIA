import 'package:app_pastia/pages/medications/widgets/detail_row.dart';
import 'package:app_pastia/providers/medications_provider.dart';
import 'package:app_pastia/utils/format_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_pastia/pages/medications/widgets/schedule_medication_card.dart';

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
                                const Icon(
                                  Icons.calendar_today,
                                  size: 16,
                                  color: Colors.green,
                                ),
                                const SizedBox(width: 7),
                                Text(
                                  'Fecha de inicio: ${formatDate(medication.startDate)}',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey.shade700,
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
                    children: [
                      const Text(
                        'Horarios de toma',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton.icon(
                        icon: Icon(Icons.add, color: Colors.blue.shade900),
                        label: const Text("Nuevo horario"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade100,
                          foregroundColor: Colors.blue.shade900,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                            side: BorderSide(
                              color: Colors.blue.shade100,
                              width: 1,
                            ),
                          ),
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                        onPressed: () {
                          // TODO: Acción para agregar nuevo horario
                        },
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
          (schedule) => ScheduleMedicationCard(
            schedule: schedule,
            token: token,
            onEventUpdated: () {
              ref.invalidate(medicationsDetailProvider((medicationId, token)));
            },
          ),
        )
        .toList();
  }
}
