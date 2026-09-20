import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/open_vts_colors.dart';
import '../../../../../core/theme/open_vts_radius.dart';
import '../../../../../core/theme/open_vts_spacing.dart';
import '../../../../../core/theme/open_vts_typography.dart';
import '../../../../../core/utils/date_time_formatter.dart';
import '../../../../../shared/helpers/toast_helper.dart';
import '../../../../../shared/widgets/open_vts_button.dart';
import '../../../../../shared/widgets/open_vts_card.dart';
import '../../../controllers/admin_driver_details_controller.dart';
import '../../../controllers/admin_providers.dart';
import '../../../models/admin_driver_details_model.dart';
import '../../../models/admin_driver_details_state.dart';
import '../../../models/admin_users_model.dart';
import '../../../utils/location_label_resolver.dart';
import 'admin_driver_edit_sheet.dart';
import 'admin_driver_password_sheet.dart';

class AdminDriverProfileTab extends ConsumerStatefulWidget {
  const AdminDriverProfileTab({
    required this.provider,
    required this.state,
    super.key,
  });

  final AutoDisposeStateNotifierProvider<AdminDriverDetailsController,
      AdminDriverDetailsState> provider;
  final AdminDriverDetailsState state;

  @override
  ConsumerState<AdminDriverProfileTab> createState() =>
      _AdminDriverProfileTabState();
}

class _AdminDriverProfileTabState extends ConsumerState<AdminDriverProfileTab> {
  List<AdminUserStateOption> _stateOptions = const [];
  String? _loadedCountryCode;

  @override
  void initState() {
    super.initState();
    _ensureCountryOptions();
    _loadStateOptionsIfNeeded(widget.state.driver?.countryCode);
  }

  @override
  void didUpdateWidget(AdminDriverProfileTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newCountry = widget.state.driver?.countryCode;
    _loadStateOptionsIfNeeded(newCountry);
  }

  Future<void> _ensureCountryOptions() async {
    await ref
        .read(adminUsersControllerProvider.notifier)
        .ensureCountryOptionsLoaded();
  }

  Future<void> _loadStateOptionsIfNeeded(String? countryCode) async {
    final normalized = countryCode?.trim().toUpperCase() ?? '';
    if (normalized.isEmpty ||
        normalized == '-' ||
        normalized == _loadedCountryCode) {
      return;
    }
    _loadedCountryCode = normalized;
    try {
      final options = await ref
          .read(adminUsersControllerProvider.notifier)
          .getStates(normalized);
      if (mounted) setState(() => _stateOptions = options);
    } catch (_) {
      // Resolver falls back to hardcoded data; ignore load errors.
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(widget.provider.notifier);
    final state = widget.state;
    final driver = state.driver;

    if (driver == null) {
      return const OpenVtsCard(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: OpenVtsSpacing.md),
          child: Text('Driver details are unavailable.'),
        ),
      );
    }

    final countryOptions =
        ref.watch(adminUsersControllerProvider).countryOptions;

    final rawCountry = driver.address.countryCode.isNotEmpty &&
            driver.address.countryCode != '-'
        ? driver.address.countryCode
        : driver.countryCode;
    final resolvedCountry = LocationLabelResolver.resolveCountry(
      rawCountry,
      apiOptions: countryOptions,
    );

    final rawState = driver.address.stateCode;
    final resolvedState = LocationLabelResolver.resolveState(
      rawCountry,
      rawState,
      apiOptions: _stateOptions,
    );

