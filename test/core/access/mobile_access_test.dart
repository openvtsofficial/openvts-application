import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/access/mobile_access.dart';
import 'package:open_vts/core/utils/permission_helper.dart';
import 'package:open_vts/features/auth/models/current_user.dart';
import 'package:open_vts/shared/models/user_role.dart';

Map<String, dynamic> userPermissions({
  Set<String> disabled = const {},
  Set<String> disabledReports = const {},
}) => {
  'features': {
    for (final key in MobileAccess.userFeatures) key: !disabled.contains(key),
  },
  'reports': {
    for (final key in MobileAccess.userReports)
      key: !disabledReports.contains(key),
  },
  'version': 3,
};
void main() {
  test(
    'all six server roles parse and unknown roles never fall back to USER',
    () {
      for (final role in UserRole.values.where(
        (role) => role != UserRole.unknown,
      )) {
        expect(UserRole.fromString(role.apiValue.toUpperCase()), role);
      }
      expect(UserRole.fromString('owner'), UserRole.unknown);
      expect(UserRole.fromString(null), UserRole.unknown);
      expect(UserRole.team.apiValue, 'team');
      expect(UserRole.team.routePrefix, '/admin');
      expect(UserRole.subuser.apiValue, 'subuser');
    },
  );
  test('profile serialization cannot persist access across sessions', () {
    final user = CurrentUser(
      id: '7',
      name: 'User',
      email: '',
      role: UserRole.user,
      access: MobileAccess.user(userPermissions()),
    );
    expect(user.accessLoaded, isTrue);
    expect(CurrentUser.fromJson(user.toJson()).accessLoaded, isFalse);
    expect(user.copyWith(name: 'Updated').accessLoaded, isTrue);
  });
  test(
    'unavailable or malformed permissions fail closed but leave account/retry accessible',
    () {
      const access = MobileAccess.unavailable();
      for (final path in ['/user', '/user/security', '/user/profile']) {
        expect(access.canAccessPath(UserRole.user, path), isTrue);
      }
      expect(access.canAccessPath(UserRole.user, '/user/map'), isFalse);
      expect(
        () => MobileAccess.user({'features': {}, 'reports': {}}),
        throwsFormatException,
      );
      expect(
        () => MobileAccess.user({
          'features': {'maps': 'true'},
          'reports': {},
        }),
        throwsFormatException,
      );
    },
  );
  test('user and subuser direct/detail/report routes obey denies', () {
    final access = MobileAccess.user(
      userPermissions(
        disabled: {'maps', 'vehicles', 'landmarks'},
        disabledReports: {'logs'},
      ),
    );
    for (final role in [UserRole.user, UserRole.subuser]) {
      for (final path in [
        '/user/map',
        '/user/history',
        '/user/vehicles/3',
        '/user/landmarks-studio/geofences/editor',
        '/user/reports/logs',
        '/user/reports/arbitrary',
      ]) {
        expect(access.canAccessPath(role, path), isFalse, reason: path);
      }
      expect(access.canAccessPath(role, '/user/reports/distance'), isTrue);
    }
  });
  test('report feature denial overrides individual grants', () {
    final access = MobileAccess.user(userPermissions(disabled: {'reports'}));
    expect(access.canAccessPath(UserRole.user, '/user/reports'), isFalse);
    expect(access.canReport(UserRole.user, 'distance'), isFalse);
  });
  test('subusers cannot manage subusers or enter USER-only Operations', () {
    final access = MobileAccess.user(userPermissions());
    expect(
      access.canAccessPath(UserRole.user, '/user/accounts/sub-users/2'),
      isTrue,
    );
    expect(
      access.canAccessPath(UserRole.subuser, '/user/accounts/sub-users/2'),
      isFalse,
    );
    expect(
      access.canAccessPath(UserRole.subuser, '/user/accounts/drivers/2'),
      isTrue,
    );
    expect(access.canAccessPath(UserRole.user, '/user/operations'), isTrue);
    expect(access.canAccessPath(UserRole.subuser, '/user/operations'), isFalse);
    expect(access.canAccessPath(UserRole.user, '/user/workflow'), isFalse);
  });
  test('team navigation requires both server projection and a valid grant', () {
    final access = MobileAccess.team({
      'grants': {
        'vehicles.view': 'ASSIGNED',
        'users.view': 'TENANT',
        'logs.view': 'invalid',
      },
      'navigation': ['vehicles', 'logs', 'dashboard', 'settings', 'notify'],
    });
    expect(access.canAccessPath(UserRole.team, '/admin/vehicles/4'), isTrue);
    for (final path in [
      'users',
      'logs',
      'dashboard',
      'team',
      'transactions',
      'create-vehicle',
    ]) {
      expect(
        access.canAccessPath(UserRole.team, '/admin/$path'),
        isFalse,
        reason: path,
      );
    }
  });
  test('team create routes use exact backend capabilities/scopes', () {
    final access = MobileAccess.team({
      'grants': {
        'users.view': 'TENANT',
        'users.update': 'OWN',
        'support.view': 'TENANT',
        'support.reply': 'TENANT',
        'vehicles.view': 'TENANT',
        'vehicles.update': 'ASSIGNED',
      },
      'navigation': ['users', 'support', 'vehicles'],
    });
    expect(access.canAccessPath(UserRole.team, '/admin/create-user'), isTrue);
    expect(
      access.canAccessPath(UserRole.team, '/admin/support/create'),
      isTrue,
    );
    expect(
      access.canAccessPath(UserRole.team, '/admin/create-vehicle'),
      isFalse,
    );
    final user = CurrentUser(
      id: '12',
      name: 'Team',
      email: '',
      role: UserRole.team,
      access: access,
    );
    expect(PermissionHelper.canPerform(user, 'users.update'), isTrue);
    expect(
      PermissionHelper.canPerform(user, 'users.update', scopes: {'TENANT'}),
      isFalse,
    );
    expect(PermissionHelper.canPerform(user, 'users.delete'), isFalse);
  });
  test(
    'admin Roles and web-only features are absent even for privileged accounts',
    () {
      const access = MobileAccess.account();
      expect(access.canAccessPath(UserRole.admin, '/admin/roles'), isFalse);
      expect(access.canAccessPath(UserRole.admin, '/admin/notify'), isFalse);
      for (final page in [
        'master-data',
        'software-license',
        'ssl',
        'notify',
        'devices',
      ]) {
        expect(
          access.canAccessPath(UserRole.superadmin, '/superadmin/$page'),
          isFalse,
        );
      }
      expect(
        access.canAccessPath(UserRole.admin, '/admin/transactions'),
        isTrue,
      );
    },
  );
  test(
    'cross-role, prefix confusion, external and arbitrary nested routes denied',
    () {
      const access = MobileAccess.account();
      for (final path in [
        '/administrator/vehicles',
        '/superadmin/vehicles',
        '/admin/users/2/private',
        'https://example.com/admin/users',
      ]) {
        expect(access.canAccessPath(UserRole.admin, path), isFalse);
      }
      expect(access.canAccessPath(UserRole.unknown, '/user'), isFalse);
    },
  );
  test('driver has implemented driver routes and account security only', () {
    const access = MobileAccess.account();
    expect(access.canFeature(UserRole.driver, 'maps'), isFalse);
    expect(access.canFeature(UserRole.admin, 'unimplemented'), isFalse);
    expect(access.canAccessPath(UserRole.driver, '/driver/trips'), isTrue);
    expect(access.canAccessPath(UserRole.driver, '/driver/security'), isTrue);
    expect(access.canAccessPath(UserRole.driver, '/driver/map'), isFalse);
    expect(access.canAccessPath(UserRole.driver, '/user/map'), isFalse);
  });
}
