import 'dart:convert';

import 'package:app_pastia/api/constants.dart';
import 'package:http/http.dart' as http;

import '../models/intake_model.dart';
import '../models/response_model.dart';
import '../models/schedule_model.dart';

Future<dynamic> createIntake({
  required Intake intake,
  required String token,
}) async {
  try {
    final url = Uri.parse('$API_URL/intake');
    final String intakeJson = intake.toRawJson();
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: intakeJson,
    );
    final jsonBody = jsonDecode(response.body);
    final apiResponse = ApiResponse<Intake>.fromJson(
      jsonBody,
      fromData: (data) => Intake.fromJson(data),
    );
    // return apiResponse; // Devolvemos la respuesta completa
    // Si necesitas solo la lista, puedes usar schedule.data
    return apiResponse.data;
  } catch (e) {
    return ApiResponse<Schedule>(
      data: null,
      message: 'Ocurrió un error inesperado.',
      statusCode: 500,
      error: e.toString(),
    );
  }
}
