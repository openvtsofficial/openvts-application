import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/open_vts_colors.dart';
import '../../../../../core/theme/open_vts_radius.dart';
import '../../../../../core/theme/open_vts_spacing.dart';
import '../../../../../core/theme/open_vts_typography.dart';
import '../../../../../core/utils/date_time_formatter.dart';
import '../../../../../shared/helpers/mobile_text.dart';
import '../../../../../shared/helpers/toast_helper.dart';
import '../../../../../shared/models/user_role.dart';
import '../../../../../shared/widgets/open_vts_bottom_sheet.dart';
import '../../../../auth/controllers/auth_controller.dart';
import '../../../controllers/admin_providers.dart';
import '../../../models/admin_team_model.dart';
import '../admin_team_details_screen.dart';
import 'admin_change_password_sheet.dart';
import 'admin_create_team_sheet.dart';

const DateTimeFormatter _cardDateFormatter = DateTimeFormatter();

class AdminTeamCard extends ConsumerWidget {
  const AdminTeamCard({required this.team, super.key});

  final AdminTeamListItem team;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _RoundedSurface(
      onTap: () => _openTeamDetails(context, ref, team.id),
      padding: const EdgeInsets.all(OpenVtsSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardHeader(team: team, ref: ref),
          const SizedBox(height: OpenVtsSpacing.md),
          _CardInfoGrid(team: team),
          const SizedBox(height: OpenVtsSpacing.md),
          _CardMetricsRow(team: team),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Card header with three-dot menu
// ---------------------------------------------------------------------------

class _CardHeader extends StatelessWidget {
  const _CardHeader({required this.team, required this.ref});

  final AdminTeamListItem team;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _AvatarCircle(team: team),
        const SizedBox(width: OpenVtsSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      _displayName(team),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ),
                  const SizedBox(width: OpenVtsSpacing.xs),
                  Icon(
                    team.isVerified
                        ? Icons.verified_rounded
                        : Icons.gpp_maybe_rounded,
                    size: 16,
                    color: team.isVerified
                        ? OpenVtsColors.success
                        : OpenVtsColors.warning,
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                '@${_displayUsername(team)}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: OpenVtsTypography.label.copyWith(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? OpenVtsColors.darkTextSecondary
                      : OpenVtsColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: OpenVtsSpacing.xs),
        _TeamCardMenu(team: team),
      ],
    );
  }
}

class _AvatarCircle extends StatelessWidget {
  const _AvatarCircle({required this.team});

