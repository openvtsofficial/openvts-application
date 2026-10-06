import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/api/api_exception.dart';
import '../../../../../../shared/helpers/mobile_text.dart';
import '../../../../../../shared/helpers/toast_helper.dart';
import '../../../../../../shared/widgets/open_vts_button.dart';
import '../../../../../../shared/widgets/open_vts_card.dart';
import '../../../../../../shared/widgets/open_vts_error_view.dart';
import '../../../../../../shared/widgets/open_vts_loader.dart';
import '../../../../controllers/user_subuser_permissions_controller.dart';
import '../../../../models/user_subuser_permissions.dart';

class UserSubUserPermissionsTab extends ConsumerStatefulWidget {
  const UserSubUserPermissionsTab({super.key, required this.subUserId});
  final String subUserId;
  @override
  ConsumerState<UserSubUserPermissionsTab> createState() =>
      _UserSubUserPermissionsTabState();
}

class _UserSubUserPermissionsTabState
    extends ConsumerState<UserSubUserPermissionsTab> {
  UserSubUserPermissions? _permissions;
  Set<String> _features = {}, _reports = {};
  bool _saving = false;
  String? _error;

  void _accept(UserSubUserPermissions data) {
    _permissions = data;
    _features = Set.from(data.disabledFeatures);
    _reports = Set.from(data.disabledReports);
    _error = null;
  }

  @override
  void didUpdateWidget(covariant UserSubUserPermissionsTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.subUserId != widget.subUserId) {
      _permissions = null;
      _saving = false;
      _error = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = userSubUserPermissionsControllerProvider(widget.subUserId);
    final snapshot = ref.watch(provider);
    ref.listen(provider, (_, next) {
      if (next.hasValue && !next.isLoading) {
        setState(() => _accept(next.requireValue));
      } else if (next.isLoading) {
        // A refreshed permission snapshot or a changed manager scope replaces
        // the draft; old account values are never displayed during loading.
        _permissions = null;
      }
    });
    if (snapshot.isLoading) return const OpenVtsLoader();
    if (snapshot.hasError) {
      return OpenVtsErrorView(
        message: _message(snapshot.error!),
        onRetry: () => ref.read(provider.notifier).load(),
      );
    }
    if (_permissions == null) _accept(snapshot.requireValue);
    final data = _permissions!;
    final changed =
        !setEquals(_features, data.disabledFeatures) ||
        !setEquals(_reports, data.disabledReports);
    return OpenVtsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            context.mobileText('Access permissions'),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            context.mobileText(
              'A sub user can only use features and reports available to your account. Settings and account security remain available.',
            ),
          ),
          const SizedBox(height: 8),
          for (final feature in data.availableFeatures.entries.where(
            (e) => e.key != 'workflow' && e.key != 'reports',
          ))
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: Text(_label(context, feature.key)),
              subtitle: feature.value
                  ? null
                  : Text(
                      context.mobileText('Restricted by your administrator'),
                    ),
              value: feature.value && !_features.contains(feature.key),
              onChanged: _saving || !feature.value
                  ? null
                  : (enabled) => setState(() {
                      enabled
                          ? _features.remove(feature.key)
                          : _features.add(feature.key);
                    }),
            ),
          const Divider(),
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            title: Text(context.mobileText('Reports')),
            subtitle: data.availableFeatures['reports'] == true
                ? null
                : Text(context.mobileText('Restricted by your administrator')),
            value:
                data.availableFeatures['reports'] == true &&
                !_features.contains('reports'),
            onChanged: _saving || data.availableFeatures['reports'] != true
                ? null
                : (enabled) => setState(() {
                    enabled
                        ? _features.remove('reports')
                        : _features.add('reports');
                  }),
          ),
          for (final report in data.availableReports.entries)
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: Text(_label(context, report.key)),
              subtitle: report.value
                  ? null
                  : Text(
                      context.mobileText('Restricted by your administrator'),
                    ),
              value:
                  report.value &&
                  !_features.contains('reports') &&
                  !_reports.contains(report.key),
              onChanged:
                  _saving || !report.value || _features.contains('reports')
                  ? null
                  : (enabled) => setState(() {
                      enabled
                          ? _reports.remove(report.key)
                          : _reports.add(report.key);
                    }),
            ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                _error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          const SizedBox(height: 12),
          OpenVtsButton(
            label: context.mobileText('Save permissions'),
            isLoading: _saving,
            onPressed: !_saving && changed ? _save : null,
          ),
          TextButton(
            onPressed: !_saving && changed
                ? () => setState(() => _accept(data))
                : null,
            child: Text(context.mobileText('Reset')),
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    if (_saving) return;
    final id = widget.subUserId;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final saved = await ref
          .read(userSubUserPermissionsControllerProvider(id).notifier)
          .save(
            disabledFeatures: _features.toList(),
            disabledReports: _reports.toList(),
          );
      if (mounted && id == widget.subUserId && saved) {
        ToastHelper.showSuccess(
          context.mobileText('Permissions updated'),
          context: context,
        );
      }
    } catch (e) {
      if (mounted && id == widget.subUserId) {
        setState(() => _error = _message(e));
      }
    } finally {
      if (mounted && id == widget.subUserId) setState(() => _saving = false);
    }
  }

  String _message(Object error) => error is ApiException
      ? (error.statusCode == 403 &&
                error.message == 'Unable to update permissions'
            ? context.mobileText('Unable to update permissions')
            : error.message)
      : context.mobileText(
          'Unable to load or save permissions. Please try again.',
        );
}

String _label(BuildContext context, String key) => switch (key) {
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
  'distance' => context.mobileText('Distance'),
  'driven' => context.mobileText('Driven'),
  'overspeed' => context.mobileText('Overspeed'),
  'geofence' => context.mobileText('Geofence'),
  'sensor' => context.mobileText('Sensor'),
  'alerts' => context.mobileText('Alerts'),
  'logs' => context.mobileText('Logs'),
  'timeline' => context.mobileText('Timeline'),
  'details' => context.mobileText('Vehicle details'),
  _ => key,
};
