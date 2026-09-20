import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/open_vts_radius.dart';
import '../../../../../core/theme/open_vts_spacing.dart';
import '../../../../../core/theme/open_vts_typography.dart';
import '../../../../../core/utils/date_time_formatter.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/open_vts_card.dart';
import '../../../../../shared/widgets/open_vts_status_chip.dart';
import '../../../models/user_settings_model.dart';

class UserSettingsHeader extends ConsumerWidget {
  const UserSettingsHeader({
    required this.selectedTab,
    required this.isCurrentTabDirty,
    required this.isCurrentTabSaving,
    this.lastUpdatedAt,
    super.key,
  });

  final UserSettingsTab selectedTab;
  final bool isCurrentTabDirty;
  final bool isCurrentTabSaving;
  final DateTime? lastUpdatedAt;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final settingsDateFormatter = ref.watch(appDateFormatterProvider);
    final tabLabel = selectedTab == UserSettingsTab.profile
        ? l10n.profile
        : l10n.localization;

    final statusChip = isCurrentTabSaving
        ? OpenVtsStatusChip(
            label: l10n.loading,
            type: OpenVtsStatusType.info,
          )
        : OpenVtsStatusChip(
            label: isCurrentTabDirty ? l10n.unsavedChanges : l10n.success,
            type: isCurrentTabDirty
                ? OpenVtsStatusType.warning
                : OpenVtsStatusType.neutral,
          );

    return OpenVtsCard(
      padding: const EdgeInsets.all(OpenVtsSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(OpenVtsRadius.sm),
                  border: Border.all(
                      color: Theme.of(context).colorScheme.outlineVariant),
                ),
                child: Icon(
                  Icons.settings_outlined,
                  size: 16,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: OpenVtsSpacing.xs),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.settings,
                      style: TextStyle(
                        fontFamily: OpenVtsTypography.primaryFontFamily,
                        fontSize: 14,
                        height: 1.25,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      selectedTab == UserSettingsTab.localization
                          ? l10n.localizationDescription
                          : l10n.settingsDescription,
                      style: TextStyle(
                        fontFamily: OpenVtsTypography.primaryFontFamily,
                        fontSize: 11.5,
                        height: 1.35,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: OpenVtsSpacing.xs),
          Wrap(
            spacing: OpenVtsSpacing.xs,
            runSpacing: OpenVtsSpacing.xs,
            children: [
              OpenVtsStatusChip(
                label: tabLabel,
                type: OpenVtsStatusType.neutral,
              ),
              statusChip,
            ],
          ),
          if (lastUpdatedAt != null) ...[
            const SizedBox(height: OpenVtsSpacing.xs),
            Text(
              'Profile updated ${settingsDateFormatter.formatDateTime(lastUpdatedAt!.toLocal())}',
              style: OpenVtsTypography.meta.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
