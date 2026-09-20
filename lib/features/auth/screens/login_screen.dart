import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/app_preferences_provider.dart';
import '../../../core/providers/core_providers.dart';
import '../../../core/router/route_paths.dart';
import '../../../core/theme/open_vts_colors.dart';
import '../../../core/theme/open_vts_radius.dart';
import '../../../core/theme/open_vts_spacing.dart';
import '../../../core/theme/open_vts_typography.dart';
import '../../../shared/helpers/toast_helper.dart';
import '../controllers/auth_controller.dart';
import '../controllers/auth_state.dart';
import '../widgets/login_form.dart';
import '../widgets/mfa_login_form.dart';
import '../../../core/widgets/app_legal_links.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AuthState>(authControllerProvider, (previous, next) {
      if (previous?.status != AuthStatus.authenticated &&
          next.status == AuthStatus.authenticated) {
        ToastHelper.showSuccess(
          'Login successful',
        );
      }

      if (previous?.status == AuthStatus.loading &&
          next.status == AuthStatus.unauthenticated &&
          next.errorMessage != null &&
          next.errorMessage!.trim().isNotEmpty) {
        ToastHelper.showError(
          next.errorMessage!.replaceFirst(
            RegExp(r'^ApiException\(\d+\):\s*'),
            '',
          ),
        );
      }
    });

    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.status == AuthStatus.loading;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          color:
              isDark ? OpenVtsColors.darkBackground : OpenVtsColors.background,
        ),
        child: Stack(
          children: [
            if (!isDark)
              Positioned.fill(
                child: Image.asset(
                  'assets/images/background-full.png',
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                  opacity: const AlwaysStoppedAnimation<double>(0.75),
                ),
              ),
            if (!isDark)
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: OpenVtsColors.white.withValues(alpha: 0.75),
                  ),
                ),
              ),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    OpenVtsSpacing.lg,
                    OpenVtsSpacing.xxl,
                    OpenVtsSpacing.lg,
                    OpenVtsSpacing.xxl,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 380),
                    child: _LoginPanel(
                      isLoading: isLoading,
                      errorMessage: authState.errorMessage,
                      onSubmit: (identifier, password) {
                        ref.read(authControllerProvider.notifier).login(
                              identifier: identifier,
                              password: password,
                            );
                      },
                      mfaRequired: authState.mfaChallenge != null,
                      isVerifyingMfa: authState.isVerifyingMfa,
                      onVerifyMfa: (code) => ref.read(authControllerProvider.notifier).verifyMfaLogin(code),
                      onCancelMfa: () => ref.read(authControllerProvider.notifier).cancelMfaLogin(),
                    ),
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(OpenVtsSpacing.md),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _ThemeToggleButton(
                        onPressed: () async {
                          await ref.read(themeModeProvider.notifier).toggle();
                          ref.invalidate(appLocalizationPreferencesProvider);
                        },
                      ),
                      const SizedBox(width: OpenVtsSpacing.xs),
                      _LoginSettingsButton(
                        onPressed: () =>
                            context.push(RoutePaths.apiBaseUrlSettings),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeToggleButton extends StatelessWidget {
  const _ThemeToggleButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return IconButton(
      onPressed: onPressed,
      tooltip: isDark ? 'Switch to light mode' : 'Switch to dark mode',
      icon: Icon(isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
      color: isDark ? OpenVtsColors.white : OpenVtsColors.brandInk,
      style: IconButton.styleFrom(
        backgroundColor: isDark
            ? OpenVtsColors.darkSurfaceElevated
            : OpenVtsColors.white.withValues(alpha: 0.92),
        fixedSize: const Size(44, 44),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(OpenVtsRadius.md),
          side: BorderSide(
            color: isDark ? OpenVtsColors.darkBorder : OpenVtsColors.border,
          ),
        ),
      ),
    );
  }
}

class _LoginSettingsButton extends StatelessWidget {
  const _LoginSettingsButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return IconButton(
      onPressed: onPressed,
      tooltip: 'Base URL settings',
      icon: const Icon(Icons.settings_rounded),
      color: isDark ? OpenVtsColors.white : OpenVtsColors.brandInk,
      style: IconButton.styleFrom(
        backgroundColor: isDark
            ? OpenVtsColors.darkSurfaceElevated
            : OpenVtsColors.white.withValues(alpha: 0.92),
        fixedSize: const Size(44, 44),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(OpenVtsRadius.md),
          side: BorderSide(
            color: isDark ? OpenVtsColors.darkBorder : OpenVtsColors.border,
          ),
        ),
      ),
    );
  }
}

class _LoginPanel extends StatelessWidget {
  const _LoginPanel({
    required this.isLoading,
    required this.onSubmit,
    required this.mfaRequired,
    required this.isVerifyingMfa,
    required this.onVerifyMfa,
    required this.onCancelMfa,
    this.errorMessage,
  });

  final bool isLoading;
  final String? errorMessage;
  final void Function(String email, String password) onSubmit;
  final bool mfaRequired;
  final bool isVerifyingMfa;
  final ValueChanged<String> onVerifyMfa;
  final VoidCallback onCancelMfa;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(OpenVtsSpacing.xl),
      decoration: BoxDecoration(
        color: isDark
            ? OpenVtsColors.darkSurfaceElevated
            : OpenVtsColors.white.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(OpenVtsRadius.lg),
        border: Border.all(
          color: isDark ? OpenVtsColors.darkBorder : OpenVtsColors.border,
        ),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: OpenVtsColors.brandInk.withValues(alpha: 0.06),
                  blurRadius: 28,
                  offset: const Offset(0, 16),
                ),
              ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            isDark ? 'assets/brand/dark-logo.png' : 'assets/brand/logo.png',
            height: 52,
            errorBuilder: (_, __, ___) {
              return Text(
                'Open VTS',
                style: OpenVtsTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isDark ? OpenVtsColors.white : null,
                ),
              );
            },
          ),
          const SizedBox(height: OpenVtsSpacing.xl),
          if (mfaRequired)
            MfaLoginForm(isLoading: isVerifyingMfa,
              onSubmit: onVerifyMfa, onCancel: onCancelMfa)
          else
            LoginForm(isLoading: isLoading, onSubmit: onSubmit),
          const SizedBox(height: OpenVtsSpacing.md),
          const AppLegalLinks(),
          if (errorMessage != null) ...[
            const SizedBox(height: OpenVtsSpacing.md),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(OpenVtsSpacing.sm),
              decoration: BoxDecoration(
                color: OpenVtsColors.error.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(OpenVtsRadius.md),
                border: Border.all(
                  color: OpenVtsColors.error.withValues(alpha: 0.16),
                ),
              ),
              child: Text(
                errorMessage!,
                style: OpenVtsTypography.body.copyWith(
                  color: OpenVtsColors.error,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
