import 'package:flutter/material.dart';

import '../../core/theme/open_vts_colors.dart' as open_vts_colors;

// ---------------------------------------------------------------------------
// Layer option and selector button
// ---------------------------------------------------------------------------

class MapLayerOption {
  const MapLayerOption({
    required this.id,
    required this.name,
    required this.shortLabel,
    required this.url,
    required this.subdomains,
    required this.previewStyle,
  });

  final String id;
  final String name;
  final String shortLabel;
  final String url;
  final List<String> subdomains;
  final MapLayerPreviewStyle previewStyle;
}

enum MapLayerPreviewStyle {
  road,
  satellite,
  terrain,
  hybrid,
  osm,
  dark,
  light,
  voyager,
  esriSatellite,
  toner,
  watercolor,
}

const List<String> _googleTileSubdomains = ['mt0', 'mt1', 'mt2', 'mt3'];
const List<String> _cartoTileSubdomains = ['a', 'b', 'c', 'd'];

const List<MapLayerOption> primaryMapLayerOptions = [
  MapLayerOption(
    id: 'google-road',
    name: 'Google Road',
    shortLabel: 'Road',
    url: 'https://{s}.google.com/vt/lyrs=m&x={x}&y={y}&z={z}',
    subdomains: _googleTileSubdomains,
    previewStyle: MapLayerPreviewStyle.road,
  ),
  MapLayerOption(
    id: 'google-satellite',
    name: 'Google Satellite',
    shortLabel: 'Satellite',
    url: 'https://{s}.google.com/vt/lyrs=s&x={x}&y={y}&z={z}',
    subdomains: _googleTileSubdomains,
    previewStyle: MapLayerPreviewStyle.satellite,
  ),
  MapLayerOption(
    id: 'esri-topo',
    name: 'Esri Topographic',
    shortLabel: 'Terrain',
    url:
        'https://server.arcgisonline.com/ArcGIS/rest/services/World_Topo_Map/MapServer/tile/{z}/{y}/{x}',
    subdomains: <String>[],
    previewStyle: MapLayerPreviewStyle.terrain,
  ),
];

const List<MapLayerOption> detailMapLayerOptions = [
  MapLayerOption(
    id: 'google-hybrid',
    name: 'Google Hybrid',
    shortLabel: 'Hybrid',
    url: 'https://{s}.google.com/vt/lyrs=s,h&x={x}&y={y}&z={z}',
    subdomains: _googleTileSubdomains,
    previewStyle: MapLayerPreviewStyle.hybrid,
  ),
  MapLayerOption(
    id: 'osm',
    name: 'OpenStreetMap',
    shortLabel: 'OSM',
    url: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
    subdomains: <String>[],
    previewStyle: MapLayerPreviewStyle.osm,
  ),
  MapLayerOption(
    id: 'carto-dark',
    name: 'CartoDB Dark',
    shortLabel: 'Dark',
    url: 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png',
    subdomains: _cartoTileSubdomains,
    previewStyle: MapLayerPreviewStyle.dark,
  ),
  MapLayerOption(
    id: 'carto-light',
    name: 'CartoDB Light',
    shortLabel: 'Light',
    url: 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
    subdomains: _cartoTileSubdomains,
    previewStyle: MapLayerPreviewStyle.light,
  ),
  MapLayerOption(
    id: 'carto-voyager',
    name: 'CartoDB Voyager',
    shortLabel: 'Voyager',
    url:
        'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png',
    subdomains: _cartoTileSubdomains,
    previewStyle: MapLayerPreviewStyle.voyager,
  ),
  MapLayerOption(
    id: 'esri-satellite',
    name: 'Esri Satellite',
    shortLabel: 'Esri Sat',
    url:
        'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
    subdomains: <String>[],
    previewStyle: MapLayerPreviewStyle.esriSatellite,
  ),
  MapLayerOption(
    id: 'stamen-toner',
    name: 'Stamen Toner',
    shortLabel: 'Toner',
    url: 'https://tiles.stadiamaps.com/tiles/stamen_toner/{z}/{x}/{y}.png',
    subdomains: <String>[],
    previewStyle: MapLayerPreviewStyle.toner,
  ),
  MapLayerOption(
    id: 'stamen-watercolor',
    name: 'Stamen Watercolor',
    shortLabel: 'Watercolor',
    url: 'https://tiles.stadiamaps.com/tiles/stamen_watercolor/{z}/{x}/{y}.jpg',
    subdomains: <String>[],
    previewStyle: MapLayerPreviewStyle.watercolor,
  ),
];

MapLayerOption? mapLayerOptionById(String? id) {
  final normalizedId = id?.trim();
  if (normalizedId == null || normalizedId.isEmpty) {
    return null;
  }

  for (final layer in [
    ...primaryMapLayerOptions,
    ...detailMapLayerOptions,
  ]) {
    if (layer.id == normalizedId) {
      return layer;
    }
  }

  return null;
}

