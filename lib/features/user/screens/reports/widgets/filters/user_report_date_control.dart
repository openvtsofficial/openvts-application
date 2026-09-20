import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../../core/theme/open_vts_colors.dart';
import '../../../../../../core/theme/open_vts_radius.dart';
import '../../../../../../core/theme/open_vts_spacing.dart';
import '../../../../../../core/theme/open_vts_typography.dart';
import '../../../../models/user_report_model.dart';
import '../../../../models/user_report_state.dart';

/// Date range control for reports.
/// Renders a date-only calendar picker or a date+time range picker
/// depending on the report's date mode.
class UserReportDateControl extends StatelessWidget {
  const UserReportDateControl({
    required this.reportKey,
    required this.dateRange,
    required this.onChanged,
    this.disabled = false,
    this.startError,
    this.endError,
    this.rangeError,
    super.key,
  });

  final UserReportKey reportKey;
  final ReportDateRange? dateRange;
  final ValueChanged<ReportDateRange?> onChanged;
  final bool disabled;
  final String? startError;
  final String? endError;
  final String? rangeError;

  @override
  Widget build(BuildContext context) {
    if (reportKey.usesDateOnly) {
      return _DateOnlyControl(
          dateRange: dateRange,
          onChanged: onChanged,
          disabled: disabled,
          startError: startError,
          endError: endError,
          rangeError: rangeError,
          maxDays: reportKey.maxDays);
    } else {
      return _DateTimeControl(
          dateRange: dateRange,
          onChanged: onChanged,
          disabled: disabled,
          startError: startError,
          endError: endError,
          rangeError: rangeError,
          maxDays: reportKey.maxDays);
    }
  }
}

// ---------------------------------------------------------------------------
// Date-only control
// ---------------------------------------------------------------------------

class _DateOnlyControl extends StatelessWidget {
  const _DateOnlyControl(
      {required this.dateRange,
      required this.onChanged,
      required this.disabled,
      this.startError,
      this.endError,
      this.rangeError,
      required this.maxDays});
  final ReportDateRange? dateRange;
  final ValueChanged<ReportDateRange?> onChanged;
  final bool disabled;
  final String? startError;
  final String? endError;
  final String? rangeError;
  final int maxDays;

  String? get _startDate =>
      dateRange?.mode == 'dateOnly' ? dateRange?.startDate : null;
  String? get _endDate =>
      dateRange?.mode == 'dateOnly' ? dateRange?.endDate : null;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _DateField(
                label: 'Start date',
                value: _startDate,
                error: startError,
                disabled: disabled,
                onTap: () => _pickDate(context, isStart: true),
              ),
            ),
            const SizedBox(width: OpenVtsSpacing.sm),
            Expanded(
              child: _DateField(
                label: 'End date',
                value: _endDate,
                error: endError,
                disabled: disabled,
                onTap: () => _pickDate(context, isStart: false),
              ),
            ),
          ],
        ),
        if (rangeError != null) ...[
          const SizedBox(height: 4),
          Text(rangeError!,
              style:
                  OpenVtsTypography.meta.copyWith(color: OpenVtsColors.error)),
        ],
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text('Max $maxDays days for this report type',
              style: OpenVtsTypography.meta
                  .copyWith(color: OpenVtsColors.textSecondary)),
        ),
      ],
    );
  }

  Future<void> _pickDate(BuildContext context, {required bool isStart}) async {
    final now = DateTime.now();
    final initial = _parseDate(isStart ? _startDate : _endDate) ?? now;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2015),
      lastDate: now,
    );
    if (picked == null) return;
    final fmt = DateFormat('yyyy-MM-dd');
    final pickedStr = fmt.format(picked);
    if (isStart) {
      onChanged(ReportDateRange.dateOnly(
          startDate: pickedStr, endDate: _endDate ?? pickedStr));
    } else {
      onChanged(ReportDateRange.dateOnly(
          startDate: _startDate ?? pickedStr, endDate: pickedStr));
    }
  }

  DateTime? _parseDate(String? s) {
    if (s == null) return null;
    try {
      final parts = s.split('-').map(int.parse).toList();
      return DateTime(parts[0], parts[1], parts[2]);
    } catch (_) {
      return null;
    }
  }
}

// ---------------------------------------------------------------------------
// Date-time control
// ---------------------------------------------------------------------------

class _DateTimeControl extends StatelessWidget {
  const _DateTimeControl(
      {required this.dateRange,
      required this.onChanged,
      required this.disabled,
      this.startError,
      this.endError,
      this.rangeError,
      required this.maxDays});
  final ReportDateRange? dateRange;
  final ValueChanged<ReportDateRange?> onChanged;
  final bool disabled;
  final String? startError;
  final String? endError;
  final String? rangeError;
  final int maxDays;

