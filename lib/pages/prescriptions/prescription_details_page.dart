import 'package:app_pastia/pages/prescriptions/widgets/medication_prescription_card.dart';
import 'package:app_pastia/providers/prescription_provider.dart';
import 'package:app_pastia/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

// --- Widget Principal ---
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
      }
    });
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

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        title: tokenAsync.when(
          data: (token) {
            if (token == null) {
              return const Text("Token no disponible.");
            }
            final prescriptionDetailAsync = ref.watch(
              prescriptionDetailsProvider((widget.prescriptionId, token)),
            );
            return prescriptionDetailAsync.maybeWhen(
              data: (response) {
                final prescription = response.data;
                return Text(
                  prescription?.name ?? "Detalle de receta",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
              orElse:
                  () => const Text(
                    "Detalle de receta",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
            );
          },
          loading:
              () => const Text(
                "Detalle de receta",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
          error:
              (err, stack) => const Text(
                "Detalle de receta",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: tokenAsync.when(
        data: (token) {
          if (token == null) {
            return const Center(child: Text("Token no disponible."));
          }
          final prescriptionDetailAsync = ref.watch(
            prescriptionDetailsProvider((widget.prescriptionId, token)),
          );
          return prescriptionDetailAsync.when(
            data: (response) {
              final prescription = response.data;
              if (prescription == null) {
                return const _NotFoundScaffold();
              }
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _PrescriptionHeader(prescription: prescription),
                      const SizedBox(height: 28),
                      _MedicationsSection(prescription: prescription),
                    ],
                  ),
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => _ErrorScaffold(message: "Error: $err"),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (err, stack) =>
                _ErrorScaffold(message: "Error obteniendo token: $err"),
      ),
    );
  }
}

// --- Cabecera de la receta ---
class _PrescriptionHeader extends StatelessWidget {
  final dynamic prescription;

  const _PrescriptionHeader({required this.prescription});

  String formatDate(String? isoDate) {
    if (isoDate == null || isoDate.isEmpty) return 'Sin fecha';
    try {
      final date = DateTime.parse(isoDate);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (_) {
      return 'Sin fecha';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 18),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: Colors.blue.shade100.withOpacity(0.2),
                    blurRadius: 12,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(18),
              child: const Icon(
                Icons.medical_services_rounded,
                color: Color(0xFF1976D2),
                size: 38,
              ),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    prescription.name ?? 'Sin nombre',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 22,
                      color: Colors.blue.shade800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: Colors.green,
                      ),
                      const SizedBox(width: 7),
                      Text(
                        'Creada el: ${formatDate(prescription.createdAt?.toString())}',
                        style: const TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Sección de medicamentos ---
class _MedicationsSection extends StatelessWidget {
  final dynamic prescription;

  const _MedicationsSection({required this.prescription});

  @override
  Widget build(BuildContext context) {
    final meds = prescription.medications;
    return Card(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Medicamentos',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  icon: Icon(Icons.add, color: Colors.blue.shade900),
                  label: const Text("Nuevo medicamento"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade50,
                    foregroundColor: Colors.blue.shade900,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                      side: BorderSide(color: Colors.blue.shade100),
                    ),
                    textStyle: const TextStyle(fontSize: 15),
                    elevation: 2,
                  ),
                  onPressed: () {
                    // TODO: Acción para crear/abrir formulario de medicamento
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (meds == null || meds.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'No hay medicamentos en esta receta.',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              )
            else
              Column(
                children:
                    meds
                        .map<Widget>(
                          (medication) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: MedicationPrescriptionCard(
                              medication: medication,
                            ),
                          ),
                        )
                        .toList(),
              ),
          ],
        ),
      ),
    );
  }
}

// --- Scaffold para error y para no encontrado ---
class _ErrorScaffold extends StatelessWidget {
  final String message;
  const _ErrorScaffold({required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade50,
      appBar: AppBar(
        title: const Text('Detalle de receta'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Text(
          message,
          style: const TextStyle(color: Colors.red, fontSize: 16),
        ),
      ),
    );
  }
}

class _NotFoundScaffold extends StatelessWidget {
  const _NotFoundScaffold();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      appBar: AppBar(
        title: const Text('Detalle de receta'),
        backgroundColor: Colors.blue,
      ),
      body: const Center(
        child: Text(
          "No se pudo encontrar la receta.",
          style: TextStyle(color: Colors.deepOrange, fontSize: 16),
        ),
      ),
    );
  }
}
