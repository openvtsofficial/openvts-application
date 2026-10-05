import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/open_vts_spacing.dart';
import '../../../core/theme/open_vts_typography.dart';
import '../../../shared/helpers/mobile_text.dart';
import '../../../shared/widgets/open_vts_loader.dart';
import '../controllers/auth_controller.dart';
import '../controllers/auth_state.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted &&
          ref.read(authControllerProvider).status == AuthStatus.initial) {
        ref.read(authControllerProvider.notifier).restoreSession();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: SplashLoadingView());
  }
}

class SplashLoadingView extends StatelessWidget {
  const SplashLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            isDark ? 'assets/brand/dark-icon.png' : 'assets/brand/icon.png',
            height: 56,
            errorBuilder: (_, __, ___) {
              return const Icon(Icons.navigation_outlined, size: 56);
            },
          ),
          const SizedBox(height: OpenVtsSpacing.md),
          Text(
            context.mobileText('OpenVTS'),
            style: OpenVtsTypography.titleMedium,
          ),
          const SizedBox(height: OpenVtsSpacing.lg),
          const OpenVtsLoader(),
        ],
      ),
    );
  }
}
