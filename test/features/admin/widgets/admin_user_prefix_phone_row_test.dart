import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/features/admin/screens/users/widgets/admin_user_form_fields.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

List<AdminUserDropdownOption> _prefixOptions() => const [
      AdminUserDropdownOption(value: '+91', label: '+91 IN'),
      AdminUserDropdownOption(value: '+234', label: '+234 NG'),
    ];

Widget _buildRow({
  required double width,
  String? prefixValue,
  TextEditingController? phoneController,
}) {
  return MaterialApp(
    home: Scaffold(
      body: SizedBox(
        width: width,
        child: AdminUserPrefixPhoneRow(
          prefixValue: prefixValue ?? '+91',
          prefixOptions: _prefixOptions(),
          onPrefixChanged: (_) {},
          phoneController: phoneController ?? TextEditingController(),
          phoneValidator: (v) => v == null || v.isEmpty ? 'Required' : null,
        ),
      ),
    ),
  );
}

Finder _prefixTrigger() {
  return find.descendant(
    of: find.byType(AdminUserDropdownField),
    matching: find.byType(GestureDetector),
  );
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('AdminUserPrefixPhoneRow — layout', () {
    testWidgets('normal width (400 px): prefix and number are side-by-side',
        (tester) async {
      await tester.pumpWidget(_buildRow(width: 400));
      await tester.pump();

      // At 400px (above 300px breakpoint), a Row should be used
      expect(find.byType(Row), findsWidgets);

      // Both labels visible
      expect(find.text('Mobile Prefix'), findsOneWidget);
      expect(find.text('Mobile Number'), findsOneWidget);
    });

    testWidgets('narrow width (280 px): stacks vertically in a Column',
        (tester) async {
      await tester.pumpWidget(_buildRow(width: 280));
      await tester.pump();

      // At 280px (below 300px breakpoint), Column layout is used
      final columnFinder = find.byWidgetPredicate(
        (w) =>
            w is Column && w.crossAxisAlignment == CrossAxisAlignment.stretch,
      );
      expect(columnFinder, findsWidgets);

      // Both labels still visible
      expect(find.text('Mobile Prefix'), findsOneWidget);
      expect(find.text('Mobile Number'), findsOneWidget);
    });

    testWidgets('320 px (narrow): no RenderFlex overflow', (tester) async {
      // Override threshold to detect actual overflows from Flutter's renderer
      final errors = <FlutterErrorDetails>[];
      FlutterError.onError = errors.add;

      await tester.pumpWidget(_buildRow(width: 320));
      await tester.pump();

      FlutterError.onError = FlutterError.dumpErrorToConsole;

      final overflowErrors = errors.where(
        (e) => e.toString().contains('overflowed'),
      );
      expect(overflowErrors, isEmpty, reason: 'No overflow at 320px');
    });
  });

  group('AdminUserPrefixPhoneRow — closed-field compact label', () {
    testWidgets('closed dropdown shows dial code only (+91), not full label',
        (tester) async {
      await tester.pumpWidget(_buildRow(width: 400, prefixValue: '+91'));
      await tester.pump();

      // The closed selected-item text should be just "+91" (via selectedLabel)
      // The full "+91 IN" label should NOT appear outside the open menu
      expect(find.text('+91'), findsWidgets);
      expect(find.text('+91 IN'), findsNothing);
    });

    testWidgets('open menu shows full label (+91 IN)', (tester) async {
      await tester.pumpWidget(_buildRow(width: 400, prefixValue: '+91'));
      await tester.pump();

      // Open the dropdown
      await tester.tap(_prefixTrigger());
      await tester.pumpAndSettle();

      // Full label is now visible in the open menu
      expect(find.text('+91 IN'), findsWidgets);
    });

    testWidgets('searches full prefix labels by dial and country code', (
      tester,
    ) async {
      String? capturedPrefix;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              child: AdminUserPrefixPhoneRow(
                prefixValue: '+91',
                prefixOptions: _prefixOptions(),
                onPrefixChanged: (value) => capturedPrefix = value,
                phoneController: TextEditingController(),
                phoneValidator: null,
              ),
            ),
          ),
        ),
      );

      await tester.tap(_prefixTrigger());
      await tester.pumpAndSettle();

      final searchField = find.byType(TextField).last;
      await tester.enterText(searchField, '234');
      await tester.pump();
      expect(find.text('+234 NG'), findsOneWidget);
      expect(find.text('+91 IN'), findsNothing);

      await tester.enterText(searchField, 'ng');
      await tester.pump();
      expect(find.text('+234 NG'), findsOneWidget);
      expect(find.text('+91 IN'), findsNothing);

      await tester.tap(find.text('+234 NG'));
      await tester.pumpAndSettle();

      expect(capturedPrefix, '+234');
    });
  });

  group('AdminUserPrefixPhoneRow — value preservation', () {
    testWidgets('submitted prefix value is the dial code, not the label',
        (tester) async {
      String? capturedPrefix;
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: SizedBox(
                width: 400,
                child: AdminUserPrefixPhoneRow(
                  prefixValue: '+91',
                  prefixOptions: _prefixOptions(),
                  onPrefixChanged: (v) => capturedPrefix = v,
                  phoneController: TextEditingController(text: '9876543210'),
                  phoneValidator: null,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      // Change to +234
      await tester.tap(_prefixTrigger());
      await tester.pumpAndSettle();
      await tester.tap(find.text('+234 NG'));
      await tester.pumpAndSettle();

      expect(capturedPrefix, '+234',
          reason: 'value is the dial code, not the label');
    });
  });
}
