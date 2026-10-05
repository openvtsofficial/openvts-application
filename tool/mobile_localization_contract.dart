import 'dart:convert';
import 'dart:io';

/// A dependency-free source guard for the narrowly defined mobileText adapter.
/// It tokenizes strings/comments/interpolations instead of grepping quoted text,
/// so escaped quotes, adjacent literals and nested placeholder expressions work.
/// It does not attempt Dart semantic analysis; runtime UI behavior is tested by
/// widget tests. Dynamic adapter calls are separately reviewed below.
class LocalizationCall {
  const LocalizationCall(
    this.file,
    this.line,
    this.expression,
    this.source,
    this.fields,
  );
  final String file, expression;
  final int line;
  final String? source;
  final Set<String> fields;
  String get location => '$file:$line';
}

class LocalizationRegistration {
  const LocalizationRegistration(this.key, this.fields);
  final String key;
  final List<String> fields;
}

class LocalizationInspection {
  const LocalizationInspection(this.calls, this.registrations, this.errors);
  final List<LocalizationCall> calls;
  final Map<String, LocalizationRegistration> registrations;
  final List<String> errors;
}

const pluralAdapterSources = <String, String>{
  'mobilePluralTrips': '{value1} trip{value2}',
  'mobilePluralBlockedVehicles': '{value1} blocked vehicle{value2} excluded.',
  'mobilePluralSelectedVehicles': '{value1} vehicle{value2} selected',
  'mobilePluralUsers': '{value1} User{value2}',
  'mobilePluralActiveDays': '{value1} active day{value2}',
  'mobilePluralResults': '{value1} result{value2}',
  'mobilePluralVehicles': '{value1} vehicle{value2}',
  'mobilePluralPoints': '{value1} point{value2}',
};

LocalizationInspection inspectMobileLocalization(Directory project) {
  final helper = File(
    '${project.path}/lib/shared/helpers/mobile_text.dart',
  ).readAsStringSync();
  final registrations = readLocalizationRegistrations(helper);
  final en =
      jsonDecode(File('${project.path}/lib/l10n/app_en.arb').readAsStringSync())
          as Map<String, dynamic>;
  final errors = <String>[];
  final signatures = _signatures(
    File('${project.path}/lib/l10n/app_localizations.dart').readAsStringSync(),
  );
  for (final entry in registrations.entries) {
    final key = entry.value.key;
    if (pluralAdapterSources[key] == entry.key) {
      if (entry.value.fields.join(',') != 'value1' ||
          signatures[key]?.join(',') != 'count' ||
          !(en[key] is String &&
              (en[key] as String).startsWith('{count, plural,'))) {
        errors.add(
          'mobile_text: $key has an invalid numeric ICU plural adapter.',
        );
      }
      continue;
    }
    if (en[key] != entry.key) {
      errors.add('mobile_text: $key does not match its English source.');
    }
    final expected = _placeholders(entry.key);
    if (!_same(expected, entry.value.fields.toSet())) {
      errors.add('mobile_text: $key uses incorrect placeholder names.');
    }
    if (expected.isNotEmpty &&
        signatures[key]?.join(',') != entry.value.fields.join(',')) {
      errors.add(
        'mobile_text: $key arguments do not match generated parameter order (${signatures[key]} vs ${entry.value.fields}).',
      );
    }
  }
  final calls = <LocalizationCall>[];
  for (final file in Directory(
    '${project.path}/lib',
  ).listSync(recursive: true).whereType<File>()) {
    final path = file.path
        .substring(project.path.length + 1)
        .replaceAll('\\', '/');
    if (!path.endsWith('.dart') ||
        path.contains('/l10n/') ||
        path.endsWith('/mobile_text.dart') ||
        path.endsWith('/operations_localizations.dart')) {
      continue;
    }
    final text = file.readAsStringSync();
    if (!RegExp(r'\b(mobileText|operationText)\s*\(').hasMatch(text)) continue;
    for (final call in readLocalizationCalls(text, path)) {
      calls.add(call);
      if (call.source == null) continue;
      if (!registrations.containsKey(call.source)) {
        errors.add(
          '${call.location}: unregistered UI source ${jsonEncode(call.source)}',
        );
      }
      final expected = _placeholders(call.source!);
      if (!_same(expected, call.fields)) {
        errors.add(
          '${call.location}: placeholders should be $expected, found ${call.fields}.',
        );
      }
    }
  }
  return LocalizationInspection(calls, registrations, errors);
}

