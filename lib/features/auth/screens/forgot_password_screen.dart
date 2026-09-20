import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/api/api_exception.dart';
import '../../../core/router/route_paths.dart';
import '../../../shared/helpers/toast_helper.dart';
import '../../../shared/widgets/open_vts_page_scaffold.dart';
import '../controllers/auth_controller.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({
    this.initialToken,
    super.key,
  });

  final String? initialToken;

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _requestFormKey = GlobalKey<FormState>();
  final _resetFormKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  final _tokenController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _showResetForm = false;
  bool _isSubmitting = false;
  bool _obscurePassword = true;
  String? _statusMessage;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    final initialToken = widget.initialToken?.trim();
    if (initialToken != null && initialToken.isNotEmpty) {
      _tokenController.text = initialToken;
      _showResetForm = true;
    }
  }

  @override
  void dispose() {
    _identifierController.dispose();
    _tokenController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OpenVtsPageScaffold(
      title: _showResetForm ? 'Reset Password' : 'Forgot Password',
      leading: IconButton(
        tooltip: 'Back to sign in',
        onPressed: () => context.go(RoutePaths.login),
        icon: const Icon(Icons.arrow_back_rounded),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  child: _showResetForm
                      ? _buildResetForm(context)
                      : _buildRequestForm(context),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRequestForm(BuildContext context) {
    return Form(
      key: _requestFormKey,
      child: Column(
        key: const ValueKey('request-password-reset'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(
            Icons.lock_reset_rounded,
            size: 52,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            'Recover your account',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          const Text(
            'Enter the email address or username used to sign in. If the '
            'account exists, we will send a time-limited reset link.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: _identifierController,
            enabled: !_isSubmitting,
            autofocus: true,
            autofillHints: const [
              AutofillHints.username,
              AutofillHints.email,
            ],
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              labelText: 'Email or username',
              prefixIcon: Icon(Icons.person_outline_rounded),
            ),
            validator: (value) => value?.trim().isEmpty == true
                ? 'Enter your email address or username.'
                : null,
            onFieldSubmitted: (_) => _requestReset(),
          ),
          const SizedBox(height: 16),
          _buildFeedback(),
          FilledButton.icon(
            onPressed: _isSubmitting ? null : _requestReset,
            icon: _isSubmitting
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.send_rounded),
            label: const Text('Send reset link'),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: _isSubmitting
                ? null
                : () => setState(() {
                      _showResetForm = true;
                      _statusMessage = null;
                      _errorMessage = null;
                    }),
            child: const Text('I already have a reset link'),
          ),
        ],
      ),
    );
  }

  Widget _buildResetForm(BuildContext context) {
    return Form(
      key: _resetFormKey,
      child: Column(
        key: const ValueKey('complete-password-reset'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(
            Icons.password_rounded,
            size: 52,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            'Choose a new password',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          const Text(
            'Paste the complete reset link or token from your email. '
            'Reset links are single-use and expire automatically.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: _tokenController,
            enabled: !_isSubmitting,
            minLines: 1,
            maxLines: 3,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Reset link or token',
              prefixIcon: Icon(Icons.link_rounded),
            ),
            validator: (value) => value?.trim().isEmpty == true
                ? 'Enter the reset link or token from your email.'
                : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _passwordController,
            enabled: !_isSubmitting,
            obscureText: _obscurePassword,
            autofillHints: const [AutofillHints.newPassword],
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: 'New password',
              helperText: '6–35 characters',
              prefixIcon: const Icon(Icons.lock_outline_rounded),
              suffixIcon: IconButton(
                tooltip: _obscurePassword ? 'Show password' : 'Hide password',
                onPressed: () => setState(
                  () => _obscurePassword = !_obscurePassword,
                ),
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
              ),
            ),
            validator: _validatePassword,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _confirmPasswordController,
            enabled: !_isSubmitting,
            obscureText: _obscurePassword,
            autofillHints: const [AutofillHints.newPassword],
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              labelText: 'Confirm password',
              prefixIcon: Icon(Icons.lock_outline_rounded),
            ),
            validator: (value) => value != _passwordController.text
                ? 'Passwords do not match.'
                : null,
            onFieldSubmitted: (_) => _completeReset(),
          ),
          const SizedBox(height: 16),
          _buildFeedback(),
          FilledButton.icon(
            onPressed: _isSubmitting ? null : _completeReset,
            icon: _isSubmitting
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.check_circle_outline_rounded),
            label: const Text('Reset password'),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: _isSubmitting
                ? null
                : () => setState(() {
                      _showResetForm = false;
                      _statusMessage = null;
                      _errorMessage = null;
                    }),
            child: const Text('Request a new reset link'),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedback() {
    final error = _errorMessage;
    final status = _statusMessage;
    if (error == null && status == null) {
      return const SizedBox.shrink();
    }

    final isError = error != null;
    final color = isError
        ? Theme.of(context).colorScheme.error
        : Theme.of(context).colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Semantics(
        liveRegion: true,
        child: Text(
          error ?? status!,
          style: TextStyle(color: color),
        ),
      ),
    );
  }

  Future<void> _requestReset() async {
    if (_isSubmitting || _requestFormKey.currentState?.validate() != true) {
      return;
    }

    setState(() {
      _isSubmitting = true;
      _statusMessage = null;
      _errorMessage = null;
    });
    try {
      final message = await ref
          .read(authControllerProvider.notifier)
          .requestPasswordReset(_identifierController.text);
      if (!mounted) return;
      setState(() {
        _statusMessage = message;
        _showResetForm = true;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _errorMessage = _messageFor(error));
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Future<void> _completeReset() async {
    if (_isSubmitting || _resetFormKey.currentState?.validate() != true) {
      return;
    }

    setState(() {
      _isSubmitting = true;
      _statusMessage = null;
      _errorMessage = null;
    });
    try {
      final message =
          await ref.read(authControllerProvider.notifier).resetPassword(
                token: _tokenController.text,
                newPassword: _passwordController.text,
              );
      if (!mounted) return;
      // The backend revokes every existing access/refresh token after a
      // successful reset. Clear matching local role sessions as one atomic
      // client-side transition before returning to sign in.
      await ref.read(authControllerProvider.notifier).logoutAllRoles();
      if (!mounted) return;
      ToastHelper.showSuccess(message);
      context.go(RoutePaths.login);
    } catch (error) {
      if (!mounted) return;
      setState(() => _errorMessage = _messageFor(error));
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  String? _validatePassword(String? value) {
    final password = value ?? '';
    if (password.length < 6 || password.length > 35) {
      return 'Password must contain between 6 and 35 characters.';
    }
    return null;
  }

  String _messageFor(Object error) {
    if (error is ApiException) {
      return error.message;
    }
    return error
        .toString()
        .replaceFirst(RegExp(r'^Exception:\s*'), '')
        .replaceFirst(RegExp(r'^ApiException\(\d+\):\s*'), '');
  }
}
