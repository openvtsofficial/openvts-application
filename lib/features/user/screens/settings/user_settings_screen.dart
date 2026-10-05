import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/app_preferences_provider.dart';
import '../../../../core/theme/open_vts_colors.dart';
import '../../../../core/theme/open_vts_radius.dart';
import '../../../../core/theme/open_vts_spacing.dart';
import '../../../../core/theme/open_vts_typography.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/helpers/mobile_text.dart';
import '../../../../shared/helpers/toast_helper.dart';
import '../../../../shared/widgets/open_vts_button.dart';
import '../../../../shared/widgets/open_vts_error_view.dart';
import '../../../../shared/widgets/open_vts_loader.dart';
import '../../../../shared/widgets/open_vts_page_scaffold.dart';
import '../../../auth/controllers/security_controller.dart';
import '../../../auth/screens/security_screen.dart';
import '../../controllers/user_providers.dart';
import '../../models/user_settings_model.dart';
import '../../models/user_settings_state.dart';
import 'widgets/user_localization_settings_tab.dart';
import 'widgets/user_profile_settings_tab.dart';
import 'widgets/user_settings_header.dart';
import 'widgets/user_settings_save_bar.dart';
import 'widgets/user_settings_tab_selector.dart';

const double _settingsMaxWidth = 920;

class UserSettingsScreen extends ConsumerStatefulWidget {
  const UserSettingsScreen({super.key, this.openSecurity = false});
  final bool openSecurity;

  @override
  ConsumerState<UserSettingsScreen> createState() => _UserSettingsScreenState();
}

