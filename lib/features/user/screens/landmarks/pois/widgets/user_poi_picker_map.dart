import 'dart:math' as math;

import 'package:dio/dio.dart' show Dio, BaseOptions;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../../../../core/theme/open_vts_colors.dart';
import '../../../../../../core/widgets/map_attribution.dart';
import '../../../../../../core/theme/open_vts_radius.dart';
import '../../../../../../core/theme/open_vts_spacing.dart';
import '../../../../../../core/theme/open_vts_typography.dart';
import '../../../../../../shared/helpers/toast_helper.dart';
import '../../../../../../shared/widgets/open_vts_button.dart';
import '../../../../../../shared/widgets/open_vts_map_layer_selector.dart';
import '../../../../models/user_landmark_model.dart';

const LatLng _kPoiFallbackCenter = LatLng(20.5937, 78.9629);

/// Result returned from [UserPoiPickerMap].
class UserPoiPickerResult {
  const UserPoiPickerResult({required this.coordinates, this.toleranceMeters});

  final UserGeoPoint coordinates;
  final double? toleranceMeters;
}

/// Full-screen page used to pick or refine a POI coordinate. Supports tap to
/// place, numeric coordinate edits, nudge controls, and an optional tolerance
/// radius slider. Marker dragging is not used because `flutter_map` v7 does
/// not provide reliable drag support; tap-to-reposition is the primary UX.
class UserPoiPickerMap extends StatefulWidget {
  const UserPoiPickerMap({
    super.key,
    this.initialPoint,
    this.initialToleranceM,
    this.title = 'Pick location',
    this.searchClient,
  });

  final LatLng? initialPoint;
  final double? initialToleranceM;
  final String title;
  final Dio? searchClient;

  @override
  State<UserPoiPickerMap> createState() => _UserPoiPickerMapState();
}

class _UserPoiPickerMapState extends State<UserPoiPickerMap> {
  late final MapController _map;
  late LatLng? _point;
  late double _tolerance;
  late final TextEditingController _latCtrl;
  late final TextEditingController _lonCtrl;
  late final TextEditingController _tolCtrl;
  late final TextEditingController _searchCtrl;

  static const double _nudgeMeters = 10;
  String _selectedLayerId = 'google-road';
  List<_NominatimResult> _searchResults = [];
  bool _searchLoading = false;
  late final Dio _nominatimDio;
  late final bool _ownsNominatimDio;

  @override
  void initState() {
    super.initState();
    _map = MapController();
    _point = widget.initialPoint;
    _tolerance = (widget.initialToleranceM ?? 0).clamp(0, 5000).toDouble();
    _latCtrl = TextEditingController(
      text: _point == null ? '' : _point!.latitude.toStringAsFixed(6),
    );
    _lonCtrl = TextEditingController(
      text: _point == null ? '' : _point!.longitude.toStringAsFixed(6),
    );
    _tolCtrl = TextEditingController(
      text: _tolerance > 0 ? _tolerance.toStringAsFixed(0) : '',
    );
    _searchCtrl = TextEditingController();
    _ownsNominatimDio = widget.searchClient == null;
    _nominatimDio = widget.searchClient ??
        Dio(
          BaseOptions(
            connectTimeout: const Duration(seconds: 6),
            receiveTimeout: const Duration(seconds: 8),
            headers: {
              'User-Agent': 'OpenVTS-Mobile/1.0 (poi-search)',
            },
          ),
        );
  }

  @override
  void dispose() {
    _latCtrl.dispose();
    _lonCtrl.dispose();
    _tolCtrl.dispose();
    _searchCtrl.dispose();
    if (_ownsNominatimDio) {
      _nominatimDio.close(force: true);
    }
    super.dispose();
  }

  void _setPoint(LatLng point, {bool recenter = false}) {
    setState(() {
      _point = point;
      _latCtrl.text = point.latitude.toStringAsFixed(6);
      _lonCtrl.text = point.longitude.toStringAsFixed(6);
    });
    if (recenter) {
      try {
        _map.move(point, _map.camera.zoom);
      } catch (_) {
        // Map not ready yet — initialCenter handles it.
      }
    }
  }

