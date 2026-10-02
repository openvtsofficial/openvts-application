import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../../core/theme/open_vts_colors.dart';
import '../../../../../../core/theme/open_vts_radius.dart';
import '../../../../../../core/theme/open_vts_spacing.dart';
import '../../../../../../core/theme/open_vts_typography.dart';
import '../../../../models/user_landmark_model.dart';
import '../../../../models/user_report_model.dart';
import '../../../../models/user_report_state.dart';
import '../../../../models/user_vehicle_model.dart';
import '../../../../../../features/user/utils/user_report_format.dart';

// ---------------------------------------------------------------------------
// Overspeed filter
// ---------------------------------------------------------------------------

class UserOverspeedReportFilter extends StatefulWidget {
  const UserOverspeedReportFilter(
      {required this.filters,
      required this.onChanged,
      this.disabled = false,
      super.key});
  final OverspeedFilters filters;
  final ValueChanged<OverspeedFilters> onChanged;
  final bool disabled;

  @override
  State<UserOverspeedReportFilter> createState() =>
      _UserOverspeedReportFilterState();
}

class _UserOverspeedReportFilterState extends State<UserOverspeedReportFilter> {
  bool _useCustom = false;
  final _customCtrl = TextEditingController();
  String? _customError;

  @override
  void initState() {
    super.initState();
    final preset = kSpeedLimitPresets.contains(widget.filters.speedLimitKmh);
    _useCustom = !preset;
    if (_useCustom) _customCtrl.text = widget.filters.speedLimitKmh.toString();
  }

  @override
  void dispose() {
    _customCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Speed Limit',
            style: OpenVtsTypography.meta.copyWith(
                fontWeight: FontWeight.w600,
                color: OpenVtsColors.textSecondary)),
        const SizedBox(height: 6),
        Wrap(
          spacing: OpenVtsSpacing.xs,
          runSpacing: OpenVtsSpacing.xs,
          children: [
            ...kSpeedLimitPresets.map((preset) {
              final isSelected =
                  !_useCustom && widget.filters.speedLimitKmh == preset;
              return _FilterChip(
                label: '$preset km/h',
                selected: isSelected,
                onTap: widget.disabled
                    ? null
                    : () {
                        setState(() {
                          _useCustom = false;
                          _customError = null;
                        });
                        widget
                            .onChanged(OverspeedFilters(speedLimitKmh: preset));
                      },
              );
            }),
            _FilterChip(
              label: 'Custom…',
              selected: _useCustom,
              onTap: widget.disabled
                  ? null
                  : () => setState(() {
                        _useCustom = true;
                      }),
            ),
          ],
        ),
        if (_useCustom) ...[
          const SizedBox(height: OpenVtsSpacing.sm),
          SizedBox(
            width: 160,
            child: TextField(
              controller: _customCtrl,
              keyboardType: TextInputType.number,
              enabled: !widget.disabled,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                hintText: '10–300',
                suffixText: 'km/h',
                isDense: true,
                errorText: _customError,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(OpenVtsRadius.md)),
              ),
              onChanged: (v) {
                final parsed = validateSpeedLimit(v);
                setState(() => _customError = parsed == null
                    ? 'Enter a value between $kSpeedLimitMin and $kSpeedLimitMax'
                    : null);
                if (parsed != null)
                  widget.onChanged(OverspeedFilters(speedLimitKmh: parsed));
              },
            ),
          ),
        ],
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Geofence filter
// ---------------------------------------------------------------------------

class UserGeofenceReportFilter extends StatefulWidget {
  const UserGeofenceReportFilter(
      {required this.filters,
      required this.geofences,
      required this.onChanged,
      this.isLoading = false,
      this.disabled = false,
      super.key});
  final GeofenceFilters filters;
  final List<UserGeofence> geofences;
  final ValueChanged<GeofenceFilters> onChanged;
  final bool isLoading;
  final bool disabled;

