import 'package:flutter/foundation.dart';

/// The iOS app is a companion to an existing deployment. Subscription renewals
/// use the deployment's manual payment API, not StoreKit, so they are unavailable
/// in the native iOS app. Payment history and administrative records remain usable.
class AdminSubscriptionPolicy {
  const AdminSubscriptionPolicy._();

  static bool get allowsRenewals =>
      kIsWeb || defaultTargetPlatform != TargetPlatform.iOS;

  static void requireRenewalsAllowed() {
    if (!allowsRenewals) {
      throw UnsupportedError('Subscription renewal is unavailable in this app.');
    }
  }
}
