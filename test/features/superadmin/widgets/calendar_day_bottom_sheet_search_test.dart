import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/features/superadmin/controllers/superadmin_calendar_controller.dart';
import 'package:open_vts/features/superadmin/models/superadmin_calendar_model.dart';
import 'package:open_vts/features/superadmin/screens/calendar/widgets/calendar_day_bottom_sheet.dart';
import 'package:open_vts/shared/widgets/open_vts_search_field.dart';

// ---------------------------------------------------------------------------
// Fixtures
// ---------------------------------------------------------------------------

final _date = DateTime(2026, 8, 1);

final _userDetail = CalendarDayDetail(
  id: 'u1',
  title: 'Alice Johnson',
  type: 'users',
  subtitle: 'alice@example.com',
  userId: 'u1',
);

final _vehicleDetail = CalendarDayDetail(
  id: 'v1',
  title: 'Toyota Camry',
  type: 'vehicle',
  subtitle: 'KA01AB1234',
  vehicleId: 'v1',
);

final _expiryDetail = CalendarDayDetail(
  id: 'e1',
  title: 'Insurance Expiry',
  type: 'expiry',
  subtitle: '2026-08-01',
);

const _userLinked = CalendarLinkedDetail(
  title: 'Alice Johnson',
  subtitle: 'alice@example.com • +91 9876543210',
  metadata: ['Active • Admin', 'Acme Corp • Mumbai'],
);

const _vehicleLinked = CalendarLinkedDetail(
  title: 'Toyota Camry',
  subtitle: 'KA01AB1234',
  metadata: ['IMEI: 123456789012345', 'Active • Bob'],
);

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

