import 'package:app_pastia/models/medication_model.dart';
import 'package:app_pastia/utils/format_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

// Encabezado y detalles de la receta, junto a acciones y horarios.
class PrescriptionDetailScaffold extends StatelessWidget {
  final dynamic prescription;
  final String prescriptionId;
  final String token;
  final void Function(dynamic) onEditPrescription;
  final Future<void> Function(BuildContext, String) onDeletePrescription;
  final WidgetRef ref;
  const PrescriptionDetailScaffold({
    super.key,
    this.prescription,
    required this.prescriptionId,
    required this.token,
    required this.onEditPrescription,
    required this.onDeletePrescription,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          prescription?.name ?? 'Detalle de receta',
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
                        child: Icon(
                          Icons.receipt_long,
                          color: Colors.blue.shade600,
                          size: 36,
                        ),
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              prescription?.name ?? 'Receta',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 24,
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
                                  'Creada el: ${formatDate(prescription.createdAt.toString())}',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(
                                  Icons.medication,
                                  size: 16,
                                  color: Colors.yellow,
                                ),
                                const SizedBox(width: 7),
                                Text(
                                  'Cantidad de medicamentos: ${prescription.medications?.length ?? 0}',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                                const SizedBox(width: 10),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          IconButton(
                            tooltip: 'Eliminar receta',
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed:
                                () => onDeletePrescription(
                                  context,
                                  prescription.prescriptionId,
                                ),
                          ),
                          IconButton(
                            tooltip: 'Editar receta',
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => onEditPrescription(prescription),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      const Text(
                        'Medicamentos',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton.icon(
                        icon: Icon(Icons.add, color: Colors.blue.shade900),
                        label: const Text("Agregar medicamento"),
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
                  if (prescription.medications == null ||
                      prescription.medications!.isEmpty)
                    const Text(
                      'No hay medicamentos asociados a esta receta',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    )
                  else
                    Column(
                      children:
                          prescription.medications!
                              .map<Widget>(
                                (med) => _MedicationCard(medication: med),
                              )
                              .toList(),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MedicationCard extends StatelessWidget {
  final Medication medication;
  const _MedicationCard({required this.medication});

  String formatDate(String? isoDate) {
    if (isoDate == null) return 'Sin fecha';
    try {
      final date = DateTime.parse(isoDate);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return 'Sin fecha';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: Colors.blue.shade100, width: 2),
      ),
      color: Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        hoverColor: Colors.blue.shade100,
        onTap: () {
          // Navegar a la página de detalles de la medicación
          Navigator.pushNamed(
            context,
            '/medicationDetails',
            arguments: {'medicationId': medication.medicationId},
          );
        },
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
                  FontAwesomeIcons.tablets,
                  color: Colors.blue,
                  size: 30,
                ),
              ),
              const SizedBox(width: 14),
              // Información principal
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      medication.name ?? 'Sin nombre',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Colors.blue.shade800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Dosis: ${medication.dosage}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blueGrey.shade700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Frecuencia: cada ${formatInterval(medication.interval)}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blueGrey.shade600,
                      ),
                    ),
                    const SizedBox(height: 6),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
