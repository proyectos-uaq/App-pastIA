import 'package:app_pastia/pages/medications/widgets/schedule_medication_card.dart';
import 'package:app_pastia/providers/medications_provider.dart';
import 'package:app_pastia/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

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
    // Revalidar los datos al entrar
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

  void _onDeleteMedication(BuildContext context, String medicationId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text("Eliminar medicamento"),
            content: const Text(
              "¿Estás seguro que deseas eliminar este medicamento?",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text("Cancelar"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text(
                  "Eliminar",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
    if (confirmed == true) {
      // Aquí deberías llamar a tu provider o método para eliminar el medicamento
      // Ejemplo: await ref.read(medicationsProvider.notifier).deleteMedication(medicationId);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Medicamento eliminado')));
      Navigator.pop(context);
    }
  }

  String _formatDate(String? isoDate) {
    if (isoDate == null || isoDate.isEmpty) return 'Sin fecha';
    try {
      final date = DateTime.parse(isoDate);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (_) {
      return 'Sin fecha';
    }
  }

  String formatInterval(String? interval) {
    if (interval == null || interval.isEmpty) return 'No especificada';

    final parts = interval.split(':');
    if (parts.length != 3) return interval;

    final hours = int.tryParse(parts[0]) ?? 0;
    final minutes = int.tryParse(parts[1]) ?? 0;
    final seconds = int.tryParse(parts[2]) ?? 0;

    if (hours > 0) {
      return '$hours horas'
          '${minutes > 0 ? ' $minutes minutos' : ''}'
          '${seconds > 0 ? ' $seconds segundos' : ''}';
    } else if (minutes > 0) {
      return '$minutes minutos'
          '${seconds > 0 ? ' $seconds segundos' : ''}';
    } else {
      return '$seconds segundos';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Refresca detalle al autoRefresh
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
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: const Text('Detalle de medicamento'),
              backgroundColor: Colors.blue,
              iconTheme: const IconThemeData(color: Colors.white),
              elevation: 0,
            ),
            body: const Center(child: Text("Token no disponible.")),
          );
        }

        final medicationDetailAsync = ref.watch(
          medicationsDetailProvider((widget.medicationId, token)),
        );
        return medicationDetailAsync.when(
          data: (response) {
            final medication = response.data;
            if (medication == null) {
              return const _NotFoundScaffold();
            }
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                title: Text(
                  medication.name ?? 'Detalle de medicamento',
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.blue,
                iconTheme: const IconThemeData(color: Colors.white),
                elevation: 0,
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 26,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header con icono y datos principales
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.blue.shade100.withOpacity(
                                        0.2,
                                      ),
                                      blurRadius: 12,
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.all(18),
                                child: const Icon(
                                  Icons.vaccines_rounded,
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
                                      medication.name ?? 'Sin nombre',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 22,
                                        color: Colors.blue.shade800,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.calendar_today,
                                          size: 16,
                                          color: Colors.green,
                                        ),
                                        const SizedBox(width: 7),
                                        Text(
                                          'Fecha de inicio: ${_formatDate(medication.startDate)}',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.grey.shade700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  IconButton(
                                    tooltip: 'Eliminar medicamento',
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed:
                                        () => _onDeleteMedication(
                                          context,
                                          medication.medicationId.toString(),
                                        ),
                                  ),
                                  IconButton(
                                    tooltip: 'Editar medicamento',
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.blue,
                                    ),
                                    onPressed:
                                        () => _onEditMedication(medication),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          // Más detalles
                          ..._medicationDetailsList(medication),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              const Text(
                                'Horarios de toma',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Spacer(),
                              ElevatedButton.icon(
                                icon: Icon(
                                  Icons.add,
                                  color: Colors.blue.shade900,
                                ),
                                label: const Text("Nuevo horario"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue.shade100,
                                  foregroundColor: Colors.blue.shade900,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                    side: BorderSide(
                                      color: Colors.blue.shade100,
                                      width: 1,
                                    ),
                                  ),
                                  textStyle: const TextStyle(fontSize: 16),
                                ),
                                onPressed: () {
                                  // TODO: Acción para agregar nuevo horario
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          if (medication.schedules == null ||
                              medication.schedules!.isEmpty)
                            const Text(
                              'No hay horarios registrados.',
                              style: TextStyle(color: Colors.grey),
                            )
                          else
                            ..._orderedScheduleCards(medication.schedules!),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
          loading:
              () => Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  title: const Text('Detalle de medicamento'),
                  backgroundColor: Colors.blue,
                  iconTheme: const IconThemeData(color: Colors.white),
                  elevation: 0,
                ),
                body: const Center(child: CircularProgressIndicator()),
              ),
          error: (err, stack) => _ErrorScaffold(message: "Error: $err"),
        );
      },
      loading:
          () => Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: const Text('Detalle de medicamento'),
              backgroundColor: Colors.blue,
              iconTheme: const IconThemeData(color: Colors.white),
              elevation: 0,
            ),
            body: const Center(child: CircularProgressIndicator()),
          ),
      error:
          (err, stack) =>
              _ErrorScaffold(message: "Error obteniendo token: $err"),
    );
  }

  List<Widget> _medicationDetailsList(dynamic medication) {
    // Puedes agregar aquí más campos según tu modelo de medicamento
    return [
      _DetailRow(label: 'Dosis', value: medication.dosage ?? 'No especificada'),
      _DetailRow(
        label: 'Frecuencia',
        value: 'Cada ${formatInterval(medication.interval)}',
      ),
      _DetailRow(label: 'Forma', value: medication.form ?? 'No especificada'),
      // Agregar aquí más detalles si los hay
    ];
  }

  List<Widget> _orderedScheduleCards(List schedules) {
    // Ordenar de menor a mayor por hora (asumiendo formato HH:mm:ss o HH:mm)
    final sorted = List.from(schedules)..sort((a, b) {
      final aTime = a.scheduledTime ?? '';
      final bTime = b.scheduledTime ?? '';
      if (aTime.length >= 5 && bTime.length >= 5) {
        return aTime.compareTo(bTime);
      }
      return 0;
    });
    return sorted
        .map<Widget>((schedule) => ScheduleMedicationCard(schedule: schedule))
        .toList();
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          SizedBox(
            width: 170,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.blueGrey.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w400),
            ),
          ),
        ],
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
        title: const Text('Detalle de medicamento'),
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
        title: const Text('Detalle de medicamento'),
        backgroundColor: Colors.blue,
      ),
      body: const Center(
        child: Text(
          "No se pudo encontrar el medicamento.",
          style: TextStyle(color: Colors.deepOrange, fontSize: 16),
        ),
      ),
    );
  }
}
