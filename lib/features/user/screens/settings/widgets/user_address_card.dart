import 'package:flutter/material.dart';

import '../../../../../core/theme/open_vts_spacing.dart';
import '../../../../../core/theme/open_vts_typography.dart';
import '../../../../../shared/widgets/open_vts_card.dart';
import '../../../models/user_settings_model.dart';

class UserAddressCard extends StatelessWidget {
  const UserAddressCard({
    required this.address,
    this.countryLabel,
    this.stateLabel,
    super.key,
  });

  final UserSettingsAddress? address;

  /// Human-readable country name (e.g. "India"). Falls back to
  /// [UserSettingsAddress.countryCode] when null.
  final String? countryLabel;

  /// Human-readable state/province name (e.g. "Chhattisgarh"). Falls back to
  /// [UserSettingsAddress.stateCode] when null.
  final String? stateLabel;

  @override
  Widget build(BuildContext context) {
    final addressLine = address?.addressLine ?? '';
    final countryCode = address?.countryCode ?? '';
    final stateCode = address?.stateCode ?? '';
    final city = address?.cityName ?? '';
    final pincode = address?.pincode ?? '';

    final hasAddress = addressLine.trim().isNotEmpty ||
        countryCode.trim().isNotEmpty ||
        stateCode.trim().isNotEmpty ||
        city.trim().isNotEmpty ||
        pincode.trim().isNotEmpty;

    if (!hasAddress) {
      return const SizedBox.shrink();
    }

    // Prefer human-readable labels; fall back to raw codes for legacy data that
    // cannot be resolved against the current reference catalogue.
    final countryDisplay =
        (countryLabel?.trim().isNotEmpty == true) ? countryLabel! : countryCode;
    final stateDisplay =
        (stateLabel?.trim().isNotEmpty == true) ? stateLabel! : stateCode;

    return OpenVtsCard(
      padding: const EdgeInsets.all(OpenVtsSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ADDRESS',
            style: OpenVtsTypography.meta.copyWith(
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: OpenVtsSpacing.xs),
          if (addressLine.trim().isNotEmpty)
            _AddressRow(
              label: 'Address',
              value: addressLine,
            ),
          if (countryCode.trim().isNotEmpty)
            _AddressRow(
              label: 'Country',
              value: countryDisplay,
            ),
          if (stateCode.trim().isNotEmpty)
            _AddressRow(
              label: 'State',
              value: stateDisplay,
            ),
          if (city.trim().isNotEmpty)
            _AddressRow(
              label: 'City',
              value: city,
            ),
          if (pincode.trim().isNotEmpty)
            _AddressRow(
              label: 'Pincode',
              value: pincode,
            ),
        ],
      ),
    );
  }
}

class _AddressRow extends StatelessWidget {
  const _AddressRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: OpenVtsSpacing.xxs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 96,
            child: Text(
              label,
              style: OpenVtsTypography.meta.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(width: OpenVtsSpacing.xs),
          Expanded(
            child: Text(
              value.trim(),
              style: OpenVtsTypography.meta.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
