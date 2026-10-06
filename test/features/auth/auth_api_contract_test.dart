import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/api/api_client.dart';
import 'package:open_vts/core/api/api_exception.dart';
import 'package:open_vts/features/auth/models/current_user.dart';
import 'package:open_vts/features/auth/models/login_request.dart';
import 'package:open_vts/features/auth/models/mfa_challenge.dart';
import 'package:open_vts/features/auth/services/auth_service.dart';
import 'package:open_vts/features/auth/services/security_service.dart';
import 'package:open_vts/shared/models/user_role.dart';

void main() {
  setUp(() => dotenv.testLoad(fileInput: 'USE_MOCK_DATA=false'));

  test(
    'MFA response remains a challenge without creating a fake session',
    () async {
      final service = _service(
        (options) => {
          'status': 'success',
          'data': {
            'action': true,
            'data': {
              'mfaRequired': true,
              'challengeToken': 'a' * 64,
              'expiresIn': 300,
            },
          },
        },
      );
      await expectLater(
        service.login(
          const LoginRequest(identifier: 'name', password: 'password'),
        ),
        throwsA(
          isA<MfaRequiredException>().having(
            (e) => e.challenge.token,
            'token',
            'a' * 64,
          ),
        ),
      );
    },
  );

  test(
    'MFA verification sends exact contract and retains subuser identity',
    () async {
      late RequestOptions captured;
      final service = _service((options) {
        captured = options;
        return _login('SUBUSER');
      });
      final response = await service.verifyMfaLogin(
        MfaChallenge(
          token: 'a' * 64,
          expiresAt: DateTime.now().add(const Duration(minutes: 5)),
        ),
        ' 123456 ',
      );
      expect(captured.uri.path, '/api/auth/mfa/verify-login');
      expect(captured.data, {'challengeToken': 'a' * 64, 'code': '123456'});
      expect(response.user.role, UserRole.subuser);
      expect(
        CurrentUser.fromJson(response.user.toJson()).role,
        UserRole.subuser,
      );
    },
  );

  test(
    'every server role is accepted while unknown roles are rejected',
    () async {
      for (final role in UserRole.values.where((r) => r != UserRole.unknown)) {
        final response =
            await _service((_) => _login(role.apiValue.toUpperCase())).login(
              const LoginRequest(identifier: 'account', password: 'password'),
            );
        expect(response.user.role, role);
      }
      await expectLater(
        _service((_) => _login('UNKNOWN')).login(
          const LoginRequest(identifier: 'account', password: 'password'),
        ),
        throwsA(isA<ApiException>()),
      );
    },
  );

  test(
    'closure requires server confirmation and preserves password whitespace',
    () async {
      late RequestOptions captured;
      final service = SecurityService(
        _client((options) {
          captured = options;
          return {
            'action': true,
            'data': {'deleted': true},
          };
        }),
      );
      await service.deleteAccount({
        'currentPassword': ' password ',
        'code': 'RECOVERY-CODE',
      });
      expect(captured.method, 'DELETE');
      expect(captured.uri.path, '/api/auth/account');
      expect(captured.data, {
        'currentPassword': ' password ',
        'code': 'RECOVERY-CODE',
      });
      final unconfirmed = SecurityService(
        _client(
          (_) => {
            'action': true,
            'data': {'deleted': false},
          },
        ),
      );
      await expectLater(
        unconfirmed.deleteAccount({'currentPassword': 'password'}),
        throwsA(isA<ApiException>()),
      );
    },
  );

  test('current backend mobileCode survives profile parsing', () {
    final user = CurrentUser.fromJson({
      'id': '7',
      'role': 'USER',
      'mobileCode': '+44',
      'mobile': '12345',
    });
    expect(user.mobilePrefix, '+44');
  });
}

AuthService _service(Map<String, dynamic> Function(RequestOptions) response) =>
    AuthService(_client(response));
ApiClient _client(Map<String, dynamic> Function(RequestOptions) response) {
  final dio = Dio(BaseOptions(baseUrl: 'https://example.test/api'));
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        handler.resolve(
          Response<dynamic>(
            requestOptions: options,
            statusCode: 200,
            data: response(options),
          ),
        );
      },
    ),
  );
  return ApiClient(dio);
}

Map<String, dynamic> _login(String role) => {
  'action': true,
  'data': {
    'token': 'access',
    'refresh_token': 'refresh',
    'user': {
      'id': '7',
      'role': role,
      'name': 'User',
      'email': 'u@example.test',
    },
  },
};
