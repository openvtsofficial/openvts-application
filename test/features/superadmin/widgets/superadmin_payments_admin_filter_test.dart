import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/features/superadmin/models/superadmin_payments_model.dart';
import 'package:open_vts/features/superadmin/models/superadmin_payments_state.dart';
import 'package:open_vts/features/superadmin/screens/payments/widgets/superadmin_payments_filters_card.dart';
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
  int? selectedAdminId,
  bool isLoadingAdmins = false,
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
    isRecordingPayment: false,
    errorMessage: null,
    analyticsErrorMessage: null,
    refreshKey: '',
  );
}

Widget _pump(
  SuperadminPaymentsState state, {
  ValueChanged<String?>? onAdminChanged,
}) {
  return MaterialApp(
    home: Scaffold(
      body: SingleChildScrollView(
        child: SuperadminPaymentsFiltersCard(
          state: state,
          onAdminChanged: onAdminChanged ?? (_) {},
          onRangePresetChanged: (_) {},
          onCustomRangeChanged: (_, __) {},
          onSearchChanged: (_) {},
          onStatusChanged: (_) {},
          onClearFilters: () {},
        ),
      ),
    ),
  );
}

// Expands the Advanced Filters collapsible section.
Future<void> _expandFilters(WidgetTester tester) async {
  await tester.tap(find.text('Advanced Filters'));
  await tester.pumpAndSettle();
}

// Opens the Administrator picker sheet.
Future<void> _openAdminPicker(WidgetTester tester) async {
  await tester.tap(find.byType(OpenVtsSearchableDropdown<int>));
  await tester.pumpAndSettle();
}

// Finds the TextField inside the picker sheet search box.
Finder _pickerSearchField() =>
    find.widgetWithText(TextField, 'Search by name, username, email or ID');

