import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../controllers/auth_controller.dart';
import '../../../core/providers/core_providers.dart';
import '../../../core/theme/open_vts_colors.dart';
import '../../../core/theme/open_vts_spacing.dart';
import '../../../core/theme/open_vts_typography.dart';
import '../../../shared/helpers/toast_helper.dart';
import '../../../shared/widgets/open_vts_button.dart';
import '../../../shared/widgets/open_vts_card.dart';
import '../../../shared/widgets/open_vts_page_scaffold.dart';
import '../../../shared/widgets/open_vts_text_field.dart';

class ApiBaseUrlSettingsScreen extends ConsumerStatefulWidget {
  const ApiBaseUrlSettingsScreen({super.key});

  @override
  ConsumerState<ApiBaseUrlSettingsScreen> createState() =>
      _ApiBaseUrlSettingsScreenState();
}

class _ApiBaseUrlSettingsScreenState
    extends ConsumerState<ApiBaseUrlSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _urlController;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _urlController = TextEditingController(text: ref.read(apiBaseUrlProvider));
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving || _formKey.currentState?.validate() != true) return;
    await _changeServer(_urlController.text.trim());
  }

  Future<void> _reset() async {
    if (_saving) return;
    await _changeServer(ref.read(apiBaseUrlProvider.notifier).defaultUrl, reset: true);
  }

  Future<void> _changeServer(String url, {bool reset = false}) async {
    setState(() => _saving = true);
    // Read both controllers before logout rebuilds the authenticated subtree.
    final server = ref.read(apiBaseUrlProvider.notifier);
    final auth = ref.read(authControllerProvider.notifier);
    try {
      if (url != ref.read(apiBaseUrlProvider)) {
        // Deregister push and remove credentials against the OLD server first.
        await auth.logoutAllRoles();
      }
      if (reset) {
        await server.resetToDefault();
      } else {
        await server.saveCustomUrl(url);
      }
      if (!mounted) return;
      _urlController.text = url;
      ToastHelper.show(context, 'Server URL updated. Sign in to continue.');
      Navigator.of(context).pop();
    } catch (_) {
      if (mounted) ToastHelper.showError('Could not update the server URL.');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  String? _validateUrl(String? value) => AppConfig.validateApiBaseUrl(value ?? '');

  @override
  Widget build(BuildContext context) {
    final activeUrl = ref.watch(apiBaseUrlProvider);
    final defaultUrl = ref.read(apiBaseUrlProvider.notifier).defaultUrl;
    final isUsingDefault = activeUrl == defaultUrl;

    return OpenVtsPageScaffold(
      title: 'Server URL',
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OpenVtsCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OpenVtsTextField(
                      label: 'Server URL',
                      controller: _urlController,
                      hintText: 'https://your-server.example/api',
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      prefixIcon: Icons.dns_rounded,
                      validator: _validateUrl,
                      onFieldSubmitted: (_) => _save(),
                    ),
                    const SizedBox(height: OpenVtsSpacing.sm),
                    Text(
                      'Include the full path, e.g. https://your-server.example/api',
                      style: OpenVtsTypography.meta.copyWith(
                        color: OpenVtsColors.textSecondary,
                      ),
                    ),
                    if (kIsWeb) ...[
                      const SizedBox(height: OpenVtsSpacing.xs),
                      Text(
                        'Web browsers require the server to allow cross-origin requests (CORS). If login fails with a connection error, enable CORS on your server.',
                        style: OpenVtsTypography.meta.copyWith(
                          color: OpenVtsColors.textSecondary,
                        ),
                      ),
                    ],
                    if (!isUsingDefault) ...[
                      const SizedBox(height: OpenVtsSpacing.sm),
                      GestureDetector(
                        onTap: _saving ? null : _reset,
                        child: Text(
                          'Reset to default ($defaultUrl)',
                          style: OpenVtsTypography.meta.copyWith(
                            color: OpenVtsColors.textSecondary,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: OpenVtsSpacing.lg),
              OpenVtsButton(
                label: 'Save',
                isLoading: _saving,
                onPressed: _save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
