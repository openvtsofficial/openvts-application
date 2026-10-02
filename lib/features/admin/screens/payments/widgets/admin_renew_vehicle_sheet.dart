import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/open_vts_colors.dart';
import '../../../../../core/theme/open_vts_spacing.dart';
import '../../../../../core/theme/open_vts_typography.dart';
import '../../../../../shared/helpers/toast_helper.dart';
import '../../../../../shared/widgets/open_vts_button.dart';
import '../../../../../shared/widgets/open_vts_search_field.dart';
import '../../../../../shared/widgets/open_vts_searchable_dropdown.dart';
import '../../../../../shared/widgets/open_vts_text_field.dart';
import '../../../controllers/admin_providers.dart';
import '../../../models/admin_payments_model.dart';

class AdminRenewVehicleSheet extends ConsumerStatefulWidget {
  const AdminRenewVehicleSheet({super.key});

  @override
  ConsumerState<AdminRenewVehicleSheet> createState() =>
      _AdminRenewVehicleSheetState();
}

class _AdminRenewVehicleSheetState
    extends ConsumerState<AdminRenewVehicleSheet> {
  String? _userId;
  List<AdminRenewVehicleOption> _vehicles = const <AdminRenewVehicleOption>[];
  final Set<String> _selected = <String>{};
  String _search = '';
  AdminPaymentMode? _mode;
  bool _modeError = false;
  final _amountController = TextEditingController();
  final _referenceController = TextEditingController();
  bool _loadingVehicles = false;

  @override
  void dispose() {
    _amountController.dispose();
    _referenceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminPaymentsControllerProvider);
    final users = state.users;

    final filtered = _vehicles
        .where((v) => v.isRenewable && v.matchesQuery(_search))
        .toList(growable: false);
    final total = filtered
        .where((v) => _selected.contains(v.id))
        .fold<double>(0, (p, v) => p + v.planPrice);
    final currency = filtered
        .firstWhere((v) => _selected.contains(v.id),
            orElse: () => const AdminRenewVehicleOption(
                  id: '',
                  name: '',
                  plateNumber: '',
                  vin: '',
                  secondaryExpiry: null,
                  planName: '',
                  planPrice: 0,
                  planCurrency: 'USD',
                  planDurationDays: null,
                  isRenewable: false,
                ))
        .planCurrency;

    return Column(
      children: [
        Expanded(
          child: ListView(
            controller: PrimaryScrollController.maybeOf(context),
            padding: const EdgeInsets.all(OpenVtsSpacing.md),
            children: [
              OpenVtsSearchableDropdown<String>(
                label: 'User',
                hintText: 'Select user',
                searchHintText: 'Search by name, username or email…',
                sheetTitle: 'Select user',
                value: _userId,
                options: users
                    .map((u) => OpenVtsDropdownOption<String>(
                          value: u.id,
                          label: u.name.trim().isEmpty ? u.username : u.name,
                          subtitle: [
                            if (u.email.trim().isNotEmpty) u.email,
                            if (u.mobileDisplay.trim().isNotEmpty)
                              u.mobileDisplay,
                          ].join(' • '),
                          searchText:
                              '${u.name} ${u.username} ${u.email} ${u.mobileDisplay}',
                        ))
                    .toList(growable: false),
                onChanged: (value) => _selectUser(value),
              ),
              if (_loadingVehicles) ...[
                const SizedBox(height: OpenVtsSpacing.sm),
                const LinearProgressIndicator(minHeight: 2),
              ],
              if (_userId != null && !_loadingVehicles) ...[
                const SizedBox(height: OpenVtsSpacing.sm),
                OpenVtsSearchField(
                  hintText: 'Search vehicles by name, plate, plan...',
                  onChanged: (v) => setState(() => _search = v),
                ),
                if (filtered.length > 1) ...[
                  const SizedBox(height: OpenVtsSpacing.xs),
                  Builder(builder: (context) {
                    final allSelected =
                        filtered.every((v) => _selected.contains(v.id));
                    return Row(
                      children: [
                        OpenVtsButton(
                          label: allSelected
                              ? 'Deselect all filtered'
                              : 'Select all filtered',
                          variant: OpenVtsButtonVariant.secondary,
                          height: 36,
                          onPressed: () {
                            setState(() {
                              if (allSelected) {
                                _selected.removeAll(filtered.map((e) => e.id));
                              } else {
                                _selected.addAll(filtered.map((e) => e.id));
                              }
                            });
                          },
                        ),
                      ],
                    );
                  }),
                ],
                const SizedBox(height: OpenVtsSpacing.xs),
                if (filtered.isEmpty)
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: OpenVtsSpacing.sm),
                    child: Text(
                      _search.trim().isEmpty
                          ? (_vehicles.isEmpty
                              ? 'No vehicles found for this user.'
                              : 'No renewable vehicles for this user.')
                          : 'No vehicles match your search.',
                      style: OpenVtsTypography.label
                          .copyWith(color: OpenVtsColors.textSecondary),
                    ),
                  )
                else
                  Container(
                    key: const Key('renew-vehicle-list'),
                    constraints: const BoxConstraints(maxHeight: 280),
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).dividerColor),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: ListView.builder(
                      primary: false,
                      shrinkWrap: true,
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final vehicle = filtered[index];
                        final checked = _selected.contains(vehicle.id);
                        return CheckboxListTile(
                          value: checked,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: OpenVtsSpacing.sm),
                          onChanged: (_) {
                            setState(() {
                              if (checked) {
                                _selected.remove(vehicle.id);
                              } else {
                                _selected.add(vehicle.id);
                              }
                            });
                          },
                          title: Text(
                              vehicle.name.isEmpty
                                  ? vehicle.plateNumber
                                  : vehicle.name,
                              style: OpenVtsTypography.label),
                          subtitle: Text(
                              'Plan: ${vehicle.planName} • ${vehicle.planCurrency} ${vehicle.planPrice.toStringAsFixed(2)}'),
                        );
                      },
                    ),
                  ),
                if (_selected.isNotEmpty) ...[
                  const SizedBox(height: OpenVtsSpacing.xs),
                  Text(
                    '${_selected.length} vehicle${_selected.length == 1 ? '' : 's'} selected',
                    style: OpenVtsTypography.label
                        .copyWith(color: OpenVtsColors.textSecondary),
                  ),
                ],
              ],
              const SizedBox(height: OpenVtsSpacing.sm),
              OpenVtsTextField(
                label: 'Amount Override',
                controller: _amountController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: OpenVtsSpacing.sm),
              OpenVtsTextField(
                  label: 'Reference (optional)',
                  controller: _referenceController),
              const SizedBox(height: OpenVtsSpacing.sm),
              DropdownButtonFormField<AdminPaymentMode>(
                initialValue: _mode,
                decoration: InputDecoration(
                  labelText: 'Payment Mode',
                  errorText: _modeError ? 'Payment mode is required' : null,
                ),
                items: AdminPaymentMode.values
                    .map((m) => DropdownMenuItem<AdminPaymentMode>(
                        value: m, child: Text(m.label)))
                    .toList(growable: false),
                onChanged: (value) => setState(() {
                  _mode = value;
                  _modeError = false;
                }),
              ),
              const SizedBox(height: OpenVtsSpacing.sm),
              Text(
                  'Auto Total: ${(currency.isEmpty ? 'USD' : currency)} ${total.toStringAsFixed(2)}',
                  style: OpenVtsTypography.label
                      .copyWith(color: OpenVtsColors.textSecondary)),
            ],
          ),
        ),
        const Divider(height: 1),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(OpenVtsSpacing.md),
            child: Row(
              children: [
                Expanded(
                  child: OpenVtsButton(
                    label: 'Cancel',
                    variant: OpenVtsButtonVariant.secondary,
                    onPressed: state.isRenewing
                        ? null
                        : () => Navigator.of(context).pop(),
                  ),
                ),
                const SizedBox(width: OpenVtsSpacing.sm),
                Expanded(
                  child: OpenVtsButton(
                    label: 'Renew',
                    isLoading: state.isRenewing,
                    onPressed: state.isRenewing ? null : _submit,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectUser(String? userId) async {
    setState(() {
      _userId = userId;
      _vehicles = const <AdminRenewVehicleOption>[];
      _selected.clear();
    });
    if ((userId ?? '').trim().isEmpty) return;

    setState(() => _loadingVehicles = true);
    try {
      final vehicles = await ref
          .read(adminPaymentsControllerProvider.notifier)
          .loadRenewVehicles(userId!);
      if (!mounted) return;
      setState(() {
        _vehicles = vehicles;
        _loadingVehicles = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _loadingVehicles = false);
      ToastHelper.showError(error.toString(), context: context);
    }
  }

  Future<void> _submit() async {
    if ((_userId ?? '').trim().isEmpty) {
      ToastHelper.showError('User is required', context: context);
      return;
    }
    if (_selected.isEmpty) {
      ToastHelper.showError('Select at least one renewable vehicle',
          context: context);
      return;
    }
    if (_mode == null) {
      setState(() => _modeError = true);
      return;
    }

    final amount = _amountController.text.trim();
    if (amount.isNotEmpty) {
      final parsed = double.tryParse(amount);
      if (parsed == null || parsed < 0.01 || parsed > 9999999.99) {
        ToastHelper.showError('Amount must be between 0.01 and 9999999.99',
            context: context);
        return;
      }
      final split = amount.split('.');
      if (split.length > 1 && split[1].length > 2) {
        ToastHelper.showError('Amount supports up to 2 decimal places',
            context: context);
        return;
      }
    }

    final refText = _referenceController.text.trim();
    if (refText.length > 200) {
      ToastHelper.showError('Reference max length is 200', context: context);
      return;
    }

    final hints = <String, Map<String, dynamic>>{
      for (final v in _vehicles.where((v) => _selected.contains(v.id)))
        v.id: {
          'name': v.name,
          'plateNumber': v.plateNumber,
        },
    };

    final request = AdminRenewPaymentRequest(
      userId: _userId!,
      vehicleIds: _selected.toList(growable: false),
      paymentMode: _mode!,
      reference: refText,
      amountOverride: amount,
      vehicleHints: hints,
    );

    final ok = await ref
        .read(adminPaymentsControllerProvider.notifier)
        .renewVehicles(request);
    if (!mounted) return;
    if (ok) {
      Navigator.of(context).pop();
      ToastHelper.showSuccess('Vehicle renew payment submitted',
          context: context);
      return;
    }

    final err = ref.read(adminPaymentsControllerProvider).errorMessage;
    ToastHelper.showError(err ?? 'Unable to process renew payment',
        context: context);
  }
}
