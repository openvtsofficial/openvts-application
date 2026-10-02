import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/providers/core_providers.dart';
import '../../../../../core/theme/open_vts_colors.dart';
import '../../../../../core/theme/open_vts_radius.dart';
import '../../../../../core/theme/open_vts_spacing.dart';
import '../../../../../core/theme/open_vts_typography.dart';
import '../../../../../core/utils/validators.dart';
import '../../../../../shared/helpers/toast_helper.dart';
import '../../../../../shared/widgets/open_vts_button.dart';
import '../../../../../shared/widgets/open_vts_card.dart';
import '../../../../../shared/widgets/open_vts_loader.dart';
import '../../../../../shared/widgets/open_vts_role_home.dart';
import '../../../../../shared/widgets/open_vts_searchable_dropdown.dart';
import '../../../../../shared/widgets/open_vts_text_field.dart';
import '../../../../auth/controllers/auth_controller.dart';
import '../../../controllers/admin_providers.dart';
import '../../../controllers/admin_settings_controller.dart';
import '../../../models/admin_settings_model.dart';
import '../../../models/admin_settings_state.dart';
import '../../../models/admin_users_model.dart';
import '../../../utils/location_label_resolver.dart';

const _allowedImageExts = ['png', 'jpg', 'jpeg', 'webp'];
const int _maxImageBytes = 2 * 1024 * 1024;

String _normalizeHexColor(dynamic value) {
  if (value == null || (value is String && value.trim().isEmpty)) return '';
  var hex = value.toString().trim();

  // Handle color names
  final colorMap = {
    'black': '#111827',
    'blue': '#2563EB',
    'green': '#16A34A',
    'red': '#DC2626',
    'orange': '#EA580C',
    'purple': '#7C3AED',
  };
  final normalized = hex.toLowerCase();
  if (colorMap.containsKey(normalized)) {
    return colorMap[normalized]!;
  }

  if (hex.startsWith('0xFF') || hex.startsWith('0xff')) {
    hex = hex.substring(4);
  } else if (hex.startsWith('0x')) {
    hex = hex.substring(2);
    if (hex.length == 8) hex = hex.substring(2);
  }
  if (!hex.startsWith('#')) hex = '#$hex';
  return hex.toUpperCase();
}

class ProfileSettingsSection extends ConsumerStatefulWidget {
  const ProfileSettingsSection({super.key, required this.state});

  final AdminSettingsState state;

  @override
  ConsumerState<ProfileSettingsSection> createState() =>
      _ProfileSettingsSectionState();
}

class _ProfileSettingsSectionState
    extends ConsumerState<ProfileSettingsSection> {
  final _imagePicker = ImagePicker();
  bool _subscriptionRequested = false;
  String? _photoCacheBust;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _maybeLoadSubscription());
  }

  @override
  void didUpdateWidget(covariant ProfileSettingsSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _maybeLoadSubscription();
    });
  }

  void _maybeLoadSubscription() {
    if (_subscriptionRequested) return;
    final profile = widget.state.profile;
    if (profile == null) return;
    _subscriptionRequested = true;
    unawaited(
      ref
          .read(adminSettingsControllerProvider.notifier)
          .loadEmailSubscription(),
    );
  }

  AdminSettingsController get _controller =>
      ref.read(adminSettingsControllerProvider.notifier);

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final profile = state.profile;

    if (state.isLoadingProfile && profile == null) {
      return const OpenVtsCard(
        padding: EdgeInsets.symmetric(vertical: OpenVtsSpacing.lg),
        child: Center(child: OpenVtsLoader()),
      );
    }

    if (profile == null) {
      return OpenVtsCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              state.sectionErrorMessage ?? 'No profile available.',
              style: TextStyle(
                fontFamily: OpenVtsTypography.primaryFontFamily,
                fontSize: 12.5,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: OpenVtsSpacing.sm),
            OpenVtsButton(
              label: 'Retry',
              variant: OpenVtsButtonVariant.secondary,
              height: 38,
              onPressed: _controller.loadProfile,
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ProfileHeaderCard(
          profile: profile,
          isUploading: state.isUploadingProfilePhoto,
          cacheBust: _photoCacheBust,
          onPickPhoto: _pickPhoto,
        ),
        const SizedBox(height: OpenVtsSpacing.sm),
        _VerificationCard(
          profile: profile,
          isRequestingEmailOtp: state.isRequestingEmailOtp,
          isRequestingWhatsAppOtp: state.isRequestingWhatsAppOtp,
          onVerifyEmail: () => _openOtpSheet(_OtpChannel.email),
          onVerifyWhatsApp: () => _openOtpSheet(_OtpChannel.whatsapp),
        ),
        const SizedBox(height: OpenVtsSpacing.sm),
        AdminProfileAddressCard(profile: profile),
        const SizedBox(height: OpenVtsSpacing.sm),
        if (profile.company != null)
          _CompanyCard(
            company: profile.company,
            onEditCompany: _openEditCompanySheet,
          ),
        if (profile.company != null) const SizedBox(height: OpenVtsSpacing.sm),
        _ActionsCard(
          onEditProfile: _openEditProfileSheet,
          onChangePassword: _openChangePasswordSheet,
        ),
        const SizedBox(height: OpenVtsSpacing.sm),
        _EmailSubscriptionCard(
          subscribed: state.emailSubscribed,
          isLoading: state.isLoadingEmailSubscription,
          isSubscribing: state.isSubscribingEmail,
          onSubscribe: _handleSubscribe,
          onRefresh: () => unawaited(_controller.loadEmailSubscription()),
        ),
        const SizedBox(height: OpenVtsSpacing.sm),
        _LogoutCard(onLogout: _handleLogout),
      ],
    );
  }

  // ---------- AuthController sync ----------

  Future<void> _syncCurrentUser() async {
    final profile = ref.read(adminSettingsControllerProvider).profile;
    if (profile == null) return;
    final current = ref.read(authControllerProvider).user;
    if (current == null) return;

    final address = profile.address;
    final updated = current.copyWith(
      name: profile.name ?? current.name,
      email: profile.email ?? current.email,
      username: profile.username ?? current.username,
      profileUrl: profile.profileUrl ?? current.profileUrl,
      mobilePrefix: profile.mobilePrefix ?? current.mobilePrefix,
      mobileNumber: profile.mobileNumber ?? current.mobileNumber,
      addressLine: address?.addressLine ?? current.addressLine,
      countryCode: address?.countryCode ?? current.countryCode,
      stateCode: address?.stateCode ?? current.stateCode,
      cityName: address?.cityName ?? current.cityName,
      pincode: address?.pincode ?? current.pincode,
    );
    await ref.read(authControllerProvider.notifier).replaceCurrentUser(updated);
  }

  // ---------- Photo upload ----------

  Future<void> _pickPhoto() async {
    if (widget.state.isUploadingProfilePhoto) return;

    final profile = widget.state.profile;
    final userId = profile?.uid?.toString();
    if (userId == null || userId.isEmpty) {
      ToastHelper.showError('Profile not loaded yet.');
      return;
    }

    XFile? picked;
    try {
      picked = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1600,
        imageQuality: 90,
      );
    } catch (_) {
      ToastHelper.showError('Unable to open image picker.');
      return;
    }
    if (picked == null) return;

    final ext = picked.name.split('.').last.toLowerCase();
    if (!_allowedImageExts.contains(ext)) {
      ToastHelper.showError(
        'Unsupported format. Use PNG, JPG, JPEG or WEBP.',
      );
      return;
    }

    final Uint8List bytes;
    try {
      bytes = await picked.readAsBytes();
    } catch (_) {
      ToastHelper.showError('Unable to read the selected image.');
      return;
    }
    if (bytes.isEmpty) {
      ToastHelper.showError('Selected file is empty.');
      return;
    }
    if (bytes.length > _maxImageBytes) {
      ToastHelper.showError('Image too large. Max 2 MB.');
      return;
    }

    final ok = await _controller.uploadProfilePhoto(
      userId: userId,
      bytes: bytes,
      fileName: picked.name,
    );
    if (!mounted) return;
    if (ok) {
      setState(() {
        _photoCacheBust = DateTime.now().millisecondsSinceEpoch.toString();
      });
      await _syncCurrentUser();
      if (!mounted) return;
      ToastHelper.showSuccess('Profile photo updated');
    } else {
      final msg =
          ref.read(adminSettingsControllerProvider).sectionErrorMessage ??
              'Unable to upload photo.';
      ToastHelper.showError(msg);
    }
  }

  // ---------- Sheets ----------

  Future<void> _openEditProfileSheet() async {
    final profile = widget.state.profile;
    if (profile == null) return;
    final saved = await _showSheet<bool>(
      child: _EditProfileSheet(profile: profile),
    );
    if (saved == true && mounted) {
      await _syncCurrentUser();
      if (!mounted) return;
      ToastHelper.showSuccess('Profile updated');
    }
  }

  Future<void> _openChangePasswordSheet() async {
    final ok = await _showSheet<bool>(child: const AdminChangePasswordSheet());
    if (ok == true && mounted) {
      ToastHelper.showSuccess('Password changed. Please sign in again.');
      await ref.read(authControllerProvider.notifier).logoutAllRoles();
    }
  }

  Future<void> _openEditCompanySheet() async {
    final profile = widget.state.profile;
    final company = profile?.company;
    if (company == null) return;
    final saved = await _showSheet<bool>(
      child: _EditCompanySheet(company: company),
    );
    if (saved == true && mounted) {
      await _syncCurrentUser();
      if (!mounted) return;
      ToastHelper.showSuccess('Company updated');
    }
  }

  Future<void> _openOtpSheet(_OtpChannel channel) async {
    final ok = await _showSheet<bool>(
      child: _OtpVerificationSheet(channel: channel),
    );
    if (ok == true && mounted) {
      ToastHelper.showSuccess(
        channel == _OtpChannel.email ? 'Email verified' : 'WhatsApp verified',
      );
    }
  }

  Future<T?> _showSheet<T>({required Widget child}) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _BottomSheetShell(child: child),
    );
  }

  Future<void> _handleSubscribe() async {
    final ok = await _controller.subscribeEmail();
    if (!mounted) return;
    if (ok) {
      ToastHelper.showSuccess('Subscribed to email updates');
    } else {
      final msg =
          ref.read(adminSettingsControllerProvider).sectionErrorMessage ??
              'Unable to subscribe.';
      ToastHelper.showError(msg);
    }
  }

  Future<void> _handleLogout() async {
    final activeRole = ref.read(authControllerProvider).activeRole;
    final loggedOut = await ref.read(authControllerProvider.notifier).logout();
    if (!mounted) return;
    final label = (loggedOut ?? activeRole)?.displayLabel;
    if (label != null) {
      ToastHelper.showInfo('Logged out from $label');
    }
  }
}

