import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../shared/helpers/mobile_text.dart';
import '../../../shared/helpers/validation_localizations.dart';

class MfaLoginForm extends StatefulWidget {
  const MfaLoginForm({
    required this.isLoading,
    required this.onSubmit,
    required this.onCancel,
    super.key,
  });
  final bool isLoading;
  final ValueChanged<String> onSubmit;
  final VoidCallback onCancel;
  @override
  State<MfaLoginForm> createState() => _MfaLoginFormState();
}

class _MfaLoginFormState extends State<MfaLoginForm> {
  final _code = TextEditingController();
  final _form = GlobalKey<FormState>();
  bool _recovery = false;
  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  void _submit() {
    if (!widget.isLoading && _form.currentState!.validate()) {
      widget.onSubmit(_code.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) => Form(
    key: _form,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Icon(Icons.verified_user_outlined, size: 40),
        const SizedBox(height: 16),
        Text(
          context.mobileText('Verify your sign-in'),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(
          _recovery
              ? context.mobileText('Enter one of your unused recovery codes.')
              : context.mobileText(
                  'Enter the six-digit code from your authenticator app.',
                ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        TextFormField(
          controller: _code,
          enabled: !widget.isLoading,
          autofocus: true,
          keyboardType: _recovery ? TextInputType.text : TextInputType.number,
          autofillHints: _recovery ? null : const [AutofillHints.oneTimeCode],
          autocorrect: false,
          enableSuggestions: false,
          maxLength: _recovery ? 80 : 6,
          inputFormatters: _recovery
              ? null
              : [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            labelText: _recovery
                ? context.mobileText('Recovery code')
                : context.mobileText('Authenticator code'),
          ),
          validator: context.localizedValidator((value) {final text = value?.trim() ?? ''; if (_recovery) {return RegExp(r'^[a-fA-F0-9]{8}(?:-?[a-fA-F0-9]{8}){3}$').hasMatch(text) ? null : context.mobileText('Enter a complete recovery code.');} return RegExp(r'^\d{6}$').hasMatch(text) ? null : context.mobileText('Enter all six digits.');}),
          onFieldSubmitted: (_) => _submit(),
        ),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: widget.isLoading ? null : _submit,
          child: Text(
            widget.isLoading
                ? context.mobileText('Verifying…')
                : context.mobileText('Verify and sign in'),
          ),
        ),
        TextButton(
          onPressed: widget.isLoading
              ? null
              : () => setState(() {
                  _recovery = !_recovery;
                  _code.clear();
                  _form.currentState?.reset();
                }),
          child: Text(
            _recovery
                ? context.mobileText('Use authenticator code')
                : context.mobileText('Use recovery code'),
          ),
        ),
        TextButton(
          onPressed: widget.isLoading ? null : widget.onCancel,
          child: Text(context.mobileText('Back to sign in')),
        ),
      ],
    ),
  );
}
