import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../../../core/theme/open_vts_colors.dart';
import '../../../../../core/theme/open_vts_radius.dart';
import '../../../../../core/theme/open_vts_spacing.dart';
import '../../../../../core/theme/open_vts_typography.dart';
import '../../../../../shared/widgets/open_vts_bottom_sheet.dart';
import '../../../../../shared/widgets/open_vts_button.dart';
import '../../../../../shared/widgets/open_vts_card.dart';
import '../../../../../shared/widgets/open_vts_empty_state.dart';
import '../../../../../shared/widgets/open_vts_loader.dart';
import '../../../models/admin_vehicle_model.dart';

class AdminVehicleEventsTab extends StatefulWidget {
  const AdminVehicleEventsTab({
    super.key,
    required this.imei,
    required this.events,
    required this.nextCursor,
    required this.isLoading,
    required this.isLoadingMore,
    required this.onLoad,
    required this.onLoadMore,
    required this.onApplyFilters,
    required this.onClearFilters,
  });

  final String imei;
  final List<AdminVehicleEventItem> events;
  final String? nextCursor;
  final bool isLoading;
  final bool isLoadingMore;
  final Future<void> Function() onLoad;
  final Future<void> Function() onLoadMore;
  final Future<void> Function({
    DateTime? from,
    DateTime? to,
    String? source,
    String? severity,
  }) onApplyFilters;
  final Future<void> Function() onClearFilters;

  @override
  State<AdminVehicleEventsTab> createState() => _AdminVehicleEventsTabState();
}