  @override
  State<UserGeofenceReportFilter> createState() =>
      _UserGeofenceReportFilterState();
}

class _UserGeofenceReportFilterState extends State<UserGeofenceReportFilter> {
  String _query = '';

  List<UserGeofence> get _filtered {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return widget.geofences;
    return widget.geofences
        .where((g) => g.name.toLowerCase().contains(q))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
                child: Text('Geofences',
                    style: OpenVtsTypography.meta.copyWith(
                        fontWeight: FontWeight.w600,
                        color: OpenVtsColors.textSecondary))),
            if (widget.filters.geofenceIds.isNotEmpty)
              TextButton(
                  onPressed: () => widget.onChanged(const GeofenceFilters()),
                  child: Text('Clear (${widget.filters.geofenceIds.length})',
                      style: OpenVtsTypography.meta)),
          ],
        ),
        const SizedBox(height: 4),
        if (widget.isLoading)
          const Padding(
              padding: EdgeInsets.all(8),
              child: CircularProgressIndicator(strokeWidth: 2))
        else if (widget.geofences.isEmpty)
          Text('No active geofences — all geofences included.',
              style: OpenVtsTypography.meta
                  .copyWith(color: OpenVtsColors.textSecondary))
        else ...[
          SizedBox(
            height: 36,
            child: TextField(
              onChanged: (q) => setState(() => _query = q),
              decoration: InputDecoration(
                hintText: 'Search geofences…',
                prefixIcon: const Icon(Icons.search_rounded, size: 14),
                isDense: true,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(OpenVtsRadius.md)),
              ),
            ),
          ),
          const SizedBox(height: OpenVtsSpacing.xs),
          Wrap(
            spacing: OpenVtsSpacing.xs,
            runSpacing: OpenVtsSpacing.xs,
            children: filtered.map((g) {
              final isSelected = widget.filters.geofenceIds.contains(g.id);
              return _FilterChip(
                label: g.name,
                selected: isSelected,
                onTap: widget.disabled
                    ? null
                    : () {
                        final ids =
                            List<String>.from(widget.filters.geofenceIds);
                        if (isSelected)
                          ids.remove(g.id);
                        else
                          ids.add(g.id);
                        widget.onChanged(GeofenceFilters(geofenceIds: ids));
                      },
              );
            }).toList(),
          ),
          if (widget.filters.geofenceIds.isEmpty)
            Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text('No selection = all geofences.',
                    style: OpenVtsTypography.meta
                        .copyWith(color: OpenVtsColors.textSecondary))),
        ],
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Sensor filter
// ---------------------------------------------------------------------------

class UserSensorReportFilter extends StatelessWidget {
  const UserSensorReportFilter({
    required this.vehicleId,
    required this.sensors,
    required this.filters,
    required this.vehicles,
    required this.onVehicleChanged,
    required this.onFiltersChanged,
    this.isLoadingSensors = false,
    this.sensorLoadError,
    this.onRetrySensorLoad,
    this.vehicleError,
    this.sensorError,
    this.disabled = false,
    super.key,
  });

  final String? vehicleId;
  final List<UserVehicleSensor> sensors;
  final SensorFilters filters;
  final List<UserReportVehicleOption> vehicles;
  final ValueChanged<String?> onVehicleChanged;
  final ValueChanged<SensorFilters> onFiltersChanged;
  final bool isLoadingSensors;
  final String? sensorLoadError;
  final VoidCallback? onRetrySensorLoad;
  final String? vehicleError;
  final String? sensorError;
  final bool disabled;

