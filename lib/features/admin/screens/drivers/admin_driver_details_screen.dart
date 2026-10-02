import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/open_vts_colors.dart';
import '../../../../core/theme/open_vts_radius.dart';
import '../../../../core/theme/open_vts_spacing.dart';
import '../../../../core/theme/open_vts_typography.dart';
import '../../../../shared/helpers/toast_helper.dart';
import '../../../../shared/widgets/open_vts_card.dart';
import '../../../../shared/widgets/open_vts_detail_tab_strip.dart';
import '../../../../shared/widgets/open_vts_error_view.dart';
import '../../../../shared/widgets/open_vts_loader.dart';
import '../../../../shared/widgets/open_vts_page_scaffold.dart';
import '../../controllers/admin_driver_details_controller.dart';
import '../../controllers/admin_providers.dart';
import '../../models/admin_driver_details_state.dart';
import '../../models/admin_drivers_model.dart';
import 'widgets/admin_driver_documents_tab.dart';
import 'widgets/admin_driver_profile_tab.dart';
import 'widgets/admin_driver_users_tab.dart';

class AdminDriverDetailsScreen extends ConsumerWidget {
  const AdminDriverDetailsScreen({
    super.key,
    required this.driverId,
    this.initialDriver,
  });

  final String driverId;
  final AdminDriverListItem? initialDriver;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = adminDriverDetailsControllerProvider(driverId);
    final state = ref.watch(provider);
    final controller = ref.read(provider.notifier);

    final driver = state.driver;
    final isActive = driver?.isActive ?? initialDriver?.isActive ?? false;
    final title = driver?.name.trim().isNotEmpty == true
        ? driver!.name
        : (initialDriver?.firstName.trim().isNotEmpty == true
            ? initialDriver!.firstName
            : 'Driver');

    return OpenVtsPageScaffold(
      title: title,
      headerMode: OpenVtsPageHeaderMode.closeable,
      onClose: () {
        if (context.canPop()) {
          context.pop();
          return;
        }
        context.go(RoutePaths.adminDrivers);
      },
      actions: [
        _HeaderStatusChip(isActive: isActive),
        const SizedBox(width: 4),
        PopupMenuButton<_DriverMenuAction>(
          tooltip: 'Driver actions',
          icon: Icon(
            Icons.more_vert_rounded,
            size: 20,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          onSelected: (value) async {
            switch (value) {
              case _DriverMenuAction.refresh:
                await controller.refreshCurrentTab();
                break;
              case _DriverMenuAction.toggleStatus:
                final current =
                    driver?.isActive ?? (initialDriver?.isActive ?? false);
                final ok = await controller.updateStatus(!current);
                if (context.mounted) {
                  if (ok) {
                    ToastHelper.showSuccess(
                      !current ? 'Driver activated.' : 'Driver deactivated.',
                      context: context,
                    );
                  } else {
                    ToastHelper.showError(
                      ref.read(provider).sectionErrorMessage ??
                          'Unable to update status.',
                      context: context,
                    );
                  }
                }
                break;
              case _DriverMenuAction.delete:
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (dialogContext) {
                    return AlertDialog(
                      title: const Text('Delete driver account'),
                      content: Text(
                        'Delete ${driver?.name ?? initialDriver?.firstName ?? 'this driver'}? '
                        'This removes the driver account and assignments.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () =>
                              Navigator.of(dialogContext).pop(false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () =>
                              Navigator.of(dialogContext).pop(true),
                          style: TextButton.styleFrom(
                            foregroundColor: OpenVtsColors.error,
                          ),
                          child: const Text('Delete'),
                        ),
                      ],
                    );
                  },
                );
                if (confirmed != true) break;
                final ok = await controller.deleteDriver();
                if (context.mounted) {
                  if (ok) {
                    ToastHelper.showSuccess('Driver deleted.',
                        context: context);
                    ref.invalidate(adminDriversControllerProvider);
                    context.go(RoutePaths.adminDrivers);
                  } else {
                    ToastHelper.showError(
                      ref.read(provider).sectionErrorMessage ??
                          'Unable to delete driver.',
                      context: context,
                    );
                  }
                }
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: _DriverMenuAction.refresh,
              height: 40,
              child: _MenuRow(icon: Icons.refresh_rounded, label: 'Refresh'),
            ),
            PopupMenuItem(
              value: _DriverMenuAction.toggleStatus,
              height: 40,
              child: _MenuRow(
                icon: (driver?.isActive ?? initialDriver?.isActive ?? false)
                    ? Icons.toggle_off_outlined
                    : Icons.toggle_on_outlined,
                label: (driver?.isActive ?? initialDriver?.isActive ?? false)
                    ? 'Set Inactive'
                    : 'Set Active',
              ),
            ),
            const PopupMenuDivider(height: 1),
            const PopupMenuItem(
              value: _DriverMenuAction.delete,
              height: 40,
              child: _MenuRow(
                icon: Icons.delete_outline_rounded,
                label: 'Delete Account',
                destructive: true,
              ),
            ),
          ],
        ),
        const SizedBox(width: 4),
      ],
      body: RefreshIndicator(
        onRefresh: controller.refreshCurrentTab,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(OpenVtsSpacing.sm),
          children: [
            if (state.isLoadingDriver &&
                driver == null &&
                initialDriver == null)
              const SizedBox(height: 220, child: OpenVtsLoader())
            else if (state.errorMessage != null &&
                driver == null &&
                initialDriver == null)
              OpenVtsErrorView(
                message: state.errorMessage!,
                onRetry: controller.loadInitial,
              )
            else
              _SummaryCard(driver: driver, initialDriver: initialDriver),
            const SizedBox(height: OpenVtsSpacing.sm),
            _TabChips(
              selected: state.selectedTab,
              onSelect: controller.selectTab,
            ),
            const SizedBox(height: OpenVtsSpacing.sm),
            _TabContent(state: state, provider: provider),
          ],
        ),
      ),
    );
  }
}