class _AdminVehicleEventsTabState extends State<AdminVehicleEventsTab> {
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  String _source = '';
  String _severity = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.imei.trim().isEmpty) {
      return const OpenVtsEmptyState(
        title: 'IMEI missing',
        message: 'IMEI is required to load vehicle events.',
      );
    }

    final rangeDisplay = _rangeStart != null
        ? _formatDateRange(_rangeStart!, _rangeEnd ?? _rangeStart!)
        : 'All dates';

    return Column(
      children: [
        OpenVtsCard(
          padding: const EdgeInsets.all(OpenVtsSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Date Range',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: OpenVtsSpacing.xs),
              GestureDetector(
                onTap: () => _openDateRangePicker(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: OpenVtsSpacing.sm,
                    vertical: OpenVtsSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Theme.of(context).colorScheme.outlineVariant),
                    borderRadius: BorderRadius.circular(OpenVtsRadius.md),
                    color:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_month_rounded,
                        size: 18,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: OpenVtsSpacing.sm),
                      Expanded(
                        child: Text(
                          rangeDisplay,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        size: 18,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: OpenVtsSpacing.sm),
        OpenVtsCard(
          padding: const EdgeInsets.all(OpenVtsSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Event Filters',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: OpenVtsSpacing.sm),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _source.isEmpty ? null : _source,
                      decoration: const InputDecoration(
                        labelText: 'Source',
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: OpenVtsSpacing.sm,
                          vertical: OpenVtsSpacing.xs,
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(value: '', child: Text('All sources')),
                        DropdownMenuItem(
                            value: 'SYSTEM', child: Text('SYSTEM')),
                        DropdownMenuItem(
                            value: 'GEOFENCE', child: Text('GEOFENCE')),
                        DropdownMenuItem(value: 'ROUTE', child: Text('ROUTE')),
                        DropdownMenuItem(
                            value: 'MOTION', child: Text('MOTION')),
                        DropdownMenuItem(
                            value: 'OVERSPEED', child: Text('OVERSPEED')),
                        DropdownMenuItem(
                            value: 'IGNITION', child: Text('IGNITION')),
                        DropdownMenuItem(
                            value: 'REMINDER', child: Text('REMINDER')),
                        DropdownMenuItem(
                            value: 'SENSOR', child: Text('SENSOR')),
                        DropdownMenuItem(
                            value: 'DRIVER', child: Text('DRIVER')),
                        DropdownMenuItem(
                            value: 'COMMAND', child: Text('COMMAND')),
                      ],
                      onChanged: (value) =>
                          setState(() => _source = value ?? ''),
                    ),
                  ),
                  const SizedBox(width: OpenVtsSpacing.sm),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _severity.isEmpty ? null : _severity,
                      decoration: const InputDecoration(
                        labelText: 'Severity',
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: OpenVtsSpacing.sm,
                          vertical: OpenVtsSpacing.xs,
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(value: '', child: Text('All')),
                        DropdownMenuItem(value: 'INFO', child: Text('INFO')),
                        DropdownMenuItem(
                            value: 'WARNING', child: Text('WARNING')),
                        DropdownMenuItem(
                            value: 'CRITICAL', child: Text('CRITICAL')),
                      ],
                      onChanged: (value) =>
                          setState(() => _severity = value ?? ''),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: OpenVtsSpacing.sm),
              Row(
                children: [
                  Expanded(
                    child: OpenVtsButton(
                      label: 'Apply',
                      height: 36,
                      isLoading: widget.isLoading,
                      onPressed: widget.isLoading ? null : _applyFilters,
                    ),
                  ),
                  const SizedBox(width: OpenVtsSpacing.xs),
                  Expanded(
                    child: OpenVtsButton(
                      label: 'Clear',
                      height: 36,
                      onPressed: widget.isLoading ? null : _reset,
                      variant: OpenVtsButtonVariant.secondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: OpenVtsSpacing.sm),
        if (widget.isLoading)
          const OpenVtsLoader()
        else if (widget.events.isEmpty)
          const OpenVtsEmptyState(
            title: 'No events found',
            message: 'No events exist for the selected date range and filters.',
          )
        else ...[
          ...widget.events.map(
            (event) => Padding(
              padding: const EdgeInsets.only(bottom: OpenVtsSpacing.sm),
              child: _EventCard(
                event: event,
                onTap: () => _openDetails(event),
              ),
            ),
          ),
          if ((widget.nextCursor ?? '').trim().isNotEmpty)
            OpenVtsButton(
              label: 'Load older',
              isLoading: widget.isLoadingMore,
              onPressed: widget.isLoadingMore ? null : widget.onLoadMore,
              variant: OpenVtsButtonVariant.secondary,
            ),
        ],
      ],
    );
  }

  Future<void> _openDateRangePicker(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return showDialog<void>(
      context: context,
      builder: (context) => _DateRangePickerDialog(
        initialStart: _rangeStart ?? today,
        initialEnd: _rangeEnd ?? today,
        onApply: (start, end) {
          Navigator.of(context).pop();
          setState(() {
            _rangeStart = start;
            _rangeEnd = end;
          });
        },
      ),
    );
  }

  Future<void> _applyFilters() {
    if (widget.isLoading) return Future.value();
    DateTime? toInclusive;
    if (_rangeEnd != null) {
      toInclusive = DateTime(
          _rangeEnd!.year, _rangeEnd!.month, _rangeEnd!.day, 23, 59, 59, 999);
    }
    return widget.onApplyFilters(
      from: _rangeStart,
      to: toInclusive,
      source: _source.trim().isEmpty ? null : _source.trim(),
      severity: _severity.trim().isEmpty ? null : _severity.trim(),
    );
  }

  Future<void> _reset() async {
    setState(() {
      _rangeStart = null;
      _rangeEnd = null;
      _source = '';
      _severity = '';
    });
    await widget.onClearFilters();
  }

  Future<void> _openDetails(AdminVehicleEventItem event) {
    return OpenVtsBottomSheet.show<void>(
      context: context,
      title: 'Event Details',
      initialChildSize: 0.8,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      child: ListView(
        padding: const EdgeInsets.all(OpenVtsSpacing.md),
        children: [
          _line('Title', event.title),
          _line('Category', _safe(event.category ?? '')),
          _line('Severity', _safe(event.severity ?? '')),
          _line('Source', _safe(event.category ?? '')),
          _line('Message', event.message),
          _line('Created At', _fmtDateTime(event.createdAt)),
          _line('Vehicle IMEI', _safe(event.vehicleImei ?? '')),
          _line('Context', _safe(event.contextLabel ?? '')),
          const SizedBox(height: OpenVtsSpacing.sm),
          Text('Metadata', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: OpenVtsSpacing.xs),
          SelectableText(_json(event.metadata)),
        ],
      ),
    );
  }

  Widget _line(String label, String value) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Text('$label: ${_safe(value)}'),
      );

  String _json(Map<String, dynamic> value) {
    if (value.isEmpty) return '{}';
    return const JsonEncoder.withIndent('  ').convert(value);
  }

  String _safe(String value) => value.trim().isEmpty ? '-' : value.trim();

  String _fmtDateTime(DateTime? value) {
    if (value == null) return '-';
    final local = value.toLocal();
    final d =
        '${local.year.toString().padLeft(4, '0')}-${local.month.toString().padLeft(2, '0')}-${local.day.toString().padLeft(2, '0')}';
    final t =
        '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
    return '$d $t';
  }

  String _formatDateRange(DateTime start, DateTime end) {
    if (start.year == end.year &&
        start.month == end.month &&
        start.day == end.day) {
      return _formatDate(start);
    }
    return '${_formatDate(start)} – ${_formatDate(end)}';
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}';
  }
}

class _DateRangePickerDialog extends StatefulWidget {
  const _DateRangePickerDialog({
    required this.initialStart,
    required this.initialEnd,
    required this.onApply,
  });

  final DateTime initialStart;
  final DateTime initialEnd;
  final Function(DateTime start, DateTime end) onApply;

  @override
  State<_DateRangePickerDialog> createState() => _DateRangePickerDialogState();
}

class _DateRangePickerDialogState extends State<_DateRangePickerDialog> {
  late DateTime _start;
  late DateTime _end;
  late DateTime _displayMonth;
  DateTime? _picking;

  @override
  void initState() {
    super.initState();
    _start = widget.initialStart;
    _end = widget.initialEnd;
    _displayMonth = widget.initialStart;
    _picking = null;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Dialog(
      backgroundColor: colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(OpenVtsSpacing.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Select Date Range',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                    ),
              ),
              const SizedBox(height: OpenVtsSpacing.md),
              _buildCalendar(),
              const SizedBox(height: OpenVtsSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: colorScheme.onSurface),
                      ),
                    ),
                  ),
                  const SizedBox(width: OpenVtsSpacing.sm),
                  Expanded(
                    child: TextButton(
                      onPressed: _setToday,
                      child: Text(
                        'Today',
                        style: TextStyle(color: colorScheme.primary),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: OpenVtsSpacing.sm),
              Row(
                children: [
                  Expanded(
                    child: OpenVtsButton(
                      label: 'Cancel',
                      height: 36,
                      variant: OpenVtsButtonVariant.secondary,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const SizedBox(width: OpenVtsSpacing.sm),
                  Expanded(
                    child: OpenVtsButton(
                      label: 'Apply',
                      height: 36,
                      onPressed: () => widget.onApply(_start, _end),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    final colorScheme = Theme.of(context).colorScheme;
    final year = _displayMonth.year;
    final month = _displayMonth.month;
    final firstDay = DateTime(year, month, 1);
    final lastDay = DateTime(year, month + 1, 0);
    final prevMonthDays = firstDay.weekday - 1;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _monthYear(_displayMonth),
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.chevron_left_rounded,
                      size: 20, color: colorScheme.onSurface),
                  onPressed: _previousMonth,
                  padding: EdgeInsets.zero,
                  constraints:
                      const BoxConstraints(minWidth: 32, minHeight: 32),
                ),
                IconButton(
                  icon: Icon(Icons.chevron_right_rounded,
                      size: 20, color: colorScheme.onSurface),
                  onPressed: _nextMonth,
                  padding: EdgeInsets.zero,
                  constraints:
                      const BoxConstraints(minWidth: 32, minHeight: 32),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: OpenVtsSpacing.md),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: OpenVtsSpacing.xs),
          child: Row(
            children: [
              _WeekdayLabel('S', colorScheme: colorScheme),
              _WeekdayLabel('M', colorScheme: colorScheme),
              _WeekdayLabel('T', colorScheme: colorScheme),
              _WeekdayLabel('W', colorScheme: colorScheme),
              _WeekdayLabel('T', colorScheme: colorScheme),
              _WeekdayLabel('F', colorScheme: colorScheme),
              _WeekdayLabel('S', colorScheme: colorScheme),
            ],
          ),
        ),
        const SizedBox(height: OpenVtsSpacing.sm),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1.2,
            crossAxisSpacing: OpenVtsSpacing.xs,
            mainAxisSpacing: OpenVtsSpacing.xs,
          ),
          itemCount: prevMonthDays + lastDay.day,
          itemBuilder: (context, index) {
            if (index < prevMonthDays) {
              return const SizedBox();
            }
            final dayNumber = index - prevMonthDays + 1;
            final date = DateTime(year, month, dayNumber);
            final isStart = _isSameDay(date, _start);
            final isEnd = _isSameDay(date, _end);
            final inRange = _isInRange(date, _start, _end);
            final isToday = _isSameDay(date, DateTime.now());

            return _DateCell(
              dayNumber: dayNumber,
              isStart: isStart,
              isEnd: isEnd,
              inRange: inRange,
              isToday: isToday,
              onTap: () => _selectDate(date),
              colorScheme: colorScheme,
            );
          },
        ),
      ],
    );
  }

  void _selectDate(DateTime date) {
    setState(() {
      if (_picking == null) {
        _start = date;
        _end = date;
        _picking = date;
      } else {
        if (date.isBefore(_start)) {
          _end = _start;
          _start = date;
        } else {
          _end = date;
        }
        _picking = null;
      }
    });
  }

  void _setToday() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    setState(() {
      _start = today;
      _end = today;
      _picking = null;
      _displayMonth = today;
    });
  }

  void _previousMonth() {
    setState(() {
      _displayMonth = DateTime(_displayMonth.year, _displayMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _displayMonth = DateTime(_displayMonth.year, _displayMonth.month + 1);
    });
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  bool _isInRange(DateTime date, DateTime start, DateTime end) {
    return (date.isAfter(start) || _isSameDay(date, start)) &&
        (date.isBefore(end) || _isSameDay(date, end));
  }

  String _monthYear(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
}

class _WeekdayLabel extends StatelessWidget {
  const _WeekdayLabel(this.label, {required this.colorScheme});

  final String label;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(
          label,
          style: OpenVtsTypography.meta.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _DateCell extends StatelessWidget {
  const _DateCell({
    required this.dayNumber,
    required this.isStart,
    required this.isEnd,
    required this.inRange,
    required this.isToday,
    required this.onTap,
    required this.colorScheme,
  });

  final int dayNumber;
  final bool isStart;
  final bool isEnd;
  final bool inRange;
  final bool isToday;
  final VoidCallback onTap;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isStart || isEnd
              ? colorScheme.primary
              : inRange
                  ? colorScheme.primary.withValues(alpha: 0.15)
                  : Colors.transparent,
          border: Border.all(
            color: isToday && !isStart && !isEnd
                ? colorScheme.primary.withValues(alpha: 0.5)
                : Colors.transparent,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(OpenVtsRadius.sm),
        ),
        alignment: Alignment.center,
        child: Text(
          dayNumber.toString(),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isStart || isEnd
                ? colorScheme.onPrimary
                : isToday
                    ? colorScheme.primary
                    : colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  const _EventCard({
    required this.event,
    required this.onTap,
  });

  final AdminVehicleEventItem event;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OpenVtsCard(
      onTap: onTap,
      padding: const EdgeInsets.all(OpenVtsSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  event.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                      ),
                ),
              ),
              if (event.severity != null) ...[
                const SizedBox(width: OpenVtsSpacing.xs),
                _SeverityChip(severity: event.severity!),
              ],
            ],
          ),
          const SizedBox(height: OpenVtsSpacing.sm),
          const Divider(height: 1, color: OpenVtsColors.border),
          const SizedBox(height: OpenVtsSpacing.sm),
          Row(
            children: [
              Expanded(
                child: _InfoItem(
                  icon: Icons.access_time_rounded,
                  label: 'Time',
                  value: event.createdAt == null
                      ? '-'
                      : _formatDateTime(event.createdAt!),
                ),
              ),
              if (event.category != null) ...[
                const SizedBox(width: OpenVtsSpacing.sm),
                Expanded(
                  child: _InfoItem(
                    icon: Icons.category_rounded,
                    label: 'Source',
                    value: event.category!,
                  ),
                ),
              ],
            ],
          ),
          if (event.message.trim().isNotEmpty) ...[
            const SizedBox(height: OpenVtsSpacing.sm),
            Text(
              event.message,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: OpenVtsTypography.meta.copyWith(
                color: OpenVtsColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    final local = dt.toLocal();
    final d =
        '${local.year.toString().padLeft(4, '0')}-${local.month.toString().padLeft(2, '0')}-${local.day.toString().padLeft(2, '0')}';
    final t =
        '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
    return '$d $t';
  }
}

class _InfoItem extends StatelessWidget {
  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: OpenVtsColors.textTertiary),
        const SizedBox(width: OpenVtsSpacing.xs),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: OpenVtsTypography.meta.copyWith(
                  color: OpenVtsColors.textSecondary,
                  fontSize: 10,
                ),
              ),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: OpenVtsTypography.meta.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SeverityChip extends StatelessWidget {
  const _SeverityChip({required this.severity});

  final String severity;

  Color _getSeverityColor() {
    switch (severity.toUpperCase()) {
      case 'CRITICAL':
        return OpenVtsColors.error;
      case 'WARNING':
        return OpenVtsColors.warning;
      case 'INFO':
        return OpenVtsColors.success;
      default:
        return OpenVtsColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getSeverityColor();
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: OpenVtsSpacing.xs,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(OpenVtsRadius.pill),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Text(
        severity.toUpperCase(),
        style: OpenVtsTypography.meta.copyWith(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
