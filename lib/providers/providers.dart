import 'dart:async';

import 'package:past_ia/models/intake_model.dart';
import 'package:past_ia/services/auth_service.dart';
import 'package:past_ia/services/schedule_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/schedule_model.dart';
import '../models/response_model.dart';

// Función auxiliar para manejar errores de respuesta
void handleServerError(ApiResponse response) {
  if (response.hasError && response.statusCode == 500) {
    throw Exception(
      'Ocurrió un error en nuestros servidores, por favor intenta de nuevo más tarde',
    );
  }
}

final schedulesProvider = FutureProvider.family<
  ApiResponse<List<Schedule>>,
  String
>((ref, token) async {
  final response = await ScheduleService.getSchedules(token: token);

  // Si el error es un timeout, lanza una excepción (esto hará que Riverpod detecte el error)
  if (response.statusCode == 408 || response.error == 'Timeout') {
    throw TimeoutException(response.message);
  }

  handleServerError(response);
  return response;
});

final intakeLogsProvider = FutureProvider.family<
  ApiResponse<List<Intake>>,
  (String scheduleId, String token)
>((ref, args) async {
  final (scheduleId, token) = args;
  final response = await ScheduleService.getScheduleLogs(
    scheduleId: scheduleId,
    token: token,
  );

  if (response.statusCode == 408 || response.error == 'Timeout') {
    throw TimeoutException(response.message);
  }

  handleServerError(response);
  return response;
});

// Provider para actualizar los providers automáticamente
final autoRefreshProvider = StreamProvider<void>((ref) async* {
  // Cambia el intervalo a lo que necesites (ej: 10 segundos)
  const duration = Duration(seconds: 10);
  while (true) {
    await Future.delayed(duration);
    yield null; // Emite un valor para forzar el rebuild
  }
});

// Provider para obtener el JWT
final jwtTokenProvider = FutureProvider<String?>((ref) async {
  return await AuthService.getJwtToken();
});

// Provider para el tamaño de texto
final textScaleProvider = StateProvider<double>((ref) => 1.0);
