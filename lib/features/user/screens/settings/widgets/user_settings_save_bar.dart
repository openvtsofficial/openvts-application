import 'package:flutter/material.dart';

import '../../../../../core/theme/open_vts_spacing.dart';
import '../../../../../core/theme/open_vts_typography.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/open_vts_button.dart';
import '../../../../../shared/widgets/open_vts_card.dart';
import '../../../models/user_settings_model.dart';

class UserSettingsSaveBar extends StatelessWidget {
  const UserSettingsSaveBar({
    required this.selectedTab,
    required this.isSaving,
    required this.canSave,
    required this.canReset,
    required this.onSave,
    required this.onReset,
    super.key,
  });

  final UserSettingsTab selectedTab;
  final bool isSaving;
  final bool canSave;
  final bool canReset;
  final VoidCallback? onSave;
  final VoidCallback? onReset;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tabLabel = selectedTab == UserSettingsTab.profile
        ? l10n.profile
        : l10n.localization;

    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(
        OpenVtsSpacing.sm,
        OpenVtsSpacing.xs,
        OpenVtsSpacing.sm,
        OpenVtsSpacing.xs,
      ),
      child: OpenVtsCard(
        padding: const EdgeInsets.all(OpenVtsSpacing.xs),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isNarrow = constraints.maxWidth < 430;
            final helperText = isSaving
                ? (isNarrow ? 'Saving…' : 'Saving $tabLabel changes...')
                : (isNarrow
                    ? l10n.unsavedChanges
                    : 'You have unsaved $tabLabel changes.');

            return Row(
              children: [
                Expanded(
                  child: Text(
                    helperText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: OpenVtsTypography.meta.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: OpenVtsSpacing.xs),
                SizedBox(
                  width: isNarrow ? 72 : 92,
                  child: OpenVtsButton(
                    label: l10n.reset,
                    height: 44,
                    variant: OpenVtsButtonVariant.secondary,
                    onPressed: canReset ? onReset : null,
                  ),
                ),
                const SizedBox(width: OpenVtsSpacing.xs),
                SizedBox(
                  width: isNarrow ? 88 : 120,
                  child: OpenVtsButton(
                    label: isSaving ? l10n.loading : l10n.save,
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
