import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/utils/validators.dart';
import 'package:open_vts/features/auth/widgets/login_form.dart';
import 'package:open_vts/l10n/app_localizations.dart';
import 'package:open_vts/shared/helpers/validation_localizations.dart';
import 'package:open_vts/shared/widgets/open_vts_text_field.dart';

void main() {
  final validationErrors = <String?>[
    Validators.required(''),
    Validators.email(''),
    Validators.email('用户@example.com'),
    Validators.email('a' * 255),
    Validators.email('not-an-email'),
    Validators.driverName(''),
    Validators.driverName('a'),
    Validators.driverName('a' * 121),
    Validators.driverUsername(''),
    Validators.driverUsername('éclair'),
    Validators.driverUsername('a'),
    Validators.driverUsername('a' * 51),
    Validators.driverAddressOptional('a'),
    Validators.driverAddressOptional('a' * 201),
    Validators.driverPincodeOptional('1'),
    Validators.driverPincodeOptional('a' * 13),
    Validators.driverPincodeOptional('abcd'),
    Validators.adminName(''),
    Validators.adminName('a'),
    Validators.adminName('a' * 121),
    Validators.adminPassword(''),
    Validators.adminPassword('日本語'),
    Validators.adminPassword('12345'),
    Validators.adminPassword('a' * 101),
    Validators.adminConfirmPassword('', 'secret'),
    Validators.adminConfirmPassword('other', 'secret'),
    Validators.companyName(''),
    Validators.companyName('a'),
    Validators.companyName('a' * 201),
    Validators.address(''),
    Validators.address('a'),
    Validators.address('a' * 201),
    Validators.mobilePrefix(''),
    Validators.mobilePrefix('1' * 11),
    Validators.mobileNumber(''),
    Validators.mobileNumber('1'),
    Validators.mobileNumber('1' * 21),
    Validators.mobileNumber('abcdefgh'),
    Validators.pincodeRequired(''),
    Validators.credits('unknown'),
    Validators.credits('-1'),
    Validators.vehicleName(''),
    Validators.vehicleName('a'),
    Validators.vehicleName('a' * 121),
    Validators.plateNumber(''),
    Validators.plateNumber('a'),
    Validators.plateNumber('a' * 33),
    Validators.vin(''),
    Validators.vin('I' * 17),
    Validators.vin('A'),
    Validators.vin('A' * 65),
    Validators.vin('A-B'),
    Validators.simNumber(''),
    Validators.simNumber('1'),
    Validators.simNumber('1' * 26),
    Validators.simNumber('abcdef'),
    Validators.documentTitle(''),
    Validators.documentTitle('a'),
    Validators.documentTitle('a' * 121),
  ];

  for (final code in ['en', 'ar', 'es', 'fr', 'hi', 'pt']) {
    test(
      '$code localizes every shared validator rule without changing constraints',
      () async {
        final l10n = await AppLocalizations.delegate.load(Locale(code));
        for (final message in validationErrors) {
          expect(message, isNotNull);
          final translated = localizeValidationMessage(message, l10n);
          expect(translated, isNotEmpty);
          if (code == 'en') {
            expect(translated, message);
          } else {
            expect(translated, isNot(message), reason: '$code: $message');
          }
        }
        expect(localizeValidationMessage(null, l10n), isNull);
        expect(
          localizeValidationMessage('Server response: 東京 shipment', l10n),
          'Server response: 東京 shipment',
        );
        expect(
          localizeValidationMessage('Custom error: client 123', l10n),
          'Custom error: client 123',
        );
        final unknownField = Validators.required('', fieldName: '東京 123');
        expect(
          localizeValidationMessage(unknownField, l10n),
          contains('東京 123'),
        );
      },
    );

    testWidgets(
      '$code login errors are localized and password bytes are preserved',
      (tester) async {
        final l10n = await AppLocalizations.delegate.load(Locale(code));
        String? submittedUser, submittedPassword;
        await tester.pumpWidget(
          _app(
            Locale(code),
            LoginForm(
              isLoading: false,
              onDemo: () {},
              onSubmit: (user, password) {
                submittedUser = user;
                submittedPassword = password;
              },
            ),
          ),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.text(l10n.login));
        await tester.pump();
        expect(
          find.text(
            localizeValidationMessage('Username or email is required.', l10n)!,
          ),
          findsOneWidget,
        );
        expect(
          find.text(localizeValidationMessage('Password is required.', l10n)!),
          findsOneWidget,
        );
        expect(submittedPassword, isNull);
        await tester.enterText(find.byType(TextFormField).first, '用户');
        await tester.enterText(find.byType(TextFormField).last, 'пароль');
        await tester.tap(find.text(l10n.login));
        await tester.pump();
        expect(
          find.text(
            localizeValidationMessage(
              'Username or email must use English characters.',
              l10n,
            )!,
          ),
          findsOneWidget,
        );
        expect(
          find.text(
            localizeValidationMessage(
              'Password must use English characters.',
              l10n,
            )!,
          ),
          findsOneWidget,
        );
        expect(submittedPassword, isNull);
        await tester.enterText(
          find.byType(TextFormField).first,
          '  driver_1  ',
        );
        await tester.enterText(find.byType(TextFormField).last, '  abcd12  ');
        await tester.tap(find.text(l10n.login));
        await tester.pump();
        expect(submittedUser, 'driver_1');
        expect(submittedPassword, '  abcd12  ');
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      '$code shared and direct form fields use the same validation locale',
      (tester) async {
        final l10n = await AppLocalizations.delegate.load(Locale(code));
        final form = GlobalKey<FormState>();
        var validationCalls = 0;
        await tester.pumpWidget(
          _app(
            Locale(code),
            Builder(
              builder: (context) {
                return Form(
                  key: form,
                  child: Column(
                    children: [
                      const OpenVtsTextField(
                        label: 'Email',
                        validator: Validators.email,
                      ),
                      TextFormField(
                        initialValue: 'AB-12',
                        validator: context.localizedValidator((value) {
                          validationCalls++;
                          return Validators.vin(value);
                        }),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(form.currentState!.validate(), isFalse);
        await tester.pump();
        expect(validationCalls, 1);
        expect(
          find.text(localizeValidationMessage('Email is required', l10n)!),
          findsOneWidget,
        );
        expect(find.text(l10n.validationVinAlphanumeric), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  }
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
  home: Scaffold(
    body: SingleChildScrollView(
      child: Padding(padding: const EdgeInsets.all(20), child: child),
    ),
  ),
);
