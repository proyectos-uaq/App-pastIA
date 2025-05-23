import 'package:past_ia/models/medication_model.dart';
import 'package:past_ia/pages/medications/widgets/prescription_dropdown.dart';
import 'package:past_ia/providers/medications_provider.dart';
import 'package:past_ia/providers/prescription_provider.dart';
import 'package:past_ia/services/medication_service.dart';
import 'package:past_ia/widgets/custom_circular_progress_indicator.dart';
import 'package:past_ia/widgets/custom_text_fields.dart';
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
    return Center(
      child: SingleChildScrollView(
        child: Card(
          color: Colors.white,
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 32),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Encabezado visual
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          // ignore: deprecated_member_use
                          color: Colors.blueAccent.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(16),
                        child: const Icon(
                          Icons.medication,
                          color: Colors.blueAccent,
                          size: 42,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Agregar medicamento",
                        style: Theme.of(
                          context,
                        ).textTheme.headlineSmall?.copyWith(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Completa los datos para registrar un medicamento",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                  // Selector de receta
                  PrescriptionDropdown(
                    prescriptions: widget.prescriptions,
                    selectedPrescriptionId: selectedPrescriptionId,
                    lockedPrescriptionId: widget.initialPrescriptionId,
                    onChanged:
                        (value) =>
                            setState(() => selectedPrescriptionId = value),
                  ),
                  const SizedBox(height: 18),
                  CustomTextFormField(
                    controller: nameController,
                    labelText: 'Nombre del medicamento',
                    hintText: 'Ejemplo: Paracetamol',
                    prefixIcon: Icons.medication_outlined,
                    validator:
                        (value) =>
                            value == null || value.trim().isEmpty
                                ? 'Campo requerido'
                                : null,
                  ),
                  const SizedBox(height: 14),
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
                  const SizedBox(height: 14),
                  CustomTextFormField(
                    controller: formController,
                    labelText: 'Presentación',
                    hintText: 'Ejemplo: Tableta, jarabe, cápsula, inyección',
                    prefixIcon: Icons.category_outlined,
                    validator:
                        (value) =>
                            value == null || value.trim().isEmpty
                                ? 'Campo requerido'
                                : null,
                  ),
                  const SizedBox(height: 14),
                  CustomTextFormField(
                    controller: instructionsController,
                    labelText: 'Instrucciones',
                    hintText:
                        'Ejemplo: Tomar con agua cada 8 horas después de los alimentos',
                    prefixIcon: Icons.info_outline_rounded,
                    validator:
                        (value) =>
                            value == null || value.trim().isEmpty
                                ? 'Campo requerido'
                                : null,
                  ),
                  const SizedBox(height: 14),
                  IntervalTextFormField(controller: intervalController),
                  const SizedBox(height: 28),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: ElevatedButton.icon(
                      key: ValueKey(saving),
                      icon:
                          saving
                              ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: MyCustomLoader(),
                              )
                              : const Icon(Icons.add, color: Colors.white),
                      label: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          saving ? 'Guardando...' : 'Agregar medicamento',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(50),
                        elevation: 2,
                        // ignore: deprecated_member_use
                        shadowColor: Colors.blueAccent.withOpacity(0.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
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
                                      ref.invalidate(
                                        medicationProvider(widget.token),
                                      );
                                      ref.invalidate(
                                        prescriptionProvider(widget.token),
                                      );
                                      ref.invalidate(
                                        prescriptionDetailsProvider((
                                          selectedPrescriptionId!,
                                          widget.token,
                                        )),
                                      );
                                      Navigator.of(context).pop();
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Medicamento agregado correctamente',
                                          ),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Error: ${response.error}',
                                          ),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  }
                                }
                              },
                    ),
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
