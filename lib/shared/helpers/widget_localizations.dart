import 'package:flutter/widgets.dart';

import '../../l10n/app_localizations.dart';
import '../../l10n/app_localizations_en.dart';

/// Shared controls also work when embedded outside the application shell.
/// Inside OpenVTS the registered delegate always supplies the active locale.
extension WidgetLocalizations on BuildContext {
  AppLocalizations get widgetL10n =>
      Localizations.of<AppLocalizations>(this, AppLocalizations) ??
      AppLocalizationsEn();
}
