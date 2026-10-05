import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../shared/helpers/mobile_text.dart';
import '../../../shared/helpers/toast_helper.dart';
import '../../../shared/helpers/validation_localizations.dart';
import '../../../shared/models/user_role.dart';
import '../controllers/auth_controller.dart';
import '../controllers/security_controller.dart';

class SecurityScreen extends ConsumerStatefulWidget {
  const SecurityScreen({super.key, this.embedded = false});
  final bool embedded;
  @override
  ConsumerState<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends ConsumerState<SecurityScreen> {
  Map<String, dynamic>? get _status =>
      ref.read(securityControllerProvider).status;
  Map<String, dynamic>? get _tokens =>
      ref.read(securityControllerProvider).tokens;
  bool _busy = false;
  bool get _loading => ref.read(securityControllerProvider).loading;
  String? _error;
  SecurityController get _service =>
      ref.read(securityControllerProvider.notifier);
  bool get _enabled => _status?['enabled'] == true;
  @override
  void initState() {
    super.initState();
    Future.microtask(_load);
  }

  Future<void> _load() async {
    await _service.load();
    if (mounted) {
      setState(() => _error = ref.read(securityControllerProvider).error);
    }
  }

  Future<void> _act(String action, {String? deviceId}) async {
    final values = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => _ProofDialog(action: action, mfaEnabled: _enabled),
    );
    if (values == null || !mounted) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      if (action == 'delete') {
        await _service.deleteAccount(values);
        return;
      }
      if (action == 'token') {
        final created = await _service.createToken(values);
        final token = created['token']?.toString() ?? '';
        if (token.isEmpty) throw const FormatException('Token not returned');
        if (mounted) {
          await _showSecrets(
            context.mobileText('API token'),
            [token],
            context.mobileText(
              'This token is shown only once. Store it securely. Anyone with it can access the selected API permissions.',
            ),
          );
        }
      } else {
        Map<String, dynamic>? changed;
        if (action == 'enroll') {
          final setup = await _service.enroll(values);
          if (mounted) {
            changed = await showDialog<Map<String, dynamic>>(
              context: context,
              barrierDismissible: false,
              builder: (_) =>
                  _EnrollmentDialog(setup: setup, service: _service),
            );
          }
        } else {
          changed = await _service.change(action, {
            ...values,
            if (deviceId != null) 'deviceId': deviceId,
          });
        }
        if (changed != null && mounted) {
          final codes =
              (changed['recoveryCodes'] as List?)
                  ?.map((v) => v.toString())
                  .toList() ??
              <String>[];
          if (codes.isNotEmpty && mounted) {
            await _showSecrets(
              context.mobileText('Save your recovery codes'),
              codes,
              context.mobileText(
                'Each code works once if you lose your authenticator. These replace previous recovery codes. Keep them in a safe place.',
              ),
            );
          }
        }
      }
      await _load();
    } catch (error) {
      if (mounted) {
        setState(() => _error = SecurityController.errorMessage(error));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _showSecrets(
    String title,
    List<String> values,
    String help,
  ) async {
    bool saved = false;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, update) => PopScope(
          canPop: saved,
          child: AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(help),
                  const SizedBox(height: 16),
                  SelectableText(
                    values.join('\n\n'),
                    style: const TextStyle(fontFamily: 'monospace'),
                  ),
                  TextButton.icon(
                    onPressed: () async {
                      await Clipboard.setData(
                        ClipboardData(text: values.join('\n')),
                      );
                      if (context.mounted) {
                        ToastHelper.showInfo(
                          context.mobileText('Copied. Store this securely.'),
                          context: context,
                        );
                      }
                    },
                    icon: const Icon(Icons.copy),
                    label: Text(context.mobileText('Copy')),
                  ),
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    value: saved,
                    onChanged: (value) => update(() => saved = value == true),
                    title: Text(
                      context.mobileText('I have saved this securely'),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: saved ? () => Navigator.pop(context) : null,
                child: Text(context.mobileText('Done')),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _revoke(Map<String, dynamic> token) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.mobileText('Revoke API token?')),
        content: Text(
          context.mobileText('{name} will stop working immediately.', {
            'name': '${token['name']}',
          }),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.mobileText('Cancel')),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.mobileText('Revoke')),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() => _busy = true);
    try {
      await _service.revokeToken(token['id'].toString());
      await _load();
    } catch (error) {
      if (mounted) {
        setState(() => _error = SecurityController.errorMessage(error));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(securityControllerProvider);
    final role = ref.watch(authControllerProvider).role;
    final devices = (_status?['devices'] as List?) ?? [];
    final tokens = (_tokens?['tokens'] as List?) ?? [];
    final children = <Widget>[
      if (_loading || _busy) const LinearProgressIndicator(),
      if (_error != null)
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(_error!),
                TextButton(
                  onPressed: _busy ? null : _load,
                  child: Text(context.mobileText('Retry')),
                ),
              ],
            ),
          ),
        ),
      if (_status != null) ...[
        _section(context.mobileText('Multi-factor authentication'), [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              _enabled ? Icons.verified_user : Icons.shield_outlined,
            ),
            title: Text(
              _enabled
                  ? context.mobileText('MFA is on')
                  : context.mobileText('MFA is off'),
            ),
            subtitle: Text(
              context.mobileText(
                'Protect sign-in with your authenticator app.',
              ),
            ),
          ),
          Text(
            context.mobileText(
              'Security changes sign out other sessions and invalidate existing API tokens.',
            ),
          ),
          const SizedBox(height: 12),
          for (final raw in devices)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.smartphone),
              title: Text('${raw['name']}'),
              subtitle: Text(
                context.mobileText('Added {date}', {
                  'date': _date(raw['createdAt']),
                }),
              ),
              trailing: IconButton(
                tooltip: context.mobileText('Remove authenticator'),
                onPressed: _busy || devices.length <= 1
                    ? null
                    : () => _act('remove', deviceId: '${raw['id']}'),
                icon: const Icon(Icons.remove_circle_outline),
              ),
            ),
          FilledButton.icon(
            onPressed:
                _busy ||
                    devices.length >= (_status?['maxDevices'] as num? ?? 10)
                ? null
                : () => _act('enroll'),
            icon: const Icon(Icons.add),
            label: Text(
              _enabled
                  ? context.mobileText('Add authenticator')
                  : context.mobileText('Set up MFA'),
            ),
          ),
          if (_enabled) ...[
            const SizedBox(height: 12),
            Text(
              context.mobileText('{count} unused recovery codes', {
                'count': _status?['recoveryCodesRemaining'] ?? 0,
              }),
            ),
            TextButton(
              onPressed: _busy ? null : () => _act('recovery'),
              child: Text(context.mobileText('Replace recovery codes')),
            ),
            TextButton(
              onPressed: _busy ? null : () => _act('disable'),
              child: Text(context.mobileText('Turn off MFA')),
            ),
          ],
        ]),
        _section(context.mobileText('API access'), [
          Text(
            context.mobileText(
              'Create credentials for integrations with the permissions of your account.',
            ),
          ),
          for (final raw in tokens)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text('${raw['name']}'),
              subtitle: Text(
                '${raw['access'] == 'READ_WRITE' ? 'Read and write' : 'Read only'} · ${raw['active'] == true ? 'Expires' : 'Inactive'} ${_date(raw['expiresAt'])}',
              ),
              trailing: raw['active'] == true
                  ? IconButton(
                      tooltip: context.mobileText('Revoke token'),
                      onPressed: _busy
                          ? null
                          : () =>
                                _revoke(Map<String, dynamic>.from(raw as Map)),
                      icon: const Icon(Icons.delete_outline),
                    )
                  : null,
            ),
          OutlinedButton.icon(
            onPressed: _busy ? null : () => _act('token'),
            icon: const Icon(Icons.key),
            label: Text(context.mobileText('Create API token')),
          ),
        ]),
        if (role == UserRole.user || role == UserRole.subuser)
          _section(context.mobileText('Delete account'), [
            Text(
              role == UserRole.user
                  ? context.mobileText(
                      'Delete your account and its workspace access, including subusers. All sessions will end. This action cannot be undone in the app.',
                    )
                  : context.mobileText(
                      'Delete your account and end its sessions. This action cannot be undone in the app.',
                    ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _busy ? null : () => _act('delete'),
              icon: const Icon(Icons.delete_forever),
              label: Text(context.mobileText('Delete my account')),
            ),
          ]),
      ],
    ];
    if (widget.embedded) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      );
    }
    return RefreshIndicator(
      onRefresh: _busy ? () async {} : _load,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: children,
      ),
    );
  }

  Widget _section(String title, List<Widget> children) => Card(
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
  String _date(dynamic value) {
    final date = DateTime.tryParse('$value')?.toLocal();
    return date == null ? '—' : '${date.day}/${date.month}/${date.year}';
  }
}

