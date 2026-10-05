import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/api/api_exception.dart';
import '../../../../../core/utils/date_time_formatter.dart';
import '../../../../../shared/helpers/mobile_text.dart';
import '../../../../../shared/helpers/toast_helper.dart';
import '../../../../../shared/widgets/open_vts_error_view.dart';
import '../../../controllers/admin_parity_controller.dart';

class AdminVehicleServiceSheet extends ConsumerStatefulWidget {
  const AdminVehicleServiceSheet({required this.vehicleId, super.key});
  final String vehicleId;
  @override
  ConsumerState<AdminVehicleServiceSheet> createState() =>
      _AdminVehicleServiceSheetState();
}

class _AdminVehicleServiceSheetState
    extends ConsumerState<AdminVehicleServiceSheet> {
  Map<String, dynamic>? _data;
  bool _loading = true, _saving = false;
  String? _error, _planId;
  String _mode = 'preserve';
  DateTime? _registration, _expiry;
  final _reason = TextEditingController();
  final _date = const DateTimeFormatter();
  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await ref
          .read(adminParityControllerProvider)
          .vehicleService(widget.vehicleId);
      if (!mounted) return;
      final vehicle = data['vehicle'] is Map
          ? data['vehicle'] as Map
          : const {};
      final service = vehicle['service'] is Map
          ? vehicle['service'] as Map
          : const {};
      if (vehicle['serviceRevision'] is! num) {
        throw ApiException(
          message: context.mobileText(
            'Vehicle service revision unavailable. Reload before editing.',
          ),
        );
      }
      if (!mounted) return;
      setState(() {
        _data = data;
        _planId = vehicle['planId']?.toString();
        _registration = DateTime.tryParse(
          '${service['registrationAt']}',
        )?.toLocal();
        _expiry = DateTime.tryParse('${service['secondaryExpiry']}')?.toLocal();
        _mode = 'preserve';
        _reason.clear();
        _loading = false;
      });
    } catch (error) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = error is ApiException
              ? error.message
              : 'Vehicle service could not be loaded.';
        });
      }
    }
  }

  Future<void> _pick(bool registration) async {
    final initial = (registration ? _registration : _expiry) ?? DateTime.now();
    final day = await showDatePicker(
      context: context,
      initialDate: initial.isBefore(DateTime(1970))
          ? DateTime(1970)
          : initial.isAfter(DateTime(2200))
          ? DateTime(2200)
          : initial,
      firstDate: DateTime(1970),
      lastDate: DateTime(2200),
    );
    if (day == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );
    if (time == null || !mounted) return;
    final value = DateTime(
      day.year,
      day.month,
      day.day,
      time.hour,
      time.minute,
    );
    setState(() {
      if (registration) {
        _registration = value;
      } else {
        _expiry = value;
      }
    });
  }

  Future<void> _save() async {
    final reason = _reason.text.trim();
    if (_data == null ||
        _planId == null ||
        _registration == null ||
        reason.length < 5 ||
        reason.length > 500) {
      ToastHelper.showError(
        context.mobileText(
          'Choose a plan, registration date and reason of 5–500 characters.',
        ),
        context: context,
      );
      return;
    }
    if (_mode == 'custom' &&
        (_expiry == null || !_expiry!.isAfter(_registration!))) {
      ToastHelper.showError(
        context.mobileText('Service expiry must follow registration.'),
        context: context,
      );
      return;
    }
    setState(() => _saving = true);
    try {
      final vehicle = _data!['vehicle'] as Map;
      await ref
          .read(adminParityControllerProvider)
          .saveVehicleService(widget.vehicleId, {
            'expectedRevision': vehicle['serviceRevision'],
            'reason': reason,
            'planId': int.parse(_planId!),
            'registrationAt': _registration!.toUtc().toIso8601String(),
            if (_mode == 'custom')
              'secondaryExpiry': _expiry!.toUtc().toIso8601String(),
            if (_mode == 'recalculate') 'recalculateExpiry': true,
          });
      if (!mounted) return;
      ToastHelper.showSuccess(
        context.mobileText('Vehicle service updated'),
        context: context,
      );
      await _load();
    } catch (error) {
      if (mounted) {
        ToastHelper.showError(
          error is ApiException
              ? error.message
              : context.mobileText('Service could not be updated'),
          context: context,
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _annual() async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(context.mobileText('Renew annual coverage?')),
        content: Text(
          context.mobileText(
            'This uses one account credit when the vehicle is eligible.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: Text(context.mobileText('Cancel')),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(c, true),
            child: Text(context.mobileText('Renew')),
          ),
        ],
      ),
    );
    if (yes != true || !mounted) return;
    setState(() => _saving = true);
    try {
      final data = await ref
          .read(adminParityControllerProvider)
          .renewAnnual(widget.vehicleId);
      if (!mounted) return;
      if (data['insufficientCredits'] == true) {
        ToastHelper.showError(
          context.mobileText('Insufficient account credits'),
          context: context,
        );
      } else {
        ToastHelper.showSuccess(
          context.mobileText("{value1} annual coverage renewed", {
            'value1': (data['renewed'] ?? 0).toString(),
          }),
          context: context,
        );
      }
      await _load();
    } catch (error) {
      if (mounted) {
        ToastHelper.showError(
          error is ApiException
              ? error.message
              : context.mobileText('Annual renewal failed'),
          context: context,
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  String _format(dynamic value) {
    final parsed = DateTime.tryParse('$value');
    return parsed == null
        ? 'Not configured'
        : _date.formatDateTime(parsed.toLocal());
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) {
      return OpenVtsErrorView(message: _error!, onRetry: _load);
    }
    final vehicle = _data!['vehicle'] as Map;
    final service = vehicle['service'] as Map? ?? const {};
    final plans = (_data!['plans'] as List? ?? []).whereType<Map>().toList();
    final plan = plans.any((p) => '${p['id']}' == _planId) ? _planId : null;
    final credits = num.tryParse('${_data!['adminCredits']}') ?? 0;
    return ListView(
      controller: PrimaryScrollController.maybeOf(context),
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          context.mobileText(
            'Annual coverage and customer service are separate.',
          ),
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        Text(
          context.mobileText("Annual coverage: {value1}", {
            'value1': (_format(service['primaryExpiry'])).toString(),
          }),
        ),
        Text(
          context.mobileText("Customer service: {value1}", {
            'value1': (_format(service['secondaryExpiry'])).toString(),
          }),
        ),
        Text(
          context.mobileText("Account credits: {value1}", {
            'value1': (credits).toString(),
          }),
        ),
        Text(
          service['liveAllowed'] == true
              ? context.mobileText('Live tracking active')
              : '${service['reason'] ?? 'Service unavailable'}'.replaceAll(
                  '_',
                  ' ',
                ),
        ),
        if (service['annualStatus'] == 'EXPIRED')
          TextButton(
            onPressed: _saving || credits < 1 ? null : _annual,
            child: Text(context.mobileText('Renew annual coverage')),
          ),
        const Divider(height: 32),
        DropdownButtonFormField<String>(
          key: ValueKey(plan),
          initialValue: plan,
          isExpanded: true,
          decoration: InputDecoration(
            labelText: context.mobileText('Service plan'),
          ),
          items: plans
              .map(
                (p) => DropdownMenuItem(
                  value: '${p['id']}',
                  child: Text(
                    context.mobileText("{value1} · {value2} days", {
                      'value1': (p['name']).toString(),
                      'value2': (p['durationDays']).toString(),
                    }),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
              .toList(),
          onChanged: _saving ? null : (v) => setState(() => _planId = v),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(context.mobileText('Registration date')),
          subtitle: Text(
            _registration == null
                ? context.mobileText('Choose date and time')
                : _date.formatDateTime(_registration!),
          ),
          trailing: const Icon(Icons.calendar_month),
          onTap: _saving ? null : () => _pick(true),
        ),
        DropdownButtonFormField<String>(
          key: ValueKey(_mode),
          isExpanded: true,
          initialValue: _mode,
          decoration: InputDecoration(
            labelText: context.mobileText('Customer expiry'),
          ),
          items: [
            DropdownMenuItem(
              value: 'preserve',
              child: Text(context.mobileText('Preserve current expiry')),
            ),
            DropdownMenuItem(
              value: 'recalculate',
              child: Text(context.mobileText('Recalculate from plan')),
            ),
            DropdownMenuItem(
              value: 'custom',
              child: Text(context.mobileText('Set custom expiry')),
            ),
          ],
          onChanged: _saving ? null : (v) => setState(() => _mode = v!),
        ),
        if (_mode == 'custom')
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(context.mobileText('Customer expiry date')),
            subtitle: Text(
              _expiry == null
                  ? context.mobileText('Choose date and time')
                  : _date.formatDateTime(_expiry!),
            ),
            trailing: const Icon(Icons.calendar_month),
            onTap: _saving ? null : () => _pick(false),
          ),
        const SizedBox(height: 12),
        TextField(
          controller: _reason,
          maxLength: 500,
          minLines: 2,
          maxLines: 4,
          enabled: !_saving,
          decoration: InputDecoration(
            labelText: context.mobileText('Reason for adjustment'),
            helperText: context.mobileText(
              'At least 5 characters. Changes are audited.',
            ),
          ),
        ),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: _saving ? null : _save,
          child: Text(
            _saving
                ? context.mobileText('Saving…')
                : context.mobileText('Save service changes'),
          ),
        ),
        const SizedBox(height: 16),
        ExpansionTile(
          title: Text(context.mobileText('Recent service activity')),
          children: [
            for (final event
                in (_data!['events'] as List? ?? []).whereType<Map>())
              ListTile(
                title: Text('${event['action']}'.replaceAll('_', ' ')),
                subtitle: Text(
                  '${_format(event['createdAt'])}\n${event['meta'] is Map ? (event['meta'] as Map)['reason'] ?? '' : ''}',
                ),
              ),
          ],
        ),
      ],
    );
  }
}
