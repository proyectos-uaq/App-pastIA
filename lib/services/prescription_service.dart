// try {
//     final response = await getPrescriptions();
//     // Extraer directamente la lista de recetas
//     final List<Prescription> prescriptions = extractOrThrow(response);
//     if (prescriptions.isEmpty) {
//       print('[]');
//       return;
//     }
//     for (var p in prescriptions) {
//       print(p);
//     }
//   } catch (e) {
//     print('Error: $e');
//   }

import 'dart:convert';

import 'package:app_pastia/api/constants.dart';
import 'package:http/http.dart' as http;

import '../models/prescription_model.dart';
import '../models/response_model.dart';

Future<dynamic> getPrescriptions({required String token}) async {
  try {
    final url = Uri.parse('$API_URL/prescriptions');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final jsonBody = jsonDecode(response.body);

    final prescriptions = ApiResponse<List<Prescription>>.fromJson(
      jsonBody,
      fromData:
          (data) =>
              (data as List)
                  .map((item) => Prescription.fromJson(item))
                  .toList(),
    );

    //return prescriptions; // Devolvemos la respuesta completa
    // Si necesitas solo la lista, puedes usar prescriptions.data
    return prescriptions.data ?? [];
  } catch (e) {
    return ApiResponse<List<Prescription>>(
      data: null,
      message: 'Ocurrió un error inesperado.',
      statusCode: 500,
      error: e.toString(),
    );
  }
}

Future<dynamic> getPrescriptionById({
  required String id,
  required String token,
}) async {
  try {
    final url = Uri.parse('$API_URL/prescriptions/$id');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final jsonBody = jsonDecode(response.body);

    final prescription = ApiResponse<Prescription>.fromJson(
      jsonBody,
      fromData: (data) => Prescription.fromJson(data),
    );

    //return prescription; //  Devolvemos la respuesta completa
    // Se puede devolver solo la receta si es necesario
    return prescription.data ?? null;
  } catch (e) {
    return ApiResponse<Prescription>(
      data: null,
      message: 'Ocurrió un error inesperado.',
      statusCode: 500,
      error: e.toString(),
    );
  }
}

Future<dynamic> createPrescription({
  required Prescription prescription,
  required String token,
}) async {
  final String prescriptionJson = jsonEncode(prescription.toJson());
  final Uri url = Uri.parse('$API_URL/prescriptions');

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: prescriptionJson,
    );

    final jsonBody = jsonDecode(response.body);

    final apiResponse = ApiResponse<Prescription>.fromJson(
      jsonBody,
      fromData: (data) => Prescription.fromJson(data),
    );

    // return apiResponse; // Devolvemos la respuesta completa
    // Si necesitas solo la receta, puedes usar apiResponse.data
    return apiResponse.data ?? null;
  } catch (e) {
    return ApiResponse<Prescription>(
      data: null,
      message: 'Ocurrió un error inesperado',
      statusCode: 500,
      error: e.toString(),
    );
  }
}

Future<dynamic> updatePrescription({
  required String id,
  required Prescription prescription,
  required String token,
}) async {
  final String prescriptionJson = jsonEncode(prescription.toJson());
  final Uri url = Uri.parse('$API_URL/prescriptions/${id}');

  try {
    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: prescriptionJson,
    );

    print(response.body);
    final jsonBody = jsonDecode(response.body);

    final apiResponse = ApiResponse<Prescription>.fromJson(
      jsonBody,
      fromData: (data) => Prescription.fromJson(data),
    );

    // return apiResponse; // Devolvemos la respuesta completa
    // Si necesitas solo la receta, puedes usar apiResponse.data
    return apiResponse.data ?? null;
  } catch (e) {
    return ApiResponse<Prescription>(
      data: null,
      message: 'Ocurrió un error inesperado',
      statusCode: 500,
      error: e.toString(),
    );
  }
}

Future<dynamic> deletePrescription({
  required String id,
  required String token,
}) async {
  final Uri url = Uri.parse('$API_URL/prescriptions/$id');

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
      fromData: (data) => data['message'] ?? '', // Mensaje de éxito
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
