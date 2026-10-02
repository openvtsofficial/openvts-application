import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/router/route_paths.dart';
import '../../../../../core/theme/open_vts_colors.dart';
import '../../../../../core/theme/open_vts_spacing.dart';
import '../../../../../core/theme/open_vts_typography.dart';
import '../../../../../core/utils/date_time_formatter.dart';
import '../../../models/admin_dashboard_model.dart';
import 'admin_dashboard_list_card.dart';

class AdminRecentPaymentsCard extends ConsumerWidget {
  const AdminRecentPaymentsCard({
    required this.payments,
    required this.fallbackCurrency,
    super.key,
  });

  final List<AdminRecentPayment> payments;
  final String fallbackCurrency;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formatter = ref.watch(appDateFormatterProvider);

    return AdminDashboardListCard(
      title: 'Recent Payments',
      icon: Icons.credit_card_rounded,
      viewAllRoute: RoutePaths.adminPayments,
      emptyTitle: 'No recent payments',
      emptyMessage: 'Payment activity will appear here.',
      itemCount: payments.length,
      itemBuilder: (context, index) {
        return _RecentPaymentRow(
          payment: payments[index],
          fallbackCurrency: fallbackCurrency,
          formatter: formatter,
        );
      },
    );
  }
}

class _RecentPaymentRow extends StatelessWidget {
  const _RecentPaymentRow({
    required this.payment,
    required this.fallbackCurrency,
    required this.formatter,
  });

  final AdminRecentPayment payment;
  final String fallbackCurrency;
  final AppDateFormatter formatter;

  @override
  Widget build(BuildContext context) {
    final status = _paymentStatus(payment.status);
    final currency =
        payment.currency.isNotEmpty ? payment.currency : fallbackCurrency;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: OpenVtsSpacing.md,
        vertical: OpenVtsSpacing.sm,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  payment.userName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: OpenVtsTypography.label.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  adminDashboardRelativeDate(payment.createdAt,
                      formatter: formatter),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: OpenVtsTypography.meta.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 10.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: OpenVtsSpacing.xs),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 128),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  adminDashboardFormatCurrency(payment.amountValue, currency),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  style: OpenVtsTypography.meta.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                AdminDashboardStatusChip(
                  label: status.label,
                  icon: status.icon,
                  color: status.color,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

_PaymentStatus _paymentStatus(String rawStatus) {
  switch (rawStatus.trim().toUpperCase()) {
    case 'SUCCESS':
      return const _PaymentStatus(
        label: 'SUCCESS',
        icon: Icons.check_circle_outline_rounded,
        color: OpenVtsColors.success,
      );
    case 'FAILED':
      return const _PaymentStatus(
        label: 'FAILED',
        icon: Icons.error_outline_rounded,
        color: OpenVtsColors.error,
      );
    case 'PENDING':
    default:
      return const _PaymentStatus(
        label: 'PENDING',
        icon: Icons.schedule_rounded,
        color: OpenVtsColors.warning,
      );
  }
}

class _PaymentStatus {
  const _PaymentStatus({
    required this.label,
    required this.icon,
    required this.color,
  });

  final String label;
  final IconData icon;
  final Color color;
}