  UserReportVehicleOption? get _selectedVehicle => vehicleId == null
      ? null
      : vehicles.firstWhereOrNull((v) => v.id == vehicleId);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedSensorId = filters.sensorIds.firstOrNull;
    final selectedSensor = selectedSensorId == null
        ? null
        : sensors.firstWhereOrNull((s) => s.id.toString() == selectedSensorId);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Vehicle',
            style: OpenVtsTypography.meta.copyWith(
                fontWeight: FontWeight.w600,
                color: OpenVtsColors.textSecondary)),
        const SizedBox(height: 4),
        _SensorVehiclePicker(
            selected: _selectedVehicle,
            vehicles: vehicles,
            onChanged: onVehicleChanged,
            disabled: disabled,
            error: vehicleError),
        const SizedBox(height: OpenVtsSpacing.sm),
        Text('Sensor',
            style: OpenVtsTypography.meta.copyWith(
                fontWeight: FontWeight.w600,
                color: OpenVtsColors.textSecondary)),
        const SizedBox(height: 4),
        if (vehicleId == null || vehicleId!.isEmpty)
          Text('Select a vehicle first',
              style: OpenVtsTypography.meta
                  .copyWith(color: OpenVtsColors.textSecondary))
        else if (isLoadingSensors)
          const SizedBox(
              height: 32,
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)))
        else if (sensorLoadError != null)
          Row(
            children: [
              Expanded(
                child: Text(sensorLoadError!,
                    style: OpenVtsTypography.meta
                        .copyWith(color: OpenVtsColors.error)),
              ),
              TextButton(
                onPressed: disabled ? null : onRetrySensorLoad,
                child: const Text('Retry'),
              ),
            ],
          )
        else if (sensors.isEmpty)
          Text('No sensors configured for this vehicle',
              style: OpenVtsTypography.meta
                  .copyWith(color: OpenVtsColors.textSecondary))
        else
          _SensorSelect(
              sensors: sensors,
              selected: selectedSensor,
              onChanged: (s) => onFiltersChanged(
                  SensorFilters(sensorIds: s != null ? [s.id.toString()] : [])),
              disabled: disabled,
              isDark: isDark),
        if (sensorError != null) ...[
          const SizedBox(height: 3),
          Text(sensorError!,
              style:
                  OpenVtsTypography.meta.copyWith(color: OpenVtsColors.error)),
        ],
      ],
    );
  }
}

class _SensorVehiclePicker extends StatelessWidget {
  const _SensorVehiclePicker(
      {required this.selected,
      required this.vehicles,
      required this.onChanged,
      required this.disabled,
      this.error});
  final UserReportVehicleOption? selected;
  final List<UserReportVehicleOption> vehicles;
  final ValueChanged<String?> onChanged;
  final bool disabled;
  final String? error;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: disabled ? null : () => _pick(context),
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: OpenVtsSpacing.sm, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? OpenVtsColors.darkSurface : OpenVtsColors.white,
              borderRadius: BorderRadius.circular(OpenVtsRadius.md),
              border: Border.all(
                  color: error != null
                      ? OpenVtsColors.error
                      : (isDark
                          ? OpenVtsColors.darkBorder
                          : OpenVtsColors.border)),
            ),
            child: Row(children: [
              const Icon(Icons.directions_car_outlined, size: 16),
              const SizedBox(width: 6),
              Expanded(
                  child: Text(selected?.displayName ?? 'Select a vehicle',
                      style: OpenVtsTypography.body.copyWith(
                          color: selected == null
                              ? (isDark
                                  ? OpenVtsColors.darkTextSecondary
                                  : OpenVtsColors.textSecondary)
                              : null))),
              const Icon(Icons.unfold_more_rounded, size: 18),
            ]),
          ),
        ),
        if (error != null)
          Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Text(error!,
                  style: OpenVtsTypography.meta
                      .copyWith(color: OpenVtsColors.error))),
      ],
    );
  }

  Future<void> _pick(BuildContext context) async {
    final id = await _VehicleSearchSheet.show(context,
        vehicles: vehicles, selectedId: selected?.id);
    if (id != null) onChanged(id);
  }
}

class _VehicleSearchSheet extends StatefulWidget {
  const _VehicleSearchSheet({required this.vehicles, required this.selectedId});
  final List<UserReportVehicleOption> vehicles;
  final String? selectedId;

