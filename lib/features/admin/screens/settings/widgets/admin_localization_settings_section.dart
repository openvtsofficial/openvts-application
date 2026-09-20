import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../core/providers/app_preferences_provider.dart';
import '../../../../../core/theme/open_vts_radius.dart';
import '../../../../../core/theme/open_vts_spacing.dart';
import '../../../../../core/theme/open_vts_typography.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/helpers/toast_helper.dart';
import '../../../../../shared/widgets/open_vts_button.dart';
import '../../../../../shared/widgets/open_vts_card.dart';
import '../../../../../shared/widgets/open_vts_loader.dart';
import '../../../../../shared/widgets/open_vts_searchable_dropdown.dart';
import '../../../../../shared/widgets/open_vts_text_field.dart';
import '../../../controllers/admin_providers.dart';
import '../../../controllers/admin_settings_controller.dart';
import '../../../models/admin_settings_model.dart';
import '../../../models/admin_settings_state.dart';

// =====================================================================
// Localization settings section
// =====================================================================

class LocalizationSettingsSection extends ConsumerStatefulWidget {
  const LocalizationSettingsSection({super.key, required this.state});

  final AdminSettingsState state;

  @override
  ConsumerState<LocalizationSettingsSection> createState() =>
      _LocalizationSettingsSectionState();
}

