import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/theme/open_vts_colors.dart';
import '../../../../../../core/theme/open_vts_radius.dart';
import '../../../../../../core/theme/open_vts_spacing.dart';
import '../../../../../../core/theme/open_vts_typography.dart';
import '../../../../../../shared/widgets/open_vts_bottom_sheet.dart';
import '../../../../../../shared/widgets/open_vts_button.dart';
import '../../../../controllers/user_providers.dart';
import '../../../../models/user_landmark_model.dart';
import '../../widgets/user_landmark_color_picker.dart';
import 'user_route_editor_screen.dart';

/// Bottom-sheet entry point for creating or editing a route. Metadata is
/// captured here; geometry is drawn in a dedicated full-screen editor. The
/// sheet never performs API calls directly — it dispatches through
/// `userRoutesControllerProvider`.
class UserRouteFormSheet {
  static Future<UserRouteLandmark?> show({
    required BuildContext context,
    UserRouteLandmark? route,
  }) {
    return OpenVtsBottomSheet.show<UserRouteLandmark>(
      context: context,
      title: route == null ? 'New route' : 'Edit route',
      initialChildSize: 0.78,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      draggableChildBuilder: (context, scrollController) {
        return _UserRouteFormBody(
          existing: route,
          scrollController: scrollController,
        );
      },
    );
  }
}

class _UserRouteFormBody extends ConsumerStatefulWidget {
  const _UserRouteFormBody({
    required this.existing,
    required this.scrollController,
  });

  final UserRouteLandmark? existing;
  final ScrollController scrollController;

  @override
  ConsumerState<_UserRouteFormBody> createState() => _UserRouteFormBodyState();
}

