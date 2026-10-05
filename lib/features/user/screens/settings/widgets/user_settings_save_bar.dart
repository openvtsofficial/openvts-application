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
                ? (isNarrow ? l10n.saving : l10n.savingChangesForTab(tabLabel))
                : (isNarrow
                      ? l10n.unsavedChanges
                      : l10n.unsavedChangesForTab(tabLabel));

            double labelWidth(String text) {
              final painter = TextPainter(
                text: TextSpan(text: text, style: OpenVtsTypography.label),
                textDirection: Directionality.of(context),
                textScaler: MediaQuery.textScalerOf(context),
              )..layout();
              return painter.width.ceilToDouble();
            }

            final resetWidth = (labelWidth(l10n.reset) + 40).clamp(
              88.0,
              double.infinity,
            );
            final saveWidth = (labelWidth(l10n.save) + 40 + (isSaving ? 26 : 0))
                .clamp(96.0, double.infinity);
            final compact =
                resetWidth + saveWidth + 2 * OpenVtsSpacing.xs + 24 <=
                constraints.maxWidth;
            final resetButton = OpenVtsButton(
              label: l10n.reset,
              variant: OpenVtsButtonVariant.secondary,
              onPressed: canReset ? onReset : null,
            );
            final saveButton = OpenVtsButton(
              label: l10n.save,
              isLoading: isSaving,
              onPressed: canSave ? onSave : null,
            );
            final status = Semantics(
              liveRegion: isSaving,
              child: Text(
                helperText,
                maxLines: compact ? 1 : null,
                overflow: compact ? TextOverflow.ellipsis : null,
                style: OpenVtsTypography.meta.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
            if (!compact) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  status,
                  const SizedBox(height: OpenVtsSpacing.xs),
                  Row(
                    children: [
                      Expanded(child: resetButton),
                      const SizedBox(width: OpenVtsSpacing.xs),
                      Expanded(child: saveButton),
                    ],
                  ),
                ],
              );
            }
            return Row(
              children: [
                Expanded(child: status),
                const SizedBox(width: OpenVtsSpacing.xs),
                SizedBox(width: resetWidth, child: resetButton),
                const SizedBox(width: OpenVtsSpacing.xs),
                SizedBox(width: saveWidth, child: saveButton),
              ],
            );
          },
        ),
      ),
    );
  }
}