Map<String, LocalizationRegistration> readLocalizationRegistrations(
  String source,
) {
  final tokens = _Lexer(source).scan(),
      result = <String, LocalizationRegistration>{};
  for (var i = 0; i + 4 < tokens.length; i++) {
    if (tokens[i].kind != 'string' ||
        tokens[i].value == null ||
        tokens[i + 1].text != '=>' ||
        tokens[i + 2].text != 'l10n' ||
        tokens[i + 3].text != '.') {
      continue;
    }
    final key = tokens[i + 4].text;
    final end = _untilTopComma(tokens, i + 5);
    final fields = <String>[];
    for (var j = i + 5; j + 3 < end; j++) {
      if (tokens[j].text == 'values' &&
          tokens[j + 1].text == '[' &&
          tokens[j + 2].value != null &&
          tokens[j + 3].text == ']') {
        fields.add(tokens[j + 2].value!);
      }
    }
    result[tokens[i].value!] = LocalizationRegistration(key, fields);
  }
  return result;
}

List<LocalizationCall> readLocalizationCalls(
  String source,
  String file, {
  int lineOffset = 0,
}) {
  final lexer = _Lexer(source);
  final tokens = lexer.scan(), result = <LocalizationCall>[];
  for (var i = 0; i + 1 < tokens.length; i++) {
    if (!const {'mobileText', 'operationText'}.contains(tokens[i].text) ||
        tokens[i + 1].text != '(') {
      continue;
    }
    final end = _closing(tokens, i + 1),
        arguments = _arguments(tokens, i + 2, end);
    if (arguments.isEmpty || arguments.first.isEmpty) continue;
    final first = arguments.first;
    final literal = first.every((t) => t.kind == 'string' && t.value != null)
        ? first.map((t) => t.value).join()
        : null;
    final fields = <String>{};
    if (arguments.length > 1) {
      final map = arguments[1];
      final start = map.indexWhere((t) => t.text == '{');
      if (start < 0) {
        fields.add('<dynamic-map>');
      } else {
        var depth = 0;
        for (var j = start; j < map.length; j++) {
          final t = map[j];
          if (const {'{', '[', '('}.contains(t.text)) depth++;
          if (const {'}', ']', ')'}.contains(t.text)) depth--;
          if (depth == 1 && j + 1 < map.length && map[j + 1].text == ':') {
            fields.add(t.value ?? '<dynamic-key>');
          }
          if (depth == 1 && t.text == '...') fields.add('<map-spread>');
        }
      }
    }
    result.add(
      LocalizationCall(
        file,
        '\n'.allMatches(source.substring(0, tokens[i].start)).length +
            1 +
            lineOffset,
        source.substring(first.first.start, first.last.end),
        literal,
        fields,
      ),
    );
  }
  // Expressions embedded in Dart interpolation are executable code too.
  var coveredEnd = -1;
  for (final span
      in lexer.interpolations..sort((a, b) => a.$1.compareTo(b.$1))) {
    if (span.$1 < coveredEnd) continue;
    coveredEnd = span.$2;
    result.addAll(
      readLocalizationCalls(
        source.substring(span.$1, span.$2),
        file,
        lineOffset:
            lineOffset + '\n'.allMatches(source.substring(0, span.$1)).length,
      ),
    );
  }
  return result;
}

Map<String, List<String>> _signatures(String source) {
  final t = _Lexer(source).scan(), result = <String, List<String>>{};
  for (var i = 0; i + 2 < t.length; i++) {
    if (t[i].text != 'String' || t[i + 2].text != '(') continue;
    final end = _closing(t, i + 2);
    result[t[i + 1].text] = _arguments(
      t,
      i + 3,
      end,
    ).where((a) => a.isNotEmpty).map((a) => a.last.text).toList();
  }
  return result;
}

Set<String> _placeholders(String text) =>
    RegExp(r'\{(\w+)\}').allMatches(text).map((m) => m[1]!).toSet();
bool _same(Set<String> a, Set<String> b) =>
    a.length == b.length && a.containsAll(b);
int _closing(List<_Token> t, int open) {
  var depth = 0;
  for (var i = open; i < t.length; i++) {
    if (const {'(', '{', '['}.contains(t[i].text)) depth++;
    if (const {')', '}', ']'}.contains(t[i].text) && --depth == 0) return i;
  }
  return t.length;
}

int _untilTopComma(List<_Token> t, int start) {
  var depth = 0;
  for (var i = start; i < t.length; i++) {
    if (t[i].text == ',' && depth == 0) return i;
    if (const {'(', '{', '['}.contains(t[i].text)) depth++;
    if (const {')', '}', ']'}.contains(t[i].text)) depth--;
  }
  return t.length;
}

List<List<_Token>> _arguments(List<_Token> tokens, int start, int end) {
  final result = <List<_Token>>[];
  var from = start, depth = 0, angle = 0;
  for (var i = start; i < end; i++) {
    final text = tokens[i].text;
    if (text == ',' && depth == 0 && angle == 0) {
      result.add(tokens.sublist(from, i));
      from = i + 1;
    }
    if (const {'(', '{', '['}.contains(text)) depth++;
    if (const {')', '}', ']'}.contains(text)) depth--;
    if (text == '<' && depth == 0) angle++;
    if (text == '>' && angle > 0) angle--;
  }
  if (from < end) result.add(tokens.sublist(from, end));
  return result;
}

