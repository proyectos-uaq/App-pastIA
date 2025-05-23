import 'dart:async';
import 'package:http/http.dart' as http;

Future<http.Response?> safeRequest(Future<http.Response> request) async {
  return request.timeout(
    const Duration(seconds: 5),
    onTimeout:
        () =>
            throw TimeoutException(
              'El servidor ha tardado demasiado en responder. Intenta de nuevo más tarde.',
            ),
  );
}
