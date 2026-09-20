import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../../auth/controllers/auth_controller.dart';
import '../../../live_map/controllers/live_map_providers.dart';
import '../../../live_map/models/live_map_role_config.dart';
import '../../../live_map/screens/live_map_screen.dart';
import '../../models/user_landmark_model.dart';
import '../landmarks/geofences/widgets/user_geofence_form_sheet.dart';
import '../landmarks/pois/widgets/user_poi_form_sheet.dart';

/// User live-map screen.
///
/// Thin role wrapper around the shared [LiveMapScreen]. The full polished
/// telemetry / overlay / drawer / replay / history / commands UI is exactly
/// the same as the superadmin one — only the underlying endpoints, storage
/// keys, default home route, and command-send mode change, all supplied by
/// [LiveMapRoleConfig.user].
///
/// Non-demo sessions additionally expose a 2-second press-and-hold to create
/// POIs and Geofences directly from the map canvas.
class UserMapScreen extends ConsumerWidget {
  const UserMapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDemo = ref.watch(
      authControllerProvider.select((state) => state.isDemo),
    );
    return LiveMapScreen(
      config: isDemo ? LiveMapRoleConfig.demo() : LiveMapRoleConfig.user(),
      onCreatePoiAt: isDemo ? null : (point) => _createPoi(context, ref, point),
      onCreateGeofenceAt:
          isDemo ? null : (point) => _createGeofence(context, ref, point),
    );
  }

  Future<void> _createPoi(
    BuildContext context,
    WidgetRef ref,
    LatLng point,
  ) async {
    final created = await UserPoiFormSheet.show(
      context: context,
      initialCoordinates:
          UserGeoPoint(lat: point.latitude, lon: point.longitude),
    );
    if (created == null) return;
    // Invalidate the live-map POI overlay so the new POI appears immediately.
    ref.invalidate(liveMapPoisProvider);
  }

  Future<void> _createGeofence(
    BuildContext context,
    WidgetRef ref,
    LatLng point,
  ) async {
    final created = await UserGeofenceFormSheet.show(
      context: context,
      initialCenter: point,
    );
    if (created == null) return;
    // Invalidate the live-map Geofence overlay so the new geofence appears immediately.
    ref.invalidate(liveMapGeofencesProvider);
  }
}