class _Token {
  const _Token(
    this.text,
    this.start,
    this.end, {
    this.kind = 'code',
    this.value,
  });
  final String text, kind;
  final String? value;
  final int start, end;
}

class _Lexer {
  _Lexer(this.source);
  final String source;
  final interpolations = <(int, int)>[];
  int cursor = 0;
  static final _space = RegExp(r'\s'), _identifier = RegExp(r'[A-Za-z_0-9$]');
  List<_Token> scan() {
    final tokens = <_Token>[];
    while (cursor < source.length) {
      if (_skipTrivia()) continue;
      final start = cursor, char = source[cursor];
      if (char == "'" ||
          char == '"' ||
          (char == 'r' &&
              cursor + 1 < source.length &&
              const ["'", '"'].contains(source[cursor + 1]))) {
        tokens.add(_string());
        continue;
      }
      if (_identifier.hasMatch(char)) {
        while (cursor < source.length && _identifier.hasMatch(source[cursor])) {
          cursor++;
        }
      } else if (source.startsWith('=>', cursor)) {
        cursor += 2;
      } else if (source.startsWith('...', cursor)) {
        cursor += 3;
      } else {
        cursor++;
      }
      tokens.add(_Token(source.substring(start, cursor), start, cursor));
    }
    return tokens;
  }

  bool _skipTrivia() {
    if (_space.hasMatch(source[cursor])) {
      cursor++;
      return true;
    }
    if (source.startsWith('//', cursor)) {
      while (cursor < source.length && source[cursor] != '\n') {
        cursor++;
      }
      return true;
    }
    if (source.startsWith('/*', cursor)) {
      var depth = 1;
      cursor += 2;
      while (cursor < source.length && depth > 0) {
        if (source.startsWith('/*', cursor)) {
          depth++;
          cursor += 2;
        } else if (source.startsWith('*/', cursor)) {
          depth--;
          cursor += 2;
        } else {
          cursor++;
        }
      }
      return true;
    }
    return false;
  }

  _Token _string() {
    final start = cursor, raw = source[cursor] == 'r';
    if (raw) cursor++;
    final quote = source[cursor],
        triple = source.startsWith(quote * 3, cursor),
        delimiter = triple ? quote * 3 : quote;
    cursor += delimiter.length;
    final value = StringBuffer();
    var interpolated = false;
    while (cursor < source.length) {
      if (source.startsWith(delimiter, cursor)) {
        cursor += delimiter.length;
        break;
      }
      var char = source[cursor++];
      if (!raw && char == '\\' && cursor < source.length) {
        char = source[cursor++];
        const escapes = {
          'n': '\n',
          'r': '\r',
          't': '\t',
          'b': '\b',
          'f': '\f',
          'v': '\x0b',
        };
        if (char == 'u' || char == 'x') {
          final braced =
              char == 'u' && cursor < source.length && source[cursor] == '{';
          if (braced) cursor++;
          final end = braced
              ? source.indexOf('}', cursor)
              : cursor + (char == 'u' ? 4 : 2);
          if (end >= cursor && end <= source.length) {
            final code = int.tryParse(source.substring(cursor, end), radix: 16);
            if (code != null) value.writeCharCode(code);
            cursor = end + (braced ? 1 : 0);
          }
        } else {
          value.write(escapes[char] ?? char);
        }
        continue;
      }
      if (!raw && char == r'$') {
        interpolated = true;
        if (cursor < source.length && source[cursor] == '{') {
          cursor++;
          _interpolation();
        }
        continue;
      }
      value.write(char);
    }
    return _Token(
      source.substring(start, cursor),
      start,
      cursor,
      kind: 'string',
      value: interpolated ? null : value.toString(),
    );
  }

  void _interpolation() {
    final start = cursor;
    var depth = 1;
    while (cursor < source.length && depth > 0) {
      if (_skipTrivia()) continue;
      final char = source[cursor];
      if (char == "'" ||
          char == '"' ||
          (char == 'r' &&
              cursor + 1 < source.length &&
              const ["'", '"'].contains(source[cursor + 1]))) {
        _string();
        continue;
      }
      if (char == '{') depth++;
      if (char == '}') depth--;
      cursor++;
    }
    interpolations.add((start, cursor - 1));
  }
}

void main(List<String> arguments) {
  final project = Directory(arguments.isEmpty ? '.' : arguments.first).absolute;
  final report = inspectMobileLocalization(project);
  stdout.writeln(
    'Localization: ${report.calls.where((c) => c.source != null).length} static calls, ${report.calls.where((c) => c.source == null).length} dynamic calls, ${report.registrations.length} registered sources.',
  );
  for (final error in report.errors) {
    stderr.writeln(error);
  }
  if (report.errors.isNotEmpty) exitCode = 1;
}
