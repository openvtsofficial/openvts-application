import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/providers/core_providers.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/open_vts_colors.dart';
import '../../../../core/theme/open_vts_radius.dart';
import '../../../../core/theme/open_vts_spacing.dart';
import '../../../../core/theme/open_vts_typography.dart';
import '../../../../shared/helpers/toast_helper.dart';
import '../../../../shared/widgets/open_vts_bottom_sheet.dart';
import '../../../../shared/widgets/open_vts_card.dart';
import '../../../../shared/widgets/open_vts_detail_tab_strip.dart';
import '../../../../shared/widgets/open_vts_empty_state.dart';
import '../../../../shared/widgets/open_vts_error_view.dart';
import '../../../../shared/widgets/open_vts_loader.dart';
import '../../../../shared/widgets/open_vts_page_scaffold.dart';
import '../../controllers/admin_providers.dart';
import '../../models/admin_vehicle_model.dart';
import '../../models/admin_vehicle_state.dart';
import 'widgets/admin_vehicle_commands_tab.dart';
import 'widgets/admin_vehicle_config_tab.dart';
import 'widgets/admin_vehicle_details_tab.dart';
import 'widgets/admin_vehicle_documents_tab.dart';
import 'widgets/admin_vehicle_edit_sheet.dart';
import 'widgets/admin_vehicle_events_tab.dart';
import 'widgets/admin_vehicle_logs_tab.dart';
import 'widgets/admin_vehicle_sensors_tab.dart';
import 'widgets/admin_vehicle_users_tab.dart';

class AdminVehicleDetailsScreen extends ConsumerStatefulWidget {
  const AdminVehicleDetailsScreen({
    super.key,
    required this.vehicleId,
    this.initialVehicle,
  });

  final String vehicleId;
  final AdminVehicleListItem? initialVehicle;

  @override
  ConsumerState<AdminVehicleDetailsScreen> createState() =>
      _AdminVehicleDetailsScreenState();
}

