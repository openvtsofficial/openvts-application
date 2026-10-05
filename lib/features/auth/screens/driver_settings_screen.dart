import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/app_preferences_provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/helpers/mobile_text.dart';
import '../../../shared/helpers/toast_helper.dart';
import '../../../shared/helpers/validation_localizations.dart';
import '../../../shared/widgets/open_vts_page_scaffold.dart';
import '../controllers/driver_settings_controller.dart';
import '../controllers/security_controller.dart';
import 'security_screen.dart';

class DriverSettingsScreen extends ConsumerStatefulWidget {
  const DriverSettingsScreen({super.key, this.openSecurity = false});
  final bool openSecurity;
  @override
  ConsumerState<DriverSettingsScreen> createState() =>
      _DriverSettingsScreenState();
}

class _DriverSettingsScreenState extends ConsumerState<DriverSettingsScreen> {
  int _tab = 0;
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController(),
      _email = TextEditingController(),
      _prefix = TextEditingController(),
      _mobile = TextEditingController(),
      _timezone = TextEditingController(),
      _language = TextEditingController();
  String _date = 'YYYY-MM-DD',
      _time = '24H',
      _theme = 'SYSTEM',
      _unit = 'KM',
      _direction = 'LTR';
  bool _loading = true, _busy = false;
  bool _hasRemoteData = false;
  String? _error;
  @override
  void initState() {
    super.initState();
    _tab = widget.openSecurity ? 2 : 0;
    Future.microtask(_load);
  }

