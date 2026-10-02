import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/open_vts_colors.dart';
import '../../../../../core/theme/open_vts_spacing.dart';
import '../../../../../core/theme/open_vts_typography.dart';
import '../../../../../core/utils/date_time_formatter.dart';
import '../../../../../shared/widgets/open_vts_card.dart';
import '../../../../../shared/widgets/open_vts_status_chip.dart';
import '../../../models/user_transactions_model.dart';

class UserTransactionCard extends ConsumerWidget {
  const UserTransactionCard({
    required this.transaction,
    required this.counterpartyName,
    required this.onTap,
    super.key,
  });

  final UserTransaction transaction;
  final String counterpartyName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateTimeFormatter = ref.watch(appDateFormatterProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? Colors.white : OpenVtsColors.textPrimary;
    final secondaryColor =
        isDark ? OpenVtsColors.darkTextSecondary : OpenVtsColors.textSecondary;
    final tertiaryColor =
        isDark ? OpenVtsColors.darkTextTertiary : OpenVtsColors.textTertiary;

    final detailsList =
        _buildDetailsList(context, transaction, dateTimeFormatter);

    return OpenVtsCard(
      onTap: onTap,
      padding: const EdgeInsets.all(OpenVtsSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      counterpartyName.trim().isEmpty ? '-' : counterpartyName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: OpenVtsTypography.label.copyWith(
                        fontWeight: FontWeight.w700,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${_paymentTypeLabel(transaction.paymentType)} | '
                      '${transaction.paymentMode.label}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: OpenVtsTypography.meta.copyWith(
                        color: secondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: OpenVtsSpacing.xs),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  OpenVtsStatusChip(
                    label: transaction.status.label,
                    type: _statusType(transaction.status),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _amountLabel(transaction),
                    style: OpenVtsTypography.numeric.copyWith(
                      fontSize: 18,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (detailsList.isNotEmpty) ...[
            const SizedBox(height: OpenVtsSpacing.sm),
            ...List.generate(detailsList.length, (index) {
              final detail = detailsList[index];
              return Column(
                children: [
                  _detailRow(
                    label: detail['label'],
                    value: detail['value'],
                    color: detail['color'],
                  ),
                  if (index < detailsList.length - 1) const SizedBox(height: 6),
                ],
              );
            }),
          ],
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(
                Icons.schedule_outlined,
                size: 14,
                color: tertiaryColor,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  _dateLabel(transaction, dateTimeFormatter),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: OpenVtsTypography.meta.copyWith(
                    color: tertiaryColor,
                  ),
                ),
              ),
              const SizedBox(width: OpenVtsSpacing.xs),
              Icon(
                Icons.chevron_right_rounded,
                size: 16,
                color: tertiaryColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  OpenVtsStatusType _statusType(UserTransactionStatus status) {
    switch (status) {
      case UserTransactionStatus.success:
        return OpenVtsStatusType.success;
      case UserTransactionStatus.pending:
        return OpenVtsStatusType.warning;
      case UserTransactionStatus.failed:
        return OpenVtsStatusType.error;
    }
  }

  String _amountLabel(UserTransaction item) {
    final amount = item.amount.trim().isEmpty ? '0' : item.amount.trim();
    final currency = item.currency.trim();
    if (currency.isEmpty) {
      return amount;
    }

    return '$currency $amount';
  }

  String _paymentTypeLabel(String rawValue) {
    final normalized = rawValue.trim().toUpperCase();
    if (normalized == 'CREDIT') {
      return 'Credit';
    }
    if (normalized == 'DEBIT') {
      return 'Debit';
    }
    if (normalized.isEmpty) {
      return 'Type N/A';
    }

    return _titleCaseWords(rawValue);
  }

  String _dateLabel(UserTransaction item, dynamic formatter) {
    if (item.createdAt != null) {
      return formatter.formatDateTime(item.createdAt!.toLocal());
    }

    final fallback = item.createdAtRaw.trim();
    return fallback.isEmpty ? '-' : fallback;
  }

  String _titleCaseWords(String value) {
    final normalized = value.trim();
    if (normalized.isEmpty) {
      return normalized;
    }

    return normalized
        .split(RegExp(r'[\s_-]+'))
        .where((part) => part.isNotEmpty)
        .map((part) {
      final lower = part.toLowerCase();
      if (lower.length == 1) {
        return lower.toUpperCase();
      }
      return '${lower[0].toUpperCase()}${lower.substring(1)}';
    }).join(' ');
  }

  List<Map<String, dynamic>> _buildDetailsList(
    BuildContext context,
    UserTransaction item,
    dynamic formatter,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final secondaryColor =
        isDark ? OpenVtsColors.darkTextSecondary : OpenVtsColors.textSecondary;

    final details = <Map<String, dynamic>>[];

    final reference = item.reference.trim();
    if (reference.isNotEmpty) {
      details.add({
        'label': 'Reference',
        'value': reference,
        'color': secondaryColor,
      });
    }

    final provider = item.provider.trim();
    final providerRef = item.providerRef.trim();
    if (provider.isNotEmpty || providerRef.isNotEmpty) {
      final providerValue =
          [provider, providerRef].where((v) => v.isNotEmpty).join(' ');
      details.add({
        'label': 'Provider',
        'value': providerValue,
        'color': secondaryColor,
      });
    }

    final vehicleName = item.vehicle?.name.trim() ?? '';
    if (vehicleName.isNotEmpty) {
      details.add({
        'label': 'Vehicle',
        'value': vehicleName,
        'color': secondaryColor,
      });
    }

    final plate = item.vehicle?.plateNumber.trim() ?? '';
    if (plate.isNotEmpty) {
      details.add({
        'label': 'Plate',
        'value': plate,
        'color': secondaryColor,
      });
    }

    final plan = item.plan ?? item.vehicle?.plan;
    final planName = plan?.name.trim() ?? '';
    if (planName.isNotEmpty) {
      details.add({
        'label': 'Plan',
        'value': planName,
        'color': secondaryColor,
      });
    }

    return details;
  }

  Widget _detailRow({
    required String label,
    required String value,
    required Color color,
  }) {
    final display = value.trim().isEmpty ? '-' : value.trim();
    return Text(
      '$label: $display',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: OpenVtsTypography.meta.copyWith(
        color: color,
      ),
    );
  }
}
