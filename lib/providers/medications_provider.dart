import 'dart:async';
import 'package:past_ia/models/medication_model.dart';
import 'package:past_ia/models/response_model.dart';
import 'package:past_ia/providers/providers.dart';
import 'package:past_ia/services/medication_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider para los detalles de un medicamento
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

      if (response.statusCode == 408 || response.error == 'Timeout') {
        throw TimeoutException(response.message);
      }

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

      if (response.statusCode == 408 || response.error == 'Timeout') {
        throw TimeoutException(response.message);
      }

      handleServerError(response);
      return response;
    });
