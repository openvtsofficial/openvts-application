import 'package:flutter/material.dart';

import '../../../../../core/theme/open_vts_colors.dart';
import '../../../../../core/theme/open_vts_spacing.dart';
import '../../../../../core/theme/open_vts_typography.dart';
import '../../../../../shared/widgets/open_vts_button.dart';
import '../../../../../shared/widgets/open_vts_card.dart';

class UserNotificationSaveBar extends StatelessWidget {
  const UserNotificationSaveBar({
    required this.isSaving,
    required this.canSave,
    required this.canReset,
    required this.onSave,
    required this.onReset,
    super.key,
  });

  final bool isSaving;
  final bool canSave;
  final bool canReset;
  final VoidCallback? onSave;
  final VoidCallback? onReset;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SafeArea(
      top: false,
      minimum: const EdgeInsets.symmetric(vertical: OpenVtsSpacing.xxs),
      child: OpenVtsCard(
        padding: const EdgeInsets.symmetric(
          horizontal: OpenVtsSpacing.xs,
          vertical: OpenVtsSpacing.xxs,
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isPhone = constraints.maxWidth < 430;
            return Row(
              children: [
                Expanded(
                  child: Text(
                    isSaving
                        ? (isPhone ? 'Saving…' : 'Saving changes…')
                        : (isPhone ? 'Unsaved' : 'You have unsaved changes.'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: OpenVtsTypography.meta.copyWith(
                      color: isDark
                          ? OpenVtsColors.white.withValues(alpha: 0.7)
                          : OpenVtsColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: OpenVtsSpacing.xs),
                SizedBox(
                  width: isPhone ? 72 : 98,
                  child: OpenVtsButton(
                    label: 'Reset',
                    height: 44,
                    variant: OpenVtsButtonVariant.secondary,
                    onPressed: canReset ? onReset : null,
                  ),
                ),
                const SizedBox(width: OpenVtsSpacing.xs),
                SizedBox(
                  width: isPhone ? 96 : 132,
                  child: OpenVtsButton(
                    label: isSaving
                        ? 'Saving…'
                        : (isPhone ? 'Save' : 'Save Changes'),
                    height: 44,
                    isLoading: isSaving,
                    onPressed: canSave ? onSave : null,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