enum _DriverMenuAction { refresh, toggleStatus, delete }

class _HeaderStatusChip extends StatelessWidget {
  const _HeaderStatusChip({required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isActive
        ? Theme.of(context).colorScheme.primaryContainer
        : Theme.of(context).colorScheme.surfaceContainerHighest;
    final foregroundColor = isActive
        ? Theme.of(context).colorScheme.onPrimaryContainer
        : Theme.of(context).colorScheme.outline;
    final borderColor = isActive
        ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.25)
        : Theme.of(context).colorScheme.outlineVariant;
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(OpenVtsRadius.pill),
          border: Border.all(color: borderColor),
        ),
        child: Text(
          isActive ? 'Active' : 'Inactive',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: foregroundColor,
          ),
        ),
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  const _MenuRow({
    required this.icon,
    required this.label,
    this.destructive = false,
  });

  final IconData icon;
  final String label;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final color = destructive
        ? OpenVtsColors.error
        : Theme.of(context).colorScheme.onSurface;
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: OpenVtsSpacing.xs),
        Text(label, style: TextStyle(color: color, fontSize: 12.5)),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.driver, required this.initialDriver});

  final dynamic driver;
  final AdminDriverListItem? initialDriver;

  @override
  Widget build(BuildContext context) {
    final name = driver?.name ?? initialDriver?.firstName ?? 'Driver';
    final username = driver?.username ?? initialDriver?.username ?? '—';
    final email = driver?.email ?? '—';
    final phone = driver?.phone ?? initialDriver?.phone ?? '—';
    final isActive = driver?.isActive ?? initialDriver?.isActive ?? false;
    final isVerified = driver?.isVerified ?? false;

    return OpenVtsCard(
      padding: const EdgeInsets.all(OpenVtsSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 56,
                height: 56,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? OpenVtsColors.darkSurface
                      : OpenVtsColors.background,
                  borderRadius: BorderRadius.circular(OpenVtsRadius.pill),
                  border: Border.all(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? OpenVtsColors.darkBorder
                        : OpenVtsColors.border,
                  ),
                ),
                child: Text(
                  _initials(name),
                  style: OpenVtsTypography.label.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              const SizedBox(width: OpenVtsSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: OpenVtsTypography.body.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: OpenVtsSpacing.xs),
                        _StatusBadge(isActive: isActive),
                      ],
                    ),
                    const SizedBox(height: OpenVtsSpacing.xxs),
                    Text(
                      '@$username',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: OpenVtsTypography.meta.copyWith(
                        color: OpenVtsColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: OpenVtsSpacing.sm),
          Divider(
            height: 1,
            color: Theme.of(context).brightness == Brightness.dark
                ? OpenVtsColors.darkBorder
                : OpenVtsColors.border,
          ),
          const SizedBox(height: OpenVtsSpacing.sm),
          _SummaryEmailRow(
            email: email,
            isVerified: isVerified,
          ),
          const SizedBox(height: OpenVtsSpacing.xs),
          _SummaryRow(
            icon: Icons.phone_outlined,
            label: 'Phone',
            value: phone,
          ),
          const SizedBox(height: OpenVtsSpacing.xs),
          const _SummaryRow(
            icon: Icons.badge_outlined,
            label: 'Role',
            value: 'Driver',
          ),
        ],
      ),
    );
  }

  String _initials(String text) {
    final parts =
        text.trim().split(RegExp(r'\s+')).where((e) => e.isNotEmpty).toList();
    if (parts.isEmpty) return '--';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isActive
        ? Theme.of(context).colorScheme.primaryContainer
        : Theme.of(context).colorScheme.surfaceContainerHighest;
    final foregroundColor = isActive
        ? Theme.of(context).colorScheme.onPrimaryContainer
        : Theme.of(context).colorScheme.outline;
    final borderColor = isActive
        ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.25)
        : Theme.of(context).colorScheme.outlineVariant;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(OpenVtsRadius.pill),
        border: Border.all(color: borderColor),
      ),
      child: Text(
        isActive ? 'Active' : 'Inactive',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: foregroundColor,
        ),
      ),
    );
  }
}

