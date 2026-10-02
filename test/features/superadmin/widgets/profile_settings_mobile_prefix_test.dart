import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/shared/widgets/open_vts_searchable_dropdown.dart';

// ---------------------------------------------------------------------------
// Options built by _EditProfileSheetState._buildPrefixOptions():
//   value      = p.dialCode   (e.g. '+91')
//   label      = p.dialCode
//   subtitle   = p.countryCode (e.g. 'IN')
//   searchText = '${p.dialCode} ${p.countryCode}'
// ---------------------------------------------------------------------------

const _prefixOptions = [
  OpenVtsDropdownOption<String>(
    value: '+91',
    label: '+91',
    subtitle: 'IN',
    searchText: '+91 IN',
  ),
  OpenVtsDropdownOption<String>(
    value: '+1',
    label: '+1',
    subtitle: 'US',
    searchText: '+1 US',
  ),
  OpenVtsDropdownOption<String>(
    value: '+44',
    label: '+44',
    subtitle: 'GB',
    searchText: '+44 GB',
  ),
  OpenVtsDropdownOption<String>(
    value: '+971',
    label: '+971',
    subtitle: 'AE',
    searchText: '+971 AE',
  ),
];

// Stateful host that mirrors how _EditProfileSheetState owns _mobilePrefix.
class _PrefixHost extends StatefulWidget {
  const _PrefixHost({this.initialValue, this.onChanged});

  final String? initialValue;
  final ValueChanged<String?>? onChanged;

  @override
  State<_PrefixHost> createState() => _PrefixHostState();
}

class _PrefixHostState extends State<_PrefixHost> {
  late String? _value = widget.initialValue;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: OpenVtsSearchableDropdown<String>(
            label: 'Prefix',
            hintText: 'Select',
            searchHintText: 'Dial code or country',
            sheetTitle: 'Select Mobile Prefix',
            options: _prefixOptions,
            value: _value,
            onChanged: (v) {
              setState(() => _value = v);
              widget.onChanged?.call(v);
            },
          ),
        ),
      ),
    );
  }
}

// Scopes text search to the picker BottomSheet only.
Finder _inPicker(String text) => find.descendant(
      of: find.byType(BottomSheet),
      matching: find.text(text),
    );

Finder _searchField() => find.widgetWithText(TextField, 'Dial code or country');

void main() {
  group('profile settings — mobile prefix field type', () {
    testWidgets('uses OpenVtsSearchableDropdown not DropdownButton', (
      tester,
    ) async {
      await tester.pumpWidget(const _PrefixHost());
      await tester.pumpAndSettle();

      expect(find.byType(OpenVtsSearchableDropdown<String>), findsOneWidget);
      expect(find.byType(DropdownButton<String>), findsNothing);
    });

    testWidgets('shows "Select" hint when nothing is selected', (tester) async {
      await tester.pumpWidget(const _PrefixHost());
      await tester.pumpAndSettle();

      expect(find.text('Select'), findsOneWidget);
    });

    testWidgets('shows pre-selected dial code in trigger', (tester) async {
      await tester.pumpWidget(const _PrefixHost(initialValue: '+91'));
      await tester.pumpAndSettle();

      expect(find.text('+91'), findsOneWidget);
    });
  });

  group('profile settings — prefix picker sheet', () {
    testWidgets('picker has the correct search hint text', (tester) async {
      await tester.pumpWidget(const _PrefixHost());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Select'));
      await tester.pumpAndSettle();

      expect(_searchField(), findsOneWidget);
    });

    testWidgets('picker shows all prefix options when opened', (tester) async {
      await tester.pumpWidget(const _PrefixHost());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Select'));
      await tester.pumpAndSettle();

      expect(_inPicker('+91'), findsOneWidget);
      expect(_inPicker('+1'), findsOneWidget);
      expect(_inPicker('+44'), findsOneWidget);
      expect(_inPicker('+971'), findsOneWidget);
    });
  });

  group('profile settings — prefix search by dial code', () {
    testWidgets('searching "91" shows +91 and hides others', (tester) async {
      await tester.pumpWidget(const _PrefixHost());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Select'));
      await tester.pumpAndSettle();

      await tester.enterText(_searchField(), '91');
      await tester.pump();

      expect(_inPicker('+91'), findsOneWidget);
      expect(_inPicker('+1'), findsNothing);
      expect(_inPicker('+44'), findsNothing);
    });

    testWidgets('searching "+44" shows only GB prefix', (tester) async {
      await tester.pumpWidget(const _PrefixHost());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Select'));
      await tester.pumpAndSettle();

      await tester.enterText(_searchField(), '+44');
      await tester.pump();

      // The search field itself contains "+44", so findsWidgets is correct.
      expect(_inPicker('+44'), findsWidgets);
      expect(_inPicker('+91'), findsNothing);
      expect(_inPicker('+1'), findsNothing);
    });
  });

  group('profile settings — prefix search by country code', () {
    testWidgets('searching "IN" shows +91', (tester) async {
      await tester.pumpWidget(const _PrefixHost());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Select'));
      await tester.pumpAndSettle();

      await tester.enterText(_searchField(), 'IN');
      await tester.pump();

      expect(_inPicker('+91'), findsOneWidget);
      expect(_inPicker('+1'), findsNothing);
    });

    testWidgets('searching "AE" shows +971', (tester) async {
      await tester.pumpWidget(const _PrefixHost());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Select'));
      await tester.pumpAndSettle();

      await tester.enterText(_searchField(), 'AE');
      await tester.pump();

      expect(_inPicker('+971'), findsOneWidget);
      expect(_inPicker('+91'), findsNothing);
      expect(_inPicker('+44'), findsNothing);
    });

    testWidgets('search is case-insensitive ("gb" → +44)', (tester) async {
      await tester.pumpWidget(const _PrefixHost());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Select'));
      await tester.pumpAndSettle();

      await tester.enterText(_searchField(), 'gb');
      await tester.pump();

      expect(_inPicker('+44'), findsOneWidget);
      expect(_inPicker('+91'), findsNothing);
    });
  });

  group('profile settings — prefix selection', () {
    testWidgets('tapping a row fires onChanged with the canonical dial code', (
      tester,
    ) async {
      String? selected;
      await tester.pumpWidget(
        _PrefixHost(onChanged: (v) => selected = v),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Select'));
      await tester.pumpAndSettle();

      await tester.tap(_inPicker('+91'));
      await tester.pumpAndSettle();

      expect(selected, '+91');
    });

    testWidgets('trigger shows selected dial code after selection', (
      tester,
    ) async {
      await tester.pumpWidget(const _PrefixHost());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Select'));
      await tester.pumpAndSettle();

      await tester.tap(_inPicker('+44'));
      await tester.pumpAndSettle();

      expect(find.text('+44'), findsWidgets);
    });

    testWidgets('search then select returns correct dial code', (tester) async {
      String? selected;
      await tester.pumpWidget(
        _PrefixHost(onChanged: (v) => selected = v),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Select'));
      await tester.pumpAndSettle();

      await tester.enterText(_searchField(), 'US');
      await tester.pump();

      await tester.tap(_inPicker('+1'));
      await tester.pumpAndSettle();

      expect(selected, '+1');
    });

    testWidgets('no-match query shows empty state without throwing', (
      tester,
    ) async {
      await tester.pumpWidget(const _PrefixHost());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Select'));
      await tester.pumpAndSettle();

      await tester.enterText(_searchField(), 'ZZZZ');
      await tester.pump();

      expect(_inPicker('+91'), findsNothing);
      expect(_inPicker('+1'), findsNothing);
      expect(tester.takeException(), isNull);
    });
  });
}
