import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/controllers/auth_controller.dart';

class UserShell extends ConsumerWidget {
  const UserShell({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDemo = ref.watch(
      authControllerProvider.select((state) => state.isDemo),
    );
    if (!isDemo) {
      return child;
    }

    final scheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Material(
          color: scheme.tertiaryContainer,
          child: SafeArea(
            bottom: false,
            child: SizedBox(
              height: 44,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Icon(
                      Icons.visibility_outlined,
                      size: 18,
                      color: scheme.onTertiaryContainer,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Demo workspace • Read-only',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: scheme.onTertiaryContainer,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        ref
                            .read(authControllerProvider.notifier)
                            .logoutActiveRole();
                      },
                      icon: const Icon(Icons.logout_rounded, size: 16),
                      label: const Text('Exit Demo'),
                      style: TextButton.styleFrom(
                        foregroundColor: scheme.onTertiaryContainer,
                        minimumSize: const Size(44, 36),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: child,
          ),
        ),
      ],
    );
  }
}
