import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/helpers/mobile_text.dart';
import '../../../../../shared/helpers/toast_helper.dart';
import '../../../../../shared/widgets/open_vts_button.dart';
import '../../../../../shared/widgets/open_vts_card.dart';
import '../../../../../shared/widgets/open_vts_error_view.dart';
import '../../../../../shared/widgets/open_vts_searchable_dropdown.dart';
import '../../../controllers/admin_user_retention_controller.dart';

import 'admin_user_access_error_label.dart';

/// Matches the web Data Backup tab: telemetry retention, inheritance and limits.
class AdminUserDataBackupTab extends ConsumerWidget {
  const AdminUserDataBackupTab({required this.userId, super.key});
  final String userId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = adminUserRetentionControllerProvider(userId);
    final state = ref.watch(provider);
    final controller = ref.read(provider.notifier);
    final l10n = AppLocalizations.of(context);
    if (state.loading) {
      return const Padding(
        padding: EdgeInsets.all(32),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    final policy = state.policy;
    if (policy == null) {
      return OpenVtsErrorView(
        message: adminUserAccessErrorLabel(context, state.error),
        onRetry: controller.load,
      );
    }
    final inherited = context.mobileText(
      'Use administrator policy ({value1})',
      {'value1': l10n.mobileDays(policy.parentDays)},
    );
    final source = switch (policy.source) {
      'GLOBAL' => context.mobileText('Global'),
      'ADMIN' => context.mobileText('Administrator'),
      _ => context.mobileText('User'),
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OpenVtsCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                context.mobileText('Data Backup'),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              _PolicyValue(
                label: context.mobileText('Effective retention'),
                value: l10n.mobileDays(policy.effectiveDays),
              ),
              _PolicyValue(
                label: context.mobileText('Administrator limit'),
                value: l10n.mobileDays(policy.maxDays),
              ),
              _PolicyValue(
                label: context.mobileText('Policy source'),
                value: source,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        OpenVtsCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              OpenVtsSearchableDropdown<String>(
                label: context.mobileText('Retention period'),
                value: state.days?.toString() ?? '',
                enabled: !state.saving,
                options: [
                  OpenVtsDropdownOption(value: '', label: inherited),
                  for (final days in policy.availableDays)
                    OpenVtsDropdownOption(
                      value: days.toString(),
                      label: l10n.mobileDays(days),
                    ),
                ],
                onChanged: (value) => controller.select(
                  value == null || value.isEmpty ? null : int.parse(value),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                context.mobileText(
                  'The retention period cannot exceed {value1} days.',
                  {'value1': policy.maxDays.toString()},
                ),
              ),
              const SizedBox(height: 12),
              Text(
                context.mobileText(
                  'Historical telemetry older than the retention period is removed by scheduled cleanup. Increasing retention does not restore deleted data.',
                ),
              ),
            ],
          ),
        ),
        if (state.error != null)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              adminUserAccessErrorLabel(context, state.error),
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            OpenVtsButton(
              label: context.mobileText('Reset'),
              variant: OpenVtsButtonVariant.secondary,
              onPressed: state.dirty && !state.saving ? controller.reset : null,
            ),
            OpenVtsButton(
              label: context.mobileText('Save'),
              isLoading: state.saving,
              onPressed: state.dirty && !state.saving
                  ? () async {
                      final ok = await controller.save();
                      if (!context.mounted) return;
                      if (ok) {
                        ToastHelper.showSuccess(
                          context.mobileText('Data retention updated'),
                          context: context,
                        );
                      }
                    }
                  : null,
            ),
          ],
        ),
      ],
    );
  }
}

class _PolicyValue extends StatelessWidget {
  const _PolicyValue({required this.label, required this.value});
  final String label, value;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 4),
        Text(value, style: Theme.of(context).textTheme.titleMedium),
      ],
    ),
  );
}
