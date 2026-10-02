import 'package:flutter/material.dart';

import '../../../../../core/theme/open_vts_colors.dart';
import '../../../../../core/theme/open_vts_radius.dart';
import '../../../../../core/theme/open_vts_spacing.dart';
import '../../../../../core/theme/open_vts_typography.dart';
import '../../../../../core/utils/date_time_formatter.dart';
import '../../../../../shared/widgets/open_vts_bottom_sheet.dart';
import '../../../../../shared/widgets/open_vts_button.dart';
import '../../../../../shared/widgets/open_vts_card.dart';
import '../../../../../shared/widgets/open_vts_empty_state.dart';
import '../../../../../shared/widgets/open_vts_loader.dart';
import '../../../models/admin_vehicle_model.dart';

const DateTimeFormatter _cardDateFormatter = DateTimeFormatter();

class AdminVehicleUsersTab extends StatelessWidget {
  const AdminVehicleUsersTab({
    super.key,
    required this.isLoading,
    required this.isLinking,
    required this.isUnlinking,
    required this.linkedUsers,
    required this.availableUsers,
    required this.onRefresh,
    required this.onLinkUser,
    required this.onUnlinkUser,
  });

  final bool isLoading;
  final bool isLinking;
  final bool isUnlinking;
  final List<AdminVehicleUserMini> linkedUsers;
  final List<AdminVehicleUserMini> availableUsers;
  final Future<void> Function() onRefresh;
  final Future<void> Function(String userId) onLinkUser;
  final Future<void> Function(String userId) onUnlinkUser;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const OpenVtsLoader();
    }

    return Column(
      children: [
        OpenVtsCard(
          padding: const EdgeInsets.all(OpenVtsSpacing.md),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Assigned Users (${linkedUsers.length})',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              OpenVtsButton(
                label: 'Assign User',
                variant: OpenVtsButtonVariant.secondary,
                onPressed: availableUsers.isEmpty
                    ? null
                    : () => _openAssignSheet(context),
              ),
            ],
          ),
        ),
        const SizedBox(height: OpenVtsSpacing.sm),
        if (linkedUsers.isEmpty)
          const OpenVtsEmptyState(
            title: 'No users assigned',
            message: 'Assign users to this vehicle.',
          )
        else
          ...linkedUsers.map(
            (user) => Padding(
              padding: const EdgeInsets.only(bottom: OpenVtsSpacing.sm),
              child: _VehicleUserCard(
                user: user,
                isUnlinking: isUnlinking,
                onUnlink: () async {
                  await onUnlinkUser(user.id);
                  await onRefresh();
                },
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _openAssignSheet(BuildContext context) {
    return OpenVtsBottomSheet.show<void>(
      context: context,
      title: 'Assign User',
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      child: _AssignUserSheet(
        users: availableUsers,
        isLinking: isLinking,
        onAssign: (userId) async {
          await onLinkUser(userId);
          await onRefresh();
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }
}

class _VehicleUserCard extends StatelessWidget {
  const _VehicleUserCard({
    required this.user,
    required this.isUnlinking,
    required this.onUnlink,
  });

  final AdminVehicleUserMini user;
  final bool isUnlinking;
  final VoidCallback onUnlink;

  @override
  Widget build(BuildContext context) {
    final hasEmail = user.email.trim().isNotEmpty;
    final hasPhone = user.mobileDisplay.trim().isNotEmpty;
    final hasContact = hasEmail || hasPhone;

    return OpenVtsCard(
      padding: const EdgeInsets.all(OpenVtsSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _AvatarCircle(user: user),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            user.displayName.isNotEmpty
                                ? user.displayName
                                : 'Unknown',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.2,
                                ),
                          ),
                        ),
                        if (user.isPrimary) ...[
                          const SizedBox(width: OpenVtsSpacing.xs),
                          const _PrimaryBadge(),
                        ],
                      ],
                    ),
                    const SizedBox(height: OpenVtsSpacing.xs),
                    if (hasEmail)
                      Text(
                        user.email,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: OpenVtsTypography.meta.copyWith(
                          color: OpenVtsColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    if (hasPhone) ...[
                      if (hasEmail) const SizedBox(height: 2),
                      Text(
                        user.mobileDisplay,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: OpenVtsTypography.meta.copyWith(
                          color: OpenVtsColors.textTertiary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                    if (!hasContact) ...[
                      Text(
                        'No contact information',
                        style: OpenVtsTypography.meta.copyWith(
                          color: OpenVtsColors.textTertiary,
                          fontSize: 11,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                height: 40,
                width: 104,
                child: Builder(
                  builder: (context) => OpenVtsButton(
                    label: 'Unassign',
                    isLoading: isUnlinking,
                    onPressed:
                        isUnlinking ? null : () => _showConfirmDialog(context),
                    variant: OpenVtsButtonVariant.secondary,
                  ),
                ),
              ),
            ],
          ),
          if (user.assignedAt != null) ...[
            const SizedBox(height: OpenVtsSpacing.sm),
            const Divider(height: 1, color: OpenVtsColors.border),
            const SizedBox(height: OpenVtsSpacing.sm),
            _InfoTile(
              icon: Icons.event_outlined,
              label: 'Assigned',
              value: _cardDateFormatter.formatDateTime(user.assignedAt!),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _showConfirmDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unassign User?'),
        content: Text(
          'Remove ${user.displayName.isNotEmpty ? user.displayName : 'this user'} from this vehicle?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onUnlink();
            },
            style: TextButton.styleFrom(
              foregroundColor: OpenVtsColors.error,
            ),
            child: const Text('Unassign'),
          ),
        ],
      ),
    );
  }
}

class _AvatarCircle extends StatelessWidget {
  const _AvatarCircle({required this.user});

  final AdminVehicleUserMini user;

  String _initials() {
    final name = user.displayName;
    if (name.isEmpty) return 'U';
    final words = name.split(RegExp(r'\s+'));
    if (words.length == 1) {
      return name.characters.take(2).toString().toUpperCase();
    }
    return '${words.first.characters.first}${words.last.characters.first}'
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: OpenVtsColors.surface,
      ),
      child: Text(
        _initials(),
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: OpenVtsColors.textPrimary,
        ),
      ),
    );
  }
}

class _PrimaryBadge extends StatelessWidget {
  const _PrimaryBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: OpenVtsColors.brandInk.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(OpenVtsRadius.pill),
        border: Border.all(
          color: OpenVtsColors.brandInk.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded,
              size: 10, color: OpenVtsColors.brandInk),
          const SizedBox(width: 2),
          Text(
            'Primary',
            style: OpenVtsTypography.meta.copyWith(
              color: OpenVtsColors.brandInk,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
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

class _AssignUserSheet extends StatefulWidget {
  const _AssignUserSheet({
    required this.users,
    required this.isLinking,
    required this.onAssign,
  });

  final List<AdminVehicleUserMini> users;
  final bool isLinking;
  final Future<void> Function(String userId) onAssign;

  @override
  State<_AssignUserSheet> createState() => _AssignUserSheetState();
}

class _AssignUserSheetState extends State<_AssignUserSheet> {
  String _query = '';
  String? _selectedUserId;

  @override
  Widget build(BuildContext context) {
    final filtered = widget.users.where((user) {
      final q = _query.trim().toLowerCase();
      if (q.isEmpty) return true;
      return <String>[
        user.name,
        user.username,
        user.email,
        user.mobileDisplay,
      ].join(' ').toLowerCase().contains(q);
    }).toList(growable: false);

    return ListView(
      padding: const EdgeInsets.all(OpenVtsSpacing.md),
      children: [
        TextField(
          decoration: const InputDecoration(
            hintText: 'Search unlinked users...',
            prefixIcon: Icon(Icons.search_rounded),
          ),
          onChanged: (value) => setState(() => _query = value),
        ),
        const SizedBox(height: OpenVtsSpacing.sm),
        if (filtered.isEmpty)
          const OpenVtsEmptyState(
            title: 'No users',
            message: 'No unlinked users match your search.',
          )
        else
          ...filtered.map(
            (user) => RadioListTile<String>(
              value: user.id,
              // ignore: deprecated_member_use
              groupValue: _selectedUserId,
              // ignore: deprecated_member_use
              onChanged: (value) => setState(() => _selectedUserId = value),
              title: Text(
                  user.displayName.isNotEmpty ? user.displayName : 'Unknown'),
              subtitle: Text(
                [user.username, user.email]
                    .where((item) => item.trim().isNotEmpty)
                    .join(' • '),
              ),
            ),
          ),
        const SizedBox(height: OpenVtsSpacing.sm),
        OpenVtsButton(
          label: 'Assign',
          isLoading: widget.isLinking,
          onPressed: _selectedUserId == null || widget.isLinking
              ? null
              : () => widget.onAssign(_selectedUserId!),
        ),
      ],
    );
  }
}
