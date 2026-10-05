import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/open_vts_colors.dart';
import '../../../../core/theme/open_vts_radius.dart';
import '../../../../core/theme/open_vts_spacing.dart';
import '../../../../core/theme/open_vts_typography.dart';
import '../../../../shared/helpers/mobile_text.dart';
import '../../../../shared/helpers/toast_helper.dart';
import '../../../../shared/models/user_role.dart';
import '../../../../shared/widgets/open_vts_bottom_sheet.dart';
import '../../../../shared/widgets/open_vts_button.dart';
import '../../../../shared/widgets/open_vts_card.dart';
import '../../../../shared/widgets/open_vts_page_scaffold.dart';
import '../../../../shared/widgets/open_vts_text_field.dart';
import '../../../auth/controllers/auth_controller.dart';
import '../../controllers/admin_providers.dart';
import '../../controllers/admin_user_details_controller.dart';
import '../../models/admin_user_details_model.dart';
import '../../models/admin_user_details_state.dart';
import '../../models/admin_users_model.dart' show AdminUserListItem;
import '../../widgets/admin_action_gate.dart';
import 'widgets/admin_user_documents_tab.dart';
import 'widgets/admin_user_drivers_tab.dart';
import 'widgets/admin_user_logs_tab.dart';
import 'widgets/admin_user_payments_tab.dart';
import 'widgets/admin_user_permissions_sheet.dart';
import 'widgets/admin_user_profile_tab.dart';
import 'widgets/admin_user_tickets_tab.dart';
import 'widgets/admin_user_vehicles_tab.dart';

class AdminUserDetailsScreen extends ConsumerStatefulWidget {
  const AdminUserDetailsScreen({
    super.key,
    required this.userId,
    this.initialUser,
  });

  final String userId;
  final AdminUserListItem? initialUser;

  @override
  ConsumerState<AdminUserDetailsScreen> createState() =>
      _AdminUserDetailsScreenState();
}

