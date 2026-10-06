import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/helpers/mobile_text.dart';
import '../../../../../shared/helpers/toast_helper.dart';
import '../../../../../shared/widgets/open_vts_button.dart';
import '../../../../../shared/widgets/open_vts_card.dart';
import '../../../../../shared/widgets/open_vts_error_view.dart';
import '../../../controllers/admin_user_permissions_controller.dart';
import '../../../models/admin_user_permissions.dart';

import 'admin_user_access_error_label.dart';

/// The same editor is accessible as a detail tab and as a legacy sheet.
class AdminUserPermissionsSheet extends StatelessWidget {
  const AdminUserPermissionsSheet({required this.userId, super.key});
  final String userId;
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    controller: PrimaryScrollController.maybeOf(context),
    padding: const EdgeInsets.all(16),
    child: AdminUserPermissionsTab(userId: userId),
  );
}

class AdminUserPermissionsTab extends ConsumerWidget {
  const AdminUserPermissionsTab({required this.userId, super.key});
  final String userId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = adminUserPermissionsControllerProvider(userId);
    final state = ref.watch(provider);
    final controller = ref.read(provider.notifier);
    if (state.loading) {
      return const Padding(
        padding: EdgeInsets.all(32),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (state.draft == null) {
      return OpenVtsErrorView(
        message: adminUserAccessErrorLabel(context, state.error),
        onRetry: controller.load,
      );
    }
    final draft = state.draft!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OpenVtsCard(
          child: Text(
            context.mobileText(
              'Choose the pages and reports available to this user. Changes also limit the access they can grant to subusers.',
            ),
          ),
        ),
        const SizedBox(height: 16),
        OpenVtsCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              for (final key in AdminUserPermissions.featureKeys.where(
                (key) => key != 'workflow',
              ))
                SwitchListTile.adaptive(
                  title: Text(_featureLabel(context, key)),
                  value: draft.features[key] == true,
                  onChanged: state.saving
                      ? null
                      : (enabled) => controller.setFeature(key, enabled),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          context.mobileText('Report access'),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        OpenVtsCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              for (final key in AdminUserPermissions.reportKeys)
                SwitchListTile.adaptive(
                  title: Text(_reportLabel(context, key)),
                  value: draft.reports[key] == true,
                  onChanged: state.saving || draft.features['reports'] != true
                      ? null
                      : (enabled) => controller.setReport(key, enabled),
                ),
            ],
          ),
        ),
        if (state.error != null)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              adminUserAccessErrorLabel(context, state.error),
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            OpenVtsButton(
              label: context.mobileText('Reset'),
              variant: OpenVtsButtonVariant.secondary,
              onPressed: state.dirty && !state.saving ? controller.reset : null,
            ),
            OpenVtsButton(
              label: context.mobileText('Save permissions'),
              isLoading: state.saving,
              onPressed: state.dirty && !state.saving
                  ? () async {
                      final ok = await controller.save();
                      if (!context.mounted) return;
                      if (ok) {
                        ToastHelper.showSuccess(
                          context.mobileText('User permissions updated'),
                          context: context,
                        );
                      }
                    }
                  : null,
            ),
          ],
        ),
      ],
    );
  }
}

String _featureLabel(BuildContext context, String key) => switch (key) {
  'dashboard' => context.mobileText('Dashboard'),
  'maps' => context.mobileText('Maps'),
  'landmarks' => context.mobileText('Landmarks'),
  'shareTrackLink' => context.mobileText('Share tracking link'),
  'routeOptimization' => context.mobileText('Operations'),
  'support' => context.mobileText('Support'),
  'transactions' => context.mobileText('Transactions'),
  'notifications' => context.mobileText('Notifications'),
  'vehicles' => context.mobileText('Vehicles'),
  'accounts' => context.mobileText('Accounts'),
  'reports' => context.mobileText('Reports'),
  _ => key,
};
String _reportLabel(BuildContext context, String key) => switch (key) {
  'distance' => context.mobileText('Distance'),
  'driven' => context.mobileText('Driven'),
  'overspeed' => context.mobileText('Overspeed'),
  'geofence' => context.mobileText('Geofence'),
  'sensor' => context.mobileText('Sensor'),
  'alerts' => context.mobileText('Alerts'),
  'logs' => context.mobileText('Logs'),
  'timeline' => context.mobileText('Timeline'),
  'details' => context.mobileText('Details'),
  _ => key,
};
