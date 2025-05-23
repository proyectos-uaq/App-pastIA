// Provider para los detalles de una receta
import 'package:past_ia/models/medication_model.dart';
import 'package:past_ia/models/response_model.dart';
import 'package:past_ia/providers/providers.dart';
import 'package:past_ia/services/medication_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final medicationsDetailProvider =
    FutureProvider.family<ApiResponse<Medication>, (String id, String token)>((
      ref,
      args,
    ) async {
      final (id, token) = args;
      final response = await MedicationService.getMedicationById(
        id: id,
        token: token,
      );

      handleServerError(response);
      return response;
    });

// Provider para la lista de medicamentos
final medicationProvider =
    FutureProvider.family<ApiResponse<List<Medication>>, String>((
      ref,
      token,
    ) async {
      var response = await MedicationService.getMedications(token: token);
      handleServerError(response);
      return response;
    });
