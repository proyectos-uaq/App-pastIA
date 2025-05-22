import 'package:app_pastia/models/medication_model.dart';
import 'package:app_pastia/pages/medications/widgets/prescription_dropdown.dart';
import 'package:app_pastia/providers/medications_provider.dart';
import 'package:app_pastia/providers/prescription_provider.dart';
import 'package:app_pastia/services/medication_service.dart';
import 'package:app_pastia/widgets/custom_text_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateMedicationForm extends ConsumerStatefulWidget {
  final String token;
  final List prescriptions;
  final String? initialPrescriptionId;

  const CreateMedicationForm({
    super.key,
    required this.token,
    required this.prescriptions,
    this.initialPrescriptionId,
  });

  @override
  ConsumerState<CreateMedicationForm> createState() =>
      _CreateMedicationFormState();
}

class _CreateMedicationFormState extends ConsumerState<CreateMedicationForm> {
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
    selectedPrescriptionId = widget.initialPrescriptionId;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          PrescriptionDropdown(
            prescriptions: widget.prescriptions,
            selectedPrescriptionId: selectedPrescriptionId,
            lockedPrescriptionId: widget.initialPrescriptionId,
            onChanged:
                (value) => setState(() => selectedPrescriptionId = value),
          ),
          const SizedBox(height: 16),
          CustomTextFormField(
            controller: nameController,
            labelText: 'Nombre del medicamento',
            hintText: 'Ejemplo: Paracetamol',
            prefixIcon: Icons.medication,
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
            validator:
                (value) =>
                    value == null || value.trim().isEmpty
                        ? 'Campo requerido'
                        : null,
          ),
          const SizedBox(height: 16),
          IntervalTextFormField(controller: intervalController),
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
                          prescriptionId: selectedPrescriptionId!,
                        );

                        final response =
                            await MedicationService.createMedication(
                              medication: medication,
                              token: widget.token,
                            );

                        setState(() => saving = false);

                        if (context.mounted) {
                          if (response.error == null) {
                            ref.invalidate(medicationProvider(widget.token));
                            ref.invalidate(prescriptionProvider(widget.token));
                            ref.invalidate(
                              prescriptionDetailsProvider((
                                selectedPrescriptionId!,
                                widget.token,
                              )),
                            );
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
                                content: Text('Error: ${response.error}'),
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
