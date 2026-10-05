import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../l10n/app_localizations.dart';
import 'open_vts_error_view.dart';

class OpenVtsCalendarMetric {
  const OpenVtsCalendarMetric({
    required this.label,
    required this.count,
    required this.color,
  });
  final String label;
  final int count;
  final Color color;
}

/// A phone-sized month view. At large accessibility sizes a date list preserves
/// full-size text instead of squeezing seven columns into a narrow viewport.
class OpenVtsMonthCalendar extends StatelessWidget {
  const OpenVtsMonthCalendar({
    required this.focusedDay,
    required this.selectedDay,
    required this.metricsByDay,
    required this.onFocusMonth,
    required this.onSelectDay,
    required this.filters,
    required this.loading,
    required this.onRetry,
    required this.onToday,
    this.errorMessage,
    super.key,
  });

  final DateTime focusedDay;
  final DateTime? selectedDay;
  final Map<String, List<OpenVtsCalendarMetric>> metricsByDay;
  final ValueChanged<DateTime> onFocusMonth;
  final ValueChanged<DateTime> onSelectDay;
  final List<Widget> filters;
  final bool loading;
  final String? errorMessage;
  final VoidCallback onRetry;
  final VoidCallback onToday;

  static String dayKey(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  List<OpenVtsCalendarMetric> _metrics(DateTime day) =>
      metricsByDay[dayKey(day)] ?? const [];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final scale = MediaQuery.textScalerOf(context).scale(1);
    final monthLabel = DateFormat.yMMMM(locale).format(focusedDay);
    final fullDate = DateFormat.yMMMMEEEEd(locale);
    final firstDay = DateTime(focusedDay.year, focusedDay.month, 1);
    final daysInMonth = DateTime(focusedDay.year, focusedDay.month + 1, 0).day;
    final selectedMetrics = selectedDay == null
        ? const <OpenVtsCalendarMetric>[]
        : _metrics(selectedDay!);
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(monthLabel, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        Row(
          children: [
            IconButton(
              tooltip: l10n.calendarPreviousMonth,
              onPressed: focusedDay.year == 2000 && focusedDay.month == 1
                  ? null
                  : () => onFocusMonth(
                      DateTime(focusedDay.year, focusedDay.month - 1, 1),
                    ),
              icon: const Icon(Icons.chevron_left_rounded),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton(
                onPressed: onToday,
                child: Text(l10n.calendarToday),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              tooltip: l10n.calendarNextMonth,
              onPressed: focusedDay.year == 2050 && focusedDay.month == 12
                  ? null
                  : () => onFocusMonth(
                      DateTime(focusedDay.year, focusedDay.month + 1, 1),
                    ),
              icon: const Icon(Icons.chevron_right_rounded),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(spacing: 8, runSpacing: 8, children: filters),
        const SizedBox(height: 16),
        if (loading)
          const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: LinearProgressIndicator(),
          ),
        if (errorMessage != null)
          OpenVtsErrorView(message: errorMessage!, onRetry: onRetry)
        else if (scale > 1.5)
          for (var index = 0; index < daysInMonth; index++)
            Card(
              key: ValueKey('calendar-day-${index + 1}'),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => onSelectDay(
                  DateTime(firstDay.year, firstDay.month, index + 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fullDate.format(
                          DateTime(firstDay.year, firstDay.month, index + 1),
                        ),
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      if (_metrics(
                        DateTime(firstDay.year, firstDay.month, index + 1),
                      ).isNotEmpty) ...[
                        const SizedBox(height: 8),
                        _MetricSummary(
                          metrics: _metrics(
                            DateTime(firstDay.year, firstDay.month, index + 1),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            )
        else ...[
          TableCalendar<OpenVtsCalendarMetric>(
            locale: locale,
            firstDay: DateTime(2000),
            lastDay: DateTime(2050, 12, 31),
            focusedDay: focusedDay,
            headerVisible: false,
            sixWeekMonthsEnforced: true,
            rowHeight: 58,
            daysOfWeekHeight: 26 * scale,
            selectedDayPredicate: (day) => isSameDay(selectedDay, day),
            onDaySelected: (day, _) => onSelectDay(day),
            onPageChanged: onFocusMonth,
            eventLoader: _metrics,
            availableGestures: AvailableGestures.horizontalSwipe,
            calendarStyle: const CalendarStyle(
              markersMaxCount: 0,
              outsideDaysVisible: true,
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: Theme.of(context).textTheme.labelSmall!,
              weekendStyle: Theme.of(context).textTheme.labelSmall!,
            ),
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, _) =>
                  _dayCell(context, day, fullDate, scheme, false, false),
              todayBuilder: (context, day, _) =>
                  _dayCell(context, day, fullDate, scheme, false, true),
              selectedBuilder: (context, day, _) => _dayCell(
                context,
                day,
                fullDate,
                scheme,
                true,
                isSameDay(DateTime.now(), day),
              ),
            ),
          ),
          if (selectedDay != null && selectedMetrics.isNotEmpty) ...[
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fullDate.format(selectedDay!),
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    _MetricSummary(metrics: selectedMetrics),
                  ],
                ),
              ),
            ),
          ],
        ],
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _dayCell(
    BuildContext context,
    DateTime day,
    DateFormat formatter,
    ColorScheme scheme,
    bool selected,
    bool today,
  ) {
    final metrics = _metrics(day);
    final label = [
      formatter.format(day),
      for (final metric in metrics) '${metric.label}: ${metric.count}',
    ].join(', ');
    return Tooltip(
      message: label,
      child: Semantics(
        label: label,
        selected: selected,
        excludeSemantics: true,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: selected
                ? scheme.primary
                : today
                ? scheme.surfaceContainerHighest
                : null,
            border: today ? Border.all(color: scheme.primary) : null,
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${day.day}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: selected ? scheme.onPrimary : scheme.onSurface,
                  ),
                ),
                if (metrics.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (final metric in metrics.take(3))
                        Container(
                          width: 4,
                          height: 4,
                          margin: const EdgeInsets.symmetric(horizontal: 1),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: selected ? scheme.onPrimary : metric.color,
                          ),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MetricSummary extends StatelessWidget {
  const _MetricSummary({required this.metrics});
  final List<OpenVtsCalendarMetric> metrics;
  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 12,
    runSpacing: 8,
    children: [
      for (final metric in metrics)
        Text(
          '${metric.label}: ${metric.count}',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
    ],
  );
}
