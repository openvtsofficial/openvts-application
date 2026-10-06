import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/access/mobile_access.dart';
import 'package:open_vts/core/api/api_client.dart';
import 'package:open_vts/core/api/api_exception.dart';
import 'package:open_vts/core/providers/core_providers.dart';
import 'package:open_vts/core/utils/date_time_formatter.dart';
import 'package:open_vts/features/admin/controllers/admin_team_details_controller.dart';
import 'package:open_vts/features/admin/models/admin_team_model.dart';
import 'package:open_vts/features/admin/screens/team/widgets/admin_team_card.dart';
import 'package:open_vts/features/admin/screens/team/widgets/admin_team_permissions_sheet.dart';
import 'package:open_vts/features/admin/services/admin_team_details_service.dart';
import 'package:open_vts/features/auth/controllers/auth_controller.dart';
import 'package:open_vts/features/auth/controllers/auth_state.dart';
import 'package:open_vts/features/auth/models/current_user.dart';
import 'package:open_vts/features/user/controllers/user_providers.dart';
import 'package:open_vts/features/user/controllers/user_subuser_permissions_controller.dart';
import 'package:open_vts/features/user/models/user_subuser_model.dart';
import 'package:open_vts/features/user/models/user_subuser_permissions.dart';
import 'package:open_vts/features/user/screens/accounts/subusers/user_subuser_details_screen.dart';
import 'package:open_vts/features/user/screens/accounts/subusers/widgets/user_subuser_permissions_tab.dart';
import 'package:open_vts/features/user/services/user_subuser_service.dart';
import 'package:open_vts/l10n/app_localizations.dart';
import 'package:open_vts/shared/models/user_role.dart';
import 'package:open_vts/shared/widgets/open_vts_searchable_dropdown.dart';

Map<String, dynamic> _subPermissions({
  bool dashboard = true,
  List<String> disabled = const [],
}) => {
  'availableFeatures': {
    for (final key in MobileAccess.userFeatures)
      key: key == 'dashboard' ? dashboard : true,
  },
  'availableReports': {for (final key in MobileAccess.userReports) key: true},
  'disabledFeatures': disabled,
  'disabledReports': <String>[],
};

final _catalog = {
  'features': [
    {
      'key': 'vehicles',
      'label': 'Vehicles',
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
    {
      'key': 'notify',
      'label': 'Notify',
      'actions': [
        {
          'action': 'view',
          'permissionSlug': 'notify.view',
          'allowedScopes': ['OWN', 'TENANT'],
        },
      ],
    },
  ],
};
AdminTeamPermissionSnapshot _teamPermissions() =>
    AdminTeamPermissionSnapshot.fromJson(_catalog, {
      'member': {'id': '7'},
      'grants': [
        {'permissionSlug': 'notify.view', 'scope': 'OWN'},
      ],
    }, '7');

class _SubService extends UserSubUserService {
  _SubService() : super(ApiClient(Dio()));
  Future<Map<String, dynamic>> Function()? read;
  Completer<Map<String, dynamic>>? pendingSave;
  int reads = 0, writes = 0;
  List<String>? savedFeatures, savedReports;
  @override
  Future<Map<String, dynamic>> fetchPermissions(String id) {
    reads++;
    return read?.call() ??
        Future.value(_subPermissions(disabled: ['workflow']));
  }

  @override
  Future<Map<String, dynamic>> replacePermissions(
    String id, {
    required List<String> disabledFeatures,
    required List<String> disabledReports,
  }) async {
    writes++;
    savedFeatures = disabledFeatures;
    savedReports = disabledReports;
    return pendingSave?.future ??
        Future.value({
          ..._subPermissions(),
          'disabledFeatures': disabledFeatures,
          'disabledReports': disabledReports,
        });
  }
}

class _TeamService extends AdminTeamDetailsService {
  _TeamService() : super(ApiClient(Dio()));
  Future<AdminTeamPermissionSnapshot> Function()? read;
  Completer<void>? pendingSave;
  int reads = 0, writes = 0;
  List<Map<String, String>>? grants;
  @override
  Future<AdminTeamPermissionSnapshot> permissions(String id) {
    reads++;
    return read?.call() ?? Future.value(_teamPermissions());
  }

  @override
  Future<void> savePermissions(
    String id,
    List<Map<String, String>> grants,
  ) async {
    writes++;
    this.grants = grants;
    await pendingSave?.future;
  }

  @override
  Future<AdminTeamListItem> profile(String id) async =>
      AdminTeamListItem.fromJson({
        'uid': id,
        'name': 'Member Seven',
        'username': 'member7',
        'email': 'member@example.com',
        'isActive': true,
      });
  @override
  Future<AdminTeamActivityPage> activity(String id, {int? cursor}) async =>
      const AdminTeamActivityPage(items: [], hasMore: false);
}

class _Auth extends StateNotifier<AuthState> implements AuthController {
  _Auth(UserRole role)
    : super(
        AuthState.authenticated(
          CurrentUser(
            id: '11',
            name: 'Manager',
            email: '',
            role: role,
            access: const MobileAccess(
              loaded: true,
              features: {'accounts': true},
            ),
          ),
        ),
      );
  void account(String id, {bool accounts = true}) =>
      state = AuthState.authenticated(
        CurrentUser(
          id: id,
          name: 'Manager',
          email: '',
          role: UserRole.user,
          access: MobileAccess(loaded: true, features: {'accounts': accounts}),
        ),
      );
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Widget _app(Widget child, List<Override> overrides) => ProviderScope(
  overrides: [
    appDateFormatterProvider.overrideWithValue(
      const AppDateFormatter(
        datePattern: 'yyyy-MM-dd',
        use24Hour: true,
        timezone: 'UTC',
      ),
    ),
    ...overrides,
  ],
  child: MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: SingleChildScrollView(child: child)),
  ),
);