    final isBusy = state.isSavingProfile || state.isUpdatingPassword;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _IdentityCard(
          driver: driver,
          resolvedCountry: resolvedCountry,
          resolvedState: resolvedState,
          isUpdatingStatus: state.isUpdatingStatus,
          profileUpdatedAt: state.profileUpdatedAt,
          onToggleStatus: () async {
            final ok = await controller.updateStatus(!driver.isActive);
            if (!context.mounted) return;
            if (ok) {
              ToastHelper.showSuccess(
                !driver.isActive ? 'Driver activated.' : 'Driver deactivated.',
                context: context,
              );
            } else {
              ToastHelper.showError(
                ref.read(widget.provider).sectionErrorMessage ??
                    'Unable to update status.',
                context: context,
              );
            }
          },
        ),
        const SizedBox(height: OpenVtsSpacing.sm),
        if (driver.attributes.isNotEmpty) ...[
          _AdditionalAttributesCard(attributes: driver.attributes),
          const SizedBox(height: OpenVtsSpacing.sm),
        ],
        const SizedBox(height: OpenVtsSpacing.xs),
        _DriverProfileBottomActions(
          isBusy: isBusy,
          onEditProfile: () => _openEditProfile(context),
          onChangePassword: () => _openChangePassword(context),
        ),
        const SizedBox(height: OpenVtsSpacing.lg),
      ],
    );
  }

  Future<void> _openEditProfile(BuildContext context) {
    return showDriverEditSheet(context: context, provider: widget.provider);
  }

  Future<void> _openChangePassword(BuildContext context) {
    return showDriverPasswordSheet(context: context, provider: widget.provider);
  }
}

// =============================================================================
// Bottom action buttons
// =============================================================================

class _DriverProfileBottomActions extends StatelessWidget {
  const _DriverProfileBottomActions({
    required this.isBusy,
    required this.onEditProfile,
    required this.onChangePassword,
  });

