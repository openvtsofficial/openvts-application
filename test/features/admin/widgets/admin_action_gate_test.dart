import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/access/mobile_access.dart';
import 'package:open_vts/features/admin/models/admin_users_model.dart';
import 'package:open_vts/features/admin/screens/users/widgets/admin_user_card.dart';
import 'package:open_vts/features/admin/widgets/admin_action_gate.dart';
import 'package:open_vts/features/auth/models/current_user.dart';
import 'package:open_vts/shared/models/user_role.dart';

CurrentUser _actor(UserRole role, MobileAccess access) =>
    CurrentUser(id: '7', name: 'Staff', email: '', role: role, access: access);

Future<void> _pump(WidgetTester tester, CurrentUser user) => tester.pumpWidget(
  ProviderScope(
    overrides: [adminActorProvider.overrideWithValue(user)],
    child: const MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            AdminActionGate(
              capability: 'vehicles.update',
              child: Text('Edit vehicle'),
            ),
            AdminActionGate(
              capability: 'vehicles.delete',
              child: Text('Delete vehicle'),
            ),
            AdminActionGate(
              capability: 'vehicles.update',
              scopes: {'TENANT'},
              child: Text('Create vehicle'),
            ),
          ],
        ),
      ),
    ),
  ),
);

void main() {
  testWidgets('read-only Team sees no mutation controls', (tester) async {
    await _pump(
      tester,
      _actor(
        UserRole.team,
        const MobileAccess(loaded: true, grants: {'vehicles.view': 'TENANT'}),
      ),
    );
    expect(find.text('Edit vehicle'), findsNothing);
    expect(find.text('Delete vehicle'), findsNothing);
    expect(find.text('Create vehicle'), findsNothing);
  });
  testWidgets('assigned updater may edit but cannot create tenant vehicles', (
    tester,
  ) async {
    await _pump(
      tester,
      _actor(
        UserRole.team,
        const MobileAccess(
          loaded: true,
          grants: {'vehicles.view': 'ASSIGNED', 'vehicles.update': 'ASSIGNED'},
        ),
      ),
    );
    expect(find.text('Edit vehicle'), findsOneWidget);
    expect(find.text('Delete vehicle'), findsNothing);
    expect(find.text('Create vehicle'), findsNothing);
  });
  testWidgets('tenant updater receives create and edit but no delete', (
    tester,
  ) async {
    await _pump(
      tester,
      _actor(
        UserRole.team,
        const MobileAccess(loaded: true, grants: {'vehicles.update': 'TENANT'}),
      ),
    );
    expect(find.text('Edit vehicle'), findsOneWidget);
    expect(find.text('Create vehicle'), findsOneWidget);
    expect(find.text('Delete vehicle'), findsNothing);
  });
  testWidgets('unavailable access snapshot fails closed', (tester) async {
    await _pump(
      tester,
      _actor(UserRole.admin, const MobileAccess.unavailable()),
    );
    expect(find.text('Edit vehicle'), findsNothing);
    expect(find.text('Create vehicle'), findsNothing);
    expect(find.text('Delete vehicle'), findsNothing);
  });
  testWidgets('authenticated admin has all action controls', (tester) async {
    await _pump(tester, _actor(UserRole.admin, const MobileAccess.account()));
    expect(find.text('Edit vehicle'), findsOneWidget);
    expect(find.text('Create vehicle'), findsOneWidget);
    expect(find.text('Delete vehicle'), findsOneWidget);
  });
  testWidgets(
    'read-only Team customer card retains view but hides account mutations',
    (tester) async {
      final user = _actor(
        UserRole.team,
        const MobileAccess(loaded: true, grants: {'users.view': 'TENANT'}),
      );
      await tester.pumpWidget(
        ProviderScope(
          overrides: [adminActorProvider.overrideWithValue(user)],
          child: MaterialApp(
            home: Scaffold(
              body: AdminUserCard(
                user: AdminUserListItem.fromJson({
                  'uid': 8,
                  'name': 'Customer',
                  'username': 'customer',
                  'isActive': true,
                }),
                isUpdating: false,
                isDeleting: false,
                isLoggingIn: false,
                onTap: () {},
                onStatusChanged: (_) {},
                onActionSelected: (_) {},
              ),
            ),
          ),
        ),
      );
      expect(find.byType(Switch), findsNothing);
      await tester.tap(find.byType(PopupMenuButton<AdminUserCardAction>));
      await tester.pumpAndSettle();
      expect(find.text('View details'), findsOneWidget);
      expect(find.text('Edit user'), findsNothing);
      expect(find.text('Change password'), findsNothing);
      expect(find.text('Login as user'), findsNothing);
      expect(find.text('Delete'), findsNothing);
    },
  );
}
