import '../../../core/api/api_exception.dart';
import 'current_user.dart';

class LoginResponse {
  const LoginResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  final String accessToken;
  final String refreshToken;
  final CurrentUser user;

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    final userJson =
        (json['user'] as Map<String, dynamic>?) ?? <String, dynamic>{};

    final serverRole = userJson['role']?.toString().trim().toUpperCase();
    if (!const {'SUPERADMIN', 'ADMIN', 'USER', 'SUBUSER'}.contains(serverRole)) {
      throw const ApiException(
        message: 'This account role is not supported by this mobile app. '
            'Please use your organization’s web application.',
      );
    }

    return LoginResponse(
      accessToken: json['token']?.toString() ??
          json['accessToken']?.toString() ??
          json['access_token']?.toString() ??
          '',
      refreshToken: json['refresh_token']?.toString() ??
          json['refreshToken']?.toString() ??
          '',
      user: CurrentUser.fromJson(userJson),
    );
  }
}