class _LocalizationSettingsSectionState
    extends ConsumerState<LocalizationSettingsSection> {
  final _formKey = GlobalKey<FormState>();
  final _latCtrl = TextEditingController();
  final _lonCtrl = TextEditingController();
  final _zoomCtrl = TextEditingController();

  String _language = 'en';
  AdminLayoutDirection _direction = AdminLayoutDirection.ltr;
  String _dateFormat = 'YYYY-MM-DD';
  bool _use24Hour = true;
  AdminTheme _theme = AdminTheme.system;
  String _timezone = '+05:30';
  AdminUnits _units = AdminUnits.km;
  bool _hydrated = false;

  @override
  void initState() {
    super.initState();
    _hydrate(widget.state.localization);
  }

  @override
  void didUpdateWidget(covariant LocalizationSettingsSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_hydrated && widget.state.localization != null) {
      _hydrate(widget.state.localization);
    }
  }

  void _hydrate(AdminLocalizationSettings? loc) {
    if (loc == null) return;
    _language = loc.language.isNotEmpty ? loc.language : 'en';
    _direction = loc.layoutDirection;
    _dateFormat = loc.dateFormat.isNotEmpty ? loc.dateFormat : 'YYYY-MM-DD';
    _use24Hour = loc.use24Hour;
    _theme = loc.theme;
    _timezone = loc.timezoneOffset.isNotEmpty ? loc.timezoneOffset : '+05:30';
    _units = loc.units;
    _latCtrl.text = loc.defaultLat == 0 ? '' : loc.defaultLat.toString();
    _lonCtrl.text = loc.defaultLon == 0 ? '' : loc.defaultLon.toString();
    _zoomCtrl.text = loc.mapZoom.toString();
    _hydrated = true;
  }

  @override
  void dispose() {
    _latCtrl.dispose();
    _lonCtrl.dispose();
    _zoomCtrl.dispose();
    super.dispose();
  }

  AdminSettingsController get _controller =>
      ref.read(adminSettingsControllerProvider.notifier);

  // -----------------------------------------------------------------
  // Save
  // -----------------------------------------------------------------

  bool _isSaving = false;

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;
    if (_isSaving) return;

    setState(() => _isSaving = true);

    final lat = double.tryParse(_latCtrl.text.trim());
    final lon = double.tryParse(_lonCtrl.text.trim());
    final zoom = int.tryParse(_zoomCtrl.text.trim());

    final request = AdminLocalizationSettings(
      language: _language,
      layoutDirection: _direction,
      dateFormat: _dateFormat,
      use24Hour: _use24Hour,
      theme: _theme,
      timezoneOffset: _timezone,
      units: _units,
      defaultLat: lat ?? 0,
      defaultLon: lon ?? 0,
      mapZoom: zoom ?? 10,
    );

    final ok = await _controller.updateLocalization(request);
    if (!mounted) return;

    setState(() => _isSaving = false);

    if (ok) {
      setState(() {
        _hydrated = true;
        _language = request.language;
        _direction = request.layoutDirection;
        _dateFormat = request.dateFormat;
        _use24Hour = request.use24Hour;
        _theme = request.theme;
        _timezone = request.timezoneOffset;
        _units = request.units;
        _latCtrl.text =
            request.defaultLat == 0 ? '' : request.defaultLat.toString();
        _lonCtrl.text =
            request.defaultLon == 0 ? '' : request.defaultLon.toString();
        _zoomCtrl.text = request.mapZoom.toString();
      });

      final prefNotifier =
          ref.read(appLocalizationPreferencesProvider.notifier);
      await prefNotifier.applyFromAdminSettings(
        language: request.language,
        dateFormat: request.dateFormat,
        use24Hour: request.use24Hour,
        theme: request.theme.apiValue,
        timezoneOffset: request.timezoneOffset,
        layoutDirection: request.layoutDirection.apiValue,
        units: request.units.apiValue,
      );
      if (!mounted) return;
      ToastHelper.showSuccess(AppLocalizations.of(context).localizationUpdated);
    } else {
      ToastHelper.showError(
        ref.read(adminSettingsControllerProvider).sectionErrorMessage ??
            l10n.failedToUpdate,
      );
    }
  }

  // -----------------------------------------------------------------
  // Presets
  // -----------------------------------------------------------------

  void _applyPreset(_MapPreset p) {
    setState(() {
      _latCtrl.text = p.lat.toString();
      _lonCtrl.text = p.lon.toString();
      _zoomCtrl.text = p.zoom.toString();
    });
  }

  // -----------------------------------------------------------------
  // Build
  // -----------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final l10n = AppLocalizations.of(context);

    if (state.isLoadingLocalization && state.localization == null) {
      return const OpenVtsCard(
        padding: EdgeInsets.symmetric(vertical: OpenVtsSpacing.lg),
        child: Center(child: OpenVtsLoader()),
      );
    }

    if (state.localization == null) {
      return OpenVtsCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              state.sectionErrorMessage ?? l10n.failedToUpdate,
              style: TextStyle(
                fontFamily: OpenVtsTypography.primaryFontFamily,
                fontSize: 12.5,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: OpenVtsSpacing.sm),
            OpenVtsButton(
              label: l10n.retry,
              variant: OpenVtsButtonVariant.secondary,
              height: 40,
              onPressed: _controller.loadLocalization,
            ),
          ],
        ),
      );
    }

    final languages = state.languages;
    final dateFormats = state.dateFormats;
    final timezones = state.timezones;

    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SectionHeader(
            title: l10n.localization,
            subtitle: l10n.localizationDescription,
            icon: Icons.public_rounded,
            trailing: IconButton(
              tooltip: l10n.refresh,
              onPressed: state.isLoadingLocalization
                  ? null
                  : _controller.loadLocalization,
              iconSize: 18,
              visualDensity: VisualDensity.compact,
              icon: const Icon(Icons.refresh_rounded),
            ),
          ),
          const SizedBox(height: OpenVtsSpacing.sm),
          _PreviewCard(
            dateFormat: _dateFormat,
            use24Hour: _use24Hour,
            timezone: _timezone,
            units: _units,
            language: _language,
            direction: _direction,
          ),
          const SizedBox(height: OpenVtsSpacing.sm),
          _GroupedCard(
            icon: Icons.translate_rounded,
            title: 'Language & Direction',
            subtitle: 'Interface language and text direction.',
            children: [
              _LanguageDropdown(
                value: _language,
                options: languages,
                onChanged: (v) {
                  if (v == null) return;
                  setState(() => _language = v);
                },
              ),
              const SizedBox(height: OpenVtsSpacing.sm),
              _LabeledRow(
                label: l10n.direction,
                child: _SegmentedControl<AdminLayoutDirection>(
                  value: _direction,
                  segments: const [
                    _Seg(value: AdminLayoutDirection.ltr, label: 'LTR'),
                    _Seg(value: AdminLayoutDirection.rtl, label: 'RTL'),
                  ],
                  onChanged: (v) => setState(() => _direction = v),
                ),
              ),
            ],
          ),
          const SizedBox(height: OpenVtsSpacing.sm),
          _GroupedCard(
            icon: Icons.event_note_rounded,
            title: 'Date & Time',
            subtitle: 'Date format, time style, and timezone.',
            children: [
              _DateFormatDropdown(
                value: _dateFormat,
                options: dateFormats,
                onChanged: (v) {
                  if (v == null) return;
                  setState(() => _dateFormat = v);
                },
              ),
              const SizedBox(height: OpenVtsSpacing.sm),
              _LabeledRow(
                label: l10n.use24Hour,
                trailing: Switch.adaptive(
                  value: _use24Hour,
                  onChanged: (v) => setState(() => _use24Hour = v),
                ),
              ),
              const SizedBox(height: OpenVtsSpacing.sm),
              _TimezoneDropdown(
                value: _timezone,
                options: timezones,
                onChanged: (v) {
                  if (v == null) return;
                  setState(() => _timezone = v);
                },
              ),
            ],
          ),
          const SizedBox(height: OpenVtsSpacing.sm),
          _GroupedCard(
            icon: Icons.tune_rounded,
            title: 'Units & Theme',
            subtitle: 'Distance units and app appearance.',
            children: [
              _LabeledRow(
                label: l10n.units,
                child: _SegmentedControl<AdminUnits>(
                  value: _units,
                  segments: const [
                    _Seg(value: AdminUnits.km, label: 'KM'),
                    _Seg(value: AdminUnits.miles, label: 'MILES'),
                  ],
                  onChanged: (v) => setState(() => _units = v),
                ),
              ),
              const SizedBox(height: OpenVtsSpacing.sm),
              _LabeledRow(
                label: l10n.theme,
                child: _SegmentedControl<AdminTheme>(
                  value: _theme,
                  segments: [
                    _Seg(value: AdminTheme.light, label: l10n.light),
                    _Seg(value: AdminTheme.dark, label: l10n.dark),
                    _Seg(value: AdminTheme.system, label: l10n.system),
                  ],
                  onChanged: (v) => setState(() => _theme = v),
                ),
              ),
            ],
          ),
          const SizedBox(height: OpenVtsSpacing.sm),
          _GroupedCard(
            icon: Icons.location_on_outlined,
            title: 'Default Map Focus',
            subtitle: 'Initial map center and zoom level.',
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: OpenVtsTextField(
                      label: 'Latitude',
                      controller: _latCtrl,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                        signed: true,
                      ),
                      hintText: '37.7749',
                      validator: (v) {
                        final s = (v ?? '').trim();
                        if (s.isEmpty) return null;
                        final n = double.tryParse(s);
                        if (n == null) return 'Invalid number';
                        if (n < -90 || n > 90) return '-90 to 90';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: OpenVtsSpacing.sm),
                  Expanded(
                    child: OpenVtsTextField(
                      label: 'Longitude',
                      controller: _lonCtrl,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                        signed: true,
                      ),
                      hintText: '-122.4194',
                      validator: (v) {
                        final s = (v ?? '').trim();
                        if (s.isEmpty) return null;
                        final n = double.tryParse(s);
                        if (n == null) return 'Invalid number';
                        if (n < -180 || n > 180) return '-180 to 180';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: OpenVtsSpacing.sm),
              OpenVtsTextField(
                label: 'Zoom',
                controller: _zoomCtrl,
                keyboardType: TextInputType.number,
                hintText: '10',
                validator: (v) {
                  final s = (v ?? '').trim();
                  if (s.isEmpty) return null;
                  final n = int.tryParse(s);
                  if (n == null) return 'Invalid number';
                  if (n < 1 || n > 22) return '1 to 22';
                  return null;
                },
              ),
              const SizedBox(height: OpenVtsSpacing.sm),
              _PresetsRow(onPick: _applyPreset),
            ],
          ),
          const SizedBox(height: OpenVtsSpacing.md),
          OpenVtsButton(
            label: l10n.save,
            isLoading: state.isSavingLocalization || _isSaving,
            height: 44,
            onPressed: (state.isSavingLocalization || _isSaving) ? null : _save,
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// Preview card
// =====================================================================

class _PreviewCard extends StatelessWidget {
  const _PreviewCard({
    required this.dateFormat,
    required this.use24Hour,
    required this.timezone,
    required this.units,
    required this.language,
    required this.direction,
  });

  final String dateFormat;
  final bool use24Hour;
  final String timezone;
  final AdminUnits units;
  final String language;
  final AdminLayoutDirection direction;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final now = DateTime.now();
    final intlPattern = _toIntlPattern(dateFormat);
    String dateString;
    try {
      dateString = DateFormat(intlPattern).format(now);
    } catch (_) {
      dateString = now.toIso8601String().split('T').first;
    }
    final timePattern = use24Hour ? 'HH:mm' : 'hh:mm a';
    String timeString;
    try {
      timeString = DateFormat(timePattern).format(now);
    } catch (_) {
      timeString = '${now.hour}:${now.minute.toString().padLeft(2, '0')}';
    }

    final distanceLabel = units == AdminUnits.miles ? 'mi' : 'km';

    return OpenVtsCard(
      padding: const EdgeInsets.all(OpenVtsSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.visibility_outlined,
                size: 14,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 6),
              Text(
                'PREVIEW',
                style: TextStyle(
                  fontFamily: OpenVtsTypography.primaryFontFamily,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.6,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: OpenVtsSpacing.xs),
          Row(
            children: [
              Expanded(
                child: _PreviewTile(
                  label: l10n.date,
                  value: dateString,
                ),
              ),
              const SizedBox(width: OpenVtsSpacing.xs),
              Expanded(
                child: _PreviewTile(
                  label: l10n.time,
                  value: timeString,
                ),
              ),
            ],
          ),
          const SizedBox(height: OpenVtsSpacing.xs),
          Row(
            children: [
              Expanded(
                child: _PreviewTile(
                  label: l10n.timezone,
                  value: timezone,
                ),
              ),
              const SizedBox(width: OpenVtsSpacing.xs),
              Expanded(
                child: _PreviewTile(
                  label: 'Distance',
                  value: '1,234 $distanceLabel',
                ),
              ),
            ],
          ),
          const SizedBox(height: OpenVtsSpacing.xs),
          Row(
            children: [
              Expanded(
                child: _PreviewTile(
                  label: l10n.language,
                  value: language.toUpperCase(),
                ),
              ),
              const SizedBox(width: OpenVtsSpacing.xs),
              Expanded(
                child: _PreviewTile(
                  label: l10n.direction,
                  value: direction.apiValue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PreviewTile extends StatelessWidget {
  const _PreviewTile({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(OpenVtsRadius.sm),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: OpenVtsTypography.primaryFontFamily,
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: OpenVtsTypography.primaryFontFamily,
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// Dropdowns
// =====================================================================

class _LanguageDropdown extends StatelessWidget {
  const _LanguageDropdown({
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final String value;
  final List<AdminLanguageOption> options;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final hasValue = options.any((o) => o.code == value);
    final dropdownOptions = <OpenVtsDropdownOption<String>>[
      if (!hasValue && value.isNotEmpty)
        OpenVtsDropdownOption(
          value: value,
          label: value.toUpperCase(),
          searchText: value,
        ),
      for (final o in options)
        OpenVtsDropdownOption(
          value: o.code,
          label: o.label,
          searchText: o.code,
        ),
    ];
    return OpenVtsSearchableDropdown<String>(
      label: AppLocalizations.of(context).language,
      value: value.isEmpty ? null : value,
      options: dropdownOptions,
      onChanged: onChanged,
    );
  }
}

class _DateFormatDropdown extends StatelessWidget {
  const _DateFormatDropdown({
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final String value;
  final List<AdminDateFormatOption> options;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final hasValue = options.any((o) => o.value == value);
    final dropdownOptions = <OpenVtsDropdownOption<String>>[
      if (!hasValue && value.isNotEmpty)
        OpenVtsDropdownOption(value: value, label: value, searchText: value),
      for (final o in options)
        OpenVtsDropdownOption(
          value: o.value,
          label: o.label,
          searchText: o.value,
        ),
    ];
    return OpenVtsSearchableDropdown<String>(
      label: AppLocalizations.of(context).dateFormat,
      value: value.isEmpty ? null : value,
      options: dropdownOptions,
      onChanged: onChanged,
    );
  }
}

class _TimezoneDropdown extends StatelessWidget {
  const _TimezoneDropdown({
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final String value;
  final List<String> options;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final hasValue = options.contains(value);
    final dropdownOptions = <OpenVtsDropdownOption<String>>[
      if (!hasValue && value.isNotEmpty)
        OpenVtsDropdownOption(value: value, label: value),
      for (final option in options)
        OpenVtsDropdownOption(value: option, label: option),
    ];
    return OpenVtsSearchableDropdown<String>(
      label: AppLocalizations.of(context).timezone,
      value: value.isEmpty ? null : value,
      options: dropdownOptions,
      onChanged: onChanged,
    );
  }
}

// =====================================================================
// Segmented control
// =====================================================================

class _Seg<T> {
  const _Seg({required this.value, required this.label});
  final T value;
  final String label;
}

class _SegmentedControl<T> extends StatelessWidget {
  const _SegmentedControl({
    required this.value,
    required this.segments,
    required this.onChanged,
  });

  final T value;
  final List<_Seg<T>> segments;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(OpenVtsRadius.sm),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final seg in segments)
            _SegBtn(
              label: seg.label,
              selected: seg.value == value,
              onTap: () => onChanged(seg.value),
            ),
        ],
      ),
    );
  }
}

class _SegBtn extends StatelessWidget {
  const _SegBtn({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(OpenVtsRadius.sm - 2),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
          borderRadius: BorderRadius.circular(OpenVtsRadius.sm - 2),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: OpenVtsTypography.primaryFontFamily,
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            color: selected
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}

// =====================================================================
// Labeled row (label on the left, control on the right)
// =====================================================================

class _LabeledRow extends StatelessWidget {
  const _LabeledRow({required this.label, this.child, this.trailing})
      : assert(child != null || trailing != null);

  final String label;
  final Widget? child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: OpenVtsTypography.primaryFontFamily,
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
        const SizedBox(width: OpenVtsSpacing.sm),
        if (child != null) child! else trailing!,
      ],
    );
  }
}

// =====================================================================
// Map presets
// =====================================================================

class _MapPreset {
  const _MapPreset(this.label, this.lat, this.lon, this.zoom);
  final String label;
  final double lat;
  final double lon;
  final int zoom;
}

const List<_MapPreset> _kMapPresets = [
  _MapPreset('San Francisco', 37.7749, -122.4194, 11),
  _MapPreset('Delhi', 28.6139, 77.2090, 11),
  _MapPreset('London', 51.5074, -0.1278, 11),
  _MapPreset('Dubai', 25.2048, 55.2708, 11),
];

class _PresetsRow extends StatelessWidget {
  const _PresetsRow({required this.onPick});
  final ValueChanged<_MapPreset> onPick;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick presets',
          style: OpenVtsTypography.label,
        ),
        const SizedBox(height: OpenVtsSpacing.xs),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            for (final p in _kMapPresets)
              _PresetChip(label: p.label, onTap: () => onPick(p)),
          ],
        ),
      ],
    );
  }
}

class _PresetChip extends StatelessWidget {
  const _PresetChip({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(OpenVtsRadius.pill),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(OpenVtsRadius.pill),
          border:
              Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.place_outlined,
              size: 12,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontFamily: OpenVtsTypography.primaryFontFamily,
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================================
// Section header
// =====================================================================

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.trailing,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return OpenVtsCard(
      padding: const EdgeInsets.all(OpenVtsSpacing.md),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(OpenVtsRadius.sm),
              border: Border.all(
                  color: Theme.of(context).colorScheme.outlineVariant),
            ),
            child: Icon(icon,
                size: 16, color: Theme.of(context).colorScheme.onSurface),
          ),
          const SizedBox(width: OpenVtsSpacing.xs),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: OpenVtsTypography.primaryFontFamily,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontFamily: OpenVtsTypography.primaryFontFamily,
                    fontSize: 11,
                    height: 1.3,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: OpenVtsSpacing.xs),
            trailing!,
          ],
        ],
      ),
    );
  }
}

// =====================================================================
// Grouped card with title row
// =====================================================================

class _GroupedCard extends StatelessWidget {
  const _GroupedCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.children,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return OpenVtsCard(
      padding: const EdgeInsets.all(OpenVtsSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(icon,
                  size: 16,
                  color: Theme.of(context).colorScheme.onSurfaceVariant),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontFamily: OpenVtsTypography.primaryFontFamily,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontFamily: OpenVtsTypography.primaryFontFamily,
                        fontSize: 11,
                        height: 1.3,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: OpenVtsSpacing.sm),
          ...children,
        ],
      ),
    );
  }
}

// =====================================================================
// Helpers
// =====================================================================

/// Translate backend pattern tokens (YYYY/MM/DD/HH/mm/ss) to intl tokens.
String _toIntlPattern(String pattern) {
  // Replace longest tokens first to avoid partial overlaps.
  return pattern
      .replaceAll('YYYY', 'yyyy')
      .replaceAll('YY', 'yy')
      .replaceAll('DD', 'dd')
      .replaceAll('DDD', 'ddd');
  // MM (month), HH, mm (minute), ss are identical between Moment/intl.
}
