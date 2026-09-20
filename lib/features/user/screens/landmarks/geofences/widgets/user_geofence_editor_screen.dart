import 'dart:async';
import 'dart:math' show Point;
import 'dart:ui' as ui;

import 'package:dio/dio.dart'
    show CancelToken, Dio, BaseOptions, DioException, DioExceptionType;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../../../../../core/theme/open_vts_colors.dart';
import '../../../../../../core/widgets/map_attribution.dart';
import '../../../../../../core/theme/open_vts_radius.dart';
import '../../../../../../core/theme/open_vts_spacing.dart';
import '../../../../../../core/theme/open_vts_typography.dart';
import '../../../../../../shared/helpers/toast_helper.dart';
import '../../../../../../shared/widgets/open_vts_map_layer_selector.dart';
import '../../../../controllers/user_landmark_geometry_editor_controller.dart';
import '../../../../controllers/user_providers.dart';
import '../../../../models/user_landmark_model.dart';
import '../../widgets/user_landmark_measurement_chip.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Public result type
// ─────────────────────────────────────────────────────────────────────────────

class UserGeofenceEditorResult {
  const UserGeofenceEditorResult({required this.geodata, this.toleranceM});

  final UserGeofenceGeoData geodata;
  final double? toleranceM;
}

// ─────────────────────────────────────────────────────────────────────────────
// Screen
// ─────────────────────────────────────────────────────────────────────────────

class UserGeofenceEditorScreen extends ConsumerStatefulWidget {
  const UserGeofenceEditorScreen({
    super.key,
    required this.initialMode,
    this.initialGeodata,
    this.initialToleranceM,
    this.initialCenter,
    this.title = 'Draw geometry',
    this.searchClient,
  });

  final UserGeofenceEditorMode initialMode;
  final UserGeofenceGeoData? initialGeodata;
  final double? initialToleranceM;
  final LatLng? initialCenter;
  final String title;
  final Dio? searchClient;

  @override
  ConsumerState<UserGeofenceEditorScreen> createState() =>
      _UserGeofenceEditorScreenState();
}

