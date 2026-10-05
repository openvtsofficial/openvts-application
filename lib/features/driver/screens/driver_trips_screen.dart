import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/errors/error_mapper.dart';
import '../../../core/utils/date_time_formatter.dart';
import '../../../core/utils/unit_formatter.dart';
import '../../../shared/helpers/mobile_text.dart';
import '../../../shared/widgets/open_vts_page_scaffold.dart';
import '../controllers/driver_actions_controller.dart';
import '../controllers/driver_providers.dart';
import '../models/driver_workspace_models.dart';
import 'driver_route_map.dart';
import 'driver_upload_sheet.dart';
import 'driver_widgets.dart';

Future<void> openDriverTrip(BuildContext context, String id) async {
  await Navigator.of(context).push<void>(
    MaterialPageRoute(builder: (_) => DriverTripDetailScreen(tripId: id)),
  );
}

class DriverTripsScreen extends ConsumerStatefulWidget {
  const DriverTripsScreen({super.key});
  @override
  ConsumerState<DriverTripsScreen> createState() => _DriverTripsScreenState();
}

class _DriverTripsScreenState extends ConsumerState<DriverTripsScreen> {
  String _scope = 'today', _search = '';
  int _page = 1;
  final _searchController = TextEditingController();
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = driverTripsProvider(
      DriverTripsQuery(scope: _scope, page: _page, search: _search),
    );
    final trips = ref.watch(provider);
    return DriverRefreshScope(
      onRefresh: () => ref.invalidate(provider),
      child: OpenVtsPageScaffold(
        title: context.mobileText('Trips'),
        body: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final entry in const {
                    'today': 'Today',
                    'upcoming': 'Upcoming',
                    'history': 'History',
                    'all': 'All trips',
                  }.entries)
                    Padding(
                      padding: const EdgeInsetsDirectional.only(end: 8),
                      child: ChoiceChip(
                        label: Text(context.mobileText(entry.value)),
                        selected: _scope == entry.key,
                        onSelected: (_) => setState(() {
                          _scope = entry.key;
                          _page = 1;
                        }),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _searchController,
              maxLength: 100,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                labelText: context.mobileText('Search trips'),
                counterText: '',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  tooltip: context.mobileText('Search'),
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () => setState(() {
                    _search = _searchController.text.trim();
                    _page = 1;
                  }),
                ),
              ),
              onSubmitted: (value) => setState(() {
                _search = value.trim();
                _page = 1;
              }),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: DriverAsyncBody(
                value: trips,
                onRetry: () => ref.invalidate(provider),
                builder: (data) => RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(provider);
                    await ref.read(provider.future);
                  },
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      if (data.items.isEmpty)
                        DriverEmpty(
                          context.mobileText('No trips in this view.'),
                        ),
                      for (final trip in data.items)
                        DriverTripCard(
                          trip: trip,
                          onTap: () => openDriverTrip(context, trip.id),
                        ),
                      if (data.totalPages > 1)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            children: [
                              IconButton(
                                tooltip: context.mobileText('Previous page'),
                                onPressed: _page > 1
                                    ? () => setState(() => _page--)
                                    : null,
                                icon: const Icon(Icons.chevron_left),
                              ),
                              Expanded(
                                child: Text(
                                  context.mobileText(
                                    "Page {value1} of {value2} · {value3} trips",
                                    {
                                      'value1': (_page).toString(),
                                      'value2': (data.totalPages).toString(),
                                      'value3': (data.total).toString(),
                                    },
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              IconButton(
                                tooltip: context.mobileText('Next page'),
                                onPressed: _page < data.totalPages
                                    ? () => setState(() => _page++)
                                    : null,
                                icon: const Icon(Icons.chevron_right),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DriverTripDetailScreen extends ConsumerStatefulWidget {
  const DriverTripDetailScreen({super.key, required this.tripId});
  final String tripId;
  @override
  ConsumerState<DriverTripDetailScreen> createState() =>
      _DriverTripDetailScreenState();
}

class _DriverTripDetailScreenState
    extends ConsumerState<DriverTripDetailScreen> {
  bool _busy = false;
  Future<void> _run(Future<void> Function() action, String success) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await action();
      if (!mounted) return;
      refreshDriverTrips(ref, widget.tripId);
      driverToast(context, context.mobileText(success));
    } catch (error) {
      if (mounted) {
        driverToast(context, ErrorMapper.from(error).message);
        ref.invalidate(driverTripProvider(widget.tripId));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _noteAction(
    String title,
    Future<void> Function(String) action, {
    String explanation = '',
    int minimum = 0,
    int maximum = 600,
  }) async {
    final note = await driverNoteDialog(
      context,
      title: context.mobileText(title),
      explanation: context.mobileText(explanation),
      minimum: minimum,
      maximum: maximum,
    );
    if (note != null && mounted) {
      await _run(() => action(note), context.mobileText('Changes saved'));
    }
  }

  Future<void> _exception() async {
    final reason = await showModalBottomSheet<String>(
      context: context,
      useSafeArea: true,
      builder: (context) => SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(context.mobileText('Report an issue')),
            ),
            for (final entry in const {
              'ACCESS': 'Access blocked',
              'RECIPIENT': 'Recipient unavailable',
              'VEHICLE': 'Vehicle issue',
              'ROUTE': 'Route issue',
              'OTHER': 'Other',
            }.entries)
              ListTile(
                title: Text(context.mobileText(entry.value)),
                onTap: () => Navigator.pop(context, entry.key),
              ),
          ],
        ),
      ),
    );
    if (reason == null || !mounted) return;
    await _noteAction(
      'Report issue',
      (note) => ref
          .read(driverActionsControllerProvider)
          .reportException(widget.tripId, reason, note),
      minimum: 2,
      maximum: 1000,
      explanation: 'Describe the issue for dispatch.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = driverTripProvider(widget.tripId),
        trip = ref.watch(driverTripProvider(widget.tripId));
    final formatter = ref.watch(appDateFormatterProvider),
        units = ref.watch(unitFormatterProvider);
    final service = ref.watch(driverActionsControllerProvider);
    return DriverRefreshScope(
      onRefresh: () {
        if (!_busy) ref.invalidate(provider);
      },
      child: OpenVtsPageScaffold(
        title: context.mobileText('Trip details'),
        actions: [
          IconButton(
            tooltip: context.mobileText('Refresh'),
            onPressed: _busy ? null : () => ref.invalidate(provider),
            icon: const Icon(Icons.refresh),
          ),
        ],
        body: DriverAsyncBody(
          value: trip,
          onRetry: () => ref.invalidate(provider),
          builder: (trip) => RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(provider);
              await ref.read(provider.future);
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                Text(
                  trip.referenceCode,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 6),
                Text(
                  trip.title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: DriverStatus(trip.status),
                ),
                if (_busy) const LinearProgressIndicator(),
                Text(
                  '${formatter.formatDateTime(trip.scheduledStart)} – ${formatter.formatDateTime(trip.scheduledEnd)}',
                ),
                if (trip.vehicleLabel.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(trip.vehicleLabel),
                  ),
                if (trip.instructions.isNotEmpty)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(trip.instructions),
                    ),
                  ),
                if (trip.status == 'CANCELLED')
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.cancel_outlined),
                      title: Text(context.mobileText('Trip cancelled')),
                      subtitle: Text(
                        driverText(
                          trip.raw['cancellationReason'],
                          'Contact dispatch for details.',
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (trip.canAcknowledge)
                      FilledButton.icon(
                        onPressed: _busy
                            ? null
                            : () => _run(
                                () => service.acknowledge(trip.id),
                                'Assignment acknowledged.',
                              ),
                        icon: const Icon(Icons.check),
                        label: Text(context.mobileText('Acknowledge')),
                      ),
                    if (trip.canStart)
                      OutlinedButton.icon(
                        onPressed: _busy
                            ? null
                            : () => _noteAction(
                                'Start trip',
                                (note) => service.start(trip.id, note),
                                explanation:
                                    'Trips normally start from vehicle telemetry. Use this manual fallback only when beginning the trip.',
                              ),
                        icon: const Icon(Icons.play_arrow),
                        label: Text(context.mobileText('Start manually')),
                      ),
                    OutlinedButton.icon(
                      onPressed: _busy
                          ? null
                          : () => _noteAction(
                              'Add remark',
                              (note) => service.remark(trip.id, note),
                              minimum: 2,
                              maximum: 1000,
                            ),
                      icon: const Icon(Icons.edit_note),
                      label: Text(context.mobileText('Remark')),
                    ),
                    OutlinedButton.icon(
                      onPressed: _busy ? null : _exception,
                      icon: const Icon(Icons.report_problem_outlined),
                      label: Text(context.mobileText('Report issue')),
                    ),
                    if (trip.canUploadProof)
                      OutlinedButton.icon(
                        onPressed: _busy
                            ? null
                            : () async {
                                final uploaded = await showDriverUploadSheet(
                                  context,
                                  trip: trip,
                                );
                                if (uploaded == true && mounted) {
                                  refreshDriverTrips(ref, trip.id);
                                }
                              },
                        icon: const Icon(Icons.upload_file),
                        label: Text(context.mobileText('Add proof')),
                      ),
                    if (trip.navigationUri != null)
                      OutlinedButton.icon(
                        onPressed: () async {
                          try {
                            if (!await launchUrl(
                                  trip.navigationUri!,
                                  mode: LaunchMode.externalApplication,
                                ) &&
                                context.mounted) {
                              driverToast(
                                context,
                                'Unable to open navigation.',
                              );
                            }
                          } catch (error) {
                            if (context.mounted) {
                              driverToast(
                                context,
                                ErrorMapper.from(error).message,
                              );
                            }
                          }
                        },
                        icon: const Icon(Icons.navigation_outlined),
                        label: Text(context.mobileText('Navigate')),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                DriverRouteMap(trip: trip),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 12,
                  runSpacing: 6,
                  children: [
                    if (trip.raw['remainingDistanceKm'] != null)
                      Text(
                        context.mobileText("{value1} remaining", {
                          'value1': (units.distance(
                            driverNumber(trip.raw['remainingDistanceKm']),
                          )).toString(),
                        }),
                      ),
                    if (trip.raw['etaAt'] != null)
                      Text(
                        context.mobileText("ETA {value1}", {
                          'value1': (formatter.formatDateTime(
                            DateTime.tryParse(driverText(trip.raw['etaAt'])),
                          )).toString(),
                        }),
                      ),
                    if (driverMap(trip.raw['currentPosition'])['recordedAt'] !=
                        null)
                      Text(
                        context.mobileText("Position updated {value1}", {
                          'value1': (formatter.formatDateTime(
                            DateTime.tryParse(
                              driverText(
                                driverMap(
                                  trip.raw['currentPosition'],
                                )['recordedAt'],
                              ),
                            ),
                          )).toString(),
                        }),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  context.mobileText('Route stops'),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 6),
                Text(
                  context.mobileText(
                    'Vehicle telemetry updates progress automatically. Manual completion is available for the current stop only.',
                  ),
                ),
                const SizedBox(height: 8),
                for (final stop in trip.stops)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(child: Text('${stop.sequence}')),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  stop.name,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                              ),
                            ],
                          ),
                          if (stop.address.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(stop.address),
                            ),
                          DriverStatus(stop.status),
                          if (stop.plannedAt != null)
                            Text(formatter.formatDateTime(stop.plannedAt)),
                          if (trip.canComplete(stop))
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: OutlinedButton.icon(
                                onPressed: _busy
                                    ? null
                                    : () => _noteAction(
                                        'Complete stop',
                                        (note) => service.completeStop(
                                          trip.id,
                                          stop.id,
                                          note,
                                        ),
                                        explanation:
                                            'Confirm arrival and completion at ${stop.name}. This manual fallback may complete the trip.',
                                      ),
                                icon: const Icon(Icons.task_alt),
                                label: Text(
                                  context.mobileText('Complete manually'),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                if (trip.proofs.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    context.mobileText('Trip proofs'),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  for (final proof in trip.proofs)
                    Card(
                      child: ListTile(
                        leading: const Icon(Icons.attach_file),
                        title: Text(
                          driverText(proof['title']).isEmpty
                              ? driverText(proof['originalFileName'])
                              : driverText(proof['title']),
                        ),
                        subtitle: Text(
                          '${driverText(proof['proofType'])} · ${formatter.formatDateTime(DateTime.tryParse(driverText(proof['createdAt'])))}',
                        ),
                        trailing: const Icon(Icons.ios_share),
                        onTap: () => shareDriverFile(
                          context,
                          () => service.proofContent(
                            trip.id,
                            driverText(proof['id']),
                          ),
                          driverText(proof['originalFileName'], 'proof.pdf'),
                          driverText(
                            proof['mimeType'],
                            'application/octet-stream',
                          ),
                        ),
                      ),
                    ),
                ],
                if (trip.events.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    context.mobileText('Activity'),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  for (final event in trip.events)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(driverText(event['title'])),
                      subtitle: Text(
                        [
                          driverText(event['detail']),
                          driverText(event['note']),
                          formatter.formatDateTime(
                            DateTime.tryParse(driverText(event['createdAt'])),
                          ),
                        ].where((v) => v.isNotEmpty).join('\n'),
                      ),
                    ),
                ],
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
