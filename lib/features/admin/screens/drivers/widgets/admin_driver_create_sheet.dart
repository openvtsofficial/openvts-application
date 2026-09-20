import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/open_vts_spacing.dart';
import '../../../../../core/utils/validators.dart';
import '../../../../../shared/helpers/toast_helper.dart';
import '../../../../../shared/widgets/open_vts_bottom_sheet.dart';
import '../../../../../shared/widgets/open_vts_button.dart';
import '../../../../../shared/widgets/open_vts_searchable_dropdown.dart';
import '../../../../../shared/widgets/open_vts_text_field.dart';
import '../../../controllers/admin_drivers_controller.dart';
import '../../../controllers/admin_providers.dart';
import '../../../models/admin_drivers_model.dart';
import '../../../models/admin_drivers_state.dart';
import '../../../models/admin_users_model.dart';
import '../../users/widgets/admin_user_form_fields.dart';

Future<void> showDriverCreateSheet({
  required BuildContext context,
  required AutoDisposeStateNotifierProvider<AdminDriversController,
          AdminDriversState>
      provider,
}) {
  return OpenVtsBottomSheet.show<void>(
    context: context,
    title: 'Add Driver',
    initialChildSize: 0.9,
    minChildSize: 0.5,
    maxChildSize: 0.96,
    child: _DriverCreateSheet(provider: provider),
  );
}

class _DriverCreateSheet extends ConsumerStatefulWidget {
  const _DriverCreateSheet({required this.provider});

  final AutoDisposeStateNotifierProvider<AdminDriversController,
      AdminDriversState> provider;

  @override
  ConsumerState<_DriverCreateSheet> createState() => _DriverCreateSheetState();
}

