import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/features/user/models/user_dashboard_model.dart';
import 'package:open_vts/features/user/screens/dashboard/widgets/user_dashboard_vehicle_selector.dart';
import 'package:open_vts/shared/widgets/open_vts_searchable_dropdown.dart';

// ---------------------------------------------------------------------------
// Fixtures
// ---------------------------------------------------------------------------

const _v1 = UserDashboardVehicleOption(
  id: 'v1',
  name: 'Delivery Truck',
  plateNumber: 'KA01AA1111',
  imei: '111222333444555',
);

const _v2 = UserDashboardVehicleOption(
  id: 'v2',
  name: 'Sedan Alpha',
  plateNumber: 'MH02BB2222',
  imei: '999888777666555',
);

const _v3 = UserDashboardVehicleOption(
  id: 'v3',
  name: 'Van Fleet',
  plateNumber: null,
  imei: null,
);

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

Widget _pump(
  List<UserDashboardVehicleOption> vehicles, {
  String? value = 'all',
  ValueChanged<String?>? onChanged,
  bool includeAll = true,
}) {
  return MaterialApp(
    home: Scaffold(
      body: SingleChildScrollView(
        child: UserDashboardVehicleSelector(
          vehicles: vehicles,
          value: value,
          onChanged: onChanged ?? (_) {},
          includeAll: includeAll,
        ),
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('UserDashboardVehicleSelector — renders', () {
    testWidgets('renders an OpenVtsSearchableDropdown', (tester) async {
      await tester.pumpWidget(_pump([_v1, _v2]));
      expect(find.byType(OpenVtsSearchableDropdown<String>), findsOneWidget);
    });

    testWidgets('label text is "Vehicle"', (tester) async {
      await tester.pumpWidget(_pump([_v1]));
      expect(find.text('Vehicle'), findsOneWidget);
    });

    testWidgets('shows All Vehicles option when includeAll is true',
        (tester) async {
      await tester.pumpWidget(_pump([_v1]));
      await tester.tap(find.byType(OpenVtsSearchableDropdown<String>));
      await tester.pumpAndSettle();
      // "All Vehicles" may appear twice: once in the selected value display and
      // once as the list item when value == 'all'.
      expect(find.text('All Vehicles'), findsAtLeastNWidgets(1));
    });

    testWidgets('does not show All Vehicles option when includeAll is false',
        (tester) async {
      await tester.pumpWidget(_pump([_v1], includeAll: false));
      await tester.tap(find.byType(OpenVtsSearchableDropdown<String>));
      await tester.pumpAndSettle();
      expect(find.text('All Vehicles'), findsNothing);
    });
  });

  group('UserDashboardVehicleSelector — search by name', () {
    testWidgets('searching by name filters correctly', (tester) async {
      await tester.pumpWidget(_pump([_v1, _v2, _v3]));
      await tester.tap(find.byType(OpenVtsSearchableDropdown<String>));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).last, 'Delivery');
      await tester.pump();

      expect(find.text('Delivery Truck · KA01AA1111'), findsOneWidget);
      expect(find.text('Sedan Alpha · MH02BB2222'), findsNothing);
      expect(find.text('Van Fleet'), findsNothing);
    });

    testWidgets('search is case-insensitive', (tester) async {
      await tester.pumpWidget(_pump([_v1, _v2, _v3]));
      await tester.tap(find.byType(OpenVtsSearchableDropdown<String>));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).last, 'sedan alpha');
      await tester.pump();

      expect(find.text('Sedan Alpha · MH02BB2222'), findsOneWidget);
      expect(find.text('Delivery Truck · KA01AA1111'), findsNothing);
    });
  });

  group('UserDashboardVehicleSelector — search by plate number', () {
    testWidgets('searching by plate number filters correctly', (tester) async {
      await tester.pumpWidget(_pump([_v1, _v2, _v3]));
      await tester.tap(find.byType(OpenVtsSearchableDropdown<String>));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).last, 'KA01AA');
      await tester.pump();

      expect(find.text('Delivery Truck · KA01AA1111'), findsOneWidget);
      expect(find.text('Sedan Alpha · MH02BB2222'), findsNothing);
    });

    testWidgets('partial plate number matches', (tester) async {
      await tester.pumpWidget(_pump([_v1, _v2, _v3]));
      await tester.tap(find.byType(OpenVtsSearchableDropdown<String>));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).last, 'MH02');
      await tester.pump();

      expect(find.text('Sedan Alpha · MH02BB2222'), findsOneWidget);
      expect(find.text('Delivery Truck · KA01AA1111'), findsNothing);
    });
  });

  group('UserDashboardVehicleSelector — search by IMEI', () {
    testWidgets('searching by IMEI filters correctly', (tester) async {
      await tester.pumpWidget(_pump([_v1, _v2, _v3]));
      await tester.tap(find.byType(OpenVtsSearchableDropdown<String>));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).last, '111222333');
      await tester.pump();

      expect(find.text('Delivery Truck · KA01AA1111'), findsOneWidget);
      expect(find.text('Sedan Alpha · MH02BB2222'), findsNothing);
    });

    testWidgets('searching by second vehicle IMEI shows correct result',
        (tester) async {
      await tester.pumpWidget(_pump([_v1, _v2, _v3]));
      await tester.tap(find.byType(OpenVtsSearchableDropdown<String>));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).last, '999888777');
      await tester.pump();

      expect(find.text('Sedan Alpha · MH02BB2222'), findsOneWidget);
      expect(find.text('Delivery Truck · KA01AA1111'), findsNothing);
    });
  });

  group('UserDashboardVehicleSelector — search by vehicle ID', () {
    testWidgets('searching by vehicle ID filters correctly', (tester) async {
      await tester.pumpWidget(_pump([_v1, _v2, _v3]));
      await tester.tap(find.byType(OpenVtsSearchableDropdown<String>));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).last, 'v3');
      await tester.pump();

      expect(find.text('Van Fleet'), findsOneWidget);
      expect(find.text('Delivery Truck · KA01AA1111'), findsNothing);
      expect(find.text('Sedan Alpha · MH02BB2222'), findsNothing);
    });
  });

  group('UserDashboardVehicleSelector — selection callback', () {
    testWidgets('selecting a vehicle calls onChanged with its ID',
        (tester) async {
      String? selected;
      await tester.pumpWidget(_pump(
        [_v1, _v2],
        onChanged: (v) => selected = v,
        value: 'all',
      ));

      await tester.tap(find.byType(OpenVtsSearchableDropdown<String>));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Delivery Truck · KA01AA1111'));
      await tester.pumpAndSettle();

      expect(selected, 'v1');
    });

    testWidgets('selecting All Vehicles calls onChanged with "all"',
        (tester) async {
      String? selected;
      await tester.pumpWidget(_pump(
        [_v1, _v2],
        value: 'v1',
        onChanged: (v) => selected = v,
      ));

      await tester.tap(find.byType(OpenVtsSearchableDropdown<String>));
      await tester.pumpAndSettle();

      await tester.tap(find.text('All Vehicles'));
      await tester.pumpAndSettle();

      expect(selected, 'all');
    });
  });

  group('UserDashboardVehicleSelector — label format', () {
    testWidgets('vehicle with plate shows "name · plate" label',
        (tester) async {
      await tester.pumpWidget(_pump([_v1]));
      await tester.tap(find.byType(OpenVtsSearchableDropdown<String>));
      await tester.pumpAndSettle();

      expect(find.text('Delivery Truck · KA01AA1111'), findsOneWidget);
    });

    testWidgets('vehicle without plate shows name only', (tester) async {
      await tester.pumpWidget(_pump([_v3]));
      await tester.tap(find.byType(OpenVtsSearchableDropdown<String>));
      await tester.pumpAndSettle();

      expect(find.text('Van Fleet'), findsOneWidget);
    });
  });

  group('UserDashboardVehicleSelector — no results', () {
    testWidgets('shows no results message when query has no matches',
        (tester) async {
      await tester.pumpWidget(_pump([_v1, _v2, _v3]));
      await tester.tap(find.byType(OpenVtsSearchableDropdown<String>));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).last, 'ZZZNOMATCH');
      await tester.pump();

      expect(find.text('Delivery Truck · KA01AA1111'), findsNothing);
      expect(find.text('Sedan Alpha · MH02BB2222'), findsNothing);
      expect(find.text('Van Fleet'), findsNothing);
    });
  });
}