/// Compact map layer selector button for use in landmarks and other maps.
/// Shows as a single icon button that opens a drawer with all layer options.
class OpenVtsMapLayerSelectorButton extends StatelessWidget {
  const OpenVtsMapLayerSelectorButton({
    super.key,
    required this.selectedLayerId,
    required this.onLayerSelected,
  });

  final String selectedLayerId;
  final ValueChanged<MapLayerOption> onLayerSelected;

  Future<void> _openLayerDrawer(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: isDark
          ? open_vts_colors.OpenVtsColors.darkSurface
          : open_vts_colors.OpenVtsColors.surfaceElevated,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _MapLayerDrawerSheet(
        initialLayerId: selectedLayerId,
        onLayerSelected: (layer) {
          onLayerSelected(layer);
          if (context.mounted) {
            Navigator.pop(context);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _openLayerDrawer(context),
        customBorder: const CircleBorder(),
        child: Ink(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: open_vts_colors.OpenVtsColors.brandInk,
            shape: BoxShape.circle,
            border: Border.all(
                color: open_vts_colors.OpenVtsColors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Icon(
            Icons.layers_rounded,
            size: 22,
            color: open_vts_colors.OpenVtsColors.white,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Drawer content
// ---------------------------------------------------------------------------

class _MapLayerDrawerSheet extends StatefulWidget {
  const _MapLayerDrawerSheet({
    required this.initialLayerId,
    required this.onLayerSelected,
  });

  final String initialLayerId;
  final ValueChanged<MapLayerOption> onLayerSelected;

  @override
  State<_MapLayerDrawerSheet> createState() => _MapLayerDrawerSheetState();
}

class _MapLayerDrawerSheetState extends State<_MapLayerDrawerSheet> {
  late String _selectedLayerId;

  @override
  void initState() {
    super.initState();
    _selectedLayerId = widget.initialLayerId;
  }

  void _selectLayer(MapLayerOption layer) {
    setState(() {
      _selectedLayerId = layer.id;
    });
    widget.onLayerSelected(layer);
  }

  @override
  Widget build(BuildContext context) {
    final primaryOptions = primaryMapLayerOptions;
    final detailOptions = detailMapLayerOptions;
    final cs = Theme.of(context).colorScheme;

    return SafeArea(
      top: false,
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.74,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              Align(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: cs.onSurface.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Map type',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: cs.onSurface,
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () => Navigator.of(context).pop(),
                              visualDensity: VisualDensity.compact,
                              splashRadius: 18,
                              icon: const Icon(Icons.close_rounded),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            for (var index = 0;
                                index < primaryOptions.length;
                                index++) ...[
                              Expanded(
                                child: _MapLayerCard(
                                  option: primaryOptions[index],
                                  isSelected: _selectedLayerId ==
                                      primaryOptions[index].id,
                                  onTap: () =>
                                      _selectLayer(primaryOptions[index]),
                                  large: true,
                                ),
                              ),
                              if (index != primaryOptions.length - 1)
                                const SizedBox(width: 14),
                            ],
                          ],
                        ),
                        const SizedBox(height: 14),
                        Divider(
                          color: cs.outlineVariant,
                          height: 1,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Map details',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: cs.onSurface,
                          ),
                        ),
                        const SizedBox(height: 12),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: detailOptions.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 14,
                            childAspectRatio: 0.78,
                          ),
                          itemBuilder: (context, index) {
                            final option = detailOptions[index];
                            return _MapLayerCard(
                              option: option,
                              isSelected: _selectedLayerId == option.id,
                              onTap: () => _selectLayer(option),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MapLayerCard extends StatelessWidget {
  const _MapLayerCard({
    required this.option,
    required this.isSelected,
    required this.onTap,
    this.large = false,
  });

  final MapLayerOption option;
  final bool isSelected;
  final VoidCallback onTap;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final labelColor =
        isSelected ? const Color(0xFF1293A6) : cs.onSurfaceVariant;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Tooltip(
        message: option.name,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color:
                      isSelected ? const Color(0xFF1293A6) : cs.outlineVariant,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  height: large ? 58 : 52,
                  width: double.infinity,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      _MapLayerPreview(option: option),
                      if (isSelected)
                        Positioned(
                          top: 6,
                          right: 6,
                          child: Container(
                            width: 18,
                            height: 18,
                            decoration: const BoxDecoration(
                              color: Color(0xFF1293A6),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check_rounded,
                              size: 13,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              option.shortLabel,
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: large ? 12 : 10,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                color: labelColor,
                height: 1.15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MapLayerPreview extends StatelessWidget {
  const _MapLayerPreview({required this.option});

  final MapLayerOption option;

  @override
  Widget build(BuildContext context) {
    switch (option.previewStyle) {
      case MapLayerPreviewStyle.road:
        return Stack(
          fit: StackFit.expand,
          children: [
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFD6F1E4), Color(0xFFB8E3E8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            Positioned(
              left: -8,
              bottom: -6,
              child: Transform.rotate(
                angle: -0.28,
                child: Container(
                  width: 70,
                  height: 30,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7EFE0),
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
            ),
            Positioned(
              right: -6,
              top: -4,
              child: Transform.rotate(
                angle: 0.8,
                child: Container(
                  width: 56,
                  height: 18,
                  decoration: BoxDecoration(
                    color: const Color(0xFF7EC6DF),
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 18,
              top: 10,
              child: Transform.rotate(
                angle: -0.75,
                child: Container(
                  width: 60,
                  height: 7,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        );
      case MapLayerPreviewStyle.satellite:
        return Stack(
          fit: StackFit.expand,
          children: [
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF6A7266), Color(0xFF444A42)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            Positioned(
              left: -8,
              top: 22,
              child: Transform.rotate(
                angle: 0.64,
                child: Container(
                  width: 92,
                  height: 12,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD3D1CB),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            Positioned(
              left: -6,
              top: 24,
              child: Transform.rotate(
                angle: 0.64,
                child: Container(
                  width: 92,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFF7D8378),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        );
      case MapLayerPreviewStyle.terrain:
        return Stack(
          fit: StackFit.expand,
          children: [
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFD6E0D0), Color(0xFFA9BC9D)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            Positioned(
              right: -8,
              top: -6,
              child: Transform.rotate(
                angle: 0.42,
                child: Container(
                  width: 50,
                  height: 82,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F0E6),
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 10,
              top: 4,
              child: Transform.rotate(
                angle: 0.38,
                child: Container(
                  width: 7,
                  height: 70,
                  decoration: BoxDecoration(
                    color: const Color(0xFF7BB9A8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        );
      case MapLayerPreviewStyle.hybrid:
        return Stack(
          fit: StackFit.expand,
          children: [
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF49514A), Color(0xFF313731)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            Positioned(
              left: -8,
              top: 22,
              child: Transform.rotate(
                angle: 0.58,
                child: Container(
                  width: 96,
                  height: 11,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            Positioned(
              left: -6,
              top: 24,
              child: Transform.rotate(
                angle: 0.58,
                child: Container(
                  width: 96,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFF879180),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        );
      case MapLayerPreviewStyle.osm:
        return Stack(
          fit: StackFit.expand,
          children: [
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFE8F5EC), Color(0xFFD6E7F3)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            Positioned(
              left: -4,
              bottom: 10,
              child: Transform.rotate(
                angle: 0.1,
                child: Container(
                  width: 86,
                  height: 10,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F1E3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 8,
              top: -10,
              child: Transform.rotate(
                angle: 0.8,
                child: Container(
                  width: 54,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        );
      case MapLayerPreviewStyle.dark:
        return Stack(
          fit: StackFit.expand,
          children: [
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF22272E), Color(0xFF111419)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            Positioned(
              left: 6,
              top: 10,
              child: Container(
                width: 56,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            Positioned(
              right: 6,
              bottom: 12,
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        );
      case MapLayerPreviewStyle.light:
        return Stack(
          fit: StackFit.expand,
          children: [
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFF8F8F8), Color(0xFFE8ECEF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            Positioned(
              left: -2,
              bottom: 12,
              child: Container(
                width: 88,
                height: 7,
                decoration: BoxDecoration(
                  color: const Color(0xFFC7CDD3),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Positioned(
              left: 12,
              top: -8,
              child: Transform.rotate(
                angle: 0.84,
                child: Container(
                  width: 54,
                  height: 6,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD4D8DE),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        );
      case MapLayerPreviewStyle.voyager:
        return Stack(
          fit: StackFit.expand,
          children: [
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFE5F6F1), Color(0xFFF4F3E6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            Positioned(
              left: 10,
              top: 10,
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF87C8B4), width: 7),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              left: -10,
              top: 22,
              child: Container(
                width: 60,
                height: 8,
                decoration: BoxDecoration(
                  color: const Color(0xFFB7D9E7),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        );
      case MapLayerPreviewStyle.esriSatellite:
        return Stack(
          fit: StackFit.expand,
          children: [
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF4E5C58), Color(0xFF29322F)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            Positioned(
              right: -12,
              top: 8,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFF6F8D86).withValues(alpha: 0.7),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              left: 8,
              bottom: 8,
              child: Container(
                width: 36,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.72),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        );
      case MapLayerPreviewStyle.toner:
        return Stack(
          fit: StackFit.expand,
          children: [
            const DecoratedBox(
              decoration: BoxDecoration(color: Color(0xFFF4F4F4)),
            ),
            Positioned(
              left: -10,
              top: 20,
              child: Transform.rotate(
                angle: 0.55,
                child: Container(
                  width: 100,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 18,
              bottom: 14,
              child: Container(
                width: 38,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.65),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        );
      case MapLayerPreviewStyle.watercolor:
        return Stack(
          fit: StackFit.expand,
          children: [
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFF8E2D0), Color(0xFFD6ECF2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            Positioned(
              left: -8,
              top: 4,
              child: Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFFE3C8A5).withValues(alpha: 0.7),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              right: -6,
              bottom: -6,
              child: Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFF8EC3D9).withValues(alpha: 0.72),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        );
    }
  }
}
