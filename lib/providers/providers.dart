import 'package:app_pastia/services/auth_service.dart';
import 'package:app_pastia/services/schedule_service.dart';
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

final schedulesProvider =
    FutureProvider.family<ApiResponse<List<Schedule>>, String>((
      ref,
      token,
    ) async {
      var response = await ScheduleService.getSchedules(token: token);
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
