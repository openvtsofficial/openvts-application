import 'package:flutter/material.dart';

import '../../../../../core/theme/open_vts_colors.dart';
import '../../../../../core/theme/open_vts_radius.dart';
import '../../../../../core/theme/open_vts_spacing.dart';
import '../../../../../core/theme/open_vts_typography.dart';
import '../../../../../shared/helpers/mobile_text.dart';
import '../../../../../shared/helpers/validation_localizations.dart';
import '../../../../../shared/widgets/open_vts_button.dart';
import '../../../models/user_settings_model.dart';

class UserCompanyEditSheet extends StatefulWidget {
  const UserCompanyEditSheet({
    required this.company,
    required this.onSave,
    super.key,
  });

  final UserSettingsCompany company;
  final Future<bool> Function(UserUpdateCompanyRequest request) onSave;

  @override
  State<UserCompanyEditSheet> createState() => _UserCompanyEditSheetState();
}

class _UserCompanyEditSheetState extends State<UserCompanyEditSheet> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _websiteController;
  late final TextEditingController _customDomainController;
  late final TextEditingController _primaryColorController;
  late final TextEditingController _facebookController;
  late final TextEditingController _twitterController;
  late final TextEditingController _linkedinController;
  late final TextEditingController _instagramController;
  late final TextEditingController _youtubeController;
  late final TextEditingController _githubController;

  bool _isSaving = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.company.name ?? '');
    _websiteController = TextEditingController(
      text: widget.company.websiteUrl ?? '',
    );
    _customDomainController = TextEditingController(
      text: widget.company.customDomain ?? '',
    );
    _primaryColorController = TextEditingController(
      text: widget.company.primaryColor ?? '',
    );

    final social = widget.company.socialLinks;
    _facebookController = TextEditingController(text: social?.facebook ?? '');
    _twitterController = TextEditingController(text: social?.twitter ?? '');
    _linkedinController = TextEditingController(text: social?.linkedin ?? '');
    _instagramController = TextEditingController(text: social?.instagram ?? '');
    _youtubeController = TextEditingController(text: social?.youtube ?? '');
    _githubController = TextEditingController(text: social?.github ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _websiteController.dispose();
    _customDomainController.dispose();
    _primaryColorController.dispose();
    _facebookController.dispose();
    _twitterController.dispose();
    _linkedinController.dispose();
    _instagramController.dispose();
    _youtubeController.dispose();
    _githubController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }

    final request = UserUpdateCompanyRequest(
      name: _trimOrNull(_nameController.text),
      websiteUrl: _trimOrNull(_websiteController.text),
      customDomain: _trimOrNull(_customDomainController.text),
      primaryColor: _trimOrNull(_primaryColorController.text),
      socialLinks: UserSettingsSocialLinks(
        facebook: _trimOrNull(_facebookController.text),
        twitter: _trimOrNull(_twitterController.text),
        linkedin: _trimOrNull(_linkedinController.text),
        instagram: _trimOrNull(_instagramController.text),
        youtube: _trimOrNull(_youtubeController.text),
        github: _trimOrNull(_githubController.text),
      ),
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
        _errorText = 'Unable to update company details. Please retry.';
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
                  context.mobileText('Edit company'),
                  style: OpenVtsTypography.label.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: OpenVtsSpacing.xxs),
                Text(
                  context.mobileText(
                    'Update company identity and social links.',
                  ),
                  style: OpenVtsTypography.meta.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: OpenVtsSpacing.sm),
                _textField(
                  controller: _nameController,
                  label: context.mobileText('Company name'),
                  validator: (value) {
                    if ((value ?? '').trim().isEmpty) {
                      return 'Company name is required.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: OpenVtsSpacing.xs),
                _textField(
                  controller: _websiteController,
                  label: context.mobileText('Website URL'),
                  hint: 'https://example.com',
                  validator: _optionalUrlValidator,
                ),
                const SizedBox(height: OpenVtsSpacing.xs),
                _textField(
                  controller: _customDomainController,
                  label: context.mobileText('Custom domain'),
                  hint: 'https://brand.example.com',
                  validator: _optionalUrlValidator,
                ),
                const SizedBox(height: OpenVtsSpacing.xs),
                _textField(
                  controller: _primaryColorController,
                  label: context.mobileText('Primary color'),
                  hint: '#0F172A',
                ),
                const SizedBox(height: OpenVtsSpacing.sm),
                Text(
                  context.mobileText('Social Links'),
                  style: OpenVtsTypography.meta.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: OpenVtsSpacing.xs),
                _textField(
                  controller: _facebookController,
                  label: context.mobileText('Facebook'),
                ),
                const SizedBox(height: OpenVtsSpacing.xs),
                _textField(
                  controller: _twitterController,
                  label: context.mobileText('Twitter/X'),
                ),
                const SizedBox(height: OpenVtsSpacing.xs),
                _textField(
                  controller: _linkedinController,
                  label: context.mobileText('LinkedIn'),
                ),
                const SizedBox(height: OpenVtsSpacing.xs),
                _textField(
                  controller: _instagramController,
                  label: context.mobileText('Instagram'),
                ),
                const SizedBox(height: OpenVtsSpacing.xs),
                _textField(
                  controller: _youtubeController,
                  label: context.mobileText('YouTube'),
                ),
                const SizedBox(height: OpenVtsSpacing.xs),
                _textField(
                  controller: _githubController,
                  label: context.mobileText('GitHub'),
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
                        label: context.mobileText('Save Company'),
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

  Widget _textField({
    required TextEditingController controller,
    required String label,
    String? hint,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: context.localizedValidator(validator),
      decoration: InputDecoration(labelText: label, hintText: hint),
    );
  }

  String? _optionalUrlValidator(String? value) {
    final normalized = (value ?? '').trim();
    if (normalized.isEmpty) {
      return null;
    }
    if (_normalizeUrl(normalized) == null) {
      return 'Enter a valid URL.';
    }
    return null;
  }

  String? _normalizeUrl(String value) {
    final candidate =
        value.startsWith('http://') || value.startsWith('https://')
        ? value
        : 'https://$value';
    final uri = Uri.tryParse(candidate);
    if (uri == null || uri.host.trim().isEmpty) {
      return null;
    }
    return candidate;
  }

  String? _trimOrNull(String value) {
    final normalized = value.trim();
    if (normalized.isEmpty) {
      return null;
    }
    return normalized;
  }
}
