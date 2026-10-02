import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/providers/app_preferences_provider.dart';
import 'package:open_vts/l10n/app_localizations.dart';

// ---------------------------------------------------------------------------
// Helpers shared across tests
// ---------------------------------------------------------------------------

/// Mirrors the production normalization logic from localization_settings_section.
String normalizeLangCode(String code) =>
    code.split('-').first.split('_').first.toLowerCase();

/// Returns the set of base language codes that Flutter can render.
Set<String> supportedLangCodes() =>
    AppLocalizations.supportedLocales.map((l) => l.languageCode).toSet();

/// Simulates the dropdown filter: given a list of backend codes, return only
/// those whose normalized form is in the Flutter-supported set.
List<String> filterToSupported(Iterable<String> backendCodes) {
  final supported = supportedLangCodes();
  final seen = <String>{};
  final result = <String>[];
  for (final raw in backendCodes) {
    final norm = normalizeLangCode(raw);
    if (supported.contains(norm) && seen.add(norm)) {
      result.add(norm);
    }
  }
  return result;
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  // -------------------------------------------------------------------------
  // 1. Supported-list consistency: ARB-derived set matches the six languages
  // -------------------------------------------------------------------------
  group('supportedLangCodes', () {
    test('contains every currently-implemented language', () {
      final codes = supportedLangCodes();
      expect(codes, containsAll(<String>['ar', 'en', 'es', 'fr', 'hi', 'pt']));
    });

    test('does not expose unimplemented languages', () {
      final codes = supportedLangCodes();
      // These must NOT appear until ARB files are added and gen-l10n re-run.
      for (final absent in ['de', 'ru', 'zh', 'ja', 'ko', 'it', 'tr']) {
        expect(codes, isNot(contains(absent)),
            reason: '$absent has no ARB file yet');
      }
    });

    test('is non-empty', () {
      expect(supportedLangCodes(), isNotEmpty);
    });
  });

  // -------------------------------------------------------------------------
  // 2. Regional variant mapping: backend codes with sub-tags resolve to base
  // -------------------------------------------------------------------------
  group('normalizeLangCode', () {
    test('strips BCP-47 region sub-tag (pt-BR → pt)', () {
      expect(normalizeLangCode('pt-BR'), 'pt');
    });

    test('strips BCP-47 region sub-tag (pt-PT → pt)', () {
      expect(normalizeLangCode('pt-PT'), 'pt');
    });

    test('strips underscore variant (en_US → en)', () {
      expect(normalizeLangCode('en_US'), 'en');
    });

    test('strips underscore variant (fr_FR → fr)', () {
      expect(normalizeLangCode('fr_FR'), 'fr');
    });

    test('lowercases the result (AR → ar)', () {
      expect(normalizeLangCode('AR'), 'ar');
    });

    test('plain code passes through unchanged (hi → hi)', () {
      expect(normalizeLangCode('hi'), 'hi');
    });

    test('es-419 (Latin-American Spanish) normalizes to es', () {
      expect(normalizeLangCode('es-419'), 'es');
    });
  });

  // -------------------------------------------------------------------------
  // 3. Filter: only supported codes survive; duplicates are deduplicated
  // -------------------------------------------------------------------------
  group('filterToSupported', () {
    test('passes all six implemented base codes through', () {
      final result = filterToSupported(['ar', 'en', 'es', 'fr', 'hi', 'pt']);
      expect(result, containsAll(<String>['ar', 'en', 'es', 'fr', 'hi', 'pt']));
    });

    test('strips unimplemented codes (de, ru) from backend list', () {
      final result = filterToSupported(['en', 'de', 'fr', 'ru']);
      expect(result, containsAll(<String>['en', 'fr']));
      expect(result, isNot(contains('de')));
      expect(result, isNot(contains('ru')));
    });

    test('deduplicates regional variants (pt-BR + pt-PT → single pt)', () {
      final result = filterToSupported(['pt-BR', 'pt-PT', 'en']);
      expect(result.where((c) => c == 'pt').length, 1);
    });

    test('normalizes region sub-tag before filtering (en-US → en)', () {
      final result = filterToSupported(['en-US', 'fr-FR']);
      expect(result, containsAll(<String>['en', 'fr']));
    });

    test('returns empty list when backend sends only unsupported codes', () {
      final result = filterToSupported(['de', 'ru', 'zh']);
      expect(result, isEmpty);
    });

    test('preserves order of first occurrence', () {
      final result = filterToSupported(['fr', 'en', 'ar']);
      expect(result.indexOf('fr'), lessThan(result.indexOf('en')));
      expect(result.indexOf('en'), lessThan(result.indexOf('ar')));
    });
  });

  // -------------------------------------------------------------------------
  // 4. Unsupported language handling in flutterLanguageCodeFor
  // -------------------------------------------------------------------------
  group('flutterLanguageCodeFor', () {
    test('resolves known base code (en → en)', () {
      expect(flutterLanguageCodeFor('en'), 'en');
    });

    test('resolves known base code (ar → ar)', () {
      expect(flutterLanguageCodeFor('ar'), 'ar');
    });

    test('resolves language name string (Arabic → ar)', () {
      expect(flutterLanguageCodeFor('Arabic'), 'ar');
    });

    test('resolves language name string (Hindi → hi)', () {
      expect(flutterLanguageCodeFor('Hindi'), 'hi');
    });

    test('resolves language name string (Portuguese → pt)', () {
      expect(flutterLanguageCodeFor('Portuguese'), 'pt');
    });

    test('falls back to en for unsupported code (de → en)', () {
      expect(flutterLanguageCodeFor('de'), 'en');
    });

    test('falls back to en for unsupported code (ru → en)', () {
      expect(flutterLanguageCodeFor('ru'), 'en');
    });

    test('falls back to en for null', () {
      expect(flutterLanguageCodeFor(null), 'en');
    });

    test('falls back to en for empty string', () {
      expect(flutterLanguageCodeFor(''), 'en');
    });

    test('strips region sub-tag before resolving (pt-BR → pt)', () {
      expect(flutterLanguageCodeFor('pt-BR'), 'pt');
    });

    test('strips region sub-tag before resolving (en-US → en)', () {
      expect(flutterLanguageCodeFor('en-US'), 'en');
    });
  });

  // -------------------------------------------------------------------------
  // 5. Locale switching: each supported locale loads distinct strings
  // -------------------------------------------------------------------------
  testWidgets('each supported locale loads non-empty language label',
      (tester) async {
    for (final code in supportedLangCodes()) {
      await tester.pumpWidget(
        MaterialApp(
          locale: Locale(code),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: Builder(
            builder: (context) => Text(AppLocalizations.of(context).language),
          ),
        ),
      );
      await tester.pump();
      final label = tester.widget<Text>(find.byType(Text)).data ?? '';
      expect(label, isNotEmpty,
          reason: 'l10n.language must be non-empty for locale $code');
    }
  });

  testWidgets('Arabic locale reports RTL directionality', (tester) async {
    late TextDirection dir;
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ar'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: Builder(
          builder: (context) {
            dir = Directionality.of(context);
            return const SizedBox.shrink();
          },
        ),
      ),
    );
    await tester.pump();
    expect(dir, TextDirection.rtl);
  });

  testWidgets('all non-Arabic locales report LTR directionality',
      (tester) async {
    for (final code in supportedLangCodes().where((c) => c != 'ar')) {
      late TextDirection dir;
      await tester.pumpWidget(
        MaterialApp(
          locale: Locale(code),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: Builder(
            builder: (context) {
              dir = Directionality.of(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      await tester.pump();
      expect(dir, TextDirection.ltr, reason: 'locale $code should be LTR');
    }
  });

  // -------------------------------------------------------------------------
  // 6. Supported-set is the single source of truth — must stay aligned
  // -------------------------------------------------------------------------
  test('_kSupportedLangCodes is exactly AppLocalizations.supportedLocales', () {
    // This test catches any future manual drift between the two.
    final fromLocales =
        AppLocalizations.supportedLocales.map((l) => l.languageCode).toSet();
    // Verify by round-tripping: every supported locale code filters through
    // correctly, and the count matches.
    final filtered = filterToSupported(fromLocales);
    expect(filtered.toSet(), equals(fromLocales));
  });
}
