import 'package:app_pastia/pages/medications/medication_nav_providers.dart';
import 'package:app_pastia/pages/medications/widgets/medication_card.dart';
import 'package:app_pastia/providers/medications_provider.dart';
import 'package:app_pastia/providers/prescription_provider.dart';
import 'package:app_pastia/widgets/custom_buttons.dart';
import 'package:app_pastia/widgets/notification_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widgets/custom_text_fields.dart';

/// Widget principal que muestra la sección de medicamentos.
class MedicationListSection extends ConsumerWidget {
  final String token;
  const MedicationListSection({super.key, required this.token});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Observa el valor de búsqueda, medicamentos y recetas (prescriptions)
    final searchText = ref.watch(medicationSearchProvider);
    final medicationsAsync = ref.watch(medicationProvider(token));
    final prescriptionsAsync = ref.watch(prescriptionProvider(token));

    // Maneja el estado de recetas (prescriptions)
    return prescriptionsAsync.when(
      data: (prescriptionData) {
        final bool hasPrescriptions = (prescriptionData.data ?? []).isNotEmpty;

        // Si hay recetas, muestra la lista de medicamentos
        return medicationsAsync.when(
          data: (medicationData) {
            return MedicationListContent(
              medications: List.from(medicationData.data ?? []),
              searchText: searchText,
              hasPrescriptions: hasPrescriptions,
              token: token,
              onSearchChanged: (value) {
                ref.read(medicationSearchProvider.notifier).state = value;
              },
            );
          },
          error: (err, stack) => ErrorNotification(message: '$err'),
          loading: () => const Center(child: CircularProgressIndicator()),
        );
      },
      error: (err, stack) => ErrorNotification(message: '$err'),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}

/// Widget que contiene el contenido principal de la lista de medicamentos.
class MedicationListContent extends StatelessWidget {
  final List medications;
  final String searchText;
  final bool hasPrescriptions;
  final String token;
  final ValueChanged<String> onSearchChanged;

  const MedicationListContent({
    super.key,
    required this.medications,
    required this.searchText,
    required this.hasPrescriptions,
    required this.token,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Filtra los medicamentos por el texto de búsqueda
    List filteredMedications = medications;
    if (searchText.isNotEmpty) {
      filteredMedications =
          medications.where((medication) {
            final name = (medication.name ?? '').toLowerCase();
            final query = searchText.toLowerCase();
            return name.contains(query);
          }).toList();
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchField(onChanged: onSearchChanged),
            const SizedBox(height: 18),
            MedicationListHeader(
              hasPrescriptions: hasPrescriptions,
              token: token,
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
            if (filteredMedications.isEmpty && hasPrescriptions)
              NotificationContainer(
                message:
                    'No tienes medicamentos registrados. Presiona el botón "Agregar medicamento" para agregar uno.',
                icon: Icons.error_outline_outlined,
                backgroundColor: Colors.blue.shade100,
                textColor: Colors.blue.shade900,
              ),
            // Lista de tarjetas de medicamentos
            ...filteredMedications.map<Widget>(
              (medication) => MedicationCard(medication: medication),
            ),
          ],
        ),
      ),
    );
  }
}

/// Encabezado de la lista, muestra el título y el botón para agregar medicamentos si corresponde.
class MedicationListHeader extends StatelessWidget {
  final bool hasPrescriptions;
  final String token;

  const MedicationListHeader({
    super.key,
    required this.hasPrescriptions,
    required this.token,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            "Tus medicamentos",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            overflow:
                TextOverflow.ellipsis, // Por si el título se alarga demasiado
          ),
        ),
        if (hasPrescriptions)
          Flexible(
            child: RoundedIconButton(
              icon: Icons.add,
              label: 'Agregar medicamento',
              onPressed: () {
                // Navega a la página de creación de medicamentos
                Navigator.pushNamed(
                  context,
                  '/createMedication',
                  arguments: {'token': token},
                );
              },
            ),
          ),
      ],
    );
  }
}

/// Widget para mostrar mensajes de error en la sección.
class ErrorNotification extends StatelessWidget {
  final String message;
  const ErrorNotification({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return NotificationContainer(
      message: message,
      icon: Icons.error_outline,
      backgroundColor: Colors.red.shade100,
      textColor: Colors.red,
    );
  }
}
