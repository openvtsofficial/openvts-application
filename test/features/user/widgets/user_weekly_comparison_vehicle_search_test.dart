import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/utils/unit_formatter.dart';
import 'package:open_vts/features/user/controllers/user_providers.dart';
import 'package:open_vts/features/user/models/user_dashboard_model.dart';
import 'package:open_vts/features/user/screens/dashboard/widgets/user_dashboard_vehicle_selector.dart';
import 'package:open_vts/features/user/screens/dashboard/widgets/user_weekly_comparison_widget.dart';
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

final _comparison = const UserDashboardWeeklyComparison(
  timezoneOffsetMin: 0,
  filter: UserDashboardVehicleFilter(mode: 'ALL'),
  week: UserDashboardWeekRange(
    thisWeek: UserDashboardDateRange(),
    lastWeek: UserDashboardDateRange(),
    weekStart: 'MON',
  ),
  points: [],
  totals: UserDashboardWeeklyTotals(
    thisWeek: UserDashboardMetricPair(drivenKm: 0, engineHours: 0),
    lastWeek: UserDashboardMetricPair(drivenKm: 0, engineHours: 0),
  ),
);

// ---------------------------------------------------------------------------
// Helper
// ---------------------------------------------------------------------------

const _config = UserDashboardWidgetConfig(
  id: 'w1',
  type: 'weekly_comparison',
);

Widget _pump() {
  return ProviderScope(
    overrides: [
      unitFormatterProvider.overrideWithValue(
        const UnitFormatter(units: 'KM'),
      ),
      userDashboardWeeklyProvider(
        const UserDashboardVehicleScopedArgs(
          widgetId: 'w1',
          refreshKey: 0,
          vehicleId: null,
        ),
      ).overrideWith((_) => Future.value((
            vehicles: const [_v1, _v2],
            comparison: _comparison,
          ))),
    ],
    child: const MaterialApp(
      home: Scaffold(
        body: SizedBox(
          height: 600,
          child: UserWeeklyComparisonWidget(config: _config, refreshTick: 0),
        ),
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('UserWeeklyComparisonWidget — vehicle selector', () {
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
