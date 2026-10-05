import 'package:flutter/material.dart';

import '../../../../../core/theme/open_vts_colors.dart';
import '../../../../../core/theme/open_vts_spacing.dart';
import '../../../../../core/theme/open_vts_typography.dart';
import '../../../../../shared/helpers/mobile_text.dart';
import '../../../../../shared/widgets/open_vts_card.dart';
import '../../../models/user_notification_settings_model.dart';

class UserNotificationChannelCard extends StatelessWidget {
  const UserNotificationChannelCard({
    required this.selectedGroup,
    required this.flags,
    required this.onChanged,
    super.key,
  });

  final UserNotificationGroup selectedGroup;
  final UserNotificationChannelFlags flags;
  final void Function(UserNotificationChannel channel, bool value) onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final groupLabel = _groupLabel(selectedGroup);
    final channels = <_ChannelRowItem>[
      _ChannelRowItem(
        channel: UserNotificationChannel.webPush,
        label: context.mobileText('Web Push'),
        icon: Icons.language_rounded,
        value: flags.notifyWebPush,
      ),
      _ChannelRowItem(
        channel: UserNotificationChannel.mobilePush,
        label: context.mobileText('Mobile Push'),
        icon: Icons.phone_android_rounded,
        value: flags.notifyMobilePush,
      ),
      _ChannelRowItem(
        channel: UserNotificationChannel.whatsapp,
        label: context.mobileText('WhatsApp'),
        icon: Icons.forum_outlined,
        value: flags.notifyWhatsapp,
      ),
      _ChannelRowItem(
        channel: UserNotificationChannel.email,
        label: context.mobileText('Email'),
        icon: Icons.mail_outline_rounded,
        value: flags.notifyEmail,
      ),
    ];

    return OpenVtsCard(
      padding: const EdgeInsets.all(OpenVtsSpacing.xs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.mobileText("{value1} Delivery Channels", {
              'value1': (groupLabel).toString(),
            }),
            style: OpenVtsTypography.meta.copyWith(
              color: isDark ? OpenVtsColors.white : OpenVtsColors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: OpenVtsSpacing.xxs),
          Text(
            context.mobileText(
              'Choose where alerts are delivered for this notification group.',
            ),
            style: OpenVtsTypography.meta.copyWith(
              color: isDark
                  ? OpenVtsColors.white.withValues(alpha: 0.7)
                  : OpenVtsColors.textTertiary,
            ),
          ),
          const SizedBox(height: OpenVtsSpacing.xs),
          ...channels.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;

            return Column(
              children: [
                _ChannelToggleRow(
                  semanticLabel: '$groupLabel ${item.label}',
                  item: item,
                  onChanged: (value) => onChanged(item.channel, value),
                ),
                if (index != channels.length - 1)
                  Divider(
                    height: OpenVtsSpacing.sm,
                    color: isDark ? OpenVtsColors.white : OpenVtsColors.border,
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }

  String _groupLabel(UserNotificationGroup group) {
    switch (group) {
      case UserNotificationGroup.basic:
        return 'Basic';
      case UserNotificationGroup.overspeed:
        return 'Overspeed';
      case UserNotificationGroup.duration:
        return 'Duration';
      case UserNotificationGroup.geofence:
        return 'Geofence';
      case UserNotificationGroup.route:
        return 'Route';
    }
  }
}

class _ChannelToggleRow extends StatelessWidget {
  const _ChannelToggleRow({
    required this.semanticLabel,
    required this.item,
    required this.onChanged,
  });

  final String semanticLabel;
  final _ChannelRowItem item;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SizedBox(
      height: 44,
      child: Row(
        children: [
          Icon(
            item.icon,
            size: 15,
            color: isDark
                ? OpenVtsColors.white.withValues(alpha: 0.7)
                : OpenVtsColors.textSecondary,
          ),
          const SizedBox(width: OpenVtsSpacing.xs),
          Expanded(
            child: Text(
              item.label,
              style: OpenVtsTypography.body.copyWith(
                color: isDark ? OpenVtsColors.white : OpenVtsColors.textPrimary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Semantics(
            label: context.mobileText("{value1} toggle", {
              'value1': (semanticLabel).toString(),
            }),
            toggled: item.value,
            child: Switch.adaptive(value: item.value, onChanged: onChanged),
          ),
        ],
      ),
    );
  }
}

class _ChannelRowItem {
  const _ChannelRowItem({
    required this.channel,
    required this.label,
    required this.icon,
    required this.value,
  });

  final UserNotificationChannel channel;
  final String label;
  final IconData icon;
  final bool value;
}
