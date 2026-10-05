import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  final english = _catalog('en');
  final keys = english.keys.where((key) => !key.startsWith('@')).toSet();
  for (final locale in ['ar', 'es', 'fr', 'hi', 'pt']) {
    test('$locale covers the complete English catalog and placeholders', () {
      final translated = _catalog(locale);
      expect(
        translated.keys.where((key) => !key.startsWith('@')).toSet(),
        keys,
      );
      for (final key in keys) {
        final value = translated[key] as String;
        expect(value.trim(), isNotEmpty, reason: '$locale:$key');
        expect(
          _placeholders(value),
          _placeholders(english[key] as String),
          reason: '$locale:$key must preserve interpolated user data',
        );
      }
    });
  }
}

Map<String, dynamic> _catalog(String locale) =>
    jsonDecode(File('lib/l10n/app_$locale.arb').readAsStringSync())
        as Map<String, dynamic>;

Set<String> _placeholders(String value) => RegExp(
  r'\{(\w+)\}',
).allMatches(value).map((match) => match.group(1)!).toSet();
