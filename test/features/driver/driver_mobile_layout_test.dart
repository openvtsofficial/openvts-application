import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/utils/date_time_formatter.dart';
import 'package:open_vts/features/driver/models/driver_workspace_models.dart';
import 'package:open_vts/features/driver/screens/driver_widgets.dart';

void main() {
  testWidgets('trip card supports a narrow screen with Unicode and large text',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(320, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final trip = DriverTrip.fromJson({
      'title': 'दिल्ली से मुंबई वितरण यात्रा — चालक की लंबी यात्रा',
      'referenceCode': 'TRIP-00001',
      'status': 'IN_PROGRESS',
      'scheduledStartAt': '2026-10-02T10:00:00Z',
      'vehicle': {'name': 'वाहन', 'plateNumber': 'DL 01 AB 1000'},
      'stops': [
        {'name': 'दिल्ली', 'sequence': 1, 'status': 'COMPLETED'},
        {'name': 'मुंबई', 'sequence': 2, 'status': 'PENDING'}
      ]
    });
    await tester.pumpWidget(ProviderScope(
        overrides: [
          appDateFormatterProvider.overrideWithValue(const AppDateFormatter(
              datePattern: 'DD MMM YYYY', use24Hour: true))
        ],
        child: MaterialApp(
            home: MediaQuery(
                data: const MediaQueryData(
                    size: Size(320, 800), textScaler: TextScaler.linear(1.5)),
                child: Scaffold(
                    body: ListView(children: [
                  DriverTripCard(trip: trip, onTap: () {})
                ]))))));
    expect(tester.takeException(), isNull);
    expect(find.text('In progress'), findsOneWidget);
    expect(find.text('1 / 2 stops completed'), findsOneWidget);
  });
  testWidgets('manual action notes enforce API minimum and retain Unicode',
      (tester) async {
    String? result;
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: Builder(
                builder: (context) => TextButton(
                    onPressed: () async {
                      result = await driverNoteDialog(context,
                          title: 'Report issue', minimum: 2, maximum: 1000);
                    },
                    child: const Text('Open'))))));
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Confirm'));
    await tester.pump();
    expect(find.text('Enter at least 2 characters.'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField), 'प्रवेश बंद है');
    await tester.tap(find.text('Confirm'));
    await tester.pumpAndSettle();
    expect(result, 'प्रवेश बंद है');
    expect(tester.takeException(), isNull);
  });
}
