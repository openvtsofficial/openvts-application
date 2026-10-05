import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/api/api_client.dart';
import 'package:open_vts/features/user/controllers/user_operations_providers.dart';
import 'package:open_vts/features/user/controllers/user_providers.dart';
import 'package:open_vts/features/user/screens/accounts/subusers/widgets/user_subuser_permissions_tab.dart';
import 'package:open_vts/features/user/screens/operations/user_operation_plan_screen.dart';
import 'package:open_vts/features/user/services/user_operations_service.dart';
import 'package:open_vts/features/user/services/user_subuser_service.dart';

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
          overrides: [userSubUsersServiceProvider.overrideWithValue(service)],
          child: const MaterialApp(
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
      await tester.ensureVisible(find.text('Save permissions'));
      await tester.tap(find.text('Save permissions'));
      await tester.pumpAndSettle();
      expect(service.savedFeatures, contains('workflow'));
      expect(service.savedFeatures, contains('maps'));
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
          child: const MaterialApp(home: UserOperationPlanScreen()),
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
      final button = tester.widget<FilledButton>(
        find.ancestor(
          of: find.text('Create trip'),
          matching: find.byType(FilledButton),
        ),
      );
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
  final payload = <String, dynamic>{
    'availableFeatures': {'maps': false, 'reports': true, 'workflow': true},
    'availableReports': {'logs': false},
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
    return payload;
  }
}
