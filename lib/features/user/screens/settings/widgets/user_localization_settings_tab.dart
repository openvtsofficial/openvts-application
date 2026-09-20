import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../../core/providers/app_preferences_provider.dart';
import '../../../../../core/theme/open_vts_colors.dart';
import '../../../../../core/theme/open_vts_radius.dart';
import '../../../../../core/theme/open_vts_spacing.dart';
import '../../../../../core/theme/open_vts_typography.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/open_vts_card.dart';
import '../../../controllers/user_settings_controller.dart';
import '../../../models/user_settings_model.dart';
import '../../../models/user_settings_state.dart';
import 'user_localization_preview_card.dart';
import 'user_localization_select_card.dart';
import 'user_location_preset_chips.dart';
import 'user_map_defaults_card.dart';

class UserLocalizationSettingsTab extends StatefulWidget {
  const UserLocalizationSettingsTab({
    required this.state,
    required this.controller,
    super.key,
  });

  final UserSettingsState state;
  final UserSettingsController controller;

  @override
  State<UserLocalizationSettingsTab> createState() =>
      _UserLocalizationSettingsTabState();
}

class _UserLocalizationSettingsTabState
    extends State<UserLocalizationSettingsTab> {
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  final TextEditingController _mapZoomController = TextEditingController();

  // Guards _onChanged callbacks while we're programmatically updating text.
  bool _isHydrating = false;

  // Tracks the epoch we last hydrated from. When the epoch advances we
  // re-sync the text controllers; all other state changes are ignored.
  int _hydratedEpoch = -1;

  String? _latitudeError;
  String? _longitudeError;
  String? _mapZoomError;

  UserLocalizationSettings get _draft =>
      widget.state.draftLocalization ??
      widget.state.localization ??
      UserLocalizationSettings.defaults;

  @override
  void initState() {
    super.initState();
    // Hydrate once from the current epoch — this is the single initial sync.
    _hydrateMapControllers(_draft, clearErrors: true);
    _hydratedEpoch = widget.state.localizationHydrationEpoch;
  }

  @override
  void didUpdateWidget(covariant UserLocalizationSettingsTab oldWidget) {
    super.didUpdateWidget(oldWidget);

    final newEpoch = widget.state.localizationHydrationEpoch;
    if (newEpoch != _hydratedEpoch) {
      // A deliberate hydration event occurred (initial load, refresh, reset,
      // preset, successful save). Re-sync the text controllers.
      _hydrateMapControllers(_draft, clearErrors: true);
      _hydratedEpoch = newEpoch;
    }
    // All other widget updates (loading flags, reference changes, error
    // changes, theme/language edits, etc.) are intentionally ignored here
    // so that the user's in-progress typed text is preserved.
  }

  @override
  void dispose() {
    _latitudeController.dispose();
    _longitudeController.dispose();
    _mapZoomController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final draft = _draft;

    final languageOptions = _buildLanguageOptions(draft);
    final dateFormatOptions = _buildDateFormatOptions(draft);
    final timezoneOptions = _buildTimezoneOptions(draft);

    final hasUnsupportedSavedLanguage =
        !isFlutterLanguageSupported(draft.language);
    final languageLabel = hasUnsupportedSavedLanguage
        ? l10n.en
        : _labelForValue(
            options: languageOptions,
            value: draft.language,
            fallback: draft.language.toUpperCase(),
          );

    final showReferenceFallbackWarning = !widget.state.isLoadingReferences &&
        (hasUnsupportedSavedLanguage ||
            widget.state.languages.isEmpty ||
            widget.state.dateFormats.isEmpty ||
            widget.state.timezones.isEmpty);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        UserLocalizationPreviewCard(
          settings: draft,
          languageLabel: languageLabel,
        ),
        if (showReferenceFallbackWarning) ...[
          const SizedBox(height: OpenVtsSpacing.sm),
          _ReferenceFallbackWarning(
            message: hasUnsupportedSavedLanguage
                ? l10n.unsupportedLanguageFallback
                : widget.state.errorMessage,
            onRetry: () {
              unawaited(widget.controller.loadReferenceData(force: true));
            },
          ),
        ],
        const SizedBox(height: OpenVtsSpacing.sm),
        UserLocalizationSelectCard(
          title: l10n.languageAndDirection,
          subtitle: l10n.languageAndDirectionSubtitle,
          icon: Icons.translate_rounded,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserLocalizationPickerTile(
                label: l10n.language,
                valueLabel: languageLabel,
                onTap: () => _pickLanguage(languageOptions),
                hintText: l10n.selectLanguage,
              ),
              const SizedBox(height: OpenVtsSpacing.sm),
              _SegmentedField<UserLayoutDirection>(
                label: l10n.textDirection,
                child: UserLocalizationSegmentedControl<UserLayoutDirection>(
                  value: draft.layoutDirection,
                  semanticsLabel: l10n.textDirection,
                  segments: const [
                    UserLocalizationSegmentOption<UserLayoutDirection>(
                      value: UserLayoutDirection.ltr,
                      label: 'LTR',
                    ),
                    UserLocalizationSegmentOption<UserLayoutDirection>(
                      value: UserLayoutDirection.rtl,
                      label: 'RTL',
                    ),
                  ],
                  onChanged: (value) {
                    widget.controller.patchDraftLocalization(
                      layoutDirection: value,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: OpenVtsSpacing.sm),
        UserLocalizationSelectCard(
          title: l10n.dateAndTime,
          subtitle: l10n.dateAndTimeSubtitle,
          icon: Icons.event_note_rounded,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserLocalizationPickerTile(
                label: l10n.dateFormat,
                valueLabel: _labelForValue(
                  options: dateFormatOptions,
                  value: draft.dateFormat,
                  fallback: draft.dateFormat,
                ),
                onTap: () => _pickDateFormat(dateFormatOptions),
                hintText: l10n.selectDateFormat,
              ),
              const SizedBox(height: OpenVtsSpacing.sm),
              _SegmentedField<bool>(
                label: l10n.timeFormat,
                child: UserLocalizationSegmentedControl<bool>(
                  value: draft.use24Hour,
                  semanticsLabel: l10n.timeFormat,
                  segments: const [
                    UserLocalizationSegmentOption<bool>(
                      value: true,
                      label: '24H',
                    ),
                    UserLocalizationSegmentOption<bool>(
                      value: false,
                      label: '12H',
                    ),
                  ],
                  onChanged: (value) {
                    widget.controller.patchDraftLocalization(use24Hour: value);
                  },
                ),
              ),
              const SizedBox(height: OpenVtsSpacing.sm),
              UserLocalizationPickerTile(
                label: l10n.timezone,
                valueLabel: _labelForValue(
                  options: timezoneOptions,
                  value: draft.timezoneOffset,
                  fallback: draft.timezoneOffset,
                ),
                onTap: () => _pickTimezone(timezoneOptions),
                hintText: l10n.selectTimezone,
              ),
            ],
          ),
        ),
        const SizedBox(height: OpenVtsSpacing.sm),
        UserLocalizationSelectCard(
          title: l10n.unitsAndTheme,
          subtitle: l10n.unitsAndThemeSubtitle,
          icon: Icons.tune_rounded,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SegmentedField<UserDistanceUnit>(
                label: l10n.units,
                child: UserLocalizationSegmentedControl<UserDistanceUnit>(
                  value: draft.units,
                  semanticsLabel: 'Distance unit selector',
                  segments: const [
                    UserLocalizationSegmentOption<UserDistanceUnit>(
                      value: UserDistanceUnit.km,
                      label: 'KM',
                    ),
                    UserLocalizationSegmentOption<UserDistanceUnit>(
                      value: UserDistanceUnit.miles,
                      label: 'MILES',
                    ),
                  ],
                  onChanged: (value) {
                    widget.controller.patchDraftLocalization(units: value);
                  },
                ),
              ),
              const SizedBox(height: OpenVtsSpacing.sm),
              _SegmentedField<UserThemeMode>(
                label: l10n.theme,
                child: UserLocalizationSegmentedControl<UserThemeMode>(
                  value: draft.theme,
                  semanticsLabel: l10n.theme,
                  segments: [
                    UserLocalizationSegmentOption<UserThemeMode>(
                      value: UserThemeMode.system,
                      label: l10n.system,
                    ),
                    UserLocalizationSegmentOption<UserThemeMode>(
                      value: UserThemeMode.light,
                      label: l10n.light,
                    ),
                    UserLocalizationSegmentOption<UserThemeMode>(
                      value: UserThemeMode.dark,
                      label: l10n.dark,
                    ),
                  ],
                  onChanged: (value) {
                    widget.controller.patchDraftLocalization(theme: value);
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: OpenVtsSpacing.sm),
        UserMapDefaultsCard(
          latitudeController: _latitudeController,
          longitudeController: _longitudeController,
          mapZoomController: _mapZoomController,
          latitudeError: _latitudeError,
          longitudeError: _longitudeError,
          mapZoomError: _mapZoomError,
          activePresetLabel: _activePresetLabel(draft),
          onLatitudeChanged: _handleLatitudeChanged,
          onLongitudeChanged: _handleLongitudeChanged,
          onMapZoomChanged: _handleMapZoomChanged,
          onPresetSelected: _applyPreset,
        ),
      ],
    );
  }

  // ── Pickers ───────────────────────────────────────────────────────────────

  Future<void> _pickLanguage(
    List<UserLocalizationOption<String>> options,
  ) async {
    final selected = await showLocalizationOptionPicker<String>(
      context: context,
      title: AppLocalizations.of(context).selectLanguage,
      options: options,
      selectedValue: _draft.language,
      searchHintText: AppLocalizations.of(context).search,
    );

    if (selected == null || !mounted) return;
    widget.controller.patchDraftLocalization(language: selected);
  }

  Future<void> _pickDateFormat(
    List<UserLocalizationOption<String>> options,
  ) async {
    final selected = await showLocalizationOptionPicker<String>(
      context: context,
      title: AppLocalizations.of(context).selectDateFormat,
      options: options,
      selectedValue: _draft.dateFormat,
      searchHintText: AppLocalizations.of(context).search,
    );

    if (selected == null || !mounted) return;
    widget.controller.patchDraftLocalization(dateFormat: selected);
  }

  Future<void> _pickTimezone(
    List<UserLocalizationOption<String>> options,
  ) async {
    final selected = await showLocalizationOptionPicker<String>(
      context: context,
      title: AppLocalizations.of(context).selectTimezone,
      options: options,
      selectedValue: _draft.timezoneOffset,
      searchHintText: AppLocalizations.of(context).search,
    );

    if (selected == null || !mounted) return;
    widget.controller.patchDraftLocalization(timezoneOffset: selected);
  }

  // ── Map field handlers ────────────────────────────────────────────────────

  void _handleLatitudeChanged(String raw) {
    if (_isHydrating) return;
    final l10n = AppLocalizations.of(context);

    final value = raw.trim();
    if (value.isEmpty) {
      _setLatitudeError(l10n.latitudeRequired);
      return;
    }

    final parsed = double.tryParse(value);
    if (parsed == null) {
      _setLatitudeError(l10n.validLatitude);
      return;
    }

    if (parsed < -90 || parsed > 90) {
      _setLatitudeError(l10n.latitudeRange);
      return;
    }

    _setLatitudeError(null);
    widget.controller.patchDraftLocalization(defaultLat: parsed);
  }

  void _handleLongitudeChanged(String raw) {
    if (_isHydrating) return;
    final l10n = AppLocalizations.of(context);

    final value = raw.trim();
    if (value.isEmpty) {
      _setLongitudeError(l10n.longitudeRequired);
      return;
    }

    final parsed = double.tryParse(value);
    if (parsed == null) {
      _setLongitudeError(l10n.validLongitude);
      return;
    }

    if (parsed < -180 || parsed > 180) {
      _setLongitudeError(l10n.longitudeRange);
      return;
    }

    _setLongitudeError(null);
    widget.controller.patchDraftLocalization(defaultLon: parsed);
  }

  void _handleMapZoomChanged(String raw) {
    if (_isHydrating) return;
    final l10n = AppLocalizations.of(context);

    final value = raw.trim();
    if (value.isEmpty) {
      _setMapZoomError(l10n.mapZoomRequired);
      return;
    }

    final parsed = int.tryParse(value);
    if (parsed == null) {
      _setMapZoomError(l10n.validMapZoom);
      return;
    }

    if (parsed < 1 || parsed > 22) {
      _setMapZoomError(l10n.mapZoomRange);
      return;
    }

    _setMapZoomError(null);
    widget.controller.patchDraftLocalization(mapZoom: parsed);
  }

  // Preset applies values immediately and bumps epoch via controller so any
  // future sibling widget also re-syncs if needed.
  void _applyPreset(UserLocationPreset preset) {
    _isHydrating = true;
    _setText(_latitudeController, _formatDouble(preset.latitude));
    _setText(_longitudeController, _formatDouble(preset.longitude));
    _setText(_mapZoomController, preset.zoom.toString());
    _isHydrating = false;

    _clearMapErrors();
    widget.controller.patchDraftLocalization(
      defaultLat: preset.latitude,
      defaultLon: preset.longitude,
      mapZoom: preset.zoom,
    );
  }

  // ── Hydration ─────────────────────────────────────────────────────────────

  void _hydrateMapControllers(
    UserLocalizationSettings settings, {
    required bool clearErrors,
  }) {
    _isHydrating = true;
    _setText(_latitudeController, _formatDouble(settings.defaultLat));
    _setText(_longitudeController, _formatDouble(settings.defaultLon));
    _setText(_mapZoomController, settings.mapZoom.toString());
    _isHydrating = false;

    if (clearErrors) _clearMapErrors();
  }

  void _setText(TextEditingController controller, String value) {
    if (controller.text == value) return;
    controller.value = TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
    );
  }

  // ── Error helpers ─────────────────────────────────────────────────────────

  void _setLatitudeError(String? error) {
    if (_latitudeError == error) return;
    setState(() => _latitudeError = error);
  }

  void _setLongitudeError(String? error) {
    if (_longitudeError == error) return;
    setState(() => _longitudeError = error);
  }

  void _setMapZoomError(String? error) {
    if (_mapZoomError == error) return;
    setState(() => _mapZoomError = error);
  }

  void _clearMapErrors() {
    if (_latitudeError == null &&
        _longitudeError == null &&
        _mapZoomError == null) {
      return;
    }
    setState(() {
      _latitudeError = null;
      _longitudeError = null;
      _mapZoomError = null;
    });
  }

  // ── Option builders ───────────────────────────────────────────────────────

  List<UserLocalizationOption<String>> _buildLanguageOptions(
    UserLocalizationSettings draft,
  ) {
    final supportedCodes = flutterSupportedLanguageCodes;
    final options = widget.state.languages
        .where((item) => isFlutterLanguageSupported(item.code))
        .map(
          (item) => UserLocalizationOption<String>(
            value: item.code,
            label: _languageOptionLabel(context, item.code),
            searchTokens: [
              item.code,
              item.label,
              _languageOptionLabel(context, item.code),
            ],
          ),
        )
        .toList(growable: true);

    for (final locale in AppLocalizations.supportedLocales) {
      final code = locale.languageCode;
      if (!options.any((item) => _flutterLocaleCode(item.value) == code)) {
        options.add(
          UserLocalizationOption<String>(
            value: code,
            label: _localizedLanguageName(context, code),
            searchTokens: [code, _localizedLanguageName(context, code)],
          ),
        );
      }
    }

    final current = draft.language.trim();
    if (supportedCodes.contains(_flutterLocaleCode(current)) &&
        current.isNotEmpty) {
      _prependIfMissing(
        options: options,
        value: current,
        label: current.toUpperCase(),
        matcher: (item) => item.value.toLowerCase(),
      );
    }

    return _distinctBy(options, (item) => item.value.trim().toLowerCase());
  }

  String _flutterLocaleCode(String value) =>
      value.trim().toLowerCase().split(RegExp('[-_]')).first;

  String _localizedLanguageName(BuildContext context, String code) {
    final l10n = AppLocalizations.of(context);
    return switch (code) {
      'ar' => l10n.ar,
      'es' => l10n.es,
      'fr' => l10n.fr,
      'hi' => l10n.hi,
      'pt' => l10n.pt,
      _ => l10n.en,
    };
  }

  String _languageOptionLabel(BuildContext context, String backendCode) {
    final normalized = backendCode.trim().replaceAll('_', '-');
    final baseCode = _flutterLocaleCode(normalized);
    final languageName = _localizedLanguageName(context, baseCode);
    final parts = normalized.split('-');
    return parts.length > 1
        ? '$languageName (${parts.skip(1).join('-').toUpperCase()})'
        : languageName;
  }

  List<UserLocalizationOption<String>> _buildDateFormatOptions(
    UserLocalizationSettings draft,
  ) {
    final options = widget.state.dateFormats
        .map(
          (item) => UserLocalizationOption<String>(
            value: item.value,
            label: item.label,
            searchTokens: [item.value, item.label],
          ),
        )
        .toList(growable: true);

    if (options.isEmpty) {
      options.addAll(const [
        UserLocalizationOption<String>(
          value: 'YYYY-MM-DD',
          label: 'YYYY-MM-DD',
        ),
        UserLocalizationOption<String>(
          value: 'DD/MM/YYYY',
          label: 'DD/MM/YYYY',
        ),
        UserLocalizationOption<String>(
          value: 'MM/DD/YYYY',
          label: 'MM/DD/YYYY',
        ),
      ]);
    }

    final current = draft.dateFormat.trim();
    if (current.isNotEmpty) {
      _prependIfMissing(
        options: options,
        value: current,
        label: current,
        matcher: (item) => item.value,
      );
    }

    return _distinctBy(options, (item) => item.value);
  }

  List<UserLocalizationOption<String>> _buildTimezoneOptions(
    UserLocalizationSettings draft,
  ) {
    final options = widget.state.timezones
        .map(
          (item) => UserLocalizationOption<String>(
            value: item,
            label: item,
            searchTokens: [item],
          ),
        )
        .toList(growable: true);

    if (options.isEmpty) {
      options.addAll(const [
        UserLocalizationOption<String>(value: '+00:00', label: '+00:00 UTC'),
        UserLocalizationOption<String>(value: '+05:30', label: '+05:30 IST'),
        UserLocalizationOption<String>(value: '-08:00', label: '-08:00 PST'),
      ]);
    }

    final current = draft.timezoneOffset.trim();
    if (current.isNotEmpty) {
      _prependIfMissing(
        options: options,
        value: current,
        label: current,
        matcher: (item) => item.value,
      );
    }

    return _distinctBy(options, (item) => item.value);
  }

  String _labelForValue({
    required List<UserLocalizationOption<String>> options,
    required String value,
    required String fallback,
  }) {
    for (final option in options) {
      if (option.value == value) return option.label;
    }

    final normalized = value.trim();
    if (normalized.isNotEmpty) return normalized;

    return fallback;
  }

  void _prependIfMissing({
    required List<UserLocalizationOption<String>> options,
    required String value,
    required String label,
    required String Function(UserLocalizationOption<String>) matcher,
  }) {
    final normalized = value.trim();
    if (normalized.isEmpty) return;

    final exists = options.any((item) => matcher(item) == normalized);
    if (exists) return;

    options.insert(
      0,
      UserLocalizationOption<String>(
        value: normalized,
        label: label,
        searchTokens: [normalized, label],
      ),
    );
  }

  List<UserLocalizationOption<String>> _distinctBy(
    List<UserLocalizationOption<String>> options,
    String Function(UserLocalizationOption<String>) keyOf,
  ) {
    final seen = <String>{};
    final distinct = <UserLocalizationOption<String>>[];

    for (final item in options) {
      final key = keyOf(item);
      if (seen.contains(key)) continue;
      seen.add(key);
      distinct.add(item);
    }

    return distinct;
  }

  String _formatDouble(double value) {
    if (value == value.roundToDouble()) {
      return value.toStringAsFixed(0);
    }

    var formatted = value.toStringAsFixed(6);
    formatted = formatted.replaceFirst(RegExp(r'0+$'), '');
    formatted = formatted.replaceFirst(RegExp(r'\.$'), '');
    return formatted;
  }

  String? _activePresetLabel(UserLocalizationSettings settings) {
    for (final preset in kUserLocationPresets) {
      final latMatches =
          (settings.defaultLat - preset.latitude).abs() <= 0.0001;
      final lonMatches =
          (settings.defaultLon - preset.longitude).abs() <= 0.0001;
      final zoomMatches = settings.mapZoom == preset.zoom;

      if (latMatches && lonMatches && zoomMatches) return preset.label;
    }

    return null;
  }
}

// ── Private supporting widgets ─────────────────────────────────────────────

class _SegmentedField<T> extends StatelessWidget {
  const _SegmentedField({
    required this.label,
    required this.child,
  });

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: OpenVtsTypography.meta.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: OpenVtsSpacing.xxs),
        child,
      ],
    );
  }
}

