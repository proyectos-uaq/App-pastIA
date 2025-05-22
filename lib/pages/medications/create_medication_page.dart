import 'package:app_pastia/models/medication_model.dart';
import 'package:app_pastia/providers/medications_provider.dart';
import 'package:app_pastia/providers/prescription_provider.dart';
import 'package:app_pastia/services/medication_service.dart';
import 'package:app_pastia/widgets/custom_text_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateMedicationPage extends ConsumerStatefulWidget {
  final String token;
  final String? prescriptionId; // <-- Permite el id de receta opcionalmente

  const CreateMedicationPage({
    super.key,
    required this.token,
    this.prescriptionId,
  });

  @override
  ConsumerState<CreateMedicationPage> createState() =>
      _CreateMedicationPageState();
}

class _CreateMedicationPageState extends ConsumerState<CreateMedicationPage> {
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
    // Si se pasa un prescriptionId, selecciona y bloquea la receta
    if (widget.prescriptionId != null) {
      selectedPrescriptionId = widget.prescriptionId;
    }
  }

  String? intervalValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Campo requerido';
    }
    final regex = RegExp(
      r'^\d{2,}:\d{2}:\d{2}$',
    ); // Permite horas de 2 o más dígitos
    if (!regex.hasMatch(value.trim())) {
      return 'El intervalo debe tener formato HH:MM:SS (ejemplo: 08:00:00 o 72:00:00)';
    }
    try {
      final parts = value.split(':');
      final h = int.parse(parts[0]);
      final m = int.parse(parts[1]);
      final s = int.parse(parts[2]);
      if (h < 0) {
        return 'Las horas deben ser mayores o iguales a 0';
      }
      if (m > 59 || m < 0 || s > 59 || s < 0) {
        return 'Minutos y segundos deben estar entre 00 y 59';
      }
    } catch (_) {
      return 'Formato inválido, usa HH:MM:SS';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final prescriptionsAsync = ref.watch(prescriptionProvider(widget.token));

    return Scaffold(
      appBar: AppBar(title: const Text('Agregar medicamento')),
      body: prescriptionsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (prescriptionData) {
          final prescriptions = prescriptionData.data ?? [];
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  DropdownButtonFormField<String>(
                    value: selectedPrescriptionId,
                    items:
                        prescriptions.map<DropdownMenuItem<String>>((
                          prescription,
                        ) {
                          return DropdownMenuItem<String>(
                            value: prescription.prescriptionId,
                            child: Text(prescription.name ?? 'Sin nombre'),
                          );
                        }).toList(),
                    onChanged:
                        widget.prescriptionId != null
                            ? null // Si se pasa prescriptionId, se bloquea el dropdown
                            : (value) =>
                                setState(() => selectedPrescriptionId = value),
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? 'Selecciona una receta'
                                : null,
                    decoration: const InputDecoration(
                      labelText: 'Receta',
                      hintText:
                          'Elige la receta a la que pertenecerá el medicamento',
                      border: OutlineInputBorder(),
                    ),
                    disabledHint:
                        widget.prescriptionId != null
                            ? Text(
                              prescriptions
                                      .firstWhere(
                                        (e) =>
                                            e.prescriptionId ==
                                            widget.prescriptionId,
                                        orElse: () => prescriptions.first,
                                      )
                                      .name ??
                                  'Sin nombre',
                            )
                            : null,
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
                  CustomTextFormField(
                    controller: intervalController,
                    labelText: 'Intervalo',
                    hintText:
                        'Ejemplo: 08:00:00 para cada 8 horas, 12:00:00 para cada 12 horas',
                    prefixIcon: Icons.schedule,
                    validator: intervalValidator,
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
                                    // Notifica a los providers para recargar
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
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
