import 'package:flutter/services.dart';

/// Resolves a backend-valid report timezone.
///
/// Android and iOS return an IANA identifier (for example `Asia/Kolkata`).
/// Other platforms use an ECMA-402 offset identifier, which is also accepted
/// by the backend's `Intl.DateTimeFormat` validation.
class PlatformTimeZone {
  const PlatformTimeZone._();

  static const MethodChannel _channel = MethodChannel('openvts/timezone');

  static Future<String> current() async {
    try {
      final identifier =
          (await _channel.invokeMethod<String>('getLocalTimezone'))?.trim();
      final normalized = _normalizeNativeIdentifier(identifier);
      if (normalized != null) {
        return normalized;
      }
    } on MissingPluginException {
      // Web and unsupported desktop platforms use the offset fallback.
    } on PlatformException {
      // A valid fallback is preferable to blocking every report request.
    }

    final totalMinutes = DateTime.now().timeZoneOffset.inMinutes;
    if (totalMinutes == 0) {
      return 'UTC';
    }
    final absoluteMinutes = totalMinutes.abs();
    final hours = (absoluteMinutes ~/ 60).toString().padLeft(2, '0');
    final minutes = (absoluteMinutes % 60).toString().padLeft(2, '0');
    final sign = totalMinutes < 0 ? '-' : '+';
    return '$sign$hours:$minutes';
  }

  static String? _normalizeNativeIdentifier(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    if (value == 'GMT' || value == 'UTC') {
      return 'UTC';
    }

    // Android may expose custom zones as GMT+05:30, while ECMA-402 accepts
    // the equivalent offset identifier +05:30.
    final customOffset = RegExp(
      r'^(?:GMT|UTC)([+-])(\d{1,2})(?::?(\d{2}))?$',
      caseSensitive: false,
    ).firstMatch(value);
    if (customOffset != null) {
      final hours = int.tryParse(customOffset.group(2) ?? '');
      final minutes = int.tryParse(customOffset.group(3) ?? '0');
      if (hours != null && minutes != null && hours <= 23 && minutes <= 59) {
        return '${customOffset.group(1)}'
            '${hours.toString().padLeft(2, '0')}:'
            '${minutes.toString().padLeft(2, '0')}';
      }
      return null;
    }

    return value;
  }
}