class _AdminVehicleDetailsScreenState
    extends ConsumerState<AdminVehicleDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = ref.read(
          adminVehicleDetailsControllerProvider(widget.vehicleId).notifier);
      controller.loadInitial();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = adminVehicleDetailsControllerProvider(widget.vehicleId);
    final state = ref.watch(provider);
    final controller = ref.read(provider.notifier);
    final apiBaseUrl = ref.watch(apiBaseUrlProvider);
    final vehicle = state.vehicle;

    final displayVehicle = vehicle?.primaryUser == null &&
            widget.initialVehicle?.primaryUser != null
        ? vehicle?.copyWith(primaryUser: widget.initialVehicle!.primaryUser)
        : vehicle;

    final title = displayVehicle?.name.isNotEmpty == true
        ? displayVehicle!.name
        : (widget.initialVehicle?.name.isNotEmpty == true
            ? widget.initialVehicle!.name
            : 'Vehicle Details');

    return OpenVtsPageScaffold(
      title: title,
      headerMode: OpenVtsPageHeaderMode.closeable,
      onClose: _close,
      padding: const EdgeInsetsDirectional.fromSTEB(
        OpenVtsSpacing.sm,
        OpenVtsSpacing.sm,
        OpenVtsSpacing.sm,
        OpenVtsSpacing.xs,
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: OpenVtsSpacing.xxs),
          child: Center(
            child: _StatusChip(
                isActive:
                    displayVehicle?.isActive ?? vehicle?.isActive ?? true),
          ),
        ),
        _HeaderMenu(
          isBusy: state.isUpdatingStatus ||
              state.isDeletingVehicle ||
              state.isUpdatingVehicle,
          onRefresh: () => controller.refreshCurrentTab(),
          onEdit: () => _onAction(context, ref, _Action.edit),
          onToggleStatus: () => _onAction(context, ref, _Action.toggleStatus),
          onDelete: () => _onAction(context, ref, _Action.delete),
        ),
        const SizedBox(width: OpenVtsSpacing.xs),
      ],
      body: RefreshIndicator(
        onRefresh: controller.refreshCurrentTab,
        child: ListView(
          padding: EdgeInsets.zero,
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            if (state.errorMessage != null)
              OpenVtsErrorView(
                message: state.errorMessage!,
                onRetry: controller.loadInitial,
              )
            else if (state.isLoadingVehicle && vehicle == null)
              const SizedBox(height: 240, child: OpenVtsLoader())
            else if (displayVehicle != null) ...[
              _SummaryCard(
                vehicle: displayVehicle,
                isSyncing: state.isLoadingVehicle,
              ),
              const SizedBox(height: OpenVtsSpacing.sm),
              _TabChips(
                selected: state.selectedTab,
                onSelect: controller.selectTab,
              ),
              const SizedBox(height: OpenVtsSpacing.sm),
              if (state.sectionErrorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: OpenVtsSpacing.sm),
                  child: OpenVtsErrorView(message: state.sectionErrorMessage!),
                ),
              _TabBody(
                state: state,
                displayVehicle: displayVehicle,
                onEdit: () => _onAction(context, ref, _Action.edit),
                onToggleStatus: () =>
                    _onAction(context, ref, _Action.toggleStatus),
                onDelete: () => _onAction(context, ref, _Action.delete),
                onLoadUsers: controller.loadUsers,
                onLinkUser: controller.linkUser,
                onUnlinkUser: controller.unlinkUser,
                onLoadLogs: () => controller.loadLogs(),
                onLoadMoreLogs: controller.loadMoreLogs,
                onLogSearchChanged: controller.setLogSearchQuery,
                onSetLogRange: ({from, to}) =>
                    controller.setLogRange(from: from, to: to),
                onLoadEvents: () => controller.loadEvents(),
                onLoadMoreEvents: controller.loadMoreEvents,
                onSetEventFilters: ({
                  DateTime? from,
                  DateTime? to,
                  String? source,
                  String? severity,
                }) =>
                    controller.applyEventFilters(
                  from: from,
                  to: to,
                  source: source,
                  severity: severity,
                ),
                onClearEventFilters: controller.clearEventFilters,
                onLoadCommands: controller.loadCommands,
                onSendCommand: ({
                  required String command,
                  String? note,
                }) =>
                    controller.sendCommand(command: command, note: note),
                onPollCommandStatus: controller.getCommandStatus,
                onFetchCommandLog: controller.getCommandLog,
                onLoadSensors: ({search}) =>
                    controller.loadSensors(search: search),
                onCreateSensor: controller.createSensor,
                onUpdateSensor: (sensorId, request) => controller.updateSensor(
                    sensorId: sensorId, request: request),
                onDeleteSensor: controller.deleteSensor,
                onRunSensor: (request) =>
                    controller.runSensor(request: request),
                onLoadDocuments: controller.loadDocuments,
                onUploadDocument: controller.uploadDocument,
                onUpdateDocument: ({required docId, required request}) =>
                    controller.updateDocument(docId: docId, request: request),
                onDeleteDocument: controller.deleteDocument,
                onUpdateConfig: controller.updateConfig,
                apiBaseUrl: apiBaseUrl,
              ),
              const SizedBox(height: OpenVtsSpacing.lg),
            ] else
              const OpenVtsEmptyState(
                title: 'Vehicle unavailable',
                message: 'Vehicle record is not available.',
              ),
          ],
        ),
      ),
    );
  }

  void _close() {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(RoutePaths.adminVehicles);
  }

  Future<void> _onAction(
      BuildContext context, WidgetRef ref, _Action action) async {
    switch (action) {
      case _Action.edit:
        await _openEditSheet(context, ref);
      case _Action.toggleStatus:
        await _toggleStatus(context, ref);
      case _Action.delete:
        await _deleteVehicle(context, ref);
    }
  }

  Future<void> _openEditSheet(BuildContext context, WidgetRef ref) async {
    final provider = adminVehicleDetailsControllerProvider(widget.vehicleId);
    final state = ref.read(provider);
    final vehicle = state.vehicle;
    if (vehicle == null) return;

    await OpenVtsBottomSheet.show<void>(
      context: context,
      title: 'Edit Vehicle',
      initialChildSize: 0.9,
      minChildSize: 0.6,
      maxChildSize: 0.94,
      child: Consumer(
        builder: (_, innerRef, __) {
          final current = innerRef.watch(provider);
          return AdminVehicleEditSheet(
            vehicle: current.vehicle ?? vehicle,
            vehicleTypes: current.vehicleTypes,
            timezones: current.timezones,
            isSubmitting: current.isUpdatingVehicle,
            onSubmit: (request) async {
              await innerRef.read(provider.notifier).updateVehicle(request);
              final next = innerRef.read(provider);
              if (next.sectionErrorMessage == null && context.mounted) {
                Navigator.of(context).pop();
                ToastHelper.showSuccess('Vehicle updated.', context: context);
              } else if (context.mounted) {
                ToastHelper.showError(
                  next.sectionErrorMessage ?? 'Unable to update vehicle.',
                  context: context,
                );
              }
            },
          );
        },
      ),
    );
  }

  Future<void> _toggleStatus(BuildContext context, WidgetRef ref) async {
    final provider = adminVehicleDetailsControllerProvider(widget.vehicleId);
    final state = ref.read(provider);
    final vehicle = state.vehicle;
    if (vehicle == null) return;
    await ref.read(provider.notifier).updateVehicleStatus(!vehicle.isActive);
    final next = ref.read(provider);
    if (!context.mounted) return;
    if (next.sectionErrorMessage == null) {
      ToastHelper.showSuccess(
        vehicle.isActive ? 'Vehicle deactivated.' : 'Vehicle activated.',
        context: context,
      );
    } else {
      ToastHelper.showError(next.sectionErrorMessage!, context: context);
    }
  }

  Future<void> _deleteVehicle(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete vehicle'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: TextButton.styleFrom(foregroundColor: OpenVtsColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final detailsProvider =
        adminVehicleDetailsControllerProvider(widget.vehicleId);
    await ref.read(detailsProvider.notifier).deleteVehicle();
    final next = ref.read(detailsProvider);
    if (!context.mounted) return;
    if (next.sectionErrorMessage == null) {
      final listProvider = adminVehiclesControllerProvider;
      await ref.read(listProvider.notifier).refresh();
      if (!context.mounted) return;
      ToastHelper.showSuccess('Vehicle deleted.', context: context);
      if (context.canPop()) {
        context.pop();
      } else {
        context.go(RoutePaths.adminVehicles);
      }
    } else {
      ToastHelper.showError(next.sectionErrorMessage!, context: context);
    }
  }
}

