import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../controllers/user_operations_providers.dart';
import '../../models/user_operation_map.dart';
import 'operations_localizations.dart';
import 'operations_ui.dart';
import 'user_operation_refresh_scope.dart';

class UserOperationRouteMap extends StatefulWidget {
  const UserOperationRouteMap({
    super.key,
    required this.data,
    this.expanded = false,
    this.tileProvider,
    this.tripId,
  });
  final UserOperationMapData data;
  final bool expanded;
  final TileProvider? tileProvider;
  final String? tripId;
  @override
  State<UserOperationRouteMap> createState() => _UserOperationRouteMapState();
}

class _UserOperationRouteMapState extends State<UserOperationRouteMap> {
  final _map = MapController();
  @override
  void dispose() {
    _map.dispose();
    super.dispose();
  }

  CameraFit? get _fit {
    final points = widget.data.bounds;
    if (points.length < 2 || points.every((p) => p == points.first)) {
      return null;
    }
    return CameraFit.bounds(
      bounds: LatLngBounds.fromPoints(points),
      padding: const EdgeInsets.all(42),
      maxZoom: 16,
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.data;
    if (data.bounds.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(
          context.operationText(
            'No route or GPS coordinates are available for this trip.',
          ),
        ),
      );
    }
    final colors = Theme.of(context).colorScheme;
    final map = ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: FlutterMap(
        mapController: _map,
        options: MapOptions(
          initialCenter: data.bounds.first,
          initialZoom: 13,
          initialCameraFit: _fit,
          minZoom: 2,
          maxZoom: 19,
          interactionOptions: InteractionOptions(
            flags: widget.expanded
                ? InteractiveFlag.all & ~InteractiveFlag.rotate
                : InteractiveFlag.pinchZoom | InteractiveFlag.doubleTapZoom,
          ),
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.google.com/vt/lyrs=m&x={x}&y={y}&z={z}',
            subdomains: const ['mt0', 'mt1', 'mt2', 'mt3'],
            userAgentPackageName: 'com.openvts.mobile',
            tileProvider: widget.tileProvider,
          ),
          if (data.route.length > 1)
            PolylineLayer(
              polylines: [
                Polyline(
                  points: data.route,
                  strokeWidth: 4,
                  color: colors.primary,
                  pattern: data.exactRoute
                      ? const StrokePattern.solid()
                      : StrokePattern.dashed(segments: const [10, 7]),
                ),
              ],
            ),
          MarkerLayer(
            markers: [
              for (final stop in data.stops)
                Marker(
                  point: stop.point,
                  width: 34,
                  height: 34,
                  child: Tooltip(
                    message:
                        '${stop.sequence}. ${stop.name} • ${operationLabel(context, stop.status)}',
                    child: CircleAvatar(
                      backgroundColor: colors.surface,
                      foregroundColor: colors.onSurface,
                      child: Text(
                        '${stop.sequence}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              if (data.position case final LatLng point)
                Marker(
                  point: point,
                  width: 44,
                  height: 44,
                  child: Tooltip(
                    message: data.trackingStatus == 'LIVE'
                        ? context.operationText('Vehicle GPS position')
                        : context.operationText('Last known vehicle position'),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: data.trackingStatus == 'LIVE'
                            ? colors.primary
                            : colors.onSurfaceVariant,
                        border: Border.all(color: colors.surface, width: 3),
                      ),
                      child: Icon(
                        Icons.local_shipping,
                        size: 22,
                        color: colors.onPrimary,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Positioned(
            top: 6,
            right: 6,
            child: Row(
              children: [
                IconButton.filledTonal(
                  tooltip: context.operationText('Fit route'),
                  icon: const Icon(Icons.center_focus_strong),
                  onPressed: () {
                    final fit = _fit;
                    if (fit == null) {
                      _map.move(data.bounds.first, 13);
                    } else {
                      _map.fitCamera(fit);
                    }
                  },
                ),
                if (!widget.expanded)
                  IconButton.filledTonal(
                    tooltip: context.operationText('Expand route map'),
                    icon: const Icon(Icons.fullscreen),
                    onPressed: () => Navigator.of(context).push<void>(
                      MaterialPageRoute(
                        builder: (_) => _ExpandedOperationMap(
                          tripId: widget.tripId,
                          initialData: data,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const Align(
            alignment: Alignment.bottomRight,
            child: ColoredBox(
              color: Colors.white70,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                child: Text(
                  'Map data © Google',
                  style: TextStyle(fontSize: 10, color: Colors.black),
                ),
              ),
            ),
          ),
        ],
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.expanded)
          Expanded(child: map)
        else
          SizedBox(height: 270, child: map),
        const SizedBox(height: 8),
        Text(
          data.route.length > 1
              ? data.exactRoute
                    ? context.operationText('Planned route • numbered stops')
                    : context.operationText(
                        'Approximate stop sequence • numbered stops',
                      )
              : context.operationText(
                  'Numbered stops • route geometry unavailable',
                ),
        ),
        if (data.position != null)
          Text(
            '${context.operationText('Vehicle GPS: {status}', {'status': operationLabel(context, data.trackingStatus)})} • ${operationDate(data.recordedAt?.toIso8601String(), timezone: data.timezone, context: context)}',
          ),
      ],
    );
  }
}

class _ExpandedOperationMap extends ConsumerWidget {
  const _ExpandedOperationMap({
    required this.tripId,
    required this.initialData,
  });
  final String? tripId;
  final UserOperationMapData initialData;
  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
    appBar: AppBar(title: Text(context.operationText('Trip route'))),
    body: SafeArea(
      child: UserOperationRefreshScope(
        onRefresh: () {
          if (tripId != null) {
            ref.invalidate(userOperationTripProvider(tripId!));
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: tripId == null
              ? UserOperationRouteMap(data: initialData, expanded: true)
              : ref
                    .watch(userOperationTripProvider(tripId!))
                    .when(
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (error, _) =>
                          Center(child: Text(operationError(context, error))),
                      data: (trip) => UserOperationRouteMap(
                        data: UserOperationMapData.fromJson(trip),
                        expanded: true,
                      ),
                    ),
        ),
      ),
    ),
  );
}
