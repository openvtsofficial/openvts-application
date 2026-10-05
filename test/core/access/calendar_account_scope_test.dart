import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/access/mobile_access.dart';
import 'package:open_vts/core/api/api_client.dart';
import 'package:open_vts/core/providers/core_providers.dart';
import 'package:open_vts/core/utils/date_time_formatter.dart';
import 'package:open_vts/features/admin/controllers/admin_calendar_controller.dart';
import 'package:open_vts/features/admin/screens/calendar/admin_calendar_screen.dart';
import 'package:open_vts/features/auth/controllers/auth_controller.dart';
import 'package:open_vts/features/auth/controllers/auth_state.dart';
import 'package:open_vts/features/auth/models/current_user.dart';
import 'package:open_vts/features/superadmin/controllers/superadmin_calendar_controller.dart';
import 'package:open_vts/features/superadmin/screens/calendar/superadmin_calendar_screen.dart';
import 'package:open_vts/l10n/app_localizations.dart';
import 'package:open_vts/shared/models/user_role.dart';
import 'package:open_vts/shared/widgets/open_vts_month_calendar.dart';

class _SwitchableAuth extends StateNotifier<AuthState>
    implements AuthController {
  _SwitchableAuth(UserRole role)
    : super(
        AuthState.authenticated(
          CurrentUser(
            id: '11',
            name: 'First account',
            email: '',
            role: role,
            access: const MobileAccess(
              loaded: true,
              grants: {'calendar.view': 'TENANT'},
              navigation: {'calendar'},
            ),
          ),
        ),
      );
  void setAccount(CurrentUser user) => state = AuthState.authenticated(user);
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  for (final role in [UserRole.admin, UserRole.team, UserRole.superadmin]) {
    test(
      '${role.name} calendar cache changes with account/access, not equal refreshes',
      () async {
        final auth = _SwitchableAuth(role);
        var requests = 0;
        final dio = Dio()
          ..interceptors.add(
            InterceptorsWrapper(
              onRequest: (options, handler) {
                requests++;
                handler.resolve(
                  Response(
                    requestOptions: options,
                    statusCode: 200,
                    data: [
                      {
                        'date': '2026-10-05',
                        'usersCount': int.parse(auth.state.user!.id),
                      },
                    ],
                  ),
                );
              },
            ),
          );
        final container = ProviderContainer(
          overrides: [
            authControllerProvider.overrideWith((_) => auth),
            apiClientProvider.overrideWithValue(ApiClient(dio)),
          ],
        );
        addTearDown(container.dispose);
        addTearDown(dio.close);
        final provider = role == UserRole.superadmin
            ? calendarEventsProvider
            : adminCalendarEventsProvider;
        final subscription = container.listen(provider, (_, __) {});
        addTearDown(subscription.close);
        expect((await container.read(provider.future)).single.usersCount, 11);
        expect(requests, 1);

        auth.setAccount(
          auth.state.user!.copyWith(
            name: 'Updated display name',
            access: const MobileAccess(
              loaded: true,
              grants: {'calendar.view': 'TENANT'},
              navigation: {'calendar'},
              version: 99,
            ),
          ),
        );
        await container.pump();
        expect((await container.read(provider.future)).single.usersCount, 11);
        expect(
          requests,
          1,
          reason:
              'Identical effective permissions must not invalidate cached calendar data every poll.',
        );

        auth.setAccount(auth.state.user!.copyWith(id: '22'));
        await container.pump();
        expect((await container.read(provider.future)).single.usersCount, 22);
        expect(requests, 2);

        auth.setAccount(
          auth.state.user!.copyWith(
            access: const MobileAccess(
              loaded: true,
              grants: {'calendar.view': 'OWN'},
              navigation: {'calendar'},
            ),
          ),
        );
        await container.pump();
        await container.read(provider.future);
        expect(
          requests,
          3,
          reason:
              'A narrower grant must invalidate data even for the same principal.',
        );
      },
    );
  }

  for (final role in [UserRole.admin, UserRole.superadmin]) {
    testWidgets(
      '${role.name} calendar hides prior account counts while new account loads',
      (tester) async {
        final auth = _SwitchableAuth(role);
        final pending = Completer<void>();
        final dio = Dio()
          ..interceptors.add(
            InterceptorsWrapper(
              onRequest: (options, handler) async {
                final account = auth.state.user!.id;
                if (account == '22') await pending.future;
                handler.resolve(
                  Response(
                    requestOptions: options,
                    statusCode: 200,
                    data: [
                      {'date': '2026-10-05', 'usersCount': int.parse(account)},
                    ],
                  ),
                );
              },
            ),
          );
        final container = ProviderContainer(
          overrides: [
            authControllerProvider.overrideWith((_) => auth),
            apiClientProvider.overrideWithValue(ApiClient(dio)),
            appDateFormatterProvider.overrideWithValue(
              const AppDateFormatter(
                datePattern: 'DD MMM YYYY',
                use24Hour: true,
              ),
            ),
            if (role == UserRole.admin)
              adminCalendarFocusedDateProvider.overrideWith(
                (_) => DateTime(2026, 10, 5),
              ),
            if (role == UserRole.superadmin)
              calendarFocusedDateProvider.overrideWith(
                (_) => DateTime(2026, 10, 5),
              ),
          ],
        );
        addTearDown(container.dispose);
        addTearDown(dio.close);
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: role == UserRole.admin
                  ? const AdminCalendarScreen()
                  : const SuperadminCalendarScreen(),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(
          tester
              .widget<OpenVtsMonthCalendar>(find.byType(OpenVtsMonthCalendar))
              .metricsByDay['2026-10-05']!
              .single
              .count,
          11,
        );
        auth.setAccount(auth.state.user!.copyWith(id: '22'));
        await tester.pump();
        await tester.pump();
        final loading = tester.widget<OpenVtsMonthCalendar>(
          find.byType(OpenVtsMonthCalendar),
        );
        expect(loading.loading, isTrue);
        expect(
          loading.metricsByDay,
          isEmpty,
          reason:
              'Riverpod retains previous AsyncData during reload; it must not be rendered across account boundaries.',
        );
        pending.complete();
        await tester.pumpAndSettle();
        expect(
          tester
              .widget<OpenVtsMonthCalendar>(find.byType(OpenVtsMonthCalendar))
              .metricsByDay['2026-10-05']!
              .single
              .count,
          22,
        );
        expect(tester.takeException(), isNull);
      },
    );
  }
}
