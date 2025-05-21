import 'dart:convert';

import 'package:app_pastia/api/constants.dart';
import 'package:http/http.dart' as http;

import '../models/medication_model.dart';
import '../models/response_model.dart';
import '../models/schedule_model.dart';

Future<dynamic> createMedication({
  required Medication medication,
  required String token,
}) async {
  try {
    final url = Uri.parse('$API_URL/medications');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: medication.toRawJson(),
    );

    final jsonBody = jsonDecode(response.body);

    final createdMedication = ApiResponse<Medication>.fromJson(
      jsonBody,
      fromData: (data) => Medication.fromJson(data),
    );

    //return createdMedication; // Devolvemos la respuesta completa
    // Si necesitas solo el medicamento creado, puedes usar createdMedication.data
    return createdMedication.data;
  } catch (e) {
    return ApiResponse<Medication>(
      data: null,
      message: 'Ocurrió un error inesperado.',
      statusCode: 500,
      error: e.toString(),
    );
  }
}

Future<dynamic> getMedications({required String token}) async {
  try {
    final url = Uri.parse('$API_URL/medications');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final jsonBody = jsonDecode(response.body);

    final medications = ApiResponse<List<Medication>>.fromJson(
      jsonBody,
      fromData:
          (data) =>
              (data as List).map((item) => Medication.fromJson(item)).toList(),
    );

    //return medications; // Devolvemos la respuesta completa
    // Si necesitas solo la lista, puedes usar medications.data
    return medications.data ?? [];
  } catch (e) {
    return ApiResponse<List<Medication>>(
      data: null,
      message: 'Ocurrió un error inesperado.',
      statusCode: 500,
      error: e.toString(),
    );
  }
}

Future<dynamic> getMedicationById({
  required String id,
  required String token,
}) async {
  try {
    final url = Uri.parse('$API_URL/medications/$id');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final jsonBody = jsonDecode(response.body);

    final medication = ApiResponse<Medication>.fromJson(
      jsonBody,
      fromData: (data) => Medication.fromJson(data),
    );

    //return medication; // Devolvemos la respuesta completa
    // Si necesitas solo el medicamento, puedes usar medication.data
    return medication.data;
  } catch (e) {
    return ApiResponse<Medication>(
      data: null,
      message: 'Ocurrió un error inesperado.',
      statusCode: 500,
      error: e.toString(),
    );
  }
}

Future<dynamic> updateMedication({
  required String id,
  required Medication medication,
  required String token,
}) async {
  try {
    final url = Uri.parse('$API_URL/medications/$id');
    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: medication.toRawJson(),
    );

    final jsonBody = jsonDecode(response.body);

    final updatedMedication = ApiResponse<Medication>.fromJson(
      jsonBody,
      fromData: (data) => Medication.fromJson(data),
    );

    //return updatedMedication; // Devolvemos la respuesta completa
    // Si necesitas solo el medicamento actualizado, puedes usar updatedMedication.data
    return updatedMedication.data;
  } catch (e) {
    return ApiResponse<Medication>(
      data: null,
      message: 'Ocurrió un error inesperado.',
      statusCode: 500,
      error: e.toString(),
    );
  }
}

Future<dynamic> deleteMedication({
  required String id,
  required String token,
}) async {
  try {
    final url = Uri.parse('$API_URL/medications/$id');
    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final jsonBody = jsonDecode(response.body);

    return ApiResponse<Medication>.fromJson(
      jsonBody,
      fromData: (data) => Medication.fromJson(data),
    );
  } catch (e) {
    return ApiResponse<Medication>(
      data: null,
      message: 'Ocurrió un error inesperado.',
      statusCode: 500,
      error: e.toString(),
    );
  }
}

// Obtenemos los horarios de un medicamento por su ID
Future<dynamic> getSchedulesByMedicationId({
  required String id,
  required String token,
}) async {
  try {
    final url = Uri.parse('$API_URL/medications/$id/schedules');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final jsonBody = jsonDecode(response.body);

    final apiResponse = ApiResponse<List<Schedule>>.fromJson(
      jsonBody,
      fromData:
          (data) =>
              (data as List).map((item) => Schedule.fromJson(item)).toList(),
    );

    //return apiResponse; // Devolvemos la respuesta completa
    // Si necesitas solo la lista, puedes usar schedules.data
    return apiResponse.data ?? [];
  } catch (e) {
    return ApiResponse<List<Schedule>>(
      data: null,
      message: 'Ocurrió un error inesperado.',
      statusCode: 500,
      error: e.toString(),
    );
  }
}
