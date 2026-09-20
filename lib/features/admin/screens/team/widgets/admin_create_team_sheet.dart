import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/open_vts_spacing.dart';
import '../../../../../core/utils/validators.dart';
import '../../../../../shared/helpers/toast_helper.dart';
import '../../../../../shared/widgets/open_vts_button.dart';
import '../../../../../shared/widgets/open_vts_searchable_dropdown.dart';
import '../../../../../shared/widgets/open_vts_text_field.dart';
import '../../../controllers/admin_providers.dart';
import '../../../models/admin_team_model.dart';

class AdminCreateTeamSheet extends ConsumerStatefulWidget {
  const AdminCreateTeamSheet({
    required this.isSubmitting,
    this.initialMember,
    super.key,
  });

  factory AdminCreateTeamSheet.edit({
    required AdminTeamListItem member,
    bool isSubmitting = false,
  }) {
    return AdminCreateTeamSheet(
      isSubmitting: isSubmitting,
      initialMember: member,
    );
  }

  final bool isSubmitting;
  final AdminTeamListItem? initialMember;

  bool get isEditMode => initialMember != null;

  @override
  ConsumerState<AdminCreateTeamSheet> createState() =>
      _AdminCreateTeamSheetState();
}

class _AdminCreateTeamSheetState extends ConsumerState<AdminCreateTeamSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileNumberController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  var _mobilePrefixes = const <AdminTeamMobilePrefixOption>[];
  String? _mobilePrefix;
  var _isLoadingPrefixes = true;
  var _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _loadMobilePrefixes();
    _initializeFormData();
  }

  void _initializeFormData() {
    final member = widget.initialMember;
    if (member == null) return;

    _nameController.text = member.teamName;
    _emailController.text = member.email;
    _mobileNumberController.text = member.mobileNumber;
    _mobilePrefix = member.mobilePrefix.isNotEmpty ? member.mobilePrefix : null;
    _usernameController.text = member.username;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _mobileNumberController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
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
                if (_isLoadingPrefixes) ...[
                  const LinearProgressIndicator(minHeight: 2),
                  const SizedBox(height: OpenVtsSpacing.md),
                ],
                OpenVtsTextField(
                  label: 'Full Name',
                  controller: _nameController,
                  textInputAction: TextInputAction.next,
                  prefixIcon: Icons.person_outline_rounded,
                  validator: Validators.adminName,
                ),
                const SizedBox(height: OpenVtsSpacing.sm),
                OpenVtsTextField(
                  label: 'Email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  prefixIcon: Icons.mail_outline_rounded,
                  validator: Validators.email,
                ),
                const SizedBox(height: OpenVtsSpacing.sm),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final availableWidth = constraints.maxWidth;
                    final isTablet = availableWidth >= 600;

                    final prefixDropdown = AdminTeamMobilePrefixDropdown(
                      key: ValueKey<String?>(
                        'team-mobile-prefix-${_mobilePrefix ?? ''}',
                      ),
                      value: _mobilePrefix,
                      prefixes: _mobilePrefixes,
                      isLoading: _isLoadingPrefixes,
                      enabled: !widget.isSubmitting,
                      onChanged: widget.isSubmitting
                          ? (_) {}
                          : (value) => setState(() => _mobilePrefix = value),
                    );

                    final numberField = OpenVtsTextField(
                      label: 'Mobile Number',
                      controller: _mobileNumberController,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      prefixIcon: Icons.phone_rounded,
                      validator: Validators.mobileNumber,
                    );

                    if (!isTablet) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          prefixDropdown,
                          const SizedBox(height: OpenVtsSpacing.sm),
                          numberField,
                        ],
                      );
                    }

                    final prefixWidth =
                        (availableWidth * 0.30).clamp(110.0, 140.0);
                    final gapWidth = OpenVtsSpacing.md;

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: prefixWidth,
                          child: prefixDropdown,
                        ),
                        SizedBox(width: gapWidth),
                        Expanded(child: numberField),
                      ],
                    );
                  },
                ),
                const SizedBox(height: OpenVtsSpacing.sm),
                OpenVtsTextField(
                  label: 'Username',
                  controller: _usernameController,
                  textInputAction: TextInputAction.next,
                  prefixIcon: Icons.alternate_email_rounded,
                  validator: Validators.adminUsername,
                ),
                if (!widget.isEditMode) ...[
                  const SizedBox(height: OpenVtsSpacing.sm),
                  OpenVtsTextField(
                    label: 'Password',
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    textInputAction: TextInputAction.done,
                    prefixIcon: Icons.lock_outline_rounded,
                    suffixIcon: IconButton(
                      tooltip:
                          _obscurePassword ? 'Show password' : 'Hide password',
                      onPressed: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        size: 18,
                      ),
                    ),
                    validator: _passwordValidator,
                  ),
                ] else
                  const SizedBox(height: 0),
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
                      label: widget.isEditMode ? 'Update' : 'Save',
                      onPressed: widget.isSubmitting ? null : _submit,
                      isLoading: widget.isSubmitting,
                      trailingIcon: widget.isEditMode
                          ? Icons.check_rounded
                          : Icons.person_add_alt_1_rounded,
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

  Future<void> _loadMobilePrefixes() async {
    setState(() => _isLoadingPrefixes = true);

    try {
      final prefixes = await ref
          .read(adminTeamControllerProvider.notifier)
          .getMobilePrefixes();
      if (!mounted) {
        return;
      }

      String? selected;
      if (prefixes.isNotEmpty) {
        final preferred = prefixes.where((item) => item.code.trim() == '+91');
        selected =
            preferred.isNotEmpty ? preferred.first.code : prefixes.first.code;
      }

      setState(() {
        _mobilePrefixes = prefixes;
        _mobilePrefix = selected;
        _isLoadingPrefixes = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _mobilePrefixes = const <AdminTeamMobilePrefixOption>[];
        _mobilePrefix = null;
        _isLoadingPrefixes = false;
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (widget.isEditMode) {
      await _submitEdit();
    } else {
      await _submitCreate();
    }
  }

  Future<void> _submitCreate() async {
    final request = AdminCreateTeamRequest(
      name: _nameController.text,
      email: _emailController.text,
      mobilePrefix: _mobilePrefix ?? '',
      mobileNumber: _mobileNumberController.text,
      username: _usernameController.text,
      password: _passwordController.text,
    );

    final success = await ref
        .read(adminTeamControllerProvider.notifier)
        .createTeam(request);

    if (!mounted) {
      return;
    }

    if (success) {
      Navigator.of(context).pop();
      ToastHelper.showSuccess('Team member created.', context: context);
      return;
    }

    final error = ref.read(adminTeamControllerProvider).createErrorMessage;
    ToastHelper.showError(
      error ?? 'Unable to create team member.',
      context: context,
    );
  }

  Future<void> _submitEdit() async {
    final member = widget.initialMember;
    if (member == null) {
      return;
    }

    final request = AdminUpdateTeamRequest(
      name: _nameController.text,
      email: _emailController.text,
      mobilePrefix: _mobilePrefix ?? '',
      mobileNumber: _mobileNumberController.text,
      username: _usernameController.text,
    );

    final success = await ref
        .read(adminTeamControllerProvider.notifier)
        .updateTeam(member.id, request);

    if (!mounted) {
      return;
    }

    if (success) {
      Navigator.of(context).pop();
      ToastHelper.showSuccess('Team member updated.', context: context);
      return;
    }

    ToastHelper.showError(
      'Unable to update team member.',
      context: context,
    );
  }

  String? _passwordValidator(String? value) {
    final requiredError = Validators.required(value, fieldName: 'Password');
    if (requiredError != null) {
      return requiredError;
    }

    if (value!.trim().length < 8) {
      return 'Password must be at least 8 characters';
    }

    return null;
  }
}

class AdminTeamMobilePrefixDropdown extends StatelessWidget {
  const AdminTeamMobilePrefixDropdown({
    required this.value,
    required this.prefixes,
    required this.onChanged,
    this.isLoading = false,
    this.enabled = true,
    super.key,
  });

  final String? value;
  final List<AdminTeamMobilePrefixOption> prefixes;
  final ValueChanged<String?> onChanged;
  final bool isLoading;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return OpenVtsSearchableDropdown<String>(
      label: 'Mobile Prefix',
      value: value,
      options: prefixes
          .map(
            (item) => OpenVtsDropdownOption<String>(
              value: item.code,
              label: item.code,
              subtitle: item.country.trim().isEmpty ? null : item.country,
              searchText: '${item.code} ${item.country} ${item.label}',
            ),
          )
          .toList(growable: false),
      hintText: '+91',
      searchHintText: 'Search dial code or country',
      leadingIcon: Icons.phone_android_rounded,
      isLoading: isLoading,
      enabled: enabled,
      required: true,
      validator: (selected) => Validators.required(
        selected,
        fieldName: 'Mobile prefix',
      ),
      onChanged: onChanged,
    );
  }
}
