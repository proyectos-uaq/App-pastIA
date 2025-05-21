import 'package:app_pastia/pages/medications/medications_page.dart';
import 'package:app_pastia/providers/providers.dart';
import 'package:app_pastia/widgets/notification_container.dart';
import 'package:app_pastia/pages/medications/widgets/medication_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class MedicationListSection extends ConsumerWidget {
  final String token;
  const MedicationListSection({super.key, required this.token});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchText = ref.watch(medicationSearchProvider);
    final medicationsAsync = ref.watch(medicationProvider(token));
    final prescriptionsAsync = ref.watch(prescriptionProvider(token));

    return prescriptionsAsync.when(
      data: (prescriptionData) {
        final bool hasPrescriptions = (prescriptionData.data ?? []).isNotEmpty;
        return medicationsAsync.when(
          data: (data) {
            List medications = List.from(data.data ?? []);

            // Filtrar por búsqueda
            if (searchText.isNotEmpty) {
              medications =
                  medications.where((medication) {
                    final name = (medication.name ?? '').toLowerCase();
                    final query = searchText.toLowerCase();
                    return name.contains(query);
                  }).toList();
            }

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Campo de búsqueda
                    TextField(
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        hintText: 'Buscar medicamento por nombre...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onChanged: (value) {
                        ref.read(medicationSearchProvider.notifier).state =
                            value;
                      },
                    ),
                    const SizedBox(height: 18),
                    // Texto arriba de la lista y botón de agregar (condicionado a recetas)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Tus medicamentos",
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        if (hasPrescriptions)
                          ElevatedButton.icon(
                            icon: Icon(Icons.add, color: Colors.blue.shade900),
                            label: const Text("Nuevo medicamento"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade100,
                              foregroundColor: Colors.blue.shade900,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                                side: BorderSide(
                                  color: Colors.blue.shade100,
                                  width: 1,
                                ),
                              ),
                              textStyle: const TextStyle(fontSize: 16),
                            ),
                            onPressed: () {
                              // Acción para crear/abrir formulario de medicamento
                              // Navigator.pushNamed(context, '/crear-medicamento');
                            },
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (!hasPrescriptions)
                      NotificationContainer(
                        message:
                            'Primero debes registrar al menos una receta para poder agregar medicamentos.',
                        icon: Icons.error_outline,
                        backgroundColor: Colors.yellow.shade100,
                        textColor: Colors.yellow.shade900,
                      ),
                    if (medications.isEmpty && hasPrescriptions)
                      NotificationContainer(
                        message:
                            'No tienes medicamentos registrados. Presiona el botón "Nuevo medicamento" para agregar uno.',
                        icon: Icons.error_outline_outlined,
                        backgroundColor: Colors.blue.shade100,
                        textColor: Colors.blue.shade900,
                      ),
                    ...medications.map<Widget>(
                      (medication) => MedicationCard(medication: medication),
                    ),
                  ],
                ),
              ),
            );
          },
          error:
              (err, stackTrace) => NotificationContainer(
                message: '$err',
                icon: Icons.error_outline,
                backgroundColor: Colors.red.shade100,
                textColor: Colors.red,
              ),
          loading: () => const Center(child: CircularProgressIndicator()),
        );
      },
      error:
          (error, stackTrace) => NotificationContainer(
            message: "$error",
            icon: Icons.error_outline,
            backgroundColor: Colors.red.shade100,
            textColor: Colors.red,
          ),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
