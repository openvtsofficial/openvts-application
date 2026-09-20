import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/features/user/controllers/user_providers.dart';
import 'package:open_vts/features/user/controllers/user_settings_controller.dart';
import 'package:open_vts/features/user/models/user_settings_model.dart';
import 'package:open_vts/features/user/models/user_settings_state.dart';
import 'package:open_vts/features/user/screens/settings/widgets/user_profile_edit_sheet.dart';
import 'package:open_vts/shared/widgets/open_vts_searchable_dropdown.dart';

// ---------------------------------------------------------------------------
// Fixtures
// ---------------------------------------------------------------------------

const _prefixes = [
  UserMobilePrefixOption(value: '+91', label: '+91', countryCode: 'IN'),
  UserMobilePrefixOption(value: '+1', label: '+1', countryCode: 'US'),
  UserMobilePrefixOption(value: '+44', label: '+44', countryCode: 'GB'),
  UserMobilePrefixOption(value: '+971', label: '+971', countryCode: 'AE'),
];

const _profile = UserSettingsProfile(
  name: 'Test User',
  mobilePrefix: '+91',
  mobileNumber: '9876543210',
);

const _profileNoPrefix = UserSettingsProfile(
  name: 'Test User',
  mobilePrefix: null,
  mobileNumber: '',
);

// ---------------------------------------------------------------------------
// Fake controller
// ---------------------------------------------------------------------------

class _FakeController extends StateNotifier<UserSettingsState>
    implements UserSettingsController {
  _FakeController(super.state);

  @override
  dynamic noSuchMethod(Invocation invocation) {}
}

UserSettingsState _makeState({
  List<UserMobilePrefixOption> prefixes = _prefixes,
  List<UserCountryOption> countries = const [],
}) {
  return const UserSettingsState.initial().copyWith(
    mobilePrefixes: prefixes,
    countries: countries,
  );
}

Widget _pump({
  UserSettingsProfile profile = _profile,
  List<UserMobilePrefixOption> prefixes = _prefixes,
}) {
  final fakeController = _FakeController(_makeState(prefixes: prefixes));
  return ProviderScope(
    overrides: [
      userSettingsControllerProvider.overrideWith(
        (_) => _FakeController(_makeState(prefixes: prefixes)),
      ),
    ],
    child: MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: UserProfileEditSheet(
            profile: profile,
            controller: fakeController,
          ),
        ),
      ),
    ),
  );
}

// Scope text finders to the bottom-sheet picker only.
Finder _inPicker(String text) => find.descendant(
      of: find.byType(BottomSheet),
      matching: find.text(text),
    );

