import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/api/api_exception.dart';
import '../../../../../../shared/helpers/mobile_text.dart';
import '../../../../../../shared/helpers/toast_helper.dart';
import '../../../../controllers/user_subuser_permissions_controller.dart';

class UserSubUserPermissionsTab extends ConsumerStatefulWidget {
  const UserSubUserPermissionsTab({super.key, required this.subUserId});
  final String subUserId;
  @override
  ConsumerState<UserSubUserPermissionsTab> createState() =>
      _UserSubUserPermissionsTabState();
}

class _UserSubUserPermissionsTabState
    extends ConsumerState<UserSubUserPermissionsTab> {
  Map<String, dynamic>? _permissions;
  Set<String> _features = {};
  Set<String> _reports = {};
  bool _saving = false;
  String? _error;
  Future<void> _load() => ref
      .read(userSubUserPermissionsControllerProvider(widget.subUserId).notifier)
      .load();
  void _accept(Map<String, dynamic> data) {
    _permissions = data;
    _features = (data['disabledFeatures'] as List? ?? [])
        .map((e) => '$e')
        .toSet();
    _reports = (data['disabledReports'] as List? ?? [])
        .map((e) => '$e')
        .toSet();
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(
      userSubUserPermissionsControllerProvider(widget.subUserId),
    );
    ref.listen(userSubUserPermissionsControllerProvider(widget.subUserId), (
      _,
      next,
    ) {
      if (next.hasValue) {
        setState(() {
          _accept(next.requireValue);
          _error = null;
        });
      }
    });
    if (snapshot.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (snapshot.hasError) {
      return Column(
        children: [
          Text(_message(snapshot.error!)),
          TextButton(
            onPressed: _load,
            child: Text(context.mobileText('Retry')),
          ),
        ],
      );
    }
    if (_permissions == null) _accept(snapshot.requireValue);
    final features = Map<String, dynamic>.from(
      _permissions!['availableFeatures'] as Map? ?? {},
    );
    final reports = Map<String, dynamic>.from(
      _permissions!['availableReports'] as Map? ?? {},
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
        // Preserve web-only workflow deny state when saving mobile permissions.
        ...features.entries
            .where((e) => e.key != 'workflow')
            .map(
              (e) => SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: Text(_label(e.key)),
                subtitle: e.value == true
                    ? null
                    : Text(
                        context.mobileText('Restricted by your administrator'),
                      ),
                value: e.value == true && !_features.contains(e.key),
                onChanged: _saving || e.value != true
                    ? null
                    : (enabled) => setState(() {
                        enabled
                            ? _features.remove(e.key)
                            : _features.add(e.key);
                      }),
              ),
            ),
        const Divider(),
        Text(
          context.mobileText('Reports'),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        ...reports.entries.map(
          (e) => SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            title: Text(_label(e.key)),
            value:
                e.value == true &&
                !_features.contains('reports') &&
                !_reports.contains(e.key),
            onChanged:
                _saving || e.value != true || _features.contains('reports')
                ? null
                : (enabled) => setState(() {
                    enabled ? _reports.remove(e.key) : _reports.add(e.key);
                  }),
          ),
        ),
        if (_error != null)
          Text(
            _error!,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: _saving ? null : _save,
          icon: const Icon(Icons.save_outlined),
          label: Text(
            _saving
                ? context.mobileText('Saving…')
                : context.mobileText('Save permissions'),
          ),
        ),
      ],
    );
  }

  Future<void> _save() async {
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ref
          .read(
            userSubUserPermissionsControllerProvider(widget.subUserId).notifier,
          )
          .save(
            disabledFeatures: _features.toList(),
            disabledReports: _reports.toList(),
          );
      if (mounted) {
        ToastHelper.showSuccess(
          context.mobileText('Permissions updated'),
          context: context,
        );
      }
    } catch (e) {
      if (mounted) setState(() => _error = _message(e));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  String _message(Object error) => error is ApiException
      ? error.message
      : 'Unable to load or save permissions. Please try again.';
  String _label(String key) =>
      const {
        'dashboard': 'Dashboard',
        'maps': 'Maps',
        'landmarks': 'Landmarks',
        'shareTrackLink': 'Share tracking link',
        'routeOptimization': 'Operations',
        'support': 'Support',
        'transactions': 'Transactions',
        'notifications': 'Notifications',
        'vehicles': 'Vehicles',
        'accounts': 'Accounts',
        'reports': 'Reports',
        'logs': 'Device logs',
        'details': 'Vehicle details',
      }[key] ??
      (key.isEmpty ? '' : '${key[0].toUpperCase()}${key.substring(1)}');
}
