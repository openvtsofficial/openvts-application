import 'package:flutter/material.dart';

import '../../../../../../core/theme/open_vts_spacing.dart';
import '../../../../../../core/theme/open_vts_typography.dart';
import '../../../../../../shared/helpers/mobile_text.dart';
import '../../../../../../shared/helpers/widget_localizations.dart';
import '../../../../../../shared/widgets/open_vts_date_time_range_selector.dart';
import '../../../../models/user_report_model.dart';
import '../../../../models/user_report_state.dart';

/// Report dates share the same calendar, presets and time controls as history.
/// Date-only requests retain civil dates. Date-time requests retain UTC instants.
class UserReportDateControl extends StatelessWidget {
  const UserReportDateControl({
    required this.reportKey,
    required this.dateRange,
    required this.onChanged,
    this.disabled = false,
    this.startError,
    this.endError,
    this.rangeError,
    this.now,
    super.key,
  });

  final UserReportKey reportKey;
  final ReportDateRange? dateRange;
  final ValueChanged<ReportDateRange?> onChanged;
  final bool disabled;
  final String? startError;
  final String? endError;
  final String? rangeError;
  final DateTime? now;

  @override
  Widget build(BuildContext context) {
    final today = now ?? DateTime.now();
    final maxRangeMessage = context.mobileText(
      'Max {value1} days for this report type',
      {'value1': reportKey.maxDays.toString()},
    );
    String? validateRange(OpenVtsDateTimeRange range) {
      final start = range.start;
      final end = range.end;
      if (start == null || end == null) {
        return context.widgetL10n.dateRangeSelect;
      }
      if (!reportKey.usesDateOnly && !start.isBefore(end)) {
        return context.widgetL10n.reportsValidationStartBeforeEnd;
      }
      // Date-only limits count civil days; date-time limits count elapsed time,
      // matching web reports even at an exact limit or a DST transition.
      final tooLong = reportKey.usesDateOnly
          ? DateTime.utc(end.year, end.month, end.day)
                        .difference(
                          DateTime.utc(start.year, start.month, start.day),
                        )
                        .inDays +
                    1 >
                reportKey.maxDays
          : end.difference(start) > Duration(days: reportKey.maxDays);
      return tooLong ? maxRangeMessage : null;
    }

    String? displayError(String? error) => switch (error) {
      null => null,
      'reportsValidationStartDateRequired' ||
      'reportsValidationEndDateRequired' => context.widgetL10n.dateRangeSelect,
      'reportsValidationStartBeforeEnd' =>
        context.widgetL10n.reportsValidationStartBeforeEnd,
      'reportsValidationRangeTooLong' => maxRangeMessage,
      _ => error,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OpenVtsDateTimeRangeField(
          label: reportKey.usesDateOnly
              ? context.mobileText('Date Range')
              : context.mobileText('Date Time Range'),
          value: _pickerValue,
          dateTimeEnabled: !reportKey.usesDateOnly,
          enabled: !disabled,
          firstDate: DateTime(2015),
          lastDate: reportKey.usesDateOnly
              ? today
              : today.add(const Duration(days: 1)),
          now: today,
          errorText: displayError(rangeError ?? startError ?? endError),
          rangeValidator: validateRange,
          onChanged: (range) {
            if (range.isEmpty) {
              onChanged(null);
              return;
            }
            final start = range.start!;
            final end = range.end!;
            onChanged(
              reportKey.usesDateOnly
                  ? ReportDateRange.dateOnly(
                      startDate: _civilDate(start),
                      endDate: _civilDate(end),
                    )
                  : ReportDateRange.dateTime(
                      from: start.toUtc().toIso8601String(),
                      to: end.toUtc().toIso8601String(),
                    ),
            );
          },
        ),
        const SizedBox(height: OpenVtsSpacing.xxs),
        Text(
          maxRangeMessage,
          style: OpenVtsTypography.meta.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  OpenVtsDateTimeRange get _pickerValue {
    if (reportKey.usesDateOnly) {
      return OpenVtsDateTimeRange(
        start: _parseCivilDate(dateRange?.startDate),
        end: _parseCivilDate(dateRange?.endDate),
      );
    }
    return OpenVtsDateTimeRange(
      start: DateTime.tryParse(dateRange?.fromISO ?? '')?.toLocal(),
      end: DateTime.tryParse(dateRange?.toISO ?? '')?.toLocal(),
    );
  }

  static DateTime? _parseCivilDate(String? value) {
    if (value == null || !RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value)) {
      return null;
    }
    final date = DateTime.tryParse(value);
    return date != null && _civilDate(date) == value ? date : null;
  }

  static String _civilDate(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
}
