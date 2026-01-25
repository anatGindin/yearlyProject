import 'dart:convert';
import 'package:http/http.dart' as http;
import '../exceptions/api_exceptions.dart';

class ApiClient {
  static const Duration _timeout = Duration(seconds: 10);

  /// Wraps all HTTP calls:
  /// - adds timeout
  /// - converts network errors into NetworkException
  static Future<http.Response> safeRequest(
    Future<http.Response> Function() request,
  ) async {
    try {
      return await request().timeout(_timeout);
    } on http.ClientException catch (e) {
      throw NetworkException('HTTP client error: ${e.message}');
    } on FormatException {
      throw NetworkException('Invalid response format');
    } on Exception catch (e) {
      throw NetworkException('Network error: $e');
    }
  }

  /// Parses backend error responses into ApiException
  static ApiException parseError(http.Response response) {
    try {
      final body = json.decode(response.body);
      return ApiException(
        response.statusCode,
        body['detail']?.toString() ?? 'API error',
        details: body['detail'],
      );
    } catch (_) {
      return ApiException(
        response.statusCode,
        'Invalid error response from server',
      );
    }
  }

  /// Validates expected HTTP status codes
  static void validateSuccess(
    http.Response response,
    List<int> expectedStatusCodes,
  ) {
    if (!expectedStatusCodes.contains(response.statusCode)) {
      throw parseError(response);
    }
  }
}
