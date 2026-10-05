import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/theme/open_vts_colors.dart';
import '../../../../../../core/theme/open_vts_spacing.dart';
import '../../../../../../core/theme/open_vts_typography.dart';
import '../../../../../../core/utils/validators.dart';
import '../../../../../../shared/helpers/mobile_text.dart';
import '../../../../../../shared/helpers/phone_helper.dart';
import '../../../../../../shared/helpers/toast_helper.dart';
import '../../../../../../shared/helpers/validation_localizations.dart';
import '../../../../../../shared/widgets/open_vts_button.dart';
import '../../../../../../shared/widgets/open_vts_searchable_dropdown.dart';
import '../../../../../../shared/widgets/open_vts_text_field.dart';
import '../../../../controllers/user_providers.dart';
import '../../../../models/user_driver_model.dart';

class UserDriverCreateSheet extends ConsumerStatefulWidget {
  const UserDriverCreateSheet({required this.onSubmit, super.key});

  final Future<UserDriver?> Function(CreateUserDriverRequest request) onSubmit;

  @override
  ConsumerState<UserDriverCreateSheet> createState() =>
      _UserDriverCreateSheetState();
}

class _UserDriverCreateSheetState extends ConsumerState<UserDriverCreateSheet> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _pincodeController = TextEditingController();

  var _mobilePrefixes = const <UserDriverMobilePrefixOption>[];
  var _countries = const <UserDriverCountryOption>[];
  var _states = const <UserDriverStateOption>[];
  var _cities = const <UserDriverCityOption>[];

  String? _mobilePrefix;
  String? _countryCode;
  String? _stateCode;
  String? _city;

  var _isLoadingReferences = true;
  var _isLoadingStates = false;
  var _isLoadingCities = false;
  var _statesLoadFailed = false;
  var _citiesLoadFailed = false;
  var _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _loadReferenceData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSubmitting = ref.watch(
      userDriversControllerProvider.select((state) => state.isCreating),
    );
    final viewInsets = MediaQuery.of(context).viewInsets;
    final maxHeight = MediaQuery.of(context).size.height * 0.92;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: viewInsets.bottom),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: Material(
          color: Theme.of(context).colorScheme.surface,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    controller: PrimaryScrollController.maybeOf(context),
                    padding: const EdgeInsets.fromLTRB(
                      OpenVtsSpacing.md,
                      OpenVtsSpacing.md,
                      OpenVtsSpacing.md,
                      OpenVtsSpacing.lg,
                    ),
                    children: [
                      if (_isLoadingReferences) ...[
                        const LinearProgressIndicator(minHeight: 2),
                        const SizedBox(height: OpenVtsSpacing.md),
                      ],
                      _SectionHeader(
                        title: context.mobileText('Identity'),
                        subtitle: context.mobileText(
                          'Basic account credentials for driver login.',
                        ),
                      ),
                      const SizedBox(height: OpenVtsSpacing.sm),
                      OpenVtsTextField(
                        label: context.mobileText('Name'),
                        controller: _nameController,
                        textInputAction: TextInputAction.next,
                        prefixIcon: Icons.person_outline_rounded,
                        validator: _nameValidator,
                      ),
                      const SizedBox(height: OpenVtsSpacing.sm),
                      OpenVtsTextField(
                        label: context.mobileText('Username'),
                        controller: _usernameController,
                        textInputAction: TextInputAction.next,
                        prefixIcon: Icons.alternate_email_rounded,
                        validator: _usernameValidator,
                      ),
                      const SizedBox(height: OpenVtsSpacing.sm),
                      OpenVtsTextField(
                        label: context.mobileText('Password'),
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        textInputAction: TextInputAction.next,
                        prefixIcon: Icons.lock_outline_rounded,
                        suffixIcon: IconButton(
                          tooltip: _obscurePassword
                              ? context.mobileText('Show password')
                              : context.mobileText('Hide password'),
                          onPressed: () {
                            setState(
                              () => _obscurePassword = !_obscurePassword,
                            );
                          },
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            size: 18,
                          ),
                        ),
                        validator: _passwordValidator,
                      ),
                      const SizedBox(height: OpenVtsSpacing.lg),
                      _SectionHeader(
                        title: context.mobileText('Contact'),
                        subtitle: context.mobileText(
                          'Mobile and email used for communication.',
                        ),
                      ),
                      const SizedBox(height: OpenVtsSpacing.sm),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 140,
                            child: OpenVtsSearchableDropdown<String>(
                              label: context.mobileText('Prefix'),
                              options: _mobilePrefixSearchOptions,
                              value: _mobilePrefix,
                              hintText: '+91',
                              searchHintText: 'Search code or country',
                              leadingIcon: Icons.phone_android_rounded,
                              isLoading: _isLoadingReferences,
                              enabled: !_isLoadingReferences,
                              required: true,
                              validator: (_) =>
                                  _requiredDropdown(_mobilePrefix),
                              onChanged: (value) {
                                setState(() => _mobilePrefix = value);
                              },
                            ),
                          ),
                          const SizedBox(width: OpenVtsSpacing.sm),
                          Expanded(
                            child: OpenVtsTextField(
                              label: context.mobileText('Mobile'),
                              controller: _mobileController,
                              keyboardType: TextInputType.phone,
                              textInputAction: TextInputAction.next,
                              prefixIcon: Icons.phone_rounded,
                              validator: _mobileValidator,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: OpenVtsSpacing.sm),
                      OpenVtsTextField(
                        label: context.mobileText('Email (optional)'),
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        prefixIcon: Icons.mail_outline_rounded,
                        validator: _optionalEmailValidator,
                      ),
                      const SizedBox(height: OpenVtsSpacing.lg),
                      _SectionHeader(
                        title: context.mobileText('Location'),
                        subtitle: context.mobileText(
                          'Address and geography details.',
                        ),
                      ),
                      const SizedBox(height: OpenVtsSpacing.sm),
                      OpenVtsSearchableDropdown<String>(
                        label: context.mobileText('Country'),
                        options: _countrySearchOptions,
                        value: _countryCode,
                        hintText: context.mobileText('Select country'),
                        searchHintText: 'Search country name or code',
                        leadingIcon: Icons.public_rounded,
                        isLoading: _isLoadingReferences,
                        enabled: !_isLoadingReferences,
                        required: true,
                        validator: (_) => _requiredDropdown(_countryCode),
                        onChanged: (value) => _onCountryChanged(value),
                      ),
                      const SizedBox(height: OpenVtsSpacing.sm),
                      OpenVtsSearchableDropdown<String>(
                        label: context.mobileText('State (optional)'),
                        options: _stateSearchOptions,
                        value: _stateCode,
                        hintText: _countryCode == null
                            ? context.mobileText('Select country first')
                            : context.mobileText('Select state'),
                        searchHintText: 'Search state name or code',
                        emptyMessage: context.mobileText(
                          'No states available for this country',
                        ),
                        leadingIcon: Icons.map_outlined,
                        isLoading: _isLoadingStates,
                        enabled:
                            _countryCode != null &&
                            !_isLoadingStates &&
                            !_statesLoadFailed,
                        onChanged: (value) => _onStateChanged(value),
                      ),
                      if (_statesLoadFailed && _countryCode != null)
                        _RetryRow(
                          message: context.mobileText('Failed to load states'),
                          onRetry: () => _loadStates(_countryCode),
                        ),
                      const SizedBox(height: OpenVtsSpacing.sm),
                      OpenVtsSearchableDropdown<String>(
                        label: context.mobileText('City (optional)'),
                        options: _citySearchOptions,
                        value: _city,
                        hintText: _stateCode == null
                            ? context.mobileText('Select state first')
                            : context.mobileText('Select city'),
                        searchHintText: 'Search city',
                        emptyMessage: context.mobileText(
                          'No cities available for this state',
                        ),
                        leadingIcon: Icons.location_city_rounded,
                        isLoading: _isLoadingCities,
                        enabled:
                            _stateCode != null &&
                            !_isLoadingCities &&
                            !_citiesLoadFailed,
                        onChanged: (value) => setState(() => _city = value),
                      ),
                      if (_citiesLoadFailed && _stateCode != null)
                        _RetryRow(
                          message: context.mobileText('Failed to load cities'),
                          onRetry: () => _loadCities(_countryCode, _stateCode),
                        ),
                      const SizedBox(height: OpenVtsSpacing.sm),
                      OpenVtsTextField(
                        label: context.mobileText('Address (optional)'),
                        controller: _addressController,
                        textInputAction: TextInputAction.next,
                        prefixIcon: Icons.place_outlined,
                        maxLines: 2,
                      ),
                      const SizedBox(height: OpenVtsSpacing.sm),
                      Text(
                        context.mobileText('Pincode (optional)'),
                        style: OpenVtsTypography.label,
                      ),
                      const SizedBox(height: OpenVtsSpacing.xs),
                      TextFormField(
                        controller: _pincodeController,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: context.localizedValidator(_pincodeValidator),
                        decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.pin_drop_outlined,
                            size: 20,
                            color: OpenVtsColors.textSecondary,
                          ),
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
                            height: 40,
                            variant: OpenVtsButtonVariant.secondary,
                            onPressed: isSubmitting
                                ? null
                                : () => Navigator.of(context).pop(),
                          ),
                        ),
                        const SizedBox(width: OpenVtsSpacing.sm),
                        Expanded(
                          child: OpenVtsButton(
                            label: context.mobileText('Create Driver'),
                            height: 40,
                            trailingIcon: Icons.person_add_alt_1_rounded,
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
          ),
        ),
      ),
    );
  }

  List<OpenVtsDropdownOption<String>> get _mobilePrefixSearchOptions {
    return _mobilePrefixes
        .map(
          (item) => OpenVtsDropdownOption<String>(
            value: item.value,
            label: item.value,
            subtitle: item.countryCode.isNotEmpty ? item.countryCode : null,
            searchText: '${item.value} ${item.countryCode} ${item.label}',
          ),
        )
        .toList(growable: false);
  }

  List<OpenVtsDropdownOption<String>> get _countrySearchOptions {
    return _countries
        .map(
          (item) => OpenVtsDropdownOption<String>(
            value: item.value,
            label: item.label,
            searchText: '${item.value} ${item.label}',
          ),
        )
        .toList(growable: false);
  }

  List<OpenVtsDropdownOption<String>> get _stateSearchOptions {
    return _states
        .map(
          (item) => OpenVtsDropdownOption<String>(
            value: item.value,
            label: item.label,
            searchText: '${item.value} ${item.label}',
          ),
        )
        .toList(growable: false);
  }

  List<OpenVtsDropdownOption<String>> get _citySearchOptions {
    return _cities
        .map(
          (item) => OpenVtsDropdownOption<String>(
            value: item.value,
            label: item.label,
            searchText: item.label,
          ),
        )
        .toList(growable: false);
  }

  Future<void> _loadReferenceData() async {
    try {
      final controller = ref.read(userDriversControllerProvider.notifier);
      final countriesFuture = controller.getCountries();
      final prefixesFuture = controller.getMobilePrefixes();

      final countries = await countriesFuture;
      final prefixes = await prefixesFuture;

      if (!mounted) {
        return;
      }

      setState(() {
        _countries = countries;
        _mobilePrefixes = prefixes;
        _isLoadingReferences = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() => _isLoadingReferences = false);
      ToastHelper.showError(
        context.mobileText('Unable to load form options.'),
        context: context,
      );
    }
  }

  Future<void> _onCountryChanged(String? value) async {
    if (value == _countryCode) {
      return;
    }

    setState(() {
      _countryCode = value;
      _stateCode = null;
      _city = null;
      _states = const <UserDriverStateOption>[];
      _cities = const <UserDriverCityOption>[];
      _statesLoadFailed = false;
      _citiesLoadFailed = false;
    });

    await _loadStates(value);
  }

  Future<void> _onStateChanged(String? value) async {
    if (value == _stateCode) {
      return;
    }

    setState(() {
      _stateCode = value;
      _city = null;
      _cities = const <UserDriverCityOption>[];
      _citiesLoadFailed = false;
    });

    await _loadCities(_countryCode, value);
  }

  Future<void> _loadStates(String? countryCode) async {
    final requestedCountry = countryCode?.trim().toUpperCase();
    if (requestedCountry == null || requestedCountry.isEmpty) {
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
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoadingStates = false;
        _statesLoadFailed = true;
      });
      ToastHelper.showError(
        context.mobileText('Unable to load states.'),
        context: context,
      );
    }
  }

  Future<void> _loadCities(String? countryCode, String? stateCode) async {
    final requestedCountry = countryCode?.trim().toUpperCase();
    final requestedState = stateCode?.trim().toUpperCase();
    if (requestedCountry == null ||
        requestedCountry.isEmpty ||
        requestedState == null ||
        requestedState.isEmpty) {
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
          _stateCode != requestedState) {
        return;
      }

      setState(() {
        _cities = cities;
        _isLoadingCities = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoadingCities = false;
        _citiesLoadFailed = true;
      });
      ToastHelper.showError(
        context.mobileText('Unable to load cities.'),
        context: context,
      );
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final normalized = normalizePhoneParts(
      dialCode: _mobilePrefix ?? '',
      mobile: _mobileController.text,
    );

    final request = CreateUserDriverRequest(
      name: _nameController.text.trim(),
      mobilePrefix: normalized.dialCode,
      mobile: normalized.nationalNumber,
      email: _optionalValue(_emailController.text),
      username: _usernameController.text.trim(),
      password: _passwordController.text,
      countryCode: (_countryCode ?? '').trim(),
      stateCode: _optionalValue(_stateCode),
      city: _optionalValue(_city),
      address: _optionalValue(_addressController.text),
      pincode: _optionalValue(_pincodeController.text),
    );

    final created = await widget.onSubmit(request);
    if (!mounted) {
      return;
    }

    if (created == null) {
      final message =
          ref.read(userDriversControllerProvider).errorMessage ??
          'Unable to create driver.';
      ToastHelper.showError(message, context: context);
      return;
    }

    Navigator.of(context).pop(created);
  }

  String? _nameValidator(String? value) {
    final normalized = value?.trim() ?? '';
    if (normalized.isEmpty) {
      return 'Name is required';
    }
    if (normalized.length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  String? _usernameValidator(String? value) {
    final normalized = value?.trim() ?? '';
    if (!Validators.isPrintableAscii(normalized)) {
      return 'Username must contain ASCII characters only';
    }
    if (normalized.isEmpty) {
      return 'Username is required';
    }
    if (normalized.length < 3) {
      return 'Username must be at least 3 characters';
    }
    return null;
  }

  String? _passwordValidator(String? value) {
    final normalized = value ?? '';
    if (!Validators.isPrintableAscii(normalized)) {
      return 'Password must contain ASCII characters only';
    }
    if (normalized.length > 100) {
      return 'Password must be 100 characters or fewer';
    }
    if (normalized.trim().isEmpty) {
      return 'Password is required';
    }
    if (normalized.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _mobileValidator(String? value) {
    final normalized = value?.trim() ?? '';
    if (normalized.isEmpty) {
      return 'Mobile number is required';
    }

    final digitsOnly = RegExp(r'^\d{7,15}$');
    if (!digitsOnly.hasMatch(normalized)) {
      return 'Enter 7 to 15 digits';
    }

    return null;
  }

  String? _optionalEmailValidator(String? value) {
    final normalized = value?.trim() ?? '';
    if (!Validators.isPrintableAscii(normalized)) {
      return 'Email must contain ASCII characters only';
    }
    if (normalized.isEmpty) {
      return null;
    }

    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(normalized)) {
      return 'Enter a valid email address';
    }

    return null;
  }

  String? _pincodeValidator(String? value) {
    final normalized = value?.trim() ?? '';
    if (normalized.isNotEmpty && normalized.length > 10) {
      return 'Use 10 digits or fewer';
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

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: OpenVtsTypography.label.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: OpenVtsTypography.meta.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
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
              style: OpenVtsTypography.meta.copyWith(
                color: OpenVtsColors.error,
              ),
            ),
          ),
          GestureDetector(
            onTap: onRetry,
            child: Text(
              context.mobileText('Retry'),
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
