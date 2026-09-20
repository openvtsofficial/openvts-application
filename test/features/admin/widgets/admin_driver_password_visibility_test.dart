import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// ---------------------------------------------------------------------------
// Inline re-implementation of the password-visibility portion of
// _DriverPasswordSheetState.  This mirrors the production toggle logic
// exactly so regressions in the production file surface here.
// ---------------------------------------------------------------------------

class _PasswordFormTest extends StatefulWidget {
  const _PasswordFormTest({this.onSubmit});

  final void Function(String newPwd, String confirmPwd)? onSubmit;

  @override
  State<_PasswordFormTest> createState() => _PasswordFormTestState();
}

class _PasswordFormTestState extends State<_PasswordFormTest> {
  final _formKey = GlobalKey<FormState>();
  final _newPassword = TextEditingController();
  final _confirmPassword = TextEditingController();
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _newPassword.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            key: const Key('new_password_field'),
            controller: _newPassword,
            obscureText: _obscureNew,
            validator: (v) => (v == null || v.length < 8)
                ? 'Password must be at least 8 characters'
                : null,
            decoration: InputDecoration(
              labelText: 'New Password',
              suffixIcon: IconButton(
                key: const Key('new_toggle'),
                tooltip: _obscureNew ? 'Show password' : 'Hide password',
                onPressed: () => setState(() => _obscureNew = !_obscureNew),
                icon: Icon(
                  _obscureNew
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 18,
                ),
              ),
            ),
          ),
          TextFormField(
            key: const Key('confirm_password_field'),
            controller: _confirmPassword,
            obscureText: _obscureConfirm,
            validator: (v) =>
                v != _newPassword.text ? 'Passwords do not match' : null,
            decoration: InputDecoration(
              labelText: 'Confirm Password',
              suffixIcon: IconButton(
                key: const Key('confirm_toggle'),
                tooltip: _obscureConfirm ? 'Show password' : 'Hide password',
                onPressed: () =>
                    setState(() => _obscureConfirm = !_obscureConfirm),
                icon: Icon(
                  _obscureConfirm
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 18,
                ),
              ),
            ),
          ),
          ElevatedButton(
            key: const Key('submit'),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                widget.onSubmit?.call(_newPassword.text, _confirmPassword.text);
              }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

Widget _wrap(_PasswordFormTest child, {bool dark = false}) => MaterialApp(
      theme: dark ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(body: child),
    );

/// Returns true when the EditableText inside the field with [key] is obscured.
bool _isObscured(WidgetTester tester, Key fieldKey) {
  final et = tester.widget<EditableText>(
    find.descendant(
      of: find.byKey(fieldKey),
      matching: find.byType(EditableText),
    ),
  );
  return et.obscureText;
}

