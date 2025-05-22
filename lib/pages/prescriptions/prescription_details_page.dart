import 'package:app_pastia/pages/medications/widgets/detail_scaffolds.dart';
import 'package:app_pastia/pages/prescriptions/widgets/prescription_detail_scaffold.dart';
import 'package:app_pastia/providers/medications_provider.dart';
import 'package:app_pastia/providers/prescription_provider.dart';
import 'package:app_pastia/providers/providers.dart';
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

  void _onEditPrescription(dynamic prescription) {
    // TODO: Acción de editar receta
  }

  Future<void> _onDeletePrescription(
    BuildContext context,
    String prescriptionId,
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
      // TODO: Accion para eliminar receta
      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(const SnackBar(content: Text('Receta eliminada')));
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
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
              onDeletePrescription: _onDeletePrescription,
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
