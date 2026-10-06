import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../shared/helpers/toast_helper.dart';
import '../../../../shared/helpers/validation_localizations.dart';
import '../../../../shared/widgets/open_vts_button.dart';
import '../../../../shared/widgets/open_vts_card.dart';
import '../../../../shared/widgets/open_vts_searchable_dropdown.dart';
import '../../controllers/user_operations_providers.dart';
import '../../models/user_landmark_model.dart';
import '../../models/user_operation_schedule.dart';
import '../../services/user_operations_service.dart';
import 'operations_localizations.dart';
import 'operations_ui.dart';
import 'user_operation_route_builder_screen.dart';

/// UI boundary is injectable so creation -> saved route -> trip submission is
/// testable without contacting map tiles or a production routing service.
typedef UserOperationRouteEditor =
    Future<UserRouteLandmark?> Function(
      BuildContext context,
      UserRouteLandmark? initialRoute,
    );
final userOperationRouteEditorProvider = Provider<UserOperationRouteEditor>(
  (ref) =>
      (context, route) => Navigator.of(context).push<UserRouteLandmark>(
        MaterialPageRoute(
          builder: (_) => UserOperationRouteBuilderScreen(initialRoute: route),
        ),
      ),
);

class UserOperationPlanScreen extends ConsumerStatefulWidget {
  const UserOperationPlanScreen({super.key, this.recurring});
  final Map<String, dynamic>? recurring;
  @override
  ConsumerState<UserOperationPlanScreen> createState() =>
      _UserOperationPlanScreenState();
}

