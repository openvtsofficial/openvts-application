import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/open_vts_spacing.dart';
import '../../../../../core/utils/validators.dart';
import '../../../../../shared/helpers/toast_helper.dart';
import '../../../../../shared/widgets/open_vts_button.dart';
import '../../../../../shared/widgets/open_vts_text_field.dart';
import '../../../controllers/admin_providers.dart';
import '../../../models/admin_team_model.dart';

class AdminChangePasswordSheet extends ConsumerStatefulWidget {
  const AdminChangePasswordSheet({
    required this.member,
    required this.isSubmitting,
    super.key,
  });

  final AdminTeamListItem member;
  final bool isSubmitting;

  @override
  ConsumerState<AdminChangePasswordSheet> createState() =>
      _AdminChangePasswordSheetState();
}

class _AdminChangePasswordSheetState
    extends ConsumerState<AdminChangePasswordSheet> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  var _obscureNew = true;
  var _obscureConfirm = true;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              controller: PrimaryScrollController.maybeOf(context),
              padding: const EdgeInsets.fromLTRB(
                OpenVtsSpacing.md,
                OpenVtsSpacing.md,
                OpenVtsSpacing.md,
                OpenVtsSpacing.lg,
              ),
              children: [
                OpenVtsTextField(
                  label: 'New Password',
                  controller: _newPasswordController,
                  obscureText: _obscureNew,
                  textInputAction: TextInputAction.next,
                  prefixIcon: Icons.lock_outline_rounded,
                  suffixIcon: IconButton(
                    tooltip: _obscureNew ? 'Show password' : 'Hide password',
                    onPressed: () {
                      setState(() => _obscureNew = !_obscureNew);
                    },
                    icon: Icon(
                      _obscureNew
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 18,
                    ),
                  ),
                  validator: _validatePassword,
                ),
                const SizedBox(height: OpenVtsSpacing.sm),
                OpenVtsTextField(
                  label: 'Confirm Password',
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirm,
                  textInputAction: TextInputAction.done,
                  prefixIcon: Icons.lock_outline_rounded,
                  suffixIcon: IconButton(
                    tooltip:
                        _obscureConfirm ? 'Show password' : 'Hide password',
                    onPressed: () {
                      setState(() => _obscureConfirm = !_obscureConfirm);
                    },
                    icon: Icon(
                      _obscureConfirm
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 18,
                    ),
                  ),
                  validator: _validateConfirm,
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                OpenVtsSpacing.md,
                OpenVtsSpacing.md,
                OpenVtsSpacing.md,
                OpenVtsSpacing.md + MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OpenVtsButton(
                      label: 'Cancel',
                      variant: OpenVtsButtonVariant.secondary,
                      onPressed: widget.isSubmitting
                          ? null
                          : () => Navigator.of(context).pop(),
                    ),
                  ),
                  const SizedBox(width: OpenVtsSpacing.sm),
                  Expanded(
                    child: OpenVtsButton(
                      label: 'Change Password',
                      onPressed: widget.isSubmitting ? null : _submit,
                      isLoading: widget.isSubmitting,
                      trailingIcon: Icons.check_rounded,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final password = _newPasswordController.text.trim();

    final success = await ref
        .read(adminTeamControllerProvider.notifier)
        .changeTeamMemberPassword(widget.member.id, password);

    if (!mounted) {
      return;
    }

    if (success) {
      Navigator.of(context).pop();
      ToastHelper.showSuccess('Password changed.', context: context);
      return;
    }

    ToastHelper.showError(
      'Unable to change password.',
      context: context,
    );
  }

  String? _validatePassword(String? value) {
    final requiredError = Validators.required(value, fieldName: 'New password');
    if (requiredError != null) {
      return requiredError;
    }

    if (value!.trim().length < 8) {
      return 'Password must be at least 8 characters';
    }

    return null;
  }

  String? _validateConfirm(String? value) {
    final requiredError =
        Validators.required(value, fieldName: 'Confirm password');
    if (requiredError != null) {
      return requiredError;
    }

    if (value != _newPasswordController.text) {
      return 'Passwords do not match';
    }

    return null;
  }
}
