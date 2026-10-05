import 'package:flutter/material.dart';

import '../../../../../core/theme/open_vts_colors.dart';
import '../../../../../core/theme/open_vts_radius.dart';
import '../../../../../core/theme/open_vts_spacing.dart';
import '../../../../../core/theme/open_vts_typography.dart';
import '../../../../../shared/helpers/mobile_text.dart';
import '../../../../../shared/helpers/validation_localizations.dart';
import '../../../../../shared/widgets/open_vts_button.dart';
import '../../../models/user_settings_model.dart';

class UserPasswordChangeSheet extends StatefulWidget {
  const UserPasswordChangeSheet({required this.onSave, super.key});

  final Future<bool> Function(UserChangePasswordRequest request) onSave;

  @override
  State<UserPasswordChangeSheet> createState() =>
      _UserPasswordChangeSheetState();
}

class _UserPasswordChangeSheetState extends State<UserPasswordChangeSheet> {
  final _formKey = GlobalKey<FormState>();
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _isSaving = false;
  String? _errorText;

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }

    final request = UserChangePasswordRequest(
      currentPassword: _currentController.text,
      newPassword: _newController.text,
    );

    setState(() {
      _isSaving = true;
      _errorText = null;
    });

    final ok = await widget.onSave(request);
    if (!mounted) {
      return;
    }

    setState(() {
      _isSaving = false;
      if (!ok) {
        _errorText = 'Unable to change password. Please try again.';
      }
    });

    if (ok) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final insets = MediaQuery.viewInsetsOf(context).bottom;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(OpenVtsRadius.lg),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            OpenVtsSpacing.md,
            OpenVtsSpacing.md,
            OpenVtsSpacing.md,
            OpenVtsSpacing.md + insets,
          ),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.mobileText('Change Password'),
                  style: OpenVtsTypography.label.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: OpenVtsSpacing.xxs),
                Text(
                  context.mobileText('Use 6–72 English characters.'),
                  style: OpenVtsTypography.meta.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: OpenVtsSpacing.sm),
                TextFormField(
                  controller: _currentController,
                  obscureText: _obscureCurrent,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: context.mobileText('Current password'),
                    suffixIcon: IconButton(
                      constraints: const BoxConstraints(
                        minWidth: 44,
                        minHeight: 44,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureCurrent = !_obscureCurrent;
                        });
                      },
                      icon: Icon(
                        _obscureCurrent
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        size: 18,
                      ),
                    ),
                  ),
                  validator: context.localizedValidator((value) {if ((value ?? '').isEmpty) {return 'Current password is required.';} return null;}),
                ),
                const SizedBox(height: OpenVtsSpacing.xs),
                TextFormField(
                  controller: _newController,
                  obscureText: _obscureNew,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: context.mobileText('New Password'),
                    suffixIcon: IconButton(
                      constraints: const BoxConstraints(
                        minWidth: 44,
                        minHeight: 44,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureNew = !_obscureNew;
                        });
                      },
                      icon: Icon(
                        _obscureNew
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        size: 18,
                      ),
                    ),
                  ),
                  validator: context.localizedValidator((value) {final next = value ?? ''; if (next.isEmpty) {return 'New password is required.';} if (next.length < 6 || next.length > 72 || next.runes.any((r) => r < 32 || r > 126)) {return context.mobileText('Use 6–72 English characters.');} if (next == _currentController.text) {return 'New password must be different.';} return null;}),
                ),
                const SizedBox(height: OpenVtsSpacing.xs),
                TextFormField(
                  controller: _confirmController,
                  obscureText: _obscureConfirm,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _handleSave(),
                  decoration: InputDecoration(
                    labelText: context.mobileText('Confirm new password'),
                    suffixIcon: IconButton(
                      constraints: const BoxConstraints(
                        minWidth: 44,
                        minHeight: 44,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirm = !_obscureConfirm;
                        });
                      },
                      icon: Icon(
                        _obscureConfirm
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        size: 18,
                      ),
                    ),
                  ),
                  validator: context.localizedValidator((value) {if ((value ?? '').isEmpty) {return 'Confirm your new password.';} if (value != _newController.text) {return 'Passwords do not match.';} return null;}),
                ),
                if (_errorText != null) ...[
                  const SizedBox(height: OpenVtsSpacing.xs),
                  Text(
                    _errorText!,
                    style: OpenVtsTypography.meta.copyWith(
                      color: OpenVtsColors.warning,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
                const SizedBox(height: OpenVtsSpacing.sm),
                Row(
                  children: [
                    Expanded(
                      child: OpenVtsButton(
                        label: context.mobileText('Cancel'),
                        variant: OpenVtsButtonVariant.secondary,
                        height: 44,
                        onPressed: _isSaving
                            ? null
                            : () => Navigator.of(context).pop(false),
                      ),
                    ),
                    const SizedBox(width: OpenVtsSpacing.xs),
                    Expanded(
                      child: OpenVtsButton(
                        label: context.mobileText('Update Password'),
                        height: 44,
                        isLoading: _isSaving,
                        onPressed: _isSaving ? null : _handleSave,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