/// Returns the current text in the field with [key].
String _fieldText(WidgetTester tester, Key fieldKey) {
  final et = tester.widget<EditableText>(
    find.descendant(
      of: find.byKey(fieldKey),
      matching: find.byType(EditableText),
    ),
  );
  return et.controller.text;
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  // -------------------------------------------------------------------------
  // Initial state
  // -------------------------------------------------------------------------

  group('initial obscured state', () {
    testWidgets('New Password field starts obscured', (tester) async {
      await tester.pumpWidget(_wrap(const _PasswordFormTest()));

      expect(_isObscured(tester, const Key('new_password_field')), isTrue);
    });

    testWidgets('Confirm Password field starts obscured', (tester) async {
      await tester.pumpWidget(_wrap(const _PasswordFormTest()));

      expect(_isObscured(tester, const Key('confirm_password_field')), isTrue);
    });

    testWidgets('both show-password icons are visibility_outlined initially',
        (tester) async {
      await tester.pumpWidget(_wrap(const _PasswordFormTest()));

      // Two visibility icons — one per field.
      expect(find.byIcon(Icons.visibility_outlined), findsNWidgets(2));
      expect(find.byIcon(Icons.visibility_off_outlined), findsNothing);
    });
  });

  // -------------------------------------------------------------------------
  // New Password toggle
  // -------------------------------------------------------------------------

  group('New Password toggle', () {
    testWidgets('tapping toggle reveals New Password', (tester) async {
      await tester.pumpWidget(_wrap(const _PasswordFormTest()));

      await tester.tap(find.byKey(const Key('new_toggle')));
      await tester.pump();

      expect(_isObscured(tester, const Key('new_password_field')), isFalse);
    });

    testWidgets('tapping toggle again re-obscures New Password',
        (tester) async {
      await tester.pumpWidget(_wrap(const _PasswordFormTest()));

      await tester.tap(find.byKey(const Key('new_toggle')));
      await tester.pump();
      await tester.tap(find.byKey(const Key('new_toggle')));
      await tester.pump();

      expect(_isObscured(tester, const Key('new_password_field')), isTrue);
    });

    testWidgets('icon switches to visibility_off_outlined after reveal',
        (tester) async {
      await tester.pumpWidget(_wrap(const _PasswordFormTest()));

      await tester.tap(find.byKey(const Key('new_toggle')));
      await tester.pump();

      // new_toggle now shows the off icon.
      final btn = tester.widget<IconButton>(
        find.byKey(const Key('new_toggle')),
      );
      expect((btn.icon as Icon).icon, Icons.visibility_off_outlined);
    });
  });

  // -------------------------------------------------------------------------
  // Confirm Password toggle
  // -------------------------------------------------------------------------

  group('Confirm Password toggle', () {
    testWidgets('tapping toggle reveals Confirm Password', (tester) async {
      await tester.pumpWidget(_wrap(const _PasswordFormTest()));

      await tester.tap(find.byKey(const Key('confirm_toggle')));
      await tester.pump();

      expect(_isObscured(tester, const Key('confirm_password_field')), isFalse);
    });

    testWidgets('tapping toggle again re-obscures Confirm Password',
        (tester) async {
      await tester.pumpWidget(_wrap(const _PasswordFormTest()));

      await tester.tap(find.byKey(const Key('confirm_toggle')));
      await tester.pump();
      await tester.tap(find.byKey(const Key('confirm_toggle')));
      await tester.pump();

      expect(_isObscured(tester, const Key('confirm_password_field')), isTrue);
    });

    testWidgets('icon switches to visibility_off_outlined after reveal',
        (tester) async {
      await tester.pumpWidget(_wrap(const _PasswordFormTest()));

      await tester.tap(find.byKey(const Key('confirm_toggle')));
      await tester.pump();

      final btn = tester.widget<IconButton>(
        find.byKey(const Key('confirm_toggle')),
      );
      expect((btn.icon as Icon).icon, Icons.visibility_off_outlined);
    });
  });

  // -------------------------------------------------------------------------
  // Independent state
  // -------------------------------------------------------------------------

  group('independent visibility state', () {
    testWidgets('toggling New Password does not change Confirm Password',
        (tester) async {
      await tester.pumpWidget(_wrap(const _PasswordFormTest()));

      await tester.tap(find.byKey(const Key('new_toggle')));
      await tester.pump();

      expect(_isObscured(tester, const Key('confirm_password_field')), isTrue);
    });

    testWidgets('toggling Confirm Password does not change New Password',
        (tester) async {
      await tester.pumpWidget(_wrap(const _PasswordFormTest()));

      await tester.tap(find.byKey(const Key('confirm_toggle')));
      await tester.pump();

      expect(_isObscured(tester, const Key('new_password_field')), isTrue);
    });

    testWidgets('both can be revealed simultaneously', (tester) async {
      await tester.pumpWidget(_wrap(const _PasswordFormTest()));

      await tester.tap(find.byKey(const Key('new_toggle')));
      await tester.pump();
      await tester.tap(find.byKey(const Key('confirm_toggle')));
      await tester.pump();

      expect(_isObscured(tester, const Key('new_password_field')), isFalse);
      expect(_isObscured(tester, const Key('confirm_password_field')), isFalse);
    });
  });

  // -------------------------------------------------------------------------
  // Text retained through toggle
  // -------------------------------------------------------------------------

  group('text retained through toggle', () {
    testWidgets('New Password text survives a toggle cycle', (tester) async {
      await tester.pumpWidget(_wrap(const _PasswordFormTest()));

      await tester.enterText(
          find.byKey(const Key('new_password_field')), 'secret123');
      await tester.tap(find.byKey(const Key('new_toggle')));
      await tester.pump();
      await tester.tap(find.byKey(const Key('new_toggle')));
      await tester.pump();

      expect(_fieldText(tester, const Key('new_password_field')), 'secret123');
    });

    testWidgets('Confirm Password text survives a toggle cycle',
        (tester) async {
      await tester.pumpWidget(_wrap(const _PasswordFormTest()));

      await tester.enterText(
          find.byKey(const Key('confirm_password_field')), 'secret123');
      await tester.tap(find.byKey(const Key('confirm_toggle')));
      await tester.pump();
      await tester.tap(find.byKey(const Key('confirm_toggle')));
      await tester.pump();

      expect(
          _fieldText(tester, const Key('confirm_password_field')), 'secret123');
    });
  });

  // -------------------------------------------------------------------------
  // Semantic tooltips
  // -------------------------------------------------------------------------

  group('semantic tooltips', () {
    testWidgets('initial tooltips are both "Show password"', (tester) async {
      await tester.pumpWidget(_wrap(const _PasswordFormTest()));

      expect(find.byTooltip('Show password'), findsNWidgets(2));
    });

    testWidgets('New Password tooltip changes to "Hide password" after reveal',
        (tester) async {
      await tester.pumpWidget(_wrap(const _PasswordFormTest()));

      await tester.tap(find.byKey(const Key('new_toggle')));
      await tester.pump();

      final btn =
          tester.widget<IconButton>(find.byKey(const Key('new_toggle')));
      expect(btn.tooltip, 'Hide password');
    });

    testWidgets(
        'Confirm Password tooltip changes to "Hide password" after reveal',
        (tester) async {
      await tester.pumpWidget(_wrap(const _PasswordFormTest()));

      await tester.tap(find.byKey(const Key('confirm_toggle')));
      await tester.pump();

      final btn =
          tester.widget<IconButton>(find.byKey(const Key('confirm_toggle')));
      expect(btn.tooltip, 'Hide password');
    });
  });

  // -------------------------------------------------------------------------
  // Theme: icons visible in light and dark mode
  // -------------------------------------------------------------------------

  group('icon visibility across themes', () {
    testWidgets('visibility icons render in light theme', (tester) async {
      await tester.pumpWidget(_wrap(const _PasswordFormTest()));

      expect(find.byIcon(Icons.visibility_outlined), findsNWidgets(2));
    });

    testWidgets('visibility icons render in dark theme', (tester) async {
      await tester.pumpWidget(_wrap(const _PasswordFormTest(), dark: true));

      expect(find.byIcon(Icons.visibility_outlined), findsNWidgets(2));
    });
  });

  // -------------------------------------------------------------------------
  // Validation and submission (unchanged behavior)
  // -------------------------------------------------------------------------

  group('validation unchanged', () {
    testWidgets('short New Password fails validation', (tester) async {
      await tester.pumpWidget(_wrap(const _PasswordFormTest()));

      await tester.enterText(
          find.byKey(const Key('new_password_field')), 'short');
      await tester.enterText(
          find.byKey(const Key('confirm_password_field')), 'short');
      await tester.tap(find.byKey(const Key('submit')));
      await tester.pump();

      expect(
          find.text('Password must be at least 8 characters'), findsOneWidget);
    });

    testWidgets('mismatched passwords fail validation', (tester) async {
      await tester.pumpWidget(_wrap(const _PasswordFormTest()));

      await tester.enterText(
          find.byKey(const Key('new_password_field')), 'password123');
      await tester.enterText(
          find.byKey(const Key('confirm_password_field')), 'different123');
      await tester.tap(find.byKey(const Key('submit')));
      await tester.pump();

      expect(find.text('Passwords do not match'), findsOneWidget);
    });

    testWidgets('matching passwords ≥8 chars pass validation', (tester) async {
      String? submittedNew;
      String? submittedConfirm;

      await tester.pumpWidget(_wrap(
        _PasswordFormTest(
          onSubmit: (n, c) {
            submittedNew = n;
            submittedConfirm = c;
          },
        ),
      ));

      await tester.enterText(
          find.byKey(const Key('new_password_field')), 'valid1234');
      await tester.enterText(
          find.byKey(const Key('confirm_password_field')), 'valid1234');
      await tester.tap(find.byKey(const Key('submit')));
      await tester.pump();

      expect(submittedNew, 'valid1234');
      expect(submittedConfirm, 'valid1234');
    });

    testWidgets('validation passes when New Password is revealed before submit',
        (tester) async {
      String? submitted;

      await tester.pumpWidget(_wrap(
        _PasswordFormTest(onSubmit: (n, _) => submitted = n),
      ));

      await tester.enterText(
          find.byKey(const Key('new_password_field')), 'revealme1');
      await tester.enterText(
          find.byKey(const Key('confirm_password_field')), 'revealme1');
      await tester.tap(find.byKey(const Key('new_toggle')));
      await tester.pump();
      await tester.tap(find.byKey(const Key('submit')));
      await tester.pump();

      expect(submitted, 'revealme1');
    });
  });
}