Finder _searchField() => find.widgetWithText(TextField, 'Dial code or country');

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('UserProfileEditSheet — mobile prefix: catalogue path', () {
    testWidgets(
        'renders OpenVtsSearchableDropdown when prefix catalogue is available',
        (tester) async {
      await tester.pumpWidget(_pump());
      await tester.pumpAndSettle();

      expect(find.byType(OpenVtsSearchableDropdown<String>), findsOneWidget);
      expect(find.byType(DropdownButtonFormField<String>), findsNothing);
    });

    testWidgets('shows pre-selected dial code in trigger', (tester) async {
      await tester.pumpWidget(_pump());
      await tester.pumpAndSettle();

      expect(find.text('+91'), findsAtLeastNWidgets(1));
    });

    testWidgets('picker opens with search field', (tester) async {
      await tester.pumpWidget(_pump());
      await tester.pumpAndSettle();

      await tester.tap(find.byType(OpenVtsSearchableDropdown<String>));
      await tester.pumpAndSettle();

      expect(_searchField(), findsOneWidget);
    });

    testWidgets('picker lists all prefix options', (tester) async {
      await tester.pumpWidget(_pump());
      await tester.pumpAndSettle();

      await tester.tap(find.byType(OpenVtsSearchableDropdown<String>));
      await tester.pumpAndSettle();

      expect(_inPicker('+91'), findsOneWidget);
      expect(_inPicker('+1'), findsOneWidget);
      expect(_inPicker('+44'), findsOneWidget);
      expect(_inPicker('+971'), findsOneWidget);
    });
  });

  group('UserProfileEditSheet — mobile prefix: search', () {
    testWidgets('searching by dial code filters results', (tester) async {
      await tester.pumpWidget(_pump(profile: _profileNoPrefix));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(OpenVtsSearchableDropdown<String>));
      await tester.pumpAndSettle();

      await tester.enterText(_searchField(), '44');
      await tester.pump();

      expect(_inPicker('+44'), findsOneWidget);
      expect(_inPicker('+91'), findsNothing);
      expect(_inPicker('+1'), findsNothing);
    });

    testWidgets('searching by country code (uppercase) filters results',
        (tester) async {
      await tester.pumpWidget(_pump(profile: _profileNoPrefix));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(OpenVtsSearchableDropdown<String>));
      await tester.pumpAndSettle();

      await tester.enterText(_searchField(), 'AE');
      await tester.pump();

      expect(_inPicker('+971'), findsOneWidget);
      expect(_inPicker('+91'), findsNothing);
      expect(_inPicker('+1'), findsNothing);
    });

    testWidgets('search is case-insensitive ("gb" → +44)', (tester) async {
      await tester.pumpWidget(_pump(profile: _profileNoPrefix));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(OpenVtsSearchableDropdown<String>));
      await tester.pumpAndSettle();

      await tester.enterText(_searchField(), 'gb');
      await tester.pump();

      expect(_inPicker('+44'), findsOneWidget);
      expect(_inPicker('+91'), findsNothing);
    });

    testWidgets('no-match query shows empty state without throwing',
        (tester) async {
      await tester.pumpWidget(_pump(profile: _profileNoPrefix));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(OpenVtsSearchableDropdown<String>));
      await tester.pumpAndSettle();

      await tester.enterText(_searchField(), 'ZZZZ');
      await tester.pump();

      expect(_inPicker('+91'), findsNothing);
      expect(_inPicker('+1'), findsNothing);
      expect(tester.takeException(), isNull);
    });
  });

  group('UserProfileEditSheet — mobile prefix: selection', () {
    testWidgets('selecting a prefix updates the trigger display',
        (tester) async {
      await tester.pumpWidget(_pump(profile: _profileNoPrefix));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(OpenVtsSearchableDropdown<String>));
      await tester.pumpAndSettle();

      await tester.tap(_inPicker('+44'));
      await tester.pumpAndSettle();

      expect(find.text('+44'), findsAtLeastNWidgets(1));
    });

    testWidgets('search then select returns correct canonical dial code',
        (tester) async {
      await tester.pumpWidget(_pump(profile: _profileNoPrefix));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(OpenVtsSearchableDropdown<String>));
      await tester.pumpAndSettle();

      await tester.enterText(_searchField(), 'US');
      await tester.pump();

      await tester.tap(_inPicker('+1'));
      await tester.pumpAndSettle();

      expect(find.text('+1'), findsAtLeastNWidgets(1));
    });
  });

  group('UserProfileEditSheet — mobile prefix: manual fallback', () {
    testWidgets(
        'renders TextFormField (not searchable dropdown) when no catalogue',
        (tester) async {
      await tester.pumpWidget(_pump(
        profile: _profileNoPrefix,
        prefixes: const [],
      ));
      await tester.pumpAndSettle();

      // No searchable dropdown when catalogue is empty.
      expect(find.byType(OpenVtsSearchableDropdown<String>), findsNothing);
      // The fallback TextFormField is rendered with the 'Mobile Prefix' label.
      expect(
        find.widgetWithText(TextFormField, 'Mobile Prefix'),
        findsOneWidget,
      );
    });

    testWidgets('manual field accepts typed dial code', (tester) async {
      await tester.pumpWidget(_pump(
        profile: _profileNoPrefix,
        prefixes: const [],
      ));
      await tester.pumpAndSettle();

      // Confirm no searchable dropdown — user must type manually.
      expect(find.byType(OpenVtsSearchableDropdown<String>), findsNothing);

      // Find the manual prefix text field by its label and enter a value.
      final prefixField = find.widgetWithText(TextFormField, 'Mobile Prefix');
      expect(prefixField, findsOneWidget);
      await tester.enterText(prefixField, '+49');
      expect(find.text('+49'), findsOneWidget);
    });
  });
}
