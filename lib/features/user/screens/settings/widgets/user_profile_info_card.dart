import 'package:flutter/material.dart';

import '../../../../../core/theme/open_vts_spacing.dart';
import '../../../../../shared/widgets/open_vts_card.dart';
import '../../../models/user_settings_model.dart';

class UserProfileInfoCard extends StatelessWidget {
  const UserProfileInfoCard({
    required this.profile,
    super.key,
  });

  final UserSettingsProfile profile;

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
          Text(
            'PERSONAL',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: OpenVtsSpacing.xs),
          Divider(
            height: 1,
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
          const SizedBox(height: OpenVtsSpacing.xs),
          _InfoRow(
            label: 'Name',
            value: _orDash(profile.name),
            icon: Icons.person_outline,
          ),
          _InfoRow(
            label: 'Username',
            value: _orDash(profile.username),
            icon: Icons.alternate_email,
          ),
          _InfoRow(
            label: 'Email',
            value: _orDash(profile.email),
            icon: Icons.mail_outline_rounded,
          ),
          _InfoRow(
            label: 'Mobile',
            value: _orDash(_join(profile.mobilePrefix, profile.mobileNumber)),
            icon: Icons.phone_outlined,
          ),
        ],
      ),
    );
  }

  String _normalize(String? value) => value?.trim() ?? '';

  String _orDash(String? value) {
    final normalized = _normalize(value);
    return normalized.isEmpty ? '—' : normalized;
  }

  String _join(String? first, String? second) {
    final parts = <String>[];
    final a = _normalize(first);
    final b = _normalize(second);
    if (a.isNotEmpty) {
      parts.add(a);
    }
    if (b.isNotEmpty) {
      parts.add(b);
    }
    return parts.join(' ');
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: OpenVtsSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon,
              size: 14, color: Theme.of(context).colorScheme.onSurfaceVariant),
          const SizedBox(width: 8),
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(width: OpenVtsSpacing.xs),
          Expanded(
            child: Text(
              value.trim().isEmpty ? '—' : value.trim(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
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
