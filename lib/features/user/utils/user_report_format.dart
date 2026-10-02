// Report formatting utilities — mirrors web report-format.ts behaviour.

const int kChartMaxPoints = 200;
const int kDrivenMaxDayColumns = 31;
const int kLogPayloadMaxLength = 2000; // on-screen display cap
const int kSpeedLimitMin = 10;
const int kSpeedLimitMax = 300;
const List<int> kSpeedLimitPresets = [50, 60, 80, 100, 120];

/// Format a duration given in seconds into a human-readable string.
/// Mirrors web: "1d 4h 23m", never negative.
String formatDurationSeconds(double totalSeconds) {
  if (!totalSeconds.isFinite || totalSeconds <= 0) return '0m';
  final total = totalSeconds.round().abs();
  final days = total ~/ 86400;
  final hours = (total % 86400) ~/ 3600;
  final minutes = (total % 3600) ~/ 60;

  final parts = <String>[];
  if (days > 0) parts.add('${days}d');
  if (hours > 0) parts.add('${hours}h');
  if (minutes > 0 || parts.isEmpty) parts.add('${minutes}m');
  return parts.join(' ');
}

/// Format lat/lon to 5 decimal places. Returns '—' for invalid.
String formatCoordinate(double? lat, double? lon) {
  if (lat == null || lon == null) return '—';
  if (!lat.isFinite || !lon.isFinite) return '—';
  return '${lat.toStringAsFixed(5)}, ${lon.toStringAsFixed(5)}';
}

/// Returns the honest location label used for overspeed display and export.
/// An API-provided address wins; coordinates are only a fallback label.
String resolveOverspeedLocation(String? address, double? lat, double? lon) {
  final normalizedAddress = address?.trim();
  if (normalizedAddress != null && normalizedAddress.isNotEmpty) {
    return normalizedAddress;
  }
  if (lat != null && lon != null && lat.isFinite && lon.isFinite) {
    return formatCoordinate(lat, lon);
  }
  return '-';
}

/// Returns a geo: URI string for map launches, null if coordinates invalid.
String? geoUri(double? lat, double? lon) {
  if (lat == null || lon == null) return null;
  if (!lat.isFinite || !lon.isFinite) return null;
  if (lat < -90 || lat > 90 || lon < -180 || lon > 180) return null;
  return 'geo:$lat,$lon?q=$lat,$lon';
}

/// Overspeed severity tiers — mirrors web getOverspeedSeverity().
enum OverspeedSeverity { critical, high, medium, low }

OverspeedSeverity getOverspeedSeverity(double excessKmh) {
  if (excessKmh >= 30) return OverspeedSeverity.critical;
  if (excessKmh >= 20) return OverspeedSeverity.high;
  if (excessKmh >= 10) return OverspeedSeverity.medium;
  return OverspeedSeverity.low;
}

/// Validate a user-entered speed limit string. Returns int value or null.
int? validateSpeedLimit(String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) return null;
  final n = int.tryParse(trimmed);
  if (n == null) return null;
  if (n < kSpeedLimitMin || n > kSpeedLimitMax) return null;
  return n;
}

/// Derive YYYY-MM-DD calendar days between startDate and endDate inclusive.
/// Operates purely on calendar strings — no timezone shifting.
List<String> getDateRangeDays(String startDate, String endDate) {
  final parts1 = startDate.split('-').map(int.parse).toList();
  final parts2 = endDate.split('-').map(int.parse).toList();
  if (parts1.length != 3 || parts2.length != 3) return [];
  var current = DateTime.utc(parts1[0], parts1[1], parts1[2]);
  final end = DateTime.utc(parts2[0], parts2[1], parts2[2]);
  final days = <String>[];
  while (!current.isAfter(end)) {
    final y = current.year.toString();
    final m = current.month.toString().padLeft(2, '0');
    final d = current.day.toString().padLeft(2, '0');
    days.add('$y-$m-$d');
    current = current.add(const Duration(days: 1));
  }
  return days;
}

/// LTTB (Largest-Triangle-Three-Buckets) downsampling for chart data.
/// Returns a new list with at most [maxPoints] items.
/// Preserves first and last points always.
/// Does NOT mutate input.
List<T> downsampleLTTB<T>({
  required List<T> data,
  required int maxPoints,
  required double Function(T) getX,
  required double Function(T) getY,
}) {
  if (data.length <= maxPoints || maxPoints < 3) return data;

  final sampled = <T>[];
  final bucketSize = (data.length - 2) / (maxPoints - 2);

  sampled.add(data.first);

  var prevIdx = 0;
  for (var i = 1; i < maxPoints - 1; i++) {
    final start = ((i - 1) * bucketSize).floor() + 1;
    final end = ((i * bucketSize).floor() + 1).clamp(0, data.length - 1);

    final nextStart = (i * bucketSize).floor() + 1;
    final nextEnd =
        (((i + 1) * bucketSize).floor() + 1).clamp(0, data.length - 1);

    var avgX = 0.0, avgY = 0.0, count = 0;
    for (var j = nextStart; j < nextEnd; j++) {
      avgX += getX(data[j]);
      avgY += getY(data[j]);
      count++;
    }
    if (count > 0) {
      avgX /= count;
      avgY /= count;
    }

    var maxArea = -1.0;
    var maxIdx = start;
    final prevX = getX(data[prevIdx]);
    final prevY = getY(data[prevIdx]);
    for (var j = start; j < end; j++) {
      final area = ((prevX - avgX) * (getY(data[j]) - prevY) -
              (prevX - getX(data[j])) * (avgY - prevY))
          .abs();
      if (area > maxArea) {
        maxArea = area;
        maxIdx = j;
      }
    }
    sampled.add(data[maxIdx]);
    prevIdx = maxIdx;
  }

  sampled.add(data.last);
  return sampled;
}

/// Truncate a payload string for on-screen display.
/// Returns (text, wasTruncated).
({String text, bool truncated}) truncatePayload(String? payload,
    {int maxLength = kLogPayloadMaxLength}) {
  if (payload == null || payload.isEmpty) return (text: '', truncated: false);
  if (payload.length <= maxLength) return (text: payload, truncated: false);
  return (text: payload.substring(0, maxLength), truncated: true);
}

/// Count inclusive calendar days between two YYYY-MM-DD strings.
int countDateRangeDays(String startDate, String endDate) {
  return getDateRangeDays(startDate, endDate).length;
}
