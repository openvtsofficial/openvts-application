import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:open_vts/shared/helpers/toast_helper.dart';

import '../../../../../core/theme/open_vts_spacing.dart';
import '../../../../../shared/helpers/mobile_text.dart';
import '../../../../../shared/widgets/open_vts_bottom_sheet.dart';
import '../../../../../shared/widgets/open_vts_button.dart';
import '../../../../../shared/widgets/open_vts_card.dart';
import '../../../../../shared/widgets/open_vts_empty_state.dart';
import '../../../../../shared/widgets/open_vts_loader.dart';
import '../../../models/admin_vehicle_model.dart';
import '../../../widgets/admin_action_gate.dart';
import 'admin_vehicle_sensor_sheet.dart';

class AdminVehicleSensorsTab extends StatefulWidget {
  const AdminVehicleSensorsTab({
    super.key,
    required this.isLoading,
    required this.isCreating,
    required this.isUpdating,
    required this.isDeleting,
    required this.isRunning,
    required this.sensors,
    required this.onLoad,
    required this.onCreate,
    required this.onUpdate,
    required this.onDelete,
    required this.onRun,
  });

  final bool isLoading;
  final bool isCreating;
  final bool isUpdating;
  final bool isDeleting;
  final bool isRunning;
  final List<AdminVehicleSensor> sensors;
  final Future<void> Function({String? search}) onLoad;
  final Future<void> Function(AdminVehicleSensorUpsertRequest request) onCreate;
  final Future<void> Function(
    String sensorId,
    AdminVehicleSensorUpsertRequest request,
  )
  onUpdate;
  final Future<void> Function(String sensorId) onDelete;
  final Future<void> Function(AdminVehicleSensorRunRequest request) onRun;

  @override
  State<AdminVehicleSensorsTab> createState() => _AdminVehicleSensorsTabState();
}

