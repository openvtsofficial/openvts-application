import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/theme/open_vts_colors.dart';
import '../../../../../../core/theme/open_vts_spacing.dart';
import '../../../../../../core/theme/open_vts_typography.dart';
import '../../../../../../core/utils/validators.dart';
import '../../../../../../shared/helpers/phone_helper.dart';
import '../../../../../../shared/helpers/toast_helper.dart';
import '../../../../../../shared/widgets/open_vts_button.dart';
import '../../../../../../shared/widgets/open_vts_searchable_dropdown.dart';
import '../../../../../../shared/widgets/open_vts_text_field.dart';
import '../../../../controllers/user_driver_details_controller.dart';
import '../../../../controllers/user_providers.dart';
import '../../../../models/user_driver_model.dart';
import '../../../../models/user_drivers_state.dart';

class UserDriverEditSheet extends ConsumerStatefulWidget {
  const UserDriverEditSheet({
    required this.provider,
    required this.driver,
    super.key,
  });

  final AutoDisposeStateNotifierProvider<UserDriverDetailsController,
      UserDriverDetailsState> provider;
  final UserDriver driver;

  @override
  ConsumerState<UserDriverEditSheet> createState() =>
      _UserDriverEditSheetState();
}

class _UserDriverEditSheetState extends ConsumerState<UserDriverEditSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _addressController = TextEditingController();
  final _pincodeController = TextEditingController();

  var _obscurePassword = true;
  var _isLoadingReferences = true;
  var _isLoadingStates = false;
  var _isLoadingCities = false;
  var _referenceLoadFailed = false;
  var _statesLoadFailed = false;
  var _citiesLoadFailed = false;

  var _mobilePrefix = '';
  var _countryCode = '';
  String? _stateCode;
  String? _city;
  List<UserDriverCountryOption> _countries = const <UserDriverCountryOption>[];
  List<UserDriverMobilePrefixOption> _mobilePrefixes =
      const <UserDriverMobilePrefixOption>[];
  List<UserDriverStateOption> _states = const <UserDriverStateOption>[];
  List<UserDriverCityOption> _cities = const <UserDriverCityOption>[];

  @override
  void initState() {
    super.initState();
    final driver = widget.driver;
    _nameController.text = driver.name;
    _emailController.text = driver.email;
    _usernameController.text = driver.username;
    _addressController.text = driver.address;
    _pincodeController.text = driver.pincode;
    _countryCode = driver.countryCode.trim().toUpperCase();
    _stateCode = _optionalValue(driver.stateCode)?.toUpperCase();
    _city = _optionalValue(driver.city);

    final normalized = normalizePhoneParts(
      dialCode: driver.mobilePrefix,
      mobile: driver.mobile,
    );
    _mobilePrefix = normalized.dialCode;
    _mobileController.text = normalized.nationalNumber;

    _loadReferenceData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _addressController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(widget.provider);
    final isSubmitting = state.isSaving;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            controller: PrimaryScrollController.maybeOf(context),
            padding: const EdgeInsets.all(OpenVtsSpacing.md),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  OpenVtsTextField(
                    label: 'Name',
                    controller: _nameController,
                    hintText: 'Driver name',
                    prefixIcon: Icons.badge_outlined,
                    textInputAction: TextInputAction.next,
                    validator: Validators.driverName,
                  ),
                  const SizedBox(height: OpenVtsSpacing.sm),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 140,
                        child: OpenVtsSearchableDropdown<String>(
                          label: 'Prefix',
                          options: _mobilePrefixSearchOptions,
                          value: _mobilePrefix.isEmpty ? null : _mobilePrefix,
                          hintText: '+91',
                          searchHintText: 'Search code or country',
                          leadingIcon: Icons.call_outlined,
                          isLoading: _isLoadingReferences,
                          enabled: !_isLoadingReferences,
                          required: true,
                          validator: (_) => _requiredDropdown(_mobilePrefix),
                          onChanged: (value) {
                            setState(() => _mobilePrefix = value ?? '');
                          },
                        ),
                      ),
                      const SizedBox(width: OpenVtsSpacing.sm),
                      Expanded(
                        child: OpenVtsTextField(
                          label: 'Mobile',
                          controller: _mobileController,
                          hintText: '7 to 15 digits',
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                          prefixIcon: Icons.phone_outlined,
                          validator: Validators.mobileNumber,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: OpenVtsSpacing.sm),
                  OpenVtsTextField(
                    label: 'Email',
                    controller: _emailController,
                    hintText: 'Optional email',
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    prefixIcon: Icons.mail_outline_rounded,
                    validator: _optionalEmailValidator,
                  ),
                  const SizedBox(height: OpenVtsSpacing.sm),
                  OpenVtsTextField(
                    label: 'Username',
                    controller: _usernameController,
                    hintText: 'Username',
                    textInputAction: TextInputAction.next,
                    prefixIcon: Icons.alternate_email_rounded,
                    validator: Validators.driverUsername,
                  ),
                  const SizedBox(height: OpenVtsSpacing.sm),
                  OpenVtsTextField(
                    label: 'Password (optional)',
                    controller: _passwordController,
                    hintText: 'Leave blank to keep current password',
                    obscureText: _obscurePassword,
                    textInputAction: TextInputAction.next,
                    prefixIcon: Icons.lock_outline_rounded,
                    suffixIcon: IconButton(
                      tooltip:
                          _obscurePassword ? 'Show password' : 'Hide password',
                      onPressed: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                    ),
                    validator: _optionalPasswordValidator,
                  ),
                  const SizedBox(height: OpenVtsSpacing.sm),
                  OpenVtsSearchableDropdown<String>(
                    label: 'Country',
                    options: _countrySearchOptions,
                    value: _countryCode.isEmpty ? null : _countryCode,
                    hintText: 'Select country',
                    leadingIcon: Icons.public_rounded,
                    isLoading: _isLoadingReferences,
                    enabled: !_isLoadingReferences,
                    required: true,
                    validator: (_) => _requiredDropdown(_countryCode),
                    onChanged: _onCountryChanged,
                  ),
                  if (_referenceLoadFailed)
                    _RetryRow(
                      message: 'Failed to load countries',
                      onRetry: _loadReferenceData,
                    ),
                  const SizedBox(height: OpenVtsSpacing.sm),
                  OpenVtsSearchableDropdown<String>(
                    label: 'State',
                    options: _stateSearchOptions,
                    value: _stateCode,
                    hintText: _countryCode.isEmpty
                        ? 'Select country first'
                        : 'Select state',
                    emptyMessage: 'No states available for this country',
                    leadingIcon: Icons.map_outlined,
                    isLoading: _isLoadingStates,
                    enabled: _countryCode.isNotEmpty &&
                        !_isLoadingStates &&
                        !_statesLoadFailed,
                    onChanged: _onStateChanged,
                  ),
                  if (_statesLoadFailed && _countryCode.isNotEmpty)
                    _RetryRow(
                      message: 'Failed to load states',
                      onRetry: () => _loadStates(_countryCode),
                    ),
                  const SizedBox(height: OpenVtsSpacing.sm),
                  OpenVtsSearchableDropdown<String>(
                    label: 'City',
                    options: _citySearchOptions,
                    value: _city,
                    hintText: _stateCode == null || _stateCode!.isEmpty
                        ? 'Select state first'
                        : 'Select city',
                    emptyMessage: 'No cities available for this state',
                    leadingIcon: Icons.location_city_outlined,
                    isLoading: _isLoadingCities,
                    enabled: _stateCode != null &&
                        _stateCode!.isNotEmpty &&
                        !_isLoadingCities &&
                        !_citiesLoadFailed,
                    onChanged: (value) => setState(() => _city = value),
                  ),
                  if (_citiesLoadFailed &&
                      _stateCode != null &&
                      _stateCode!.isNotEmpty)
                    _RetryRow(
                      message: 'Failed to load cities',
                      onRetry: () => _loadCities(_countryCode, _stateCode),
                    ),
                  const SizedBox(height: OpenVtsSpacing.sm),
                  OpenVtsTextField(
                    label: 'Address',
                    controller: _addressController,
                    hintText: 'Address',
                    textInputAction: TextInputAction.next,
                    prefixIcon: Icons.home_outlined,
                    validator: Validators.driverAddressOptional,
                  ),
                  const SizedBox(height: OpenVtsSpacing.sm),
                  OpenVtsTextField(
                    label: 'Pincode',
                    controller: _pincodeController,
                    hintText: 'Postal code',
                    textInputAction: TextInputAction.done,
                    prefixIcon: Icons.pin_drop_outlined,
                    validator: Validators.driverPincodeOptional,
                  ),
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
                    height: 40,
                    variant: OpenVtsButtonVariant.secondary,
                    onPressed:
                        isSubmitting ? null : () => Navigator.of(context).pop(),
                  ),
                ),
                const SizedBox(width: OpenVtsSpacing.sm),
                Expanded(
                  child: OpenVtsButton(
                    label: 'Save',
                    height: 40,
                    trailingIcon: Icons.check_rounded,
                    isLoading: isSubmitting,
                    onPressed: isSubmitting ? null : _submit,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<OpenVtsDropdownOption<String>> get _mobilePrefixSearchOptions {
    final options = _mobilePrefixes
        .map(
          (item) => OpenVtsDropdownOption<String>(
            value: item.value,
            label: item.value,
            subtitle: item.countryCode.isNotEmpty ? item.countryCode : null,
            searchText: '${item.value} ${item.countryCode} ${item.label}',
          ),
        )
        .toList(growable: false);

    if (_mobilePrefix.isNotEmpty &&
        !_mobilePrefixes.any((p) => p.value == _mobilePrefix)) {
      return [
        OpenVtsDropdownOption<String>(
          value: _mobilePrefix,
          label: '$_mobilePrefix (current)',
          searchText: _mobilePrefix,
        ),
        ...options,
      ];
    }
    return options;
  }

  List<OpenVtsDropdownOption<String>> get _countrySearchOptions {
    final options = _countries
        .map((item) => OpenVtsDropdownOption<String>(
              value: item.value,
              label: item.label,
              searchText: item.value,
            ))
        .toList(growable: false);

    if (_countryCode.isNotEmpty &&
        !_countries.any((c) => c.value == _countryCode)) {
      return [
        OpenVtsDropdownOption<String>(
          value: _countryCode,
          label: '$_countryCode (current)',
          searchText: _countryCode,
        ),
        ...options,
      ];
    }
    return options;
  }

  List<OpenVtsDropdownOption<String>> get _stateSearchOptions {
    final options = _states
        .map((item) => OpenVtsDropdownOption<String>(
              value: item.value,
              label: item.label,
              searchText: item.value,
            ))
        .toList(growable: false);

    if (_stateCode != null &&
        _stateCode!.isNotEmpty &&
        !_states.any((s) => s.value == _stateCode)) {
      return [
        OpenVtsDropdownOption<String>(
          value: _stateCode!,
          label: '$_stateCode (current)',
          searchText: _stateCode,
        ),
        ...options,
      ];
    }
    return options;
  }

  List<OpenVtsDropdownOption<String>> get _citySearchOptions {
    final options = _cities
        .map((item) => OpenVtsDropdownOption<String>(
              value: item.value,
              label: item.label,
              searchText: item.value,
            ))
        .toList(growable: false);

    if (_city != null &&
        _city!.isNotEmpty &&
        !_cities.any((c) => c.value == _city)) {
      return [
        OpenVtsDropdownOption<String>(
          value: _city!,
          label: '$_city (current)',
          searchText: _city,
        ),
        ...options,
      ];
    }
    return options;
  }

  Future<void> _loadReferenceData() async {
    setState(() {
      _isLoadingReferences = true;
      _referenceLoadFailed = false;
    });

    try {
      final controller = ref.read(userDriversControllerProvider.notifier);
      final countriesFuture = controller.getCountries();
      final prefixesFuture = controller.getMobilePrefixes();

      final results = await Future.wait([countriesFuture, prefixesFuture]);

      if (!mounted) {
        return;
      }

      final countries = results[0] as List<UserDriverCountryOption>;
      final prefixes = results[1] as List<UserDriverMobilePrefixOption>;

      setState(() {
        _countries = countries;
        _mobilePrefixes = prefixes;
        _isLoadingReferences = false;
        _referenceLoadFailed = countries.isEmpty;
      });

      if (_countryCode.isNotEmpty) {
        await _loadStates(_countryCode);
      }
      if (_countryCode.isNotEmpty && (_stateCode ?? '').isNotEmpty) {
        await _loadCities(_countryCode, _stateCode);
      }
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoadingReferences = false;
        _referenceLoadFailed = true;
      });
      ToastHelper.showError('Unable to load form options.', context: context);
    }
  }

  Future<void> _onCountryChanged(String? value) async {
    final nextCountry = value?.trim().toUpperCase() ?? '';
    if (nextCountry == _countryCode) {
      return;
    }

    setState(() {
      _countryCode = nextCountry;
      _stateCode = null;
      _city = null;
      _states = const <UserDriverStateOption>[];
      _cities = const <UserDriverCityOption>[];
      _statesLoadFailed = false;
      _citiesLoadFailed = false;
    });

    if (nextCountry.isNotEmpty) {
      await _loadStates(nextCountry);
    }
  }

  Future<void> _onStateChanged(String? value) async {
    final nextState = value?.trim().toUpperCase();
    if (nextState == _stateCode) {
      return;
    }

    setState(() {
      _stateCode = nextState;
      _city = null;
      _cities = const <UserDriverCityOption>[];
      _citiesLoadFailed = false;
    });

    if (nextState != null && nextState.isNotEmpty) {
      await _loadCities(_countryCode, nextState);
    }
  }

  Future<void> _loadStates(String? countryCode) async {
    final requestedCountry = countryCode?.trim().toUpperCase() ?? '';
    if (requestedCountry.isEmpty) {
      return;
    }

    setState(() {
      _isLoadingStates = true;
      _statesLoadFailed = false;
    });
    try {
      final states = await ref
          .read(userDriversControllerProvider.notifier)
          .getStates(requestedCountry);

      if (!mounted || _countryCode != requestedCountry) {
        return;
      }

      setState(() {
        _states = states;
        _isLoadingStates = false;
        _statesLoadFailed = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoadingStates = false;
        _statesLoadFailed = true;
      });
      ToastHelper.showError('Unable to load states.', context: context);
    }
  }

  Future<void> _loadCities(String? countryCode, String? stateCode) async {
    final requestedCountry = countryCode?.trim().toUpperCase() ?? '';
    final requestedState = stateCode?.trim().toUpperCase() ?? '';
    if (requestedCountry.isEmpty || requestedState.isEmpty) {
      return;
    }

    setState(() {
      _isLoadingCities = true;
      _citiesLoadFailed = false;
    });
    try {
      final cities = await ref
          .read(userDriversControllerProvider.notifier)
          .getCities(requestedCountry, requestedState);

      if (!mounted ||
          _countryCode != requestedCountry ||
          (_stateCode ?? '') != requestedState) {
        return;
      }

      setState(() {
        _cities = cities;
        _isLoadingCities = false;
        _citiesLoadFailed = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoadingCities = false;
        _citiesLoadFailed = true;
      });
      ToastHelper.showError('Unable to load cities.', context: context);
    }
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final normalized = normalizePhoneParts(
      dialCode: _mobilePrefix,
      mobile: _mobileController.text,
    );

    final request = UpdateUserDriverRequest(
      name: _nameController.text.trim(),
      mobilePrefix: normalized.dialCode,
      mobile: normalized.nationalNumber,
      email: _optionalValue(_emailController.text),
      username: _usernameController.text.trim(),
      password: _optionalValue(_passwordController.text),
      countryCode: _countryCode.trim(),
      stateCode: _optionalValue(_stateCode),
      city: _optionalValue(_city),
      address: _optionalValue(_addressController.text),
      pincode: _optionalValue(_pincodeController.text),
    );

    final ok = await ref.read(widget.provider.notifier).updateDriver(request);
    if (!mounted) {
      return;
    }

    if (ok) {
      ToastHelper.showSuccess('Driver updated.', context: context);
      Navigator.of(context).pop(true);
      return;
    }

    ToastHelper.showError(
      ref.read(widget.provider).errorMessage ?? 'Unable to update driver.',
      context: context,
    );
  }

  String? _optionalPasswordValidator(String? value) {
    final normalized = value?.trim() ?? '';
    if (normalized.isEmpty) {
      return null;
    }
    if (normalized.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _optionalEmailValidator(String? value) {
    final normalized = value?.trim() ?? '';
    if (normalized.isEmpty) {
      return null;
    }

    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(normalized)) {
      return 'Enter a valid email address';
    }

    return null;
  }

  String? _requiredDropdown(String? value) {
    final normalized = value?.trim() ?? '';
    if (normalized.isEmpty) {
      return 'Required';
    }
    return null;
  }

  String? _optionalValue(String? value) {
    final normalized = value?.trim();
    if (normalized == null || normalized.isEmpty) {
      return null;
    }
    return normalized;
  }
}

class _RetryRow extends StatelessWidget {
  const _RetryRow({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: OpenVtsSpacing.xs),
      child: Row(
        children: [
          const Icon(Icons.error_outline, size: 14, color: OpenVtsColors.error),
          const SizedBox(width: OpenVtsSpacing.xs),
          Expanded(
            child: Text(
              message,
              style:
                  OpenVtsTypography.meta.copyWith(color: OpenVtsColors.error),
            ),
          ),
          GestureDetector(
            onTap: onRetry,
            child: Text(
              'Retry',
              style: OpenVtsTypography.meta.copyWith(
                color: OpenVtsColors.info,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
