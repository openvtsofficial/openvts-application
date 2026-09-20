import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/open_vts_colors.dart';
import '../../../../core/theme/open_vts_radius.dart';
import '../../../../core/theme/open_vts_spacing.dart';
import '../../../../core/theme/open_vts_typography.dart';
import '../../../../shared/widgets/open_vts_page_scaffold.dart';
import '../../models/user_report_model.dart';

class UserReportsCatalogScreen extends StatefulWidget {
  const UserReportsCatalogScreen({super.key});

  @override
  State<UserReportsCatalogScreen> createState() =>
      _UserReportsCatalogScreenState();
}

class _UserReportsCatalogScreenState extends State<UserReportsCatalogScreen> {
  final _searchCtrl = TextEditingController();
  String _query = '';

  static const _catalog = [
    _CatalogEntry(
      key: UserReportKey.distance,
      icon: Icons.route_rounded,
      title: 'Distance',
      description:
          'Total distance driven per vehicle per day with engine hours and odometer readings.',
    ),
    _CatalogEntry(
      key: UserReportKey.driven,
      icon: Icons.calendar_month_rounded,
      title: 'Driven Days',
      description:
          'Daily distance matrix — which vehicles moved on which days and how far.',
    ),
    _CatalogEntry(
      key: UserReportKey.details,
      icon: Icons.info_outline_rounded,
      title: 'Vehicle Details',
      description:
          'Fleet summary: total distance, engine hours, active days, last known location per vehicle.',
    ),
    _CatalogEntry(
      key: UserReportKey.overspeed,
      icon: Icons.speed_rounded,
      title: 'Overspeed',
      description:
          'Speeding events with observed speed, configured limit, excess, duration, and location.',
    ),
    _CatalogEntry(
      key: UserReportKey.geofence,
      icon: Icons.location_city_rounded,
      title: 'Geofence',
      description:
          'Entry and exit events for selected geofences with timestamps and dwell duration.',
    ),
    _CatalogEntry(
      key: UserReportKey.alerts,
      icon: Icons.notifications_rounded,
      title: 'Alerts',
      description:
          'Alert events by type and severity with acknowledgement status.',
    ),
    _CatalogEntry(
      key: UserReportKey.sensor,
      icon: Icons.sensors_rounded,
      title: 'Sensor',
      description:
          'Time-series readings for a specific sensor on a single vehicle with chart visualisation.',
    ),
    _CatalogEntry(
      key: UserReportKey.logs,
      icon: Icons.terminal_rounded,
      title: 'Device Logs',
      description:
          'Raw communication logs from vehicle devices grouped by category and level.',
    ),
    _CatalogEntry(
      key: UserReportKey.timeline,
      icon: Icons.timeline_rounded,
      title: 'Timeline',
      description:
          'Running and stopped segments with duration, distance, and GPS map trace per segment.',
    ),
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _query.isEmpty
        ? _catalog
        : _catalog.where((e) {
            final q = _query.toLowerCase();
            return e.title.toLowerCase().contains(q) ||
                e.description.toLowerCase().contains(q);
          }).toList();

    return OpenVtsPageScaffold(
      title: 'Reports',
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
                OpenVtsSpacing.md, OpenVtsSpacing.sm, OpenVtsSpacing.md, 0),
            child: _SearchBar(
                controller: _searchCtrl,
                onChanged: (v) => setState(() => _query = v)),
          ),
          Expanded(
            child: filtered.isEmpty
                ? _EmptySearch(query: _query)
                : ListView.builder(
                    padding: const EdgeInsets.all(OpenVtsSpacing.md),
                    itemCount: filtered.length,
                    itemBuilder: (context, i) => _CatalogCard(
                        entry: filtered[i],
                        onTap: () => _openReport(context, filtered[i].key)),
                  ),
          ),
        ],
      ),
    );
  }

  void _openReport(BuildContext context, UserReportKey key) {
    context.push(RoutePaths.userReportWorkspacePath(key.name));
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.controller, required this.onChanged});
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: 'Search reports…',
        hintStyle:
            OpenVtsTypography.body.copyWith(color: OpenVtsColors.textSecondary),
        prefixIcon: const Icon(Icons.search_rounded, size: 20),
        suffixIcon: controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear_rounded, size: 18),
                onPressed: () {
                  controller.clear();
                  onChanged('');
                })
            : null,
        filled: true,
        fillColor: isDark ? OpenVtsColors.darkSurface : OpenVtsColors.white,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(OpenVtsRadius.md),
            borderSide: BorderSide(
                color:
                    isDark ? OpenVtsColors.darkBorder : OpenVtsColors.border)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(OpenVtsRadius.md),
            borderSide: BorderSide(
                color:
                    isDark ? OpenVtsColors.darkBorder : OpenVtsColors.border)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(OpenVtsRadius.md),
            borderSide: BorderSide(color: OpenVtsColors.brandInk)),
        contentPadding: const EdgeInsets.symmetric(
            horizontal: OpenVtsSpacing.sm, vertical: 10),
      ),
    );
  }
}

