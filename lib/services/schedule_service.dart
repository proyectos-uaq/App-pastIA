import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:past_ia/api/constants.dart';
import 'package:past_ia/utils/time_out_exception.dart';

import '../models/intake_model.dart';
import '../models/response_model.dart';
import '../models/schedule_model.dart';

class ScheduleService {
  // Crear un nuevo horario
  static Future<ApiResponse<Schedule>> createSchedule({
    required Schedule schedule,
    required String token,
  }) async {
    try {
      final url = Uri.parse('$API_URL/schedules');
      final response = await safeRequest(
        http.post(
          url,
          headers: _headers(token),
          body: jsonEncode(schedule.toJson()),
        ),
      );

      final jsonBody = jsonDecode(response!.body);

      return ApiResponse<Schedule>.fromJson(
        jsonBody,
        fromData: (data) => Schedule.fromJson(data),
      );
    } on TimeoutException {
      return _timeoutResponse<Schedule>();
    } catch (e) {
      return _errorResponse<Schedule>(e);
    }
  }

  // Actualizar un horario existente
  static Future<ApiResponse<Schedule>> updateSchedule({
    required String scheduleId,
    required Schedule schedule,
    required String token,
  }) async {
    try {
      final url = Uri.parse('$API_URL/schedules/$scheduleId');
      final response = await safeRequest(
        http.patch(
          url,
          headers: _headers(token),
          body: jsonEncode(schedule.toJson()),
        ),
      );

      final jsonBody = jsonDecode(response!.body);

      return ApiResponse<Schedule>.fromJson(
        jsonBody,
        fromData: (data) => Schedule.fromJson(data),
      );
    } on TimeoutException {
      return _timeoutResponse<Schedule>();
    } catch (e) {
      return _errorResponse<Schedule>(e);
    }
  }

  // Eliminar un horario
  static Future<ApiResponse<Schedule>> deleteSchedule({
    required String scheduleId,
    required String token,
  }) async {
    try {
      final url = Uri.parse('$API_URL/schedules/$scheduleId');
      final response = await safeRequest(
        http.delete(url, headers: _headers(token)),
      );

      final jsonBody = jsonDecode(response!.body);

      return ApiResponse<Schedule>.fromJson(
        jsonBody,
        fromData: (data) => Schedule.fromJson(data),
      );
    } on TimeoutException {
      return _timeoutResponse<Schedule>();
    } catch (e) {
      return _errorResponse<Schedule>(e);
    }
  }

  // Obtener los logs de consumo (intake) de un horario
  static Future<ApiResponse<List<Intake>>> getScheduleLogs({
    required String scheduleId,
    required String token,
  }) async {
    try {
      final url = Uri.parse('$API_URL/schedules/$scheduleId/intake/logs');
      final response = await safeRequest(
        http.get(url, headers: _headers(token)),
      );

      final jsonBody = jsonDecode(response!.body);

      return ApiResponse<List<Intake>>.fromJson(
        jsonBody,
        fromData:
            (data) =>
                (data as List).map((item) => Intake.fromJson(item)).toList(),
      );
    } on TimeoutException {
      return _timeoutResponse<List<Intake>>();
    } catch (e) {
      return _errorResponse<List<Intake>>(e);
    }
  }

  // Obtener todos los horarios
  static Future<ApiResponse<List<Schedule>>> getSchedules({
    required String token,
  }) async {
    try {
      final url = Uri.parse('$API_URL/schedules');
      final response = await safeRequest(
        http.get(url, headers: _headers(token)),
      );

      final jsonBody = jsonDecode(response!.body);

      return ApiResponse<List<Schedule>>.fromJson(
        jsonBody,
        fromData:
            (data) =>
                (data as List).map((item) => Schedule.fromJson(item)).toList(),
      );
    } on TimeoutException {
      return _timeoutResponse<List<Schedule>>();
    } catch (e) {
      return _errorResponse<List<Schedule>>(e);
    }
  }

  // Helpers

  static Map<String, String> _headers(String token) => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  };

  static ApiResponse<T> _errorResponse<T>(Object e) => ApiResponse<T>(
    data: null,
    message: 'Ocurrió un error inesperado.',
    statusCode: 500,
    error: e.toString(),
  );

  static ApiResponse<T> _timeoutResponse<T>() => ApiResponse<T>(
    data: null,
    message: 'La solicitud tardó demasiado. Intenta de nuevo.',
    statusCode: 408,
    error: 'Timeout',
  );
}
