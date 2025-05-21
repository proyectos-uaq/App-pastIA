import 'dart:convert';

import 'package:app_pastia/api/constants.dart';
import 'package:http/http.dart' as http;

import '../models/intake_model.dart';
import '../models/response_model.dart';
import '../models/schedule_model.dart';

Future<dynamic> createSchedule({
  required Schedule schedule,
  required String token,
}) async {
  try {
    final url = Uri.parse('$API_URL/schedules');
    final String scheduleJson = jsonEncode(schedule.toJson());
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: scheduleJson,
    );

    final jsonBody = jsonDecode(response.body);

    final apiResponse = ApiResponse<Schedule>.fromJson(
      jsonBody,
      fromData: (data) => Schedule.fromJson(data),
    );
    // return apiRespnse; // Devolvemos la respuesta completa
    // Si necesitas solo la lista, puedes usar schedule.data
    return apiResponse.data ?? Schedule();
  } catch (e) {
    return ApiResponse<Schedule>(
      data: null,
      message: 'Ocurrió un error inesperado.',
      statusCode: 500,
      error: e.toString(),
    );
  }
}

Future<dynamic> updateSchedule({
  required String scheduleId,
  required Schedule schedule,
  required String token,
}) async {
  try {
    final url = Uri.parse('$API_URL/schedules/$scheduleId');
    final String scheduleJson = jsonEncode(schedule.toJson());
    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: scheduleJson,
    );

    final jsonBody = jsonDecode(response.body);

    final apiResponse = ApiResponse<Schedule>.fromJson(
      jsonBody,
      fromData: (data) => Schedule.fromJson(data),
    );
    // return apiRespnse; // Devolvemos la respuesta completa
    // Si necesitas solo la lista, puedes usar schedule.data
    return apiResponse.data ?? Schedule();
  } catch (e) {
    return ApiResponse<Schedule>(
      data: null,
      message: 'Ocurrió un error inesperado.',
      statusCode: 500,
      error: e.toString(),
    );
  }
}

Future<dynamic> deleteSchedule({
  required String scheduleId,
  required String token,
}) async {
  try {
    final url = Uri.parse('$API_URL/schedules/$scheduleId');
    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final jsonBody = jsonDecode(response.body);

    return ApiResponse<Schedule>.fromJson(
      jsonBody,
      fromData: (data) => Schedule.fromJson(data),
    );
  } catch (e) {
    return ApiResponse<Schedule>(
      data: null,
      message: 'Ocurrió un error inesperado.',
      statusCode: 500,
      error: e.toString(),
    );
  }
}

// Obtener los logs de horarios
Future<ApiResponse<List<Intake>>> getScheduleLogs({
  required String scheduleId,
  required String token,
}) async {
  try {
    final url = Uri.parse('$API_URL/schedules/$scheduleId/intake/logs');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final jsonBody = jsonDecode(response.body);

    return ApiResponse<List<Intake>>.fromJson(
      jsonBody,
      fromData:
          (data) =>
              (data as List).map((item) => Intake.fromJson(item)).toList(),
    );
  } catch (e) {
    return ApiResponse<List<Intake>>(
      data: null,
      message: 'Ocurrió un error inesperado.',
      statusCode: 500,
      error: e.toString(),
    );
  }
}
