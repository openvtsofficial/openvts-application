import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/shared/widgets/open_vts_searchable_dropdown.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/// Three realistic users covering empty-name, long-name, and normal cases.
final _users = [
  const OpenVtsDropdownOption<String>(
    value: 'u1',
    label: 'Alice Sharma',
    subtitle: 'alice@example.com • +91 98765 43210',
    searchText: 'alice sharma alicesharma alice@example.com +91 98765 43210',
  ),
  const OpenVtsDropdownOption<String>(
    value: 'u2',
    label: 'Bob',
    subtitle: 'bob@example.com',
    searchText: 'bob bob bob@example.com',
  ),
  const OpenVtsDropdownOption<String>(
    value: 'u3',
    label:
        'Verylongfirstname Verylonglastname With Extra Words That Should Truncate',
    subtitle: 'longname@example.com • +91 00000 00000',
    searchText:
        'verylongfirstname verylonglastname longname@example.com +91 00000 00000',
  ),
];

Widget _wrap(Widget child, {bool dark = false}) => MaterialApp(
      theme: dark ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: child,
        ),
      ),
    );

/// Stateful wrapper so selection callbacks can be tested.
class _TestDropdown extends StatefulWidget {
  const _TestDropdown({
    this.initialValue,
    this.onChanged,
  });

  final String? initialValue;
  final ValueChanged<String?>? onChanged;

  @override
  State<_TestDropdown> createState() => _TestDropdownState();
}

class _TestDropdownState extends State<_TestDropdown> {
  late String? _value = widget.initialValue;

  @override
  Widget build(BuildContext context) {
    return _wrap(
      OpenVtsSearchableDropdown<String>(
        label: 'User',
        hintText: 'Select user',
        searchHintText: 'Search by name, username or email…',
        sheetTitle: 'Select user',
        value: _value,
        options: _users,
        onChanged: (v) {
          setState(() => _value = v);
          widget.onChanged?.call(v);
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  // -------------------------------------------------------------------------
  // Trigger renders — label visible before any selection
  // -------------------------------------------------------------------------

  group('trigger — unselected state', () {
    testWidgets('label "User" is visible in light theme', (tester) async {
      await tester.pumpWidget(
        _wrap(
          OpenVtsSearchableDropdown<String>(
            label: 'User',
            hintText: 'Select user',
            options: _users,
            onChanged: (_) {},
          ),
        ),
      );
      expect(find.text('User'), findsOneWidget);
    });

    testWidgets('hint text is visible when nothing selected', (tester) async {
      await tester.pumpWidget(
        _wrap(
          OpenVtsSearchableDropdown<String>(
            label: 'User',
            hintText: 'Select user',
            options: _users,
            onChanged: (_) {},
          ),
        ),
      );
      expect(find.text('Select user'), findsOneWidget);
    });

    testWidgets('label "User" is visible in dark theme', (tester) async {
      await tester.pumpWidget(
        _wrap(
          OpenVtsSearchableDropdown<String>(
            label: 'User',
            hintText: 'Select user',
            options: _users,
            onChanged: (_) {},
          ),
          dark: true,
        ),
      );
      expect(find.text('User'), findsOneWidget);
    });
  });

  // -------------------------------------------------------------------------
  // Selected state — primary and secondary text
  // -------------------------------------------------------------------------

  group('selected state — primary and secondary text', () {
    testWidgets('selected user name shown as primary text (light)', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          OpenVtsSearchableDropdown<String>(
            label: 'User',
            hintText: 'Select user',
            options: _users,
            value: 'u1',
            onChanged: (_) {},
          ),
        ),
      );
      expect(find.text('Alice Sharma'), findsOneWidget);
    });

    testWidgets('selected user name shown as primary text (dark)', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          OpenVtsSearchableDropdown<String>(
            label: 'User',
            hintText: 'Select user',
            options: _users,
            value: 'u1',
            onChanged: (_) {},
          ),
          dark: true,
        ),
      );
      expect(find.text('Alice Sharma'), findsOneWidget);
    });

