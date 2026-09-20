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

void main() {
  testWidgets('date format searches label and value and updates selection', (
    tester,
  ) async {
    final state = const AdminSettingsState.initial().copyWith(
      localization: const AdminLocalizationSettings(
        dateFormat: 'YYYY-MM-DD',
      ),
      dateFormats: const [
        AdminDateFormatOption(
          value: 'YYYY-MM-DD',
          label: 'Year first',
        ),
        AdminDateFormatOption(
          value: 'DD/MM/YYYY',
          label: 'Day first',
        ),
        AdminDateFormatOption(
          value: 'MM.DD.YYYY',
          label: 'US dotted',
        ),
      ],
      timezones: const ['+00:00'],
    );

    await tester.pumpWidget(
      ProviderScope(
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
      ),
    );

    final selectedFormat = find.text('Year first');
    await tester.ensureVisible(selectedFormat);
    await tester.pumpAndSettle();
    await tester.tap(selectedFormat);
    await tester.pumpAndSettle();

    final searchField = find.byType(TextField).last;
    await tester.enterText(searchField, 'Day first');
    await tester.pump();
    expect(find.text('Day first'), findsNWidgets(2));
    expect(find.text('US dotted'), findsNothing);

    await tester.enterText(searchField, 'MM.DD.YYYY');
    await tester.pump();
    expect(find.text('US dotted'), findsOneWidget);
    expect(find.text('Day first'), findsNothing);

    await tester.tap(find.text('US dotted'));
    await tester.pumpAndSettle();

    expect(find.text('US dotted'), findsOneWidget);
  });
}
