import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/open_vts_colors.dart';
import '../../../../../core/theme/open_vts_radius.dart';
import '../../../../../core/theme/open_vts_spacing.dart';
import '../../../../../core/theme/open_vts_typography.dart';
import '../../../../../core/utils/date_time_formatter.dart';
import '../../../../../core/utils/unit_formatter.dart';
import '../../../../../shared/widgets/open_vts_bottom_sheet.dart';
import '../../../../../shared/widgets/open_vts_button.dart';
import '../../../../../shared/widgets/open_vts_card.dart';
import '../../../../../shared/widgets/open_vts_empty_state.dart';
import '../../../../../shared/widgets/open_vts_loader.dart';
import '../../../../../shared/widgets/open_vts_search_field.dart';
import '../../../models/admin_vehicle_model.dart';

class AdminVehicleLogsTab extends ConsumerStatefulWidget {
  const AdminVehicleLogsTab({
    super.key,
    required this.imei,
    required this.logs,
    required this.hasLoadedLogs,
    required this.searchQuery,
    required this.nextCursor,
    required this.isLoading,
    required this.isLoadingMore,
    required this.onLoad,
    required this.onLoadMore,
    required this.onApplyRange,
    required this.onSearchChanged,
  });

  final String imei;
  final List<AdminVehicleLogItem> logs;
  final bool hasLoadedLogs;
  final String searchQuery;
  final String? nextCursor;
  final bool isLoading;
  final bool isLoadingMore;
  final Future<void> Function() onLoad;
  final Future<void> Function() onLoadMore;
  final Future<void> Function(DateTime? from, DateTime? to) onApplyRange;
  final ValueChanged<String> onSearchChanged;

  @override
  ConsumerState<AdminVehicleLogsTab> createState() =>
      _AdminVehicleLogsTabState();
}

class _AdminVehicleLogsTabState extends ConsumerState<AdminVehicleLogsTab> {
  DateTimeRange? _range;
  late UnitFormatter _unitFormatter;

  @override
  Widget build(BuildContext context) {
    _unitFormatter = ref.watch(unitFormatterProvider);
    ref.watch(appDateFormatterProvider);
    if (widget.imei.trim().isEmpty) {
      return const OpenVtsEmptyState(
        title: 'IMEI missing',
        message: 'IMEI is required to load telemetry logs.',
      );
    }

    return Column(
      children: [
        OpenVtsCard(
          padding: const EdgeInsets.all(OpenVtsSpacing.sm),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  _range == null
                      ? 'All dates'
                      : '${_fmtDate(_range!.start)} → ${_fmtDate(_range!.end)}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              IconButton(
                tooltip: 'Date range',
                onPressed: _pickRange,
                icon: const Icon(Icons.date_range_rounded, size: 18),
              ),
              TextButton(
                onPressed: widget.onLoad,
                child: const Text('Reset'),
              ),
            ],
          ),
        ),
        const SizedBox(height: OpenVtsSpacing.sm),
        OpenVtsSearchField(
          hintText: 'Search loaded logs',
          onChanged: widget.onSearchChanged,
        ),
        const SizedBox(height: OpenVtsSpacing.sm),
        if (widget.isLoading)
          const OpenVtsLoader()
        else if (!widget.hasLoadedLogs)
          const OpenVtsEmptyState(
            title: 'No logs found for this vehicle',
            message: 'Vehicle activity and system logs will appear here.',
          )
        else ...[
          if (widget.logs.isEmpty && widget.searchQuery.trim().isNotEmpty)
            const OpenVtsEmptyState(
              title: 'No matching logs',
              message: 'Try a different search term.',
            )
          else
            ...widget.logs.map(
              (log) => Padding(
                padding: const EdgeInsets.only(bottom: OpenVtsSpacing.sm),
                child: _LogCard(
                  log: log,
                  unitFormatter: _unitFormatter,
                  onTap: () => _openDetails(log),
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

  Future<void> _pickRange() async {
    final now = DateTime.now();
    final selected = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 1),
      initialDateRange: _range,
    );
    if (selected == null) return;
    setState(() => _range = selected);
    await widget.onApplyRange(selected.start, selected.end);
  }

  Future<void> _openDetails(AdminVehicleLogItem log) {
    return OpenVtsBottomSheet.show<void>(
      context: context,
      title: 'Log Details',
      initialChildSize: 0.8,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      child: ListView(
        padding: const EdgeInsets.all(OpenVtsSpacing.md),
        children: [
          _line('ID', _safe(log.id)),
          _line('IMEI', _safe(log.imei)),
          _line('Time', _fmtDateTime(log.displayTime)),
          _line('Packet Type', _safe(log.packetType)),
          _line('Protocol', _safe(log.protocol)),
          _line('Speed', '${_num(log.speedKph)} ${_unitFormatter.speedLabel}'),
          _line('Course', _num(log.course)),
          _line('Ignition', _bool(log.ignition)),
          _line('ACC', _bool(log.acc)),
          _line('Latitude', _coord(log.latitude)),
          _line('Longitude', _coord(log.longitude)),
          _line('Altitude', _num(log.altitude)),
          _line('Satellites', log.satellites?.toString() ?? '-'),
          _line('Valid', _bool(log.valid)),
          _line('Odometer', _num(log.odometer)),
          _line('Distance', _num(log.distance)),
          _line('Engine Hours', _num(log.engineHours)),
          _line('Total Engine Hours', _num(log.totalEngineHours)),
          _line('Raw Packet', _safe(log.rawPacket)),
          const SizedBox(height: OpenVtsSpacing.sm),
          Text('Attributes', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: OpenVtsSpacing.xs),
          SelectableText(_json(log.attributes)),
        ],
      ),
    );
  }

  Widget _line(String label, String value) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Text('$label: $value'),
      );

  String _json(Object? value) {
    if (value == null) return '{}';
    try {
      return const JsonEncoder.withIndent('  ').convert(value);
    } catch (_) {
      return value.toString();
    }
  }

  String _safe(String value) => value.trim().isEmpty ? '-' : value.trim();

  String _num(num? value) => value == null ? '-' : value.toStringAsFixed(2);

  String _coord(double? value) =>
      value == null ? '-' : value.toStringAsFixed(5);

  String _bool(bool? value) => value == null ? '-' : (value ? 'ON' : 'OFF');

  String _fmtDate(DateTime value) =>
      '${value.year.toString().padLeft(4, '0')}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';

  String _fmtDateTime(DateTime? value) {
    if (value == null) return '-';
    return value.toIso8601String();
  }
}

class _LogCard extends ConsumerWidget {
  const _LogCard({
    required this.log,
    required this.unitFormatter,
    required this.onTap,
  });

