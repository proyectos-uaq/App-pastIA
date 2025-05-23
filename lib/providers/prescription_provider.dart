// Provider para la lista de recetas
import 'package:past_ia/models/prescription_model.dart';
import 'package:past_ia/models/response_model.dart';
import 'package:past_ia/providers/providers.dart';
import 'package:past_ia/services/prescription_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Providerpara la lista de recetas
final prescriptionProvider =
    FutureProvider.family<ApiResponse<List<Prescription>>, String>((
      ref,
      token,
    ) async {
      var response = await PrescriptionService.getPrescriptions(token: token);
      handleServerError(response);
      return response;
    });

// Provider para los detalles de una receta
final prescriptionDetailsProvider =
    FutureProvider.family<ApiResponse<Prescription>, (String id, String token)>(
      (ref, args) async {
        final (id, token) = args;
        final response = await PrescriptionService.getPrescriptionById(
          id: id,
          token: token,
        );
        handleServerError(response);
        return response;
      },
    );
