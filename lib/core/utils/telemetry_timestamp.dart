/// Parses API/socket timestamps without confusing epoch strings with ISO dates.
/// UTC epoch values may be seconds, milliseconds, microseconds or nanoseconds.
DateTime? parseTelemetryTimestamp(Object? value) {
  if (value is DateTime) return value;
  num? epoch;
  if (value is num) {
    epoch = value;
  } else if (value is String) {
    final text = value.trim();
    if (text.isEmpty) return null;
    if (RegExp(r'^-?\d+(?:\.\d+)?$').hasMatch(text)) {
      epoch = num.tryParse(text);
    } else {
      return DateTime.tryParse(text);
    }
  }
  if (epoch == null || !epoch.isFinite) return null;
  final magnitude = epoch.abs();
  final milliseconds = magnitude >= 100000000000000000
      ? epoch / 1000000
      : magnitude >= 100000000000000
      ? epoch / 1000
      : magnitude < 100000000000
      ? epoch * 1000
      : epoch;
  if (milliseconds.abs() > 8640000000000000) return null;
  return DateTime.fromMillisecondsSinceEpoch(milliseconds.round(), isUtc: true);
}
