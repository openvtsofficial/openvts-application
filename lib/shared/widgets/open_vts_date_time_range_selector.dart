import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/theme/open_vts_radius.dart';
import '../../core/theme/open_vts_spacing.dart';
import '../../core/theme/open_vts_typography.dart';
import '../helpers/widget_localizations.dart';
import 'open_vts_button.dart';

/// Explicitly follows the active widget locale, including runtime language changes.
String _formatRangeDate(
  BuildContext context,
  DateTime value, {
  bool includeTime = false,
}) {
  final local = value.toLocal();
  final locale = Localizations.localeOf(context).toLanguageTag();
  final date = DateFormat.yMMMd(locale).format(local);
  if (!includeTime) return date;
  final time = MaterialLocalizations.of(context).formatTimeOfDay(
    TimeOfDay.fromDateTime(local),
    alwaysUse24HourFormat: MediaQuery.alwaysUse24HourFormatOf(context),
  );
  return '$date, $time';
}

class OpenVtsDateTimeRange {
  const OpenVtsDateTimeRange({this.start, this.end});

  const OpenVtsDateTimeRange.empty() : start = null, end = null;

  final DateTime? start;
  final DateTime? end;

  bool get isEmpty => start == null && end == null;

  bool get isComplete => start != null && end != null;

  OpenVtsDateTimeRange normalized({required bool dateTimeEnabled}) {
    if (isEmpty) {
      return const OpenVtsDateTimeRange.empty();
    }

    final resolvedStart = start ?? end!;
    final resolvedEnd = end ?? start!;

    if (dateTimeEnabled) {
      return resolvedEnd.isBefore(resolvedStart)
          ? OpenVtsDateTimeRange(start: resolvedEnd, end: resolvedStart)
          : OpenVtsDateTimeRange(start: resolvedStart, end: resolvedEnd);
    }

    final startDate = DateUtils.dateOnly(resolvedStart);
    final endDate = DateUtils.dateOnly(resolvedEnd);

    return endDate.isBefore(startDate)
        ? OpenVtsDateTimeRange(start: endDate, end: startDate)
        : OpenVtsDateTimeRange(start: startDate, end: endDate);
  }
}

class OpenVtsDateTimeRangeField extends StatelessWidget {
  const OpenVtsDateTimeRangeField({
    required this.label,
    required this.value,
    required this.onChanged,
    this.dateTimeEnabled = false,
    this.enabled = true,
    this.firstDate,
    this.lastDate,
    this.title,
    this.hintText,
    this.now,
    this.errorText,
    this.rangeValidator,
    super.key,
  });