// Finds text scoped to the BottomSheet to avoid false positives from the
// trigger widget showing a pre-selected value.
Finder _inPicker(String text) => find.descendant(
      of: find.byType(BottomSheet),
      matching: find.text(text),
    );

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('SuperadminPaymentsFiltersCard — admin filter field', () {
    testWidgets('filter section is collapsed by default', (tester) async {
      await tester.pumpWidget(_pump(_stateWith()));
      await tester.pumpAndSettle();

      expect(find.byType(OpenVtsSearchableDropdown<int>), findsNothing);
    });

    testWidgets('expanding section shows the Administrator dropdown', (
      tester,
    ) async {
      await tester.pumpWidget(_pump(_stateWith()));
      await tester.pumpAndSettle();

      await _expandFilters(tester);

      expect(find.byType(OpenVtsSearchableDropdown<int>), findsOneWidget);
    });

    testWidgets('uses OpenVtsSearchableDropdown instead of old dropdown', (
      tester,
    ) async {
      await tester.pumpWidget(_pump(_stateWith()));
      await tester.pumpAndSettle();

      await _expandFilters(tester);

      expect(find.byType(OpenVtsSearchableDropdown<int>), findsOneWidget);
      expect(find.byType(DropdownButtonFormField<int?>), findsNothing);
    });

    testWidgets('shows hint text "All Admins" when no admin is selected', (
      tester,
    ) async {
      await tester.pumpWidget(_pump(_stateWith()));
      await tester.pumpAndSettle();

      await _expandFilters(tester);

      expect(find.text('All Admins'), findsOneWidget);
    });
  });

  group('SuperadminPaymentsFiltersCard — admin picker content', () {
    testWidgets('picker shows all loaded admins', (tester) async {
      await tester.pumpWidget(_pump(_stateWith()));
      await tester.pumpAndSettle();

      await _expandFilters(tester);
      await _openAdminPicker(tester);

      expect(_inPicker('Alice Johnson'), findsOneWidget);
      expect(_inPicker('Bob Smith'), findsOneWidget);
      expect(_inPicker('Carol White'), findsOneWidget);
    });

    testWidgets('picker has a search field', (tester) async {
      await tester.pumpWidget(_pump(_stateWith()));
      await tester.pumpAndSettle();

      await _expandFilters(tester);
      await _openAdminPicker(tester);

      expect(_pickerSearchField(), findsOneWidget);
    });
  });

  group('SuperadminPaymentsFiltersCard — admin search by name', () {
    testWidgets('searching by first name filters to matching admin', (
      tester,
    ) async {
      await tester.pumpWidget(_pump(_stateWith()));
      await tester.pumpAndSettle();

      await _expandFilters(tester);
      await _openAdminPicker(tester);
      await tester.enterText(_pickerSearchField(), 'alice');
      await tester.pumpAndSettle();

      expect(_inPicker('Alice Johnson'), findsOneWidget);
      expect(_inPicker('Bob Smith'), findsNothing);
      expect(_inPicker('Carol White'), findsNothing);
    });

    testWidgets('name search is case-insensitive', (tester) async {
      await tester.pumpWidget(_pump(_stateWith()));
      await tester.pumpAndSettle();

      await _expandFilters(tester);
      await _openAdminPicker(tester);
      await tester.enterText(_pickerSearchField(), 'BOB');
      await tester.pumpAndSettle();

      expect(_inPicker('Bob Smith'), findsOneWidget);
      expect(_inPicker('Alice Johnson'), findsNothing);
      expect(_inPicker('Carol White'), findsNothing);
    });
  });

  group('SuperadminPaymentsFiltersCard — admin search by username', () {
    testWidgets('searching by username matches correct admin', (tester) async {
      await tester.pumpWidget(_pump(_stateWith()));
      await tester.pumpAndSettle();

      await _expandFilters(tester);
      await _openAdminPicker(tester);
      await tester.enterText(_pickerSearchField(), 'carolw');
      await tester.pumpAndSettle();

      expect(_inPicker('Carol White'), findsOneWidget);
      expect(_inPicker('Alice Johnson'), findsNothing);
      expect(_inPicker('Bob Smith'), findsNothing);
    });
  });

  group('SuperadminPaymentsFiltersCard — admin search by email', () {
    testWidgets('searching by email domain shows matching admins', (
      tester,
    ) async {
      await tester.pumpWidget(_pump(_stateWith()));
      await tester.pumpAndSettle();

      await _expandFilters(tester);
      await _openAdminPicker(tester);
      await tester.enterText(_pickerSearchField(), 'example.com');
      await tester.pumpAndSettle();

      expect(_inPicker('Alice Johnson'), findsOneWidget);
      expect(_inPicker('Bob Smith'), findsOneWidget);
      expect(_inPicker('Carol White'), findsNothing);
    });

    testWidgets('searching by full email matches single admin', (tester) async {
      await tester.pumpWidget(_pump(_stateWith()));
      await tester.pumpAndSettle();

      await _expandFilters(tester);
      await _openAdminPicker(tester);
      await tester.enterText(_pickerSearchField(), 'carol@acme');
      await tester.pumpAndSettle();

      expect(_inPicker('Carol White'), findsOneWidget);
      expect(_inPicker('Alice Johnson'), findsNothing);
      expect(_inPicker('Bob Smith'), findsNothing);
    });
  });

  group('SuperadminPaymentsFiltersCard — admin search by UID', () {
    testWidgets('searching by admin UID matches single admin', (tester) async {
      await tester.pumpWidget(_pump(_stateWith()));
      await tester.pumpAndSettle();

      await _expandFilters(tester);
      await _openAdminPicker(tester);
      await tester.enterText(_pickerSearchField(), '3');
      await tester.pumpAndSettle();

      expect(_inPicker('Carol White'), findsOneWidget);
    });
  });

  group('SuperadminPaymentsFiltersCard — admin selection', () {
    testWidgets('selecting admin dismisses picker and calls onAdminChanged', (
      tester,
    ) async {
      String? captured;
      await tester.pumpWidget(
        _pump(_stateWith(), onAdminChanged: (v) => captured = v),
      );
      await tester.pumpAndSettle();

      await _expandFilters(tester);
      await _openAdminPicker(tester);
      await tester.tap(_inPicker('Bob Smith'));
      await tester.pumpAndSettle();

      expect(captured, '2');
      expect(_pickerSearchField(), findsNothing);
    });

    testWidgets('selecting after search picks the searched admin', (
      tester,
    ) async {
      String? captured;
      await tester.pumpWidget(
        _pump(_stateWith(), onAdminChanged: (v) => captured = v),
      );
      await tester.pumpAndSettle();

      await _expandFilters(tester);
      await _openAdminPicker(tester);
      await tester.enterText(_pickerSearchField(), 'carol');
      await tester.pumpAndSettle();
      await tester.tap(_inPicker('Carol White'));
      await tester.pumpAndSettle();

      expect(captured, '3');
      expect(_pickerSearchField(), findsNothing);
    });
  });

  group('SuperadminPaymentsFiltersCard — clearing back to All Admins', () {
    testWidgets(
      'clearing selection from pre-selected admin calls onAdminChanged(null)',
      (tester) async {
        final capturedValues = <String?>[];
        // Start with admin 2 selected so the dropdown shows a value and exposes
        // the clear affordance inside the picker sheet.
        await tester.pumpWidget(
          _pump(
            _stateWith(selectedAdminId: 2),
            onAdminChanged: capturedValues.add,
          ),
        );
        await tester.pumpAndSettle();

        await _expandFilters(tester);

        // Trigger widget should display the selected admin's name.
        expect(find.text('Bob Smith'), findsOneWidget);

        await _openAdminPicker(tester);

        // Tap the "Clear" TextButton in the picker header (shown when a value
        // is selected).
        final clearButton = find.descendant(
          of: find.byType(BottomSheet),
          matching: find.text('Clear'),
        );
        await tester.tap(clearButton);
        await tester.pumpAndSettle();

        expect(capturedValues.last, isNull);
        expect(_pickerSearchField(), findsNothing);
      },
    );
  });

  group('SuperadminPaymentsFiltersCard — no-match state', () {
    testWidgets('query with no match shows empty without throwing', (
      tester,
    ) async {
      await tester.pumpWidget(_pump(_stateWith()));
      await tester.pumpAndSettle();

      await _expandFilters(tester);
      await _openAdminPicker(tester);
      await tester.enterText(_pickerSearchField(), 'ZZZNOTFOUND');
      await tester.pumpAndSettle();

      expect(_inPicker('Alice Johnson'), findsNothing);
      expect(_inPicker('Bob Smith'), findsNothing);
      expect(_inPicker('Carol White'), findsNothing);
      expect(tester.takeException(), isNull);
    });
  });

  group('SuperadminPaymentsFiltersCard — phantom admin', () {
    testWidgets('shows placeholder entry when selectedAdminId not in list', (
      tester,
    ) async {
      // selectedAdminId 99 is not in _admins — phantom entry must be created.
      await tester.pumpWidget(_pump(_stateWith(selectedAdminId: 99)));
      await tester.pumpAndSettle();

      await _expandFilters(tester);

      expect(find.text('Admin #99'), findsOneWidget);
    });
  });
}