class _UserRouteFormBodyState extends ConsumerState<_UserRouteFormBody> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _description;
  late String _color;
  late bool _active;
  List<UserGeoPoint> _points = const <UserGeoPoint>[];
  double _toleranceM = 50;
  bool _alertEnabled = false;
  double _alertToleranceM = 100;
  int _alertCooldownMinutes = 10;

  bool _submitting = false;
  String? _submitError;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _name = TextEditingController(text: existing?.name ?? '');
    _description = TextEditingController(text: existing?.description ?? '');
    _color = existing?.color.isNotEmpty == true
        ? existing!.color
        : kUserLandmarkPalette.first;
    _active = existing?.isActive ?? true;
    _points = existing?.geodata?.coordinates ?? const <UserGeoPoint>[];
    final t = existing?.toleranceMeters ?? existing?.geodata?.toleranceM;
    if (t != null && t > 0) _toleranceM = t;
    final alert = existing?.routeAlert;
    if (alert != null) {
      _alertEnabled = alert.enabled;
      _alertToleranceM = alert.toleranceMeters;
      _alertCooldownMinutes = alert.cooldownMinutes;
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    super.dispose();
  }

  Color get _routeColor {
    final cleaned = _color.replaceAll('#', '').trim();
    final parsed = int.tryParse('FF$cleaned', radix: 16);
    return parsed == null ? OpenVtsColors.brandInk : Color(parsed);
  }

  Future<void> _openEditor() async {
    final result = await Navigator.of(context).push<UserRouteEditorResult>(
      MaterialPageRoute<UserRouteEditorResult>(
        fullscreenDialog: true,
        builder: (_) => UserRouteEditorScreen(
          initialPoints: _points,
          initialToleranceM: _toleranceM,
          routeColor: _routeColor,
          title: widget.existing == null ? 'Draw route' : 'Edit route',
        ),
      ),
    );
    if (result == null || !mounted) return;
    setState(() {
      _points = result.points;
      _toleranceM = result.toleranceM;
      _submitError = null;
    });
  }

  Future<void> _submit() async {
    if (_submitting) return;
    if (!_formKey.currentState!.validate()) return;
    if (_points.length < 2) {
      setState(() => _submitError = 'Draw at least 2 route points.');
      return;
    }
    if (!_isValidHex(_color)) {
      setState(() => _submitError = 'Pick a valid color.');
      return;
    }
    if (_toleranceM < 1) {
      setState(
        () => _submitError = 'Tolerance must be at least 1 meter.',
      );
      return;
    }

    setState(() {
      _submitting = true;
      _submitError = null;
    });

    final controller = ref.read(userRoutesControllerProvider.notifier);
    try {
      final UserRouteLandmark saved;
      final geodata = UserLineGeoData(
        coordinates: _points,
        toleranceM: _toleranceM,
      );
      final routeAlert = _alertEnabled
          ? UserRouteAlert(
              enabled: true,
              toleranceMeters: _alertToleranceM,
              cooldownMinutes: _alertCooldownMinutes,
            )
          : null;
      if (widget.existing == null) {
        saved = await controller.createRoute(
          CreateUserRouteRequest(
            name: _name.text.trim(),
            description: _description.text.trim().isEmpty
                ? null
                : _description.text.trim(),
            color: _color,
            isActive: _active,
            toleranceMeters: _toleranceM,
            geodata: geodata,
            routeAlert: routeAlert,
          ),
        );
      } else {
        saved = await controller.updateRoute(
          widget.existing!.id,
          UpdateUserRouteRequest(
            name: _name.text.trim(),
            description: _description.text.trim(),
            color: _color,
            isActive: _active,
            toleranceMeters: _toleranceM,
            geodata: geodata,
            routeAlert: routeAlert,
          ),
        );
      }
      if (!mounted) return;
      Navigator.of(context).pop(saved);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _submitError = e.toString();
        _submitting = false;
      });
    }
  }

  bool _isValidHex(String value) {
    final v = value.replaceAll('#', '').trim();
    if (v.length != 6) return false;
    return int.tryParse(v, radix: 16) != null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        controller: widget.scrollController,
        padding: const EdgeInsets.fromLTRB(
          OpenVtsSpacing.md,
          OpenVtsSpacing.sm,
          OpenVtsSpacing.md,
          OpenVtsSpacing.lg,
        ),
        children: [
          const _SectionLabel('Details'),
          const SizedBox(height: OpenVtsSpacing.xs),
          const _FieldLabel('Name'),
          TextFormField(
            controller: _name,
            style: OpenVtsTypography.body,
            decoration: _denseDecoration(hint: 'e.g. Mumbai → Pune corridor'),
            validator: (value) {
              final v = value?.trim() ?? '';
              if (v.length < 2) return 'Enter at least 2 characters.';
              return null;
            },
          ),
          const SizedBox(height: OpenVtsSpacing.sm),
          const _FieldLabel('Description (optional)'),
          TextFormField(
            controller: _description,
            style: OpenVtsTypography.body,
            maxLines: 2,
            decoration: _denseDecoration(hint: 'Notes for your team'),
          ),
          const SizedBox(height: OpenVtsSpacing.md),
          const _SectionLabel('Geometry'),
          const SizedBox(height: OpenVtsSpacing.xs),
          _GeometryCard(
            points: _points,
            toleranceM: _toleranceM,
            onOpenEditor: _openEditor,
          ),
          const SizedBox(height: OpenVtsSpacing.md),
          const _SectionLabel('Route alerts'),
          const SizedBox(height: OpenVtsSpacing.xs),
          _RouteAlertSection(
            enabled: _alertEnabled,
            toleranceM: _alertToleranceM,
            cooldownMinutes: _alertCooldownMinutes,
            onEnabledChanged: (v) => setState(() => _alertEnabled = v),
            onToleranceChanged: (v) => setState(() => _alertToleranceM = v),
            onCooldownChanged: (v) => setState(() => _alertCooldownMinutes = v),
          ),
          const SizedBox(height: OpenVtsSpacing.md),
          const _SectionLabel('Appearance'),
          const SizedBox(height: OpenVtsSpacing.xs),
          UserLandmarkColorPicker(
            value: _color,
            onChanged: (hex) => setState(() => _color = hex),
          ),
          const SizedBox(height: OpenVtsSpacing.sm),
          _ActiveToggle(
            value: _active,
            onChanged: (v) => setState(() => _active = v),
          ),
          if (_submitError != null) ...[
            const SizedBox(height: OpenVtsSpacing.sm),
            Text(
              _submitError!,
              style: OpenVtsTypography.meta.copyWith(
                color: OpenVtsColors.error,
              ),
            ),
          ],
          const SizedBox(height: OpenVtsSpacing.md),
          OpenVtsButton(
            label: widget.existing == null ? 'Create route' : 'Save changes',
            onPressed: _submit,
            isLoading: _submitting,
          ),
          const SizedBox(height: OpenVtsSpacing.xs),
          Center(
            child: TextButton(
              onPressed: _submitting ? null : () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: OpenVtsTypography.label.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _denseDecoration({String? hint}) {
    return InputDecoration(
      isDense: true,
      hintText: hint,
      hintStyle: OpenVtsTypography.body.copyWith(
        color: Theme.of(context).colorScheme.outline,
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: OpenVtsSpacing.sm,
        vertical: 10,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(OpenVtsRadius.button),
        borderSide: const BorderSide(color: OpenVtsColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(OpenVtsRadius.button),
        borderSide: const BorderSide(color: OpenVtsColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(OpenVtsRadius.button),
        borderSide: const BorderSide(color: OpenVtsColors.brandInk, width: 1.4),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: OpenVtsTypography.meta.copyWith(
        color: Theme.of(context).colorScheme.outline,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.6,
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        label,
        style: OpenVtsTypography.meta.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _GeometryCard extends StatelessWidget {
  const _GeometryCard({
    required this.points,
    required this.toleranceM,
    required this.onOpenEditor,
  });

  final List<UserGeoPoint> points;
  final double toleranceM;
  final VoidCallback onOpenEditor;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? OpenVtsColors.brandInk : OpenVtsColors.surface;
    final textColor = isDark ? OpenVtsColors.white : OpenVtsColors.textPrimary;
    final borderColor = isDark ? OpenVtsColors.white : OpenVtsColors.border;
    final hasGeometry = points.length >= 2;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(OpenVtsRadius.lg),
        border: Border.all(color: borderColor),
      ),
      padding: const EdgeInsets.all(OpenVtsSpacing.sm),
      child: Row(
        children: [
          Icon(
            Icons.timeline,
            size: 18,
            color: textColor,
          ),
          const SizedBox(width: OpenVtsSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hasGeometry ? '${points.length} points' : 'No geometry yet',
                  style: OpenVtsTypography.label.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  hasGeometry
                      ? 'Tolerance ±${toleranceM.toStringAsFixed(0)} m'
                      : 'Draw at least 2 points on the map.',
                  style: OpenVtsTypography.meta.copyWith(
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onOpenEditor,
            style: TextButton.styleFrom(
              foregroundColor: textColor,
            ),
            child: Text(
              hasGeometry ? 'Edit on map' : 'Draw on map',
              style: OpenVtsTypography.label.copyWith(
                color: textColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActiveToggle extends StatelessWidget {
  const _ActiveToggle({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? OpenVtsColors.brandInk : OpenVtsColors.surface;
    final textColor = isDark ? OpenVtsColors.white : OpenVtsColors.textPrimary;
    final borderColor = isDark ? OpenVtsColors.white : OpenVtsColors.border;
    final toggleBgOn = isDark ? OpenVtsColors.white : OpenVtsColors.textPrimary;
    final toggleBgOff = isDark ? const Color(0xFF555555) : OpenVtsColors.border;
    final toggleThumbColor =
        isDark ? OpenVtsColors.brandInk : OpenVtsColors.white;
    final toggleThumbBorder =
        isDark ? OpenVtsColors.white : OpenVtsColors.textPrimary;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(OpenVtsRadius.lg),
        border: Border.all(color: borderColor),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: OpenVtsSpacing.sm,
        vertical: 6,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Active',
                  style: OpenVtsTypography.label.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Inactive routes stay archived but visible.',
                  style: OpenVtsTypography.meta.copyWith(
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => onChanged(!value),
            child: Container(
              width: 50,
              height: 28,
              decoration: BoxDecoration(
                color: value ? toggleBgOn : toggleBgOff,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: borderColor, width: 1),
              ),
              child: Row(
                children: [
                  if (!value)
                    Expanded(
                      child: Container(),
                    ),
                  Container(
                    width: 24,
                    height: 24,
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: toggleThumbColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: toggleThumbBorder, width: 1),
                    ),
                    child: Icon(
                      Icons.check,
                      size: 14,
                      color: isDark ? OpenVtsColors.white : bgColor,
                    ),
                  ),
                  if (value)
                    Expanded(
                      child: Container(),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RouteAlertSection extends StatelessWidget {
  const _RouteAlertSection({
    required this.enabled,
    required this.toleranceM,
    required this.cooldownMinutes,
    required this.onEnabledChanged,
    required this.onToleranceChanged,
    required this.onCooldownChanged,
  });

  final bool enabled;
  final double toleranceM;
  final int cooldownMinutes;
  final ValueChanged<bool> onEnabledChanged;
  final ValueChanged<double> onToleranceChanged;
  final ValueChanged<int> onCooldownChanged;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? OpenVtsColors.brandInk : OpenVtsColors.surface;
    final textColor = isDark ? OpenVtsColors.white : OpenVtsColors.textPrimary;
    final borderColor = isDark ? OpenVtsColors.white : OpenVtsColors.border;
    final toggleBgOn = isDark ? OpenVtsColors.white : OpenVtsColors.textPrimary;
    final toggleBgOff = isDark ? const Color(0xFF555555) : OpenVtsColors.border;
    final toggleThumbColor =
        isDark ? OpenVtsColors.brandInk : OpenVtsColors.white;
    final toggleThumbBorder =
        isDark ? OpenVtsColors.white : OpenVtsColors.textPrimary;
    final chipBgUnselected = isDark
        ? OpenVtsColors.white.withValues(alpha: 0.1)
        : OpenVtsColors.border;
    final chipBgSelected =
        isDark ? OpenVtsColors.white : OpenVtsColors.textPrimary;
    final chipTextSelected =
        isDark ? OpenVtsColors.brandInk : OpenVtsColors.white;
    final chipBorderUnselected = isDark
        ? OpenVtsColors.white.withValues(alpha: 0.5)
        : OpenVtsColors.border;
    final chipBorderSelected = isDark ? OpenVtsColors.white : borderColor;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(OpenVtsRadius.lg),
        border: Border.all(color: borderColor),
      ),
      padding: const EdgeInsets.all(OpenVtsSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Notify when vehicle leaves route',
                      style: OpenVtsTypography.label.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Get notified when assigned vehicles deviate.',
                      style: OpenVtsTypography.meta.copyWith(
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => onEnabledChanged(!enabled),
                child: Container(
                  width: 50,
                  height: 28,
                  decoration: BoxDecoration(
                    color: enabled ? toggleBgOn : toggleBgOff,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: borderColor, width: 1),
                  ),
                  child: Row(
                    children: [
                      if (!enabled)
                        Expanded(
                          child: Container(),
                        ),
                      Container(
                        width: 24,
                        height: 24,
                        margin: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: toggleThumbColor,
                          borderRadius: BorderRadius.circular(12),
                          border:
                              Border.all(color: toggleThumbBorder, width: 1),
                        ),
                        child: Icon(
                          Icons.check,
                          size: 14,
                          color: isDark ? OpenVtsColors.white : bgColor,
                        ),
                      ),
                      if (enabled)
                        Expanded(
                          child: Container(),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (enabled) ...[
            const SizedBox(height: OpenVtsSpacing.sm),
            Divider(color: borderColor, height: 1),
            const SizedBox(height: OpenVtsSpacing.sm),
            Text(
              'Allowed deviation',
              style: OpenVtsTypography.meta.copyWith(
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: OpenVtsSpacing.xs),
            Wrap(
              spacing: OpenVtsSpacing.xs,
              children: [50.0, 100.0, 200.0, 500.0].map((value) {
                final isSelected = (toleranceM - value).abs() < 1;
                return ChoiceChip(
                  label: Text('${value.toInt()}m'),
                  selected: isSelected,
                  onSelected: (_) => onToleranceChanged(value),
                  backgroundColor: chipBgUnselected,
                  selectedColor: chipBgSelected,
                  labelStyle: OpenVtsTypography.meta.copyWith(
                    color: isSelected ? chipTextSelected : textColor,
                    fontWeight: FontWeight.w600,
                  ),
                  side: BorderSide(
                    color:
                        isSelected ? chipBorderSelected : chipBorderUnselected,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: OpenVtsSpacing.sm),
            Text(
              'Notification cooldown',
              style: OpenVtsTypography.meta.copyWith(
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: OpenVtsSpacing.xs),
            Wrap(
              spacing: OpenVtsSpacing.xs,
              children: [5, 10, 15, 30].map((value) {
                final isSelected = cooldownMinutes == value;
                return ChoiceChip(
                  label: Text('${value}min'),
                  selected: isSelected,
                  onSelected: (_) => onCooldownChanged(value),
                  backgroundColor: chipBgUnselected,
                  selectedColor: chipBgSelected,
                  labelStyle: OpenVtsTypography.meta.copyWith(
                    color: isSelected ? chipTextSelected : textColor,
                    fontWeight: FontWeight.w600,
                  ),
                  side: BorderSide(
                    color:
                        isSelected ? chipBorderSelected : chipBorderUnselected,
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}
