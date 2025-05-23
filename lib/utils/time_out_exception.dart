import 'dart:async';

import 'package:http/http.dart' as http;

const Duration _timeout = Duration(seconds: 10);

// Función helper para manejar timeout y errores de red
Future<http.Response?> safeRequest(Future<http.Response> future) async {
  try {
    return await future.timeout(_timeout);
  } on TimeoutException {
    throw TimeoutException(
      'El servidor tardó demasiado en responder. Intenta de nuevo más tarde.',
    );
  } catch (_) {
    rethrow;
  }
}
