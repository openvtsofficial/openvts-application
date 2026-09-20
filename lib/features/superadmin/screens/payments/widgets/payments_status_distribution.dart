import 'package:flutter/material.dart';

import '../../../../../core/theme/open_vts_radius.dart';
import '../../../../../core/theme/open_vts_spacing.dart';
import '../../../../../core/theme/open_vts_typography.dart';
import '../../../../../shared/widgets/open_vts_card.dart';
import '../../../../../shared/widgets/open_vts_empty_state.dart';

class PaymentsStatusDistribution extends StatelessWidget {
  const PaymentsStatusDistribution({
    required this.success,
    required this.pending,
    required this.failed,
    super.key,
  });

  final int success;
  final int pending;
  final int failed;

  @override
  Widget build(BuildContext context) {
    final total = success + pending + failed;

    return OpenVtsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Status Distribution',
            style: OpenVtsTypography.titleSmall.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: OpenVtsSpacing.xxs),
          Text(
            'Success, pending, and failed share',
            style: OpenVtsTypography.meta.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: OpenVtsSpacing.sm),
          if (total <= 0)
            const OpenVtsEmptyState(
              title: 'No status data',
              message: 'Status distribution is not available for this range.',
            )
          else ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(OpenVtsRadius.pill),
              child: SizedBox(
                height: 12,
                child: Builder(
                  builder: (context) {
                    final scheme = Theme.of(context).colorScheme;
                    return Row(
                      children: [
                        if (success > 0)
                          Expanded(
                            flex: success,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: scheme.secondary,
                              ),
                            ),
                          ),
                        if (pending > 0)
                          Expanded(
                            flex: pending,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: scheme.tertiary,
                              ),
                            ),
                          ),
                        if (failed > 0)
                          Expanded(
                            flex: failed,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: scheme.error,
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: OpenVtsSpacing.sm),
            Builder(
              builder: (context) {
                final scheme = Theme.of(context).colorScheme;
                return Wrap(
                  spacing: OpenVtsSpacing.sm,
                  runSpacing: OpenVtsSpacing.xs,
                  children: [
                    _LegendItem(
                      label: 'Success',
                      value: success,
                      total: total,
                      color: scheme.secondary,
                    ),
                    _LegendItem(
                      label: 'Pending',
                      value: pending,
                      total: total,
                      color: scheme.tertiary,
                    ),
                    _LegendItem(
                      label: 'Failed',
                      value: failed,
                      total: total,
                      color: scheme.error,
                    ),
                  ],
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.label,
    required this.value,
    required this.total,
    required this.color,
  });

  final String label;
  final int value;
  final int total;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final percent = total <= 0 ? 0 : (value * 100 / total);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(OpenVtsRadius.pill),
            border:
                Border.all(color: Theme.of(context).colorScheme.outlineVariant),
          ),
        ),
        const SizedBox(width: OpenVtsSpacing.xxs),
        Text(
          '$label ${percent.toStringAsFixed(1)}%',
          style: OpenVtsTypography.meta.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
