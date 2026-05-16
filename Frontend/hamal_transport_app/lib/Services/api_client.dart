/*
* based on Anat's version of api_client from PR #172
* Key modifications: safe request now adds headers
* */
import 'dart:convert';
import 'package:http/http.dart' as http;

class APIClient{
  // singleton
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() {
    return _instance;
  }
  ApiClient._internal();

  const Duration _timeout = Duration(seconds: 10);

  // HTTP wrapper
  static Future<http.Response> safeRequest(Future<http.Response> Function() request) async {
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
  }static void validateSuccess(
      http.Response response,
      List<int> expectedStatusCodes,
      ) {
    if (!expectedStatusCodes.contains(response.statusCode)) {
      throw parseError(response);
    }
  }
}


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