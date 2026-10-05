import 'package:flutter/material.dart';
import 'package:open_vts/core/theme/open_vts_spacing.dart';
import 'package:open_vts/features/user/screens/support/widgets/user_support_ticket_form.dart';
import 'package:open_vts/shared/widgets/open_vts_page_scaffold.dart';

import '../../../../shared/helpers/mobile_text.dart';

class UserCreateSupportTicketScreen extends StatelessWidget {
  const UserCreateSupportTicketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return OpenVtsPageScaffold(
      title: context.mobileText('Create Ticket'),
      headerMode: OpenVtsPageHeaderMode.closeable,
      padding: EdgeInsets.zero,
      body: const UserSupportTicketForm(
        contentPadding: EdgeInsets.all(OpenVtsSpacing.sm),
      ),
    );
  }
}
