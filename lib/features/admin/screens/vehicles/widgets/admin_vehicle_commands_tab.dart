import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
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

class AdminVehicleCommandsTab extends StatefulWidget {
  const AdminVehicleCommandsTab({
    super.key,
    required this.vehicle,
    required this.customCommands,
    required this.systemVariables,
    required this.history,
    required this.isLoading,
    required this.isSending,
    required this.onRefresh,
    required this.onSend,
    required this.onPollStatus,
    required this.onFetchCommandLog,
  });

  final AdminVehicleDetails vehicle;
  final List<AdminCustomCommand> customCommands;
  final List<AdminSystemVariable> systemVariables;
  final List<AdminVehicleCommandItem> history;
  final bool isLoading;
  final bool isSending;
  final Future<void> Function() onRefresh;
  final Future<void> Function({required String command, String? note}) onSend;
  final Future<AdminCommandStatus?> Function(String cmdId) onPollStatus;
  final Future<AdminVehicleCommandItem?> Function(String cmdId)
      onFetchCommandLog;

  @override
  State<AdminVehicleCommandsTab> createState() =>
      _AdminVehicleCommandsTabState();
}

class _AdminVehicleCommandsTabState extends State<AdminVehicleCommandsTab> {
  final TextEditingController _commandController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  String? _selectedTemplateId;
  int _dropdownEpoch = 0;
  String _latestStatus = '-';
  bool _polling = false;

  static const Set<String> _terminalStatuses = {
    'RESPONDED',
    'ENCODE_FAILED',
    'FAILED',
    'TIMEOUT',
    'ERROR',
  };

