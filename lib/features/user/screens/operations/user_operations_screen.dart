import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../core/access/workspace_scope_provider.dart';
import '../../../../shared/helpers/toast_helper.dart';
import '../../../../shared/widgets/open_vts_page_scaffold.dart';
import '../../controllers/user_operations_providers.dart';
import '../../models/user_operation_schedule.dart';
import '../../services/user_operations_service.dart';
import 'operations_localizations.dart';
import 'operations_ui.dart';
import 'user_operation_plan_screen.dart';
import 'user_operation_refresh_scope.dart';
import 'user_operation_trip_screen.dart';

class UserOperationsScreen extends ConsumerStatefulWidget {
  const UserOperationsScreen({super.key});
  @override
  ConsumerState<UserOperationsScreen> createState() =>
      _UserOperationsScreenState();
}

class _UserOperationsScreenState extends ConsumerState<UserOperationsScreen> {
  String _tab = 'today';
  String _search = '';
  final _searchController = TextEditingController();
  Timer? _searchDebounce;
  bool _initializedMonth = false;
  String? _status;
  DateTime? _date;
  DateTime _month = DateTime.now();
  DateTimeRange? _range;
  final Set<String> _busy = {};
  UserOperationsState get _state => ref.read(userOperationsControllerProvider);
  Map<String, dynamic> get _data => _state.data;
  List<Map<String, dynamic>> get _items => _state.items;
  bool get _loading => _state.loading;
  String? get _error =>
      _state.error == null ? null : operationError(context, _state.error!);

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _searchNow() {
    _searchDebounce?.cancel();
    _load();
  }

  Future<void> _load({bool more = false}) =>
      ref.read(userOperationsControllerProvider.notifier).load(_tab, {
        if (_tab == 'calendar')
          'month': DateFormat('yyyy-MM').format(_month)
        else ...{
          if (_search.isNotEmpty) 'search': _search,
          if (_status != null) 'status': _status,
          if (_tab == 'today' && _date != null)
            'date': operationDateKey(_date!),
          if (_tab == 'trips' && _range != null) ...{
            'from': operationDateKey(_range!.start),
            'to': operationDateKey(_range!.end),
          },
        },
      }, more: more);