    testWidgets('subtitle (email • mobile) shown as secondary text (light)', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          OpenVtsSearchableDropdown<String>(
            label: 'User',
            hintText: 'Select user',
            options: _users,
            value: 'u1',
            onChanged: (_) {},
          ),
        ),
      );
      expect(
        find.text('alice@example.com • +91 98765 43210'),
        findsOneWidget,
      );
    });

    testWidgets('subtitle (email • mobile) shown as secondary text (dark)', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          OpenVtsSearchableDropdown<String>(
            label: 'User',
            hintText: 'Select user',
            options: _users,
            value: 'u1',
            onChanged: (_) {},
          ),
          dark: true,
        ),
      );
      expect(
        find.text('alice@example.com • +91 98765 43210'),
        findsOneWidget,
      );
    });

    testWidgets('subtitle uses theme-driven color (not fixed black/grey)', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          OpenVtsSearchableDropdown<String>(
            label: 'User',
            hintText: 'Select user',
            options: _users,
            value: 'u1',
            onChanged: (_) {},
          ),
        ),
      );
      final subtitleFinder = find.text('alice@example.com • +91 98765 43210');
      expect(subtitleFinder, findsOneWidget);
      final subtitleWidget = tester.widget<Text>(subtitleFinder);
      final color = subtitleWidget.style?.color;
      // The shared component uses colorScheme.onSurfaceVariant — never a
      // hard-coded constant like Colors.black or Colors.grey.
      expect(color, isNot(equals(Colors.black)));
      expect(color, isNot(equals(Colors.grey)));
    });
  });

  // -------------------------------------------------------------------------
  // User selection callback
  // -------------------------------------------------------------------------

  group('user selection', () {
    testWidgets('tapping an option fires onChanged with correct user ID', (
      tester,
    ) async {
      String? selected;
      await tester.pumpWidget(
        _TestDropdown(onChanged: (v) => selected = v),
      );

      // Open the sheet by tapping the visible hint text inside the InkWell.
      await tester.tap(find.text('Select user'));
      await tester.pumpAndSettle();

      // The sheet lists all users — tap Alice (only one "Alice Sharma" widget
      // is in the tree while the trigger shows the hint, not a name).
      await tester.tap(find.text('Alice Sharma'));
      await tester.pumpAndSettle();

      expect(selected, 'u1');
    });

    testWidgets('trigger shows selected user name after selection', (
      tester,
    ) async {
      await tester.pumpWidget(const _TestDropdown());

      await tester.tap(find.text('Select user'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Bob'));
      await tester.pumpAndSettle();

      // After the sheet closes, the trigger must display the chosen name.
      expect(find.text('Bob'), findsWidgets);
    });

    testWidgets('selecting a different user replaces previous selection', (
      tester,
    ) async {
      String? selected;
      await tester.pumpWidget(
        _TestDropdown(initialValue: 'u1', onChanged: (v) => selected = v),
      );

      // Trigger already shows "Alice Sharma" — tap it to open the sheet.
      await tester.tap(find.text('Alice Sharma'));
      await tester.pumpAndSettle();

      // In the open sheet, "Bob" is a separate option row.
      await tester.tap(find.text('Bob'));
      await tester.pumpAndSettle();

      expect(selected, 'u2');
    });
  });

  // -------------------------------------------------------------------------
  // Search
  // -------------------------------------------------------------------------

  group('search', () {
    testWidgets('typing a name filters to matching options', (tester) async {
      await tester.pumpWidget(const _TestDropdown());

      await tester.tap(find.text('Select user'));
      await tester.pumpAndSettle();

      // The sheet's autofocused TextField is the only TextField in the tree.
      await tester.enterText(find.byType(TextField), 'alice');
      await tester.pump();

      expect(find.text('Alice Sharma'), findsOneWidget);
      expect(find.text('Bob'), findsNothing);
    });

    testWidgets('search by email filters correctly', (tester) async {
      await tester.pumpWidget(const _TestDropdown());

      await tester.tap(find.text('Select user'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'bob@example');
      await tester.pump();

      expect(find.text('Bob'), findsOneWidget);
      expect(find.text('Alice Sharma'), findsNothing);
    });

    testWidgets('search by mobile filters correctly', (tester) async {
      await tester.pumpWidget(const _TestDropdown());

      await tester.tap(find.text('Select user'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), '98765');
      await tester.pump();

      expect(find.text('Alice Sharma'), findsOneWidget);
      expect(find.text('Bob'), findsNothing);
    });

    testWidgets('empty search shows all users', (tester) async {
      await tester.pumpWidget(const _TestDropdown());

      await tester.tap(find.text('Select user'));
      await tester.pumpAndSettle();

      // Leave search empty — all users should be visible in the list.
      expect(find.text('Alice Sharma'), findsOneWidget);
      expect(find.text('Bob'), findsOneWidget);
    });
  });

  // -------------------------------------------------------------------------
  // Long text truncation
  // -------------------------------------------------------------------------

  group('long text truncation', () {
    testWidgets('long name in trigger is clipped, not overflowed', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          OpenVtsSearchableDropdown<String>(
            label: 'User',
            hintText: 'Select user',
            options: _users,
            value: 'u3',
            onChanged: (_) {},
          ),
        ),
      );
      // A RenderFlex overflow would throw an exception, causing this to fail.
      expect(tester.takeException(), isNull);
    });

    testWidgets('long name in sheet row is clipped, not overflowed', (
      tester,
    ) async {
      await tester.pumpWidget(const _TestDropdown());

      await tester.tap(find.text('Select user'));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });
  });
}