Widget _pump(
  List<CalendarDayDetail> details, {
  CalendarLinkedDetail? userLinked = _userLinked,
  CalendarLinkedDetail? vehicleLinked = _vehicleLinked,
}) {
  return ProviderScope(
    overrides: [
      calendarDayDetailsProvider(_date).overrideWith(
        (_) => Future.value(details),
      ),
      calendarUserDetailsProvider('u1').overrideWith(
        (_) => Future.value(userLinked),
      ),
      calendarVehicleDetailsProvider('v1').overrideWith(
        (_) => Future.value(vehicleLinked),
      ),
    ],
    child: MaterialApp(
      home: Scaffold(
        body: SizedBox(
          height: 600,
          child: CalendarDayBottomSheet(date: _date),
        ),
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('CalendarDayBottomSheet — search field presence', () {
    testWidgets('search field is shown when day has records', (tester) async {
      await tester.pumpWidget(_pump([_userDetail, _vehicleDetail]));
      await tester.pumpAndSettle();

      expect(find.byType(OpenVtsSearchField), findsOneWidget);
    });

    testWidgets('search field is absent when day is empty', (tester) async {
      await tester.pumpWidget(_pump([]));
      await tester.pumpAndSettle();

      expect(find.byType(OpenVtsSearchField), findsNothing);
    });
  });

  group('CalendarDayBottomSheet — unfiltered state', () {
    testWidgets('all items visible before any search', (tester) async {
      await tester.pumpWidget(
        _pump([_userDetail, _vehicleDetail, _expiryDetail]),
      );
      await tester.pumpAndSettle();

      expect(find.text('Alice Johnson'), findsOneWidget);
      expect(find.text('Toyota Camry'), findsOneWidget);
      expect(find.text('Insurance Expiry'), findsOneWidget);
    });
  });

  group('CalendarDayBottomSheet — title search', () {
    testWidgets('searching by title shows matching item', (tester) async {
      await tester.pumpWidget(
        _pump([_userDetail, _vehicleDetail, _expiryDetail]),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'alice');
      await tester.pump();

      expect(find.text('Alice Johnson'), findsOneWidget);
      expect(find.text('Toyota Camry'), findsNothing);
      expect(find.text('Insurance Expiry'), findsNothing);
    });

    testWidgets('title search is case-insensitive', (tester) async {
      await tester.pumpWidget(
        _pump([_userDetail, _vehicleDetail, _expiryDetail]),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'TOYOTA');
      await tester.pump();

      expect(find.text('Toyota Camry'), findsOneWidget);
      expect(find.text('Alice Johnson'), findsNothing);
    });
  });

  group('CalendarDayBottomSheet — subtitle search', () {
    testWidgets('searching by email matches user subtitle', (tester) async {
      await tester.pumpWidget(_pump([_userDetail, _vehicleDetail]));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'alice@example');
      await tester.pump();

      expect(find.text('Alice Johnson'), findsOneWidget);
      expect(find.text('Toyota Camry'), findsNothing);
    });

    testWidgets('searching by plate matches vehicle subtitle', (tester) async {
      await tester.pumpWidget(_pump([_userDetail, _vehicleDetail]));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'KA01');
      await tester.pump();

      expect(find.text('Toyota Camry'), findsOneWidget);
      expect(find.text('Alice Johnson'), findsNothing);
    });
  });

  group('CalendarDayBottomSheet — linked detail search', () {
    testWidgets('searching linked metadata matches vehicle IMEI', (
      tester,
    ) async {
      await tester.pumpWidget(_pump([_userDetail, _vehicleDetail]));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), '123456789');
      await tester.pump();

      expect(find.text('Toyota Camry'), findsOneWidget);
      expect(find.text('Alice Johnson'), findsNothing);
    });

    testWidgets('searching linked subtitle matches user email', (tester) async {
      await tester.pumpWidget(_pump([_userDetail, _vehicleDetail]));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), '9876543210');
      await tester.pump();

      expect(find.text('Alice Johnson'), findsOneWidget);
      expect(find.text('Toyota Camry'), findsNothing);
    });
  });

  group('CalendarDayBottomSheet — no-match state', () {
    testWidgets('shows "No matching records" when query has no results', (
      tester,
    ) async {
      await tester.pumpWidget(
        _pump([_userDetail, _vehicleDetail, _expiryDetail]),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'ZZZZZNOTFOUND');
      await tester.pump();

      expect(find.text('No matching records'), findsOneWidget);
      expect(find.text('Alice Johnson'), findsNothing);
      expect(find.text('Toyota Camry'), findsNothing);
      expect(find.text('Insurance Expiry'), findsNothing);
    });

    testWidgets('"No matching records" is not shown for empty day', (
      tester,
    ) async {
      await tester.pumpWidget(_pump([]));
      await tester.pumpAndSettle();

      expect(find.text('No matching records'), findsNothing);
      expect(find.text('No Data'), findsOneWidget);
    });
  });

  group('CalendarDayBottomSheet — clearing search', () {
    testWidgets('clearing search restores all items', (tester) async {
      await tester.pumpWidget(
        _pump([_userDetail, _vehicleDetail, _expiryDetail]),
      );
      await tester.pumpAndSettle();

      final searchField = find.byType(TextField);

      await tester.enterText(searchField, 'alice');
      await tester.pump();
      expect(find.text('Toyota Camry'), findsNothing);

      await tester.enterText(searchField, '');
      await tester.pump();

      expect(find.text('Alice Johnson'), findsOneWidget);
      expect(find.text('Toyota Camry'), findsOneWidget);
      expect(find.text('Insurance Expiry'), findsOneWidget);
    });

    testWidgets('whitespace-only query shows all items', (tester) async {
      await tester.pumpWidget(_pump([_userDetail, _vehicleDetail]));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), '   ');
      await tester.pump();

      expect(find.text('Alice Johnson'), findsOneWidget);
      expect(find.text('Toyota Camry'), findsOneWidget);
    });
  });

  group('CalendarDayBottomSheet — providers not re-called on search', () {
    testWidgets('typing does not throw or cause uncaught errors', (
      tester,
    ) async {
      await tester.pumpWidget(_pump([_userDetail, _vehicleDetail]));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'cam');
      await tester.pump();
      await tester.enterText(find.byType(TextField), 'camr');
      await tester.pump();
      await tester.enterText(find.byType(TextField), 'camry');
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(find.text('Toyota Camry'), findsOneWidget);
    });
  });
}
