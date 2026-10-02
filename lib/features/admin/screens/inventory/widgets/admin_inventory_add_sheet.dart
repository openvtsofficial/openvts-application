import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/open_vts_colors.dart';
import '../../../../../core/theme/open_vts_spacing.dart';
import '../../../../../core/theme/open_vts_typography.dart';
import '../../../../../core/utils/validators.dart';
import '../../../../../shared/helpers/toast_helper.dart';
import '../../../../../shared/widgets/open_vts_button.dart';
import '../../../../../shared/widgets/open_vts_text_field.dart';
import '../../../../../shared/widgets/searchable_dropdown_field.dart';
import '../../../controllers/admin_providers.dart';
import '../../../models/admin_inventory_model.dart';

enum AdminInventoryAddMode { device, sim, both }

class AdminInventoryAddSheet extends ConsumerStatefulWidget {
  const AdminInventoryAddSheet({super.key});

  @override
  ConsumerState<AdminInventoryAddSheet> createState() =>
      _AdminInventoryAddSheetState();
}

class _AdminInventoryAddSheetState
    extends ConsumerState<AdminInventoryAddSheet> {
  final _formKey = GlobalKey<FormState>();
  final _imeiController = TextEditingController();
  final _simNumberController = TextEditingController();
  final _imsiController = TextEditingController();
  final _iccidController = TextEditingController();

  AdminInventoryAddMode _mode = AdminInventoryAddMode.device;
  List<AdminDeviceTypeOption> _deviceTypes = const <AdminDeviceTypeOption>[];
  List<AdminSimProviderOption> _providers = const <AdminSimProviderOption>[];
  String? _deviceTypeId;
  String? _providerId;
  bool _loadingRefs = true;
  String? _referenceError;
  int _referenceGeneration = 0;

  @override
  void initState() {
    super.initState();
    _loadReferences();
  }

  @override
  void dispose() {
    _imeiController.dispose();
    _simNumberController.dispose();
    _imsiController.dispose();
    _iccidController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminInventoryControllerProvider);
    final isSubmitting = state.isCreating;

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Flexible(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(OpenVtsSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _modeChips(),
                    if (_loadingRefs) ...[
                      const SizedBox(height: OpenVtsSpacing.sm),
                      const _ReferenceLoadingIndicator(),
                    ] else if (_referenceError != null) ...[
                      const SizedBox(height: OpenVtsSpacing.sm),
                      _ReferenceLoadError(
                        message: _referenceError!,
                        onRetry: _loadReferences,
                      ),
                    ],
                    const SizedBox(height: OpenVtsSpacing.sm),
                    if (_mode != AdminInventoryAddMode.sim) ...[
                      OpenVtsTextField(
                        label: 'IMEI',
                        controller: _imeiController,
                        keyboardType: TextInputType.number,
                        validator: _validateImei,
                      ),
                      const SizedBox(height: OpenVtsSpacing.sm),
                      SearchableDropdownField<String>(
                        key: ValueKey(
                          'device-type-$_referenceGeneration-$_deviceTypeId',
                        ),
                        label: 'Device Type',
                        hintText: _loadingRefs
                            ? 'Loading device types...'
                            : 'Select device type',
                        searchHint: 'Search device type…',
                        initialValue: _deviceTypeId,
                        items: _deviceTypes
                            .map((item) => SearchableDropdownItem<String>(
                                  value: item.id,
                                  label: item.name,
                                ))
                            .toList(growable: false),
                        enabled: !isSubmitting &&
                            !_loadingRefs &&
                            _referenceError == null &&
                            _deviceTypes.isNotEmpty,
                        validator: _mode == AdminInventoryAddMode.sim
                            ? null
                            : (value) => (value == null || value.isEmpty)
                                ? 'Device type is required'
                                : null,
                        onChanged: (v) => setState(() => _deviceTypeId = v),
                      ),
                      const SizedBox(height: OpenVtsSpacing.sm),
                    ],
                    if (_mode != AdminInventoryAddMode.device) ...[
                      OpenVtsTextField(
                        label: 'SIM Number',
                        controller: _simNumberController,
                        keyboardType: TextInputType.number,
                        validator: (v) {
                          if (_mode == AdminInventoryAddMode.device) {
                            return null;
                          }
                          return Validators.simNumber(v);
                        },
                      ),
                      const SizedBox(height: OpenVtsSpacing.sm),
                      OpenVtsTextField(
                        label: 'IMSI (optional)',
                        controller: _imsiController,
                        keyboardType: TextInputType.number,
                        validator: _validateImsi,
                      ),
                      const SizedBox(height: OpenVtsSpacing.sm),
                      OpenVtsTextField(
                        label: 'ICCID (optional)',
                        controller: _iccidController,
                        keyboardType: TextInputType.number,
                        validator: _validateIccid,
                      ),
                      const SizedBox(height: OpenVtsSpacing.sm),
                      SearchableDropdownField<String>(
                        key: ValueKey(
                          'sim-provider-$_referenceGeneration-$_providerId',
                        ),
                        label: 'SIM Provider (optional)',
                        hintText: 'Select provider',
                        searchHint: 'Search provider…',
                        initialValue: _providerId,
                        items: [
                          const SearchableDropdownItem<String>(
                              value: '', label: 'No Provider'),
                          ..._providers
                              .map((item) => SearchableDropdownItem<String>(
                                    value: item.id,
                                    label: item.name,
                                  )),
                        ],
                        enabled: !isSubmitting &&
                            !_loadingRefs &&
                            _referenceError == null,
                        onChanged: (v) => setState(() => _providerId = v),
                      ),
                    ],
                  ],
                ),
              ),
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
                      onPressed: isSubmitting
                          ? null
                          : () => Navigator.of(context).pop(),
                    ),
                  ),
                  const SizedBox(width: OpenVtsSpacing.sm),
                  Expanded(
                    child: OpenVtsButton(
                      label: 'Save',
                      isLoading: isSubmitting,
                      onPressed: isSubmitting ? null : _submit,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _modeChips() {
    return SizedBox(
      height: 36,
      child: Row(
        children: [
          Expanded(
            child: _ModeChip(
              label: 'Device Only',
              isSelected: _mode == AdminInventoryAddMode.device,
              onTap: () => setState(() => _mode = AdminInventoryAddMode.device),
            ),
          ),
          const SizedBox(width: OpenVtsSpacing.xs),
          Expanded(
            child: _ModeChip(
              label: 'SIM Only',
              isSelected: _mode == AdminInventoryAddMode.sim,
              onTap: () => setState(() => _mode = AdminInventoryAddMode.sim),
            ),
          ),
          const SizedBox(width: OpenVtsSpacing.xs),
          Expanded(
            child: _ModeChip(
              label: 'Device + SIM',
              isSelected: _mode == AdminInventoryAddMode.both,
              onTap: () => setState(() => _mode = AdminInventoryAddMode.both),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _loadReferences() async {
    setState(() {
      _loadingRefs = true;
      _referenceError = null;
    });
    final controller = ref.read(adminInventoryControllerProvider.notifier);
    try {
      final results = await Future.wait([
        controller.loadDeviceTypes(),
        controller.loadSimProviders(),
      ]);
      if (!mounted) return;
      final deviceTypes = results[0] as List<AdminDeviceTypeOption>;
      final providers = results[1] as List<AdminSimProviderOption>;
      setState(() {
        _deviceTypes = deviceTypes;
        _providers = providers;
        _deviceTypeId = null;
        _providerId = '';
        _loadingRefs = false;
        _referenceGeneration++;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loadingRefs = false;
        _referenceError = 'Unable to load device types and providers.';
        _referenceGeneration++;
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final controller = ref.read(adminInventoryControllerProvider.notifier);
    dynamic result;
    bool success = false;

    if (_mode == AdminInventoryAddMode.device) {
      result = await controller.createDevice(
        AdminCreateDeviceRequest(
          imei: _imeiController.text,
          deviceTypeId: int.parse(_deviceTypeId ?? '0'),
        ),
      );
      success = result != null;
    } else if (_mode == AdminInventoryAddMode.sim) {
      result = await controller.createSimCard(
        AdminCreateSimCardRequest(
          simNumber: _simNumberController.text,
          imsi: _imsiController.text,
          iccid: _iccidController.text,
          providerId: (_providerId ?? '').trim().isEmpty ? null : _providerId,
        ),
      );
      success = result;
    } else {
      result = await controller.createDeviceAndSim(
        AdminCreateDeviceAndSimRequest(
          imei: _imeiController.text,
          deviceTypeId: int.parse(_deviceTypeId ?? '0'),
          simNumber: _simNumberController.text,
          imsi: _imsiController.text,
          iccid: _iccidController.text,
          providerId: (_providerId ?? '').trim().isEmpty ? null : _providerId,
        ),
      );
      success = result;
    }

    if (!mounted) {
      return;
    }
    if (success) {
      Navigator.of(context).pop(result);
      ToastHelper.showSuccess('Inventory item created.', context: context);
      return;
    }

    final message =
        ref.read(adminInventoryControllerProvider).createErrorMessage;
    ToastHelper.showError(message ?? 'Unable to create inventory item.',
        context: context);
  }

  String? _validateImei(String? value) {
    if (_mode == AdminInventoryAddMode.sim) {
      return null;
    }
    final input = (value ?? '').trim();
    if (input.isEmpty) {
      return 'IMEI is required';
    }
    if (!RegExp(r'^\d+$').hasMatch(input)) {
      return 'IMEI must be digits only';
    }
    if (input.length < 5 || input.length > 20) {
      return 'IMEI length must be 5-20 digits';
    }
    return null;
  }

  String? _validateImsi(String? value) {
    final input = (value ?? '').trim();
    if (input.isEmpty) {
      return null;
    }
    if (!RegExp(r'^\d+$').hasMatch(input)) {
      return 'IMSI must be digits only';
    }
    if (input.length < 5 || input.length > 20) {
      return 'IMSI length must be 5-20 digits';
    }
    return null;
  }

  String? _validateIccid(String? value) {
    final input = (value ?? '').trim();
    if (input.isEmpty) {
      return null;
    }
    if (!RegExp(r'^\d+$').hasMatch(input)) {
      return 'ICCID must be digits only';
    }
    if (input.length < 10 || input.length > 25) {
      return 'ICCID length must be 10-25 digits';
    }
    return null;
  }
}

class _ModeChip extends StatelessWidget {
  const _ModeChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bgColor = isSelected ? OpenVtsColors.brandInk : OpenVtsColors.white;
    final fgColor =
        isSelected ? OpenVtsColors.white : OpenVtsColors.textPrimary;
    final borderColor =
        isSelected ? OpenVtsColors.brandInk : OpenVtsColors.border;

    return Material(
      color: bgColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: borderColor),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: OpenVtsTypography.meta.copyWith(
              color: fgColor,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _ReferenceLoadingIndicator extends StatelessWidget {
  const _ReferenceLoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return const Row(
      key: Key('inventory-reference-loading'),
      children: [
        SizedBox.square(
          dimension: 16,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        SizedBox(width: OpenVtsSpacing.xs),
        Expanded(child: Text('Loading device types and providers...')),
      ],
    );
  }
}

class _ReferenceLoadError extends StatelessWidget {
  const _ReferenceLoadError({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Row(
      key: const Key('inventory-reference-error'),
      children: [
        const Icon(Icons.error_outline, color: OpenVtsColors.error),
        const SizedBox(width: OpenVtsSpacing.xs),
        Expanded(
          child: Text(
            message,
            style: OpenVtsTypography.meta.copyWith(
              color: OpenVtsColors.error,
            ),
          ),
        ),
        TextButton(
          onPressed: onRetry,
          child: const Text('Retry'),
        ),
      ],
    );
  }
}
