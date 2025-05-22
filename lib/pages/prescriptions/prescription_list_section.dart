import 'package:app_pastia/pages/prescriptions/prescription_nav_providers.dart';
import 'package:app_pastia/providers/prescription_provider.dart';
import 'package:app_pastia/widgets/custom_buttons.dart';
import 'package:app_pastia/widgets/custom_text_fields.dart';
import 'package:app_pastia/widgets/dialogs/create_prescription_dialog.dart';
import 'package:app_pastia/widgets/notification_container.dart';
import 'package:app_pastia/pages/prescriptions/widgets/prescription_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

// Widget principal que muestra la sección de recetas.
class PrescriptionListSection extends ConsumerWidget {
  final String token;
  const PrescriptionListSection({super.key, required this.token});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Observa el valor de búsqueda y recetas (prescriptions)
    final searchText = ref.watch(prescriptionSearchProvider);
    final prescriptionsAsync = ref.watch(prescriptionProvider(token));

    return prescriptionsAsync.when(
      data: (prescriptionData) {
        return PrescriptionListContent(
          prescriptions: List.from(prescriptionData.data ?? []),
          searchText: searchText,
          onSearchChanged: (value) {
            ref.read(prescriptionSearchProvider.notifier).state = value;
          },
          token: token,
          ref: ref,
        );
      },
      error:
          (err, stack) => NotificationContainer(
            message: '$err',
            icon: Icons.error_outline,
            backgroundColor: Colors.red.shade100,
            textColor: Colors.red,
          ),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}

// Widget que contiene el contenido principal de la lista de recetas.
class PrescriptionListContent extends StatelessWidget {
  final List prescriptions;
  final String searchText;
  final ValueChanged<String> onSearchChanged;
  final String token;
  final WidgetRef ref;

  const PrescriptionListContent({
    super.key,
    required this.prescriptions,
    required this.searchText,
    required this.onSearchChanged,
    required this.token,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    // Filtra las recetas por el texto de búsqueda
    List filteredPrescriptions = prescriptions;
    if (searchText.isNotEmpty) {
      filteredPrescriptions =
          prescriptions.where((prescription) {
            final name = (prescription.name ?? '').toLowerCase();
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
            const SizedBox(height: 16),
            PrescriptionListHeader(token: token, ref: ref),
            if (filteredPrescriptions.isEmpty)
              NotificationContainer(
                message:
                    'No tienes recetas registradas. Presiona el botón "Agregar receta" para crear una.',
                icon: Icons.error_outline_outlined,
                backgroundColor: Colors.blue.shade100,
                textColor: Colors.blue.shade900,
              ),
            // Lista de tarjetas de recetas
            ...filteredPrescriptions.map<Widget>(
              (prescription) => PrescriptionCard(prescription: prescription),
            ),
          ],
        ),
      ),
    );
  }
}

class PrescriptionListHeader extends StatelessWidget {
  final String token;
  final WidgetRef ref;
  const PrescriptionListHeader({
    super.key,
    required this.token,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            "Tus recetas",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            overflow: TextOverflow.ellipsis, // Por si el texto es muy largo
          ),
        ),
        Flexible(
          child: RoundedIconButton(
            icon: Icons.add,
            label: 'Agregar receta',
            onPressed: () async {
              final prescription = await showCreatePrescriptionDialog(
                context,
                token: token,
              );

              if (prescription != null) {
                ref.invalidate(prescriptionProvider(token));
              }
            },
          ),
        ),
      ],
    );
  }
}
