import 'package:app_pastia/pages/prescriptions/prescription_page.dart';
import 'package:app_pastia/providers/providers.dart';
import 'package:app_pastia/widgets/notification_container.dart';
import 'package:app_pastia/pages/prescriptions/widgets/prescription_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class PrescriptionListSection extends ConsumerWidget {
  final String token;
  const PrescriptionListSection({super.key, required this.token});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchText = ref.watch(prescriptionSearchProvider);
    final prescriptionsAsync = ref.watch(prescriptionProvider(token));

    return prescriptionsAsync.when(
      data: (data) {
        List prescriptions = List.from(data.data ?? []);

        // Filtrar por búsqueda
        if (searchText.isNotEmpty) {
          prescriptions =
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
                // Campo de búsqueda
                TextField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: 'Buscar receta...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (value) {
                    ref.read(prescriptionSearchProvider.notifier).state = value;
                  },
                ),
                const SizedBox(height: 18),
                // Texto arriba de la lista y botón de agregar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Mis recetas",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    ElevatedButton.icon(
                      icon: Icon(Icons.add, color: Colors.blue.shade900),
                      label: const Text("Agregar receta"),
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
                            width: 0,
                          ),
                        ),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                      onPressed: () {
                        // Acción para crear/abrir formulario de receta
                        // Navigator.pushNamed(context, '/crear-receta');
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ...prescriptions.map<Widget>(
                  (prescription) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: PrescriptionCard(prescription: prescription),
                  ),
                ),
                if (prescriptions.isEmpty)
                  NotificationContainer(
                    message:
                        'No tienes recetas. Presiona el botón "Agregar receta" para crear una.',
                    icon: Icons.error_outline_outlined,
                    backgroundColor: Colors.blue.shade100,
                    textColor: Colors.blue.shade900,
                  ),
              ],
            ),
          ),
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
