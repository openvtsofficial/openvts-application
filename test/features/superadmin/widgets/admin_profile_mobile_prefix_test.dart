import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/shared/widgets/open_vts_searchable_dropdown.dart';

// ---------------------------------------------------------------------------
// Sample prefix options mirroring SuperadminMobilePrefixOption → OpenVtsDropdownOption
// ---------------------------------------------------------------------------

final _prefixOptions = [
  const OpenVtsDropdownOption<String>(
    value: '+91',
    label: '+91',
    subtitle: 'IN',
    searchText: '+91 IN',
  ),
  const OpenVtsDropdownOption<String>(
    value: '+1',
    label: '+1',
    subtitle: 'US',
    searchText: '+1 US',
  ),
  const OpenVtsDropdownOption<String>(
    value: '+44',
    label: '+44',
    subtitle: 'GB',
    searchText: '+44 GB',
  ),
  const OpenVtsDropdownOption<String>(
    value: '+971',
    label: '+971',
    subtitle: 'AE',
    searchText: '+971 AE',
  ),
];

Widget _wrap(Widget child, {bool dark = false}) => MaterialApp(
      theme: dark ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: child,
        ),
      ),
    );

class _TestPrefixDropdown extends StatefulWidget {
  const _TestPrefixDropdown({this.initialValue, this.onChanged});

  final String? initialValue;
  final ValueChanged<String?>? onChanged;

  @override
  State<_TestPrefixDropdown> createState() => _TestPrefixDropdownState();
}

class _TestPrefixDropdownState extends State<_TestPrefixDropdown> {
  late String? _value = widget.initialValue;

