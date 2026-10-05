import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/features/user/screens/notification_settings/widgets/user_notification_save_bar.dart';
import 'package:open_vts/shared/widgets/open_vts_button.dart';

Future<void> _pumpBar(
  WidgetTester tester, {
  required bool isDirty,
  bool isSaving = false,
  double width = 320,
  double textScale = 1,
  double keyboardInset = 0,
  VoidCallback? onSave,
  VoidCallback? onReset,
}) async {
  tester.view.physicalSize = Size(width, 700);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(
          size: Size(width, 700),
          textScaler: TextScaler.linear(textScale),
          viewInsets: EdgeInsets.only(bottom: keyboardInset),
        ),
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: Column(
            children: [
              const Expanded(child: SizedBox()),
              if (isDirty || isSaving)
                UserNotificationSaveBar(
                  isSaving: isSaving,
                  canSave: isDirty && !isSaving,
                  canReset: isDirty && !isSaving,
                  onSave: onSave,
                  onReset: onReset,
                ),
            ],
          ),
        ),
      ),
    ),
  );
  await tester.pump();
}

void _expectCompactAccessibleActions(WidgetTester tester) {
  // A 48px minimum touch target replaces the former 44px visual button.
  // Allow the row padding while retaining the compact mobile height contract.
  expect(
    tester.getSize(find.byType(UserNotificationSaveBar)).height,
    lessThanOrEqualTo(80),
  );
  for (final button in find.byType(OpenVtsButton).evaluate()) {
    expect(
      tester.getSize(find.byWidget(button.widget)).height,
      greaterThanOrEqualTo(48),
    );
  }
}

void main() {
  testWidgets('clean state does not reserve save-bar space', (tester) async {
    await _pumpBar(tester, isDirty: false);

    expect(find.byType(UserNotificationSaveBar), findsNothing);
  });

  testWidgets('mobile dirty state is one compact reachable action row', (
    tester,
  ) async {
    var saves = 0;
    var resets = 0;
    await _pumpBar(
      tester,
      isDirty: true,
      onSave: () => saves++,
      onReset: () => resets++,
    );

    expect(find.text('Unsaved'), findsOneWidget);
    expect(find.text('Reset'), findsOneWidget);
    expect(find.text('Save'), findsOneWidget);
    _expectCompactAccessibleActions(tester);

    await tester.tap(find.text('Reset'));
    await tester.tap(find.text('Save'));
    expect(resets, 1);
    expect(saves, 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('saving state disables actions and stays compact', (
    tester,
  ) async {
    await _pumpBar(tester, isDirty: true, isSaving: true);

    expect(find.text('Saving…'), findsWidgets);
    _expectCompactAccessibleActions(tester);
    expect(tester.takeException(), isNull);
  });

  testWidgets('large text and longest desktop labels do not overflow', (
    tester,
  ) async {
    await _pumpBar(tester, isDirty: true, width: 480, textScale: 2);

    expect(find.text('You have unsaved changes.'), findsOneWidget);
    expect(find.text('Save Changes'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('keyboard inset does not add duplicate bar padding', (
    tester,
  ) async {
    await _pumpBar(tester, isDirty: true, keyboardInset: 300);

    _expectCompactAccessibleActions(tester);
    expect(tester.takeException(), isNull);
  });
}
