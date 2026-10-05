import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/mobile_localization_contract.dart';

// Each dynamic source was reviewed against its producer. None contains user
// names, addresses, messages or API free text. Keep this list narrow: a new
// dynamic lookup must be traced back to a static UI catalog before approval.
const _reviewed = <String, Map<String, int>>{
  // Private, fixed replay-speed options.
  'lib/features/live_map/screens/live_map_screen.dart': {'option.label': 1},
  'lib/features/live_map/screens/replay/replay_widgets.dart': {
    'option.label': 1,
  },
  // Both entry maps are literal enum menus; action text comes from static UI callers.
  'lib/features/driver/screens/driver_trips_screen.dart': {
    'entry.value': 2,
    'success': 1,
    'title': 1,
    'explanation': 1,
  },
  'lib/features/driver/screens/driver_widgets.dart': {
    'driverStatusLabel(status)': 1,
  },
  // _contentForPrefix returns fixed empty-state messages, not activity payloads.
  'lib/features/superadmin/screens/administrators/widgets/admin_details_activity_tab.dart':
      {'title': 1, 'subtitle': 1},
  'lib/features/admin/screens/dashboard/widgets/admin_recent_vehicles_card.dart':
      {'status.label': 1},
  // Presets are the app's fixed city shortcut definitions.
  'lib/features/user/screens/settings/widgets/user_location_preset_chips.dart':
      {'preset.label': 1},
  'lib/features/user/screens/dashboard/widgets/user_recent_alerts_widget.dart':
      {'severity.label': 2},
  // KPI labels and catalog fields are static UI descriptors. Their values stay raw.
  'lib/features/user/screens/reports/widgets/user_report_kpi_row.dart': {
    'kpi.label': 1,
  },
  'lib/features/user/screens/reports/user_reports_catalog_screen.dart': {
    'e.title': 1,
    'e.description': 1,
    'entry.title': 1,
    'entry.description': 1,
  },
  'lib/features/user/screens/operations/user_operations_screen.dart': {
    "switch (_tab) {'recurring' => 'Recurring', 'drivers' => 'Drivers', _ => 'Trips'}":
        1,
  },
  // operationLabel checks a fixed localizedLabels set before entering the adapter.
  'lib/features/user/screens/operations/operations_ui.dart': {'label': 1},
  'lib/features/user/screens/landmarks/user_landmark_studio_screen.dart': {
    'option.label': 1,
    'option.description': 1,
    'option.cta': 1,
  },
  // Only predefined categories enter the adapter; custom category text stays raw.
  'lib/features/user/screens/landmarks/pois/user_poi_constants.dart': {
    'option.label': 1,
  },
  'lib/features/user/screens/landmarks/pois/widgets/user_poi_category_picker.dart':
      {'option.label': 1},
};
String _normalized(String value) => value
    .replaceAll(RegExp(r'\s+'), '')
    .replaceAll(RegExp(r',(?=[}\]\)])'), '');

void main() {
  test(
    'all static mobileText and operationText sources and placeholders are registered',
    () {
      final report = inspectMobileLocalization(Directory.current);
      expect(
        report.calls.where((c) => c.source != null).length,
        greaterThan(4000),
      );
      expect(report.registrations.length, greaterThan(2500));
      expect(report.errors, isEmpty, reason: report.errors.join('\n'));
    },
  );

  test(
    'dynamic translation sources remain restricted to reviewed UI catalogs',
    () {
      final report = inspectMobileLocalization(Directory.current);
      final actual = <String, int>{}, expected = <String, int>{};
      for (final file in _reviewed.entries) {
        for (final call in file.value.entries) {
          expected['${file.key}|${_normalized(call.key)}'] = call.value;
        }
      }
      for (final call in report.calls.where((c) => c.source == null)) {
        final key = '${call.file}|${_normalized(call.expression)}';
        actual[key] = (actual[key] ?? 0) + 1;
      }
      expect(
        actual,
        expected,
        reason:
            'Review new dynamic sources; use a literal template with placeholders for user/server text.',
      );
    },
  );

  test(
    'scanner handles escaped quotes, raw and adjacent literals, comments and interpolated nested calls',
    () {
      final calls = readLocalizationCalls(r'''
      // context.mobileText('not a call');
      /* outer /* context.mobileText('also not a call') */ comment */
      context.mobileText("She said \"Hi\"");
      context.operationText('Hello ' '{name}', {'name': row['name']});
      context.mobileText(r'File C:\route');
      Text('Nested ${context.mobileText('Save')}');
      context.mobileText('Amount {value}', <String, Object>{'value': (x > 4 ? x : 0)});
      context.mobileText('Unicode \u0041 \u{1f69a}');
    ''', 'fixture.dart');
      expect(calls.map((c) => c.source), [
        'She said "Hi"',
        'Hello {name}',
        r'File C:\route',
        'Amount {value}',
        'Unicode A 🚚',
        'Save',
      ]);
      expect(calls[1].fields, {'name'});
      expect(calls[3].fields, {'value'});
    },
  );

  test(
    'scanner identifies interpolated user content as dynamic, not a registered literal',
    () {
      final calls = readLocalizationCalls(
        r'''context.mobileText('User ${row['name']}'); context.mobileText(user.name);''',
        'fixture.dart',
      );
      expect(calls.length, 2);
      expect(calls.every((c) => c.source == null), isTrue);
    },
  );

  test(
    'guard catches unregistered new UI text and missing or extra placeholder arguments',
    () {
      final dir = _fixture(
        "context.mobileText('New unsupported label'); context.mobileText('Hello {name}', {'wrong': 'x'});",
      );
      addTearDown(() => dir.deleteSync(recursive: true));
      final report = inspectMobileLocalization(dir);
      expect(
        report.errors.any((e) => e.contains('unregistered UI source')),
        true,
      );
      expect(
        report.errors.any(
          (e) => e.contains('placeholders should be {name}, found {wrong}'),
        ),
        true,
      );
    },
  );

  test('guard catches swapped generated localization parameter order', () {
    final dir = _fixture("context.mobileText('Hello {name}', {'name': 'x'});");
    addTearDown(() => dir.deleteSync(recursive: true));
    File('${dir.path}/lib/l10n/app_localizations.dart').writeAsStringSync(
      'abstract class AppLocalizations { String hello(Object wrongName); }',
    );
    expect(
      inspectMobileLocalization(
        dir,
      ).errors.any((e) => e.contains('parameter order')),
      true,
    );
  });
}

Directory _fixture(String screen) {
  final dir = Directory.systemTemp.createTempSync(
    'openvts-localization-contract-',
  );
  Directory('${dir.path}/lib/shared/helpers').createSync(recursive: true);
  Directory('${dir.path}/lib/l10n').createSync(recursive: true);
  File('${dir.path}/lib/shared/helpers/mobile_text.dart').writeAsStringSync(r'''
    String mobileText(String source, Map<String,Object> values) => switch(source) {
      'Hello {name}' => l10n.hello(values['name'] ?? ''),
      'Save' => l10n.save,
      _ => source,
    };
  ''');
  File(
    '${dir.path}/lib/l10n/app_en.arb',
  ).writeAsStringSync(jsonEncode({'hello': 'Hello {name}', 'save': 'Save'}));
  File('${dir.path}/lib/l10n/app_localizations.dart').writeAsStringSync(
    'abstract class AppLocalizations { String hello(Object name); }',
  );
  File('${dir.path}/lib/screen.dart').writeAsStringSync(screen);
  return dir;
}
