import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/access/workspace_scope_provider.dart';
import '../../../../core/api/road_routing_client.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/models/user_role.dart';
import '../../../../shared/widgets/open_vts_button.dart';
import '../../../../shared/widgets/open_vts_text_field.dart';
import '../../../auth/controllers/auth_controller.dart';
import '../../controllers/user_providers.dart';
import '../../controllers/user_route_builder_controller.dart';
import '../../models/user_landmark_model.dart';
import '../../models/user_route_stop.dart';
import '../../services/user_route_builder_service.dart';
import '../../services/user_route_optimizer.dart';
import 'user_operation_route_inputs.dart';

final userRouteBuilderMapProvider =
    Provider<Widget Function(List<UserRouteStop>, List<UserGeoPoint>)>(
      (_) =>
          (stops, geometry) =>
              UserOperationBuilderMap(stops: stops, geometry: geometry),
    );

/// Mobile counterpart of the web EnterpriseRouteBuilder. Stops, source IDs and
/// the actual road geometry are persisted independently for Operations.
class UserOperationRouteBuilderScreen extends ConsumerStatefulWidget {
  const UserOperationRouteBuilderScreen({super.key, this.initialRoute});
  final UserRouteLandmark? initialRoute;
  @override
  ConsumerState<UserOperationRouteBuilderScreen> createState() =>
      _RouteBuilderState();
}

