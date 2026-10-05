import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/api/api_client.dart';
import 'package:open_vts/features/user/controllers/user_operations_providers.dart';
import 'package:open_vts/features/user/models/user_landmark_model.dart';
import 'package:open_vts/features/user/screens/operations/user_operation_plan_screen.dart';
import 'package:open_vts/features/user/services/user_operations_service.dart';
import 'package:open_vts/l10n/app_localizations.dart';

void main() {
  Future<void> open(
    WidgetTester tester,
    _Operations service, {
    Map<String, dynamic>? recurring,
    Completer<UserRouteLandmark?>? routeResult,
  }) async {
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
                  'name': 'Delivery truck',
                  'plateNumber': 'DL 01',
                  'eligible': true,
                  'driver': {'id': 6, 'name': 'Driver One'},
                },
                {
                  'id': 5,
                  'name': 'Inactive truck',
                  'eligible': false,
                  'eligibility': 'VEHICLE_INACTIVE',
                },
              ],
              // No pre-existing routes: this is the reported blocked workflow.
              'routes': recurring == null
                  ? []
                  : [
                      {'id': 52, 'name': 'Warehouse route', 'stopCount': 2},
                    ],
            },
          ),
          userOperationsActionsProvider.overrideWithValue(
            UserOperationsActionsController(service),
          ),
          userOperationRouteEditorProvider.overrideWithValue((
            context,
            initial,
          ) async {
            if (routeResult != null) return routeResult.future;
            return UserRouteLandmark.fromJson({
              'id': 52,
              'name': 'Warehouse route',
              'isActive': true,
              'geodata': {
                'type': 'LineString',
                'coordinates': [
                  [77.1, 28.1],
                  [77.2, 28.2],
                ],
              },
              'stops': [
                {
                  'sequence': 1,
                  'name': 'Warehouse',
                  'sourceType': 'MANUAL',
                  'latitude': 28.1,
                  'longitude': 77.1,
                },
                {
                  'sequence': 2,
                  'name': 'Destination',
                  'sourceType': 'MANUAL',
                  'latitude': 28.2,
                  'longitude': 77.2,
                },
              ],
            });
          }),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                child: const Text('Open planner'),
                onPressed: () => Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        UserOperationPlanScreen(recurring: recurring),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open planner'));
    await tester.pumpAndSettle();
  }

  Future<void> reveal(WidgetTester tester, Finder finder) async {
    await tester.scrollUntilVisible(
      finder,
      250,
      scrollable: find
          .descendant(
            of: find.byType(ListView).first,
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await tester.pumpAndSettle();
  }

  testWidgets(
    'Create route returns to retained draft, selects saved ID, and creates trip',
    (tester) async {
      final service = _Operations();
      await open(tester, service);
      await tester.tap(find.byKey(const ValueKey('operation-vehicle')));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).last, 'Driver One');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delivery truck').last);
      await tester.pumpAndSettle();
      await reveal(tester, find.byKey(const ValueKey('operation-title')));
      await tester.enterText(
        find.byKey(const ValueKey('operation-title')),
        'Morning delivery',
      );
      await tester.ensureVisible(
        find.byKey(const ValueKey('operation-create-route')),
      );
      await tester.tap(find.byKey(const ValueKey('operation-create-route')));
      await tester.pumpAndSettle();
      expect(find.text('Warehouse route'), findsOneWidget);
      expect(
        tester
            .widget<TextFormField>(
              find.byKey(const ValueKey('operation-title')),
            )
            .controller!
            .text,
        'Morning delivery',
      );
      await reveal(tester, find.byKey(const ValueKey('operation-save-plan')));
      await tester.tap(find.byKey(const ValueKey('operation-save-plan')));
      await tester.pumpAndSettle();
      expect(service.payload?['routeId'], 52);
      expect(service.payload?['vehicleId'], 4);
      expect(service.payload?['title'], 'Morning delivery');
      expect(service.payload?.containsKey('endDate'), false);
      expect(find.text('Open planner'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('Back protects dirty trip draft and keeps saved routes', (
    tester,
  ) async {
    final service = _Operations();
    await open(tester, service);
    await reveal(tester, find.byKey(const ValueKey('operation-title')));
    await tester.enterText(
      find.byKey(const ValueKey('operation-title')),
      'Do not lose this',
    );
    await tester.pump();
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(find.text('Discard trip changes?'), findsOneWidget);
    await tester.tap(find.text('Keep editing'));
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<TextFormField>(find.byKey(const ValueKey('operation-title')))
          .controller!
          .text,
      'Do not lose this',
    );
    expect(service.payload, isNull);
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Discard changes'));
    await tester.pumpAndSettle();
    expect(find.text('Open planner'), findsOneWidget);
  });

  testWidgets(
    'Recurring generation warning remains visible after successful save',
    (tester) async {
      final service = _Operations()
        ..result = {'warning': 'Vehicle has a conflicting trip'};
      await open(
        tester,
        service,
        recurring: {
          'id': 'rule-1',
          'version': 3,
          'title': 'Morning schedule',
          'scheduleType': 'FIXED_TIME',
          'vehicle': {'id': 4},
          'route': {'id': 52},
          'weekdays': [1, 2, 3, 4, 5],
          'startDate': '2026-10-01',
          'startTime': '09:00',
        },
      );
      await reveal(tester, find.byKey(const ValueKey('operation-save-plan')));
      await tester.tap(find.byKey(const ValueKey('operation-save-plan')));
      await tester.pumpAndSettle();
      expect(service.payload?['version'], 3);
      expect(service.payload?.containsKey('endDate'), true);
      expect(
        find.textContaining('Vehicle has a conflicting trip'),
        findsOneWidget,
      );
      expect(find.byType(UserOperationPlanScreen), findsOneWidget);
      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();
      expect(find.text('Open planner'), findsOneWidget);
    },
  );
}

class _Operations extends UserOperationsService {
  _Operations() : super(ApiClient(Dio()));
  Map<String, dynamic>? payload;
  Map<String, dynamic> result = {'id': 'trip-created'};
  @override
  Future<Map<String, dynamic>> create(
    Map<String, dynamic> payload, {
    required bool recurring,
  }) async {
    this.payload = payload;
    return result;
  }

  @override
  Future<Map<String, dynamic>> updateRecurring(
    String id,
    Map<String, dynamic> payload,
  ) async {
    this.payload = payload;
    return result;
  }
}
