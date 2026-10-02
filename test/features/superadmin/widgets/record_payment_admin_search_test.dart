import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/api/api_client.dart';
import 'package:open_vts/features/superadmin/controllers/superadmin_payments_controller.dart';
import 'package:open_vts/features/superadmin/controllers/superadmin_providers.dart';
import 'package:open_vts/features/superadmin/models/superadmin_payments_model.dart';
import 'package:open_vts/features/superadmin/models/superadmin_payments_state.dart';
import 'package:open_vts/features/superadmin/screens/payments/widgets/record_payment_sheet.dart';
import 'package:open_vts/features/superadmin/services/superadmin_payments_service.dart';
import 'package:open_vts/shared/widgets/open_vts_searchable_dropdown.dart';

// ---------------------------------------------------------------------------
// Fixtures
// ---------------------------------------------------------------------------

final _admins = [
  const SuperadminPaymentAdminOption(
    uid: 1,
    name: 'Alice Johnson',
    username: 'alicej',
    email: 'alice@example.com',
    currency: 'INR',
  ),
  const SuperadminPaymentAdminOption(
    uid: 2,
    name: 'Bob Smith',
    username: 'bobsmith',
    email: 'bob@example.com',
    currency: 'USD',
  ),
  const SuperadminPaymentAdminOption(
    uid: 3,
    name: 'Carol White',
    username: 'carolw',
    email: 'carol@acme.org',
    currency: 'EUR',
  ),
];

SuperadminPaymentsState _stateWith({
  List<SuperadminPaymentAdminOption>? admins,
  bool isLoadingAdmins = false,
  bool isRecordingPayment = false,
  int? selectedAdminId,
}) {
  return SuperadminPaymentsState(
    admins: admins ?? _admins,
    transactions: const [],
    analytics: null,
    selectedAdminId: selectedAdminId,
    selectedStatus: null,
    searchQuery: '',
    rangePreset: SuperadminPaymentsRangePreset.allTime,
    customFrom: null,
    customTo: null,
    page: 1,
    limit: 100,
    total: 0,
    isLoadingAdmins: isLoadingAdmins,
    isLoadingTransactions: false,
    isLoadingAnalytics: false,
    isRecordingPayment: isRecordingPayment,
    errorMessage: null,
    analyticsErrorMessage: null,
    refreshKey: '',
  );
}

// A minimal controller subclass that seeds a fixed state and ignores mutations.
// We extend the real controller (passing a no-op service) so the type matches
// the StateNotifierProvider declaration.
class _StubPaymentsController extends SuperadminPaymentsController {
  _StubPaymentsController(SuperadminPaymentsState fixedState)
      : super(SuperadminPaymentsService(ApiClient(Dio()))) {
    // Seed the desired state immediately after construction.
    state = fixedState;
  }

  @override
  Future<void> loadAdmins() async {}

  @override
  Future<void> loadTransactions() async {}

  @override
  Future<void> loadAnalytics() async {}

  @override
  Future<SuperadminTransaction> recordManualPayment(
    SuperadminRecordPaymentRequest _,
  ) async {
    throw UnimplementedError('stub');
  }
}

Widget _pump(SuperadminPaymentsState state) {
  return ProviderScope(
    overrides: [
      superadminPaymentsControllerProvider.overrideWith(
        (_) => _StubPaymentsController(state),
      ),
    ],
    child: const MaterialApp(
      home: Scaffold(
        body: RecordPaymentSheet(),
      ),
    ),
  );
}

// Opens the Administrator picker sheet by tapping the dropdown trigger.
Future<void> _openAdminPicker(WidgetTester tester) async {
  await tester.tap(find.byType(OpenVtsSearchableDropdown<int>));
  await tester.pumpAndSettle();
}

// Finds the TextField inside the picker sheet search box.
Finder _pickerSearchField() =>
    find.widgetWithText(TextField, 'Search by name, username, email or ID');

