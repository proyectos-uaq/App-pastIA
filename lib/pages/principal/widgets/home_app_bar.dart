import 'package:app_pastia/providers/medications_provider.dart';
import 'package:app_pastia/providers/prescription_provider.dart';
import 'package:app_pastia/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int selectedIndex;
  final String token;
  final WidgetRef ref;

  const HomeAppBar({
    super.key,
    required this.selectedIndex,
    required this.token,
    required this.ref,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          Icon(
            selectedIndex == 0
                ? Icons.schedule
                : selectedIndex == 1
                ? Icons.description
                : selectedIndex == 2
                ? Icons.medication
                : Icons.settings,
          ),
          const SizedBox(width: 20),
          Text(
            selectedIndex == 0
                ? 'Horarios'
                : selectedIndex == 1
                ? 'Recetas'
                : selectedIndex == 2
                ? 'Medicamentos'
                : 'Ajustes',
          ),
        ],
      ),
      actions: [
        if (selectedIndex == 0)
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualizar',
            onPressed: () {
              ref.invalidate(schedulesProvider(token));
              ref.invalidate(prescriptionProvider(token));
              ref.invalidate(medicationProvider(token));
            },
          ),
        if (selectedIndex == 1)
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualizar',
            onPressed: () {
              ref.invalidate(schedulesProvider(token));
              ref.invalidate(prescriptionProvider(token));
              ref.invalidate(medicationProvider(token));
            },
          ),
        if (selectedIndex == 2)
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualizar',
            onPressed: () {
              ref.invalidate(schedulesProvider(token));
              ref.invalidate(prescriptionProvider(token));
              ref.invalidate(medicationProvider(token));
            },
          ),
      ],
    );
  }
}
