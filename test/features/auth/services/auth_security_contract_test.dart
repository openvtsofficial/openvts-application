import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/api/api_client.dart';
import 'package:open_vts/features/auth/models/login_request.dart';
import 'package:open_vts/features/auth/models/mfa_challenge.dart';
import 'package:open_vts/features/auth/services/auth_service.dart';
import 'package:open_vts/features/auth/services/security_service.dart';
import 'package:open_vts/shared/models/user_role.dart';

void main() {
  setUp(() => dotenv.testLoad(fileInput: 'USE_MOCK_DATA=false'));
  const challengeToken =
      'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
  test('password challenge does not become a token session', () async {
    final service = AuthService(_client((r) => {
          'mfaRequired': true,
          'challengeToken': challengeToken,
          'expiresIn': 300
        }));
    await expectLater(
        service.login(
            const LoginRequest(identifier: 'driver', password: 'example')),
        throwsA(isA<MfaRequiredException>()
            .having((e) => e.challenge.token, 'challenge', challengeToken)));
  });
  test('recovery login uses the challenge endpoint and trims the code',
      () async {
    late RequestOptions sent;
    final service = AuthService(_client((r) {
      sent = r;
      return _session('DRIVER');
    }));
    final response = await service.verifyMfaLogin(
        MfaChallenge(
            token: challengeToken,
            expiresAt: DateTime.now().add(const Duration(minutes: 5))),
        ' abcdefab-abcdefab-abcdefab-abcdefab ');
    expect(sent.uri.path, '/api/auth/mfa/verify-login');
    expect(sent.data, {
      'challengeToken': challengeToken,
      'code': 'abcdefab-abcdefab-abcdefab-abcdefab'
    });
    expect(response.user.role, UserRole.driver);
  });
  test('expired challenge never sends a verification request', () async {
    var called = false;
    final service = AuthService(_client((r) {
      called = true;
      return {};
    }));
    await expectLater(
        service.verifyMfaLogin(
            MfaChallenge(
                token: challengeToken,
                expiresAt: DateTime.now().subtract(const Duration(seconds: 1))),
            '123456'),
        throwsException);
    expect(called, false);
  });
  for (final role in [
    UserRole.superadmin,
    UserRole.admin,
    UserRole.team,
    UserRole.user,
    UserRole.subuser,
    UserRole.driver
  ]) {
    test('accepts ${role.apiValue} and requests correct profile', () async {
      final paths = <String>[];
      final service = AuthService(_client((r) {
        paths.add(r.uri.path);
        return r.uri.path.endsWith('/login')
            ? _session(role.apiValue.toUpperCase())
            : {'id': '7', 'name': 'Updated'};
      }));
      final login = await service.login(
          const LoginRequest(identifier: 'account', password: 'example'));
      expect(login.user.role, role);
      expect((await service.getProfile(login.user)).role, role);
      expect(paths.last,
          '/api/${role == UserRole.subuser ? 'user' : role.apiValue}/profile');
    });
  }
  test('unknown role never silently becomes user', () async {
    await expectLater(
        AuthService(_client((r) => _session('UNRECOGNIZED'))).login(
            const LoginRequest(identifier: 'account', password: 'example')),
        throwsException);
  });
  test('security lifecycle uses current backend payloads', () async {
    final sent = <RequestOptions>[];
    final service = SecurityService(_client((r) {
      sent.add(r);
      return {
        'enabled': true,
        'session': {'token': 'new', 'refresh_token': 'new-refresh'}
      };
    }));
    await service.enroll(
        {'name': 'Phone', 'currentPassword': 'password', 'code': '123456'});
    await service.confirm(challengeToken, '654321');
    await service.change('remove',
        {'deviceId': 'id', 'currentPassword': 'password', 'code': '123456'});
    expect(sent.map((r) => r.uri.path), [
      '/api/auth/mfa/enroll',
      '/api/auth/mfa/confirm',
      '/api/auth/mfa/devices/remove'
    ]);
    expect(sent[1].data, {'enrollmentToken': challengeToken, 'code': '654321'});
  });
  test('account deletion requires explicit server confirmation', () async {
    late RequestOptions sent;
    final service = SecurityService(_client((r) {
      sent = r;
      return {'deleted': true};
    }));
    await service
        .deleteAccount({'currentPassword': 'password', 'code': '123456'});
    expect(sent.method, 'DELETE');
    expect(sent.uri.path, '/api/auth/account');
    await expectLater(
        SecurityService(_client((r) => {'deleted': false}))
            .deleteAccount({'currentPassword': 'password'}),
        throwsException);
  });
}

Map<String, dynamic> _session(String role) => {
      'token': 'access',
      'refresh_token': 'refresh',
      'user': {
        'id': '7',
        'name': 'Account',
        'username': 'account',
        'role': role
      }
    };
ApiClient _client(Map<String, dynamic> Function(RequestOptions) responder) {
  final dio = Dio(BaseOptions(baseUrl: 'https://server.example/api'));
  dio.interceptors.add(InterceptorsWrapper(
      onRequest: (r, h) =>
          h.resolve(Response(requestOptions: r, statusCode: 200, data: {
            'status': 'success',
            'data': {'action': true, 'data': responder(r)}
          }))));
  return ApiClient(dio);
}
