import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/app_preferences_provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/helpers/mobile_text.dart';
import '../../../shared/helpers/toast_helper.dart';
import '../../../shared/helpers/validation_localizations.dart';
import '../../../shared/widgets/open_vts_page_scaffold.dart';
import '../../admin/models/admin_settings_model.dart';
import '../../user/models/user_settings_model.dart';
import '../controllers/security_controller.dart';
import '../controllers/team_settings_controller.dart';
import 'security_screen.dart';

/// Team has personal account controls only. Tenant configuration belongs to Admin.
class TeamSettingsScreen extends ConsumerStatefulWidget {
  const TeamSettingsScreen({super.key, this.openSecurity = false});
  final bool openSecurity;
  @override
  ConsumerState<TeamSettingsScreen> createState() => _TeamSettingsScreenState();
}

class _TeamSettingsScreenState extends ConsumerState<TeamSettingsScreen> {
  final _form = GlobalKey<FormState>();
  final _fields = <String, TextEditingController>{
    for (final key in [
      'name',
      'email',
      'mobilePrefix',
      'mobileNumber',
      'addressLine',
      'pincode',
    ])
      key: TextEditingController(),
  };
  int _tab = 0;
  bool _loading = true, _busy = false, _loadingAddress = false;
  bool _hasProfile = false, _hasPreferences = false;
  String? _error;
  String _country = '', _state = '', _city = '';
  List<UserCountryOption> _countries = [];
  List<UserStateOption> _states = [];
  List<UserCityOption> _cities = [];
  List<UserDateFormatOption> _dates = [];
  List<String> _zones = [];
  AdminLocalizationSettings _preferences = const AdminLocalizationSettings();
  int _addressGeneration = 0;
  TeamSettingsController get _controller =>
      ref.read(teamSettingsControllerProvider);

  @override
  void initState() {
    super.initState();
    _tab = widget.openSecurity ? 2 : 0;
    Future.microtask(_load);
  }