  static Future<String?> show(BuildContext context,
      {required List<UserReportVehicleOption> vehicles, String? selectedId}) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(OpenVtsRadius.xl))),
      builder: (_) =>
          _VehicleSearchSheet(vehicles: vehicles, selectedId: selectedId),
    );
  }

  @override
  State<_VehicleSearchSheet> createState() => _VehicleSearchSheetState();
}

class _VehicleSearchSheetState extends State<_VehicleSearchSheet> {
  String _q = '';
  final _ctrl = TextEditingController();
  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  List<UserReportVehicleOption> get _filtered {
    final q = _q.trim().toLowerCase();
    if (q.isEmpty) return widget.vehicles;
    return widget.vehicles
        .where((v) =>
            v.name.toLowerCase().contains(q) ||
            (v.plateNumber?.toLowerCase().contains(q) ?? false) ||
            v.imei.toLowerCase().contains(q))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.65,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      builder: (_, ctrl) => Column(
        children: [
          const SizedBox(height: OpenVtsSpacing.sm),
          Center(
              child: Container(
                  height: 4,
                  width: 40,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(2)))),
          Padding(
            padding: const EdgeInsets.all(OpenVtsSpacing.md),
            child: Row(children: [
              const Expanded(
                  child: Text('Select Vehicle',
                      style: OpenVtsTypography.titleSmall)),
              IconButton(
                  icon: const Icon(Icons.close_rounded, size: 20),
                  onPressed: () => Navigator.of(context).maybePop()),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: OpenVtsSpacing.md),
            child: SizedBox(
                height: 40,
                child: TextField(
                    controller: _ctrl,
                    onChanged: (q) => setState(() => _q = q),
                    decoration: InputDecoration(
                        hintText: 'Search by name or plate…',
                        prefixIcon: const Icon(Icons.search_rounded, size: 14),
                        isDense: true,
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(OpenVtsRadius.md))))),
          ),
          const SizedBox(height: OpenVtsSpacing.xs),
          Divider(
              height: 1, color: Theme.of(context).colorScheme.outlineVariant),
          Expanded(
            child: filtered.isEmpty
                ? const Center(
                    child: Text('No vehicles found',
                        style: OpenVtsTypography.body))
                : ListView.builder(
                    controller: ctrl,
                    itemCount: filtered.length,
                    itemBuilder: (_, i) {
                      final v = filtered[i];
                      final sel = widget.selectedId == v.id;
                      return ListTile(
                        leading: Icon(
                            sel
                                ? Icons.check_circle_rounded
                                : Icons.radio_button_off_rounded,
                            size: 20,
                            color: sel
                                ? (isDark
                                    ? OpenVtsColors.darkTextPrimary
                                    : OpenVtsColors.brandInk)
                                : Theme.of(context).colorScheme.outline),
                        title: Text(v.displayName,
                            style: OpenVtsTypography.body.copyWith(
                                fontWeight:
                                    sel ? FontWeight.w700 : FontWeight.w400)),
                        onTap: () => Navigator.of(context).pop(v.id),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _SensorSelect extends StatelessWidget {
  const _SensorSelect(
      {required this.sensors,
      required this.selected,
      required this.onChanged,
      required this.disabled,
      required this.isDark});
  final List<UserVehicleSensor> sensors;
  final UserVehicleSensor? selected;
  final ValueChanged<UserVehicleSensor?> onChanged;
  final bool disabled;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: disabled ? null : () => _pick(context),
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: OpenVtsSpacing.sm, vertical: 10),
        decoration: BoxDecoration(
          color: isDark ? OpenVtsColors.darkSurface : OpenVtsColors.white,
          borderRadius: BorderRadius.circular(OpenVtsRadius.md),
          border: Border.all(
              color: isDark ? OpenVtsColors.darkBorder : OpenVtsColors.border),
        ),
        child: Row(children: [
          const Icon(Icons.sensors_rounded, size: 16),
          const SizedBox(width: 6),
          Expanded(
              child: Text(
                  selected != null
                      ? '${selected!.name}${selected!.unit?.isNotEmpty == true ? ' (${selected!.unit})' : ''}'
                      : 'Select a sensor',
                  style: OpenVtsTypography.body.copyWith(
                      color: selected == null
                          ? (isDark
                              ? OpenVtsColors.darkTextSecondary
                              : OpenVtsColors.textSecondary)
                          : null))),
          const Icon(Icons.unfold_more_rounded, size: 18),
        ]),
      ),
    );
  }

  Future<void> _pick(BuildContext context) async {
    final result = await showModalBottomSheet<UserVehicleSensor>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(OpenVtsRadius.xl))),
      builder: (_) => _SensorPickerSheet(
          sensors: sensors, selectedId: selected?.id.toString()),
    );
    if (result != null) onChanged(result);
  }
}

