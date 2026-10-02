import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/api/api_exception.dart';
import '../../../../core/platform/platform_time_zone.dart';
import '../../../../shared/widgets/open_vts_date_time_range_selector.dart';
import '../../../../shared/widgets/open_vts_page_scaffold.dart';
import '../../../auth/controllers/auth_controller.dart';
import '../../controllers/user_providers.dart';
import '../../models/user_landmark_model.dart';
import '../../models/user_report_model.dart';
import '../../models/user_vehicle_model.dart';

class UserReportsScreen extends ConsumerStatefulWidget {
  const UserReportsScreen({super.key});

  @override
  ConsumerState<UserReportsScreen> createState() => _UserReportsScreenState();
}

class _UserReportsScreenState extends ConsumerState<UserReportsScreen> {
  final _speedLimitController = TextEditingController(text: '120');
  final _logSearchController = TextEditingController();

  UserReportOptions? _options;
  UserReportKey _reportKey = UserReportKey.distance;
  String _scopeMode = 'all';
  String? _singleVehicleId;
  String? _groupId;
  Set<String> _multipleVehicleIds = <String>{};
  DateTime _rangeStart = _startOfToday();
  DateTime _rangeEndExclusive = _startOfToday().add(const Duration(days: 1));
  String _acknowledged = 'all';
  Set<String> _alertTypes = <String>{};
  Set<String> _alertSeverities = <String>{};
  Set<String> _logCategories = <String>{};
  Set<String> _logLevels = <String>{};
  Set<String> _logDirections = <String>{};
  Set<String> _timelineStates = <String>{'running', 'stopped'};
  List<UserGeofence> _geofences = const <UserGeofence>[];
  Set<String> _geofenceIds = <String>{};
  List<UserVehicleSensor> _sensors = const <UserVehicleSensor>[];
  String? _sensorId;

  List<Map<String, dynamic>> _rows = const <Map<String, dynamic>>[];
  _ReportRequest? _lastRequest;
  String? _nextCursor;
  String? _warning;
  String? _source;
  String? _errorMessage;
  bool _hasMore = false;
  bool _isLoadingOptions = true;
  bool _isGenerating = false;
  bool _isLoadingMore = false;
  bool _isLoadingSensors = false;
  bool _isLoadingGeofences = false;
  String? _loadingMapKey;
  int _rowsPerPage = 10;

  static DateTime _startOfToday() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  @override
  void initState() {
    super.initState();
    if (ref.read(authControllerProvider).isDemo) {
      _isLoadingOptions = false;
    } else {
      unawaited(_loadOptions());
    }
  }

