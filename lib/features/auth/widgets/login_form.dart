import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/route_paths.dart';
import '../../../core/theme/open_vts_colors.dart';
import '../../../core/theme/open_vts_spacing.dart';
import '../../../core/theme/open_vts_typography.dart';
import '../../../shared/helpers/mobile_text.dart';
import '../../../shared/widgets/open_vts_button.dart';
import '../../../shared/widgets/open_vts_text_field.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    required this.isLoading,
    required this.onSubmit,
    required this.onDemo,
    super.key,
  });

  final bool isLoading;
  final void Function(String email, String password) onSubmit;
  final VoidCallback onDemo;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _asciiRequired(String? value, String field) {
    if (value == null || value.isEmpty) return '$field is required.';
    if (value.runes.any((rune) => rune > 127)) {
      return '$field must use English characters.';
    }
    return null;
  }

  void _submit() {
    if (widget.isLoading) return;
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    widget.onSubmit(
      _identifierController.text.trim(),
      _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AutofillGroup(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            OpenVtsTextField(
              label: context.mobileText('Username or email'),
              hintText: context.mobileText('Enter your username or email'),
              controller: _identifierController,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.username],
              prefixIcon: Icons.person_outline_rounded,
              validator: (value) => _asciiRequired(value, 'Username or email'),
            ),
            const SizedBox(height: OpenVtsSpacing.md),
            OpenVtsTextField(
              label: context.mobileText('Password'),
              hintText: context.mobileText('Enter your password'),
              controller: _passwordController,
              obscureText: _obscurePassword,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.password],
              prefixIcon: Icons.lock_outline_rounded,
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
                tooltip: _obscurePassword
                    ? context.mobileText('Show password')
                    : context.mobileText('Hide password'),
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: isDark
                      ? OpenVtsColors.darkTextSecondary
                      : OpenVtsColors.textSecondary,
                ),
              ),
              validator: (value) => _asciiRequired(value, 'Password'),
              onFieldSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: OpenVtsSpacing.sm),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TextButton(
                onPressed: widget.isLoading
                    ? null
                    : () => context.push(RoutePaths.forgotPassword),
                style: TextButton.styleFrom(
                  foregroundColor: isDark
                      ? OpenVtsColors.darkTextTertiary
                      : OpenVtsColors.textTertiary,
                  minimumSize: const Size(44, 44),
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textStyle: OpenVtsTypography.meta.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                child: Text(context.mobileText('Forgot Password?')),
              ),
            ),
            const SizedBox(height: OpenVtsSpacing.md),
            SizedBox(
              width: double.infinity,
              child: OpenVtsButton(
                label: context.mobileText('Login'),
                isLoading: widget.isLoading,
                trailingIcon: Icons.arrow_forward_rounded,
                onPressed: _submit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
