import 'package:app_pastia/pages/medications/widgets/medication_detail_scaffold.dart';
import 'package:app_pastia/providers/medications_provider.dart';
import 'package:app_pastia/providers/providers.dart';
import 'package:app_pastia/services/medication_service.dart';
import 'package:app_pastia/widgets/custom_dialogs.dart';
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
    // Revalida los datos al entrar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final token = ref.read(jwtTokenProvider).valueOrNull;
      if (token != null) {
        ref.invalidate(medicationsDetailProvider((widget.medicationId, token)));
        ref.invalidate(schedulesProvider(token));
      }
    });
  }

  void _onEditMedication(dynamic medication) {
    Navigator.pushNamed(
      context,
      '/updateMedication',
      arguments: {'medication': medication},
    );
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
      final token = ref.read(jwtTokenProvider).valueOrNull;

      var response = await MedicationService.deleteMedication(
        id: medicationId,
        token: token!,
      );
      if (context.mounted) {
        if (response.error == null) {
          // Notifica a los providers relacionados
          ref.invalidate(medicationProvider(token));

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Receta eliminada correctamente'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Ocurrió un error: ${response.error}'),
              backgroundColor: Colors.red,
            ),
          );
          // No se cierra la pantalla si falló
        }
      }
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
          return const NotAvailableScaffold(
            tittle: 'medicamento',
            message: 'No se ha podido obtener el token de acceso',
          );
        }
        final medicationDetailAsync = ref.watch(
          medicationsDetailProvider((widget.medicationId, token)),
        );
        return medicationDetailAsync.when(
          data: (response) {
            final medication = response.data;
            if (medication == null) {
              return const NotFoundScaffold(
                tittle: 'medicamento',
                message: 'No se ha encontrado el medicamento ',
              );
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
          error:
              (err, stack) => ErrorScaffold(
                tittle: "medicamento",
                message: "Error obteniendo medicamento: $err",
              ),
        );
      },
      loading: () => const LoadingScaffold(),
      error:
          (err, stack) => ErrorScaffold(
            tittle: "medicamento",
            message: "Error obteniendo token: $err",
          ),
    );
  }
}
