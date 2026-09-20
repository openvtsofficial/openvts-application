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

const _timezones = [
  '+00:00',
  '+05:30',
  '+05:45',
  '-05:00',
  '-08:00',
];

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
  vehicleType: null,
  vehicleMeta: <String, dynamic>{},
  gmtOffset: '+05:30',
  device: null,
  plan: null,
);

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
  List<String> timezones = _timezones,
  bool isLoading = false,
}) {
  return StateNotifierProvider.autoDispose<UserVehicleDetailsController,
      UserVehicleDetailsState>(
    (ref) => _FakeController(
      UserVehicleDetailsState.initial(vehicleId: 'v1').copyWith(
        vehicleTypes: const [],
        timezones: timezones,
        isLoadingReferenceData: isLoading,
      ),
    ),
  );
}

Widget _pump({
  UserVehicleDetails vehicle = _vehicle,
  List<String> timezones = _timezones,
  bool isLoading = false,
}) {
  return ProviderScope(
    child: MaterialApp(
      home: Scaffold(
        body: UserVehicleEditSheet(
          provider: _makeProvider(timezones: timezones, isLoading: isLoading),
          vehicle: vehicle,
        ),
      ),
    ),
  );
}

// Find the GMT Offset dropdown (second OpenVtsSearchableDropdown).
Finder get _gmtDropdown => find.byType(OpenVtsSearchableDropdown<String>).at(1);

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('UserVehicleEditSheet — GMT offset selector', () {
    testWidgets('renders OpenVtsSearchableDropdown for GMT Offset',
        (tester) async {
      await tester.pumpWidget(_pump());
      // Two dropdowns: vehicle type + GMT offset.
      expect(
        find.byType(OpenVtsSearchableDropdown<String>),
        findsNWidgets(2),
      );
    });

    testWidgets('shows the current GMT offset value', (tester) async {
      await tester.pumpWidget(_pump());
      expect(find.text('+05:30'), findsAtLeastNWidgets(1));
    });

    testWidgets('GMT offset sheet opens on tap', (tester) async {
      await tester.pumpWidget(_pump());
      await tester.tap(_gmtDropdown);
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsAtLeastNWidgets(1));
    });

    testWidgets('all timezones are listed in the picker', (tester) async {
      await tester.pumpWidget(_pump());
      await tester.tap(_gmtDropdown);
      await tester.pumpAndSettle();

      for (final tz in _timezones) {
        expect(find.text(tz), findsAtLeastNWidgets(1));
      }
    });

    testWidgets('search filters timezones case-insensitively', (tester) async {
      // Use no pre-selected value so no trigger label obscures the picker list.
      await tester.pumpWidget(_pump(
        vehicle: const UserVehicleDetails(
          id: 'v1',
          name: 'Test',
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
      await tester.tap(_gmtDropdown);
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).last, '+05');
      await tester.pump();

      expect(find.text('+05:30'), findsOneWidget);
      expect(find.text('+05:45'), findsOneWidget);
      expect(find.text('+00:00'), findsNothing);
      expect(find.text('-05:00'), findsNothing);
    });

    testWidgets('partial search narrows results', (tester) async {
      // Use no pre-selected value so the trigger label stays empty.
      await tester.pumpWidget(_pump(
        vehicle: const UserVehicleDetails(
          id: 'v1',
          name: 'Test',
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
      await tester.tap(_gmtDropdown);
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).last, '-08');
      await tester.pump();

      expect(find.text('-08:00'), findsOneWidget);
      expect(find.text('+05:30'), findsNothing);
      expect(find.text('+00:00'), findsNothing);
    });

    testWidgets('selecting a timezone updates displayed value', (tester) async {
      await tester.pumpWidget(_pump(
        vehicle: const UserVehicleDetails(
          id: 'v1',
          name: 'Test',
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

      await tester.tap(_gmtDropdown);
      await tester.pumpAndSettle();

      await tester.tap(find.text('+00:00'));
      await tester.pumpAndSettle();

      expect(find.text('+00:00'), findsAtLeastNWidgets(1));
    });

    testWidgets('out-of-list current value appears as fallback option',
        (tester) async {
      await tester.pumpWidget(_pump(
        vehicle: const UserVehicleDetails(
          id: 'v1',
          name: 'Test',
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
          gmtOffset: '+09:00',
          device: null,
          plan: null,
        ),
        timezones: const ['+05:30'],
      ));

      await tester.tap(_gmtDropdown);
      await tester.pumpAndSettle();

      // +09:00 is not in the list but should appear as a fallback.
      expect(find.text('+09:00'), findsAtLeastNWidgets(1));
    });
  });
}
