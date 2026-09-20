import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/utils/unit_formatter.dart';
import 'package:open_vts/features/user/controllers/user_providers.dart';
import 'package:open_vts/features/user/models/user_dashboard_model.dart';
import 'package:open_vts/features/user/screens/dashboard/widgets/user_dashboard_vehicle_selector.dart';
import 'package:open_vts/features/user/screens/dashboard/widgets/user_day_night_comparison_widget.dart';
import 'package:open_vts/shared/widgets/open_vts_searchable_dropdown.dart';

// ---------------------------------------------------------------------------
// Fixtures
// ---------------------------------------------------------------------------

const _v1 = UserDashboardVehicleOption(
  id: 'v1',
  name: 'Truck Alpha',
  plateNumber: 'KA01AA0001',
  imei: '100200300400500',
);

const _v2 = UserDashboardVehicleOption(
  id: 'v2',
  name: 'Sedan Beta',
  plateNumber: 'MH02BB0002',
  imei: '200300400500600',
);

// ---------------------------------------------------------------------------
// Helper
// ---------------------------------------------------------------------------

const _config = UserDashboardWidgetConfig(
  id: 'w1',
  type: 'day_night_comparison',
);

// The widget uses _resolvedRange() which adds end-of-day to `to`, so we
// need to match the provider args that the widget actually passes.
// The widget passes vehicleId: _selectedVehicleId (= 'all') directly.
// The `from`/`to` come from _resolvedRange() — since `_range` is
// initialized to today (start of day / end of day), we cannot predict the
// exact DateTime values at test time. To avoid brittle date matching we
// override the provider family loosely by catching any args through a
// provider that is set up to return our fixture data.
//
// We use overrideWith on the raw provider (not .family) to intercept all
// calls regardless of args.

Widget _pump() {
  return ProviderScope(
    overrides: [
      unitFormatterProvider.overrideWithValue(
        const UnitFormatter(units: 'KM'),
      ),
      userDashboardDayNightProvider.overrideWith((ref, args) => Future.value((
            vehicles: const [_v1, _v2],
            comparison: const UserDashboardDayNightComparison(
              timezoneOffsetMin: 0,
              filter: UserDashboardVehicleFilter(mode: 'ALL'),
              range: UserDashboardDateRange(),
              dayWindow: UserDashboardDayWindow(
                startHour: 6,
                endHour: 18,
                label: '06:00 - 18:00',
              ),
              points: [],
              totals: UserDashboardDayNightTotals(
                day: UserDashboardMetricPair(drivenKm: 0, engineHours: 0),
                night: UserDashboardMetricPair(drivenKm: 0, engineHours: 0),
                overall: UserDashboardMetricPair(drivenKm: 0, engineHours: 0),
              ),
              percentages: UserDashboardDayNightPercentages(
                dayDrivenKm: 0,
                nightDrivenKm: 0,
                dayEngineHours: 0,
                nightEngineHours: 0,
              ),
            ),
          ))),
    ],
    child: const MaterialApp(
      home: Scaffold(
        body: SizedBox(
          height: 700,
          child: UserDayNightComparisonWidget(config: _config, refreshTick: 0),
        ),
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('UserDayNightComparisonWidget — vehicle selector', () {
    testWidgets('renders UserDashboardVehicleSelector', (tester) async {
      await tester.pumpWidget(_pump());
      await tester.pumpAndSettle();
      expect(find.byType(UserDashboardVehicleSelector), findsOneWidget);
    });

    testWidgets('selector opens searchable sheet', (tester) async {
      await tester.pumpWidget(_pump());
      await tester.pumpAndSettle();

      await tester.tap(find.byType(OpenVtsSearchableDropdown<String>));
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsAtLeastNWidgets(1));
    });

    testWidgets('All Vehicles option is present', (tester) async {
      await tester.pumpWidget(_pump());
      await tester.pumpAndSettle();

      await tester.tap(find.byType(OpenVtsSearchableDropdown<String>));
      await tester.pumpAndSettle();

      // May appear twice: selected value display + list item when value == 'all'.
      expect(find.text('All Vehicles'), findsAtLeastNWidgets(1));
    });

    testWidgets('searches by vehicle name', (tester) async {
      await tester.pumpWidget(_pump());
      await tester.pumpAndSettle();

      await tester.tap(find.byType(OpenVtsSearchableDropdown<String>));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).last, 'Truck');
      await tester.pump();

      expect(find.text('Truck Alpha · KA01AA0001'), findsOneWidget);
      expect(find.text('Sedan Beta · MH02BB0002'), findsNothing);
    });

    testWidgets('searches by plate number', (tester) async {
      await tester.pumpWidget(_pump());
      await tester.pumpAndSettle();

      await tester.tap(find.byType(OpenVtsSearchableDropdown<String>));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).last, 'MH02BB');
      await tester.pump();

      expect(find.text('Sedan Beta · MH02BB0002'), findsOneWidget);
      expect(find.text('Truck Alpha · KA01AA0001'), findsNothing);
    });

    testWidgets('searches by IMEI', (tester) async {
      await tester.pumpWidget(_pump());
      await tester.pumpAndSettle();

      await tester.tap(find.byType(OpenVtsSearchableDropdown<String>));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).last, '100200300');
      await tester.pump();

      expect(find.text('Truck Alpha · KA01AA0001'), findsOneWidget);
      expect(find.text('Sedan Beta · MH02BB0002'), findsNothing);
    });

    testWidgets('searches by vehicle ID', (tester) async {
      await tester.pumpWidget(_pump());
      await tester.pumpAndSettle();

      await tester.tap(find.byType(OpenVtsSearchableDropdown<String>));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).last, 'v2');
      await tester.pump();

      expect(find.text('Sedan Beta · MH02BB0002'), findsOneWidget);
      expect(find.text('Truck Alpha · KA01AA0001'), findsNothing);
    });
  });
}
