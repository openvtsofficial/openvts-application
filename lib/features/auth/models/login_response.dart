import 'current_user.dart';

class LoginResponse {
  const LoginResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
    this.settings = const <String, dynamic>{},
  });

  final String accessToken;
  final String refreshToken;
  final CurrentUser user;
  final Map<String, dynamic> settings;

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    final userJson =
        (json['user'] as Map<String, dynamic>?) ?? <String, dynamic>{};

    return LoginResponse(
      accessToken: json['token']?.toString() ??
          json['accessToken']?.toString() ??
          json['access_token']?.toString() ??
          '',
      refreshToken: json['refresh_token']?.toString() ??
          json['refreshToken']?.toString() ??
          '',
      user: CurrentUser.fromJson(userJson),
      settings: json['settings'] is Map
          ? Map<String, dynamic>.from(json['settings'] as Map)
          : const {},
    );
  }
}