  @override
  void didUpdateWidget(AdminVehicleCommandsTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_selectedTemplateId != null) {
      final stillExists =
          widget.customCommands.any((cmd) => cmd.id == _selectedTemplateId);
      if (!stillExists) {
        setState(() {
          _selectedTemplateId = null;
          _dropdownEpoch++;
        });
      }
    }
  }

  @override
  void dispose() {
    _commandController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final imei = widget.vehicle.imei.trim();
    if (imei.isEmpty) {
      return const OpenVtsEmptyState(
        title: 'Command unavailable',
        message: 'IMEI is required to send commands.',
      );
    }

    return Column(
      children: [
        _TargetVehicleCard(vehicle: widget.vehicle),
        const SizedBox(height: OpenVtsSpacing.sm),
        OpenVtsCard(
          padding: const EdgeInsets.all(OpenVtsSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Command',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: OpenVtsSpacing.sm),
              DropdownButtonFormField<String>(
                key: ValueKey(_dropdownEpoch),
                initialValue: _selectedTemplateId,
                decoration: const InputDecoration(
                  labelText: 'Template',
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: OpenVtsSpacing.sm,
                    vertical: OpenVtsSpacing.xs,
                  ),
                ),
                hint: const Text('Select command template'),
                items: widget.customCommands
                    .map(
                      (item) => DropdownMenuItem<String>(
                        value: item.id,
                        child: Text(item.displaySelectedLabel),
                      ),
                    )
                    .toList(growable: false),
                onChanged: (value) {
                  if (kDebugMode) {
                    debugPrint(
                      '[CommandsTab] template selected: value="$value" '
                      'total=${widget.customCommands.length} '
                      'ids=[${widget.customCommands.map((c) => c.id).join(", ")}]',
                    );
                  }
                  setState(() => _selectedTemplateId = value);
                  final selected = widget.customCommands
                      .where((item) => item.id == value)
                      .toList(growable: false);
                  if (selected.isNotEmpty) {
                    _commandController.text =
                        _resolveVariables(selected.first.command);
                  }
                },
              ),
              const SizedBox(height: OpenVtsSpacing.sm),
              TextField(
                controller: _commandController,
                maxLines: 3,
                maxLength: 500,
                decoration: const InputDecoration(
                  labelText: 'Command',
                  hintText: 'Enter command text',
                ),
              ),
              const SizedBox(height: OpenVtsSpacing.sm),
              TextField(
                controller: _noteController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Note',
                  hintText: 'Optional notes',
                ),
              ),
              const SizedBox(height: OpenVtsSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: OpenVtsButton(
                      label: _polling ? 'Polling status...' : 'Send',
                      isLoading: widget.isSending,
                      onPressed: widget.isSending || _polling ? null : _send,
                    ),
                  ),
                ],
              ),
              if (_latestStatus != '-') ...[
                const SizedBox(height: OpenVtsSpacing.sm),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: OpenVtsSpacing.sm,
                    vertical: OpenVtsSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: OpenVtsColors.background,
                    borderRadius: BorderRadius.circular(OpenVtsRadius.sm),
                    border: Border.all(color: OpenVtsColors.border),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.info_rounded,
                        size: 16,
                        color: OpenVtsColors.textSecondary,
                      ),
                      const SizedBox(width: OpenVtsSpacing.xs),
                      Expanded(
                        child: Text(
                          'Status: $_latestStatus',
                          style: OpenVtsTypography.meta.copyWith(
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: OpenVtsSpacing.sm),
        if (widget.isLoading)
          const OpenVtsLoader()
        else if (widget.history.isEmpty)
          const OpenVtsEmptyState(
            title: 'No command history',
            message: 'Send a command to see history.',
          )
        else ...[
          ...widget.history.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: OpenVtsSpacing.sm),
              child: _CommandHistoryCard(
                item: item,
                onTap: () => _openHistoryDetails(item),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _send() async {
    final command = _commandController.text.trim();
    if (command.isEmpty) {
      _toast('Command is required.');
      return;
    }
    if (command.length > 500) {
      _toast('Command must be 500 characters or less.');
      return;
    }

    await widget.onSend(
      command: command,
      note: _noteController.text.trim().isEmpty
          ? null
          : _noteController.text.trim(),
    );
    await widget.onRefresh();

    final latest = widget.history.isEmpty ? null : widget.history.first;
    final cmdId = latest?.cmdId.trim() ?? '';
    if (cmdId.isNotEmpty) {
      _latestStatus = latest?.status ?? 'REQUESTED';
      setState(() {});
      unawaited(_startPolling(cmdId));
    }
  }

  Future<void> _startPolling(String cmdId) async {
    _polling = true;
    final deadline = DateTime.now().add(const Duration(seconds: 90));

    while (DateTime.now().isBefore(deadline)) {
      final status = await widget.onPollStatus(cmdId);
      final current = (status?.status ?? '').trim().toUpperCase();
      if (current.isNotEmpty) {
        _latestStatus = current;
        if (mounted) setState(() {});
      }
      if (_terminalStatuses.contains(current)) {
        break;
      }
      await Future<void>.delayed(const Duration(seconds: 3));
    }

    _polling = false;
    if (mounted) {
      setState(() {});
      await widget.onRefresh();
    }
  }

  Future<void> _openHistoryDetails(AdminVehicleCommandItem item) async {
    final cmdId = item.cmdId.trim();
    final loaded =
        cmdId.isEmpty ? item : (await widget.onFetchCommandLog(cmdId) ?? item);

    if (!mounted) return;
    await OpenVtsBottomSheet.show<void>(
      context: context,
      title: 'Command Details',
      initialChildSize: 0.82,
      minChildSize: 0.52,
      maxChildSize: 0.95,
      child: ListView(
        padding: const EdgeInsets.all(OpenVtsSpacing.md),
        children: [
          _line('CmdId', _safe(loaded.cmdId)),
          _line('Status', _safe(loaded.status)),
          _line('Command', _safe(loaded.command)),
          _line('IMEI', _safe(loaded.imei)),
          _line('Requested At', _fmtDateTime(loaded.requestedAt)),
          _line('Queued At', _fmtDateTime(loaded.queuedAt)),
          _line('Sent At', _fmtDateTime(loaded.sentAt)),
          _line('Responded At', _fmtDateTime(loaded.respondedAt)),
          _line('Failed At', _fmtDateTime(loaded.failedAt)),
          _line('Timeout At', _fmtDateTime(loaded.timeoutAt)),
          _line('Response Raw', _safe(loaded.responseRaw ?? '')),
          _line('Response Hex', _safe(loaded.responseHex ?? '')),
          _line('Error', _safe(loaded.errorMessage ?? '')),
          const SizedBox(height: OpenVtsSpacing.xs),
          Text('Metadata', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: OpenVtsSpacing.xs),
          SelectableText(
              const JsonEncoder.withIndent('  ').convert(loaded.metadata)),
        ],
      ),
    );
  }

  Widget _line(String label, String value) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Text('$label: $value'),
      );

  String _resolveVariables(String template) {
    final map = <String, String>{
      'IMEI': widget.vehicle.imei,
      'LAT': _extractVehicleValue(['lat', 'latitude']),
      'LON': _extractVehicleValue(['lon', 'lng', 'longitude']),
      'SPEED': _extractVehicleValue(['speed']),
      'TIMESTAMP': DateTime.now().toUtc().toIso8601String(),
    };

    var text = template;
    for (final entry in map.entries) {
      text = text
          .replaceAll('{${entry.key}}', entry.value)
          .replaceAll('{{${entry.key}}}', entry.value)
          .replaceAll('{${entry.key.toLowerCase()}}', entry.value)
          .replaceAll('{{${entry.key.toLowerCase()}}}', entry.value);
    }
    return text;
  }

  String _extractVehicleValue(List<String> keys) {
    final meta = widget.vehicle.vehicleMeta;
    for (final key in keys) {
      final value =
          meta[key] ?? meta[key.toUpperCase()] ?? meta[key.toLowerCase()];
      if (value != null && value.toString().trim().isNotEmpty) {
        return value.toString().trim();
      }
    }
    return '';
  }

  void _toast(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  String _safe(String value) => value.trim().isEmpty ? '-' : value.trim();

  String _fmtDateTime(DateTime? value) {
    if (value == null) return '-';
    final local = value.toLocal();
    final d =
        '${local.year.toString().padLeft(4, '0')}-${local.month.toString().padLeft(2, '0')}-${local.day.toString().padLeft(2, '0')}';
    final t =
        '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}:${local.second.toString().padLeft(2, '0')}';
    return '$d $t';
  }
}

class _TargetVehicleCard extends StatelessWidget {
  const _TargetVehicleCard({required this.vehicle});

  final AdminVehicleDetails vehicle;

  @override
  Widget build(BuildContext context) {
    final name =
        vehicle.name.trim().isEmpty ? vehicle.plateNumber : vehicle.name;
    final hasType = vehicle.vehicleType != null;

    return OpenVtsCard(
      padding: const EdgeInsets.all(OpenVtsSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Target Vehicle',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: OpenVtsSpacing.sm),
          Text(
            name.isEmpty ? '-' : name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                ),
          ),
          if (vehicle.plateNumber.trim().isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              vehicle.plateNumber,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: OpenVtsTypography.meta.copyWith(
                color: OpenVtsColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ],
          const SizedBox(height: OpenVtsSpacing.sm),
          const Divider(height: 1, color: OpenVtsColors.border),
          const SizedBox(height: OpenVtsSpacing.sm),
          Row(
            children: [
              Expanded(
                child: _DetailItem(
                  icon: Icons.device_unknown_rounded,
                  label: 'IMEI',
                  value: vehicle.imei.trim().isEmpty ? '-' : vehicle.imei,
                ),
              ),
              if (vehicle.simNumber.trim().isNotEmpty) ...[
                const SizedBox(width: OpenVtsSpacing.sm),
                Expanded(
                  child: _DetailItem(
                    icon: Icons.sim_card_rounded,
                    label: 'SIM',
                    value: vehicle.simNumber,
                  ),
                ),
              ],
            ],
          ),
          if (hasType || vehicle.primaryUser != null) ...[
            const SizedBox(height: OpenVtsSpacing.sm),
            Row(
              children: [
                if (hasType)
                  Expanded(
                    child: _DetailItem(
                      icon: Icons.category_rounded,
                      label: 'Type',
                      value: vehicle.vehicleType?.name ?? '-',
                    ),
                  ),
                if (vehicle.primaryUser != null) ...[
                  if (hasType) const SizedBox(width: OpenVtsSpacing.sm),
                  Expanded(
                    child: _DetailItem(
                      icon: Icons.person_rounded,
                      label: 'Primary User',
                      value: vehicle.primaryUser?.displayName ?? '-',
                    ),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  const _DetailItem({
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

class _CommandHistoryCard extends StatelessWidget {
  const _CommandHistoryCard({
    required this.item,
    required this.onTap,
  });

  final AdminVehicleCommandItem item;
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
                  item.command,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                      ),
                ),
              ),
              const SizedBox(width: OpenVtsSpacing.xs),
              _StatusChip(status: item.status),
            ],
          ),
          const SizedBox(height: OpenVtsSpacing.sm),
          const Divider(height: 1, color: OpenVtsColors.border),
          const SizedBox(height: OpenVtsSpacing.sm),
          Row(
            children: [
              Expanded(
                child: _DetailItem(
                  icon: Icons.access_time_rounded,
                  label: 'Requested',
                  value: _formatTime(item.requestedAt ?? item.displayTime),
                ),
              ),
              const SizedBox(width: OpenVtsSpacing.sm),
              Expanded(
                child: _DetailItem(
                  icon: Icons.check_circle_outline_rounded,
                  label: 'Status',
                  value: item.status,
                ),
              ),
            ],
          ),
          if (item.responseRaw?.trim().isNotEmpty == true ||
              item.errorMessage?.trim().isNotEmpty == true) ...[
            const SizedBox(height: OpenVtsSpacing.sm),
            Text(
              (item.responseRaw ?? item.errorMessage ?? '-'),
              maxLines: 1,
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

  String _formatTime(DateTime? dt) {
    if (dt == null) return '-';
    final local = dt.toLocal();
    return '${local.year.toString().padLeft(4, '0')}-${local.month.toString().padLeft(2, '0')}-${local.day.toString().padLeft(2, '0')} ${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final String status;

  Color _getStatusColor() {
    switch (status.toUpperCase()) {
      case 'RESPONDED':
        return OpenVtsColors.success;
      case 'FAILED':
      case 'ENCODE_FAILED':
      case 'ERROR':
        return OpenVtsColors.error;
      case 'TIMEOUT':
        return OpenVtsColors.warning;
      default:
        return OpenVtsColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor();
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
        status.toUpperCase(),
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