  void _applyCoordsFromFields() {
    final lat = double.tryParse(_latCtrl.text.trim());
    final lon = double.tryParse(_lonCtrl.text.trim());
    if (lat == null || lon == null) return;
    if (lat < -90 || lat > 90 || lon < -180 || lon > 180) return;
    _setPoint(LatLng(lat, lon), recenter: true);
  }

  void _applyToleranceFromField() {
    final raw = _tolCtrl.text.trim();
    final value = raw.isEmpty ? 0.0 : double.tryParse(raw);
    if (value == null || value < 0) return;
    setState(() => _tolerance = value.clamp(0, 5000).toDouble());
  }

  void _nudge({required double dLat, required double dLon}) {
    if (_point == null) return;
    final p = _point!;
    const metersPerDegLat = 111111.0;
    final metersPerDegLon =
        metersPerDegLat * math.cos(p.latitude * math.pi / 180).abs();
    final latOffset = (dLat * _nudgeMeters) / metersPerDegLat;
    final lonOffset =
        metersPerDegLon < 1 ? 0.0 : (dLon * _nudgeMeters) / metersPerDegLon;
    _setPoint(LatLng(p.latitude + latOffset, p.longitude + lonOffset));
  }

  void _save() {
    if (_point == null) {
      ToastHelper.showError(
        'Tap the map or enter coordinates to place the POI.',
        context: context,
      );
      return;
    }
    Navigator.of(context).pop(
      UserPoiPickerResult(
        coordinates: UserGeoPoint(
          lat: _point!.latitude,
          lon: _point!.longitude,
        ),
        toleranceMeters: _tolerance > 0 ? _tolerance : null,
      ),
    );
  }