  @override
  void didUpdateWidget(covariant DriverSettingsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.openSecurity && !oldWidget.openSecurity) _tab = 2;
  }

  @override
  void dispose() {
    for (final c in [_name, _email, _prefix, _mobile, _timezone, _language]) {
      c.dispose();
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
      await ref.read(driverSettingsControllerProvider.notifier).load();
      if (!mounted) return;
      final loaded = ref.read(driverSettingsControllerProvider);
      if (loaded.error != null) {
        setState(() => _error = loaded.error);
        return;
      }
      final p = loaded.profile!, s = loaded.settings!;
      _hasRemoteData = true;
      _name.text = '${p['name'] ?? ''}';
      _email.text = '${p['email'] ?? ''}';
      _prefix.text = '${p['mobileCode'] ?? ''}';
      _mobile.text = '${p['mobile'] ?? ''}';
      _timezone.text = '${s['timezone'] ?? '+00:00'}';
      final language = '${s['languageCode'] ?? 'en'}';
      _language.text =
          const ['en', 'es', 'fr', 'pt', 'ar', 'hi'].contains(language)
          ? language
          : 'en';
      _date = '${s['dateFormat'] ?? 'YYYY-MM-DD'}';
      _time = '${s['timeFormat'] ?? '24H'}';
      _theme = '${s['theme'] ?? 'SYSTEM'}';
      _unit = '${s['distanceUnit'] ?? 'KM'}';
      _direction = '${s['direction'] ?? 'LTR'}';
      if (ref.exists(appLocalizationPreferencesProvider)) {
        final device = ref
            .read(appLocalizationPreferencesProvider.notifier)
            .languageOverride;
        if (device != null) {
          _language.text = device.languageCode;
          _direction = device.layoutDirection;
        }
      }
    } catch (error) {
      if (mounted) _error = SecurityController.errorMessage(error);
    } finally {
      if (mounted) setState(() => _loading = false);
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
          context.mobileText('Changes saved'),
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
    if (!_hasRemoteData || !_form.currentState!.validate()) return;
    await _run(
      () => ref.read(driverSettingsControllerProvider.notifier).saveProfile({
        'name': _name.text.trim(),
        'email': _email.text.trim(),
        'mobileCode': _prefix.text.trim(),
        'mobile': _mobile.text.trim(),
      }),
    );
  }

  Future<void> _savePreferences() async {
    if (!_hasRemoteData) return;
    if (!RegExp(
      r'^[+-](?:0\d|1[0-4]):[0-5]\d$',
    ).hasMatch(_timezone.text.trim())) {
      setState(() => _error = 'Enter a time zone offset such as +05:30.');
      return;
    }
    if (!RegExp(
      r'^[A-Za-z]{2,3}(?:-[A-Za-z0-9]{2,8})?$',
    ).hasMatch(_language.text.trim())) {
      setState(
        () => _error = context.mobileText(
          'Enter a language code such as en or hi.',
        ),
      );
      return;
    }
    await _run(
      () => ref.read(driverSettingsControllerProvider.notifier).saveSettings({
        'dateFormat': _date,
        'timeFormat': _time,
        'theme': _theme,
        'distanceUnit': _unit,
        'direction': _direction,
        'timezone': _timezone.text.trim(),
        'languageCode': _language.text.trim(),
      }),
    );
  }

  Future<void> _changePassword() async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (_) => const _DriverPasswordDialog(),
    );
    if (result == null || !mounted) return;
    await _run(
      () => ref
          .read(driverSettingsControllerProvider.notifier)
          .changePassword(result),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(driverSettingsControllerProvider);
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
                    if (_busy) const LinearProgressIndicator(),
                    if (_error != null)
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Text(_error!),
                              TextButton(
                                onPressed: _busy ? null : _load,
                                child: Text(context.mobileText('Reload')),
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (_tab == 0)
                      _card(context.mobileText('Profile'), [
                        Form(
                          key: _form,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _name,
                                enabled: !_busy,
                                maxLength: 120,
                                decoration: InputDecoration(
                                  labelText: context.mobileText('Name'),
                                ),
                                validator: context.localizedValidator((v) => v?.trim().isNotEmpty == true ? null : context.mobileText('Enter your name.')),
                              ),
                              TextFormField(
                                controller: _email,
                                enabled: !_busy,
                                maxLength: 190,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  labelText: context.mobileText(
                                    'Email (optional)',
                                  ),
                                ),
                                validator: context.localizedValidator((v) {final value = v ?? ''; if (value.isEmpty) return null; return value.runes.any((r) => r > 127) || !RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value) ? context.mobileText('Enter a valid English email address.') : null;}),
                              ),
                              TextFormField(
                                controller: _prefix,
                                enabled: !_busy,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  labelText: context.mobileText(
                                    'Country calling code',
                                  ),
                                ),
                                validator: context.localizedValidator((v) => (v ?? '').isEmpty || RegExp(r'^\+?[0-9]{1,6}$').hasMatch(v!) ? null : context.mobileText('Enter a calling code.')),
                              ),
                              TextFormField(
                                controller: _mobile,
                                enabled: !_busy,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  labelText: context.mobileText(
                                    'Mobile number',
                                  ),
                                ),
                                validator: context.localizedValidator((v) => (v ?? '').isEmpty || RegExp(r'^[0-9][0-9\s-]{3,23}$').hasMatch(v!) ? null : context.mobileText('Enter a valid mobile number.')),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed: _busy || !_hasRemoteData
                              ? null
                              : _saveProfile,
                          child: Text(context.mobileText('Save profile')),
                        ),
                      ]),
                    if (_tab == 1)
                      _card(context.mobileText('Display preferences'), [
                        _dropdown(context.mobileText('Date format'), _date, [
                          'YYYY-MM-DD',
                          'DD/MM/YYYY',
                          'MM/DD/YYYY',
                          'DD MMM YYYY',
                        ], (v) => _date = v),
                        _dropdown(context.mobileText('Time format'), _time, [
                          '12H',
                          '24H',
                        ], (v) => _time = v),
                        _dropdown(context.mobileText('Theme'), _theme, [
                          'SYSTEM',
                          'LIGHT',
                          'DARK',
                        ], (v) => _theme = v),
                        _dropdown(context.mobileText('Distance unit'), _unit, [
                          'KM',
                          'MILES',
                        ], (v) => _unit = v),
                        _dropdown(
                          context.mobileText('Text direction'),
                          _direction,
                          ['LTR', 'RTL'],
                          (v) => _direction = v,
                        ),
                        TextField(
                          controller: _timezone,
                          enabled: !_busy,
                          decoration: InputDecoration(
                            labelText: context.mobileText('Time zone offset'),
                            hintText: '+05:30',
                          ),
                        ),
                        _dropdown(
                          context.mobileText('Language'),
                          _language.text,
                          ['en', 'es', 'fr', 'pt', 'ar', 'hi'],
                          (value) => _language.text = value,
                        ),
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed: _busy || !_hasRemoteData
                              ? null
                              : _savePreferences,
                          child: Text(context.mobileText('Save preferences')),
                        ),
                      ]),
                    if (_tab == 0)
                      _card(context.mobileText('Password'), [
                        Text(
                          context.mobileText(
                            'Changing your password signs you out of all sessions.',
                          ),
                        ),
                        OutlinedButton(
                          onPressed: _busy ? null : _changePassword,
                          child: Text(context.mobileText('Change password')),
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
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    ),
  );
  String _preferenceLabel(String value) => switch (value) {
    'SYSTEM' => context.mobileText('System'),
    'LIGHT' => context.mobileText('Light'),
    'DARK' => context.mobileText('Dark'),
    'KM' => context.mobileText('Kilometers'),
    'MILES' => context.mobileText('Miles'),
    'LTR' => context.mobileText('Left to right'),
    'RTL' => context.mobileText('Right to left'),
    '12H' => context.mobileText('12-hour time'),
    '24H' => context.mobileText('24-hour time'),
    _ => value,
  };

  Widget _dropdown(
    String label,
    String value,
    List<String> values,
    ValueChanged<String> change,
  ) => DropdownButtonFormField<String>(
    initialValue: values.contains(value) ? value : values.first,
    decoration: InputDecoration(labelText: label),
    items: values
        .map(
          (v) => DropdownMenuItem(value: v, child: Text(_preferenceLabel(v))),
        )
        .toList(),
    onChanged: _busy ? null : (v) => setState(() => change(v!)),
  );
}

class _DriverPasswordDialog extends StatefulWidget {
  const _DriverPasswordDialog();
  @override
  State<_DriverPasswordDialog> createState() => _DriverPasswordDialogState();
}

class _DriverPasswordDialogState extends State<_DriverPasswordDialog> {
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
            TextFormField(
              controller: _current,
              obscureText: true,
              maxLength: 128,
              decoration: InputDecoration(
                labelText: context.mobileText('Current password'),
              ),
              validator: context.localizedValidator((v) => (v ?? '').isEmpty ? context.mobileText('Enter your password.') : null),
            ),
            TextFormField(
              controller: _next,
              obscureText: true,
              maxLength: 128,
              decoration: InputDecoration(
                labelText: context.mobileText('New password'),
              ),
              validator: context.localizedValidator((v) => (v?.length ?? 0) < 8 || v!.runes.any((r) => r > 127) ? 'Use 8–128 English characters.' : v == _current.text ? context.mobileText('Choose a different password.') : null),
            ),
            TextFormField(
              controller: _confirm,
              obscureText: true,
              maxLength: 128,
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
        child: Text(context.mobileText('Cancel')),
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
        child: Text(context.mobileText('Change password')),
      ),
    ],
  );
}
