import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/features/admin/models/admin_logs_model.dart';
import 'package:open_vts/features/admin/screens/logs/widgets/admin_vehicle_logs_panel.dart';

void main() {
  testWidgets('Vehicle searches source fields, selects ID, and clears', (
    tester,
  ) async {
    String? selectedVehicleId;
    final changes = <String?>[];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) => AdminVehicleLogsVehicleDropdown(
              value: selectedVehicleId,
              vehicles: const [
                AdminLogsVehicleOption(
                  id: 'vehicle-42',
                  name: 'Delivery Van',
                  plateNumber: 'KA01AB1234',
                  imei: '860123456789012',
                ),
                AdminLogsVehicleOption(
                  id: 'vehicle-99',
                  name: 'Service Car',
                  plateNumber: 'DL02CD5678',
                  imei: '860999999999999',
                ),
              ],
              onChanged: (value) => setState(() {
                selectedVehicleId = value;
                changes.add(value);
              }),
            ),
          ),
        ),
      ),
    );

    expect(find.text('All vehicles'), findsOneWidget);
    final trigger = find.descendant(
      of: find.byType(AdminVehicleLogsVehicleDropdown),
      matching: find.byType(InkWell),
    );
    await tester.tap(trigger);
    await tester.pumpAndSettle();

    final search = find.byType(TextField).last;
    final results = find.byType(ListView);
    final deliveryVan = find.descendant(
      of: results,
      matching: find.text('Delivery Van (KA01AB1234)'),
    );

    for (final query in ['delivery', 'vehicle-42', 'ka01ab', '860123']) {
      await tester.enterText(search, query);
      await tester.pump();
      expect(deliveryVan, findsOneWidget, reason: 'query: $query');
      expect(
        find.descendant(
          of: results,
          matching: find.text('Service Car (DL02CD5678)'),
        ),
        findsNothing,
      );
    }

    await tester.tap(deliveryVan);
    await tester.pumpAndSettle();
    expect(selectedVehicleId, 'vehicle-42');
    expect(changes, ['vehicle-42']);

    await tester.tap(trigger);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Clear'));
    await tester.pumpAndSettle();

    expect(selectedVehicleId, isNull);
    expect(changes, ['vehicle-42', null]);
    expect(find.text('All vehicles'), findsOneWidget);
  });
}
