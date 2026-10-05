import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/access/mobile_access.dart';
import 'package:open_vts/core/access/workspace_scope_provider.dart';
import 'package:open_vts/features/auth/models/current_user.dart';
import 'package:open_vts/shared/models/user_role.dart';

void main() {
  const user = CurrentUser(
    id: '7',
    name: 'Original',
    email: '',
    role: UserRole.team,
    access: MobileAccess(
      loaded: true,
      grants: {'vehicles.view': 'TENANT', 'users.view': 'OWN'},
      navigation: {'vehicles', 'users'},
    ),
  );
  test('scope isolates same-role accounts, demo and logout', () {
    final scope = workspaceDataScope(user);
    expect(workspaceDataScope(user.copyWith(id: '8')), isNot(scope));
    expect(workspaceDataScope(null), isNot(scope));
    expect(workspaceDataScope(user, isDemo: true), isNot(scope));
  });
  test('profile and equivalent permission refresh keep stable data scope', () {
    expect(
      workspaceDataScope(user.copyWith(name: 'Updated')),
      workspaceDataScope(user),
    );
    final equivalent = user.copyWith(
      access: const MobileAccess(
        loaded: true,
        grants: {'users.view': 'OWN', 'vehicles.view': 'TENANT'},
        navigation: {'users', 'vehicles'},
        version: 99,
      ),
    );
    expect(workspaceDataScope(equivalent), workspaceDataScope(user));
  });
  test(
    'revoked grants, narrower scopes and unavailable access invalidate data',
    () {
      final narrower = user.copyWith(
        access: const MobileAccess(
          loaded: true,
          grants: {'vehicles.view': 'ASSIGNED'},
          navigation: {'vehicles'},
        ),
      );
      expect(workspaceDataScope(narrower), isNot(workspaceDataScope(user)));
      expect(
        workspaceDataScope(
          user.copyWith(access: const MobileAccess.unavailable()),
        ),
        isNot(workspaceDataScope(user)),
      );
    },
  );
}