// =====================================================================
// Header card
// =====================================================================

class _ProfileHeaderCard extends ConsumerWidget {
  const _ProfileHeaderCard({
    required this.profile,
    required this.isUploading,
    required this.cacheBust,
    required this.onPickPhoto,
  });

  final AdminProfileSettings profile;
  final bool isUploading;
  final String? cacheBust;
  final VoidCallback onPickPhoto;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final baseUrl = ref.watch(apiBaseUrlProvider);
    var url = resolveProfileImageUrl(baseUrl, profile.profileUrl);
    if (url != null && cacheBust != null) {
      final sep = url.contains('?') ? '&' : '?';
      url = '$url${sep}ts=$cacheBust';
    }
    final name = (profile.name ?? '').trim();
    final username = (profile.username ?? '').trim();
    final email = (profile.email ?? '').trim();
    final mobile = [
      profile.mobilePrefix?.trim() ?? '',
      profile.mobileNumber?.trim() ?? '',
    ].where((s) => s.isNotEmpty).join(' ');

    return OpenVtsCard(
      padding: const EdgeInsets.all(OpenVtsSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _AvatarWithEdit(
                url: url,
                name: name.isNotEmpty ? name : 'S',
                isUploading: isUploading,
                onTap: onPickPhoto,
              ),
              const SizedBox(width: OpenVtsSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name.isNotEmpty ? name : 'Admin',
                      style: TextStyle(
                        fontFamily: OpenVtsTypography.primaryFontFamily,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.onSurface,
                        height: 1.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (username.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        '@$username',
                        style: TextStyle(
                          fontFamily: OpenVtsTypography.primaryFontFamily,
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          height: 1.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (email.isNotEmpty || mobile.isNotEmpty) ...[
            const SizedBox(height: OpenVtsSpacing.sm),
            if (email.isNotEmpty)
              Row(
                children: [
                  Icon(Icons.mail_outline_rounded,
                      size: 14, color: Theme.of(context).colorScheme.outline),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      email,
                      style: TextStyle(
                        fontFamily: OpenVtsTypography.primaryFontFamily,
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        height: 1.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            if (email.isNotEmpty && mobile.isNotEmpty)
              const SizedBox(height: 4),
            if (mobile.isNotEmpty)
              Row(
                children: [
                  Icon(Icons.phone_outlined,
                      size: 14, color: Theme.of(context).colorScheme.outline),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      mobile,
                      style: TextStyle(
                        fontFamily: OpenVtsTypography.primaryFontFamily,
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        height: 1.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
          ],
          if (profile.credits != null) ...[
            const SizedBox(height: OpenVtsSpacing.md),
            Divider(
                height: 1, color: Theme.of(context).colorScheme.outlineVariant),
            const SizedBox(height: OpenVtsSpacing.md),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: OpenVtsSpacing.sm,
                vertical: OpenVtsSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(OpenVtsRadius.md),
                border: Border.all(
                    color: Theme.of(context).colorScheme.outlineVariant),
              ),
              child: Row(
                children: [
                  Icon(Icons.credit_card_outlined,
                      size: 16,
                      color: Theme.of(context).colorScheme.onSurfaceVariant),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Credits',
                          style: TextStyle(
                            fontFamily: OpenVtsTypography.primaryFontFamily,
                            fontSize: 11,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          profile.credits!.toStringAsFixed(0),
                          style: TextStyle(
                            fontFamily: OpenVtsTypography.primaryFontFamily,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).colorScheme.onSurface,
                            height: 1.1,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _AvatarWithEdit extends StatelessWidget {
  const _AvatarWithEdit({
    required this.url,
    required this.name,
    required this.isUploading,
    required this.onTap,
  });

  final String? url;
  final String name;
  final bool isUploading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasUrl = (url ?? '').trim().isNotEmpty;
    final initial = name.isNotEmpty ? name[0].toUpperCase() : 'S';

    return SizedBox(
      width: 56,
      height: 56,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: isDark ? OpenVtsColors.brandInk : OpenVtsColors.white,
              borderRadius: BorderRadius.circular(OpenVtsRadius.md),
              border: isDark
                  ? null
                  : Border.all(color: OpenVtsColors.border, width: 1),
              image: hasUrl
                  ? DecorationImage(
                      image: NetworkImage(url!),
                      fit: BoxFit.cover,
                      onError: (_, __) {},
                    )
                  : null,
            ),
            alignment: Alignment.center,
            child: hasUrl
                ? null
                : Text(
                    initial,
                    style: TextStyle(
                      fontFamily: OpenVtsTypography.primaryFontFamily,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color:
                          isDark ? OpenVtsColors.white : OpenVtsColors.brandInk,
                    ),
                  ),
          ),
          if (isUploading)
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.black.withValues(alpha: 0.45)
                      : OpenVtsColors.darkTextPrimary.withValues(alpha: 0.45),
                  borderRadius: BorderRadius.circular(OpenVtsRadius.md),
                ),
                child: const Center(
                  child: SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(
                        OpenVtsColors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          Positioned(
            right: -2,
            bottom: -2,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: isUploading ? null : onTap,
                borderRadius: BorderRadius.circular(OpenVtsRadius.pill),
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                    borderRadius: BorderRadius.circular(OpenVtsRadius.pill),
                  ),
                  child: Icon(
                    Icons.camera_alt_rounded,
                    size: 12,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// Verification chips card
// =====================================================================

class _VerificationCard extends StatelessWidget {
  const _VerificationCard({
    required this.profile,
    required this.isRequestingEmailOtp,
    required this.isRequestingWhatsAppOtp,
    required this.onVerifyEmail,
    required this.onVerifyWhatsApp,
  });

  final AdminProfileSettings profile;
  final bool isRequestingEmailOtp;
  final bool isRequestingWhatsAppOtp;
  final VoidCallback onVerifyEmail;
  final VoidCallback onVerifyWhatsApp;

  @override
  Widget build(BuildContext context) {
    return OpenVtsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _VerificationRow(
            icon: Icons.mail_outline_rounded,
            label: 'Email',
            value: profile.email ?? '',
            verified: profile.isEmailVerified,
            busy: isRequestingEmailOtp,
            onVerify: onVerifyEmail,
          ),
          Divider(
            height: OpenVtsSpacing.md,
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
          _VerificationRow(
            icon: Icons.chat_outlined,
            label: 'WhatsApp',
            value: [
              profile.mobilePrefix?.trim() ?? '',
              profile.mobileNumber?.trim() ?? '',
            ].where((s) => s.isNotEmpty).join(' '),
            verified: profile.isMobileVerified,
            busy: isRequestingWhatsAppOtp,
            onVerify: onVerifyWhatsApp,
          ),
        ],
      ),
    );
  }
}

class _VerificationRow extends StatelessWidget {
  const _VerificationRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.verified,
    required this.busy,
    required this.onVerify,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool verified;
  final bool busy;
  final VoidCallback onVerify;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon,
            size: 18, color: Theme.of(context).colorScheme.onSurfaceVariant),
        const SizedBox(width: OpenVtsSpacing.xs),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontFamily: OpenVtsTypography.primaryFontFamily,
                  fontSize: 11,
                  color: Theme.of(context).colorScheme.outline,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.4,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                value.isNotEmpty ? value : '—',
                style: TextStyle(
                  fontFamily: OpenVtsTypography.primaryFontFamily,
                  fontSize: 12.5,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: OpenVtsSpacing.xs),
        if (verified)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: OpenVtsColors.success.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(OpenVtsRadius.pill),
              border: Border.all(
                color: OpenVtsColors.success.withValues(alpha: 0.4),
              ),
            ),
            child: const Text(
              'Verified',
              style: TextStyle(
                fontFamily: OpenVtsTypography.primaryFontFamily,
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
                color: OpenVtsColors.success,
              ),
            ),
          )
        else
          SizedBox(
            height: 30,
            child: Builder(
              builder: (context) {
                final isDark = Theme.of(context).brightness == Brightness.dark;
                return TextButton(
                  onPressed: busy || value.isEmpty ? null : onVerify,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    minimumSize: const Size(0, 30),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    foregroundColor:
                        isDark ? OpenVtsColors.white : Colors.black,
                    backgroundColor:
                        isDark ? OpenVtsColors.brandInk : Colors.white,
                    side: BorderSide(
                      color: isDark ? OpenVtsColors.white : Colors.black,
                      width: 1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(OpenVtsRadius.sm),
                    ),
                    textStyle: const TextStyle(
                      fontFamily: OpenVtsTypography.primaryFontFamily,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  child: busy
                      ? SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(
                              isDark ? OpenVtsColors.white : Colors.black,
                            ),
                          ),
                        )
                      : const Text('Verify'),
                );
              },
            ),
          ),
      ],
    );
  }
}

// =====================================================================
// Address card
// =====================================================================

class AdminProfileAddressCard extends ConsumerStatefulWidget {
  const AdminProfileAddressCard({
    super.key,
    required this.profile,
    this.initialCountries = const [],
    this.initialStates = const [],
    this.initialCities = const [],
    this.loadCatalogs = true,
  });

  final AdminProfileSettings profile;
  final List<AdminUserCountryOption> initialCountries;
  final List<AdminUserStateOption> initialStates;
  final List<AdminUserCityOption> initialCities;
  final bool loadCatalogs;

  @override
  ConsumerState<AdminProfileAddressCard> createState() =>
      _AdminProfileAddressCardState();
}

class _AdminProfileAddressCardState
    extends ConsumerState<AdminProfileAddressCard> {
  late List<AdminUserCountryOption> _countries;
  late List<AdminUserStateOption> _states;
  late List<AdminUserCityOption> _cities;

  @override
  void initState() {
    super.initState();
    _countries = widget.initialCountries;
    _states = widget.initialStates;
    _cities = widget.initialCities;
    if (widget.loadCatalogs) {
      unawaited(_loadLocationLabels());
    }
  }

  @override
  void didUpdateWidget(covariant AdminProfileAddressCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    final previous = oldWidget.profile.address;
    final current = widget.profile.address;
    if (previous?.countryCode != current?.countryCode ||
        previous?.stateCode != current?.stateCode ||
        previous?.cityValue != current?.cityValue) {
      if (widget.loadCatalogs) {
        unawaited(_loadLocationLabels());
      }
    }
  }

  Future<void> _loadLocationLabels() async {
    final address = widget.profile.address;
    final countryCode = address?.countryCode?.trim() ?? '';
    final stateCode = address?.stateCode?.trim() ?? '';
    final controller = ref.read(adminUsersControllerProvider.notifier);

    try {
      final countries = await controller.getCountries();
      final states = countryCode.isEmpty
          ? const <AdminUserStateOption>[]
          : await controller.getStates(countryCode);
      final cities = countryCode.isEmpty || stateCode.isEmpty
          ? const <AdminUserCityOption>[]
          : await controller.getCities(countryCode, stateCode);
      if (!mounted || widget.profile.address != address) return;
      setState(() {
        _countries = countries;
        _states = states;
        _cities = cities;
      });
    } catch (_) {
      // The synchronous resolver still supplies local country/state labels.
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = widget.profile;
    final address = profile.address;
    final addressLine = address?.addressLine ?? '';
    final countryCode = address?.countryCode ?? '';
    final stateCode = address?.stateCode ?? '';
    final country = (address?.countryName?.trim().isNotEmpty ?? false)
        ? address!.countryName!.trim()
        : LocationLabelResolver.resolveCountry(
            countryCode,
            apiOptions: _countries,
          );
    final state = (address?.stateName?.trim().isNotEmpty ?? false)
        ? address!.stateName!.trim()
        : LocationLabelResolver.resolveState(
            countryCode,
            stateCode,
            apiOptions: _states,
          );
    final explicitCity = address?.cityName ?? profile.cityName;
    final city = (explicitCity?.trim().isNotEmpty ?? false)
        ? explicitCity!.trim()
        : LocationLabelResolver.resolveCity(
            address?.cityValue ?? '',
            apiOptions: _cities,
          );
    final pincode = address?.pincode ?? '';

    final hasAddress = addressLine.trim().isNotEmpty ||
        countryCode.trim().isNotEmpty ||
        stateCode.trim().isNotEmpty ||
        city.trim().isNotEmpty ||
        pincode.trim().isNotEmpty;

    if (!hasAddress) return const SizedBox.shrink();

    return _SectionCard(
      title: 'ADDRESS',
      children: [
        if (addressLine.trim().isNotEmpty)
          _InfoRow(
            label: 'Address',
            value: addressLine,
            icon: Icons.home_outlined,
          ),
        if (countryCode.trim().isNotEmpty)
          _InfoRow(
            label: 'Country',
            value: country,
            icon: Icons.public_outlined,
          ),
        if (stateCode.trim().isNotEmpty)
          _InfoRow(
            label: 'State',
            value: state,
            icon: Icons.map_outlined,
          ),
        _InfoRow(
          label: 'City',
          value: city.trim().isNotEmpty ? city : '—',
          icon: Icons.location_city_outlined,
        ),
        if (pincode.trim().isNotEmpty)
          _InfoRow(
            label: 'Pincode',
            value: pincode,
            icon: Icons.local_post_office_outlined,
          ),
      ],
    );
  }
}

// =====================================================================
// Company card
// =====================================================================

class _CompanyCard extends StatelessWidget {
  const _CompanyCard({
    required this.company,
    required this.onEditCompany,
  });

  final AdminCompanySettings? company;
  final VoidCallback onEditCompany;

  @override
  Widget build(BuildContext context) {
    final companyName = company?.name?.trim() ?? '';
    final website = company?.websiteUrl ?? '';
    final domain = company?.customDomain ?? '';

    return _SectionCard(
      title: 'COMPANY',
      trailing: SizedBox(
        width: 32,
        height: 32,
        child: IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          icon: Icon(
            Icons.edit_outlined,
            size: 16,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          tooltip: 'Edit company',
          onPressed: onEditCompany,
        ),
      ),
      children: [
        if (companyName.isNotEmpty)
          _InfoRow(
            label: 'Company',
            value: companyName,
            icon: Icons.business_outlined,
          ),
        if (website.isNotEmpty)
          _InfoRow(
            label: 'Website',
            value: website,
            icon: Icons.language_outlined,
          ),
        if (domain.isNotEmpty)
          _InfoRow(
            label: 'Domain',
            value: domain,
            icon: Icons.dns_outlined,
          ),
      ],
    );
  }
}

// =====================================================================
// Actions card
// =====================================================================

class _ActionsCard extends StatelessWidget {
  const _ActionsCard({
    required this.onEditProfile,
    required this.onChangePassword,
  });

  final VoidCallback onEditProfile;
  final VoidCallback onChangePassword;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OpenVtsButton(
            label: 'Edit Profile',
            variant: OpenVtsButtonVariant.secondary,
            onPressed: onEditProfile,
          ),
        ),
        const SizedBox(width: OpenVtsSpacing.sm),
        Expanded(
          child: OpenVtsButton(
            label: 'Change Password',
            variant: OpenVtsButtonVariant.secondary,
            onPressed: onChangePassword,
          ),
        ),
      ],
    );
  }
}

// =====================================================================
// Section card
// =====================================================================

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.children,
    this.trailing,
  });

  final String title;
  final List<Widget> children;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return OpenVtsCard(
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
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: OpenVtsSpacing.xs),
          Divider(
              height: 1, color: Theme.of(context).colorScheme.outlineVariant),
          const SizedBox(height: OpenVtsSpacing.xs),
          ...children,
        ],
      ),
    );
  }
}

