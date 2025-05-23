import 'dart:async';
import 'dart:convert';

import 'package:past_ia/api/constants.dart';
import 'package:http/http.dart' as http;
import 'package:past_ia/utils/safe_request.dart';

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
    final response = await safeRequest(
      http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: intakeJson,
      ),
    );
    final jsonBody = jsonDecode(response!.body);
    final apiResponse = ApiResponse<Intake>.fromJson(
      jsonBody,
      fromData: (data) => Intake.fromJson(data),
    );
    return apiResponse.data;
  } on TimeoutException {
    return ApiResponse<Schedule>(
      data: null,
      message: 'La solicitud tardó demasiado. Intenta de nuevo.',
      statusCode: 408,
      error: 'Timeout',
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
