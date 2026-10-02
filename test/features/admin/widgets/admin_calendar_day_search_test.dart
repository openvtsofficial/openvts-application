import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/features/admin/controllers/admin_calendar_controller.dart';
import 'package:open_vts/features/admin/models/admin_calendar_model.dart';
import 'package:open_vts/features/admin/screens/calendar/widgets/admin_calendar_day_bottom_sheet.dart';

void main() {
  final date = DateTime(2026, 8, 12);
  final details = [
    AdminCalendarDayDetail(
      id: 'user-1',
      title: 'Users',
      type: 'users',
      subtitle: '',
      userId: 'user-1',
    ),
    AdminCalendarDayDetail(
      id: 'vehicle-1',
      title: 'Vehicle',
      type: 'vehicle',
      subtitle: '',
      vehicleId: 'vehicle-1',
    ),
  ];

  testWidgets('searches linked user and vehicle data without reloading day', (
    tester,
  ) async {
    var dayLoads = 0;
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          adminCalendarDayDetailsProvider.overrideWith((ref, requestedDate) {
            dayLoads++;
            return details;
          }),
          adminCalendarUserDetailsProvider.overrideWith((ref, id) {
            return const AdminCalendarLinkedDetail(
              title: 'Asha Rao',
              subtitle: 'asha@example.com • +91 9876543210',
              metadata: ['username: asha_admin'],
            );
          }),
          adminCalendarVehicleDetailsProvider.overrideWith((ref, id) {
            return const AdminCalendarLinkedDetail(
              title: 'Delivery Van',
              subtitle: 'KA01AB1234',
              metadata: ['IMEI: 860123456789012'],
            );
          }),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: AdminCalendarDayBottomSheet(date: date),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final search = find.byType(TextField);
    expect(search, findsOneWidget);
    expect(find.text('Asha Rao'), findsOneWidget);
    expect(find.text('Delivery Van'), findsOneWidget);

    await tester.enterText(search, 'asha_admin');
    await tester.pumpAndSettle();
    expect(find.text('Asha Rao'), findsOneWidget);
    expect(find.text('Delivery Van'), findsNothing);

    await tester.enterText(search, '860123');
    await tester.pumpAndSettle();
    expect(find.text('Delivery Van'), findsOneWidget);
    expect(find.text('Asha Rao'), findsNothing);

    await tester.enterText(search, 'not-present');
    await tester.pumpAndSettle();
    expect(find.text('No matching records'), findsOneWidget);

    await tester.enterText(search, '');
    await tester.pumpAndSettle();
    expect(find.text('Asha Rao'), findsOneWidget);
    expect(find.text('Delivery Van'), findsOneWidget);
    expect(dayLoads, 1);
  });

  test('matches source titles/subtitles and linked metadata case-insensitively',
      () {
    final sourceDetail = AdminCalendarDayDetail(
      id: 'source',
      title: 'New User Priya',
      type: 'users',
      subtitle: 'priya@example.com',
      userId: 'source',
    );
    const linked = AdminCalendarLinkedDetail(
      title: 'Priya Sharma',
      subtitle: '+91 9000000000',
      metadata: ['username: PRIYA_ADMIN'],
    );

    expect(
      filterAdminCalendarDayDetails(
          [sourceDetail], {'source': linked}, 'PRIYA'),
      [sourceDetail],
    );
    expect(
      filterAdminCalendarDayDetails(
        [sourceDetail],
        {'source': linked},
        'priya_admin',
      ),
      [sourceDetail],
    );
  });
}