enum _HeaderMenuAction {
  refresh,
  edit,
  toggleStatus,
  delete,
}

class _HeaderMenu extends StatelessWidget {
  const _HeaderMenu({
    required this.isBusy,
    required this.onRefresh,
    required this.onEdit,
    required this.onToggleStatus,
    required this.onDelete,
  });

  final bool isBusy;
  final VoidCallback onRefresh;
  final VoidCallback onEdit;
  final VoidCallback onToggleStatus;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_HeaderMenuAction>(
      tooltip: 'Vehicle actions',
      enabled: !isBusy,
      icon: Icon(
        Icons.more_vert_rounded,
        size: 20,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      onSelected: (action) {
        switch (action) {
          case _HeaderMenuAction.refresh:
            onRefresh();
          case _HeaderMenuAction.edit:
            onEdit();
          case _HeaderMenuAction.toggleStatus:
            onToggleStatus();
          case _HeaderMenuAction.delete:
            onDelete();
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: _HeaderMenuAction.refresh,
          height: 40,
          child: _MenuRow(icon: Icons.refresh_rounded, label: 'Refresh'),
        ),
        const PopupMenuItem(
          value: _HeaderMenuAction.edit,
          height: 40,
          child: _MenuRow(icon: Icons.edit_outlined, label: 'Edit'),
        ),
        const PopupMenuItem(
          value: _HeaderMenuAction.toggleStatus,
          height: 40,
          child: _MenuRow(
            icon: Icons.toggle_off_outlined,
            label: 'Toggle Status',
          ),
        ),
        const PopupMenuDivider(height: 8),
        const PopupMenuItem(
          value: _HeaderMenuAction.delete,
          height: 40,
          child: _MenuRow(
            icon: Icons.delete_outline_rounded,
            label: 'Delete',
            isDestructive: true,
          ),
        ),
      ],
    );
  }
}

class _MenuRow extends StatelessWidget {
  const _MenuRow({
    required this.icon,
    required this.label,
    this.isDestructive = false,
  });

  final IconData icon;
  final String label;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final color = isDestructive
        ? OpenVtsColors.error
        : Theme.of(context).colorScheme.onSurface;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: OpenVtsSpacing.xs),
        Text(
          label,
          style: OpenVtsTypography.label.copyWith(color: color),
        ),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isActive
        ? (isDark ? OpenVtsColors.darkTextPrimary : OpenVtsColors.brandInk)
        : Theme.of(context).colorScheme.onSurfaceVariant;
    return _MicroChip(
      label: isActive ? 'Active' : 'Inactive',
      icon: isActive
          ? Icons.check_circle_outline_rounded
          : Icons.pause_circle_outline_rounded,
      color: color,
    );
  }
}