  DateTime? get _from => dateRange?.mode == 'dateTime'
      ? DateTime.tryParse(dateRange!.fromISO ?? '')
      : null;
  DateTime? get _to => dateRange?.mode == 'dateTime'
      ? DateTime.tryParse(dateRange!.toISO ?? '')
      : null;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _DateTimeField(
                label: 'Start',
                value: _from?.toLocal(),
                error: startError,
                disabled: disabled,
                onTap: () => _pickDateTime(context, isStart: true),
              ),
            ),
            const SizedBox(width: OpenVtsSpacing.sm),
            Expanded(
              child: _DateTimeField(
                label: 'End',
                value: _to?.toLocal(),
                error: endError,
                disabled: disabled,
                onTap: () => _pickDateTime(context, isStart: false),
              ),
            ),
          ],
        ),
        if (rangeError != null) ...[
          const SizedBox(height: 4),
          Text(rangeError!,
              style:
                  OpenVtsTypography.meta.copyWith(color: OpenVtsColors.error)),
        ],
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text('Max $maxDays days for this report type',
              style: OpenVtsTypography.meta
                  .copyWith(color: OpenVtsColors.textSecondary)),
        ),
      ],
    );
  }

  Future<void> _pickDateTime(BuildContext context,
      {required bool isStart}) async {
    final now = DateTime.now();
    final initial = (isStart ? _from?.toLocal() : _to?.toLocal()) ?? now;

    final date = await showDatePicker(
        context: context,
        initialDate: initial,
        firstDate: DateTime(2015),
        lastDate: now.add(const Duration(days: 1)));
    if (date == null) return;
    if (!context.mounted) return;

    final time = await showTimePicker(
        context: context, initialTime: TimeOfDay.fromDateTime(initial));
    if (time == null) return;

    final picked =
        DateTime(date.year, date.month, date.day, time.hour, time.minute);
    final from = isStart
        ? picked
        : (_from ?? DateTime(date.year, date.month, date.day, 0, 1));
    final to = isStart
        ? (_to ?? DateTime(date.year, date.month, date.day, 23, 59))
        : picked;

    onChanged(ReportDateRange.dateTime(
        from: from.toUtc().toIso8601String(),
        to: to.toUtc().toIso8601String()));
  }
}

// ---------------------------------------------------------------------------
// Field widgets
// ---------------------------------------------------------------------------

class _DateField extends StatelessWidget {
  const _DateField(
      {required this.label,
      required this.value,
      required this.disabled,
      required this.onTap,
      this.error});
  final String label;
  final String? value;
  final bool disabled;
  final VoidCallback onTap;
  final String? error;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasError = error != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: OpenVtsTypography.meta.copyWith(
                fontWeight: FontWeight.w600,
                color: isDark
                    ? OpenVtsColors.darkTextSecondary
                    : OpenVtsColors.textSecondary)),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: disabled ? null : onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: OpenVtsSpacing.sm, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? OpenVtsColors.darkSurface : OpenVtsColors.white,
              borderRadius: BorderRadius.circular(OpenVtsRadius.md),
              border: Border.all(
                  color: hasError
                      ? OpenVtsColors.error
                      : (isDark
                          ? OpenVtsColors.darkBorder
                          : OpenVtsColors.border),
                  width: hasError ? 1.4 : 1),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today_rounded, size: 14),
                const SizedBox(width: 6),
                Expanded(
                    child: Text(value ?? 'Select',
                        style: OpenVtsTypography.body.copyWith(
                            color: value == null
                                ? (isDark
                                    ? OpenVtsColors.darkTextSecondary
                                    : OpenVtsColors.textSecondary)
                                : null))),
              ],
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 3),
          Text(error!,
              style:
                  OpenVtsTypography.meta.copyWith(color: OpenVtsColors.error)),
        ],
      ],
    );
  }
}

class _DateTimeField extends StatelessWidget {
  const _DateTimeField(
      {required this.label,
      required this.value,
      required this.disabled,
      required this.onTap,
      this.error});
  final String label;
  final DateTime? value;
  final bool disabled;
  final VoidCallback onTap;
  final String? error;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasError = error != null;
    final fmt = value != null ? DateFormat('MM/dd HH:mm').format(value!) : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: OpenVtsTypography.meta.copyWith(
                fontWeight: FontWeight.w600,
                color: isDark
                    ? OpenVtsColors.darkTextSecondary
                    : OpenVtsColors.textSecondary)),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: disabled ? null : onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: OpenVtsSpacing.sm, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? OpenVtsColors.darkSurface : OpenVtsColors.white,
              borderRadius: BorderRadius.circular(OpenVtsRadius.md),
              border: Border.all(
                  color: hasError
                      ? OpenVtsColors.error
                      : (isDark
                          ? OpenVtsColors.darkBorder
                          : OpenVtsColors.border),
                  width: hasError ? 1.4 : 1),
            ),
            child: Row(
              children: [
                const Icon(Icons.access_time_rounded, size: 14),
                const SizedBox(width: 6),
                Expanded(
                    child: Text(fmt ?? 'Select',
                        style: OpenVtsTypography.body.copyWith(
                            color: fmt == null
                                ? (isDark
                                    ? OpenVtsColors.darkTextSecondary
                                    : OpenVtsColors.textSecondary)
                                : null))),
              ],
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 3),
          Text(error!,
              style:
                  OpenVtsTypography.meta.copyWith(color: OpenVtsColors.error)),
        ],
      ],
    );
  }
}
