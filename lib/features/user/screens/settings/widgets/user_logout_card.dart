import 'package:flutter/material.dart';

import '../../../../../core/theme/open_vts_spacing.dart';
import '../../../../../shared/widgets/open_vts_button.dart';
import '../../../../../shared/widgets/open_vts_card.dart';

class UserLogoutCard extends StatelessWidget {
  const UserLogoutCard({
    required this.onLogout,
    super.key,
  });

  final Future<void> Function() onLogout;

  @override
  Widget build(BuildContext context) {
    return OpenVtsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.logout_rounded,
                  size: 16,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(width: OpenVtsSpacing.xs),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sign out',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      'End this session on this device.',
                      style: TextStyle(
                        fontSize: 11,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: OpenVtsSpacing.sm),
          OpenVtsButton(
            label: 'Logout',
            variant: OpenVtsButtonVariant.secondary,
            height: 38,
            onPressed: () => onLogout(),
          ),
        ],
      ),
    );
  }
}
