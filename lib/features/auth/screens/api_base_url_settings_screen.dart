import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../../core/providers/core_providers.dart';
import '../../../core/theme/open_vts_colors.dart';
import '../../../core/theme/open_vts_spacing.dart';
import '../../../core/theme/open_vts_typography.dart';
import '../../../shared/helpers/mobile_text.dart';
import '../../../shared/helpers/toast_helper.dart';
import '../../../shared/widgets/open_vts_button.dart';
import '../../../shared/widgets/open_vts_card.dart';
import '../../../shared/widgets/open_vts_page_scaffold.dart';
import '../../../shared/widgets/open_vts_text_field.dart';
import '../controllers/auth_controller.dart';

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
    await _changeServer(_urlController.text, reset: false);
  }

  Future<void> _reset() async {
    if (_saving) return;
    await _changeServer(AppConfig.defaultApiBaseUrl, reset: true);
  }

  Future<void> _changeServer(String value, {required bool reset}) async {
    setState(() => _saving = true);
    try {
      final controller = ref.read(apiBaseUrlProvider.notifier);
      final next = reset
          ? controller.defaultUrl
          : ApiBaseUrlController.normalizeUrl(value);
      if (next != ref.read(apiBaseUrlProvider)) {
        // Credentials are scoped to the server that issued them. Cancel pending
        // authentication and clear every local role before changing the origin.
        await ref
            .read(authControllerProvider.notifier)
            .logoutAllRoles(deregisterPush: false, showLoading: false);
      }
      if (!mounted) return;
      if (reset) {
        await controller.resetToDefault();
      } else {
        await controller.saveCustomUrl(value);
      }
      if (!mounted) return;
      _urlController.text = next;
      ToastHelper.show(
        context,
        reset ? 'Server URL reset to default' : 'Server URL updated',
      );
      if (!reset) Navigator.of(context).pop();
    } catch (_) {
      if (mounted) {
        ToastHelper.showError(
          context.mobileText('Unable to update the server URL.'),
          context: context,
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  String? _validateUrl(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return 'Enter a server URL';

    final uri = Uri.tryParse(trimmed);
    final hasValidScheme = uri?.scheme == 'http' || uri?.scheme == 'https';

    if (uri == null || !uri.isAbsolute || !hasValidScheme || uri.host.isEmpty) {
      return 'Enter a valid URL (e.g. http://192.168.1.10:3000/api)';
    }

    if (uri.userInfo.isNotEmpty || uri.hasQuery || uri.hasFragment) {
      return 'Enter a server URL without credentials, query parameters or a fragment.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final activeUrl = ref.watch(apiBaseUrlProvider);
    final isUsingDefault = activeUrl == AppConfig.defaultApiBaseUrl;

    return OpenVtsPageScaffold(
      title: context.mobileText('Server URL'),
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
                      label: context.mobileText('Server URL'),
                      controller: _urlController,
                      hintText: 'http://192.168.1.10:3000/api',
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      prefixIcon: Icons.dns_rounded,
                      validator: _validateUrl,
                      onFieldSubmitted: (_) => _save(),
                    ),
                    const SizedBox(height: OpenVtsSpacing.sm),
                    Text(
                      context.mobileText(
                        'Include the full path, e.g. http://192.168.1.10:3000/api',
                      ),
                      style: OpenVtsTypography.meta.copyWith(
                        color: OpenVtsColors.textSecondary,
                      ),
                    ),
                    if (kIsWeb) ...[
                      const SizedBox(height: OpenVtsSpacing.xs),
                      Text(
                        context.mobileText(
                          'Web browsers require the server to allow cross-origin requests (CORS). If login fails with a connection error, enable CORS on your server.',
                        ),
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
                          context.mobileText("Reset to default ({value1})", {
                            'value1': (AppConfig.defaultApiBaseUrl).toString(),
                          }),
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
                label: context.mobileText('Save'),
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
