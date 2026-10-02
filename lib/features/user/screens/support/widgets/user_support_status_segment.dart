import 'package:flutter/material.dart';

import '../../../../../core/theme/open_vts_spacing.dart';
import '../../../../../shared/widgets/support/open_vts_support_filter_chip.dart';
import '../../../models/user_support_model.dart';

class UserSupportStatusSegment extends StatelessWidget {
  const UserSupportStatusSegment({
    required this.selected,
    required this.onChanged,
    this.counts,
    super.key,
  });

  final UserSupportTicketStatus? selected;
  final ValueChanged<UserSupportTicketStatus?> onChanged;
  final Map<UserSupportTicketStatus?, int>? counts;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          OpenVtsSupportFilterChip(
            label: 'All',
            count: counts?[null] ?? 0,
            selected: selected == null,
            onSelected: () => onChanged(null),
          ),
          const SizedBox(width: OpenVtsSpacing.xs),
          for (final status in UserSupportTicketStatus.values) ...[
            OpenVtsSupportFilterChip(
              label: status.label,
              count: counts?[status] ?? 0,
              selected: selected == status,
              onSelected: () => onChanged(status),
            ),
            const SizedBox(width: OpenVtsSpacing.xs),
          ],
        ],
      ),
    );
  }
}
