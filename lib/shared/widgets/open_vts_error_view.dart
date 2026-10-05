import 'package:flutter/material.dart';

import '../../core/theme/open_vts_spacing.dart';
import '../../core/theme/open_vts_typography.dart';
import '../helpers/widget_localizations.dart';
import 'open_vts_button.dart';

class OpenVtsErrorView extends StatelessWidget {
  const OpenVtsErrorView({required this.message, this.onRetry, super.key});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(OpenVtsSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.widgetL10n.unableToLoad,
                style: OpenVtsTypography.titleSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: OpenVtsSpacing.xs),
              Text(
                message,
                style: OpenVtsTypography.body,
                textAlign: TextAlign.center,
              ),
              if (onRetry != null) ...[
                const SizedBox(height: OpenVtsSpacing.md),
                OpenVtsButton(
                  label: context.widgetL10n.retry,
                  onPressed: onRetry,
                  variant: OpenVtsButtonVariant.secondary,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