  @override
  void dispose() {
    _speedLimitController.dispose();
    _logSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDemo = ref.watch(
      authControllerProvider.select((state) => state.isDemo),
    );
    if (isDemo) {
      return OpenVtsPageScaffold(
        title: 'Reports',
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.lock_outline_rounded,
                      size: 48,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Reports are restricted in demo mode',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Advanced reporting features are not available in the '
                      'public demo. Sign in with an OpenVTS account to run, '
                      'page, visualise, and export fleet reports.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    return OpenVtsPageScaffold(
      title: 'Reports',
      actions: [
        IconButton(
          tooltip: 'Refresh report options',
          onPressed: _isLoadingOptions ? null : _loadOptions,
          icon: const Icon(Icons.refresh_rounded),
        ),
      ],
      body: _isLoadingOptions
          ? const Center(child: CircularProgressIndicator())
          : _options == null
              ? _buildOptionsError()
              : ListView(
                  children: [
                    _buildQueryCard(),
                    const SizedBox(height: 12),
                    if (_errorMessage != null) _buildErrorCard(_errorMessage!),
                    if (_warning != null) _buildWarningCard(_warning!),
                    if (_rows.isNotEmpty) ...[
                      _MetricBars(
                        reportKey: _reportKey,
                        rows: _rows,
                      ),
                      const SizedBox(height: 12),
                      _buildResultsTable(),
                    ] else if (!_isGenerating && _lastRequest != null)
                      const Card(
                        child: Padding(
                          padding: EdgeInsets.all(24),
                          child: Center(
                            child: Text(
                              'No rows matched the selected report filters.',
                            ),
                          ),
                        ),
                      ),
                    if (_isGenerating)
                      const Padding(
                        padding: EdgeInsets.all(32),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                  ],
                ),
    );
  }

  Widget _buildOptionsError() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.cloud_off_rounded, size: 44),
          const SizedBox(height: 12),
          Text(_errorMessage ?? 'Report options could not be loaded.'),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: _loadOptions,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildQueryCard() {
    final options = _options!;
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Generate report',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Text(
              'Queries are bounded to ${_reportKey.maxDays} days for this '
              'report type. Dates use your device timezone.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SizedBox(
                  width: 220,
                  child: DropdownButtonFormField<UserReportKey>(
                    initialValue: _reportKey,
                    decoration: const InputDecoration(
                      labelText: 'Report type',
                    ),
                    items: [
                      for (final key in UserReportKey.values)
                        DropdownMenuItem(
                          value: key,
                          child: Text(key.label),
                        ),
                    ],
                    onChanged: _isGenerating
                        ? null
                        : (value) {
                            if (value != null) _changeReport(value);
                          },
                  ),
                ),
                if (!_reportKey.requiresSingleVehicle)
                  SizedBox(
                    width: 180,
                    child: DropdownButtonFormField<String>(
                      initialValue: _scopeMode,
                      decoration: const InputDecoration(
                        labelText: 'Vehicle scope',
                      ),
                      items: const [
                        DropdownMenuItem(value: 'all', child: Text('All')),
                        DropdownMenuItem(
                          value: 'single',
                          child: Text('One vehicle'),
                        ),
                        DropdownMenuItem(
                          value: 'multiple',
                          child: Text('Selected vehicles'),
                        ),
                        DropdownMenuItem(
                          value: 'group',
                          child: Text('Vehicle group'),
                        ),
                      ],
                      onChanged: _isGenerating
                          ? null
                          : (value) => setState(() {
                                _scopeMode = value ?? 'all';
                                _clearResult();
                              }),
                    ),
                  ),
                if (_scopeMode == 'single' || _reportKey.requiresSingleVehicle)
                  OutlinedButton.icon(
                    onPressed: _isGenerating
                        ? null
                        : () => _pickVehicles(multiple: false),
                    icon: const Icon(Icons.directions_car_outlined),
                    label: Text(_singleVehicleLabel(options)),
                  ),
                if (_scopeMode == 'multiple' &&
                    !_reportKey.requiresSingleVehicle)
                  OutlinedButton.icon(
                    onPressed: _isGenerating
                        ? null
                        : () => _pickVehicles(multiple: true),
                    icon: const Icon(Icons.checklist_rounded),
                    label: Text(
                      _multipleVehicleIds.isEmpty
                          ? 'Select vehicles'
                          : '${_multipleVehicleIds.length} vehicles selected',
                    ),
                  ),
                if (_scopeMode == 'group' && !_reportKey.requiresSingleVehicle)
                  SizedBox(
                    width: 240,
                    child: DropdownButtonFormField<String>(
                      initialValue: _groupId,
                      decoration: const InputDecoration(
                        labelText: 'Vehicle group',
                      ),
                      items: [
                        for (final group in options.groups)
                          DropdownMenuItem(
                            value: group.id,
                            child: Text(
                              '${group.name} (${group.vehicleCount})',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                      onChanged: _isGenerating
                          ? null
                          : (value) => setState(() {
                                _groupId = value;
                                _clearResult();
                              }),
                    ),
                  ),
                OutlinedButton.icon(
                  onPressed: _isGenerating ? null : _pickDateRange,
                  icon: const Icon(Icons.date_range_rounded),
                  label: Text(_rangeLabel()),
                ),
              ],
            ),
            if (_reportKey == UserReportKey.overspeed ||
                _reportKey == UserReportKey.geofence ||
                _reportKey == UserReportKey.sensor ||
                _reportKey == UserReportKey.alerts ||
                _reportKey == UserReportKey.logs ||
                _reportKey == UserReportKey.timeline) ...[
              const SizedBox(height: 16),
              Divider(color: colorScheme.outlineVariant),
              const SizedBox(height: 8),
              _buildReportFilters(),
            ],
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                onPressed: _isGenerating ? null : _generate,
                icon: const Icon(Icons.analytics_outlined),
                label: const Text('Generate'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportFilters() {
    switch (_reportKey) {
      case UserReportKey.overspeed:
        return SizedBox(
          width: 260,
          child: TextField(
            controller: _speedLimitController,
            enabled: !_isGenerating,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Speed limit (km/h)',
              helperText: 'Allowed range: 10–300',
            ),
          ),
        );
      case UserReportKey.sensor:
        return SizedBox(
          width: 320,
          child: DropdownButtonFormField<String>(
            initialValue: _sensorId,
            decoration: InputDecoration(
              labelText: 'Sensor',
              helperText: _singleVehicleId == null
                  ? 'Select a vehicle first'
                  : _isLoadingSensors
                      ? 'Loading sensors…'
                      : null,
            ),
            items: [
              for (final sensor in _sensors.where((item) => item.isActive))
                DropdownMenuItem(
                  value: sensor.id,
                  child: Text(sensor.title, overflow: TextOverflow.ellipsis),
                ),
            ],
            onChanged: _isGenerating || _isLoadingSensors
                ? null
                : (value) => setState(() => _sensorId = value),
          ),
        );
      case UserReportKey.geofence:
        return OutlinedButton.icon(
          onPressed:
              _isGenerating || _isLoadingGeofences ? null : _pickGeofences,
          icon: _isLoadingGeofences
              ? const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.radar_rounded),
          label: Text(
            _geofenceIds.isEmpty
                ? 'All geofences'
                : '${_geofenceIds.length} geofences selected',
          ),
        );
      case UserReportKey.alerts:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _FilterChips(
              title: 'Alert type',
              values: const {
                'overspeed': 'Overspeed',
                'geofence_entry': 'Geofence entry',
                'geofence_exit': 'Geofence exit',
                'ignition_on': 'Ignition on',
                'ignition_off': 'Ignition off',
                'sensor': 'Sensor',
                'sos': 'SOS',
                'alarm': 'Alarm',
                'running': 'Running',
                'stopped': 'Stopped',
                'idle': 'Idle',
                'route_deviation': 'Route deviation',
                'reminder': 'Reminder',
                'command': 'Command',
              },
              selected: _alertTypes,
              enabled: !_isGenerating,
              onChanged: (next) => setState(() => _alertTypes = next),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _FilterChips(
                  title: 'Severity',
                  values: const {
                    'critical': 'Critical',
                    'high': 'High',
                    'low': 'Low',
                  },
                  selected: _alertSeverities,
                  enabled: !_isGenerating,
                  onChanged: (next) => setState(() => _alertSeverities = next),
                ),
                SizedBox(
                  width: 240,
                  child: DropdownButtonFormField<String>(
                    initialValue: _acknowledged,
                    decoration:
                        const InputDecoration(labelText: 'Acknowledged'),
                    items: const [
                      DropdownMenuItem(value: 'all', child: Text('All alerts')),
                      DropdownMenuItem(
                        value: 'yes',
                        child: Text('Acknowledged'),
                      ),
                      DropdownMenuItem(
                        value: 'no',
                        child: Text('Not acknowledged'),
                      ),
                    ],
                    onChanged: _isGenerating
                        ? null
                        : (value) => setState(
                              () => _acknowledged = value ?? 'all',
                            ),
                  ),
                ),
              ],
            ),
          ],
        );
      case UserReportKey.logs:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _FilterChips(
              title: 'Category',
              values: const {
                'telemetry': 'Telemetry',
                'device_event': 'Device event',
                'command': 'Command',
                'connection': 'Connection',
                'system': 'System',
              },
              selected: _logCategories,
              enabled: !_isGenerating,
              onChanged: (next) => setState(() => _logCategories = next),
            ),
            const SizedBox(height: 8),
            _FilterChips(
              title: 'Level',
              values: const {
                'info': 'Info',
                'warning': 'Warning',
                'error': 'Error',
                'debug': 'Debug',
              },
              selected: _logLevels,
              enabled: !_isGenerating,
              onChanged: (next) => setState(() => _logLevels = next),
            ),
            const SizedBox(height: 8),
            _FilterChips(
              title: 'Direction',
              values: const {
                'device_to_server': 'Device → server',
                'server_to_device': 'Server → device',
                'internal': 'Internal',
              },
              selected: _logDirections,
              enabled: !_isGenerating,
              onChanged: (next) => setState(() => _logDirections = next),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: 360,
              child: TextField(
                controller: _logSearchController,
                enabled: !_isGenerating,
                decoration: const InputDecoration(
                  labelText: 'Search device logs',
                  helperText: 'Optional; enter at least 3 characters',
                  prefixIcon: Icon(Icons.search_rounded),
                ),
              ),
            ),
          ],
        );
      case UserReportKey.timeline:
        return Wrap(
          spacing: 8,
          children: [
            for (final stateName in const ['running', 'stopped'])
              FilterChip(
                label: Text(
                  stateName == 'running' ? 'Running' : 'Stopped',
                ),
                selected: _timelineStates.contains(stateName),
                onSelected: _isGenerating
                    ? null
                    : (selected) => setState(() {
                          if (selected) {
                            _timelineStates.add(stateName);
                          } else {
                            _timelineStates.remove(stateName);
                          }
                        }),
              ),
          ],
        );
      case UserReportKey.distance:
      case UserReportKey.driven:
      case UserReportKey.details:
        return const SizedBox.shrink();
    }
  }

  Widget _buildResultsTable() {
    final columns = _visibleColumns();
    final source = _ReportTableSource(
      rows: _rows,
      columns: columns,
      reportKey: _reportKey,
      loadingMapKey: _loadingMapKey,
      onTimelineMap: _openTimelineMap,
    );
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: math.max(
                  MediaQuery.sizeOf(context).width - 48,
                  720.0,
                ),
              ),
              child: PaginatedDataTable(
                header: Text(
                  '${_reportKey.label} · ${_rows.length} loaded row'
                  '${_rows.length == 1 ? '' : 's'}',
                ),
                columns: [
                  for (final column in columns)
                    DataColumn(label: Text(_columnLabel(column))),
                  if (_reportKey == UserReportKey.timeline)
                    const DataColumn(label: Text('Route')),
                ],
                source: source,
                rowsPerPage: _rowsPerPage,
                availableRowsPerPage: const [10, 25, 50],
                onRowsPerPageChanged: (value) {
                  if (value != null) setState(() => _rowsPerPage = value);
                },
                showFirstLastButtons: true,
              ),
            ),
          ),
          if (_source?.trim().isNotEmpty == true)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Text(
                'Source: $_source',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          if (_hasMore)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
              child: OutlinedButton.icon(
                onPressed: _isLoadingMore ? null : _loadMore,
                icon: _isLoadingMore
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.expand_more_rounded),
                label: const Text('Load more from server'),
              ),
            ),
        ],
      ),
    );
  }

  List<String> _visibleColumns() {
    final available = <String>{
      for (final row in _rows) ...row.keys,
    };
    final preferred = _reportKey.preferredColumns
        .where(available.contains)
        .toList(growable: false);
    if (preferred.isNotEmpty) {
      return preferred;
    }
    return available.take(8).toList(growable: false);
  }

  Future<void> _loadOptions() async {
    if (_isLoadingOptions && _options != null) return;
    setState(() {
      _isLoadingOptions = true;
      _errorMessage = null;
    });
    try {
      final options = await ref.read(userReportControllerProvider).getOptions();
      if (!mounted) return;
      setState(() {
        final validVehicleIds =
            options.vehicles.map((vehicle) => vehicle.id).toSet();
        final validGroupIds = options.groups.map((group) => group.id).toSet();
        _options = options;
        if (!validVehicleIds.contains(_singleVehicleId)) {
          _singleVehicleId = null;
          _sensorId = null;
          _sensors = const <UserVehicleSensor>[];
        }
        _multipleVehicleIds = _multipleVehicleIds.intersection(validVehicleIds);
        if (!validGroupIds.contains(_groupId)) {
          _groupId = null;
        }
        _isLoadingOptions = false;
        _clearResult();
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _options = null;
        _isLoadingOptions = false;
        _errorMessage = _messageFor(error);
      });
    }
  }

  void _changeReport(UserReportKey key) {
    setState(() {
      _reportKey = key;
      _scopeMode = key.requiresSingleVehicle ? 'single' : 'all';
      _sensorId = null;
      _sensors = const <UserVehicleSensor>[];
      _timelineStates = <String>{'running', 'stopped'};
      _acknowledged = 'all';
      _alertTypes = <String>{};
      _alertSeverities = <String>{};
      _logCategories = <String>{};
      _logLevels = <String>{};
      _logDirections = <String>{};
      _geofenceIds = <String>{};
      _logSearchController.clear();
      _speedLimitController.text = '120';
      _resetDateRangeFor(key);
      _clearResult();
    });
    if (key == UserReportKey.sensor && _singleVehicleId != null) {
      unawaited(_loadSensors(_singleVehicleId!));
    }
    if (key == UserReportKey.geofence && _geofences.isEmpty) {
      unawaited(_loadGeofences());
    }
  }

  Future<void> _pickDateRange() async {
    final dateTimeEnabled = !_reportKey.usesDateOnly;
    final selected = await OpenVtsDateTimeRangeSelector.show(
      context: context,
      initialValue: OpenVtsDateTimeRange(
        start: _rangeStart,
        end: dateTimeEnabled
            ? _rangeEndExclusive
            : _rangeEndExclusive.subtract(const Duration(days: 1)),
      ),
      dateTimeEnabled: dateTimeEnabled,
      firstDate: DateTime.now().subtract(const Duration(days: 3650)),
      lastDate: DateTime.now(),
      title: 'Select ${_reportKey.label.toLowerCase()} report range',
    );
    final normalized = selected?.normalized(dateTimeEnabled: dateTimeEnabled);
    final start = normalized?.start;
    final end = normalized?.end;
    if (start == null || end == null || !mounted) return;
    final selectedDuration = dateTimeEnabled
        ? end.difference(start)
        : Duration(days: end.difference(start).inDays + 1);
    if (selectedDuration > Duration(days: _reportKey.maxDays)) {
      setState(() {
        _errorMessage =
            'This report supports a maximum of ${_reportKey.maxDays} days.';
      });
      return;
    }
    setState(() {
      _rangeStart = start;
      _rangeEndExclusive =
          dateTimeEnabled ? end : end.add(const Duration(days: 1));
      _clearResult();
    });
  }

  void _resetDateRangeFor(UserReportKey key) {
    final today = _startOfToday();
    if (key.usesDateOnly) {
      _rangeStart = today;
      _rangeEndExclusive = today.add(const Duration(days: 1));
      return;
    }
    final now = DateTime.now();
    _rangeStart = today;
    _rangeEndExclusive =
        now.isAfter(today) ? now : today.add(const Duration(minutes: 1));
  }

  Future<void> _pickVehicles({required bool multiple}) async {
    final options = _options?.vehicles ?? const <UserReportVehicleOption>[];
    final initial = multiple
        ? _multipleVehicleIds
        : <String>{if (_singleVehicleId != null) _singleVehicleId!};
    final selected = await _showVehiclePicker(
      options,
      initial: initial,
      multiple: multiple,
    );
    if (selected == null || !mounted) return;
    if (multiple) {
      setState(() {
        _multipleVehicleIds = selected;
        _clearResult();
      });
      return;
    }

    final vehicleId = selected.isEmpty ? null : selected.first;
    setState(() {
      _singleVehicleId = vehicleId;
      _sensorId = null;
      _sensors = const <UserVehicleSensor>[];
      _clearResult();
    });
    if (_reportKey == UserReportKey.sensor && vehicleId != null) {
      await _loadSensors(vehicleId);
    }
  }

  Future<Set<String>?> _showVehiclePicker(
    List<UserReportVehicleOption> vehicles, {
    required Set<String> initial,
    required bool multiple,
  }) async {
    final searchController = TextEditingController();
    var selected = <String>{...initial};
    var query = '';
    final result = await showDialog<Set<String>>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) {
          final normalized = query.trim().toLowerCase();
          final filtered = normalized.isEmpty
              ? vehicles
              : vehicles
                  .where(
                    (vehicle) =>
                        vehicle.displayName
                            .toLowerCase()
                            .contains(normalized) ||
                        vehicle.imei.toLowerCase().contains(normalized),
                  )
                  .toList(growable: false);
          return AlertDialog(
            title: Text(multiple ? 'Select vehicles' : 'Select vehicle'),
            content: SizedBox(
              width: 560,
              height: math.min(MediaQuery.sizeOf(context).height * 0.7, 620.0),
              child: Column(
                children: [
                  TextField(
                    controller: searchController,
                    autofocus: true,
                    decoration: const InputDecoration(
                      labelText: 'Search name, plate or IMEI',
                      prefixIcon: Icon(Icons.search_rounded),
                    ),
                    onChanged: (value) => setDialogState(() => query = value),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: filtered.isEmpty
                        ? const Center(child: Text('No vehicles found.'))
                        : ListView.builder(
                            itemCount: filtered.length,
                            itemBuilder: (context, index) {
                              final vehicle = filtered[index];
                              final checked = selected.contains(vehicle.id);
                              return CheckboxListTile(
                                value: checked,
                                title: Text(vehicle.displayName),
                                subtitle: Text(vehicle.imei),
                                onChanged: (_) {
                                  if (!multiple) {
                                    Navigator.of(dialogContext)
                                        .pop(<String>{vehicle.id});
                                    return;
                                  }
                                  setDialogState(() {
                                    if (checked) {
                                      selected.remove(vehicle.id);
                                    } else {
                                      selected.add(vehicle.id);
                                    }
                                  });
                                },
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('Cancel'),
              ),
              if (multiple)
                FilledButton(
                  onPressed: () => Navigator.of(dialogContext).pop(selected),
                  child: Text('Use ${selected.length} selected'),
                ),
            ],
          );
        },
      ),
    );
    searchController.dispose();
    return result;
  }

  Future<void> _loadSensors(String vehicleId) async {
    setState(() {
      _isLoadingSensors = true;
      _errorMessage = null;
    });
    try {
      final page =
          await ref.read(userReportControllerProvider).getSensors(vehicleId);
      if (!mounted || _singleVehicleId != vehicleId) return;
      setState(() {
        _sensors = page.items;
        _sensorId = page.items.where((item) => item.isActive).firstOrNull?.id;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _errorMessage = _messageFor(error));
    } finally {
      if (mounted) setState(() => _isLoadingSensors = false);
    }
  }

  Future<void> _loadGeofences() async {
    setState(() {
      _isLoadingGeofences = true;
      _errorMessage = null;
    });
    try {
      final geofences =
          await ref.read(userReportControllerProvider).getActiveGeofences();
      if (!mounted) return;
      setState(() => _geofences = geofences);
    } catch (error) {
      if (mounted) setState(() => _errorMessage = _messageFor(error));
    } finally {
      if (mounted) setState(() => _isLoadingGeofences = false);
    }
  }

  Future<void> _pickGeofences() async {
    if (_geofences.isEmpty) {
      await _loadGeofences();
      if (!mounted || _geofences.isEmpty) return;
    }
    var selected = <String>{..._geofenceIds};
    final result = await showDialog<Set<String>>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Filter geofences'),
          content: SizedBox(
            width: 500,
            height: math.min(
              MediaQuery.sizeOf(context).height * 0.65,
              560.0,
            ),
            child: ListView.builder(
              itemCount: _geofences.length,
              itemBuilder: (context, index) {
                final geofence = _geofences[index];
                final checked = selected.contains(geofence.id);
                return CheckboxListTile(
                  value: checked,
                  title: Text(
                    geofence.name.trim().isEmpty
                        ? 'Geofence ${geofence.id}'
                        : geofence.name,
                  ),
                  subtitle: Text(geofence.type.label),
                  onChanged: (_) => setDialogState(() {
                    if (checked) {
                      selected.remove(geofence.id);
                    } else {
                      selected.add(geofence.id);
                    }
                  }),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(<String>{}),
              child: const Text('Use all'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(selected),
              child: Text('Use ${selected.length} selected'),
            ),
          ],
        ),
      ),
    );
    if (result != null && mounted) {
      setState(() {
        _geofenceIds = result;
        _clearResult();
      });
    }
  }

  Future<void> _generate() async {
    final request = await _buildRequest();
    if (request == null || !mounted) return;
    await _requestPage(request, append: false);
  }

  Future<void> _loadMore() async {
    final request = _lastRequest;
    if (request == null || _nextCursor == null || _isLoadingMore) return;
    await _requestPage(request, append: true);
  }

  Future<_ReportRequest?> _buildRequest() async {
    final options = _options;
    if (options == null || options.vehicles.isEmpty) {
      _setError('No reportable vehicles are available for this account.');
      return null;
    }
    if (!_rangeEndExclusive.isAfter(_rangeStart)) {
      _setError('Report end must be after report start.');
      return null;
    }

    Map<String, dynamic> scope;
    final effectiveScope =
        _reportKey.requiresSingleVehicle ? 'single' : _scopeMode;
    switch (effectiveScope) {
      case 'single':
        if (_singleVehicleId == null) {
          _setError('Select one vehicle.');
          return null;
        }
        scope = <String, dynamic>{
          'mode': 'single',
          'vehicleId': _singleVehicleId,
        };
        break;
      case 'multiple':
        if (_multipleVehicleIds.isEmpty) {
          _setError('Select at least one vehicle.');
          return null;
        }
        scope = <String, dynamic>{
          'mode': 'multiple',
          'vehicleIds': _multipleVehicleIds.toList(growable: false),
        };
        break;
      case 'group':
        if (_groupId == null) {
          _setError('Select a vehicle group.');
          return null;
        }
        scope = <String, dynamic>{'mode': 'group', 'groupId': _groupId};
        break;
      default:
        scope = const <String, dynamic>{'mode': 'all'};
    }

    final filters = <String, dynamic>{};
    switch (_reportKey) {
      case UserReportKey.overspeed:
        final limit = num.tryParse(_speedLimitController.text.trim());
        if (limit == null || limit < 10 || limit > 300) {
          _setError('Speed limit must be between 10 and 300 km/h.');
          return null;
        }
        filters['speedLimitKmh'] = limit;
        break;
      case UserReportKey.sensor:
        if (_sensorId == null) {
          _setError('Select one sensor.');
          return null;
        }
        filters['sensorIds'] = <String>[_sensorId!];
        break;
      case UserReportKey.alerts:
        filters.addAll(<String, dynamic>{
          'alertTypes': _alertTypes.toList(growable: false),
          'severities': _alertSeverities.toList(growable: false),
          'acknowledged': _acknowledged,
        });
        break;
      case UserReportKey.logs:
        final search = _logSearchController.text.trim();
        if (search.isNotEmpty && search.length < 3) {
          _setError('Log search must contain at least 3 characters.');
          return null;
        }
        filters.addAll(<String, dynamic>{
          'categories': _logCategories.toList(growable: false),
          'levels': _logLevels.toList(growable: false),
          'directions': _logDirections.toList(growable: false),
          'search': search,
        });
        break;
      case UserReportKey.timeline:
        if (_timelineStates.isEmpty) {
          _setError('Select running, stopped, or both timeline states.');
          return null;
        }
        filters['states'] = _timelineStates.toList(growable: false);
        break;
      case UserReportKey.geofence:
        filters['geofenceIds'] = _geofenceIds.toList(growable: false);
        break;
      case UserReportKey.distance:
      case UserReportKey.driven:
      case UserReportKey.details:
        break;
    }

    final endDate = _reportKey.usesDateOnly
        ? _rangeEndExclusive.subtract(const Duration(days: 1))
        : _rangeEndExclusive;
    final dateRange = _reportKey.usesDateOnly
        ? <String, dynamic>{
            'mode': 'dateOnly',
            'startDate': DateFormat('yyyy-MM-dd').format(_rangeStart),
            'endDate': DateFormat('yyyy-MM-dd').format(endDate),
          }
        : <String, dynamic>{
            'mode': 'dateTime',
            'fromISO': _rangeStart.toUtc().toIso8601String(),
            'toISO': _rangeEndExclusive.toUtc().toIso8601String(),
          };

    final timeZone = await PlatformTimeZone.current();
    return _ReportRequest(
      reportKey: _reportKey,
      vehicleScope: scope,
      dateRange: dateRange,
      filters: filters,
      timeZone: timeZone,
      from: _rangeStart,
      to: _rangeEndExclusive,
    );
  }

  Future<void> _requestPage(
    _ReportRequest request, {
    required bool append,
  }) async {
    setState(() {
      if (append) {
        _isLoadingMore = true;
      } else {
        _isGenerating = true;
        _rows = const <Map<String, dynamic>>[];
        _nextCursor = null;
        _hasMore = false;
      }
      _errorMessage = null;
      _warning = null;
    });
    try {
      final page = await ref.read(userReportControllerProvider).generate(
            reportKey: request.reportKey,
            vehicleScope: request.vehicleScope,
            dateRange: request.dateRange,
            filters: request.filters,
            timeZone: request.timeZone,
            from: request.from,
            to: request.to,
            cursor: append ? _nextCursor : null,
          );
      if (!mounted) return;
      setState(() {
        _lastRequest = request;
        _rows = append
            ? List<Map<String, dynamic>>.unmodifiable([
                ..._rows,
                ...page.rows,
              ])
            : page.rows;
        _nextCursor = page.nextCursor;
        _hasMore = page.hasMore && page.nextCursor != null;
        _warning = page.warning;
        _source = page.source;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _errorMessage = _messageFor(error));
    } finally {
      if (mounted) {
        setState(() {
          _isGenerating = false;
          _isLoadingMore = false;
        });
      }
    }
  }

  Future<void> _openTimelineMap(Map<String, dynamic> row) async {
    final vehicleId = reportText(row['vehicleId']);
    final from = DateTime.tryParse(reportText(row['startedAt']));
    final to = DateTime.tryParse(reportText(row['endedAt']));
    if (vehicleId.isEmpty || from == null || to == null) {
      _setError('This timeline row does not contain a valid map segment.');
      return;
    }

    final mapKey = '$vehicleId:${reportText(row['startedAt'])}';
    setState(() {
      _loadingMapKey = mapKey;
      _errorMessage = null;
    });
    try {
      final points =
          await ref.read(userReportControllerProvider).getTimelineMap(
                vehicleId: vehicleId,
                from: from,
                to: to,
              );
      if (!mounted) return;
      if (points.isEmpty) {
        _setError('No valid route points were recorded for this segment.');
        return;
      }
      await showDialog<void>(
        context: context,
        builder: (_) => _TimelineMapDialog(
          title: reportText(row['vehicleName'], fallback: 'Timeline route'),
          points: points,
        ),
      );
    } catch (error) {
      if (mounted) _setError(_messageFor(error));
    } finally {
      if (mounted) setState(() => _loadingMapKey = null);
    }
  }

  void _setError(String message) {
    if (!mounted) return;
    setState(() => _errorMessage = message);
  }

  void _clearResult() {
    _lastRequest = null;
    _rows = const <Map<String, dynamic>>[];
    _nextCursor = null;
    _hasMore = false;
    _warning = null;
    _source = null;
    _errorMessage = null;
  }

  String _singleVehicleLabel(UserReportOptions options) {
    final id = _singleVehicleId;
    if (id == null) return 'Select vehicle';
    for (final vehicle in options.vehicles) {
      if (vehicle.id == id) return vehicle.displayName;
    }
    return 'Select vehicle';
  }

  String _rangeLabel() {
    final end = _reportKey.usesDateOnly
        ? _rangeEndExclusive.subtract(const Duration(days: 1))
        : _rangeEndExclusive;
    final format = _reportKey.usesDateOnly
        ? DateFormat.yMMMd()
        : DateFormat.yMMMd().add_jm();
    return _rangeStart == end
        ? format.format(_rangeStart)
        : '${format.format(_rangeStart)} – ${format.format(end)}';
  }

  Widget _buildErrorCard(String message) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      color: colors.errorContainer,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(Icons.error_outline_rounded, color: colors.onErrorContainer),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: colors.onErrorContainer),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWarningCard(String message) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      color: colors.tertiaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: colors.onTertiaryContainer,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: colors.onTertiaryContainer),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _messageFor(Object error) {
    if (error is ApiException) return error.message;
    return error
        .toString()
        .replaceFirst(RegExp(r'^Exception:\s*'), '')
        .replaceFirst(RegExp(r'^ApiException\(\d+\):\s*'), '');
  }
}

class _ReportRequest {
  const _ReportRequest({
    required this.reportKey,
    required this.vehicleScope,
    required this.dateRange,
    required this.filters,
    required this.timeZone,
    required this.from,
    required this.to,
  });

  final UserReportKey reportKey;
  final Map<String, dynamic> vehicleScope;
  final Map<String, dynamic> dateRange;
  final Map<String, dynamic> filters;
  final String timeZone;
  final DateTime from;
  final DateTime to;
}

class _ReportTableSource extends DataTableSource {
  _ReportTableSource({
    required this.rows,
    required this.columns,
    required this.reportKey,
    required this.loadingMapKey,
    required this.onTimelineMap,
  });

  final List<Map<String, dynamic>> rows;
  final List<String> columns;
  final UserReportKey reportKey;
  final String? loadingMapKey;
  final Future<void> Function(Map<String, dynamic> row) onTimelineMap;

  @override
  DataRow? getRow(int index) {
    if (index < 0 || index >= rows.length) return null;
    final row = rows[index];
    final mapKey =
        '${reportText(row['vehicleId'])}:${reportText(row['startedAt'])}';
    return DataRow.byIndex(
      index: index,
      cells: [
        for (final column in columns)
          DataCell(
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 260),
              child: Text(
                _formatReportValue(column, row[column]),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          ),
        if (reportKey == UserReportKey.timeline)
          DataCell(
            IconButton(
              tooltip: 'Show route trail',
              onPressed:
                  loadingMapKey == null ? () => onTimelineMap(row) : null,
              icon: loadingMapKey == mapKey
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.route_rounded),
            ),
          ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => rows.length;

  @override
  int get selectedRowCount => 0;
}

class _MetricBars extends StatelessWidget {
  const _MetricBars({
    required this.reportKey,
    required this.rows,
  });

  final UserReportKey reportKey;
  final List<Map<String, dynamic>> rows;

  @override
  Widget build(BuildContext context) {
    final metric = reportKey.chartMetric;
    final category = reportKey.chartCategory;
    final List<_MetricEntry> entries;
    final String chartTitle;
    if (metric != null) {
      entries = rows
          .map(
            (row) => _MetricEntry(
              reportText(
                row['vehicleName'] ?? row['sensorLabel'] ?? row['date'],
                fallback: 'Row',
              ),
              row[metric] is num
                  ? (row[metric] as num).toDouble()
                  : double.tryParse(row[metric]?.toString() ?? '') ?? 0,
            ),
          )
          .where((entry) => entry.value.isFinite && entry.value >= 0)
          .take(10)
          .toList(growable: false);
      chartTitle = '${_columnLabel(metric)} overview';
    } else if (category != null) {
      final counts = <String, int>{};
      for (final row in rows) {
        final label = reportText(row[category], fallback: 'Other');
        counts[label] = (counts[label] ?? 0) + 1;
      }
      final ranked = counts.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      entries = ranked
          .take(10)
          .map((entry) => _MetricEntry(entry.key, entry.value.toDouble()))
          .toList(growable: false);
      chartTitle = '${_columnLabel(category)} distribution';
    } else {
      return const SizedBox.shrink();
    }
    if (entries.isEmpty) return const SizedBox.shrink();
    final maximum = entries.fold<double>(
      0,
      (current, entry) => math.max(current, entry.value),
    );
    if (maximum <= 0) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              chartTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            for (final entry in entries) ...[
              Row(
                children: [
                  SizedBox(
                    width: 120,
                    child: Text(
                      entry.label,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: entry.value / maximum,
                      minHeight: 10,
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 72,
                    child: Text(
                      _formatReportValue(metric ?? category!, entry.value),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ],
        ),
      ),
    );
  }
}

class _MetricEntry {
  const _MetricEntry(this.label, this.value);

  final String label;
  final double value;
}

class _FilterChips extends StatelessWidget {
  const _FilterChips({
    required this.title,
    required this.values,
    required this.selected,
    required this.enabled,
    required this.onChanged,
  });

  final String title;
  final Map<String, String> values;
  final Set<String> selected;
  final bool enabled;
  final ValueChanged<Set<String>> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 6,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text('$title:'),
        for (final entry in values.entries)
          FilterChip(
            label: Text(entry.value),
            selected: selected.contains(entry.key),
            onSelected: enabled
                ? (isSelected) {
                    final next = <String>{...selected};
                    if (isSelected) {
                      next.add(entry.key);
                    } else {
                      next.remove(entry.key);
                    }
                    onChanged(next);
                  }
                : null,
          ),
      ],
    );
  }
}

class _TimelineMapDialog extends StatefulWidget {
  const _TimelineMapDialog({
    required this.title,
    required this.points,
  });

  final String title;
  final List<UserTimelinePoint> points;

  @override
  State<_TimelineMapDialog> createState() => _TimelineMapDialogState();
}

class _TimelineMapDialogState extends State<_TimelineMapDialog> {
  final _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    final points = widget.points
        .map((point) => LatLng(point.latitude, point.longitude))
        .toList(growable: false);
    final size = MediaQuery.sizeOf(context);
    return Dialog(
      child: SizedBox(
        width: math.min(size.width - 32, 820.0),
        height: math.min(size.height - 64, 620.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Close',
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: points.first,
                  initialZoom: 13,
                  onMapReady: () {
                    if (points.length < 2) return;
                    _mapController.fitCamera(
                      CameraFit.bounds(
                        bounds: LatLngBounds.fromPoints(points),
                        padding: const EdgeInsets.all(44),
                        maxZoom: 17,
                      ),
                    );
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.openvts.app',
                  ),
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: points,
                        strokeWidth: 5,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ],
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: points.first,
                        width: 42,
                        height: 42,
                        child: const Icon(
                          Icons.trip_origin_rounded,
                          color: Colors.green,
                          size: 34,
                        ),
                      ),
                      Marker(
                        point: points.last,
                        width: 42,
                        height: 42,
                        child: const Icon(
                          Icons.location_on_rounded,
                          color: Colors.red,
                          size: 38,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _columnLabel(String key) {
  const known = <String, String>{
    'vehicleName': 'Vehicle',
    'date': 'Date',
    'distanceKm': 'Distance (km)',
    'durationSeconds': 'Duration',
    'engineHoursSeconds': 'Engine hours',
    'maxSpeedKmh': 'Max speed (km/h)',
    'avgSpeedKmh': 'Avg speed (km/h)',
    'startedAt': 'Started',
    'endedAt': 'Ended',
    'timestamp': 'Time',
    'startAddress': 'Start address',
    'endAddress': 'End address',
    'geofenceName': 'Geofence',
    'sensorLabel': 'Sensor',
    'alertType': 'Alert',
    'acknowledged': 'Acknowledged',
  };
  if (known.containsKey(key)) return known[key]!;
  return key
      .replaceAllMapped(
        RegExp(r'([a-z0-9])([A-Z])'),
        (match) => '${match.group(1)} ${match.group(2)}',
      )
      .replaceAll('_', ' ')
      .split(' ')
      .where((part) => part.isNotEmpty)
      .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
      .join(' ');
}

String _formatReportValue(String key, dynamic value) {
  if (value == null) return '—';
  if (key == 'durationSeconds' || key == 'engineHoursSeconds') {
    final seconds =
        value is num ? value.toInt() : int.tryParse(value.toString()) ?? 0;
    final duration = Duration(seconds: math.max(0, seconds));
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final remainingSeconds = duration.inSeconds.remainder(60);
    return hours > 0
        ? '${hours}h ${minutes}m'
        : minutes > 0
            ? '${minutes}m ${remainingSeconds}s'
            : '${remainingSeconds}s';
  }
  if (value is bool) return value ? 'Yes' : 'No';
  if (value is num) {
    if (key.endsWith('Km') ||
        key.endsWith('Kmh') ||
        key == 'value' ||
        key == 'distanceKm') {
      return NumberFormat('0.##').format(value);
    }
    return NumberFormat.decimalPattern().format(value);
  }
  if (value is Map || value is List) {
    return jsonEncode(value);
  }
  final text = value.toString();
  if (key == 'date') return text;
  if (key.endsWith('At') || key == 'timestamp') {
    final date = DateTime.tryParse(text);
    if (date != null) {
      return DateFormat.yMd().add_jm().format(date.toLocal());
    }
  }
  return text.trim().isEmpty ? '—' : text;
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull {
    final iterator = this.iterator;
    return iterator.moveNext() ? iterator.current : null;
  }
}