class _DriverCreateSheetState extends ConsumerState<_DriverCreateSheet> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _mobile = TextEditingController();
  final _email = TextEditingController();
  final _username = TextEditingController();
  final _password = TextEditingController();
  final _address = TextEditingController();
  final _pincode = TextEditingController();

  String? _mobilePrefix = '+91';
  String? _countryCode;
  String? _stateCode;
  String? _cityValue;
  bool _obscurePassword = true;
  bool _loadingUsers = true;
  bool _loadingReferences = true;
  bool _loadingStates = false;
  bool _loadingCities = false;

  var _primaryUsers = const <AdminDriverListItem>[];
  var _mobilePrefixes = const <AdminUserMobilePrefixOption>[];
  var _countries = const <AdminUserCountryOption>[];
  var _states = const <AdminUserStateOption>[];
  var _cities = const <AdminUserCityOption>[];
  String? _primaryUserId;

  @override
  void initState() {
    super.initState();
    _loadPrimaryUsers();
    _loadReferenceData();
  }

  @override
  void dispose() {
    _name.dispose();
    _mobile.dispose();
    _email.dispose();
    _username.dispose();
    _password.dispose();
    _address.dispose();
    _pincode.dispose();
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
    final controller = ref.read(widget.provider.notifier);

    return Form(
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
                if (_loadingUsers) ...[
                  const LinearProgressIndicator(minHeight: 2),
                  const SizedBox(height: OpenVtsSpacing.md),
                ],
                AdminDriverPrimaryUserDropdown(
                  value: _primaryUserId,
                  users: _primaryUsers,
                  isLoading: _loadingUsers,
                  onChanged: (value) => setState(() => _primaryUserId = value),
                ),
                const SizedBox(height: OpenVtsSpacing.sm),
                OpenVtsTextField(
                  label: 'Name',
                  controller: _name,
                  prefixIcon: Icons.person_outline_rounded,
                  validator: (value) => Validators.driverName(value),
                ),
                const SizedBox(height: OpenVtsSpacing.sm),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final availableWidth = constraints.maxWidth;
                    final isTablet = availableWidth >= 600;

                    final prefixDropdown = AdminUserDropdownField(
                      label: 'Mobile Prefix',
                      value: _mobilePrefix,
                      options: _mobilePrefixOptions,
                      hintText: '+91',
                      prefixIcon: Icons.phone_android_rounded,
                      isLoading: _loadingReferences,
                      searchable: true,
                      validator: requiredDropdown,
                      onChanged: (value) {
                        setState(() => _mobilePrefix = value);
                      },
                    );

                    final numberField = OpenVtsTextField(
                      label: 'Mobile',
                      controller: _mobile,
                      keyboardType: TextInputType.phone,
                      prefixIcon: Icons.phone_rounded,
                      validator: (value) => Validators.mobileNumber(value),
                    );

                    if (!isTablet) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          prefixDropdown,
                          const SizedBox(height: OpenVtsSpacing.sm),
                          numberField,
                        ],
                      );
                    }

                    final prefixWidth =
                        (availableWidth * 0.30).clamp(110.0, 140.0);
                    final gapWidth = OpenVtsSpacing.md;

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: prefixWidth,
                          child: prefixDropdown,
                        ),
                        SizedBox(width: gapWidth),
                        Expanded(child: numberField),
                      ],
                    );
                  },
                ),
                const SizedBox(height: OpenVtsSpacing.sm),
                OpenVtsTextField(
                  label: 'Email',
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.mail_outline_rounded,
                  validator: (value) {
                    final text = value?.trim() ?? '';
                    if (text.isEmpty) return null;
                    return Validators.email(text);
                  },
                ),
                const SizedBox(height: OpenVtsSpacing.sm),
                OpenVtsTextField(
                  label: 'Username',
                  controller: _username,
                  prefixIcon: Icons.alternate_email_rounded,
                  validator: (value) => Validators.driverUsername(value),
                ),
                const SizedBox(height: OpenVtsSpacing.sm),
                OpenVtsTextField(
                  label: 'Password',
                  controller: _password,
                  obscureText: _obscurePassword,
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
                      size: 18,
                    ),
                  ),
                  validator: (value) {
                    final text = value?.trim() ?? '';
                    if (text.isEmpty) return 'Password is required';
                    if (text.length < 8) return 'Minimum 8 characters';
                    return null;
                  },
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
                  label: 'Address',
                  controller: _address,
                  prefixIcon: Icons.place_outlined,
                  maxLines: 2,
                  validator: (value) => Validators.driverAddressOptional(value),
                ),
                const SizedBox(height: OpenVtsSpacing.sm),
                OpenVtsTextField(
                  label: 'Pincode',
                  controller: _pincode,
                  keyboardType: TextInputType.number,
                  prefixIcon: Icons.pin_drop_outlined,
                  validator: (value) => Validators.driverPincodeOptional(value),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                OpenVtsSpacing.md,
                OpenVtsSpacing.md,
                OpenVtsSpacing.md,
                OpenVtsSpacing.md + MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OpenVtsButton(
                      label: 'Cancel',
                      variant: OpenVtsButtonVariant.secondary,
                      onPressed: state.isCreating
                          ? null
                          : () => Navigator.of(context).pop(),
                    ),
                  ),
                  const SizedBox(width: OpenVtsSpacing.sm),
                  Expanded(
                    child: OpenVtsButton(
                      label: 'Create driver',
                      isLoading: state.isCreating,
                      trailingIcon: Icons.person_add_alt_1_rounded,
                      onPressed: state.isCreating
                          ? null
                          : () => _submit(context, controller),
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

  Future<void> _loadPrimaryUsers() async {
    try {
      final users = await ref
          .read(widget.provider.notifier)
          .fetchUsersForPrimarySelection();
      if (!mounted) return;
      setState(() {
        _primaryUsers = users;
        _primaryUserId = users.isNotEmpty ? users.first.id : null;
      });
    } catch (_) {
      if (mounted) {
        ToastHelper.showError('Unable to load users.', context: context);
      }
    } finally {
      if (mounted) setState(() => _loadingUsers = false);
    }
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

  Future<void> _submit(
    BuildContext context,
    AdminDriversController controller,
  ) async {
    if (!_formKey.currentState!.validate()) return;

    final request = AdminDriverCreateRequest(
      primaryUserid: _primaryUserId ?? '',
      name: _name.text.trim(),
      mobilePrefix: _mobilePrefix ?? '',
      mobile: _mobile.text.trim(),
      email: _email.text.trim(),
      username: _username.text.trim(),
      password: _password.text,
      countryCode: (_countryCode ?? '').toUpperCase(),
      stateCode: (_stateCode ?? '').toUpperCase(),
      city: _cityValue ?? '',
      address: _address.text.trim(),
      pincode: _pincode.text.trim(),
    );

    // Debug logging (sensitive data not logged)
    if (kDebugMode) {
      final payload = request.toJson();
      final keys = payload.keys.toList()..sort();
      debugPrint('📤 Driver Create Payload Keys: $keys');
      debugPrint('📤 Driver Create Fields:');
      debugPrint('   name: ${payload['name']}');
      debugPrint('   username: ${payload['username']}');
      debugPrint('   mobilePrefix: ${payload['mobilePrefix']}');
      debugPrint('   countryCode: ${payload['countryCode']}');
      debugPrint('   stateCode: ${payload['stateCode']}');
      debugPrint('   city: ${payload['city']}');
      debugPrint('   email: ${payload['email']}');
      debugPrint('   address: ${payload['address']}');
      debugPrint('   pincode: ${payload['pincode']}');
      debugPrint('   primaryUserid: ${payload['primaryUserid']}');
      debugPrint('   (password and mobile omitted from log)');
    }

    try {
      await controller.createDriver(request);
      if (!context.mounted) return;
      ToastHelper.showSuccess('Driver created.', context: context);
      Navigator.of(context).pop();
    } catch (_) {
      if (!context.mounted) return;
      ToastHelper.showError(
        ref.read(widget.provider).errorMessage ?? 'Unable to create driver.',
        context: context,
      );
    }
  }
}

class AdminDriverPrimaryUserDropdown extends StatelessWidget {
  const AdminDriverPrimaryUserDropdown({
    super.key,
    required this.value,
    required this.users,
    required this.isLoading,
    required this.onChanged,
  });

  final String? value;
  final List<AdminDriverListItem> users;
  final bool isLoading;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return OpenVtsSearchableDropdown<String>(
      label: 'Primary User',
      hintText: 'Select primary user',
      leadingIcon: Icons.person_search_outlined,
      value: value,
      options: users
          .map(
            (user) => OpenVtsDropdownOption<String>(
              value: user.id,
              label: _primaryUserName(user),
              subtitle: _primaryUserSubtitle(user),
              searchText: [
                user.firstName,
                user.username,
                user.email,
                user.phone,
                user.mobile,
                user.id,
              ].join(' '),
            ),
          )
          .toList(growable: false),
      isLoading: isLoading,
      required: true,
      validator: (selected) => Validators.required(
        selected,
        fieldName: 'Primary user',
      ),
      onChanged: onChanged,
    );
  }

  String _primaryUserName(AdminDriverListItem user) {
    final name = user.firstName.trim();
    if (name.isNotEmpty && name != '-') return name;
    final username = user.username.trim();
    return username.isNotEmpty && username != '-' ? username : 'User';
  }

  String? _primaryUserSubtitle(AdminDriverListItem user) {
    for (final value in [user.email, user.phone, user.mobile]) {
      final normalized = value.trim();
      if (normalized.isNotEmpty && normalized != '-') return normalized;
    }
    return null;
  }
}
