import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:past_ia/providers/providers.dart';
import 'dart:async';
import 'package:intl/intl.dart'; // Asegúrate de tener intl en tu pubspec.yaml

class IntakeLogsPage extends ConsumerWidget {
  final String scheduleId;
  final String token;

  const IntakeLogsPage({
    super.key,
    required this.scheduleId,
    required this.token,
  });

  // Retorna la fecha en formato dd/MM/yyyy
  String _formatOnlyDate(String? isoString) {
    if (isoString == null) return '-';
    try {
      final date = DateTime.parse(isoString).toLocal();
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (_) {
      return isoString;
    }
  }

  // Retorna solo la hora amigable
  String _formatOnlyTime(String? isoString, BuildContext context) {
    if (isoString == null) return '-';
    try {
      final date = DateTime.parse(isoString).toLocal();
      final time = TimeOfDay.fromDateTime(date);
      return time.format(context);
    } catch (_) {
      return isoString;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final intakeLogsAsyncValue = ref.watch(
      intakeLogsProvider((scheduleId, token)),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registros de ingesta'),
        centerTitle: true,
      ),
      body: intakeLogsAsyncValue.when(
        data: (apiResponse) {
          final logs = apiResponse.data;
          if (logs == null || logs.isEmpty) {
            return const Center(child: Text('No hay registros disponibles.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 12),
            itemCount: logs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 0),
            itemBuilder: (context, index) {
              final intake = logs[index];
              final wasTaken = intake.isTaken == true;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),

                    // No border
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        // Estado
                        CircleAvatar(
                          radius: 28,
                          backgroundColor:
                              wasTaken
                                  ? Colors.green.shade200
                                  : Colors.red.shade200,
                          child: Icon(
                            wasTaken
                                ? Icons.check_circle_outline
                                : Icons.cancel_outlined,
                            color:
                                wasTaken
                                    ? Colors.green.shade900
                                    : Colors.red.shade900,
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Info principal
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Registro: ${intake.intakeLogId ?? "-"}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    size: 20,
                                    color: Colors.blueGrey,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    _formatOnlyDate(intake.buttonPressTime),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(width: 18),
                                  Icon(
                                    Icons.access_time,
                                    size: 20,
                                    color: Colors.blueGrey,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    _formatOnlyTime(
                                      intake.buttonPressTime,
                                      context,
                                    ),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(
                                    wasTaken
                                        ? Icons.check_circle
                                        : Icons.cancel,
                                    color: wasTaken ? Colors.green : Colors.red,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    wasTaken ? "Tomada" : "No tomada",
                                    style: TextStyle(
                                      color:
                                          wasTaken ? Colors.green : Colors.red,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) {
          if (error is TimeoutException) {
            return const Center(child: Text('Tiempo de espera agotado.'));
          }
          return Center(child: Text('Error: ${error.toString()}'));
        },
      ),
    );
  }
}