class _UserGeofenceEditorScreenState
    extends ConsumerState<UserGeofenceEditorScreen> {
  // ── Editor args ──────────────────────────────────────────────────────────

  late final UserLandmarkGeometryEditorArgs _args;
  late final MapController _mapController;
  bool _hydrated = false;

  // ── Map layer ────────────────────────────────────────────────────────────

  String _selectedLayerId = 'google-road';

  // ── Drag state ───────────────────────────────────────────────────────────

  /// Index of the vertex currently being dragged, or null.
  int? _draggingIndex;

  /// Whether a drag of the circle center is in progress.
  bool _draggingCircleCenter = false;

  /// Index of the rectangle corner being dragged (0 = start, 1 = end / opposite).
  int? _draggingRectCorner;

  /// Suppresses map pan/zoom while any geometry drag is active.
  bool get _dragActive =>
      _draggingIndex != null ||
      _draggingCircleCenter ||
      _draggingRectCorner != null;

  // ── Search state ─────────────────────────────────────────────────────────

  late final TextEditingController _searchCtrl;
  late final Dio _nominatimDio;
  late final bool _ownsNominatimDio;
  late final FocusNode _searchFocus;

  Timer? _debounceTimer;
  CancelToken? _searchCancel;

  List<_NominatimResult> _searchResults = [];
  bool _searchLoading = false;

  /// Marker shown temporarily after a search result is selected.
  LatLng? _searchPin;

  // ── Lifecycle ────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _args = UserLandmarkGeometryEditorArgs(
      initialMode: widget.initialMode,
      initialCenterLat: widget.initialCenter?.latitude,
      initialCenterLon: widget.initialCenter?.longitude,
      initialZoom: 14,
    );
    _mapController = MapController();
    _searchCtrl = TextEditingController();
    _searchFocus = FocusNode();
    _ownsNominatimDio = widget.searchClient == null;
    _nominatimDio = widget.searchClient ??
        Dio(
          BaseOptions(
            connectTimeout: const Duration(seconds: 6),
            receiveTimeout: const Duration(seconds: 10),
            headers: {'User-Agent': 'OpenVTS-Mobile/1.0 (geofence-search)'},
          ),
        );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref
          .read(userLandmarkGeometryEditorControllerProvider(_args).notifier)
          .loadFromExistingGeodata(
            widget.initialGeodata,
            toleranceM: widget.initialToleranceM,
            cameraCenter: widget.initialCenter,
          );
      _hydrated = true;
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchCancel?.cancel();
    _searchCtrl.dispose();
    _searchFocus.dispose();
    if (_ownsNominatimDio) {
      _nominatimDio.close(force: true);
    }
    super.dispose();
  }

  // ── Controller helper ─────────────────────────────────────────────────────

  UserLandmarkGeometryEditorController get _ctrl =>
      ref.read(userLandmarkGeometryEditorControllerProvider(_args).notifier);

  // ── Map tap ──────────────────────────────────────────────────────────────

  void _handleMapTap(LatLng point) {
    // Discard taps that arrive during geometry drags or when search results
    // are visible (user may be tapping a result tile).
    if (_dragActive || _searchResults.isNotEmpty) return;
    _ctrl.tapMap(UserGeoPoint(lat: point.latitude, lon: point.longitude));
  }

  // ── Save ─────────────────────────────────────────────────────────────────

  void _handleSave() {
    final error = _ctrl.validate();
    if (error != null) {
      ToastHelper.showError(error, context: context);
      return;
    }
    final geo = _ctrl.buildGeofenceGeoData();
    if (geo == null) return;
    final state = ref.read(userLandmarkGeometryEditorControllerProvider(_args));
    Navigator.of(context).pop(
      UserGeofenceEditorResult(geodata: geo, toleranceM: state.toleranceM),
    );
  }

  // ── Screen-to-LatLng conversion ──────────────────────────────────────────

  LatLng _offsetToLatLng(Offset localOffset) {
    // flutter_map ≥7: camera.pointToLatLng expects a Point<double>.
    final camera = _mapController.camera;
    return camera.pointToLatLng(Point<double>(localOffset.dx, localOffset.dy));
  }

  // ── Vertex drag handlers ─────────────────────────────────────────────────

  void _onVertexPanStart(DragStartDetails details, int index) {
    _ctrl.beginVertexDrag(index);
    setState(() => _draggingIndex = index);
  }

  void _onVertexPanUpdate(DragUpdateDetails details, int index) {
    // globalPosition → map-local offset → geographic coordinate.
    // localPosition is relative to the marker widget and would produce the
    // wrong coordinate; we must convert through the map's RenderBox instead.
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;
    final mapLocal = renderBox.globalToLocal(details.globalPosition);
    final geo = _offsetToLatLng(mapLocal);
    _ctrl.moveVertexSilently(
        index, UserGeoPoint(lat: geo.latitude, lon: geo.longitude));
  }

  void _onVertexPanEnd(DragEndDetails details, int index) {
    final state = ref.read(userLandmarkGeometryEditorControllerProvider(_args));
    if (index < state.points.length) {
      final p = state.points[index];
      _ctrl.endVertexDrag(index, UserGeoPoint(lat: p.lat, lon: p.lon));
    }
    setState(() => _draggingIndex = null);
  }

  void _onVertexPanCancel(int index) {
    // Leave geometry in whatever state it reached — undo is available.
    setState(() => _draggingIndex = null);
  }

  // ── Circle center drag ────────────────────────────────────────────────────

  void _onCircleCenterPanStart(DragStartDetails _) {
    _ctrl.beginCircleCenterDrag();
    setState(() => _draggingCircleCenter = true);
  }

  void _onCircleCenterPanUpdate(DragUpdateDetails details) {
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;
    final mapLocal = renderBox.globalToLocal(details.globalPosition);
    final geo = _offsetToLatLng(mapLocal);
    _ctrl.moveCircleCenterSilently(
        UserGeoPoint(lat: geo.latitude, lon: geo.longitude));
  }

  void _onCircleCenterPanEnd(DragEndDetails _) {
    final state = ref.read(userLandmarkGeometryEditorControllerProvider(_args));
    if (state.circleCenter != null) {
      _ctrl.endCircleCenterDrag(state.circleCenter!);
    }
    setState(() => _draggingCircleCenter = false);
  }

  void _onCircleCenterPanCancel() {
    setState(() => _draggingCircleCenter = false);
  }

  // ── Rectangle corner drag ─────────────────────────────────────────────────

  void _onRectCornerPanStart(DragStartDetails _, int cornerIndex) {
    _ctrl.beginRectangleDrag();
    setState(() => _draggingRectCorner = cornerIndex);
  }

  void _onRectCornerPanUpdate(DragUpdateDetails details, int cornerIndex) {
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;
    final mapLocal = renderBox.globalToLocal(details.globalPosition);
    final geo = _offsetToLatLng(mapLocal);
    final newCorner = UserGeoPoint(lat: geo.latitude, lon: geo.longitude);

    final state = ref.read(userLandmarkGeometryEditorControllerProvider(_args));
    final start = state.rectangleStart;
    final end = state.rectangleEnd;

    if (cornerIndex == 0) {
      // Dragging rectangleStart; keep rectangleEnd fixed (or use current end).
      _ctrl.moveRectangleSilently(newCorner, end ?? newCorner);
    } else {
      // Dragging rectangleEnd; keep rectangleStart fixed.
      _ctrl.moveRectangleSilently(start ?? newCorner, newCorner);
    }
  }

  void _onRectCornerPanEnd(DragEndDetails _, int cornerIndex) {
    setState(() => _draggingRectCorner = null);
  }

  void _onRectCornerPanCancel(int cornerIndex) {
    setState(() => _draggingRectCorner = null);
  }

  // ── Search ────────────────────────────────────────────────────────────────

  void _onSearchChanged(String _) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 400), _runSearch);
  }

  Future<void> _runSearch() async {
    final query = _searchCtrl.text.trim();
    if (query.length < 3) {
      setState(() {
        _searchResults = [];
        _searchLoading = false;
      });
      return;
    }

    // Cancel any in-flight request.
    _searchCancel?.cancel('superseded');
    final token = CancelToken();
    _searchCancel = token;

    setState(() => _searchLoading = true);

    try {
      final response = await _nominatimDio.get<List<dynamic>>(
        'https://nominatim.openstreetmap.org/search',
        queryParameters: {
          'q': query,
          'format': 'json',
          'limit': 6,
          'addressdetails': 1,
        },
        cancelToken: token,
      );

      if (!mounted) return;
      // Stale guard: if a newer token was issued while we awaited, drop result.
      if (token != _searchCancel) return;

      final results = <_NominatimResult>[];
      if (response.data is List) {
        for (final item in response.data!) {
          if (item is Map<String, dynamic>) {
            final lat = double.tryParse(item['lat']?.toString() ?? '');
            final lon = double.tryParse(item['lon']?.toString() ?? '');
            if (lat == null || lon == null) continue;

            final addr = item['address'] as Map<String, dynamic>?;
            final primary = _primaryLabel(item, addr);
            final secondary = _secondaryLabel(addr);

            results.add(_NominatimResult(
              primary: primary,
              secondary: secondary,
              lat: lat,
              lon: lon,
            ));
          }
        }
      }

      setState(() {
        _searchResults = results;
        _searchLoading = false;
      });
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) return;
      if (!mounted) return;
      setState(() {
        _searchResults = [];
        _searchLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _searchResults = [];
        _searchLoading = false;
      });
    }
  }

  /// Best human-readable primary label from a Nominatim result.
  String _primaryLabel(Map<String, dynamic> item, Map<String, dynamic>? addr) {
    if (addr != null) {
      final name = addr['name']?.toString().trim() ??
          addr['amenity']?.toString().trim() ??
          addr['building']?.toString().trim() ??
          addr['road']?.toString().trim();
      if (name != null && name.isNotEmpty) return name;
    }
    final display = item['display_name']?.toString().trim() ?? '';
    // Take only the first component of display_name as the primary.
    final firstComma = display.indexOf(',');
    if (firstComma > 0) return display.substring(0, firstComma).trim();
    return display;
  }

  /// Contextual secondary label: city / state / country chain from address.
  String _secondaryLabel(Map<String, dynamic>? addr) {
    if (addr == null) return '';
    final parts = <String>[];
    for (final key in const [
      'suburb',
      'city',
      'town',
      'village',
      'county',
      'state',
      'country',
    ]) {
      final v = addr[key]?.toString().trim();
      if (v != null && v.isNotEmpty) parts.add(v);
      if (parts.length >= 3) break;
    }
    return parts.join(', ');
  }

  void _selectResult(_NominatimResult result) {
    // Dismiss keyboard and collapse results.
    _searchFocus.unfocus();
    _searchCancel?.cancel('selected');
    _debounceTimer?.cancel();

    final target = LatLng(result.lat, result.lon);

    setState(() {
      _searchResults = [];
      _searchLoading = false;
      _searchPin = target;
    });

    // Move camera to the result at a useful editing zoom.
    try {
      final currentZoom = _mapController.camera.zoom;
      final zoom = currentZoom < 14 ? 15.0 : currentZoom.clamp(14.0, 17.0);
      _mapController.move(target, zoom);
    } catch (_) {}

    // Remove the search pin after 3 s so it doesn't clutter editing.
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _searchPin = null);
    });
  }

  void _clearSearch() {
    _debounceTimer?.cancel();
    _searchCancel?.cancel('cleared');
    _searchCtrl.clear();
    setState(() {
      _searchResults = [];
      _searchLoading = false;
    });
    // Do NOT touch geometry — clearing search never modifies the geofence.
  }

  // ── Layer helper ──────────────────────────────────────────────────────────

  MapLayerOption _getSelectedLayer() =>
      mapLayerOptionById(_selectedLayerId) ?? primaryMapLayerOptions.first;

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final state =
        ref.watch(userLandmarkGeometryEditorControllerProvider(_args));
    final ctrl = _ctrl;

    // Disable map interaction flags while a vertex/handle is being dragged so
    // the map cannot steal the gesture.
    final interactFlags = _dragActive
        ? InteractiveFlag.none
        : InteractiveFlag.drag |
            InteractiveFlag.pinchZoom |
            InteractiveFlag.doubleTapZoom |
            InteractiveFlag.scrollWheelZoom;

    return Scaffold(
      backgroundColor: OpenVtsColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _EditorTopBar(
              title: widget.title,
              onCancel: () => Navigator.of(context).maybePop(),
              onSave: _hydrated ? _handleSave : null,
            ),
            Expanded(
              child: Stack(
                children: [
                  // ── Map ──────────────────────────────────────────────────
                  Positioned.fill(
                    child: FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        initialCenter: widget.initialCenter ??
                            const LatLng(20.5937, 78.9629),
                        initialZoom: widget.initialCenter == null ? 5 : 14,
                        minZoom: 3,
                        maxZoom: 19,
                        interactionOptions:
                            InteractionOptions(flags: interactFlags),
                        onTap: (_, point) => _handleMapTap(point),
                      ),
                      children: _buildMapLayers(state, ctrl),
                    ),
                  ),

                  // ── Shape selector + layer button ────────────────────────
                  Positioned(
                    top: OpenVtsSpacing.sm,
                    left: 0,
                    right: 0,
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: OpenVtsSpacing.md),
                            child: _ModeToggleBar(
                              mode: state.editorMode,
                              onSelect: ctrl.setMode,
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(right: OpenVtsSpacing.sm),
                          child: OpenVtsMapLayerSelectorButton(
                            selectedLayerId: _selectedLayerId,
                            onLayerSelected: (layer) {
                              setState(() => _selectedLayerId = layer.id);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── Search bar ───────────────────────────────────────────
                  Positioned(
                    top: OpenVtsSpacing.sm + 56,
                    left: OpenVtsSpacing.sm,
                    right: OpenVtsSpacing.sm,
                    child: _SearchBar(
                      controller: _searchCtrl,
                      focusNode: _searchFocus,
                      isLoading: _searchLoading,
                      results: _searchResults,
                      onChanged: _onSearchChanged,
                      onClear: _clearSearch,
                      onSelectResult: _selectResult,
                    ),
                  ),

                  // ── Measurement chip ─────────────────────────────────────
                  if (state.measurementSummary != null &&
                      _searchResults.isEmpty)
                    Positioned(
                      top: OpenVtsSpacing.sm + 112,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: UserLandmarkMeasurementChip(
                          label: state.measurementSummary!,
                        ),
                      ),
                    ),

                  // ── Map controls ─────────────────────────────────────────
                  Positioned(
                    right: OpenVtsSpacing.sm,
                    top: OpenVtsSpacing.sm + 160,
                    child: _EditorMapControls(
                      onZoomIn: () => _mapController.move(
                        _mapController.camera.center,
                        (_mapController.camera.zoom + 1).clamp(3.0, 19.0),
                      ),
                      onZoomOut: () => _mapController.move(
                        _mapController.camera.center,
                        (_mapController.camera.zoom - 1).clamp(3.0, 19.0),
                      ),
                      canUndo: state.canUndo,
                      canRedo: state.canRedo,
                      onUndo: state.canUndo ? ctrl.undo : null,
                      onRedo: state.canRedo ? ctrl.redo : null,
                      onClear: ctrl.clear,
                      showLockSquare:
                          state.editorMode == UserGeofenceEditorMode.rectangle,
                      lockSquare: state.lockSquare,
                      onToggleLockSquare: () =>
                          ctrl.setLockSquare(!state.lockSquare),
                    ),
                  ),
                ],
              ),
            ),

            // ── Bottom panel ───────────────────────────────────────────────
            _BottomEditorPanel(state: state, controller: ctrl),
          ],
        ),
      ),
    );
  }

  // ── Map layer builder ─────────────────────────────────────────────────────

  List<Widget> _buildMapLayers(
    UserLandmarkGeometryEditorState state,
    UserLandmarkGeometryEditorController ctrl,
  ) {
    final selectedLayer = _getSelectedLayer();
    final layers = <Widget>[
      TileLayer(
        key: ValueKey<String>(_selectedLayerId),
        urlTemplate: selectedLayer.url,
        subdomains: selectedLayer.subdomains,
        userAgentPackageName: 'com.openvts.mobile',
      ),
    ];

    switch (state.editorMode) {
      case UserGeofenceEditorMode.circle:
        _buildCircleLayers(layers, state);
        break;
      case UserGeofenceEditorMode.polygon:
        _buildPolygonLayers(layers, state, ctrl);
        break;
      case UserGeofenceEditorMode.rectangle:
        _buildRectangleLayers(layers, state);
        break;
      case UserGeofenceEditorMode.line:
        _buildLineLayers(layers, state, ctrl);
        break;
      case UserGeofenceEditorMode.view:
        break;
    }

    // Search-pin overlay (temporary after selecting a search result).
    if (_searchPin != null) {
      layers.add(MarkerLayer(markers: [_searchPinMarker(_searchPin!)]));
    }

    layers.add(OpenVtsMapAttribution(layerId: _selectedLayerId));
    return layers;
  }

  // ── Circle layers ─────────────────────────────────────────────────────────

  void _buildCircleLayers(
      List<Widget> layers, UserLandmarkGeometryEditorState state) {
    if (state.circleCenter == null) return;
    final center = state.circleCenter!.toLatLng();

    if ((state.circleRadiusM ?? 0) > 0) {
      layers.add(CircleLayer(circles: [
        CircleMarker(
          point: center,
          radius: state.circleRadiusM!,
          useRadiusInMeter: true,
          color: OpenVtsColors.info.withValues(alpha: 0.18),
          borderColor: OpenVtsColors.brandInk,
          borderStrokeWidth: 2,
        ),
      ]));
    }

    layers.add(MarkerLayer(markers: [
      _draggableCircleCenterMarker(
        center,
        isDragging: _draggingCircleCenter,
      ),
    ]));
  }

  // ── Polygon layers ────────────────────────────────────────────────────────

  void _buildPolygonLayers(
    List<Widget> layers,
    UserLandmarkGeometryEditorState state,
    UserLandmarkGeometryEditorController ctrl,
  ) {
    final pts = state.points.map((p) => p.toLatLng()).toList();
    if (pts.length >= 3) {
      layers.add(PolygonLayer(polygons: [
        Polygon(
          points: pts,
          color: OpenVtsColors.info.withValues(alpha: 0.18),
          borderColor: OpenVtsColors.brandInk,
          borderStrokeWidth: 1.6,
        ),
      ]));
    }
    if (pts.length >= 2) {
      layers.add(PolylineLayer(polylines: [
        Polyline(
          points: pts,
          color: OpenVtsColors.brandInk,
          strokeWidth: 1.6,
        ),
      ]));
    }
    layers.add(MarkerLayer(
      markers: [
        for (var i = 0; i < pts.length; i++)
          _draggableVertexMarker(
            pts[i],
            index: i,
            isSelected: state.selectedVertexIndex == i,
            isDragging: _draggingIndex == i,
            onTap: () => ctrl.selectVertex(i),
            onPanStart: (d) => _onVertexPanStart(d, i),
            onPanUpdate: (d) => _onVertexPanUpdate(d, i),
            onPanEnd: (d) => _onVertexPanEnd(d, i),
            onPanCancel: () => _onVertexPanCancel(i),
          ),
      ],
    ));
  }

  // ── Rectangle layers ──────────────────────────────────────────────────────

  void _buildRectangleLayers(
      List<Widget> layers, UserLandmarkGeometryEditorState state) {
    final corners = state.rectangleCorners.map((p) => p.toLatLng()).toList();
    if (corners.length == 4) {
      layers.add(PolygonLayer(polygons: [
        Polygon(
          points: corners,
          color: OpenVtsColors.info.withValues(alpha: 0.18),
          borderColor: OpenVtsColors.brandInk,
          borderStrokeWidth: 1.6,
        ),
      ]));
      // Show draggable handles at the two stored opposite corners (start/end).
      final handlePts = <LatLng>[];
      if (state.rectangleStart != null) {
        handlePts.add(state.rectangleStart!.toLatLng());
      }
      if (state.rectangleEnd != null) {
        handlePts.add(state.rectangleEnd!.toLatLng());
      }
      layers.add(MarkerLayer(
        markers: [
          for (var i = 0; i < handlePts.length; i++)
            _draggableRectCornerMarker(
              handlePts[i],
              cornerIndex: i,
              isDragging: _draggingRectCorner == i,
              onPanStart: (d) => _onRectCornerPanStart(d, i),
              onPanUpdate: (d) => _onRectCornerPanUpdate(d, i),
              onPanEnd: (d) => _onRectCornerPanEnd(d, i),
              onPanCancel: () => _onRectCornerPanCancel(i),
            ),
        ],
      ));
    } else if (state.rectangleStart != null) {
      layers.add(MarkerLayer(markers: [
        _staticCornerMarker(state.rectangleStart!.toLatLng()),
      ]));
    }
  }

  // ── Line layers ───────────────────────────────────────────────────────────

  void _buildLineLayers(
    List<Widget> layers,
    UserLandmarkGeometryEditorState state,
    UserLandmarkGeometryEditorController ctrl,
  ) {
    final pts = state.points.map((p) => p.toLatLng()).toList();
    if (pts.length >= 2) {
      layers.add(PolylineLayer(polylines: [
        Polyline(
          points: pts,
          color: OpenVtsColors.brandInk,
          strokeWidth: 3,
        ),
      ]));
    }
    layers.add(MarkerLayer(
      markers: [
        for (var i = 0; i < pts.length; i++)
          _draggableVertexMarker(
            pts[i],
            index: i,
            isSelected: state.selectedVertexIndex == i,
            isDragging: _draggingIndex == i,
            onTap: () => ctrl.selectVertex(i),
            onPanStart: (d) => _onVertexPanStart(d, i),
            onPanUpdate: (d) => _onVertexPanUpdate(d, i),
            onPanEnd: (d) => _onVertexPanEnd(d, i),
            onPanCancel: () => _onVertexPanCancel(i),
          ),
      ],
    ));
  }

  // ── Marker factories ──────────────────────────────────────────────────────

  /// 44 px touch target with a small visible circle inside. Supports drag.
  Marker _draggableVertexMarker(
    LatLng point, {
    required int index,
    required bool isSelected,
    required bool isDragging,
    required VoidCallback onTap,
    required GestureDragStartCallback onPanStart,
    required GestureDragUpdateCallback onPanUpdate,
    required GestureDragEndCallback onPanEnd,
    required VoidCallback onPanCancel,
  }) {
    const hitSize = 44.0;
    const dotSize = 22.0;

    Color dotColor;
    Color borderColor;
    double borderWidth;

    if (isDragging) {
      dotColor = OpenVtsColors.brandInk;
      borderColor = OpenVtsColors.white;
      borderWidth = 2.5;
    } else if (isSelected) {
      dotColor = OpenVtsColors.brandInk;
      borderColor = OpenVtsColors.white;
      borderWidth = 2.0;
    } else {
      dotColor = OpenVtsColors.white;
      borderColor = OpenVtsColors.brandInk;
      borderWidth = 1.4;
    }

    return Marker(
      point: point,
      width: hitSize,
      height: hitSize,
      child: GestureDetector(
        onTap: onTap,
        onPanStart: onPanStart,
        onPanUpdate: onPanUpdate,
        onPanEnd: onPanEnd,
        onPanCancel: onPanCancel,
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: Container(
            width: isDragging ? dotSize + 4 : dotSize,
            height: isDragging ? dotSize + 4 : dotSize,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
              border: Border.all(color: borderColor, width: borderWidth),
              boxShadow: isDragging
                  ? const [
                      BoxShadow(
                        color: Color(0x33000000),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: OpenVtsTypography.meta.copyWith(
                  color: isSelected || isDragging
                      ? OpenVtsColors.white
                      : OpenVtsColors.brandInk,
                  fontWeight: FontWeight.w700,
                  fontSize: 10,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Draggable circle center marker.
  Marker _draggableCircleCenterMarker(LatLng point,
      {required bool isDragging}) {
    const hitSize = 44.0;
    const dotSize = 18.0;

    return Marker(
      point: point,
      width: hitSize,
      height: hitSize,
      child: GestureDetector(
        onPanStart: _onCircleCenterPanStart,
        onPanUpdate: _onCircleCenterPanUpdate,
        onPanEnd: _onCircleCenterPanEnd,
        onPanCancel: _onCircleCenterPanCancel,
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: Container(
            width: isDragging ? dotSize + 4 : dotSize,
            height: isDragging ? dotSize + 4 : dotSize,
            decoration: BoxDecoration(
              color: OpenVtsColors.brandInk,
              shape: BoxShape.circle,
              border: Border.all(color: OpenVtsColors.white, width: 2),
              boxShadow: isDragging
                  ? const [
                      BoxShadow(
                        color: Color(0x33000000),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
          ),
        ),
      ),
    );
  }

  /// Draggable rectangle corner marker (diamond shape, filled when dragging).
  Marker _draggableRectCornerMarker(
    LatLng point, {
    required int cornerIndex,
    required bool isDragging,
    required GestureDragStartCallback onPanStart,
    required GestureDragUpdateCallback onPanUpdate,
    required GestureDragEndCallback onPanEnd,
    required VoidCallback onPanCancel,
  }) {
    const hitSize = 44.0;
    const dotSize = 16.0;

    return Marker(
      point: point,
      width: hitSize,
      height: hitSize,
      child: GestureDetector(
        onPanStart: onPanStart,
        onPanUpdate: onPanUpdate,
        onPanEnd: onPanEnd,
        onPanCancel: onPanCancel,
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: Container(
            width: isDragging ? dotSize + 4 : dotSize,
            height: isDragging ? dotSize + 4 : dotSize,
            decoration: BoxDecoration(
              color: isDragging ? OpenVtsColors.brandInk : OpenVtsColors.white,
              border: Border.all(color: OpenVtsColors.brandInk, width: 2),
              boxShadow: isDragging
                  ? const [
                      BoxShadow(
                        color: Color(0x33000000),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
          ),
        ),
      ),
    );
  }

  /// Static (non-draggable) corner for the first tap of a rectangle.
  Marker _staticCornerMarker(LatLng point) => Marker(
        point: point,
        width: 16,
        height: 16,
        child: Container(
          decoration: BoxDecoration(
            color: OpenVtsColors.brandInk,
            border: Border.all(color: OpenVtsColors.white, width: 2),
          ),
        ),
      );

  /// Temporary pin shown after a search result is selected.
  Marker _searchPinMarker(LatLng point) => Marker(
        point: point,
        width: 32,
        height: 40,
        alignment: const Alignment(0, -1),
        child: const _SearchPinWidget(),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// Search pin visual
// ─────────────────────────────────────────────────────────────────────────────

class _SearchPinWidget extends StatelessWidget {
  const _SearchPinWidget();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            color: OpenVtsColors.brandInk,
            shape: BoxShape.circle,
            border: Border.all(color: OpenVtsColors.white, width: 2),
          ),
          child: const Icon(Icons.search, size: 14, color: OpenVtsColors.white),
        ),
        CustomPaint(
          size: const Size(10, 8),
          painter: _DropTailPainter(),
        ),
      ],
    );
  }
}

class _DropTailPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = OpenVtsColors.brandInk;
    final path = ui.Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_DropTailPainter _) => false;
}

// ─────────────────────────────────────────────────────────────────────────────
// Top bar
// ─────────────────────────────────────────────────────────────────────────────

class _EditorTopBar extends StatelessWidget {
  const _EditorTopBar({
    required this.title,
    required this.onCancel,
    required this.onSave,
  });

  final String title;
  final VoidCallback onCancel;
  final VoidCallback? onSave;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? OpenVtsColors.brandInk : OpenVtsColors.surface;
    final textColor = isDark ? OpenVtsColors.white : OpenVtsColors.textPrimary;
    final borderColor = isDark ? OpenVtsColors.white : OpenVtsColors.border;

    return Container(
      padding: const EdgeInsets.fromLTRB(
        OpenVtsSpacing.sm,
        OpenVtsSpacing.xs,
        OpenVtsSpacing.sm,
        OpenVtsSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(bottom: BorderSide(color: borderColor, width: 1)),
      ),
      child: Row(
        children: [
          IconButton(
            iconSize: 18,
            onPressed: onCancel,
            icon: Icon(Icons.close, color: textColor),
            tooltip: 'Cancel',
          ),
          Expanded(
            child: Text(
              title,
              style: OpenVtsTypography.titleSmall.copyWith(
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 36,
            child: ElevatedButton(
              onPressed: onSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: bgColor,
                foregroundColor: textColor,
                side: BorderSide(color: textColor, width: 1),
                padding: const EdgeInsets.symmetric(
                  horizontal: OpenVtsSpacing.sm,
                ),
              ),
              child: Text(
                'Save',
                style: OpenVtsTypography.label.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Mode toggle bar
// ─────────────────────────────────────────────────────────────────────────────

class _ModeToggleBar extends StatelessWidget {
  const _ModeToggleBar({required this.mode, required this.onSelect});

  final UserGeofenceEditorMode mode;
  final ValueChanged<UserGeofenceEditorMode> onSelect;

  static const _modes = <UserGeofenceEditorMode>[
    UserGeofenceEditorMode.circle,
    UserGeofenceEditorMode.polygon,
    UserGeofenceEditorMode.rectangle,
    UserGeofenceEditorMode.line,
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? OpenVtsColors.brandInk : OpenVtsColors.surface;
    final borderColor = isDark ? OpenVtsColors.white : OpenVtsColors.border;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(OpenVtsRadius.pill),
        border: Border.all(color: borderColor),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final m in _modes)
            _ModeChip(
              icon: _iconFor(m),
              label: m.label,
              selected: m == mode,
              onTap: () => onSelect(m),
            ),
        ],
      ),
    );
  }

  IconData _iconFor(UserGeofenceEditorMode m) {
    switch (m) {
      case UserGeofenceEditorMode.circle:
        return Icons.radio_button_unchecked;
      case UserGeofenceEditorMode.polygon:
        return Icons.hexagon_outlined;
      case UserGeofenceEditorMode.rectangle:
        return Icons.crop_square;
      case UserGeofenceEditorMode.line:
        return Icons.show_chart;
      case UserGeofenceEditorMode.view:
        return Icons.visibility_outlined;
    }
  }
}

class _ModeChip extends StatelessWidget {
  const _ModeChip({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedBg =
        isDark ? OpenVtsColors.brandInk : OpenVtsColors.textPrimary;
    final selectedFg = OpenVtsColors.white;
    final unselectedFg = isDark
        ? Theme.of(context).colorScheme.onSurface
        : OpenVtsColors.textPrimary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(OpenVtsRadius.pill),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? selectedBg : Colors.transparent,
          borderRadius: BorderRadius.circular(OpenVtsRadius.pill),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: selected ? selectedFg : unselectedFg),
            const SizedBox(width: 4),
            Text(
              label,
              style: OpenVtsTypography.meta.copyWith(
                color: selected ? selectedFg : unselectedFg,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Map controls
// ─────────────────────────────────────────────────────────────────────────────

class _EditorMapControls extends StatelessWidget {
  const _EditorMapControls({
    required this.onZoomIn,
    required this.onZoomOut,
    required this.canUndo,
    required this.canRedo,
    required this.onUndo,
    required this.onRedo,
    required this.onClear,
    required this.showLockSquare,
    required this.lockSquare,
    required this.onToggleLockSquare,
  });

  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final bool canUndo;
  final bool canRedo;
  final VoidCallback? onUndo;
  final VoidCallback? onRedo;
  final VoidCallback onClear;
  final bool showLockSquare;
  final bool lockSquare;
  final VoidCallback onToggleLockSquare;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? OpenVtsColors.brandInk : OpenVtsColors.surface;
    final borderColor = isDark ? OpenVtsColors.white : OpenVtsColors.border;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(OpenVtsRadius.md),
        border: Border.all(color: borderColor),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ControlButton(icon: Icons.add, tooltip: 'Zoom in', onTap: onZoomIn),
          const _ControlDivider(),
          _ControlButton(
              icon: Icons.remove, tooltip: 'Zoom out', onTap: onZoomOut),
          const _ControlDivider(),
          _ControlButton(
              icon: Icons.undo,
              tooltip: 'Undo',
              onTap: onUndo,
              enabled: canUndo),
          _ControlButton(
              icon: Icons.redo,
              tooltip: 'Redo',
              onTap: onRedo,
              enabled: canRedo),
          const _ControlDivider(),
          _ControlButton(
              icon: Icons.layers_clear_outlined,
              tooltip: 'Clear',
              onTap: onClear),
          if (showLockSquare) ...[
            const _ControlDivider(),
            _ControlButton(
              icon: lockSquare ? Icons.lock : Icons.lock_open,
              tooltip: lockSquare ? 'Unlock square' : 'Lock square',
              onTap: onToggleLockSquare,
              active: lockSquare,
            ),
          ],
        ],
      ),
    );
  }
}

class _ControlDivider extends StatelessWidget {
  const _ControlDivider();

  @override
  Widget build(BuildContext context) =>
      const Divider(height: 1, color: OpenVtsColors.divider);
}

class _ControlButton extends StatelessWidget {
  const _ControlButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.enabled = true,
    this.active = false,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onTap;
  final bool enabled;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final disabled = !enabled || onTap == null;
    final activeBg = isDark
        ? OpenVtsColors.brandInk.withValues(alpha: 0.08)
        : OpenVtsColors.textPrimary.withValues(alpha: 0.08);
    final iconColor = disabled
        ? Theme.of(context).colorScheme.outline
        : Theme.of(context).colorScheme.onSurface;

    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: disabled ? null : onTap,
        child: Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          color: active ? activeBg : Colors.transparent,
          child: Icon(icon, size: 16, color: iconColor),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Bottom panel
// ─────────────────────────────────────────────────────────────────────────────

class _BottomEditorPanel extends StatelessWidget {
  const _BottomEditorPanel({required this.state, required this.controller});

  final UserLandmarkGeometryEditorState state;
  final UserLandmarkGeometryEditorController controller;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? OpenVtsColors.brandInk : OpenVtsColors.surface;
    final textColor = isDark ? OpenVtsColors.white : OpenVtsColors.textPrimary;
    final borderColor = isDark ? OpenVtsColors.white : OpenVtsColors.border;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(top: BorderSide(color: borderColor)),
      ),
      padding: const EdgeInsets.fromLTRB(
        OpenVtsSpacing.md,
        OpenVtsSpacing.sm,
        OpenVtsSpacing.md,
        OpenVtsSpacing.sm,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _hintFor(state.editorMode),
            style: OpenVtsTypography.meta.copyWith(color: textColor),
          ),
          const SizedBox(height: OpenVtsSpacing.xs),
          if (state.editorMode == UserGeofenceEditorMode.circle)
            _CircleControls(state: state, controller: controller),
          if (state.editorMode == UserGeofenceEditorMode.line)
            _LineControls(state: state, controller: controller),
          if (state.editorMode == UserGeofenceEditorMode.polygon ||
              state.editorMode == UserGeofenceEditorMode.line)
            _VertexControls(state: state, controller: controller),
          if (state.validationError != null) ...[
            const SizedBox(height: OpenVtsSpacing.xs),
            Text(
              state.validationError!,
              style:
                  OpenVtsTypography.meta.copyWith(color: OpenVtsColors.error),
            ),
          ],
        ],
      ),
    );
  }

  String _hintFor(UserGeofenceEditorMode mode) {
    switch (mode) {
      case UserGeofenceEditorMode.circle:
        return 'Tap map to set center. Drag center to reposition.';
      case UserGeofenceEditorMode.polygon:
        return 'Tap to add vertices. Drag any vertex to reposition.';
      case UserGeofenceEditorMode.rectangle:
        return 'Tap two opposite corners. Drag handles to adjust.';
      case UserGeofenceEditorMode.line:
        return 'Tap to add points. Drag any point to reposition.';
      case UserGeofenceEditorMode.view:
        return '';
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Circle controls
// ─────────────────────────────────────────────────────────────────────────────

class _CircleControls extends StatefulWidget {
  const _CircleControls({required this.state, required this.controller});

  final UserLandmarkGeometryEditorState state;
  final UserLandmarkGeometryEditorController controller;

  @override
  State<_CircleControls> createState() => _CircleControlsState();
}

class _CircleControlsState extends State<_CircleControls> {
  late final TextEditingController _radius = TextEditingController(
    text: widget.state.circleRadiusM == null
        ? ''
        : widget.state.circleRadiusM!.round().toString(),
  );

  @override
  void didUpdateWidget(covariant _CircleControls oldWidget) {
    super.didUpdateWidget(oldWidget);
    final r = widget.state.circleRadiusM;
    final text = r == null ? '' : r.round().toString();
    if (text != _radius.text) {
      _radius.text = text;
      _radius.selection = TextSelection.collapsed(offset: _radius.text.length);
    }
  }

  @override
  void dispose() {
    _radius.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? OpenVtsColors.white : OpenVtsColors.textPrimary;
    final borderColor = isDark ? OpenVtsColors.white : OpenVtsColors.border;
    final value = widget.state.circleRadiusM ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Slider(
                value: value.clamp(1, 5000).toDouble(),
                min: 1,
                max: 5000,
                divisions: 99,
                onChanged: widget.state.circleCenter == null
                    ? null
                    : (v) => widget.controller.setCircleRadius(v),
              ),
            ),
            SizedBox(
              width: 96,
              child: TextField(
                controller: _radius,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                style: OpenVtsTypography.body.copyWith(color: textColor),
                decoration: InputDecoration(
                  isDense: true,
                  suffixText: 'm',
                  suffixStyle:
                      OpenVtsTypography.body.copyWith(color: textColor),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  enabled: widget.state.circleCenter != null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(OpenVtsRadius.button),
                    borderSide: BorderSide(color: borderColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(OpenVtsRadius.button),
                    borderSide: BorderSide(color: borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(OpenVtsRadius.button),
                    borderSide: BorderSide(color: borderColor, width: 1.4),
                  ),
                ),
                onSubmitted: (text) {
                  final parsed = double.tryParse(text.trim());
                  if (parsed != null && parsed.isFinite && parsed >= 1) {
                    widget.controller.setCircleRadius(parsed);
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Line tolerance controls
// ─────────────────────────────────────────────────────────────────────────────

class _LineControls extends StatefulWidget {
  const _LineControls({required this.state, required this.controller});

  final UserLandmarkGeometryEditorState state;
  final UserLandmarkGeometryEditorController controller;

  @override
  State<_LineControls> createState() => _LineControlsState();
}

class _LineControlsState extends State<_LineControls> {
  late final TextEditingController _tolerance = TextEditingController(
    text: widget.state.toleranceM == null
        ? ''
        : widget.state.toleranceM!.round().toString(),
  );

  @override
  void didUpdateWidget(covariant _LineControls oldWidget) {
    super.didUpdateWidget(oldWidget);
    final t = widget.state.toleranceM;
    final text = t == null ? '' : t.round().toString();
    if (text != _tolerance.text) {
      _tolerance.text = text;
      _tolerance.selection =
          TextSelection.collapsed(offset: _tolerance.text.length);
    }
  }

  @override
  void dispose() {
    _tolerance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? OpenVtsColors.white : OpenVtsColors.textPrimary;
    final borderColor = isDark ? OpenVtsColors.white : OpenVtsColors.border;
    final value = widget.state.toleranceM ?? 0;

    return Row(
      children: [
        Expanded(
          child: Slider(
            value: value.clamp(0, 1000).toDouble(),
            min: 0,
            max: 1000,
            divisions: 100,
            onChanged: widget.controller.updateTolerance,
          ),
        ),
        SizedBox(
          width: 110,
          child: TextField(
            controller: _tolerance,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: OpenVtsTypography.body.copyWith(color: textColor),
            decoration: InputDecoration(
              isDense: true,
              labelText: 'Tolerance',
              labelStyle: OpenVtsTypography.body.copyWith(color: textColor),
              suffixText: 'm',
              suffixStyle: OpenVtsTypography.body.copyWith(color: textColor),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(OpenVtsRadius.button),
                borderSide: BorderSide(color: borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(OpenVtsRadius.button),
                borderSide: BorderSide(color: borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(OpenVtsRadius.button),
                borderSide: BorderSide(color: borderColor, width: 1.4),
              ),
            ),
            onSubmitted: (text) {
              final parsed = double.tryParse(text.trim());
              if (parsed != null && parsed.isFinite && parsed >= 0) {
                widget.controller.updateTolerance(parsed);
              }
            },
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Vertex controls (point count + delete + nudge)
// ─────────────────────────────────────────────────────────────────────────────

class _VertexControls extends StatelessWidget {
  const _VertexControls({required this.state, required this.controller});

  final UserLandmarkGeometryEditorState state;
  final UserLandmarkGeometryEditorController controller;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? OpenVtsColors.white : OpenVtsColors.textPrimary;
    final selected = state.selectedVertexIndex;
    final count = state.points.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: OpenVtsSpacing.xs),
        Row(
          children: [
            Text(
              '$count point${count == 1 ? '' : 's'}',
              style: OpenVtsTypography.meta.copyWith(color: textColor),
            ),
            const Spacer(),
            if (selected != null)
              TextButton.icon(
                style: TextButton.styleFrom(
                  foregroundColor: OpenVtsColors.error,
                  padding: const EdgeInsets.symmetric(
                    horizontal: OpenVtsSpacing.sm,
                    vertical: 0,
                  ),
                  minimumSize: const Size(0, 32),
                  side: const BorderSide(color: OpenVtsColors.error),
                ),
                onPressed: () => controller.removePoint(selected),
                icon: const Icon(Icons.delete_outline, size: 14),
                label: Text(
                  'Remove #${selected + 1}',
                  style: OpenVtsTypography.meta.copyWith(
                    fontWeight: FontWeight.w600,
                    color: OpenVtsColors.error,
                  ),
                ),
              ),
          ],
        ),
        // Nudge row kept as optional fine-adjustment, no longer primary.
        if (selected != null && selected < state.points.length)
          _NudgeRow(
            onNudge: ({double north = 0, double east = 0}) =>
                controller.moveSelectedPointByMeters(north: north, east: east),
          ),
      ],
    );
  }
}

class _NudgeRow extends StatelessWidget {
  const _NudgeRow({required this.onNudge});

  final void Function({double north, double east}) onNudge;

  static const double _stepM = 10;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? OpenVtsColors.white : OpenVtsColors.textPrimary;

    return Padding(
      padding: const EdgeInsets.only(top: OpenVtsSpacing.xs),
      child: Row(
        children: [
          Text(
            'Fine-adjust (${_stepM.toInt()} m)',
            style: OpenVtsTypography.meta.copyWith(color: textColor),
          ),
          const SizedBox(width: OpenVtsSpacing.sm),
          _NudgeBtn(icon: Icons.north, onTap: () => onNudge(north: _stepM)),
          _NudgeBtn(icon: Icons.south, onTap: () => onNudge(north: -_stepM)),
          _NudgeBtn(icon: Icons.east, onTap: () => onNudge(east: _stepM)),
          _NudgeBtn(icon: Icons.west, onTap: () => onNudge(east: -_stepM)),
        ],
      ),
    );
  }
}

class _NudgeBtn extends StatelessWidget {
  const _NudgeBtn({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? OpenVtsColors.brandInk : OpenVtsColors.textPrimary;
    final borderColor =
        isDark ? OpenVtsColors.white : OpenVtsColors.textPrimary;

    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: InkResponse(
        onTap: onTap,
        radius: 18,
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(OpenVtsRadius.sm),
            border: Border.all(color: borderColor),
          ),
          child: Icon(icon, size: 14, color: OpenVtsColors.white),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Search bar
// ─────────────────────────────────────────────────────────────────────────────

class _NominatimResult {
  const _NominatimResult({
    required this.primary,
    required this.secondary,
    required this.lat,
    required this.lon,
  });

  final String primary;
  final String secondary;
  final double lat;
  final double lon;
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({
    required this.controller,
    required this.focusNode,
    required this.isLoading,
    required this.results,
    required this.onChanged,
    required this.onClear,
    required this.onSelectResult,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isLoading;
  final List<_NominatimResult> results;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final ValueChanged<_NominatimResult> onSelectResult;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? OpenVtsColors.brandInk : OpenVtsColors.surface;
    final textColor = isDark ? OpenVtsColors.white : OpenVtsColors.textPrimary;
    final secondaryColor = isDark
        ? OpenVtsColors.white.withValues(alpha: 0.55)
        : OpenVtsColors.textSecondary;
    final borderColor = isDark ? OpenVtsColors.white : OpenVtsColors.border;
    final hintColor = isDark
        ? OpenVtsColors.white.withValues(alpha: 0.6)
        : OpenVtsColors.textSecondary;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(OpenVtsRadius.md),
        border: Border.all(color: borderColor),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              onChanged: onChanged,
              textInputAction: TextInputAction.search,
              style: OpenVtsTypography.body.copyWith(color: textColor),
              decoration: InputDecoration(
                isDense: true,
                hintText: 'Search place or address...',
                hintStyle: OpenVtsTypography.body.copyWith(color: hintColor),
                prefixIcon: Icon(
                  Icons.search,
                  size: 18,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                suffixIcon: isLoading
                    ? Padding(
                        padding: const EdgeInsets.all(8),
                        child: SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              textColor.withValues(alpha: 0.6),
                            ),
                          ),
                        ),
                      )
                    : controller.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.close, size: 18, color: textColor),
                            onPressed: onClear,
                          )
                        : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
          if (results.isNotEmpty)
            Container(
              constraints: const BoxConstraints(maxHeight: 220),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: borderColor.withValues(alpha: 0.3),
                  ),
                ),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: results.length,
                itemBuilder: (context, index) {
                  final r = results[index];
                  return InkWell(
                    onTap: () => onSelectResult(r),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 9,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            r.primary,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: OpenVtsTypography.body.copyWith(
                              color: textColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (r.secondary.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Text(
                                r.secondary,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: OpenVtsTypography.meta.copyWith(
                                  color: secondaryColor,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