// =====================================================================
// Info row
// =====================================================================

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

// =====================================================================
// Email subscription card
// =====================================================================

class _EmailSubscriptionCard extends StatelessWidget {
  const _EmailSubscriptionCard({
    required this.subscribed,
    required this.isLoading,
    required this.isSubscribing,
    required this.onSubscribe,
    required this.onRefresh,
  });

  final bool? subscribed;
  final bool isLoading;
  final bool isSubscribing;
  final Future<void> Function() onSubscribe;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final isSubscribed = subscribed == true;
    return OpenVtsCard(
      padding: const EdgeInsets.symmetric(
        horizontal: OpenVtsSpacing.md,
        vertical: OpenVtsSpacing.sm,
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border.all(
                  color: Theme.of(context).colorScheme.outlineVariant),
              borderRadius: BorderRadius.circular(OpenVtsRadius.sm),
            ),
            child: Icon(
              Icons.notifications_none_rounded,
              size: 16,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(width: OpenVtsSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Email Subscription',
                  style: TextStyle(
                    fontFamily: OpenVtsTypography.primaryFontFamily,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  isLoading
                      ? 'Checking status…'
                      : subscribed == null
                          ? 'Status unknown'
                          : isSubscribed
                              ? 'Subscribed'
                              : 'Not subscribed',
                  style: TextStyle(
                    fontFamily: OpenVtsTypography.primaryFontFamily,
                    fontSize: 11.5,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: OpenVtsSpacing.xs),
          if (isSubscribed)
            IconButton(
              tooltip: 'Refresh',
              onPressed: isLoading ? null : onRefresh,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              visualDensity: VisualDensity.compact,
            )
          else
            SizedBox(
              height: 32,
              child: OpenVtsButton(
                label: 'Subscribe',
                variant: OpenVtsButtonVariant.secondary,
                height: 32,
                isLoading: isSubscribing,
                onPressed: () => onSubscribe(),
              ),
            ),
        ],
      ),
    );
  }
}

