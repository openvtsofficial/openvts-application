import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/open_vts_spacing.dart';
import '../../../../../core/utils/validators.dart';
import '../../../../../shared/helpers/toast_helper.dart';
import '../../../../../shared/widgets/open_vts_bottom_sheet.dart';
import '../../../../../shared/widgets/open_vts_button.dart';
import '../../../../../shared/widgets/open_vts_text_field.dart';
import '../../../controllers/admin_driver_details_controller.dart';
import '../../../controllers/admin_providers.dart';
import '../../../models/admin_driver_details_model.dart';
import '../../../models/admin_driver_details_state.dart';
import '../../../models/admin_users_model.dart';
import '../../users/widgets/admin_user_form_fields.dart';

Future<void> showDriverEditSheet({
  required BuildContext context,
  required AutoDisposeStateNotifierProvider<AdminDriverDetailsController,
          AdminDriverDetailsState>
      provider,
}) {
  return OpenVtsBottomSheet.show<void>(
    context: context,
    title: 'Edit Profile',
    initialChildSize: 0.9,
    minChildSize: 0.5,
    maxChildSize: 0.96,
    child: _DriverEditSheet(provider: provider),
  );
}

class _DriverEditSheet extends ConsumerStatefulWidget {
  const _DriverEditSheet({required this.provider});

  final AutoDisposeStateNotifierProvider<AdminDriverDetailsController,
      AdminDriverDetailsState> provider;

  @override
  ConsumerState<_DriverEditSheet> createState() => _DriverEditSheetState();
}

