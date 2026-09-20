import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/features/admin/controllers/admin_payments_controller.dart';
import 'package:open_vts/features/admin/controllers/admin_providers.dart';
import 'package:open_vts/features/admin/models/admin_payments_model.dart';
import 'package:open_vts/features/admin/models/admin_users_model.dart';
import 'package:open_vts/features/admin/screens/payments/widgets/admin_renew_vehicle_sheet.dart';
import 'package:open_vts/features/admin/services/admin_payments_service.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

AdminRenewVehicleOption _mkVehicle(
  String id, {
  String name = '',
  String plate = 'KA01AB1234',
  String plan = 'Basic',
  double price = 500,
  // isRenewable is computed by the model from planId + planName, NOT from a
  // dedicated flag.  Pass renewable: false to omit the plan entirely.
  bool renewable = true,
}) =>
    AdminRenewVehicleOption.fromJson(<String, dynamic>{
      'id': id,
      'name': name,
      'plateNumber': plate,
      'vin': '',
      'plan': renewable
          ? <String, dynamic>{
              'id': 'p1',
              'name': plan,
              'price': price,
              'currency': 'INR',
            }
          : <String,
              dynamic>{}, // Empty plan → planId null → isRenewable = false
    });

List<AdminRenewVehicleOption> _mkFleet(int count, {bool renewable = true}) =>
    List.generate(
      count,
      (i) => _mkVehicle('v$i',
          name: 'Vehicle $i',
          plate: 'KA${i.toString().padLeft(2, '0')}AB1234',
          plan: 'Basic',
          price: 500,
          renewable: renewable),
    );

AdminUserListItem _mkUser(String id, String name) =>
    AdminUserListItem.fromJson(<String, dynamic>{
      'id': id,
      'name': name,
      'username': id,
      'email': '$id@example.com',
    });

// ---------------------------------------------------------------------------
// Fake service
// ---------------------------------------------------------------------------

class _FakeService extends Fake implements AdminPaymentsService {
  Completer<List<AdminRenewVehicleOption>> _vehicles = Completer();
  List<AdminUserListItem> users = <AdminUserListItem>[];

  @override
  Future<AdminPaymentsPage> getPayments({
    int page = 1,
    int limit = 100,
    String? userId,
    AdminPaymentStatus? status,
    DateTime? from,
    DateTime? to,
    String? q,
    String? refreshKey,
  }) async =>
      AdminPaymentsPage(page: page, limit: limit, total: 0, items: const []);

  @override
  Future<AdminPaymentsAnalytics> getTransactionsAnalytics({
    String? userId,
    DateTime? from,
    DateTime? to,
    String? refreshKey,
  }) async =>
      const AdminPaymentsAnalytics.empty();

  @override
  Future<List<AdminUserListItem>> getUsers() async => users;

  @override
  Future<List<AdminRenewVehicleOption>> getLinkedVehicles(String userId) =>
      _vehicles.future;

  @override
  Future<AdminPaymentTransaction?> renewVehicles(
          AdminRenewPaymentRequest request) async =>
      null;

  void completeVehicles(List<AdminRenewVehicleOption> list) {
    _vehicles.complete(list);
    _vehicles = Completer();
  }

  void failVehicles(Object error) {
    _vehicles.completeError(error);
    _vehicles = Completer();
  }
}

// ---------------------------------------------------------------------------
// Pump helper
// ---------------------------------------------------------------------------

Future<void> _pumpSheet(
  WidgetTester tester,
  _FakeService service,
) async {
  tester.view.physicalSize = const Size(400, 800);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  final controller = AdminPaymentsController(service: service);
  // Seed users into controller state before pumping.
  await controller.loadUsers();

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        adminPaymentsControllerProvider.overrideWith((_) => controller),
      ],
      child: const MaterialApp(
        home: Scaffold(body: AdminRenewVehicleSheet()),
      ),
    ),
  );
  await tester.pump();
}

