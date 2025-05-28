import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:past_ia/api/constants.dart';
import 'package:past_ia/models/response_model.dart';

/// Envía los datos a la IA
Future<ApiResponse<Map<String, dynamic>>> sendDataToAI({
  required String prescriptionId,
  required String token,
}) async {
  try {
    final url = Uri.parse('$API_URL/Ia/send-data/$prescriptionId');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final int statusCode = response.statusCode;

    if (statusCode == 200) {
      final jsonBody = jsonDecode(response.body) as Map<String, dynamic>;
      return ApiResponse<Map<String, dynamic>>(
        data: jsonBody['data'] as Map<String, dynamic>?,
        message: jsonBody['message'] ?? 'Operación exitosa',
        statusCode: statusCode,
        error: jsonBody['error'],
      );
    } else {
      // Intenta decodificar el body si posible
      Map<String, dynamic>? errorBody;
      try {
        errorBody = jsonDecode(response.body) as Map<String, dynamic>?;
      } catch (_) {}
      return ApiResponse<Map<String, dynamic>>(
        data: null,
        message: errorBody?['message'] ?? 'Error al enviar datos a la IA',
        statusCode: statusCode,
        error: errorBody?['error'] ?? 'HTTP $statusCode',
      );
    }
  } catch (e) {
    return ApiResponse<Map<String, dynamic>>(
      data: null,
      message: 'Excepción: $e',
      statusCode: 0,
      error: e.toString(),
    );
  }
}
