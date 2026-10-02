import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/open_vts_spacing.dart';
import '../../../../../shared/widgets/open_vts_bottom_sheet.dart';
import '../../../../../shared/widgets/open_vts_button.dart';
import '../../../../../shared/widgets/open_vts_date_time_range_selector.dart';
import '../../../../../shared/widgets/open_vts_empty_state.dart';
import '../../../../../shared/widgets/open_vts_error_view.dart';
import '../../../../../shared/widgets/open_vts_loader.dart';
import '../../../../../shared/widgets/open_vts_search_field.dart';
import '../../../../../shared/widgets/open_vts_searchable_dropdown.dart';
import '../../../controllers/admin_providers.dart';
import '../../../models/admin_logs_model.dart';
import '../widgets/admin_logs_filter_widgets.dart';
import '../widgets/admin_telemetry_log_card.dart';
import '../widgets/admin_telemetry_log_detail_sheet.dart';

class AdminTelemetryLogsPanel extends ConsumerStatefulWidget {
  const AdminTelemetryLogsPanel({super.key});

  @override
  ConsumerState<AdminTelemetryLogsPanel> createState() =>
      _AdminTelemetryLogsPanelState();
}

class _AdminTelemetryLogsPanelState
    extends ConsumerState<AdminTelemetryLogsPanel> {
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminLogsControllerProvider);
    final controller = ref.read(adminLogsControllerProvider.notifier);
    final vehicleMap = {
      for (final v in state.options.vehicles) v.imei: v.displayName
    };

    if (state.isLoadingTelemetry && state.telemetryLogs.isEmpty) {
      return const OpenVtsLoader();
    }
    if (state.sectionErrorMessage != null && state.telemetryLogs.isEmpty) {
      return OpenVtsErrorView(
        message: state.sectionErrorMessage!,
        onRetry: controller.loadTelemetryLogs,
      );
    }

    final filteredLogs = _applyTelemetryReadFilter(
        state.telemetryLogs, state.telemetryReadFilter);

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        AdminTelemetryVehicleDropdown(
          value: state.telemetryVehicleId,
          vehicles: state.options.vehicles,
          onChanged: (v) {
            controller.setTelemetryFilters(
              vehicleId: v,
              clearVehicleId: v == null,
              imeiSearch: '',
            );
            unawaited(controller.loadTelemetryLogs());
          },
        ),
        const SizedBox(height: OpenVtsSpacing.sm),
        if ((state.telemetryVehicleId ?? '').isEmpty)
          OpenVtsSearchField(
            hintText: 'Search by IMEI...',
            onChanged: (v) {
              controller.setTelemetryFilters(imeiSearch: v);
              _debounce?.cancel();
              _debounce = Timer(const Duration(milliseconds: 350), () {
                unawaited(controller.loadTelemetryLogs());
              });
            },
          ),
        if ((state.telemetryVehicleId ?? '').isEmpty)
          const SizedBox(height: OpenVtsSpacing.sm),
        Wrap(
          spacing: OpenVtsSpacing.xs,
          runSpacing: OpenVtsSpacing.xs,
          children: [
            _chip('All', state.telemetryPacketType.isEmpty, () {
              controller.setTelemetryFilters(packetType: '');
              controller.loadTelemetryLogs();
            }),
            _chip('LOCATION', state.telemetryPacketType == 'LOCATION', () {
              controller.setTelemetryFilters(packetType: 'LOCATION');
              controller.loadTelemetryLogs();
            }),
            _chip('HISTORY', state.telemetryPacketType == 'HISTORY', () {
              controller.setTelemetryFilters(packetType: 'HISTORY');
              controller.loadTelemetryLogs();
            }),
            _chip('ALARM', state.telemetryPacketType == 'ALARM', () {
              controller.setTelemetryFilters(packetType: 'ALARM');
              controller.loadTelemetryLogs();
            }),
            _chip('HEARTBEAT', state.telemetryPacketType == 'HEARTBEAT', () {
              controller.setTelemetryFilters(packetType: 'HEARTBEAT');
              controller.loadTelemetryLogs();
            }),
            _chip('COMMAND', state.telemetryPacketType == 'COMMAND', () {
              controller.setTelemetryFilters(packetType: 'COMMAND');
              controller.loadTelemetryLogs();
            }),
            _chip('EVENT', state.telemetryPacketType == 'EVENT', () {
              controller.setTelemetryFilters(packetType: 'EVENT');
              controller.loadTelemetryLogs();
            }),
            _chip('UNKNOWN', state.telemetryPacketType == 'UNKNOWN', () {
              controller.setTelemetryFilters(packetType: 'UNKNOWN');
              controller.loadTelemetryLogs();
            }),
          ],
        ),
        const SizedBox(height: OpenVtsSpacing.sm),
        Wrap(
          spacing: OpenVtsSpacing.xs,
          runSpacing: OpenVtsSpacing.xs,
          children: [
            _chip('All read states',
                state.telemetryReadFilter == AdminReadFilter.all, () {
              controller.setTelemetryFilters(readFilter: AdminReadFilter.all);
              unawaited(controller.loadTelemetryLogs());
            }),
            _chip('Read', state.telemetryReadFilter == AdminReadFilter.read,
                () {
              controller.setTelemetryFilters(readFilter: AdminReadFilter.read);
              unawaited(controller.loadTelemetryLogs());
            }),
            _chip('Unread', state.telemetryReadFilter == AdminReadFilter.unread,
                () {
              controller.setTelemetryFilters(
                  readFilter: AdminReadFilter.unread);
              unawaited(controller.loadTelemetryLogs());
            }),
          ],
        ),
        const SizedBox(height: OpenVtsSpacing.sm),
        OpenVtsDateTimeRangeField(
          label: 'Date range',
          title: 'Telemetry date range',
          dateTimeEnabled: true,
          value: OpenVtsDateTimeRange(
              start: state.telemetryFrom, end: state.telemetryTo),
          onChanged: (range) {
            controller.setTelemetryFilters(
              from: range.start,
              to: range.end,
              clearFrom: range.start == null,
              clearTo: range.end == null,
            );
            unawaited(controller.loadTelemetryLogs());
          },
        ),
        const SizedBox(height: OpenVtsSpacing.sm),
        if (filteredLogs.isEmpty)
          const OpenVtsEmptyState(
            title: 'No telemetry logs found',
            message: 'Try changing filters.',
          )
        else ...[
          for (final item in filteredLogs) ...[
            AdminTelemetryLogCard(
              item: item,
              vehicleLabel: vehicleMap[item.imei] ?? '',
              onTap: () => OpenVtsBottomSheet.show<void>(
                context: context,
                title: 'Telemetry Detail',
                initialChildSize: 0.88,
                minChildSize: 0.5,
                maxChildSize: 0.96,
                child: AdminTelemetryLogDetailSheet(id: item.id),
              ),
            ),
            if (item != filteredLogs.last)
              const SizedBox(height: OpenVtsSpacing.sm),
          ],
          if ((state.telemetryNextCursor ?? '').isNotEmpty) ...[
            const SizedBox(height: OpenVtsSpacing.sm),
            OpenVtsButton(
              label: 'Load More',
              height: 38,
              variant: OpenVtsButtonVariant.secondary,
              isLoading: state.isLoadingMoreTelemetry,
              onPressed: state.isLoadingMoreTelemetry
                  ? null
                  : controller.loadMoreTelemetryLogs,
            ),
          ],
        ]
      ],
    );
  }

  Widget _chip(String label, bool selected, VoidCallback onTap) {
    return AdminFilterChip(label: label, selected: selected, onTap: onTap);
  }

  bool _isTelemetryRead(AdminTelemetryLogItem item) {
    return item.valid == true && item.ignition != null && item.acc != null;
  }

  List<AdminTelemetryLogItem> _applyTelemetryReadFilter(
    List<AdminTelemetryLogItem> items,
    AdminReadFilter filter,
  ) {
    switch (filter) {
      case AdminReadFilter.all:
        return items;
      case AdminReadFilter.read:
        return items.where((item) => _isTelemetryRead(item)).toList();
      case AdminReadFilter.unread:
        return items.where((item) => !_isTelemetryRead(item)).toList();
    }
  }
}

class AdminTelemetryVehicleDropdown extends StatelessWidget {
  const AdminTelemetryVehicleDropdown({
    required this.value,
    required this.vehicles,
    required this.onChanged,
    super.key,
  });

  final String? value;
  final List<AdminLogsVehicleOption> vehicles;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return OpenVtsSearchableDropdown<String>(
      label: 'Vehicle',
      value: value,
      hintText: 'All vehicles',
      searchHintText: 'Search vehicles...',
      options: vehicles
          .map(
            (vehicle) => OpenVtsDropdownOption<String>(
              value: vehicle.id,
              label: vehicle.displayName,
              subtitle: vehicle.imei.trim().isEmpty ? null : vehicle.imei,
              searchText: [
                vehicle.displayName,
                vehicle.id,
                vehicle.name,
                vehicle.plateNumber,
                vehicle.imei,
              ].join(' '),
            ),
          )
          .toList(growable: false),
      onChanged: onChanged,
    );
  }
}