  final AdminTeamListItem team;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      width: 44,
      decoration: BoxDecoration(
        color: _softSurfaceColor(context),
        shape: BoxShape.circle,
        border: Border.all(color: _softBorderColor(context)),
      ),
      alignment: Alignment.center,
      child: Text(
        _initials(_displayName(team)),
        style: OpenVtsTypography.label.copyWith(
          fontWeight: FontWeight.w700,
          color: _primaryInkColor(context),
          fontSize: 14,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Three-dot menu
// ---------------------------------------------------------------------------

class _TeamCardMenu extends ConsumerWidget {
  const _TeamCardMenu({required this.team});

  final AdminTeamListItem team;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<String>(
      onSelected: (value) => _handleMenuAction(context, ref, value),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              const Icon(Icons.edit_outlined, size: 18),
              const SizedBox(width: OpenVtsSpacing.sm),
              Text(context.mobileText('Edit')),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'permissions',
          child: Text(context.mobileText('Permissions')),
        ),
        PopupMenuItem(
          value: 'password',
          child: Row(
            children: [
              const Icon(Icons.lock_outline_rounded, size: 18),
              const SizedBox(width: OpenVtsSpacing.sm),
              Text(context.mobileText('Change Password')),
            ],
          ),
        ),
        if (team.isActive)
          PopupMenuItem(
            value: 'setInactive',
            child: Row(
              children: [
                const Icon(Icons.pause_circle_outline_rounded, size: 18),
                const SizedBox(width: OpenVtsSpacing.sm),
                Text(context.mobileText('Set Inactive')),
              ],
            ),
          )
        else
          PopupMenuItem(
            value: 'setActive',
            child: Row(
              children: [
                const Icon(Icons.check_circle_outline_rounded, size: 18),
                const SizedBox(width: OpenVtsSpacing.sm),
                Text(context.mobileText('Set Active')),
              ],
            ),
          ),
        const PopupMenuDivider(),
        PopupMenuItem(
          value: 'logs',
          child: Row(
            children: [
              const Icon(Icons.history_rounded, size: 18),
              const SizedBox(width: OpenVtsSpacing.sm),
              Text(context.mobileText('Activity Logs')),
            ],
          ),
        ),
      ],
      child: SizedBox(
        width: 44,
        height: 44,
        child: Center(
          child: Icon(
            Icons.more_horiz_rounded,
            size: 20,
            color: Theme.of(context).brightness == Brightness.dark
                ? OpenVtsColors.darkTextSecondary
                : OpenVtsColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Future<void> _handleMenuAction(
    BuildContext context,
    WidgetRef ref,
    String action,
  ) async {
    final auth = ref.read(authControllerProvider);
    if (!auth.isRealSession || auth.user?.role != UserRole.admin) return;
    final controller = ref.read(adminTeamControllerProvider.notifier);

    switch (action) {
      case 'edit':
        _showEditTeamSheet(context, ref);
      case 'permissions':
        await _openTeamDetails(
          context,
          ref,
          team.id,
          initialTab: AdminTeamDetailsTab.permissions,
        );
      case 'password':
        _showPasswordSheet(context, ref);
      case 'setInactive':
        final ok = await controller.updateTeamStatus(team.id, false);
        if (context.mounted) {
          if (ok) {
            ToastHelper.showSuccess(
              context.mobileText('Team deactivated.'),
              context: context,
            );
          } else {
            ToastHelper.showError(
              context.mobileText('Unable to update team member status.'),
              context: context,
            );
          }
        }
      case 'setActive':
        final ok = await controller.updateTeamStatus(team.id, true);
        if (context.mounted) {
          if (ok) {
            ToastHelper.showSuccess(
              context.mobileText('Team activated.'),
              context: context,
            );
          } else {
            ToastHelper.showError(
              context.mobileText('Unable to update team member status.'),
              context: context,
            );
          }
        }
      case 'logs':
        await _openTeamDetails(
          context,
          ref,
          team.id,
          initialTab: AdminTeamDetailsTab.activity,
        );
    }
  }

  Future<void> _showEditTeamSheet(BuildContext context, WidgetRef ref) async {
    return OpenVtsBottomSheet.show<void>(
      context: context,
      title: context.mobileText('Edit Team Member'),
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.96,
      child: Consumer(
        builder: (context, ref, child) {
          final state = ref.watch(adminTeamControllerProvider);
          return AdminCreateTeamSheet.edit(
            member: team,
            isSubmitting: state.isUpdating,
          );
        },
      ),
    );
  }

  Future<void> _showPasswordSheet(BuildContext context, WidgetRef ref) async {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(OpenVtsRadius.xl),
        ),
      ),
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: Consumer(
            builder: (context, ref, child) {
              final state = ref.watch(adminTeamControllerProvider);
              return AdminChangePasswordSheet(
                member: team,
                isSubmitting: state.isChangingPassword,
              );
            },
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Card info grid (email, phone)
// ---------------------------------------------------------------------------

class _CardInfoGrid extends StatelessWidget {
  const _CardInfoGrid({required this.team});

  final AdminTeamListItem team;

  @override
  Widget build(BuildContext context) {
    final emailValue = _displayValue(team.email);
    final phoneValue = _displayValue(team.phone);

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 420;

        if (compact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _InfoRow(icon: Icons.mail_outline_rounded, value: emailValue),
              const SizedBox(height: OpenVtsSpacing.xs),
              _InfoRow(icon: Icons.call_outlined, value: phoneValue),
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _InfoRow(
                icon: Icons.mail_outline_rounded,
                value: emailValue,
              ),
            ),
            const SizedBox(width: OpenVtsSpacing.sm),
            Expanded(
              child: _InfoRow(icon: Icons.call_outlined, value: phoneValue),
            ),
          ],
        );
      },
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.value});

  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 16,
          color: Theme.of(context).brightness == Brightness.dark
              ? OpenVtsColors.darkTextSecondary
              : OpenVtsColors.textSecondary,
        ),
        const SizedBox(width: OpenVtsSpacing.xs),
        Expanded(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: OpenVtsTypography.label.copyWith(
              color: Theme.of(context).brightness == Brightness.dark
                  ? OpenVtsColors.darkTextPrimary
                  : OpenVtsColors.textPrimary,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Card metrics row (Status + Created)
// ---------------------------------------------------------------------------

class _CardMetricsRow extends StatelessWidget {
  const _CardMetricsRow({required this.team});

  final AdminTeamListItem team;

  @override
  Widget build(BuildContext context) {
    final createdValue = _createdLabel(team.createdAt);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Expanded(
          child: _MetricCell(
            icon: team.isActive
                ? Icons.check_circle_outline_rounded
                : Icons.pause_circle_outline_rounded,
            label: context.mobileText('Status'),
            value: team.statusLabel,
            color: team.isActive
                ? (isDark ? Colors.white : OpenVtsColors.brandInk)
                : OpenVtsColors.textTertiary,
            useValueColorForIcon: team.isActive,
          ),
        ),
        const SizedBox(width: OpenVtsSpacing.xs),
        Expanded(
          flex: 2,
          child: _MetricCell(
            icon: Icons.schedule_outlined,
            label: context.mobileText('Created'),
            value: createdValue,
            color: isDark
                ? OpenVtsColors.darkTextSecondary
                : OpenVtsColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _MetricCell extends StatelessWidget {
  const _MetricCell({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.useValueColorForIcon = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final bool useValueColorForIcon;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultIconColor = isDark
        ? OpenVtsColors.darkTextSecondary
        : OpenVtsColors.textSecondary;

    return Container(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: OpenVtsSpacing.sm,
        vertical: OpenVtsSpacing.xs + 2,
      ),
      decoration: BoxDecoration(
        color: _softSurfaceColor(context),
        borderRadius: BorderRadius.circular(OpenVtsRadius.md),
        border: Border.all(color: _softBorderColor(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 14,
                color: useValueColorForIcon ? color : defaultIconColor,
              ),
              const SizedBox(width: OpenVtsSpacing.xxs + 2),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: OpenVtsTypography.meta.copyWith(
                    color: isDark
                        ? OpenVtsColors.darkTextSecondary
                        : OpenVtsColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: OpenVtsSpacing.xxs + 2),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: OpenVtsTypography.label.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Shared surface
// ---------------------------------------------------------------------------

class _RoundedSurface extends StatelessWidget {
  const _RoundedSurface({
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(OpenVtsSpacing.md),
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(OpenVtsRadius.lg);
    return Material(
      color: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: BorderSide(color: _softBorderColor(context)),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Theme helpers
// ---------------------------------------------------------------------------

Color _softSurfaceColor(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark
      ? OpenVtsColors.darkSurface
      : OpenVtsColors.background;
}

Color _softBorderColor(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark
      ? OpenVtsColors.darkBorder
      : OpenVtsColors.border;
}

Color _primaryInkColor(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark
      ? OpenVtsColors.darkTextPrimary
      : OpenVtsColors.brandInk;
}

// ---------------------------------------------------------------------------
// Data helpers
// ---------------------------------------------------------------------------

String _displayName(AdminTeamListItem team) {
  final name = team.teamName.trim();
  if (name.isNotEmpty && name != '-') {
    return name;
  }
  final username = team.username.trim();
  if (username.isNotEmpty && username != '-') {
    return username;
  }
  return _displayValue(team.email);
}

String _displayUsername(AdminTeamListItem team) {
  final username = team.username.trim();
  if (username.isNotEmpty && username != '-') {
    return username;
  }
  final email = team.email.trim();
  if (email.isNotEmpty && email != '-') {
    return email;
  }
  return 'unknown';
}

String _initials(String input) {
  final parts = input
      .trim()
      .split(RegExp(r'\s+'))
      .where((e) => e.isNotEmpty)
      .toList(growable: false);
  if (parts.isEmpty) return '';
  if (parts.length == 1) {
    return parts.first.characters.first.toUpperCase();
  }
  return '${parts.first.characters.first}${parts.last.characters.first}'
      .toUpperCase();
}

String _displayValue(String value) {
  final normalized = value.trim();
  return normalized.isEmpty || normalized == '-' ? '—' : normalized;
}

String _createdLabel(DateTime? value) {
  if (value == null) {
    return '—';
  }
  final local = value.toLocal();
  return _cardDateFormatter.formatDate(local);
}

Future<void> _openTeamDetails(
  BuildContext context,
  WidgetRef ref,
  String memberId, {
  AdminTeamDetailsTab initialTab = AdminTeamDetailsTab.profile,
}) async {
  final auth = ref.read(authControllerProvider);
  if (!auth.isRealSession ||
      auth.user?.role != UserRole.admin ||
      memberId.trim().isEmpty) {
    return;
  }
  await Navigator.of(context).push<void>(
    MaterialPageRoute(
      builder: (_) =>
          AdminTeamDetailsScreen(memberId: memberId, initialTab: initialTab),
    ),
  );
}
