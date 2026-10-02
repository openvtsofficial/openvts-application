import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/features/admin/models/admin_vehicle_model.dart';
import 'package:open_vts/features/admin/screens/vehicles/widgets/admin_vehicle_edit_sheet.dart';
import 'package:open_vts/shared/widgets/open_vts_searchable_dropdown.dart';

const _vehicle = AdminVehicleDetails(
  id: 'vehicle-1',
  name: 'Delivery Vehicle',
  vin: '',
  plateNumber: '',
  isActive: true,
  isLicenseBlocked: false,
  createdAt: null,
  updatedAt: null,
  imei: '',
  simNumber: '',
  vehicleType: null,
  vehicleTypeId: '999',
  device: null,
  primaryUser: null,
  gmtOffset: '+05:30',
  vehicleMeta: <String, dynamic>{},
  plan: null,
);

void main() {
  testWidgets('vehicle type searches by name and ID and updates payload', (
    tester,
  ) async {
    AdminUpdateVehicleRequest? submitted;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AdminVehicleEditSheet(
            vehicle: _vehicle,
            vehicleTypes: const [
              AdminVehicleTypeOption(id: '101', name: 'Car', slug: 'car'),
              AdminVehicleTypeOption(
                id: '202',
                name: 'Heavy Truck',
                slug: 'truck',
              ),
            ],
            timezones: const ['+05:30'],
            isSubmitting: false,
            onSubmit: (request) async => submitted = request,
          ),
        ),
      ),
    );

    expect(find.text('999'), findsOneWidget);

    await tester.tap(find.byType(OpenVtsSearchableDropdown<String>));
    await tester.pumpAndSettle();

    final searchField = find.byType(TextField).last;
    await tester.enterText(searchField, 'heavy truck');
    await tester.pump();
    expect(find.text('Heavy Truck'), findsOneWidget);
    expect(find.text('Car'), findsNothing);

    await tester.enterText(searchField, '202');
    await tester.pump();
    expect(find.text('Heavy Truck'), findsOneWidget);
    expect(find.text('Car'), findsNothing);

    await tester.tap(find.text('Heavy Truck'));
    await tester.pumpAndSettle();
    expect(find.text('Heavy Truck'), findsOneWidget);

    final saveButton = find.text('Save Changes');
    await tester.ensureVisible(saveButton);
    await tester.pumpAndSettle();
    await tester.tap(saveButton);
    await tester.pump();

    expect(submitted?.vehicleTypeId, 202);
    expect(submitted?.gmtOffset, '+05:30');
  });
}