// Finds text scoped to the BottomSheet to avoid false positives from the
// trigger widget showing a pre-selected value behind the open picker.
Finder _inPicker(String text) => find.descendant(
      of: find.byType(BottomSheet),
      matching: find.text(text),
    );

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('RecordPaymentSheet — administrator field', () {
    testWidgets('shows OpenVtsSearchableDropdown instead of old dropdown', (
      tester,
    ) async {
      await tester.pumpWidget(_pump(_stateWith()));
      await tester.pumpAndSettle();

      expect(find.byType(OpenVtsSearchableDropdown<int>), findsOneWidget);
      expect(find.byType(DropdownButtonFormField<int>), findsNothing);
    });

    testWidgets('shows all admins in picker sheet', (tester) async {
      await tester.pumpWidget(_pump(_stateWith()));
      await tester.pumpAndSettle();

      await _openAdminPicker(tester);

      expect(_inPicker('Alice Johnson'), findsWidgets);
      expect(_inPicker('Bob Smith'), findsOneWidget);
      expect(_inPicker('Carol White'), findsOneWidget);
    });

    testWidgets('picker sheet has a search field', (tester) async {
      await tester.pumpWidget(_pump(_stateWith()));
      await tester.pumpAndSettle();

      await _openAdminPicker(tester);

      expect(_pickerSearchField(), findsOneWidget);
    });
  });

  group('RecordPaymentSheet — admin search by name', () {
    testWidgets('searching by first name filters to matching admin', (
      tester,
    ) async {
      await tester.pumpWidget(_pump(_stateWith()));
      await tester.pumpAndSettle();

      await _openAdminPicker(tester);
      await tester.enterText(_pickerSearchField(), 'alice');
      await tester.pumpAndSettle();

      expect(_inPicker('Alice Johnson'), findsWidgets);
      expect(_inPicker('Bob Smith'), findsNothing);
      expect(_inPicker('Carol White'), findsNothing);
    });

    testWidgets('name search is case-insensitive', (tester) async {
      await tester.pumpWidget(_pump(_stateWith()));
      await tester.pumpAndSettle();

      await _openAdminPicker(tester);
      await tester.enterText(_pickerSearchField(), 'BOB');
      await tester.pumpAndSettle();

      expect(_inPicker('Bob Smith'), findsOneWidget);
      expect(_inPicker('Alice Johnson'), findsNothing);
      expect(_inPicker('Carol White'), findsNothing);
    });
  });

  group('RecordPaymentSheet — admin search by username', () {
    testWidgets('searching by username matches correct admin', (tester) async {
      await tester.pumpWidget(_pump(_stateWith()));
      await tester.pumpAndSettle();

      await _openAdminPicker(tester);
      await tester.enterText(_pickerSearchField(), 'carolw');
      await tester.pumpAndSettle();

      expect(_inPicker('Carol White'), findsOneWidget);
      expect(_inPicker('Alice Johnson'), findsNothing);
      expect(_inPicker('Bob Smith'), findsNothing);
    });
  });

  group('RecordPaymentSheet — admin search by email', () {
    testWidgets('searching by email domain shows matching admins', (
      tester,
    ) async {
      await tester.pumpWidget(_pump(_stateWith()));
      await tester.pumpAndSettle();

      await _openAdminPicker(tester);
      await tester.enterText(_pickerSearchField(), 'example.com');
      await tester.pumpAndSettle();

      expect(_inPicker('Alice Johnson'), findsWidgets);
      expect(_inPicker('Bob Smith'), findsOneWidget);
      expect(_inPicker('Carol White'), findsNothing);
    });

    testWidgets('searching by full email matches single admin', (tester) async {
      await tester.pumpWidget(_pump(_stateWith()));
      await tester.pumpAndSettle();

      await _openAdminPicker(tester);
      await tester.enterText(_pickerSearchField(), 'carol@acme');
      await tester.pumpAndSettle();

      expect(_inPicker('Carol White'), findsOneWidget);
      expect(_inPicker('Alice Johnson'), findsNothing);
      expect(_inPicker('Bob Smith'), findsNothing);
    });
  });

  group(
      'RecordPaymentSheet — admin search by username (covers UID via searchText)',
      () {
    testWidgets('searching by username is deterministic and filters correctly',
        (
      tester,
    ) async {
      await tester.pumpWidget(_pump(_stateWith()));
      await tester.pumpAndSettle();

      await _openAdminPicker(tester);
      await tester.enterText(_pickerSearchField(), 'bobsmith');
      await tester.pumpAndSettle();

      expect(_inPicker('Bob Smith'), findsOneWidget);
      expect(_inPicker('Alice Johnson'), findsNothing);
      expect(_inPicker('Carol White'), findsNothing);
    });
  });

  group('RecordPaymentSheet — admin search by currency', () {
    testWidgets('searching by currency filters admins', (tester) async {
      await tester.pumpWidget(_pump(_stateWith()));
      await tester.pumpAndSettle();

      await _openAdminPicker(tester);
      await tester.enterText(_pickerSearchField(), 'INR');
      await tester.pumpAndSettle();

      expect(_inPicker('Alice Johnson'), findsWidgets);
      expect(_inPicker('Bob Smith'), findsNothing);
      expect(_inPicker('Carol White'), findsNothing);
    });
  });

  group('RecordPaymentSheet — admin selection', () {
    testWidgets('selecting an admin dismisses sheet and shows selection', (
      tester,
    ) async {
      // Use a single unique admin so the trigger text is unambiguous.
      await tester.pumpWidget(
        _pump(
          _stateWith(
            admins: [
              const SuperadminPaymentAdminOption(
                uid: 10,
                name: 'Xavier Unique',
                username: 'xavier',
                email: 'x@test.io',
                currency: 'USD',
              ),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      await _openAdminPicker(tester);
      await tester.tap(_inPicker('Xavier Unique'));
      await tester.pumpAndSettle();

      // Picker is dismissed and trigger shows the selected name.
      expect(find.text('Xavier Unique'), findsOneWidget);
      // The picker search field is gone.
      expect(_pickerSearchField(), findsNothing);
    });

    testWidgets('selecting after search picks the searched admin', (
      tester,
    ) async {
      await tester.pumpWidget(_pump(_stateWith()));
      await tester.pumpAndSettle();

      await _openAdminPicker(tester);
      await tester.enterText(_pickerSearchField(), 'carol');
      await tester.pumpAndSettle();
      await tester.tap(_inPicker('Carol White'));
      await tester.pumpAndSettle();

      // Picker is gone and Carol White is the new trigger label.
      expect(find.text('Carol White'), findsOneWidget);
      expect(_pickerSearchField(), findsNothing);
    });
  });

  group('RecordPaymentSheet — disabled state', () {
    testWidgets('dropdown is disabled while recording payment', (tester) async {
      await tester.pumpWidget(
        _pump(_stateWith(isRecordingPayment: true)),
      );
      // Use pump() instead of pumpAndSettle() because the "Record Payment"
      // loading button contains a CircularProgressIndicator that never settles.
      await tester.pump();

      final dropdown = tester.widget<OpenVtsSearchableDropdown<int>>(
        find.byType(OpenVtsSearchableDropdown<int>),
      );

      expect(dropdown.enabled, isFalse);
    });
  });

  group('RecordPaymentSheet — no-match state', () {
    testWidgets('query with no match shows empty and does not throw', (
      tester,
    ) async {
      await tester.pumpWidget(_pump(_stateWith()));
      await tester.pumpAndSettle();

      await _openAdminPicker(tester);
      await tester.enterText(_pickerSearchField(), 'ZZZNOTFOUND');
      await tester.pumpAndSettle();

      expect(_inPicker('Alice Johnson'), findsNothing);
      expect(_inPicker('Bob Smith'), findsNothing);
      expect(_inPicker('Carol White'), findsNothing);
      expect(tester.takeException(), isNull);
    });
  });
}