class _SensorPickerSheet extends StatelessWidget {
  const _SensorPickerSheet({required this.sensors, required this.selectedId});
  final List<UserVehicleSensor> sensors;
  final String? selectedId;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: OpenVtsSpacing.sm),
          Center(
              child: Container(
                  height: 4,
                  width: 40,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(2)))),
          Padding(
            padding: const EdgeInsets.all(OpenVtsSpacing.md),
            child: Row(children: [
              const Expanded(
                  child: Text('Select Sensor',
                      style: OpenVtsTypography.titleSmall)),
              IconButton(
                  icon: const Icon(Icons.close_rounded, size: 20),
                  onPressed: () => Navigator.of(context).maybePop()),
            ]),
          ),
          Divider(
              height: 1, color: Theme.of(context).colorScheme.outlineVariant),
          ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.sizeOf(context).height * 0.5),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: sensors.length,
              itemBuilder: (_, i) {
                final s = sensors[i];
                final sel = s.id.toString() == selectedId;
                return ListTile(
                  leading: Icon(
                      sel
                          ? Icons.check_circle_rounded
                          : Icons.radio_button_off_rounded,
                      size: 20,
                      color: sel
                          ? (isDark
                              ? OpenVtsColors.darkTextPrimary
                              : OpenVtsColors.brandInk)
                          : Theme.of(context).colorScheme.outline),
                  title: Text(s.name,
                      style: OpenVtsTypography.body.copyWith(
                          fontWeight: sel ? FontWeight.w700 : FontWeight.w400)),
                  subtitle: s.unit?.isNotEmpty == true
                      ? Text(s.unit!,
                          style: OpenVtsTypography.meta
                              .copyWith(color: OpenVtsColors.textSecondary))
                      : null,
                  onTap: () => Navigator.of(context).pop(s),
                );
              },
            ),
          ),
          const SizedBox(height: OpenVtsSpacing.md),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Alerts filter
// ---------------------------------------------------------------------------

// Backend and web use snake_case alert type keys.
const _kAlertTypes = [
  'overspeed',
  'geofence_exit',
  'geofence_entry',
  'ignition_on',
  'ignition_off',
  'sensor',
  'sos',
  'alarm',
  'running',
  'stopped',
  'idle',
  'route_deviation',
  'reminder',
  'command',
];
const _kAlertTypeLabels = {
  'overspeed': 'Overspeed',
  'geofence_exit': 'Geofence Exit',
  'geofence_entry': 'Geofence Entry',
  'ignition_on': 'Ignition On',
  'ignition_off': 'Ignition Off',
  'sensor': 'Sensor',
  'sos': 'SOS',
  'alarm': 'Alarm',
  'running': 'Continuous Running',
  'stopped': 'Continuous Stop',
  'idle': 'Continuous Idle',
  'route_deviation': 'Route Deviation',
  'reminder': 'Reminder',
  'command': 'Command',
};
// Web/backend severities: critical, high, low (no medium).
const _kSeverities = ['critical', 'high', 'low'];
const _kSeverityLabels = {
  'critical': 'Critical',
  'high': 'High',
  'low': 'Low',
};