  Future<void> _searchPlace() async {
    final query = _searchCtrl.text.trim();
    if (query.length < 3) {
      setState(() => _searchResults = []);
      return;
    }

    setState(() => _searchLoading = true);
    try {
      final response = await _nominatimDio.get<List<dynamic>>(
        'https://nominatim.openstreetmap.org/search',
        queryParameters: {
          'q': query,
          'format': 'json',
          'limit': 5,
          'addressdetails': 0,
        },
      );

      if (!mounted) return;

      final results = <_NominatimResult>[];
      if (response.data is List) {
        for (final item in response.data!) {
          if (item is Map<String, dynamic>) {
            final lat = double.tryParse(item['lat'].toString());
            final lon = double.tryParse(item['lon'].toString());
            if (lat != null && lon != null) {
              results.add(_NominatimResult(
                label: item['display_name'] ?? '',
                lat: lat,
                lon: lon,
              ));
            }
          }
        }
      }

      setState(() {
        _searchResults = results;
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

  void _selectSearchResult(_NominatimResult result) {
    final point = LatLng(result.lat, result.lon);
    _setPoint(point, recenter: true);
    _searchCtrl.clear();
    setState(() => _searchResults = []);
  }

  MapLayerOption _getSelectedLayer() {
    final layer = mapLayerOptionById(_selectedLayerId);
    return layer ?? primaryMapLayerOptions.first;
  }

  @override
  Widget build(BuildContext context) {
    final center = _point ?? widget.initialPoint ?? _kPoiFallbackCenter;
    return Scaffold(
      backgroundColor: OpenVtsColors.brandInk,
      appBar: AppBar(
        backgroundColor: OpenVtsColors.brandInk,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: OpenVtsColors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.title,
          style: OpenVtsTypography.titleSmall.copyWith(
            color: OpenVtsColors.white,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _save,
            style: TextButton.styleFrom(
              foregroundColor: OpenVtsColors.white,
            ),
            child: Text(
              'Save',
              style: OpenVtsTypography.label.copyWith(
                color: OpenVtsColors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: OpenVtsSpacing.xs),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: OpenVtsColors.white),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ColoredBox(
              color: const Color(0xFFE8EEF5),
              child: Stack(
                children: [
                  FlutterMap(
                    mapController: _map,
                    options: MapOptions(
                      initialCenter: center,
                      initialZoom: widget.initialPoint == null ? 4.5 : 15,
                      minZoom: 2,
                      maxZoom: 19,
                      interactionOptions: const InteractionOptions(
                        flags: InteractiveFlag.all,
                      ),
                      onTap: (_, latlng) => _setPoint(latlng),
                    ),
                    children: [
                      TileLayer(
                        key: ValueKey<String>(_selectedLayerId),
                        urlTemplate: _getSelectedLayer().url,
                        subdomains: _getSelectedLayer().subdomains,
                        userAgentPackageName: 'com.openvts.mobile',
                      ),
                      if (_point != null && _tolerance > 0)
                        CircleLayer(
                          circles: [
                            CircleMarker(
                              point: _point!,
                              useRadiusInMeter: true,
                              radius: _tolerance,
                              color: OpenVtsColors.brandInk
                                  .withValues(alpha: 0.10),
                              borderStrokeWidth: 1.2,
                              borderColor: OpenVtsColors.brandInk.withValues(
                                alpha: 0.6,
                              ),
                            ),
                          ],
                        ),
                      if (_point != null)
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: _point!,
                              width: 22,
                              height: 22,
                              alignment: Alignment.center,
                              child: const _PickerPin(),
                            ),
                          ],
                        ),
                      OpenVtsMapAttribution(layerId: _selectedLayerId),
                    ],
                  ),
                  // Layer button at top-right
                  Positioned(
                    top: OpenVtsSpacing.sm,
                    right: OpenVtsSpacing.sm,
                    child: OpenVtsMapLayerSelectorButton(
                      selectedLayerId: _selectedLayerId,
                      onLayerSelected: (layer) {
                        setState(() => _selectedLayerId = layer.id);
                      },
                    ),
                  ),
                  // Search bar below layer button area
                  Positioned(
                    top: OpenVtsSpacing.sm + 56,
                    left: OpenVtsSpacing.sm,
                    right: OpenVtsSpacing.sm,
                    child: _SearchBar(
                      controller: _searchCtrl,
                      isLoading: _searchLoading,
                      results: _searchResults,
                      onSearch: _searchPlace,
                      onSelectResult: _selectSearchResult,
                    ),
                  ),
                ],
              ),
            ),
          ),
          _Panel(
            latCtrl: _latCtrl,
            lonCtrl: _lonCtrl,
            tolCtrl: _tolCtrl,
            tolerance: _tolerance,
            hasPoint: _point != null,
            onApplyCoords: _applyCoordsFromFields,
            onApplyTolerance: _applyToleranceFromField,
            onToleranceChanged: (value) {
              setState(() {
                _tolerance = value;
                _tolCtrl.text = value > 0 ? value.toStringAsFixed(0) : '';
              });
            },
            onNudgeNorth: () => _nudge(dLat: 1, dLon: 0),
            onNudgeSouth: () => _nudge(dLat: -1, dLon: 0),
            onNudgeEast: () => _nudge(dLat: 0, dLon: 1),
            onNudgeWest: () => _nudge(dLat: 0, dLon: -1),
            onRecenter: () {
              if (_point != null) {
                try {
                  _map.move(_point!, 16);
                } catch (_) {}
              }
            },
            onSave: _save,
          ),
        ],
      ),
    );
  }
}