  @override
  Widget build(BuildContext context) {
    return _wrap(
      OpenVtsSearchableDropdown<String>(
        label: 'Prefix',
        hintText: 'Select',
        searchHintText: 'Search dial code or country',
        sheetTitle: 'Mobile Prefix',
        value: _value,
        options: _prefixOptions,
        onChanged: (v) {
          setState(() => _value = v);
          widget.onChanged?.call(v);
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------

void main() {
  // -------------------------------------------------------------------------
  // Trigger renders
  // -------------------------------------------------------------------------

  group('mobile prefix trigger — unselected', () {
    testWidgets('label "Prefix" is visible (light)', (tester) async {
      await tester.pumpWidget(
        _wrap(
          OpenVtsSearchableDropdown<String>(
            label: 'Prefix',
            hintText: 'Select',
            options: _prefixOptions,
            onChanged: (_) {},
          ),
        ),
      );
      expect(find.text('Prefix'), findsOneWidget);
    });

    testWidgets('hint text shown when nothing selected', (tester) async {
      await tester.pumpWidget(
        _wrap(
          OpenVtsSearchableDropdown<String>(
            label: 'Prefix',
            hintText: 'Select',
            options: _prefixOptions,
            onChanged: (_) {},
          ),
        ),
      );
      expect(find.text('Select'), findsOneWidget);
    });

    testWidgets('label "Prefix" is visible (dark)', (tester) async {
      await tester.pumpWidget(
        _wrap(
          OpenVtsSearchableDropdown<String>(
            label: 'Prefix',
            hintText: 'Select',
            options: _prefixOptions,
            onChanged: (_) {},
          ),
          dark: true,
        ),
      );
      expect(find.text('Prefix'), findsOneWidget);
    });
  });

  // -------------------------------------------------------------------------
  // Search by dial code (e.g. "91" → +91)
  // -------------------------------------------------------------------------

  group('search by dial code', () {
    testWidgets('searching "91" shows +91 and hides others', (tester) async {
      await tester.pumpWidget(const _TestPrefixDropdown());

      await tester.tap(find.text('Select'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), '91');
      await tester.pump();

      expect(find.text('+91'), findsOneWidget);
      expect(find.text('+1'), findsNothing);
      expect(find.text('+44'), findsNothing);
    });

    testWidgets('searching "+44" shows GB prefix', (tester) async {
      await tester.pumpWidget(const _TestPrefixDropdown());

      await tester.tap(find.text('Select'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), '+44');
      await tester.pump();

      // The text "+44" appears in the search field AND the list row.
      expect(find.text('+44'), findsWidgets);
      expect(find.text('+91'), findsNothing);
    });
  });

  // -------------------------------------------------------------------------
  // Search by country code (e.g. "IN" → +91)
  // -------------------------------------------------------------------------

  group('search by country code', () {
    testWidgets('searching "IN" shows +91 entry', (tester) async {
      await tester.pumpWidget(const _TestPrefixDropdown());

      await tester.tap(find.text('Select'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'IN');
      await tester.pump();

      expect(find.text('+91'), findsOneWidget);
      expect(find.text('+1'), findsNothing);
    });

    testWidgets('searching "US" shows +1 entry', (tester) async {
      await tester.pumpWidget(const _TestPrefixDropdown());

      await tester.tap(find.text('Select'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'US');
      await tester.pump();

      expect(find.text('+1'), findsOneWidget);
      expect(find.text('+91'), findsNothing);
    });

    testWidgets('search is case-insensitive (lowercase "gb" → +44)', (
      tester,
    ) async {
      await tester.pumpWidget(const _TestPrefixDropdown());

      await tester.tap(find.text('Select'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'gb');
      await tester.pump();

      expect(find.text('+44'), findsOneWidget);
      expect(find.text('+91'), findsNothing);
    });
  });

  // -------------------------------------------------------------------------
  // Selection updates value
  // -------------------------------------------------------------------------

  group('prefix selection', () {
    testWidgets('tapping a row fires onChanged with canonical dial code', (
      tester,
    ) async {
      String? selected;
      await tester.pumpWidget(
        _TestPrefixDropdown(onChanged: (v) => selected = v),
      );

      await tester.tap(find.text('Select'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('+91'));
      await tester.pumpAndSettle();

      expect(selected, '+91');
    });

    testWidgets('trigger shows selected dial code after selection', (
      tester,
    ) async {
      await tester.pumpWidget(const _TestPrefixDropdown());

      await tester.tap(find.text('Select'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('+91'));
      await tester.pumpAndSettle();

      // The trigger now shows the selected label.
      expect(find.text('+91'), findsWidgets);
    });

    testWidgets('searching and then selecting returns correct dial code', (
      tester,
    ) async {
      String? selected;
      await tester.pumpWidget(
        _TestPrefixDropdown(onChanged: (v) => selected = v),
      );

      await tester.tap(find.text('Select'));
      await tester.pumpAndSettle();

      // Search by country code, then select the filtered result.
      await tester.enterText(find.byType(TextField), 'AE');
      await tester.pump();

      await tester.tap(find.text('+971'));
      await tester.pumpAndSettle();

      expect(selected, '+971');
    });

    testWidgets('pre-selected value shown in trigger (dark)', (tester) async {
      await tester.pumpWidget(
        _wrap(
          OpenVtsSearchableDropdown<String>(
            label: 'Prefix',
            options: _prefixOptions,
            value: '+1',
            onChanged: (_) {},
          ),
          dark: true,
        ),
      );
      expect(find.text('+1'), findsOneWidget);
    });

    testWidgets('selecting a different prefix replaces previous selection', (
      tester,
    ) async {
      String? selected;
      await tester.pumpWidget(
        _TestPrefixDropdown(
          initialValue: '+1',
          onChanged: (v) => selected = v,
        ),
      );

      // Trigger shows current value — tap to open.
      await tester.tap(find.text('+1'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('+44'));
      await tester.pumpAndSettle();

      expect(selected, '+44');
    });
  });

  // -------------------------------------------------------------------------
  // Empty search state
  // -------------------------------------------------------------------------

  group('empty search', () {
    testWidgets('shows all prefixes when query is empty', (tester) async {
      await tester.pumpWidget(const _TestPrefixDropdown());

      await tester.tap(find.text('Select'));
      await tester.pumpAndSettle();

      // All four options should be visible without any query.
      expect(find.text('+91'), findsOneWidget);
      expect(find.text('+1'), findsOneWidget);
      expect(find.text('+44'), findsOneWidget);
      expect(find.text('+971'), findsOneWidget);
    });

    testWidgets('non-matching query shows empty state, not overflow', (
      tester,
    ) async {
      await tester.pumpWidget(const _TestPrefixDropdown());

      await tester.tap(find.text('Select'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'ZZZZ');
      await tester.pump();

      expect(find.text('+91'), findsNothing);
      expect(find.text('+1'), findsNothing);
      expect(tester.takeException(), isNull);
    });
  });
}
