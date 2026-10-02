import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/features/user/controllers/user_vehicle_details_controller.dart';
import 'package:open_vts/features/user/models/user_vehicle_model.dart';
import 'package:open_vts/features/user/models/user_vehicle_state.dart';
import 'package:open_vts/features/user/screens/vehicles/widgets/user_vehicle_edit_sheet.dart';
import 'package:open_vts/shared/widgets/open_vts_searchable_dropdown.dart';

// ---------------------------------------------------------------------------
// Fixtures
// ---------------------------------------------------------------------------

const _vehicle = UserVehicleDetails(
  id: 'v1',
  name: 'Test Vehicle',
  vin: '',
  plateNumber: '',
  isActive: true,
  isLicenseBlocked: false,
  licenseBlockedAt: null,
  licenseBlockReason: null,
  createdAt: null,
  imei: '',
  simNumber: '',
  vehicleType: UserVehicleTypeMini(id: '999', name: 'Unknown', slug: ''),
  vehicleMeta: <String, dynamic>{},
  gmtOffset: '+05:30',
  device: null,
  plan: null,
);

const _vehicleTypes = [
  UserVehicleTypeOption(id: '101', name: 'Car', slug: 'car'),
  UserVehicleTypeOption(id: '202', name: 'Heavy Truck', slug: 'truck'),
];

// ---------------------------------------------------------------------------
// Fake controller
// ---------------------------------------------------------------------------

class _FakeController extends StateNotifier<UserVehicleDetailsState>
    implements UserVehicleDetailsController {
  _FakeController(super.state);

  @override
  dynamic noSuchMethod(Invocation invocation) {}
}

AutoDisposeStateNotifierProvider<UserVehicleDetailsController,
    UserVehicleDetailsState> _makeProvider({
  List<UserVehicleTypeOption> vehicleTypes = _vehicleTypes,
  List<String> timezones = const ['+05:30', '+00:00', '-05:00'],
  bool isLoading = false,
}) {
  return StateNotifierProvider.autoDispose<UserVehicleDetailsController,
      UserVehicleDetailsState>(
    (ref) => _FakeController(
      UserVehicleDetailsState.initial(vehicleId: 'v1').copyWith(
        vehicleTypes: vehicleTypes,
        timezones: timezones,
        isLoadingReferenceData: isLoading,
      ),
    ),
  );
}

Widget _pump({
  UserVehicleDetails vehicle = _vehicle,
  List<UserVehicleTypeOption> vehicleTypes = _vehicleTypes,
  List<String> timezones = const ['+05:30', '+00:00', '-05:00'],
  bool isLoading = false,
}) {
  return ProviderScope(
    child: MaterialApp(
      home: Scaffold(
        body: UserVehicleEditSheet(
          provider: _makeProvider(
            vehicleTypes: vehicleTypes,
            timezones: timezones,
            isLoading: isLoading,
          ),
          vehicle: vehicle,
        ),
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('UserVehicleEditSheet — vehicle type selector', () {
    testWidgets('renders OpenVtsSearchableDropdown for vehicle type',
        (tester) async {
      await tester.pumpWidget(_pump());
      expect(
        find.byType(OpenVtsSearchableDropdown<String>),
        findsAtLeastNWidgets(1),
      );
    });

    testWidgets('shows current vehicle type value when not in list',
        (tester) async {
      await tester.pumpWidget(_pump());
      // vehicle type id 999 is not in _vehicleTypes list — should appear as fallback
      expect(find.text('999'), findsOneWidget);
    });

    testWidgets('vehicle type sheet opens on tap', (tester) async {
      await tester.pumpWidget(_pump());

      final dropdowns = find.byType(OpenVtsSearchableDropdown<String>);
      await tester.tap(dropdowns.first);
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsAtLeastNWidgets(1));
    });

    testWidgets('searches vehicle type by name case-insensitively',
        (tester) async {
      await tester.pumpWidget(_pump());

      final dropdowns = find.byType(OpenVtsSearchableDropdown<String>);
      await tester.tap(dropdowns.first);
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).last, 'heavy truck');
      await tester.pump();

      expect(find.text('Heavy Truck'), findsOneWidget);
      expect(find.text('Car'), findsNothing);
    });

    testWidgets('searches vehicle type by ID', (tester) async {
      await tester.pumpWidget(_pump());

      final dropdowns = find.byType(OpenVtsSearchableDropdown<String>);
      await tester.tap(dropdowns.first);
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).last, '202');
      await tester.pump();

      expect(find.text('Heavy Truck'), findsOneWidget);
      expect(find.text('Car'), findsNothing);
    });

    testWidgets('selecting a vehicle type updates the displayed value',
        (tester) async {
      await tester.pumpWidget(_pump(
        vehicle: const UserVehicleDetails(
          id: 'v1',
          name: 'Test Vehicle',
          vin: '',
          plateNumber: '',
          isActive: true,
          isLicenseBlocked: false,
          licenseBlockedAt: null,
          licenseBlockReason: null,
          createdAt: null,
          imei: '',
          simNumber: '',
          vehicleType: null,
          vehicleMeta: <String, dynamic>{},
          gmtOffset: null,
          device: null,
          plan: null,
        ),
      ));

      final dropdowns = find.byType(OpenVtsSearchableDropdown<String>);
      await tester.tap(dropdowns.first);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Car'));
      await tester.pumpAndSettle();

      expect(find.text('Car'), findsOneWidget);
    });
  });
}
