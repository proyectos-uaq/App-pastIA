import 'package:app_pastia/models/medication_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

String _formatInterval(String? interval) {
  if (interval == null || interval.isEmpty) return 'No especificada';

  final parts = interval.split(':');
  if (parts.length != 3) return interval;

  final hours = int.tryParse(parts[0]) ?? 0;
  final minutes = int.tryParse(parts[1]) ?? 0;
  final seconds = int.tryParse(parts[2]) ?? 0;

  if (hours > 0) {
    return '$hours horas'
        '${minutes > 0 ? ' $minutes minutos' : ''}'
        '${seconds > 0 ? ' $seconds segundos' : ''}';
  } else if (minutes > 0) {
    return '$minutes minutos'
        '${seconds > 0 ? ' $seconds segundos' : ''}';
  } else {
    return '$seconds segundos';
  }
}

class MedicationPrescriptionCard extends StatelessWidget {
  final Medication medication;
  const MedicationPrescriptionCard({super.key, required this.medication});

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
                      'Frecuencia: cada ${_formatInterval(medication.interval)}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blueGrey.shade600,
                      ),
                    ),
                    const SizedBox(height: 6),
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
