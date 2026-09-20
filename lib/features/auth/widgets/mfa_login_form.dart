import 'package:flutter/material.dart';

/// Completes the backend's existing MFA login challenge.
class MfaLoginForm extends StatefulWidget {
  const MfaLoginForm({required this.isLoading, required this.onSubmit,
    required this.onCancel, super.key});

  final bool isLoading;
  final ValueChanged<String> onSubmit;
  final VoidCallback onCancel;

  @override
  State<MfaLoginForm> createState() => _MfaLoginFormState();
}

class _MfaLoginFormState extends State<MfaLoginForm> {
  final _form = GlobalKey<FormState>();
  final _code = TextEditingController();

  @override
  void dispose() { _code.dispose(); super.dispose(); }

  void _submit() {
    if (!widget.isLoading && _form.currentState!.validate()) {
      widget.onSubmit(_code.text.trim());
      _code.clear();
    }
  }

  @override
  Widget build(BuildContext context) => Form(
    key: _form,
    child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Text('Verify your sign-in', style: Theme.of(context).textTheme.titleMedium),
      const SizedBox(height: 8),
      const Text('Enter a code from your authenticator app or an unused recovery code.'),
      const SizedBox(height: 16),
      TextFormField(controller: _code, autofocus: true,
        enabled: !widget.isLoading, maxLength: 80,
        autocorrect: false, enableSuggestions: false,
        autofillHints: const [AutofillHints.oneTimeCode],
        textInputAction: TextInputAction.done,
        decoration: const InputDecoration(labelText: 'Verification code'),
        onFieldSubmitted: (_) => _submit(),
        validator: (value) => (value?.trim().length ?? 0) < 6
            ? 'Enter your authenticator or recovery code.' : null),
      const SizedBox(height: 16),
      FilledButton(onPressed: widget.isLoading ? null : _submit,
        child: Text(widget.isLoading ? 'Verifying…' : 'Verify')),
      TextButton(onPressed: widget.isLoading ? null : widget.onCancel,
        child: const Text('Back to sign-in')),
    ]),
  );
}