  final String label;
  final OpenVtsDateTimeRange value;
  final ValueChanged<OpenVtsDateTimeRange> onChanged;
  final bool dateTimeEnabled;
  final bool enabled;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String? title;
  final String? hintText;
  final DateTime? now;
  final String? errorText;
  final String? Function(OpenVtsDateTimeRange range)? rangeValidator;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final displayValue = _formatRangeLabel(context, value);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: OpenVtsTypography.label),
        const SizedBox(height: OpenVtsSpacing.xs),
        Semantics(
          button: true,
          enabled: enabled,
          label: label,
          child: InkWell(
            borderRadius: BorderRadius.circular(OpenVtsRadius.md),
            onTap: enabled ? () => _openSelector(context) : null,
            child: InputDecorator(
              decoration: InputDecoration(
                enabled: enabled,
                errorText: errorText,
                errorMaxLines: 3,
                suffixIcon: Icon(
                  Icons.calendar_month_outlined,
                  size: 18,
                  color: scheme.onSurfaceVariant,
                ),
              ),
              child: Text(
                displayValue ?? hintText ?? context.widgetL10n.dateRangeSelect,
                maxLines: null,
                style: OpenVtsTypography.body.copyWith(
                  color: displayValue == null
                      ? scheme.onSurfaceVariant
                      : scheme.onSurface,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _openSelector(BuildContext context) async {
    final result = await OpenVtsDateTimeRangeSelector.show(
      context: context,
      initialValue: value,
      dateTimeEnabled: dateTimeEnabled,
      firstDate: firstDate,
      lastDate: lastDate,
      title: title,
      now: now,
      rangeValidator: rangeValidator,
    );

    if (context.mounted && result != null) {
      onChanged(result);
    }
  }

  String? _formatRangeLabel(BuildContext context, OpenVtsDateTimeRange range) {
    final normalized = range.normalized(dateTimeEnabled: dateTimeEnabled);
    final start = normalized.start;
    final end = normalized.end;

    if (start == null || end == null) {
      return null;
    }

    if (dateTimeEnabled) {
      final startLabel = _formatRangeDate(context, start, includeTime: true);
      final endLabel = _formatRangeDate(context, end, includeTime: true);
      return startLabel == endLabel ? startLabel : '$startLabel - $endLabel';
    }

    final startLabel = _formatRangeDate(context, start);
    final endLabel = _formatRangeDate(context, end);
    return startLabel == endLabel ? startLabel : '$startLabel - $endLabel';
  }
}

class OpenVtsDateTimeRangeSelector extends StatefulWidget {
  const OpenVtsDateTimeRangeSelector({
    this.initialValue = const OpenVtsDateTimeRange.empty(),
    this.dateTimeEnabled = false,
    this.firstDate,
    this.lastDate,
    this.title,
    this.now,
    this.onApply,
    this.onClear,
    this.onCancel,
    this.scrollController,
    this.rangeValidator,
    super.key,
  });

  final OpenVtsDateTimeRange initialValue;
  final bool dateTimeEnabled;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String? title;
  final DateTime? now;
  final ValueChanged<OpenVtsDateTimeRange>? onApply;
  final VoidCallback? onClear;
  final VoidCallback? onCancel;
  final ScrollController? scrollController;
  final String? Function(OpenVtsDateTimeRange range)? rangeValidator;

  static Future<OpenVtsDateTimeRange?> show({
    required BuildContext context,
    OpenVtsDateTimeRange initialValue = const OpenVtsDateTimeRange.empty(),
    bool dateTimeEnabled = false,
    DateTime? firstDate,
    DateTime? lastDate,
    String? title,
    DateTime? now,
    String? Function(OpenVtsDateTimeRange range)? rangeValidator,
  }) {
    return showModalBottomSheet<OpenVtsDateTimeRange>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (context) {
        final mediaQuery = MediaQuery.of(context);
        final screenSize = mediaQuery.size;
        final useMobileSheet =
            screenSize.width <= 700 || screenSize.height <= 900;
        final targetMobileHeight = dateTimeEnabled ? 610.0 : 530.0;
        final mobileInitial = (targetMobileHeight / screenSize.height).clamp(
          0.72,
          0.94,
        );
        final initialChildSize = useMobileSheet ? mobileInitial : 0.88;
        final minChildSize = useMobileSheet
            ? (initialChildSize - 0.1).clamp(0.6, 0.9)
            : 0.58;
        final maxChildSize = useMobileSheet
            ? (initialChildSize + 0.12).clamp(0.82, 0.98)
            : 0.96;
        final snapSizes = <double>[minChildSize, initialChildSize, maxChildSize]
          ..sort();

        return SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.only(bottom: mediaQuery.viewInsets.bottom),
            child: DraggableScrollableSheet(
              expand: false,
              initialChildSize: initialChildSize,
              minChildSize: minChildSize,
              maxChildSize: maxChildSize,
              snap: true,
              snapSizes: snapSizes,
              builder: (context, scrollController) {
                return Align(
                  alignment: Alignment.bottomCenter,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 560),
                    child: Builder(
                      builder: (builderContext) {
                        final scheme = Theme.of(builderContext).colorScheme;
                        return DecoratedBox(
                          decoration: BoxDecoration(
                            color: scheme.surface,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(OpenVtsRadius.lg),
                            ),
                          ),
                          child: OpenVtsDateTimeRangeSelector(
                            initialValue: initialValue,
                            dateTimeEnabled: dateTimeEnabled,
                            firstDate: firstDate,
                            lastDate: lastDate,
                            title: title,
                            now: now,
                            rangeValidator: rangeValidator,
                            scrollController: scrollController,
                            onApply: (range) =>
                                Navigator.of(context).pop(range),
                            onClear: () => Navigator.of(
                              context,
                            ).pop(const OpenVtsDateTimeRange.empty()),
                            onCancel: () => Navigator.of(context).pop(),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  State<OpenVtsDateTimeRangeSelector> createState() =>
      _OpenVtsDateTimeRangeSelectorState();
}

class _OpenVtsDateTimeRangeSelectorState
    extends State<OpenVtsDateTimeRangeSelector> {
  late final DateTime _now;
  late final DateTime _firstDate;
  late final DateTime _lastDate;
  late DateTime _focusedMonth;
  late DateTime _startDate;
  late DateTime _endDate;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  Duration _startSubMinute = Duration.zero;
  Duration _endSubMinute = Duration.zero;
  DateTime? _startOriginal;
  DateTime? _endOriginal;
  _RangePresetType _selectedPreset = _RangePresetType.custom;
  bool _awaitingEndDate = false;

  @override
  void initState() {
    super.initState();

    _now = (widget.now ?? DateTime.now()).toLocal();
    _firstDate = DateUtils.dateOnly(widget.firstDate ?? DateTime(2020));
    _lastDate = DateUtils.dateOnly(widget.lastDate ?? DateTime(2100, 12, 31));

    final normalized = widget.initialValue.normalized(
      dateTimeEnabled: widget.dateTimeEnabled,
    );
    final today = _clampDate(DateUtils.dateOnly(_now));
    final initialStart = normalized.start == null
        ? today
        : _clampDate(DateUtils.dateOnly(normalized.start!.toLocal()));
    final initialEnd = normalized.end == null
        ? initialStart
        : _clampDate(DateUtils.dateOnly(normalized.end!.toLocal()));

    _startDate = initialStart;
    _endDate = initialEnd.isBefore(initialStart) ? initialStart : initialEnd;
    _startTime = normalized.start == null
        ? const TimeOfDay(hour: 0, minute: 0)
        : TimeOfDay.fromDateTime(normalized.start!.toLocal());
    _endTime = normalized.end == null
        ? const TimeOfDay(hour: 23, minute: 59)
        : TimeOfDay.fromDateTime(normalized.end!.toLocal());
    _startOriginal = normalized.start?.toLocal();
    _endOriginal = normalized.end?.toLocal();
    _startSubMinute = _subMinute(normalized.start);
    _endSubMinute = normalized.end == null
        ? const Duration(seconds: 59, milliseconds: 999)
        : _subMinute(normalized.end);
    _focusedMonth = DateTime(_endDate.year, _endDate.month);
  }

  @override
  Widget build(BuildContext context) {
    final title =
        widget.title ??
        (widget.dateTimeEnabled
            ? context.widgetL10n.dateTimeRangeChoose
            : context.widgetL10n.dateRangeChoose);

    return LayoutBuilder(
      builder: (context, constraints) {
        final mediaQuery = MediaQuery.of(context);
        final isCompact = _isCompactLayout(
          screenHeight: mediaQuery.size.height,
          availableHeight: constraints.maxHeight,
          width: constraints.maxWidth,
        );
        final sectionSpacing = isCompact ? 6.0 : OpenVtsSpacing.md;
        final scrollActions = constraints.maxHeight < 480;
        final actions = _SelectorActions(
          canApply: _isCurrentRangeValid,
          compact: isCompact,
          onClear: widget.onClear ?? () {},
          onCancel: widget.onCancel ?? () {},
          onApply: () => widget.onApply?.call(_currentRange),
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _SelectorHeader(
              title: title,
              onClose: widget.onCancel ?? () {},
              compact: isCompact,
            ),
            const Divider(height: 1),
            Expanded(
              child: SingleChildScrollView(
                controller: widget.scrollController,
                primary: widget.scrollController == null,
                padding: EdgeInsets.fromLTRB(
                  isCompact ? OpenVtsSpacing.sm : OpenVtsSpacing.md,
                  isCompact ? OpenVtsSpacing.xs : OpenVtsSpacing.md,
                  isCompact ? OpenVtsSpacing.sm : OpenVtsSpacing.md,
                  isCompact ? OpenVtsSpacing.xs : OpenVtsSpacing.sm,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _PresetGrid(
                      presets: _visiblePresets,
                      selectedPreset: _selectedPreset,
                      onSelected: _selectPreset,
                      compact: isCompact,
                    ),
                    SizedBox(height: sectionSpacing),
                    _MonthCalendar(
                      focusedMonth: _focusedMonth,
                      firstDate: _firstDate,
                      lastDate: _lastDate,
                      startDate: _startDate,
                      endDate: _endDate,
                      onPreviousMonth: _canMoveMonth(-1)
                          ? () => _moveFocusedMonth(-1)
                          : null,
                      onNextMonth: _canMoveMonth(1)
                          ? () => _moveFocusedMonth(1)
                          : null,
                      onDateSelected: _selectDate,
                      onChooseDate: _pickCalendarDate,
                      compact: isCompact,
                    ),
                    SizedBox(height: sectionSpacing),
                    _SelectedRangeSummary(
                      range: _currentRange,
                      dateTimeEnabled: widget.dateTimeEnabled,
                      compact: isCompact,
                    ),
                    if (widget.dateTimeEnabled) ...[
                      SizedBox(height: sectionSpacing),
                      _TimeRangeFields(
                        startTime: _startTime,
                        endTime: _endTime,
                        isValid: !_currentRange.end!.isBefore(
                          _currentRange.start!,
                        ),
                        compact: isCompact,
                        onStartTap: _pickStartTime,
                        onEndTap: _pickEndTime,
                      ),
                    ],
                    if (_rangeValidationError != null) ...[
                      SizedBox(height: sectionSpacing),
                      Text(
                        _rangeValidationError!,
                        style: OpenVtsTypography.meta.copyWith(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ],
                    if (scrollActions) ...[
                      SizedBox(height: sectionSpacing),
                      actions,
                    ],
                  ],
                ),
              ),
            ),
            if (!scrollActions) actions,
          ],
        );
      },
    );
  }

  bool _isCompactLayout({
    required double screenHeight,
    required double availableHeight,
    required double width,
  }) {
    final narrow = width <= 600;
    final shortSheet = availableHeight <= 700;
    final shortScreen = screenHeight <= 860 && width <= 900;
    return narrow || shortSheet || shortScreen;
  }

  Future<void> _pickStartTime() async {
    final selected = await _pickTime(
      initialTime: _startTime,
      helpText: context.widgetL10n.dateRangeSelectStartTime,
    );
    if (!mounted || selected == null) {
      return;
    }

    setState(() {
      _selectedPreset = _RangePresetType.custom;
      _startTime = selected;
      _startSubMinute = Duration.zero;
    });
  }

  Future<void> _pickEndTime() async {
    final selected = await _pickTime(
      initialTime: _endTime,
      helpText: context.widgetL10n.dateRangeSelectEndTime,
    );
    if (!mounted || selected == null) {
      return;
    }

    setState(() {
      _selectedPreset = _RangePresetType.custom;
      _endTime = selected;
      _endSubMinute = Duration.zero;
    });
  }

  Future<TimeOfDay?> _pickTime({
    required TimeOfDay initialTime,
    required String helpText,
  }) {
    return showTimePicker(
      context: context,
      initialTime: initialTime,
      helpText: helpText,
      builder: (builderContext, child) {
        final baseTheme = Theme.of(builderContext);
        final scheme = baseTheme.colorScheme;
        return Theme(
          data: baseTheme.copyWith(
            colorScheme: scheme.copyWith(
              primary: scheme.onSurface,
              onPrimary: scheme.surface,
              surface: scheme.surface,
              onSurface: scheme.onSurface,
            ),
            timePickerTheme: TimePickerThemeData(
              backgroundColor: scheme.surface,
              dialBackgroundColor: scheme.surfaceContainer,
              hourMinuteShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(OpenVtsRadius.md),
                side: BorderSide(color: scheme.outlineVariant),
              ),
              dayPeriodShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(OpenVtsRadius.md),
                side: BorderSide(color: scheme.outlineVariant),
              ),
              dayPeriodColor: scheme.surfaceContainer,
              dayPeriodTextColor: scheme.onSurface,
              helpTextStyle: OpenVtsTypography.label.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }

  List<_RangePreset> get _visiblePresets {
    return <_RangePreset>[
      _RangePreset.custom,
      if (widget.dateTimeEnabled) ..._RangePreset.durationPresets,
      ..._RangePreset.datePresets,
    ];
  }

  bool get _isCurrentRangeValid {
    final range = _currentRange;
    final start = range.start;
    final end = range.end;
    return start != null &&
        end != null &&
        !end.isBefore(start) &&
        _rangeValidationError == null;
  }

  String? get _rangeValidationError =>
      widget.rangeValidator?.call(_currentRange);

  OpenVtsDateTimeRange get _currentRange {
    if (widget.dateTimeEnabled) {
      return OpenVtsDateTimeRange(
        start: _combineDateAndTime(
          _startDate,
          _startTime,
          _startSubMinute,
          _startOriginal,
        ),
        end: _combineDateAndTime(
          _endDate,
          _endTime,
          _endSubMinute,
          _endOriginal,
        ),
      );
    }

    return OpenVtsDateTimeRange(
      start: DateUtils.dateOnly(_startDate),
      end: DateUtils.dateOnly(_endDate),
    ).normalized(dateTimeEnabled: false);
  }

  void _selectPreset(_RangePreset preset) {
    if (preset.type == _RangePresetType.custom) {
      setState(() => _selectedPreset = preset.type);
      return;
    }

    final range = preset
        .resolve(
          _now,
          widget.dateTimeEnabled,
          firstWeekday: MaterialLocalizations.of(context).firstDayOfWeekIndex,
        )
        .normalized(dateTimeEnabled: widget.dateTimeEnabled);
    final start = range.start!;
    final end = range.end!;

    setState(() {
      _selectedPreset = preset.type;
      _awaitingEndDate = false;
      _startDate = _clampDate(DateUtils.dateOnly(start));
      _endDate = _clampDate(DateUtils.dateOnly(end));
      _startTime = TimeOfDay.fromDateTime(start.toLocal());
      _endTime = TimeOfDay.fromDateTime(end.toLocal());
      _startOriginal = start.toLocal();
      _endOriginal = end.toLocal();
      _startSubMinute = _subMinute(start);
      _endSubMinute = _subMinute(end);
      _focusedMonth = DateTime(_endDate.year, _endDate.month);
    });
  }

  void _selectDate(DateTime date) {
    setState(() {
      _selectedPreset = _RangePresetType.custom;
      final selectedDate = _clampDate(DateUtils.dateOnly(date));
      if (!_awaitingEndDate) {
        // Every custom range begins with one explicit date. Inferring selection
        // progress from equal dates misread an earlier first click as a range
        // ending today, so the next click incorrectly restarted the selection.
        _startDate = selectedDate;
        _endDate = selectedDate;
        _awaitingEndDate = true;
      } else {
        if (selectedDate.isBefore(_startDate)) {
          _endDate = _startDate;
          _startDate = selectedDate;
        } else {
          _endDate = selectedDate;
        }
        _awaitingEndDate = false;
      }
    });
  }

  Future<void> _pickCalendarDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _clampDate(_focusedMonth),
      firstDate: _firstDate,
      lastDate: _lastDate,
      initialDatePickerMode: DatePickerMode.year,
    );
    if (picked == null || !mounted) return;
    _selectDate(picked);
    setState(() => _focusedMonth = DateTime(picked.year, picked.month));
  }

  void _moveFocusedMonth(int amount) {
    setState(() {
      _focusedMonth = DateTime(
        _focusedMonth.year,
        _focusedMonth.month + amount,
      );
    });
  }

  bool _canMoveMonth(int amount) {
    final nextMonth = DateTime(
      _focusedMonth.year,
      _focusedMonth.month + amount,
    );
    final firstAllowedMonth = DateTime(_firstDate.year, _firstDate.month);
    final lastAllowedMonth = DateTime(_lastDate.year, _lastDate.month);
    return !nextMonth.isBefore(firstAllowedMonth) &&
        !nextMonth.isAfter(lastAllowedMonth);
  }

  DateTime _clampDate(DateTime date) {
    if (date.isBefore(_firstDate)) {
      return _firstDate;
    }
    if (date.isAfter(_lastDate)) {
      return _lastDate;
    }
    return date;
  }

  Duration _subMinute(DateTime? date) => date == null
      ? Duration.zero
      : Duration(
          seconds: date.second,
          milliseconds: date.millisecond,
          microseconds: date.microsecond,
        );

  DateTime _combineDateAndTime(
    DateTime date,
    TimeOfDay time,
    Duration subMinute,
    DateTime? original,
  ) {
    // Reapplying an unchanged instant must retain the original offset during
    // a repeated DST clock hour, rather than reconstructing the first occurrence.
    if (original != null &&
        original.year == date.year &&
        original.month == date.month &&
        original.day == date.day &&
        original.hour == time.hour &&
        original.minute == time.minute &&
        _subMinute(original) == subMinute) {
      return original;
    }
    return DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
      subMinute.inSeconds,
      subMinute.inMilliseconds.remainder(1000),
      subMinute.inMicroseconds.remainder(1000),
    );
  }
}

class _SelectorHeader extends StatelessWidget {
  const _SelectorHeader({
    required this.title,
    required this.onClose,
    required this.compact,
  });

  final String title;
  final VoidCallback onClose;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final iconSize = compact ? 18.0 : 22.0;
    const actionSize = 48.0;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        OpenVtsSpacing.md,
        compact ? OpenVtsSpacing.xs : OpenVtsSpacing.md,
        OpenVtsSpacing.md,
        compact ? OpenVtsSpacing.xxs : OpenVtsSpacing.sm,
      ),
      child: Row(
        children: [
          const SizedBox(width: actionSize),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: OpenVtsTypography.titleSmall.copyWith(
                color: scheme.onSurface,
                fontWeight: FontWeight.w700,
                fontSize: compact ? 14 : null,
              ),
            ),
          ),
          SizedBox.square(
            dimension: actionSize,
            child: IconButton(
              tooltip: context.widgetL10n.close,
              onPressed: onClose,
              icon: Icon(Icons.close_rounded, size: iconSize),
              style: IconButton.styleFrom(
                backgroundColor: scheme.surfaceContainer,
                foregroundColor: scheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PresetGrid extends StatelessWidget {
  const _PresetGrid({
    required this.presets,
    required this.selectedPreset,
    required this.onSelected,
    required this.compact,
  });

  final List<_RangePreset> presets;
  final _RangePresetType selectedPreset;
  final ValueChanged<_RangePreset> onSelected;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    if (compact) {
      final scheme = Theme.of(context).colorScheme;
      final outerBackgroundColor = scheme.surfaceContainer;
      final outerBorderColor = scheme.outlineVariant;

      return Container(
        height: (MediaQuery.textScalerOf(context).scale(12) + 24).clamp(
          48,
          120,
        ),
        decoration: BoxDecoration(
          color: outerBackgroundColor,
          border: Border.all(color: outerBorderColor, width: 1),
          borderRadius: BorderRadius.circular(OpenVtsRadius.pill),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(OpenVtsRadius.pill),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: presets.length,
            separatorBuilder: (_, __) =>
                Container(width: 1, height: 32, color: outerBorderColor),
            itemBuilder: (builderContext, index) {
              final preset = presets[index];
              return _PresetCompactChip(
                preset: preset,
                isSelected: preset.type == selectedPreset,
                onTap: () => onSelected(preset),
              );
            },
          ),
        ),
      );
    }

    const spacing = OpenVtsSpacing.xs;

    return LayoutBuilder(
      builder: (layoutContext, constraints) {
        final effectiveWidth =
            constraints.maxWidth /
            (MediaQuery.textScalerOf(context).scale(14) / 14);
        final columns = effectiveWidth >= 520
            ? 6
            : effectiveWidth >= 420
            ? 4
            : effectiveWidth >= 300
            ? 3
            : 2;
        final tileWidth =
            (constraints.maxWidth - (spacing * (columns - 1))) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final preset in presets)
              SizedBox(
                width: tileWidth,
                child: _PresetTile(
                  preset: preset,
                  isSelected: preset.type == selectedPreset,
                  onTap: () => onSelected(preset),
                  compact: false,
                ),
              ),
          ],
        );
      },
    );
  }
}

class _PresetTile extends StatelessWidget {
  const _PresetTile({
    required this.preset,
    required this.isSelected,
    required this.onTap,
    required this.compact,
  });

  final _RangePreset preset;
  final bool isSelected;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final foregroundColor = isSelected ? scheme.onPrimary : scheme.onSurface;
    final backgroundColor = isSelected ? scheme.primary : scheme.surface;
    final borderColor = isSelected ? scheme.primary : scheme.outlineVariant;

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(OpenVtsRadius.md),
      child: InkWell(
        borderRadius: BorderRadius.circular(OpenVtsRadius.md),
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: 76),
          padding: const EdgeInsets.symmetric(
            horizontal: OpenVtsSpacing.xs,
            vertical: OpenVtsSpacing.xs,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(OpenVtsRadius.md),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                preset.icon,
                size: compact ? 18 : 20,
                color: foregroundColor,
              ),
              SizedBox(height: compact ? 4 : 6),
              Text(
                preset.label(context),
                textAlign: TextAlign.center,
                style: OpenVtsTypography.label.copyWith(
                  color: foregroundColor,
                  fontWeight: FontWeight.w600,
                  fontSize: compact ? 11 : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PresetCompactChip extends StatelessWidget {
  const _PresetCompactChip({
    required this.preset,
    required this.isSelected,
    required this.onTap,
  });

  final _RangePreset preset;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final backgroundColor = isSelected ? scheme.primary : Colors.transparent;
    final textColor = isSelected ? scheme.onPrimary : scheme.onSurface;
    final borderColor = isSelected ? scheme.primary : scheme.outlineVariant;

    return Semantics(
      selected: isSelected,
      button: true,
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(OpenVtsRadius.pill),
        child: InkWell(
          borderRadius: BorderRadius.circular(OpenVtsRadius.pill),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: OpenVtsSpacing.sm,
              vertical: OpenVtsSpacing.xs,
            ),
            decoration: isSelected
                ? BoxDecoration(
                    borderRadius: BorderRadius.circular(OpenVtsRadius.pill),
                    border: Border.all(color: borderColor, width: 1),
                  )
                : null,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(preset.icon, size: 16, color: textColor),
                const SizedBox(width: OpenVtsSpacing.xxs),
                Text(
                  preset.label(context),
                  style: OpenVtsTypography.meta.copyWith(
                    color: textColor,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MonthCalendar extends StatelessWidget {
  const _MonthCalendar({
    required this.focusedMonth,
    required this.firstDate,
    required this.lastDate,
    required this.startDate,
    required this.endDate,
    required this.onPreviousMonth,
    required this.onNextMonth,
    required this.onDateSelected,
    required this.onChooseDate,
    required this.compact,
  });

  final DateTime focusedMonth;
  final DateTime firstDate;
  final DateTime lastDate;
  final DateTime startDate;
  final DateTime endDate;
  final VoidCallback? onPreviousMonth;
  final VoidCallback? onNextMonth;
  final ValueChanged<DateTime> onDateSelected;
  final VoidCallback onChooseDate;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final localizations = MaterialLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final firstWeekday = localizations.firstDayOfWeekIndex;
    final days = _daysForMonth(focusedMonth, firstWeekday);
    final textScaler = MediaQuery.textScalerOf(context);

    return Container(
      padding: EdgeInsets.all(compact ? OpenVtsSpacing.xs : OpenVtsSpacing.md),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(OpenVtsRadius.md),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _CalendarNavButton(
                icon: Icons.chevron_left_rounded,
                tooltip: localizations.previousMonthTooltip,
                onPressed: onPreviousMonth,
                compact: compact,
              ),
              Expanded(
                child: InkWell(
                  onTap: onChooseDate,
                  borderRadius: BorderRadius.circular(OpenVtsRadius.md),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 48),
                    child: Center(
                      child: Text(
                        DateFormat.yMMMM(locale).format(focusedMonth),
                        textAlign: TextAlign.center,
                        style: OpenVtsTypography.titleSmall.copyWith(
                          color: scheme.onSurface,
                          fontSize: compact ? 14 : null,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              _CalendarNavButton(
                icon: Icons.chevron_right_rounded,
                tooltip: localizations.nextMonthTooltip,
                onPressed: onNextMonth,
                compact: compact,
              ),
            ],
          ),
          SizedBox(height: compact ? OpenVtsSpacing.xs : OpenVtsSpacing.sm),
          if (textScaler.scale(14) > 24)
            _largeTextDates(context)
          else ...[
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 7,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisExtent: textScaler.scale(compact ? 11 : 12) + 16,
              ),
              itemBuilder: (calendarContext, index) => Center(
                child: Text(
                  localizations.narrowWeekdays[(firstWeekday + index) % 7],
                  style: OpenVtsTypography.meta.copyWith(
                    color: scheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                    fontSize: compact ? 11 : null,
                  ),
                ),
              ),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: days.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisExtent: (textScaler.scale(compact ? 12 : 14) + 20)
                    .clamp(48, 100),
              ),
              itemBuilder: (context, index) {
                final day = days[index];
                final isOutsideMonth = day.month != focusedMonth.month;
                final isDisabled =
                    day.isBefore(firstDate) || day.isAfter(lastDate);
                final isStart = DateUtils.isSameDay(day, startDate);
                final isEnd = DateUtils.isSameDay(day, endDate);
                final isInRange =
                    !day.isBefore(startDate) && !day.isAfter(endDate);

                return _CalendarDayCell(
                  key: ValueKey(
                    'range-day-${day.year}-${day.month}-${day.day}',
                  ),
                  day: day,
                  isOutsideMonth: isOutsideMonth,
                  isDisabled: isDisabled,
                  isSelected: isStart || isEnd,
                  isInRange: isInRange,
                  compact: compact,
                  onTap: isDisabled ? null : () => onDateSelected(day),
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _largeTextDates(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final count = DateUtils.getDaysInMonth(
      focusedMonth.year,
      focusedMonth.month,
    );
    return Column(
      children: List.generate(count, (index) {
        final day = DateTime(focusedMonth.year, focusedMonth.month, index + 1);
        final enabled = !day.isBefore(firstDate) && !day.isAfter(lastDate);
        final selected =
            DateUtils.isSameDay(day, startDate) ||
            DateUtils.isSameDay(day, endDate);
        final inRange = !day.isBefore(startDate) && !day.isAfter(endDate);
        return Material(
          color: Colors.transparent,
          child: ListTile(
            key: ValueKey('range-day-${day.year}-${day.month}-${day.day}'),
            enabled: enabled,
            selected: selected,
            selectedTileColor: scheme.primaryContainer,
            selectedColor: scheme.onPrimaryContainer,
            tileColor: inRange ? scheme.surfaceContainer : null,
            title: Text(MaterialLocalizations.of(context).formatFullDate(day)),
            trailing: selected ? const Icon(Icons.check_rounded) : null,
            onTap: enabled ? () => onDateSelected(day) : null,
          ),
        );
      }),
    );
  }

  List<DateTime> _daysForMonth(DateTime month, int firstWeekday) {
    final firstOfMonth = DateTime(month.year, month.month);
    final daysBefore = (firstOfMonth.weekday - firstWeekday) % 7;
    final firstVisibleDay = DateTime(month.year, month.month, 1 - daysBefore);

    return List<DateTime>.generate(
      42,
      (index) => DateTime(
        firstVisibleDay.year,
        firstVisibleDay.month,
        firstVisibleDay.day + index,
      ),
    );
  }
}

class _CalendarNavButton extends StatelessWidget {
  const _CalendarNavButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    required this.compact,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    const dimension = 48.0;

    return SizedBox.square(
      dimension: dimension,
      child: IconButton(
        tooltip: tooltip,
        onPressed: onPressed,
        icon: Icon(icon, size: compact ? 18 : 22),
        style: IconButton.styleFrom(
          backgroundColor: scheme.surfaceContainer,
          foregroundColor: scheme.onSurface,
          disabledForegroundColor: scheme.onSurfaceVariant,
          side: BorderSide(color: scheme.outlineVariant),
        ),
      ),
    );
  }
}

class _CalendarDayCell extends StatelessWidget {
  const _CalendarDayCell({
    required this.day,
    required this.isOutsideMonth,
    required this.isDisabled,
    required this.isSelected,
    required this.isInRange,
    required this.compact,
    required this.onTap,
    super.key,
  });

  final DateTime day;
  final bool isOutsideMonth;
  final bool isDisabled;
  final bool isSelected;
  final bool isInRange;
  final bool compact;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final dayColor = isSelected
        ? scheme.onPrimary
        : isDisabled || isOutsideMonth
        ? scheme.onSurfaceVariant
        : scheme.onSurface;

    return Semantics(
      label: MaterialLocalizations.of(context).formatFullDate(day),
      selected: isSelected,
      enabled: !isDisabled,
      button: true,
      onTap: onTap,
      excludeSemantics: true,
      child: InkWell(
        borderRadius: BorderRadius.circular(OpenVtsRadius.sm),
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: compact ? 1 : 3),
          decoration: BoxDecoration(
            color: isInRange && !isDisabled
                ? scheme.surfaceContainer
                : Colors.transparent,
            borderRadius: BorderRadius.circular(OpenVtsRadius.sm),
          ),
          alignment: Alignment.center,
          child: Container(
            constraints: const BoxConstraints(minHeight: 40, minWidth: 36),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? scheme.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(OpenVtsRadius.sm),
            ),
            child: Text(
              MaterialLocalizations.of(context).formatDecimal(day.day),
              style: OpenVtsTypography.body.copyWith(
                color: dayColor,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                fontSize: compact ? 12 : null,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SelectedRangeSummary extends StatelessWidget {
  const _SelectedRangeSummary({
    required this.range,
    required this.dateTimeEnabled,
    required this.compact,
  });

  final OpenVtsDateTimeRange range;
  final bool dateTimeEnabled;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final start = range.start;
    final end = range.end;

    final startLabel = start == null
        ? '--'
        : dateTimeEnabled
        ? _formatRangeDate(context, start, includeTime: true)
        : _formatRangeDate(context, start);
    final endLabel = end == null
        ? '--'
        : dateTimeEnabled
        ? _formatRangeDate(context, end, includeTime: true)
        : _formatRangeDate(context, end);

    return Container(
      padding: EdgeInsets.all(compact ? OpenVtsSpacing.xs : OpenVtsSpacing.md),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(OpenVtsRadius.md),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!compact) ...[
            Text(
              context.widgetL10n.dateRangeSelected,
              style: OpenVtsTypography.label.copyWith(
                color: scheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: OpenVtsSpacing.xs),
          ],
          LayoutBuilder(
            builder: (context, constraints) {
              final values = [
                _RangeSummaryValue(
                  label: compact
                      ? context.widgetL10n.dateRangeFrom
                      : context.widgetL10n.reportsDateFrom,
                  value: startLabel,
                  compact: compact,
                ),
                _RangeSummaryValue(
                  label: compact
                      ? context.widgetL10n.dateRangeTo
                      : context.widgetL10n.reportsDateTo,
                  value: endLabel,
                  compact: compact,
                ),
              ];
              final useColumn =
                  constraints.maxWidth < 350 ||
                  MediaQuery.textScalerOf(context).scale(14) > 20;
              return useColumn
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        values[0],
                        const SizedBox(height: OpenVtsSpacing.xs),
                        values[1],
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(child: values[0]),
                        const SizedBox(width: OpenVtsSpacing.xs),
                        Expanded(child: values[1]),
                      ],
                    );
            },
          ),
        ],
      ),
    );
  }
}

class _RangeSummaryValue extends StatelessWidget {
  const _RangeSummaryValue({
    required this.label,
    required this.value,
    required this.compact,
  });

  final String label;
  final String value;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? OpenVtsSpacing.xs : OpenVtsSpacing.sm,
        vertical: compact ? OpenVtsSpacing.xxs : OpenVtsSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: scheme.surfaceContainer,
        borderRadius: BorderRadius.circular(OpenVtsRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: OpenVtsTypography.meta.copyWith(
              color: scheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: OpenVtsTypography.label.copyWith(
              color: scheme.onSurface,
              fontSize: compact ? 12 : null,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _TimeRangeFields extends StatelessWidget {
  const _TimeRangeFields({
    required this.startTime,
    required this.endTime,
    required this.isValid,
    required this.compact,
    required this.onStartTap,
    required this.onEndTap,
  });

  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final bool isValid;
  final bool compact;
  final VoidCallback onStartTap;
  final VoidCallback onEndTap;

  @override
  Widget build(BuildContext context) {
    final fields = LayoutBuilder(
      builder: (context, constraints) {
        final useColumn =
            constraints.maxWidth < 350 ||
            MediaQuery.textScalerOf(context).scale(14) > 20;

        if (useColumn) {
          return Column(
            children: [
              _TimePickerField(
                label: context.widgetL10n.dateRangeStartTime,
                value: _formatTime(context, startTime),
                onTap: onStartTap,
                compact: compact,
              ),
              const SizedBox(height: OpenVtsSpacing.xs),
              _TimePickerField(
                label: context.widgetL10n.dateRangeEndTime,
                value: _formatTime(context, endTime),
                onTap: onEndTap,
                compact: compact,
              ),
            ],
          );
        }

        return Row(
          children: [
            Expanded(
              child: _TimePickerField(
                label: context.widgetL10n.dateRangeStartTime,
                value: _formatTime(context, startTime),
                onTap: onStartTap,
                compact: compact,
              ),
            ),
            SizedBox(width: compact ? OpenVtsSpacing.xs : OpenVtsSpacing.sm),
            Expanded(
              child: _TimePickerField(
                label: context.widgetL10n.dateRangeEndTime,
                value: _formatTime(context, endTime),
                onTap: onEndTap,
                compact: compact,
              ),
            ),
          ],
        );
      },
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        fields,
        if (!isValid) ...[
          const SizedBox(height: OpenVtsSpacing.xs),
          Text(
            context.widgetL10n.dateRangeInvalidTime,
            style: OpenVtsTypography.meta.copyWith(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ],
      ],
    );
  }

  String _formatTime(BuildContext context, TimeOfDay time) {
    final localizations = MaterialLocalizations.of(context);
    final use24HourFormat = MediaQuery.of(context).alwaysUse24HourFormat;
    return localizations.formatTimeOfDay(
      time,
      alwaysUse24HourFormat: use24HourFormat,
    );
  }
}

class _TimePickerField extends StatelessWidget {
  const _TimePickerField({
    required this.label,
    required this.value,
    required this.onTap,
    required this.compact,
  });

  final String label;
  final String value;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(OpenVtsRadius.md),
        child: Ink(
          padding: EdgeInsets.symmetric(
            horizontal: compact ? OpenVtsSpacing.sm : OpenVtsSpacing.md,
            vertical: compact ? OpenVtsSpacing.xs : OpenVtsSpacing.md,
          ),
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: BorderRadius.circular(OpenVtsRadius.md),
            border: Border.all(color: scheme.outlineVariant),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: OpenVtsTypography.label.copyWith(
                        color: scheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      value,
                      style: OpenVtsTypography.titleSmall.copyWith(
                        color: scheme.onSurface,
                        fontWeight: FontWeight.w700,
                        fontSize: compact ? 15 : null,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: OpenVtsSpacing.xs),
              Icon(
                Icons.schedule_rounded,
                size: compact ? 18 : 20,
                color: scheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectorActions extends StatelessWidget {
  const _SelectorActions({
    required this.canApply,
    required this.compact,
    required this.onClear,
    required this.onCancel,
    required this.onApply,
  });

  final bool canApply;
  final bool compact;
  final VoidCallback onClear;
  final VoidCallback onCancel;
  final VoidCallback onApply;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surface,
        border: Border(top: BorderSide(color: scheme.outlineVariant)),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          OpenVtsSpacing.md,
          compact ? OpenVtsSpacing.xs : OpenVtsSpacing.sm,
          OpenVtsSpacing.md,
          compact ? OpenVtsSpacing.xs : OpenVtsSpacing.md,
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final buttons = <Widget>[
              OpenVtsButton(
                label: context.widgetL10n.clearSelection,
                variant: OpenVtsButtonVariant.secondary,
                onPressed: onClear,
              ),
              OpenVtsButton(
                label: context.widgetL10n.cancel,
                variant: OpenVtsButtonVariant.secondary,
                onPressed: onCancel,
              ),
              OpenVtsButton(
                label: context.widgetL10n.apply,
                onPressed: canApply ? onApply : null,
              ),
            ];
            final stack =
                constraints.maxWidth < 300 ||
                MediaQuery.textScalerOf(context).scale(14) > 20;
            return stack
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      buttons[2],
                      const SizedBox(height: OpenVtsSpacing.xs),
                      buttons[1],
                      const SizedBox(height: OpenVtsSpacing.xs),
                      buttons[0],
                    ],
                  )
                : Row(
                    children: [
                      Expanded(child: buttons[0]),
                      const SizedBox(width: OpenVtsSpacing.xs),
                      Expanded(child: buttons[1]),
                      const SizedBox(width: OpenVtsSpacing.xs),
                      Expanded(child: buttons[2]),
                    ],
                  );
          },
        ),
      ),
    );
  }
}

class _RangePreset {
  const _RangePreset({required this.type, required this.icon, this.duration});

  final _RangePresetType type;
  final IconData icon;
  final Duration? duration;

  static const custom = _RangePreset(
    type: _RangePresetType.custom,
    icon: Icons.calendar_today_outlined,
  );

  static const durationPresets = <_RangePreset>[
    _RangePreset(
      type: _RangePresetType.lastHour,
      icon: Icons.access_time_rounded,
      duration: Duration(hours: 1),
    ),
    _RangePreset(
      type: _RangePresetType.last3Hours,
      icon: Icons.timer_3_outlined,
      duration: Duration(hours: 3),
    ),
    _RangePreset(
      type: _RangePresetType.last6Hours,
      icon: Icons.history_toggle_off_rounded,
      duration: Duration(hours: 6),
    ),
    _RangePreset(
      type: _RangePresetType.last12Hours,
      icon: Icons.watch_later_outlined,
      duration: Duration(hours: 12),
    ),
    _RangePreset(
      type: _RangePresetType.last24Hours,
      icon: Icons.schedule_rounded,
      duration: Duration(hours: 24),
    ),
  ];

  static const datePresets = <_RangePreset>[
    _RangePreset(
      type: _RangePresetType.today,
      icon: Icons.calendar_view_day_outlined,
    ),
    _RangePreset(
      type: _RangePresetType.yesterday,
      icon: Icons.event_repeat_outlined,
    ),
    _RangePreset(
      type: _RangePresetType.thisWeek,
      icon: Icons.calendar_view_week_outlined,
    ),
    _RangePreset(
      type: _RangePresetType.lastWeek,
      icon: Icons.calendar_month_outlined,
    ),
    _RangePreset(
      type: _RangePresetType.last7Days,
      icon: Icons.date_range_outlined,
    ),
    _RangePreset(
      type: _RangePresetType.last30Days,
      icon: Icons.calendar_month_outlined,
    ),
  ];

  String label(BuildContext context) => switch (type) {
    _RangePresetType.custom => context.widgetL10n.dateRangeCustom,
    _RangePresetType.lastHour => context.widgetL10n.dateRangeLastHour,
    _RangePresetType.last3Hours => context.widgetL10n.dateRangeLast3Hours,
    _RangePresetType.last6Hours => context.widgetL10n.dateRangeLast6Hours,
    _RangePresetType.last12Hours => context.widgetL10n.dateRangeLast12Hours,
    _RangePresetType.last24Hours => context.widgetL10n.dateRangeLast24Hours,
    _RangePresetType.today => context.widgetL10n.dateRangeToday,
    _RangePresetType.yesterday => context.widgetL10n.dateRangeYesterday,
    _RangePresetType.thisWeek => context.widgetL10n.dateRangeThisWeek,
    _RangePresetType.lastWeek => context.widgetL10n.dateRangeLastWeek,
    _RangePresetType.last7Days => context.widgetL10n.dateRangeLast7Days,
    _RangePresetType.last30Days => context.widgetL10n.dateRangeLast30Days,
  };

  OpenVtsDateTimeRange resolve(
    DateTime now,
    bool dateTimeEnabled, {
    int firstWeekday = 0,
  }) {
    if (duration != null) {
      return OpenVtsDateTimeRange(start: now.subtract(duration!), end: now);
    }

    final today = DateUtils.dateOnly(now);
    final daysSinceWeekStart = (today.weekday - firstWeekday) % 7;
    final thisWeekStart = DateTime(
      today.year,
      today.month,
      today.day - daysSinceWeekStart,
    );

    switch (type) {
      case _RangePresetType.custom:
        return OpenVtsDateTimeRange(start: today, end: today);
      case _RangePresetType.lastHour:
      case _RangePresetType.last3Hours:
      case _RangePresetType.last6Hours:
      case _RangePresetType.last12Hours:
      case _RangePresetType.last24Hours:
        return OpenVtsDateTimeRange(start: now, end: now);
      case _RangePresetType.today:
        return OpenVtsDateTimeRange(
          start: _startOfDay(today),
          end: _endForDate(today, dateTimeEnabled),
        );
      case _RangePresetType.yesterday:
        final yesterday = DateTime(today.year, today.month, today.day - 1);
        return OpenVtsDateTimeRange(
          start: _startOfDay(yesterday),
          end: _endForDate(yesterday, dateTimeEnabled),
        );
      case _RangePresetType.thisWeek:
        return OpenVtsDateTimeRange(
          start: _startOfDay(thisWeekStart),
          end: _endForDate(today, dateTimeEnabled),
        );
      case _RangePresetType.lastWeek:
        final lastWeekStart = DateTime(
          thisWeekStart.year,
          thisWeekStart.month,
          thisWeekStart.day - 7,
        );
        final lastWeekEnd = DateTime(
          lastWeekStart.year,
          lastWeekStart.month,
          lastWeekStart.day + 6,
        );
        return OpenVtsDateTimeRange(
          start: _startOfDay(lastWeekStart),
          end: _endForDate(lastWeekEnd, dateTimeEnabled),
        );
      case _RangePresetType.last7Days:
        return OpenVtsDateTimeRange(
          start: DateTime(today.year, today.month, today.day - 6),
          end: _endForDate(today, dateTimeEnabled),
        );
      case _RangePresetType.last30Days:
        return OpenVtsDateTimeRange(
          start: DateTime(today.year, today.month, today.day - 29),
          end: _endForDate(today, dateTimeEnabled),
        );
    }
  }

  DateTime _startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  DateTime _endForDate(DateTime date, bool dateTimeEnabled) {
    if (!dateTimeEnabled) {
      return DateUtils.dateOnly(date);
    }

    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }
}

enum _RangePresetType {
  custom,
  lastHour,
  last3Hours,
  last6Hours,
  last12Hours,
  last24Hours,
  today,
  yesterday,
  thisWeek,
  lastWeek,
  last7Days,
  last30Days,
}