class _CatalogCard extends StatelessWidget {
  const _CatalogCard({required this.entry, required this.onTap});
  final _CatalogEntry entry;
  final VoidCallback onTap;

  static const _dateChip = {
    UserReportKey.distance: 'Date range',
    UserReportKey.driven: 'Date & time',
    UserReportKey.details: 'Date range',
    UserReportKey.geofence: 'Date & time',
    UserReportKey.alerts: 'Date & time',
    UserReportKey.overspeed: 'Date & time',
    UserReportKey.sensor: 'Date & time',
    UserReportKey.logs: 'Date & time',
    UserReportKey.timeline: 'Date range',
  };
  static const _scopeChip = {
    UserReportKey.sensor: 'Single vehicle',
    UserReportKey.logs: 'Single vehicle',
  };

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dateLabel = _dateChip[entry.key] ?? 'Date range';
    final scopeLabel = _scopeChip[entry.key];
    return Padding(
      padding: const EdgeInsets.only(bottom: OpenVtsSpacing.sm),
      child: InkWell(
        borderRadius: BorderRadius.circular(OpenVtsRadius.lg),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(OpenVtsSpacing.sm),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(OpenVtsRadius.lg),
            border: Border.all(
                color:
                    isDark ? OpenVtsColors.darkBorder : OpenVtsColors.border),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isDark
                      ? OpenVtsColors.brandInk.withValues(alpha: 0.18)
                      : OpenVtsColors.brandInk.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(OpenVtsRadius.md),
                ),
                child: Icon(entry.icon,
                    size: 22,
                    color:
                        isDark ? OpenVtsColors.white : OpenVtsColors.brandInk),
              ),
              const SizedBox(width: OpenVtsSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Text(entry.title,
                          style: OpenVtsTypography.label
                              .copyWith(fontWeight: FontWeight.w700)),
                      const Spacer(),
                      const Icon(Icons.chevron_right_rounded,
                          size: 18, color: OpenVtsColors.textSecondary),
                    ]),
                    const SizedBox(height: 3),
                    Text(entry.description,
                        style: OpenVtsTypography.meta
                            .copyWith(color: OpenVtsColors.textSecondary),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 6),
                    Wrap(spacing: 4, runSpacing: 4, children: [
                      _Chip(label: dateLabel),
                      if (scopeLabel != null)
                        _Chip(label: scopeLabel, color: OpenVtsColors.info),
                    ]),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, this.color});
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = color ?? OpenVtsColors.textSecondary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(OpenVtsRadius.sm),
        border: Border.all(color: c.withValues(alpha: 0.25)),
      ),
      child: Text(label,
          style: OpenVtsTypography.meta.copyWith(color: c, fontSize: 11)),
    );
  }
}

class _EmptySearch extends StatelessWidget {
  const _EmptySearch({required this.query});
  final String query;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(OpenVtsSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off_rounded,
                size: 48, color: OpenVtsColors.textSecondary),
            const SizedBox(height: OpenVtsSpacing.sm),
            Text('No reports found for "$query"',
                style: OpenVtsTypography.body
                    .copyWith(color: OpenVtsColors.textSecondary),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _CatalogEntry {
  const _CatalogEntry(
      {required this.key,
      required this.icon,
      required this.title,
      required this.description});
  final UserReportKey key;
  final IconData icon;
  final String title;
  final String description;
}
