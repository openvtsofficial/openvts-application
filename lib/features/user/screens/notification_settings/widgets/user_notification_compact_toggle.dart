import 'package:flutter/material.dart';

import '../../../../../core/theme/open_vts_colors.dart';
import '../../../../../core/theme/open_vts_radius.dart';
import '../../../../../core/theme/open_vts_spacing.dart';
import '../../../../../core/theme/open_vts_typography.dart';

class UserNotificationCompactToggle extends StatelessWidget {
  const UserNotificationCompactToggle({
    required this.label,
    required this.value,
    required this.onChanged,
    this.icon,
    this.semanticsLabel,
    this.enabled = true,
    super.key,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final IconData? icon;
  final String? semanticsLabel;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.black : OpenVtsColors.surfaceElevated,
        borderRadius: BorderRadius.circular(OpenVtsRadius.sm),
        border: Border.all(
          color: isDark ? OpenVtsColors.white : OpenVtsColors.border,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: OpenVtsSpacing.xs),
      child: SizedBox(
        height: 44,
        child: Row(
          children: [
            if (icon != null)
              Icon(
                icon,
                size: 14,
                color: isDark
                    ? OpenVtsColors.white.withValues(alpha: 0.7)
                    : OpenVtsColors.textSecondary,
              ),
            if (icon != null) const SizedBox(width: OpenVtsSpacing.xxs),
            Expanded(
              child: Text(
                label,
                style: OpenVtsTypography.meta.copyWith(
                  color: isDark
                      ? OpenVtsColors.white.withValues(alpha: 0.7)
                      : OpenVtsColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Semantics(
              label: semanticsLabel ?? '$label toggle',
              toggled: value,
              child: Switch.adaptive(
                value: value,
                onChanged: enabled ? onChanged : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
