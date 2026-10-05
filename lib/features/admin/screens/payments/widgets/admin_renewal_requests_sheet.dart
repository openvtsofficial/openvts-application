import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/api/api_exception.dart';
import '../../../../../core/utils/date_time_formatter.dart';
import '../../../../../shared/helpers/mobile_text.dart';
import '../../../../../shared/helpers/toast_helper.dart';
import '../../../../../shared/widgets/open_vts_error_view.dart';
import '../../../controllers/admin_parity_controller.dart';

class AdminRenewalRequestsSheet extends ConsumerStatefulWidget {
  const AdminRenewalRequestsSheet({super.key});
  @override
  ConsumerState<AdminRenewalRequestsSheet> createState() =>
      _AdminRenewalRequestsSheetState();
}

class _AdminRenewalRequestsSheetState
    extends ConsumerState<AdminRenewalRequestsSheet> {
  final _rows = <Map<String, dynamic>>[];
  bool _loading = true, _hasMore = false;
  int? _cursor;
  String? _error, _busyId;
  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load({bool more = false}) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await ref
          .read(adminParityControllerProvider)
          .renewalRequests(cursor: more ? _cursor : null);
      if (!mounted) return;
      setState(() {
        if (!more) _rows.clear();
        _rows.addAll(
          (data['items'] as List? ?? []).whereType<Map>().map(
            (v) => Map<String, dynamic>.from(v),
          ),
        );
        _hasMore = data['hasMore'] == true;
        _cursor = int.tryParse('${data['nextCursor']}');
        _loading = false;
      });
    } catch (error) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = error is ApiException
              ? error.message
              : 'Renewal requests could not be loaded.';
        });
      }
    }
  }

  Future<void> _act(Map<String, dynamic> row, {required bool confirm}) async {
    Map<String, dynamic>? body;
    if (confirm) {
      body = await showDialog<Map<String, dynamic>>(
        context: context,
        builder: (_) => _ConfirmRenewalDialog(
          amount: '${row['currency']} ${row['amount']}',
        ),
      );
      if (body == null || !mounted) return;
    } else {
      final yes = await showDialog<bool>(
        context: context,
        builder: (c) => AlertDialog(
          title: Text(context.mobileText('Cancel renewal request?')),
          content: Text(
            context.mobileText(
              'The customer can create a fresh request. No vehicle service is extended.',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(c, false),
              child: Text(context.mobileText('Keep request')),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(c, true),
              child: Text(context.mobileText('Cancel request')),
            ),
          ],
        ),
      );
      if (yes != true || !mounted) return;
    }
    setState(() => _busyId = '${row['id']}');
    try {
      final controller = ref.read(adminParityControllerProvider);
      if (confirm) {
        await controller.confirmRenewal('${row['id']}', body!);
      } else {
        await controller.cancelRenewal('${row['id']}');
      }
      if (!mounted) return;
      ToastHelper.showSuccess(
        confirm
            ? context.mobileText('Payment confirmed and service renewed')
            : context.mobileText('Renewal request cancelled'),
        context: context,
      );
      await _load();
    } catch (error) {
      if (mounted) {
        ToastHelper.showError(
          error is ApiException
              ? error.message
              : context.mobileText('Request could not be updated'),
          context: context,
        );
      }
    } finally {
      if (mounted) setState(() => _busyId = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null && _rows.isEmpty) {
      return OpenVtsErrorView(message: _error!, onRetry: () => _load());
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            context.mobileText(
              'Review customer renewal requests. Confirm only payments actually received outside the app.',
            ),
          ),
        ),
        if (_loading) const LinearProgressIndicator(),
        if (_error != null) Text(_error!),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => _load(),
            child: ListView.builder(
              controller: PrimaryScrollController.maybeOf(context),
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(12),
              itemCount: _rows.length + 1,
              itemBuilder: (context, index) {
                if (index == _rows.length) {
                  return _rows.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(
                            context.mobileText('No pending renewal requests.'),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : _hasMore
                      ? TextButton(
                          onPressed: _loading ? null : () => _load(more: true),
                          child: Text(context.mobileText('Load more')),
                        )
                      : const SizedBox(height: 16);
                }
                final row = _rows[index];
                final meta = row['meta'] is Map ? row['meta'] as Map : const {};
                final payer = row['fromUser'] is Map
                    ? row['fromUser'] as Map
                    : const {};
                final expires = DateTime.tryParse('${meta['expiresAt']}');
                final expired =
                    row['requestExpired'] == true ||
                    (expires != null && !expires.isAfter(DateTime.now()));
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '#${row['id']} · ${row['currency']} ${row['amount']}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text('${payer['name'] ?? payer['username'] ?? ''}'),
                        if (expires != null)
                          Text(
                            expired
                                ? context.mobileText('Quote expired')
                                : 'Quote expires ${const DateTimeFormatter().formatDateTime(expires.toLocal())}',
                          ),
                        const SizedBox(height: 8),
                        for (final line
                            in (meta['lines'] as List? ?? []).whereType<Map>())
                          Text(
                            context.mobileText(
                              "{value1} · {value2} · {value3} days",
                              {
                                'value1': (line['name']).toString(),
                                'value2': (line['planName']).toString(),
                                'value3': (line['durationDays']).toString(),
                              },
                            ),
                          ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 12,
                          children: [
                            if (!expired)
                              FilledButton(
                                onPressed: _busyId != null
                                    ? null
                                    : () => _act(row, confirm: true),
                                child: Text(
                                  context.mobileText('Confirm payment'),
                                ),
                              ),
                            TextButton(
                              onPressed: _busyId != null
                                  ? null
                                  : () => _act(row, confirm: false),
                              child: Text(context.mobileText('Cancel request')),
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
        ),
      ],
    );
  }
}

class _ConfirmRenewalDialog extends StatefulWidget {
  const _ConfirmRenewalDialog({required this.amount});
  final String amount;
  @override
  State<_ConfirmRenewalDialog> createState() => _ConfirmRenewalDialogState();
}

class _ConfirmRenewalDialogState extends State<_ConfirmRenewalDialog> {
  String _mode = 'BANK_TRANSFER';
  final _reference = TextEditingController();
  bool _received = false;
  @override
  void dispose() {
    _reference.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(context.mobileText('Confirm received payment')),
    content: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(widget.amount),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _mode,
            isExpanded: true,
            items: ['CASH', 'UPI', 'BANK_TRANSFER', 'CARD', 'OTHER']
                .map(
                  (v) => DropdownMenuItem(
                    value: v,
                    child: Text(v.replaceAll('_', ' ')),
                  ),
                )
                .toList(),
            onChanged: (v) {
              if (v != null) setState(() => _mode = v);
            },
          ),
          TextField(
            controller: _reference,
            maxLength: 200,
            decoration: InputDecoration(
              labelText: context.mobileText('Payment reference'),
            ),
            onChanged: (_) => setState(() {}),
          ),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            value: _received,
            title: Text(
              context.mobileText("I received {value1}", {
                'value1': (widget.amount).toString(),
              }),
            ),
            onChanged: (v) => setState(() => _received = v == true),
          ),
        ],
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text(context.mobileText('Cancel')),
      ),
      FilledButton(
        onPressed:
            !_received || (_mode != 'CASH' && _reference.text.trim().isEmpty)
            ? null
            : () => Navigator.pop(context, {
                'paymentMode': _mode,
                if (_reference.text.trim().isNotEmpty)
                  'reference': _reference.text.trim(),
              }),
        child: Text(context.mobileText('Confirm')),
      ),
    ],
  );
}
