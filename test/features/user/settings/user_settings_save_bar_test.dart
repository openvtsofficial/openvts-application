import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/features/user/models/user_settings_model.dart';
import 'package:open_vts/features/user/screens/settings/widgets/user_settings_save_bar.dart';
import 'package:open_vts/l10n/app_localizations.dart';

// ---------------------------------------------------------------------------
// Helper
// ---------------------------------------------------------------------------

Future<void> _pumpBar(
  WidgetTester tester, {
  UserSettingsTab tab = UserSettingsTab.localization,
  bool isSaving = false,
  bool canSave = true,
  bool canReset = true,
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
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
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
              UserSettingsSaveBar(
                selectedTab: tab,
                isSaving: isSaving,
                canSave: canSave && !isSaving,
                canReset: canReset && !isSaving,
                onSave: onSave,
                onReset: onReset,
              ),
            ],
          ),
        ),
      ),
    ),
  );
  // Use pump(duration) rather than pumpAndSettle() so tests with an
  // ongoing loading animation (isSaving: true) do not time out.
  await tester.pump(const Duration(milliseconds: 100));
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  // -------------------------------------------------------------------------
  // 1. Compact — always single row on phone width
  // -------------------------------------------------------------------------

  group('UserSettingsSaveBar — compact single row on narrow width', () {
    testWidgets('dirty state is one compact row at phone width (320px)',
        (tester) async {
      var saves = 0;
      var resets = 0;
      await _pumpBar(
        tester,
        onSave: () => saves++,
        onReset: () => resets++,
      );

      // Both buttons are reachable
      expect(find.text('Reset'), findsOneWidget);
      expect(find.text('Save'), findsOneWidget);

      // Bar height ≤ 80px (xs*2 outer + card border + card pad*2 + button 44)
      expect(
        tester.getSize(find.byType(UserSettingsSaveBar)).height,
        lessThanOrEqualTo(80),
      );

      await tester.tap(find.text('Reset'));
      await tester.tap(find.text('Save'));
      expect(resets, 1);
      expect(saves, 1);
      expect(tester.takeException(), isNull);
    });

    testWidgets('does not stack text above buttons on narrow width',
        (tester) async {
      await _pumpBar(tester);

      // No Column child with text followed by a Row of buttons — verify by
      // confirming bar height is single-row height (≤ 76px).
      expect(
        tester.getSize(find.byType(UserSettingsSaveBar)).height,
        lessThanOrEqualTo(80),
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('shows short "Unsaved changes" text on narrow width',
        (tester) async {
      await _pumpBar(tester, tab: UserSettingsTab.localization);

      // Short label is shown (not the long "You have unsaved Localization changes.")
      expect(find.text('Unsaved changes'), findsOneWidget);
      expect(find.text('You have unsaved Localization changes.'), findsNothing);
    });

    testWidgets('shows "Saving…" text while saving on narrow width',
        (tester) async {
      await _pumpBar(tester, isSaving: true, canSave: false, canReset: false);

      expect(find.text('Saving…'), findsOneWidget);
      expect(
        tester.getSize(find.byType(UserSettingsSaveBar)).height,
        lessThanOrEqualTo(80),
      );
      expect(tester.takeException(), isNull);
    });
  });

  // -------------------------------------------------------------------------
  // 2. Wide layout (≥ 430px) — full helper text
  // -------------------------------------------------------------------------

  group('UserSettingsSaveBar — wide layout helper text', () {
    testWidgets(
        'shows full "You have unsaved Localization changes." on wide width',
        (tester) async {
      await _pumpBar(
        tester,
        tab: UserSettingsTab.localization,
        width: 500,
      );

      expect(
        find.text('You have unsaved Localization changes.'),
        findsOneWidget,
      );
      expect(find.text('Unsaved changes'), findsNothing);
    });

    testWidgets('shows full "You have unsaved Profile changes." on wide width',
        (tester) async {
      await _pumpBar(
        tester,
        tab: UserSettingsTab.profile,
        width: 500,
      );

      expect(find.text('You have unsaved Profile changes.'), findsOneWidget);
    });

    testWidgets('shows "Saving Localization changes..." while saving wide',
        (tester) async {
      await _pumpBar(
        tester,
        tab: UserSettingsTab.localization,
        isSaving: true,
        canSave: false,
        canReset: false,
        width: 500,
      );

      expect(find.text('Saving Localization changes...'), findsOneWidget);
    });

    testWidgets('Reset and Save are still reachable on wide width',
        (tester) async {
      var saves = 0;
      var resets = 0;
      await _pumpBar(
        tester,
        width: 500,
        onSave: () => saves++,
        onReset: () => resets++,
      );

      await tester.tap(find.text('Reset'));
      await tester.tap(find.text('Save'));
      expect(resets, 1);
      expect(saves, 1);
      expect(tester.takeException(), isNull);
    });
  });

  // -------------------------------------------------------------------------
  // 3. Saving state — buttons disabled
  // -------------------------------------------------------------------------

  group('UserSettingsSaveBar — saving state', () {
    testWidgets('saving state stays compact and does not overflow',
        (tester) async {
      await _pumpBar(
        tester,
        isSaving: true,
        canSave: false,
        canReset: false,
      );

      expect(
        tester.getSize(find.byType(UserSettingsSaveBar)).height,
        lessThanOrEqualTo(80),
      );
      expect(tester.takeException(), isNull);
    });
  });

  // -------------------------------------------------------------------------
  // 4. Keyboard inset — bar stays compact
  // -------------------------------------------------------------------------

  group('UserSettingsSaveBar — keyboard inset', () {
    testWidgets('bar stays compact when keyboard is open', (tester) async {
      await _pumpBar(tester, keyboardInset: 300);

      // Bar itself should not grow; the Scaffold handles the resize.
      expect(
        tester.getSize(find.byType(UserSettingsSaveBar)).height,
        lessThanOrEqualTo(80),
      );
      expect(tester.takeException(), isNull);
    });
  });

  // -------------------------------------------------------------------------
  // 5. Large text scaling — no overflow
  // -------------------------------------------------------------------------

  group('UserSettingsSaveBar — large text scaling', () {
    testWidgets('2x text scale does not overflow on narrow width',
        (tester) async {
      await _pumpBar(tester, textScale: 2);

      expect(tester.takeException(), isNull);
    });

    testWidgets('2x text scale does not overflow on wide width',
        (tester) async {
      await _pumpBar(tester, width: 500, textScale: 2);

      expect(tester.takeException(), isNull);
    });
  });

  // -------------------------------------------------------------------------
  // 6. canSave / canReset gate — disabled callbacks
  // -------------------------------------------------------------------------

  group('UserSettingsSaveBar — disabled state', () {
    testWidgets('canSave=false prevents save callback', (tester) async {
      var saves = 0;
      await _pumpBar(
        tester,
        canSave: false,
        onSave: () => saves++,
      );

      await tester.tap(find.text('Save'), warnIfMissed: false);
      expect(saves, 0);
      expect(tester.takeException(), isNull);
    });

    testWidgets('canReset=false prevents reset callback', (tester) async {
      var resets = 0;
      await _pumpBar(
        tester,
        canReset: false,
        onReset: () => resets++,
      );

      await tester.tap(find.text('Reset'), warnIfMissed: false);
      expect(resets, 0);
      expect(tester.takeException(), isNull);
    });
  });
}
