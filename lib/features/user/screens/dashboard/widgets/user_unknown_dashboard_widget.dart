import 'package:flutter/material.dart';

import '../../../../../core/theme/open_vts_spacing.dart';
import '../../../../../core/theme/open_vts_typography.dart';
import '../../../../../shared/helpers/mobile_text.dart';
import '../../../models/user_dashboard_model.dart';
import 'user_dashboard_widget_card.dart';

class UserUnknownDashboardWidget extends StatelessWidget {
  const UserUnknownDashboardWidget({required this.config, super.key});

  final UserDashboardWidgetConfig config;

  @override
  Widget build(BuildContext context) {
    return UserDashboardWidgetCard(
      title: context.mobileText('Unsupported widget'),
      icon: Icons.extension_off_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.mobileText('Unsupported widget'),
            style: OpenVtsTypography.label.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: OpenVtsSpacing.xs),
          Text(
            context.mobileText("type: {value1}", {
              'value1': (config.type).toString(),
            }),
            style: OpenVtsTypography.meta.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