class _MicroChip extends StatelessWidget {
  const _MicroChip({
    required this.label,
    required this.icon,
    required this.color,
  });

  final String label;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(OpenVtsRadius.pill),
        border: Border.all(color: color.withValues(alpha: 0.28)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: OpenVtsTypography.meta.copyWith(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.vehicle,
    required this.isSyncing,
  });

  final AdminVehicleDetails vehicle;
  final bool isSyncing;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return OpenVtsCard(
      padding: const EdgeInsets.all(OpenVtsSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 44,
                width: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.surfaceContainerHighest,
                ),
                child: Icon(
                  Icons.directions_car_filled_rounded,
                  size: 24,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(width: OpenVtsSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vehicle.name.isEmpty ? 'Untitled Vehicle' : vehicle.name,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                        height: 1.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (vehicle.plateNumber.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        vehicle.plateNumber,
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.onSurfaceVariant,
                          height: 1.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: OpenVtsSpacing.sm),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _StatusChip(isActive: vehicle.isActive),
                  if (vehicle.isLicenseBlocked) ...[
                    const SizedBox(height: 4),
                    const _MicroChip(
                      label: 'License Blocked',
                      icon: Icons.lock_outline_rounded,
                      color: OpenVtsColors.error,
                    ),
                  ],
                ],
              ),
            ],
          ),
          if (vehicle.imei.isNotEmpty || vehicle.simNumber.isNotEmpty) ...[
            const SizedBox(height: OpenVtsSpacing.sm),
            if (vehicle.imei.isNotEmpty)
              _CompactInfoLine(
                  icon: Icons.device_hub_outlined, value: vehicle.imei),
            if (vehicle.imei.isNotEmpty && vehicle.simNumber.isNotEmpty)
              const SizedBox(height: 4),
            if (vehicle.simNumber.isNotEmpty)
              _CompactInfoLine(
                  icon: Icons.sim_card_outlined, value: vehicle.simNumber),
          ],
          const SizedBox(height: OpenVtsSpacing.md),
          Divider(height: 1, color: colorScheme.outlineVariant),
          const SizedBox(height: OpenVtsSpacing.md),
          Row(
            children: [
              Expanded(
                child: _MetricTile(
                  icon: Icons.badge_outlined,
                  label: 'Type',
                  value: _displayValue(vehicle.vehicleType?.name ?? ''),
                ),
              ),
              const SizedBox(width: OpenVtsSpacing.sm),
              if (isSyncing)
                const Expanded(
                  child: Center(
                    child: SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                )
              else
                Expanded(
                  child: _MetricTile(
                    icon: Icons.person_outline_rounded,
                    label: 'Primary User',
                    value: vehicle.primaryUser?.displayName.isNotEmpty == true
                        ? vehicle.primaryUser!.displayName
                        : '-',
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  String _displayValue(String value) {
    final normalized = value.trim();
    if (normalized.isEmpty || normalized == '-') {
      return '-';
    }
    return normalized;
  }
}

class _CompactInfoLine extends StatelessWidget {
  const _CompactInfoLine({required this.icon, required this.value});

  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: OpenVtsSpacing.xxs),
      child: Row(
        children: [
          Icon(icon, size: 14, color: colorScheme.onSurfaceVariant),
          const SizedBox(width: OpenVtsSpacing.xs),
          Expanded(
            child: Text(
              _displayValue(value),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: OpenVtsTypography.meta.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _displayValue(String value) {
    final normalized = value.trim();
    if (normalized.isEmpty || normalized == '-') {
      return '-';
    }
    return normalized;
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: OpenVtsSpacing.sm,
        vertical: OpenVtsSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(OpenVtsRadius.md),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: colorScheme.onSurfaceVariant),
          const SizedBox(width: OpenVtsSpacing.xs),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TabChips extends StatelessWidget {
  const _TabChips({required this.selected, required this.onSelect});

  final AdminVehicleDetailsTab selected;
  final ValueChanged<AdminVehicleDetailsTab> onSelect;

  static const Map<AdminVehicleDetailsTab, String> _labels = {
    AdminVehicleDetailsTab.details: 'Vehicle Details',
    AdminVehicleDetailsTab.users: 'Users',
    AdminVehicleDetailsTab.logs: 'Logs',
    AdminVehicleDetailsTab.commands: 'Commands',
    AdminVehicleDetailsTab.sensors: 'Sensors',
    AdminVehicleDetailsTab.documents: 'Documents',
    AdminVehicleDetailsTab.config: 'Config',
    AdminVehicleDetailsTab.events: 'Events',
  };

  @override
  Widget build(BuildContext context) {
    final tabs = AdminVehicleDetailsTab.values
        .map(
          (tab) => OpenVtsDetailTabOption<AdminVehicleDetailsTab>(
            value: tab,
            label: _labels[tab] ?? tab.name,
          ),
        )
        .toList(growable: false);

    return OpenVtsDetailTabStrip<AdminVehicleDetailsTab>(
      tabs: tabs,
      selected: selected,
      onChanged: onSelect,
    );
  }
}

class _TabBody extends StatelessWidget {
  const _TabBody({
    required this.state,
    required this.displayVehicle,
    required this.onEdit,
    required this.onToggleStatus,
    required this.onDelete,
    required this.onLoadUsers,
    required this.onLinkUser,
    required this.onUnlinkUser,
    required this.onLoadLogs,
    required this.onLoadMoreLogs,
    required this.onLogSearchChanged,
    required this.onSetLogRange,
    required this.onLoadEvents,
    required this.onLoadMoreEvents,
    required this.onSetEventFilters,
    required this.onClearEventFilters,
    required this.onLoadCommands,
    required this.onSendCommand,
    required this.onPollCommandStatus,
    required this.onFetchCommandLog,
    required this.onLoadSensors,
    required this.onCreateSensor,
    required this.onUpdateSensor,
    required this.onDeleteSensor,
    required this.onRunSensor,
    required this.onLoadDocuments,
    required this.onUploadDocument,
    required this.onUpdateDocument,
    required this.onDeleteDocument,
    required this.onUpdateConfig,
    required this.apiBaseUrl,
  });

  final AdminVehicleDetailsState state;
  final AdminVehicleDetails? displayVehicle;
  final VoidCallback onEdit;
  final VoidCallback onToggleStatus;
  final VoidCallback onDelete;
  final Future<void> Function() onLoadUsers;
  final Future<void> Function(String userId) onLinkUser;
  final Future<void> Function(String userId) onUnlinkUser;
  final Future<void> Function() onLoadLogs;
  final Future<void> Function() onLoadMoreLogs;
  final ValueChanged<String> onLogSearchChanged;
  final Future<void> Function({DateTime? from, DateTime? to}) onSetLogRange;
  final Future<void> Function() onLoadEvents;
  final Future<void> Function() onLoadMoreEvents;
  final Future<void> Function({
    DateTime? from,
    DateTime? to,
    String? source,
    String? severity,
  }) onSetEventFilters;
  final Future<void> Function() onClearEventFilters;
  final Future<void> Function() onLoadCommands;
  final Future<void> Function({
    required String command,
    String? note,
  }) onSendCommand;
  final Future<AdminCommandStatus?> Function(String cmdId) onPollCommandStatus;
  final Future<AdminVehicleCommandItem?> Function(String cmdId)
      onFetchCommandLog;
  final Future<void> Function({String? search}) onLoadSensors;
  final Future<void> Function(AdminVehicleSensorUpsertRequest request)
      onCreateSensor;
  final Future<void> Function(
    String sensorId,
    AdminVehicleSensorUpsertRequest request,
  ) onUpdateSensor;
  final Future<void> Function(String sensorId) onDeleteSensor;
  final Future<void> Function(AdminVehicleSensorRunRequest request) onRunSensor;
  final Future<void> Function() onLoadDocuments;
  final Future<void> Function(AdminVehicleDocumentRequest request)
      onUploadDocument;
  final Future<void> Function({
    required String docId,
    required AdminVehicleDocumentRequest request,
  }) onUpdateDocument;
  final Future<void> Function(String docId) onDeleteDocument;
  final Future<void> Function(AdminVehicleConfigUpdateRequest request)
      onUpdateConfig;
  final String apiBaseUrl;

  @override
  Widget build(BuildContext context) {
    switch (state.selectedTab) {
      case AdminVehicleDetailsTab.details:
        final vehicle = displayVehicle ?? state.vehicle;
        if (vehicle == null) {
          return const OpenVtsEmptyState(
            title: 'No details',
            message: 'Vehicle details are unavailable.',
          );
        }
        return AdminVehicleDetailsOverviewTab(
          vehicle: vehicle,
          isUpdatingStatus: state.isUpdatingStatus,
          isDeleting: state.isDeletingVehicle,
          onEdit: onEdit,
          onToggleStatus: onToggleStatus,
          onDelete: onDelete,
        );
      case AdminVehicleDetailsTab.users:
        return AdminVehicleUsersTab(
          isLoading: state.isLoadingUsers,
          isLinking: state.isLinkingUser,
          isUnlinking: state.isUnlinkingUser,
          linkedUsers: state.linkedUsers,
          availableUsers: state.availableUsers,
          onRefresh: onLoadUsers,
          onLinkUser: onLinkUser,
          onUnlinkUser: onUnlinkUser,
        );
      case AdminVehicleDetailsTab.logs:
        return AdminVehicleLogsTab(
          imei: state.vehicle?.imei ?? '',
          logs: state.filteredLogs,
          hasLoadedLogs: state.logs.isNotEmpty,
          searchQuery: state.logSearchQuery,
          nextCursor: state.logNextCursor,
          isLoading: state.isLoadingLogs,
          isLoadingMore: state.isLoadingMoreLogs,
          onLoad: onLoadLogs,
          onLoadMore: onLoadMoreLogs,
          onSearchChanged: onLogSearchChanged,
          onApplyRange: (from, to) => onSetLogRange(from: from, to: to),
        );
      case AdminVehicleDetailsTab.commands:
        final vehicle = state.vehicle;
        if (vehicle == null) {
          return const OpenVtsEmptyState(
            title: 'Vehicle unavailable',
            message: 'Cannot load commands without vehicle details.',
          );
        }
        return AdminVehicleCommandsTab(
          vehicle: vehicle,
          customCommands: state.customCommands,
          systemVariables: state.systemVariables,
          history: state.commandHistory,
          isLoading: state.isLoadingCommands,
          isSending: state.isSendingCommand,
          onRefresh: onLoadCommands,
          onSend: onSendCommand,
          onPollStatus: onPollCommandStatus,
          onFetchCommandLog: onFetchCommandLog,
        );
      case AdminVehicleDetailsTab.sensors:
        return AdminVehicleSensorsTab(
          isLoading: state.isLoadingSensors,
          isCreating: state.isCreatingSensor,
          isUpdating: state.isUpdatingSensor,
          isDeleting: state.isDeletingSensor,
          isRunning: state.isRunningSensor,
          sensors: state.sensors,
          onLoad: onLoadSensors,
          onCreate: onCreateSensor,
          onUpdate: onUpdateSensor,
          onDelete: onDeleteSensor,
          onRun: onRunSensor,
        );
      case AdminVehicleDetailsTab.documents:
        return AdminVehicleDocumentsTab(
          vehicleId: state.vehicleId,
          apiBaseUrl: apiBaseUrl,
          documents: state.documents,
          docTypes: state.documentTypes,
          isLoading: state.isLoadingDocuments,
          isUploading: state.isUploadingDocument,
          isUpdating: state.isUpdatingDocument,
          isDeleting: state.isDeletingDocument,
          onLoad: onLoadDocuments,
          onUpload: onUploadDocument,
          onUpdate: onUpdateDocument,
          onDelete: onDeleteDocument,
        );
      case AdminVehicleDetailsTab.config:
        final vehicle = state.vehicle;
        if (vehicle == null) {
          return const OpenVtsEmptyState(
            title: 'No config',
            message: 'Vehicle details are unavailable.',
          );
        }
        return AdminVehicleConfigTab(
          vehicle: vehicle,
          isSaving: state.isUpdatingConfig,
          onSave: onUpdateConfig,
        );
      case AdminVehicleDetailsTab.events:
        return AdminVehicleEventsTab(
          imei: state.vehicle?.imei ?? '',
          events: state.events,
          nextCursor: state.eventNextCursor,
          isLoading: state.isLoadingEvents,
          isLoadingMore: state.isLoadingMoreEvents,
          onLoad: onLoadEvents,
          onLoadMore: onLoadMoreEvents,
          onApplyFilters: ({
            DateTime? from,
            DateTime? to,
            String? source,
            String? severity,
          }) =>
              onSetEventFilters(
            from: from,
            to: to,
            source: source,
            severity: severity,
          ),
          onClearFilters: onClearEventFilters,
        );
    }
  }
}

enum _Action { edit, toggleStatus, delete }
