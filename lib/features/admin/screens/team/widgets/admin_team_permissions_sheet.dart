import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/api/api_exception.dart';
import '../../../../../shared/helpers/mobile_text.dart';
import '../../../../../shared/helpers/toast_helper.dart';
import '../../../../../shared/widgets/open_vts_error_view.dart';
import '../../../controllers/admin_parity_controller.dart';
import '../../../models/admin_team_permissions.dart';

class AdminTeamPermissionsSheet extends ConsumerStatefulWidget {
  const AdminTeamPermissionsSheet({required this.memberId, super.key});
  final String memberId;
  @override
  ConsumerState<AdminTeamPermissionsSheet> createState() =>
      _AdminTeamPermissionsSheetState();
}

class _AdminTeamPermissionsSheetState
    extends ConsumerState<AdminTeamPermissionsSheet> {
  List<AdminTeamPermissionFeature> _features = [];
  Map<String, String> _selected = {}, _saved = {};
  bool _loading = true, _saving = false;
  String? _error;
  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final responses = await ref
          .read(adminParityControllerProvider)
          .loadTeamPermissions(widget.memberId);
      if (!mounted) return;
      final features = parseAdminTeamFeatures(responses[0]);
      if (features.isEmpty) {
        throw ApiException(
          message: context.mobileText(
            'The permission catalog is unavailable. Editing is disabled.',
          ),
        );
      }
      if (!mounted) return;
      setState(() {
        _features = features;
        _selected = parseAdminTeamGrants(responses[1]);
        _saved = Map.from(_selected);
        _loading = false;
      });
    } catch (error) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = error is ApiException
              ? error.message
              : 'Permissions could not be loaded.';
        });
      }
    }
  }

  Future<void> _save() async {
    final grants = legalAdminTeamGrants(_features, _selected);
    final elevated = grants.any(
      (g) =>
          (g['scope'] == 'TENANT' && _saved[g['permissionSlug']] != 'TENANT') ||
          (_features
                  .expand((f) => f.actions)
                  .any(
                    (a) =>
                        a.slug == g['permissionSlug'] && a.action == 'delete',
                  ) &&
              !_saved.containsKey(g['permissionSlug'])),
    );
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
      if (yes != true || !mounted) return;
    }
    setState(() => _saving = true);
    try {
      await ref
          .read(adminParityControllerProvider)
          .saveTeamPermissions(widget.memberId, grants);
      if (!mounted) return;
      ToastHelper.showSuccess(
        context.mobileText('Team permissions updated'),
        context: context,
      );
      await _load();
    } catch (error) {
      if (mounted) {
        ToastHelper.showError(
          error is ApiException
              ? error.message
              : context.mobileText('Unable to update permissions'),
          context: context,
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) {
      return OpenVtsErrorView(message: _error!, onRetry: _load);
    }
    final changed =
        jsonEncode(legalAdminTeamGrants(_features, _selected)) !=
        jsonEncode(legalAdminTeamGrants(_features, _saved));
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            context.mobileText(
              'Choose what this member can view, edit and delete. Own applies to their records; Global applies across your account.',
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            controller: PrimaryScrollController.maybeOf(context),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _features.length,
            itemBuilder: (context, index) {
              final feature = _features[index];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        feature.label,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      if (feature.description.isNotEmpty)
                        Text(
                          feature.description,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      for (final action in feature.actions)
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${action.action[0].toUpperCase()}${action.action.substring(1)}',
                              ),
                            ),
                            DropdownButton<String>(
                              value:
                                  _selected[action.slug] != null &&
                                      action.scopes.contains(
                                        _selected[action.slug],
                                      )
                                  ? _selected[action.slug]!
                                  : 'NONE',
                              items: [
                                DropdownMenuItem(
                                  value: 'NONE',
                                  child: Text(context.mobileText('None')),
                                ),
                                for (final scope in action.scopes)
                                  DropdownMenuItem(
                                    value: scope,
                                    child: Text(
                                      scope == 'OWN'
                                          ? context.mobileText('Own')
                                          : context.mobileText('Global'),
                                    ),
                                  ),
                              ],
                              onChanged: _saving
                                  ? null
                                  : (scope) => setState(
                                      () => _selected = changeAdminTeamGrant(
                                        _features,
                                        _selected,
                                        action,
                                        scope == 'NONE' ? null : scope,
                                      ),
                                    ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: !_saving && changed
                        ? () => setState(() => _selected = Map.from(_saved))
                        : null,
                    child: Text(context.mobileText('Reset')),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: FilledButton(
                    onPressed: !_saving && changed ? _save : null,
                    child: Text(
                      _saving
                          ? context.mobileText('Saving…')
                          : context.mobileText('Save permissions'),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
