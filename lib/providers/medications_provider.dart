// Provider para los detalles de una receta
import 'package:app_pastia/models/medication_model.dart';
import 'package:app_pastia/models/response_model.dart';
import 'package:app_pastia/providers/providers.dart';
import 'package:app_pastia/services/medication_service.dart';
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