class _AdminVehicleSensorsTabState extends State<AdminVehicleSensorsTab> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OpenVtsCard(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: context.mobileText('Search sensors...'),
                        prefixIcon: const Icon(Icons.search_rounded),
                      ),
                      onSubmitted: (value) =>
                          widget.onLoad(search: value.trim()),
                    ),
                  ),
                  const SizedBox(width: OpenVtsSpacing.xs),
                  AdminActionGate(
                    capability: 'vehicles.update',
                    child: OpenVtsButton(
                      label: context.mobileText('Add Sensor'),
                      variant: OpenVtsButtonVariant.secondary,
                      onPressed: _openCreateSheet,
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
        else if (widget.sensors.isEmpty)
          OpenVtsEmptyState(
            title: context.mobileText('No sensors'),
            message: context.mobileText('Create a sensor for this vehicle.'),
          )
        else
          ...widget.sensors.map(
            (sensor) => Padding(
              padding: const EdgeInsets.only(bottom: OpenVtsSpacing.sm),
              child: OpenVtsCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            sensor.name,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                        Text(
                          sensor.isOk
                              ? context.mobileText('Active')
                              : context.mobileText('Inactive'),
                        ),
                      ],
                    ),
                    const SizedBox(height: OpenVtsSpacing.xxs),
                    Text(
                      context.mobileText("Live Value: {value1} {value2}", {
                        'value1': (_safe(sensor.latestValue)).toString(),
                        'value2': (_safe(sensor.unit ?? '')).toString(),
                      }),
                    ),
                    Text(
                      context.mobileText("Status: {value1}", {
                        'value1': (_safe(sensor.status)).toString(),
                      }),
                    ),
                    Text(
                      context.mobileText("Code: {value1}", {
                        'value1': (_safe(
                          sensor.sourceKey ?? sensor.expression ?? '',
                        )).toString(),
                      }),
                    ),
                    const SizedBox(height: OpenVtsSpacing.sm),
                    Wrap(
                      spacing: OpenVtsSpacing.xs,
                      runSpacing: OpenVtsSpacing.xs,
                      children: [
                        AdminActionGate(
                          capability: 'vehicles.update',
                          child: OutlinedButton(
                            onPressed: () => _openEditSheet(sensor),
                            child: Text(context.mobileText('Edit')),
                          ),
                        ),
                        AdminActionGate(
                          capability: 'vehicles.update',
                          child: OutlinedButton(
                            onPressed: widget.isRunning
                                ? null
                                : () => _runSensor(sensor),
                            child: widget.isRunning
                                ? const SizedBox(
                                    width: 14,
                                    height: 14,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(context.mobileText('Run')),
                          ),
                        ),
                        AdminActionGate(
                          capability: 'vehicles.update',
                          child: OutlinedButton(
                            onPressed: widget.isDeleting
                                ? null
                                : () => _deleteSensor(sensor),
                            child: Text(context.mobileText('Delete')),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _openCreateSheet() {
    return OpenVtsBottomSheet.show<void>(
      context: context,
      title: context.mobileText('Add Sensor'),
      initialChildSize: 0.8,
      minChildSize: 0.5,
      maxChildSize: 0.94,
      child: AdminVehicleSensorSheet(
        isSubmitting: widget.isCreating,
        onSubmit: (request) async {
          await widget.onCreate(request);
          if (!mounted) return;
          await widget.onLoad();
          if (!mounted) return;
          Navigator.of(context).pop();
        },
      ),
    );
  }

  Future<void> _openEditSheet(AdminVehicleSensor sensor) {
    return OpenVtsBottomSheet.show<void>(
      context: context,
      title: context.mobileText('Edit Sensor'),
      initialChildSize: 0.8,
      minChildSize: 0.5,
      maxChildSize: 0.94,
      child: AdminVehicleSensorSheet(
        initial: sensor,
        isSubmitting: widget.isUpdating,
        onSubmit: (request) async {
          await widget.onUpdate(sensor.id, request);
          if (!mounted) return;
          await widget.onLoad();
          if (!mounted) return;
          Navigator.of(context).pop();
        },
      ),
    );
  }

  Future<void> _runSensor(AdminVehicleSensor sensor) async {
    final code = sensor.sourceKey?.trim().isNotEmpty == true
        ? sensor.sourceKey!.trim()
        : sensor.expression?.trim() ?? '';
    if (code.isEmpty) {
      _toast('Sensor code is required to run.');
      return;
    }

    await OpenVtsBottomSheet.show<void>(
      context: context,
      title: context.mobileText('Run Sensor'),
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      child: _RunSensorSheet(
        defaultCode: code,
        isRunning: widget.isRunning,
        onRun: (request) async {
          await widget.onRun(request);
          if (!mounted) return;
          Navigator.of(context).pop();
        },
      ),
    );
  }

  Future<void> _deleteSensor(AdminVehicleSensor sensor) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.mobileText('Delete sensor')),
        content: Text(
          context.mobileText("Delete {value1}?", {
            'value1': (sensor.name).toString(),
          }),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(context.mobileText('Cancel')),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(context.mobileText('Delete')),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await widget.onDelete(sensor.id);
    await widget.onLoad();
  }

  void _toast(String message) {
    ToastHelper.show(context, message);
  }

  String _safe(String value) => value.trim().isEmpty ? '-' : value.trim();
}

class _RunSensorSheet extends StatefulWidget {
  const _RunSensorSheet({
    required this.defaultCode,
    required this.isRunning,
    required this.onRun,
  });

  final String defaultCode;
  final bool isRunning;
  final Future<void> Function(AdminVehicleSensorRunRequest request) onRun;

  @override
  State<_RunSensorSheet> createState() => _RunSensorSheetState();
}

class _RunSensorSheetState extends State<_RunSensorSheet> {
  late final TextEditingController _codeController;
  final TextEditingController _payloadController = TextEditingController(
    text: '{}',
  );

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController(text: widget.defaultCode);
  }

  @override
  void dispose() {
    _codeController.dispose();
    _payloadController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(OpenVtsSpacing.md),
      children: [
        TextField(
          controller: _codeController,
          decoration: InputDecoration(labelText: context.mobileText('Code')),
        ),
        const SizedBox(height: OpenVtsSpacing.sm),
        TextField(
          controller: _payloadController,
          maxLines: 6,
          decoration: InputDecoration(
            labelText: context.mobileText('Payload JSON'),
          ),
        ),
        const SizedBox(height: OpenVtsSpacing.sm),
        OpenVtsButton(
          label: context.mobileText('Run Sensor'),
          isLoading: widget.isRunning,
          onPressed: widget.isRunning ? null : _submit,
        ),
      ],
    );
  }

  Future<void> _submit() async {
    final code = _codeController.text.trim();
    if (code.isEmpty) {
      ToastHelper.showError(
        context.mobileText('Code is required.'),
        context: context,
      );
      return;
    }

    Map<String, dynamic> payload = const <String, dynamic>{};
    final raw = _payloadController.text.trim();
    if (raw.isNotEmpty) {
      try {
        final decoded = jsonDecode(raw);
        if (decoded is! Map<String, dynamic>) {
          throw const FormatException('Payload must be a JSON object.');
        }
        payload = decoded;
      } catch (_) {
        ToastHelper.showError(
          context.mobileText('Payload must be valid JSON object.'),
          context: context,
        );
        return;
      }
    }

    await widget.onRun(
      AdminVehicleSensorRunRequest(code: code, payload: payload),
    );
  }
}
