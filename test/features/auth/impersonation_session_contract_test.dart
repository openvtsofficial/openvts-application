import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/features/admin/models/admin_users_model.dart';
import 'package:open_vts/features/superadmin/models/superadmin_administrator_model.dart';
import 'package:open_vts/shared/models/user_role.dart';

void main() {
  test('Admin Login-as User preserves role and localization settings', () {
    final outcome = AdminUserLoginResult.fromJson(_payload('USER'));
    expect(outcome.hasSession, true);
    final session = outcome.toLoginResponse();
    expect(session.user.role, UserRole.user);
    expect(session.settings['timezone'], '+05:30');
    expect(session.settings['timeFormat'], '24H');
  });

  test(
    'Admin User impersonation never coerces another role or malformed session',
    () {
      for (final role in ['TEAM', 'DRIVER', 'SUBUSER', 'ADMIN', 'UNKNOWN']) {
        final outcome = AdminUserLoginResult.fromJson(_payload(role));
        expect(outcome.hasSession, false);
        expect(outcome.user.role, UserRole.fromString(role));
      }
      final payload = _payload('USER');
      payload['refresh_token'] = '';
      expect(AdminUserLoginResult.fromJson(payload).hasSession, false);
    },
  );

  test(
    'Superadmin Login-as Admin requires verified Admin identity and both tokens',
    () {
      final outcome = SuperadminAdministratorLoginOutcome.fromJson(
        _payload('ADMIN'),
      );
      expect(outcome.hasSession, true);
      expect(outcome.settings['timezone'], '+05:30');
      for (final role in ['USER', 'TEAM', 'DRIVER', 'UNKNOWN']) {
        expect(
          SuperadminAdministratorLoginOutcome.fromJson(
            _payload(role),
          ).hasSession,
          false,
        );
      }
      final payload = _payload('ADMIN');
      payload['refresh_token'] = null;
      expect(
        SuperadminAdministratorLoginOutcome.fromJson(payload).hasSession,
        false,
      );
    },
  );

  test(
    'nested current backend envelopes preserve exact impersonation tokens',
    () {
      expect(
        AdminUserLoginResult.fromJson({'data': _payload('USER')}).hasSession,
        true,
      );
      expect(
        SuperadminAdministratorLoginOutcome.fromJson({
          'data': _payload('ADMIN'),
        }).hasSession,
        true,
      );
    },
  );
}

Map<String, dynamic> _payload(String role) => {
  'token': 'access',
  'refresh_token': 'refresh',
  'user': {'id': '7', 'name': 'Account', 'role': role},
  'settings': {
    'timezone': '+05:30',
    'timeFormat': '24H',
    'dateFormat': 'YYYY-MM-DD',
  },
};
