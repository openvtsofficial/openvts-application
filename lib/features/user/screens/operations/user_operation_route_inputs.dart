import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/open_vts_button.dart';
import '../../../../shared/widgets/open_vts_text_field.dart';
import '../../controllers/user_route_builder_controller.dart';
import '../../models/user_route_stop.dart';

class UserOperationRouteInputs {
  static Future<UserRouteStop?> show({
    required BuildContext context,
    required WidgetRef ref,
    required bool allowLandmarks,
    UserRouteStop? existing,
    LatLng? mapCenter,
  }) async {
    if (existing != null) return _details(context, existing);
    final l = AppLocalizations.of(context);
    final source = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                l.routeBuilderChooseSource,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.map_outlined),
              title: Text(l.routeBuilderMap),
              onTap: () => Navigator.pop(ctx, 'map'),
            ),
            ListTile(
              leading: const Icon(Icons.my_location),
              title: Text(l.routeBuilderCoordinates),
              onTap: () => Navigator.pop(ctx, 'manual'),
            ),
            ListTile(
              enabled: allowLandmarks,
              leading: const Icon(Icons.place_outlined),
              title: Text(l.routeBuilderPoi),
              onTap: () => Navigator.pop(ctx, 'poi'),
            ),
            ListTile(
              enabled: allowLandmarks,
              leading: const Icon(Icons.hexagon_outlined),
              title: Text(l.routeBuilderGeofence),
              onTap: () => Navigator.pop(ctx, 'geofence'),
            ),
            if (!allowLandmarks)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(l.routeBuilderLandmarksPermission),
              ),
          ],
        ),
      ),
    );
    if (source == null || !context.mounted) return null;
    if (source == 'manual') return _details(context, null);
    if (source == 'map') {
      final point = await Navigator.of(context).push<LatLng>(
        MaterialPageRoute(
          builder: (_) => UserOperationRouteMapPicker(initialPoint: mapCenter),
        ),
      );
      if (point == null || !context.mounted) return null;
      return _details(
        context,
        UserRouteStop(
          name: '',
          latitude: point.latitude,
          longitude: point.longitude,
          sourceType: 'MAP',
        ),
      );
    }
    final stop = await showModalBottomSheet<UserRouteStop>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (ctx) => _LandmarkPicker(geofences: source == 'geofence'),
    );
    if (stop == null || !context.mounted) return null;
    return _details(context, stop);
  }

  static Future<UserRouteStop?> _details(
    BuildContext context,
    UserRouteStop? stop,
  ) => showModalBottomSheet<UserRouteStop>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => UserOperationRouteStopForm(existing: stop),
  );
}

class UserOperationRouteStopForm extends StatefulWidget {
  const UserOperationRouteStopForm({super.key, this.existing});
  final UserRouteStop? existing;
  @override
  State<UserOperationRouteStopForm> createState() => _StopFormState();
}

class _StopFormState extends State<UserOperationRouteStopForm> {
  final _form = GlobalKey<FormState>();
  late final TextEditingController _name, _address, _lat, _lon;
  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.existing?.name);
    _address = TextEditingController(text: widget.existing?.address);
    _lat = TextEditingController(text: widget.existing?.latitude.toString());
    _lon = TextEditingController(text: widget.existing?.longitude.toString());
  }

  @override
  void dispose() {
    _name.dispose();
    _address.dispose();
    _lat.dispose();
    _lon.dispose();
    super.dispose();
  }

  double? _number(String? value) => double.tryParse((value ?? '').trim());
  void _submit() {
    if (!_form.currentState!.validate()) return;
    final lat = _number(_lat.text)!, lon = _number(_lon.text)!;
    final previous = widget.existing;
    final moved =
        previous != null &&
        (previous.latitude != lat || previous.longitude != lon);
    Navigator.of(context).pop(
      UserRouteStop(
        name: _name.text.trim(),
        address: _address.text.trim(),
        latitude: lat,
        longitude: lon,
        sourceType: moved
            ? (previous.isVia ? 'VIA' : 'MANUAL')
            : previous?.sourceType ?? 'MANUAL',
        sourceId: moved ? null : previous?.sourceId,
        geofenceRadiusMeters: previous?.geofenceRadiusMeters ?? 50,
        expectedDwellSeconds: previous?.expectedDwellSeconds ?? 0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    String? coordinate(String? value, double limit) {
      final n = _number(value);
      return n == null || !n.isFinite || n.abs() > limit
          ? l.routeBuilderCoordinateError
          : null;
    }

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          20,
          4,
          20,
          MediaQuery.viewInsetsOf(context).bottom + 20,
        ),
        child: Form(
          key: _form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l.routeBuilderEditStop,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              OpenVtsTextField(
                label: l.routeBuilderStopName,
                controller: _name,
                maxLength: 160,
                validator: (v) =>
                    (v?.trim().isEmpty ?? true) || v!.trim().length > 160
                    ? l.routeBuilderStopNameError
                    : null,
              ),
              const SizedBox(height: 12),
              OpenVtsTextField(
                label: l.routeBuilderAddress,
                controller: _address,
                maxLength: 300,
              ),
              const SizedBox(height: 12),
              OpenVtsTextField(
                label: l.routeBuilderLatitude,
                controller: _lat,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                validator: (v) => coordinate(v, 90),
              ),
              const SizedBox(height: 12),
              OpenVtsTextField(
                label: l.routeBuilderLongitude,
                controller: _lon,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                validator: (v) => coordinate(v, 180),
              ),
              if (widget.existing?.sourceType == 'GEOFENCE')
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(l.routeBuilderGeofenceHint),
                ),
              const SizedBox(height: 24),
              OpenVtsButton(label: l.save, onPressed: _submit),
            ],
          ),
        ),
      ),
    );
  }
}