  @override
  void didUpdateWidget(covariant TeamSettingsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.openSecurity && !oldWidget.openSecurity) _tab = 2;
  }

  @override
  void dispose() {
    for (final controller in _fields.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _load() async {
    if (!mounted) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final result = await _controller.load();
      if (!mounted) return;
      final profile = result.profile;
      if (profile != null) {
        final address = profile['address'] is Map
            ? Map<String, dynamic>.from(profile['address'] as Map)
            : <String, dynamic>{};
        for (final key in _fields.keys) {
          _fields[key]!.text = '${profile[key] ?? address[key] ?? ''}';
        }
        _country = '${address['countryCode'] ?? ''}';
        _state = '${address['stateCode'] ?? ''}';
        _city = '${address['cityId'] ?? address['cityName'] ?? ''}';
        _hasProfile = true;
      }
      if (result.preferences != null) {
        _preferences = result.preferences!;
        if (ref.exists(appLocalizationPreferencesProvider)) {
          final device = ref
              .read(appLocalizationPreferencesProvider.notifier)
              .languageOverride;
          if (device != null) {
            _preferences = _preferences.copyWith(
              language: device.languageCode,
              layoutDirection: device.isRtl
                  ? AdminLayoutDirection.rtl
                  : AdminLayoutDirection.ltr,
            );
          }
        }
        _hasPreferences = true;
      }
      if (result.countries != null) _countries = result.countries!;
      if (result.dateFormats != null) _dates = result.dateFormats!;
      if (result.timezones != null) _zones = result.timezones!;
      if (result.errors.isNotEmpty) _error = result.errors.toSet().join('\n');
      if (_hasProfile) await _loadAddress();
    } catch (error) {
      if (mounted) _error = SecurityController.errorMessage(error);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _loadAddress() async {
    final generation = ++_addressGeneration;
    final country = _country, state = _state;
    setState(() => _loadingAddress = true);
    try {
      final address = await _controller.loadAddress(country, state);
      if (mounted && generation == _addressGeneration) {
        setState(() {
          _states = address.states;
          _cities = address.cities;
        });
      }
    } catch (error) {
      if (mounted && generation == _addressGeneration) {
        setState(() => _error = SecurityController.errorMessage(error));
      }
    } finally {
      if (mounted && generation == _addressGeneration) {
        setState(() => _loadingAddress = false);
      }
    }
  }

  Future<void> _run(Future<void> Function() action) async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await action();
      if (mounted) {
        ToastHelper.showSuccess(
          AppLocalizations.of(context).success,
          context: context,
        );
      }
    } catch (error) {
      if (mounted) {
        setState(() => _error = SecurityController.errorMessage(error));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _saveProfile() async {
    if (!_hasProfile || !_form.currentState!.validate()) return;
    await _run(
      () => _controller.saveProfile({
        for (final entry in _fields.entries) entry.key: entry.value.text.trim(),
        'countryCode': _country,
        'stateCode': _state,
        'cityName': _city,
      }),
    );
  }

  Future<void> _savePreferences() => !_hasPreferences
      ? Future.value()
      : _run(() => _controller.savePreferences(_preferences));
  Future<void> _password() async {
    final values = await showDialog<Map<String, String>>(
      context: context,
      builder: (_) => const _TeamPasswordDialog(),
    );
    if (values == null || !mounted) return;
    await _run(() => _controller.changePassword(values));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return OpenVtsPageScaffold(
      title: l10n.settings,
      headerMode: OpenVtsPageHeaderMode.closeable,
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final entry in [
                  (l10n.profile, Icons.person_outline),
                  (l10n.localization, Icons.public),
                  (l10n.security, Icons.shield_outlined),
                ].indexed)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      avatar: Icon(entry.$2.$2, size: 18),
                      label: Text(entry.$2.$1),
                      selected: _tab == entry.$1,
                      onSelected: (_) => setState(() => _tab = entry.$1),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => _tab == 2
                  ? ref.read(securityControllerProvider.notifier).load()
                  : _load(),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  if (_tab == 2)
                    const SecurityScreen(embedded: true)
                  else if (_loading)
                    const Padding(
                      padding: EdgeInsets.all(48),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else ...[
                    if (_busy || _loadingAddress)
                      const LinearProgressIndicator(),
                    if (_error != null)
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Text(_error!),
                              TextButton(
                                onPressed: _busy ? null : _load,
                                child: Text(l10n.retry),
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (_tab == 0)
                      _card(l10n.profile, [
                        Form(
                          key: _form,
                          child: Column(
                            children: [
                              _field('name', context.mobileText('Name')),
                              _field(
                                'email',
                                context.mobileText('Email (optional)'),
                                required: false,
                              ),
                              _field(
                                'mobilePrefix',
                                context.mobileText('Country calling code'),
                                keyboard: TextInputType.phone,
                              ),
                              _field(
                                'mobileNumber',
                                context.mobileText('Mobile number'),
                                keyboard: TextInputType.phone,
                              ),
                              _field(
                                'addressLine',
                                context.mobileText('Address'),
                              ),
                              _select(
                                context.mobileText('Country'),
                                _country,
                                {
                                  for (final country in _countries)
                                    country.value: country.label,
                                },
                                (v) {
                                  _country = v;
                                  _state = '';
                                  _city = '';
                                  _states = [];
                                  _cities = [];
                                  _loadAddress();
                                },
                                required: true,
                              ),
                              _select(
                                'State (optional)',
                                _state,
                                {
                                  '': '—',
                                  for (final state in _states)
                                    state.value: state.label,
                                },
                                (v) {
                                  _state = v;
                                  _city = '';
                                  _cities = [];
                                  _loadAddress();
                                },
                              ),
                              _select('City (optional)', _city, {
                                '': '—',
                                for (final city in _cities)
                                  city.value: city.label,
                              }, (v) => _city = v),
                              _field(
                                'pincode',
                                context.mobileText('Postal code (optional)'),
                                required: false,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed: _busy || _loadingAddress || !_hasProfile
                              ? null
                              : _saveProfile,
                          child: Text(l10n.saveChanges),
                        ),
                        const SizedBox(height: 16),
                        OutlinedButton.icon(
                          onPressed: _busy ? null : _password,
                          icon: const Icon(Icons.password),
                          label: Text(context.mobileText('Change password')),
                        ),
                      ]),
                    if (_tab == 1)
                      _card(l10n.localization, [
                        _select(
                          l10n.language,
                          _preferences.language,
                          const {
                            'en': 'English',
                            'es': 'Español',
                            'fr': 'Français',
                            'pt': 'Português',
                            'ar': 'العربية',
                            'hi': 'हिन्दी',
                          },
                          (v) =>
                              _preferences = _preferences.copyWith(language: v),
                        ),
                        _select(
                          l10n.textDirection,
                          _preferences.layoutDirection.apiValue,
                          const {'LTR': 'LTR', 'RTL': 'RTL'},
                          (v) => _preferences = _preferences.copyWith(
                            layoutDirection: AdminLayoutDirection.fromValue(v),
                          ),
                        ),
                        _select(
                          l10n.dateFormat,
                          _preferences.dateFormat,
                          {for (final date in _dates) date.value: date.label},
                          (v) => _preferences = _preferences.copyWith(
                            dateFormat: v,
                          ),
                        ),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(l10n.use24Hour),
                          value: _preferences.use24Hour,
                          onChanged: _busy
                              ? null
                              : (v) => setState(
                                  () => _preferences = _preferences.copyWith(
                                    use24Hour: v,
                                  ),
                                ),
                        ),
                        _select(
                          l10n.theme,
                          _preferences.theme.apiValue,
                          {
                            'SYSTEM': l10n.system,
                            'LIGHT': l10n.light,
                            'DARK': l10n.dark,
                          },
                          (v) => _preferences = _preferences.copyWith(
                            theme: AdminTheme.fromValue(v),
                          ),
                        ),
                        _select(
                          l10n.timezone,
                          _preferences.timezoneOffset,
                          {for (final zone in _zones) zone: zone},
                          (v) => _preferences = _preferences.copyWith(
                            timezoneOffset: v,
                          ),
                        ),
                        _select(
                          l10n.units,
                          _preferences.units.apiValue,
                          {'KM': l10n.kilometers, 'MILES': l10n.miles},
                          (v) => _preferences = _preferences.copyWith(
                            units: AdminUnits.fromValue(v),
                          ),
                        ),
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed: _busy || !_hasPreferences
                              ? null
                              : _savePreferences,
                          child: Text(l10n.saveChanges),
                        ),
                      ]),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _card(String title, List<Widget> children) => Card(
    margin: const EdgeInsets.only(bottom: 16),
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    ),
  );
  Widget _field(
    String key,
    String label, {
    bool required = true,
    TextInputType? keyboard,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: TextFormField(
      controller: _fields[key],
      enabled: !_busy,
      keyboardType:
          keyboard ??
          (key == 'email' ? TextInputType.emailAddress : TextInputType.text),
      decoration: InputDecoration(labelText: label),
      validator: context.localizedValidator((value) {final text = (value ?? '').trim(); if (required && text.isEmpty) {return context.mobileText('This field is required.');} if (key == 'email' && text.isNotEmpty && (text.runes.any((r) => r > 127) || !RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(text))) {return context.mobileText('Enter a valid English email address.');} return null;}),
    ),
  );
  Widget _select(
    String label,
    String value,
    Map<String, String> values,
    ValueChanged<String> change, {
    bool required = false,
  }) {
    final options = {
      ...values,
      if (value.isNotEmpty && !values.containsKey(value)) value: value,
    };
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        key: ValueKey('$label:$value:${options.length}'),
        initialValue: options.containsKey(value) ? value : null,
        isExpanded: true,
        decoration: InputDecoration(labelText: label),
        items: options.entries
            .map(
              (e) => DropdownMenuItem(
                value: e.key,
                child: Text(e.value, overflow: TextOverflow.ellipsis),
              ),
            )
            .toList(),
        onChanged: _busy || _loadingAddress
            ? null
            : (v) {
                if (v != null) setState(() => change(v));
              },
        validator: context.localizedValidator(required ? (v) => v == null || v.isEmpty ? context.mobileText('This field is required.') : null : null),
      ),
    );
  }
}

class _TeamPasswordDialog extends StatefulWidget {
  const _TeamPasswordDialog();
  @override
  State<_TeamPasswordDialog> createState() => _TeamPasswordDialogState();
}

class _TeamPasswordDialogState extends State<_TeamPasswordDialog> {
  final _form = GlobalKey<FormState>();
  final _current = TextEditingController(),
      _next = TextEditingController(),
      _confirm = TextEditingController();
  @override
  void dispose() {
    _current.dispose();
    _next.dispose();
    _confirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(context.mobileText('Change password')),
    content: SingleChildScrollView(
      child: Form(
        key: _form,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              context.mobileText(
                'Changing your password signs you out of all sessions.',
              ),
            ),
            TextFormField(
              controller: _current,
              obscureText: true,
              decoration: InputDecoration(
                labelText: context.mobileText('Current password'),
              ),
              validator: context.localizedValidator((v) => (v ?? '').isEmpty ? context.mobileText('Enter your password.') : null),
            ),
            TextFormField(
              controller: _next,
              obscureText: true,
              maxLength: 72,
              decoration: InputDecoration(
                labelText: context.mobileText('New password'),
              ),
              validator: context.localizedValidator((v) => (v?.length ?? 0) < 6 || v!.runes.any((r) => r < 32 || r > 126) ? context.mobileText('Use 6–72 English characters.') : v == _current.text ? context.mobileText('Choose a different password.') : null),
            ),
            TextFormField(
              controller: _confirm,
              obscureText: true,
              decoration: InputDecoration(
                labelText: context.mobileText('Confirm new password'),
              ),
              validator: context.localizedValidator((v) => v != _next.text ? context.mobileText('Passwords do not match.') : null),
            ),
          ],
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text(AppLocalizations.of(context).cancel),
      ),
      FilledButton(
        onPressed: () {
          if (_form.currentState!.validate()) {
            Navigator.pop(context, {
              'currentPassword': _current.text,
              'newPassword': _next.text,
            });
          }
        },
        child: Text(AppLocalizations.of(context).saveChanges),
      ),
    ],
  );
}
