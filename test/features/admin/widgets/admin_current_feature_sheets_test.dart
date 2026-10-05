import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/api/api_client.dart';
import 'package:open_vts/features/admin/controllers/admin_parity_controller.dart';
import 'package:open_vts/features/admin/screens/payments/widgets/admin_renewal_requests_sheet.dart';
import 'package:open_vts/features/admin/screens/team/widgets/admin_team_permissions_sheet.dart';
import 'package:open_vts/features/admin/screens/users/widgets/admin_user_permissions_sheet.dart';
import 'package:open_vts/features/admin/screens/vehicles/widgets/admin_vehicle_service_sheet.dart';

class _Controller extends AdminParityController {
  _Controller() : super(ApiClient(Dio()));
  @override
  Future<List<Map<String, dynamic>>> loadTeamPermissions(String id) async => [
    {
      'features': [
        {
          'label': 'Vehicles',
          'description': 'Access to vehicle records',
          'actions': [
            {
              'action': 'view',
              'permissionSlug': 'vehicles.view',
              'allowedScopes': ['OWN', 'TENANT'],
            },
            {
              'action': 'edit',
              'permissionSlug': 'vehicles.update',
              'allowedScopes': ['OWN', 'TENANT'],
            },
          ],
        },
      ],
    },
    {
      'grants': [
        {'permissionSlug': 'vehicles.view', 'scope': 'OWN'},
      ],
    },
  ];
  @override
  Future<Map<String, dynamic>> userPermissions(String id) async => {
    'catalogVersion': 1,
    'features': {
      for (final key in [
        'dashboard',
        'maps',
        'landmarks',
        'shareTrackLink',
        'routeOptimization',
        'support',
        'transactions',
        'notifications',
        'vehicles',
        'accounts',
        'reports',
        'workflow',
      ])
        key: true,
    },
    'reports': {
      for (final key in [
        'distance',
        'driven',
        'overspeed',
        'geofence',
        'sensor',
        'alerts',
        'logs',
        'timeline',
        'details',
      ])
        key: true,
    },
  };
  @override
  Future<Map<String, dynamic>> vehicleService(String id) async => {
    'adminCredits': 3,
    'vehicle': {
      'serviceRevision': 2,
      'planId': 1,
      'service': {
        'registrationAt': '2026-01-01T00:00:00Z',
        'primaryExpiry': '2027-01-01T00:00:00Z',
        'secondaryExpiry': '2026-12-01T00:00:00Z',
        'annualStatus': 'ACTIVE',
        'liveAllowed': true,
      },
    },
    'plans': [
      {'id': 1, 'name': 'Standard', 'durationDays': 90},
    ],
    'events': [],
  };
  @override
  Future<Map<String, dynamic>> renewalRequests({int? cursor}) async => {
    'items': [
      {
        'id': 10,
        'currency': 'USD',
        'amount': '25.00',
        'status': 'PENDING',
        'fromUser': {'name': 'Alice'},
        'meta': {
          'expiresAt': '2099-01-01T00:00:00Z',
          'lines': [
            {'name': 'Truck A', 'planName': 'Standard', 'durationDays': 90},
          ],
        },
      },
    ],
    'hasMore': false,
  };
}

Future<void> _pump(WidgetTester tester, Widget sheet) async {
  tester.view.physicalSize = const Size(360, 780);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        adminParityControllerProvider.overrideWithValue(_Controller()),
      ],
      child: MaterialApp(home: Scaffold(body: sheet)),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets(
    'team matrix renders own scope on a mobile width without overflow',
    (tester) async {
      await _pump(tester, const AdminTeamPermissionsSheet(memberId: '5'));
      expect(find.text('Vehicles'), findsOneWidget);
      expect(find.text('Save permissions'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'user permission editor excludes web-only workflow from controls',
    (tester) async {
      await _pump(tester, const AdminUserPermissionsSheet(userId: '5'));
      expect(find.text('Dashboard'), findsOneWidget);
      expect(find.text('Workflow'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'service sheet keeps annual and customer expiry separately visible',
    (tester) async {
      await _pump(tester, const AdminVehicleServiceSheet(vehicleId: '5'));
      expect(find.textContaining('Annual coverage:'), findsOneWidget);
      expect(find.textContaining('Customer service:'), findsOneWidget);
      expect(find.text('Live tracking active'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'request settlement starts disabled until receipt and reference acknowledged',
    (tester) async {
      await _pump(tester, const AdminRenewalRequestsSheet());
      await tester.tap(find.text('Confirm payment'));
      await tester.pumpAndSettle();
      final confirm = find.widgetWithText(FilledButton, 'Confirm');
      expect(tester.widget<FilledButton>(confirm).onPressed, isNull);
      await tester.tap(find.byType(CheckboxListTile));
      await tester.pump();
      expect(tester.widget<FilledButton>(confirm).onPressed, isNull);
      await tester.enterText(find.byType(TextField), 'BANK-REF-42');
      await tester.pump();
      expect(tester.widget<FilledButton>(confirm).onPressed, isNotNull);
      expect(tester.takeException(), isNull);
    },
  );
}
