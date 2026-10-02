import 'package:flutter/material.dart';

import '../../../../../core/theme/open_vts_colors.dart';
import '../../../../../core/theme/open_vts_radius.dart';
import '../../../../../core/theme/open_vts_spacing.dart';
import '../../../../../core/theme/open_vts_typography.dart';
import '../../../../../shared/widgets/open_vts_card.dart';
import '../../../../../shared/widgets/open_vts_date_time_range_selector.dart';
import '../../../models/admin_payments_model.dart';
import '../../../models/admin_payments_state.dart';
import '../../../models/admin_users_model.dart';

class AdminPaymentsFiltersCard extends StatefulWidget {
  const AdminPaymentsFiltersCard({
    required this.state,
    required this.onUserChanged,
    required this.onStatusChanged,
    required this.onModeChanged,
    required this.onRangePresetChanged,
    required this.onCustomRangeChanged,
    required this.onClear,
    required this.onApply,
    super.key,
  });

  final AdminPaymentsState state;
  final ValueChanged<String?> onUserChanged;
  final ValueChanged<AdminPaymentStatus?> onStatusChanged;
  final ValueChanged<AdminPaymentMode?> onModeChanged;
  final ValueChanged<AdminPaymentsRangePreset> onRangePresetChanged;
  final void Function(DateTime? from, DateTime? to) onCustomRangeChanged;
  final VoidCallback onClear;
  final VoidCallback onApply;

  @override
  State<AdminPaymentsFiltersCard> createState() =>
      _AdminPaymentsFiltersCardState();
}

class _AdminPaymentsFiltersCardState extends State<AdminPaymentsFiltersCard> {
  bool _showAdvancedFilters = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final headingColor = isDark ? Colors.white : OpenVtsColors.textPrimary;
    final hasAdvancedSelection = widget.state.selectedMode != null;
    final showAdvancedFilters = _showAdvancedFilters || hasAdvancedSelection;

