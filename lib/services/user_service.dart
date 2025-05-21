import 'dart:convert';
import 'package:app_pastia/api/constants.dart';
import 'package:http/http.dart' as http;

import '../models/response_model.dart';
import '../models/user_model.dart';

Future<ApiResponse<User>> updateUserData({
  required User user,
  required String token,
}) async {
  final String userJson = jsonEncode(user.toJson()); // Sin password
  final Uri url = Uri.parse('$API_URL/users/me');

  try {
    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: userJson,
    );

    final jsonBody = jsonDecode(response.body);

    final apiResponse = ApiResponse<User>.fromJson(
      jsonBody,
      fromData: (data) => User.fromJson(data),
    );

    return apiResponse;
  } catch (e) {
    return ApiResponse<User>(
      data: null,
      message: 'Ocurrió un error inesperado',
      statusCode: 500,
      error: e.toString(),
    );
  }
}

Future<ApiResponse<String>> deleteUser({required String token}) async {
  final Uri url = Uri.parse('$API_URL/users/me');

  try {
    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final jsonBody = jsonDecode(response.body);

    return ApiResponse<String>.fromJson(
      jsonBody,
      fromData: (_) => '', // Data no es necesaria
    );
  } catch (e) {
    return ApiResponse<String>(
      data: null,
      message: 'Ocurrió un error inesperado',
      statusCode: 500,
      error: e.toString(),
    );
  }
}
