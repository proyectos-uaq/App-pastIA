import 'package:app_pastia/pages/medications/widgets/medication_detail_scaffold.dart';
import 'package:app_pastia/providers/medications_provider.dart';
import 'package:app_pastia/providers/providers.dart';
import 'package:app_pastia/widgets/delete_confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'widgets/detail_scaffolds.dart';

/// Página de detalles de un medicamento.
class MedicationDetailsPage extends ConsumerStatefulWidget {
  final String medicationId;
  const MedicationDetailsPage({super.key, required this.medicationId});

  @override
  ConsumerState<MedicationDetailsPage> createState() =>
      _MedicationDetailsPageState();
}

class _MedicationDetailsPageState extends ConsumerState<MedicationDetailsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final token = ref.read(jwtTokenProvider).valueOrNull;
      if (token != null) {
        ref.invalidate(medicationsDetailProvider((widget.medicationId, token)));
        ref.invalidate(schedulesProvider(token));
      }
    });
  }

  void _onEditMedication(dynamic medication) {
    // TODO: Acción para editar medicamento
    // Navigator.pushNamed(context, '/editar-medicamento', arguments: medication);
  }

  Future<void> _onDeleteMedication(
    BuildContext context,
    String medicationId,
  ) async {
    final confirmed = await showDeleteConfirmationDialog(
      context,
      title: 'Eliminar medicamento',
      message: '¿Estás seguro que deseas eliminar este medicamento?',
      confirmText: 'Eliminar',
      cancelText: 'Cancelar',
      icon: Icons.delete,
      iconColor: Colors.redAccent,
      confirmColor: Colors.red,
      cancelColor: Colors.blue.shade600,
    );
    if (confirmed == true) {
      // Aquí deberías llamar a tu provider o método para eliminar el medicamento
      // Ejemplo: await ref.read(medicationsProvider.notifier).deleteMedication(medicationId);
      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(const SnackBar(content: Text('Medicamento eliminado')));
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<void>>(autoRefreshProvider, (previous, next) {
      final token = ref.read(jwtTokenProvider).valueOrNull;
      if (token != null) {
        ref.invalidate(medicationsDetailProvider((widget.medicationId, token)));
        ref.invalidate(schedulesProvider(token));
      }
    });

    final tokenAsync = ref.watch(jwtTokenProvider);

    return tokenAsync.when(
      data: (token) {
        if (token == null) {
          return const NotAvailableScaffold();
        }
        final medicationDetailAsync = ref.watch(
          medicationsDetailProvider((widget.medicationId, token)),
        );
        return medicationDetailAsync.when(
          data: (response) {
            final medication = response.data;
            if (medication == null) {
              return const NotFoundScaffold();
            }
            return MedicationDetailScaffold(
              medication: medication,
              medicationId: widget.medicationId,
              token: token,
              onEditMedication: _onEditMedication,
              onDeleteMedication: _onDeleteMedication,
              ref: ref,
            );
          },
          loading: () => const LoadingScaffold(),
          error: (err, stack) => ErrorScaffold(message: "Error: $err"),
        );
      },
      loading: () => const LoadingScaffold(),
      error:
          (err, stack) =>
              ErrorScaffold(message: "Error obteniendo token: $err"),
    );
  }
}
