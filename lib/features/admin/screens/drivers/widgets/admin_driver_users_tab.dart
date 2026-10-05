import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/open_vts_colors.dart';
import '../../../../../core/theme/open_vts_radius.dart';
import '../../../../../core/theme/open_vts_spacing.dart';
import '../../../../../core/theme/open_vts_typography.dart';
import '../../../../../core/utils/date_time_formatter.dart';
import '../../../../../shared/helpers/mobile_text.dart';
import '../../../../../shared/helpers/toast_helper.dart';
import '../../../../../shared/widgets/open_vts_card.dart';
import '../../../../../shared/widgets/open_vts_empty_state.dart';
import '../../../../../shared/widgets/open_vts_error_view.dart';
import '../../../../../shared/widgets/open_vts_loader.dart';
import '../../../controllers/admin_driver_details_controller.dart';
import '../../../models/admin_driver_details_model.dart';
import '../../../models/admin_driver_details_state.dart';
import '../../../widgets/admin_action_gate.dart';
import 'admin_driver_assign_user_sheet.dart';

class AdminDriverUsersTab extends ConsumerWidget {
  const AdminDriverUsersTab({
    required this.provider,
    required this.state,
    super.key,
  });

  final AutoDisposeStateNotifierProvider<
    AdminDriverDetailsController,
    AdminDriverDetailsState
  >
  provider;
  final AdminDriverDetailsState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(provider.notifier);

    if (state.isLoadingUsers && state.linkedUsers.isEmpty) {
      return const OpenVtsCard(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: OpenVtsSpacing.md),
          child: OpenVtsLoader(),
        ),
      );
    }

    if (state.sectionErrorMessage != null && state.linkedUsers.isEmpty) {
      return OpenVtsErrorView(
        message: state.sectionErrorMessage!,
        onRetry: controller.loadUsers,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AdminActionGate(
          capability: 'drivers.update',
          child: OutlinedButton.icon(
            onPressed: state.isAssigningUser
                ? null
                : () => showDriverAssignUserSheet(
                    context: context,
                    provider: provider,
                    users: state.unlinkedUsers,
                  ),
            icon: const Icon(Icons.person_add_alt_1_rounded, size: 16),
            label: Text(context.mobileText('Assign User')),
          ),
        ),
        const SizedBox(height: OpenVtsSpacing.sm),
        if (state.linkedUsers.isEmpty)
          OpenVtsEmptyState(
            title: context.mobileText('No assigned users'),
            message: context.mobileText('Assign users to this driver.'),
          )
        else
          ...state.linkedUsers.map(
            (user) => Padding(
              padding: const EdgeInsets.only(bottom: OpenVtsSpacing.xs),
              child: _UserCard(
                user: user,
                unassigning: state.unassigningUserIds.contains(user.id),
                onUnassign: () async {
                  final yes = await showDialog<bool>(
                    context: context,
                    builder: (dCtx) => AlertDialog(
                      title: Text(context.mobileText('Unassign user')),
                      content: Text(
                        context.mobileText(
                          "Remove {value1} from this driver?",
                          {'value1': (user.name).toString()},
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(dCtx).pop(false),
                          child: Text(context.mobileText('Cancel')),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(dCtx).pop(true),
                          style: TextButton.styleFrom(
                            foregroundColor: OpenVtsColors.error,
                          ),
                          child: Text(context.mobileText('Unassign')),
                        ),
                      ],
                    ),
                  );
                  if (yes != true) return;
                  final ok = await controller.unassignUser(user.id);
                  if (!context.mounted) return;
                  if (ok) {
                    ToastHelper.showSuccess(
                      context.mobileText('User unassigned.'),
                      context: context,
                    );
                  } else {
                    ToastHelper.showError(
                      ref.read(provider).sectionErrorMessage ??
                          'Unable to unassign user.',
                      context: context,
                    );
                  }
                },
              ),
            ),
          ),
      ],
    );
  }
}

class _UserCard extends StatelessWidget {
  const _UserCard({
    required this.user,
    required this.unassigning,
    required this.onUnassign,
  });

  final AdminDriverLinkedUser user;
  final bool unassigning;
  final VoidCallback onUnassign;

  @override
  Widget build(BuildContext context) {
    final f = const DateTimeFormatter();
    return OpenVtsCard(
      padding: const EdgeInsets.all(OpenVtsSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _UserAvatar(name: user.name),
              const SizedBox(width: OpenVtsSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: OpenVtsTypography.label.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '@${user.username}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: OpenVtsTypography.meta.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              AdminActionGate(
                capability: 'drivers.update',
                child: _TinyTextButton(
                  onPressed: unassigning ? null : onUnassign,
                  isLoading: unassigning,
                  label: context.mobileText('Unassign'),
                  icon: Icons.link_off_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: OpenVtsSpacing.sm),
          Wrap(
            spacing: OpenVtsSpacing.xs,
            runSpacing: OpenVtsSpacing.xs,
            children: [
              if (user.phone.trim().isNotEmpty)
                _MetaPill(
                  icon: Icons.phone_outlined,
                  label: user.phone,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              if (user.email.trim().isNotEmpty)
                _MetaPill(
                  icon: Icons.mail_outline_rounded,
                  label: user.email,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              if (user.isActive != null)
                _MetaPill(
                  icon: user.isActive!
                      ? Icons.check_circle_outline_rounded
                      : Icons.pause_circle_outline_rounded,
                  label: user.isActive!
                      ? context.mobileText('Active')
                      : context.mobileText('Inactive'),
                  color: user.isActive!
                      ? OpenVtsColors.success
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              if (user.assignedAt != null)
                _MetaPill(
                  icon: Icons.calendar_today_rounded,
                  label: f.formatDate(user.assignedAt!),
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _UserAvatar extends StatelessWidget {
  const _UserAvatar({required this.name});

  final String name;

  String _initials() {
    final words = name.trim().split(RegExp(r'\s+'));
    if (words.isEmpty) return 'U';
    if (words.length == 1) return words.first.substring(0, 1).toUpperCase();
    return '${words.first.substring(0, 1)}${words.last.substring(0, 1)}'
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: _softSurfaceColor(context),
        borderRadius: BorderRadius.circular(OpenVtsRadius.md),
        border: Border.all(color: _softBorderColor(context)),
      ),
      child: Text(
        _initials(),
        style: OpenVtsTypography.label.copyWith(
          fontWeight: FontWeight.w700,
          color: _primaryInkColor(context),
          fontSize: 13,
        ),
      ),
    );
  }
}

class _TinyTextButton extends StatelessWidget {
  const _TinyTextButton({
    required this.onPressed,
    required this.isLoading,
    required this.label,
    required this.icon,
  });

  final VoidCallback? onPressed;
  final bool isLoading;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: isLoading
              ? const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      icon,
                      size: 14,
                      color: onPressed != null
                          ? Theme.of(context).colorScheme.onSurfaceVariant
                          : Theme.of(context).colorScheme.onSurfaceVariant
                                .withValues(alpha: 0.5),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      label,
                      style: OpenVtsTypography.meta.copyWith(
                        fontWeight: FontWeight.w600,
                        color: onPressed != null
                            ? Theme.of(context).colorScheme.onSurfaceVariant
                            : Theme.of(context).colorScheme.onSurfaceVariant
                                  .withValues(alpha: 0.5),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _MetaPill extends StatelessWidget {
  const _MetaPill({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(OpenVtsRadius.pill),
        border: Border.all(color: color.withValues(alpha: 0.28)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: OpenVtsTypography.meta.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 10,
            ),
          ),
        ],
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
