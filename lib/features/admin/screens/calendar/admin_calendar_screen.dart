import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/date_time_formatter.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/open_vts_bottom_sheet.dart';
import '../../../../shared/widgets/open_vts_month_calendar.dart';
import '../../../../shared/widgets/open_vts_page_scaffold.dart';
import '../../controllers/admin_calendar_controller.dart';
import 'widgets/admin_calendar_day_bottom_sheet.dart';

class AdminCalendarScreen extends ConsumerWidget {
  const AdminCalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final formatter = ref.watch(appDateFormatterProvider);
    final focused = ref.watch(adminCalendarFocusedDateProvider);
    final selected = ref.watch(adminCalendarSelectedDateProvider);
    final events = ref.watch(adminCalendarEventsProvider);
    final filters = ref.watch(adminCalendarFiltersProvider);
    final scheme = Theme.of(context).colorScheme;
    final options = [
      ('users', l10n.users, scheme.primary),
      ('vehicle', l10n.vehicles, scheme.secondary),
      ('expiry', l10n.calendarExpiry, scheme.error),
    ];
    return OpenVtsPageScaffold(
      title: l10n.calendar,
      headerMode: OpenVtsPageHeaderMode.closeable,
      body: ListView(
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: OpenVtsMonthCalendar(
                focusedDay: focused,
                selectedDay: selected,
                loading: events.isLoading,
                errorMessage: events.hasError
                    ? _calendarErrorMessage(events.error!)
                    : null,
                onRetry: () => ref.invalidate(adminCalendarEventsProvider),
                onFocusMonth: (date) =>
                    ref.read(adminCalendarFocusedDateProvider.notifier).state =
                        date,
                onToday: () {
                  final now = DateTime.now();
                  ref.read(adminCalendarFocusedDateProvider.notifier).state =
                      now;
                  ref.read(adminCalendarSelectedDateProvider.notifier).state =
                      now;
                },
                onSelectDay: (date) {
                  ref.read(adminCalendarSelectedDateProvider.notifier).state =
                      date;
                  ref.read(adminCalendarFocusedDateProvider.notifier).state =
                      date;
                  OpenVtsBottomSheet.show<void>(
                    context: context,
                    title: formatter.formatDate(date),
                    child: AdminCalendarDayBottomSheet(date: date),
                  );
                },
                filters: [
                  for (final option in options)
                    FilterChip(
                      label: Text(option.$2),
                      selectedColor: scheme.primary,
                      checkmarkColor: scheme.onPrimary,
                      labelStyle: TextStyle(
                        color: filters.contains(option.$1)
                            ? scheme.onPrimary
                            : scheme.onSurface,
                      ),
                      selected: filters.contains(option.$1),
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                      onSelected: (value) {
                        ref
                            .read(adminCalendarFiltersProvider.notifier)
                            .state = value
                            ? {...filters, option.$1}.toList()
                            : filters
                                  .where((filter) => filter != option.$1)
                                  .toList();
                      },
                    ),
                ],
                metricsByDay: {
                  for (final event
                      in events.isLoading ? [] : events.valueOrNull ?? [])
                    event.date: [
                      if (filters.contains('users') && event.usersCount > 0)
                        OpenVtsCalendarMetric(
                          label: l10n.users,
                          count: event.usersCount,
                          color: scheme.primary,
                        ),
                      if (filters.contains('vehicle') &&
                          event.vehiclesCount > 0)
                        OpenVtsCalendarMetric(
                          label: l10n.vehicles,
                          count: event.vehiclesCount,
                          color: scheme.secondary,
                        ),
                      if (filters.contains('expiry') && event.expiryCount > 0)
                        OpenVtsCalendarMetric(
                          label: l10n.calendarExpiry,
                          count: event.expiryCount,
                          color: scheme.error,
                        ),
                    ],
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _calendarErrorMessage(Object err) {
    if (err is DioException) {
      final responseMessage = _extractResponseMessage(err.response?.data);
      if (responseMessage != null) return responseMessage;

      if (err.type == DioExceptionType.connectionTimeout ||
          err.type == DioExceptionType.receiveTimeout ||
          err.type == DioExceptionType.sendTimeout) {
        return 'The calendar request timed out. Please try again.';
      }

      if (err.type == DioExceptionType.connectionError) {
        return 'Unable to reach the server right now.';
      }

      final message = err.message?.trim();
      if (message != null && message.isNotEmpty) return message;
    }

    final raw = err.toString().trim();
    if (raw.startsWith('Exception: ')) {
      return raw.substring('Exception: '.length).trim();
    }

    return 'Failed to load calendar events.';
  }

  String? _extractResponseMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      for (final key in const ['message', 'error']) {
        final value = data[key];
        if (value is String && value.trim().isNotEmpty) {
          return value.trim();
        }
      }

      final nestedData = data['data'];
      if (!identical(nestedData, data)) {
        return _extractResponseMessage(nestedData);
      }
    }

    if (data is String && data.trim().isNotEmpty) return data.trim();

    return null;
  }
}