class UserAlertsReportFilter extends StatelessWidget {
  const UserAlertsReportFilter(
      {required this.filters,
      required this.onChanged,
      this.disabled = false,
      super.key});
  final AlertsFilters filters;
  final ValueChanged<AlertsFilters> onChanged;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FilterSection(
          label: 'Alert Type',
          chips:
              _kAlertTypes.map((t) => (t, _kAlertTypeLabels[t] ?? t)).toList(),
          selected: filters.alertTypes,
          onChanged: (types) => onChanged(AlertsFilters(
              alertTypes: types,
              severities: filters.severities,
              acknowledged: filters.acknowledged)),
          disabled: disabled,
          emptyMeansAll: true,
        ),
        const SizedBox(height: OpenVtsSpacing.sm),
        _FilterSection(
          label: 'Severity',
          chips:
              _kSeverities.map((s) => (s, _kSeverityLabels[s] ?? s)).toList(),
          selected: filters.severities,
          onChanged: (sevs) => onChanged(AlertsFilters(
              alertTypes: filters.alertTypes,
              severities: sevs,
              acknowledged: filters.acknowledged)),
          disabled: disabled,
          emptyMeansAll: true,
        ),
        const SizedBox(height: OpenVtsSpacing.sm),
        Text('Acknowledgement',
            style: OpenVtsTypography.meta.copyWith(
                fontWeight: FontWeight.w600,
                color: OpenVtsColors.textSecondary)),
        const SizedBox(height: 4),
        Wrap(
          spacing: OpenVtsSpacing.xs,
          runSpacing: OpenVtsSpacing.xs,
          children: [
            for (final (v, label) in [
              ('all', 'All'),
              ('yes', 'Acknowledged'),
              ('no', 'Unacknowledged')
            ])
              _FilterChip(
                label: label,
                selected: filters.acknowledged == v,
                onTap: disabled
                    ? null
                    : () => onChanged(AlertsFilters(
                        alertTypes: filters.alertTypes,
                        severities: filters.severities,
                        acknowledged: v)),
              ),
          ],
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Logs filter
// ---------------------------------------------------------------------------

const _kLogCategories = [
  'telemetry',
  'device_event',
  'command',
  'connection',
  'system'
];
const _kLogCategoryLabels = {
  'telemetry': 'Telemetry',
  'device_event': 'Device Event',
  'command': 'Command',
  'connection': 'Connection',
  'system': 'System'
};
const _kLogLevels = ['info', 'warning', 'error', 'debug'];
const _kLogLevelLabels = {
  'info': 'Info',
  'warning': 'Warning',
  'error': 'Error',
  'debug': 'Debug'
};
const _kLogDirections = [
  'device_to_server',
  'server_to_device',
  'internal',
];
const _kLogDirectionLabels = {
  'device_to_server': 'Device → Server',
  'server_to_device': 'Server → Device',
  'internal': 'Internal',
};

class UserLogsReportFilter extends StatefulWidget {
  const UserLogsReportFilter({
    required this.vehicleId,
    required this.vehicles,
    required this.filters,
    required this.onVehicleChanged,
    required this.onFiltersChanged,
    this.vehicleError,
    this.disabled = false,
    super.key,
  });

  final String? vehicleId;
  final List<UserReportVehicleOption> vehicles;
  final LogsFilters filters;
  final ValueChanged<String?> onVehicleChanged;
  final ValueChanged<LogsFilters> onFiltersChanged;
  final String? vehicleError;
  final bool disabled;

  @override
  State<UserLogsReportFilter> createState() => _UserLogsReportFilterState();
}

class _UserLogsReportFilterState extends State<UserLogsReportFilter> {
  late final TextEditingController _searchCtrl;
  String? _searchError;

  @override
  void initState() {
    super.initState();
    _searchCtrl = TextEditingController(text: widget.filters.search);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  UserReportVehicleOption? get _selected => widget.vehicleId == null
      ? null
      : widget.vehicles.firstWhereOrNull((v) => v.id == widget.vehicleId);

  void _updateFilters({
    List<String>? categories,
    List<String>? levels,
    List<String>? directions,
    String? search,
  }) {
    widget.onFiltersChanged(LogsFilters(
      categories: categories ?? widget.filters.categories,
      levels: levels ?? widget.filters.levels,
      directions: directions ?? widget.filters.directions,
      search: search ?? widget.filters.search,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Vehicle',
            style: OpenVtsTypography.meta.copyWith(
                fontWeight: FontWeight.w600,
                color: OpenVtsColors.textSecondary)),
        const SizedBox(height: 4),
        _SensorVehiclePicker(
            selected: _selected,
            vehicles: widget.vehicles,
            onChanged: widget.onVehicleChanged,
            disabled: widget.disabled,
            error: widget.vehicleError),
        const SizedBox(height: OpenVtsSpacing.sm),
        _FilterSection(
          label: 'Category',
          chips: _kLogCategories
              .map((c) => (c, _kLogCategoryLabels[c] ?? c))
              .toList(),
          selected: widget.filters.categories,
          onChanged: (cats) => _updateFilters(categories: cats),
          disabled: widget.disabled,
          emptyMeansAll: true,
        ),
        const SizedBox(height: OpenVtsSpacing.sm),
        _FilterSection(
          label: 'Level',
          chips: _kLogLevels.map((l) => (l, _kLogLevelLabels[l] ?? l)).toList(),
          selected: widget.filters.levels,
          onChanged: (lvls) => _updateFilters(levels: lvls),
          disabled: widget.disabled,
          emptyMeansAll: true,
        ),
        const SizedBox(height: OpenVtsSpacing.sm),
        _FilterSection(
          label: 'Direction',
          chips: _kLogDirections
              .map((d) => (d, _kLogDirectionLabels[d] ?? d))
              .toList(),
          selected: widget.filters.directions,
          onChanged: (dirs) => _updateFilters(directions: dirs),
          disabled: widget.disabled,
          emptyMeansAll: true,
        ),
        const SizedBox(height: OpenVtsSpacing.sm),
        Text('Search',
            style: OpenVtsTypography.meta.copyWith(
                fontWeight: FontWeight.w600,
                color: OpenVtsColors.textSecondary)),
        const SizedBox(height: 4),
        TextField(
          controller: _searchCtrl,
          enabled: !widget.disabled,
          decoration: InputDecoration(
            hintText: 'Min 3 characters…',
            isDense: true,
            errorText: _searchError,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(OpenVtsRadius.md)),
            suffixIcon: _searchCtrl.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close_rounded, size: 16),
                    onPressed: () {
                      _searchCtrl.clear();
                      setState(() => _searchError = null);
                      _updateFilters(search: '');
                    })
                : null,
          ),
          onChanged: (v) {
            final trimmed = v.trim();
            setState(() {
              _searchError = trimmed.isNotEmpty && trimmed.length < 3
                  ? 'Enter at least 3 characters'
                  : null;
            });
            _updateFilters(search: v);
          },
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Timeline filter
// ---------------------------------------------------------------------------

class UserTimelineReportFilter extends StatelessWidget {
  const UserTimelineReportFilter(
      {required this.filters,
      required this.onChanged,
      this.disabled = false,
      this.error,
      super.key});
  final TimelineFilters filters;
  final ValueChanged<TimelineFilters> onChanged;
  final bool disabled;
  final String? error;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('State Filter',
            style: OpenVtsTypography.meta.copyWith(
                fontWeight: FontWeight.w600,
                color: OpenVtsColors.textSecondary)),
        const SizedBox(height: 4),
        Wrap(
          spacing: OpenVtsSpacing.xs,
          runSpacing: OpenVtsSpacing.xs,
          children: [
            _FilterChip(
              label: 'Running',
              selected: filters.states.contains('running'),
              icon: Icons.play_arrow_rounded,
              onTap: disabled ? null : () => _toggle('running'),
            ),
            _FilterChip(
              label: 'Stopped',
              selected: filters.states.contains('stopped'),
              icon: Icons.stop_rounded,
              onTap: disabled ? null : () => _toggle('stopped'),
            ),
          ],
        ),
        if (error != null) ...[
          const SizedBox(height: 4),
          Text(error!,
              style:
                  OpenVtsTypography.meta.copyWith(color: OpenVtsColors.error)),
        ],
        if (filters.states.isEmpty)
          Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text('Select at least one state',
                  style: OpenVtsTypography.meta
                      .copyWith(color: OpenVtsColors.error))),
      ],
    );
  }

