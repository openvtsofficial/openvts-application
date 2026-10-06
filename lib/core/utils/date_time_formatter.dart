import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../l10n/app_localizations.dart';
import '../providers/app_preferences_provider.dart';

// ---------------------------------------------------------------------------
// Global date format config — updated by AppLocalizationPreferencesController
// so that ALL existing DateTimeFormatter usages automatically pick up the
// user's selected format without per-screen migration.
// ---------------------------------------------------------------------------

String _globalDatePattern = 'dd MMM yyyy';
String _globalTimePattern = 'hh:mm a';
String _globalDisplayLocale = 'en';

/// Called by the preferences controller whenever localization settings change.
/// This updates the format used by every [DateTimeFormatter] instance in the app.
void updateGlobalDateFormatConfig({
  required String datePattern,
  required bool use24Hour,
  String locale = 'en',
}) {
  _globalDatePattern = _toIntlPattern(datePattern);
  _globalTimePattern = use24Hour ? 'HH:mm' : 'hh:mm a';
  _globalDisplayLocale = locale;
}

// ---------------------------------------------------------------------------
// DateTimeFormatter — now reads from global config instead of hardcoded values.
// All 85+ existing usages automatically get the user's preferred format.
// ---------------------------------------------------------------------------

class DateTimeFormatter {
  const DateTimeFormatter();

  String formatDateTime(DateTime value) {
    try {
      return DateFormat(
        '$_globalDatePattern, $_globalTimePattern',
        _globalDisplayLocale,
      ).format(value.toLocal());
    } catch (_) {
      return DateFormat(
        'dd MMM yyyy, hh:mm a',
        'en_US',
      ).format(value.toLocal());
    }
  }

  String formatDate(DateTime value) {
    try {
      return DateFormat(
        _globalDatePattern,
        _globalDisplayLocale,
      ).format(value.toLocal());
    } catch (_) {
      return DateFormat('dd MMM yyyy', 'en_US').format(value.toLocal());
    }
  }

  String formatTime(DateTime value) {
    try {
      return DateFormat(
        _globalTimePattern,
        _globalDisplayLocale,
      ).format(value.toLocal());
    } catch (_) {
      return DateFormat('hh:mm a', 'en_US').format(value.toLocal());
    }
  }
}

// ---------------------------------------------------------------------------
// AppDateFormatter — provider-aware, null-safe, with relative time support.
// Preferred for new code: ref.watch(appDateFormatterProvider).formatDate(value)
// ---------------------------------------------------------------------------

class AppDateFormatter {
  const AppDateFormatter({
    required this.datePattern,
    required this.use24Hour,
    this.timezone = '',
    this.locale = 'en',
  });

  final String datePattern;
  final bool use24Hour;
  final String timezone;
  final String locale;

  String get _intlDatePattern => _toIntlPattern(datePattern);

  String get _timePattern => use24Hour ? 'HH:mm' : 'hh:mm a';

  /// Web display follows the browser/device timezone. The saved account
  /// timezone is retained for scheduling/settings, never added to a local date.
  DateTime _applyTimezone(DateTime value) => value.toLocal();

  String formatDateTime(DateTime? value) {
    if (value == null) return '';
    try {
      final adjusted = _applyTimezone(value);
      return DateFormat(
        '$_intlDatePattern, $_timePattern',
        locale,
      ).format(adjusted);
    } catch (_) {
      return _fallbackDateTime(value);
    }
  }

  String formatDate(DateTime? value) {
    if (value == null) return '';
    try {
      final adjusted = _applyTimezone(value);
      return DateFormat(_intlDatePattern, locale).format(adjusted);
    } catch (_) {
      return _fallbackDate(value);
    }
  }

  String formatTime(DateTime? value) {
    if (value == null) return '';
    try {
      final adjusted = _applyTimezone(value);
      return DateFormat(_timePattern, locale).format(adjusted);
    } catch (_) {
      return _fallbackTime(value);
    }
  }

  String formatTimeWithSeconds(DateTime? value) {
    if (value == null) return '';
    final adjusted = _applyTimezone(value);
    final pattern = use24Hour ? 'HH:mm:ss' : 'hh:mm:ss a';
    try {
      return DateFormat(pattern, locale).format(adjusted);
    } catch (_) {
      return DateFormat(pattern, 'en_US').format(adjusted);
    }
  }

  String formatDateTimeWithSeconds(DateTime? value) {
    if (value == null) return '';
    return '${formatDate(value)}, ${formatTimeWithSeconds(value)}';
  }

  /// Format relative time (e.g., "2h ago") falling back to date for older timestamps.
  String formatRelativeOrDate(DateTime? value) {
    if (value == null) return '';
    final now = DateTime.now();
    final diff = now.difference(value);
    final l10n = lookupAppLocalizations(Locale(flutterLanguageCodeFor(locale)));
    if (diff.inSeconds < 60 && diff.inSeconds >= 0) return l10n.relativeJustNow;
    if (diff.inMinutes < 60 && diff.inMinutes >= 0) {
      return l10n.relativeMinutesAgo(diff.inMinutes);
    }
    if (diff.inHours < 24 && diff.inHours >= 0) {
      return l10n.relativeHoursAgo(diff.inHours);
    }
    if (diff.inDays < 7 && diff.inDays >= 0) {
      return l10n.relativeDaysAgo(diff.inDays);
    }
    if (diff.inDays == 1) return l10n.relativeYesterday;
    return formatDate(value);
  }

  static String _fallbackDateTime(DateTime value) {
    return DateFormat('dd MMM yyyy, hh:mm a', 'en_US').format(value.toLocal());
  }

  static String _fallbackDate(DateTime value) {
    return DateFormat('dd MMM yyyy', 'en_US').format(value.toLocal());
  }

  static String _fallbackTime(DateTime value) {
    return DateFormat('hh:mm a', 'en_US').format(value.toLocal());
  }
}

// ---------------------------------------------------------------------------
// Shared pattern converter
// ---------------------------------------------------------------------------

/// Converts backend/web date pattern tokens to Dart intl tokens.
/// Backend uses Moment.js-style: YYYY, YY, MM, DD, HH, mm, ss, A
/// Dart intl uses: yyyy, yy, MM, dd, HH, mm, ss, a
String _toIntlPattern(String pattern) {
  if (pattern.trim().isEmpty) return 'dd MMM yyyy';
  final normalized = switch (pattern.trim()) {
    'YYYY_MM_DD' => 'YYYY-MM-DD',
    'DD_MMM_YYYY' => 'DD MMM YYYY',
    'MMM_DD_YYYY' => 'MMM DD YYYY',
    _ => pattern.trim(),
  };
  return normalized
      .replaceAll('dddd', 'EEEE')
      .replaceAll('ddd', 'EEE')
      .replaceAll('YYYY', 'yyyy')
      .replaceAll('YY', 'yy')
      .replaceAll('DD', 'dd')
      .replaceAll('D', 'd');
}

// ---------------------------------------------------------------------------
// Provider
// ---------------------------------------------------------------------------

final appDateFormatterProvider = Provider<AppDateFormatter>((ref) {
  final prefs = ref.watch(appLocalizationPreferencesProvider);
  return AppDateFormatter(
    datePattern: prefs.dateFormat,
    use24Hour: prefs.use24Hour,
    timezone: prefs.timezone,
    locale: prefs.languageCode,
  );
});
