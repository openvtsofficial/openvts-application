import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/api/api_exception.dart';
import '../../../../shared/helpers/mobile_text.dart';
import '../../../../shared/helpers/toast_helper.dart';
import '../../../../shared/models/user_role.dart';
import '../../../auth/controllers/auth_controller.dart';
import '../../controllers/user_vehicle_service_billing_controller.dart';
import '../../services/user_operations_service.dart'
    show operationMap, operationItems;

/// Customer service dates are independent from annual provider credits and
/// deployment vehicle capacity. This page requests offline renewal only.
class UserVehicleServicesScreen extends ConsumerStatefulWidget {
  const UserVehicleServicesScreen({super.key});
  @override
  ConsumerState<UserVehicleServicesScreen> createState() =>
      _UserVehicleServicesScreenState();
}

class _UserVehicleServicesScreenState
    extends ConsumerState<UserVehicleServicesScreen> {
  String _search = '';
  final Set<int> _busy = {};
  UserVehicleServiceBillingState get _state =>
      ref.read(userVehicleServiceBillingControllerProvider);
  bool get _requests => _state.requests;
  bool get _loading => _state.loading;
  bool get _hasMore => _state.hasMore;
  String? get _error => _state.error == null ? null : _message(_state.error!);
  List<Map<String, dynamic>> get _items => _state.items;
  bool get _isPrimary =>
      ref.read(authControllerProvider).user?.role == UserRole.user;
  Future<void> _load({bool more = false, bool? requests}) => ref
      .read(userVehicleServiceBillingControllerProvider.notifier)
      .load(more: more, requests: requests, search: _search);

  @override
  Widget build(BuildContext context) {
    ref.watch(userVehicleServiceBillingControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(context.mobileText('Vehicle services')),
        actions: [
          IconButton(
            tooltip: context.mobileText('Refresh'),
            onPressed: _loading ? null : () => _load(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          if (_isPrimary)
            Padding(
              padding: const EdgeInsets.all(12),
              child: SegmentedButton<bool>(
                segments: [
                  ButtonSegment(
                    value: false,
                    label: Text(context.mobileText('Vehicles')),
                  ),
                  ButtonSegment(
                    value: true,
                    label: Text(context.mobileText('Requests')),
                  ),
                ],
                selected: {_requests},
                onSelectionChanged: (value) => _load(requests: value.single),
              ),
            ),
          if (!_requests)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                maxLength: 100,
                decoration: InputDecoration(
                  hintText: context.mobileText('Search vehicles'),
                  prefixIcon: const Icon(Icons.search),
                  counterText: '',
                  suffixIcon: IconButton(
                    tooltip: context.mobileText('Search'),
                    onPressed: () => _load(),
                    icon: const Icon(Icons.arrow_forward),
                  ),
                ),
                onChanged: (value) => _search = value.trim(),
                onSubmitted: (_) => _load(),
              ),
            ),
          if (_loading) const LinearProgressIndicator(minHeight: 2),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => _load(),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                children: [
                  if (!_requests)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        context.mobileText(
                          'Service expiry controls live tracking. Contact your administrator for renewal. A renewal request does not extend service until payment is confirmed.',
                        ),
                      ),
                    ),
                  if (_error != null)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Text(_error!),
                            TextButton(
                              onPressed: () => _load(),
                              child: Text(context.mobileText('Retry')),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (_items.isEmpty && !_loading && _error == null)
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Center(
                        child: Text(context.mobileText('No records found.')),
                      ),
                    ),
                  ..._items.map(_requests ? _requestCard : _vehicleCard),
                  if (_hasMore)
                    OutlinedButton(
                      onPressed: _loading ? null : () => _load(more: true),
                      child: Text(context.mobileText('Load more')),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _vehicleCard(Map<String, dynamic> row) {
    final service = operationMap(row['service']);
    final plan = operationMap(row['plan']);
    final id = (row['id'] as num?)?.toInt();
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${row['name'] ?? row['plateNumber'] ?? 'Vehicle'}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (row['plateNumber'] != null) Text('${row['plateNumber']}'),
            const SizedBox(height: 8),
            Text(
              service['liveAllowed'] == true
                  ? context.mobileText('Live tracking available')
                  : _reason('${service['reason'] ?? ''}'),
              style: TextStyle(
                color: service['liveAllowed'] == true
                    ? null
                    : Theme.of(context).colorScheme.error,
              ),
            ),
            Text(
              context.mobileText("Service starts: {value1}", {
                'value1': (_date(service['registrationAt'])).toString(),
              }),
            ),
            Text(
              context.mobileText("Customer service expires: {value1}", {
                'value1': (_date(service['secondaryExpiry'])).toString(),
              }),
            ),
            Text(
              context.mobileText("Provider coverage expires: {value1}", {
                'value1': (_date(service['primaryExpiry'])).toString(),
              }),
            ),
            if (plan.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                context.mobileText("{value1} • {value2} days", {
                  'value1': (plan['name'] ?? 'Plan').toString(),
                  'value2': (plan['durationDays'] ?? '—').toString(),
                }),
              ),
              Text('${plan['currency'] ?? ''} ${plan['price'] ?? ''}'),
            ],
            if (_isPrimary && id != null && row['canRequestRenewal'] == true)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _busy.contains(id) ? null : () => _request(row),
                  child: Text(
                    _busy.contains(id)
                        ? context.mobileText('Sending…')
                        : context.mobileText('Request renewal'),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _requestCard(Map<String, dynamic> row) {
    final meta = operationMap(row['meta']);
    final id = (row['id'] as num?)?.toInt();
    final expired = row['requestExpired'] == true;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.mobileText("Request #{value1}", {
                'value1': (row['id']).toString(),
              }),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              expired
                  ? context.mobileText('Expired request')
                  : '${row['status'] ?? ''}',
            ),
            Text('${row['currency'] ?? ''} ${row['amount'] ?? ''}'),
            Text(
              context.mobileText("Created: {value1}", {
                'value1': (_date(row['createdAt'])).toString(),
              }),
            ),
            ...operationItems(meta['lines']).map(
              (line) => Text(
                context.mobileText("{value1} • {value2} days", {
                  'value1':
                      (line['vehicleName'] ??
                              line['name'] ??
                              'Vehicle #${line['vehicleId']}')
                          .toString(),
                  'value2': (line['durationDays'] ?? '—').toString(),
                }),
              ),
            ),
            if (row['status'] == 'PENDING' && !expired && id != null)
              TextButton(
                onPressed: _busy.contains(id) ? null : () => _cancel(id),
                child: Text(context.mobileText('Cancel request')),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _request(Map<String, dynamic> row) async {
    final id = (row['id'] as num).toInt();
    final plan = operationMap(row['plan']);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.mobileText('Request vehicle renewal?')),
        content: Text(
          context.mobileText(
            "{value1}\n{value2} • {value3} days\n{value4} {value5}\n\nYour administrator must confirm payment before service is extended.",
            {
              'value1': (row['name']).toString(),
              'value2': (plan['name']).toString(),
              'value3': (plan['durationDays']).toString(),
              'value4': (plan['currency']).toString(),
              'value5': (plan['price']).toString(),
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(context.mobileText('Back')),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(context.mobileText('Send request')),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() => _busy.add(id));
    try {
      await ref
          .read(userVehicleServiceBillingControllerProvider.notifier)
          .requestRenewal(id);
    } catch (e) {
      if (mounted) ToastHelper.showError(_message(e), context: context);
    } finally {
      if (mounted) setState(() => _busy.remove(id));
    }
  }

  Future<void> _cancel(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.mobileText('Cancel renewal request?')),
        content: Text(
          context.mobileText("Request #{value1}", {'value1': (id).toString()}),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(context.mobileText('Keep request')),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(context.mobileText('Cancel request')),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() => _busy.add(id));
    try {
      await ref
          .read(userVehicleServiceBillingControllerProvider.notifier)
          .cancel(id);
    } catch (e) {
      if (mounted) ToastHelper.showError(_message(e), context: context);
    } finally {
      if (mounted) setState(() => _busy.remove(id));
    }
  }
}

String _date(dynamic value) {
  final date = DateTime.tryParse('${value ?? ''}');
  return date == null
      ? 'Not configured'
      : '${DateFormat('d MMM y, HH:mm').format(date.toLocal())} (device time)';
}

String _reason(String code) =>
    const {
      'VEHICLE_INACTIVE': 'Vehicle is inactive',
      'LICENSE_REQUIRED': 'Deployment license required',
      'ADMIN_COVERAGE_NOT_CONFIGURED': 'Provider coverage is not configured',
      'ADMIN_COVERAGE_EXPIRED': 'Provider coverage has expired',
      'SERVICE_NOT_CONFIGURED': 'Service is not configured',
      'SERVICE_NOT_STARTED': 'Service has not started',
      'SERVICE_EXPIRED': 'Customer service has expired',
    }[code] ??
    'Live tracking unavailable';
String _message(Object error) => error is ApiException
    ? error.message
    : 'Unable to complete this request. Please try again.';
