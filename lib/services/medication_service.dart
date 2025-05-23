import 'dart:async';
import 'dart:convert';
import 'package:past_ia/api/constants.dart';
import 'package:http/http.dart' as http;
import 'package:past_ia/utils/safe_request.dart';

import '../models/medication_model.dart';
import '../models/response_model.dart';
import '../models/schedule_model.dart';

class MedicationService {
  static Future<ApiResponse<Medication>> createMedication({
    required Medication medication,
    required String token,
  }) async {
    try {
      final url = Uri.parse('$API_URL/medications');
      final response = await safeRequest(
        http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: medication.toRawJson(),
        ),
      );

      final jsonBody = jsonDecode(response!.body);

      return ApiResponse<Medication>.fromJson(
        jsonBody,
        fromData: (data) => Medication.fromJson(data),
      );
    } on TimeoutException catch (e) {
      // Relanza el TimeoutException para que el provider pueda atraparlo si lo desea
      throw e;
    } catch (e) {
      return ApiResponse<Medication>(
        data: null,
        message: 'Ocurrió un error inesperado.',
        statusCode: 500,
        error: e.toString(),
      );
    }
  }

  static Future<ApiResponse<List<Medication>>> getMedications({
    required String token,
  }) async {
    try {
      final url = Uri.parse('$API_URL/medications');
      final response = await safeRequest(
        http.get(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      final jsonBody = jsonDecode(response!.body);

      return ApiResponse<List<Medication>>.fromJson(
        jsonBody,
        fromData:
            (data) =>
                (data as List)
                    .map((item) => Medication.fromJson(item))
                    .toList(),
      );
    } on TimeoutException catch (e) {
      throw e;
    } catch (e) {
      return ApiResponse<List<Medication>>(
        data: null,
        message: 'Ocurrió un error inesperado.',
        statusCode: 500,
        error: e.toString(),
      );
    }
  }

  static Future<ApiResponse<Medication>> getMedicationById({
    required String id,
    required String token,
  }) async {
    try {
      final url = Uri.parse('$API_URL/medications/$id');
      final response = await safeRequest(
        http.get(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      final jsonBody = jsonDecode(response!.body);

      return ApiResponse<Medication>.fromJson(
        jsonBody,
        fromData: (data) => Medication.fromJson(data),
      );
    } on TimeoutException catch (e) {
      throw e;
    } catch (e) {
      return ApiResponse<Medication>(
        data: null,
        message: 'Ocurrió un error inesperado.',
        statusCode: 500,
        error: e.toString(),
      );
    }
  }

  static Future<ApiResponse<Medication>> updateMedication({
    required String id,
    required Medication medication,
    required String token,
  }) async {
    try {
      final url = Uri.parse('$API_URL/medications/$id');
      final response = await safeRequest(
        http.patch(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: medication.toRawJson(),
        ),
      );

      final jsonBody = jsonDecode(response!.body);

      return ApiResponse<Medication>.fromJson(
        jsonBody,
        fromData: (data) => Medication.fromJson(data),
      );
    } on TimeoutException catch (e) {
      throw e;
    } catch (e) {
      return ApiResponse<Medication>(
        data: null,
        message: 'Ocurrió un error inesperado.',
        statusCode: 500,
        error: e.toString(),
      );
    }
  }

  static Future<ApiResponse<String>> deleteMedication({
    required String id,
    required String token,
  }) async {
    try {
      final url = Uri.parse('$API_URL/medications/$id');
      final response = await safeRequest(
        http.delete(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      final jsonBody = jsonDecode(response!.body);

      return ApiResponse<String>.fromJson(
        jsonBody,
        fromData: (data) => data is Map ? data['message'] ?? '' : '',
      );
    } on TimeoutException catch (e) {
      throw e;
    } catch (e) {
      return ApiResponse<String>(
        data: null,
        message: 'Ocurrió un error inesperado.',
        statusCode: 500,
        error: e.toString(),
      );
    }
  }

  static Future<ApiResponse<List<Schedule>>> getSchedulesByMedicationId({
    required String id,
    required String token,
  }) async {
    try {
      final url = Uri.parse('$API_URL/medications/$id/schedules');
      final response = await safeRequest(
        http.get(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      final jsonBody = jsonDecode(response!.body);

      return ApiResponse<List<Schedule>>.fromJson(
        jsonBody,
        fromData:
            (data) =>
                (data as List).map((item) => Schedule.fromJson(item)).toList(),
      );
    } on TimeoutException catch (e) {
      throw e;
    } catch (e) {
      return ApiResponse<List<Schedule>>(
        data: null,
        message: 'Ocurrió un error inesperado.',
        statusCode: 500,
        error: e.toString(),
      );
    }
  }
}
