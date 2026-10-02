// Report query validation — mirrors web report-validation.ts behaviour exactly.

import '../models/user_report_model.dart';
import '../models/user_report_state.dart';
import 'user_report_format.dart';

/// Returns a map of fieldKey → error message. Empty map means valid.
Map<String, String> validateReportQuery({
  required UserReportKey reportKey,
  required ReportVehicleScope scope,
  required ReportDateRange? dateRange,
  required OverspeedFilters overspeedFilters,
  required SensorFilters sensorFilters,
  required TimelineFilters timelineFilters,
}) {
  final errors = <String, String>{};

  // --- Vehicle scope ---
  // Sensor and logs have inline vehicle pickers that report to their own keys.
  // All other reports use the shared scope selector keyed as 'scope'.
  final vehicleKey = switch (reportKey) {
    UserReportKey.sensor => 'sensorVehicle',
    UserReportKey.logs => 'logsVehicle',
    _ => 'scope',
  };

  if (reportKey.requiresSingleVehicle) {
    if (scope.mode != ReportScopeMode.single ||
        (scope.vehicleId?.isEmpty ?? true)) {
      errors[vehicleKey] = 'reportsValidationSingleVehicleRequired';
    }
  } else {
    switch (scope.mode) {
      case ReportScopeMode.single:
        if (scope.vehicleId?.isEmpty ?? true) {
          errors[vehicleKey] = 'reportsValidationSelectVehicle';
        }
      case ReportScopeMode.multiple:
        if (scope.vehicleIds.isEmpty) {
          errors[vehicleKey] = 'reportsValidationSelectAtLeastOne';
        }
      case ReportScopeMode.group:
        if (scope.groupId?.isEmpty ?? true) {
          errors[vehicleKey] = 'reportsValidationSelectGroup';
        }
      case ReportScopeMode.all:
        break;
    }
  }

  // --- Date range ---
  if (dateRange == null) {
    errors['startDate'] = 'reportsValidationStartDateRequired';
    errors['endDate'] = 'reportsValidationEndDateRequired';
  } else if (dateRange.mode == 'dateOnly') {
    final start = dateRange.startDate;
    final end = dateRange.endDate;
    if (start == null || start.isEmpty) {
      errors['startDate'] = 'reportsValidationStartDateRequired';
    } else if (end == null || end.isEmpty) {
      errors['endDate'] = 'reportsValidationEndDateRequired';
    } else {
      final startParsed = _parseDate(start);
      final endParsed = _parseDate(end);
      if (startParsed == null) {
        errors['startDate'] = 'reportsValidationStartDateRequired';
      } else if (endParsed == null) {
        errors['endDate'] = 'reportsValidationEndDateRequired';
      } else if (!startParsed.isBefore(endParsed) && startParsed != endParsed) {
        errors['startDate'] = 'reportsValidationStartBeforeEnd';
      } else {
        final dayCount = countDateRangeDays(start, end);
        if (dayCount > reportKey.maxDays) {
          errors['dateRange'] = 'reportsValidationRangeTooLong';
        }
      }
    }
  } else {
    // dateTime
    final fromStr = dateRange.fromISO;
    final toStr = dateRange.toISO;
    if (fromStr == null || fromStr.isEmpty) {
      errors['startDate'] = 'reportsValidationStartDateRequired';
    } else if (toStr == null || toStr.isEmpty) {
      errors['endDate'] = 'reportsValidationEndDateRequired';
    } else {
      final from = DateTime.tryParse(fromStr);
      final to = DateTime.tryParse(toStr);
      if (from == null) {
        errors['startDate'] = 'reportsValidationStartDateRequired';
      } else if (to == null) {
        errors['endDate'] = 'reportsValidationEndDateRequired';
      } else if (!from.isBefore(to)) {
        errors['startDate'] = 'reportsValidationStartBeforeEnd';
      } else {
        final dayCount = to.difference(from).inDays + 1;
        if (dayCount > reportKey.maxDays) {
          errors['dateRange'] = 'reportsValidationRangeTooLong';
        }
      }
    }
  }

  // --- Report-specific ---
  if (reportKey == UserReportKey.sensor) {
    if (sensorFilters.sensorIds.length != 1) {
      errors['sensorSensor'] = 'reportsValidationSelectSensor';
    }
  }

  if (reportKey == UserReportKey.overspeed) {
    final limit = overspeedFilters.speedLimitKmh;
    if (limit < kSpeedLimitMin || limit > kSpeedLimitMax) {
      errors['speedLimit'] = 'reportsOverspeedInvalidLimit';
    }
  }

  if (reportKey == UserReportKey.timeline) {
    if (timelineFilters.states.isEmpty) {
      errors['timelineState'] = 'reportsTimelineStateRequired';
    }
  }

  return errors;
}

DateTime? _parseDate(String s) {
  try {
    final parts = s.split('-').map(int.parse).toList();
    if (parts.length != 3) return null;
    return DateTime.utc(parts[0], parts[1], parts[2]);
  } catch (_) {
    return null;
  }
}

/// Build the default date range for a report key.
/// dateOnly reports default to today; dateTime reports default to today 00:01–23:59 local.
ReportDateRange buildDefaultDateRange(UserReportKey key) {
  final now = DateTime.now();
  if (key.usesDateOnly) {
    final today =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    return ReportDateRange.dateOnly(startDate: today, endDate: today);
  } else {
    final start = DateTime(now.year, now.month, now.day, 0, 1);
    final end = DateTime(now.year, now.month, now.day, 23, 59);
    return ReportDateRange.dateTime(
      from: start.toUtc().toIso8601String(),
      to: end.toUtc().toIso8601String(),
    );
  }
}

/// Builds UTC from/to DateTime from the report date range for the API call.
/// Returns null if the range is incomplete/invalid.
({DateTime from, DateTime to})? buildApiDateBounds(ReportDateRange range) {
  if (range.mode == 'dateOnly') {
    final start = _parseDate(range.startDate ?? '');
    final end = _parseDate(range.endDate ?? '');
    if (start == null || end == null) return null;
    // end is inclusive in UI → exclusive boundary = end + 1 day at midnight UTC
    final fromUtc = start; // already UTC midnight
    final toUtc = end.add(const Duration(days: 1)); // exclusive boundary
    return (from: fromUtc, to: toUtc);
  } else {
    final from = DateTime.tryParse(range.fromISO ?? '');
    final to = DateTime.tryParse(range.toISO ?? '');
    if (from == null || to == null) return null;
    return (from: from.toUtc(), to: to.toUtc());
  }
}
