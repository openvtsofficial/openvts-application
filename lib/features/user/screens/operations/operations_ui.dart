import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/api/api_exception.dart';
import '../../models/user_operation_schedule.dart';
import 'operations_localizations.dart';

String operationDateKey(DateTime value) =>
    DateFormat('yyyy-MM-dd').format(value);
String operationClock(TimeOfDay value) =>
    '${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';
String operationDate(
  dynamic value, {
  String? timezone,
  String? locale,
  BuildContext? context,
}) {
  final parsed = DateTime.tryParse('${value ?? ''}');
  if (parsed == null) return '—';
  final accountZone = timezone?.trim() ?? '';
  final date = accountZone.isEmpty
      ? parsed.toLocal()
      : operationAccountNow(accountZone, instant: parsed);
  final suffix = accountZone.isEmpty
      ? (context?.operationText('Device time') ?? 'device time')
      : accountZone;
  return '${DateFormat('d MMM y, HH:mm', locale ?? (context == null ? null : Localizations.localeOf(context).toLanguageTag())).format(date)} ($suffix)';
}

String operationLabel(BuildContext context, String value) {
  final label = value
      .replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (m) => '${m[1]} ${m[2]}')
      .replaceAll('_', ' ')
      .toLowerCase()
      .split(' ')
      .map((s) => s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}')
      .join(' ');
  const localizedLabels = {
    'Date Only',
    'Fixed Time',
    'Time Slot',
    'Multi Day',
    'Assigned',
    'Acknowledged',
    'In Progress',
    'Completed',
    'Failed',
    'Cancelled',
    'Active',
    'Paused',
    'Ended',
    'On Trip',
    'No Assignment',
    'Attention',
    'Pending',
    'Running',
    'Missed',
    'Vehicle Inactive',
    'Vehicle License Blocked',
    'Driver Required',
    'Unavailable',
    'Not Started',
    'Late',
    'Driver Exception',
    'No Telemetry',
    'Route Deviation',
    'Start',
    'Complete',
    'Cancel',
    'Add Remark',
    'Pause',
    'Resume',
    'End',
    'Delete',
    'Live',
    'Stale',
    'Vehicle Gps',
    'Driver',
    'Fleet Manager',
    'System Automation',
    'Assignment Created',
    'Assignment Acknowledged',
    'Trip Auto Started',
    'Trip Auto Completed',
    'Trip Driver Completed',
    'Stop Auto Arrived',
    'Stop Auto Completed',
    'Stop Driver Completed',
    'Route Deviation Started',
    'Route Deviation Cleared',
    'No Telemetry Started',
    'No Telemetry Cleared',
    'Overspeed Started',
    'Overspeed Cleared',
    'Arrived',
    'Skipped',
    'Total Trips',
    'Upcoming',
    'Delayed',
    'On Time Completed Trips',
    'On Time Percent',
    'Distance Km',
  };
  // Future server codes remain readable; only registered UI labels are localized.
  return localizedLabels.contains(label) ? context.operationText(label) : label;
}

String operationError(BuildContext context, Object error) =>
    error is ApiException
    ? error.message
    : context.operationText(
        'The request could not be completed. Please refresh and try again.',
      );
