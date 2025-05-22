import 'package:app_pastia/pages/medications/medications_list_section.dart';
import 'package:app_pastia/pages/principal/home_page.dart';
import 'package:app_pastia/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

/// Página principal de medicamentos.
/// Muestra la lista de medicamentos si el token existe, o mensajes de error/carga.
class MedicationsPage extends ConsumerWidget {
  const MedicationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokenAsync = ref.watch(jwtTokenProvider);
    final selectedIndex = ref.watch(navBarIndexProvider);

    // Escucha el autoRefreshProvider para refrescar automáticamente los medicamentos
    ref.listen<AsyncValue<void>>(autoRefreshProvider, (_, __) {
      final token = ref.read(jwtTokenProvider).valueOrNull;
      if (token != null) {
        ref.invalidate(medicationProvider(token));
      }
    });

    return tokenAsync.when(
      data: (token) {
        if (token == null) {
          return const Scaffold(
            body: Center(
              child: Text(
                'No se encontró un token de sesión. Por favor inicia sesión nuevamente.',
              ),
            ),
          );
        }

        Widget content;
        if (selectedIndex == 2) {
          content = MedicationListSection(token: token);
        } else {
          content = const Center(child: Text('Página no encontrada.'));
        }

        return Scaffold(body: content);
      },
      error:
          (error, stackTrace) => Scaffold(
            body: Center(
              child: Text('Ocurrió un error al cargar los datos: $error'),
            ),
          ),
      loading:
          () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}
