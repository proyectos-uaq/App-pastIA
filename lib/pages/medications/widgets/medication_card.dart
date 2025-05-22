import 'package:app_pastia/models/medication_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class MedicationCard extends StatelessWidget {
  final Medication medication;
  const MedicationCard({super.key, required this.medication});

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
      elevation: 6,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      color: Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
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
                      'Forma: ${medication.form}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blueGrey.shade700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Frecuencia: cada ${medication.interval!.split(':')[0]} horas',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blueGrey.shade600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 15,
                          color: Colors.green.shade400,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'Fecha de inicio: ${formatDate(medication.startDate)}',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.green.shade700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Botón de acción (opcional)
              // Este boton puede ser para ver mas detalles
              // IconButton(
              //   icon: Icon(Icons.info_outline, color: Colors.grey),
              //   onPressed: () {
              //     // Acción al tocar el botón (puedes personalizar)
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