  @override
  Widget build(BuildContext context) {
    ref.listen(workspaceDataScopeProvider, (previous, next) {
      if (previous != null && previous != next) {
        setState(() {
          _tab = 'today';
          _status = null;
          _search = '';
          _searchController.clear();
          _searchDebounce?.cancel();
          _initializedMonth = false;
          _date = null;
          _range = null;
          _busy.clear();
        });
      }
    });
    ref.watch(userOperationsControllerProvider);
    final pagination = operationMap(_data['pagination']);
    final total = (pagination['total'] as num?)?.toInt() ?? _items.length;
    return OpenVtsPageScaffold(
      title: context.operationText('Operations'),
      padding: EdgeInsets.zero,
      actions: [
        IconButton(
          tooltip: context.operationText('Plan trip'),
          onPressed: () => _plan(),
          icon: const Icon(Icons.add_rounded),
        ),
      ],
      body: UserOperationRefreshScope(
        onRefresh: () {
          if (!_loading && _busy.isEmpty && _state.page == 1) _load();
        },
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(12),
              child: Row(
                children:
                    {
                          'today': context.operationText('Today'),
                          'calendar': context.operationText('Calendar'),
                          'trips': context.operationText('Trips'),
                          'recurring': context.operationText('Recurring'),
                          'drivers': context.operationText('Drivers'),
                        }.entries
                        .map(
                          (entry) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(entry.value),
                              selected: _tab == entry.key,
                              onSelected: (_) {
                                setState(() {
                                  if (entry.key == 'calendar' &&
                                      !_initializedMonth) {
                                    _month = operationAccountNow(
                                      '${_data['timezone'] ?? 'UTC'}',
                                    );
                                    _initializedMonth = true;
                                  }
                                  _tab = entry.key;
                                  _status = null;
                                  _search = '';
                                  _searchController.clear();
                                  _searchDebounce?.cancel();
                                });
                                _load();
                              },
                            ),
                          ),
                        )
                        .toList(),
              ),
            ),
            if (_tab != 'calendar') ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _searchController,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: context.operationText('Search {field}', {
                      'field': context.operationText(switch (_tab) {
                        'recurring' => 'Recurring',
                        'drivers' => 'Drivers',
                        _ => 'Trips',
                      }),
                    }),
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      tooltip: context.operationText('Search'),
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: _searchNow,
                    ),
                    counterText: '',
                  ),
                  maxLength: 100,
                  onChanged: (value) {
                    _search = value.trim();
                    _searchDebounce?.cancel();
                    _searchDebounce = Timer(
                      const Duration(milliseconds: 350),
                      _searchNow,
                    );
                  },
                  onSubmitted: (_) => _searchNow(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        key: ValueKey('$_tab:${_status ?? ''}'),
                        initialValue: _status ?? '',
                        isExpanded: true,
                        decoration: InputDecoration(
                          labelText: context.operationText('Status'),
                          isDense: true,
                        ),
                        items: [
                          DropdownMenuItem(
                            value: '',
                            child: Text(context.operationText('All statuses')),
                          ),
                          ..._statuses.map(
                            (s) => DropdownMenuItem(
                              value: s,
                              child: Text(operationLabel(context, s)),
                            ),
                          ),
                        ],
                        onChanged: (v) {
                          setState(() => _status = v == '' ? null : v);
                          _load();
                        },
                      ),
                    ),
                    if (_tab == 'today' || _tab == 'trips')
                      IconButton(
                        tooltip: _tab == 'today'
                            ? context.operationText('Choose day')
                            : context.operationText('Choose date range'),
                        onPressed: _pickDate,
                        icon: const Icon(Icons.date_range),
                      ),
                    IconButton(
                      tooltip: context.operationText('Refresh'),
                      onPressed: _loading ? null : () => _load(),
                      icon: const Icon(Icons.refresh),
                    ),
                  ],
                ),
              ),
            ] else
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    tooltip: context.operationText('Previous month'),
                    onPressed: () => _shiftMonth(-1),
                    icon: const Icon(Icons.chevron_left),
                  ),
                  Flexible(
                    child: Text(
                      DateFormat(
                        'MMMM y',
                        Localizations.localeOf(context).toLanguageTag(),
                      ).format(_month),
                    ),
                  ),
                  IconButton(
                    tooltip: context.operationText('Next month'),
                    onPressed: () => _shiftMonth(1),
                    icon: const Icon(Icons.chevron_right),
                  ),
                ],
              ),
            if (_tab == 'today' && (_date != null || _data['date'] != null))
              Text(
                '${_date != null ? operationDateKey(_date!) : _data['date']} • ${_data['timezone'] ?? context.operationText('Account timezone')}',
              ),
            if (_tab == 'trips' && _range != null)
              TextButton(
                onPressed: () {
                  setState(() => _range = null);
                  _load();
                },
                child: Text(
                  '${operationDateKey(_range!.start)} – ${operationDateKey(_range!.end)}  ×',
                ),
              ),
            if (_loading) const LinearProgressIndicator(minHeight: 2),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => _load(),
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  children: [
                    if (_error != null)
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Text(_error!),
                              TextButton(
                                onPressed: () => _load(),
                                child: Text(context.operationText('Retry')),
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (_tab == 'today' && _data['summary'] is Map)
                      _summary(operationMap(_data['summary'])),
                    if (_tab == 'calendar') ...[
                      Text(
                        '${context.operationText('{count} trips', {'count': _data['totalTrips'] ?? 0})} • ${_data['timezone'] ?? context.operationText('Account timezone')}',
                      ),
                      _calendar(),
                    ] else ...[
                      if (!_loading && _items.isEmpty && _error == null)
                        Padding(
                          padding: const EdgeInsets.all(32),
                          child: Center(
                            child: Text(
                              context.operationText(
                                'No records for this view.',
                              ),
                            ),
                          ),
                        ),
                      ..._items.map(_card),
                      if (_items.length < total)
                        OutlinedButton(
                          onPressed: _loading ? null : () => _load(more: true),
                          child: Text(
                            context.operationText(
                              'Load more ({loaded} of {total})',
                              {'loaded': _items.length, 'total': total},
                            ),
                          ),
                        ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _calendar() {
    final days = {
      for (final row in operationItems(_data['days']))
        '${row['date']}': (row['count'] as num?)?.toInt() ?? 0,
    };
    final colors = Theme.of(context).colorScheme;
    return TableCalendar<int>(
      locale: Localizations.localeOf(context).toLanguageTag(),
      firstDay: DateTime(2000),
      lastDay: DateTime(2100),
      focusedDay: _month,
      headerVisible: false,
      availableGestures: AvailableGestures.horizontalSwipe,
      calendarFormat: CalendarFormat.month,
      startingDayOfWeek: StartingDayOfWeek.monday,
      rowHeight: 58,
      daysOfWeekHeight: 28,
      eventLoader: (day) {
        final count = days[operationDateKey(day)] ?? 0;
        return count > 0 ? [count] : [];
      },
      calendarBuilders: CalendarBuilders<int>(
        markerBuilder: (context, date, events) => events.isEmpty
            ? null
            : Positioned(
                bottom: 1,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    color: colors.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${events.single}',
                    style: TextStyle(
                      color: colors.onPrimaryContainer,
                      fontSize: 11,
                    ),
                  ),
                ),
              ),
      ),
      calendarStyle: CalendarStyle(
        todayDecoration: BoxDecoration(
          color: colors.secondaryContainer,
          shape: BoxShape.circle,
        ),
        todayTextStyle: TextStyle(color: colors.onSecondaryContainer),
        outsideDaysVisible: false,
      ),
      onPageChanged: (day) {
        setState(() => _month = day);
        _load();
      },
      onDaySelected: (day, _) {
        setState(() {
          _date = day;
          _tab = 'today';
          _status = null;
          _search = '';
          _searchController.clear();
        });
        _load();
      },
    );
  }

  List<String> get _statuses => switch (_tab) {
    'recurring' => ['ACTIVE', 'PAUSED', 'ENDED'],
    'drivers' => ['ON_TRIP', 'ASSIGNED', 'NO_ASSIGNMENT', 'ATTENTION'],
    _ => [
      'ASSIGNED',
      'ACKNOWLEDGED',
      'IN_PROGRESS',
      'COMPLETED',
      'FAILED',
      'CANCELLED',
    ],
  };
  Widget _summary(Map<String, dynamic> data) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Wrap(
      spacing: 8,
      runSpacing: 8,
      children:
          {
                'totalTrips': context.operationText('Trips'),
                'running': context.operationText('Running'),
                'completed': context.operationText('Completed'),
                'needsAttention': context.operationText('Attention'),
              }.entries
              .map((e) => Chip(label: Text('${e.value}: ${data[e.key] ?? 0}')))
              .toList(),
    ),
  );
  Widget _card(Map<String, dynamic> row) {
    final vehicle = operationMap(row['vehicle']);
    final driver = operationMap(row['driver']);
    if (_tab == 'drivers') {
      return Card(
        child: ListTile(
          leading: const Icon(Icons.person_outline),
          title: Text('${row['name'] ?? driver['name'] ?? 'Driver'}'),
          subtitle: Text(
            operationLabel(
              context,
              '${row['operationalStatus'] ?? row['status'] ?? ''}',
            ),
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _driver(row),
        ),
      );
    }
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${row['title'] ?? 'Trip'}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                if (_tab == 'recurring')
                  PopupMenuButton<String>(
                    tooltip: context.operationText(
                      'Recurring schedule actions',
                    ),
                    enabled: !_busy.contains('${row['id']}'),
                    onSelected: (action) => _recurringAction(row, action),
                    itemBuilder: (_) => [
                      if (row['status'] != 'ENDED')
                        PopupMenuItem(
                          value: 'edit',
                          child: Text(context.operationText('Edit schedule')),
                        ),
                      if (row['status'] == 'ACTIVE')
                        PopupMenuItem(
                          value: 'pause',
                          child: Text(context.operationText('Pause')),
                        ),
                      if (row['status'] == 'PAUSED')
                        PopupMenuItem(
                          value: 'resume',
                          child: Text(context.operationText('Resume')),
                        ),
                      if (row['status'] != 'ENDED')
                        PopupMenuItem(
                          value: 'end',
                          child: Text(context.operationText('End schedule')),
                        ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Text(context.operationText('Delete schedule')),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              [
                vehicle['name'],
                vehicle['plateNumber'],
                driver['name'],
              ].where((v) => v != null && '$v'.isNotEmpty).join(' • '),
            ),
            const SizedBox(height: 6),
            Text(
              operationLabel(
                context,
                '${row['lifecycleStatus'] ?? row['status'] ?? ''}',
              ),
            ),
            if (_tab == 'recurring') ...[
              Text('${row['startTime'] ?? ''} • ${row['timezone'] ?? ''}'),
              Text(
                context.operationText('Next: {date}', {
                  'date': operationDate(
                    row['nextOccurrence'],
                    timezone: row['timezone']?.toString(),
                    context: context,
                  ),
                }),
              ),
              if (row['lastGenerationError'] != null)
                Text(
                  '${row['lastGenerationError']}',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
            ] else ...[
              Text('${row['serviceDate'] ?? ''} • ${row['timezone'] ?? ''}'),
              if (row['progress'] is Map)
                Text(
                  context.operationText('{completed}/{total} stops', {
                    'completed':
                        operationMap(row['progress'])['completedStops'] ?? 0,
                    'total': operationMap(row['progress'])['totalStops'] ?? 0,
                  }),
                ),
              if (row['attentionCodes'] is List &&
                  (row['attentionCodes'] as List).isNotEmpty)
                Text(
                  (row['attentionCodes'] as List)
                      .map((e) => operationLabel(context, '$e'))
                      .join(' • '),
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => _details(row),
                  child: Text(context.operationText('View trip')),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    if (_tab == 'today') {
      final date = await showDatePicker(
        context: context,
        initialDate: _date ?? DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );
      if (date == null || !mounted) return;
      setState(() => _date = date);
    } else {
      final range = await showDateRangePicker(
        context: context,
        initialDateRange: _range,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );
      if (range == null || !mounted) return;
      setState(() => _range = range);
    }
    await _load();
  }

  void _shiftMonth(int shift) {
    setState(() {
      _month = DateTime(_month.year, _month.month + shift);
    });
    _load();
  }

  Future<void> _plan([Map<String, dynamic>? recurring]) async {
    final changed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => UserOperationPlanScreen(recurring: recurring),
      ),
    );
    if (changed == true && mounted) await _load();
  }

  Future<void> _recurringAction(Map<String, dynamic> row, String action) async {
    if (action == 'edit') {
      await _plan(row);
      return;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          context.operationText('{action} recurring schedule?', {
            'action': operationLabel(context, action),
          }),
        ),
        content: Text('${row['title']}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(context.operationText('Keep schedule')),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(operationLabel(context, action)),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    final id = '${row['id']}';
    setState(() => _busy.add(id));
    try {
      await ref.read(userOperationsActionsProvider).recurringAction(id, action);
      if (mounted) await _load();
    } catch (e) {
      if (mounted) _showError(e);
    } finally {
      if (mounted) setState(() => _busy.remove(id));
    }
  }

  Future<void> _details(Map<String, dynamic> row) async {
    await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => UserOperationTripScreen(id: '${row['id']}'),
      ),
    );
    if (mounted) await _load();
  }

  Future<void> _driver(Map<String, dynamic> row) => showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (ctx) => SafeArea(
      child: SizedBox(
        height: MediaQuery.sizeOf(ctx).height * .75,
        child: _DriverDashboard(
          id: '${row['id']}',
          onTrip: (trip) {
            Navigator.pop(ctx);
            _details(trip);
          },
        ),
      ),
    ),
  );
  void _showError(Object error) =>
      ToastHelper.showError(operationError(context, error), context: context);
}

class _DriverDashboard extends ConsumerWidget {
  const _DriverDashboard({required this.id, required this.onTrip});
  final String id;
  final ValueChanged<Map<String, dynamic>> onTrip;
  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) => UserOperationRefreshScope(
    onRefresh: () => ref.invalidate(userOperationDriverProvider(id)),
    child: ref
        .watch(userOperationDriverProvider(id))
        .when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(operationError(context, error)),
                TextButton(
                  onPressed: () =>
                      ref.invalidate(userOperationDriverProvider(id)),
                  child: Text(context.operationText('Retry')),
                ),
              ],
            ),
          ),
          data: (data) => RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(userOperationDriverProvider(id));
              await ref.read(userOperationDriverProvider(id).future);
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              children: [
                Text(
                  '${operationMap(data['driver'])['name'] ?? context.operationText('Driver')}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text('${data['date'] ?? ''} • ${data['timezone'] ?? ''}'),
                const SizedBox(height: 16),
                ...operationMap(data['summary']).entries.map(
                  (e) => ListTile(
                    title: Text(operationLabel(context, e.key)),
                    trailing: Text('${e.value ?? '—'}'),
                  ),
                ),
                ...operationItems(data['trips']).map(
                  (trip) => ListTile(
                    title: Text(
                      '${trip['title'] ?? context.operationText('Trip')}',
                    ),
                    subtitle: Text(
                      operationLabel(context, '${trip['status'] ?? ''}'),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => onTrip(trip),
                  ),
                ),
              ],
            ),
          ),
        ),
  );
}
