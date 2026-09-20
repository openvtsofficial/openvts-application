import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_exception.dart';
import '../../../shared/widgets/open_vts_card.dart';
import '../controllers/auth_controller.dart';

/// Account deletion card with immediate deletion UX.
class AccountClosureCard extends ConsumerWidget {
  const AccountClosureCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authControllerProvider);
    if (auth.isDemo || auth.user?.canCloseAccount != true) {
      return const SizedBox.shrink();
    }
    return OpenVtsCard(child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Delete Account', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        const Text('Permanently delete your account and all associated data. '
          'This action cannot be undone.'),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          icon: const Icon(Icons.person_remove_outlined),
          label: const Text('Delete Account'),
          style: OutlinedButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.error),
          onPressed: () => showDialog<void>(context: context,
            barrierDismissible: false,
            builder: (_) => _AccountClosureDialog(isSubuser: auth.user!.isSubuser,
              onConfirm: (password, code) => ref.read(authControllerProvider.notifier)
                  .closeAccount(currentPassword: password, code: code))),
        ),
      ],
    ));
  }
}

class _AccountClosureDialog extends StatefulWidget {
  const _AccountClosureDialog({required this.isSubuser, required this.onConfirm});
  final bool isSubuser;
  final Future<void> Function(String password, String? code) onConfirm;
  @override
  State<_AccountClosureDialog> createState() => _AccountClosureDialogState();
}

class _AccountClosureDialogState extends State<_AccountClosureDialog> {
  final _form = GlobalKey<FormState>();
  final _password = TextEditingController();
  final _code = TextEditingController();
  bool _busy = false;
  String? _error;

  @override
  void dispose() { _password.dispose(); _code.dispose(); super.dispose(); }

  Future<void> _submit() async {
    if (_busy || !_form.currentState!.validate()) return;
    setState(() { _busy = true; _error = null; });
    try {
      await widget.onConfirm(_password.text, _code.text.trim());
      if (mounted) Navigator.of(context).pop();
    } catch (error) {
      if (!mounted) return;
      var message = 'Could not delete your account. Please try again.';
      if (error is ApiException) message = error.message;
      if (error is DioException) {
        final data = error.response?.data;
        if (data is Map && data['message'] is String) message = data['message'] as String;
        if (error.type == DioExceptionType.connectionError ||
            error.type == DioExceptionType.connectionTimeout ||
            error.type == DioExceptionType.receiveTimeout) {
          message = 'The server response could not be confirmed. '
              'Check your connection and account status before trying again.';
        }
      }
      setState(() { _busy = false; _error = message; });
    }
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: !_busy,
    child: AlertDialog(
      title: const Text('Delete Account?'),
      content: SingleChildScrollView(child: Form(key: _form, child: Column(
        mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Are you sure you want to delete your account? This will permanently remove your account and all associated data. This action cannot be undone.'),
          const SizedBox(height: 12),
          const SizedBox(height: 16),
          TextFormField(controller: _password, obscureText: true,
            enabled: !_busy, maxLength: 128, autocorrect: false, enableSuggestions: false,
            decoration: const InputDecoration(labelText: 'Current password'),
            validator: (value) => value == null || value.isEmpty ? 'Enter your password.' : null),
          TextFormField(controller: _code, enabled: !_busy, maxLength: 80,
            autocorrect: false, enableSuggestions: false,
            decoration: const InputDecoration(labelText: 'Authenticator or recovery code',
                helperText: 'Required only if two-factor authentication is enabled.'),
            autofillHints: const [AutofillHints.oneTimeCode]),
          if (_error != null) Padding(padding: const EdgeInsets.only(top: 12),
            child: Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error))),
        ],
      ))),
      actions: [
        TextButton(onPressed: _busy ? null : () => Navigator.of(context).pop(),
            child: const Text('Cancel')),
        FilledButton(onPressed: _busy ? null : _submit,
          style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
          child: Text(_busy ? 'Deleting…' : 'Delete Account')),
      ],
    ),
  );
}