  final bool isBusy;
  final VoidCallback onEditProfile;
  final VoidCallback onChangePassword;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OpenVtsButton(
            label: 'Edit Profile',
            variant: OpenVtsButtonVariant.secondary,
            onPressed: isBusy ? null : onEditProfile,
          ),
        ),
        const SizedBox(width: OpenVtsSpacing.sm),
        Expanded(
          child: OpenVtsButton(
            label: 'Change Password',
            variant: OpenVtsButtonVariant.secondary,
            onPressed: isBusy ? null : onChangePassword,
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// Shared display components
// =============================================================================

class _SectionCard extends StatelessWidget {
  const _SectionCard(
      {required this.title, required this.children, this.trailing});

  final String title;
  final List<Widget> children;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return OpenVtsCard(
      padding: const EdgeInsets.fromLTRB(
        OpenVtsSpacing.md,
        OpenVtsSpacing.sm,
        OpenVtsSpacing.md,
        OpenVtsSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: OpenVtsSpacing.xs),
          Divider(height: 1, color: _softBorderColor(context)),
          const SizedBox(height: OpenVtsSpacing.xs),
          ...children,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    this.icon,
    this.valueColor,
  });

  final String label;
  final String value;
  final IconData? icon;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon,
                size: 14,
                color: Theme.of(context).colorScheme.onSurfaceVariant),
            const SizedBox(width: 8),
          ],
          SizedBox(
            width: 108,
            child: Text(
              label,
              style: OpenVtsTypography.meta.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.trim().isEmpty ? '—' : value,
              style: OpenVtsTypography.label.copyWith(
                color: valueColor ?? Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DriverAvatar extends StatelessWidget {
  const _DriverAvatar({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: _softSurfaceColor(context),
        borderRadius: BorderRadius.circular(OpenVtsRadius.md),
        border: Border.all(color: _softBorderColor(context)),
      ),
      alignment: Alignment.center,
      child: Text(
        _initials(name),
        style: OpenVtsTypography.label.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  static String _initials(String value) {
    final parts =
        value.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return 'OV';
    if (parts.length == 1) {
      return parts.first
          .substring(0, parts.first.length.clamp(1, 2))
          .toUpperCase();
    }
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }
}

class _IdentityCard extends StatelessWidget {
  const _IdentityCard({
    required this.driver,
    required this.resolvedCountry,
    required this.resolvedState,
    required this.isUpdatingStatus,
    required this.onToggleStatus,
    this.profileUpdatedAt,
  });

  final AdminDriverDetails driver;
  final String resolvedCountry;
  final String resolvedState;
  final bool isUpdatingStatus;
  final VoidCallback onToggleStatus;

  /// Effective Driver Updated timestamp (server → persisted → createdAt).
  final DateTime? profileUpdatedAt;

  @override
  Widget build(BuildContext context) {
    final formatter = const DateTimeFormatter();
    final created = driver.createdAt != null
        ? formatter.formatDate(driver.createdAt!)
        : '—';
    // profileUpdatedAt is the fully-resolved effective timestamp (set by
    // loadProfile and updateProfile): server updatedAt → persisted → createdAt.
    final updated = profileUpdatedAt != null
        ? formatter.formatDateTime(profileUpdatedAt!)
        : '—';
    final address = driver.address;
    final fullAddress = address.fullAddress.trim();
    final composedLine = [
      address.addressLine,
      address.cityId,
      resolvedState,
      resolvedCountry,
      address.pincode,
    ].where((v) => v.trim().isNotEmpty && v.trim() != '-').join(', ');

    return _SectionCard(
      title: 'IDENTITY',
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: OpenVtsSpacing.xs),
          child: Row(
            children: [
              _DriverAvatar(name: driver.name),
              const SizedBox(width: OpenVtsSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      driver.name,
                      style: OpenVtsTypography.label.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '@${driver.username}',
                      style: OpenVtsTypography.meta.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 11,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: OpenVtsSpacing.xs),
              if (isUpdatingStatus)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else
                SizedBox(
                  width: 44,
                  height: 44,
                  child: Switch.adaptive(
                    value: driver.isActive,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    onChanged: (_) => onToggleStatus(),
                  ),
                ),
            ],
          ),
        ),
        _InfoRow(
          label: 'Address',
          value: address.addressLine,
          icon: Icons.home_outlined,
        ),
        _InfoRow(
          label: 'Country',
          value: resolvedCountry,
          icon: Icons.public_outlined,
        ),
        _InfoRow(
          label: 'State',
          value: resolvedState,
          icon: Icons.map_outlined,
        ),
        _InfoRow(
          label: 'City',
          value: address.cityId,
          icon: Icons.location_city_outlined,
        ),
        _InfoRow(
          label: 'Pincode',
          value: address.pincode,
          icon: Icons.local_post_office_outlined,
        ),
        if (fullAddress.isNotEmpty && fullAddress != composedLine)
          _InfoRow(
            label: 'Full address',
            value: fullAddress,
            icon: Icons.place_outlined,
          ),
        Padding(
          padding: const EdgeInsets.only(top: OpenVtsSpacing.xs),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.event_outlined,
                      size: 14,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Created: ',
                      style: OpenVtsTypography.meta.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        created,
                        style: OpenVtsTypography.label.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: OpenVtsSpacing.xs),
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.update_outlined,
                      size: 14,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Updated: ',
                      style: OpenVtsTypography.meta.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        updated,
                        style: OpenVtsTypography.label.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AdditionalAttributesCard extends StatelessWidget {
  const _AdditionalAttributesCard({required this.attributes});

  final Map<String, dynamic> attributes;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'ADDITIONAL ATTRIBUTES',
      children: attributes.entries
          .map(
            (entry) => _InfoRow(
              label: _labelize(entry.key),
              value: (entry.value?.toString().trim().isNotEmpty ?? false)
                  ? entry.value.toString()
                  : '—',
              icon: Icons.data_object_outlined,
            ),
          )
          .toList(),
    );
  }

  String _labelize(String key) {
    final raw = key.replaceAll('_', ' ').trim();
    if (raw.isEmpty) return key;
    return raw
        .split(RegExp(r'\s+'))
        .map((w) => w.isEmpty ? '' : '${w[0].toUpperCase()}${w.substring(1)}')
        .join(' ');
  }
}

// ---------------------------------------------------------------------------
// Theme helpers
// ---------------------------------------------------------------------------

Color _softSurfaceColor(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark
      ? OpenVtsColors.darkSurface
      : OpenVtsColors.background;
}

Color _softBorderColor(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark
      ? OpenVtsColors.darkBorder
      : OpenVtsColors.border;
}
