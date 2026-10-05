import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/api/api_exception.dart';
import '../../../../../shared/helpers/mobile_text.dart';
import '../../../../../shared/helpers/toast_helper.dart';
import '../../../../../shared/widgets/open_vts_error_view.dart';
import '../../../controllers/admin_parity_controller.dart';

class AdminUserPermissionsSheet extends ConsumerStatefulWidget {
  const AdminUserPermissionsSheet({required this.userId, super.key});
  final String userId;
  @override
  ConsumerState<AdminUserPermissionsSheet> createState() =>
      _AdminUserPermissionsSheetState();
}

class _AdminUserPermissionsSheetState
    extends ConsumerState<AdminUserPermissionsSheet> {
  static const _featureLabels = {
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
  };
  static const _reportLabels = {
    'distance': 'Distance',
    'driven': 'Driven',
    'overspeed': 'Overspeed',
    'geofence': 'Geofence',
    'sensor': 'Sensor',
    'alerts': 'Alerts',
    'logs': 'Logs',
    'timeline': 'Timeline',
    'details': 'Details',
  };
  Map<String, bool> _features = {}, _reports = {};
  String _saved = '';
  bool _loading = true, _saving = false;
  String? _error;
  Map<String, dynamic> get _payload => {
    'disabledFeatures':
        _features.entries.where((e) => !e.value).map((e) => e.key).toList()
          ..sort(),
    'disabledReports':
        _reports.entries.where((e) => !e.value).map((e) => e.key).toList()
          ..sort(),
  };
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
      final data = await ref
          .read(adminParityControllerProvider)
          .userPermissions(widget.userId);
      if (!mounted) return;
      final features = data['features'], reports = data['reports'];
      if (data['catalogVersion'] != 1 ||
          features is! Map ||
          reports is! Map ||
          ![
            ..._featureLabels.keys,
            'workflow',
          ].every((k) => features[k] is bool) ||
          !_reportLabels.keys.every((k) => reports[k] is bool)) {
        throw ApiException(
          message: context.mobileText(
            'The server returned an unsupported permission catalog. Editing is disabled.',
          ),
        );
      }
      if (!mounted) return;
      setState(() {
        _features = {
          for (final key in [..._featureLabels.keys, 'workflow'])
            key: features[key] as bool,
        };
        _reports = {
          for (final key in _reportLabels.keys) key: reports[key] as bool,
        };
        _saved = jsonEncode(_payload);
        _loading = false;
      });
    } catch (error) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = error is ApiException
              ? error.message
              : 'User permissions could not be loaded.';
        });
      }
    }
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await ref
          .read(adminParityControllerProvider)
          .saveUserPermissions(widget.userId, _payload);
      if (!mounted) return;
      ToastHelper.showSuccess(
        context.mobileText('User permissions updated'),
        context: context,
      );
      await _load();
    } catch (error) {
      if (mounted) {
        ToastHelper.showError(
          error is ApiException
              ? error.message
              : context.mobileText('Unable to save permissions'),
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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            context.mobileText(
              'Choose the pages and reports available to this user. Changes also limit the access they can grant to subusers.',
            ),
          ),
        ),
        Expanded(
          child: ListView(
            controller: PrimaryScrollController.maybeOf(context),
            children: [
              for (final e in _featureLabels.entries)
                SwitchListTile(
                  title: Text(e.value),
                  value: _features[e.key] == true,
                  onChanged: _saving
                      ? null
                      : (v) => setState(() => _features[e.key] = v),
                ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(context.mobileText('Report access')),
              ),
              for (final e in _reportLabels.entries)
                SwitchListTile(
                  title: Text(e.value),
                  value: _reports[e.key] == true,
                  onChanged: _saving || _features['reports'] != true
                      ? null
                      : (v) => setState(() => _reports[e.key] = v),
                ),
            ],
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: FilledButton(
              onPressed: _saving || _saved == jsonEncode(_payload)
                  ? null
                  : _save,
              child: Text(
                _saving
                    ? context.mobileText('Saving…')
                    : context.mobileText('Save permissions'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
