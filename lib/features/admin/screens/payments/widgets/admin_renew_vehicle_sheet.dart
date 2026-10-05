import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../../core/theme/open_vts_colors.dart';
import '../../../../../core/theme/open_vts_spacing.dart';
import '../../../../../core/theme/open_vts_typography.dart';
import '../../../../../shared/helpers/mobile_text.dart';
import '../../../../../shared/helpers/toast_helper.dart';
import '../../../../../shared/widgets/open_vts_button.dart';
import '../../../../../shared/widgets/open_vts_search_field.dart';
import '../../../../../shared/widgets/open_vts_searchable_dropdown.dart';
import '../../../../../shared/widgets/open_vts_text_field.dart';
import '../../../controllers/admin_providers.dart';
import '../../../models/admin_payments_model.dart';
import '../../../models/admin_users_model.dart';

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
  final _overrideReasonController = TextEditingController();
  String? _lastPayload;
  String? _idempotencyKey;
  int _vehicleRequest = 0;
  List<AdminUserListItem> _renewalUsers = const [];
  String? _usersError;
  @override
  void initState() {
    super.initState();
    _amountController.addListener(() {
      if (mounted) setState(() {});
    });
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    try {
      final users = await ref
          .read(adminPaymentsControllerProvider.notifier)
          .loadRenewalUsers();
      if (mounted) {
        setState(() {
          _renewalUsers = users;
          _usersError = null;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _usersError = 'Renewal users could not be loaded.');
      }
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _referenceController.dispose();
    _overrideReasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminPaymentsControllerProvider);
    final users = _renewalUsers;

    final filtered = _vehicles
        .where((v) => v.isRenewable && v.matchesQuery(_search))
        .toList(growable: false);
    final total = _vehicles
        .where((v) => _selected.contains(v.id))
        .fold<double>(0, (p, v) => p + v.planPrice);
    final currency = _vehicles
        .firstWhere(
          (v) => _selected.contains(v.id),
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
          ),
        )
        .planCurrency;

    return Column(
      children: [
        Expanded(
          child: ListView(
            controller: PrimaryScrollController.maybeOf(context),
            padding: const EdgeInsets.all(OpenVtsSpacing.md),
            children: [
              if (_usersError != null)
                TextButton(
                  onPressed: _loadUsers,
                  child: Text(
                    context.mobileText("{value1} Retry", {
                      'value1': (_usersError).toString(),
                    }),
                  ),
                ),
              OpenVtsSearchableDropdown<String>(
                label: context.mobileText('User'),
                hintText: context.mobileText('Select user'),
                searchHintText: 'Search by name, username or email…',
                sheetTitle: 'Select user',
                value: _userId,
                options: users
                    .map(
                      (u) => OpenVtsDropdownOption<String>(
                        value: u.id,
                        label: u.name.trim().isEmpty ? u.username : u.name,
                        subtitle: [
                          if (u.email.trim().isNotEmpty) u.email,
                          if (u.mobileDisplay.trim().isNotEmpty)
                            u.mobileDisplay,
                        ].join(' • '),
                        searchText:
                            '${u.name} ${u.username} ${u.email} ${u.mobileDisplay}',
                      ),
                    )
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
                  hintText: context.mobileText(
                    'Search vehicles by name, plate, plan...',
                  ),
                  onChanged: (v) => setState(() => _search = v),
                ),
                if (filtered.length > 1) ...[
                  const SizedBox(height: OpenVtsSpacing.xs),
                  Builder(
                    builder: (context) {
                      final allSelected = filtered.every(
                        (v) => _selected.contains(v.id),
                      );
                      return Row(
                        children: [
                          OpenVtsButton(
                            label: allSelected
                                ? context.mobileText('Deselect all filtered')
                                : context.mobileText('Select all filtered'),
                            variant: OpenVtsButtonVariant.secondary,
                            height: 36,
                            onPressed: () {
                              setState(() {
                                if (allSelected) {
                                  _selected.removeAll(
                                    filtered.map((e) => e.id),
                                  );
                                } else {
                                  _selected.addAll(filtered.map((e) => e.id));
                                }
                              });
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ],
                const SizedBox(height: OpenVtsSpacing.xs),
                if (filtered.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: OpenVtsSpacing.sm,
                    ),
                    child: Text(
                      _search.trim().isEmpty
                          ? (_vehicles.isEmpty
                                ? 'No vehicles found for this user.'
                                : 'No renewable vehicles for this user.')
                          : context.mobileText(
                              'No vehicles match your search.',
                            ),
                      style: OpenVtsTypography.label.copyWith(
                        color: OpenVtsColors.textSecondary,
                      ),
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
                            horizontal: OpenVtsSpacing.sm,
                          ),
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
                            style: OpenVtsTypography.label,
                          ),
                          subtitle: Text(
                            context.mobileText(
                              "Plan: {value1} • {value2} {value3}",
                              {
                                'value1': (vehicle.planName).toString(),
                                'value2': (vehicle.planCurrency).toString(),
                                'value3': (vehicle.planPrice.toStringAsFixed(
                                  2,
                                )).toString(),
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                if (_selected.isNotEmpty) ...[
                  const SizedBox(height: OpenVtsSpacing.xs),
                  Text(
                    context.mobileText("{value1} vehicle{value2} selected", {
                      'value1': (_selected.length).toString(),
                      'value2': (_selected.length == 1 ? '' : 's').toString(),
                    }),
                    style: OpenVtsTypography.label.copyWith(
                      color: OpenVtsColors.textSecondary,
                    ),
                  ),
                ],
              ],
              const SizedBox(height: OpenVtsSpacing.sm),
              OpenVtsTextField(
                label: context.mobileText('Amount Override'),
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
              const SizedBox(height: OpenVtsSpacing.sm),
              if (_amountController.text.trim().isNotEmpty) ...[
                OpenVtsTextField(
                  label: context.mobileText(
                    'Reason for amount override (5–500 characters)',
                  ),
                  controller: _overrideReasonController,
                ),
                const SizedBox(height: OpenVtsSpacing.sm),
              ],
              OpenVtsTextField(
                label: context.mobileText('Reference (optional)'),
                controller: _referenceController,
              ),
              const SizedBox(height: OpenVtsSpacing.sm),
              DropdownButtonFormField<AdminPaymentMode>(
                initialValue: _mode,
                decoration: InputDecoration(
                  labelText: context.mobileText('Payment Mode'),
                  errorText: _modeError ? 'Payment mode is required' : null,
                ),
                items: AdminPaymentMode.values
                    .where(
                      (mode) =>
                          mode != AdminPaymentMode.razorpay &&
                          mode != AdminPaymentMode.stripe &&
                          mode != AdminPaymentMode.wallet,
                    )
                    .map(
                      (m) => DropdownMenuItem<AdminPaymentMode>(
                        value: m,
                        child: Text(m.label),
                      ),
                    )
                    .toList(growable: false),
                onChanged: (value) => setState(() {
                  _mode = value;
                  _modeError = false;
                }),
              ),
              const SizedBox(height: OpenVtsSpacing.sm),
              Text(
                context.mobileText("Auto Total: {value1} {value2}", {
                  'value1': ((currency.isEmpty ? 'USD' : currency)).toString(),
                  'value2': (total.toStringAsFixed(2)).toString(),
                }),
                style: OpenVtsTypography.label.copyWith(
                  color: OpenVtsColors.textSecondary,
                ),
              ),
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
                    label: context.mobileText('Cancel'),
                    variant: OpenVtsButtonVariant.secondary,
                    onPressed: state.isRenewing
                        ? null
                        : () => Navigator.of(context).pop(),
                  ),
                ),
                const SizedBox(width: OpenVtsSpacing.sm),
                Expanded(
                  child: OpenVtsButton(
                    label: context.mobileText('Renew'),
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
    final requestId = ++_vehicleRequest;
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
      if (!mounted || requestId != _vehicleRequest) return;
      setState(() {
        _vehicles = vehicles;
        _loadingVehicles = false;
      });
    } catch (error) {
      if (!mounted || requestId != _vehicleRequest) return;
      setState(() => _loadingVehicles = false);
      ToastHelper.showError(error.toString(), context: context);
    }
  }

  Future<void> _submit() async {
    if ((_userId ?? '').trim().isEmpty) {
      ToastHelper.showError(
        context.mobileText('User is required'),
        context: context,
      );
      return;
    }
    if (_selected.isEmpty) {
      ToastHelper.showError(
        context.mobileText('Select at least one renewable vehicle'),
        context: context,
      );
      return;
    }
    if (_selected.length > 100) {
      ToastHelper.showError(
        context.mobileText('Renew up to 100 vehicles at a time'),
        context: context,
      );
      return;
    }
    final currencies = _vehicles
        .where((v) => _selected.contains(v.id))
        .map((v) => v.planCurrency)
        .toSet();
    if (currencies.length > 1) {
      ToastHelper.showError(
        context.mobileText('Select vehicles with the same plan currency'),
        context: context,
      );
      return;
    }
    if (_mode == null) {
      setState(() => _modeError = true);
      return;
    }

    final amount = _amountController.text.trim();
    if (amount.isNotEmpty) {
      if (!RegExp(r'^\d+(\.\d{1,2})?$').hasMatch(amount)) {
        ToastHelper.showError(
          context.mobileText(
            'Enter a decimal amount with at most 2 decimal places',
          ),
          context: context,
        );
        return;
      }
      final reason = _overrideReasonController.text.trim();
      if (reason.length < 5 || reason.length > 500) {
        ToastHelper.showError(
          context.mobileText('Enter an override reason of 5–500 characters'),
          context: context,
        );
        return;
      }
      final parsed = double.tryParse(amount);
      if (parsed == null || parsed < 0.01 || parsed > 9999999.99) {
        ToastHelper.showError(
          context.mobileText('Amount must be between 0.01 and 9999999.99'),
          context: context,
        );
        return;
      }
      final split = amount.split('.');
      if (split.length > 1 && split[1].length > 2) {
        ToastHelper.showError(
          context.mobileText('Amount supports up to 2 decimal places'),
          context: context,
        );
        return;
      }
    }

    final refText = _referenceController.text.trim();
    if (refText.length > 200) {
      ToastHelper.showError(
        context.mobileText('Reference max length is 200'),
        context: context,
      );
      return;
    }

    final hints = <String, Map<String, dynamic>>{
      for (final v in _vehicles.where((v) => _selected.contains(v.id)))
        v.id: {'name': v.name, 'plateNumber': v.plateNumber},
    };

    final sortedIds = _selected.toList()..sort();
    final payload =
        '$_userId|${sortedIds.join(',')}|${_mode!.apiValue}|$refText|$amount|${_overrideReasonController.text.trim()}';
    if (_lastPayload != payload) {
      _lastPayload = payload;
      _idempotencyKey = const Uuid().v4();
    }
    final request = AdminRenewPaymentRequest(
      userId: _userId!,
      vehicleIds: sortedIds,
      paymentMode: _mode!,
      reference: refText,
      amountOverride: amount,
      overrideReason: amount.isEmpty
          ? null
          : _overrideReasonController.text.trim(),
      idempotencyKey: _idempotencyKey,
      vehicleHints: hints,
    );

    final ok = await ref
        .read(adminPaymentsControllerProvider.notifier)
        .renewVehicles(request);
    if (!mounted) return;
    if (ok) {
      Navigator.of(context).pop();
      ToastHelper.showSuccess(
        context.mobileText('Vehicle renew payment submitted'),
        context: context,
      );
      return;
    }

    final err = ref.read(adminPaymentsControllerProvider).errorMessage;
    ToastHelper.showError(
      err ?? 'Unable to process renew payment',
      context: context,
    );
  }
}
