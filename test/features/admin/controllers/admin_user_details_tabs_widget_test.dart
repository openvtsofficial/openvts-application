import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/access/mobile_access.dart';
import 'package:open_vts/core/api/api_client.dart';
import 'package:open_vts/core/providers/core_providers.dart';
import 'package:open_vts/features/admin/controllers/admin_providers.dart';
import 'package:open_vts/features/admin/models/admin_user_details_state.dart';
import 'package:open_vts/features/admin/models/admin_user_permissions.dart';
import 'package:open_vts/features/admin/models/admin_users_model.dart';
import 'package:open_vts/features/admin/screens/users/admin_user_details_screen.dart';
import 'package:open_vts/features/admin/screens/users/widgets/admin_user_data_backup_tab.dart';
import 'package:open_vts/features/admin/screens/users/widgets/admin_user_permissions_sheet.dart';
import 'package:open_vts/features/admin/services/admin_user_details_service.dart';
import 'package:open_vts/features/auth/controllers/auth_controller.dart';
import 'package:open_vts/features/auth/controllers/auth_state.dart';
import 'package:open_vts/features/auth/models/current_user.dart';
import 'package:open_vts/l10n/app_localizations.dart';
import 'package:open_vts/shared/models/user_role.dart';
import 'package:open_vts/shared/widgets/open_vts_detail_tab_strip.dart';
import 'package:open_vts/shared/widgets/open_vts_searchable_dropdown.dart';

class _Auth extends StateNotifier<AuthState> implements AuthController {
  _Auth(UserRole role)
    : super(
        AuthState.authenticated(
          CurrentUser(
            id: '11',
            name: 'Operator',
            email: '',
            role: role,
            access: const MobileAccess.account(),
          ),
        ),
      );
  void switchAccount(String id) =>
      state = AuthState.authenticated(state.user!.copyWith(id: id));
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  testWidgets(
    'retained Admin user detail hides route extras after scope change and retains valid current-account data',
    (tester) async {
      dotenv.testLoad(fileInput: 'USE_MOCK_DATA=false');
      final auth = _Auth(UserRole.admin);
      final switchedProfile = Completer<void>();
      bool failCurrentRefresh = false;
      final dio = Dio()
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) async {
              final principal = auth.state.user!.id;
              if (options.path.endsWith('/users/42')) {
                if (principal == '22') await switchedProfile.future;
                if (principal == '22' || failCurrentRefresh) {
                  handler.reject(
                    DioException(
                      requestOptions: options,
                      type: DioExceptionType.badResponse,
                      response: Response(
                        requestOptions: options,
                        statusCode: principal == '22' ? 403 : 503,
                      ),
                    ),
                  );
                  return;
                }
                handler.resolve(
                  Response(
                    requestOptions: options,
                    statusCode: 200,
                    data: {
                      'action': true,
                      'data': {'id': '42', 'name': 'Verified current customer'},
                    },
                  ),
                );
                return;
              }
              handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 200,
                  data: {'action': true, 'data': []},
                ),
              );
            },
          ),
        );
      final api = ApiClient(dio, activeUser: () => auth.state.user);
      final container = ProviderContainer(
        overrides: [
          authControllerProvider.overrideWith((_) => auth),
          apiClientProvider.overrideWithValue(api),
          adminUserDetailsServiceProvider.overrideWithValue(
            AdminUserDetailsService(api),
          ),
        ],
      );
      addTearDown(container.dispose);
      addTearDown(() => dio.close(force: true));
      final initial = AdminUserListItem.fromJson({
        'id': '42',
        'name': 'Stale route customer',
        'email': 'stale@example.test',
        'companyName': 'Stale route company',
      });
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: AdminUserDetailsScreen(userId: '42', initialUser: initial),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Verified current customer'), findsWidgets);
      expect(find.text('Stale route customer'), findsNothing);
      // A transient refresh failure on the same authenticated scope retains the
      // already verified fetched profile, rather than replacing it with extras.
      failCurrentRefresh = true;
      final refresh = container
          .read(adminUserDetailsControllerProvider('42').notifier)
          .loadProfile();
      await tester.pumpAndSettle();
      await refresh;
      expect(find.text('Verified current customer'), findsWidgets);
      expect(find.text('Stale route customer'), findsNothing);
      auth.switchAccount('22');
      await tester.pump();
      await tester.pump();
      expect(find.text('Verified current customer'), findsNothing);
      expect(find.text('Stale route customer'), findsNothing);
      expect(find.text('Stale route company'), findsNothing);
      switchedProfile.complete();
      await tester.pumpAndSettle();
      expect(find.text('Verified current customer'), findsNothing);
      expect(find.text('Stale route customer'), findsNothing);
      expect(find.text('stale@example.test'), findsNothing);
      expect(find.text('Stale route company'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'single User has reachable Permissions and Data Backup tabs with loaded controls',
    (tester) async {
      dotenv.testLoad(fileInput: 'USE_MOCK_DATA=false');
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final auth = _Auth(UserRole.admin);
      final dio = Dio()
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) {
              Object data = [];
              if (options.path.endsWith('/users/42')) {
                data = {'id': '42', 'name': 'Customer'};
              }
              if (options.path.endsWith('/permissions')) {
                data = {
                  'catalogVersion': 1,
                  'features': {
                    for (final key in AdminUserPermissions.featureKeys)
                      key: true,
                  },
                  'reports': {
                    for (final key in AdminUserPermissions.reportKeys)
                      key: true,
                  },
                };
              }
              if (options.path.endsWith('/data-retention')) {
                data = {
                  'globalRetentionDays': 180,
                  'parentRetentionDays': 90,
                  'configuredRetentionDays': null,
                  'effectiveRetentionDays': 90,
                  'maxAllowedDays': 90,
                  'source': 'ADMIN',
                  'isCapped': false,
                };
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
      final client = ApiClient(dio, activeUser: () => auth.state.user);
      addTearDown(() => dio.close(force: true));
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authControllerProvider.overrideWith((_) => auth),
            apiClientProvider.overrideWithValue(client),
            adminUserDetailsServiceProvider.overrideWithValue(
              AdminUserDetailsService(client),
            ),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: AdminUserDetailsScreen(userId: '42'),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final tabs = tester.widget<OpenVtsDetailTabStrip>(
        find
            .byWidgetPredicate(
              (widget) => widget is OpenVtsDetailTabStrip<AdminUserDetailsTab>,
            )
            .first,
      );
      final labels = tabs.tabs.map((tab) => tab.label);
      expect(labels, containsAll(['Permissions', 'Data Backup']));
      final horizontalPicker = find.descendant(
        of: find.byWidgetPredicate(
          (widget) => widget is OpenVtsDetailTabStrip<AdminUserDetailsTab>,
        ),
        matching: find.byType(Scrollable),
      );
      await tester.drag(horizontalPicker, const Offset(-2000, 0));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Permissions'));
      await tester.pumpAndSettle();
      expect(find.byType(AdminUserPermissionsTab), findsOneWidget);
      expect(find.byType(SwitchListTile), findsWidgets);
      await tester.drag(horizontalPicker, const Offset(-2000, 0));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Data Backup'));
      await tester.pumpAndSettle();
      expect(find.byType(AdminUserDataBackupTab), findsOneWidget);
      expect(find.byType(OpenVtsSearchableDropdown<String>), findsOneWidget);
      expect(find.text('90 days'), findsWidgets);
      expect(tester.takeException(), isNull);
    },
  );
}
