import 'package:flutter/material.dart';

import '../../../../../core/theme/open_vts_spacing.dart';
import '../../../../../core/theme/open_vts_typography.dart';
import '../../../../../shared/helpers/mobile_text.dart';
import '../../../../../shared/widgets/open_vts_button.dart';
import '../../../../../shared/widgets/open_vts_loader.dart';

class ReportInitialView extends StatelessWidget {
  const ReportInitialView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(OpenVtsSpacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.analytics_outlined,
            size: 40,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: OpenVtsSpacing.sm),
          Text(
            context.mobileText('Configure your report'),
            style: OpenVtsTypography.titleSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: OpenVtsSpacing.xs),
          Text(
            context.mobileText(
              'Select vehicles, date range, and filters, then generate to view results.',
            ),
            style: OpenVtsTypography.body.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class ReportLoadingView extends StatelessWidget {
  const ReportLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(OpenVtsSpacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const OpenVtsLoader(),
          const SizedBox(height: OpenVtsSpacing.sm),
          Text(
            context.mobileText('Generating…'),
            style: OpenVtsTypography.body,
          ),
        ],
      ),
    );
  }
}

class ReportEmptyView extends StatelessWidget {
  const ReportEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(OpenVtsSpacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 40,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: OpenVtsSpacing.sm),
          Text(
            context.mobileText('No results found'),
            style: OpenVtsTypography.titleSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: OpenVtsSpacing.xs),
          Text(
            context.mobileText('Try adjusting your filters or date range.'),
            style: OpenVtsTypography.body.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class ReportErrorView extends StatelessWidget {
  const ReportErrorView({required this.message, this.onRetry, super.key});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(OpenVtsSpacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 40,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: OpenVtsSpacing.sm),
          Text(
            context.mobileText('Generation failed'),
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
              label: context.mobileText('Retry'),
              onPressed: onRetry,
              variant: OpenVtsButtonVariant.secondary,
            ),
          ],
        ],
      ),
    );
  }
}
