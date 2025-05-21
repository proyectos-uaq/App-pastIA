class ApiResponse<T> {
  final T? data;
  final String message;
  final int statusCode;
  final String? error;

  ApiResponse({
    this.data,
    required this.message,
    required this.statusCode,
    this.error,
  });

  bool get hasError => error != null;

  factory ApiResponse.fromJson(
    Map<String, dynamic> json, {
    required T Function(dynamic data) fromData,
  }) {
    final String parsedMessage;
    if (json['message'] is String) {
      parsedMessage = json['message'];
    } else if (json['message'] is List && json['message'].isNotEmpty) {
      parsedMessage = json['message'][0];
    } else {
      parsedMessage = 'Mensaje no disponible';
    }

    final String? parsedError = json['error'] is String ? json['error'] : null;

    T? parsedData;
    if (json['data'] != null) {
      if (json['data'] is List) {
        parsedData = fromData(
          (json['data'] as List).map((e) => e as Map<String, dynamic>).toList(),
        );
      } else {
        parsedData = fromData(json['data']);
      }
    }

    return ApiResponse<T>(
      data: parsedData,
      message: parsedMessage,
      statusCode: json['statusCode'] ?? 0,
      error: parsedError,
    );
  }

  @override
  String toString() {
    final buffer = StringBuffer('ApiResponse {\n');
    buffer.writeln('  data: $data,');
    buffer.writeln('  message: $message,');
    buffer.writeln('  statusCode: $statusCode,');
    buffer.writeln('  error: $error');
    buffer.write('}');
    return buffer.toString();
  }
}

T extractOrThrow<T>(ApiResponse<T> response) {
  if (response.hasError || response.data == null) {
    throw Exception(response.message);
  }
  return response.data!;
}
