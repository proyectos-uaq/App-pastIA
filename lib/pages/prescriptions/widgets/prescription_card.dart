import 'package:app_pastia/models/prescription_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PrescriptionCard extends StatelessWidget {
  final Prescription prescription;
  const PrescriptionCard({super.key, required this.prescription});

  String formatDate(String? isoDate) {
    if (isoDate == null || isoDate.isEmpty) return 'Sin fecha';
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
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          // Acción al presionar la tarjeta
          Navigator.pushNamed(
            context,
            '/prescriptionDetails',
            arguments: {'prescriptionId': prescription.prescriptionId},
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icono decorativo
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(12),
                child: const Icon(
                  Icons.medical_services_rounded,
                  color: Colors.blue,
                  size: 32,
                ),
              ),
              const SizedBox(width: 18),
              // Información principal
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      prescription.name ?? 'Sin nombre',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.blue.shade900,
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
                        const SizedBox(width: 6),
                        Text(
                          'Creada el: ${formatDate(prescription.createdAt.toString())}',
                          style: const TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.medication,
                          size: 16,
                          color: Colors.amber,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Medicamentos: ${prescription.medicationCount ?? 'Sin descripción'}',
                          style: const TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Botón de acción (opcional)
              IconButton(
                icon: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.black,
                ),
                hoverColor: Colors.grey.shade100,
                iconSize: 24,
                onPressed: () {
                  // Acción al presionar el botón (puedes personalizar)
                  Navigator.pushNamed(
                    context,
                    '/prescriptionDetails',
                    arguments: {'prescriptionId': prescription.prescriptionId},
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
