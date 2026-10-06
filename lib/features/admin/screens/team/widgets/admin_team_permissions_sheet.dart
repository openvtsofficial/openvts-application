import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/api/api_exception.dart';
import '../../../../../shared/helpers/mobile_text.dart';
import '../../../../../shared/helpers/toast_helper.dart';
import '../../../../../shared/widgets/open_vts_button.dart';
import '../../../../../shared/widgets/open_vts_card.dart';
import '../../../../../shared/widgets/open_vts_error_view.dart';
import '../../../../../shared/widgets/open_vts_loader.dart';
import '../../../../../shared/widgets/open_vts_searchable_dropdown.dart';
import '../../../controllers/admin_team_details_controller.dart';
import '../../../models/admin_team_permissions.dart';
import '../../../services/admin_team_details_service.dart';

class AdminTeamPermissionsSheet extends ConsumerStatefulWidget {
  const AdminTeamPermissionsSheet({required this.memberId, super.key});
  final String memberId;
  @override
  ConsumerState<AdminTeamPermissionsSheet> createState() =>
      _AdminTeamPermissionsSheetState();
}

class _AdminTeamPermissionsSheetState
    extends ConsumerState<AdminTeamPermissionsSheet> {
  AdminTeamPermissionSnapshot? _snapshot;
  Map<String, String> _selected = {};
  bool _saving = false;
  String? _error;

  void _accept(AdminTeamPermissionSnapshot snapshot) {
    _snapshot = snapshot;
    _selected = Map.from(snapshot.grants);
    _error = null;
  }

  @override
  Widget build(BuildContext context) {
    final provider = adminTeamPermissionsControllerProvider(widget.memberId);
    final state = ref.watch(provider);
    ref.listen(provider, (_, next) {
      if (next.hasValue && !next.isLoading) {
        setState(() => _accept(next.requireValue));
      }
      if (next.isLoading) _snapshot = null;
    });
    if (state.isLoading) return const OpenVtsLoader();
    if (state.hasError) {
      return OpenVtsErrorView(
        message: _message(state.error!),
        onRetry: () => ref.read(provider.notifier).load(),
      );
    }
    if (_snapshot == null) _accept(state.requireValue);
    final snapshot = _snapshot!;
    final features = snapshot.features
        .where((feature) => feature.key != 'notify')
        .toList(growable: false);
    final changed =
        jsonEncode(legalAdminTeamGrants(snapshot.features, _selected)) !=
        jsonEncode(legalAdminTeamGrants(snapshot.features, snapshot.grants));
    return Column(
      children: [
        Expanded(
          child: ListView(
            controller: PrimaryScrollController.maybeOf(context),
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                context.mobileText(
                  'Choose what this member can view, edit and delete. Own applies to their records; Global applies across your account.',
                ),
              ),
              const SizedBox(height: 12),
              for (final feature in features)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: OpenVtsCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _featureLabel(context, feature),
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        for (final action in feature.actions)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: OpenVtsSearchableDropdown<String>(
                              key: ValueKey(action.slug),
                              label: switch (action.action) {
                                'view' => context.mobileText('View'),
                                'edit' => context.mobileText('Edit'),
                                'delete' => context.mobileText('Delete'),
                                _ => action.action,
                              },
                              value:
                                  action.scopes.contains(_selected[action.slug])
                                  ? _selected[action.slug]
                                  : 'NONE',
                              enabled: !_saving,
                              options: [
                                OpenVtsDropdownOption(
                                  value: 'NONE',
                                  label: context.mobileText('None'),
                                ),
                                for (final scope in action.scopes)
                                  OpenVtsDropdownOption(
                                    value: scope,
                                    label: scope == 'OWN'
                                        ? context.mobileText('Own')
                                        : context.mobileText('Global'),
                                  ),
                              ],
                              onChanged: (scope) => setState(
                                () => _selected = changeAdminTeamGrant(
                                  snapshot.features,
                                  _selected,
                                  action,
                                  scope == 'NONE' ? null : scope,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              if (_error != null)
                Text(
                  _error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
            ],
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                OpenVtsButton(
                  label: context.mobileText('Save permissions'),
                  isLoading: _saving,
                  onPressed: !_saving && changed ? _save : null,
                ),
                TextButton(
                  onPressed: !_saving && changed
                      ? () => setState(() => _accept(snapshot))
                      : null,
                  child: Text(context.mobileText('Reset')),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _save() async {
    final snapshot = _snapshot;
    if (_saving || snapshot == null) return;
    final controller = ref.read(
      adminTeamPermissionsControllerProvider(widget.memberId).notifier,
    );
    final grants = legalAdminTeamGrants(snapshot.features, _selected);
    final elevated = grants.any(
      (grant) =>
          (grant['scope'] == 'TENANT' &&
              snapshot.grants[grant['permissionSlug']] != 'TENANT') ||
          (snapshot.features
                  .expand((feature) => feature.actions)
                  .any(
                    (action) =>
                        action.slug == grant['permissionSlug'] &&
                        action.action == 'delete',
                  ) &&
              !snapshot.grants.containsKey(grant['permissionSlug'])),
    );
    // Lock the button while confirmation is open to prevent double submissions.
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      if (elevated) {
        final yes = await showDialog<bool>(
          context: context,
          builder: (c) => AlertDialog(
            title: Text(context.mobileText('Confirm increased access')),
            content: Text(
              context.mobileText(
                'These changes grant global or delete access. Apply them to this team member?',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(c, false),
                child: Text(context.mobileText('Cancel')),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(c, true),
                child: Text(context.mobileText('Confirm')),
              ),
            ],
          ),
        );
        if (!mounted || yes != true) return;
      }
      // Read the current scope after confirmation; permission revocation or an
      // account switch while the dialog is open must block the write.
      final saved = await controller.save(Map.from(_selected));
      if (mounted && saved) {
        ToastHelper.showSuccess(
          context.mobileText('Team permissions updated'),
          context: context,
        );
      }
    } catch (error) {
      if (mounted) setState(() => _error = _message(error));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  String _message(Object error) => error is ApiException
      ? (error.statusCode == 403 &&
                error.message == 'Unable to update permissions'
            ? context.mobileText('Unable to update permissions')
            : error.message)
      : context.mobileText('Permissions could not be loaded.');
}

String _featureLabel(
  BuildContext context,
  AdminTeamPermissionFeature feature,
) => switch (feature.key) {
  'dashboard' => context.mobileText('Dashboard'),
  'users' => context.mobileText('Users'),
  'vehicles' => context.mobileText('Vehicles'),
  'drivers' => context.mobileText('Drivers'),
  'inventory' => context.mobileText('Inventory'),
  'maps' => context.mobileText('Maps'),
  'payments' => context.mobileText('Payments'),
  'support' => context.mobileText('Support'),
  'calendar' => context.mobileText('Calendar'),
  'logs' => context.mobileText('Logs'),
  _ => feature.label,
};
