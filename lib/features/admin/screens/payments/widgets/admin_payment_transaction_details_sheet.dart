import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../../../core/theme/open_vts_spacing.dart';
import '../../../../../core/utils/date_time_formatter.dart';
import '../../../../../shared/helpers/mobile_text.dart';
import '../../../../../shared/widgets/open_vts_card.dart';
import '../../../models/admin_payments_model.dart';

class AdminPaymentTransactionDetailsSheet extends StatelessWidget {
  const AdminPaymentTransactionDetailsSheet({required this.item, super.key});

  final AdminPaymentTransaction item;

  @override
  Widget build(BuildContext context) {
    final formatter = const DateTimeFormatter();
    final date = item.createdAt == null
        ? item.createdAtRaw
        : formatter.formatDateTime(item.createdAt!.toLocal());

    return ListView(
      controller: PrimaryScrollController.maybeOf(context),
      padding: const EdgeInsets.all(OpenVtsSpacing.md),
      children: [
        OpenVtsCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.mobileText("Transaction ID: {value1}", {
                  'value1': (item.id.isEmpty ? '-' : item.id).toString(),
                }),
              ),
              Text(
                context.mobileText("Amount: {value1}", {
                  'value1': (item.amountDisplay).toString(),
                }),
              ),
              Text(
                context.mobileText("Status: {value1}", {
                  'value1': (item.status.label).toString(),
                }),
              ),
              Text(
                context.mobileText("Created: {value1}", {
                  'value1': (date.trim().isEmpty ? '-' : date).toString(),
                }),
              ),
              Text(
                context.mobileText("Payment Type: {value1}", {
                  'value1': (item.paymentType.isEmpty ? '-' : item.paymentType)
                      .toString(),
                }),
              ),
              Text(
                context.mobileText("Payment Mode: {value1}", {
                  'value1': (item.paymentMode.label).toString(),
                }),
              ),
              Text(
                context.mobileText("Reference: {value1}", {
                  'value1': (item.reference.isEmpty ? '-' : item.reference)
                      .toString(),
                }),
              ),
              Text(
                context.mobileText("Provider: {value1}", {
                  'value1': (item.provider.isEmpty ? '-' : item.provider)
                      .toString(),
                }),
              ),
              Text(
                context.mobileText("Provider Ref: {value1}", {
                  'value1': (item.providerRef.isEmpty ? '-' : item.providerRef)
                      .toString(),
                }),
              ),
              Text(
                context.mobileText("From: {value1}", {
                  'value1': (item.fromUser?.displayName ?? '-').toString(),
                }),
              ),
              Text(
                context.mobileText("To: {value1}", {
                  'value1': (item.toUser?.displayName ?? '-').toString(),
                }),
              ),
              Text(
                context.mobileText("Recorded By: {value1}", {
                  'value1': (item.recordedBy?.displayName ?? '-').toString(),
                }),
              ),
              Text(
                context.mobileText("Vehicle: {value1}", {
                  'value1':
                      (item.vehicleDisplayName.isEmpty
                              ? '-'
                              : item.vehicleDisplayName)
                          .toString(),
                }),
              ),
              if (item.vehicleImei.isNotEmpty)
                Text(
                  context.mobileText("IMEI: {value1}", {
                    'value1': (item.vehicleImei).toString(),
                  }),
                ),
              if (item.planDisplayName.isNotEmpty)
                Text(
                  context.mobileText("Plan: {value1}", {
                    'value1': (item.planDisplayName).toString(),
                  }),
                ),
              Text(
                context.mobileText("Failure Code: {value1}", {
                  'value1': (item.failureCode.isEmpty ? '-' : item.failureCode)
                      .toString(),
                }),
              ),
              Text(
                context.mobileText("Failure Message: {value1}", {
                  'value1':
                      (item.failureMessage.isEmpty ? '-' : item.failureMessage)
                          .toString(),
                }),
              ),
            ],
          ),
        ),
        if (item.meta.isNotEmpty) ...[
          const SizedBox(height: OpenVtsSpacing.sm),
          OpenVtsCard(
            child: SelectableText(
              const JsonEncoder.withIndent('  ').convert(item.meta),
            ),
          ),
        ],
      ],
    );
  }
}
