import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/access/mobile_access.dart';
import 'package:open_vts/core/api/api_client.dart';
import 'package:open_vts/core/providers/core_providers.dart';
import 'package:open_vts/features/admin/controllers/admin_parity_controller.dart';
import 'package:open_vts/features/admin/models/admin_user_permissions.dart';
import 'package:open_vts/features/admin/screens/payments/widgets/admin_renewal_requests_sheet.dart';
import 'package:open_vts/features/admin/screens/team/widgets/admin_team_permissions_sheet.dart';
import 'package:open_vts/features/admin/screens/users/widgets/admin_user_permissions_sheet.dart';
import 'package:open_vts/features/admin/screens/vehicles/widgets/admin_vehicle_service_sheet.dart';
import 'package:open_vts/features/auth/controllers/auth_controller.dart';
import 'package:open_vts/features/auth/controllers/auth_state.dart';
import 'package:open_vts/features/auth/models/current_user.dart';
import 'package:open_vts/l10n/app_localizations.dart';
import 'package:open_vts/shared/models/user_role.dart';
import 'package:open_vts/shared/widgets/open_vts_button.dart';
import 'package:open_vts/shared/widgets/open_vts_searchable_dropdown.dart';

class _Controller extends AdminParityController {
  _Controller() : super(ApiClient(Dio()));
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

class _Auth extends StateNotifier<AuthState> implements AuthController {
  _Auth()
    : super(
        const AuthState.authenticated(
          CurrentUser(
            id: '11',
            name: 'Administrator',
            email: '',
            role: UserRole.admin,
            access: MobileAccess.account(),
          ),
        ),
      );
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// Permission tests use the scoped current controllers/services and complete
/// backend-shaped envelopes; vehicle service/settlement keep their own fixture.
class _PermissionTransport {
  final requests = <RequestOptions>[];
  Map<String, bool> features = {
    for (final key in AdminUserPermissions.featureKeys) key: key != 'workflow',
  };
  Map<String, bool> reports = {
    for (final key in AdminUserPermissions.reportKeys) key: true,
  };
  void respond(RequestOptions options, RequestInterceptorHandler handler) {
    requests.add(options);
    dynamic data;
    switch (options.path) {
      case '/admin/team-permissions/catalog':
        data = {
          'features': [
            {
              'key': 'vehicles',
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
        };
      case '/admin/teams/5/permissions':
        data = {
          'member': {'id': 5},
          'grants': [
            {'permissionSlug': 'vehicles.view', 'scope': 'OWN'},
          ],
        };
      case '/admin/users/5/permissions':
        if (options.method == 'PUT') {
          final body = Map<String, dynamic>.from(options.data as Map);
          final disabledFeatures = (body['disabledFeatures'] as List)
              .cast<String>();
          final disabledReports = (body['disabledReports'] as List)
              .cast<String>();
          features = {
            for (final key in AdminUserPermissions.featureKeys)
              key: !disabledFeatures.contains(key),
          };
          reports = {
            for (final key in AdminUserPermissions.reportKeys)
              key: !disabledReports.contains(key),
          };
        }
        data = {'catalogVersion': 1, 'features': features, 'reports': reports};
      default:
        handler.reject(
          DioException(
            requestOptions: options,
            message: 'Unexpected permission fixture API: ${options.path}',
          ),
        );
        return;
    }
    handler.resolve(
      Response(
        requestOptions: options,
        statusCode: 200,
        data: {'action': true, 'data': data},
      ),
    );
  }
}

Future<_PermissionTransport> _pump(WidgetTester tester, Widget sheet) async {
  tester.view.physicalSize = const Size(360, 780);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  final auth = _Auth();
  final transport = _PermissionTransport();
  final dio = Dio()
    ..interceptors.add(InterceptorsWrapper(onRequest: transport.respond));
  addTearDown(dio.close);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        adminParityControllerProvider.overrideWithValue(_Controller()),
        authControllerProvider.overrideWith((_) => auth),
        apiClientProvider.overrideWithValue(
          ApiClient(dio, activeUser: () => auth.state.user),
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: sheet),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return transport;
}

void main() {
  testWidgets(
    'team matrix renders own scope on a mobile width without overflow',
    (tester) async {
      await _pump(tester, const AdminTeamPermissionsSheet(memberId: '5'));
      expect(find.text('Vehicles'), findsOneWidget);
      final field = tester.widget<OpenVtsSearchableDropdown<String>>(
        find.byKey(const ValueKey('vehicles.view')),
      );
      expect(field.value, 'OWN');
      expect(find.text('Own'), findsOneWidget);
      expect(find.text('Save permissions'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'user permission editor excludes web-only workflow from controls',
    (tester) async {
      final transport = await _pump(
        tester,
        const AdminUserPermissionsSheet(userId: '5'),
      );
      expect(find.text('Dashboard'), findsOneWidget);
      expect(find.text('Workflow'), findsNothing);
      final dashboard = find.ancestor(
        of: find.text('Dashboard'),
        matching: find.byType(SwitchListTile),
      );
      await tester.tap(dashboard);
      await tester.pump();
      final save = find.widgetWithText(OpenVtsButton, 'Save permissions');
      await tester.ensureVisible(save);
      await tester.tap(save);
      await tester.pumpAndSettle();
      final writes = transport.requests
          .where((r) => r.method == 'PUT')
          .toList();
      expect(writes, hasLength(1));
      expect(writes.single.path, '/admin/users/5/permissions');
      expect(writes.single.data, {
        'disabledFeatures': ['dashboard', 'workflow'],
        'disabledReports': <String>[],
      });
      expect(transport.features['workflow'], false);
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