void main() {
  test(
    'Subuser parser distinguishes parent restrictions and direct denies',
    () {
      final data = UserSubUserPermissions.fromJson({
        'data': _subPermissions(dashboard: false, disabled: ['workflow']),
      });
      expect(data.availableFeatures['dashboard'], false);
      expect(data.disabledFeatures, {'workflow'});
      expect(
        () => data.availableFeatures['dashboard'] = true,
        throwsUnsupportedError,
      );
    },
  );
  test('Malformed or incomplete inherited permissions fail closed', () {
    expect(() => UserSubUserPermissions.fromJson({}), throwsFormatException);
    final raw = _subPermissions();
    (raw['availableReports'] as Map).remove('details');
    expect(() => UserSubUserPermissions.fromJson(raw), throwsFormatException);
    expect(
      () => UserSubUserPermissions.fromJson({
        ..._subPermissions(),
        'disabledFeatures': ['unknown'],
      }),
      throwsFormatException,
    );
  });
  test(
    'Subuser save preserves web-only workflow and rejects duplicate writes',
    () async {
      final service = _SubService()..pendingSave = Completer();
      final controller = UserSubUserPermissionsController(service, '7');
      addTearDown(controller.dispose);
      await controller.load();
      final first = controller.save(
        disabledFeatures: ['maps'],
        disabledReports: ['distance'],
      );
      expect(
        await controller.save(disabledFeatures: [], disabledReports: []),
        false,
      );
      expect(service.writes, 1);
      expect(service.savedFeatures, ['maps', 'workflow']);
      service.pendingSave!.complete({
        ..._subPermissions(),
        'disabledFeatures': ['maps', 'workflow'],
        'disabledReports': ['distance'],
      });
      expect(await first, true);
    },
  );
  test('Invalid loads prevent permission writes', () async {
    final service = _SubService()..read = () async => {};
    final controller = UserSubUserPermissionsController(service, '7');
    addTearDown(controller.dispose);
    await controller.load();
    expect(controller.state.hasError, true);
    expect(
      await controller.save(disabledFeatures: [], disabledReports: []),
      false,
    );
    expect(service.writes, 0);
  });
  test('Subuser authorization is checked again when saving', () async {
    var authorized = true;
    final service = _SubService();
    final controller = UserSubUserPermissionsController(
      service,
      '7',
      canManage: () => authorized,
    );
    addTearDown(controller.dispose);
    await controller.load();
    authorized = false;
    await expectLater(
      controller.save(disabledFeatures: [], disabledReports: []),
      throwsA(isA<ApiException>()),
    );
    expect(service.writes, 0);
  });
  test('Older Subuser response cannot overwrite a newer refresh', () async {
    final first = Completer<Map<String, dynamic>>();
    final second = Completer<Map<String, dynamic>>();
    final service = _SubService();
    var count = 0;
    service.read = () => count++ == 0 ? first.future : second.future;
    final controller = UserSubUserPermissionsController(service, '7');
    addTearDown(controller.dispose);
    final old = controller.load();
    final newest = controller.load();
    second.complete(_subPermissions(disabled: ['maps']));
    await newest;
    first.complete(_subPermissions(disabled: ['vehicles']));
    await old;
    expect(controller.state.requireValue.disabledFeatures, {'maps'});
  });
  test(
    'Subuser account change disposes stale in-flight results and denies revoked access',
    () async {
      final auth = _Auth(UserRole.user), service = _SubService();
      final pending = Completer<Map<String, dynamic>>();
      service.read = () => pending.future;
      final container = ProviderContainer(
        overrides: [
          authControllerProvider.overrideWith((_) => auth),
          userSubUsersServiceProvider.overrideWithValue(service),
        ],
      );
      addTearDown(container.dispose);
      final provider = userSubUserPermissionsControllerProvider('7');
      final subscription = container.listen(provider, (_, __) {});
      addTearDown(subscription.close);
      final original = container.read(provider.notifier);
      auth.account('22', accounts: false);
      await Future<void>.delayed(Duration.zero);
      final current = container.read(provider.notifier);
      expect(identical(current, original), false);
      pending.complete(_subPermissions());
      await Future<void>.delayed(Duration.zero);
      expect(container.read(provider).hasError, true);
      expect(service.reads, 1);
      await expectLater(
        original.save(disabledFeatures: [], disabledReports: []),
        throwsA(isA<ApiException>()),
      );
      expect(service.writes, 0);
    },
  );
  test('Team permission response verifies target member and valid catalog', () {
    expect(
      () => AdminTeamPermissionSnapshot.fromJson(_catalog, {
        'member': {'id': 'wrong'},
        'grants': [],
      }, '7'),
      throwsFormatException,
    );
    expect(
      () => AdminTeamPermissionSnapshot.fromJson(
        {'features': []},
        {
          'member': {'id': '7'},
          'grants': [],
        },
        '7',
      ),
      throwsFormatException,
    );
    expect(_teamPermissions().grants, {'notify.view': 'OWN'});
  });
  test(
    'Team save retains web-only grants, legal dependencies and suppresses duplicates',
    () async {
      final service = _TeamService()..pendingSave = Completer();
      final controller = AdminTeamPermissionsController(service, '7');
      addTearDown(controller.dispose);
      await controller.load();
      final selected = {
        'notify.view': 'OWN',
        'vehicles.view': 'OWN',
        'vehicles.update': 'TENANT',
      };
      final first = controller.save(selected);
      expect(await controller.save({}), false);
      expect(service.writes, 1);
      expect(service.grants, [
        {'permissionSlug': 'notify.view', 'scope': 'OWN'},
        {'permissionSlug': 'vehicles.view', 'scope': 'OWN'},
      ]);
      service.pendingSave!.complete();
      expect(await first, true);
      expect(service.reads, 2);
    },
  );
  test(
    'Disposed Team controller does not apply or re-read save results',
    () async {
      final service = _TeamService()..pendingSave = Completer();
      final controller = AdminTeamPermissionsController(service, '7');
      await controller.load();
      final result = controller.save({'vehicles.view': 'OWN'});
      controller.dispose();
      service.pendingSave!.complete();
      expect(await result, false);
      expect(service.reads, 1);
    },
  );
  testWidgets(
    'Subuser restricted switches are disabled and report master uses common controls',
    (tester) async {
      final service = _SubService()
        ..read = () async => _subPermissions(dashboard: false);
      await tester.pumpWidget(
        _app(const UserSubUserPermissionsTab(subUserId: '7'), [
          userSubUserPermissionsControllerProvider.overrideWith(
            (ref, id) => UserSubUserPermissionsController(service, id)..load(),
          ),
        ]),
      );
      await tester.pumpAndSettle();
      final dashboard = tester.widget<SwitchListTile>(
        find.ancestor(
          of: find.text('Dashboard'),
          matching: find.byType(SwitchListTile),
        ),
      );
      expect(dashboard.value, false);
      expect(dashboard.onChanged, isNull);
      expect(find.text('Reports'), findsOneWidget);
      expect(find.text('Workflow'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets('Team row opens Profile, Permissions and Activity Logs details', (
    tester,
  ) async {
    final auth = _Auth(UserRole.admin), service = _TeamService();
    await tester.pumpWidget(
      _app(AdminTeamCard(team: await service.profile('7')), [
        authControllerProvider.overrideWith((_) => auth),
        adminTeamDetailsServiceProvider.overrideWithValue(service),
      ]),
    );
    await tester.tap(find.text('Member Seven'));
    await tester.pumpAndSettle();
    expect(find.text('Profile'), findsOneWidget);
    expect(find.text('Permissions'), findsOneWidget);
    expect(find.text('Activity Logs'), findsOneWidget);
    expect(find.text('member@example.com'), findsOneWidget);
    await tester.tap(find.text('Permissions'));
    await tester.pumpAndSettle();
    expect(find.text('Save permissions'), findsOneWidget);
    expect(find.text('Notify'), findsNothing);
    await tester.tap(find.text('Activity Logs'));
    await tester.pumpAndSettle();
    expect(find.text('No team activity found.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  test(
    'Team service follows current scoped detail, catalog, grants and cursor APIs',
    () async {
      final requests = <RequestOptions>[];
      final dio = Dio()
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) {
              requests.add(options);
              dynamic data;
              if (options.path.endsWith('/catalog')) {
                data = _catalog;
              } else if (options.path.endsWith('/activitylogs')) {
                data = {'items': [], 'hasMore': false, 'nextCursorId': null};
              } else if (options.path.endsWith('/permissions')) {
                data = {
                  'member': {'id': 7},
                  'grants': [],
                };
              } else {
                data = {'uid': 7, 'name': 'Team Seven'};
              }
              handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 200,
                  data: {'action': true, 'data': data},
                ),
              );
            },
          ),
        );
      addTearDown(dio.close);
      final service = AdminTeamDetailsService(ApiClient(dio));
      expect((await service.profile('7')).teamName, 'Team Seven');
      expect((await service.permissions('7')).features.length, 2);
      await service.savePermissions('7', [
        {'permissionSlug': 'vehicles.view', 'scope': 'OWN'},
      ]);
      await service.activity('7', cursor: 19);
      expect(requests.map((r) => '${r.method} ${r.path}'), [
        'GET /admin/teams/7',
        'GET /admin/team-permissions/catalog',
        'GET /admin/teams/7/permissions',
        'PUT /admin/teams/7/permissions',
        'GET /admin/teams/7/activitylogs',
      ]);
      expect(requests[3].data, {
        'grants': [
          {'permissionSlug': 'vehicles.view', 'scope': 'OWN'},
        ],
      });
      expect(requests.last.queryParameters, {'limit': 30, 'cursorId': 19});
    },
  );
  testWidgets(
    'Team permissions use scalable shared pickers on a narrow RTL phone',
    (tester) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final service = _TeamService();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            adminTeamPermissionsControllerProvider.overrideWith(
              (ref, id) => AdminTeamPermissionsController(service, id)..load(),
            ),
          ],
          child: MaterialApp(
            locale: const Locale('ar'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: const TextScaler.linear(2)),
              child: child!,
            ),
            home: const Scaffold(
              body: AdminTeamPermissionsSheet(memberId: '7'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      final field = find.byKey(const ValueKey('vehicles.view'));
      await tester.scrollUntilVisible(
        field,
        150,
        scrollable: find.byType(Scrollable).first,
      );
      final picker = tester.widget<OpenVtsSearchableDropdown<String>>(field);
      final global = picker.options
          .singleWhere((option) => option.value == 'TENANT')
          .label;
      final trigger = find
          .descendant(of: field, matching: find.byType(InkWell))
          .first;
      await Scrollable.ensureVisible(tester.element(trigger), alignment: 0.1);
      await tester.pumpAndSettle();
      await tester.tap(trigger);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await tester.tap(find.text(global).last);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'Retained Subuser route hides old extras and verified data when the account changes',
    (tester) async {
      final auth = _Auth(UserRole.user);
      final first = Completer<Map<String, dynamic>>();
      final second = Completer<Map<String, dynamic>>();
      var detailReads = 0;
      final dio = Dio()
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) async {
              dynamic data = <dynamic>[];
              if (options.path == '/user/subusers/7') {
                detailReads++;
                data = await (detailReads == 1 ? first.future : second.future);
              }
              handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 200,
                  data: {'action': true, 'data': data},
                ),
              );
            },
          ),
        );
      addTearDown(dio.close);
      final stale = UserSubUser.fromJson({
        'uid': 7,
        'name': 'Unverified route profile',
      });
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authControllerProvider.overrideWith((_) => auth),
            apiClientProvider.overrideWithValue(ApiClient(dio)),
            appDateFormatterProvider.overrideWithValue(
              const AppDateFormatter(
                datePattern: 'yyyy-MM-dd',
                use24Hour: true,
                timezone: 'UTC',
              ),
            ),
          ],
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: UserSubUserDetailsScreen(
              subUserId: '7',
              initialSubUser: stale,
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.text('Unverified route profile'), findsNothing);
      first.complete({
        'uid': 7,
        'name': 'Verified first account profile',
        'username': 'first',
      });
      await tester.pumpAndSettle();
      expect(find.text('Verified first account profile'), findsWidgets);
      auth.account('22');
      await tester.pump();
      await tester.pump();
      expect(find.text('Verified first account profile'), findsNothing);
      expect(find.text('Unverified route profile'), findsNothing);
      second.complete({
        'uid': 7,
        'name': 'Verified second account profile',
        'username': 'second',
      });
      await tester.pumpAndSettle();
      expect(detailReads, 2);
      expect(find.text('Verified second account profile'), findsWidgets);
      expect(find.text('Verified first account profile'), findsNothing);
      expect(find.text('Unverified route profile'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );
}
