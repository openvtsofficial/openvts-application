import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/helpers/toast_helper.dart';
import '../../../../shared/helpers/validation_localizations.dart';
import '../../../../shared/widgets/open_vts_card.dart';
import '../../controllers/user_operations_providers.dart';
import '../../models/user_operation_attachment.dart';
import '../../models/user_operation_map.dart';
import '../../services/user_operations_service.dart';
import 'operations_localizations.dart';
import 'operations_ui.dart';
import 'user_operation_proof_screen.dart';
import 'user_operation_refresh_scope.dart';
import 'user_operation_route_map.dart';

class UserOperationTripScreen extends ConsumerStatefulWidget {
  const UserOperationTripScreen({super.key, required this.id});
  final String id;
  @override
  ConsumerState<UserOperationTripScreen> createState() =>
      _UserOperationTripScreenState();
}

class _UserOperationTripScreenState
    extends ConsumerState<UserOperationTripScreen> {
  bool _saving = false;
  final Set<String> _acknowledging = {};
  @override
  Widget build(BuildContext context) => PopScope(
    canPop: !_saving,
    child: Scaffold(
      appBar: AppBar(
        title: Text(context.operationText('Trip details')),
        actions: [
          IconButton(
            tooltip: context.operationText('Refresh'),
            onPressed: _saving
                ? null
                : () => ref.invalidate(userOperationTripProvider(widget.id)),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SafeArea(
        child: UserOperationRefreshScope(
          onRefresh: () {
            if (!_saving) {
              ref.invalidate(userOperationTripProvider(widget.id));
            }
          },
          child: ref
              .watch(userOperationTripProvider(widget.id))
              .when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(operationError(context, error)),
                        TextButton(
                          onPressed: () => ref.invalidate(
                            userOperationTripProvider(widget.id),
                          ),
                          child: Text(context.operationText('Retry')),
                        ),
                      ],
                    ),
                  ),
                ),
                data: (data) {
                  final trip = data['trip'] is Map
                      ? operationMap(data['trip'])
                      : data;
                  final status = '${trip['status']}';
                  final tracking = operationMap(trip['tracking']);
                  final timezone = '${trip['timezone'] ?? ''}';
                  final progress = operationMap(trip['progress']);
                  String date(dynamic value) => operationDate(
                    value,
                    timezone: timezone,
                    context: context,
                  );
                  final actions = [
                    if (status == 'ASSIGNED' || status == 'ACKNOWLEDGED')
                      'START',
                    if (status == 'IN_PROGRESS') 'COMPLETE',
                    if ([
                      'ASSIGNED',
                      'ACKNOWLEDGED',
                      'IN_PROGRESS',
                    ].contains(status))
                      'CANCEL',
                    'ADD_REMARK',
                  ];
                  return ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      OpenVtsCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${trip['title'] ?? context.operationText('Trip')}',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            Text(
                              '${trip['referenceCode'] ?? ''} • ${operationLabel(context, status)}',
                            ),
                            const SizedBox(height: 16),
                            Text(
                              '${operationMap(trip['vehicle'])['name'] ?? ''} • ${operationMap(trip['driver'])['name'] ?? ''}',
                            ),
                            Text(
                              context.operationText('Scheduled: {date}', {
                                'date': date(trip['scheduledStartAt']),
                              }),
                            ),
                            Text(
                              context.operationText('Ends: {date}', {
                                'date': date(trip['scheduledEndAt']),
                              }),
                            ),
                            if (trip['instructions'] != null)
                              Text('${trip['instructions']}'),
                            if (tracking.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Text(
                                context.operationText('Vehicle GPS: {status}', {
                                  'status': operationLabel(
                                    context,
                                    '${tracking['status'] ?? 'UNAVAILABLE'}',
                                  ),
                                }),
                              ),
                              Text(
                                context.operationText('Last position: {date}', {
                                  'date': date(tracking['lastPositionAt']),
                                }),
                              ),
                            ],
                            if (trip['actualKm'] != null)
                              Text(
                                context.operationText(
                                  'Actual distance: {distance} km',
                                  {'distance': trip['actualKm']},
                                ),
                              ),
                            if (trip['tripScore'] is Map)
                              Text(
                                context.operationText('Trip score: {value}', {
                                  'value':
                                      operationMap(
                                        trip['tripScore'],
                                      )['value'] ??
                                      context.operationText('Not Available'),
                                }),
                              ),
                            if (progress.isNotEmpty) ...[
                              const SizedBox(height: 12),
                              LinearProgressIndicator(
                                value:
                                    ((progress['percent'] as num?)
                                                ?.toDouble() ??
                                            0)
                                        .clamp(0, 100) /
                                    100,
                                minHeight: 6,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                context.operationText(
                                  '{completed}/{total} stops',
                                  {
                                    'completed':
                                        progress['completedStops'] ?? 0,
                                    'total': progress['totalStops'] ?? 0,
                                  },
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      UserOperationRouteMap(
                        data: UserOperationMapData.fromJson(trip),
                        tripId: widget.id,
                      ),
                      if (operationItems(trip['attention']).isNotEmpty) ...[
                        const SizedBox(height: 16),
                        OpenVtsCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.operationText('Needs attention'),
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              ...operationItems(trip['attention']).map((item) {
                                final eventId = item['eventId']?.toString();
                                return Padding(
                                  padding: const EdgeInsets.only(top: 12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        operationLabel(
                                          context,
                                          '${item['code'] ?? ''}',
                                        ),
                                      ),
                                      Text(
                                        date(item['startedAt']),
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodySmall,
                                      ),
                                      if (item['acknowledgedAt'] != null)
                                        Text(
                                          context.operationText('Acknowledged'),
                                        )
                                      else if (eventId != null)
                                        TextButton.icon(
                                          onPressed:
                                              _saving ||
                                                  _acknowledging.contains(
                                                    eventId,
                                                  )
                                              ? null
                                              : () => _acknowledge(eventId),
                                          icon: const Icon(
                                            Icons.done_all_rounded,
                                          ),
                                          label: Text(
                                            context.operationText(
                                              'Acknowledge',
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                      Text(
                        context.operationText('Dispatcher actions'),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: actions
                            .map(
                              (action) => OutlinedButton(
                                onPressed: _saving || trip['version'] is! num
                                    ? null
                                    : () => _override(trip, action),
                                child: Text(operationLabel(context, action)),
                              ),
                            )
                            .toList(),
                      ),
                      if (_saving) const LinearProgressIndicator(),
                      const SizedBox(height: 20),
                      Text(
                        context.operationText('Stops'),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      ...operationItems(data['stops'] ?? trip['stops']).map(
                        (stop) => ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            child: Text('${stop['sequence'] ?? ''}'),
                          ),
                          title: Text(
                            '${stop['name'] ?? context.operationText('Stop')}',
                          ),
                          subtitle: Text(
                            '${operationLabel(context, '${stop['status'] ?? ''}')}\n${stop['address'] ?? ''}',
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        context.operationText('Activity'),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      if (operationItems(
                        data['events'] ?? trip['events'],
                      ).isEmpty)
                        Text(context.operationText('No activity yet.')),
                      ...operationItems(data['events'] ?? trip['events']).map(
                        (event) => ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(
                            event['severity'] == 'CRITICAL'
                                ? Icons.error_outline_rounded
                                : Icons.history_rounded,
                          ),
                          title: Text(
                            operationLabel(
                              context,
                              '${event['eventType'] ?? event['type'] ?? ''}',
                            ),
                          ),
                          subtitle: Text(
                            [
                              if (event['note'] != null) '${event['note']}',
                              if (event['source'] != null)
                                operationLabel(context, '${event['source']}'),
                              date(event['occurredAt'] ?? event['createdAt']),
                            ].join('\n'),
                          ),
                        ),
                      ),
                      if (operationItems(trip['proofs']).isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Text(
                          context.operationText('Submitted proofs'),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        ...operationItems(trip['proofs']).map(
                          (proof) => ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.attachment),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => _openProof(proof),
                            title: Text(
                              '${proof['title'] ?? proof['originalFileName'] ?? context.operationText('Proof')}',
                            ),
                            subtitle: Text(
                              '${proof['note'] ?? ''}\n${date(proof['createdAt'])}',
                            ),
                          ),
                        ),
                      ],
                    ],
                  );
                },
              ),
        ),
      ),
    ),
  );

  Future<void> _acknowledge(String id) async {
    if (_acknowledging.contains(id)) return;
    setState(() => _acknowledging.add(id));
    try {
      await ref.read(userOperationsActionsProvider).acknowledgeEvent(id);
      if (mounted) ref.invalidate(userOperationTripProvider(widget.id));
    } catch (error) {
      if (mounted) {
        ToastHelper.showError(operationError(context, error), context: context);
      }
    } finally {
      if (mounted) setState(() => _acknowledging.remove(id));
    }
  }

  void _openProof(Map<String, dynamic> json) {
    try {
      final proof = UserOperationProof.fromJson(widget.id, json);
      Navigator.of(context).push<void>(
        MaterialPageRoute(
          builder: (_) => UserOperationProofScreen(proof: proof),
        ),
      );
    } on FormatException catch (error) {
      ToastHelper.showError(error.message, context: context);
    }
  }

  Future<void> _override(Map<String, dynamic> trip, String action) async {
    final reason = await showDialog<String>(
      context: context,
      builder: (_) => _ReasonDialog(action: action),
    );
    if (reason == null || !mounted) return;
    setState(() => _saving = true);
    try {
      await ref
          .read(userOperationsActionsProvider)
          .overrideTrip(
            widget.id,
            action: action,
            reason: reason,
            version: (trip['version'] as num).toInt(),
          );
      if (mounted) ref.invalidate(userOperationTripProvider(widget.id));
    } catch (e) {
      if (mounted) {
        ToastHelper.showError(operationError(context, e), context: context);
        // Always refetch after conflict, so a stale version cannot be resubmitted.
        ref.invalidate(userOperationTripProvider(widget.id));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}

class _ReasonDialog extends StatefulWidget {
  const _ReasonDialog({required this.action});
  final String action;
  @override
  State<_ReasonDialog> createState() => _ReasonDialogState();
}

class _ReasonDialogState extends State<_ReasonDialog> {
  final _reason = TextEditingController();
  final _form = GlobalKey<FormState>();
  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(operationLabel(context, widget.action)),
    scrollable: true,
    content: Form(
      key: _form,
      child: TextFormField(
        controller: _reason,
        autofocus: true,
        maxLines: 3,
        maxLength: 600,
        decoration: InputDecoration(
          labelText: context.operationText('Reason / remark'),
        ),
        validator: context.localizedValidator((v) => (v?.trim().length ?? 0) < 3 ? context.operationText('Enter at least 3 characters') : null),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text(context.operationText('Back')),
      ),
      FilledButton(
        onPressed: () {
          if (_form.currentState!.validate()) {
            Navigator.pop(context, _reason.text.trim());
          }
        },
        child: Text(context.operationText('Confirm')),
      ),
    ],
  );
}
