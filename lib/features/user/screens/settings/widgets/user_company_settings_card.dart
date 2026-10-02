import 'package:flutter/material.dart';

import '../../../../../core/theme/open_vts_spacing.dart';
import '../../../../../shared/widgets/open_vts_card.dart';
import '../../../models/user_settings_model.dart';

class UserCompanySettingsCard extends StatelessWidget {
  const UserCompanySettingsCard({
    required this.company,
    required this.onEdit,
    super.key,
  });

  final UserSettingsCompany? company;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    if (company == null) {
      return const SizedBox.shrink();
    }

    final companyName = company?.name?.trim() ?? '';
    final website = company?.websiteUrl?.trim() ?? '';
    final customDomain = company?.customDomain?.trim() ?? '';
    final primaryColor = company?.primaryColor?.trim() ?? '';

    final socialLinks = company?.socialLinks;
    final facebook = socialLinks?.facebook?.trim() ?? '';
    final twitter = socialLinks?.twitter?.trim() ?? '';
    final linkedin = socialLinks?.linkedin?.trim() ?? '';
    final instagram = socialLinks?.instagram?.trim() ?? '';
    final youtube = socialLinks?.youtube?.trim() ?? '';
    final github = socialLinks?.github?.trim() ?? '';

    final hasSocialLinks = [
      facebook,
      twitter,
      linkedin,
      instagram,
      youtube,
      github
    ].any((link) => link.isNotEmpty);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OpenVtsCard(
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
                      'COMPANY DETAILS',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 32,
                    height: 32,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      constraints:
                          const BoxConstraints(minWidth: 32, minHeight: 32),
                      icon: Icon(
                        Icons.edit_outlined,
                        size: 16,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      tooltip: 'Edit company',
                      onPressed: onEdit,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: OpenVtsSpacing.xs),
              Divider(
                height: 1,
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
              const SizedBox(height: OpenVtsSpacing.xs),
              _InfoRow(
                label: 'Name',
                value: companyName,
                icon: Icons.business_outlined,
              ),
              _InfoRow(
                label: 'Website',
                value: website,
                icon: Icons.language_outlined,
              ),
              _InfoRow(
                label: 'Custom Domain',
                value: customDomain,
                icon: Icons.dns_outlined,
              ),
              _InfoRow(
                label: 'Primary Color',
                value: primaryColor,
                icon: Icons.palette_outlined,
              ),
            ],
          ),
        ),
        if (hasSocialLinks) ...[
          const SizedBox(height: OpenVtsSpacing.sm),
          OpenVtsCard(
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
                  'SOCIAL LINKS',
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
                if (facebook.isNotEmpty)
                  _InfoRow(
                    label: 'Facebook',
                    value: facebook,
                    icon: Icons.facebook_outlined,
                  ),
                if (twitter.isNotEmpty)
                  _InfoRow(
                    label: 'Twitter/X',
                    value: twitter,
                    icon: Icons.public_outlined,
                  ),
                if (linkedin.isNotEmpty)
                  _InfoRow(
                    label: 'LinkedIn',
                    value: linkedin,
                    icon: Icons.public_outlined,
                  ),
                if (instagram.isNotEmpty)
                  _InfoRow(
                    label: 'Instagram',
                    value: instagram,
                    icon: Icons.public_outlined,
                  ),
                if (youtube.isNotEmpty)
                  _InfoRow(
                    label: 'YouTube',
                    value: youtube,
                    icon: Icons.video_library_outlined,
                  ),
                if (github.isNotEmpty)
                  _InfoRow(
                    label: 'GitHub',
                    value: github,
                    icon: Icons.code_outlined,
                  ),
              ],
            ),
          ),
        ],
      ],
    );
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
