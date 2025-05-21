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

  bool get hasError => error != null || data == null;

  factory ApiResponse.fromJson(
    Map<String, dynamic> json, {
    required T Function(dynamic data) fromData,
  }) {
    final String parsedMessage;
    if (json['message'] is String) {
      parsedMessage = json['message'];
    } else if (json['message'] is List && json['message'].isNotEmpty) {
      parsedMessage = json['message'][0].toString();
    } else {
      parsedMessage = 'Mensaje no disponible';
    }

    final String? parsedError = json['error'] is String ? json['error'] : null;

    T? parsedData;
    final rawData = json['data'];

    if (rawData != null) {
      parsedData = fromData(rawData);
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
    return '''
ApiResponse {
  data: $data,
  message: $message,
  statusCode: $statusCode,
  error: $error
}''';
  }
}

T extractOrThrow<T>(ApiResponse<T> response) {
  if (response.hasError || response.data == null) {
    throw Exception(response.message);
  }
  return response.data as T;
}