class _DriverEditSheetState extends ConsumerState<_DriverEditSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _email;
  late final TextEditingController _mobile;
  late final TextEditingController _username;
  late final TextEditingController _address;
  late final TextEditingController _pincode;

  String? _mobilePrefix;
  String? _countryCode;
  String? _stateCode;
  String? _cityValue;
  bool _loadingReferences = true;
  bool _loadingStates = false;
  bool _loadingCities = false;

  var _mobilePrefixes = const <AdminUserMobilePrefixOption>[];
  var _countries = const <AdminUserCountryOption>[];
  var _states = const <AdminUserStateOption>[];
  var _cities = const <AdminUserCityOption>[];
  final List<_AttrRow> _attrs = <_AttrRow>[];

  @override
  void initState() {
    super.initState();
    final driver = ref.read(widget.provider).driver;
    _name = TextEditingController(text: driver?.name ?? '');
    _email = TextEditingController(text: _editText(driver?.email));
    _mobile = TextEditingController(
      text: _stripPrefix(driver?.mobile, driver?.mobilePrefix),
    );
    _username = TextEditingController(text: driver?.username ?? '');
    _address = TextEditingController(
      text: _editText(driver?.address.addressLine),
    );
    _pincode = TextEditingController(
      text: _editText(driver?.address.pincode),
    );

    _mobilePrefix = _editValue(driver?.mobilePrefix);
    _countryCode = _editValue(driver?.address.countryCode);
    _stateCode = _editValue(driver?.address.stateCode);
    _cityValue = _editValue(driver?.address.cityId);

    final attrs = driver?.attributes ?? const <String, dynamic>{};
    if (attrs.isEmpty) {
      _attrs.add(_AttrRow());
    } else {
      for (final entry in attrs.entries) {
        _attrs.add(
          _AttrRow(key: entry.key, value: entry.value?.toString() ?? ''),
        );
      }
    }

    _loadReferenceData();
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _mobile.dispose();
    _username.dispose();
    _address.dispose();
    _pincode.dispose();
    for (final row in _attrs) {
      row.dispose();
    }
    super.dispose();
  }

  List<AdminUserDropdownOption> get _mobilePrefixOptions {
    return _mobilePrefixes
        .map((item) =>
            AdminUserDropdownOption(value: item.value, label: item.label))
        .toList(growable: false);
  }

  List<AdminUserDropdownOption> get _countryOptions {
    final options = _countries
        .map((item) =>
            AdminUserDropdownOption(value: item.value, label: item.label))
        .toList(growable: true);
    if (_countryCode != null && !options.any((o) => o.value == _countryCode)) {
      options.insert(
        0,
        AdminUserDropdownOption(
            value: _countryCode!, label: '$_countryCode (current)'),
      );
    }
    return options;
  }

  List<AdminUserDropdownOption> get _stateOptions {
    final options = _states
        .map((item) =>
            AdminUserDropdownOption(value: item.value, label: item.label))
        .toList(growable: true);
    if (_stateCode != null && !options.any((o) => o.value == _stateCode)) {
      options.insert(
        0,
        AdminUserDropdownOption(
            value: _stateCode!, label: '$_stateCode (current)'),
      );
    }
    return options;
  }

  List<AdminUserDropdownOption> get _cityOptions {
    final options = _cities
        .map((item) =>
            AdminUserDropdownOption(value: item.value, label: item.label))
        .toList(growable: true);
    if (_cityValue != null && !options.any((o) => o.value == _cityValue)) {
      options.insert(
        0,
        AdminUserDropdownOption(
            value: _cityValue!, label: '$_cityValue (current)'),
      );
    }
    return options;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(widget.provider);
    final isSubmitting = state.isSavingProfile;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(OpenVtsSpacing.md),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            OpenVtsTextField(
              label: 'Name',
              controller: _name,
              validator: Validators.driverName,
            ),
            const SizedBox(height: OpenVtsSpacing.sm),
            OpenVtsTextField(
              label: 'Email',
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              validator: (v) {
                final text = v?.trim() ?? '';
                if (text.isEmpty) return null;
                final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(text);
                return ok ? null : 'Enter a valid email';
              },
            ),
            const SizedBox(height: OpenVtsSpacing.sm),
            AdminUserDropdownField(
              label: 'Mobile Prefix',
              value: _mobilePrefix,
              options: _mobilePrefixOptions,
              hintText: '+91',
              prefixIcon: Icons.phone_android_rounded,
              isLoading: _loadingReferences,
              searchable: true,
              validator: (value) => _mobile.text.trim().isNotEmpty &&
                      (value == null || value.trim().isEmpty)
                  ? 'Mobile prefix is required'
                  : null,
              onChanged: (value) {
                setState(() => _mobilePrefix = value);
              },
            ),
            const SizedBox(height: OpenVtsSpacing.sm),
            OpenVtsTextField(
              label: 'Mobile',
              controller: _mobile,
              keyboardType: TextInputType.phone,
              validator: Validators.mobileNumber,
            ),
            const SizedBox(height: OpenVtsSpacing.sm),
            OpenVtsTextField(
              label: 'Username',
              controller: _username,
              validator: Validators.driverUsername,
            ),
            const SizedBox(height: OpenVtsSpacing.sm),
            OpenVtsTextField(
              label: 'Address',
              controller: _address,
              validator: Validators.driverAddressOptional,
            ),
            const SizedBox(height: OpenVtsSpacing.sm),
            AdminUserDropdownField(
              label: 'Country',
              value: _countryCode,
              options: _countryOptions,
              hintText: 'Select country',
              prefixIcon: Icons.public_rounded,
              isLoading: _loadingReferences,
              searchable: true,
              validator: requiredDropdown,
              onChanged: _onCountryChanged,
            ),
            const SizedBox(height: OpenVtsSpacing.sm),
            AdminUserDropdownField(
              label: 'State',
              value: _stateCode,
              options: _stateOptions,
              hintText: _countryCode == null
                  ? 'Select country first'
                  : 'Select state',
              prefixIcon: Icons.map_outlined,
              isLoading: _loadingStates,
              searchable: true,
              validator: requiredDropdown,
              onChanged: _countryCode == null ? null : _onStateChanged,
            ),
            const SizedBox(height: OpenVtsSpacing.sm),
            AdminUserDropdownField(
              label: 'City',
              value: _cityValue,
              options: _cityOptions,
              hintText:
                  _stateCode == null ? 'Select state first' : 'Select city',
              prefixIcon: Icons.location_city_rounded,
              isLoading: _loadingCities,
              searchable: true,
              validator: requiredDropdown,
              onChanged: _stateCode == null
                  ? null
                  : (value) => setState(() => _cityValue = value),
            ),
            const SizedBox(height: OpenVtsSpacing.sm),
            OpenVtsTextField(
              label: 'Pincode',
              controller: _pincode,
              validator: Validators.driverPincodeOptional,
            ),
            const SizedBox(height: OpenVtsSpacing.sm),
            const Text('Attributes'),
            const SizedBox(height: OpenVtsSpacing.xs),
            ..._attrs.asMap().entries.map((entry) {
              final index = entry.key;
              final row = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: OpenVtsSpacing.xs),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: row.key,
                        decoration: const InputDecoration(hintText: 'Key'),
                      ),
                    ),
                    const SizedBox(width: OpenVtsSpacing.xs),
                    Expanded(
                      child: TextFormField(
                        controller: row.value,
                        decoration: const InputDecoration(hintText: 'Value'),
                      ),
                    ),
                    IconButton(
                      onPressed: _attrs.length == 1
                          ? null
                          : () {
                              setState(() {
                                _attrs.removeAt(index).dispose();
                              });
                            },
                      icon: const Icon(Icons.remove_circle_outline),
                    ),
                  ],
                ),
              );
            }),
            TextButton.icon(
              onPressed: () => setState(() => _attrs.add(_AttrRow())),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add attribute'),
            ),
            const SizedBox(height: OpenVtsSpacing.sm),
            OpenVtsButton(
              label: 'Save Profile',
              isLoading: isSubmitting,
              onPressed: isSubmitting ? null : _submit,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _loadReferenceData() async {
    try {
      final controller = ref.read(adminUsersControllerProvider.notifier);
      final countriesFuture = controller.getCountries();
      final prefixesFuture = controller.getMobilePrefixes();
      final countries = await countriesFuture;
      final prefixes = await prefixesFuture;

      if (!mounted) return;

      setState(() {
        _countries = countries;
        _mobilePrefixes = prefixes;
        _loadingReferences = false;
      });

      await _loadStates(_countryCode, clearSelection: false);
      await _loadCities(_countryCode, _stateCode, clearSelection: false);
    } catch (_) {
      if (!mounted) return;
      setState(() => _loadingReferences = false);
      if (mounted) {
        ToastHelper.showError('Unable to load form options.', context: context);
      }
    }
  }

  Future<void> _onCountryChanged(String? value) async {
    if (value == _countryCode) return;
    setState(() {
      _countryCode = value;
      _stateCode = null;
      _cityValue = null;
      _states = const <AdminUserStateOption>[];
      _cities = const <AdminUserCityOption>[];
    });
    await _loadStates(value, clearSelection: true);
  }

  Future<void> _onStateChanged(String? value) async {
    if (value == _stateCode) return;
    setState(() {
      _stateCode = value;
      _cityValue = null;
      _cities = const <AdminUserCityOption>[];
    });
    await _loadCities(_countryCode, value, clearSelection: true);
  }

  Future<void> _loadStates(
    String? countryCode, {
    required bool clearSelection,
  }) async {
    final requestedCountry = countryCode?.trim().toUpperCase();
    if (requestedCountry == null || requestedCountry.isEmpty) return;

    setState(() => _loadingStates = true);
    try {
      final states = await ref
          .read(adminUsersControllerProvider.notifier)
          .getStates(requestedCountry);
      if (!mounted || _countryCode?.toUpperCase() != requestedCountry) return;
      setState(() {
        _states = states;
        if (clearSelection) _stateCode = null;
        _loadingStates = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loadingStates = false);
      ToastHelper.showError('Unable to load states.', context: context);
    }
  }

  Future<void> _loadCities(
    String? countryCode,
    String? stateCode, {
    required bool clearSelection,
  }) async {
    final requestedCountry = countryCode?.trim().toUpperCase();
    final requestedState = stateCode?.trim().toUpperCase();
    if (requestedCountry == null ||
        requestedCountry.isEmpty ||
        requestedState == null ||
        requestedState.isEmpty) {
      return;
    }

    setState(() => _loadingCities = true);
    try {
      final cities = await ref
          .read(adminUsersControllerProvider.notifier)
          .getCities(requestedCountry, requestedState);
      if (!mounted ||
          _countryCode?.toUpperCase() != requestedCountry ||
          _stateCode?.toUpperCase() != requestedState) {
        return;
      }
      setState(() {
        _cities = cities;
        if (clearSelection) _cityValue = null;
        _loadingCities = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loadingCities = false);
      ToastHelper.showError('Unable to load cities.', context: context);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final attributes = <String, dynamic>{};
    final seen = <String>{};
    for (final row in _attrs) {
      final key = row.key.text.trim();
      final value = row.value.text.trim();
      if (key.isEmpty) continue;
      if (!seen.add(key.toLowerCase())) {
        ToastHelper.showError(
          'Attribute keys must be unique.',
          context: context,
        );
        return;
      }
      attributes[key] = value;
    }

    final request = AdminDriverUpdateRequest(
      name: _name.text,
      mobilePrefix: _mobilePrefix ?? '',
      mobile: _mobile.text,
      email: _email.text,
      username: _username.text,
      countryCode: _countryCode ?? '',
      stateCode: _stateCode ?? '',
      city: _cityValue ?? '',
      address: _address.text,
      pincode: _pincode.text,
      attributes: attributes,
    );

    final ok = await ref.read(widget.provider.notifier).updateProfile(request);
    if (!mounted) return;
    if (ok) {
      Navigator.of(context).pop();
      ToastHelper.showSuccess('Profile updated.', context: context);
    } else {
      ToastHelper.showError(
        ref.read(widget.provider).sectionErrorMessage ??
            'Unable to update profile.',
        context: context,
      );
    }
  }
}

/// Strips a leading country/mobile prefix from a mobile number so the Mobile
/// field shows only the subscriber number, not the composed "+91 9986546544"
/// form that some API responses place in the `mobile` key.
String _stripPrefix(String? mobile, String? prefix) {
  final raw = mobile?.trim() ?? '';
  if (raw.isEmpty || raw == '-') return '';
  final p = prefix?.trim() ?? '';
  if (p.isNotEmpty && raw.startsWith(p)) {
    return raw.substring(p.length).trimLeft();
  }
  // Also strip a bare leading '+' followed by digits if no explicit prefix was
  // matched but the value looks like a full E.164 number (+919986546544).
  if (raw.startsWith('+') && raw.length > 4) {
    // Only strip when the stored prefix is non-empty and matches the start.
    // Without a known prefix we cannot safely strip — return as-is.
  }
  return raw;
}

/// Returns a blank string for edit-field prefill when the stored value is
/// absent, the legacy `'-'` sentinel, or pure whitespace.
String _editText(String? raw) {
  final v = raw?.trim() ?? '';
  return (v.isEmpty || v == '-') ? '' : v;
}

/// Returns null for dropdown prefill when the stored value is absent,
/// the legacy `'-'` sentinel, or pure whitespace.
String? _editValue(String? raw) {
  final v = raw?.trim() ?? '';
  return (v.isEmpty || v == '-') ? null : v;
}

class _AttrRow {
  _AttrRow({String? key, String? value})
      : key = TextEditingController(text: key ?? ''),
        value = TextEditingController(text: value ?? '');

  final TextEditingController key;
  final TextEditingController value;

  void dispose() {
    key.dispose();
    value.dispose();
  }
}
