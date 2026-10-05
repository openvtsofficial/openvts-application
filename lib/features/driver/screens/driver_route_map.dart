import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../shared/helpers/mobile_text.dart';
import '../models/driver_workspace_models.dart';

/// Road map source matches the existing app. Position comes from vehicle telemetry.
class DriverRouteMap extends StatelessWidget {
  const DriverRouteMap({super.key, required this.trip});
  final DriverTrip trip;
  LatLng? _point(dynamic latitude, dynamic longitude) {
    final lat = double.tryParse('$latitude'),
        lon = double.tryParse('$longitude');
    if (lat == null ||
        lon == null ||
        !lat.isFinite ||
        !lon.isFinite ||
        lat.abs() > 90 ||
        lon.abs() > 180) {
      return null;
    }
    return LatLng(lat, lon);
  }

  @override
  Widget build(BuildContext context) {
    final points = trip.stops
        .map((s) => _point(s.latitude, s.longitude))
        .whereType<LatLng>()
        .toList();
    final position = driverMap(trip.raw['currentPosition']),
        geometry = driverMap(trip.raw['routeGeometry'])['coordinates'];
    final live = _point(position['latitude'], position['longitude']);
    final route = <LatLng>[];
    if (geometry is List) {
      for (final coordinate in geometry) {
        if (coordinate is List && coordinate.length >= 2) {
          final point = _point(coordinate[1], coordinate[0]);
          if (point != null) route.add(point);
        }
      }
    }
    final bounds = [...points, ...route, if (live != null) live];
    if (bounds.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      height: 240,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: FlutterMap(
          key: ValueKey(trip.id),
          options: MapOptions(
            initialCenter: bounds.first,
            initialZoom: 13,
            initialCameraFit: bounds.length > 1
                ? CameraFit.bounds(
                    bounds: LatLngBounds.fromPoints(bounds),
                    padding: const EdgeInsets.all(40),
                    maxZoom: 16,
                  )
                : null,
            minZoom: 2,
            maxZoom: 19,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
            ),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://{s}.google.com/vt/lyrs=m&x={x}&y={y}&z={z}',
              subdomains: const ['mt0', 'mt1', 'mt2', 'mt3'],
              userAgentPackageName: 'com.openvts.mobile',
            ),
            // Without routed geometry show stops only, not a misleading straight route.
            if (route.length > 1)
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: route,
                    strokeWidth: 4,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ],
              ),
            MarkerLayer(
              markers: [
                for (final stop in trip.stops)
                  if (_point(stop.latitude, stop.longitude)
                      case final LatLng point)
                    Marker(
                      point: point,
                      width: 34,
                      height: 34,
                      child: Tooltip(
                        message: '${stop.sequence}. ${stop.name}',
                        child: CircleAvatar(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.surface,
                          foregroundColor: Theme.of(
                            context,
                          ).colorScheme.onSurface,
                          child: Text(
                            '${stop.sequence}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                if (live != null)
                  Marker(
                    point: live,
                    width: 42,
                    height: 42,
                    child: Tooltip(
                      message: context.mobileText('Vehicle position'),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context).colorScheme.surface,
                            width: 3,
                          ),
                        ),
                        child: Icon(
                          Icons.local_shipping,
                          color: Theme.of(context).colorScheme.onPrimary,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: ColoredBox(
                color: Colors.white70,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  child: Text(
                    context.mobileText('Map data © Google'),
                    style: const TextStyle(fontSize: 10, color: Colors.black),
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
