import 'package:app_pastia/pages/medications/widgets/detail_scaffolds.dart';
import 'package:app_pastia/pages/prescriptions/widgets/prescription_detail_scaffold.dart';
import 'package:app_pastia/providers/medications_provider.dart';
import 'package:app_pastia/providers/prescription_provider.dart';
import 'package:app_pastia/providers/providers.dart';
import 'package:app_pastia/services/prescription_service.dart';
import 'package:app_pastia/widgets/custom_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Pagina de detalles de una receta.
class PrescriptionDetailPage extends ConsumerStatefulWidget {
  final String prescriptionId;
  const PrescriptionDetailPage({super.key, required this.prescriptionId});

  @override
  ConsumerState<PrescriptionDetailPage> createState() =>
      _PrescriptionDetailPageState();
}

class _PrescriptionDetailPageState
    extends ConsumerState<PrescriptionDetailPage> {
  @override
  void initState() {
    super.initState();
    // Revalida los datos al entrar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final token = ref.read(jwtTokenProvider).valueOrNull;
      if (token != null) {
        ref.invalidate(
          prescriptionDetailsProvider((widget.prescriptionId, token)),
        );
        ref.invalidate(medicationProvider(token));
      }
    });
  }

  void _onEditPrescription(dynamic prescription) async {
    final token = ref.read(jwtTokenProvider).valueOrNull;
    final nuevoNombre = await showEditPrescriptionDialog(
      context,
      initialName: prescription.name,
      prescriptionId: prescription.prescriptionId,
      token: token!,
    );
    if (nuevoNombre != null) {
      ref.invalidate(
        prescriptionDetailsProvider((widget.prescriptionId, token)),
      );
    }
  }

  Future<void> _onDeletePrescription(
    BuildContext context,
    WidgetRef ref,
    String prescriptionId,
    String token,
  ) async {
    final confirmed = await showDeleteConfirmationDialog(
      context,
      title: 'Eliminar receta',
      message: '¿Estás seguro que deseas eliminar esta receta?',
      confirmText: 'Eliminar',
      cancelText: 'Cancelar',
      icon: Icons.delete,
      iconColor: Colors.redAccent,
      confirmColor: Colors.red,
      cancelColor: Colors.blue.shade600,
    );
    if (confirmed == true) {
      var response = await PrescriptionService.deletePrescription(
        id: prescriptionId,
        token: token,
      );

      if (context.mounted) {
        if (response.error == null) {
          // Notifica a los providers relacionados
          ref.invalidate(prescriptionProvider(token));
          ref.invalidate(prescriptionDetailsProvider((prescriptionId, token)));
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
    // Refresca detalle al autoRefresh
    ref.listen<AsyncValue<void>>(autoRefreshProvider, (_, __) {
      final token = ref.read(jwtTokenProvider).valueOrNull;
      if (token != null) {
        ref.invalidate(
          prescriptionDetailsProvider((widget.prescriptionId, token)),
        );
      }
    });

    final tokenAsync = ref.watch(jwtTokenProvider);

    return tokenAsync.when(
      data: (token) {
        if (token == null) {
          return const NotAvailableScaffold(
            tittle: "receta",
            message: "No se ha podido obtener el token de acceso",
          );
        }

        final prescriptionDetailAsync = ref.watch(
          prescriptionDetailsProvider((widget.prescriptionId, token)),
        );

        return prescriptionDetailAsync.when(
          data: (response) {
            final prescription = response.data;
            if (prescription == null) {
              return const NotFoundScaffold(
                tittle: 'receta',
                message: 'No se ha encontrado la receta',
              );
            }
            return PrescriptionDetailScaffold(
              prescription: prescription,
              prescriptionId: widget.prescriptionId,
              token: token,
              onEditPrescription: _onEditPrescription,
              onDeletePrescription:
                  (context, id) =>
                      _onDeletePrescription(context, ref, id, token),
              ref: ref,
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error:
              (err, stack) =>
                  ErrorScaffold(tittle: 'receta', message: "Error: $err"),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error:
          (err, stack) => ErrorScaffold(
            tittle: 'receta',
            message: "Error obteniendo token: $err",
          ),
    );
  }
}