  final AdminVehicleLogItem log;
  final UnitFormatter unitFormatter;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final displayTime = log.displayTime;
    final speedLabel = '${_num(log.speedKph)} ${unitFormatter.speedLabel}';
    final formatter = ref.watch(appDateFormatterProvider);

    return OpenVtsCard(
      onTap: onTap,
      padding: const EdgeInsets.all(OpenVtsSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Telemetry Log',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.2,
                          ),
                    ),
                    if (log.packetType.trim().isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        log.packetType,
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
              ),
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
                  value: displayTime == null
                      ? '-'
                      : formatter.formatDateTime(displayTime),
                ),
              ),
              const SizedBox(width: OpenVtsSpacing.sm),
              Expanded(
                child: _InfoItem(
                  icon: Icons.speed_rounded,
                  label: 'Speed',
                  value: speedLabel,
                ),
              ),
            ],
          ),
          const SizedBox(height: OpenVtsSpacing.sm),
          Row(
            children: [
              Expanded(
                child: _InfoItem(
                  icon: Icons.location_on_rounded,
                  label: 'Latitude',
                  value: _coord(log.latitude),
                ),
              ),
              const SizedBox(width: OpenVtsSpacing.sm),
              Expanded(
                child: _InfoItem(
                  icon: Icons.location_on_rounded,
                  label: 'Longitude',
                  value: _coord(log.longitude),
                ),
              ),
            ],
          ),
          if (log.ignition != null || log.acc != null) ...[
            const SizedBox(height: OpenVtsSpacing.sm),
            Row(
              children: [
                if (log.ignition != null)
                  Expanded(
                    child: _StatusChip(
                      label: 'Ignition',
                      value: log.ignition!,
                    ),
                  ),
                if (log.acc != null) ...[
                  if (log.ignition != null)
                    const SizedBox(width: OpenVtsSpacing.sm),
                  Expanded(
                    child: _StatusChip(
                      label: 'ACC',
                      value: log.acc!,
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

  String _coord(double? value) =>
      value == null ? '-' : value.toStringAsFixed(5);

  String _num(num? value) => value == null ? '-' : value.toStringAsFixed(2);
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

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.label,
    required this.value,
  });

  final String label;
  final bool value;

  @override
  Widget build(BuildContext context) {
    final isActive = value;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: OpenVtsSpacing.xs,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: isActive
            ? OpenVtsColors.success.withValues(alpha: 0.08)
            : OpenVtsColors.surface,
        borderRadius: BorderRadius.circular(OpenVtsRadius.sm),
        border: Border.all(
          color: isActive
              ? OpenVtsColors.success.withValues(alpha: 0.25)
              : OpenVtsColors.border,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isActive ? Icons.check_circle_rounded : Icons.cancel_rounded,
            size: 12,
            color:
                isActive ? OpenVtsColors.success : OpenVtsColors.textTertiary,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: OpenVtsTypography.meta.copyWith(
              color:
                  isActive ? OpenVtsColors.success : OpenVtsColors.textTertiary,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
