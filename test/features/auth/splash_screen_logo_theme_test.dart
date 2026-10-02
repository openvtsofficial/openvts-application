import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/features/auth/screens/splash_screen.dart';

Future<void> _pumpSplash(
  WidgetTester tester, {
  required ThemeMode themeMode,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: themeMode,
        home: const Scaffold(body: SplashLoadingView()),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  group('SplashScreen loading logo', () {
    testWidgets('uses the approved light-background icon in light theme', (
      tester,
    ) async {
      await _pumpSplash(tester, themeMode: ThemeMode.light);

      final image = tester.widget<Image>(find.byType(Image));
      expect(
        (image.image as AssetImage).assetName,
        'assets/brand/icon.png',
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('uses the approved dark-background icon in dark theme', (
      tester,
    ) async {
      await _pumpSplash(tester, themeMode: ThemeMode.dark);

      final image = tester.widget<Image>(find.byType(Image));
      expect(
        (image.image as AssetImage).assetName,
        'assets/brand/dark-icon.png',
      );
      expect(tester.takeException(), isNull);
    });
  });
}
