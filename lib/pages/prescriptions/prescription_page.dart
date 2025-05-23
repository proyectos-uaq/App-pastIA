import 'package:past_ia/pages/prescriptions/prescription_list_section.dart';
import 'package:past_ia/pages/prescriptions/prescription_nav_providers.dart';
import 'package:past_ia/providers/prescription_provider.dart';
import 'package:past_ia/providers/providers.dart';
import 'package:past_ia/widgets/custom_circular_progress_indicator.dart';
import 'package:past_ia/widgets/error_scaffolds.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

/// Página principal de recetas médicas.
/// Muestra la lista de recetas si el token existe, o mensajes de error/carga.
class PrescriptionPage extends ConsumerWidget {
  const PrescriptionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokenAsync = ref.watch(jwtTokenProvider);
    final selectedIndex = ref.watch(navBarIndexProvider);

    // Escucha el autoRefreshProvider para refrescar automáticamente las recetas
    ref.listen<AsyncValue<void>>(autoRefreshProvider, (_, __) {
      final token = ref.read(jwtTokenProvider).valueOrNull;
      if (token != null) {
        ref.invalidate(prescriptionProvider(token));
      }
    });

    return tokenAsync.when(
      data: (token) {
        if (token == null) {
          return TokenMissingScaffold();
        }

        Widget content;
        if (selectedIndex == 1) {
          content = PrescriptionListSection(token: token);
        } else {
          content = const SizedBox();
        }
        return Scaffold(body: content);
      },
      loading: () => const Scaffold(body: Center(child: MyCustomLoader())),
      error:
          (error, stack) => ErrorScaffold(
            error: 'Ocurrió un error al cargar las recetas: $error',
          ),
    );
  }
}
