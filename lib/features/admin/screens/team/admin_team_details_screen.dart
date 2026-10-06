import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/api_exception.dart';
import '../../../../core/utils/date_time_formatter.dart';
import '../../../../shared/helpers/mobile_text.dart';
import '../../../../shared/models/user_role.dart';
import '../../../../shared/widgets/open_vts_bottom_sheet.dart';
import '../../../../shared/widgets/open_vts_button.dart';
import '../../../../shared/widgets/open_vts_card.dart';
import '../../../../shared/widgets/open_vts_detail_tab_strip.dart';
import '../../../../shared/widgets/open_vts_error_view.dart';
import '../../../../shared/widgets/open_vts_loader.dart';
import '../../../../shared/widgets/open_vts_page_scaffold.dart';
import '../../../auth/controllers/auth_controller.dart';
import '../../controllers/admin_providers.dart';
import '../../controllers/admin_team_details_controller.dart';
import 'widgets/admin_create_team_sheet.dart';
import 'widgets/admin_team_activity_sheet.dart';
import 'widgets/admin_team_permissions_sheet.dart';

enum AdminTeamDetailsTab { profile, permissions, activity }

class AdminTeamDetailsScreen extends ConsumerStatefulWidget {
  const AdminTeamDetailsScreen({
    required this.memberId,
    this.initialTab = AdminTeamDetailsTab.profile,
    super.key,
  });
  final String memberId;
  final AdminTeamDetailsTab initialTab;
  @override
  ConsumerState<AdminTeamDetailsScreen> createState() =>
      _AdminTeamDetailsScreenState();
}

class _AdminTeamDetailsScreenState
    extends ConsumerState<AdminTeamDetailsScreen> {
  late AdminTeamDetailsTab _selected = widget.initialTab;
  late final _visited = <AdminTeamDetailsTab>{widget.initialTab};

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authControllerProvider);
    final authorized = auth.isRealSession && auth.user?.role == UserRole.admin;
    return OpenVtsPageScaffold(
      title: context.mobileText('Team'),
      padding: const EdgeInsets.all(12),
      leading: IconButton(
        tooltip: context.mobileText('Back'),
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(Icons.arrow_back_rounded),
      ),
      actions: [
        if (authorized)
          IconButton(
            tooltip: context.mobileText('Refresh'),
            onPressed: _refresh,
            icon: const Icon(Icons.refresh_rounded),
          ),
      ],
      body: !authorized
          ? OpenVtsErrorView(
              message: context.mobileText('Unable to update permissions'),
            )
          : Column(
              children: [
                OpenVtsDetailTabStrip<AdminTeamDetailsTab>(
                  selected: _selected,
                  onChanged: (tab) => setState(() {
                    _selected = tab;
                    _visited.add(tab);
                  }),
                  tabs: [
                    OpenVtsDetailTabOption(
                      value: AdminTeamDetailsTab.profile,
                      label: context.mobileText('Profile'),
                      icon: Icons.person_outline_rounded,
                    ),
                    OpenVtsDetailTabOption(
                      value: AdminTeamDetailsTab.permissions,
                      label: context.mobileText('Permissions'),
                      icon: Icons.shield_outlined,
                    ),
                    OpenVtsDetailTabOption(
                      value: AdminTeamDetailsTab.activity,
                      label: context.mobileText('Activity Logs'),
                      icon: Icons.history_rounded,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: IndexedStack(
                    index: _selected.index,
                    children: [
                      _visited.contains(AdminTeamDetailsTab.profile)
                          ? _ProfileTab(memberId: widget.memberId)
                          : const SizedBox.shrink(),
                      _visited.contains(AdminTeamDetailsTab.permissions)
                          ? AdminTeamPermissionsSheet(memberId: widget.memberId)
                          : const SizedBox.shrink(),
                      _visited.contains(AdminTeamDetailsTab.activity)
                          ? AdminTeamActivitySheet(memberId: widget.memberId)
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Future<void> _refresh() => switch (_selected) {
    AdminTeamDetailsTab.profile =>
      ref
          .read(adminTeamProfileControllerProvider(widget.memberId).notifier)
          .load(),
    AdminTeamDetailsTab.permissions =>
      ref
          .read(
            adminTeamPermissionsControllerProvider(widget.memberId).notifier,
          )
          .load(),
    AdminTeamDetailsTab.activity =>
      ref
          .read(adminTeamActivityControllerProvider(widget.memberId).notifier)
          .load(),
  };
}

class _ProfileTab extends ConsumerWidget {
  const _ProfileTab({required this.memberId});
  final String memberId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = adminTeamProfileControllerProvider(memberId);
    final state = ref.watch(provider);
    final controller = ref.read(provider.notifier);
    if (state.isLoading) return const OpenVtsLoader();
    if (state.hasError) {
      return OpenVtsErrorView(
        message: state.error is ApiException
            ? (state.error as ApiException).message
            : context.mobileText('Team could not be loaded.'),
        onRetry: controller.load,
      );
    }
    final member = state.requireValue;
    final dates = ref.watch(appDateFormatterProvider);
    return RefreshIndicator(
      onRefresh: controller.load,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          OpenVtsCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  member.teamName,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                _Field(
                  label: context.mobileText('Username'),
                  value: member.username,
                ),
                _Field(label: context.mobileText('Email'), value: member.email),
                _Field(label: context.mobileText('Phone'), value: member.phone),
                _Field(
                  label: context.mobileText('Status'),
                  value: member.isActive
                      ? context.mobileText('Active')
                      : context.mobileText('Inactive'),
                ),
                _Field(
                  label: context.mobileText('Created'),
                  value: dates.formatDateTime(member.createdAt),
                ),
                const SizedBox(height: 16),
                OpenVtsButton(
                  label: context.mobileText('Edit'),
                  trailingIcon: Icons.edit_outlined,
                  onPressed: () async {
                    // The provider that owned this page is retained throughout the sheet;
                    // scope changes dispose it and suppress the subsequent refresh.
                    await OpenVtsBottomSheet.show<void>(
                      context: context,
                      title: context.mobileText('Edit Team Member'),
                      initialChildSize: .9,
                      minChildSize: .5,
                      maxChildSize: .96,
                      child: Consumer(
                        builder: (context, ref, _) => AdminCreateTeamSheet.edit(
                          member: member,
                          isSubmitting: ref
                              .watch(adminTeamControllerProvider)
                              .isUpdating,
                        ),
                      ),
                    );
                    if (context.mounted) await controller.load();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({required this.label, required this.value});
  final String label, value;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 2),
        SelectableText(value.isEmpty ? '—' : value),
      ],
    ),
  );
}
