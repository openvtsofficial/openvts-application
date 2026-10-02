import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/core_providers.dart';
import '../../../core/theme/open_vts_spacing.dart';
import '../../../core/theme/open_vts_typography.dart';
import '../../../shared/widgets/open_vts_button.dart';
import '../../../shared/widgets/open_vts_card.dart';

class MobilePushDiagnosticsCard extends ConsumerWidget {
  const MobilePushDiagnosticsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pushState = ref.watch(mobilePushControllerProvider);

    if (!pushState.isSupported) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);

    return OpenVtsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mobile Push Diagnostics',
            style: OpenVtsTypography.label.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: OpenVtsSpacing.sm),
          const Text(
            'Notifications are optional. Enable them to receive vehicle alerts. '
            'Your push token is shared with this server and Firebase for delivery.',
          ),
          const SizedBox(height: OpenVtsSpacing.md),
          _DiagnosticRow(
            label: 'Platform',
            value: pushState.platform.apiValue.toUpperCase(),
          ),
          _DiagnosticRow(
            label: 'Permission',
            value: _formatPermissionStatus(pushState.permissionStatus),
            valueColor:
                _getPermissionColor(pushState.isPermissionGranted, theme),
          ),
          _DiagnosticRow(
            label: 'Firebase',
            value: pushState.isInitialized ? 'Initialized' : 'Not Initialized',
            valueColor: pushState.isInitialized
                ? theme.colorScheme.primary
                : theme.colorScheme.error,
          ),
          if (pushState.configVersion != null)
            _DiagnosticRow(
              label: 'Config Version',
              value: pushState.configVersion!,
            ),
          if (pushState.fcmTokenLast10 != null)
            _DiagnosticRow(
              label: 'FCM Token',
              value: '***${pushState.fcmTokenLast10}',
            ),
          if (pushState.registeredTokenLast10 != null)
            _DiagnosticRow(
              label: 'Registered',
              value: '***${pushState.registeredTokenLast10}',
            ),
          if (pushState.registeredTokenCount != null)
            _DiagnosticRow(
              label: 'Backend Tokens',
              value: pushState.registeredTokenCount.toString(),
            ),
          if (pushState.currentTokenVerifiedByBackend != null)
            _DiagnosticRow(
              label: 'Verified',
              value: pushState.currentTokenVerifiedByBackend! ? 'Yes' : 'No',
              valueColor: pushState.currentTokenVerifiedByBackend!
                  ? theme.colorScheme.primary
                  : theme.colorScheme.error,
            ),
          if (pushState.lastError != null)
            Padding(
              padding: const EdgeInsets.only(top: OpenVtsSpacing.md),
              child: Text(
                'Error: ${pushState.lastError}',
                style: OpenVtsTypography.meta.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ),
          const SizedBox(height: OpenVtsSpacing.md),
          Row(
            children: [
              Expanded(
                child: OpenVtsButton(
                  label: 'Enable/Refresh',
                  isLoading: pushState.isInitializing,
                  onPressed: !pushState.isInitializing && !pushState.isTesting
                      ? () async {
                          await ref
                              .read(mobilePushControllerProvider.notifier)
                              .requestPermissionAndRegisterForCurrentSession();
                        }
                      : null,
                ),
              ),
              const SizedBox(width: OpenVtsSpacing.sm),
              Expanded(
                child: OpenVtsButton(
                  label: 'Test Push',
                  isLoading: pushState.isTesting,
                  variant: OpenVtsButtonVariant.secondary,
                  onPressed: !pushState.isInitializing && !pushState.isTesting
                      ? () async {
                          final controller =
                              ref.read(mobilePushControllerProvider.notifier);
                          await controller.sendTestNotification();
                        }
                      : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DiagnosticRow extends StatelessWidget {
  const _DiagnosticRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: OpenVtsSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: OpenVtsTypography.meta,
          ),
          Text(
            value,
            style: OpenVtsTypography.meta.copyWith(
              color: valueColor ?? theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.end,
          ),
        ],
      ),
    );
  }
}

String _formatPermissionStatus(String? status) {
  if (status == null) return 'Unknown';
  final normalized = status.trim().toLowerCase();
  switch (normalized) {
    case 'authorized':
      return 'Granted';
    case 'provisional':
      return 'Provisional';
    case 'denied':
      return 'Denied';
    case 'notdetermined':
      return 'Not Determined';
    default:
      return normalized;
  }
}

Color _getPermissionColor(bool isGranted, ThemeData theme) {
  return isGranted ? theme.colorScheme.primary : theme.colorScheme.error;
}