// =====================================================================
// Logout card
// =====================================================================

class _LogoutCard extends StatelessWidget {
  const _LogoutCard({required this.onLogout});
  final Future<void> Function() onLogout;

  @override
  Widget build(BuildContext context) {
    return OpenVtsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  border: Border.all(
                      color: Theme.of(context).colorScheme.outlineVariant),
                  borderRadius: BorderRadius.circular(OpenVtsRadius.sm),
                ),
                child: Icon(
                  Icons.logout_rounded,
                  size: 16,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(width: OpenVtsSpacing.xs),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sign out',
                      style: TextStyle(
                        fontFamily: OpenVtsTypography.primaryFontFamily,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      'End this session on this device.',
                      style: TextStyle(
                        fontFamily: OpenVtsTypography.primaryFontFamily,
                        fontSize: 11,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: OpenVtsSpacing.sm),
          OpenVtsButton(
            label: 'Logout',
            variant: OpenVtsButtonVariant.secondary,
            height: 38,
            onPressed: () => onLogout(),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// Bottom sheet shell
// =====================================================================

class _BottomSheetShell extends StatelessWidget {
  const _BottomSheetShell({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final inset = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: inset),
      child: SafeArea(
        top: false,
        child: Container(
          margin: const EdgeInsets.all(OpenVtsSpacing.sm),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(OpenVtsRadius.lg),
            border:
                Border.all(color: Theme.of(context).colorScheme.outlineVariant),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.85,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

class _SheetHeader extends StatelessWidget {
  const _SheetHeader({required this.title, this.subtitle});
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        OpenVtsSpacing.md,
        OpenVtsSpacing.md,
        OpenVtsSpacing.sm,
        OpenVtsSpacing.xs,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: OpenVtsTypography.primaryFontFamily,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: TextStyle(
                      fontFamily: OpenVtsTypography.primaryFontFamily,
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(Icons.close_rounded, size: 18),
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// Edit Profile sheet (with cascading country/state/city)
// =====================================================================

class _EditProfileSheet extends ConsumerStatefulWidget {
  const _EditProfileSheet({required this.profile});
  final AdminProfileSettings profile;

  @override
  ConsumerState<_EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends ConsumerState<_EditProfileSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _email;
  late final TextEditingController _mobile;
  late final TextEditingController _addressLine;
  late final TextEditingController _pincode;

  String? _mobilePrefix;
  String? _countryCode;
  String? _stateCode;
  String? _cityValue;

  List<AdminUserMobilePrefixOption> _prefixes = [];
  List<AdminUserCountryOption> _countries = [];
  List<AdminUserStateOption> _states = [];
  List<AdminUserCityOption> _cities = [];

  bool _loadingCatalogs = true;
  bool _loadingStates = false;
  bool _loadingCities = false;
  bool _submitting = false;
  bool _isInitializingProfileLocation = true;

  String? _initialCityValue;
  String? _initialCityDisplayName;

  @override
  void initState() {
    super.initState();
    final p = widget.profile;
    final a = p.address;
    _name = TextEditingController(text: p.name ?? '');
    _email = TextEditingController(text: p.email ?? '');
    _mobile = TextEditingController(text: p.mobileNumber ?? '');
    _addressLine = TextEditingController(text: a?.addressLine ?? '');
    _pincode = TextEditingController(text: a?.pincode ?? '');
    _mobilePrefix =
        p.mobilePrefix?.trim().isNotEmpty == true ? p.mobilePrefix : null;
    _countryCode =
        a?.countryCode?.trim().isNotEmpty == true ? a!.countryCode : null;
    _stateCode = a?.stateCode?.trim().isNotEmpty == true ? a!.stateCode : null;

    _initialCityValue = a?.cityValue;
    _initialCityDisplayName = a?.cityDisplayName;

    _cityValue = _initialCityValue;

    unawaited(_loadCatalogs());
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _mobile.dispose();
    _addressLine.dispose();
    _pincode.dispose();
    super.dispose();
  }

  Future<void> _loadCatalogs() async {
    final controller = ref.read(adminUsersControllerProvider.notifier);
    try {
      final results = await Future.wait([
        controller.getCountries(),
        controller.getMobilePrefixes(),
      ]);
      if (!mounted) return;
      setState(() {
        _countries = results[0] as List<AdminUserCountryOption>;
        _prefixes = results[1] as List<AdminUserMobilePrefixOption>;
        _loadingCatalogs = false;
      });
      if (_countryCode != null) {
        await _loadStates(_countryCode!);
        if (_stateCode != null) {
          await _loadCities(_countryCode!, _stateCode!);
        }
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => _loadingCatalogs = false);
    }
  }

  Future<void> _loadStates(String countryCode) async {
    setState(() {
      _loadingStates = true;
      _states = [];
    });
    try {
      final states = await ref
          .read(adminUsersControllerProvider.notifier)
          .getStates(countryCode);
      if (!mounted) return;
      setState(() {
        _states = states;
        _loadingStates = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loadingStates = false);
    }
  }

  Future<void> _loadCities(String countryCode, String stateCode) async {
    setState(() {
      _loadingCities = true;
      _cities = [];
    });
    try {
      final cities = await ref
          .read(adminUsersControllerProvider.notifier)
          .getCities(countryCode, stateCode);
      if (!mounted) return;
      setState(() {
        _cities = cities;
        _loadingCities = false;
      });

      // Try to match initial city using multiple strategies
      AdminUserCityOption? matchedOption;

      if (_initialCityValue != null && _initialCityValue!.isNotEmpty) {
        // Try exact match on value (id or code)
        try {
          matchedOption =
              _cities.firstWhere((c) => c.value == _initialCityValue);
        } catch (_) {
          matchedOption = null;
        }
      }

      if (matchedOption == null &&
          _initialCityDisplayName != null &&
          _initialCityDisplayName!.isNotEmpty) {
        // Try case-insensitive match on label/name
        try {
          matchedOption = _cities.firstWhere(
            (c) =>
                c.label.toLowerCase() == _initialCityDisplayName!.toLowerCase(),
          );
        } catch (_) {
          matchedOption = null;
        }
      }

      if (!mounted) return;
      if (matchedOption != null) {
        // Found exact match in list - sync state to matched option
        setState(() {
          _cityValue = matchedOption!.value;
        });
      } else if (matchedOption == null &&
          (_initialCityValue != null || _initialCityDisplayName != null)) {
        // Not found, inject synthetic option for backward compatibility
        final displayLabel = _initialCityDisplayName ?? _initialCityValue ?? '';
        final syntheticValue =
            _initialCityValue ?? _initialCityDisplayName ?? '';
        setState(() {
          _cities = [
            AdminUserCityOption(
              label: displayLabel,
              value: syntheticValue,
            ),
            ..._cities,
          ];
          _cityValue = syntheticValue;
        });
      }

      // Mark initialization as complete
      if (!mounted) return;
      setState(() => _isInitializingProfileLocation = false);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loadingCities = false;
        _isInitializingProfileLocation = false;
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);
    final controller = ref.read(adminSettingsControllerProvider.notifier);

    final ok = await controller.updateProfile(
      AdminUpdateProfileRequest(
        name: _name.text.trim(),
        email: _email.text.trim(),
        mobilePrefix: _mobilePrefix,
        mobileNumber: _mobile.text.trim().isEmpty ? null : _mobile.text.trim(),
        addressLine:
            _addressLine.text.trim().isEmpty ? null : _addressLine.text.trim(),
        countryCode: _countryCode,
        stateCode: _stateCode,
        cityName: _cityValue,
        pincode: _pincode.text.trim().isEmpty ? null : _pincode.text.trim(),
      ),
    );
    if (!mounted) return;
    if (ok) {
      Navigator.of(context).pop(true);
    } else {
      setState(() => _submitting = false);
      final msg =
          ref.read(adminSettingsControllerProvider).sectionErrorMessage ??
              'Unable to update profile.';
      ToastHelper.showError(msg);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingCatalogs) {
      return const SizedBox(
        height: 220,
        child: Center(child: OpenVtsLoader()),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const _SheetHeader(
          title: 'Edit Profile',
          subtitle: 'Personal details and address',
        ),
        Flexible(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              OpenVtsSpacing.md,
              0,
              OpenVtsSpacing.md,
              OpenVtsSpacing.md,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  OpenVtsTextField(
                    label: 'Name',
                    controller: _name,
                    validator: Validators.adminName,
                  ),
                  const SizedBox(height: OpenVtsSpacing.sm),
                  OpenVtsTextField(
                    label: 'Email (optional)',
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.adminEmailOptional,
                  ),
                  const SizedBox(height: OpenVtsSpacing.sm),
                  Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: AdminProfileMobilePrefixDropdown(
                          value: _mobilePrefix,
                          prefixes: _prefixes,
                          isLoading: _loadingCatalogs,
                          onChanged: (v) => setState(() => _mobilePrefix = v),
                        ),
                      ),
                      const SizedBox(width: OpenVtsSpacing.xs),
                      Expanded(
                        flex: 7,
                        child: OpenVtsTextField(
                          label: 'Mobile',
                          controller: _mobile,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(
                                Validators.maxMobileNumberLength),
                          ],
                          validator: Validators.mobileNumberOptional,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: OpenVtsSpacing.sm),
                  OpenVtsTextField(
                    label: 'Address',
                    controller: _addressLine,
                  ),
                  const SizedBox(height: OpenVtsSpacing.sm),
                  OpenVtsSearchableDropdown<String>(
                    label: 'Country',
                    value: _countryCode,
                    options: _countries
                        .map(
                          (c) => OpenVtsDropdownOption(
                            value: c.value,
                            label: c.label,
                            searchText: c.value,
                          ),
                        )
                        .toList(),
                    onChanged: (v) {
                      setState(() {
                        _countryCode = v;
                        _stateCode = null;
                        if (!_isInitializingProfileLocation) {
                          _cityValue = null;
                        }
                        _states = [];
                        _cities = [];
                      });
                      if (v != null) unawaited(_loadStates(v));
                    },
                  ),
                  const SizedBox(height: OpenVtsSpacing.sm),
                  OpenVtsSearchableDropdown<String>(
                    label: 'State',
                    value: _stateCode,
                    enabled: !_loadingStates,
                    isLoading: _loadingStates,
                    options: _states
                        .map(
                          (s) => OpenVtsDropdownOption(
                            value: s.value,
                            label: s.label,
                            searchText: s.value,
                          ),
                        )
                        .toList(),
                    onChanged: (v) {
                      setState(() {
                        _stateCode = v;
                        if (!_isInitializingProfileLocation) {
                          _cityValue = null;
                        }
                        _cities = [];
                      });
                      if (v != null && _countryCode != null) {
                        unawaited(_loadCities(_countryCode!, v));
                      }
                    },
                  ),
                  const SizedBox(height: OpenVtsSpacing.sm),
                  OpenVtsSearchableDropdown<String>(
                    label: 'City',
                    value: _cityValue,
                    enabled: !_loadingCities &&
                        (_cities.isNotEmpty || _cityValue != null),
                    isLoading: _loadingCities,
                    options: _cities
                        .map(
                          (c) => OpenVtsDropdownOption(
                            value: c.value,
                            label: c.label,
                          ),
                        )
                        .toList(),
                    onChanged: (v) {
                      setState(() {
                        _cityValue = v;
                        _isInitializingProfileLocation = false;
                      });
                    },
                  ),
                  const SizedBox(height: OpenVtsSpacing.sm),
                  OpenVtsTextField(
                    label: 'Pincode',
                    controller: _pincode,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(
                          Validators.maxPincodeLength),
                    ],
                    validator: Validators.pincodeOptional,
                  ),
                  const SizedBox(height: OpenVtsSpacing.md),
                  OpenVtsButton(
                    label: 'Save Changes',
                    isLoading: _submitting,
                    onPressed: _submit,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class AdminProfileMobilePrefixDropdown extends StatelessWidget {
  const AdminProfileMobilePrefixDropdown({
    required this.value,
    required this.prefixes,
    required this.onChanged,
    this.isLoading = false,
    super.key,
  });

  final String? value;
  final List<AdminUserMobilePrefixOption> prefixes;
  final ValueChanged<String?> onChanged;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return OpenVtsSearchableDropdown<String>(
      label: 'Prefix',
      value: value,
      options: prefixes
          .map(
            (prefix) => OpenVtsDropdownOption<String>(
              value: prefix.value,
              label: '${prefix.value} (${prefix.countryCode})',
              searchText: '${prefix.value} ${prefix.countryCode}',
            ),
          )
          .toList(growable: false),
      searchHintText: 'Search dial or country code',
      leadingIcon: Icons.phone_android_rounded,
      isLoading: isLoading,
      onChanged: onChanged,
    );
  }
}

class _DropdownField<T> extends StatelessWidget {
  const _DropdownField({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.enabled = true,
    this.busy = false,
  });

  final String label;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final bool enabled;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: OpenVtsTypography.primaryFontFamily,
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 4),
        InputDecorator(
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(OpenVtsRadius.sm),
              borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.outlineVariant),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(OpenVtsRadius.sm),
              borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.outlineVariant),
            ),
            suffixIcon: busy
                ? const Padding(
                    padding: EdgeInsets.all(10),
                    child: SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : null,
          ),
          child: DropdownButtonHideUnderline(
            child: Builder(
              builder: (context) {
                final hasValueInItems =
                    value != null && items.any((it) => it.value == value);
                final safeItems = hasValueInItems
                    ? items
                    : <DropdownMenuItem<T>>[
                        if (value != null)
                          DropdownMenuItem<T>(
                            value: value,
                            child: Text(
                              value.toString(),
                              style: TextStyle(
                                fontFamily: OpenVtsTypography.primaryFontFamily,
                                fontSize: 12.5,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                            ),
                          ),
                        ...items,
                      ];
                return DropdownButton<T>(
                  value: value,
                  isExpanded: true,
                  isDense: true,
                  onChanged: enabled ? onChanged : null,
                  items: safeItems,
                  hint: Text(
                    'Select',
                    style: TextStyle(
                      fontFamily: OpenVtsTypography.primaryFontFamily,
                      fontSize: 12.5,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  style: TextStyle(
                    fontFamily: OpenVtsTypography.primaryFontFamily,
                    fontSize: 12.5,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

// =====================================================================
// Change Password sheet
// =====================================================================

class AdminChangePasswordSheet extends ConsumerStatefulWidget {
  const AdminChangePasswordSheet({super.key});

  @override
  ConsumerState<AdminChangePasswordSheet> createState() =>
      _ChangePasswordSheetState();
}

class _ChangePasswordSheetState
    extends ConsumerState<AdminChangePasswordSheet> {
  final _formKey = GlobalKey<FormState>();
  final _current = TextEditingController();
  final _next = TextEditingController();
  final _confirm = TextEditingController();
  bool _obscureCurrent = true;
  bool _obscureNext = true;
  bool _obscureConfirm = true;
  bool _submitting = false;

  @override
  void dispose() {
    _current.dispose();
    _next.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);
    final ok =
        await ref.read(adminSettingsControllerProvider.notifier).changePassword(
              AdminChangePasswordRequest(
                currentPassword: _current.text,
                newPassword: _next.text,
              ),
            );
    if (!mounted) return;
    if (ok) {
      Navigator.of(context).pop(true);
    } else {
      setState(() => _submitting = false);
      final msg =
          ref.read(adminSettingsControllerProvider).sectionErrorMessage ??
              'Unable to change password.';
      ToastHelper.showError(msg);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const _SheetHeader(
          title: 'Change Password',
          subtitle: 'Use a strong, unique password',
        ),
        Flexible(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              OpenVtsSpacing.md,
              0,
              OpenVtsSpacing.md,
              OpenVtsSpacing.md,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  OpenVtsTextField(
                    label: 'Current password',
                    controller: _current,
                    obscureText: _obscureCurrent,
                    suffixIcon: IconButton(
                      key: const ValueKey('current-password-visibility'),
                      tooltip: _obscureCurrent
                          ? 'Show current password'
                          : 'Hide current password',
                      icon: Icon(
                        _obscureCurrent
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        size: 18,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      onPressed: () => setState(
                        () => _obscureCurrent = !_obscureCurrent,
                      ),
                    ),
                    validator: (v) =>
                        (v ?? '').isEmpty ? 'Current password required' : null,
                  ),
                  const SizedBox(height: OpenVtsSpacing.sm),
                  OpenVtsTextField(
                    label: 'New password',
                    controller: _next,
                    obscureText: _obscureNext,
                    suffixIcon: IconButton(
                      key: const ValueKey('new-password-visibility'),
                      tooltip: _obscureNext
                          ? 'Show new password'
                          : 'Hide new password',
                      icon: Icon(
                        _obscureNext
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        size: 18,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      onPressed: () =>
                          setState(() => _obscureNext = !_obscureNext),
                    ),
                    validator: (v) {
                      final t = v ?? '';
                      if (t.length < 8) {
                        return 'Use at least 8 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: OpenVtsSpacing.sm),
                  OpenVtsTextField(
                    label: 'Confirm new password',
                    controller: _confirm,
                    obscureText: _obscureConfirm,
                    suffixIcon: IconButton(
                      key: const ValueKey('confirm-password-visibility'),
                      tooltip: _obscureConfirm
                          ? 'Show confirm new password'
                          : 'Hide confirm new password',
                      icon: Icon(
                        _obscureConfirm
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        size: 18,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      onPressed: () => setState(
                        () => _obscureConfirm = !_obscureConfirm,
                      ),
                    ),
                    validator: (v) {
                      if ((v ?? '') != _next.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: OpenVtsSpacing.md),
                  OpenVtsButton(
                    label: 'Update Password',
                    isLoading: _submitting,
                    onPressed: _submit,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// =====================================================================
// Edit Company sheet
// =====================================================================

class _EditCompanySheet extends ConsumerStatefulWidget {
  const _EditCompanySheet({required this.company});
  final AdminCompanySettings company;

  @override
  ConsumerState<_EditCompanySheet> createState() => _EditCompanySheetState();
}

class _EditCompanySheetState extends ConsumerState<_EditCompanySheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _website;
  late final TextEditingController _domain;
  late final TextEditingController _primaryColor;
  late final TextEditingController _facebook;
  late final TextEditingController _twitter;
  late final TextEditingController _linkedin;
  late final TextEditingController _instagram;
  late final TextEditingController _youtube;
  late final TextEditingController _github;
  bool _submitting = false;

  static const List<Map<String, String>> _colorOptions = [
    {'name': 'Black', 'hex': '#111827'},
    {'name': 'Blue', 'hex': '#2563EB'},
    {'name': 'Green', 'hex': '#16A34A'},
    {'name': 'Red', 'hex': '#DC2626'},
    {'name': 'Orange', 'hex': '#EA580C'},
    {'name': 'Purple', 'hex': '#7C3AED'},
  ];

  @override
  void initState() {
    super.initState();
    final c = widget.company;
    final s = c.socialLinks ?? const AdminSocialLinks();
    _name = TextEditingController(text: c.name ?? '');
    _website = TextEditingController(text: c.websiteUrl ?? '');
    _domain = TextEditingController(text: c.customDomain ?? '');

    // Map existing color to dropdown option
    String? selectedColor;
    if (c.primaryColor != null) {
      final normalized = _normalizeHexColor(c.primaryColor!);
      selectedColor = _colorOptions.cast<Map<String, String>?>().firstWhere(
            (opt) => opt?['hex']?.toUpperCase() == normalized.toUpperCase(),
            orElse: () => null,
          )?['name'];
    }
    _primaryColor = TextEditingController(text: selectedColor ?? '');

    _facebook = TextEditingController(text: s.facebook ?? '');
    _twitter = TextEditingController(text: s.twitter ?? '');
    _linkedin = TextEditingController(text: s.linkedin ?? '');
    _instagram = TextEditingController(text: s.instagram ?? '');
    _youtube = TextEditingController(text: s.youtube ?? '');
    _github = TextEditingController(text: s.github ?? '');
  }

  @override
  void dispose() {
    _name.dispose();
    _website.dispose();
    _domain.dispose();
    _primaryColor.dispose();
    _facebook.dispose();
    _twitter.dispose();
    _linkedin.dispose();
    _instagram.dispose();
    _youtube.dispose();
    _github.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);
    final colorName = _primaryColor.text.trim();
    String? normalizedColor;
    if (colorName.isNotEmpty) {
      normalizedColor = _colorOptions.cast<Map<String, String>?>().firstWhere(
            (opt) => opt?['name'] == colorName,
            orElse: () => null,
          )?['hex'];
    }
    final ok =
        await ref.read(adminSettingsControllerProvider.notifier).updateCompany(
              AdminUpdateCompanyRequest(
                name: _name.text.trim(),
                websiteUrl: _website.text.trim(),
                customDomain: _domain.text.trim(),
                primaryColor: normalizedColor,
                socialLinks: AdminSocialLinks(
                  facebook: _facebook.text.trim(),
                  twitter: _twitter.text.trim(),
                  linkedin: _linkedin.text.trim(),
                  instagram: _instagram.text.trim(),
                  youtube: _youtube.text.trim(),
                  github: _github.text.trim(),
                ),
              ),
            );
    if (!mounted) return;
    if (ok) {
      Navigator.of(context).pop(true);
    } else {
      setState(() => _submitting = false);
      final msg =
          ref.read(adminSettingsControllerProvider).sectionErrorMessage ??
              'Unable to update company.';
      ToastHelper.showError(msg);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const _SheetHeader(
          title: 'Edit Company',
          subtitle: 'Brand and contact details',
        ),
        Flexible(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              OpenVtsSpacing.md,
              0,
              OpenVtsSpacing.md,
              OpenVtsSpacing.md,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  OpenVtsTextField(
                    label: 'Company name',
                    controller: _name,
                    validator: Validators.companyName,
                  ),
                  const SizedBox(height: OpenVtsSpacing.sm),
                  OpenVtsTextField(
                    label: 'Website',
                    controller: _website,
                    keyboardType: TextInputType.url,
                    validator: (v) {
                      final t = (v ?? '').trim();
                      if (t.isEmpty) return null;
                      final candidate =
                          t.startsWith('http://') || t.startsWith('https://')
                              ? t
                              : 'https://$t';
                      final uri = Uri.tryParse(candidate);
                      if (uri == null || (uri.host).isEmpty) {
                        return 'Enter a valid URL';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: OpenVtsSpacing.sm),
                  OpenVtsTextField(
                    label: 'Custom domain',
                    controller: _domain,
                    keyboardType: TextInputType.url,
                  ),
                  const SizedBox(height: OpenVtsSpacing.sm),
                  _DropdownField<String>(
                    label: 'Primary color',
                    value:
                        _primaryColor.text.isEmpty ? null : _primaryColor.text,
                    items: _colorOptions
                        .map(
                          (opt) => DropdownMenuItem(
                            value: opt['name'],
                            child: Row(
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  decoration: BoxDecoration(
                                    color: Color(int.parse(
                                          opt['hex']!.substring(1),
                                          radix: 16,
                                        ) +
                                        0xFF000000),
                                    borderRadius: BorderRadius.circular(3),
                                    border: Border.all(
                                      color: OpenVtsColors.border,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(opt['name']!),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (v) =>
                        setState(() => _primaryColor.text = v ?? ''),
                  ),
                  const SizedBox(height: OpenVtsSpacing.md),
                  const _SubSectionLabel('Social Links'),
                  const SizedBox(height: OpenVtsSpacing.xs),
                  OpenVtsTextField(
                    label: 'Facebook',
                    controller: _facebook,
                    keyboardType: TextInputType.url,
                  ),
                  const SizedBox(height: OpenVtsSpacing.xs),
                  OpenVtsTextField(
                    label: 'Twitter / X',
                    controller: _twitter,
                    keyboardType: TextInputType.url,
                  ),
                  const SizedBox(height: OpenVtsSpacing.xs),
                  OpenVtsTextField(
                    label: 'LinkedIn',
                    controller: _linkedin,
                    keyboardType: TextInputType.url,
                  ),
                  const SizedBox(height: OpenVtsSpacing.xs),
                  OpenVtsTextField(
                    label: 'Instagram',
                    controller: _instagram,
                    keyboardType: TextInputType.url,
                  ),
                  const SizedBox(height: OpenVtsSpacing.xs),
                  OpenVtsTextField(
                    label: 'YouTube',
                    controller: _youtube,
                    keyboardType: TextInputType.url,
                  ),
                  const SizedBox(height: OpenVtsSpacing.xs),
                  OpenVtsTextField(
                    label: 'GitHub',
                    controller: _github,
                    keyboardType: TextInputType.url,
                  ),
                  const SizedBox(height: OpenVtsSpacing.md),
                  OpenVtsButton(
                    label: 'Save Changes',
                    isLoading: _submitting,
                    onPressed: _submit,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SubSectionLabel extends StatelessWidget {
  const _SubSectionLabel(this.label);
  final String label;
  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: TextStyle(
        fontFamily: OpenVtsTypography.primaryFontFamily,
        fontSize: 10,
        letterSpacing: 0.8,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.outline,
      ),
    );
  }
}

// =====================================================================
// OTP verification sheet
// =====================================================================

enum _OtpChannel { email, whatsapp }

class _OtpVerificationSheet extends ConsumerStatefulWidget {
  const _OtpVerificationSheet({required this.channel});
  final _OtpChannel channel;

  @override
  ConsumerState<_OtpVerificationSheet> createState() =>
      _OtpVerificationSheetState();
}

class _OtpVerificationSheetState extends ConsumerState<_OtpVerificationSheet> {
  final _otp = TextEditingController();
  bool _requested = false;
  bool _submitting = false;
  bool _resending = false;
  bool _requestInFlight = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _requestOtp());
  }

  @override
  void dispose() {
    _otp.dispose();
    super.dispose();
  }

  Future<void> _requestOtp({bool isResend = false}) async {
    if (_requestInFlight) return;
    setState(() {
      _requestInFlight = true;
      if (isResend) _resending = true;
    });
    final controller = ref.read(adminSettingsControllerProvider.notifier);
    final ok = widget.channel == _OtpChannel.email
        ? await controller.requestEmailOtp()
        : await controller.requestWhatsAppOtp();
    if (!mounted) return;
    setState(() {
      _resending = false;
      _requestInFlight = false;
      _requested = _requested || ok;
    });
    if (ok) {
      ToastHelper.showInfo(
        widget.channel == _OtpChannel.email
            ? 'OTP sent to your email'
            : 'OTP sent via WhatsApp',
      );
    } else {
      final msg =
          ref.read(adminSettingsControllerProvider).sectionErrorMessage ??
              'Unable to send OTP.';
      ToastHelper.showError(msg);
    }
  }

  Future<void> _confirm() async {
    final code = _otp.text.trim();
    if (code.length != 6) {
      ToastHelper.showError('Enter the 6-digit code');
      return;
    }
    setState(() => _submitting = true);
    final controller = ref.read(adminSettingsControllerProvider.notifier);
    final ok = widget.channel == _OtpChannel.email
        ? await controller.confirmEmailOtp(code)
        : await controller.confirmWhatsAppOtp(code);
    if (!mounted) return;
    if (ok) {
      Navigator.of(context).pop(true);
    } else {
      setState(() => _submitting = false);
      final msg =
          ref.read(adminSettingsControllerProvider).sectionErrorMessage ??
              'Invalid or expired code.';
      ToastHelper.showError(msg);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEmail = widget.channel == _OtpChannel.email;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _SheetHeader(
          title: isEmail ? 'Verify Email' : 'Verify WhatsApp',
          subtitle: 'Enter the 6-digit code we sent you',
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            OpenVtsSpacing.md,
            0,
            OpenVtsSpacing.md,
            OpenVtsSpacing.md,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _otp,
                keyboardType: TextInputType.number,
                maxLength: 6,
                textAlign: TextAlign.center,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                style: TextStyle(
                  fontFamily: OpenVtsTypography.primaryFontFamily,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 8,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                decoration: InputDecoration(
                  counterText: '',
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(OpenVtsRadius.sm),
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.outlineVariant),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(OpenVtsRadius.sm),
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.outlineVariant),
                  ),
                ),
              ),
              const SizedBox(height: OpenVtsSpacing.sm),
              Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: _requestInFlight
                      ? null
                      : () => _requestOtp(isResend: true),
                  child: _resending
                      ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          'Resend code',
                          style: TextStyle(
                            fontFamily: OpenVtsTypography.primaryFontFamily,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: OpenVtsSpacing.sm),
              OpenVtsButton(
                label: 'Verify',
                isLoading: _submitting,
                onPressed: _confirm,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