class _ProofDialog extends StatefulWidget {
  const _ProofDialog({required this.action, required this.mfaEnabled});
  final String action;
  final bool mfaEnabled;
  @override
  State<_ProofDialog> createState() => _ProofDialogState();
}

class _ProofDialogState extends State<_ProofDialog> {
  final _form = GlobalKey<FormState>();
  final _password = TextEditingController(),
      _code = TextEditingController(),
      _name = TextEditingController();
  bool _confirmed = false;
  String _access = 'READ_ONLY';
  int _days = 90;
  @override
  void dispose() {
    _password.dispose();
    _code.dispose();
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final titles = {
      'enroll': context.mobileText('Add authenticator'),
      'disable': context.mobileText('Turn off MFA'),
      'remove': context.mobileText('Remove authenticator'),
      'recovery': context.mobileText('Replace recovery codes'),
      'delete': context.mobileText('Delete my account'),
      'token': context.mobileText('Create API token'),
    };
    return AlertDialog(
      title: Text(titles[widget.action]!),
      content: SingleChildScrollView(
        child: Form(
          key: _form,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (widget.action == 'disable')
                Text(
                  context.mobileText(
                    'Future sign-ins will need only your password.',
                  ),
                ),
              if (widget.action == 'recovery')
                Text(
                  context.mobileText(
                    'Your previous recovery codes will stop working.',
                  ),
                ),
              if (widget.action == 'enroll' || widget.action == 'token')
                TextFormField(
                  controller: _name,
                  maxLength: widget.action == 'token' ? 80 : 60,
                  decoration: InputDecoration(
                    labelText: widget.action == 'token'
                        ? context.mobileText('Token name')
                        : context.mobileText('Authenticator name'),
                  ),
                  validator: context.localizedValidator((v) => v?.trim().isNotEmpty == true ? null : context.mobileText('Enter a name.')),
                ),
              if (widget.action == 'token') ...[
                DropdownButtonFormField<String>(
                  initialValue: _access,
                  decoration: InputDecoration(
                    labelText: context.mobileText('Access'),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: 'READ_ONLY',
                      child: Text(context.mobileText('Read only')),
                    ),
                    DropdownMenuItem(
                      value: 'READ_WRITE',
                      child: Text(context.mobileText('Read and write')),
                    ),
                  ],
                  onChanged: (v) => setState(() => _access = v!),
                ),
                DropdownButtonFormField<int>(
                  initialValue: _days,
                  decoration: InputDecoration(
                    labelText: context.mobileText('Expires after'),
                  ),
                  items: [7, 30, 90, 365]
                      .map(
                        (v) => DropdownMenuItem(
                          value: v,
                          child: Text(
                            context.mobileText('{count} days', {'count': v}),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => setState(() => _days = v!),
                ),
              ],
              TextFormField(
                controller: _password,
                obscureText: true,
                autocorrect: false,
                enableSuggestions: false,
                maxLength: 128,
                decoration: InputDecoration(
                  labelText: context.mobileText('Current password'),
                ),
                validator: context.localizedValidator((v) => v?.isNotEmpty == true ? null : context.mobileText('Enter your password.')),
              ),
              if (widget.mfaEnabled)
                TextFormField(
                  controller: _code,
                  autocorrect: false,
                  enableSuggestions: false,
                  maxLength: 80,
                  decoration: InputDecoration(
                    labelText: context.mobileText(
                      'Authenticator or recovery code',
                    ),
                  ),
                  validator: context.localizedValidator((v) => (v?.trim().length ?? 0) >= 6 ? null : context.mobileText('Enter your verification code.')),
                ),
              if (widget.action == 'delete')
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  value: _confirmed,
                  onChanged: (v) => setState(() => _confirmed = v == true),
                  title: Text(
                    context.mobileText(
                      'I understand that my account and workspace access will be deleted.',
                    ),
                  ),
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
          onPressed: widget.action == 'delete' && !_confirmed
              ? null
              : () {
                  if (_form.currentState!.validate()) {
                    Navigator.pop(context, <String, dynamic>{
                      'currentPassword': _password.text,
                      if (widget.mfaEnabled) 'code': _code.text.trim(),
                      if (widget.action == 'enroll' || widget.action == 'token')
                        'name': _name.text.trim(),
                      if (widget.action == 'token') ...{
                        'access': _access,
                        'expiresInDays': _days,
                      },
                    });
                  }
                },
          child: Text(
            widget.action == 'delete'
                ? context.mobileText('Delete account')
                : context.mobileText('Continue'),
          ),
        ),
      ],
    );
  }
}

class _EnrollmentDialog extends StatefulWidget {
  const _EnrollmentDialog({required this.setup, required this.service});
  final Map<String, dynamic> setup;
  final SecurityController service;
  @override
  State<_EnrollmentDialog> createState() => _EnrollmentDialogState();
}

class _EnrollmentDialogState extends State<_EnrollmentDialog> {
  final _code = TextEditingController();
  bool _busy = false;
  String? _error;
  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  Future<void> _confirm() async {
    if (!RegExp(r'^\d{6}$').hasMatch(_code.text.trim())) {
      setState(() => _error = context.mobileText('Enter all six digits.'));
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final result = await widget.service.confirm(
        '${widget.setup['enrollmentToken']}',
        _code.text,
      );
      if (mounted) Navigator.pop(context, result);
    } catch (error) {
      if (mounted) {
        setState(() => _error = SecurityController.errorMessage(error));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final qr = '${widget.setup['qrDataUrl'] ?? ''}';
    Widget? qrWidget;
    if (qr.startsWith('data:image/svg+xml;base64,')) {
      try {
        qrWidget = SvgPicture.string(
          utf8.decode(base64Decode(qr.split(',').last)),
          width: 200,
          height: 200,
        );
      } catch (_) {
        /* Manual setup key remains available. */
      }
    }
    return PopScope(
      canPop: !_busy,
      child: AlertDialog(
        title: Text(context.mobileText('Connect your authenticator')),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                context.mobileText(
                  'Scan the QR code on another device, or copy the setup key into your authenticator app. Setup expires in 10 minutes.',
                ),
              ),
              if (qrWidget != null)
                Padding(padding: const EdgeInsets.all(16), child: qrWidget),
              const SizedBox(height: 12),
              SelectableText(
                '${widget.setup['secret']}',
                style: const TextStyle(fontFamily: 'monospace'),
              ),
              TextButton.icon(
                onPressed: _busy
                    ? null
                    : () => Clipboard.setData(
                        ClipboardData(text: '${widget.setup['secret']}'),
                      ),
                icon: const Icon(Icons.copy),
                label: Text(context.mobileText('Copy setup key')),
              ),
              TextField(
                controller: _code,
                enabled: !_busy,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                maxLength: 6,
                autofillHints: const [AutofillHints.oneTimeCode],
                decoration: InputDecoration(
                  labelText: context.mobileText('New authenticator code'),
                ),
              ),
              if (_error != null)
                Text(
                  _error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: _busy ? null : () => Navigator.pop(context),
            child: Text(context.mobileText('Cancel')),
          ),
          FilledButton(
            onPressed: _busy ? null : _confirm,
            child: Text(
              _busy
                  ? context.mobileText('Verifying…')
                  : context.mobileText('Confirm'),
            ),
          ),
        ],
      ),
    );
  }
}
