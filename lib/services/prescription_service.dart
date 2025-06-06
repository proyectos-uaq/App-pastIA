import 'dart:async';
import 'dart:convert';

import 'package:past_ia/api/constants.dart';
import 'package:http/http.dart' as http;
import 'package:past_ia/utils/safe_request.dart';

import '../models/prescription_model.dart';
import '../models/response_model.dart';

class PrescriptionService {
  static Future<ApiResponse<List<Prescription>>> getPrescriptions({
    required String token,
  }) async {
    try {
      final url = Uri.parse('$API_URL/prescriptions');
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

      return ApiResponse<List<Prescription>>.fromJson(
        jsonBody,
        fromData:
            (data) =>
                (data as List)
                    .map((item) => Prescription.fromJson(item))
                    .toList(),
      );
    } on TimeoutException catch (e) {
      // Relanza el TimeoutException para que el provider pueda atraparlo si lo desea
      throw e;
    } catch (e) {
      return ApiResponse<List<Prescription>>(
        data: null,
        message: 'Ocurrió un error inesperado.',
        statusCode: 500,
        error: e.toString(),
      );
    }
  }

  static Future<ApiResponse<Prescription>> getPrescriptionById({
    required String id,
    required String token,
  }) async {
    try {
      final url = Uri.parse('$API_URL/prescriptions/$id');
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

      return ApiResponse<Prescription>.fromJson(
        jsonBody,
        fromData: (data) => Prescription.fromJson(data),
      );
    } on TimeoutException catch (e) {
      throw e;
    } catch (e) {
      return ApiResponse<Prescription>(
        data: null,
        message: 'Ocurrió un error inesperado.',
        statusCode: 500,
        error: e.toString(),
      );
    }
  }

  static Future<ApiResponse<Prescription>> createPrescription({
    required Prescription prescription,
    required String token,
  }) async {
    final String prescriptionJson = jsonEncode(prescription.toJson());
    final Uri url = Uri.parse('$API_URL/prescriptions');

    try {
      final response = await safeRequest(
        http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: prescriptionJson,
        ),
      );

      final jsonBody = jsonDecode(response!.body);

      return ApiResponse<Prescription>.fromJson(
        jsonBody,
        fromData: (data) => Prescription.fromJson(data),
      );
    } on TimeoutException catch (e) {
      throw e;
    } catch (e) {
      return ApiResponse<Prescription>(
        data: null,
        message: 'Ocurrió un error inesperado',
        statusCode: 500,
        error: e.toString(),
      );
    }
  }

  static Future<ApiResponse<Prescription>> updatePrescription({
    required String id,
    required Prescription prescription,
    required String token,
  }) async {
    final String prescriptionJson = jsonEncode(prescription.toJson());
    final Uri url = Uri.parse('$API_URL/prescriptions/$id');

    try {
      final response = await safeRequest(
        http.patch(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: prescriptionJson,
        ),
      );

      final jsonBody = jsonDecode(response!.body);

      return ApiResponse<Prescription>.fromJson(
        jsonBody,
        fromData: (data) => Prescription.fromJson(data),
      );
    } on TimeoutException catch (e) {
      throw e;
    } catch (e) {
      return ApiResponse<Prescription>(
        data: null,
        message: 'Ocurrió un error inesperado',
        statusCode: 500,
        error: e.toString(),
      );
    }
  }

  static Future<ApiResponse<String>> deletePrescription({
    required String id,
    required String token,
  }) async {
    final Uri url = Uri.parse('$API_URL/prescriptions/$id');

    try {
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
        message: 'Ocurrió un error inesperado',
        statusCode: 500,
        error: e.toString(),
      );
    }
  }
}
