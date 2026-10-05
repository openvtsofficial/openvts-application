import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/access/mobile_access.dart';
import 'package:open_vts/core/api/api_client.dart';
import 'package:open_vts/core/api/api_exception.dart';
import 'package:open_vts/features/auth/models/current_user.dart';
import 'package:open_vts/features/auth/services/team_settings_service.dart';
import 'package:open_vts/shared/models/user_role.dart';

void main() {
  test('all known roles retain personal Settings without workspace grants', () {
    const access = MobileAccess.unavailable();
    for (final role in UserRole.values.where((r) => r != UserRole.unknown)) {
      expect(access.canAccessPath(role, role.settingsPath), isTrue);
      expect(access.canAccessPath(role, role.securityPath), isTrue);
      expect(access.canFeature(role, 'settings'), isTrue);
      expect(role.securityPath, '${role.settingsPath}?tab=security');
    }
    expect(access.canFeature(UserRole.unknown, 'settings'), isFalse);
  });
  test(
    'Team profile, localization and password use personal Team APIs only',
    () async {
      final sent = <RequestOptions>[];
      final service = TeamSettingsService(_client(UserRole.team, sent));
      await service.profile();
      await service.localization();
      await service.saveProfile({'name': 'नाम', 'email': ''});
      await service.saveLocalization({'language': 'hi', 'use24Hour': false});
      await service.changePassword({
        'currentPassword': ' old password ',
        'newPassword': ' next password ',
      });
      expect(sent.map((r) => '${r.method} ${r.uri.path}'), [
        'GET /api/team/profile',
        'GET /api/team/localization',
        'PATCH /api/team/profile',
        'PATCH /api/team/localization',
        'PATCH /api/team/updatepassword',
      ]);
      expect(sent.last.data, {
        'currentPassword': ' old password ',
        'newPassword': ' next password ',
      });
      expect(sent[2].data, {'name': 'नाम', 'email': ''});
    },
  );
  test(
    'wrong role cannot invoke personal Team settings or fall back to Admin',
    () async {
      for (final role in UserRole.values.where((r) => r != UserRole.team)) {
        final sent = <RequestOptions>[];
        final service = TeamSettingsService(_client(role, sent));
        for (final request in [
          service.profile,
          service.localization,
          () => service.saveProfile({}),
          () => service.saveLocalization({}),
          () => service.changePassword({}),
        ]) {
          await expectLater(
            request(),
            throwsA(
              isA<ApiException>().having((e) => e.statusCode, 'status', 403),
            ),
          );
        }
        expect(sent, isEmpty, reason: role.name);
      }
    },
  );
}

ApiClient _client(UserRole role, List<RequestOptions> sent) {
  final dio = Dio(BaseOptions(baseUrl: 'https://server.example/api'));
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (r, h) {
        sent.add(r);
        h.resolve(
          Response(
            requestOptions: r,
            statusCode: 200,
            data: {
              'action': true,
              'data': {'name': 'Team'},
            },
          ),
        );
      },
    ),
  );
  return ApiClient(
    dio,
    activeUser: () => CurrentUser(id: '7', name: 'Team', email: '', role: role),
  );
}
