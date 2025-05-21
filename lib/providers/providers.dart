import 'package:app_pastia/models/medication_model.dart';
import 'package:app_pastia/models/prescription_model.dart';
import 'package:app_pastia/services/auth_service.dart';
import 'package:app_pastia/services/medication_service.dart';
import 'package:app_pastia/services/prescription_service.dart';
import 'package:app_pastia/services/schedule_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/schedule_model.dart';
import '../models/response_model.dart';

// Función auxiliar para manejar errores de respuesta
void _handleServerError(ApiResponse response) {
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
      _handleServerError(response);
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

// Provider para la lista de recetas
final prescriptionProvider =
    FutureProvider.family<ApiResponse<List<Prescription>>, String>((
      ref,
      token,
    ) async {
      var response = await PrescriptionService.getPrescriptions(token: token);
      _handleServerError(response);
      return response;
    });

// Provider para la lista de medicamentos
final medicationProvider =
    FutureProvider.family<ApiResponse<List<Medication>>, String>((
      ref,
      token,
    ) async {
      var response = await MedicationService.getMedications(token: token);
      _handleServerError(response);
      return response;
    });

// Provider para obtener el JWT
final jwtTokenProvider = FutureProvider<String?>((ref) async {
  return await AuthService.getJwtToken();
});
