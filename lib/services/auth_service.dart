import 'dart:convert';

import 'package:app_pastia/api/constants.dart';
import 'package:app_pastia/models/response_model.dart';
import 'package:app_pastia/models/user_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  static Future<ApiResponse<String>> login({required User user}) async {
    final String userJson = jsonEncode(user.toJsonForCreate());
    final Uri url = Uri.parse('$API_URL/auth/login');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: userJson,
      );

      final jsonBody = jsonDecode(response.body);

      return ApiResponse<String>.fromJson(
        jsonBody,
        fromData: (data) => data['token'] ?? '', // Extraemos el token del login
      );
    } catch (e) {
      return ApiResponse<String>(
        data: null,
        message: 'Ocurrió un error inesperado: ${e.toString()}',
        statusCode: 500,
        error: 'Exception',
      );
    }
  }

  static Future<ApiResponse<String>> signUp({required User user}) async {
    final String userJson = jsonEncode(user.toJsonForCreate());
    final Uri url = Uri.parse('$API_URL/auth/register');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: userJson,
      );

      final jsonBody = jsonDecode(response.body);

      return ApiResponse<String>.fromJson(
        jsonBody,
        fromData: (data) => '', // SignUp no necesita retornar datos
      );
    } catch (e) {
      return ApiResponse<String>(
        data: null,
        message: 'Ocurrió un error inesperado: ${e.toString()}',
        statusCode: 500,
        error: 'Exception',
      );
    }
  }

  // Obtener el JWT
  static Future<void> saveJwtToken({required String token}) async {
    const FlutterSecureStorage secureStorage = FlutterSecureStorage();
    await secureStorage.write(key: 'token', value: token);

    final storage = FlutterSecureStorage();
    Map<String, String> allValues = await storage.readAll();
    print(allValues);
  }

  // Eliminar el JWT (ej: logout)
  Future<void> removeJwtToken() async {
    await secureStorage.delete(key: 'token');
  }
}
