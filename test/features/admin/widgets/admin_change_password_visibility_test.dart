import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/features/admin/screens/settings/widgets/admin_profile_settings_section.dart';

void main() {
  Future<void> pumpSheet(WidgetTester tester, ThemeMode themeMode) {
    return tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: themeMode,
          home: const Scaffold(body: AdminChangePasswordSheet()),
        ),
      ),
    );
  }

  List<bool> obscuredFields(WidgetTester tester) => tester
      .widgetList<EditableText>(find.byType(EditableText))
      .map((field) => field.obscureText)
      .toList();

  testWidgets('password visibility controls are independent and accessible',
      (tester) async {
    await pumpSheet(tester, ThemeMode.light);

    expect(obscuredFields(tester), [true, true, true]);
    expect(find.byTooltip('Show current password'), findsOneWidget);
    expect(find.byTooltip('Show new password'), findsOneWidget);
    expect(find.byTooltip('Show confirm new password'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('confirm-password-visibility')));
    await tester.pump();
    expect(obscuredFields(tester), [true, true, false]);
    expect(find.byTooltip('Hide confirm new password'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('new-password-visibility')));
    await tester.pump();
    expect(obscuredFields(tester), [true, false, false]);

    await tester.tap(find.byKey(const ValueKey('current-password-visibility')));
    await tester.pump();
    expect(obscuredFields(tester), [false, false, false]);
  });

  testWidgets('visibility icons contrast in light and dark themes',
      (tester) async {
    for (final mode in [ThemeMode.light, ThemeMode.dark]) {
      await pumpSheet(tester, mode);
      final context = tester.element(
        find.byKey(const ValueKey('confirm-password-visibility')),
      );
      final expected = Theme.of(context).colorScheme.onSurfaceVariant;
      final icon = tester.widget<Icon>(
        find.descendant(
          of: find.byKey(const ValueKey('confirm-password-visibility')),
          matching: find.byType(Icon),
        ),
      );
      expect(icon.color, expected);
    }
  });
}