    return OpenVtsCard(
      padding: const EdgeInsets.all(OpenVtsSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Filters',
                style: OpenVtsTypography.label.copyWith(
                  fontWeight: FontWeight.w700,
                  color: headingColor,
                ),
              ),
              const Spacer(),
              if (widget.state.hasActiveFilters)
                TextButton.icon(
                  onPressed: _handleClear,
                  style: TextButton.styleFrom(
                    foregroundColor: OpenVtsColors.textSecondary,
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(
                      horizontal: OpenVtsSpacing.xs,
                    ),
                    minimumSize: const Size(44, 44),
                  ),
                  icon: const Icon(Icons.filter_alt_off_outlined, size: 14),
                  label: Text(
                    'Clear',
                    style: OpenVtsTypography.meta.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: OpenVtsSpacing.sm),
          const _SectionLabel(text: 'Date Range'),
          const SizedBox(height: OpenVtsSpacing.xs),
          Wrap(
            spacing: OpenVtsSpacing.xs,
            runSpacing: OpenVtsSpacing.xs,
            children: [
              _CompactChoiceChip(
                label: 'Today',
                selected:
                    widget.state.rangePreset == AdminPaymentsRangePreset.today,
                onTap: () => widget.onRangePresetChanged(
                  AdminPaymentsRangePreset.today,
                ),
              ),
              _CompactChoiceChip(
                label: 'Yesterday',
                selected: widget.state.rangePreset ==
                    AdminPaymentsRangePreset.yesterday,
                onTap: () => widget.onRangePresetChanged(
                  AdminPaymentsRangePreset.yesterday,
                ),
              ),
              _CompactChoiceChip(
                label: 'Last 12 Hours',
                selected: widget.state.rangePreset ==
                    AdminPaymentsRangePreset.last12Hours,
                onTap: () => widget.onRangePresetChanged(
                  AdminPaymentsRangePreset.last12Hours,
                ),
              ),
              _CompactChoiceChip(
                label: 'Last 24 Hours',
                selected: widget.state.rangePreset ==
                    AdminPaymentsRangePreset.last24Hours,
                onTap: () => widget.onRangePresetChanged(
                  AdminPaymentsRangePreset.last24Hours,
                ),
              ),
              _CompactChoiceChip(
                label: 'Last 7 Days',
                selected: widget.state.rangePreset ==
                    AdminPaymentsRangePreset.last7Days,
                onTap: () => widget.onRangePresetChanged(
                  AdminPaymentsRangePreset.last7Days,
                ),
              ),
              _CompactChoiceChip(
                label: 'Last 30 Days',
                selected: widget.state.rangePreset ==
                    AdminPaymentsRangePreset.last30Days,
                onTap: () => widget.onRangePresetChanged(
                  AdminPaymentsRangePreset.last30Days,
                ),
              ),
              _CompactChoiceChip(
                label: 'This Month',
                selected: widget.state.rangePreset ==
                    AdminPaymentsRangePreset.thisMonth,
                onTap: () => widget.onRangePresetChanged(
                  AdminPaymentsRangePreset.thisMonth,
                ),
              ),
              _CompactChoiceChip(
                label: 'This Year',
                selected: widget.state.rangePreset ==
                    AdminPaymentsRangePreset.thisYear,
                onTap: () => widget.onRangePresetChanged(
                  AdminPaymentsRangePreset.thisYear,
                ),
              ),
              _CompactChoiceChip(
                label: 'Custom',
                selected:
                    widget.state.rangePreset == AdminPaymentsRangePreset.custom,
                onTap: () => widget.onRangePresetChanged(
                  AdminPaymentsRangePreset.custom,
                ),
              ),
            ],
          ),
          if (widget.state.rangePreset == AdminPaymentsRangePreset.custom) ...[
            const SizedBox(height: OpenVtsSpacing.sm),
            OpenVtsDateTimeRangeField(
              label: 'Custom Range',
              value: OpenVtsDateTimeRange(
                start: widget.state.customFrom,
                end: widget.state.customTo,
              ),
              onChanged: (range) =>
                  widget.onCustomRangeChanged(range.start, range.end),
              title: 'Choose Date Range',
            ),
          ],
          const SizedBox(height: OpenVtsSpacing.sm),
          const _SectionLabel(text: 'Status'),
          const SizedBox(height: OpenVtsSpacing.xs),
          Wrap(
            spacing: OpenVtsSpacing.xs,
            runSpacing: OpenVtsSpacing.xs,
            children: [
              _CompactChoiceChip(
                label: 'All',
                selected: widget.state.selectedStatus == null,
                onTap: () => widget.onStatusChanged(null),
              ),
              _CompactChoiceChip(
                label: 'Success',
                selected:
                    widget.state.selectedStatus == AdminPaymentStatus.success,
                onTap: () => widget.onStatusChanged(AdminPaymentStatus.success),
              ),
              _CompactChoiceChip(
                label: 'Pending',
                selected:
                    widget.state.selectedStatus == AdminPaymentStatus.pending,
                onTap: () => widget.onStatusChanged(AdminPaymentStatus.pending),
              ),
              _CompactChoiceChip(
                label: 'Failed',
                selected:
                    widget.state.selectedStatus == AdminPaymentStatus.failed,
                onTap: () => widget.onStatusChanged(AdminPaymentStatus.failed),
              ),
            ],
          ),
          const SizedBox(height: OpenVtsSpacing.sm),
          TextButton.icon(
            onPressed: () {
              setState(() {
                _showAdvancedFilters = !showAdvancedFilters;
              });
            },
            style: TextButton.styleFrom(
              foregroundColor: OpenVtsColors.textSecondary,
              minimumSize: const Size(44, 44),
              padding:
                  const EdgeInsets.symmetric(horizontal: OpenVtsSpacing.xs),
            ),
            icon: Icon(
              showAdvancedFilters
                  ? Icons.expand_less_rounded
                  : Icons.tune_rounded,
              size: 16,
            ),
            label: Text(
              showAdvancedFilters
                  ? 'Hide payment filters'
                  : 'Show payment filters',
              style: OpenVtsTypography.meta.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          if (showAdvancedFilters) ...[
            const SizedBox(height: OpenVtsSpacing.xs),
            const _SectionLabel(text: 'User'),
            const SizedBox(height: OpenVtsSpacing.xs),
            Wrap(
              spacing: OpenVtsSpacing.xs,
              runSpacing: OpenVtsSpacing.xs,
              children: [
                _CompactChoiceChip(
                  label: 'All Users',
                  selected: widget.state.selectedUserId == null,
                  onTap: () => widget.onUserChanged(null),
                ),
                ...widget.state.users.map((user) => _CompactChoiceChip(
                      label: _getUserLabel(user),
                      selected: widget.state.selectedUserId == user.id,
                      onTap: () => widget.onUserChanged(user.id),
                    )),
              ],
            ),
            const SizedBox(height: OpenVtsSpacing.sm),
            const _SectionLabel(text: 'Payment Mode'),
            const SizedBox(height: OpenVtsSpacing.xs),
            Wrap(
              spacing: OpenVtsSpacing.xs,
              runSpacing: OpenVtsSpacing.xs,
              children: [
                _CompactChoiceChip(
                  label: 'All',
                  selected: widget.state.selectedMode == null,
                  onTap: () => widget.onModeChanged(null),
                ),
                _CompactChoiceChip(
                  label: 'Cash',
                  selected: widget.state.selectedMode == AdminPaymentMode.cash,
                  onTap: () => widget.onModeChanged(AdminPaymentMode.cash),
                ),
                _CompactChoiceChip(
                  label: 'UPI',
                  selected: widget.state.selectedMode == AdminPaymentMode.upi,
                  onTap: () => widget.onModeChanged(AdminPaymentMode.upi),
                ),
                _CompactChoiceChip(
                  label: 'Bank Transfer',
                  selected: widget.state.selectedMode ==
                      AdminPaymentMode.bankTransfer,
                  onTap: () =>
                      widget.onModeChanged(AdminPaymentMode.bankTransfer),
                ),
                _CompactChoiceChip(
                  label: 'Card',
                  selected: widget.state.selectedMode == AdminPaymentMode.card,
                  onTap: () => widget.onModeChanged(AdminPaymentMode.card),
                ),
                _CompactChoiceChip(
                  label: 'Wallet',
                  selected:
                      widget.state.selectedMode == AdminPaymentMode.wallet,
                  onTap: () => widget.onModeChanged(AdminPaymentMode.wallet),
                ),
                _CompactChoiceChip(
                  label: 'Razorpay',
                  selected:
                      widget.state.selectedMode == AdminPaymentMode.razorpay,
                  onTap: () => widget.onModeChanged(AdminPaymentMode.razorpay),
                ),
                _CompactChoiceChip(
                  label: 'Stripe',
                  selected:
                      widget.state.selectedMode == AdminPaymentMode.stripe,
                  onTap: () => widget.onModeChanged(AdminPaymentMode.stripe),
                ),
                _CompactChoiceChip(
                  label: 'Other',
                  selected: widget.state.selectedMode == AdminPaymentMode.other,
                  onTap: () => widget.onModeChanged(AdminPaymentMode.other),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _handleClear() {
    widget.onClear();
    widget.onApply();
    setState(() {
      _showAdvancedFilters = false;
    });
  }

  String _getUserLabel(AdminUserListItem user) {
    final username = user.username.trim();
    final text = username.isEmpty ? user.name : '${user.name} (@$username)';
    return text;
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.grey[300] : OpenVtsColors.textSecondary;

    return Text(
      text,
      style: OpenVtsTypography.meta.copyWith(
        color: textColor,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _CompactChoiceChip extends StatelessWidget {
  const _CompactChoiceChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = selected
        ? (isDark ? Colors.black : OpenVtsColors.white)
        : Colors.transparent;
    final textColor = isDark ? Colors.white : OpenVtsColors.brandInk;
    final borderColor = isDark ? Colors.white : OpenVtsColors.border;

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(OpenVtsRadius.pill),
      child: InkWell(
        borderRadius: BorderRadius.circular(OpenVtsRadius.pill),
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: 34),
          padding: const EdgeInsets.symmetric(
            horizontal: OpenVtsSpacing.sm,
            vertical: OpenVtsSpacing.xs,
          ),
          decoration: selected
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(OpenVtsRadius.pill),
                  border: Border.all(color: borderColor, width: 1),
                )
              : null,
          child: Text(
            label,
            style: OpenVtsTypography.meta.copyWith(
              color: textColor,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
