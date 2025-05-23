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
    );
  }
}