/// Opens the user picker, selects the user, then pumps until the
/// vehicle-load future settles with [vehicles].
///
/// Important: do NOT use pumpAndSettle() after selecting the user.
/// `onChanged` fires after the sheet close animation completes; by that
/// point the widget shows an indeterminate LinearProgressIndicator, which
/// keeps scheduling frames and causes pumpAndSettle to time out.
Future<void> _selectUser(
  WidgetTester tester, {
  required String userName,
  required _FakeService service,
  required List<AdminRenewVehicleOption> vehicles,
}) async {
  await tester.tap(find.text('Select user'));
  await tester
      .pumpAndSettle(); // Sheet open animation — no progress indicator yet.
  await tester.tap(find.text(userName));
  // Drive the sheet's exit animation (~250 ms default). Once it completes,
  // showModalBottomSheet returns → onChanged fires → loading starts.
  await tester.pump(const Duration(milliseconds: 500));
  // Now _loadingVehicles = true.  Complete the future so loading ends.
  service.completeVehicles(vehicles);
  await tester.pump(); // Drain the completed future through the event loop.
  await tester.pump(); // Let setState rebuild the widget.
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  // ── Initial state ─────────────────────────────────────────────────────────

  group('initial state', () {
    testWidgets('user picker shown before any user is selected',
        (tester) async {
      final service = _FakeService()..users = [_mkUser('u1', 'Alice')];
      await _pumpSheet(tester, service);

      expect(find.text('Select user'), findsOneWidget);
      expect(find.byKey(const Key('renew-vehicle-list')), findsNothing);
    });

    testWidgets('vehicle section is hidden before user is selected',
        (tester) async {
      final service = _FakeService()..users = [_mkUser('u1', 'Alice')];
      await _pumpSheet(tester, service);

      expect(
          find.text('Search vehicles by name, plate, plan...'), findsNothing);
    });
  });

  // ── Loading indicator ──────────────────────────────────────────────────────

  group('loading', () {
    testWidgets('progress bar visible while vehicles are loading',
        (tester) async {
      final service = _FakeService()..users = [_mkUser('u1', 'Alice')];
      await _pumpSheet(tester, service);

      await tester.tap(find.text('Select user'));
      await tester.pumpAndSettle(); // Sheet opens.
      await tester.tap(find.text('Alice'));
      // Drive exit animation so onChanged fires → loading = true.
      await tester.pump(const Duration(milliseconds: 500));

      // Future has not resolved yet — progress bar must be visible.
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
      expect(find.byKey(const Key('renew-vehicle-list')), findsNothing);

      // Resolve the future so the test ends cleanly (no pending async work).
      service.completeVehicles(const []);
      await tester.pump();
      await tester.pump();
    });
  });

  // ── Empty states ──────────────────────────────────────────────────────────

  group('empty states', () {
    testWidgets('no vehicles found message when user has no vehicles',
        (tester) async {
      final service = _FakeService()..users = [_mkUser('u1', 'Alice')];
      await _pumpSheet(tester, service);
      await _selectUser(tester,
          userName: 'Alice', service: service, vehicles: const []);

      expect(find.text('No vehicles found for this user.'), findsOneWidget);
      expect(find.byKey(const Key('renew-vehicle-list')), findsNothing);
    });

    testWidgets('no renewable vehicles message when all vehicles non-renewable',
        (tester) async {
      final service = _FakeService()..users = [_mkUser('u1', 'Alice')];
      await _pumpSheet(tester, service);
      await _selectUser(
        tester,
        userName: 'Alice',
        service: service,
        vehicles: [_mkVehicle('v1', renewable: false)],
      );

      expect(find.text('No renewable vehicles for this user.'), findsOneWidget);
      expect(find.byKey(const Key('renew-vehicle-list')), findsNothing);
    });

    testWidgets('no match message when search yields no results',
        (tester) async {
      final service = _FakeService()..users = [_mkUser('u1', 'Alice')];
      await _pumpSheet(tester, service);
      await _selectUser(
        tester,
        userName: 'Alice',
        service: service,
        vehicles: [_mkVehicle('v1', name: 'Truck Alpha')],
      );

      await tester.enterText(find.byType(TextField).first, 'zzz_no_match_zzz');
      await tester.pump();

      expect(find.text('No vehicles match your search.'), findsOneWidget);
    });
  });

  // ── Bounded list ──────────────────────────────────────────────────────────

  group('bounded vehicle list', () {
    testWidgets('1 vehicle — bounded container shown, no overflow', (
      tester,
    ) async {
      final service = _FakeService()..users = [_mkUser('u1', 'Alice')];
      await _pumpSheet(tester, service);
      await _selectUser(
        tester,
        userName: 'Alice',
        service: service,
        vehicles: [_mkVehicle('v1', name: 'Truck Alpha')],
      );

      expect(find.byKey(const Key('renew-vehicle-list')), findsOneWidget);
      final size = tester.getSize(find.byKey(const Key('renew-vehicle-list')));
      expect(size.height, lessThanOrEqualTo(280));
      expect(tester.takeException(), isNull);
    });

    testWidgets('50 vehicles — list stays bounded at ≤ 280 px', (
      tester,
    ) async {
      final service = _FakeService()..users = [_mkUser('u1', 'Alice')];
      await _pumpSheet(tester, service);
      await _selectUser(
        tester,
        userName: 'Alice',
        service: service,
        vehicles: _mkFleet(50),
      );

      final size = tester.getSize(find.byKey(const Key('renew-vehicle-list')));
      expect(size.height, lessThanOrEqualTo(280));
      expect(tester.takeException(), isNull);
    });

    testWidgets('500 vehicles — list stays bounded, no layout overflow', (
      tester,
    ) async {
      final service = _FakeService()..users = [_mkUser('u1', 'Alice')];
      await _pumpSheet(tester, service);
      await _selectUser(
        tester,
        userName: 'Alice',
        service: service,
        vehicles: _mkFleet(500),
      );

      final size = tester.getSize(find.byKey(const Key('renew-vehicle-list')));
      expect(size.height, lessThanOrEqualTo(280));
      expect(tester.takeException(), isNull);
    });

    testWidgets(
        'Amount Override field always findable regardless of fleet size',
        (tester) async {
      final service = _FakeService()..users = [_mkUser('u1', 'Alice')];
      await _pumpSheet(tester, service);
      await _selectUser(
        tester,
        userName: 'Alice',
        service: service,
        vehicles: _mkFleet(500),
      );

      // All lower-form fields must be in the widget tree (not pushed out).
      expect(find.text('Amount Override'), findsOneWidget);
      expect(find.text('Reference (optional)'), findsOneWidget);
      expect(find.text('Payment Mode'), findsOneWidget);
    });
  });

  // ── Search ────────────────────────────────────────────────────────────────

  group('search', () {
    testWidgets('matching vehicles shown, non-matching hidden', (tester) async {
      final service = _FakeService()..users = [_mkUser('u1', 'Alice')];
      await _pumpSheet(tester, service);
      await _selectUser(
        tester,
        userName: 'Alice',
        service: service,
        vehicles: [
          _mkVehicle('v1', name: 'Truck Alpha'),
          _mkVehicle('v2', name: 'Car Beta'),
        ],
      );

      await tester.enterText(find.byType(TextField).first, 'truck');
      await tester.pump();

      expect(find.text('Truck Alpha'), findsOneWidget);
      expect(find.text('Car Beta'), findsNothing);
    });

    testWidgets('clearing search restores all vehicles', (tester) async {
      final service = _FakeService()..users = [_mkUser('u1', 'Alice')];
      await _pumpSheet(tester, service);
      await _selectUser(
        tester,
        userName: 'Alice',
        service: service,
        vehicles: [
          _mkVehicle('v1', name: 'Truck Alpha'),
          _mkVehicle('v2', name: 'Car Beta'),
        ],
      );

      await tester.enterText(find.byType(TextField).first, 'truck');
      await tester.pump();
      await tester.enterText(find.byType(TextField).first, '');
      await tester.pump();

      expect(find.text('Truck Alpha'), findsOneWidget);
      expect(find.text('Car Beta'), findsOneWidget);
    });
  });

  // ── Select / deselect all filtered ────────────────────────────────────────

  group('select / deselect all filtered', () {
    testWidgets('"Select all filtered" absent for single vehicle', (
      tester,
    ) async {
      final service = _FakeService()..users = [_mkUser('u1', 'Alice')];
      await _pumpSheet(tester, service);
      await _selectUser(
        tester,
        userName: 'Alice',
        service: service,
        vehicles: [_mkVehicle('v1', name: 'Solo Truck')],
      );

      expect(find.text('Select all filtered'), findsNothing);
    });

    testWidgets('"Select all filtered" present for two+ vehicles', (
      tester,
    ) async {
      final service = _FakeService()..users = [_mkUser('u1', 'Alice')];
      await _pumpSheet(tester, service);
      await _selectUser(
        tester,
        userName: 'Alice',
        service: service,
        vehicles: _mkFleet(3),
      );

      expect(find.text('Select all filtered'), findsOneWidget);
    });

    testWidgets('tapping "Select all filtered" selects all and shows count', (
      tester,
    ) async {
      final service = _FakeService()..users = [_mkUser('u1', 'Alice')];
      await _pumpSheet(tester, service);
      await _selectUser(
        tester,
        userName: 'Alice',
        service: service,
        vehicles: _mkFleet(3),
      );

      await tester.tap(find.text('Select all filtered'));
      await tester.pump();

      expect(find.text('Deselect all filtered'), findsOneWidget);
      expect(find.text('3 vehicles selected'), findsOneWidget);
    });

    testWidgets('"Deselect all filtered" clears selection', (tester) async {
      final service = _FakeService()..users = [_mkUser('u1', 'Alice')];
      await _pumpSheet(tester, service);
      await _selectUser(
        tester,
        userName: 'Alice',
        service: service,
        vehicles: _mkFleet(3),
      );

      await tester.tap(find.text('Select all filtered'));
      await tester.pump();
      await tester.tap(find.text('Deselect all filtered'));
      await tester.pump();

      expect(find.text('Select all filtered'), findsOneWidget);
      expect(find.textContaining('selected'), findsNothing);
    });

    testWidgets('select-all respects active search filter', (tester) async {
      final service = _FakeService()..users = [_mkUser('u1', 'Alice')];
      await _pumpSheet(tester, service);
      await _selectUser(
        tester,
        userName: 'Alice',
        service: service,
        vehicles: [
          _mkVehicle('v1', name: 'Truck Alpha'),
          _mkVehicle('v2', name: 'Truck Beta'),
          _mkVehicle('v3', name: 'Car Gamma'),
        ],
      );

      // Filter to only 2 trucks.
      await tester.enterText(find.byType(TextField).first, 'truck');
      await tester.pump();

      await tester.tap(find.text('Select all filtered'));
      await tester.pump();

      // Only 2 out of 3 vehicles match, so count should be 2.
      expect(find.text('2 vehicles selected'), findsOneWidget);
    });
  });

  // ── Selected count summary ────────────────────────────────────────────────

  group('selected count summary', () {
    testWidgets('singular label for exactly one vehicle selected', (
      tester,
    ) async {
      final service = _FakeService()..users = [_mkUser('u1', 'Alice')];
      await _pumpSheet(tester, service);
      await _selectUser(
        tester,
        userName: 'Alice',
        service: service,
        vehicles: [
          _mkVehicle('v1', name: 'Truck A'),
          _mkVehicle('v2', name: 'Truck B'),
        ],
      );

      await tester.tap(find.text('Truck A'));
      await tester.pump();

      expect(find.text('1 vehicle selected'), findsOneWidget);
    });

    testWidgets('plural label for two or more vehicles selected', (
      tester,
    ) async {
      final service = _FakeService()..users = [_mkUser('u1', 'Alice')];
      await _pumpSheet(tester, service);
      await _selectUser(
        tester,
        userName: 'Alice',
        service: service,
        vehicles: _mkFleet(4),
      );

      await tester.tap(find.text('Select all filtered'));
      await tester.pump();

      expect(find.text('4 vehicles selected'), findsOneWidget);
    });

    testWidgets('summary absent when nothing selected', (tester) async {
      final service = _FakeService()..users = [_mkUser('u1', 'Alice')];
      await _pumpSheet(tester, service);
      await _selectUser(
        tester,
        userName: 'Alice',
        service: service,
        vehicles: _mkFleet(3),
      );

      expect(find.textContaining('selected'), findsNothing);
    });
  });

  // ── Auto total ────────────────────────────────────────────────────────────

  group('auto total', () {
    testWidgets('total reflects sum of all selected vehicles', (tester) async {
      final service = _FakeService()..users = [_mkUser('u1', 'Alice')];
      await _pumpSheet(tester, service);
      await _selectUser(
        tester,
        userName: 'Alice',
        service: service,
        vehicles: [
          _mkVehicle('v1', name: 'Truck A', price: 300),
          _mkVehicle('v2', name: 'Truck B', price: 700),
        ],
      );

      // Use 'Select all filtered' (tested separately) to select both vehicles.
      await tester.tap(find.text('Select all filtered'));
      await tester.pump();

      // 300 + 700 = 1000.00
      expect(find.textContaining('1000.00'), findsOneWidget);
    });

    testWidgets('total drops to zero after deselecting all', (tester) async {
      final service = _FakeService()..users = [_mkUser('u1', 'Alice')];
      await _pumpSheet(tester, service);
      await _selectUser(
        tester,
        userName: 'Alice',
        service: service,
        vehicles: [
          _mkVehicle('v1', name: 'Truck A', price: 300),
          _mkVehicle('v2', name: 'Truck B', price: 700),
        ],
      );

      await tester.tap(find.text('Select all filtered'));
      await tester.pump();
      expect(find.textContaining('1000.00'), findsOneWidget);

      await tester.tap(find.text('Deselect all filtered'));
      await tester.pump();

      // After deselect: total = 0; no vehicles selected → currency defaults to USD.
      expect(find.textContaining('Auto Total: USD 0.00'), findsOneWidget);
    });
  });
}
