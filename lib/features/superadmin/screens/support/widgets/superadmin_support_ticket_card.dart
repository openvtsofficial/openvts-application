import 'package:flutter/material.dart';
import 'package:open_vts/core/theme/open_vts_colors.dart';
import 'package:open_vts/core/utils/date_time_formatter.dart';
import 'package:open_vts/features/superadmin/models/superadmin_support_model.dart';

import 'package:open_vts/shared/widgets/support/open_vts_support_ticket_card.dart';

const DateTimeFormatter _dateFormatter = DateTimeFormatter();

class SuperadminSupportTicketCard extends StatelessWidget {
  const SuperadminSupportTicketCard({
    required this.ticket,
    this.onTap,
    this.isSelected = false,
    super.key,
  });

  final SuperadminSupportTicketListItem ticket;
  final VoidCallback? onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final activityDate =
        ticket.lastMessageAt ?? ticket.updatedAt ?? ticket.createdAt;
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final statusColor = switch (ticket.status) {
      SuperadminSupportTicketStatus.open =>
        isDark ? const Color(0xFF5DB588) : OpenVtsColors.success,
      SuperadminSupportTicketStatus.inProgress =>
        isDark ? const Color(0xFFD4A852) : OpenVtsColors.warning,
      SuperadminSupportTicketStatus.closed => cs.onSurfaceVariant,
    };

    final priorityColor = switch (ticket.priority) {
      SuperadminSupportTicketPriority.high => OpenVtsColors.warning,
      SuperadminSupportTicketPriority.medium => OpenVtsColors.info,
      SuperadminSupportTicketPriority.low => OpenVtsColors.textTertiary,
    };

    return OpenVtsSupportTicketCard(
      title: ticket.title,
      ticketNumber: ticket.displayTicketNo,
      statusLabel: ticket.status.label,
      statusColor: statusColor,
      priorityLabel: ticket.priority.label,
      priorityColor: priorityColor,
      categoryLabel: ticket.category.label,
      extraMetaLabels: <String>['From: ${ticket.displayFromName}'],
      dateLabel: activityDate == null
          ? 'No activity yet'
          : _dateFormatter.formatDateTime(activityDate),
      messageCountLabel: null,
      preview: null,
      isSelected: isSelected,
      onTap: onTap,
    );
  }
}
