import 'package:app_pastia/pages/medications/widgets/medication_form.dart';
import 'package:app_pastia/providers/prescription_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateMedicationPage extends ConsumerWidget {
  final String token;
  final String? prescriptionId;

  const CreateMedicationPage({
    super.key,
    required this.token,
    this.prescriptionId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prescriptionsAsync = ref.watch(prescriptionProvider(token));

    return Scaffold(
      appBar: AppBar(title: const Text('Agregar medicamento')),
      body: prescriptionsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (prescriptionData) {
          final prescriptions = prescriptionData.data ?? [];
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: CreateMedicationForm(
              token: token,
              prescriptions: prescriptions,
              initialPrescriptionId: prescriptionId,
            ),
          );
        },
      ),
    );
  }
}
