import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/features/auth/widgets/mfa_login_form.dart';
import 'package:open_vts/l10n/app_localizations.dart';
import 'package:open_vts/shared/helpers/mobile_text.dart';

void main() {
  testWidgets('legacy English plural suffixes use native plural rules', (
    tester,
  ) async {
    for (final entry in const {
      'en': '2 trips',
      'fr': '2 trajets',
      'ar': 'رحلتان',
    }.entries) {
      await tester.pumpWidget(
        _app(
          Locale(entry.key),
          Builder(
            builder: (context) {
              return Text(
                context.mobileText('{value1} trip{value2}', {
                  'value1': '2',
                  'value2': 's',
                }),
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text(entry.value), findsOneWidget);
      expect(tester.takeException(), isNull);
    }
  });

  for (final code in ['en', 'ar', 'es', 'fr', 'hi', 'pt']) {
    testWidgets('$code renders MFA, localized actions and correct direction', (
      tester,
    ) async {
      final locale = Locale(code);
      final localizations = await AppLocalizations.delegate.load(locale);
      await tester.pumpWidget(
        _app(
          locale,
          MfaLoginForm(isLoading: false, onSubmit: (_) {}, onCancel: () {}),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text(localizations.mobileVerifySignIn), findsOneWidget);
      expect(find.text(localizations.mobileVerifyAndSignIn), findsOneWidget);
      expect(find.text(localizations.mobileAuthenticatorCode), findsOneWidget);
      expect(
        Directionality.of(tester.element(find.byType(MfaLoginForm))),
        code == 'ar' ? TextDirection.rtl : TextDirection.ltr,
      );
      await tester.tap(find.text(localizations.mobileUseRecovery));
      await tester.pump();
      expect(find.text(localizations.mobileRecoveryCode), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets(
    'changing locale rebuilds mounted content and preserves user data',
    (tester) async {
      const name = '東京 شاحنة – 123';
      final locale = ValueNotifier(const Locale('en'));
      addTearDown(locale.dispose);
      await tester.pumpWidget(
        ValueListenableBuilder<Locale>(
          valueListenable: locale,
          builder: (_, value, __) => _app(
            value,
            Builder(
              builder: (context) {
                return Column(
                  children: [
                    Text(context.mobileText('Security')),
                    Text(
                      context.mobileText(
                        '{name} will stop working immediately.',
                        {'name': name},
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Security'), findsOneWidget);
      locale.value = const Locale('fr');
      await tester.pumpAndSettle();
      expect(find.text('Sécurité'), findsOneWidget);
      expect(find.text('Security'), findsNothing);
      expect(find.textContaining(name), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}

Widget _app(Locale locale, Widget child) => MaterialApp(
  locale: locale,
  supportedLocales: AppLocalizations.supportedLocales,
  localizationsDelegates: const [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  home: Scaffold(body: SingleChildScrollView(child: child)),
);
