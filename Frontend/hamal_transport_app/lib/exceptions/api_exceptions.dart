class ApiException implements Exception {
  final int statusCode;
  final String message;
  final dynamic details;

  ApiException(
    this.statusCode,
    this.message, {
    this.details,
  });

  @override
  String toString() =>
      'ApiException(statusCode: $statusCode, message: $message, details: $details)';
}

class NetworkException implements Exception {
  final String message;

  NetworkException(this.message);

  @override
  String toString() => 'NetworkException: $message';
}
