import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/open_vts_colors.dart';
import '../../../../../core/theme/open_vts_radius.dart';
import '../../../../../core/theme/open_vts_spacing.dart';
import '../../../../../core/theme/open_vts_typography.dart';
import '../../../../../core/utils/date_time_formatter.dart';
import '../../../../../shared/helpers/toast_helper.dart';
import '../../../../../shared/widgets/open_vts_bottom_sheet.dart';
import '../../../controllers/admin_providers.dart';
import '../../../models/admin_team_model.dart';
import 'admin_change_password_sheet.dart';
import 'admin_create_team_sheet.dart';

const DateTimeFormatter _cardDateFormatter = DateTimeFormatter();

class AdminTeamCard extends ConsumerWidget {
  const AdminTeamCard({
    required this.team,
    super.key,
  });

  final AdminTeamListItem team;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _RoundedSurface(
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
        const PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit_outlined, size: 18),
              SizedBox(width: OpenVtsSpacing.sm),
              Text('Edit'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'password',
          child: Row(
            children: [
              Icon(Icons.lock_outline_rounded, size: 18),
              SizedBox(width: OpenVtsSpacing.sm),
              Text('Change Password'),
            ],
          ),
        ),
        if (team.isActive)
          const PopupMenuItem(
            value: 'setInactive',
            child: Row(
              children: [
                Icon(Icons.pause_circle_outline_rounded, size: 18),
                SizedBox(width: OpenVtsSpacing.sm),
                Text('Set Inactive'),
              ],
            ),
          )
        else
          const PopupMenuItem(
            value: 'setActive',
            child: Row(
              children: [
                Icon(Icons.check_circle_outline_rounded, size: 18),
                SizedBox(width: OpenVtsSpacing.sm),
                Text('Set Active'),
              ],
            ),
          ),
        const PopupMenuDivider(),
        const PopupMenuItem(
          value: 'logs',
          child: Row(
            children: [
              Icon(Icons.history_rounded, size: 18),
              SizedBox(width: OpenVtsSpacing.sm),
              Text('Activity Logs'),
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
    final controller = ref.read(adminTeamControllerProvider.notifier);

    switch (action) {
      case 'edit':
        _showEditTeamSheet(context, ref);
      case 'password':
        _showPasswordSheet(context, ref);
      case 'setInactive':
        await controller.updateTeamStatus(team.id, false);
        if (context.mounted) {
          ToastHelper.showSuccess('Team deactivated.', context: context);
        }
      case 'setActive':
        await controller.updateTeamStatus(team.id, true);
        if (context.mounted) {
          ToastHelper.showSuccess('Team activated.', context: context);
        }
      case 'logs':
        _showActivityLogsSheet(context);
    }
  }

  Future<void> _showEditTeamSheet(BuildContext context, WidgetRef ref) async {
    return OpenVtsBottomSheet.show<void>(
      context: context,
      title: 'Edit Team Member',
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
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(OpenVtsRadius.xl)),
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

  Future<void> _showActivityLogsSheet(BuildContext context) async {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(OpenVtsRadius.xl)),
      ),
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(OpenVtsSpacing.md),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Activity Logs',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Expanded(
                child: Center(
                  child: Text(
                    'No activity logs available for this team member.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
            ],
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
              child: _InfoRow(
                icon: Icons.call_outlined,
                value: phoneValue,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.value,
  });

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
            label: 'Status',
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
            label: 'Created',
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
    final defaultIconColor =
        isDark ? OpenVtsColors.darkTextSecondary : OpenVtsColors.textSecondary;

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
    this.padding = const EdgeInsets.all(OpenVtsSpacing.md),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(OpenVtsRadius.lg);
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: radius,
        border: Border.all(color: _softBorderColor(context)),
      ),
      child: child,
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