class _PickerPin extends StatelessWidget {
  const _PickerPin();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: OpenVtsColors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
              blurRadius: 4, color: Color(0x33000000), offset: Offset(0, 2)),
        ],
      ),
      padding: const EdgeInsets.all(3),
      child: Container(
        decoration: const BoxDecoration(
          color: OpenVtsColors.brandInk,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({
    required this.latCtrl,
    required this.lonCtrl,
    required this.tolCtrl,
    required this.tolerance,
    required this.hasPoint,
    required this.onApplyCoords,
    required this.onApplyTolerance,
    required this.onToleranceChanged,
    required this.onNudgeNorth,
    required this.onNudgeSouth,
    required this.onNudgeEast,
    required this.onNudgeWest,
    required this.onRecenter,
    required this.onSave,
  });

  final TextEditingController latCtrl;
  final TextEditingController lonCtrl;
  final TextEditingController tolCtrl;
  final double tolerance;
  final bool hasPoint;
  final VoidCallback onApplyCoords;
  final VoidCallback onApplyTolerance;
  final ValueChanged<double> onToleranceChanged;
  final VoidCallback onNudgeNorth;
  final VoidCallback onNudgeSouth;
  final VoidCallback onNudgeEast;
  final VoidCallback onNudgeWest;
  final VoidCallback onRecenter;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: OpenVtsColors.brandInk,
        border: Border(
          top: BorderSide(color: OpenVtsColors.white),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(
        OpenVtsSpacing.md,
        OpenVtsSpacing.sm,
        OpenVtsSpacing.md,
        OpenVtsSpacing.sm,
      ),
      child: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: _CoordField(
                    label: 'Latitude',
                    controller: latCtrl,
                    onSubmitted: onApplyCoords,
                  ),
                ),
                const SizedBox(width: OpenVtsSpacing.xs),
                Expanded(
                  child: _CoordField(
                    label: 'Longitude',
                    controller: lonCtrl,
                    onSubmitted: onApplyCoords,
                  ),
                ),
                const SizedBox(width: OpenVtsSpacing.xs),
                _IconBtn(
                  icon: Icons.my_location,
                  tooltip: 'Recenter',
                  onTap: hasPoint ? onRecenter : null,
                ),
              ],
            ),
            const SizedBox(height: OpenVtsSpacing.xs),
            Row(
              children: [
                Text(
                  'Nudge 10 m',
                  style: OpenVtsTypography.meta.copyWith(
                    color: OpenVtsColors.white,
                  ),
                ),
                const Spacer(),
                _IconBtn(
                  icon: Icons.arrow_upward,
                  tooltip: 'North',
                  onTap: hasPoint ? onNudgeNorth : null,
                ),
                _IconBtn(
                  icon: Icons.arrow_downward,
                  tooltip: 'South',
                  onTap: hasPoint ? onNudgeSouth : null,
                ),
                _IconBtn(
                  icon: Icons.arrow_back,
                  tooltip: 'West',
                  onTap: hasPoint ? onNudgeWest : null,
                ),
                _IconBtn(
                  icon: Icons.arrow_forward,
                  tooltip: 'East',
                  onTap: hasPoint ? onNudgeEast : null,
                ),
              ],
            ),
            const SizedBox(height: OpenVtsSpacing.xs),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tolerance',
                  style: OpenVtsTypography.label.copyWith(
                    color: OpenVtsColors.white,
                  ),
                ),
                const SizedBox(height: OpenVtsSpacing.xs),
                Row(
                  children: [
                    Expanded(
                      child: Slider(
                        value: tolerance.clamp(0, 1000).toDouble(),
                        min: 0,
                        max: 1000,
                        divisions: 100,
                        activeColor: OpenVtsColors.white,
                        inactiveColor: const Color(0xFF666666),
                        label: tolerance > 0
                            ? '${tolerance.toStringAsFixed(0)} m'
                            : 'off',
                        onChanged: onToleranceChanged,
                      ),
                    ),
                    const SizedBox(width: OpenVtsSpacing.sm),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: OpenVtsColors.brandInk,
                        borderRadius: BorderRadius.circular(4),
                        border:
                            Border.all(color: OpenVtsColors.white, width: 1),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 40,
                            child: TextField(
                              controller: tolCtrl,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9.]')),
                              ],
                              cursorColor: OpenVtsColors.white,
                              style: OpenVtsTypography.numeric.copyWith(
                                color: OpenVtsColors.white,
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.center,
                              decoration: const InputDecoration(
                                isDense: true,
                                filled: false,
                                hintText: '0',
                                hintStyle:
                                    TextStyle(color: OpenVtsColors.white),
                                contentPadding: EdgeInsets.zero,
                                border: InputBorder.none,
                              ),
                              onChanged: (_) => onApplyTolerance(),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'm',
                            style: OpenVtsTypography.label.copyWith(
                              color: OpenVtsColors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: OpenVtsSpacing.xs),
            OpenVtsButton(
              label: hasPoint ? 'Use this location' : 'Tap map to place POI',
              onPressed: hasPoint ? onSave : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _CoordField extends StatelessWidget {
  const _CoordField({
    required this.label,
    required this.controller,
    required this.onSubmitted,
  });

  final String label;
  final TextEditingController controller;
  final VoidCallback onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(
        signed: true,
        decimal: true,
      ),
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[0-9.\-]')),
      ],
      cursorColor: OpenVtsColors.white,
      style: OpenVtsTypography.numeric.copyWith(
        color: OpenVtsColors.white,
      ),
      onSubmitted: (_) => onSubmitted(),
      onEditingComplete: onSubmitted,
      decoration: InputDecoration(
        isDense: true,
        filled: false,
        labelText: label,
        labelStyle: OpenVtsTypography.meta.copyWith(
          color: OpenVtsColors.white,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: OpenVtsSpacing.sm,
          vertical: 10,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(OpenVtsRadius.button),
          borderSide: const BorderSide(color: OpenVtsColors.white),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(OpenVtsRadius.button),
          borderSide: const BorderSide(color: OpenVtsColors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(OpenVtsRadius.button),
          borderSide: const BorderSide(
            color: OpenVtsColors.white,
            width: 1.4,
          ),
        ),
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  const _IconBtn({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;
    return Tooltip(
      message: tooltip,
      child: InkResponse(
        onTap: onTap,
        radius: 20,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(
            icon,
            size: 18,
            color: disabled
                ? OpenVtsColors.white.withValues(alpha: 0.4)
                : OpenVtsColors.white,
          ),
        ),
      ),
    );
  }
}

class _NominatimResult {
  const _NominatimResult({
    required this.label,
    required this.lat,
    required this.lon,
  });

  final String label;
  final double lat;
  final double lon;
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({
    required this.controller,
    required this.isLoading,
    required this.results,
    required this.onSearch,
    required this.onSelectResult,
  });

  final TextEditingController controller;
  final bool isLoading;
  final List<_NominatimResult> results;
  final VoidCallback onSearch;
  final Function(_NominatimResult) onSelectResult;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: OpenVtsColors.brandInk,
        borderRadius: BorderRadius.circular(OpenVtsRadius.md),
        border: Border.all(color: OpenVtsColors.white),
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
              onChanged: (_) => onSearch(),
              cursorColor: OpenVtsColors.white,
              style: OpenVtsTypography.body.copyWith(
                color: OpenVtsColors.white,
              ),
              decoration: InputDecoration(
                isDense: true,
                filled: false,
                hintText: 'Search place...',
                hintStyle: OpenVtsTypography.body.copyWith(
                  color: OpenVtsColors.white.withValues(alpha: 0.6),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  size: 18,
                  color: OpenVtsColors.white,
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
                              OpenVtsColors.white.withValues(alpha: 0.85),
                            ),
                          ),
                        ),
                      )
                    : controller.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close,
                                size: 18, color: OpenVtsColors.white),
                            onPressed: () {
                              controller.clear();
                              onSearch();
                            },
                          )
                        : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                suffixIconColor: OpenVtsColors.white,
              ),
            ),
          ),
          if (results.isNotEmpty)
            Container(
              constraints: const BoxConstraints(maxHeight: 200),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                      color: OpenVtsColors.white.withValues(alpha: 0.2)),
                ),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: results.length,
                itemBuilder: (context, index) {
                  final result = results[index];
                  return InkWell(
                    onTap: () => onSelectResult(result),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Text(
                        result.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: OpenVtsTypography.body.copyWith(
                          color: OpenVtsColors.white,
                        ),
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
