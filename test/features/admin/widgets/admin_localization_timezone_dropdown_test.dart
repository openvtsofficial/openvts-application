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

const _timezones = [
  'Asia/Kolkata',
  'America/New_York',
  'UTC',
  'Europe/London',
];

AdminSettingsState _state({required String timezone}) {
  return const AdminSettingsState.initial().copyWith(
    localization: AdminLocalizationSettings(timezoneOffset: timezone),
    timezones: _timezones,
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

Finder _timezoneDropdown() {
  return find.byWidgetPredicate(
    (widget) =>
        widget is OpenVtsSearchableDropdown<String> &&
        widget.label == 'Timezone',
  );
}

Finder _visibleOption(String value) {
  return find.descendant(
    of: find.byType(ListView).last,
    matching: find.text(value),
  );
}

Future<void> _openTimezone(WidgetTester tester) async {
  final dropdown = _timezoneDropdown();
  await tester.ensureVisible(dropdown);
  await tester.pumpAndSettle();
  await tester.tap(dropdown);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('timezone search is case-insensitive and preserves selection', (
    tester,
  ) async {
    await tester.pumpWidget(_app(_state(timezone: 'UTC')));
    await _openTimezone(tester);

    final searchField = find.byType(TextField).last;
    for (final expectation in const {
      'KoLkAtA': 'Asia/Kolkata',
      'america': 'America/New_York',
      'utc': 'UTC',
      'LONDON': 'Europe/London',
    }.entries) {
      await tester.enterText(searchField, expectation.key);
      await tester.pump();
      expect(_visibleOption(expectation.value), findsOneWidget);
    }

    await tester.enterText(searchField, 'america');
    await tester.pump();
    await tester.tap(_visibleOption('America/New_York'));
    await tester.pumpAndSettle();

    expect(find.text('America/New_York'), findsNWidgets(2));
  });

  testWidgets('timezone keeps a current value missing from the options', (
    tester,
  ) async {
    const currentValue = 'Custom/Exact_Timezone';
    await tester.pumpWidget(_app(_state(timezone: currentValue)));

    expect(find.text(currentValue), findsNWidgets(2));

    await _openTimezone(tester);
    await tester.enterText(find.byType(TextField).last, 'exact_timezone');
    await tester.pump();

    expect(_visibleOption(currentValue), findsOneWidget);
  });
}