class _ReferenceFallbackWarning extends StatelessWidget {
  const _ReferenceFallbackWarning({
    required this.message,
    required this.onRetry,
  });

  final String? message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final normalizedMessage = message?.trim();

    return OpenVtsCard(
      padding: const EdgeInsets.all(OpenVtsSpacing.sm),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: OpenVtsColors.warning.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(OpenVtsRadius.md),
          border: Border.all(
            color: OpenVtsColors.warning.withValues(alpha: 0.3),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            OpenVtsSpacing.sm,
            OpenVtsSpacing.xs,
            OpenVtsSpacing.xs,
            OpenVtsSpacing.xs,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 1),
                child: Icon(
                  Icons.warning_amber_rounded,
                  size: 16,
                  color: OpenVtsColors.warning,
                ),
              ),
              const SizedBox(width: OpenVtsSpacing.xs),
              Expanded(
                child: Text(
                  normalizedMessage == null || normalizedMessage.isEmpty
                      ? AppLocalizations.of(context).couldNotLoadLocalization
                      : '${AppLocalizations.of(context).couldNotLoadLocalization} '
                          '$normalizedMessage',
                  style: OpenVtsTypography.meta.copyWith(
                    color: OpenVtsColors.warning,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              TextButton(
                onPressed: onRetry,
                style: TextButton.styleFrom(
                  minimumSize: const Size(0, 44),
                ),
                child: Text(AppLocalizations.of(context).retry),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
