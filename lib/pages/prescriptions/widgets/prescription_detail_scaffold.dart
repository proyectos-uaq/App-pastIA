import 'package:past_ia/models/medication_model.dart';
import 'package:past_ia/services/ia_service.dart';
import 'package:past_ia/utils/format_helpers.dart';
import 'package:past_ia/widgets/custom_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:past_ia/widgets/dialogs/progress_dialog.dart';
import 'package:past_ia/widgets/dialogs/slow_operation_dialog.dart';
import 'package:past_ia/widgets/dialogs/error_dialog.dart';

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

  Future<void> _sendDataToAI(BuildContext context) async {
    // 1. Mostrar el diálogo de progreso
    showProgressDialog(
      context,
      message: 'Procesando información de la receta...',
    );

    // 2. Esperar la respuesta de la API
    final response = await sendDataToAI(
      prescriptionId: prescriptionId,
      token: token,
    );

    // 3. Cerrar el diálogo de progreso
    // ignore: use_build_context_synchronously
    Navigator.of(context, rootNavigator: true).pop();

    // 4. Mostrar error si corresponde
    if (response.statusCode != 200) {
      // ignore: use_build_context_synchronously
      await showErrorDialog(context, response.message);
      return;
    }

    // Aquí continúa el flujo normal si fue éxito
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          '¡Tus horarios fueron actualizados correctamente!',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.green[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

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
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                                Expanded(
                                  child: Text(
                                    'Creada el: ${formatDate(prescription.createdAt.toString())}',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                    ),
                                    overflow: TextOverflow.ellipsis,
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
                                Expanded(
                                  child: Text(
                                    'Cantidad de medicamentos: ${prescription.medications?.length ?? 0}',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                    ),
                                    overflow: TextOverflow.ellipsis,
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
                  Align(
                    alignment: Alignment.topRight,
                    child: RoundedIconButton(
                      icon: Icons.smart_toy_outlined,
                      label: 'Enviar datos a la IA',
                      onPressed: () async {
                        final confirmation = await showSlowOperationInfoDialog(
                          context,
                        );
                        if (confirmation == true) {
                          // ignore: use_build_context_synchronously
                          await _sendDataToAI(context);
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Text(
                          'Medicamentos',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis, // Por si acaso
                        ),
                      ),
                      Flexible(
                        child: RoundedIconButton(
                          icon: Icons.add,
                          label: 'Agregar medicamento',
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/createMedication',
                              arguments: {
                                'token': token,
                                'prescriptionId': prescription.prescriptionId,
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      medication.name ?? 'Sin nombre',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Colors.black,
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
