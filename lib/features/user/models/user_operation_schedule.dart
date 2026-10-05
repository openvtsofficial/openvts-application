import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

bool _timezonesReady = false;

/// Calendar dates and clock values are account-local inputs. They must not be
/// converted to the phone's zone before sending to the planning endpoint.
DateTime operationAccountNow(String timezone, {DateTime? instant}) {
  if (!_timezonesReady) {
    tzdata.initializeTimeZones();
    _timezonesReady = true;
  }
  final now = instant ?? DateTime.now();
  try {
    return tz.TZDateTime.from(now, tz.getLocation(timezone));
  } catch (_) {
    // The backend falls back to UTC when a stored timezone is invalid.
    return now.toUtc();
  }
}

String operationIsoDay(DateTime day) =>
    '${day.year.toString().padLeft(4, '0')}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';

/// Builds only the fields accepted by the selected schedule variant. This
/// prevents an end date from a previous selection changing a one-day trip.
Map<String, dynamic> operationSchedulePayload({
  required String title,
  required String remark,
  required int vehicleId,
  required int routeId,
  required bool recurring,
  required String scheduleType,
  required DateTime date,
  required String startTime,
  required String endTime,
  DateTime? endDate,
  Set<int> weekdays = const {},
  List<String> exceptionDates = const [],
  int? version,
  DateTime? earliestDate,
}) {
  if (title.trim().length < 2 || title.trim().length > 120) {
    throw const FormatException('Enter a title between 2 and 120 characters.');
  }
  if (remark.trim().length > 600) {
    throw const FormatException('Use at most 600 characters for the remark.');
  }
  if (vehicleId < 1 || routeId < 1) {
    throw const FormatException('Choose a vehicle and route.');
  }
  final allowed = recurring
      ? const ['FIXED_TIME', 'TIME_SLOT']
      : const ['DATE_ONLY', 'FIXED_TIME', 'TIME_SLOT', 'MULTI_DAY'];
  if (!allowed.contains(scheduleType)) {
    throw const FormatException('Choose a valid schedule.');
  }
  final day = operationIsoDay(date);
  final lastDay = endDate == null ? null : operationIsoDay(endDate);
  if (earliestDate != null &&
      day.compareTo(operationIsoDay(earliestDate)) < 0) {
    throw const FormatException('Choose today or a later date.');
  }
  final clock = RegExp(r'^([01]\d|2[0-3]):[0-5]\d$');
  if (scheduleType != 'DATE_ONLY' && !clock.hasMatch(startTime)) {
    throw const FormatException('Choose a valid start time.');
  }
  if (scheduleType == 'TIME_SLOT' &&
      (!clock.hasMatch(endTime) || endTime.compareTo(startTime) <= 0)) {
    throw const FormatException('End time must be later than start time.');
  }
  if (scheduleType == 'MULTI_DAY' &&
      (lastDay == null ||
          !clock.hasMatch(endTime) ||
          '$lastDay $endTime'.compareTo('$day $startTime') <= 0)) {
    throw const FormatException('Completion must be after the start.');
  }
  if (recurring) {
    if (weekdays.isEmpty || weekdays.any((day) => day < 0 || day > 6)) {
      throw const FormatException('Choose at least one weekday.');
    }
    if (lastDay != null && lastDay.compareTo(day) < 0) {
      throw const FormatException(
        'Choose an end date on or after the start date.',
      );
    }
    if (exceptionDates.length > 100) {
      throw const FormatException('Use at most 100 skip dates');
    }
    for (final value in exceptionDates) {
      final parsed = DateTime.tryParse(value);
      if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value) ||
          parsed == null ||
          operationIsoDay(parsed) != value) {
        throw const FormatException('Use valid dates in YYYY-MM-DD format');
      }
      if (value.compareTo(day) < 0 ||
          (lastDay != null && value.compareTo(lastDay) > 0)) {
        throw const FormatException(
          'Skip dates must be inside the schedule date range.',
        );
      }
    }
  }
  if (version != null && version < 1) {
    throw const FormatException('Refresh this schedule before editing it.');
  }
  return {
    'title': title.trim(),
    'remark': remark.trim(),
    'vehicleId': vehicleId,
    'routeId': routeId,
    'scheduleType': scheduleType,
    if (recurring) ...{
      'startDate': day,
      'weekdays': weekdays.toList()..sort(),
      'exceptionDates': exceptionDates.toSet().toList()..sort(),
      if (lastDay != null)
        'endDate': lastDay
      else if (version != null)
        'endDate': null,
    } else
      'date': day,
    if (scheduleType != 'DATE_ONLY') 'startTime': startTime,
    if (scheduleType == 'TIME_SLOT' || scheduleType == 'MULTI_DAY')
      'endTime': endTime,
    if (scheduleType == 'MULTI_DAY') 'endDate': lastDay,
    if (version != null) 'version': version,
  };
}
