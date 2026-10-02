import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/app_legal_links.dart';
import '../../../../core/theme/open_vts_colors.dart';
import '../../../../core/theme/open_vts_radius.dart';
import '../../../../core/theme/open_vts_spacing.dart';
import '../../../../core/theme/open_vts_typography.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/open_vts_card.dart';
import '../../../../shared/widgets/open_vts_page_scaffold.dart';
import '../../controllers/superadmin_providers.dart';
import '../../models/superadmin_settings_model.dart';
import '../../models/superadmin_settings_state.dart';
import 'widgets/general_settings_section.dart';
import 'widgets/localization_settings_section.dart';
import 'widgets/profile_settings_section.dart';
import 'widgets/white_label_settings_section.dart';

class SuperadminSettingsScreen extends ConsumerStatefulWidget {
  const SuperadminSettingsScreen({super.key});

  @override
  ConsumerState<SuperadminSettingsScreen> createState() =>
      _SuperadminSettingsScreenState();
}

class _SuperadminSettingsScreenState
    extends ConsumerState<SuperadminSettingsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      unawaited(
        ref.read(superadminSettingsControllerProvider.notifier).loadInitial(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(superadminSettingsControllerProvider);

    final l10n = AppLocalizations.of(context);
    return OpenVtsPageScaffold(
      title: l10n.settings,
      headerMode: OpenVtsPageHeaderMode.closeable,
      padding: const EdgeInsets.fromLTRB(
        OpenVtsSpacing.sm,
        OpenVtsSpacing.sm,
        OpenVtsSpacing.sm,
        OpenVtsSpacing.md,
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          const _SettingsHeader(),
          const SizedBox(height: OpenVtsSpacing.sm),
          _SectionSelector(selected: state.selectedSection),
          const SizedBox(height: OpenVtsSpacing.sm),
          _SectionContent(state: state),
            const AppLegalLinks(),
        ],
      ),
    );
  }
}

// =====================================================================
// Top header card
// =====================================================================

class _SettingsHeader extends StatelessWidget {
  const _SettingsHeader();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return OpenVtsCard(
      padding: const EdgeInsets.symmetric(
        horizontal: OpenVtsSpacing.md,
        vertical: OpenVtsSpacing.sm,
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isDark ? Colors.black : OpenVtsColors.white,
              borderRadius: BorderRadius.circular(OpenVtsRadius.md),
              border: isDark
                  ? Border.all(color: Colors.white, width: 1)
                  : Border.all(color: OpenVtsColors.border, width: 1),
            ),
            child: Icon(
              Icons.tune_rounded,
              size: 18,
              color: isDark ? Colors.white : OpenVtsColors.brandInk,
            ),
          ),
          const SizedBox(width: OpenVtsSpacing.sm),
          Expanded(
            child: Builder(
              builder: (context) {
                final l10n = AppLocalizations.of(context);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l10n.settings,
                      style: TextStyle(
                        fontFamily: OpenVtsTypography.primaryFontFamily,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.settingsHeaderSubtitle,
                      style: TextStyle(
                        fontFamily: OpenVtsTypography.primaryFontFamily,
                        fontSize: 11.5,
                        height: 1.35,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// Horizontal section selector
// =====================================================================

class _SectionItem {
  const _SectionItem(this.section, this.label, this.icon);
  final SuperadminSettingsSection section;
  final String label;
  final IconData icon;
}

List<_SectionItem> _buildSections(AppLocalizations l10n) => [
      _SectionItem(
        SuperadminSettingsSection.profile,
        l10n.profile,
        Icons.person_outline_rounded,
      ),
      _SectionItem(
        SuperadminSettingsSection.whiteLabel,
        l10n.whiteLabel,
        Icons.palette_outlined,
      ),
      _SectionItem(
        SuperadminSettingsSection.localization,
        l10n.localization,
        Icons.public_rounded,
      ),
      _SectionItem(
        SuperadminSettingsSection.general,
        l10n.settings,
        Icons.settings_suggest_outlined,
      ),
    ];

class _SectionSelector extends ConsumerWidget {
  const _SectionSelector({required this.selected});

  final SuperadminSettingsSection selected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sections = _buildSections(AppLocalizations.of(context));
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 2),
        physics: const BouncingScrollPhysics(),
        itemCount: sections.length,
        separatorBuilder: (_, __) => const SizedBox(width: OpenVtsSpacing.xs),
        itemBuilder: (context, index) {
          final item = sections[index];
          final isSelected = item.section == selected;
          return _SectionChip(
            item: item,
            isSelected: isSelected,
            onTap: () {
              ref
                  .read(superadminSettingsControllerProvider.notifier)
                  .selectSection(item.section);
            },
          );
        },
      ),
    );
  }
}

class _SectionChip extends StatelessWidget {
  const _SectionChip({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final _SectionItem item;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bg = isSelected ? scheme.primary : scheme.surfaceContainer;
    final fg = isSelected ? scheme.onPrimary : scheme.onSurface;
    final borderColor = isSelected ? scheme.primary : scheme.outlineVariant;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(OpenVtsRadius.pill),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: OpenVtsSpacing.sm,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(OpenVtsRadius.pill),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(item.icon, size: 14, color: fg),
              const SizedBox(width: 6),
              Text(
                item.label,
                style: TextStyle(
                  fontFamily: OpenVtsTypography.primaryFontFamily,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: fg,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =====================================================================
// Section dispatch
// =====================================================================

class _SectionContent extends ConsumerWidget {
  const _SectionContent({required this.state});

  final SuperadminSettingsState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    switch (state.selectedSection) {
      case SuperadminSettingsSection.profile:
        return ProfileSettingsSection(state: state);
      case SuperadminSettingsSection.whiteLabel:
        return WhiteLabelSettingsSection(state: state);
      case SuperadminSettingsSection.localization:
        return LocalizationSettingsSection(state: state);
      case SuperadminSettingsSection.general:
        return GeneralSettingsSection(state: state);
    }
  }
}