class _SummaryEmailRow extends StatelessWidget {
  const _SummaryEmailRow({
    required this.email,
    required this.isVerified,
  });

  final String email;
  final bool isVerified;

  @override
  Widget build(BuildContext context) {
    final displayEmail = email.trim().isEmpty ? '—' : email;
    final verifiedColor =
        isVerified ? OpenVtsColors.success : OpenVtsColors.textTertiary;
    final verifiedIcon =
        isVerified ? Icons.verified_rounded : Icons.error_outline_rounded;
    final tooltip = isVerified ? 'Email verified' : 'Email unverified';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.mail_outline_rounded,
            size: 14, color: OpenVtsColors.textTertiary),
        const SizedBox(width: 8),
        SizedBox(
          width: 56,
          child: Text(
            'Email',
            style: OpenVtsTypography.meta.copyWith(
              color: OpenVtsColors.textTertiary,
              fontSize: 11,
            ),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                displayEmail,
                style: OpenVtsTypography.meta.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                  height: 1.3,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 6),
            Tooltip(
              message: tooltip,
              child: Icon(
                verifiedIcon,
                size: 14,
                color: verifiedColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: OpenVtsColors.textTertiary),
        const SizedBox(width: 8),
        SizedBox(
          width: 56,
          child: Text(
            label,
            style: OpenVtsTypography.meta.copyWith(
              color: OpenVtsColors.textTertiary,
              fontSize: 11,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value.trim().isEmpty ? '—' : value,
            style: OpenVtsTypography.meta.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w500,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}

class _TabChips extends StatelessWidget {
  const _TabChips({required this.selected, required this.onSelect});

  final AdminDriverDetailsTab selected;
  final ValueChanged<AdminDriverDetailsTab> onSelect;

  @override
  Widget build(BuildContext context) {
    return OpenVtsDetailTabStrip<AdminDriverDetailsTab>(
      selected: selected,
      onChanged: onSelect,
      tabs: const [
        OpenVtsDetailTabOption(
          value: AdminDriverDetailsTab.profile,
          label: 'Profile',
          icon: Icons.person_outline_rounded,
        ),
        OpenVtsDetailTabOption(
          value: AdminDriverDetailsTab.documents,
          label: 'Documents',
          icon: Icons.description_outlined,
        ),
        OpenVtsDetailTabOption(
          value: AdminDriverDetailsTab.users,
          label: 'Users',
          icon: Icons.group_outlined,
        ),
      ],
    );
  }
}

class _TabContent extends ConsumerWidget {
  const _TabContent({required this.state, required this.provider});

  final AdminDriverDetailsState state;
  final AutoDisposeStateNotifierProvider<AdminDriverDetailsController,
      AdminDriverDetailsState> provider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    switch (state.selectedTab) {
      case AdminDriverDetailsTab.profile:
        return AdminDriverProfileTab(provider: provider, state: state);
      case AdminDriverDetailsTab.documents:
        return AdminDriverDocumentsTab(provider: provider, state: state);
      case AdminDriverDetailsTab.users:
        return AdminDriverUsersTab(provider: provider, state: state);
    }
  }
}
