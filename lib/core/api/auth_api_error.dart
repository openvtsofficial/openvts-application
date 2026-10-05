import 'package:dio/dio.dart';
import 'api_exception.dart';

/// Transport error details stay in the API layer, outside account UI/controllers.
class AuthApiError {
  const AuthApiError._();
  static bool isUnauthorized(Object error) =>
      error is DioException && error.response?.statusCode == 401;
  static String message(Object error) {
    if (error is ApiException) return error.message;
    if (error is DioException) {
      final data = error.response?.data;
      if (data is Map && data['message'] != null) {
        final message = data['message'];
        return message is List ? message.join(', ') : message.toString();
      }
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.sendTimeout) {
        return 'Connection timed out. Check your Server URL and network connection.';
      }
      if (error.response?.statusCode == 401 ||
          error.response?.statusCode == 403) {
        return 'Unable to authenticate this request. Sign in again.';
      }
      return 'Unable to reach the server. Check your Server URL and network connection.';
    }
    return 'Unable to complete this request. Please try again.';
  }
}
