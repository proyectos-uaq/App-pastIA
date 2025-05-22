import 'package:flutter/material.dart';

class PrescriptionDropdown extends StatelessWidget {
  final List prescriptions;
  final String? selectedPrescriptionId;
  final String? lockedPrescriptionId;
  final Function(String?)? onChanged;

  const PrescriptionDropdown({
    super.key,
    required this.prescriptions,
    required this.selectedPrescriptionId,
    this.lockedPrescriptionId,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedPrescriptionId,
      items:
          prescriptions.map<DropdownMenuItem<String>>((prescription) {
            return DropdownMenuItem<String>(
              value: prescription.prescriptionId,
              child: Text(prescription.name ?? 'Sin nombre'),
            );
          }).toList(),
      onChanged: lockedPrescriptionId != null ? null : onChanged,
      validator:
          (value) =>
              value == null || value.isEmpty ? 'Selecciona una receta' : null,
      decoration: const InputDecoration(
        labelText: 'Receta',
        hintText: 'Elige la receta a la que pertenecerá el medicamento',
        border: OutlineInputBorder(),
      ),
    );
  }
}
