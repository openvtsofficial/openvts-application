import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/api/api_client.dart';
import 'package:open_vts/core/api/api_exception.dart';
import 'package:open_vts/features/auth/models/current_user.dart';
import 'package:open_vts/features/auth/models/login_request.dart';
import 'package:open_vts/features/auth/models/login_response.dart';
import 'package:open_vts/features/auth/models/mfa_login_challenge.dart';
import 'package:open_vts/features/auth/services/auth_service.dart';

void main() {
  setUp(() => dotenv.testLoad(fileInput: 'USE_MOCK_DATA=false'));

  test('MFA response remains a challenge without creating a fake session', () async {
    final service = _service((options) => {
      'status': 'success', 'data': {'action': true, 'data': {
        'mfaRequired': true, 'challengeToken': 'a' * 64, 'expiresIn': 300,
      }},
    });
    await expectLater(service.login(const LoginRequest(identifier: 'name', password: 'password')),
      throwsA(isA<MfaLoginChallenge>().having((e) => e.token, 'token', 'a' * 64)));
  });

  test('MFA verification sends exact contract and retains subuser identity', () async {
    late RequestOptions captured;
    final service = _service((options) {
      captured = options;
      return _login('SUBUSER');
    });
    final response = await service.verifyMfaLogin(challengeToken: 'a' * 64, code: ' 123456 ');
    expect(captured.uri.path, '/api/auth/mfa/verify-login');
    expect(captured.data, {'challengeToken': 'a' * 64, 'code': '123456'});
    expect(response.user.isSubuser, isTrue);
    expect(CurrentUser.fromJson(response.user.toJson()).isSubuser, isTrue);
  });

  test('unsupported roles are rejected instead of opening the user workspace', () {
    for (final role in ['TEAM', 'DRIVER', 'UNKNOWN']) {
      expect(() => LoginResponse.fromJson({'token': 'a', 'refresh_token': 'r',
        'user': {'id': '7', 'role': role}}), throwsA(isA<ApiException>()));
    }
  });

  test('closure requires server confirmation and preserves password whitespace', () async {
    late RequestOptions captured;
    final service = _service((options) {
      captured = options;
      return {'action': true, 'data': {'deleted': true}};
    });
    await service.closeAccount(currentPassword: ' password ', code: ' RECOVERY-CODE ');
    expect(captured.method, 'DELETE');
    expect(captured.uri.path, '/api/auth/account');
    expect(captured.data, {'currentPassword': ' password ', 'code': 'RECOVERY-CODE'});
    final unconfirmed = _service((_) => {'action': true, 'data': {'deleted': false}});
    await expectLater(unconfirmed.closeAccount(currentPassword: 'password'),
        throwsA(isA<ApiException>()));
  });

  test('current backend mobileCode survives profile parsing', () {
    final user = CurrentUser.fromJson({'id': '7', 'role': 'USER', 'mobileCode': '+44', 'mobile': '12345'});
    expect(user.mobilePrefix, '+44');
  });
}

AuthService _service(Map<String, dynamic> Function(RequestOptions) response) {
  final dio = Dio(BaseOptions(baseUrl: 'https://example.test/api'));
  dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
    handler.resolve(Response<dynamic>(requestOptions: options, statusCode: 200, data: response(options)));
  }));
  return AuthService(ApiClient(dio));
}

Map<String, dynamic> _login(String role) => {'action': true, 'data': {
  'token': 'access', 'refresh_token': 'refresh',
  'user': {'id': '7', 'role': role, 'name': 'User', 'email': 'u@example.test'},
}};