class _UserSettingsScreenState extends ConsumerState<UserSettingsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && widget.openSecurity) {
        ref
            .read(userSettingsControllerProvider.notifier)
            .selectTab(UserSettingsTab.security);
      }
    });
  }

  @override
  void didUpdateWidget(covariant UserSettingsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.openSecurity && !oldWidget.openSecurity) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ref
              .read(userSettingsControllerProvider.notifier)
              .selectTab(UserSettingsTab.security);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    ref.listen<UserSettingsState>(
      userSettingsControllerProvider,
      _handleStateTransition,
    );

    final state = ref.watch(userSettingsControllerProvider);
    final controller = ref.read(userSettingsControllerProvider.notifier);

    final isProfileFirstLoad =
        !state.hasProfile && (state.isLoadingInitial || state.isLoadingProfile);
    final profileFailureMessage = _firstMeaningful(
      state.profileErrorMessage,
      state.errorMessage,
    );
    final didProfileLoadFail =
        !state.hasProfile && profileFailureMessage != null;
    final selectedTab = state.selectedTab;
    final isProfileTab = selectedTab == UserSettingsTab.profile;
    final isSecurityTab = selectedTab == UserSettingsTab.security;
    final currentTabDirty =
        !isSecurityTab &&
        (isProfileTab ? state.isProfileDirty : state.isLocalizationDirty);
    final currentTabSaving =
        !isSecurityTab &&
        (isProfileTab ? state.isSavingProfile : state.isSavingLocalization);
    final canResetCurrentTab = currentTabDirty && !currentTabSaving;
    final canSaveCurrentTab = isProfileTab
        ? state.canSaveProfile
        : state.canSaveLocalization;

    // Toolbar refresh indicator reflects only the current tab's busy state, not
    // every background Settings operation.
    final currentTabRefreshBusy = isSecurityTab
        ? ref.watch(securityControllerProvider).loading
        : isProfileTab
        ? state.isProfileRefreshBusy
        : state.isLocalizationRefreshBusy;

    Future<void> onRefreshCurrentTab() async {
      if (isSecurityTab) {
        await ref.read(securityControllerProvider.notifier).load();
        return;
      }
      if (currentTabRefreshBusy) {
        return;
      }

      final shouldDiscardUnsaved = currentTabDirty;
      if (shouldDiscardUnsaved) {
        final confirmed = await _confirmDiscardAndRefresh(
          context,
          tabLabel: isProfileTab ? l10n.profile : l10n.localization,
        );
        if (!confirmed) {
          return;
        }
      }

      await controller.refreshCurrentTab(discardUnsaved: shouldDiscardUnsaved);
    }

    Future<void> onSaveCurrentTab() async {
      final saved = isProfileTab
          ? await controller.saveProfile()
          : await controller.saveLocalization();
      if (!mounted || !saved) {
        return;
      }

      if (!isProfileTab) {
        final loc = ref.read(userSettingsControllerProvider).localization;
        if (loc != null) {
          await ref
              .read(appLocalizationPreferencesProvider.notifier)
              .applyFromUserSettings(
                languageCode: loc.language,
                dateFormat: loc.dateFormat,
                timeFormat: loc.use24Hour ? '24H' : '12H',
                theme: loc.theme.apiValue,
                timezone: loc.timezoneOffset,
                layoutDirection: loc.layoutDirection.apiValue,
                units: loc.units.apiValue,
              );
        }
        if (!mounted) return;
      }

      ToastHelper.showSuccess(
        isProfileTab ? l10n.profileUpdated : l10n.localizationUpdated,
      );
    }

    void onResetCurrentTab() {
      if (isProfileTab) {
        controller.resetProfileDraft();
      } else {
        controller.resetLocalizationDraft();
      }
    }

    return OpenVtsPageScaffold(
      title: l10n.settings,
      headerMode: OpenVtsPageHeaderMode.closeable,
      padding: const EdgeInsets.fromLTRB(
        OpenVtsSpacing.sm,
        OpenVtsSpacing.xs,
        OpenVtsSpacing.sm,
        0,
      ),
      actions: [
        IconButton(
          tooltip: l10n.refresh,
          constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
          onPressed: currentTabRefreshBusy
              ? null
              : () {
                  unawaited(onRefreshCurrentTab());
                },
          icon: currentTabRefreshBusy
              ? const SizedBox.square(
                  dimension: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.refresh_rounded, size: 18),
        ),
      ],
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: _settingsMaxWidth),
              child: Column(
                children: [
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: onRefreshCurrentTab,
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.only(
                          bottom: OpenVtsSpacing.md,
                        ),
                        children: [
                          UserSettingsHeader(
                            selectedTab: selectedTab,
                            isCurrentTabDirty: currentTabDirty,
                            isCurrentTabSaving: currentTabSaving,
                            lastUpdatedAt: state.profile?.updatedAt,
                          ),
                          const SizedBox(height: OpenVtsSpacing.sm),
                          UserSettingsTabSelector(
                            selectedTab: selectedTab,
                            onChanged: controller.selectTab,
                          ),
                          const SizedBox(height: OpenVtsSpacing.sm),
                          if (!isSecurityTab &&
                              state.errorMessage != null &&
                              state.errorMessage!.trim().isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: OpenVtsSpacing.sm,
                              ),
                              child: _InlineNoticeBanner(
                                message: state.errorMessage!,
                                tone: _NoticeTone.error,
                                onDismiss: controller.clearErrorMessage,
                              ),
                            ),
                          if (selectedTab == UserSettingsTab.localization &&
                              state.localizationErrorMessage != null &&
                              state.localizationErrorMessage!.trim().isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: OpenVtsSpacing.sm,
                              ),
                              child: _InlineNoticeBanner(
                                message: context.mobileText(
                                  "Using safe defaults. {value1}",
                                  {
                                    'value1': (state.localizationErrorMessage!)
                                        .toString(),
                                  },
                                ),
                                tone: _NoticeTone.warning,
                                onDismiss:
                                    controller.clearLocalizationErrorMessage,
                              ),
                            ),
                          if (isProfileTab &&
                              state.profileErrorMessage != null &&
                              state.profileErrorMessage!.trim().isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: OpenVtsSpacing.sm,
                              ),
                              child: _InlineNoticeBanner(
                                message: state.profileErrorMessage!,
                                tone: _NoticeTone.error,
                                onDismiss: controller.clearProfileErrorMessage,
                              ),
                            ),
                          if (isSecurityTab)
                            const SecurityScreen(embedded: true)
                          else if (isProfileTab && isProfileFirstLoad)
                            const SizedBox(height: 180, child: OpenVtsLoader())
                          else if (isProfileTab && didProfileLoadFail)
                            OpenVtsErrorView(
                              message: profileFailureMessage,
                              onRetry: controller.loadProfile,
                            )
                          else if (isProfileTab)
                            UserProfileSettingsTab(
                              state: state,
                              controller: controller,
                            )
                          else
                            UserLocalizationSettingsTab(
                              state: state,
                              controller: controller,
                            ),
                          const SizedBox(height: OpenVtsSpacing.sm),
                        ],
                      ),
                    ),
                  ),
                  if (currentTabDirty || currentTabSaving)
                    UserSettingsSaveBar(
                      selectedTab: selectedTab,
                      isSaving: currentTabSaving,
                      canSave: canSaveCurrentTab,
                      canReset: canResetCurrentTab,
                      onSave: () {
                        unawaited(onSaveCurrentTab());
                      },
                      onReset: onResetCurrentTab,
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _handleStateTransition(
    UserSettingsState? previous,
    UserSettingsState next,
  ) {
    final previousError = previous?.errorMessage?.trim();
    final currentError = next.errorMessage?.trim();
    if (currentError != null &&
        currentError.isNotEmpty &&
        currentError != previousError) {
      ToastHelper.showError(currentError);
    }

    final previousProfileError = previous?.profileErrorMessage?.trim();
    final currentProfileError = next.profileErrorMessage?.trim();
    if (currentProfileError != null &&
        currentProfileError.isNotEmpty &&
        currentProfileError != previousProfileError) {
      ToastHelper.showError(currentProfileError);
    }

    final previousLocalizationError = previous?.localizationErrorMessage
        ?.trim();
    final currentLocalizationError = next.localizationErrorMessage?.trim();
    if (currentLocalizationError != null &&
        currentLocalizationError.isNotEmpty &&
        currentLocalizationError != previousLocalizationError) {
      ToastHelper.showError(currentLocalizationError);
    }
  }

  String? _firstMeaningful(String? first, String? second) {
    final a = first?.trim();
    if (a != null && a.isNotEmpty) {
      return a;
    }
    final b = second?.trim();
    if (b != null && b.isNotEmpty) {
      return b;
    }
    return null;
  }

  Future<bool> _confirmDiscardAndRefresh(
    BuildContext context, {
    required String tabLabel,
  }) async {
    final l10n = AppLocalizations.of(context);
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        final insets = MediaQuery.viewInsetsOf(sheetContext).bottom;

        return DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(sheetContext).colorScheme.surfaceContainer,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(OpenVtsRadius.lg),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                OpenVtsSpacing.md,
                OpenVtsSpacing.md,
                OpenVtsSpacing.md,
                OpenVtsSpacing.sm + insets,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.confirmDiscard,
                    style: OpenVtsTypography.label.copyWith(
                      color: Theme.of(sheetContext).colorScheme.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: OpenVtsSpacing.xs),
                  Text(
                    l10n.confirmDiscardMessage(tabLabel),
                    style: OpenVtsTypography.body.copyWith(
                      color: Theme.of(
                        sheetContext,
                      ).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: OpenVtsSpacing.sm),
                  Row(
                    children: [
                      Expanded(
                        child: OpenVtsButton(
                          label: l10n.keepEditing,
                          height: 44,
                          variant: OpenVtsButtonVariant.secondary,
                          onPressed: () {
                            Navigator.of(sheetContext).pop(false);
                          },
                        ),
                      ),
                      const SizedBox(width: OpenVtsSpacing.xs),
                      Expanded(
                        child: OpenVtsButton(
                          label: l10n.discardChanges,
                          height: 44,
                          onPressed: () {
                            Navigator.of(sheetContext).pop(true);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    return result == true;
  }
}

enum _NoticeTone { warning, error }

class _InlineNoticeBanner extends StatelessWidget {
  const _InlineNoticeBanner({
    required this.message,
    required this.tone,
    this.onDismiss,
  });

  final String message;
  final _NoticeTone tone;
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    final isWarning = tone == _NoticeTone.warning;
    final foreground = isWarning ? OpenVtsColors.warning : OpenVtsColors.error;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: foreground.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(OpenVtsRadius.md),
        border: Border.all(color: foreground.withValues(alpha: 0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          OpenVtsSpacing.sm,
          OpenVtsSpacing.xs,
          OpenVtsSpacing.xs,
          OpenVtsSpacing.xs,
        ),
        child: Row(
          children: [
            Icon(
              isWarning
                  ? Icons.warning_amber_rounded
                  : Icons.error_outline_rounded,
              size: 17,
              color: foreground,
            ),
            const SizedBox(width: OpenVtsSpacing.xs),
            Expanded(
              child: Text(
                message,
                style: OpenVtsTypography.body.copyWith(color: foreground),
              ),
            ),
            if (onDismiss != null)
              IconButton(
                tooltip: context.mobileText('Dismiss'),
                onPressed: onDismiss,
                iconSize: 16,
                constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
                icon: Icon(Icons.close_rounded, color: foreground),
              ),
          ],
        ),
      ),
    );
  }
}