class _LandmarkPicker extends ConsumerStatefulWidget {
  const _LandmarkPicker({required this.geofences});
  final bool geofences;
  @override
  ConsumerState<_LandmarkPicker> createState() => _LandmarkPickerState();
}

class _LandmarkPickerState extends ConsumerState<_LandmarkPicker> {
  String _query = '';
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return SafeArea(
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.65,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Text(
                widget.geofences ? l.routeBuilderGeofence : l.routeBuilderPoi,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: l.routeBuilderLandmarkSearch,
                  prefixIcon: const Icon(Icons.search),
                ),
                onChanged: (q) =>
                    setState(() => _query = q.toLowerCase().trim()),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ref
                    .watch(userRouteLandmarkStopsProvider(widget.geofences))
                    .when(
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (_, __) => Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(l.routeBuilderLandmarkError),
                            OpenVtsButton(
                              label: l.routeBuilderRetry,
                              onPressed: () => ref.invalidate(
                                userRouteLandmarkStopsProvider(
                                  widget.geofences,
                                ),
                              ),
                              variant: OpenVtsButtonVariant.secondary,
                            ),
                          ],
                        ),
                      ),
                      data: (data) {
                        final rows = data
                            .where((p) => p.name.toLowerCase().contains(_query))
                            .toList();
                        if (rows.isEmpty) {
                          return Center(child: Text(l.routeBuilderNoLandmarks));
                        }
                        return ListView.separated(
                          itemCount: rows.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (context, i) => ListTile(
                            title: Text(rows[i].name),
                            subtitle: Text(
                              '${rows[i].latitude.toStringAsFixed(5)}, ${rows[i].longitude.toStringAsFixed(5)}',
                            ),
                            leading: Icon(
                              widget.geofences
                                  ? Icons.hexagon_outlined
                                  : Icons.place_outlined,
                            ),
                            onTap: () => Navigator.pop(context, rows[i]),
                          ),
                        );
                      },
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserOperationRouteMapPicker extends StatefulWidget {
  const UserOperationRouteMapPicker({super.key, this.initialPoint});
  final LatLng? initialPoint;
  @override
  State<UserOperationRouteMapPicker> createState() => _MapPickerState();
}

class _MapPickerState extends State<UserOperationRouteMapPicker> {
  LatLng? _point;
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.routeBuilderMap)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(l.routeBuilderMapHint),
          ),
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                initialCenter:
                    widget.initialPoint ?? const LatLng(20.59, 78.96),
                initialZoom: widget.initialPoint == null ? 4 : 13,
                onTap: (_, point) => setState(() => _point = point),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.openvts.mobile',
                ),
                if (_point != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: _point!,
                        child: Icon(
                          Icons.place,
                          color: Theme.of(context).colorScheme.primary,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              l.routeBuilderMapAttribution,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: OpenVtsButton(
            label: l.routeBuilderUseLocation,
            onPressed: _point == null
                ? null
                : () => Navigator.pop(context, _point),
          ),
        ),
      ),
    );
  }
}
