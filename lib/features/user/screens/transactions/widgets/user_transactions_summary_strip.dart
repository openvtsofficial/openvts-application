import 'package:flutter/material.dart';

import '../../../../../core/theme/open_vts_colors.dart';
import '../../../../../core/theme/open_vts_radius.dart';
import '../../../../../core/theme/open_vts_spacing.dart';
import '../../../../../core/theme/open_vts_typography.dart';
import '../../../../../shared/widgets/open_vts_card.dart';
import '../../../../../shared/widgets/open_vts_status_chip.dart';
import '../../../models/user_transactions_model.dart';

class UserTransactionsSummaryStrip extends StatelessWidget {
  const UserTransactionsSummaryStrip({
    required this.transactions,
    super.key,
  });

  final List<UserTransaction> transactions;

  @override
  Widget build(BuildContext context) {
    final successCount = transactions
        .where((item) => item.status == UserTransactionStatus.success)
        .length;
    final pendingCount = transactions
        .where((item) => item.status == UserTransactionStatus.pending)
        .length;
    final failedCount = transactions
        .where((item) => item.status == UserTransactionStatus.failed)
        .length;
    final currencyTotals = _buildCurrencyTotals(transactions);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.grey[300] : OpenVtsColors.textSecondary;

    return OpenVtsCard(
      padding: const EdgeInsets.all(OpenVtsSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Summary',
            style: OpenVtsTypography.meta.copyWith(
              color: textColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: OpenVtsSpacing.xs),
          Wrap(
            spacing: OpenVtsSpacing.xs,
            runSpacing: OpenVtsSpacing.xs,
            children: [
              OpenVtsStatusChip(
                label: 'Success $successCount',
                type: OpenVtsStatusType.success,
              ),
              OpenVtsStatusChip(
                label: 'Pending $pendingCount',
                type: OpenVtsStatusType.warning,
              ),
              OpenVtsStatusChip(
                label: 'Failed $failedCount',
                type: OpenVtsStatusType.error,
              ),
              if (currencyTotals.length == 1)
                _AmountChip(
                  label: _singleCurrencyLabel(currencyTotals),
                ),
            ],
          ),
          if (currencyTotals.length > 1) ...[
            const SizedBox(height: OpenVtsSpacing.xs),
            Builder(
              builder: (context) {
                final isDark = Theme.of(context).brightness == Brightness.dark;
                final textColor =
                    isDark ? Colors.grey[300] : OpenVtsColors.textSecondary;
                return Text(
                  'Totals by currency',
                  style: OpenVtsTypography.meta.copyWith(
                    color: textColor,
                  ),
                );
              },
            ),
            const SizedBox(height: OpenVtsSpacing.xxs),
            Wrap(
              spacing: OpenVtsSpacing.xs,
              runSpacing: OpenVtsSpacing.xs,
              children: [
                for (final entry in currencyTotals.entries)
                  _AmountChip(
                    label:
                        '${_currencyLabel(entry.key)} ${_formatAmount(entry.value)}',
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Map<String, double> _buildCurrencyTotals(List<UserTransaction> rows) {
    final grouped = <String, double>{};

    for (final item in rows) {
      final amount = item.amountAsDouble;
      if (amount == null) {
        continue;
      }

      final currency = item.currency.trim().toUpperCase();
      final key = currency.isEmpty ? 'UNSPECIFIED' : currency;
      grouped[key] = (grouped[key] ?? 0) + amount;
    }

    final keys = grouped.keys.toList()..sort();
    return <String, double>{
      for (final key in keys) key: grouped[key]!,
    };
  }

  String _singleCurrencyLabel(Map<String, double> totals) {
    final entry = totals.entries.first;
    return '${_currencyLabel(entry.key)} ${_formatAmount(entry.value)}';
  }

  String _currencyLabel(String value) {
    return value == 'UNSPECIFIED' ? 'Total' : value;
  }

  String _formatAmount(double value) {
    final fixed = value.toStringAsFixed(2);
    if (fixed.endsWith('.00')) {
      return fixed.substring(0, fixed.length - 3);
    }

    if (fixed.endsWith('0')) {
      return fixed.substring(0, fixed.length - 1);
    }

    return fixed;
  }
}

class _AmountChip extends StatelessWidget {
  const _AmountChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDark ? Colors.black : OpenVtsColors.surfaceElevated;
    final borderColor = isDark ? Colors.white : OpenVtsColors.border;
    final textColor = isDark ? Colors.white : OpenVtsColors.textPrimary;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: OpenVtsSpacing.xs,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(OpenVtsRadius.sm),
        border: Border.all(
          color: borderColor,
          width: isDark ? 1 : 1,
        ),
      ),
      child: Text(
        label,
        style: OpenVtsTypography.meta.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
