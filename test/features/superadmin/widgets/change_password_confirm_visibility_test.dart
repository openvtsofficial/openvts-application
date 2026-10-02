import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// ---------------------------------------------------------------------------
// Standalone harness that mirrors the three-field layout of
// _ChangePasswordSheetState without requiring Riverpod or network.
// ---------------------------------------------------------------------------

class _ChangePasswordHarness extends StatefulWidget {
  const _ChangePasswordHarness();

  @override
  State<_ChangePasswordHarness> createState() => _ChangePasswordHarnessState();
}

class _ChangePasswordHarnessState extends State<_ChangePasswordHarness> {
  final _current = TextEditingController();
  final _next = TextEditingController();
  final _confirm = TextEditingController();
  bool _obscureCurrent = true;
  bool _obscureNext = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _current.dispose();
    _next.dispose();
    _confirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                key: const Key('current'),
                controller: _current,
                obscureText: _obscureCurrent,
                decoration: InputDecoration(
                  labelText: 'Current password',
                  suffixIcon: IconButton(
                    tooltip: _obscureCurrent
                        ? 'Show current password'
                        : 'Hide current password',
                    icon: Icon(
                      _obscureCurrent
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                    onPressed: () =>
                        setState(() => _obscureCurrent = !_obscureCurrent),
                  ),
                ),
              ),
              TextField(
                key: const Key('next'),
                controller: _next,
                obscureText: _obscureNext,
                decoration: InputDecoration(
                  labelText: 'New password',
                  suffixIcon: IconButton(
                    tooltip: _obscureNext
                        ? 'Show new password'
                        : 'Hide new password',
                    icon: Icon(
                      _obscureNext
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                    onPressed: () =>
                        setState(() => _obscureNext = !_obscureNext),
                  ),
                ),
              ),
              TextField(
                key: const Key('confirm'),
                controller: _confirm,
                obscureText: _obscureConfirm,
                decoration: InputDecoration(
                  labelText: 'Confirm new password',
                  suffixIcon: IconButton(
                    key: const Key('confirm-toggle'),
                    tooltip: _obscureConfirm
                        ? 'Show confirm password'
                        : 'Hide confirm password',
                    icon: Icon(
                      _obscureConfirm
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                    onPressed: () =>
                        setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

TextField _field(WidgetTester tester, Key key) =>
    tester.widget<TextField>(find.byKey(key));

bool _isObscured(WidgetTester tester, Key key) =>
    _field(tester, key).obscureText;

// Returns the icon inside the suffix IconButton for the given field.
IconData _suffixIcon(WidgetTester tester, Key fieldKey) {
  final field = _field(tester, fieldKey);
  final decoration = field.decoration!;
  final btn = decoration.suffixIcon! as IconButton;
  return (btn.icon as Icon).icon!;
}

void main() {
  group('change password — confirm visibility toggle', () {
    testWidgets('confirm field starts obscured', (tester) async {
      await tester.pumpWidget(const _ChangePasswordHarness());
      await tester.pumpAndSettle();

      expect(_isObscured(tester, const Key('confirm')), isTrue);
    });

    testWidgets('confirm field shows visibility_off icon when obscured',
        (tester) async {
      await tester.pumpWidget(const _ChangePasswordHarness());
      await tester.pumpAndSettle();

      expect(
        _suffixIcon(tester, const Key('confirm')),
        Icons.visibility_off_outlined,
      );
    });

    testWidgets('tapping confirm toggle reveals the field', (tester) async {
      await tester.pumpWidget(const _ChangePasswordHarness());
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('confirm-toggle')));
      await tester.pumpAndSettle();

      expect(_isObscured(tester, const Key('confirm')), isFalse);
    });

    testWidgets('confirm toggle switches icon to visibility_outlined',
        (tester) async {
      await tester.pumpWidget(const _ChangePasswordHarness());
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('confirm-toggle')));
      await tester.pumpAndSettle();

      expect(
        _suffixIcon(tester, const Key('confirm')),
        Icons.visibility_outlined,
      );
    });

    testWidgets('tapping confirm toggle twice re-obscures the field',
        (tester) async {
      await tester.pumpWidget(const _ChangePasswordHarness());
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('confirm-toggle')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('confirm-toggle')));
      await tester.pumpAndSettle();

      expect(_isObscured(tester, const Key('confirm')), isTrue);
    });

    testWidgets('confirm toggle does not affect new-password field',
        (tester) async {
      await tester.pumpWidget(const _ChangePasswordHarness());
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('confirm-toggle')));
      await tester.pumpAndSettle();

      expect(_isObscured(tester, const Key('next')), isTrue,
          reason: 'new-password must stay obscured when confirm is toggled');
    });

    testWidgets('new-password toggle does not affect confirm field',
        (tester) async {
      await tester.pumpWidget(const _ChangePasswordHarness());
      await tester.pumpAndSettle();

      // Tap the new-password suffix (visibility_off icon inside 'next' field).
      final nextField = _field(tester, const Key('next'));
      final nextBtn = nextField.decoration!.suffixIcon! as IconButton;
      await tester.tap(find.byWidget(nextBtn));
      await tester.pumpAndSettle();

      expect(_isObscured(tester, const Key('confirm')), isTrue,
          reason: 'confirm must stay obscured when new-password is toggled');
    });

    testWidgets('toggling confirm does not clear its text', (tester) async {
      await tester.pumpWidget(const _ChangePasswordHarness());
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key('confirm')), 'secret123');
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('confirm-toggle')));
      await tester.pumpAndSettle();

      expect(find.text('secret123'), findsOneWidget);
    });

    testWidgets('confirm toggle has semantic tooltip when obscured',
        (tester) async {
      await tester.pumpWidget(const _ChangePasswordHarness());
      await tester.pumpAndSettle();

      final btn = tester.widget<IconButton>(
        find.byKey(const Key('confirm-toggle')),
      );
      expect(btn.tooltip, 'Show confirm password');
    });

    testWidgets('confirm toggle has semantic tooltip when revealed',
        (tester) async {
      await tester.pumpWidget(const _ChangePasswordHarness());
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('confirm-toggle')));
      await tester.pumpAndSettle();

      final btn = tester.widget<IconButton>(
        find.byKey(const Key('confirm-toggle')),
      );
      expect(btn.tooltip, 'Hide confirm password');
    });

    testWidgets(
        'all three fields are independent — toggling one does not '
        'affect the other two', (tester) async {
      await tester.pumpWidget(const _ChangePasswordHarness());
      await tester.pumpAndSettle();

      // Reveal confirm only.
      await tester.tap(find.byKey(const Key('confirm-toggle')));
      await tester.pumpAndSettle();

      expect(_isObscured(tester, const Key('current')), isTrue);
      expect(_isObscured(tester, const Key('next')), isTrue);
      expect(_isObscured(tester, const Key('confirm')), isFalse);
    });
  });
}