  void _toggle(String state) {
    final states = List<String>.from(filters.states);
    if (states.contains(state))
      states.remove(state);
    else
      states.add(state);
    onChanged(TimelineFilters(states: states));
  }
}

// ---------------------------------------------------------------------------
// Shared filter components
// ---------------------------------------------------------------------------

class _FilterSection extends StatelessWidget {
  const _FilterSection(
      {required this.label,
      required this.chips,
      required this.selected,
      required this.onChanged,
      this.disabled = false,
      this.emptyMeansAll = false});
  final String label;
  final List<(String, String)> chips;
  final List<String> selected;
  final ValueChanged<List<String>> onChanged;
  final bool disabled;
  final bool emptyMeansAll;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Expanded(
              child: Text(label,
                  style: OpenVtsTypography.meta.copyWith(
                      fontWeight: FontWeight.w600,
                      color: OpenVtsColors.textSecondary))),
          if (selected.isNotEmpty)
            GestureDetector(
                onTap: () => onChanged([]),
                child: Text('Clear',
                    style: OpenVtsTypography.meta
                        .copyWith(color: OpenVtsColors.textSecondary))),
        ]),
        const SizedBox(height: 4),
        Wrap(
          spacing: OpenVtsSpacing.xs,
          runSpacing: OpenVtsSpacing.xs,
          children: chips.map((c) {
            final isSelected = selected.contains(c.$1);
            return _FilterChip(
              label: c.$2,
              selected: isSelected,
              onTap: disabled
                  ? null
                  : () {
                      final list = List<String>.from(selected);
                      if (isSelected)
                        list.remove(c.$1);
                      else
                        list.add(c.$1);
                      onChanged(list);
                    },
            );
          }).toList(),
        ),
        if (emptyMeansAll && selected.isEmpty)
          Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text('No selection = all',
                  style: OpenVtsTypography.meta
                      .copyWith(color: OpenVtsColors.textSecondary))),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip(
      {required this.label, required this.selected, this.onTap, this.icon});
  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fg = selected
        ? (isDark ? OpenVtsColors.brandInk : OpenVtsColors.white)
        : (isDark
            ? OpenVtsColors.darkTextSecondary
            : OpenVtsColors.textSecondary);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: selected
              ? (isDark
                  ? OpenVtsColors.darkTextPrimary
                  : OpenVtsColors.brandInk)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(OpenVtsRadius.pill),
          border: Border.all(
              color: selected
                  ? (isDark
                      ? OpenVtsColors.darkTextPrimary
                      : OpenVtsColors.brandInk)
                  : (isDark ? OpenVtsColors.darkBorder : OpenVtsColors.border)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 12, color: fg),
              const SizedBox(width: 4)
            ],
            Text(label,
                style: OpenVtsTypography.meta.copyWith(
                    color: fg,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}

extension _ListExtensions<T> on List<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    for (final item in this) {
      if (test(item)) return item;
    }
    return null;
  }

  T? get firstOrNull => isEmpty ? null : first;
}