class _RouteBuilderState
    extends ConsumerState<UserOperationRouteBuilderScreen> {
  final _name = TextEditingController();
  final _form = GlobalKey<FormState>();
  List<UserRouteStop> _stops = [];
  UserRoadRoute? _road;
  List<UserGeoPoint> _savedGeometry = [];
  UserRouteLandmark? _initial;
  RoadRoutingRequest? _routeCancel;
  bool _roundTrip = false,
      _routing = false,
      _saving = false,
      _loading = false,
      _dirty = false;
  bool _allowPop = false;
  int _revision = 0;
  String? _errorKey;
  late final String _principal;
  AppLocalizations get l => AppLocalizations.of(context);
  bool get _busy => _routing || _saving || _loading;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authControllerProvider).user;
    _principal = '${user?.role.name}:${user?.id}';
    _initial = widget.initialRoute;
    if (_initial != null) {
      _hydrate(_initial!);
      _loading = true;
      Future.microtask(_loadDetails);
    }
    _name.addListener(() {
      _dirty = true;
    });
  }

  Future<void> _loadDetails() async {
    if (!_canEdit) {
      if (mounted) {
        setState(() {
          _loading = false;
          _errorKey = 'access';
        });
      }
      return;
    }
    try {
      final route = await ref
          .read(userRouteBuilderControllerProvider)
          .load(widget.initialRoute!.id);
      if (!mounted) return;
      setState(() {
        _initial = route;
        _hydrate(route);
        _loading = false;
        _dirty = false;
      });
    } catch (_) {
      if (mounted) {
        setState(() {
          _loading = false;
          _errorKey = 'load';
        });
      }
    }
  }

  void _hydrate(UserRouteLandmark route) {
    _name.text = route.name;
    _stops = [...route.stops];
    final regular = _stops.where((s) => !s.isVia).toList();
    if (regular.length >= 3 &&
        (regular.first.latitude - regular.last.latitude).abs() < 0.000001 &&
        (regular.first.longitude - regular.last.longitude).abs() < 0.000001) {
      _roundTrip = true;
      _stops.remove(regular.last);
    }
    _savedGeometry = route.geodata?.coordinates ?? [];
    if (_savedGeometry.any(
      (p) =>
          !p.lat.isFinite ||
          !p.lon.isFinite ||
          p.lat.abs() > 90 ||
          p.lon.abs() > 180,
    )) {
      _savedGeometry = [];
    }
    if (_stops.isEmpty && _savedGeometry.length >= 2) {
      _stops = [
        UserRouteStop(
          name: route.name,
          latitude: _savedGeometry.first.lat,
          longitude: _savedGeometry.first.lon,
          sourceType: 'MAP',
        ),
        UserRouteStop(
          name: route.name,
          latitude: _savedGeometry.last.lat,
          longitude: _savedGeometry.last.lon,
          sourceType: 'MAP',
        ),
      ];
    }
  }

  @override
  void dispose() {
    _routeCancel?.cancel();
    _name.dispose();
    super.dispose();
  }

  void _change(VoidCallback action) {
    _routeCancel?.cancel();
    setState(() {
      action();
      // Shape points belong to a segment between operational stops. Removing
      // an endpoint also removes any shape controls orphaned by that deletion.
      while (_stops.isNotEmpty && _stops.first.isVia) {
        _stops.removeAt(0);
      }
      while (!_roundTrip && _stops.isNotEmpty && _stops.last.isVia) {
        _stops.removeLast();
      }
      _revision++;
      _road = null;
      _savedGeometry = [];
      _errorKey = null;
      _dirty = true;
      _routing = false;
    });
  }

  bool get _canUseLandmarks {
    final user = ref.read(authControllerProvider).user;
    return user != null && user.access.canFeature(user.role, 'landmarks');
  }

  bool get _canEdit {
    final user = ref.read(authControllerProvider).user;
    return user != null &&
        user.accessLoaded &&
        '${user.role.name}:${user.id}' == _principal &&
        user.role.isUserWorkspace &&
        (user.access.canFeature(user.role, 'landmarks') ||
            (user.role == UserRole.user &&
                user.access.canFeature(user.role, 'routeOptimization')));
  }

  Future<void> _add({int? editIndex}) async {
    if (_busy) return;
    if (editIndex == null && _stops.length + (_roundTrip ? 1 : 0) >= 100) {
      setState(() => _errorKey = 'limit');
      return;
    }
    final result = await UserOperationRouteInputs.show(
      context: context,
      ref: ref,
      existing: editIndex == null ? null : _stops[editIndex],
      allowLandmarks: _canUseLandmarks,
      mapCenter: _stops.isEmpty
          ? null
          : LatLng(_stops.last.latitude, _stops.last.longitude),
    );
    if (result == null || !mounted) return;
    _change(() {
      if (editIndex == null) {
        _stops.add(result);
      } else {
        _stops[editIndex] = result;
      }
    });
  }

  Future<void> _optimize() async {
    if (_busy) return;
    try {
      routeStopsForSave(_stops, roundTrip: _roundTrip);
    } catch (_) {
      setState(() => _errorKey = 'minimum');
      return;
    }
    _change(() {});
    setState(() => _routing = true);
    final revision = _revision;
    try {
      final input = List<UserRouteStop>.of(_stops), roundTrip = _roundTrip;
      final optimized = await compute(_optimizeMessage, (
        stops: input,
        roundTrip: roundTrip,
      ));
      if (!mounted || revision != _revision) return;
      setState(() {
        _stops = optimized;
        _routing = false;
      });
      await _calculate();
    } catch (_) {
      if (mounted && revision == _revision) {
        setState(() {
          _routing = false;
          _errorKey = 'road';
        });
      }
    }
  }

  Future<bool> _calculate() async {
    List<UserRouteStop> stops;
    try {
      stops = routeStopsForSave(_stops, roundTrip: _roundTrip);
    } catch (_) {
      setState(
        () => _errorKey = _stops.length + (_roundTrip ? 1 : 0) > 100
            ? 'limit'
            : 'minimum',
      );
      return false;
    }
    _routeCancel?.cancel();
    final token = _routeCancel = RoadRoutingRequest(), revision = _revision;
    setState(() {
      _routing = true;
      _errorKey = null;
    });
    try {
      final road = await ref
          .read(userRouteBuilderControllerProvider)
          .road(stops, request: token);
      if (!mounted || revision != _revision || token.isCancelled) return false;
      setState(() {
        _road = road;
        _routing = false;
      });
      return true;
    } catch (_) {
      if (mounted && revision == _revision && !token.isCancelled) {
        setState(() {
          _routing = false;
          _errorKey = 'road';
        });
      }
      return false;
    }
  }

  Future<void> _save() async {
    if (_busy || !_form.currentState!.validate()) return;
    if (!_canEdit) {
      setState(() => _errorKey = 'access');
      return;
    }
    // Edits invalidate geometry immediately; never save an unrouted line.
    if (_road == null && _savedGeometry.length < 2 && !await _calculate()) {
      return;
    }
    if (!mounted || !_canEdit) return;
    final geometry = _road?.points ?? _savedGeometry;
    List<UserRouteStop> stops;
    try {
      stops = routeStopsForSave(_stops, roundTrip: _roundTrip);
    } catch (_) {
      setState(() => _errorKey = 'minimum');
      return;
    }
    setState(() {
      _saving = true;
      _errorKey = null;
    });
    try {
      final route = await ref
          .read(userRouteBuilderControllerProvider)
          .save(
            name: _name.text,
            stops: stops,
            geometry: geometry,
            existing: _initial,
          );
      if (!mounted) return;
      if (route.id.trim().isEmpty) {
        throw const FormatException('Missing saved route id');
      }
      ref.invalidate(userRoutesControllerProvider);
      setState(() {
        _dirty = false;
        _allowPop = true;
      });
      Navigator.of(context).pop(route);
    } catch (_) {
      if (mounted) {
        setState(() {
          _saving = false;
          _errorKey = 'save';
        });
      }
    }
  }

  Future<void> _close() async {
    if (_saving) return;
    if (_dirty) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(l.routeBuilderDiscardTitle),
          content: Text(l.routeBuilderDiscardMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(l.routeBuilderKeepEditing),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(l.routeBuilderDiscard),
            ),
          ],
        ),
      );
      if (confirmed != true || !mounted) return;
    }
    _routeCancel?.cancel();
    setState(() => _allowPop = true);
    Navigator.of(context).pop();
  }

  String? get _error => switch (_errorKey) {
    'road' => l.routeBuilderRoutingError,
    'save' => l.routeBuilderSaveError,
    'minimum' => l.routeBuilderMinimumStops,
    'limit' => l.routeBuilderStopLimit,
    'access' => l.routeBuilderAccessDenied,
    'load' => l.routeBuilderEditingLoadError,
    _ => null,
  };

  @override
  Widget build(BuildContext context) {
    ref.watch(authControllerProvider.select((state) => state.user));
    ref.listen(workspaceDataScopeProvider, (previous, next) {
      if (previous == next) return;
      _routeCancel?.cancel();
      if (!_canEdit && mounted) {
        setState(() {
          _revision++;
          _routing = false;
          _road = null;
          _errorKey = 'access';
        });
      }
    });
    final allowed = _canEdit;
    if (allowed) ref.watch(userRouteBuilderControllerProvider);
    final color = Theme.of(context).colorScheme;
    final geometry = _road?.points ?? _savedGeometry;
    final hasGeometry = geometry.length >= 2;
    return PopScope(
      canPop: _allowPop || (!_dirty && !_saving),
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _close();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            _initial == null ? l.routeBuilderCreate : l.routeBuilderEdit,
          ),
          leading: IconButton(
            onPressed: _saving ? null : _close,
            tooltip: l.routeBuilderClose,
            icon: const Icon(Icons.close),
          ),
        ),
        body: !allowed
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(l.routeBuilderAccessDenied),
                ),
              )
            : _loading
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: _form,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    OpenVtsTextField(
                      label: l.routeBuilderName,
                      controller: _name,
                      hintText: l.routeBuilderNameHint,
                      validator: (v) => (v?.trim().length ?? 0) < 2
                          ? l.routeBuilderNameError
                          : null,
                    ),
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: SizedBox(
                        height: 240,
                        child: ref.watch(userRouteBuilderMapProvider)(
                          _stops,
                          geometry,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l.routeBuilderMapAttribution,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    if (_road != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          '${l.routeBuilderReady} · ${(_road!.distanceMeters / 1000).toStringAsFixed(1)} ${l.routeBuilderDistanceUnit} · ${(_road!.durationSeconds / 60).ceil()} ${l.routeBuilderMinutes}',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: color.primary),
                        ),
                      ),
                    if (_road == null && hasGeometry)
                      Text(l.routeBuilderSavedGeometry),
                    if (!hasGeometry && _stops.length >= 2)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(l.routeBuilderChanged),
                      ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            l.routeBuilderStops,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: _busy || _errorKey == 'load'
                              ? null
                              : () => _add(),
                          icon: const Icon(Icons.add),
                          label: Text(l.routeBuilderAddStop),
                        ),
                      ],
                    ),
                    if (_stops.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Text(l.routeBuilderNoStops),
                      ),
                    for (var i = 0; i < _stops.length; i++) _stopTile(i),
                    if (_stops.any((s) => s.isVia))
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(l.routeBuilderShapeHint),
                      ),
                    const SizedBox(height: 12),
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      title: Text(l.routeBuilderRoundTrip),
                      subtitle: Text(l.routeBuilderRoundTripHint),
                      value: _roundTrip,
                      onChanged: _busy || _errorKey == 'load'
                          ? null
                          : (v) => _change(() => _roundTrip = v),
                    ),
                    const SizedBox(height: 8),
                    OpenVtsButton(
                      label: l.routeBuilderOptimize,
                      onPressed:
                          _busy || _stops.length < 2 || _errorKey == 'load'
                          ? null
                          : _optimize,
                      variant: OpenVtsButtonVariant.secondary,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l.routeBuilderOptimizeHint,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 12),
                    OpenVtsButton(
                      label: _routing
                          ? l.routeBuilderRouting
                          : l.routeBuilderRoadPath,
                      onPressed:
                          _busy || _stops.length < 2 || _errorKey == 'load'
                          ? null
                          : _calculate,
                      variant: OpenVtsButtonVariant.secondary,
                      isLoading: _routing,
                    ),
                    if (_error != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Semantics(
                          liveRegion: true,
                          child: Text(
                            _error!,
                            style: TextStyle(color: color.error),
                          ),
                        ),
                      ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
        bottomNavigationBar: allowed
            ? SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: OpenVtsButton(
                    label: l.save,
                    isLoading: _saving,
                    onPressed: _busy || _stops.length < 2 || _errorKey == 'load'
                        ? null
                        : _save,
                  ),
                ),
              )
            : null,
      ),
    );
  }

  Widget _stopTile(int index) {
    final stop = _stops[index];
    final regular = _stops.where((s) => !s.isVia).toList();
    final label = stop.isVia
        ? l.routeBuilderShapePoint
        : stop == regular.first
        ? l.routeBuilderOrigin
        : !_roundTrip && stop == regular.last
        ? l.routeBuilderDestination
        : l.routeBuilderWaypoint;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 4, 8),
        child: Row(
          children: [
            CircleAvatar(radius: 17, child: Text('${index + 1}')),
            const SizedBox(width: 12),
            Expanded(
              child: InkWell(
                onTap: _busy || _errorKey == 'load'
                    ? null
                    : () => _add(editIndex: index),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stop.name,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Text(
                        '$label · ${stop.latitude.toStringAsFixed(5)}, ${stop.longitude.toStringAsFixed(5)}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            PopupMenuButton<String>(
              enabled: !_busy && _errorKey != 'load',
              tooltip: l.routeBuilderEditStop,
              onSelected: (action) {
                if (action == 'edit') {
                  _add(editIndex: index);
                  return;
                }
                _change(() {
                  if (action == 'remove') {
                    _stops.removeAt(index);
                  } else {
                    final target = action == 'up' ? index - 1 : index + 1;
                    final stop = _stops.removeAt(index);
                    _stops.insert(target, stop);
                  }
                });
              },
              itemBuilder: (_) => [
                PopupMenuItem(
                  value: 'edit',
                  child: Text(l.routeBuilderEditStop),
                ),
                if (index > 0)
                  PopupMenuItem(value: 'up', child: Text(l.routeBuilderMoveUp)),
                if (index + 1 < _stops.length)
                  PopupMenuItem(
                    value: 'down',
                    child: Text(l.routeBuilderMoveDown),
                  ),
                PopupMenuItem(
                  value: 'remove',
                  child: Text(l.routeBuilderRemove),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

List<UserRouteStop> _optimizeMessage(
  ({List<UserRouteStop> stops, bool roundTrip}) input,
) => optimizeUserRouteStops(input.stops, roundTrip: input.roundTrip);

class UserOperationBuilderMap extends StatelessWidget {
  const UserOperationBuilderMap({
    super.key,
    required this.stops,
    required this.geometry,
  });
  final List<UserRouteStop> stops;
  final List<UserGeoPoint> geometry;
  @override
  Widget build(BuildContext context) {
    final points = geometry.isNotEmpty
        ? geometry.map((p) => p.toLatLng()).toList()
        : stops
              .where((s) => s.validCoordinates)
              .map((s) => LatLng(s.latitude, s.longitude))
              .toList();
    final color = Theme.of(context).colorScheme.primary;
    // No line is rendered until the routing provider returns actual geometry.
    return FlutterMap(
      key: ValueKey(
        Object.hashAll(points.map((p) => '${p.latitude},${p.longitude}')),
      ),
      options: MapOptions(
        initialCenter: points.isEmpty
            ? const LatLng(20.59, 78.96)
            : points.first,
        initialZoom: points.isEmpty ? 4 : 12,
        initialCameraFit: points.length >= 2
            ? CameraFit.bounds(
                bounds: LatLngBounds.fromPoints(points),
                padding: const EdgeInsets.all(34),
                maxZoom: 15,
              )
            : null,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.openvts.mobile',
        ),
        if (geometry.length >= 2)
          PolylineLayer(
            polylines: [
              Polyline(
                points: geometry.map((p) => p.toLatLng()).toList(),
                color: color,
                strokeWidth: 4,
              ),
            ],
          ),
        MarkerLayer(
          markers: [
            for (var i = 0; i < stops.length; i++)
              if (stops[i].validCoordinates)
                Marker(
                  point: LatLng(stops[i].latitude, stops[i].longitude),
                  width: 30,
                  height: 30,
                  child: CircleAvatar(
                    backgroundColor: color,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    child: Text(
                      '${i + 1}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
          ],
        ),
      ],
    );
  }
}