class _AdminUserDetailsScreenState
    extends ConsumerState<AdminUserDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = ref.read(
        adminUserDetailsControllerProvider(widget.userId).notifier,
      );
      // Seed initial data if available
      if (widget.initialUser != null) {
        controller.seedInitialData(lastLogin: widget.initialUser!.updatedAt);
      }
      // Ensure vehicle count is loaded early for summary card (don't wait for Vehicle tab)
      controller.ensureVehicleCountLoaded();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = adminUserDetailsControllerProvider(widget.userId);
    final state = ref.watch(provider);
    final controller = ref.read(provider.notifier);
    final user = _UserSnapshot.resolve(
      details: state.user,
      fallback: widget.initialUser,
      userId: widget.userId,
      effectiveIsActive: state.effectiveIsActive,
    );

    return OpenVtsPageScaffold(
      title: user.title,
      headerMode: OpenVtsPageHeaderMode.closeable,
      onClose: _close,
      padding: const EdgeInsetsDirectional.fromSTEB(
        OpenVtsSpacing.sm,
        OpenVtsSpacing.sm,
        OpenVtsSpacing.sm,
        OpenVtsSpacing.xs,
      ),
      actions: [
        if (ref.watch(authControllerProvider).user?.role == UserRole.admin)
          IconButton(
            tooltip: context.mobileText('Permissions'),
            icon: const Icon(Icons.admin_panel_settings_outlined),
            onPressed: () => OpenVtsBottomSheet.show<void>(
              context: context,
              title: context.mobileText('Permissions'),
              initialChildSize: 0.9,
              minChildSize: 0.5,
              maxChildSize: 0.96,
              child: AdminUserPermissionsSheet(userId: widget.userId),
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(right: OpenVtsSpacing.xxs),
          child: Center(child: _StatusChip(isActive: user.isActive)),
        ),
        _HeaderMenu(
          isActive: user.isActive,
          isBusy:
              state.isUpdatingStatus ||
              state.isChangingPassword ||
              state.isLoadingProfile,
          onRefresh: () => controller.refreshCurrentTab(),
          onEditProfile: () => _showEditProfileSheet(),
          onEditCompany: () => _showEditCompanySheet(),
          onToggleStatus: () => _toggleStatus(user),
          onChangePassword: () => _showPasswordSheet(),
          onLoginAsUser: () => _loginAsUser(user),
          onDelete: () => _confirmDelete(user),
        ),
        const SizedBox(width: OpenVtsSpacing.xs),
      ],
      body: RefreshIndicator(
        onRefresh: controller.refreshCurrentTab,
        child: ListView(
          padding: EdgeInsets.zero,
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            if (state.isLoadingProfile && !user.hasKnownData)
              const _SummarySkeleton()
            else
              _SummaryCard(
                user: user,
                isSyncing: state.isLoadingProfile,
                resolvedVehicleCount: state.resolvedVehicleCount,
              ),
            if (state.errorMessage != null && !user.hasKnownData) ...[
              const SizedBox(height: OpenVtsSpacing.sm),
              _SectionErrorCard(
                message: state.errorMessage!,
                onRetry: controller.loadProfile,
              ),
            ],
            const SizedBox(height: OpenVtsSpacing.sm),
            _TabChips(
              selected: state.selectedTab,
              onSelect: controller.selectTab,
            ),
            const SizedBox(height: OpenVtsSpacing.sm),
            _TabContent(
              state: state,
              userId: widget.userId,
              initialUser: widget.initialUser,
              controller: controller,
            ),
            const SizedBox(height: OpenVtsSpacing.lg),
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
    context.go(RoutePaths.adminUsers);
  }

  Future<void> _toggleStatus(_UserSnapshot user) async {
    final controller = ref.read(
      adminUserDetailsControllerProvider(widget.userId).notifier,
    );
    final next = !user.isActive;
    final ok = await controller.updateStatus(next);
    if (!mounted) {
      return;
    }
    if (ok) {
      ToastHelper.showSuccess(
        next
            ? context.mobileText('User activated.')
            : context.mobileText('User deactivated.'),
        context: context,
      );
    } else {
      final state = ref.read(adminUserDetailsControllerProvider(widget.userId));
      ToastHelper.showError(
        state.sectionErrorMessage ?? 'Unable to update user status.',
        context: context,
      );
    }
  }

  Future<void> _showPasswordSheet() {
    final provider = adminUserDetailsControllerProvider(widget.userId);
    return OpenVtsBottomSheet.show<void>(
      context: context,
      title: context.mobileText('Change Password'),
      initialChildSize: 0.46,
      minChildSize: 0.36,
      maxChildSize: 0.72,
      child: Consumer(
        builder: (sheetContext, ref, child) {
          final state = ref.watch(provider);
          return _PasswordSheet(
            isSubmitting: state.isChangingPassword,
            errorMessage: state.sectionErrorMessage,
            onSubmit: (password) async {
              final ok = await ref
                  .read(provider.notifier)
                  .updatePassword(password);
              if (!sheetContext.mounted) {
                return;
              }
              if (ok) {
                Navigator.of(sheetContext).pop();
                if (!mounted) {
                  return;
                }
                ToastHelper.showSuccess(
                  context.mobileText('Password updated.'),
                  context: context,
                );
              } else {
                ToastHelper.showError(
                  ref.read(provider).sectionErrorMessage ??
                      'Unable to update password.',
                  context: sheetContext,
                );
              }
            },
          );
        },
      ),
    );
  }

  Future<void> _showEditProfileSheet() {
    final provider = adminUserDetailsControllerProvider(widget.userId);
    final controller = ref.read(provider.notifier);
    final state = ref.read(provider);
    return showAdminUserEditProfileSheet(
      context: context,
      ref: ref,
      userId: widget.userId,
      details: state.user,
      fallback: widget.initialUser,
      controller: controller,
    );
  }

  Future<void> _showEditCompanySheet() {
    final provider = adminUserDetailsControllerProvider(widget.userId);
    final controller = ref.read(provider.notifier);
    final state = ref.read(provider);
    return showAdminUserEditCompanySheet(
      context: context,
      ref: ref,
      userId: widget.userId,
      details: state.user,
      fallback: widget.initialUser,
      controller: controller,
    );
  }

  Future<void> _loginAsUser(_UserSnapshot user) async {
    try {
      await ref
          .read(adminUsersControllerProvider.notifier)
          .loginAsUser(user.id);
      if (!mounted) {
        return;
      }
      ToastHelper.showSuccess(
        context.mobileText("Signed in as {value1}.", {
          'value1': (user.displayName).toString(),
        }),
        context: context,
      );
      context.go(RoutePaths.userHome);
    } catch (_) {
      if (!mounted) {
        return;
      }
      ToastHelper.showError(
        ref.read(adminUsersControllerProvider).errorMessage ??
            'Unable to login as user.',
        context: context,
      );
    }
  }

  Future<void> _confirmDelete(_UserSnapshot user) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(context.mobileText('Delete user')),
          content: Text(
            context.mobileText(
              "Remove {value1} from this administrator account?",
              {'value1': (user.displayName).toString()},
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(context.mobileText('Cancel')),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: TextButton.styleFrom(foregroundColor: OpenVtsColors.error),
              child: Text(context.mobileText('Delete')),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    try {
      await ref.read(adminUsersControllerProvider.notifier).deleteUser(user.id);
      if (!mounted) {
        return;
      }
      ToastHelper.showSuccess(
        context.mobileText('User deleted.'),
        context: context,
      );
      context.go(RoutePaths.adminUsers);
    } catch (_) {
      if (!mounted) {
        return;
      }
      ToastHelper.showError(
        ref.read(adminUsersControllerProvider).errorMessage ??
            'Unable to delete user.',
        context: context,
      );
    }
  }
}

enum _HeaderMenuAction {
  refresh,
  editProfile,
  editCompany,
  toggleStatus,
  changePassword,
  loginAsUser,
  deleteUser,
}

class _HeaderMenu extends ConsumerWidget {
  const _HeaderMenu({
    required this.isActive,
    required this.isBusy,
    required this.onRefresh,
    required this.onEditProfile,
    required this.onEditCompany,
    required this.onToggleStatus,
    required this.onChangePassword,
    required this.onLoginAsUser,
    required this.onDelete,
  });

  final bool isActive;
  final bool isBusy;
  final VoidCallback onRefresh;
  final VoidCallback onEditProfile;
  final VoidCallback onEditCompany;
  final VoidCallback onToggleStatus;
  final VoidCallback onChangePassword;
  final VoidCallback onLoginAsUser;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<_HeaderMenuAction>(
      tooltip: context.mobileText('User actions'),
      enabled: !isBusy,
      icon: const Icon(
        Icons.more_vert_rounded,
        size: 20,
        color: OpenVtsColors.textSecondary,
      ),
      onSelected: (action) {
        switch (action) {
          case _HeaderMenuAction.refresh:
            onRefresh();
          case _HeaderMenuAction.editProfile:
            onEditProfile();
          case _HeaderMenuAction.editCompany:
            onEditCompany();
          case _HeaderMenuAction.toggleStatus:
            onToggleStatus();
          case _HeaderMenuAction.changePassword:
            onChangePassword();
          case _HeaderMenuAction.loginAsUser:
            onLoginAsUser();
          case _HeaderMenuAction.deleteUser:
            onDelete();
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: _HeaderMenuAction.refresh,
          height: 40,
          child: _MenuRow(
            icon: Icons.refresh_rounded,
            label: context.mobileText('Refresh'),
          ),
        ),
        if (adminCanPerform(ref, 'users.update'))
          PopupMenuItem(
            value: _HeaderMenuAction.editProfile,
            height: 40,
            child: _MenuRow(
              icon: Icons.edit_outlined,
              label: context.mobileText('Edit Profile'),
            ),
          ),
        if (adminCanPerform(ref, 'users.update'))
          PopupMenuItem(
            value: _HeaderMenuAction.editCompany,
            height: 40,
            child: _MenuRow(
              icon: Icons.apartment_outlined,
              label: context.mobileText('Edit Company'),
            ),
          ),
        if (adminCanPerform(ref, 'users.update'))
          PopupMenuItem(
            value: _HeaderMenuAction.toggleStatus,
            height: 40,
            child: _MenuRow(
              icon: isActive
                  ? Icons.toggle_off_outlined
                  : Icons.toggle_on_outlined,
              label: isActive
                  ? context.mobileText('Deactivate')
                  : context.mobileText('Activate'),
            ),
          ),
        if (adminCanPerform(ref, 'users.update'))
          PopupMenuItem(
            value: _HeaderMenuAction.changePassword,
            height: 40,
            child: _MenuRow(
              icon: Icons.key_rounded,
              label: context.mobileText('Change Password'),
            ),
          ),
        if (adminCanPerform(ref, 'users.update'))
          PopupMenuItem(
            value: _HeaderMenuAction.loginAsUser,
            height: 40,
            child: _MenuRow(
              icon: Icons.login_rounded,
              label: context.mobileText('Login as User'),
            ),
          ),
        const PopupMenuDivider(height: 8),
        if (adminCanPerform(ref, 'users.delete'))
          PopupMenuItem(
            value: _HeaderMenuAction.deleteUser,
            height: 40,
            child: _MenuRow(
              icon: Icons.delete_outline_rounded,
              label: context.mobileText('Delete User'),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isDestructive
        ? OpenVtsColors.error
        : (isDark ? OpenVtsColors.white : OpenVtsColors.textPrimary);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: OpenVtsSpacing.xs),
        Text(label, style: OpenVtsTypography.label.copyWith(color: color)),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.user,
    required this.isSyncing,
    required this.resolvedVehicleCount,
  });

  final _UserSnapshot user;
  final bool isSyncing;
  final int? resolvedVehicleCount;

  @override
  Widget build(BuildContext context) {
    return OpenVtsCard(
      padding: const EdgeInsets.all(OpenVtsSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 44,
                width: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                ),
                child: Text(
                  user.initials,
                  style: TextStyle(
                    fontSize: 16,
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
                    Text(
                      user.displayName,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.onSurface,
                        height: 1.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (user.username.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        '@${user.username}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
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
                  _StatusChip(isActive: user.isActive),
                  if (user.isEmailVerified) ...[
                    const SizedBox(height: 4),
                    _MicroChip(
                      label: context.mobileText('Verified'),
                      icon: Icons.verified_outlined,
                      color: OpenVtsColors.success,
                    ),
                  ],
                ],
              ),
            ],
          ),
          if (user.email.isNotEmpty || user.phone.isNotEmpty) ...[
            const SizedBox(height: OpenVtsSpacing.sm),
            if (user.email.isNotEmpty)
              _ContactLineWithVerification(
                icon: Icons.mail_outline_rounded,
                text: user.email,
                isVerified: user.isEmailVerified,
              ),
            if (user.email.isNotEmpty && user.phone.isNotEmpty)
              const SizedBox(height: 4),
            if (user.phone.isNotEmpty)
              _CompactInfoLine(icon: Icons.phone_outlined, value: user.phone),
          ],
          const SizedBox(height: OpenVtsSpacing.md),
          Divider(
            height: 1,
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
          const SizedBox(height: OpenVtsSpacing.md),
          Row(
            children: [
              Expanded(
                child: _MetricTile(
                  icon: Icons.directions_car_outlined,
                  label: context.mobileText('Vehicles'),
                  value: resolvedVehicleCount == null
                      ? '—'
                      : resolvedVehicleCount.toString(),
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
                    icon: Icons.apartment_outlined,
                    label: context.mobileText('Company'),
                    value: _displayValue(user.company),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummarySkeleton extends StatelessWidget {
  const _SummarySkeleton();

  @override
  Widget build(BuildContext context) {
    return const OpenVtsCard(
      padding: EdgeInsets.all(OpenVtsSpacing.sm),
      child: Row(
        children: [
          _SkeletonBox(width: 46, height: 46, radius: OpenVtsRadius.pill),
          SizedBox(width: OpenVtsSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SkeletonBox(width: 140, height: 14),
                SizedBox(height: OpenVtsSpacing.xs),
                _SkeletonBox(width: 96, height: 11),
                SizedBox(height: OpenVtsSpacing.sm),
                _SkeletonBox(width: double.infinity, height: 11),
                SizedBox(height: OpenVtsSpacing.xs),
                _SkeletonBox(width: 180, height: 11),
              ],
            ),
          ),
        ],
      ),
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
        ? (isDark ? OpenVtsColors.white : OpenVtsColors.brandInk)
        : Theme.of(context).colorScheme.outline;
    return _MicroChip(
      label: isActive
          ? context.mobileText('Active')
          : context.mobileText('Inactive'),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.15 : 0.06),
        borderRadius: BorderRadius.circular(OpenVtsRadius.pill),
        border: Border.all(
          color: color.withValues(alpha: isDark ? 0.35 : 0.22),
        ),
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

class _ContactLineWithVerification extends StatelessWidget {
  const _ContactLineWithVerification({
    required this.icon,
    required this.text,
    required this.isVerified,
  });

  final IconData icon;
  final String text;
  final bool isVerified;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: OpenVtsSpacing.xxs),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Theme.of(context).colorScheme.outline),
          const SizedBox(width: OpenVtsSpacing.xs),
          Flexible(
            child: Text(
              _displayValue(text),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: OpenVtsTypography.meta.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 4),
          Tooltip(
            message: isVerified
                ? context.mobileText('Email verified')
                : context.mobileText('Email unverified'),
            child: Icon(
              isVerified
                  ? Icons.check_circle_rounded
                  : Icons.error_outline_rounded,
              size: 15,
              color: isVerified ? OpenVtsColors.success : OpenVtsColors.warning,
            ),
          ),
        ],
      ),
    );
  }
}

class _CompactInfoLine extends StatelessWidget {
  const _CompactInfoLine({required this.icon, required this.value});

  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: OpenVtsSpacing.xxs),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Theme.of(context).colorScheme.outline),
          const SizedBox(width: OpenVtsSpacing.xs),
          Expanded(
            child: Text(
              _displayValue(value),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: OpenVtsTypography.meta.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
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
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: OpenVtsSpacing.sm,
        vertical: OpenVtsSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(OpenVtsRadius.md),
        border: Border.all(
          color: Theme.of(
            context,
          ).colorScheme.outlineVariant.withValues(alpha: 0.7),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: OpenVtsSpacing.xs),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.onSurface,
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

  final AdminUserDetailsTab selected;
  final ValueChanged<AdminUserDetailsTab> onSelect;

  @override
  Widget build(BuildContext context) {
    const tabs = AdminUserDetailsTab.values;
    return SizedBox(
      height: 32,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: tabs.length,
        separatorBuilder: (context, index) =>
            const SizedBox(width: OpenVtsSpacing.xs),
        itemBuilder: (context, index) {
          final tab = tabs[index];
          return _TabChip(
            tab: tab,
            isSelected: tab == selected,
            onTap: () => onSelect(tab),
          );
        },
      ),
    );
  }
}

class _TabChip extends StatelessWidget {
  const _TabChip({
    required this.tab,
    required this.isSelected,
    required this.onTap,
  });

  final AdminUserDetailsTab tab;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final background = isSelected
        ? OpenVtsColors.brandInk
        : Theme.of(context).colorScheme.surface;
    final foreground = isSelected
        ? (isDark ? OpenVtsColors.darkTextPrimary : OpenVtsColors.white)
        : Theme.of(context).colorScheme.onSurface;
    final borderColor = isSelected
        ? OpenVtsColors.brandInk
        : Theme.of(context).colorScheme.outlineVariant;
    return Material(
      color: background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(OpenVtsRadius.pill),
        side: BorderSide(color: borderColor),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(OpenVtsRadius.pill),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(tab.icon, size: 14, color: foreground),
              const SizedBox(width: 5),
              Text(
                tab.label,
                style: OpenVtsTypography.meta.copyWith(
                  color: foreground,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabContent extends StatelessWidget {
  const _TabContent({
    required this.state,
    required this.userId,
    required this.initialUser,
    required this.controller,
  });

  final AdminUserDetailsState state;
  final String userId;
  final AdminUserListItem? initialUser;
  final AdminUserDetailsController controller;

  @override
  Widget build(BuildContext context) {
    switch (state.selectedTab) {
      case AdminUserDetailsTab.profile:
        return AdminUserProfileTab(userId: userId, initialUser: initialUser);
      case AdminUserDetailsTab.vehicles:
        return AdminUserVehiclesTab(userId: userId);
      case AdminUserDetailsTab.drivers:
        return AdminUserDriversTab(userId: userId);
      case AdminUserDetailsTab.documents:
        return AdminUserDocumentsTab(userId: userId);
      case AdminUserDetailsTab.tickets:
        return AdminUserTicketsTab(userId: userId);
      case AdminUserDetailsTab.payments:
        return AdminUserPaymentsTab(userId: userId);
      case AdminUserDetailsTab.logs:
        return AdminUserLogsTab(userId: userId);
    }
  }
}

class _SectionErrorCard extends StatelessWidget {
  const _SectionErrorCard({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return OpenVtsCard(
      padding: const EdgeInsets.all(OpenVtsSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.error_outline_rounded,
                size: 17,
                color: OpenVtsColors.error,
              ),
              const SizedBox(width: OpenVtsSpacing.xs),
              Expanded(
                child: Text(
                  context.mobileText('Unable to load'),
                  style: OpenVtsTypography.label.copyWith(
                    color: OpenVtsColors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: OpenVtsSpacing.xs),
          Text(
            message,
            style: OpenVtsTypography.meta.copyWith(
              color: OpenVtsColors.textSecondary,
            ),
          ),
          const SizedBox(height: OpenVtsSpacing.sm),
          OpenVtsButton(
            label: context.mobileText('Retry'),
            height: 34,
            variant: OpenVtsButtonVariant.secondary,
            onPressed: onRetry,
          ),
        ],
      ),
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  const _SkeletonBox({
    required this.width,
    required this.height,
    this.radius = OpenVtsRadius.sm,
  });

  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: OpenVtsColors.surface,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

class _PasswordSheet extends StatefulWidget {
  const _PasswordSheet({
    required this.isSubmitting,
    required this.errorMessage,
    required this.onSubmit,
  });

  final bool isSubmitting;
  final String? errorMessage;
  final Future<void> Function(String password) onSubmit;

  @override
  State<_PasswordSheet> createState() => _PasswordSheetState();
}

class _PasswordSheetState extends State<_PasswordSheet> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  var _obscurePassword = true;
  var _obscureConfirm = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(OpenVtsSpacing.md),
        children: [
          OpenVtsTextField(
            label: context.mobileText('New password'),
            controller: _passwordController,
            obscureText: _obscurePassword,
            textInputAction: TextInputAction.next,
            prefixIcon: Icons.lock_outline_rounded,
            suffixIcon: IconButton(
              tooltip: _obscurePassword
                  ? context.mobileText('Show password')
                  : context.mobileText('Hide password'),
              onPressed: () {
                setState(() => _obscurePassword = !_obscurePassword);
              },
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                size: 18,
              ),
            ),
            validator: _passwordValidator,
          ),
          const SizedBox(height: OpenVtsSpacing.sm),
          OpenVtsTextField(
            label: context.mobileText('Confirm password'),
            controller: _confirmController,
            obscureText: _obscureConfirm,
            textInputAction: TextInputAction.done,
            prefixIcon: Icons.lock_reset_rounded,
            suffixIcon: IconButton(
              tooltip: _obscureConfirm
                  ? context.mobileText('Show password')
                  : context.mobileText('Hide password'),
              onPressed: () {
                setState(() => _obscureConfirm = !_obscureConfirm);
              },
              icon: Icon(
                _obscureConfirm
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                size: 18,
              ),
            ),
            validator: _confirmValidator,
          ),
          if (widget.errorMessage != null) ...[
            const SizedBox(height: OpenVtsSpacing.sm),
            Text(
              widget.errorMessage!,
              style: OpenVtsTypography.meta.copyWith(
                color: OpenVtsColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          const SizedBox(height: OpenVtsSpacing.lg),
          OpenVtsButton(
            label: context.mobileText('Update Password'),
            height: 40,
            isLoading: widget.isSubmitting,
            onPressed: widget.isSubmitting ? null : _submit,
            trailingIcon: Icons.check_rounded,
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    await widget.onSubmit(_passwordController.text);
  }

  String? _passwordValidator(String? value) {
    final normalized = value ?? '';
    if (normalized.isEmpty) {
      return 'Required';
    }
    if (normalized.length < 8) {
      return 'Use at least 8 characters';
    }
    return null;
  }

  String? _confirmValidator(String? value) {
    final normalized = value ?? '';
    if (normalized.isEmpty) {
      return 'Required';
    }
    if (normalized != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }
}

class _UserSnapshot {
  const _UserSnapshot({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.phone,
    required this.isActive,
    required this.isEmailVerified,
    required this.company,
    required this.location,
    required this.countryCode,
    required this.stateCode,
    required this.city,
    required this.pincode,
    required this.createdAt,
    required this.updatedAt,
    required this.vehicleCount,
  });

  final String id;
  final String name;
  final String username;
  final String email;
  final String phone;
  final bool isActive;
  final bool isEmailVerified;
  final String company;
  final String location;
  final String countryCode;
  final String stateCode;
  final String city;
  final String pincode;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? vehicleCount;

  bool get hasKnownData =>
      name.isNotEmpty || username.isNotEmpty || email.isNotEmpty;

  String get displayName {
    if (name.trim().isNotEmpty) {
      return name.trim();
    }
    if (username.trim().isNotEmpty) {
      return username.trim();
    }
    if (email.trim().isNotEmpty) {
      return email.trim();
    }
    return 'User';
  }

  String get title {
    if (name.trim().isNotEmpty) {
      return name.trim();
    }
    if (username.trim().isNotEmpty) {
      return username.trim();
    }
    if (email.trim().isNotEmpty) {
      return email.trim();
    }
    return 'User';
  }

  String get usernameLabel {
    if (username.trim().isNotEmpty) {
      return '@${username.trim()}';
    }
    if (email.trim().isNotEmpty) {
      return email.trim();
    }
    return 'ID ${id.trim()}';
  }

  String get initials {
    final source = displayName;
    final words = source.split(RegExp(r'\s+'));
    if (words.length == 1) {
      return words.first.characters.take(2).toString().toUpperCase();
    }
    return '${words.first.characters.first}${words.last.characters.first}'
        .toUpperCase();
  }

  static _UserSnapshot resolve({
    required AdminUserDetails? details,
    required AdminUserListItem? fallback,
    required String userId,
    required bool effectiveIsActive,
  }) {
    if (details != null) {
      final address = details.address;
      final company = details.companies.isNotEmpty
          ? details.companies.first.name
          : details.organization;
      return _UserSnapshot(
        id: details.id.isNotEmpty ? details.id : userId,
        name: details.name,
        username: details.username,
        email: details.email,
        phone: details.mobileDisplay,
        isActive: effectiveIsActive,
        isEmailVerified: details.isEmailVerified,
        company: company,
        location: details.location,
        countryCode: details.countryCode,
        stateCode: address?.stateCode ?? '',
        city: address?.cityName ?? '',
        pincode: address?.pincode ?? '',
        createdAt: details.createdAt,
        updatedAt: details.updatedAt,
        vehicleCount: details.vehicleCount,
      );
    }

    if (fallback != null) {
      return _UserSnapshot(
        id: fallback.id.isNotEmpty ? fallback.id : userId,
        name: fallback.name,
        username: fallback.username,
        email: fallback.email,
        phone: fallback.mobileDisplay,
        isActive: effectiveIsActive,
        isEmailVerified: fallback.isEmailVerified,
        company: fallback.companyName,
        location: fallback.location,
        countryCode: fallback.countryCode,
        stateCode: fallback.stateCode,
        city: fallback.city,
        pincode: fallback.pincode,
        createdAt: fallback.createdAt,
        updatedAt: fallback.updatedAt,
        vehicleCount: fallback.vehicleCount,
      );
    }

    return _UserSnapshot(
      id: userId,
      name: '',
      username: '',
      email: '',
      phone: '',
      isActive: effectiveIsActive,
      isEmailVerified: false,
      company: '',
      location: '',
      countryCode: '',
      stateCode: '',
      city: '',
      pincode: '',
      createdAt: null,
      updatedAt: null,
      vehicleCount: null,
    );
  }
}

extension _AdminUserDetailsTabX on AdminUserDetailsTab {
  String get label {
    switch (this) {
      case AdminUserDetailsTab.profile:
        return 'Profile';
      case AdminUserDetailsTab.vehicles:
        return 'Vehicles';
      case AdminUserDetailsTab.drivers:
        return 'Drivers';
      case AdminUserDetailsTab.documents:
        return 'Documents';
      case AdminUserDetailsTab.tickets:
        return 'Tickets';
      case AdminUserDetailsTab.payments:
        return 'Payments';
      case AdminUserDetailsTab.logs:
        return 'Logs';
    }
  }

  IconData get icon {
    switch (this) {
      case AdminUserDetailsTab.profile:
        return Icons.person_outline_rounded;
      case AdminUserDetailsTab.vehicles:
        return Icons.directions_car_filled_outlined;
      case AdminUserDetailsTab.drivers:
        return Icons.badge_outlined;
      case AdminUserDetailsTab.documents:
        return Icons.description_outlined;
      case AdminUserDetailsTab.tickets:
        return Icons.confirmation_number_outlined;
      case AdminUserDetailsTab.payments:
        return Icons.payments_outlined;
      case AdminUserDetailsTab.logs:
        return Icons.history_rounded;
    }
  }
}

String _displayValue(String value) {
  final normalized = value.trim();
  if (normalized.isEmpty || normalized == '-') {
    return '-';
  }
  return normalized;
}
