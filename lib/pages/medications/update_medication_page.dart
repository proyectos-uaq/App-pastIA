import 'package:past_ia/models/medication_model.dart';
import 'package:past_ia/pages/medications/update_medication_form.dart';
import 'package:past_ia/providers/prescription_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:past_ia/widgets/custom_circular_progress_indicator.dart';

class UpdateMedicationPage extends ConsumerWidget {
  final String token;
  final Medication medication;

  const UpdateMedicationPage({
    super.key,
    required this.token,
    required this.medication,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prescriptionsAsync = ref.watch(prescriptionProvider(token));

    return Scaffold(
      appBar: AppBar(title: const Text('Editar medicamento')),
      body: prescriptionsAsync.when(
        loading: () => const Center(child: MyCustomLoader()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (prescriptionData) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: UpdateMedicationForm(token: token, medication: medication),
          );
        },
      ),
    );
  }
}
