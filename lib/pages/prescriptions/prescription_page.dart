import 'package:app_pastia/pages/prescriptions/prescription_list_section.dart';
import 'package:app_pastia/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

// Provider para el índice seleccionado en la NavigationBar
final navBarIndexProvider = StateProvider<int>((ref) => 1);
// Provider para el texto de búsqueda
final prescriptionSearchProvider = StateProvider<String>((ref) => '');

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
          return const Scaffold(
            body: Center(child: Text('Ningún token fue encontrado')),
          );
        }
        Widget content;
        if (selectedIndex == 1) {
          content = PrescriptionListSection(token: token);
        } else {
          content = const SizedBox();
        }
        return Scaffold(body: content);
      },
      loading:
          () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
      error:
          (error, stack) =>
              Scaffold(body: Center(child: Text('Error: $error'))),
    );
  }
}
