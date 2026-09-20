import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/theme/open_vts_colors.dart';
import '../../../../../../core/theme/open_vts_radius.dart';
import '../../../../../../core/theme/open_vts_spacing.dart';
import '../../../../../../core/theme/open_vts_typography.dart';
import '../../../../../../core/utils/date_time_formatter.dart';
import '../../../../../../shared/widgets/open_vts_card.dart';
import '../../../../models/user_subuser_model.dart';

class UserSubUserCard extends ConsumerWidget {
  const UserSubUserCard({
    required this.subUser,
    required this.isTogglingStatus,
    required this.onToggleStatus,
    this.onTap,
    super.key,
  });

  final UserSubUser subUser;
  final bool isTogglingStatus;
  final ValueChanged<bool> onToggleStatus;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateFormatter = ref.watch(appDateFormatterProvider);
    final isActive = subUser.isActive;

    return OpenVtsCard(
      onTap: onTap,
      padding: const EdgeInsets.all(OpenVtsSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(OpenVtsRadius.sm),
                  border: Border.all(
                      color: Theme.of(context).colorScheme.outlineVariant),
                ),
                child: Icon(
                  Icons.person_outline_rounded,
                  size: 17,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: OpenVtsSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _displayTitle(subUser),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: OpenVtsTypography.label.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '@${_displayUsername(subUser)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: OpenVtsTypography.meta.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: 18,
                color: Theme.of(context).colorScheme.outline,
              ),
            ],
          ),
          const SizedBox(height: OpenVtsSpacing.xs),
          _InfoRow(label: 'Email', value: _displayEmail(subUser)),
          _InfoRow(label: 'Mobile', value: _displayMobile(subUser)),
          _InfoRow(
              label: 'Created', value: _displayCreated(subUser, dateFormatter)),
          const SizedBox(height: OpenVtsSpacing.xs),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(OpenVtsRadius.pill),
                  border: Border.all(
                    color: (isActive
                            ? Theme.of(context).colorScheme.onSurfaceVariant
                            : Theme.of(context).colorScheme.outline)
                        .withValues(alpha: 0.35),
                  ),
                ),
                child: Text(
                  isActive ? 'Active' : 'Inactive',
                  style: OpenVtsTypography.meta.copyWith(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : (isActive
                            ? Theme.of(context).colorScheme.onSurfaceVariant
                            : Theme.of(context).colorScheme.outline),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                'Status',
                style: OpenVtsTypography.meta.copyWith(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: OpenVtsSpacing.xs),
              if (isTogglingStatus)
                const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else
                Transform.scale(
                  scale: 0.88,
                  child: Switch.adaptive(
                    value: isActive,
                    activeThumbColor:
                        Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : OpenVtsColors.brandInk,
                    activeTrackColor:
                        Theme.of(context).brightness == Brightness.dark
                            ? Colors.white.withValues(alpha: 0.4)
                            : OpenVtsColors.brandInk.withValues(alpha: 0.35),
                    inactiveThumbColor:
                        Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : OpenVtsColors.textTertiary,
                    inactiveTrackColor:
                        Theme.of(context).brightness == Brightness.dark
                            ? const Color(0xFF333333)
                            : null,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    onChanged: onToggleStatus,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 56,
            child: Text(
              label,
              style: OpenVtsTypography.meta.copyWith(
                color: Theme.of(context).colorScheme.outline,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: OpenVtsSpacing.xs),
          Expanded(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: OpenVtsTypography.meta.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _displayTitle(UserSubUser subUser) {
  for (final value in [subUser.name, subUser.username, subUser.email]) {
    final normalized = value.trim();
    if (normalized.isNotEmpty) {
      return normalized;
    }
  }
  return 'Sub User';
}

String _displayUsername(UserSubUser subUser) {
  final username = subUser.username.trim();
  if (username.isNotEmpty) {
    return username;
  }
  return 'not-set';
}

String _displayEmail(UserSubUser subUser) {
  final email = subUser.email.trim();
  return email.isEmpty ? '-' : email;
}

String _displayMobile(UserSubUser subUser) {
  final prefix = subUser.mobilePrefix.trim();
  final mobile = subUser.mobileNumber.trim();
  final merged =
      [prefix, mobile].where((part) => part.isNotEmpty).join(' ').trim();
  return merged.isEmpty ? '-' : merged;
}

String _displayCreated(UserSubUser subUser, dynamic formatter) {
  final createdAt = subUser.createdAt;
  if (createdAt == null) {
    return 'Unknown';
  }
  return formatter.formatDate(createdAt.toLocal());
}
