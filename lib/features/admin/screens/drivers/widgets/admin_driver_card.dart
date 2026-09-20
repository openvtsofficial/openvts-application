import 'package:flutter/material.dart';

import '../../../../../core/theme/open_vts_colors.dart';
import '../../../../../core/theme/open_vts_radius.dart';
import '../../../../../core/theme/open_vts_spacing.dart';
import '../../../../../core/theme/open_vts_typography.dart';
import '../../../../../core/utils/date_time_formatter.dart';
import '../../../models/admin_drivers_model.dart';

const DateTimeFormatter _cardDateFormatter = DateTimeFormatter();

class AdminDriverCard extends StatelessWidget {
  const AdminDriverCard({
    required this.driver,
    this.onTap,
    this.isUpdatingStatus = false,
    this.onStatusChanged,
    super.key,
  });

  final AdminDriverListItem driver;
  final VoidCallback? onTap;
  final bool isUpdatingStatus;
  final ValueChanged<bool>? onStatusChanged;

  @override
  Widget build(BuildContext context) {
    return _RoundedSurface(
      onTap: onTap,
      padding: const EdgeInsets.all(OpenVtsSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardHeader(
            driver: driver,
            isUpdatingStatus: isUpdatingStatus,
            onStatusChanged: onStatusChanged,
          ),
          const SizedBox(height: OpenVtsSpacing.md),
          _CardInfoGrid(driver: driver),
          const SizedBox(height: OpenVtsSpacing.md),
          _CardMetricsRow(driver: driver),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Card header (avatar + name + status badge)
// ---------------------------------------------------------------------------

class _CardHeader extends StatelessWidget {
  const _CardHeader({
    required this.driver,
    required this.isUpdatingStatus,
    required this.onStatusChanged,
  });

  final AdminDriverListItem driver;
  final bool isUpdatingStatus;
  final ValueChanged<bool>? onStatusChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _AvatarCircle(driver: driver),
        const SizedBox(width: OpenVtsSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      _displayName(driver),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.2,
                          ),
                    ),
                  ),
                  const SizedBox(width: OpenVtsSpacing.xs),
                  if (driver.isVerified)
                    const Icon(
                      Icons.verified_rounded,
                      size: 16,
                      color: OpenVtsColors.success,
                    ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                '@${_displayUsername(driver)}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: OpenVtsTypography.label.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: OpenVtsSpacing.xs),
        _StatusToggle(
          isActive: driver.isActive,
          isBusy: isUpdatingStatus,
          isToggling: isUpdatingStatus,
          onChanged: onStatusChanged,
        ),
      ],
    );
  }
}

class _AvatarCircle extends StatelessWidget {
  const _AvatarCircle({required this.driver});

  final AdminDriverListItem driver;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      width: 44,
      decoration: BoxDecoration(
        color: _softSurfaceColor(context),
        shape: BoxShape.circle,
        border: Border.all(color: _softBorderColor(context)),
      ),
      alignment: Alignment.center,
      child: Text(
        _initials(_displayName(driver)),
        style: OpenVtsTypography.label.copyWith(
          fontWeight: FontWeight.w700,
          color: _primaryInkColor(context),
          fontSize: 14,
        ),
      ),
    );
  }
}

class _StatusToggle extends StatelessWidget {
  const _StatusToggle({
    required this.isActive,
    required this.isBusy,
    required this.isToggling,
    required this.onChanged,
  });

  final bool isActive;
  final bool isBusy;
  final bool isToggling;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    if (isToggling) {
      return const SizedBox(
        width: 40,
        height: 32,
        child: Center(
          child: SizedBox.square(
            dimension: 16,
            child: CircularProgressIndicator(strokeWidth: 2.2),
          ),
        ),
      );
    }

