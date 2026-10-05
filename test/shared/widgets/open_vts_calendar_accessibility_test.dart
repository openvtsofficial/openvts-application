import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/utils/date_time_formatter.dart';
import 'package:open_vts/features/admin/controllers/admin_calendar_controller.dart';
import 'package:open_vts/features/admin/screens/calendar/admin_calendar_screen.dart';
import 'package:open_vts/features/auth/controllers/auth_controller.dart';
import 'package:open_vts/features/auth/controllers/auth_state.dart';
import 'package:open_vts/features/superadmin/controllers/superadmin_calendar_controller.dart';
import 'package:open_vts/features/superadmin/models/superadmin_calendar_model.dart';
import 'package:open_vts/features/superadmin/screens/calendar/superadmin_calendar_screen.dart';
import 'package:open_vts/features/user/models/user_vehicle_state.dart';
import 'package:open_vts/features/user/screens/vehicles/widgets/user_vehicle_status_segment.dart';
import 'package:open_vts/l10n/app_localizations.dart';
import 'package:open_vts/shared/widgets/open_vts_month_calendar.dart';
import 'package:table_calendar/table_calendar.dart';

class _TestAuth extends StateNotifier<AuthState> implements AuthController {
  _TestAuth() : super(const AuthState.initial());
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Future<void> _pump(
  WidgetTester tester,
  Widget child, {
  double scale = 1,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(320, 568);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(
          context,
        ).copyWith(textScaler: TextScaler.linear(scale)),
        child: child!,
      ),
      home: child,
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  for (final role in ['admin', 'superadmin']) {
    for (final scale in [1.0, 2.5]) {
      testWidgets(
        '$role month scrolls safely on small phones at ${scale}x text',
        (tester) async {
          final date = DateTime(2026, 10, 5);
          final event = CalendarEvent(
            date: '2026-10-05',
            usersCount: 2,
            vehiclesCount: 5,
            expiryCount: 3,
          );
          final container = ProviderContainer(
            overrides: [
              authControllerProvider.overrideWith((_) => _TestAuth()),
              appDateFormatterProvider.overrideWithValue(
                const AppDateFormatter(
                  datePattern: 'DD MMM YYYY',
                  use24Hour: true,
                ),
              ),
              if (role == 'admin') ...[
                adminCalendarFocusedDateProvider.overrideWith((ref) => date),
                adminCalendarSelectedDateProvider.overrideWith((ref) => date),
                adminCalendarEventsProvider.overrideWith((ref) => [event]),
              ] else ...[
                calendarFocusedDateProvider.overrideWith((ref) => date),
                calendarSelectedDateProvider.overrideWith((ref) => date),
                calendarEventsProvider.overrideWith((ref) => [event]),
              ],
            ],
          );
          addTearDown(container.dispose);
          await _pump(
            tester,
            UncontrolledProviderScope(
              container: container,
              child: role == 'admin'
                  ? const AdminCalendarScreen()
                  : const SuperadminCalendarScreen(),
            ),
            scale: scale,
          );
          if (scale == 1) {
            expect(
              find.byType(TableCalendar<OpenVtsCalendarMetric>),
              findsOneWidget,
            );
            await tester.scrollUntilVisible(
              find.text('Vehicles: 5'),
              160,
              scrollable: find.byType(Scrollable).first,
            );
            expect(find.text('Expiry: 3'), findsOneWidget);
          } else {
            expect(
              find.byType(TableCalendar<OpenVtsCalendarMetric>),
              findsNothing,
            );
            await tester.scrollUntilVisible(
              find.byKey(const ValueKey('calendar-day-31')),
              700,
              scrollable: find.byType(Scrollable).first,
            );
            expect(
              find.byKey(const ValueKey('calendar-day-31')),
              findsOneWidget,
            );
          }
          expect(tester.takeException(), isNull);
        },
      );
    }
  }

  testWidgets(
    'calendar previous/next month controls preserve role controller state',
    (tester) async {
      final container = ProviderContainer(
        overrides: [
          authControllerProvider.overrideWith((_) => _TestAuth()),
          appDateFormatterProvider.overrideWithValue(
            const AppDateFormatter(datePattern: 'DD MMM YYYY', use24Hour: true),
          ),
          adminCalendarFocusedDateProvider.overrideWith(
            (ref) => DateTime(2026, 10, 5),
          ),
          adminCalendarEventsProvider.overrideWith((ref) => []),
        ],
      );
      addTearDown(container.dispose);
      await _pump(
        tester,
        UncontrolledProviderScope(
          container: container,
          child: const AdminCalendarScreen(),
        ),
      );
      await tester.tap(find.byTooltip('Next month'));
      await tester.pumpAndSettle();
      expect(
        DateUtils.dateOnly(container.read(adminCalendarFocusedDateProvider)),
        DateTime(2026, 11),
      );
      await tester.tap(find.byTooltip('Previous month'));
      await tester.pumpAndSettle();
      expect(
        DateUtils.dateOnly(container.read(adminCalendarFocusedDateProvider)),
        DateTime(2026, 10),
      );
    },
  );

  testWidgets('vehicle status chips keep full touch height and large text', (
    tester,
  ) async {
    UserVehicleStatusFilter? selected;
    await _pump(
      tester,
      Scaffold(
        body: UserVehicleStatusSegment(
          current: UserVehicleStatusFilter.all,
          counts: const {UserVehicleStatusFilter.all: 999},
          onChanged: (value) => selected = value,
        ),
      ),
      scale: 3,
    );
    final chip = find.ancestor(
      of: find.text('All'),
      matching: find.byType(InkWell),
    );
    expect(tester.getSize(chip).height, greaterThanOrEqualTo(48));
    await tester.tap(find.text('All'));
    expect(selected, UserVehicleStatusFilter.all);
    await tester.drag(
      find.byType(SingleChildScrollView),
      const Offset(-600, 0),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
