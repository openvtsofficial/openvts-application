import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/api/api_client.dart';
import 'package:open_vts/features/admin/controllers/admin_providers.dart';
import 'package:open_vts/features/admin/controllers/admin_settings_controller.dart';
import 'package:open_vts/features/admin/models/admin_settings_model.dart';
import 'package:open_vts/features/admin/models/admin_settings_state.dart';
import 'package:open_vts/features/admin/screens/settings/widgets/admin_localization_settings_section.dart';
import 'package:open_vts/features/admin/services/admin_settings_service.dart';
import 'package:open_vts/l10n/app_localizations.dart';
import 'package:open_vts/shared/widgets/open_vts_searchable_dropdown.dart';

const _languages = [
  AdminLanguageOption(code: 'en', label: 'English'),
  AdminLanguageOption(code: 'ar', label: 'Arabic'),
  AdminLanguageOption(code: 'fr', label: 'French'),
  AdminLanguageOption(code: 'de', label: 'German'),
];

AdminSettingsState _state({required String language}) {
  return const AdminSettingsState.initial().copyWith(
    localization: AdminLocalizationSettings(language: language),
    languages: _languages,
    timezones: const ['+00:00'],
  );
}

Widget _app(AdminSettingsState state) {
  return ProviderScope(
    overrides: [
      adminSettingsControllerProvider.overrideWith(
        (ref) => AdminSettingsController(
          AdminSettingsService(ApiClient(Dio())),
        ),
      ),
    ],
    child: MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: SingleChildScrollView(
          child: LocalizationSettingsSection(state: state),
        ),
      ),
    ),
  );
}

Finder _languageDropdown() {
  return find.byWidgetPredicate(
    (widget) =>
        widget is OpenVtsSearchableDropdown<String> &&
        widget.label == 'Language',
  );
}

Finder _visibleOption(String value) {
  return find.descendant(
    of: find.byType(ListView).last,
    matching: find.text(value),
  );
}

Future<void> _openLanguage(WidgetTester tester) async {
  final dropdown = _languageDropdown();
  await tester.ensureVisible(dropdown);
  await tester.pumpAndSettle();
  await tester.tap(dropdown);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('language search by label is case-insensitive', (tester) async {
    await tester.pumpWidget(_app(_state(language: 'en')));
    await _openLanguage(tester);

    final searchField = find.byType(TextField).last;
    for (final entry in const {
      'english': 'English',
      'arabic': 'Arabic',
      'FRENCH': 'French',
      'GeRmAn': 'German',
    }.entries) {
      await tester.enterText(searchField, entry.key);
      await tester.pump();
      expect(_visibleOption(entry.value), findsOneWidget);
    }
  });

  testWidgets('language search by code finds the matching option', (
    tester,
  ) async {
    await tester.pumpWidget(_app(_state(language: 'en')));
    await _openLanguage(tester);

    final searchField = find.byType(TextField).last;
    await tester.enterText(searchField, 'ar');
    await tester.pump();

    expect(_visibleOption('Arabic'), findsOneWidget);
    expect(_visibleOption('French'), findsNothing);
    expect(_visibleOption('German'), findsNothing);
  });

  testWidgets('selecting a language updates the trigger display', (
    tester,
  ) async {
    await tester.pumpWidget(_app(_state(language: 'en')));
    await _openLanguage(tester);

    await tester.enterText(find.byType(TextField).last, 'French');
    await tester.pump();
    await tester.tap(_visibleOption('French'));
    await tester.pumpAndSettle();

    // Trigger shows the label; preview card shows the code ('FR'), not the label.
    expect(find.text('French'), findsOneWidget);
  });

  testWidgets('language keeps a current value missing from the options', (
    tester,
  ) async {
    const currentCode = 'xx';
    await tester.pumpWidget(_app(_state(language: currentCode)));

    expect(find.text('XX'), findsNWidgets(2));

    await _openLanguage(tester);
    await tester.enterText(find.byType(TextField).last, 'xx');
    await tester.pump();

    expect(_visibleOption('XX'), findsOneWidget);
  });
}
