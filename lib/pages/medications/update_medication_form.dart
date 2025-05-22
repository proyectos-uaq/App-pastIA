import 'package:app_pastia/models/medication_model.dart';
import 'package:app_pastia/providers/medications_provider.dart';
import 'package:app_pastia/providers/prescription_provider.dart';
import 'package:app_pastia/services/medication_service.dart';
import 'package:app_pastia/widgets/text_fields/interval_text_field.dart';
import 'package:app_pastia/widgets/text_fields/text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdateMedicationForm extends ConsumerStatefulWidget {
  final String token;
  final Medication medication;

  const UpdateMedicationForm({
    super.key,
    required this.token,
    required this.medication,
  });

  @override
  ConsumerState<UpdateMedicationForm> createState() =>
      _UpdateMedicationFormState();
}

class _UpdateMedicationFormState extends ConsumerState<UpdateMedicationForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dosageController = TextEditingController();
  final TextEditingController formController = TextEditingController();
  final TextEditingController instructionsController = TextEditingController();
  final TextEditingController intervalController = TextEditingController();
  String? selectedPrescriptionId;
  bool saving = false;

  @override
  void initState() {
    super.initState();
    selectedPrescriptionId = widget.medication.prescriptionId;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          CustomTextFormField(
            controller: nameController,
            labelText: 'Nombre del medicamento',
            hintText: 'Ejemplo: Paracetamol',
            prefixIcon: Icons.medication,
            initialText: widget.medication.name,
            validator:
                (value) =>
                    value == null || value.trim().isEmpty
                        ? 'Campo requerido'
                        : null,
          ),
          const SizedBox(height: 16),
          CustomTextFormField(
            controller: dosageController,
            labelText: 'Dosis',
            hintText: 'Ejemplo: 500mg, 1 tableta o 10ml',
            prefixIcon: Icons.numbers,
            initialText: widget.medication.dosage,
            validator:
                (value) =>
                    value == null || value.trim().isEmpty
                        ? 'Campo requerido'
                        : null,
          ),
          const SizedBox(height: 16),
          CustomTextFormField(
            controller: formController,
            labelText: 'Presentación',
            hintText: 'Ejemplo: Tableta, jarabe, cápsula, inyección',
            prefixIcon: Icons.category,
            initialText: widget.medication.form,
            validator:
                (value) =>
                    value == null || value.trim().isEmpty
                        ? 'Campo requerido'
                        : null,
          ),
          const SizedBox(height: 16),
          CustomTextFormField(
            controller: instructionsController,
            labelText: 'Instrucciones',
            hintText:
                'Ejemplo: Tomar con agua cada 8 horas después de los alimentos',
            prefixIcon: Icons.info_outline,
            initialText: widget.medication.instructions,
            validator:
                (value) =>
                    value == null || value.trim().isEmpty
                        ? 'Campo requerido'
                        : null,
          ),
          const SizedBox(height: 16),
          IntervalTextFormField(
            controller: intervalController,
            initialText: widget.medication.interval,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            icon:
                saving
                    ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                    : const Icon(Icons.save),
            label: Text(saving ? 'Guardando...' : 'Guardar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(48),
            ),
            onPressed:
                saving
                    ? null
                    : () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() => saving = true);

                        Medication medication = Medication(
                          name: nameController.text,
                          dosage: dosageController.text,
                          form: formController.text,
                          instructions: instructionsController.text,
                          startDate: DateTime.now().toIso8601String(),
                          interval: intervalController.text,
                        );

                        final response =
                            await MedicationService.updateMedication(
                              medication: medication,
                              token: widget.token,
                              id: widget.medication.medicationId!,
                            );

                        setState(() => saving = false);

                        if (context.mounted) {
                          if (response.error == null) {
                            ref.invalidate(medicationProvider(widget.token));
                            ref.invalidate(prescriptionProvider(widget.token));
                            ref.invalidate(medicationsDetailProvider);
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Medicamento agregado correctamente',
                                ),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error: ${response.message}'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      }
                    },
          ),
        ],
      ),
    );
  }
}