class _UserOperationPlanScreenState
    extends ConsumerState<UserOperationPlanScreen> {
  final _form = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _remark = TextEditingController();
  final _exceptions = TextEditingController();
  final _scroll = ScrollController();
  final _errorKey = GlobalKey();
  int? _vehicle;
  int? _route;
  bool _recurring = false;
  bool _saving = false;
  bool _openingRoute = false;
  bool _dirty = false;
  bool _allowPop = false;
  bool _confirmingExit = false;
  bool _initializedDay = false;
  String _schedule = 'DATE_ONLY';
  DateTime _date = DateTime.now();
  DateTime? _endDate;
  TimeOfDay _start = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _end = const TimeOfDay(hour: 17, minute: 0);
  final Set<int> _weekdays = {1, 2, 3, 4, 5};
  Map<String, dynamic>? _savedRoute;
  String? _error;
  bool get _busy => _saving || _openingRoute;

  @override
  void initState() {
    super.initState();
    final existing = widget.recurring;
    if (existing != null) {
      _recurring = true;
      _initializedDay = true;
      _title.text = '${existing['title'] ?? ''}';
      _remark.text = '${existing['remark'] ?? ''}';
      _vehicle = _id(operationMap(existing['vehicle'])['id']);
      _route = _id(operationMap(existing['route'])['id']);
      _date = DateTime.tryParse('${existing['startDate']}') ?? _date;
      _endDate = DateTime.tryParse('${existing['endDate']}');
      _schedule = '${existing['scheduleType'] ?? 'FIXED_TIME'}';
      _start = _parseClock(existing['startTime']) ?? _start;
      _end = _parseClock(existing['endTime']) ?? _end;
      _weekdays
        ..clear()
        ..addAll(
          (existing['weekdays'] as List? ?? []).whereType<num>().map(
            (n) => n.toInt(),
          ),
        );
      _exceptions.text = (existing['exceptionDates'] as List? ?? []).join('\n');
    }
    _title.addListener(_changed);
    _remark.addListener(_changed);
    _exceptions.addListener(_changed);
  }

  void _changed() {
    if (!_dirty && mounted) setState(() => _dirty = true);
  }

  void _change(VoidCallback update) => setState(() {
    update();
    _dirty = true;
    _error = null;
  });
  static int? _id(dynamic value) => int.tryParse('$value');

  @override
  void dispose() {
    _title.dispose();
    _remark.dispose();
    _exceptions.dispose();
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => PopScope<bool>(
    canPop: _allowPop || (!_dirty && !_busy),
    onPopInvokedWithResult: (didPop, _) {
      if (!didPop && !_busy) _requestExit();
    },
    child: Scaffold(
      appBar: AppBar(
        title: Text(
          widget.recurring == null
              ? context.operationText('Plan trip')
              : context.operationText('Edit recurring schedule'),
        ),
        actions: [
          IconButton(
            tooltip: context.operationText('Refresh planning options'),
            onPressed: _busy
                ? null
                : () => ref.invalidate(userOperationPlanningProvider),
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: ref
            .watch(userOperationPlanningProvider)
            .when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        operationError(context, error),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      OpenVtsButton(
                        label: context.operationText('Retry'),
                        onPressed: () =>
                            ref.invalidate(userOperationPlanningProvider),
                        variant: OpenVtsButtonVariant.secondary,
                        trailingIcon: Icons.refresh_rounded,
                      ),
                    ],
                  ),
                ),
              ),
              data: _buildForm,
            ),
      ),
    ),
  );

  Widget _buildForm(Map<String, dynamic> data) {
    final timezone = '${data['timezone'] ?? 'UTC'}';
    if (!_initializedDay) {
      _date = operationAccountNow(timezone);
      _initializedDay = true;
    }
    final vehicles = operationItems(data['vehicles']);
    final eligible = vehicles
        .where((v) => v['eligible'] == true && _id(v['id']) != null)
        .toList();
    final unavailable = vehicles.where((v) => v['eligible'] != true).toList();
    final routes = [
      if (_savedRoute != null) _savedRoute!,
      ...operationItems(
        data['routes'],
      ).where((r) => _id(r['id']) != _id(_savedRoute?['id'])),
    ];
    final selectedVehicle = eligible
        .where((v) => _id(v['id']) == _vehicle)
        .firstOrNull;
    final selectedRoute = routes
        .where((r) => _id(r['id']) == _route)
        .firstOrNull;
    return Form(
      key: _form,
      child: ListView(
        controller: _scroll,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          if (_openingRoute) const LinearProgressIndicator(),
          _section(
            context.operationText('Vehicle and route'),
            Icons.route_rounded,
            [
              Text(
                'Times use $timezone.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 16),
              OpenVtsSearchableDropdown<int>(
                key: const ValueKey('operation-vehicle'),
                label: context.operationText('Vehicle and driver'),
                value: selectedVehicle == null ? null : _vehicle,
                enabled: !_busy,
                hintText: context.operationText('Choose a vehicle'),
                searchHintText: context.operationText(
                  'Search vehicle, plate or driver',
                ),
                emptyMessage: context.operationText(
                  'No eligible vehicle is available.',
                ),
                leadingIcon: Icons.local_shipping_outlined,
                required: true,
                options: eligible
                    .map(
                      (v) => OpenVtsDropdownOption<int>(
                        value: _id(v['id'])!,
                        label: '${v['name'] ?? v['plateNumber'] ?? ''}',
                        subtitle:
                            [
                                  v['plateNumber'],
                                  operationMap(v['driver'])['name'],
                                ]
                                .where(
                                  (value) =>
                                      value != null && '$value'.isNotEmpty,
                                )
                                .join(' • '),
                        searchText: '${v['imei'] ?? ''}',
                      ),
                    )
                    .toList(),
                validator: (value) =>
                    !eligible.any((v) => _id(v['id']) == value)
                    ? context.operationText('Choose an eligible vehicle')
                    : null,
                onChanged: (value) => _change(() => _vehicle = value),
              ),
              if (eligible.isEmpty) ...[
                const SizedBox(height: 12),
                _notice(
                  context.operationText(
                    'No eligible vehicle is available. Assign an active driver to an active vehicle before planning.',
                  ),
                ),
              ],
              if (unavailable.isNotEmpty)
                ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  title: Text(context.operationText('Unavailable vehicles')),
                  children: unavailable
                      .map(
                        (v) => ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.info_outline_rounded),
                          title: Text('${v['name'] ?? ''}'),
                          subtitle: Text(
                            operationLabel(
                              context,
                              '${v['eligibility'] ?? 'UNAVAILABLE'}',
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              if (selectedVehicle?['gpsWarning'] != null) ...[
                const SizedBox(height: 12),
                _notice(
                  context.operationText(
                    'GPS is not linked. The trip can be planned, but live tracking will be unavailable.',
                  ),
                ),
              ],
              const SizedBox(height: 20),
              OpenVtsSearchableDropdown<int>(
                key: const ValueKey('operation-route'),
                label: context.operationText('Route'),
                value: selectedRoute == null ? null : _route,
                enabled: !_busy,
                hintText: context.operationText('Choose a route'),
                searchHintText: context.operationText('Search routes'),
                emptyMessage: context.operationText(
                  'Create a route to start planning.',
                ),
                leadingIcon: Icons.route_outlined,
                required: true,
                options: routes
                    .where((r) => _id(r['id']) != null)
                    .map(
                      (r) => OpenVtsDropdownOption<int>(
                        value: _id(r['id'])!,
                        label: '${r['name'] ?? ''}',
                        subtitle: context.operationText('{count} stops', {
                          'count': r['stopCount'] ?? 0,
                        }),
                        searchText: '${r['description'] ?? ''}',
                      ),
                    )
                    .toList(),
                validator: (value) => !routes.any((r) => _id(r['id']) == value)
                    ? context.operationText('Choose a route')
                    : null,
                onChanged: (value) => _change(() => _route = value),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  OpenVtsButton(
                    key: const ValueKey('operation-create-route'),
                    label: context.operationText('Create route'),
                    onPressed: _busy ? null : () => _editRoute(),
                    variant: OpenVtsButtonVariant.secondary,
                    trailingIcon: Icons.add_rounded,
                  ),
                  if (selectedRoute != null)
                    OpenVtsButton(
                      key: const ValueKey('operation-edit-route'),
                      label: context.operationText('Edit route'),
                      onPressed: _busy ? null : () => _editRoute(id: _route),
                      variant: OpenVtsButtonVariant.secondary,
                      trailingIcon: Icons.edit_outlined,
                    ),
                ],
              ),
              if (selectedRoute != null &&
                  '${selectedRoute['description'] ?? ''}'.trim().isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text('${selectedRoute['description']}'),
                ),
            ],
          ),
          const SizedBox(height: 16),
          _section(
            context.operationText('Trip details'),
            Icons.edit_note_rounded,
            [
              TextFormField(
                key: const ValueKey('operation-title'),
                controller: _title,
                enabled: !_busy,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: context.operationText('Trip title'),
                ),
                maxLength: 120,
                validator: context.localizedValidator(
                  (v) => (v?.trim().length ?? 0) < 2
                      ? context.operationText('Enter at least 2 characters')
                      : null,
                ),
              ),
              TextFormField(
                controller: _remark,
                enabled: !_busy,
                maxLength: 600,
                minLines: 2,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: context.operationText('Remark (optional)'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _section(
            context.operationText('Schedule'),
            Icons.calendar_month_outlined,
            [
              if (widget.recurring == null)
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  title: Text(context.operationText('Recurring schedule')),
                  value: _recurring,
                  onChanged: _busy
                      ? null
                      : (value) => _change(() {
                          _recurring = value;
                          _schedule = value ? 'FIXED_TIME' : 'DATE_ONLY';
                          _endDate = null;
                        }),
                ),
              OpenVtsSearchableDropdown<String>(
                key: ValueKey(_schedule),
                value: _schedule,
                enabled: !_busy,
                label: context.operationText('Schedule'),
                options:
                    (_recurring
                            ? ['FIXED_TIME', 'TIME_SLOT']
                            : [
                                'DATE_ONLY',
                                'FIXED_TIME',
                                'TIME_SLOT',
                                'MULTI_DAY',
                              ])
                        .map(
                          (schedule) => OpenVtsDropdownOption(
                            value: schedule,
                            label: operationLabel(context, schedule),
                          ),
                        )
                        .toList(),
                onChanged: (value) {
                  if (value != null) _change(() => _schedule = value);
                },
              ),
              const SizedBox(height: 8),
              Text(
                _scheduleDescription,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              _dateTile(
                _recurring
                    ? context.operationText('Starts')
                    : context.operationText('Date'),
                operationDateKey(_date),
                () => _pickDay(false),
              ),
              if (_recurring || _schedule == 'MULTI_DAY')
                _dateTile(
                  _recurring
                      ? context.operationText('Ends (optional)')
                      : context.operationText('End date'),
                  _endDate == null
                      ? context.operationText('Choose date')
                      : operationDateKey(_endDate!),
                  () => _pickDay(true),
                ),
              if (_endDate != null && _recurring)
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: OpenVtsButton(
                    label: context.operationText('Remove end date'),
                    onPressed: _busy
                        ? null
                        : () => _change(() => _endDate = null),
                    variant: OpenVtsButtonVariant.secondary,
                  ),
                ),
              if (_schedule != 'DATE_ONLY')
                _dateTile(
                  context.operationText('Start time'),
                  _start.format(context),
                  () => _pickTime(false),
                  time: true,
                ),
              if (_schedule == 'TIME_SLOT' || _schedule == 'MULTI_DAY')
                _dateTile(
                  _schedule == 'TIME_SLOT'
                      ? context.operationText('Latest start time')
                      : context.operationText('End time'),
                  _end.format(context),
                  () => _pickTime(true),
                  time: true,
                ),
              if (_recurring) ...[
                const Divider(height: 24),
                Text(
                  context.operationText('Repeat on'),
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  children: [
                    for (final day in [1, 2, 3, 4, 5, 6, 0])
                      FilterChip(
                        label: Text(
                          DateFormat.E(
                            Localizations.localeOf(context).toLanguageTag(),
                          ).format(DateTime(2026, 10, 4 + day)),
                        ),
                        selected: _weekdays.contains(day),
                        onSelected: _busy
                            ? null
                            : (selected) => _change(() {
                                selected
                                    ? _weekdays.add(day)
                                    : _weekdays.remove(day);
                              }),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _exceptions,
                  enabled: !_busy,
                  minLines: 2,
                  maxLines: 4,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    labelText: context.operationText('Skip dates (optional)'),
                    hintText: context.operationText(
                      'YYYY-MM-DD, one date per line',
                    ),
                  ),
                  validator: context.localizedValidator(_validateExceptions),
                ),
              ],
            ],
          ),
          if (_error != null)
            Padding(
              key: _errorKey,
              padding: const EdgeInsets.only(top: 16),
              child: _notice(_error!, error: true),
            ),
          const SizedBox(height: 20),
          OpenVtsButton(
            key: const ValueKey('operation-save-plan'),
            onPressed: _busy || eligible.isEmpty || routes.isEmpty
                ? null
                : () => _save(timezone),
            isLoading: _saving,
            trailingIcon: Icons.check_rounded,
            label: widget.recurring != null
                ? context.operationText('Save schedule')
                : _recurring
                ? context.operationText('Create schedule')
                : context.operationText('Create trip'),
          ),
        ],
      ),
    );
  }

  Widget _section(String title, IconData icon, List<Widget> children) =>
      OpenVtsCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(icon, size: 21),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      );
  Widget _notice(String text, {bool error = false}) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: error
          ? Theme.of(context).colorScheme.errorContainer
          : Theme.of(context).colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          error ? Icons.error_outline : Icons.info_outline,
          size: 20,
          color: error ? Theme.of(context).colorScheme.onErrorContainer : null,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: error
                ? TextStyle(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  )
                : null,
          ),
        ),
      ],
    ),
  );
  Widget _dateTile(
    String title,
    String value,
    VoidCallback onTap, {
    bool time = false,
  }) => ListTile(
    contentPadding: EdgeInsets.zero,
    leading: Icon(time ? Icons.schedule_outlined : Icons.event_outlined),
    title: Text(title),
    subtitle: Text(value),
    trailing: const Icon(Icons.chevron_right_rounded),
    onTap: _busy ? null : onTap,
  );
  String get _scheduleDescription => switch (_schedule) {
    'DATE_ONLY' => context.operationText(
      'The driver can start any time on the selected day.',
    ),
    'FIXED_TIME' => context.operationText(
      'The trip starts at a specific time in the account timezone.',
    ),
    'TIME_SLOT' => context.operationText(
      'The driver can start within this time window. The end of the window is not the trip completion time.',
    ),
    _ => context.operationText(
      'Choose the start and completion date and time for a multi-day trip.',
    ),
  };

  Future<void> _editRoute({int? id}) async {
    setState(() {
      _openingRoute = true;
      _error = null;
    });
    try {
      // The editor loads the complete current route before allowing edits.
      // Passing its identity avoids two consecutive detail requests.
      final initial = id == null
          ? null
          : UserRouteLandmark.fromJson({'id': id, 'name': ''});
      if (!mounted) return;
      final saved = await ref.read(userOperationRouteEditorProvider)(
        context,
        initial,
      );
      if (!mounted || saved == null) return;
      final routeId = int.tryParse(saved.id);
      if (routeId == null || routeId < 1 || !saved.isActive) {
        throw const FormatException(
          'The saved route is unavailable for planning. Refresh routes and try again.',
        );
      }
      _change(() {
        _route = routeId;
        _savedRoute = {
          'id': routeId,
          'name': saved.name,
          'description': saved.description,
          'stopCount': saved.stops.where((stop) => !stop.isVia).length,
          'toleranceMeters': saved.toleranceMeters,
        };
      });
      // Keep the saved route selected even if the refresh is temporarily late.
      // The server rechecks eligibility at trip creation.
      ref.invalidate(userOperationPlanningProvider);
    } catch (error) {
      if (mounted) _showError(error);
    } finally {
      if (mounted) setState(() => _openingRoute = false);
    }
  }

  List<String> get _exceptionDates =>
      _exceptions.text
          .split(RegExp(r'[\s,]+'))
          .where((s) => s.isNotEmpty)
          .toSet()
          .toList()
        ..sort();
  String? _validateExceptions(String? _) {
    if (_exceptionDates.length > 100) {
      return context.operationText('Use at most 100 skip dates');
    }
    for (final value in _exceptionDates) {
      final parsed = DateTime.tryParse(value);
      if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value) ||
          parsed == null ||
          operationDateKey(parsed) != value) {
        return context.operationText('Use valid dates in YYYY-MM-DD format');
      }
      if (value.compareTo(operationDateKey(_date)) < 0 ||
          (_endDate != null &&
              value.compareTo(operationDateKey(_endDate!)) > 0)) {
        return context.operationText(
          'Skip dates must be inside the schedule date range.',
        );
      }
    }
    return null;
  }

  Future<void> _pickDay(bool end) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: end ? _endDate ?? _date : _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && mounted) {
      _change(() {
        if (end) {
          _endDate = picked;
        } else {
          _date = picked;
          if (_endDate != null && _endDate!.isBefore(picked)) _endDate = picked;
        }
      });
    }
  }

  Future<void> _pickTime(bool end) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: end ? _end : _start,
    );
    if (picked != null && mounted) {
      _change(() {
        if (end) {
          _end = picked;
        } else {
          _start = picked;
        }
      });
    }
  }

  Future<void> _save(String timezone) async {
    if (_busy || !_form.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    Map<String, dynamic> payload;
    try {
      final version = widget.recurring == null
          ? null
          : _id(widget.recurring!['version']);
      if (widget.recurring != null && version == null) {
        throw const FormatException('Refresh this schedule before editing it.');
      }
      payload = operationSchedulePayload(
        title: _title.text,
        remark: _remark.text,
        vehicleId: _vehicle ?? 0,
        routeId: _route ?? 0,
        recurring: _recurring,
        scheduleType: _schedule,
        date: _date,
        endDate: _endDate,
        startTime: operationClock(_start),
        endTime: operationClock(_end),
        weekdays: _weekdays,
        exceptionDates: _exceptionDates,
        version: version,
        earliestDate: widget.recurring == null
            ? operationAccountNow(timezone)
            : null,
      );
    } catch (error) {
      _showError(error);
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final actions = ref.read(userOperationsActionsProvider);
      final result = widget.recurring != null
          ? await actions.updateRecurring('${widget.recurring!['id']}', payload)
          : await actions.create(payload, recurring: _recurring);
      if (!mounted) return;
      final warning = '${result['warning'] ?? ''}'.trim();
      if (warning.isNotEmpty) {
        setState(() => _saving = false);
        await showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => PopScope(
            canPop: false,
            child: AlertDialog(
              title: Text(context.operationText('Schedule saved')),
              content: SingleChildScrollView(
                child: Text(
                  '${context.operationText('The schedule was saved, but some trips could not be generated.')}\n\n$warning',
                ),
              ),
              actions: [
                OpenVtsButton(
                  label: context.operationText('Done'),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
          ),
        );
      } else {
        ToastHelper.showSuccess(
          _recurring
              ? context.operationText('Schedule saved')
              : context.operationText('Trip created'),
          context: context,
        );
      }
      if (mounted) {
        setState(() {
          _allowPop = true;
          _saving = false;
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) Navigator.pop(context, true);
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() => _saving = false);
        _showError(error);
      }
    }
  }

  void _showError(Object error) {
    setState(
      () => _error = error is FormatException
          ? error.message
          : operationError(context, error),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final target = _errorKey.currentContext;
      if (mounted && target != null) {
        Scrollable.ensureVisible(
          target,
          duration: const Duration(milliseconds: 200),
        );
      }
    });
  }

  Future<void> _requestExit() async {
    if (_confirmingExit) return;
    _confirmingExit = true;
    final discard = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.operationText('Discard trip changes?')),
        content: Text(
          context.operationText(
            'Your unsaved planning changes will be lost. Saved routes will remain available.',
          ),
        ),
        actions: [
          OpenVtsButton(
            label: context.operationText('Keep editing'),
            onPressed: () => Navigator.pop(ctx, false),
            variant: OpenVtsButtonVariant.secondary,
          ),
          OpenVtsButton(
            label: context.operationText('Discard changes'),
            onPressed: () => Navigator.pop(ctx, true),
          ),
        ],
      ),
    );
    _confirmingExit = false;
    if (discard == true && mounted) {
      setState(() => _allowPop = true);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) Navigator.pop(context);
      });
    }
  }

  TimeOfDay? _parseClock(dynamic input) {
    final parts = '$input'.split(':');
    if (parts.length != 2) return null;
    final hour = int.tryParse(parts[0]), minute = int.tryParse(parts[1]);
    return hour == null ||
            minute == null ||
            hour < 0 ||
            hour > 23 ||
            minute < 0 ||
            minute > 59
        ? null
        : TimeOfDay(hour: hour, minute: minute);
  }
}
