import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/utils/date_time_formatter.dart';
import 'package:open_vts/features/user/controllers/user_providers.dart';
import 'package:open_vts/features/user/models/user_dashboard_model.dart';
import 'package:open_vts/features/user/screens/dashboard/widgets/user_dashboard_vehicle_selector.dart';
import 'package:open_vts/features/user/screens/dashboard/widgets/user_sensor_history_widget.dart';
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
  type: 'sensor_history',
);

Widget _pump() {
  return ProviderScope(
    overrides: [
      userDashboardSensorHistoryProvider
          .overrideWith((ref, args) => Future.value((
                vehicles: const [_v1, _v2],
                sensors: const <UserDashboardSensorOption>[],
                selectedVehicleId: null,
                selectedSensorId: null,
                history: null,
                emptyMessage: 'No sensors available.',
              ))),
      appDateFormatterProvider.overrideWithValue(
        const AppDateFormatter(
          datePattern: 'yyyy-MM-dd',
          use24Hour: true,
          timezone: 'UTC',
        ),
      ),
    ],
    child: const MaterialApp(
      home: Scaffold(
        body: SizedBox(
          height: 700,
          child: UserSensorHistoryWidget(config: _config, refreshTick: 0),
        ),
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('UserSensorHistoryWidget — vehicle selector', () {
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

    testWidgets('All Vehicles option is absent (sensor history requires one)',
        (tester) async {
      await tester.pumpWidget(_pump());
      await tester.pumpAndSettle();

      await tester.tap(find.byType(OpenVtsSearchableDropdown<String>));
      await tester.pumpAndSettle();

      expect(find.text('All Vehicles'), findsNothing);
    });

    testWidgets('both vehicles are listed in the picker', (tester) async {
      await tester.pumpWidget(_pump());
      await tester.pumpAndSettle();

      await tester.tap(find.byType(OpenVtsSearchableDropdown<String>));
      await tester.pumpAndSettle();

      expect(find.text('Truck Alpha · KA01AA0001'), findsOneWidget);
      expect(find.text('Sedan Beta · MH02BB0002'), findsOneWidget);
    });

    testWidgets('searches by vehicle name', (tester) async {
      await tester.pumpWidget(_pump());
      await tester.pumpAndSettle();

      await tester.tap(find.byType(OpenVtsSearchableDropdown<String>));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).last, 'Sedan');
      await tester.pump();

      expect(find.text('Sedan Beta · MH02BB0002'), findsOneWidget);
      expect(find.text('Truck Alpha · KA01AA0001'), findsNothing);
    });

    testWidgets('searches by plate number', (tester) async {
      await tester.pumpWidget(_pump());
      await tester.pumpAndSettle();

      await tester.tap(find.byType(OpenVtsSearchableDropdown<String>));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).last, 'KA01AA');
      await tester.pump();

      expect(find.text('Truck Alpha · KA01AA0001'), findsOneWidget);
      expect(find.text('Sedan Beta · MH02BB0002'), findsNothing);
    });

    testWidgets('searches by IMEI', (tester) async {
      await tester.pumpWidget(_pump());
      await tester.pumpAndSettle();

      await tester.tap(find.byType(OpenVtsSearchableDropdown<String>));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).last, '200300400500600');
      await tester.pump();

      expect(find.text('Sedan Beta · MH02BB0002'), findsOneWidget);
      expect(find.text('Truck Alpha · KA01AA0001'), findsNothing);
    });

    testWidgets('searches by vehicle ID', (tester) async {
      await tester.pumpWidget(_pump());
      await tester.pumpAndSettle();

      await tester.tap(find.byType(OpenVtsSearchableDropdown<String>));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).last, 'v1');
      await tester.pump();

      expect(find.text('Truck Alpha · KA01AA0001'), findsOneWidget);
      expect(find.text('Sedan Beta · MH02BB0002'), findsNothing);
    });
  });
}