    return Tooltip(
      message: isActive ? 'Deactivate driver' : 'Activate driver',
      child: Transform.scale(
        scale: 0.85,
        child: Switch(
          value: isActive,
          onChanged: isBusy ? null : onChanged,
          activeThumbColor: Theme.of(context).colorScheme.onPrimary,
          activeTrackColor: _primaryInkColor(context),
          inactiveThumbColor: Theme.of(context).colorScheme.onSurface,
          inactiveTrackColor: _softBorderColor(context),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Card info grid (email, phone, address, primary user)
// ---------------------------------------------------------------------------

class _CardInfoGrid extends StatelessWidget {
  const _CardInfoGrid({required this.driver});

  final AdminDriverListItem driver;

  @override
  Widget build(BuildContext context) {
    final emailValue = _displayValue(driver.email);
    final phoneValue = _displayValue(driver.phone);
    final addressValue = _displayAddress(driver);
    final primaryUserValue = _displayPrimaryUser(driver);

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 420;

        if (compact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _InfoRow(icon: Icons.mail_outline_rounded, value: emailValue),
              const SizedBox(height: OpenVtsSpacing.xs),
              _InfoRow(icon: Icons.call_outlined, value: phoneValue),
              const SizedBox(height: OpenVtsSpacing.xs),
              _InfoRow(
                  icon: Icons.place_outlined, value: addressValue, maxLines: 2),
              if (primaryUserValue.isNotEmpty) ...[
                const SizedBox(height: OpenVtsSpacing.xs),
                _InfoRow(
                  icon: Icons.account_circle_outlined,
                  value: 'Primary: $primaryUserValue',
                ),
              ],
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _InfoRow(
                    icon: Icons.mail_outline_rounded,
                    value: emailValue,
                  ),
                ),
                const SizedBox(width: OpenVtsSpacing.sm),
                Expanded(
                  child: _InfoRow(
                    icon: Icons.call_outlined,
                    value: phoneValue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: OpenVtsSpacing.xs),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _InfoRow(
                    icon: Icons.place_outlined,
                    value: addressValue,
                    maxLines: 2,
                  ),
                ),
                const SizedBox(width: OpenVtsSpacing.sm),
                Expanded(
                  child: primaryUserValue.isNotEmpty
                      ? _InfoRow(
                          icon: Icons.account_circle_outlined,
                          value: 'Primary: $primaryUserValue',
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.value,
    this.maxLines = 1,
  });

  final IconData icon;
  final String value;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 16, color: OpenVtsColors.textSecondary),
        const SizedBox(width: OpenVtsSpacing.xs),
        Expanded(
          child: Text(
            value,
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
            style: OpenVtsTypography.label.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Card metrics row (Created / Documents / Users)
// ---------------------------------------------------------------------------

class _CardMetricsRow extends StatelessWidget {
  const _CardMetricsRow({required this.driver});

  final AdminDriverListItem driver;

  @override
  Widget build(BuildContext context) {
    final createdValue = _createdLabel(driver.createdAt);

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 420;

        if (compact) {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _MetricCell(
                      icon: Icons.calendar_today_rounded,
                      label: 'Created',
                      value: createdValue,
                    ),
                  ),
                  const SizedBox(width: OpenVtsSpacing.xs),
                  const Expanded(
                    child: _MetricCell(
                      icon: Icons.description_outlined,
                      label: 'Role',
                      value: 'Driver',
                    ),
                  ),
                ],
              ),
            ],
          );
        }

        return Row(
          children: [
            Expanded(
              child: _MetricCell(
                icon: Icons.calendar_today_rounded,
                label: 'Created',
                value: createdValue,
              ),
            ),
            const SizedBox(width: OpenVtsSpacing.xs),
            Expanded(
              flex: 2,
              child: _MetricCell(
                icon: Icons.schedule_outlined,
                label: 'Updated',
                value: _updatedLabel(driver.updatedAt),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _MetricCell extends StatelessWidget {
  const _MetricCell({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: OpenVtsSpacing.sm,
        vertical: OpenVtsSpacing.xs + 2,
      ),
      decoration: BoxDecoration(
        color: _softSurfaceColor(context),
        borderRadius: BorderRadius.circular(OpenVtsRadius.md),
        border: Border.all(color: _softBorderColor(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(icon,
                  size: 14,
                  color: Theme.of(context).colorScheme.onSurfaceVariant),
              const SizedBox(width: OpenVtsSpacing.xxs + 2),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: OpenVtsTypography.meta.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: OpenVtsSpacing.xxs + 2),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: OpenVtsTypography.label.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Shared surface
// ---------------------------------------------------------------------------

class _RoundedSurface extends StatelessWidget {
  const _RoundedSurface({
    required this.child,
    this.padding = const EdgeInsets.all(OpenVtsSpacing.md),
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(OpenVtsRadius.lg);
    final surface = Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: radius,
        border: Border.all(color: _softBorderColor(context)),
      ),
      child: child,
    );

    if (onTap == null) {
      return surface;
    }

    return Material(
      color: Colors.transparent,
      borderRadius: radius,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: surface,
      ),
    );
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

Color _primaryInkColor(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark
      ? OpenVtsColors.darkTextPrimary
      : OpenVtsColors.brandInk;
}

// ---------------------------------------------------------------------------
// Data helpers
// ---------------------------------------------------------------------------

String _displayName(AdminDriverListItem driver) {
  final name = driver.firstName.trim();
  if (name.isNotEmpty) {
    return name;
  }
  final username = driver.username.trim();
  if (username.isNotEmpty) {
    return username;
  }
  return _displayValue(driver.email);
}

String _displayUsername(AdminDriverListItem driver) {
  final username = driver.username.trim();
  if (username.isNotEmpty) {
    return username;
  }
  final email = driver.email.trim();
  if (email.isNotEmpty) {
    return email;
  }
  return 'unknown';
}

String _displayAddress(AdminDriverListItem driver) {
  final full = driver.fullAddress.trim();
  if (full.isNotEmpty && full != '-') {
    return full;
  }
  return _displayValue(driver.address);
}

String _displayPrimaryUser(AdminDriverListItem driver) {
  final name = driver.primaryUserName.trim();
  if (name.isEmpty || name == '-') {
    return '';
  }
  return name;
}

String _initials(String input) {
  final source = input.trim();
  if (source.isEmpty || source == '—') {
    return 'D';
  }
  final words = source.split(RegExp(r'\s+'));
  if (words.length == 1) {
    return words.first.characters.take(2).toString().toUpperCase();
  }
  return '${words.first.characters.first}${words.last.characters.first}'
      .toUpperCase();
}

String _displayValue(String value) {
  final normalized = value.trim();
  return normalized.isEmpty || normalized == '-' ? '—' : normalized;
}

String _createdLabel(DateTime? value) {
  if (value == null) {
    return '—';
  }
  final local = value.toLocal();
  return _cardDateFormatter.formatDate(local);
}

String _updatedLabel(DateTime? value) {
  if (value == null) {
    return '—';
  }
  final local = value.toLocal();
  return _cardDateFormatter.formatDateTime(local);
}
