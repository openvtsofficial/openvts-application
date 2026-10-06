import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/access/mobile_access.dart';
import 'package:open_vts/core/api/api_client.dart';
import 'package:open_vts/features/auth/controllers/auth_controller.dart';
import 'package:open_vts/features/auth/controllers/auth_state.dart';
import 'package:open_vts/features/auth/models/current_user.dart';
import 'package:open_vts/features/user/controllers/user_operations_providers.dart';
import 'package:open_vts/features/user/controllers/user_providers.dart';
import 'package:open_vts/features/user/screens/accounts/subusers/widgets/user_subuser_permissions_tab.dart';
import 'package:open_vts/features/user/screens/operations/user_operation_plan_screen.dart';
import 'package:open_vts/features/user/services/user_operations_service.dart';
import 'package:open_vts/features/user/services/user_subuser_service.dart';
import 'package:open_vts/l10n/app_localizations.dart';
import 'package:open_vts/shared/models/user_role.dart';
import 'package:open_vts/shared/widgets/open_vts_button.dart';

void main() {
  test(
    'Operations discards an older tab response after a newer request',
    () async {
      final service = _Operations();
      final controller = UserOperationsController(service);
      final today = controller.load('today', {});
      final trips = controller.load('trips', {});
      service.calls[1].complete({
        'items': [
          {'id': 'new', 'title': 'Current trip'},
        ],
        'pagination': {'total': 1},
      });
      await trips;
      service.calls[0].complete({
        'items': [
          {'id': 'old'},
        ],
      });
      await today;
      expect(controller.state.items.single['id'], 'new');
      controller.dispose();
    },
  );

  test('Refresh keeps the current records when the network fails', () async {
    final service = _Operations();
    final controller = UserOperationsController(service);
    final first = controller.load('today', {});
    service.calls.single.complete({
      'items': [
        {'id': 'trip'},
      ],
    });
    await first;
    final refresh = controller.load('today', {});
    expect(controller.state.items.single['id'], 'trip');
    service.calls.last.completeError(Exception('Offline'));
    await refresh;
    expect(controller.state.items.single['id'], 'trip');
    expect(controller.state.error, isNotNull);
    controller.dispose();
  });

  testWidgets(
    'Parent restrictions disable subuser toggles and preserve hidden deny keys on save',
    (tester) async {
      final service = _Permissions();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            userSubUsersServiceProvider.overrideWithValue(service),
            authControllerProvider.overrideWith((_) => _Auth()),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: SingleChildScrollView(
                child: UserSubUserPermissionsTab(subUserId: '8'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final maps = tester.widget<SwitchListTile>(
        find.widgetWithText(SwitchListTile, 'Maps'),
      );
      expect(maps.value, false);
      expect(maps.onChanged, isNull);
      expect(find.text('Workflow'), findsNothing);
      await tester.tap(find.widgetWithText(SwitchListTile, 'Dashboard'));
      await tester.pump();
      await tester.ensureVisible(find.text('Save permissions'));
      await tester.tap(find.text('Save permissions'));
      await tester.pumpAndSettle();
      expect(service.savedFeatures, contains('workflow'));
      expect(service.savedFeatures, contains('maps'));
      expect(service.savedFeatures, contains('dashboard'));
      expect(service.savedReports, ['logs']);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'Mobile trip planner explains ineligible vehicle and blocks submit',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            userOperationPlanningProvider.overrideWith(
              (ref) async => {
                'timezone': 'Asia/Kolkata',
                'vehicles': [
                  {
                    'id': 4,
                    'name': 'Truck',
                    'eligible': false,
                    'eligibility': 'DRIVER_REQUIRED',
                  },
                ],
                'routes': [
                  {'id': 2, 'name': 'Morning route', 'stopCount': 3},
                ],
              },
            ),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: UserOperationPlanScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.textContaining('No eligible vehicle'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('Create trip'),
        240,
        scrollable: find
            .descendant(
              of: find.byType(ListView),
              matching: find.byType(Scrollable),
            )
            .first,
      );
      final commonButton = find.widgetWithText(OpenVtsButton, 'Create trip');
      final button = tester.widget<ElevatedButton>(
        find.descendant(
          of: commonButton,
          matching: find.byType(ElevatedButton),
        ),
      );
      expect(tester.widget<OpenVtsButton>(commonButton).onPressed, isNull);
      expect(button.onPressed, isNull);
      expect(tester.takeException(), isNull);
    },
  );
}

class _Operations extends UserOperationsService {
  _Operations() : super(ApiClient(Dio()));
  final calls = <Completer<Map<String, dynamic>>>[];
  @override
  Future<Map<String, dynamic>> read(
    String resource, [
    Map<String, dynamic>? query,
  ]) {
    final result = Completer<Map<String, dynamic>>();
    calls.add(result);
    return result.future;
  }
}

class _Permissions extends UserSubUserService {
  _Permissions() : super(ApiClient(Dio()));
  List<String>? savedFeatures;
  List<String>? savedReports;
  final payload = <String, dynamic>{
    'availableFeatures': {
      for (final key in MobileAccess.userFeatures) key: key != 'maps',
    },
    'availableReports': {
      for (final key in MobileAccess.userReports) key: key != 'logs',
    },
    'disabledFeatures': ['maps', 'workflow'],
    'disabledReports': ['logs'],
  };
  @override
  Future<Map<String, dynamic>> fetchPermissions(String id) async => payload;
  @override
  Future<Map<String, dynamic>> replacePermissions(
    String id, {
    required List<String> disabledFeatures,
    required List<String> disabledReports,
  }) async {
    savedFeatures = disabledFeatures;
    savedReports = disabledReports;
    return {
      ...payload,
      'disabledFeatures': disabledFeatures,
      'disabledReports': disabledReports,
    };
  }
}

class _Auth extends StateNotifier<AuthState> implements AuthController {
  _Auth()
    : super(
        const AuthState.authenticated(
          CurrentUser(
            id: '11',
            name: 'User manager',
            email: '',
            role: UserRole.user,
            access: MobileAccess(loaded: true, features: {'accounts': true}),
          ),
        ),
      );
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
