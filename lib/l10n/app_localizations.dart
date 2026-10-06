import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
    Locale('pt')
  ];

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @direction.
  ///
  /// In en, this message translates to:
  /// **'Direction'**
  String get direction;

  /// No description provided for @units.
  ///
  /// In en, this message translates to:
  /// **'Units'**
  String get units;

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'OpenVTS'**
  String get appTitle;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @localization.
  ///
  /// In en, this message translates to:
  /// **'Localization'**
  String get localization;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @dateFormat.
  ///
  /// In en, this message translates to:
  /// **'Date Format'**
  String get dateFormat;

  /// No description provided for @timeFormat.
  ///
  /// In en, this message translates to:
  /// **'Time Format'**
  String get timeFormat;

  /// No description provided for @timezone.
  ///
  /// In en, this message translates to:
  /// **'Timezone'**
  String get timezone;

  /// No description provided for @use24Hour.
  ///
  /// In en, this message translates to:
  /// **'24-Hour Time'**
  String get use24Hour;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @prev.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get prev;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @warning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @en.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get en;

  /// No description provided for @hi.
  ///
  /// In en, this message translates to:
  /// **'Hindi'**
  String get hi;

  /// No description provided for @ar.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get ar;

  /// No description provided for @es.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get es;

  /// No description provided for @fr.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get fr;

  /// No description provided for @pt.
  ///
  /// In en, this message translates to:
  /// **'Portuguese'**
  String get pt;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @administrators.
  ///
  /// In en, this message translates to:
  /// **'Administrators'**
  String get administrators;

  /// No description provided for @payments.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get payments;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @tickets.
  ///
  /// In en, this message translates to:
  /// **'Tickets'**
  String get tickets;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @keepEditing.
  ///
  /// In en, this message translates to:
  /// **'Keep Editing'**
  String get keepEditing;

  /// No description provided for @discardChanges.
  ///
  /// In en, this message translates to:
  /// **'Discard Changes'**
  String get discardChanges;

  /// No description provided for @unsavedChanges.
  ///
  /// In en, this message translates to:
  /// **'Unsaved changes'**
  String get unsavedChanges;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @selectTheme.
  ///
  /// In en, this message translates to:
  /// **'Select Theme'**
  String get selectTheme;

  /// No description provided for @selectDateFormat.
  ///
  /// In en, this message translates to:
  /// **'Select Date Format'**
  String get selectDateFormat;

  /// No description provided for @selectTimeFormat.
  ///
  /// In en, this message translates to:
  /// **'Select Time Format'**
  String get selectTimeFormat;

  /// No description provided for @selectTimezone.
  ///
  /// In en, this message translates to:
  /// **'Select Timezone'**
  String get selectTimezone;

  /// Date format preview
  ///
  /// In en, this message translates to:
  /// **'Preview: {date}'**
  String previewDate(String date);

  /// Time format preview
  ///
  /// In en, this message translates to:
  /// **'Preview: {time}'**
  String previewTime(String time);

  /// No description provided for @settingsUpdated.
  ///
  /// In en, this message translates to:
  /// **'Settings updated'**
  String get settingsUpdated;

  /// No description provided for @profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated'**
  String get profileUpdated;

  /// No description provided for @localizationUpdated.
  ///
  /// In en, this message translates to:
  /// **'Localization settings updated'**
  String get localizationUpdated;

  /// No description provided for @failedToUpdate.
  ///
  /// In en, this message translates to:
  /// **'Failed to update. Please try again.'**
  String get failedToUpdate;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noData;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @confirmDiscard.
  ///
  /// In en, this message translates to:
  /// **'Discard unsaved changes?'**
  String get confirmDiscard;

  /// Confirmation message for discarding changes
  ///
  /// In en, this message translates to:
  /// **'{tab} has unsaved edits. Discarding will lose these changes.'**
  String confirmDiscardMessage(String tab);

  /// No description provided for @reportsTitle.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reportsTitle;

  /// No description provided for @reportsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search reports…'**
  String get reportsSearchHint;

  /// No description provided for @reportsNoResultsFor.
  ///
  /// In en, this message translates to:
  /// **'No reports found for \"{query}\"'**
  String reportsNoResultsFor(Object query);

  /// No description provided for @reportsGenerate.
  ///
  /// In en, this message translates to:
  /// **'Generate Report'**
  String get reportsGenerate;

  /// No description provided for @reportsGenerating.
  ///
  /// In en, this message translates to:
  /// **'Generating…'**
  String get reportsGenerating;

  /// No description provided for @reportsReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reportsReset;

  /// No description provided for @reportsConfigureHint.
  ///
  /// In en, this message translates to:
  /// **'Configure your report above and tap Generate.'**
  String get reportsConfigureHint;

  /// No description provided for @reportsNoResults.
  ///
  /// In en, this message translates to:
  /// **'No results found for the selected filters.'**
  String get reportsNoResults;

  /// No description provided for @reportsErrorRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get reportsErrorRetry;

  /// No description provided for @reportsRowCount.
  ///
  /// In en, this message translates to:
  /// **'{count} rows loaded'**
  String reportsRowCount(Object count);

  /// No description provided for @reportsLoadMore.
  ///
  /// In en, this message translates to:
  /// **'Load More'**
  String get reportsLoadMore;

  /// No description provided for @reportsLoadingMore.
  ///
  /// In en, this message translates to:
  /// **'Loading more…'**
  String get reportsLoadingMore;

  /// No description provided for @reportsGeneratedAt.
  ///
  /// In en, this message translates to:
  /// **'Generated {time}'**
  String reportsGeneratedAt(Object time);

  /// No description provided for @reportsExportTitle.
  ///
  /// In en, this message translates to:
  /// **'Export Report'**
  String get reportsExportTitle;

  /// No description provided for @reportsExportCsv.
  ///
  /// In en, this message translates to:
  /// **'CSV'**
  String get reportsExportCsv;

  /// No description provided for @reportsExportXlsx.
  ///
  /// In en, this message translates to:
  /// **'Excel (XLSX)'**
  String get reportsExportXlsx;

  /// No description provided for @reportsExportJson.
  ///
  /// In en, this message translates to:
  /// **'JSON'**
  String get reportsExportJson;

  /// No description provided for @reportsExportPdf.
  ///
  /// In en, this message translates to:
  /// **'PDF'**
  String get reportsExportPdf;

  /// No description provided for @reportsExportHtml.
  ///
  /// In en, this message translates to:
  /// **'HTML'**
  String get reportsExportHtml;

  /// No description provided for @reportsScopeAll.
  ///
  /// In en, this message translates to:
  /// **'All vehicles'**
  String get reportsScopeAll;

  /// No description provided for @reportsScopeSingle.
  ///
  /// In en, this message translates to:
  /// **'Single vehicle'**
  String get reportsScopeSingle;

  /// No description provided for @reportsScopeMultiple.
  ///
  /// In en, this message translates to:
  /// **'Multiple vehicles'**
  String get reportsScopeMultiple;

  /// No description provided for @reportsScopeGroup.
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get reportsScopeGroup;

  /// No description provided for @reportsScopeSelectVehicle.
  ///
  /// In en, this message translates to:
  /// **'Select vehicle'**
  String get reportsScopeSelectVehicle;

  /// No description provided for @reportsScopeSelectVehicles.
  ///
  /// In en, this message translates to:
  /// **'Select vehicles'**
  String get reportsScopeSelectVehicles;

  /// No description provided for @reportsScopeSelectGroup.
  ///
  /// In en, this message translates to:
  /// **'Select group'**
  String get reportsScopeSelectGroup;

  /// No description provided for @reportsScopeSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by name, plate or IMEI…'**
  String get reportsScopeSearchHint;

  /// No description provided for @reportsScopeSelectAll.
  ///
  /// In en, this message translates to:
  /// **'Select all visible'**
  String get reportsScopeSelectAll;

  /// No description provided for @reportsScopeDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get reportsScopeDone;

  /// No description provided for @reportsScopeNVehiclesSelected.
  ///
  /// In en, this message translates to:
  /// **'{count} vehicles selected'**
  String reportsScopeNVehiclesSelected(Object count);

  /// No description provided for @reportsDateStart.
  ///
  /// In en, this message translates to:
  /// **'Start date'**
  String get reportsDateStart;

  /// No description provided for @reportsDateEnd.
  ///
  /// In en, this message translates to:
  /// **'End date'**
  String get reportsDateEnd;

  /// No description provided for @reportsDateFrom.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get reportsDateFrom;

  /// No description provided for @reportsDateTo.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get reportsDateTo;

  /// No description provided for @reportsDateMaxDays.
  ///
  /// In en, this message translates to:
  /// **'Max {days} days for this report type'**
  String reportsDateMaxDays(Object days);

  /// No description provided for @reportsValidationScopeRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select at least one vehicle.'**
  String get reportsValidationScopeRequired;

  /// No description provided for @reportsValidationStartRequired.
  ///
  /// In en, this message translates to:
  /// **'Start date is required.'**
  String get reportsValidationStartRequired;

  /// No description provided for @reportsValidationEndRequired.
  ///
  /// In en, this message translates to:
  /// **'End date is required.'**
  String get reportsValidationEndRequired;

  /// No description provided for @reportsValidationStartBeforeEnd.
  ///
  /// In en, this message translates to:
  /// **'Start must be before end.'**
  String get reportsValidationStartBeforeEnd;

  /// No description provided for @reportsValidationMaxDays.
  ///
  /// In en, this message translates to:
  /// **'Date range exceeds the {days}-day limit for this report.'**
  String reportsValidationMaxDays(Object days);

  /// No description provided for @reportsValidationSensorVehicleRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select a vehicle for the sensor report.'**
  String get reportsValidationSensorVehicleRequired;

  /// No description provided for @reportsValidationSensorRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select a sensor.'**
  String get reportsValidationSensorRequired;

  /// No description provided for @reportsValidationTimelineStateRequired.
  ///
  /// In en, this message translates to:
  /// **'Select at least one state (Running or Stopped).'**
  String get reportsValidationTimelineStateRequired;

  /// No description provided for @reportsFilterSpeedLimit.
  ///
  /// In en, this message translates to:
  /// **'Speed limit (km/h)'**
  String get reportsFilterSpeedLimit;

  /// No description provided for @reportsFilterSpeedCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom limit…'**
  String get reportsFilterSpeedCustom;

  /// No description provided for @reportsFilterGeofenceHint.
  ///
  /// In en, this message translates to:
  /// **'Search geofences…'**
  String get reportsFilterGeofenceHint;

  /// No description provided for @reportsFilterGeofenceAllNote.
  ///
  /// In en, this message translates to:
  /// **'No selection includes all geofences.'**
  String get reportsFilterGeofenceAllNote;

  /// No description provided for @reportsFilterAlertType.
  ///
  /// In en, this message translates to:
  /// **'Alert type'**
  String get reportsFilterAlertType;

  /// No description provided for @reportsFilterAlertSeverity.
  ///
  /// In en, this message translates to:
  /// **'Severity'**
  String get reportsFilterAlertSeverity;

  /// No description provided for @reportsFilterAlertAck.
  ///
  /// In en, this message translates to:
  /// **'Acknowledgement'**
  String get reportsFilterAlertAck;

  /// No description provided for @reportsFilterAlertAckAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get reportsFilterAlertAckAll;

  /// No description provided for @reportsFilterAlertAckAcknowledged.
  ///
  /// In en, this message translates to:
  /// **'Acknowledged'**
  String get reportsFilterAlertAckAcknowledged;

  /// No description provided for @reportsFilterAlertAckUnacknowledged.
  ///
  /// In en, this message translates to:
  /// **'Unacknowledged'**
  String get reportsFilterAlertAckUnacknowledged;

  /// No description provided for @reportsFilterLogsVehicle.
  ///
  /// In en, this message translates to:
  /// **'Vehicle'**
  String get reportsFilterLogsVehicle;

  /// No description provided for @reportsFilterLogsCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get reportsFilterLogsCategory;

  /// No description provided for @reportsFilterLogsLevel.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get reportsFilterLogsLevel;

  /// No description provided for @reportsFilterTimelineRunning.
  ///
  /// In en, this message translates to:
  /// **'Running'**
  String get reportsFilterTimelineRunning;

  /// No description provided for @reportsFilterTimelineStopped.
  ///
  /// In en, this message translates to:
  /// **'Stopped'**
  String get reportsFilterTimelineStopped;

  /// No description provided for @reportsFilterSensorVehicle.
  ///
  /// In en, this message translates to:
  /// **'Vehicle'**
  String get reportsFilterSensorVehicle;

  /// No description provided for @reportsFilterSensorSensor.
  ///
  /// In en, this message translates to:
  /// **'Sensor'**
  String get reportsFilterSensorSensor;

  /// No description provided for @reportsCatalogDistanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get reportsCatalogDistanceTitle;

  /// No description provided for @reportsCatalogDistanceDesc.
  ///
  /// In en, this message translates to:
  /// **'Total distance driven per vehicle per day with engine hours and odometer readings.'**
  String get reportsCatalogDistanceDesc;

  /// No description provided for @reportsCatalogDrivenTitle.
  ///
  /// In en, this message translates to:
  /// **'Driven Days'**
  String get reportsCatalogDrivenTitle;

  /// No description provided for @reportsCatalogDrivenDesc.
  ///
  /// In en, this message translates to:
  /// **'Daily distance matrix — which vehicles moved on which days and how far.'**
  String get reportsCatalogDrivenDesc;

  /// No description provided for @reportsCatalogDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Details'**
  String get reportsCatalogDetailsTitle;

  /// No description provided for @reportsCatalogDetailsDesc.
  ///
  /// In en, this message translates to:
  /// **'Fleet summary: total distance, engine hours, active days, last known location per vehicle.'**
  String get reportsCatalogDetailsDesc;

  /// No description provided for @reportsCatalogOverspeedTitle.
  ///
  /// In en, this message translates to:
  /// **'Overspeed'**
  String get reportsCatalogOverspeedTitle;

  /// No description provided for @reportsCatalogOverspeedDesc.
  ///
  /// In en, this message translates to:
  /// **'Speeding events with observed speed, configured limit, excess, duration, and location.'**
  String get reportsCatalogOverspeedDesc;

  /// No description provided for @reportsCatalogGeofenceTitle.
  ///
  /// In en, this message translates to:
  /// **'Geofence'**
  String get reportsCatalogGeofenceTitle;

  /// No description provided for @reportsCatalogGeofenceDesc.
  ///
  /// In en, this message translates to:
  /// **'Entry and exit events for selected geofences with timestamps and dwell duration.'**
  String get reportsCatalogGeofenceDesc;

  /// No description provided for @reportsCatalogAlertsTitle.
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get reportsCatalogAlertsTitle;

  /// No description provided for @reportsCatalogAlertsDesc.
  ///
  /// In en, this message translates to:
  /// **'Alert events by type and severity with acknowledgement status.'**
  String get reportsCatalogAlertsDesc;

  /// No description provided for @reportsCatalogSensorTitle.
  ///
  /// In en, this message translates to:
  /// **'Sensor'**
  String get reportsCatalogSensorTitle;

  /// No description provided for @reportsCatalogSensorDesc.
  ///
  /// In en, this message translates to:
  /// **'Time-series readings for a specific sensor on a single vehicle with chart visualisation.'**
  String get reportsCatalogSensorDesc;

  /// No description provided for @reportsCatalogLogsTitle.
  ///
  /// In en, this message translates to:
  /// **'Device Logs'**
  String get reportsCatalogLogsTitle;

  /// No description provided for @reportsCatalogLogsDesc.
  ///
  /// In en, this message translates to:
  /// **'Raw communication logs from vehicle devices grouped by category and level.'**
  String get reportsCatalogLogsDesc;

  /// No description provided for @reportsCatalogTimelineTitle.
  ///
  /// In en, this message translates to:
  /// **'Timeline'**
  String get reportsCatalogTimelineTitle;

  /// No description provided for @reportsCatalogTimelineDesc.
  ///
  /// In en, this message translates to:
  /// **'Running and stopped segments with duration, distance, and GPS map trace per segment.'**
  String get reportsCatalogTimelineDesc;

  /// No description provided for @reportsKpiTotalDistance.
  ///
  /// In en, this message translates to:
  /// **'Total Distance'**
  String get reportsKpiTotalDistance;

  /// No description provided for @reportsKpiEngineHours.
  ///
  /// In en, this message translates to:
  /// **'Engine Hours'**
  String get reportsKpiEngineHours;

  /// No description provided for @reportsKpiActiveVehicles.
  ///
  /// In en, this message translates to:
  /// **'Active Vehicles'**
  String get reportsKpiActiveVehicles;

  /// No description provided for @reportsKpiAvgDistance.
  ///
  /// In en, this message translates to:
  /// **'Avg Distance'**
  String get reportsKpiAvgDistance;

  /// No description provided for @reportsKpiVehiclesDriven.
  ///
  /// In en, this message translates to:
  /// **'Vehicles Driven'**
  String get reportsKpiVehiclesDriven;

  /// No description provided for @reportsKpiAvgDaily.
  ///
  /// In en, this message translates to:
  /// **'Avg Daily'**
  String get reportsKpiAvgDaily;

  /// No description provided for @reportsKpiPeakDay.
  ///
  /// In en, this message translates to:
  /// **'Peak Day'**
  String get reportsKpiPeakDay;

  /// No description provided for @reportsKpiViolations.
  ///
  /// In en, this message translates to:
  /// **'Violations'**
  String get reportsKpiViolations;

  /// No description provided for @reportsKpiAffectedVehicles.
  ///
  /// In en, this message translates to:
  /// **'Affected Vehicles'**
  String get reportsKpiAffectedVehicles;

  /// No description provided for @reportsKpiHighestSpeed.
  ///
  /// In en, this message translates to:
  /// **'Highest Speed'**
  String get reportsKpiHighestSpeed;

  /// No description provided for @reportsKpiTotalDuration.
  ///
  /// In en, this message translates to:
  /// **'Total Duration'**
  String get reportsKpiTotalDuration;

  /// No description provided for @reportsKpiTotalEvents.
  ///
  /// In en, this message translates to:
  /// **'Total Events'**
  String get reportsKpiTotalEvents;

  /// No description provided for @reportsKpiEntries.
  ///
  /// In en, this message translates to:
  /// **'Entries'**
  String get reportsKpiEntries;

  /// No description provided for @reportsKpiExits.
  ///
  /// In en, this message translates to:
  /// **'Exits'**
  String get reportsKpiExits;

  /// No description provided for @reportsKpiTotalAlerts.
  ///
  /// In en, this message translates to:
  /// **'Total Alerts'**
  String get reportsKpiTotalAlerts;

  /// No description provided for @reportsKpiCritical.
  ///
  /// In en, this message translates to:
  /// **'Critical'**
  String get reportsKpiCritical;

  /// No description provided for @reportsKpiAcknowledged.
  ///
  /// In en, this message translates to:
  /// **'Acknowledged'**
  String get reportsKpiAcknowledged;

  /// No description provided for @reportsKpiReadings.
  ///
  /// In en, this message translates to:
  /// **'Readings'**
  String get reportsKpiReadings;

  /// No description provided for @reportsKpiOnEvents.
  ///
  /// In en, this message translates to:
  /// **'ON Events'**
  String get reportsKpiOnEvents;

  /// No description provided for @reportsKpiOffEvents.
  ///
  /// In en, this message translates to:
  /// **'OFF Events'**
  String get reportsKpiOffEvents;

  /// No description provided for @reportsKpiTotalLogs.
  ///
  /// In en, this message translates to:
  /// **'Total Logs'**
  String get reportsKpiTotalLogs;

  /// No description provided for @reportsKpiRunningDuration.
  ///
  /// In en, this message translates to:
  /// **'Running Duration'**
  String get reportsKpiRunningDuration;

  /// No description provided for @reportsKpiStoppedDuration.
  ///
  /// In en, this message translates to:
  /// **'Stopped Duration'**
  String get reportsKpiStoppedDuration;

  /// No description provided for @reportsKpiMovementDistance.
  ///
  /// In en, this message translates to:
  /// **'Movement Distance'**
  String get reportsKpiMovementDistance;

  /// No description provided for @reportsKpiStopCount.
  ///
  /// In en, this message translates to:
  /// **'Stop Count'**
  String get reportsKpiStopCount;

  /// No description provided for @reportsDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Row Details'**
  String get reportsDetailTitle;

  /// No description provided for @reportsDetailRawPayload.
  ///
  /// In en, this message translates to:
  /// **'Raw Payload'**
  String get reportsDetailRawPayload;

  /// No description provided for @reportsDetailCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get reportsDetailCopied;

  /// No description provided for @reportsDetailCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get reportsDetailCopy;

  /// No description provided for @reportsDetailTruncated.
  ///
  /// In en, this message translates to:
  /// **'Payload truncated for display. Export for full data.'**
  String get reportsDetailTruncated;

  /// No description provided for @reportsRowDetailsViewMap.
  ///
  /// In en, this message translates to:
  /// **'View Map'**
  String get reportsRowDetailsViewMap;

  /// No description provided for @reportsRowDetailsHideMap.
  ///
  /// In en, this message translates to:
  /// **'Hide Map'**
  String get reportsRowDetailsHideMap;

  /// No description provided for @reportsRowDetailsNoGps.
  ///
  /// In en, this message translates to:
  /// **'No GPS data available for this segment.'**
  String get reportsRowDetailsNoGps;

  /// No description provided for @reportsWarningBanner.
  ///
  /// In en, this message translates to:
  /// **'Warning: {message}'**
  String reportsWarningBanner(Object message);

  /// No description provided for @reportsSourceLabel.
  ///
  /// In en, this message translates to:
  /// **'Source: {source}'**
  String reportsSourceLabel(Object source);

  /// No description provided for @adminRole.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get adminRole;

  /// No description provided for @users.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get users;

  /// No description provided for @vehicles.
  ///
  /// In en, this message translates to:
  /// **'Vehicles'**
  String get vehicles;

  /// No description provided for @drivers.
  ///
  /// In en, this message translates to:
  /// **'Drivers'**
  String get drivers;

  /// No description provided for @team.
  ///
  /// In en, this message translates to:
  /// **'Team'**
  String get team;

  /// No description provided for @inventory.
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get inventory;

  /// No description provided for @map.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get map;

  /// No description provided for @transactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactions;

  /// No description provided for @calendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendar;

  /// No description provided for @logs.
  ///
  /// In en, this message translates to:
  /// **'Logs'**
  String get logs;

  /// No description provided for @plans.
  ///
  /// In en, this message translates to:
  /// **'Plans'**
  String get plans;

  /// No description provided for @roles.
  ///
  /// In en, this message translates to:
  /// **'Roles'**
  String get roles;

  /// No description provided for @smtp.
  ///
  /// In en, this message translates to:
  /// **'SMTP'**
  String get smtp;

  /// No description provided for @settingsDescription.
  ///
  /// In en, this message translates to:
  /// **'Manage profile, localization and SMTP settings.'**
  String get settingsDescription;

  /// No description provided for @localizationDescription.
  ///
  /// In en, this message translates to:
  /// **'Language, date/time, units, and default map focus.'**
  String get localizationDescription;

  /// No description provided for @whiteLabel.
  ///
  /// In en, this message translates to:
  /// **'White Label'**
  String get whiteLabel;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get saveChanges;

  /// No description provided for @textDirection.
  ///
  /// In en, this message translates to:
  /// **'Text direction'**
  String get textDirection;

  /// No description provided for @languageAndDirection.
  ///
  /// In en, this message translates to:
  /// **'Language & Direction'**
  String get languageAndDirection;

  /// No description provided for @languageAndDirectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Interface language and text direction.'**
  String get languageAndDirectionSubtitle;

  /// No description provided for @dateAndTime.
  ///
  /// In en, this message translates to:
  /// **'Date & Time'**
  String get dateAndTime;

  /// No description provided for @dateAndTimeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Date format, time style, and timezone.'**
  String get dateAndTimeSubtitle;

  /// No description provided for @unitsAndTheme.
  ///
  /// In en, this message translates to:
  /// **'Units & Theme'**
  String get unitsAndTheme;

  /// No description provided for @unitsAndThemeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Distance units and app appearance.'**
  String get unitsAndThemeSubtitle;

  /// No description provided for @defaultMapFocus.
  ///
  /// In en, this message translates to:
  /// **'Default Map Focus'**
  String get defaultMapFocus;

  /// No description provided for @defaultMapFocusSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Initial map center and zoom level.'**
  String get defaultMapFocusSubtitle;

  /// No description provided for @couldNotLoadLocalization.
  ///
  /// In en, this message translates to:
  /// **'Could not load localization.'**
  String get couldNotLoadLocalization;

  /// No description provided for @localizationSaved.
  ///
  /// In en, this message translates to:
  /// **'Localization saved'**
  String get localizationSaved;

  /// No description provided for @quickPresets.
  ///
  /// In en, this message translates to:
  /// **'Quick presets'**
  String get quickPresets;

  /// No description provided for @settingsHeaderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Profile, branding, mail, localization, and platform preferences.'**
  String get settingsHeaderSubtitle;

  /// No description provided for @localizationPreview.
  ///
  /// In en, this message translates to:
  /// **'Localization Preview'**
  String get localizationPreview;

  /// No description provided for @latitude.
  ///
  /// In en, this message translates to:
  /// **'Latitude'**
  String get latitude;

  /// No description provided for @longitude.
  ///
  /// In en, this message translates to:
  /// **'Longitude'**
  String get longitude;

  /// No description provided for @mapZoom.
  ///
  /// In en, this message translates to:
  /// **'Map Zoom'**
  String get mapZoom;

  /// No description provided for @mapCenter.
  ///
  /// In en, this message translates to:
  /// **'Map Center'**
  String get mapCenter;

  /// No description provided for @kilometers.
  ///
  /// In en, this message translates to:
  /// **'Kilometers'**
  String get kilometers;

  /// No description provided for @miles.
  ///
  /// In en, this message translates to:
  /// **'Miles'**
  String get miles;

  /// No description provided for @latitudeRequired.
  ///
  /// In en, this message translates to:
  /// **'Latitude is required.'**
  String get latitudeRequired;

  /// No description provided for @validLatitude.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid latitude.'**
  String get validLatitude;

  /// No description provided for @latitudeRange.
  ///
  /// In en, this message translates to:
  /// **'Latitude must be between -90 and 90.'**
  String get latitudeRange;

  /// No description provided for @longitudeRequired.
  ///
  /// In en, this message translates to:
  /// **'Longitude is required.'**
  String get longitudeRequired;

  /// No description provided for @validLongitude.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid longitude.'**
  String get validLongitude;

  /// No description provided for @longitudeRange.
  ///
  /// In en, this message translates to:
  /// **'Longitude must be between -180 and 180.'**
  String get longitudeRange;

  /// No description provided for @mapZoomRequired.
  ///
  /// In en, this message translates to:
  /// **'Map zoom is required.'**
  String get mapZoomRequired;

  /// No description provided for @validMapZoom.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid zoom level.'**
  String get validMapZoom;

  /// No description provided for @mapZoomRange.
  ///
  /// In en, this message translates to:
  /// **'Map zoom must be between 1 and 22.'**
  String get mapZoomRange;

  /// No description provided for @unsupportedLanguageFallback.
  ///
  /// In en, this message translates to:
  /// **'The saved language is not available in the app. Select a supported language; English is used for now.'**
  String get unsupportedLanguageFallback;

  /// No description provided for @homeWorkspace.
  ///
  /// In en, this message translates to:
  /// **'{role} workspace'**
  String homeWorkspace(Object role);

  /// No description provided for @homeAccessUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Workspace access could not be refreshed. Pull down to retry.'**
  String get homeAccessUnavailable;

  /// No description provided for @homeCopyright.
  ///
  /// In en, this message translates to:
  /// **'© 2026 Open VTS All rights reserved.'**
  String get homeCopyright;

  /// No description provided for @lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light mode'**
  String get lightMode;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get darkMode;

  /// No description provided for @landmarksStudio.
  ///
  /// In en, this message translates to:
  /// **'Landmarks Studio'**
  String get landmarksStudio;

  /// No description provided for @trackLinks.
  ///
  /// In en, this message translates to:
  /// **'Track Links'**
  String get trackLinks;

  /// No description provided for @messages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messages;

  /// No description provided for @accounts.
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get accounts;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @operations.
  ///
  /// In en, this message translates to:
  /// **'Operations'**
  String get operations;

  /// No description provided for @server.
  ///
  /// In en, this message translates to:
  /// **'Server'**
  String get server;

  /// No description provided for @trips.
  ///
  /// In en, this message translates to:
  /// **'Trips'**
  String get trips;

  /// No description provided for @documents.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get documents;

  /// No description provided for @userRole.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get userRole;

  /// No description provided for @subuserRole.
  ///
  /// In en, this message translates to:
  /// **'Subuser'**
  String get subuserRole;

  /// No description provided for @driverRole.
  ///
  /// In en, this message translates to:
  /// **'Driver'**
  String get driverRole;

  /// No description provided for @superadminRole.
  ///
  /// In en, this message translates to:
  /// **'Superadmin'**
  String get superadminRole;

  /// No description provided for @demoReadOnly.
  ///
  /// In en, this message translates to:
  /// **'Demo • Read-only'**
  String get demoReadOnly;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @routeBuilderCreate.
  ///
  /// In en, this message translates to:
  /// **'Create route'**
  String get routeBuilderCreate;

  /// No description provided for @routeBuilderEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit route'**
  String get routeBuilderEdit;

  /// No description provided for @routeBuilderName.
  ///
  /// In en, this message translates to:
  /// **'Route name'**
  String get routeBuilderName;

  /// No description provided for @routeBuilderNameHint.
  ///
  /// In en, this message translates to:
  /// **'For example, morning deliveries'**
  String get routeBuilderNameHint;

  /// No description provided for @routeBuilderNameError.
  ///
  /// In en, this message translates to:
  /// **'Enter a route name with at least 2 characters.'**
  String get routeBuilderNameError;

  /// No description provided for @routeBuilderStops.
  ///
  /// In en, this message translates to:
  /// **'Stops'**
  String get routeBuilderStops;

  /// No description provided for @routeBuilderAddStop.
  ///
  /// In en, this message translates to:
  /// **'Add stop'**
  String get routeBuilderAddStop;

  /// No description provided for @routeBuilderEditStop.
  ///
  /// In en, this message translates to:
  /// **'Edit stop'**
  String get routeBuilderEditStop;

  /// No description provided for @routeBuilderStopName.
  ///
  /// In en, this message translates to:
  /// **'Stop name'**
  String get routeBuilderStopName;

  /// No description provided for @routeBuilderStopNameError.
  ///
  /// In en, this message translates to:
  /// **'Enter a name between 1 and 160 characters.'**
  String get routeBuilderStopNameError;

  /// No description provided for @routeBuilderAddress.
  ///
  /// In en, this message translates to:
  /// **'Address (optional)'**
  String get routeBuilderAddress;

  /// No description provided for @routeBuilderCoordinates.
  ///
  /// In en, this message translates to:
  /// **'Coordinates'**
  String get routeBuilderCoordinates;

  /// No description provided for @routeBuilderLatitude.
  ///
  /// In en, this message translates to:
  /// **'Latitude'**
  String get routeBuilderLatitude;

  /// No description provided for @routeBuilderLongitude.
  ///
  /// In en, this message translates to:
  /// **'Longitude'**
  String get routeBuilderLongitude;

  /// No description provided for @routeBuilderCoordinateError.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid latitude (−90 to 90) and longitude (−180 to 180).'**
  String get routeBuilderCoordinateError;

  /// No description provided for @routeBuilderMap.
  ///
  /// In en, this message translates to:
  /// **'Choose on map'**
  String get routeBuilderMap;

  /// No description provided for @routeBuilderMapHint.
  ///
  /// In en, this message translates to:
  /// **'Tap the map to choose a stop location.'**
  String get routeBuilderMapHint;

  /// No description provided for @routeBuilderUseLocation.
  ///
  /// In en, this message translates to:
  /// **'Use location'**
  String get routeBuilderUseLocation;

  /// No description provided for @routeBuilderPoi.
  ///
  /// In en, this message translates to:
  /// **'Point of interest'**
  String get routeBuilderPoi;

  /// No description provided for @routeBuilderGeofence.
  ///
  /// In en, this message translates to:
  /// **'Geofence'**
  String get routeBuilderGeofence;

  /// No description provided for @routeBuilderLandmarkSearch.
  ///
  /// In en, this message translates to:
  /// **'Search saved landmarks'**
  String get routeBuilderLandmarkSearch;

  /// No description provided for @routeBuilderNoLandmarks.
  ///
  /// In en, this message translates to:
  /// **'No matching landmarks with valid coordinates.'**
  String get routeBuilderNoLandmarks;

  /// No description provided for @routeBuilderLandmarkError.
  ///
  /// In en, this message translates to:
  /// **'Could not load saved landmarks. Please try again.'**
  String get routeBuilderLandmarkError;

  /// No description provided for @routeBuilderStopLimit.
  ///
  /// In en, this message translates to:
  /// **'A route can contain up to 100 stops, including the return stop.'**
  String get routeBuilderStopLimit;

  /// No description provided for @routeBuilderMinimumStops.
  ///
  /// In en, this message translates to:
  /// **'Add at least 2 distinct stops.'**
  String get routeBuilderMinimumStops;

  /// No description provided for @routeBuilderRoundTrip.
  ///
  /// In en, this message translates to:
  /// **'Return to start'**
  String get routeBuilderRoundTrip;

  /// No description provided for @routeBuilderRoundTripHint.
  ///
  /// In en, this message translates to:
  /// **'Add the starting point as the final destination.'**
  String get routeBuilderRoundTripHint;

  /// No description provided for @routeBuilderOptimize.
  ///
  /// In en, this message translates to:
  /// **'Optimize order'**
  String get routeBuilderOptimize;

  /// No description provided for @routeBuilderOptimizeHint.
  ///
  /// In en, this message translates to:
  /// **'Reorders stops using geographic distance, keeping your start and destination. Road distance is calculated separately.'**
  String get routeBuilderOptimizeHint;

  /// No description provided for @routeBuilderRoadPath.
  ///
  /// In en, this message translates to:
  /// **'Preview road path'**
  String get routeBuilderRoadPath;

  /// No description provided for @routeBuilderRouting.
  ///
  /// In en, this message translates to:
  /// **'Calculating driving route…'**
  String get routeBuilderRouting;

  /// No description provided for @routeBuilderRoutingError.
  ///
  /// In en, this message translates to:
  /// **'No driving route is available. Check the stop locations or your connection, then try again.'**
  String get routeBuilderRoutingError;

  /// No description provided for @routeBuilderReady.
  ///
  /// In en, this message translates to:
  /// **'Driving route ready'**
  String get routeBuilderReady;

  /// No description provided for @routeBuilderChanged.
  ///
  /// In en, this message translates to:
  /// **'Stops changed. Preview the new driving route before saving.'**
  String get routeBuilderChanged;

  /// No description provided for @routeBuilderSaveError.
  ///
  /// In en, this message translates to:
  /// **'Could not save the route. Please try again.'**
  String get routeBuilderSaveError;

  /// No description provided for @routeBuilderAccessDenied.
  ///
  /// In en, this message translates to:
  /// **'You do not have permission to create or edit routes.'**
  String get routeBuilderAccessDenied;

  /// No description provided for @routeBuilderOrigin.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get routeBuilderOrigin;

  /// No description provided for @routeBuilderDestination.
  ///
  /// In en, this message translates to:
  /// **'Destination'**
  String get routeBuilderDestination;

  /// No description provided for @routeBuilderWaypoint.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get routeBuilderWaypoint;

  /// No description provided for @routeBuilderShapePoint.
  ///
  /// In en, this message translates to:
  /// **'Route shape'**
  String get routeBuilderShapePoint;

  /// No description provided for @routeBuilderMoveUp.
  ///
  /// In en, this message translates to:
  /// **'Move earlier'**
  String get routeBuilderMoveUp;

  /// No description provided for @routeBuilderMoveDown.
  ///
  /// In en, this message translates to:
  /// **'Move later'**
  String get routeBuilderMoveDown;

  /// No description provided for @routeBuilderRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove stop'**
  String get routeBuilderRemove;

  /// No description provided for @routeBuilderNoStops.
  ///
  /// In en, this message translates to:
  /// **'Add your starting point and destination, then any stops along the way.'**
  String get routeBuilderNoStops;

  /// No description provided for @routeBuilderSavedGeometry.
  ///
  /// In en, this message translates to:
  /// **'Saved route path'**
  String get routeBuilderSavedGeometry;

  /// No description provided for @routeBuilderEditingLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load the complete route. Go back and try again.'**
  String get routeBuilderEditingLoadError;

  /// No description provided for @routeBuilderDiscardTitle.
  ///
  /// In en, this message translates to:
  /// **'Discard route changes?'**
  String get routeBuilderDiscardTitle;

  /// No description provided for @routeBuilderDiscardMessage.
  ///
  /// In en, this message translates to:
  /// **'Your unsaved route changes will be lost.'**
  String get routeBuilderDiscardMessage;

  /// No description provided for @routeBuilderDiscard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get routeBuilderDiscard;

  /// No description provided for @routeBuilderKeepEditing.
  ///
  /// In en, this message translates to:
  /// **'Keep editing'**
  String get routeBuilderKeepEditing;

  /// No description provided for @routeBuilderClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get routeBuilderClose;

  /// No description provided for @routeBuilderRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get routeBuilderRetry;

  /// No description provided for @routeBuilderMapAttribution.
  ///
  /// In en, this message translates to:
  /// **'© OpenStreetMap contributors · Routing: OSRM'**
  String get routeBuilderMapAttribution;

  /// No description provided for @routeBuilderRouteDetails.
  ///
  /// In en, this message translates to:
  /// **'Route details'**
  String get routeBuilderRouteDetails;

  /// No description provided for @routeBuilderMinutes.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get routeBuilderMinutes;

  /// No description provided for @routeBuilderDistanceUnit.
  ///
  /// In en, this message translates to:
  /// **'km'**
  String get routeBuilderDistanceUnit;

  /// No description provided for @routeBuilderChooseSource.
  ///
  /// In en, this message translates to:
  /// **'Add a stop from'**
  String get routeBuilderChooseSource;

  /// No description provided for @routeBuilderLandmarksPermission.
  ///
  /// In en, this message translates to:
  /// **'Saved landmarks require the Landmarks permission.'**
  String get routeBuilderLandmarksPermission;

  /// No description provided for @routeBuilderShapeHint.
  ///
  /// In en, this message translates to:
  /// **'Shape points guide the road path. They are not delivery stops. Optimizing removes shape points.'**
  String get routeBuilderShapeHint;

  /// No description provided for @routeBuilderGeofenceHint.
  ///
  /// In en, this message translates to:
  /// **'Uses the geofence centre. Confirm that it is reachable by road.'**
  String get routeBuilderGeofenceHint;

  /// No description provided for @selectField.
  ///
  /// In en, this message translates to:
  /// **'Select {field}'**
  String selectField(Object field);

  /// No description provided for @searchField.
  ///
  /// In en, this message translates to:
  /// **'Search {field}'**
  String searchField(Object field);

  /// No description provided for @noMatchingField.
  ///
  /// In en, this message translates to:
  /// **'No matching {field}'**
  String noMatchingField(Object field);

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'{field} is required.'**
  String fieldRequired(Object field);

  /// No description provided for @clearSelection.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clearSelection;

  /// No description provided for @clearSearch.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get clearSearch;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No results'**
  String get noResults;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @unableToLoad.
  ///
  /// In en, this message translates to:
  /// **'Unable to load'**
  String get unableToLoad;

  /// No description provided for @mobileApiToken.
  ///
  /// In en, this message translates to:
  /// **'API token'**
  String get mobileApiToken;

  /// No description provided for @mobileTokenOnce.
  ///
  /// In en, this message translates to:
  /// **'This token is shown only once. Store it securely. Anyone with it can access the selected API permissions.'**
  String get mobileTokenOnce;

  /// No description provided for @mobileSaveRecovery.
  ///
  /// In en, this message translates to:
  /// **'Save your recovery codes'**
  String get mobileSaveRecovery;

  /// No description provided for @mobileRecoveryHelp.
  ///
  /// In en, this message translates to:
  /// **'Each code works once if you lose your authenticator. These replace previous recovery codes. Keep them in a safe place.'**
  String get mobileRecoveryHelp;

  /// No description provided for @mobileCopiedSecurely.
  ///
  /// In en, this message translates to:
  /// **'Copied. Store this securely.'**
  String get mobileCopiedSecurely;

  /// No description provided for @mobileSavedSecurely.
  ///
  /// In en, this message translates to:
  /// **'I have saved this securely'**
  String get mobileSavedSecurely;

  /// No description provided for @mobileDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get mobileDone;

  /// No description provided for @mobileRevokeTokenQuestion.
  ///
  /// In en, this message translates to:
  /// **'Revoke API token?'**
  String get mobileRevokeTokenQuestion;

  /// No description provided for @mobileTokenStops.
  ///
  /// In en, this message translates to:
  /// **'{name} will stop working immediately.'**
  String mobileTokenStops(Object name);

  /// No description provided for @mobileRevoke.
  ///
  /// In en, this message translates to:
  /// **'Revoke'**
  String get mobileRevoke;

  /// No description provided for @mobileMfa.
  ///
  /// In en, this message translates to:
  /// **'Multi-factor authentication'**
  String get mobileMfa;

  /// No description provided for @mobileMfaOn.
  ///
  /// In en, this message translates to:
  /// **'MFA is on'**
  String get mobileMfaOn;

  /// No description provided for @mobileMfaOff.
  ///
  /// In en, this message translates to:
  /// **'MFA is off'**
  String get mobileMfaOff;

  /// No description provided for @mobileMfaHelp.
  ///
  /// In en, this message translates to:
  /// **'Protect sign-in with your authenticator app.'**
  String get mobileMfaHelp;

  /// No description provided for @mobileSecuritySessions.
  ///
  /// In en, this message translates to:
  /// **'Security changes sign out other sessions and invalidate existing API tokens.'**
  String get mobileSecuritySessions;

  /// No description provided for @mobileAddedDate.
  ///
  /// In en, this message translates to:
  /// **'Added {date}'**
  String mobileAddedDate(Object date);

  /// No description provided for @mobileRemoveAuthenticator.
  ///
  /// In en, this message translates to:
  /// **'Remove authenticator'**
  String get mobileRemoveAuthenticator;

  /// No description provided for @mobileAddAuthenticator.
  ///
  /// In en, this message translates to:
  /// **'Add authenticator'**
  String get mobileAddAuthenticator;

  /// No description provided for @mobileSetupMfa.
  ///
  /// In en, this message translates to:
  /// **'Set up MFA'**
  String get mobileSetupMfa;

  /// No description provided for @mobileRecoveryRemaining.
  ///
  /// In en, this message translates to:
  /// **'{count} unused recovery codes'**
  String mobileRecoveryRemaining(Object count);

  /// No description provided for @mobileReplaceRecovery.
  ///
  /// In en, this message translates to:
  /// **'Replace recovery codes'**
  String get mobileReplaceRecovery;

  /// No description provided for @mobileTurnOffMfa.
  ///
  /// In en, this message translates to:
  /// **'Turn off MFA'**
  String get mobileTurnOffMfa;

  /// No description provided for @mobileApiAccess.
  ///
  /// In en, this message translates to:
  /// **'API access'**
  String get mobileApiAccess;

  /// No description provided for @mobileApiHelp.
  ///
  /// In en, this message translates to:
  /// **'Create credentials for integrations with the permissions of your account.'**
  String get mobileApiHelp;

  /// No description provided for @mobileReadWrite.
  ///
  /// In en, this message translates to:
  /// **'Read and write'**
  String get mobileReadWrite;

  /// No description provided for @mobileReadOnly.
  ///
  /// In en, this message translates to:
  /// **'Read only'**
  String get mobileReadOnly;

  /// No description provided for @mobileExpires.
  ///
  /// In en, this message translates to:
  /// **'Expires'**
  String get mobileExpires;

  /// No description provided for @mobileInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get mobileInactive;

  /// No description provided for @mobileRevokeToken.
  ///
  /// In en, this message translates to:
  /// **'Revoke token'**
  String get mobileRevokeToken;

  /// No description provided for @mobileCreateToken.
  ///
  /// In en, this message translates to:
  /// **'Create API token'**
  String get mobileCreateToken;

  /// No description provided for @mobileDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get mobileDeleteAccount;

  /// No description provided for @mobileDeleteWorkspaceHelp.
  ///
  /// In en, this message translates to:
  /// **'Delete your account and its workspace access, including subusers. All sessions will end. This action cannot be undone in the app.'**
  String get mobileDeleteWorkspaceHelp;

  /// No description provided for @mobileDeleteSelfHelp.
  ///
  /// In en, this message translates to:
  /// **'Delete your account and end its sessions. This action cannot be undone in the app.'**
  String get mobileDeleteSelfHelp;

  /// No description provided for @mobileDeleteMyAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete my account'**
  String get mobileDeleteMyAccount;

  /// No description provided for @mobilePasswordOnly.
  ///
  /// In en, this message translates to:
  /// **'Future sign-ins will need only your password.'**
  String get mobilePasswordOnly;

  /// No description provided for @mobileRecoveryReplaced.
  ///
  /// In en, this message translates to:
  /// **'Your previous recovery codes will stop working.'**
  String get mobileRecoveryReplaced;

  /// No description provided for @mobileTokenName.
  ///
  /// In en, this message translates to:
  /// **'Token name'**
  String get mobileTokenName;

  /// No description provided for @mobileAuthenticatorName.
  ///
  /// In en, this message translates to:
  /// **'Authenticator name'**
  String get mobileAuthenticatorName;

  /// No description provided for @mobileEnterName.
  ///
  /// In en, this message translates to:
  /// **'Enter a name.'**
  String get mobileEnterName;

  /// No description provided for @mobileAccess.
  ///
  /// In en, this message translates to:
  /// **'Access'**
  String get mobileAccess;

  /// No description provided for @mobileExpiresAfter.
  ///
  /// In en, this message translates to:
  /// **'Expires after'**
  String get mobileExpiresAfter;

  /// No description provided for @mobileDays.
  ///
  /// In en, this message translates to:
  /// **'{count} days'**
  String mobileDays(Object count);

  /// No description provided for @mobileCurrentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get mobileCurrentPassword;

  /// No description provided for @mobileEnterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password.'**
  String get mobileEnterPassword;

  /// No description provided for @mobileAuthenticatorOrRecovery.
  ///
  /// In en, this message translates to:
  /// **'Authenticator or recovery code'**
  String get mobileAuthenticatorOrRecovery;

  /// No description provided for @mobileEnterVerification.
  ///
  /// In en, this message translates to:
  /// **'Enter your verification code.'**
  String get mobileEnterVerification;

  /// No description provided for @mobileDeleteConfirmation.
  ///
  /// In en, this message translates to:
  /// **'I understand that my account and workspace access will be deleted.'**
  String get mobileDeleteConfirmation;

  /// No description provided for @mobileContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get mobileContinue;

  /// No description provided for @mobileSixDigits.
  ///
  /// In en, this message translates to:
  /// **'Enter all six digits.'**
  String get mobileSixDigits;

  /// No description provided for @mobileConnectAuthenticator.
  ///
  /// In en, this message translates to:
  /// **'Connect your authenticator'**
  String get mobileConnectAuthenticator;

  /// No description provided for @mobileScanQrHelp.
  ///
  /// In en, this message translates to:
  /// **'Scan the QR code on another device, or copy the setup key into your authenticator app. Setup expires in 10 minutes.'**
  String get mobileScanQrHelp;

  /// No description provided for @mobileCopySetup.
  ///
  /// In en, this message translates to:
  /// **'Copy setup key'**
  String get mobileCopySetup;

  /// No description provided for @mobileNewAuthenticatorCode.
  ///
  /// In en, this message translates to:
  /// **'New authenticator code'**
  String get mobileNewAuthenticatorCode;

  /// No description provided for @mobileVerifying.
  ///
  /// In en, this message translates to:
  /// **'Verifying…'**
  String get mobileVerifying;

  /// No description provided for @mobileConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get mobileConfirm;

  /// No description provided for @mobileVerifySignIn.
  ///
  /// In en, this message translates to:
  /// **'Verify your sign-in'**
  String get mobileVerifySignIn;

  /// No description provided for @mobileUnusedRecovery.
  ///
  /// In en, this message translates to:
  /// **'Enter one of your unused recovery codes.'**
  String get mobileUnusedRecovery;

  /// No description provided for @mobileAuthenticatorInstructions.
  ///
  /// In en, this message translates to:
  /// **'Enter the six-digit code from your authenticator app.'**
  String get mobileAuthenticatorInstructions;

  /// No description provided for @mobileRecoveryCode.
  ///
  /// In en, this message translates to:
  /// **'Recovery code'**
  String get mobileRecoveryCode;

  /// No description provided for @mobileAuthenticatorCode.
  ///
  /// In en, this message translates to:
  /// **'Authenticator code'**
  String get mobileAuthenticatorCode;

  /// No description provided for @mobileCompleteRecovery.
  ///
  /// In en, this message translates to:
  /// **'Enter a complete recovery code.'**
  String get mobileCompleteRecovery;

  /// No description provided for @mobileVerifyAndSignIn.
  ///
  /// In en, this message translates to:
  /// **'Verify and sign in'**
  String get mobileVerifyAndSignIn;

  /// No description provided for @mobileUseAuthenticator.
  ///
  /// In en, this message translates to:
  /// **'Use authenticator code'**
  String get mobileUseAuthenticator;

  /// No description provided for @mobileUseRecovery.
  ///
  /// In en, this message translates to:
  /// **'Use recovery code'**
  String get mobileUseRecovery;

  /// No description provided for @mobileBackSignIn.
  ///
  /// In en, this message translates to:
  /// **'Back to sign in'**
  String get mobileBackSignIn;

  /// No description provided for @mobileName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get mobileName;

  /// No description provided for @mobileCallingCode.
  ///
  /// In en, this message translates to:
  /// **'Country calling code'**
  String get mobileCallingCode;

  /// No description provided for @mobileMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Mobile number'**
  String get mobileMobileNumber;

  /// No description provided for @mobileAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get mobileAddress;

  /// No description provided for @mobileCountry.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get mobileCountry;

  /// No description provided for @mobileState.
  ///
  /// In en, this message translates to:
  /// **'State / Province'**
  String get mobileState;

  /// No description provided for @mobileCity.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get mobileCity;

  /// No description provided for @mobilePostcode.
  ///
  /// In en, this message translates to:
  /// **'Postal code'**
  String get mobilePostcode;

  /// No description provided for @mobileChangePassword.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get mobileChangePassword;

  /// No description provided for @mobileRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required.'**
  String get mobileRequired;

  /// No description provided for @mobileValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid English email address.'**
  String get mobileValidEmail;

  /// No description provided for @mobilePasswordSessions.
  ///
  /// In en, this message translates to:
  /// **'Changing your password signs you out of all sessions.'**
  String get mobilePasswordSessions;

  /// No description provided for @mobileNewPassword.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get mobileNewPassword;

  /// No description provided for @mobilePasswordCharacters.
  ///
  /// In en, this message translates to:
  /// **'Use 6–72 English characters.'**
  String get mobilePasswordCharacters;

  /// No description provided for @mobileDifferentPassword.
  ///
  /// In en, this message translates to:
  /// **'Choose a different password.'**
  String get mobileDifferentPassword;

  /// No description provided for @mobileConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm new password'**
  String get mobileConfirmPassword;

  /// No description provided for @mobilePasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match.'**
  String get mobilePasswordMismatch;

  /// No description provided for @mobileChangesSaved.
  ///
  /// In en, this message translates to:
  /// **'Changes saved'**
  String get mobileChangesSaved;

  /// No description provided for @mobileLanguageCodeHelp.
  ///
  /// In en, this message translates to:
  /// **'Enter a language code such as en or hi.'**
  String get mobileLanguageCodeHelp;

  /// No description provided for @mobileReload.
  ///
  /// In en, this message translates to:
  /// **'Reload'**
  String get mobileReload;

  /// No description provided for @mobileEnterYourName.
  ///
  /// In en, this message translates to:
  /// **'Enter your name.'**
  String get mobileEnterYourName;

  /// No description provided for @mobileEnterCallingCode.
  ///
  /// In en, this message translates to:
  /// **'Enter a calling code.'**
  String get mobileEnterCallingCode;

  /// No description provided for @mobileValidMobile.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid mobile number.'**
  String get mobileValidMobile;

  /// No description provided for @mobileSaveProfile.
  ///
  /// In en, this message translates to:
  /// **'Save profile'**
  String get mobileSaveProfile;

  /// No description provided for @mobileDisplayPreferences.
  ///
  /// In en, this message translates to:
  /// **'Display preferences'**
  String get mobileDisplayPreferences;

  /// No description provided for @mobileDateFormat.
  ///
  /// In en, this message translates to:
  /// **'Date format'**
  String get mobileDateFormat;

  /// No description provided for @mobileTimeFormat.
  ///
  /// In en, this message translates to:
  /// **'Time format'**
  String get mobileTimeFormat;

  /// No description provided for @mobileDistanceUnit.
  ///
  /// In en, this message translates to:
  /// **'Distance unit'**
  String get mobileDistanceUnit;

  /// No description provided for @mobileTextDirection.
  ///
  /// In en, this message translates to:
  /// **'Text direction'**
  String get mobileTextDirection;

  /// No description provided for @mobileTimeOffset.
  ///
  /// In en, this message translates to:
  /// **'Time zone offset'**
  String get mobileTimeOffset;

  /// No description provided for @mobileLanguageCode.
  ///
  /// In en, this message translates to:
  /// **'Language code'**
  String get mobileLanguageCode;

  /// No description provided for @mobileSavePreferences.
  ///
  /// In en, this message translates to:
  /// **'Save preferences'**
  String get mobileSavePreferences;

  /// No description provided for @mobileProofAccountChanged.
  ///
  /// In en, this message translates to:
  /// **'Account access changed. Reopen this trip proof.'**
  String get mobileProofAccountChanged;

  /// No description provided for @mobileActivity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get mobileActivity;

  /// No description provided for @mobileAllStatuses.
  ///
  /// In en, this message translates to:
  /// **'All statuses'**
  String get mobileAllStatuses;

  /// No description provided for @mobileApproximateRoute.
  ///
  /// In en, this message translates to:
  /// **'Approximate stop sequence • numbered stops'**
  String get mobileApproximateRoute;

  /// No description provided for @mobileAttention.
  ///
  /// In en, this message translates to:
  /// **'Attention'**
  String get mobileAttention;

  /// No description provided for @mobileChooseRoute.
  ///
  /// In en, this message translates to:
  /// **'Choose a route'**
  String get mobileChooseRoute;

  /// No description provided for @mobileValidSchedule.
  ///
  /// In en, this message translates to:
  /// **'Choose a valid schedule.'**
  String get mobileValidSchedule;

  /// No description provided for @mobileValidStartTime.
  ///
  /// In en, this message translates to:
  /// **'Choose a valid start time.'**
  String get mobileValidStartTime;

  /// No description provided for @mobileChooseVehicle.
  ///
  /// In en, this message translates to:
  /// **'Choose a vehicle'**
  String get mobileChooseVehicle;

  /// No description provided for @mobileChooseVehicleRoute.
  ///
  /// In en, this message translates to:
  /// **'Choose a vehicle and route.'**
  String get mobileChooseVehicleRoute;

  /// No description provided for @mobileChooseEligibleVehicle.
  ///
  /// In en, this message translates to:
  /// **'Choose an eligible vehicle'**
  String get mobileChooseEligibleVehicle;

  /// No description provided for @mobileEndDateAfterStart.
  ///
  /// In en, this message translates to:
  /// **'Choose an end date on or after the start date.'**
  String get mobileEndDateAfterStart;

  /// No description provided for @mobileChooseWeekday.
  ///
  /// In en, this message translates to:
  /// **'Choose at least one weekday.'**
  String get mobileChooseWeekday;

  /// No description provided for @mobileChooseDate.
  ///
  /// In en, this message translates to:
  /// **'Choose date'**
  String get mobileChooseDate;

  /// No description provided for @mobileChooseDateRange.
  ///
  /// In en, this message translates to:
  /// **'Choose date range'**
  String get mobileChooseDateRange;

  /// No description provided for @mobileChooseDay.
  ///
  /// In en, this message translates to:
  /// **'Choose day'**
  String get mobileChooseDay;

  /// No description provided for @mobileMultiDayHelp.
  ///
  /// In en, this message translates to:
  /// **'Choose the start and completion date and time for a multi-day trip.'**
  String get mobileMultiDayHelp;

  /// No description provided for @mobileFutureDate.
  ///
  /// In en, this message translates to:
  /// **'Choose today or a later date.'**
  String get mobileFutureDate;

  /// No description provided for @mobileCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get mobileCompleted;

  /// No description provided for @mobileCompletionAfterStart.
  ///
  /// In en, this message translates to:
  /// **'Completion must be after the start.'**
  String get mobileCompletionAfterStart;

  /// No description provided for @mobileCreateRouteFirst.
  ///
  /// In en, this message translates to:
  /// **'Create a route to start planning.'**
  String get mobileCreateRouteFirst;

  /// No description provided for @mobileCreateSchedule.
  ///
  /// In en, this message translates to:
  /// **'Create schedule'**
  String get mobileCreateSchedule;

  /// No description provided for @mobileCreateTrip.
  ///
  /// In en, this message translates to:
  /// **'Create trip'**
  String get mobileCreateTrip;

  /// No description provided for @mobileDeleteSchedule.
  ///
  /// In en, this message translates to:
  /// **'Delete schedule'**
  String get mobileDeleteSchedule;

  /// No description provided for @mobileDiscardChanges.
  ///
  /// In en, this message translates to:
  /// **'Discard changes'**
  String get mobileDiscardChanges;

  /// No description provided for @mobileDiscardTrip.
  ///
  /// In en, this message translates to:
  /// **'Discard trip changes?'**
  String get mobileDiscardTrip;

  /// No description provided for @mobileEditRecurring.
  ///
  /// In en, this message translates to:
  /// **'Edit recurring schedule'**
  String get mobileEditRecurring;

  /// No description provided for @mobileEditSchedule.
  ///
  /// In en, this message translates to:
  /// **'Edit schedule'**
  String get mobileEditSchedule;

  /// No description provided for @mobileEndDate.
  ///
  /// In en, this message translates to:
  /// **'End date'**
  String get mobileEndDate;

  /// No description provided for @mobileEndSchedule.
  ///
  /// In en, this message translates to:
  /// **'End schedule'**
  String get mobileEndSchedule;

  /// No description provided for @mobileEndTime.
  ///
  /// In en, this message translates to:
  /// **'End time'**
  String get mobileEndTime;

  /// No description provided for @mobileEndTimeAfterStart.
  ///
  /// In en, this message translates to:
  /// **'End time must be later than start time.'**
  String get mobileEndTimeAfterStart;

  /// No description provided for @mobileEndsOptional.
  ///
  /// In en, this message translates to:
  /// **'Ends (optional)'**
  String get mobileEndsOptional;

  /// No description provided for @mobileTripTitleLength.
  ///
  /// In en, this message translates to:
  /// **'Enter a title between 2 and 120 characters.'**
  String get mobileTripTitleLength;

  /// No description provided for @mobileAtLeastTwo.
  ///
  /// In en, this message translates to:
  /// **'Enter at least 2 characters'**
  String get mobileAtLeastTwo;

  /// No description provided for @mobileAtLeastThree.
  ///
  /// In en, this message translates to:
  /// **'Enter at least 3 characters'**
  String get mobileAtLeastThree;

  /// No description provided for @mobileExpandRoute.
  ///
  /// In en, this message translates to:
  /// **'Expand route map'**
  String get mobileExpandRoute;

  /// No description provided for @mobileFitRoute.
  ///
  /// In en, this message translates to:
  /// **'Fit route'**
  String get mobileFitRoute;

  /// No description provided for @mobileNoGpsPlanning.
  ///
  /// In en, this message translates to:
  /// **'GPS is not linked. The trip can be planned, but live tracking will be unavailable.'**
  String get mobileNoGpsPlanning;

  /// No description provided for @mobileKeepEditing.
  ///
  /// In en, this message translates to:
  /// **'Keep editing'**
  String get mobileKeepEditing;

  /// No description provided for @mobileKeepSchedule.
  ///
  /// In en, this message translates to:
  /// **'Keep schedule'**
  String get mobileKeepSchedule;

  /// No description provided for @mobileLastKnownPosition.
  ///
  /// In en, this message translates to:
  /// **'Last known vehicle position'**
  String get mobileLastKnownPosition;

  /// No description provided for @mobileLatestStart.
  ///
  /// In en, this message translates to:
  /// **'Latest start time'**
  String get mobileLatestStart;

  /// No description provided for @mobileNextMonth.
  ///
  /// In en, this message translates to:
  /// **'Next month'**
  String get mobileNextMonth;

  /// No description provided for @mobileNoEligible.
  ///
  /// In en, this message translates to:
  /// **'No eligible vehicle is available.'**
  String get mobileNoEligible;

  /// No description provided for @mobileNoEligibleHelp.
  ///
  /// In en, this message translates to:
  /// **'No eligible vehicle is available. Assign an active driver to an active vehicle before planning.'**
  String get mobileNoEligibleHelp;

  /// No description provided for @mobileNoRecordsView.
  ///
  /// In en, this message translates to:
  /// **'No records for this view.'**
  String get mobileNoRecordsView;

  /// No description provided for @mobileNoRouteGps.
  ///
  /// In en, this message translates to:
  /// **'No route or GPS coordinates are available for this trip.'**
  String get mobileNoRouteGps;

  /// No description provided for @mobileStopsWithoutGeometry.
  ///
  /// In en, this message translates to:
  /// **'Numbered stops • route geometry unavailable'**
  String get mobileStopsWithoutGeometry;

  /// No description provided for @mobilePause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get mobilePause;

  /// No description provided for @mobilePlanTrip.
  ///
  /// In en, this message translates to:
  /// **'Plan trip'**
  String get mobilePlanTrip;

  /// No description provided for @mobilePlannedNumbered.
  ///
  /// In en, this message translates to:
  /// **'Planned route • numbered stops'**
  String get mobilePlannedNumbered;

  /// No description provided for @mobilePreviousMonth.
  ///
  /// In en, this message translates to:
  /// **'Previous month'**
  String get mobilePreviousMonth;

  /// No description provided for @mobileReasonRemark.
  ///
  /// In en, this message translates to:
  /// **'Reason / remark'**
  String get mobileReasonRemark;

  /// No description provided for @mobileRecurring.
  ///
  /// In en, this message translates to:
  /// **'Recurring'**
  String get mobileRecurring;

  /// No description provided for @mobileRecurringSchedule.
  ///
  /// In en, this message translates to:
  /// **'Recurring schedule'**
  String get mobileRecurringSchedule;

  /// No description provided for @mobileRecurringActions.
  ///
  /// In en, this message translates to:
  /// **'Recurring schedule actions'**
  String get mobileRecurringActions;

  /// No description provided for @mobileRefreshPlanning.
  ///
  /// In en, this message translates to:
  /// **'Refresh planning options'**
  String get mobileRefreshPlanning;

  /// No description provided for @mobileRefreshSchedule.
  ///
  /// In en, this message translates to:
  /// **'Refresh this schedule before editing it.'**
  String get mobileRefreshSchedule;

  /// No description provided for @mobileRemarkOptional.
  ///
  /// In en, this message translates to:
  /// **'Remark (optional)'**
  String get mobileRemarkOptional;

  /// No description provided for @mobileRemoveEndDate.
  ///
  /// In en, this message translates to:
  /// **'Remove end date'**
  String get mobileRemoveEndDate;

  /// No description provided for @mobileRepeatOn.
  ///
  /// In en, this message translates to:
  /// **'Repeat on'**
  String get mobileRepeatOn;

  /// No description provided for @mobileResume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get mobileResume;

  /// No description provided for @mobileRoute.
  ///
  /// In en, this message translates to:
  /// **'Route'**
  String get mobileRoute;

  /// No description provided for @mobileRunning.
  ///
  /// In en, this message translates to:
  /// **'Running'**
  String get mobileRunning;

  /// No description provided for @mobileSaveShareProof.
  ///
  /// In en, this message translates to:
  /// **'Save or share proof'**
  String get mobileSaveShareProof;

  /// No description provided for @mobileSaveSchedule.
  ///
  /// In en, this message translates to:
  /// **'Save schedule'**
  String get mobileSaveSchedule;

  /// No description provided for @mobileSchedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get mobileSchedule;

  /// No description provided for @mobileScheduleSaved.
  ///
  /// In en, this message translates to:
  /// **'Schedule saved'**
  String get mobileScheduleSaved;

  /// No description provided for @mobileSearchRoutes.
  ///
  /// In en, this message translates to:
  /// **'Search routes'**
  String get mobileSearchRoutes;

  /// No description provided for @mobileSearchVehicleDriver.
  ///
  /// In en, this message translates to:
  /// **'Search vehicle, plate or driver'**
  String get mobileSearchVehicleDriver;

  /// No description provided for @mobileSkipDates.
  ///
  /// In en, this message translates to:
  /// **'Skip dates (optional)'**
  String get mobileSkipDates;

  /// No description provided for @mobileSkipDatesRange.
  ///
  /// In en, this message translates to:
  /// **'Skip dates must be inside the schedule date range.'**
  String get mobileSkipDatesRange;

  /// No description provided for @mobileStartTime.
  ///
  /// In en, this message translates to:
  /// **'Start time'**
  String get mobileStartTime;

  /// No description provided for @mobileStarts.
  ///
  /// In en, this message translates to:
  /// **'Starts'**
  String get mobileStarts;

  /// No description provided for @mobileStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get mobileStatus;

  /// No description provided for @mobileSubmittedProofs.
  ///
  /// In en, this message translates to:
  /// **'Submitted proofs'**
  String get mobileSubmittedProofs;

  /// No description provided for @mobileAnyTimeDay.
  ///
  /// In en, this message translates to:
  /// **'The driver can start any time on the selected day.'**
  String get mobileAnyTimeDay;

  /// No description provided for @mobileStartWindowHelp.
  ///
  /// In en, this message translates to:
  /// **'The driver can start within this time window. The end of the window is not the trip completion time.'**
  String get mobileStartWindowHelp;

  /// No description provided for @mobileRequestFailed.
  ///
  /// In en, this message translates to:
  /// **'The request could not be completed. Please refresh and try again.'**
  String get mobileRequestFailed;

  /// No description provided for @mobileRouteUnavailable.
  ///
  /// In en, this message translates to:
  /// **'The saved route is unavailable for planning. Refresh routes and try again.'**
  String get mobileRouteUnavailable;

  /// No description provided for @mobileAccountTimeHelp.
  ///
  /// In en, this message translates to:
  /// **'The trip starts at a specific time in the account timezone.'**
  String get mobileAccountTimeHelp;

  /// No description provided for @mobilePdfPreviewFailed.
  ///
  /// In en, this message translates to:
  /// **'This PDF could not be previewed. Use Save or share to open it in another app.'**
  String get mobilePdfPreviewFailed;

  /// No description provided for @mobileImagePreviewFailed.
  ///
  /// In en, this message translates to:
  /// **'This image could not be previewed. Use Save or share to open it in another app.'**
  String get mobileImagePreviewFailed;

  /// No description provided for @mobileToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get mobileToday;

  /// No description provided for @mobileTripCreated.
  ///
  /// In en, this message translates to:
  /// **'Trip created'**
  String get mobileTripCreated;

  /// No description provided for @mobileTripDetails.
  ///
  /// In en, this message translates to:
  /// **'Trip details'**
  String get mobileTripDetails;

  /// No description provided for @mobileTripRoute.
  ///
  /// In en, this message translates to:
  /// **'Trip route'**
  String get mobileTripRoute;

  /// No description provided for @mobileTripTitle.
  ///
  /// In en, this message translates to:
  /// **'Trip title'**
  String get mobileTripTitle;

  /// No description provided for @mobileProofShareFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to share this proof. Please try again.'**
  String get mobileProofShareFailed;

  /// No description provided for @mobileUnavailableVehicles.
  ///
  /// In en, this message translates to:
  /// **'Unavailable vehicles'**
  String get mobileUnavailableVehicles;

  /// No description provided for @mobileMaxSkipDates.
  ///
  /// In en, this message translates to:
  /// **'Use at most 100 skip dates'**
  String get mobileMaxSkipDates;

  /// No description provided for @mobileRemarkLength.
  ///
  /// In en, this message translates to:
  /// **'Use at most 600 characters for the remark.'**
  String get mobileRemarkLength;

  /// No description provided for @mobileValidDates.
  ///
  /// In en, this message translates to:
  /// **'Use valid dates in YYYY-MM-DD format'**
  String get mobileValidDates;

  /// No description provided for @mobileVehicleGpsPosition.
  ///
  /// In en, this message translates to:
  /// **'Vehicle GPS position'**
  String get mobileVehicleGpsPosition;

  /// No description provided for @mobileVehicleDriver.
  ///
  /// In en, this message translates to:
  /// **'Vehicle and driver'**
  String get mobileVehicleDriver;

  /// No description provided for @mobileVehicleRoute.
  ///
  /// In en, this message translates to:
  /// **'Vehicle and route'**
  String get mobileVehicleRoute;

  /// No description provided for @mobileViewTrip.
  ///
  /// In en, this message translates to:
  /// **'View trip'**
  String get mobileViewTrip;

  /// No description provided for @mobileDatesPerLine.
  ///
  /// In en, this message translates to:
  /// **'YYYY-MM-DD, one date per line'**
  String get mobileDatesPerLine;

  /// No description provided for @mobileDiscardPlanningHelp.
  ///
  /// In en, this message translates to:
  /// **'Your unsaved planning changes will be lost. Saved routes will remain available.'**
  String get mobileDiscardPlanningHelp;

  /// No description provided for @mobileTimesTimezone.
  ///
  /// In en, this message translates to:
  /// **'Times use {timezone}.'**
  String mobileTimesTimezone(Object timezone);

  /// No description provided for @mobileStopsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} stops'**
  String mobileStopsCount(Object count);

  /// No description provided for @mobileTripsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} trips'**
  String mobileTripsCount(Object count);

  /// No description provided for @mobileLoadMoreCount.
  ///
  /// In en, this message translates to:
  /// **'Load more ({loaded} of {total})'**
  String mobileLoadMoreCount(Object loaded, Object total);

  /// No description provided for @mobileScheduledDate.
  ///
  /// In en, this message translates to:
  /// **'Scheduled: {date}'**
  String mobileScheduledDate(Object date);

  /// No description provided for @mobileEndsDate.
  ///
  /// In en, this message translates to:
  /// **'Ends: {date}'**
  String mobileEndsDate(Object date);

  /// No description provided for @mobileNextDate.
  ///
  /// In en, this message translates to:
  /// **'Next: {date}'**
  String mobileNextDate(Object date);

  /// No description provided for @mobileGpsStatus.
  ///
  /// In en, this message translates to:
  /// **'Vehicle GPS: {status}'**
  String mobileGpsStatus(Object status);

  /// No description provided for @mobileLastPosition.
  ///
  /// In en, this message translates to:
  /// **'Last position: {date}'**
  String mobileLastPosition(Object date);

  /// No description provided for @mobileActualDistance.
  ///
  /// In en, this message translates to:
  /// **'Actual distance: {distance} km'**
  String mobileActualDistance(Object distance);

  /// No description provided for @mobileTripScore.
  ///
  /// In en, this message translates to:
  /// **'Trip score: {value}'**
  String mobileTripScore(Object value);

  /// No description provided for @mobileStopsProgress.
  ///
  /// In en, this message translates to:
  /// **'{completed}/{total} stops'**
  String mobileStopsProgress(Object completed, Object total);

  /// No description provided for @mobileScheduleAction.
  ///
  /// In en, this message translates to:
  /// **'{action} recurring schedule?'**
  String mobileScheduleAction(Object action);

  /// No description provided for @dateRangeSelect.
  ///
  /// In en, this message translates to:
  /// **'Select date range'**
  String get dateRangeSelect;

  /// No description provided for @dateRangeChoose.
  ///
  /// In en, this message translates to:
  /// **'Choose Date Range'**
  String get dateRangeChoose;

  /// No description provided for @dateTimeRangeChoose.
  ///
  /// In en, this message translates to:
  /// **'Choose Date & Time Range'**
  String get dateTimeRangeChoose;

  /// No description provided for @dateRangeFrom.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get dateRangeFrom;

  /// No description provided for @dateRangeTo.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get dateRangeTo;

  /// No description provided for @dateRangeSelected.
  ///
  /// In en, this message translates to:
  /// **'Selected Range'**
  String get dateRangeSelected;

  /// No description provided for @dateRangeStartTime.
  ///
  /// In en, this message translates to:
  /// **'Start Time'**
  String get dateRangeStartTime;

  /// No description provided for @dateRangeEndTime.
  ///
  /// In en, this message translates to:
  /// **'End Time'**
  String get dateRangeEndTime;

  /// No description provided for @dateRangeSelectStartTime.
  ///
  /// In en, this message translates to:
  /// **'Select start time'**
  String get dateRangeSelectStartTime;

  /// No description provided for @dateRangeSelectEndTime.
  ///
  /// In en, this message translates to:
  /// **'Select end time'**
  String get dateRangeSelectEndTime;

  /// No description provided for @dateRangeInvalidTime.
  ///
  /// In en, this message translates to:
  /// **'End time must be after start time.'**
  String get dateRangeInvalidTime;

  /// No description provided for @dateRangeCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get dateRangeCustom;

  /// No description provided for @dateRangeLastHour.
  ///
  /// In en, this message translates to:
  /// **'Last Hour'**
  String get dateRangeLastHour;

  /// No description provided for @dateRangeLast3Hours.
  ///
  /// In en, this message translates to:
  /// **'Last 3 Hours'**
  String get dateRangeLast3Hours;

  /// No description provided for @dateRangeLast6Hours.
  ///
  /// In en, this message translates to:
  /// **'Last 6 Hours'**
  String get dateRangeLast6Hours;

  /// No description provided for @dateRangeLast12Hours.
  ///
  /// In en, this message translates to:
  /// **'Last 12 Hours'**
  String get dateRangeLast12Hours;

  /// No description provided for @dateRangeLast24Hours.
  ///
  /// In en, this message translates to:
  /// **'Last 24 Hours'**
  String get dateRangeLast24Hours;

  /// No description provided for @dateRangeToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get dateRangeToday;

  /// No description provided for @dateRangeYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get dateRangeYesterday;

  /// No description provided for @dateRangeThisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get dateRangeThisWeek;

  /// No description provided for @dateRangeLastWeek.
  ///
  /// In en, this message translates to:
  /// **'Last Week'**
  String get dateRangeLastWeek;

  /// No description provided for @dateRangeLast7Days.
  ///
  /// In en, this message translates to:
  /// **'Last 7 Days'**
  String get dateRangeLast7Days;

  /// No description provided for @dateRangeLast30Days.
  ///
  /// In en, this message translates to:
  /// **'Last 30 Days'**
  String get dateRangeLast30Days;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @calendarToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get calendarToday;

  /// No description provided for @calendarPreviousMonth.
  ///
  /// In en, this message translates to:
  /// **'Previous month'**
  String get calendarPreviousMonth;

  /// No description provided for @calendarNextMonth.
  ///
  /// In en, this message translates to:
  /// **'Next month'**
  String get calendarNextMonth;

  /// No description provided for @calendarExpiry.
  ///
  /// In en, this message translates to:
  /// **'Expiry'**
  String get calendarExpiry;

  /// No description provided for @legacyUi869d62ddcd.
  ///
  /// In en, this message translates to:
  /// **' to enable the button.'**
  String get legacyUi869d62ddcd;

  /// No description provided for @legacyUi7f4f41c8c3.
  ///
  /// In en, this message translates to:
  /// **'#RRGGBB'**
  String get legacyUi7f4f41c8c3;

  /// No description provided for @legacyUi9515360684.
  ///
  /// In en, this message translates to:
  /// **'+ Add new device'**
  String get legacyUi9515360684;

  /// No description provided for @legacyUi6116c134de.
  ///
  /// In en, this message translates to:
  /// **'+ Create new plan'**
  String get legacyUi6116c134de;

  /// No description provided for @legacyUic10e9a1c41.
  ///
  /// In en, this message translates to:
  /// **'+ Create new user'**
  String get legacyUic10e9a1c41;

  /// No description provided for @legacyUi5e9a7040e4.
  ///
  /// In en, this message translates to:
  /// **'2 digits'**
  String get legacyUi5e9a7040e4;

  /// No description provided for @legacyUia0483eec37.
  ///
  /// In en, this message translates to:
  /// **'3 digits'**
  String get legacyUia0483eec37;

  /// No description provided for @legacyUi3994dbd48e.
  ///
  /// In en, this message translates to:
  /// **'6–35 characters'**
  String get legacyUi3994dbd48e;

  /// No description provided for @legacyUi250e268e83.
  ///
  /// In en, this message translates to:
  /// **'7 to 15 digits'**
  String get legacyUi250e268e83;

  /// No description provided for @legacyUie69a9a5ee9.
  ///
  /// In en, this message translates to:
  /// **'7-Day Usage'**
  String get legacyUie69a9a5ee9;

  /// No description provided for @legacyUib8cee60c75.
  ///
  /// In en, this message translates to:
  /// **'A sub user can only use features and reports available to your account. Settings and account security remain available.'**
  String get legacyUib8cee60c75;

  /// No description provided for @legacyUif0ee13e963.
  ///
  /// In en, this message translates to:
  /// **'Access restricted'**
  String get legacyUif0ee13e963;

  /// No description provided for @legacyUi6e702cb4e0.
  ///
  /// In en, this message translates to:
  /// **'Account Status'**
  String get legacyUi6e702cb4e0;

  /// No description provided for @legacyUi6d6eba9279.
  ///
  /// In en, this message translates to:
  /// **'Account access'**
  String get legacyUi6d6eba9279;

  /// No description provided for @legacyUi82cf8a5fc7.
  ///
  /// In en, this message translates to:
  /// **'Account settings'**
  String get legacyUi82cf8a5fc7;

  /// No description provided for @legacyUi9beb96dac8.
  ///
  /// In en, this message translates to:
  /// **'Acknowledge'**
  String get legacyUi9beb96dac8;

  /// No description provided for @legacyUibf539b1d10.
  ///
  /// In en, this message translates to:
  /// **'Acme Logistics Pvt. Ltd.'**
  String get legacyUibf539b1d10;

  /// No description provided for @legacyUic3cd636a58.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get legacyUic3cd636a58;

  /// No description provided for @legacyUia733b809d2.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get legacyUia733b809d2;

  /// No description provided for @legacyUi15cf579b89.
  ///
  /// In en, this message translates to:
  /// **'Active Duration'**
  String get legacyUi15cf579b89;

  /// No description provided for @legacyUifaa171bc07.
  ///
  /// In en, this message translates to:
  /// **'Active Vehicle'**
  String get legacyUifaa171bc07;

  /// No description provided for @legacyUibde34d0278.
  ///
  /// In en, this message translates to:
  /// **'Active status'**
  String get legacyUibde34d0278;

  /// No description provided for @legacyUi14c5b09cd4.
  ///
  /// In en, this message translates to:
  /// **'Activity Detail'**
  String get legacyUi14c5b09cd4;

  /// No description provided for @legacyUifbed23bc25.
  ///
  /// In en, this message translates to:
  /// **'Activity Logs'**
  String get legacyUifbed23bc25;

  /// No description provided for @legacyUie35effbf63.
  ///
  /// In en, this message translates to:
  /// **'Activity date range'**
  String get legacyUie35effbf63;

  /// No description provided for @legacyUicbd19b5c39.
  ///
  /// In en, this message translates to:
  /// **'Actor'**
  String get legacyUicbd19b5c39;

  /// No description provided for @legacyUi7980ca2475.
  ///
  /// In en, this message translates to:
  /// **'Actor User'**
  String get legacyUi7980ca2475;

  /// No description provided for @legacyUi4ac5084db4.
  ///
  /// In en, this message translates to:
  /// **'Add Device or SIM'**
  String get legacyUi4ac5084db4;

  /// No description provided for @legacyUiaa752d14b8.
  ///
  /// In en, this message translates to:
  /// **'Add Driver'**
  String get legacyUiaa752d14b8;

  /// No description provided for @legacyUi224f2486e6.
  ///
  /// In en, this message translates to:
  /// **'Add Inventory'**
  String get legacyUi224f2486e6;

  /// No description provided for @legacyUi1836b111cd.
  ///
  /// In en, this message translates to:
  /// **'Add Meta Row'**
  String get legacyUi1836b111cd;

  /// No description provided for @legacyUi31dd5bb29e.
  ///
  /// In en, this message translates to:
  /// **'Add New Team'**
  String get legacyUi31dd5bb29e;

  /// No description provided for @legacyUi47b2149c9c.
  ///
  /// In en, this message translates to:
  /// **'Add Plan'**
  String get legacyUi47b2149c9c;

  /// No description provided for @legacyUic08d1e9d3f.
  ///
  /// In en, this message translates to:
  /// **'Add Sensor'**
  String get legacyUic08d1e9d3f;

  /// No description provided for @legacyUi12071f1c87.
  ///
  /// In en, this message translates to:
  /// **'Add a new plan or change your search.'**
  String get legacyUi12071f1c87;

  /// No description provided for @legacyUic0c181937e.
  ///
  /// In en, this message translates to:
  /// **'Add attribute'**
  String get legacyUic0c181937e;

  /// No description provided for @legacyUi5367d642e2.
  ///
  /// In en, this message translates to:
  /// **'Add credits'**
  String get legacyUi5367d642e2;

  /// No description provided for @legacyUi1fa55e4562.
  ///
  /// In en, this message translates to:
  /// **'Add metadata row'**
  String get legacyUi1fa55e4562;

  /// No description provided for @legacyUi7be087b7a7.
  ///
  /// In en, this message translates to:
  /// **'Add proof'**
  String get legacyUi7be087b7a7;

  /// No description provided for @legacyUib68734c259.
  ///
  /// In en, this message translates to:
  /// **'Added'**
  String get legacyUib68734c259;

  /// No description provided for @legacyUi41b5f2e6ae.
  ///
  /// In en, this message translates to:
  /// **'Additional notes'**
  String get legacyUi41b5f2e6ae;

  /// No description provided for @legacyUid5e920a5cb.
  ///
  /// In en, this message translates to:
  /// **'Address Line'**
  String get legacyUid5e920a5cb;

  /// No description provided for @legacyUi7748043229.
  ///
  /// In en, this message translates to:
  /// **'Address and geography details.'**
  String get legacyUi7748043229;

  /// No description provided for @legacyUi4faa35048a.
  ///
  /// In en, this message translates to:
  /// **'Admin login request completed.'**
  String get legacyUi4faa35048a;

  /// No description provided for @legacyUi1eda23758b.
  ///
  /// In en, this message translates to:
  /// **'Administrator'**
  String get legacyUi1eda23758b;

  /// No description provided for @legacyUi3df513225f.
  ///
  /// In en, this message translates to:
  /// **'Administrator created.'**
  String get legacyUi3df513225f;

  /// No description provided for @legacyUif981236722.
  ///
  /// In en, this message translates to:
  /// **'Affected vehicles'**
  String get legacyUif981236722;

  /// No description provided for @legacyUib7fb586ff2.
  ///
  /// In en, this message translates to:
  /// **'Airport'**
  String get legacyUib7fb586ff2;

  /// No description provided for @legacyUi25f8c55de8.
  ///
  /// In en, this message translates to:
  /// **'Alarm'**
  String get legacyUi25f8c55de8;

  /// No description provided for @legacyUib5faca3a78.
  ///
  /// In en, this message translates to:
  /// **'Alert Type'**
  String get legacyUib5faca3a78;

  /// No description provided for @legacyUic03d80790d.
  ///
  /// In en, this message translates to:
  /// **'All Admins'**
  String get legacyUic03d80790d;

  /// No description provided for @legacyUi0b313a76be.
  ///
  /// In en, this message translates to:
  /// **'All Countries'**
  String get legacyUi0b313a76be;

  /// No description provided for @legacyUiffeed47b5a.
  ///
  /// In en, this message translates to:
  /// **'All Providers'**
  String get legacyUiffeed47b5a;

  /// No description provided for @legacyUi4745c5dce5.
  ///
  /// In en, this message translates to:
  /// **'All Time'**
  String get legacyUi4745c5dce5;

  /// No description provided for @legacyUieb672cb3ba.
  ///
  /// In en, this message translates to:
  /// **'All Types'**
  String get legacyUieb672cb3ba;

  /// No description provided for @legacyUib4f25a1426.
  ///
  /// In en, this message translates to:
  /// **'All Users'**
  String get legacyUib4f25a1426;

  /// No description provided for @legacyUidd9eb32418.
  ///
  /// In en, this message translates to:
  /// **'All Vehicles'**
  String get legacyUidd9eb32418;

  /// No description provided for @legacyUi060be00f4f.
  ///
  /// In en, this message translates to:
  /// **'All categories'**
  String get legacyUi060be00f4f;

  /// No description provided for @legacyUi0aaede0bb1.
  ///
  /// In en, this message translates to:
  /// **'All notifications marked as read.'**
  String get legacyUi0aaede0bb1;

  /// No description provided for @legacyUi30c8a0fc9c.
  ///
  /// In en, this message translates to:
  /// **'All types'**
  String get legacyUi30c8a0fc9c;

  /// No description provided for @legacyUice832d9b31.
  ///
  /// In en, this message translates to:
  /// **'All users'**
  String get legacyUice832d9b31;

  /// No description provided for @legacyUie512a2f10a.
  ///
  /// In en, this message translates to:
  /// **'Allow History'**
  String get legacyUie512a2f10a;

  /// No description provided for @legacyUif8f993b052.
  ///
  /// In en, this message translates to:
  /// **'Allow route history access.'**
  String get legacyUif8f993b052;

  /// No description provided for @legacyUi1ffee134b1.
  ///
  /// In en, this message translates to:
  /// **'Allow visitors to log in to a demo workspace.'**
  String get legacyUi1ffee134b1;

  /// No description provided for @legacyUie5d30dc481.
  ///
  /// In en, this message translates to:
  /// **'Allowed range: 10–300'**
  String get legacyUie5d30dc481;

  /// No description provided for @legacyUi22786d42cc.
  ///
  /// In en, this message translates to:
  /// **'Altitude'**
  String get legacyUi22786d42cc;

  /// No description provided for @legacyUi43dc8532f7.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get legacyUi43dc8532f7;

  /// No description provided for @legacyUi76aa32f207.
  ///
  /// In en, this message translates to:
  /// **'Amount *'**
  String get legacyUi76aa32f207;

  /// No description provided for @legacyUia01154a861.
  ///
  /// In en, this message translates to:
  /// **'Amount Override'**
  String get legacyUia01154a861;

  /// No description provided for @legacyUi7d66157b06.
  ///
  /// In en, this message translates to:
  /// **'Amount must be between 0.01 and 9999999.99'**
  String get legacyUi7d66157b06;

  /// No description provided for @legacyUib34440b2cd.
  ///
  /// In en, this message translates to:
  /// **'Amount override'**
  String get legacyUib34440b2cd;

  /// No description provided for @legacyUib757c50159.
  ///
  /// In en, this message translates to:
  /// **'Amount supports up to 2 decimal places'**
  String get legacyUib757c50159;

  /// No description provided for @legacyUic8c3ba95bb.
  ///
  /// In en, this message translates to:
  /// **'Analytics will appear once payments are available.'**
  String get legacyUic8c3ba95bb;

  /// No description provided for @legacyUif6c665f4fe.
  ///
  /// In en, this message translates to:
  /// **'Analytics will appear once transactions are available.'**
  String get legacyUif6c665f4fe;

  /// No description provided for @legacyUi6b2a78a8f7.
  ///
  /// In en, this message translates to:
  /// **'Apply Filters'**
  String get legacyUi6b2a78a8f7;

  /// No description provided for @legacyUi2444928438.
  ///
  /// In en, this message translates to:
  /// **'Assign'**
  String get legacyUi2444928438;

  /// No description provided for @legacyUi561f6317fe.
  ///
  /// In en, this message translates to:
  /// **'Assign Driver'**
  String get legacyUi561f6317fe;

  /// No description provided for @legacyUi3d2183f9ae.
  ///
  /// In en, this message translates to:
  /// **'Assign Selected'**
  String get legacyUi3d2183f9ae;

  /// No description provided for @legacyUi5e97289597.
  ///
  /// In en, this message translates to:
  /// **'Assign User'**
  String get legacyUi5e97289597;

  /// No description provided for @legacyUib8db201262.
  ///
  /// In en, this message translates to:
  /// **'Assign Vehicle'**
  String get legacyUib8db201262;

  /// No description provided for @legacyUi20b5675c39.
  ///
  /// In en, this message translates to:
  /// **'Assign Vehicles'**
  String get legacyUi20b5675c39;

  /// No description provided for @legacyUic403a13c66.
  ///
  /// In en, this message translates to:
  /// **'Assign one or more vehicles to this sub user.'**
  String get legacyUic403a13c66;

  /// No description provided for @legacyUie12261bf18.
  ///
  /// In en, this message translates to:
  /// **'Assign users to this driver.'**
  String get legacyUie12261bf18;

  /// No description provided for @legacyUi41c90cdeef.
  ///
  /// In en, this message translates to:
  /// **'Assign users to this vehicle.'**
  String get legacyUi41c90cdeef;

  /// No description provided for @legacyUi32265d6dad.
  ///
  /// In en, this message translates to:
  /// **'Assign vehicles to configure basic notifications.'**
  String get legacyUi32265d6dad;

  /// No description provided for @legacyUi117326ffd2.
  ///
  /// In en, this message translates to:
  /// **'Assign vehicles to configure duration notifications.'**
  String get legacyUi117326ffd2;

  /// No description provided for @legacyUi74dfd6593f.
  ///
  /// In en, this message translates to:
  /// **'Assign vehicles to configure geofence notifications.'**
  String get legacyUi74dfd6593f;

  /// No description provided for @legacyUi8c6586176a.
  ///
  /// In en, this message translates to:
  /// **'Assign vehicles to configure overspeed notifications.'**
  String get legacyUi8c6586176a;

  /// No description provided for @legacyUi086854873d.
  ///
  /// In en, this message translates to:
  /// **'Assign vehicles to configure route notifications.'**
  String get legacyUi086854873d;

  /// No description provided for @legacyUie24e824b68.
  ///
  /// In en, this message translates to:
  /// **'Assigned'**
  String get legacyUie24e824b68;

  /// No description provided for @legacyUie94ba984c3.
  ///
  /// In en, this message translates to:
  /// **'Assigned vehicles'**
  String get legacyUie94ba984c3;

  /// No description provided for @legacyUie55df441e8.
  ///
  /// In en, this message translates to:
  /// **'Assignment'**
  String get legacyUie55df441e8;

  /// No description provided for @legacyUi0c686b74d7.
  ///
  /// In en, this message translates to:
  /// **'At least 5 characters. Changes are audited.'**
  String get legacyUi0c686b74d7;

  /// No description provided for @legacyUi1afff0157c.
  ///
  /// In en, this message translates to:
  /// **'Attach'**
  String get legacyUi1afff0157c;

  /// No description provided for @legacyUi0c431f4969.
  ///
  /// In en, this message translates to:
  /// **'Attach file'**
  String get legacyUi0c431f4969;

  /// No description provided for @legacyUi137135dbf6.
  ///
  /// In en, this message translates to:
  /// **'Attach files'**
  String get legacyUi137135dbf6;

  /// No description provided for @legacyUi2286866966.
  ///
  /// In en, this message translates to:
  /// **'Attachment URL is not available.'**
  String get legacyUi2286866966;

  /// No description provided for @legacyUib6b6277691.
  ///
  /// In en, this message translates to:
  /// **'Attachment path is not available.'**
  String get legacyUib6b6277691;

  /// No description provided for @legacyUi1b30607d41.
  ///
  /// In en, this message translates to:
  /// **'Attribute keys must be unique.'**
  String get legacyUi1b30607d41;

  /// No description provided for @legacyUia6652617f2.
  ///
  /// In en, this message translates to:
  /// **'Attributes'**
  String get legacyUia6652617f2;

  /// No description provided for @legacyUi7c62a14244.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get legacyUi7c62a14244;

  /// No description provided for @legacyUicdc93143c6.
  ///
  /// In en, this message translates to:
  /// **'Avg'**
  String get legacyUicdc93143c6;

  /// No description provided for @legacyUib1ff8731de.
  ///
  /// In en, this message translates to:
  /// **'Avg Speed'**
  String get legacyUib1ff8731de;

  /// No description provided for @legacyUi3e6e9b59e4.
  ///
  /// In en, this message translates to:
  /// **'Backend Tokens'**
  String get legacyUi3e6e9b59e4;

  /// No description provided for @legacyUib15950ccc9.
  ///
  /// In en, this message translates to:
  /// **'Backend tokens'**
  String get legacyUib15950ccc9;

  /// No description provided for @legacyUief5c48114b.
  ///
  /// In en, this message translates to:
  /// **'Backend verified'**
  String get legacyUief5c48114b;

  /// No description provided for @legacyUidd96994d01.
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get legacyUidd96994d01;

  /// No description provided for @legacyUi775fe0e609.
  ///
  /// In en, this message translates to:
  /// **'Backup / Data Retention'**
  String get legacyUi775fe0e609;

  /// No description provided for @legacyUi17ef50d8f8.
  ///
  /// In en, this message translates to:
  /// **'Bank Transfer'**
  String get legacyUi17ef50d8f8;

  /// No description provided for @legacyUi1007a1a728.
  ///
  /// In en, this message translates to:
  /// **'Bank ref / UTR / transaction ID'**
  String get legacyUi1007a1a728;

  /// No description provided for @legacyUi5be1ae92e8.
  ///
  /// In en, this message translates to:
  /// **'Bank transfer note / UTR / transaction ref'**
  String get legacyUi5be1ae92e8;

  /// No description provided for @legacyUi6b57349e97.
  ///
  /// In en, this message translates to:
  /// **'Base URL settings'**
  String get legacyUi6b57349e97;

  /// No description provided for @legacyUiaa2c96dacf.
  ///
  /// In en, this message translates to:
  /// **'Basic'**
  String get legacyUiaa2c96dacf;

  /// No description provided for @legacyUic73c27be48.
  ///
  /// In en, this message translates to:
  /// **'Basic account credentials for driver login.'**
  String get legacyUic73c27be48;

  /// No description provided for @legacyUi904d23cb6a.
  ///
  /// In en, this message translates to:
  /// **'Basic identification for the new vehicle.'**
  String get legacyUi904d23cb6a;

  /// No description provided for @legacyUi99613c74ce.
  ///
  /// In en, this message translates to:
  /// **'Blocked'**
  String get legacyUi99613c74ce;

  /// No description provided for @legacyUi584522b903.
  ///
  /// In en, this message translates to:
  /// **'Brand and contact details'**
  String get legacyUi584522b903;

  /// No description provided for @legacyUibfc8921ede.
  ///
  /// In en, this message translates to:
  /// **'Brand color'**
  String get legacyUibfc8921ede;

  /// No description provided for @legacyUi54a2cf5e63.
  ///
  /// In en, this message translates to:
  /// **'Browser'**
  String get legacyUi54a2cf5e63;

  /// No description provided for @legacyUi73e0b16797.
  ///
  /// In en, this message translates to:
  /// **'Browser tab icon. ICO, PNG or SVG. Max 2 MB.'**
  String get legacyUi73e0b16797;

  /// No description provided for @legacyUicfadbd7a57.
  ///
  /// In en, this message translates to:
  /// **'By'**
  String get legacyUicfadbd7a57;

  /// No description provided for @legacyUi42878ce3fa.
  ///
  /// In en, this message translates to:
  /// **'CPU Usage'**
  String get legacyUi42878ce3fa;

  /// No description provided for @legacyUi37efa8a990.
  ///
  /// In en, this message translates to:
  /// **'Cafe'**
  String get legacyUi37efa8a990;

  /// No description provided for @legacyUi26b937c51d.
  ///
  /// In en, this message translates to:
  /// **'Cancel renewal request?'**
  String get legacyUi26b937c51d;

  /// No description provided for @legacyUi84837a2168.
  ///
  /// In en, this message translates to:
  /// **'Cancel request'**
  String get legacyUi84837a2168;

  /// No description provided for @legacyUi2738a0a1db.
  ///
  /// In en, this message translates to:
  /// **'Cannot load commands without vehicle details.'**
  String get legacyUi2738a0a1db;

  /// No description provided for @legacyUi4d4ce73b15.
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get legacyUi4d4ce73b15;

  /// No description provided for @legacyUi758ec54e43.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get legacyUi758ec54e43;

  /// No description provided for @legacyUi6ccb60071b.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get legacyUi6ccb60071b;

  /// No description provided for @legacyUi49289db43e.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get legacyUi49289db43e;

  /// No description provided for @legacyUi6fc0529f2d.
  ///
  /// In en, this message translates to:
  /// **'Change status'**
  String get legacyUi6fc0529f2d;

  /// No description provided for @legacyUica5df1dad1.
  ///
  /// In en, this message translates to:
  /// **'Choose Date Time Range'**
  String get legacyUica5df1dad1;

  /// No description provided for @legacyUid2174d8075.
  ///
  /// In en, this message translates to:
  /// **'Choose Replay Range'**
  String get legacyUid2174d8075;

  /// No description provided for @legacyUi66542fe55c.
  ///
  /// In en, this message translates to:
  /// **'Choose a plan, registration date and reason of 5–500 characters.'**
  String get legacyUi66542fe55c;

  /// No description provided for @legacyUi7db804aa37.
  ///
  /// In en, this message translates to:
  /// **'Choose vehicles, expiry, and sharing options.'**
  String get legacyUi7db804aa37;

  /// No description provided for @legacyUi037c5eba86.
  ///
  /// In en, this message translates to:
  /// **'City (optional)'**
  String get legacyUi037c5eba86;

  /// No description provided for @legacyUief153831d1.
  ///
  /// In en, this message translates to:
  /// **'City is required.'**
  String get legacyUief153831d1;

  /// No description provided for @legacyUi8da6bb0466.
  ///
  /// In en, this message translates to:
  /// **'Cleanup completed'**
  String get legacyUi8da6bb0466;

  /// No description provided for @legacyUi381c4bf1d4.
  ///
  /// In en, this message translates to:
  /// **'Clear Filters'**
  String get legacyUi381c4bf1d4;

  /// No description provided for @legacyUicdb64ef80e.
  ///
  /// In en, this message translates to:
  /// **'Clear date range'**
  String get legacyUicdb64ef80e;

  /// No description provided for @legacyUid3c69afc35.
  ///
  /// In en, this message translates to:
  /// **'Clear dates'**
  String get legacyUid3c69afc35;

  /// No description provided for @legacyUi1bf7452cd6.
  ///
  /// In en, this message translates to:
  /// **'Clear expiry'**
  String get legacyUi1bf7452cd6;

  /// No description provided for @legacyUi40b66a41b8.
  ///
  /// In en, this message translates to:
  /// **'Clear expiry date'**
  String get legacyUi40b66a41b8;

  /// No description provided for @legacyUi92e60a4db3.
  ///
  /// In en, this message translates to:
  /// **'Clear replay'**
  String get legacyUi92e60a4db3;

  /// No description provided for @legacyUi53dde4f2c0.
  ///
  /// In en, this message translates to:
  /// **'Client revenue will appear after payments are recorded.'**
  String get legacyUi53dde4f2c0;

  /// No description provided for @legacyUide4e7f6fad.
  ///
  /// In en, this message translates to:
  /// **'Close drawer'**
  String get legacyUide4e7f6fad;

  /// No description provided for @legacyUi3dc631324c.
  ///
  /// In en, this message translates to:
  /// **'Close map'**
  String get legacyUi3dc631324c;

  /// No description provided for @legacyUid75dc68bbd.
  ///
  /// In en, this message translates to:
  /// **'Cluster'**
  String get legacyUid75dc68bbd;

  /// No description provided for @legacyUiadac69379a.
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get legacyUiadac69379a;

  /// No description provided for @legacyUiea6ac41a6a.
  ///
  /// In en, this message translates to:
  /// **'Code is required.'**
  String get legacyUiea6ac41a6a;

  /// No description provided for @legacyUi5b0f7590d0.
  ///
  /// In en, this message translates to:
  /// **'Collected'**
  String get legacyUi5b0f7590d0;

  /// No description provided for @legacyUi8901895fb1.
  ///
  /// In en, this message translates to:
  /// **'Command'**
  String get legacyUi8901895fb1;

  /// No description provided for @legacyUif7e08456d0.
  ///
  /// In en, this message translates to:
  /// **'Command Details'**
  String get legacyUif7e08456d0;

  /// No description provided for @legacyUi6c4cb3de03.
  ///
  /// In en, this message translates to:
  /// **'Command Text'**
  String get legacyUi6c4cb3de03;

  /// No description provided for @legacyUibfed234d46.
  ///
  /// In en, this message translates to:
  /// **'Command unavailable'**
  String get legacyUibfed234d46;

  /// No description provided for @legacyUi45e5f3f72e.
  ///
  /// In en, this message translates to:
  /// **'Commands'**
  String get legacyUi45e5f3f72e;

  /// No description provided for @legacyUi7a1994999d.
  ///
  /// In en, this message translates to:
  /// **'Company'**
  String get legacyUi7a1994999d;

  /// No description provided for @legacyUi8599f5cc48.
  ///
  /// In en, this message translates to:
  /// **'Company Name'**
  String get legacyUi8599f5cc48;

  /// No description provided for @legacyUi1e5f7dc45c.
  ///
  /// In en, this message translates to:
  /// **'Company name'**
  String get legacyUi1e5f7dc45c;

  /// No description provided for @legacyUib55887f633.
  ///
  /// In en, this message translates to:
  /// **'Company updated'**
  String get legacyUib55887f633;

  /// No description provided for @legacyUi657063c67c.
  ///
  /// In en, this message translates to:
  /// **'Company updated.'**
  String get legacyUi657063c67c;

  /// No description provided for @legacyUif1ab0a6f4e.
  ///
  /// In en, this message translates to:
  /// **'Complete manually'**
  String get legacyUif1ab0a6f4e;

  /// No description provided for @legacyUif14ebb39ce.
  ///
  /// In en, this message translates to:
  /// **'Config Version'**
  String get legacyUif14ebb39ce;

  /// No description provided for @legacyUi755bea99c0.
  ///
  /// In en, this message translates to:
  /// **'Config updated.'**
  String get legacyUi755bea99c0;

  /// No description provided for @legacyUic69463a5a9.
  ///
  /// In en, this message translates to:
  /// **'Configure outgoing mail delivery.'**
  String get legacyUic69463a5a9;

  /// No description provided for @legacyUic2d404cb7b.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get legacyUic2d404cb7b;

  /// No description provided for @legacyUiea3723a45c.
  ///
  /// In en, this message translates to:
  /// **'Confirm increased access'**
  String get legacyUiea3723a45c;

  /// No description provided for @legacyUi4a7c565d4c.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get legacyUi4a7c565d4c;

  /// No description provided for @legacyUi5febc18b54.
  ///
  /// In en, this message translates to:
  /// **'Confirm payment'**
  String get legacyUi5febc18b54;

  /// No description provided for @legacyUi05a7fffae1.
  ///
  /// In en, this message translates to:
  /// **'Confirm received payment'**
  String get legacyUi05a7fffae1;

  /// No description provided for @legacyUi90d96c7cec.
  ///
  /// In en, this message translates to:
  /// **'Confirmation phrase'**
  String get legacyUi90d96c7cec;

  /// No description provided for @legacyUic2f9b7b489.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get legacyUic2f9b7b489;

  /// No description provided for @legacyUib37456c453.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get legacyUib37456c453;

  /// No description provided for @legacyUicc11b3a28f.
  ///
  /// In en, this message translates to:
  /// **'Context'**
  String get legacyUicc11b3a28f;

  /// No description provided for @legacyUi3cf29aa7f5.
  ///
  /// In en, this message translates to:
  /// **'Continuous Idle'**
  String get legacyUi3cf29aa7f5;

  /// No description provided for @legacyUic352b92e1f.
  ///
  /// In en, this message translates to:
  /// **'Continuous Running'**
  String get legacyUic352b92e1f;

  /// No description provided for @legacyUi347d3dbf17.
  ///
  /// In en, this message translates to:
  /// **'Continuous Stop'**
  String get legacyUi347d3dbf17;

  /// No description provided for @legacyUi49fdb038f4.
  ///
  /// In en, this message translates to:
  /// **'Control what viewers can see.'**
  String get legacyUi49fdb038f4;

  /// No description provided for @legacyUi02c6c04dec.
  ///
  /// In en, this message translates to:
  /// **'Copy KML'**
  String get legacyUi02c6c04dec;

  /// No description provided for @legacyUi44fe06869f.
  ///
  /// In en, this message translates to:
  /// **'Copy header'**
  String get legacyUi44fe06869f;

  /// No description provided for @legacyUi3a9d77c901.
  ///
  /// In en, this message translates to:
  /// **'Could not open URL'**
  String get legacyUi3a9d77c901;

  /// No description provided for @legacyUi0c09a7eccc.
  ///
  /// In en, this message translates to:
  /// **'Could not open attachment.'**
  String get legacyUi0c09a7eccc;

  /// No description provided for @legacyUif2344997aa.
  ///
  /// In en, this message translates to:
  /// **'Could not open document.'**
  String get legacyUif2344997aa;

  /// No description provided for @legacyUi2209ab63ce.
  ///
  /// In en, this message translates to:
  /// **'Could not open file.'**
  String get legacyUi2209ab63ce;

  /// No description provided for @legacyUi5905ce4109.
  ///
  /// In en, this message translates to:
  /// **'Could not open file. Link copied.'**
  String get legacyUi5905ce4109;

  /// No description provided for @legacyUi9b09f53bdd.
  ///
  /// In en, this message translates to:
  /// **'Could not open link.'**
  String get legacyUi9b09f53bdd;

  /// No description provided for @legacyUi72be0e8616.
  ///
  /// In en, this message translates to:
  /// **'Could not pick file'**
  String get legacyUi72be0e8616;

  /// No description provided for @legacyUi76e835f8c3.
  ///
  /// In en, this message translates to:
  /// **'Could not pick file.'**
  String get legacyUi76e835f8c3;

  /// No description provided for @legacyUiaef46d6729.
  ///
  /// In en, this message translates to:
  /// **'Could not read selected file'**
  String get legacyUiaef46d6729;

  /// No description provided for @legacyUi280c98ccef.
  ///
  /// In en, this message translates to:
  /// **'Country filter'**
  String get legacyUi280c98ccef;

  /// No description provided for @legacyUi1c9a9315c9.
  ///
  /// In en, this message translates to:
  /// **'Country is required.'**
  String get legacyUi1c9a9315c9;

  /// No description provided for @legacyUid82b56cad9.
  ///
  /// In en, this message translates to:
  /// **'Course'**
  String get legacyUid82b56cad9;

  /// No description provided for @legacyUi6e157c5da4.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get legacyUi6e157c5da4;

  /// No description provided for @legacyUi318d1da4e0.
  ///
  /// In en, this message translates to:
  /// **'Create Admin'**
  String get legacyUi318d1da4e0;

  /// No description provided for @legacyUi0a62dd4d37.
  ///
  /// In en, this message translates to:
  /// **'Create Driver'**
  String get legacyUi0a62dd4d37;

  /// No description provided for @legacyUie3429ab78d.
  ///
  /// In en, this message translates to:
  /// **'Create Geofence'**
  String get legacyUie3429ab78d;

  /// No description provided for @legacyUidb7c457634.
  ///
  /// In en, this message translates to:
  /// **'Create POI'**
  String get legacyUidb7c457634;

  /// No description provided for @legacyUicdd060d443.
  ///
  /// In en, this message translates to:
  /// **'Create Pricing Plan'**
  String get legacyUicdd060d443;

  /// No description provided for @legacyUi5d16c5ffd7.
  ///
  /// In en, this message translates to:
  /// **'Create Sub User'**
  String get legacyUi5d16c5ffd7;

  /// No description provided for @legacyUiafe9a7ae15.
  ///
  /// In en, this message translates to:
  /// **'Create Ticket'**
  String get legacyUiafe9a7ae15;

  /// No description provided for @legacyUib25c91fe61.
  ///
  /// In en, this message translates to:
  /// **'Create User'**
  String get legacyUib25c91fe61;

  /// No description provided for @legacyUi705b0946b2.
  ///
  /// In en, this message translates to:
  /// **'Create Vehicle'**
  String get legacyUi705b0946b2;

  /// No description provided for @legacyUi22a6b9d964.
  ///
  /// In en, this message translates to:
  /// **'Create a dashboard from the web application to view it here.'**
  String get legacyUi22a6b9d964;

  /// No description provided for @legacyUi769479a4d5.
  ///
  /// In en, this message translates to:
  /// **'Create a public track link to share live vehicle tracking.'**
  String get legacyUi769479a4d5;

  /// No description provided for @legacyUi50aab1f7b5.
  ///
  /// In en, this message translates to:
  /// **'Create a sensor for this vehicle.'**
  String get legacyUi50aab1f7b5;

  /// No description provided for @legacyUi0d2cd08b59.
  ///
  /// In en, this message translates to:
  /// **'Create administrator'**
  String get legacyUi0d2cd08b59;

  /// No description provided for @legacyUi6f876ff9c0.
  ///
  /// In en, this message translates to:
  /// **'Create at least one item before exporting.'**
  String get legacyUi6f876ff9c0;

  /// No description provided for @legacyUic42adee4d7.
  ///
  /// In en, this message translates to:
  /// **'Create device without leaving this form'**
  String get legacyUic42adee4d7;

  /// No description provided for @legacyUiaba922c9b5.
  ///
  /// In en, this message translates to:
  /// **'Create driver'**
  String get legacyUiaba922c9b5;

  /// No description provided for @legacyUi6efd8652f4.
  ///
  /// In en, this message translates to:
  /// **'Create drivers, manage assigned vehicles, documents, and driver activity.'**
  String get legacyUi6efd8652f4;

  /// No description provided for @legacyUiba98384ac3.
  ///
  /// In en, this message translates to:
  /// **'Create geofences to configure geofence notifications.'**
  String get legacyUiba98384ac3;

  /// No description provided for @legacyUif7b868f7d4.
  ///
  /// In en, this message translates to:
  /// **'Create points of interest with category, icon, color, and tolerance radius.'**
  String get legacyUif7b868f7d4;

  /// No description provided for @legacyUie42ed33e33.
  ///
  /// In en, this message translates to:
  /// **'Create pricing plan without leaving this form'**
  String get legacyUie42ed33e33;

  /// No description provided for @legacyUie40f966076.
  ///
  /// In en, this message translates to:
  /// **'Create route lines manually or from source and destination where supported.'**
  String get legacyUie40f966076;

  /// No description provided for @legacyUi567e040ce2.
  ///
  /// In en, this message translates to:
  /// **'Create routes to configure route deviation notifications.'**
  String get legacyUi567e040ce2;

  /// No description provided for @legacyUica09bbf34d.
  ///
  /// In en, this message translates to:
  /// **'Create sub users and control which vehicles they can access.'**
  String get legacyUica09bbf34d;

  /// No description provided for @legacyUi3afcbed7e6.
  ///
  /// In en, this message translates to:
  /// **'Create ticket'**
  String get legacyUi3afcbed7e6;

  /// No description provided for @legacyUibdbcfa0af0.
  ///
  /// In en, this message translates to:
  /// **'Create user'**
  String get legacyUibdbcfa0af0;

  /// No description provided for @legacyUie7358de58e.
  ///
  /// In en, this message translates to:
  /// **'Create user without leaving this vehicle form'**
  String get legacyUie7358de58e;

  /// No description provided for @legacyUi505a950fbb.
  ///
  /// In en, this message translates to:
  /// **'Create vehicle'**
  String get legacyUi505a950fbb;

  /// No description provided for @legacyUi1ef0c932b3.
  ///
  /// In en, this message translates to:
  /// **'Create your first driver to start assignments.'**
  String get legacyUi1ef0c932b3;

  /// No description provided for @legacyUi7d3ca14313.
  ///
  /// In en, this message translates to:
  /// **'Create your first geofence to define operational boundaries.'**
  String get legacyUi7d3ca14313;

  /// No description provided for @legacyUi60a39e1fde.
  ///
  /// In en, this message translates to:
  /// **'Create your first place to track operational points.'**
  String get legacyUi60a39e1fde;

  /// No description provided for @legacyUi4fbf4f09cd.
  ///
  /// In en, this message translates to:
  /// **'Create your first sub user to share selected access.'**
  String get legacyUi4fbf4f09cd;

  /// No description provided for @legacyUiaccf40c89b.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get legacyUiaccf40c89b;

  /// No description provided for @legacyUia5682ef199.
  ///
  /// In en, this message translates to:
  /// **'Created : '**
  String get legacyUia5682ef199;

  /// No description provided for @legacyUi5db1542e68.
  ///
  /// In en, this message translates to:
  /// **'Created At'**
  String get legacyUi5db1542e68;

  /// No description provided for @legacyUif1c69716be.
  ///
  /// In en, this message translates to:
  /// **'Created at'**
  String get legacyUif1c69716be;

  /// No description provided for @legacyUidd097a2297.
  ///
  /// In en, this message translates to:
  /// **'Credentials'**
  String get legacyUidd097a2297;

  /// No description provided for @legacyUi9f58b9e39b.
  ///
  /// In en, this message translates to:
  /// **'Credentials the administrator will use to sign into OpenVTS.'**
  String get legacyUi9f58b9e39b;

  /// No description provided for @legacyUiec535bab6f.
  ///
  /// In en, this message translates to:
  /// **'Credentials the user will use to sign into OpenVTS.'**
  String get legacyUiec535bab6f;

  /// No description provided for @legacyUi8a45d339a6.
  ///
  /// In en, this message translates to:
  /// **'Credit'**
  String get legacyUi8a45d339a6;

  /// No description provided for @legacyUic3dc6e3ef9.
  ///
  /// In en, this message translates to:
  /// **'Credit, payment, or billing updates will appear here.'**
  String get legacyUic3dc6e3ef9;

  /// No description provided for @legacyUibfac50d642.
  ///
  /// In en, this message translates to:
  /// **'Credits'**
  String get legacyUibfac50d642;

  /// No description provided for @legacyUie070de2244.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get legacyUie070de2244;

  /// No description provided for @legacyUiea4b114ac6.
  ///
  /// In en, this message translates to:
  /// **'Current State'**
  String get legacyUiea4b114ac6;

  /// No description provided for @legacyUieeed986410.
  ///
  /// In en, this message translates to:
  /// **'Current credits'**
  String get legacyUieeed986410;

  /// No description provided for @legacyUibe1ac4e322.
  ///
  /// In en, this message translates to:
  /// **'Current step'**
  String get legacyUibe1ac4e322;

  /// No description provided for @legacyUi9c378938cd.
  ///
  /// In en, this message translates to:
  /// **'Custom Command'**
  String get legacyUi9c378938cd;

  /// No description provided for @legacyUi28be3fd018.
  ///
  /// In en, this message translates to:
  /// **'Custom Domain'**
  String get legacyUi28be3fd018;

  /// No description provided for @legacyUif130609dfc.
  ///
  /// In en, this message translates to:
  /// **'Custom Range'**
  String get legacyUif130609dfc;

  /// No description provided for @legacyUia9d9e61bf2.
  ///
  /// In en, this message translates to:
  /// **'Custom category (e.g. \"vendor\")'**
  String get legacyUia9d9e61bf2;

  /// No description provided for @legacyUi0354c8896b.
  ///
  /// In en, this message translates to:
  /// **'Custom domain'**
  String get legacyUi0354c8896b;

  /// No description provided for @legacyUi3a55eba66f.
  ///
  /// In en, this message translates to:
  /// **'Custom domain and brand color.'**
  String get legacyUi3a55eba66f;

  /// No description provided for @legacyUi9f1d0368da.
  ///
  /// In en, this message translates to:
  /// **'Customer expiry'**
  String get legacyUi9f1d0368da;

  /// No description provided for @legacyUi1588fe44aa.
  ///
  /// In en, this message translates to:
  /// **'Customer expiry date'**
  String get legacyUi1588fe44aa;

  /// No description provided for @legacyUib13a49701d.
  ///
  /// In en, this message translates to:
  /// **'Customer renewal requests'**
  String get legacyUib13a49701d;

  /// No description provided for @legacyUi0c919bd08d.
  ///
  /// In en, this message translates to:
  /// **'Customer service expires'**
  String get legacyUi0c919bd08d;

  /// No description provided for @legacyUidce04fd315.
  ///
  /// In en, this message translates to:
  /// **'Custom…'**
  String get legacyUidce04fd315;

  /// No description provided for @legacyUi118de3988f.
  ///
  /// In en, this message translates to:
  /// **'Cutoff'**
  String get legacyUi118de3988f;

  /// No description provided for @legacyUi5c487cb2d8.
  ///
  /// In en, this message translates to:
  /// **'Daily revenue points are not available for this range.'**
  String get legacyUi5c487cb2d8;

  /// No description provided for @legacyUi99c0019cc6.
  ///
  /// In en, this message translates to:
  /// **'Dark Logo'**
  String get legacyUi99c0019cc6;

  /// No description provided for @legacyUia167278399.
  ///
  /// In en, this message translates to:
  /// **'Dark logo updated'**
  String get legacyUia167278399;

  /// No description provided for @legacyUi2b197ef6be.
  ///
  /// In en, this message translates to:
  /// **'Database and live telemetry logs will appear here.'**
  String get legacyUi2b197ef6be;

  /// No description provided for @legacyUi6bb4b674b3.
  ///
  /// In en, this message translates to:
  /// **'Date Range'**
  String get legacyUi6bb4b674b3;

  /// No description provided for @legacyUie3d06ca6a1.
  ///
  /// In en, this message translates to:
  /// **'Date Time Range'**
  String get legacyUie3d06ca6a1;

  /// No description provided for @legacyUic65ea4ae01.
  ///
  /// In en, this message translates to:
  /// **'Date range'**
  String get legacyUic65ea4ae01;

  /// No description provided for @legacyUi853aab7f56.
  ///
  /// In en, this message translates to:
  /// **'Date/Time'**
  String get legacyUi853aab7f56;

  /// No description provided for @legacyUi842b7b5d71.
  ///
  /// In en, this message translates to:
  /// **'Dates'**
  String get legacyUi842b7b5d71;

  /// No description provided for @legacyUi987b9ced08.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get legacyUi987b9ced08;

  /// No description provided for @legacyUi82c29dd5fa.
  ///
  /// In en, this message translates to:
  /// **'Day / Night Comparison'**
  String get legacyUi82c29dd5fa;

  /// No description provided for @legacyUibfb1ba6e3e.
  ///
  /// In en, this message translates to:
  /// **'Day / Night Range'**
  String get legacyUibfb1ba6e3e;

  /// No description provided for @legacyUicf558941e0.
  ///
  /// In en, this message translates to:
  /// **'Debit'**
  String get legacyUicf558941e0;

  /// No description provided for @legacyUibb3cec5175.
  ///
  /// In en, this message translates to:
  /// **'Deduct credits'**
  String get legacyUibb3cec5175;

  /// No description provided for @legacyUi6bccca646f.
  ///
  /// In en, this message translates to:
  /// **'Deducted'**
  String get legacyUi6bccca646f;

  /// No description provided for @legacyUi1dcab135ef.
  ///
  /// In en, this message translates to:
  /// **'Dedupe'**
  String get legacyUi1dcab135ef;

  /// No description provided for @legacyUi15462a4954.
  ///
  /// In en, this message translates to:
  /// **'Dedupe duplicate events'**
  String get legacyUi15462a4954;

  /// No description provided for @legacyUi6184deb041.
  ///
  /// In en, this message translates to:
  /// **'Default plan'**
  String get legacyUi6184deb041;

  /// No description provided for @legacyUiee1b9a9f23.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get legacyUiee1b9a9f23;

  /// No description provided for @legacyUie81c14c990.
  ///
  /// In en, this message translates to:
  /// **'Delete Driver'**
  String get legacyUie81c14c990;

  /// No description provided for @legacyUi749f8e14e3.
  ///
  /// In en, this message translates to:
  /// **'Delete Sub User'**
  String get legacyUi749f8e14e3;

  /// No description provided for @legacyUi0a0a90f6c5.
  ///
  /// In en, this message translates to:
  /// **'Delete User'**
  String get legacyUi0a0a90f6c5;

  /// No description provided for @legacyUi4bcd1233a1.
  ///
  /// In en, this message translates to:
  /// **'Delete admin'**
  String get legacyUi4bcd1233a1;

  /// No description provided for @legacyUi6fd38c1fb9.
  ///
  /// In en, this message translates to:
  /// **'Delete administrator'**
  String get legacyUi6fd38c1fb9;

  /// No description provided for @legacyUie8df0b7902.
  ///
  /// In en, this message translates to:
  /// **'Delete document'**
  String get legacyUie8df0b7902;

  /// No description provided for @legacyUi4ecae3e148.
  ///
  /// In en, this message translates to:
  /// **'Delete document?'**
  String get legacyUi4ecae3e148;

  /// No description provided for @legacyUid1571af327.
  ///
  /// In en, this message translates to:
  /// **'Delete driver account'**
  String get legacyUid1571af327;

  /// No description provided for @legacyUia34ada32da.
  ///
  /// In en, this message translates to:
  /// **'Delete sensor'**
  String get legacyUia34ada32da;

  /// No description provided for @legacyUi1ce5593800.
  ///
  /// In en, this message translates to:
  /// **'Delete this document?'**
  String get legacyUi1ce5593800;

  /// No description provided for @legacyUi6a58093cab.
  ///
  /// In en, this message translates to:
  /// **'Delete track link'**
  String get legacyUi6a58093cab;

  /// No description provided for @legacyUi9afe6c7b95.
  ///
  /// In en, this message translates to:
  /// **'Delete user'**
  String get legacyUi9afe6c7b95;

  /// No description provided for @legacyUif7ff7065a9.
  ///
  /// In en, this message translates to:
  /// **'Delete vehicle'**
  String get legacyUif7ff7065a9;

  /// No description provided for @legacyUi441bda6cd8.
  ///
  /// In en, this message translates to:
  /// **'Deleted'**
  String get legacyUi441bda6cd8;

  /// No description provided for @legacyUif7c094a571.
  ///
  /// In en, this message translates to:
  /// **'Deleted rows'**
  String get legacyUif7c094a571;

  /// No description provided for @legacyUic6bdaac949.
  ///
  /// In en, this message translates to:
  /// **'Delhi'**
  String get legacyUic6bdaac949;

  /// No description provided for @legacyUibc4f986ecb.
  ///
  /// In en, this message translates to:
  /// **'Deliveries'**
  String get legacyUibc4f986ecb;

  /// No description provided for @legacyUi921a6f6b55.
  ///
  /// In en, this message translates to:
  /// **'Delivery Logs'**
  String get legacyUi921a6f6b55;

  /// No description provided for @legacyUib2c4e6cb46.
  ///
  /// In en, this message translates to:
  /// **'Demo Login'**
  String get legacyUib2c4e6cb46;

  /// No description provided for @legacyUi4675a25777.
  ///
  /// In en, this message translates to:
  /// **'Demo login'**
  String get legacyUi4675a25777;

  /// No description provided for @legacyUi59013d16af.
  ///
  /// In en, this message translates to:
  /// **'Describe the request or issue'**
  String get legacyUi59013d16af;

  /// No description provided for @legacyUi55f8ebc805.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get legacyUi55f8ebc805;

  /// No description provided for @legacyUi388de6fa3a.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get legacyUi388de6fa3a;

  /// No description provided for @legacyUi763630a9ce.
  ///
  /// In en, this message translates to:
  /// **'Description is required.'**
  String get legacyUi763630a9ce;

  /// No description provided for @legacyUi8a96cce5e5.
  ///
  /// In en, this message translates to:
  /// **'Description must contain at least one letter or number.'**
  String get legacyUi8a96cce5e5;

  /// No description provided for @legacyUidc3decbb93.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get legacyUidc3decbb93;

  /// No description provided for @legacyUia5a74a6df0.
  ///
  /// In en, this message translates to:
  /// **'Device'**
  String get legacyUia5a74a6df0;

  /// No description provided for @legacyUid69ba8a9eb.
  ///
  /// In en, this message translates to:
  /// **'Device + SIM'**
  String get legacyUid69ba8a9eb;

  /// No description provided for @legacyUic587837fda.
  ///
  /// In en, this message translates to:
  /// **'Device IMEI'**
  String get legacyUic587837fda;

  /// No description provided for @legacyUif59a7a21bb.
  ///
  /// In en, this message translates to:
  /// **'Device Installs'**
  String get legacyUif59a7a21bb;

  /// No description provided for @legacyUi219288726d.
  ///
  /// In en, this message translates to:
  /// **'Device Only'**
  String get legacyUi219288726d;

  /// No description provided for @legacyUi554dd558bd.
  ///
  /// In en, this message translates to:
  /// **'Device Summary'**
  String get legacyUi554dd558bd;

  /// No description provided for @legacyUi20d5df8b4a.
  ///
  /// In en, this message translates to:
  /// **'Device Type'**
  String get legacyUi20d5df8b4a;

  /// No description provided for @legacyUi30de920ef1.
  ///
  /// In en, this message translates to:
  /// **'Device created and selected'**
  String get legacyUi30de920ef1;

  /// No description provided for @legacyUi3c47b57c83.
  ///
  /// In en, this message translates to:
  /// **'Device response'**
  String get legacyUi3c47b57c83;

  /// No description provided for @legacyUi6d2870160a.
  ///
  /// In en, this message translates to:
  /// **'Device time'**
  String get legacyUi6d2870160a;

  /// No description provided for @legacyUi21fe5a18d0.
  ///
  /// In en, this message translates to:
  /// **'Device updated.'**
  String get legacyUi21fe5a18d0;

  /// No description provided for @legacyUidf485c8713.
  ///
  /// In en, this message translates to:
  /// **'Devices'**
  String get legacyUidf485c8713;

  /// No description provided for @legacyUibb73469225.
  ///
  /// In en, this message translates to:
  /// **'Disable without deleting the link.'**
  String get legacyUibb73469225;

  /// No description provided for @legacyUid3e4b30e10.
  ///
  /// In en, this message translates to:
  /// **'Discard & Refresh'**
  String get legacyUid3e4b30e10;

  /// No description provided for @legacyUi427dc4f0cd.
  ///
  /// In en, this message translates to:
  /// **'Discard new administrator?'**
  String get legacyUi427dc4f0cd;

  /// No description provided for @legacyUid1b8679c63.
  ///
  /// In en, this message translates to:
  /// **'Discard new user?'**
  String get legacyUid1b8679c63;

  /// No description provided for @legacyUi6012a2d760.
  ///
  /// In en, this message translates to:
  /// **'Discard new vehicle?'**
  String get legacyUi6012a2d760;

  /// No description provided for @legacyUifb0a3e6787.
  ///
  /// In en, this message translates to:
  /// **'Disk Usage'**
  String get legacyUifb0a3e6787;

  /// No description provided for @legacyUi70afe9eff3.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get legacyUi70afe9eff3;

  /// No description provided for @legacyUi515aa7ad86.
  ///
  /// In en, this message translates to:
  /// **'Display assigned geofence context.'**
  String get legacyUi515aa7ad86;

  /// No description provided for @legacyUi37bbdde1a6.
  ///
  /// In en, this message translates to:
  /// **'Display geofence boundaries on the map'**
  String get legacyUi37bbdde1a6;

  /// No description provided for @legacyUi2eebf5225a.
  ///
  /// In en, this message translates to:
  /// **'Display saved routes on the map'**
  String get legacyUi2eebf5225a;

  /// No description provided for @legacyUifb71a3779e.
  ///
  /// In en, this message translates to:
  /// **'Distance Multiplier'**
  String get legacyUifb71a3779e;

  /// No description provided for @legacyUib3262ecb53.
  ///
  /// In en, this message translates to:
  /// **'Distance Variation'**
  String get legacyUib3262ecb53;

  /// No description provided for @legacyUiac3f0eb0ea.
  ///
  /// In en, this message translates to:
  /// **'Distance/Hours'**
  String get legacyUiac3f0eb0ea;

  /// No description provided for @legacyUi2c21f68832.
  ///
  /// In en, this message translates to:
  /// **'Document Type'**
  String get legacyUi2c21f68832;

  /// No description provided for @legacyUi7615530d7a.
  ///
  /// In en, this message translates to:
  /// **'Document URL is unavailable.'**
  String get legacyUi7615530d7a;

  /// No description provided for @legacyUi6dad05c10e.
  ///
  /// In en, this message translates to:
  /// **'Document actions'**
  String get legacyUi6dad05c10e;

  /// No description provided for @legacyUibd9a0f027e.
  ///
  /// In en, this message translates to:
  /// **'Document deleted.'**
  String get legacyUibd9a0f027e;

  /// No description provided for @legacyUi3859bdaa8c.
  ///
  /// In en, this message translates to:
  /// **'Document title'**
  String get legacyUi3859bdaa8c;

  /// No description provided for @legacyUi300b6ef0cd.
  ///
  /// In en, this message translates to:
  /// **'Document type'**
  String get legacyUi300b6ef0cd;

  /// No description provided for @legacyUi9b10914d8b.
  ///
  /// In en, this message translates to:
  /// **'Domain'**
  String get legacyUi9b10914d8b;

  /// No description provided for @legacyUifb349182fc.
  ///
  /// In en, this message translates to:
  /// **'Domain & Color'**
  String get legacyUifb349182fc;

  /// No description provided for @legacyUi8b58eea04e.
  ///
  /// In en, this message translates to:
  /// **'Domain and brand color saved'**
  String get legacyUi8b58eea04e;

  /// No description provided for @legacyUi0ec2ae5cda.
  ///
  /// In en, this message translates to:
  /// **'Domain, logos, favicon, and brand color.'**
  String get legacyUi0ec2ae5cda;

  /// No description provided for @legacyUibfa50c7a38.
  ///
  /// In en, this message translates to:
  /// **'Draw'**
  String get legacyUibfa50c7a38;

  /// No description provided for @legacyUi2e617aeb36.
  ///
  /// In en, this message translates to:
  /// **'Draw circles, polygons, rectangles, and line boundaries on the map.'**
  String get legacyUi2e617aeb36;

  /// No description provided for @legacyUid952b9d3da.
  ///
  /// In en, this message translates to:
  /// **'Draw your first route corridor to start tracking.'**
  String get legacyUid952b9d3da;

  /// No description provided for @legacyUi0ecf1d5bc0.
  ///
  /// In en, this message translates to:
  /// **'Driven'**
  String get legacyUi0ecf1d5bc0;

  /// No description provided for @legacyUi845a6bd3ab.
  ///
  /// In en, this message translates to:
  /// **'Driver Profile'**
  String get legacyUi845a6bd3ab;

  /// No description provided for @legacyUi450d68e4fe.
  ///
  /// In en, this message translates to:
  /// **'Driver actions'**
  String get legacyUi450d68e4fe;

  /// No description provided for @legacyUid1ba6aea38.
  ///
  /// In en, this message translates to:
  /// **'Driver assigned.'**
  String get legacyUid1ba6aea38;

  /// No description provided for @legacyUifbaa386fbc.
  ///
  /// In en, this message translates to:
  /// **'Driver assignment and profile activity will appear here.'**
  String get legacyUifbaa386fbc;

  /// No description provided for @legacyUi017bb97653.
  ///
  /// In en, this message translates to:
  /// **'Driver created.'**
  String get legacyUi017bb97653;

  /// No description provided for @legacyUif8acdd5348.
  ///
  /// In en, this message translates to:
  /// **'Driver creation or driver updates will appear here.'**
  String get legacyUif8acdd5348;

  /// No description provided for @legacyUib057fefdc2.
  ///
  /// In en, this message translates to:
  /// **'Driver deleted.'**
  String get legacyUib057fefdc2;

  /// No description provided for @legacyUi63a7342acd.
  ///
  /// In en, this message translates to:
  /// **'Driver name'**
  String get legacyUi63a7342acd;

  /// No description provided for @legacyUi8d30cc59a1.
  ///
  /// In en, this message translates to:
  /// **'Driver unassigned.'**
  String get legacyUi8d30cc59a1;

  /// No description provided for @legacyUia010b0a25f.
  ///
  /// In en, this message translates to:
  /// **'Driver updated.'**
  String get legacyUia010b0a25f;

  /// No description provided for @legacyUifdd68e9960.
  ///
  /// In en, this message translates to:
  /// **'Driver workspace'**
  String get legacyUifdd68e9960;

  /// No description provided for @legacyUi3d14659ca9.
  ///
  /// In en, this message translates to:
  /// **'Dry-run'**
  String get legacyUi3d14659ca9;

  /// No description provided for @legacyUi87bd16c150.
  ///
  /// In en, this message translates to:
  /// **'Dry-run completed'**
  String get legacyUi87bd16c150;

  /// No description provided for @legacyUi91310be76f.
  ///
  /// In en, this message translates to:
  /// **'Dubai'**
  String get legacyUi91310be76f;

  /// No description provided for @legacyUi1370004da7.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get legacyUi1370004da7;

  /// No description provided for @legacyUia051787af6.
  ///
  /// In en, this message translates to:
  /// **'Each attachment must be 5MB or smaller.'**
  String get legacyUia051787af6;

  /// No description provided for @legacyUi9bb58b2d1b.
  ///
  /// In en, this message translates to:
  /// **'East'**
  String get legacyUi9bb58b2d1b;

  /// No description provided for @legacyUi7de491bedc.
  ///
  /// In en, this message translates to:
  /// **'Edit Company'**
  String get legacyUi7de491bedc;

  /// No description provided for @legacyUi5b7faa9d61.
  ///
  /// In en, this message translates to:
  /// **'Edit Device'**
  String get legacyUi5b7faa9d61;

  /// No description provided for @legacyUicf5ddc10b3.
  ///
  /// In en, this message translates to:
  /// **'Edit Driver'**
  String get legacyUicf5ddc10b3;

  /// No description provided for @legacyUi13a7a7c3a7.
  ///
  /// In en, this message translates to:
  /// **'Edit Plan'**
  String get legacyUi13a7a7c3a7;

  /// No description provided for @legacyUicd280a41f7.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get legacyUicd280a41f7;

  /// No description provided for @legacyUi19d57bd021.
  ///
  /// In en, this message translates to:
  /// **'Edit SIM'**
  String get legacyUi19d57bd021;

  /// No description provided for @legacyUi4a0fe224b9.
  ///
  /// In en, this message translates to:
  /// **'Edit Sensor'**
  String get legacyUi4a0fe224b9;

  /// No description provided for @legacyUic8e262db5b.
  ///
  /// In en, this message translates to:
  /// **'Edit Sub User'**
  String get legacyUic8e262db5b;

  /// No description provided for @legacyUi38a1cb0f89.
  ///
  /// In en, this message translates to:
  /// **'Edit Team Member'**
  String get legacyUi38a1cb0f89;

  /// No description provided for @legacyUi0e457253ad.
  ///
  /// In en, this message translates to:
  /// **'Edit User'**
  String get legacyUi0e457253ad;

  /// No description provided for @legacyUib213eb6d7b.
  ///
  /// In en, this message translates to:
  /// **'Edit Vehicle'**
  String get legacyUib213eb6d7b;

  /// No description provided for @legacyUid03750ccbf.
  ///
  /// In en, this message translates to:
  /// **'Edit company'**
  String get legacyUid03750ccbf;

  /// No description provided for @legacyUi15141eab3a.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get legacyUi15141eab3a;

  /// No description provided for @legacyUi84add5b295.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get legacyUi84add5b295;

  /// No description provided for @legacyUi5c10b588a9.
  ///
  /// In en, this message translates to:
  /// **'Email (optional)'**
  String get legacyUi5c10b588a9;

  /// No description provided for @legacyUi094f6a5934.
  ///
  /// In en, this message translates to:
  /// **'Email or username'**
  String get legacyUi094f6a5934;

  /// No description provided for @legacyUi79d1feaf62.
  ///
  /// In en, this message translates to:
  /// **'Email status'**
  String get legacyUi79d1feaf62;

  /// No description provided for @legacyUia674e88b73.
  ///
  /// In en, this message translates to:
  /// **'Email verification'**
  String get legacyUia674e88b73;

  /// No description provided for @legacyUic1feb155ec.
  ///
  /// In en, this message translates to:
  /// **'Enable demo login'**
  String get legacyUic1feb155ec;

  /// No description provided for @legacyUi7cf7a0d02a.
  ///
  /// In en, this message translates to:
  /// **'Enable public signup'**
  String get legacyUi7cf7a0d02a;

  /// No description provided for @legacyUif6321257f1.
  ///
  /// In en, this message translates to:
  /// **'Enable this public link.'**
  String get legacyUif6321257f1;

  /// No description provided for @legacyUid093b28018.
  ///
  /// In en, this message translates to:
  /// **'Enable/Refresh'**
  String get legacyUid093b28018;

  /// No description provided for @legacyUi0af149c2ed.
  ///
  /// In en, this message translates to:
  /// **'Encryption'**
  String get legacyUi0af149c2ed;

  /// No description provided for @legacyUic1f65ddb75.
  ///
  /// In en, this message translates to:
  /// **'Engine'**
  String get legacyUic1f65ddb75;

  /// No description provided for @legacyUi49dda3d71a.
  ///
  /// In en, this message translates to:
  /// **'Engine hours'**
  String get legacyUi49dda3d71a;

  /// No description provided for @legacyUi4c9c7856d1.
  ///
  /// In en, this message translates to:
  /// **'Enter 6-digit code'**
  String get legacyUi4c9c7856d1;

  /// No description provided for @legacyUibc96ad8350.
  ///
  /// In en, this message translates to:
  /// **'Enter a decimal amount with at most 2 decimal places'**
  String get legacyUibc96ad8350;

  /// No description provided for @legacyUib0e59c93d7.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid amount.'**
  String get legacyUib0e59c93d7;

  /// No description provided for @legacyUi6d59e6aee7.
  ///
  /// In en, this message translates to:
  /// **'Enter an override reason of 5–500 characters'**
  String get legacyUi6d59e6aee7;

  /// No description provided for @legacyUi571c7347b7.
  ///
  /// In en, this message translates to:
  /// **'Enter an override reason of 5–500 characters.'**
  String get legacyUi571c7347b7;

  /// No description provided for @legacyUi18b809c9fb.
  ///
  /// In en, this message translates to:
  /// **'Enter command text'**
  String get legacyUi18b809c9fb;

  /// No description provided for @legacyUid5cd51c7b9.
  ///
  /// In en, this message translates to:
  /// **'Enter credit amount'**
  String get legacyUid5cd51c7b9;

  /// No description provided for @legacyUibe7572b6c5.
  ///
  /// In en, this message translates to:
  /// **'Enter state or territory'**
  String get legacyUibe7572b6c5;

  /// No description provided for @legacyUid148321ad7.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code'**
  String get legacyUid148321ad7;

  /// No description provided for @legacyUi0d639c50f1.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code we sent you'**
  String get legacyUi0d639c50f1;

  /// No description provided for @legacyUi6d1e849865.
  ///
  /// In en, this message translates to:
  /// **'Enter the OTP sent to your registered contact.'**
  String get legacyUi6d1e849865;

  /// No description provided for @legacyUied634c4edc.
  ///
  /// In en, this message translates to:
  /// **'Enter the email address or username used to sign in. If the account exists, we will send a time-limited reset link.'**
  String get legacyUied634c4edc;

  /// No description provided for @legacyUi1378167d52.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get legacyUi1378167d52;

  /// No description provided for @legacyUib6334ab817.
  ///
  /// In en, this message translates to:
  /// **'Enter your username or email'**
  String get legacyUib6334ab817;

  /// No description provided for @legacyUic7fb317725.
  ///
  /// In en, this message translates to:
  /// **'Entity'**
  String get legacyUic7fb317725;

  /// No description provided for @legacyUi04d694e298.
  ///
  /// In en, this message translates to:
  /// **'Entity ID'**
  String get legacyUi04d694e298;

  /// No description provided for @legacyUi948542c1d6.
  ///
  /// In en, this message translates to:
  /// **'Error/Critical'**
  String get legacyUi948542c1d6;

  /// No description provided for @legacyUic250d77524.
  ///
  /// In en, this message translates to:
  /// **'Event Details'**
  String get legacyUic250d77524;

  /// No description provided for @legacyUi894b1c749d.
  ///
  /// In en, this message translates to:
  /// **'Event ID'**
  String get legacyUi894b1c749d;

  /// No description provided for @legacyUif8e451a5d0.
  ///
  /// In en, this message translates to:
  /// **'Events unavailable'**
  String get legacyUif8e451a5d0;

  /// No description provided for @legacyUief09596668.
  ///
  /// In en, this message translates to:
  /// **'Exit Demo'**
  String get legacyUief09596668;

  /// No description provided for @legacyUia689a999a5.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get legacyUia689a999a5;

  /// No description provided for @legacyUib98d67213b.
  ///
  /// In en, this message translates to:
  /// **'Expiring'**
  String get legacyUib98d67213b;

  /// No description provided for @legacyUi57fe01159c.
  ///
  /// In en, this message translates to:
  /// **'Expiry Date (Optional)'**
  String get legacyUi57fe01159c;

  /// No description provided for @legacyUi1275b51587.
  ///
  /// In en, this message translates to:
  /// **'Expiry Date/Time'**
  String get legacyUi1275b51587;

  /// No description provided for @legacyUi6b440cd506.
  ///
  /// In en, this message translates to:
  /// **'Expiry date'**
  String get legacyUi6b440cd506;

  /// No description provided for @legacyUic9f6710324.
  ///
  /// In en, this message translates to:
  /// **'Expiry must be in the future.'**
  String get legacyUic9f6710324;

  /// No description provided for @legacyUif3e4fadb9e.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get legacyUif3e4fadb9e;

  /// No description provided for @legacyUi416a52a386.
  ///
  /// In en, this message translates to:
  /// **'Export KML'**
  String get legacyUi416a52a386;

  /// No description provided for @legacyUi09b28aeb8d.
  ///
  /// In en, this message translates to:
  /// **'FCM Token'**
  String get legacyUi09b28aeb8d;

  /// No description provided for @legacyUic2bf1a9df5.
  ///
  /// In en, this message translates to:
  /// **'FCM token last 10'**
  String get legacyUic2bf1a9df5;

  /// No description provided for @legacyUi82da67b211.
  ///
  /// In en, this message translates to:
  /// **'Facebook'**
  String get legacyUi82da67b211;

  /// No description provided for @legacyUi09fef5d8d9.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get legacyUi09fef5d8d9;

  /// No description provided for @legacyUid68666787d.
  ///
  /// In en, this message translates to:
  /// **'Failed tables'**
  String get legacyUid68666787d;

  /// No description provided for @legacyUi706b9a59b6.
  ///
  /// In en, this message translates to:
  /// **'Failed to load cities'**
  String get legacyUi706b9a59b6;

  /// No description provided for @legacyUi6eb9516fdf.
  ///
  /// In en, this message translates to:
  /// **'Failed to load countries'**
  String get legacyUi6eb9516fdf;

  /// No description provided for @legacyUi4bc4b2e555.
  ///
  /// In en, this message translates to:
  /// **'Failed to load details'**
  String get legacyUi4bc4b2e555;

  /// No description provided for @legacyUia7bc426a05.
  ///
  /// In en, this message translates to:
  /// **'Failed to load full vehicle details.'**
  String get legacyUia7bc426a05;

  /// No description provided for @legacyUia17267ffa7.
  ///
  /// In en, this message translates to:
  /// **'Failed to load states'**
  String get legacyUia17267ffa7;

  /// No description provided for @legacyUi6bb1f1d9fb.
  ///
  /// In en, this message translates to:
  /// **'Failed to update status.'**
  String get legacyUi6bb1f1d9fb;

  /// No description provided for @legacyUi1656649117.
  ///
  /// In en, this message translates to:
  /// **'Failure'**
  String get legacyUi1656649117;

  /// No description provided for @legacyUib7ef43c84d.
  ///
  /// In en, this message translates to:
  /// **'Failure Code'**
  String get legacyUib7ef43c84d;

  /// No description provided for @legacyUi41510b1b21.
  ///
  /// In en, this message translates to:
  /// **'Failure Message'**
  String get legacyUi41510b1b21;

  /// No description provided for @legacyUi8db6a2f1d3.
  ///
  /// In en, this message translates to:
  /// **'Fast'**
  String get legacyUi8db6a2f1d3;

  /// No description provided for @legacyUiadc7ac2ae5.
  ///
  /// In en, this message translates to:
  /// **'Faster'**
  String get legacyUiadc7ac2ae5;

  /// No description provided for @legacyUib0f47aaf77.
  ///
  /// In en, this message translates to:
  /// **'Favicon'**
  String get legacyUib0f47aaf77;

  /// No description provided for @legacyUi7d9baea15f.
  ///
  /// In en, this message translates to:
  /// **'Favicon updated'**
  String get legacyUi7d9baea15f;

  /// No description provided for @legacyUi2c3cafa4db.
  ///
  /// In en, this message translates to:
  /// **'File'**
  String get legacyUi2c3cafa4db;

  /// No description provided for @legacyUi55fee60744.
  ///
  /// In en, this message translates to:
  /// **'File URL is not available.'**
  String get legacyUi55fee60744;

  /// No description provided for @legacyUif76f22f075.
  ///
  /// In en, this message translates to:
  /// **'File exceeds 10MB limit.'**
  String get legacyUif76f22f075;

  /// No description provided for @legacyUi7e184124be.
  ///
  /// In en, this message translates to:
  /// **'File is required.'**
  String get legacyUi7e184124be;

  /// No description provided for @legacyUi36f2202687.
  ///
  /// In en, this message translates to:
  /// **'File must be 10MB or smaller.'**
  String get legacyUi36f2202687;

  /// No description provided for @legacyUi937fd74b36.
  ///
  /// In en, this message translates to:
  /// **'Filter SIM cards'**
  String get legacyUi937fd74b36;

  /// No description provided for @legacyUi15db08d15e.
  ///
  /// In en, this message translates to:
  /// **'Filter activity logs'**
  String get legacyUi15db08d15e;

  /// No description provided for @legacyUi582198fab2.
  ///
  /// In en, this message translates to:
  /// **'Filter administrators'**
  String get legacyUi582198fab2;

  /// No description provided for @legacyUi9911a4c0ed.
  ///
  /// In en, this message translates to:
  /// **'Filter devices'**
  String get legacyUi9911a4c0ed;

  /// No description provided for @legacyUi6a7fe2dc2c.
  ///
  /// In en, this message translates to:
  /// **'Filter drivers'**
  String get legacyUi6a7fe2dc2c;

  /// No description provided for @legacyUi5439ccf95d.
  ///
  /// In en, this message translates to:
  /// **'Filter geofences'**
  String get legacyUi5439ccf95d;

  /// No description provided for @legacyUif1fe9835a2.
  ///
  /// In en, this message translates to:
  /// **'Filter team'**
  String get legacyUif1fe9835a2;

  /// No description provided for @legacyUi8cfc14a859.
  ///
  /// In en, this message translates to:
  /// **'Filter users'**
  String get legacyUi8cfc14a859;

  /// No description provided for @legacyUia9d1432d0d.
  ///
  /// In en, this message translates to:
  /// **'Filter vehicles'**
  String get legacyUia9d1432d0d;

  /// No description provided for @legacyUiaa234fb61d.
  ///
  /// In en, this message translates to:
  /// **'Firebase'**
  String get legacyUiaa234fb61d;

  /// No description provided for @legacyUib15839eae8.
  ///
  /// In en, this message translates to:
  /// **'Firebase initialized'**
  String get legacyUib15839eae8;

  /// No description provided for @legacyUi916a78d701.
  ///
  /// In en, this message translates to:
  /// **'First'**
  String get legacyUi916a78d701;

  /// No description provided for @legacyUic617ebad3b.
  ///
  /// In en, this message translates to:
  /// **'Fix validation issues before testing'**
  String get legacyUic617ebad3b;

  /// No description provided for @legacyUi4d4e9621c4.
  ///
  /// In en, this message translates to:
  /// **'Fleet Status'**
  String get legacyUi4d4e9621c4;

  /// No description provided for @legacyUi1cc8d18151.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get legacyUi1cc8d18151;

  /// No description provided for @legacyUibaa0e2872d.
  ///
  /// In en, this message translates to:
  /// **'Free signup credits'**
  String get legacyUibaa0e2872d;

  /// No description provided for @legacyUi236ddee138.
  ///
  /// In en, this message translates to:
  /// **'From Admin'**
  String get legacyUi236ddee138;

  /// No description provided for @legacyUi19fe826cc8.
  ///
  /// In en, this message translates to:
  /// **'From Email'**
  String get legacyUi19fe826cc8;

  /// No description provided for @legacyUi64346b483c.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get legacyUi64346b483c;

  /// No description provided for @legacyUi9f8ce19bf4.
  ///
  /// In en, this message translates to:
  /// **'Full address'**
  String get legacyUi9f8ce19bf4;

  /// No description provided for @legacyUieeb692087d.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get legacyUieeb692087d;

  /// No description provided for @legacyUifcee5b52cc.
  ///
  /// In en, this message translates to:
  /// **'GMT Offset'**
  String get legacyUifcee5b52cc;

  /// No description provided for @legacyUi590df4df1f.
  ///
  /// In en, this message translates to:
  /// **'GMT offset must use +05:30 format.'**
  String get legacyUi590df4df1f;

  /// No description provided for @legacyUi0933ed5657.
  ///
  /// In en, this message translates to:
  /// **'GPS Model'**
  String get legacyUi0933ed5657;

  /// No description provided for @legacyUicbb0014411.
  ///
  /// In en, this message translates to:
  /// **'Gas Station'**
  String get legacyUicbb0014411;

  /// No description provided for @legacyUifc45f9b7a9.
  ///
  /// In en, this message translates to:
  /// **'Generate'**
  String get legacyUifc45f9b7a9;

  /// No description provided for @legacyUi549f31c53e.
  ///
  /// In en, this message translates to:
  /// **'Generate route'**
  String get legacyUi549f31c53e;

  /// No description provided for @legacyUidfde035f40.
  ///
  /// In en, this message translates to:
  /// **'Geocoding'**
  String get legacyUidfde035f40;

  /// No description provided for @legacyUi5cdf1dbd7e.
  ///
  /// In en, this message translates to:
  /// **'Geofences'**
  String get legacyUi5cdf1dbd7e;

  /// No description provided for @legacyUic09b487feb.
  ///
  /// In en, this message translates to:
  /// **'Get Replay'**
  String get legacyUic09b487feb;

  /// No description provided for @legacyUi5442e2b64f.
  ///
  /// In en, this message translates to:
  /// **'GitHub'**
  String get legacyUi5442e2b64f;

  /// No description provided for @legacyUi1efbf15894.
  ///
  /// In en, this message translates to:
  /// **'Group nearby vehicles into clusters at lower zoom'**
  String get legacyUi1efbf15894;

  /// No description provided for @legacyUiac69db7d02.
  ///
  /// In en, this message translates to:
  /// **'Growth Chart'**
  String get legacyUiac69db7d02;

  /// No description provided for @legacyUibc4359231d.
  ///
  /// In en, this message translates to:
  /// **'Gym'**
  String get legacyUibc4359231d;

  /// No description provided for @legacyUifa8a6b01e3.
  ///
  /// In en, this message translates to:
  /// **'Header copied'**
  String get legacyUifa8a6b01e3;

  /// No description provided for @legacyUi071c1366b0.
  ///
  /// In en, this message translates to:
  /// **'Higher precision uses more lookups.'**
  String get legacyUi071c1366b0;

  /// No description provided for @legacyUi90ccd64974.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get legacyUi90ccd64974;

  /// No description provided for @legacyUic3669ffe53.
  ///
  /// In en, this message translates to:
  /// **'History needs a vehicle with an IMEI from live telemetry.'**
  String get legacyUic3669ffe53;

  /// No description provided for @legacyUi8d4a22ea2b.
  ///
  /// In en, this message translates to:
  /// **'History values are not numeric.'**
  String get legacyUi8d4a22ea2b;

  /// No description provided for @legacyUidbb927867e.
  ///
  /// In en, this message translates to:
  /// **'Hospital'**
  String get legacyUidbb927867e;

  /// No description provided for @legacyUi3960ec4ca5.
  ///
  /// In en, this message translates to:
  /// **'Host'**
  String get legacyUi3960ec4ca5;

  /// No description provided for @legacyUiadd03be31a.
  ///
  /// In en, this message translates to:
  /// **'Host, port and encryption.'**
  String get legacyUiadd03be31a;

  /// No description provided for @legacyUi9c4ba7d047.
  ///
  /// In en, this message translates to:
  /// **'Hotel'**
  String get legacyUi9c4ba7d047;

  /// No description provided for @legacyUi1e3beed01c.
  ///
  /// In en, this message translates to:
  /// **'How long historical data is kept before cleanup.'**
  String get legacyUi1e3beed01c;

  /// No description provided for @legacyUi2635a51635.
  ///
  /// In en, this message translates to:
  /// **'How the administrator will be identified on the platform.'**
  String get legacyUi2635a51635;

  /// No description provided for @legacyUi0f053057ee.
  ///
  /// In en, this message translates to:
  /// **'How the user will be identified on the platform.'**
  String get legacyUi0f053057ee;

  /// No description provided for @legacyUi077f5f9dad.
  ///
  /// In en, this message translates to:
  /// **'I already have a reset link'**
  String get legacyUi077f5f9dad;

  /// No description provided for @legacyUibff7cfa991.
  ///
  /// In en, this message translates to:
  /// **'ICCID (optional)'**
  String get legacyUibff7cfa991;

  /// No description provided for @legacyUidc7458a51a.
  ///
  /// In en, this message translates to:
  /// **'IMEI is required to load telemetry logs.'**
  String get legacyUidc7458a51a;

  /// No description provided for @legacyUif4c88fb92e.
  ///
  /// In en, this message translates to:
  /// **'IMEI is required to load vehicle events.'**
  String get legacyUif4c88fb92e;

  /// No description provided for @legacyUi7e77081c51.
  ///
  /// In en, this message translates to:
  /// **'IMEI is required to send commands.'**
  String get legacyUi7e77081c51;

  /// No description provided for @legacyUif44426c787.
  ///
  /// In en, this message translates to:
  /// **'IMEI is unavailable for this vehicle. Showing the live map summary only.'**
  String get legacyUif44426c787;

  /// No description provided for @legacyUi8a4b9cf4a9.
  ///
  /// In en, this message translates to:
  /// **'IMEI missing'**
  String get legacyUi8a4b9cf4a9;

  /// No description provided for @legacyUi11da2cb7f0.
  ///
  /// In en, this message translates to:
  /// **'IMSI (optional)'**
  String get legacyUi11da2cb7f0;

  /// No description provided for @legacyUi716f63b96e.
  ///
  /// In en, this message translates to:
  /// **'Icon'**
  String get legacyUi716f63b96e;

  /// No description provided for @legacyUi7e5a975b6a.
  ///
  /// In en, this message translates to:
  /// **'Identity'**
  String get legacyUi7e5a975b6a;

  /// No description provided for @legacyUi2d40c36445.
  ///
  /// In en, this message translates to:
  /// **'Ignition'**
  String get legacyUi2d40c36445;

  /// No description provided for @legacyUif2d738d99c.
  ///
  /// In en, this message translates to:
  /// **'Ignition Source'**
  String get legacyUif2d738d99c;

  /// No description provided for @legacyUi4157fc56ab.
  ///
  /// In en, this message translates to:
  /// **'Image too large. Max 2 MB.'**
  String get legacyUi4157fc56ab;

  /// No description provided for @legacyUifcf7141427.
  ///
  /// In en, this message translates to:
  /// **'Image too large. Max 5 MB.'**
  String get legacyUifcf7141427;

  /// No description provided for @legacyUieeec98db23.
  ///
  /// In en, this message translates to:
  /// **'Import CSV'**
  String get legacyUieeec98db23;

  /// No description provided for @legacyUieebd26ef51.
  ///
  /// In en, this message translates to:
  /// **'Inactive - 48H'**
  String get legacyUieebd26ef51;

  /// No description provided for @legacyUi4b631f6984.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get legacyUi4b631f6984;

  /// No description provided for @legacyUi29981bf033.
  ///
  /// In en, this message translates to:
  /// **'Initial credit balance assigned to this administrator account.'**
  String get legacyUi29981bf033;

  /// No description provided for @legacyUi58984ab1ac.
  ///
  /// In en, this message translates to:
  /// **'Initial credits'**
  String get legacyUi58984ab1ac;

  /// No description provided for @legacyUi5721bbef40.
  ///
  /// In en, this message translates to:
  /// **'Instagram'**
  String get legacyUi5721bbef40;

  /// No description provided for @legacyUi9b5ca633e8.
  ///
  /// In en, this message translates to:
  /// **'Insufficient account credits'**
  String get legacyUi9b5ca633e8;

  /// No description provided for @legacyUi2ab95a4afe.
  ///
  /// In en, this message translates to:
  /// **'Invalid administrator id.'**
  String get legacyUi2ab95a4afe;

  /// No description provided for @legacyUicfa3e9c7e1.
  ///
  /// In en, this message translates to:
  /// **'Inventory item created.'**
  String get legacyUicfa3e9c7e1;

  /// No description provided for @legacyUi32091e3797.
  ///
  /// In en, this message translates to:
  /// **'Inventory status'**
  String get legacyUi32091e3797;

  /// No description provided for @legacyUia430dcf58c.
  ///
  /// In en, this message translates to:
  /// **'Jane Smith'**
  String get legacyUia430dcf58c;

  /// No description provided for @legacyUi049874e4f7.
  ///
  /// In en, this message translates to:
  /// **'KML copied to clipboard'**
  String get legacyUi049874e4f7;

  /// No description provided for @legacyUi62fc561458.
  ///
  /// In en, this message translates to:
  /// **'Keep request'**
  String get legacyUi62fc561458;

  /// No description provided for @legacyUic67dd20ee8.
  ///
  /// In en, this message translates to:
  /// **'Key'**
  String get legacyUic67dd20ee8;

  /// No description provided for @legacyUi52c4afe84f.
  ///
  /// In en, this message translates to:
  /// **'Landmark Studio'**
  String get legacyUi52c4afe84f;

  /// No description provided for @legacyUid1c69a859a.
  ///
  /// In en, this message translates to:
  /// **'Last'**
  String get legacyUid1c69a859a;

  /// No description provided for @legacyUi43df3046ba.
  ///
  /// In en, this message translates to:
  /// **'Last Change'**
  String get legacyUi43df3046ba;

  /// No description provided for @legacyUi7a78ad49d8.
  ///
  /// In en, this message translates to:
  /// **'Last Month Revenue'**
  String get legacyUi7a78ad49d8;

  /// No description provided for @legacyUicec3d948d9.
  ///
  /// In en, this message translates to:
  /// **'Last Payment'**
  String get legacyUicec3d948d9;

  /// No description provided for @legacyUiada1b72559.
  ///
  /// In en, this message translates to:
  /// **'Last checked'**
  String get legacyUiada1b72559;

  /// No description provided for @legacyUi43dab84ff6.
  ///
  /// In en, this message translates to:
  /// **'Last login'**
  String get legacyUi43dab84ff6;

  /// No description provided for @legacyUib916a123cc.
  ///
  /// In en, this message translates to:
  /// **'Last month revenue'**
  String get legacyUib916a123cc;

  /// No description provided for @legacyUi76c1ed9309.
  ///
  /// In en, this message translates to:
  /// **'Last week'**
  String get legacyUi76c1ed9309;

  /// No description provided for @legacyUieb3a622ae8.
  ///
  /// In en, this message translates to:
  /// **'Lat / Long'**
  String get legacyUieb3a622ae8;

  /// No description provided for @legacyUi1e5421b5bc.
  ///
  /// In en, this message translates to:
  /// **'Lat/Lng'**
  String get legacyUi1e5421b5bc;

  /// No description provided for @legacyUidecd7ca800.
  ///
  /// In en, this message translates to:
  /// **'Latest'**
  String get legacyUidecd7ca800;

  /// No description provided for @legacyUiefaed3a1b0.
  ///
  /// In en, this message translates to:
  /// **'Leave blank to keep current password'**
  String get legacyUiefaed3a1b0;

  /// No description provided for @legacyUib8100f5ba8.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get legacyUib8100f5ba8;

  /// No description provided for @legacyUi3229609e15.
  ///
  /// In en, this message translates to:
  /// **'License'**
  String get legacyUi3229609e15;

  /// No description provided for @legacyUi99929a05d8.
  ///
  /// In en, this message translates to:
  /// **'License Blocked'**
  String get legacyUi99929a05d8;

  /// No description provided for @legacyUi7452738cf9.
  ///
  /// In en, this message translates to:
  /// **'License Issued'**
  String get legacyUi7452738cf9;

  /// No description provided for @legacyUibbe96bcfaa.
  ///
  /// In en, this message translates to:
  /// **'License Used'**
  String get legacyUibbe96bcfaa;

  /// No description provided for @legacyUib957e7bd7b.
  ///
  /// In en, this message translates to:
  /// **'License blocked'**
  String get legacyUib957e7bd7b;

  /// No description provided for @legacyUiee92c8a4b6.
  ///
  /// In en, this message translates to:
  /// **'Licenses'**
  String get legacyUiee92c8a4b6;

  /// No description provided for @legacyUi6731d7cd1a.
  ///
  /// In en, this message translates to:
  /// **'Light Logo'**
  String get legacyUi6731d7cd1a;

  /// No description provided for @legacyUi6a1c6c8807.
  ///
  /// In en, this message translates to:
  /// **'Light logo updated'**
  String get legacyUi6a1c6c8807;

  /// No description provided for @legacyUi24d948e4bd.
  ///
  /// In en, this message translates to:
  /// **'Limit'**
  String get legacyUi24d948e4bd;

  /// No description provided for @legacyUied1ed2b68d.
  ///
  /// In en, this message translates to:
  /// **'Link copied.'**
  String get legacyUied1ed2b68d;

  /// No description provided for @legacyUi36d1b59b88.
  ///
  /// In en, this message translates to:
  /// **'Link the vehicle to a primary user, GPS device, and pricing plan.'**
  String get legacyUi36d1b59b88;

  /// No description provided for @legacyUi6b6390a441.
  ///
  /// In en, this message translates to:
  /// **'LinkedIn'**
  String get legacyUi6b6390a441;

  /// No description provided for @legacyUi4ac08d16b8.
  ///
  /// In en, this message translates to:
  /// **'Load earlier messages'**
  String get legacyUi4ac08d16b8;

  /// No description provided for @legacyUidfe60ca92e.
  ///
  /// In en, this message translates to:
  /// **'Load more'**
  String get legacyUidfe60ca92e;

  /// No description provided for @legacyUifc53db81a0.
  ///
  /// In en, this message translates to:
  /// **'Load more from server'**
  String get legacyUifc53db81a0;

  /// No description provided for @legacyUi949d7ee41c.
  ///
  /// In en, this message translates to:
  /// **'Load older'**
  String get legacyUi949d7ee41c;

  /// No description provided for @legacyUi6db90a0ab6.
  ///
  /// In en, this message translates to:
  /// **'Loaded'**
  String get legacyUi6db90a0ab6;

  /// No description provided for @legacyUi326ad2f9f8.
  ///
  /// In en, this message translates to:
  /// **'Loading assigned vehicles'**
  String get legacyUi326ad2f9f8;

  /// No description provided for @legacyUi8936529136.
  ///
  /// In en, this message translates to:
  /// **'Loading available vehicles'**
  String get legacyUi8936529136;

  /// No description provided for @legacyUi9f1e0ce448.
  ///
  /// In en, this message translates to:
  /// **'Loading documents'**
  String get legacyUi9f1e0ce448;

  /// No description provided for @legacyUide261e9b89.
  ///
  /// In en, this message translates to:
  /// **'Loading logs'**
  String get legacyUide261e9b89;

  /// No description provided for @legacyUi324989adf0.
  ///
  /// In en, this message translates to:
  /// **'Loading sensors'**
  String get legacyUi324989adf0;

  /// No description provided for @legacyUid219c68101.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get legacyUid219c68101;

  /// No description provided for @legacyUi2350df02c2.
  ///
  /// In en, this message translates to:
  /// **'Log Details'**
  String get legacyUi2350df02c2;

  /// No description provided for @legacyUiaacbd6aa68.
  ///
  /// In en, this message translates to:
  /// **'Log ID'**
  String get legacyUiaacbd6aa68;

  /// No description provided for @legacyUia3d749050e.
  ///
  /// In en, this message translates to:
  /// **'Login as User'**
  String get legacyUia3d749050e;

  /// No description provided for @legacyUi31a519ee99.
  ///
  /// In en, this message translates to:
  /// **'Login, password, or account status changes will appear here.'**
  String get legacyUi31a519ee99;

  /// No description provided for @legacyUi16b583cf21.
  ///
  /// In en, this message translates to:
  /// **'Logs unavailable'**
  String get legacyUi16b583cf21;

  /// No description provided for @legacyUi4c57f0c88d.
  ///
  /// In en, this message translates to:
  /// **'London'**
  String get legacyUi4c57f0c88d;

  /// No description provided for @legacyUi3bf98fa618.
  ///
  /// In en, this message translates to:
  /// **'Mark read'**
  String get legacyUi3bf98fa618;

  /// No description provided for @legacyUia95e85aed5.
  ///
  /// In en, this message translates to:
  /// **'Max'**
  String get legacyUia95e85aed5;

  /// No description provided for @legacyUi35f72dc38d.
  ///
  /// In en, this message translates to:
  /// **'Max Speed'**
  String get legacyUi35f72dc38d;

  /// No description provided for @legacyUi03a68b7d8b.
  ///
  /// In en, this message translates to:
  /// **'Memory Usage'**
  String get legacyUi03a68b7d8b;

  /// No description provided for @legacyUi68f4145fee.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get legacyUi68f4145fee;

  /// No description provided for @legacyUi54a144c1dd.
  ///
  /// In en, this message translates to:
  /// **'Message dispatch'**
  String get legacyUi54a144c1dd;

  /// No description provided for @legacyUi23b9e4546e.
  ///
  /// In en, this message translates to:
  /// **'Message your fleet manager here.'**
  String get legacyUi23b9e4546e;

  /// No description provided for @legacyUi8d546a6dea.
  ///
  /// In en, this message translates to:
  /// **'Meta'**
  String get legacyUi8d546a6dea;

  /// No description provided for @legacyUi251edc0eb5.
  ///
  /// In en, this message translates to:
  /// **'Metadata'**
  String get legacyUi251edc0eb5;

  /// No description provided for @legacyUic0b8960edf.
  ///
  /// In en, this message translates to:
  /// **'Metadata copied'**
  String get legacyUic0b8960edf;

  /// No description provided for @legacyUi7eb0cee888.
  ///
  /// In en, this message translates to:
  /// **'Min'**
  String get legacyUi7eb0cee888;

  /// No description provided for @legacyUib6bcd4535a.
  ///
  /// In en, this message translates to:
  /// **'Min 3 characters…'**
  String get legacyUib6bcd4535a;

  /// No description provided for @legacyUi925c181c00.
  ///
  /// In en, this message translates to:
  /// **'Minimum 6 characters'**
  String get legacyUi925c181c00;

  /// No description provided for @legacyUi092f99ea11.
  ///
  /// In en, this message translates to:
  /// **'Minutes'**
  String get legacyUi092f99ea11;

  /// No description provided for @legacyUib1d7024593.
  ///
  /// In en, this message translates to:
  /// **'Mobile'**
  String get legacyUib1d7024593;

  /// No description provided for @legacyUia0d9c28a1e.
  ///
  /// In en, this message translates to:
  /// **'Mobile (optional)'**
  String get legacyUia0d9c28a1e;

  /// No description provided for @legacyUi5968acfb01.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get legacyUi5968acfb01;

  /// No description provided for @legacyUic242b24d94.
  ///
  /// In en, this message translates to:
  /// **'Mobile Prefix'**
  String get legacyUic242b24d94;

  /// No description provided for @legacyUi802cdad736.
  ///
  /// In en, this message translates to:
  /// **'Mobile Push'**
  String get legacyUi802cdad736;

  /// No description provided for @legacyUi00618b3856.
  ///
  /// In en, this message translates to:
  /// **'Mobile and email used for communication.'**
  String get legacyUi00618b3856;

  /// No description provided for @legacyUi5d96299833.
  ///
  /// In en, this message translates to:
  /// **'Mobile number (optional)'**
  String get legacyUi5d96299833;

  /// No description provided for @legacyUi2ab961738f.
  ///
  /// In en, this message translates to:
  /// **'Mobile prefix'**
  String get legacyUi2ab961738f;

  /// No description provided for @legacyUi90ee975346.
  ///
  /// In en, this message translates to:
  /// **'Mobile prefix (optional)'**
  String get legacyUi90ee975346;

  /// No description provided for @legacyUiaa6630b79b.
  ///
  /// In en, this message translates to:
  /// **'Mobile push registration retried.'**
  String get legacyUiaa6630b79b;

  /// No description provided for @legacyUia1e34f9157.
  ///
  /// In en, this message translates to:
  /// **'More actions'**
  String get legacyUia1e34f9157;

  /// No description provided for @legacyUi86c0a35ec8.
  ///
  /// In en, this message translates to:
  /// **'More options'**
  String get legacyUi86c0a35ec8;

  /// No description provided for @legacyUi69d9f3e5ae.
  ///
  /// In en, this message translates to:
  /// **'Museum'**
  String get legacyUi69d9f3e5ae;

  /// No description provided for @legacyUi4ff2aa7688.
  ///
  /// In en, this message translates to:
  /// **'My Tickets'**
  String get legacyUi4ff2aa7688;

  /// No description provided for @legacyUi2e65b706ae.
  ///
  /// In en, this message translates to:
  /// **'Name and code are required.'**
  String get legacyUi2e65b706ae;

  /// No description provided for @legacyUi1eee3afea2.
  ///
  /// In en, this message translates to:
  /// **'Navigate'**
  String get legacyUi1eee3afea2;

  /// No description provided for @legacyUiccfb5f0286.
  ///
  /// In en, this message translates to:
  /// **'New POI'**
  String get legacyUiccfb5f0286;

  /// No description provided for @legacyUi4894cb39ee.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get legacyUi4894cb39ee;

  /// No description provided for @legacyUidcaa5db473.
  ///
  /// In en, this message translates to:
  /// **'New Ticket'**
  String get legacyUidcaa5db473;

  /// No description provided for @legacyUib85e445f60.
  ///
  /// In en, this message translates to:
  /// **'New User'**
  String get legacyUib85e445f60;

  /// No description provided for @legacyUia273c96341.
  ///
  /// In en, this message translates to:
  /// **'New Vehicle'**
  String get legacyUia273c96341;

  /// No description provided for @legacyUie0725b6664.
  ///
  /// In en, this message translates to:
  /// **'New geofence'**
  String get legacyUie0725b6664;

  /// No description provided for @legacyUif39fa269a9.
  ///
  /// In en, this message translates to:
  /// **'New route'**
  String get legacyUif39fa269a9;

  /// No description provided for @legacyUi395e182389.
  ///
  /// In en, this message translates to:
  /// **'New users will appear here.'**
  String get legacyUi395e182389;

  /// No description provided for @legacyUi2213317245.
  ///
  /// In en, this message translates to:
  /// **'New vehicles will appear here.'**
  String get legacyUi2213317245;

  /// No description provided for @legacyUi4bfc194b68.
  ///
  /// In en, this message translates to:
  /// **'Next page'**
  String get legacyUi4bfc194b68;

  /// No description provided for @legacyUi1097b553dc.
  ///
  /// In en, this message translates to:
  /// **'Night'**
  String get legacyUi1097b553dc;

  /// No description provided for @legacyUi4276e6ab2a.
  ///
  /// In en, this message translates to:
  /// **'No Data'**
  String get legacyUi4276e6ab2a;

  /// No description provided for @legacyUi3de93f521b.
  ///
  /// In en, this message translates to:
  /// **'No Device'**
  String get legacyUi3de93f521b;

  /// No description provided for @legacyUi79858167e6.
  ///
  /// In en, this message translates to:
  /// **'No POIs yet'**
  String get legacyUi79858167e6;

  /// No description provided for @legacyUia434e9985c.
  ///
  /// In en, this message translates to:
  /// **'No Provider'**
  String get legacyUia434e9985c;

  /// No description provided for @legacyUi7094ba4f01.
  ///
  /// In en, this message translates to:
  /// **'No active assignment. New trips appear here when dispatch assigns them.'**
  String get legacyUi7094ba4f01;

  /// No description provided for @legacyUia9206f399a.
  ///
  /// In en, this message translates to:
  /// **'No activity logs'**
  String get legacyUia9206f399a;

  /// No description provided for @legacyUi8bd5b910e5.
  ///
  /// In en, this message translates to:
  /// **'No activity logs found'**
  String get legacyUi8bd5b910e5;

  /// No description provided for @legacyUic38a37a193.
  ///
  /// In en, this message translates to:
  /// **'No activity matches your filters.'**
  String get legacyUic38a37a193;

  /// No description provided for @legacyUibff9905096.
  ///
  /// In en, this message translates to:
  /// **'No activity recorded yet.'**
  String get legacyUibff9905096;

  /// No description provided for @legacyUi0f5cca70f8.
  ///
  /// In en, this message translates to:
  /// **'No administrators found'**
  String get legacyUi0f5cca70f8;

  /// No description provided for @legacyUi31d3df94ab.
  ///
  /// In en, this message translates to:
  /// **'No administrators found.'**
  String get legacyUi31d3df94ab;

  /// No description provided for @legacyUic0d322c2b0.
  ///
  /// In en, this message translates to:
  /// **'No adoption data'**
  String get legacyUic0d322c2b0;

  /// No description provided for @legacyUie5d64448e5.
  ///
  /// In en, this message translates to:
  /// **'No alerts'**
  String get legacyUie5d64448e5;

  /// No description provided for @legacyUi501176c9f8.
  ///
  /// In en, this message translates to:
  /// **'No analytics data'**
  String get legacyUi501176c9f8;

  /// No description provided for @legacyUi63f5349bb8.
  ///
  /// In en, this message translates to:
  /// **'No assigned users'**
  String get legacyUi63f5349bb8;

  /// No description provided for @legacyUi852751d61f.
  ///
  /// In en, this message translates to:
  /// **'No assigned vehicles'**
  String get legacyUi852751d61f;

  /// No description provided for @legacyUi7546829892.
  ///
  /// In en, this message translates to:
  /// **'No billing activity found.'**
  String get legacyUi7546829892;

  /// No description provided for @legacyUi657275c0c1.
  ///
  /// In en, this message translates to:
  /// **'No cities available for this state'**
  String get legacyUi657275c0c1;

  /// No description provided for @legacyUia130e0f01b.
  ///
  /// In en, this message translates to:
  /// **'No command history'**
  String get legacyUia130e0f01b;

  /// No description provided for @legacyUi92db635f14.
  ///
  /// In en, this message translates to:
  /// **'No commands yet'**
  String get legacyUi92db635f14;

  /// No description provided for @legacyUi14a4bfc72c.
  ///
  /// In en, this message translates to:
  /// **'No completed trips this month.'**
  String get legacyUi14a4bfc72c;

  /// No description provided for @legacyUiee9c2e1df0.
  ///
  /// In en, this message translates to:
  /// **'No config'**
  String get legacyUiee9c2e1df0;

  /// No description provided for @legacyUic3017a3316.
  ///
  /// In en, this message translates to:
  /// **'No conversation yet'**
  String get legacyUic3017a3316;

  /// No description provided for @legacyUic140165b8f.
  ///
  /// In en, this message translates to:
  /// **'No credit history yet.'**
  String get legacyUic140165b8f;

  /// No description provided for @legacyUic8114767e8.
  ///
  /// In en, this message translates to:
  /// **'No dashboard configured'**
  String get legacyUic8114767e8;

  /// No description provided for @legacyUi7be70212b0.
  ///
  /// In en, this message translates to:
  /// **'No day or night data for this range.'**
  String get legacyUi7be70212b0;

  /// No description provided for @legacyUi2a4eb69350.
  ///
  /// In en, this message translates to:
  /// **'No details'**
  String get legacyUi2a4eb69350;

  /// No description provided for @legacyUi03ca0261ac.
  ///
  /// In en, this message translates to:
  /// **'No device'**
  String get legacyUi03ca0261ac;

  /// No description provided for @legacyUi893d388d16.
  ///
  /// In en, this message translates to:
  /// **'No device assigned to this vehicle.'**
  String get legacyUi893d388d16;

  /// No description provided for @legacyUi8386fe15ef.
  ///
  /// In en, this message translates to:
  /// **'No documents'**
  String get legacyUi8386fe15ef;

  /// No description provided for @legacyUi017ce6604c.
  ///
  /// In en, this message translates to:
  /// **'No documents uploaded'**
  String get legacyUi017ce6604c;

  /// No description provided for @legacyUiec7eb3c93e.
  ///
  /// In en, this message translates to:
  /// **'No documents uploaded yet.'**
  String get legacyUiec7eb3c93e;

  /// No description provided for @legacyUi54e1079e44.
  ///
  /// In en, this message translates to:
  /// **'No documents yet. Upload your first document using the upload button.'**
  String get legacyUi54e1079e44;

  /// No description provided for @legacyUia419748e62.
  ///
  /// In en, this message translates to:
  /// **'No driver activity found.'**
  String get legacyUia419748e62;

  /// No description provided for @legacyUi98e6629503.
  ///
  /// In en, this message translates to:
  /// **'No driver document types are configured. Ask your administrator to add one.'**
  String get legacyUi98e6629503;

  /// No description provided for @legacyUi36f5cbf894.
  ///
  /// In en, this message translates to:
  /// **'No driver documents'**
  String get legacyUi36f5cbf894;

  /// No description provided for @legacyUic5dc9718a6.
  ///
  /// In en, this message translates to:
  /// **'No drivers'**
  String get legacyUic5dc9718a6;

  /// No description provided for @legacyUi7a127d70b3.
  ///
  /// In en, this message translates to:
  /// **'No drivers available'**
  String get legacyUi7a127d70b3;

  /// No description provided for @legacyUi9c8198d34d.
  ///
  /// In en, this message translates to:
  /// **'No drivers found'**
  String get legacyUi9c8198d34d;

  /// No description provided for @legacyUi208ffc64d1.
  ///
  /// In en, this message translates to:
  /// **'No event detail found'**
  String get legacyUi208ffc64d1;

  /// No description provided for @legacyUiec11a02374.
  ///
  /// In en, this message translates to:
  /// **'No events exist for the selected date range and filters.'**
  String get legacyUiec11a02374;

  /// No description provided for @legacyUia48cbba615.
  ///
  /// In en, this message translates to:
  /// **'No events found'**
  String get legacyUia48cbba615;

  /// No description provided for @legacyUi81ab95b9f0.
  ///
  /// In en, this message translates to:
  /// **'No events yet'**
  String get legacyUi81ab95b9f0;

  /// No description provided for @legacyUi774a252215.
  ///
  /// In en, this message translates to:
  /// **'No file available.'**
  String get legacyUi774a252215;

  /// No description provided for @legacyUi35f65e1e57.
  ///
  /// In en, this message translates to:
  /// **'No geofences available.'**
  String get legacyUi35f65e1e57;

  /// No description provided for @legacyUi019549899f.
  ///
  /// In en, this message translates to:
  /// **'No geofences yet'**
  String get legacyUi019549899f;

  /// No description provided for @legacyUi5358cec56d.
  ///
  /// In en, this message translates to:
  /// **'No history points'**
  String get legacyUi5358cec56d;

  /// No description provided for @legacyUia0ed9c8031.
  ///
  /// In en, this message translates to:
  /// **'No history points for this range.'**
  String get legacyUia0ed9c8031;

  /// No description provided for @legacyUi8bf09d954a.
  ///
  /// In en, this message translates to:
  /// **'No linked vehicles available'**
  String get legacyUi8bf09d954a;

  /// No description provided for @legacyUif48787eb30.
  ///
  /// In en, this message translates to:
  /// **'No logs found'**
  String get legacyUif48787eb30;

  /// No description provided for @legacyUi6b68d448a0.
  ///
  /// In en, this message translates to:
  /// **'No logs found for this vehicle'**
  String get legacyUi6b68d448a0;

  /// No description provided for @legacyUic7462a9dac.
  ///
  /// In en, this message translates to:
  /// **'No logs yet'**
  String get legacyUic7462a9dac;

  /// No description provided for @legacyUi1db215fbaa.
  ///
  /// In en, this message translates to:
  /// **'No matches for your search.'**
  String get legacyUi1db215fbaa;

  /// No description provided for @legacyUia734fde29a.
  ///
  /// In en, this message translates to:
  /// **'No matching POIs'**
  String get legacyUia734fde29a;

  /// No description provided for @legacyUi2d928306c1.
  ///
  /// In en, this message translates to:
  /// **'No matching drivers'**
  String get legacyUi2d928306c1;

  /// No description provided for @legacyUid6e8839481.
  ///
  /// In en, this message translates to:
  /// **'No matching geofences'**
  String get legacyUid6e8839481;

  /// No description provided for @legacyUif6830db2e7.
  ///
  /// In en, this message translates to:
  /// **'No matching logs'**
  String get legacyUif6830db2e7;

  /// No description provided for @legacyUi748bd377da.
  ///
  /// In en, this message translates to:
  /// **'No matching records'**
  String get legacyUi748bd377da;

  /// No description provided for @legacyUi6590e5eab8.
  ///
  /// In en, this message translates to:
  /// **'No matching routes'**
  String get legacyUi6590e5eab8;

  /// No description provided for @legacyUid17e9558cf.
  ///
  /// In en, this message translates to:
  /// **'No matching sub users'**
  String get legacyUid17e9558cf;

  /// No description provided for @legacyUif1d8690cd7.
  ///
  /// In en, this message translates to:
  /// **'No matching vehicles found. Try a different search or filter.'**
  String get legacyUif1d8690cd7;

  /// No description provided for @legacyUic04921f8d9.
  ///
  /// In en, this message translates to:
  /// **'No messages yet'**
  String get legacyUic04921f8d9;

  /// No description provided for @legacyUi2449a03436.
  ///
  /// In en, this message translates to:
  /// **'No mode data'**
  String get legacyUi2449a03436;

  /// No description provided for @legacyUi50806db52e.
  ///
  /// In en, this message translates to:
  /// **'No notification settings found'**
  String get legacyUi50806db52e;

  /// No description provided for @legacyUic1f531f996.
  ///
  /// In en, this message translates to:
  /// **'No payments found'**
  String get legacyUic1f531f996;

  /// No description provided for @legacyUiaf4a7f06d0.
  ///
  /// In en, this message translates to:
  /// **'No plans found'**
  String get legacyUiaf4a7f06d0;

  /// No description provided for @legacyUi4ae157aff3.
  ///
  /// In en, this message translates to:
  /// **'No recent alerts.'**
  String get legacyUi4ae157aff3;

  /// No description provided for @legacyUi26776d0320.
  ///
  /// In en, this message translates to:
  /// **'No recent users'**
  String get legacyUi26776d0320;

  /// No description provided for @legacyUi42ec1ecf96.
  ///
  /// In en, this message translates to:
  /// **'No recent vehicles'**
  String get legacyUi42ec1ecf96;

  /// No description provided for @legacyUi9833364a35.
  ///
  /// In en, this message translates to:
  /// **'No routes available.'**
  String get legacyUi9833364a35;

  /// No description provided for @legacyUid233dd5d9f.
  ///
  /// In en, this message translates to:
  /// **'No routes yet'**
  String get legacyUid233dd5d9f;

  /// No description provided for @legacyUic9bfb1492b.
  ///
  /// In en, this message translates to:
  /// **'No security activity found.'**
  String get legacyUic9bfb1492b;

  /// No description provided for @legacyUid07b6b93d6.
  ///
  /// In en, this message translates to:
  /// **'No selectable vehicles'**
  String get legacyUid07b6b93d6;

  /// No description provided for @legacyUi5653bf7251.
  ///
  /// In en, this message translates to:
  /// **'No sensor points for this range.'**
  String get legacyUi5653bf7251;

  /// No description provided for @legacyUi1ef59c9c2b.
  ///
  /// In en, this message translates to:
  /// **'No sensors'**
  String get legacyUi1ef59c9c2b;

  /// No description provided for @legacyUi3c30b80f16.
  ///
  /// In en, this message translates to:
  /// **'No sensors configured for this vehicle.'**
  String get legacyUi3c30b80f16;

  /// No description provided for @legacyUicbae766d34.
  ///
  /// In en, this message translates to:
  /// **'No settings activity found.'**
  String get legacyUicbae766d34;

  /// No description provided for @legacyUicd0c79d188.
  ///
  /// In en, this message translates to:
  /// **'No share links'**
  String get legacyUicd0c79d188;

  /// No description provided for @legacyUi9eac2f6695.
  ///
  /// In en, this message translates to:
  /// **'No states available for this country'**
  String get legacyUi9eac2f6695;

  /// No description provided for @legacyUid05ab60501.
  ///
  /// In en, this message translates to:
  /// **'No status data'**
  String get legacyUid05ab60501;

  /// No description provided for @legacyUi4b78e836ec.
  ///
  /// In en, this message translates to:
  /// **'No sub users'**
  String get legacyUi4b78e836ec;

  /// No description provided for @legacyUib30adf9758.
  ///
  /// In en, this message translates to:
  /// **'No sub users available'**
  String get legacyUib30adf9758;

  /// No description provided for @legacyUi3a1fa8f145.
  ///
  /// In en, this message translates to:
  /// **'No team members found'**
  String get legacyUi3a1fa8f145;

  /// No description provided for @legacyUi12c6f10a41.
  ///
  /// In en, this message translates to:
  /// **'No telemetry detail found'**
  String get legacyUi12c6f10a41;

  /// No description provided for @legacyUi429d6e6ece.
  ///
  /// In en, this message translates to:
  /// **'No telemetry logs found'**
  String get legacyUi429d6e6ece;

  /// No description provided for @legacyUiea04e18b66.
  ///
  /// In en, this message translates to:
  /// **'No top assets for this range.'**
  String get legacyUiea04e18b66;

  /// No description provided for @legacyUi48d2d8da35.
  ///
  /// In en, this message translates to:
  /// **'No transactions'**
  String get legacyUi48d2d8da35;

  /// No description provided for @legacyUid60c045dd2.
  ///
  /// In en, this message translates to:
  /// **'No transactions found'**
  String get legacyUid60c045dd2;

  /// No description provided for @legacyUif794b6c6d1.
  ///
  /// In en, this message translates to:
  /// **'No transactions yet.'**
  String get legacyUif794b6c6d1;

  /// No description provided for @legacyUi8d92589518.
  ///
  /// In en, this message translates to:
  /// **'No trend data'**
  String get legacyUi8d92589518;

  /// No description provided for @legacyUi7d3e5f72b8.
  ///
  /// In en, this message translates to:
  /// **'No trips in this view.'**
  String get legacyUi7d3e5f72b8;

  /// No description provided for @legacyUib4c96ae04e.
  ///
  /// In en, this message translates to:
  /// **'No unlinked users found.'**
  String get legacyUib4c96ae04e;

  /// No description provided for @legacyUi4b3155e704.
  ///
  /// In en, this message translates to:
  /// **'No unlinked users match your search.'**
  String get legacyUi4b3155e704;

  /// No description provided for @legacyUid9c71203a5.
  ///
  /// In en, this message translates to:
  /// **'No usage data for the selected range.'**
  String get legacyUid9c71203a5;

  /// No description provided for @legacyUic4b060bd59.
  ///
  /// In en, this message translates to:
  /// **'No users'**
  String get legacyUic4b060bd59;

  /// No description provided for @legacyUi5cc2b29f54.
  ///
  /// In en, this message translates to:
  /// **'No users assigned'**
  String get legacyUi5cc2b29f54;

  /// No description provided for @legacyUi3b614a59c7.
  ///
  /// In en, this message translates to:
  /// **'No users available'**
  String get legacyUi3b614a59c7;

  /// No description provided for @legacyUi612eb3c64c.
  ///
  /// In en, this message translates to:
  /// **'No users found'**
  String get legacyUi612eb3c64c;

  /// No description provided for @legacyUie611ef5702.
  ///
  /// In en, this message translates to:
  /// **'No users found.'**
  String get legacyUie611ef5702;

  /// No description provided for @legacyUif800dfd722.
  ///
  /// In en, this message translates to:
  /// **'No valid GPS path or stop markers were returned.'**
  String get legacyUif800dfd722;

  /// No description provided for @legacyUib96ee669b0.
  ///
  /// In en, this message translates to:
  /// **'No vehicle activity found.'**
  String get legacyUib96ee669b0;

  /// No description provided for @legacyUi748eafd21d.
  ///
  /// In en, this message translates to:
  /// **'No vehicles'**
  String get legacyUi748eafd21d;

  /// No description provided for @legacyUi8fbc8deb7a.
  ///
  /// In en, this message translates to:
  /// **'No vehicles are visible on the map right now.'**
  String get legacyUi8fbc8deb7a;

  /// No description provided for @legacyUi72ed5bbcdf.
  ///
  /// In en, this message translates to:
  /// **'No vehicles assigned yet.'**
  String get legacyUi72ed5bbcdf;

  /// No description provided for @legacyUi7223e6b8cb.
  ///
  /// In en, this message translates to:
  /// **'No vehicles assigned.'**
  String get legacyUi7223e6b8cb;

  /// No description provided for @legacyUiac0e4dbd5b.
  ///
  /// In en, this message translates to:
  /// **'No vehicles available'**
  String get legacyUiac0e4dbd5b;

  /// No description provided for @legacyUic578cfdbd5.
  ///
  /// In en, this message translates to:
  /// **'No vehicles found'**
  String get legacyUic578cfdbd5;

  /// No description provided for @legacyUie1de5f8ce2.
  ///
  /// In en, this message translates to:
  /// **'No vehicles match your search.'**
  String get legacyUie1de5f8ce2;

  /// No description provided for @legacyUia41b297cf1.
  ///
  /// In en, this message translates to:
  /// **'No weekly comparison data.'**
  String get legacyUia41b297cf1;

  /// No description provided for @legacyUi35163920f3.
  ///
  /// In en, this message translates to:
  /// **'No widgets configured'**
  String get legacyUi35163920f3;

  /// No description provided for @legacyUi45e118d056.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get legacyUi45e118d056;

  /// No description provided for @legacyUif8e45b2be2.
  ///
  /// In en, this message translates to:
  /// **'North'**
  String get legacyUif8e45b2be2;

  /// No description provided for @legacyUi2c924e3088.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get legacyUi2c924e3088;

  /// No description provided for @legacyUi2fd5716446.
  ///
  /// In en, this message translates to:
  /// **'Notes (Optional)'**
  String get legacyUi2fd5716446;

  /// No description provided for @legacyUicf62dbc83d.
  ///
  /// In en, this message translates to:
  /// **'Notes / Description'**
  String get legacyUicf62dbc83d;

  /// No description provided for @legacyUi3e56dbb775.
  ///
  /// In en, this message translates to:
  /// **'Notes about this document'**
  String get legacyUi3e56dbb775;

  /// No description provided for @legacyUi7faf33fcca.
  ///
  /// In en, this message translates to:
  /// **'Nothing to export'**
  String get legacyUi7faf33fcca;

  /// No description provided for @legacyUi76544814eb.
  ///
  /// In en, this message translates to:
  /// **'Notification actions'**
  String get legacyUi76544814eb;

  /// No description provided for @legacyUi4eb32de6c9.
  ///
  /// In en, this message translates to:
  /// **'Notification settings saved successfully.'**
  String get legacyUi4eb32de6c9;

  /// No description provided for @legacyUi8ca2cb9290.
  ///
  /// In en, this message translates to:
  /// **'Odometer'**
  String get legacyUi8ca2cb9290;

  /// No description provided for @legacyUi6c3a72eaf6.
  ///
  /// In en, this message translates to:
  /// **'Office'**
  String get legacyUi6c3a72eaf6;

  /// No description provided for @legacyUi63f34dd211.
  ///
  /// In en, this message translates to:
  /// **'Older'**
  String get legacyUi63f34dd211;

  /// No description provided for @legacyUi35c5d4307a.
  ///
  /// In en, this message translates to:
  /// **'Older rows'**
  String get legacyUi35c5d4307a;

  /// No description provided for @legacyUi9f8f7411e8.
  ///
  /// In en, this message translates to:
  /// **'One or more selected vehicles are invalid.'**
  String get legacyUi9f8f7411e8;

  /// No description provided for @legacyUie81cd61ea1.
  ///
  /// In en, this message translates to:
  /// **'Only assigned user vehicles can be shared.'**
  String get legacyUie81cd61ea1;

  /// No description provided for @legacyUicf9b77061f.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get legacyUicf9b77061f;

  /// No description provided for @legacyUi8f5f529938.
  ///
  /// In en, this message translates to:
  /// **'Open / save'**
  String get legacyUi8f5f529938;

  /// No description provided for @legacyUi55d00c31ab.
  ///
  /// In en, this message translates to:
  /// **'Open Vehicles'**
  String get legacyUi55d00c31ab;

  /// No description provided for @legacyUicc6b7ec50c.
  ///
  /// In en, this message translates to:
  /// **'Open failed rows CSV'**
  String get legacyUicc6b7ec50c;

  /// No description provided for @legacyUi99bd9c01d7.
  ///
  /// In en, this message translates to:
  /// **'OpenVTS Notifications'**
  String get legacyUi99bd9c01d7;

  /// No description provided for @legacyUic1b94f880c.
  ///
  /// In en, this message translates to:
  /// **'Optional amount'**
  String get legacyUic1b94f880c;

  /// No description provided for @legacyUi7afdcf3257.
  ///
  /// In en, this message translates to:
  /// **'Optional email'**
  String get legacyUi7afdcf3257;

  /// No description provided for @legacyUic553137ef5.
  ///
  /// In en, this message translates to:
  /// **'Optional mobile'**
  String get legacyUic553137ef5;

  /// No description provided for @legacyUi410d481882.
  ///
  /// In en, this message translates to:
  /// **'Optional notes'**
  String get legacyUi410d481882;

  /// No description provided for @legacyUi4f8f9c2bba.
  ///
  /// In en, this message translates to:
  /// **'Optional receipt or note'**
  String get legacyUi4f8f9c2bba;

  /// No description provided for @legacyUi3494a60f96.
  ///
  /// In en, this message translates to:
  /// **'Optional username'**
  String get legacyUi3494a60f96;

  /// No description provided for @legacyUia493c04fb5.
  ///
  /// In en, this message translates to:
  /// **'Optional; enter at least 3 characters'**
  String get legacyUia493c04fb5;

  /// No description provided for @legacyUi6bf5da9c08.
  ///
  /// In en, this message translates to:
  /// **'Options'**
  String get legacyUi6bf5da9c08;

  /// No description provided for @legacyUidefe0db589.
  ///
  /// In en, this message translates to:
  /// **'Order by'**
  String get legacyUidefe0db589;

  /// No description provided for @legacyUi6e6a6f2086.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get legacyUi6e6a6f2086;

  /// No description provided for @legacyUi4bed336194.
  ///
  /// In en, this message translates to:
  /// **'Output'**
  String get legacyUi4bed336194;

  /// No description provided for @legacyUi9e339da256.
  ///
  /// In en, this message translates to:
  /// **'Overspeed Enabled'**
  String get legacyUi9e339da256;

  /// No description provided for @legacyUi0efc2e6be4.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get legacyUi0efc2e6be4;

  /// No description provided for @legacyUi3e90e4cbf4.
  ///
  /// In en, this message translates to:
  /// **'Ownership'**
  String get legacyUi3e90e4cbf4;

  /// No description provided for @legacyUi07afcc61d8.
  ///
  /// In en, this message translates to:
  /// **'Packet type'**
  String get legacyUi07afcc61d8;

  /// No description provided for @legacyUif92c24e8df.
  ///
  /// In en, this message translates to:
  /// **'Park'**
  String get legacyUif92c24e8df;

  /// No description provided for @legacyUi07ba1bef85.
  ///
  /// In en, this message translates to:
  /// **'Parties'**
  String get legacyUi07ba1bef85;

  /// No description provided for @legacyUi8be3c943b1.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get legacyUi8be3c943b1;

  /// No description provided for @legacyUi408255ed02.
  ///
  /// In en, this message translates to:
  /// **'Password (optional)'**
  String get legacyUi408255ed02;

  /// No description provided for @legacyUi092a16e7af.
  ///
  /// In en, this message translates to:
  /// **'Password changed'**
  String get legacyUi092a16e7af;

  /// No description provided for @legacyUi47fa528931.
  ///
  /// In en, this message translates to:
  /// **'Password changed.'**
  String get legacyUi47fa528931;

  /// No description provided for @legacyUi3efdbb2011.
  ///
  /// In en, this message translates to:
  /// **'Password updated.'**
  String get legacyUi3efdbb2011;

  /// No description provided for @legacyUi8ac0c75d5e.
  ///
  /// In en, this message translates to:
  /// **'Paste the complete reset link or token from your email. Reset links are single-use and expire automatically.'**
  String get legacyUi8ac0c75d5e;

  /// No description provided for @legacyUi5616b61bb7.
  ///
  /// In en, this message translates to:
  /// **'Payload JSON'**
  String get legacyUi5616b61bb7;

  /// No description provided for @legacyUif8c3596eab.
  ///
  /// In en, this message translates to:
  /// **'Payload must be valid JSON object.'**
  String get legacyUif8c3596eab;

  /// No description provided for @legacyUi23b35c414a.
  ///
  /// In en, this message translates to:
  /// **'Payment Mode'**
  String get legacyUi23b35c414a;

  /// No description provided for @legacyUi670d2a76c7.
  ///
  /// In en, this message translates to:
  /// **'Payment Mode *'**
  String get legacyUi670d2a76c7;

  /// No description provided for @legacyUi662210d869.
  ///
  /// In en, this message translates to:
  /// **'Payment Mode Breakdown'**
  String get legacyUi662210d869;

  /// No description provided for @legacyUia629fd8a2e.
  ///
  /// In en, this message translates to:
  /// **'Payment Type'**
  String get legacyUia629fd8a2e;

  /// No description provided for @legacyUi43f8c9c90f.
  ///
  /// In en, this message translates to:
  /// **'Payment activity will appear here.'**
  String get legacyUi43f8c9c90f;

  /// No description provided for @legacyUi8fbf2ec0dd.
  ///
  /// In en, this message translates to:
  /// **'Payment mode'**
  String get legacyUi8fbf2ec0dd;

  /// No description provided for @legacyUi653c04fc42.
  ///
  /// In en, this message translates to:
  /// **'Payment mode breakdown is not available for this range.'**
  String get legacyUi653c04fc42;

  /// No description provided for @legacyUidbc3c0ca72.
  ///
  /// In en, this message translates to:
  /// **'Payment recorded'**
  String get legacyUidbc3c0ca72;

  /// No description provided for @legacyUi197b45d161.
  ///
  /// In en, this message translates to:
  /// **'Payment reference'**
  String get legacyUi197b45d161;

  /// No description provided for @legacyUi96f608c16c.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get legacyUi96f608c16c;

  /// No description provided for @legacyUid1240d2832.
  ///
  /// In en, this message translates to:
  /// **'Pending / Failed'**
  String get legacyUid1240d2832;

  /// No description provided for @legacyUi9126c119ae.
  ///
  /// In en, this message translates to:
  /// **'Pending Payments'**
  String get legacyUi9126c119ae;

  /// No description provided for @legacyUib4ebfb2f75.
  ///
  /// In en, this message translates to:
  /// **'Pending payments'**
  String get legacyUib4ebfb2f75;

  /// No description provided for @legacyUi167a47ff3e.
  ///
  /// In en, this message translates to:
  /// **'Performed by'**
  String get legacyUi167a47ff3e;

  /// No description provided for @legacyUi1785713451.
  ///
  /// In en, this message translates to:
  /// **'Permission'**
  String get legacyUi1785713451;

  /// No description provided for @legacyUid06d555709.
  ///
  /// In en, this message translates to:
  /// **'Permissions'**
  String get legacyUid06d555709;

  /// No description provided for @legacyUi1e99c04657.
  ///
  /// In en, this message translates to:
  /// **'Permissions updated'**
  String get legacyUi1e99c04657;

  /// No description provided for @legacyUi0219adf447.
  ///
  /// In en, this message translates to:
  /// **'Personal details and address'**
  String get legacyUi0219adf447;

  /// No description provided for @legacyUib1b9e59387.
  ///
  /// In en, this message translates to:
  /// **'Personal information'**
  String get legacyUib1b9e59387;

  /// No description provided for @legacyUi77064d5265.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get legacyUi77064d5265;

  /// No description provided for @legacyUi26730cddc4.
  ///
  /// In en, this message translates to:
  /// **'Pick CSV'**
  String get legacyUi26730cddc4;

  /// No description provided for @legacyUif2c5ca7b8c.
  ///
  /// In en, this message translates to:
  /// **'Pincode'**
  String get legacyUif2c5ca7b8c;

  /// No description provided for @legacyUifd25c49d56.
  ///
  /// In en, this message translates to:
  /// **'Pincode (optional)'**
  String get legacyUifd25c49d56;

  /// No description provided for @legacyUiae2f98a099.
  ///
  /// In en, this message translates to:
  /// **'Plan'**
  String get legacyUiae2f98a099;

  /// No description provided for @legacyUiec0632cbbf.
  ///
  /// In en, this message translates to:
  /// **'Plan Name'**
  String get legacyUiec0632cbbf;

  /// No description provided for @legacyUi2b366a2f95.
  ///
  /// In en, this message translates to:
  /// **'Plan Price'**
  String get legacyUi2b366a2f95;

  /// No description provided for @legacyUi7f97f6a268.
  ///
  /// In en, this message translates to:
  /// **'Plan created and selected'**
  String get legacyUi7f97f6a268;

  /// No description provided for @legacyUi2db331cefa.
  ///
  /// In en, this message translates to:
  /// **'Plate'**
  String get legacyUi2db331cefa;

  /// No description provided for @legacyUi7d86677521.
  ///
  /// In en, this message translates to:
  /// **'Plate Number'**
  String get legacyUi7d86677521;

  /// No description provided for @legacyUia6b7aa4d9c.
  ///
  /// In en, this message translates to:
  /// **'Plate Number (optional)'**
  String get legacyUia6b7aa4d9c;

  /// No description provided for @legacyUif2ce282e2d.
  ///
  /// In en, this message translates to:
  /// **'Plate number'**
  String get legacyUif2ce282e2d;

  /// No description provided for @legacyUi09d9c23846.
  ///
  /// In en, this message translates to:
  /// **'Plate number (optional)'**
  String get legacyUi09d9c23846;

  /// No description provided for @legacyUi123a7f2fcc.
  ///
  /// In en, this message translates to:
  /// **'Platform'**
  String get legacyUi123a7f2fcc;

  /// No description provided for @legacyUi16596c477e.
  ///
  /// In en, this message translates to:
  /// **'Platform behavior, signup, geocoding, and retention.'**
  String get legacyUi16596c477e;

  /// No description provided for @legacyUid095e279b3.
  ///
  /// In en, this message translates to:
  /// **'Please fix the highlighted fields before continuing.'**
  String get legacyUid095e279b3;

  /// No description provided for @legacyUi51668149ea.
  ///
  /// In en, this message translates to:
  /// **'Please select an administrator.'**
  String get legacyUi51668149ea;

  /// No description provided for @legacyUife035157cd.
  ///
  /// In en, this message translates to:
  /// **'Port'**
  String get legacyUife035157cd;

  /// No description provided for @legacyUi16c2eb4dbb.
  ///
  /// In en, this message translates to:
  /// **'Ports'**
  String get legacyUi16c2eb4dbb;

  /// No description provided for @legacyUib629d4165b.
  ///
  /// In en, this message translates to:
  /// **'Postal / ZIP code'**
  String get legacyUib629d4165b;

  /// No description provided for @legacyUib86b6a2b3b.
  ///
  /// In en, this message translates to:
  /// **'Postal code (optional)'**
  String get legacyUib86b6a2b3b;

  /// No description provided for @legacyUi90eceb016c.
  ///
  /// In en, this message translates to:
  /// **'Prefix'**
  String get legacyUi90eceb016c;

  /// No description provided for @legacyUif1fbb2b43d.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get legacyUif1fbb2b43d;

  /// No description provided for @legacyUiba3e0b4a86.
  ///
  /// In en, this message translates to:
  /// **'Preview updated'**
  String get legacyUiba3e0b4a86;

  /// No description provided for @legacyUi81f547195b.
  ///
  /// In en, this message translates to:
  /// **'Previous page'**
  String get legacyUi81f547195b;

  /// No description provided for @legacyUi3e8248e32e.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get legacyUi3e8248e32e;

  /// No description provided for @legacyUi15ac0c0a27.
  ///
  /// In en, this message translates to:
  /// **'Pricing plan'**
  String get legacyUi15ac0c0a27;

  /// No description provided for @legacyUid3dcce7d10.
  ///
  /// In en, this message translates to:
  /// **'Primary Color'**
  String get legacyUid3dcce7d10;

  /// No description provided for @legacyUi170f443f36.
  ///
  /// In en, this message translates to:
  /// **'Primary User'**
  String get legacyUi170f443f36;

  /// No description provided for @legacyUia1055f11a9.
  ///
  /// In en, this message translates to:
  /// **'Primary color'**
  String get legacyUia1055f11a9;

  /// No description provided for @legacyUic1ee865b42.
  ///
  /// In en, this message translates to:
  /// **'Primary color (hex)'**
  String get legacyUic1ee865b42;

  /// No description provided for @legacyUi0554f68465.
  ///
  /// In en, this message translates to:
  /// **'Primary user'**
  String get legacyUi0554f68465;

  /// No description provided for @legacyUi1e5947a051.
  ///
  /// In en, this message translates to:
  /// **'Primary user, device, vehicle type, and pricing plan are required.'**
  String get legacyUi1e5947a051;

  /// No description provided for @legacyUi886cbff9d9.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get legacyUi886cbff9d9;

  /// No description provided for @legacyUi7e7302bb73.
  ///
  /// In en, this message translates to:
  /// **'Profile not loaded yet.'**
  String get legacyUi7e7302bb73;

  /// No description provided for @legacyUi5049e8f42b.
  ///
  /// In en, this message translates to:
  /// **'Profile photo updated'**
  String get legacyUi5049e8f42b;

  /// No description provided for @legacyUi49ba5b4d7b.
  ///
  /// In en, this message translates to:
  /// **'Profile settings unavailable'**
  String get legacyUi49ba5b4d7b;

  /// No description provided for @legacyUibcf7629607.
  ///
  /// In en, this message translates to:
  /// **'Profile updated.'**
  String get legacyUibcf7629607;

  /// No description provided for @legacyUibda244507b.
  ///
  /// In en, this message translates to:
  /// **'Profile, company, or configuration changes will appear here.'**
  String get legacyUibda244507b;

  /// No description provided for @legacyUi204be1a53a.
  ///
  /// In en, this message translates to:
  /// **'Projected'**
  String get legacyUi204be1a53a;

  /// No description provided for @legacyUi5c620cdb78.
  ///
  /// In en, this message translates to:
  /// **'Proof type'**
  String get legacyUi5c620cdb78;

  /// No description provided for @legacyUi1ed77c3f7f.
  ///
  /// In en, this message translates to:
  /// **'Protocol'**
  String get legacyUi1ed77c3f7f;

  /// No description provided for @legacyUi7ceee3f361.
  ///
  /// In en, this message translates to:
  /// **'Provider'**
  String get legacyUi7ceee3f361;

  /// No description provided for @legacyUi767359109d.
  ///
  /// In en, this message translates to:
  /// **'Provider Ref'**
  String get legacyUi767359109d;

  /// No description provided for @legacyUi8d80f9c731.
  ///
  /// In en, this message translates to:
  /// **'Provider coverage expires'**
  String get legacyUi8d80f9c731;

  /// No description provided for @legacyUi8a87202949.
  ///
  /// In en, this message translates to:
  /// **'Public URL is not available.'**
  String get legacyUi8a87202949;

  /// No description provided for @legacyUi411c13db3b.
  ///
  /// In en, this message translates to:
  /// **'Public signup and welcome credits.'**
  String get legacyUi411c13db3b;

  /// No description provided for @legacyUicf0a64d03d.
  ///
  /// In en, this message translates to:
  /// **'Pull to refresh and try loading your profile again.'**
  String get legacyUicf0a64d03d;

  /// No description provided for @legacyUic8f58b21ae.
  ///
  /// In en, this message translates to:
  /// **'Pull to refresh or add a new driver.'**
  String get legacyUic8f58b21ae;

  /// No description provided for @legacyUi011bc421c2.
  ///
  /// In en, this message translates to:
  /// **'Pull to refresh or create a new sub user.'**
  String get legacyUi011bc421c2;

  /// No description provided for @legacyUi6a599877d7.
  ///
  /// In en, this message translates to:
  /// **'Queued'**
  String get legacyUi6a599877d7;

  /// No description provided for @legacyUia16c5bbe4b.
  ///
  /// In en, this message translates to:
  /// **'Range'**
  String get legacyUia16c5bbe4b;

  /// No description provided for @legacyUida433cd41e.
  ///
  /// In en, this message translates to:
  /// **'Raw'**
  String get legacyUida433cd41e;

  /// No description provided for @legacyUice09c15f57.
  ///
  /// In en, this message translates to:
  /// **'Raw packet'**
  String get legacyUice09c15f57;

  /// No description provided for @legacyUia3ccb33027.
  ///
  /// In en, this message translates to:
  /// **'Razorpay'**
  String get legacyUia3ccb33027;

  /// No description provided for @legacyUi2af51c3e17.
  ///
  /// In en, this message translates to:
  /// **'Re-enter the password'**
  String get legacyUi2af51c3e17;

  /// No description provided for @legacyUi852b438f91.
  ///
  /// In en, this message translates to:
  /// **'Read'**
  String get legacyUi852b438f91;

  /// No description provided for @legacyUid14d593883.
  ///
  /// In en, this message translates to:
  /// **'Read all'**
  String get legacyUid14d593883;

  /// No description provided for @legacyUi00db810078.
  ///
  /// In en, this message translates to:
  /// **'Reason for adjustment'**
  String get legacyUi00db810078;

  /// No description provided for @legacyUid4835a2d13.
  ///
  /// In en, this message translates to:
  /// **'Reason for amount override (5–500 characters)'**
  String get legacyUid4835a2d13;

  /// No description provided for @legacyUi03c3ccd3ff.
  ///
  /// In en, this message translates to:
  /// **'Recent Alerts'**
  String get legacyUi03c3ccd3ff;

  /// No description provided for @legacyUi3abf211c93.
  ///
  /// In en, this message translates to:
  /// **'Recent Payments'**
  String get legacyUi3abf211c93;

  /// No description provided for @legacyUi93c62de33f.
  ///
  /// In en, this message translates to:
  /// **'Recent Users'**
  String get legacyUi93c62de33f;

  /// No description provided for @legacyUi6b33999078.
  ///
  /// In en, this message translates to:
  /// **'Recent Vehicles'**
  String get legacyUi6b33999078;

  /// No description provided for @legacyUi790a1b9e7b.
  ///
  /// In en, this message translates to:
  /// **'Recent activity will appear here once the backend returns it.'**
  String get legacyUi790a1b9e7b;

  /// No description provided for @legacyUic1541851a1.
  ///
  /// In en, this message translates to:
  /// **'Recent service activity'**
  String get legacyUic1541851a1;

  /// No description provided for @legacyUi204110a010.
  ///
  /// In en, this message translates to:
  /// **'Recent users will appear here when the dashboard overview returns them.'**
  String get legacyUi204110a010;

  /// No description provided for @legacyUida67fde0f7.
  ///
  /// In en, this message translates to:
  /// **'Recenter'**
  String get legacyUida67fde0f7;

  /// No description provided for @legacyUi7df7c0bb40.
  ///
  /// In en, this message translates to:
  /// **'Recipient email'**
  String get legacyUi7df7c0bb40;

  /// No description provided for @legacyUi8ee92c936a.
  ///
  /// In en, this message translates to:
  /// **'Recipient/User'**
  String get legacyUi8ee92c936a;

  /// No description provided for @legacyUi6577ced3c0.
  ///
  /// In en, this message translates to:
  /// **'Record Payment'**
  String get legacyUi6577ced3c0;

  /// No description provided for @legacyUib19313692e.
  ///
  /// In en, this message translates to:
  /// **'Recorded By'**
  String get legacyUib19313692e;

  /// No description provided for @legacyUi471b94d402.
  ///
  /// In en, this message translates to:
  /// **'Redo'**
  String get legacyUi471b94d402;

  /// No description provided for @legacyUidb1c784524.
  ///
  /// In en, this message translates to:
  /// **'Reference'**
  String get legacyUidb1c784524;

  /// No description provided for @legacyUic9dc8442d5.
  ///
  /// In en, this message translates to:
  /// **'Reference (Optional)'**
  String get legacyUic9dc8442d5;

  /// No description provided for @legacyUie3039b8476.
  ///
  /// In en, this message translates to:
  /// **'Reference (optional)'**
  String get legacyUie3039b8476;

  /// No description provided for @legacyUid8b2ee1dcd.
  ///
  /// In en, this message translates to:
  /// **'Reference max length is 200'**
  String get legacyUid8b2ee1dcd;

  /// No description provided for @legacyUi7a8e2a362c.
  ///
  /// In en, this message translates to:
  /// **'Reference must be 100 characters or less.'**
  String get legacyUi7a8e2a362c;

  /// No description provided for @legacyUi483e715402.
  ///
  /// In en, this message translates to:
  /// **'Refresh administrators'**
  String get legacyUi483e715402;

  /// No description provided for @legacyUif2b5787c06.
  ///
  /// In en, this message translates to:
  /// **'Refresh dashboard'**
  String get legacyUif2b5787c06;

  /// No description provided for @legacyUie75f05fced.
  ///
  /// In en, this message translates to:
  /// **'Refresh drivers'**
  String get legacyUie75f05fced;

  /// No description provided for @legacyUiebbc55f9ce.
  ///
  /// In en, this message translates to:
  /// **'Refresh history'**
  String get legacyUiebbc55f9ce;

  /// No description provided for @legacyUid0512701b2.
  ///
  /// In en, this message translates to:
  /// **'Refresh inventory'**
  String get legacyUid0512701b2;

  /// No description provided for @legacyUif6cf59106a.
  ///
  /// In en, this message translates to:
  /// **'Refresh messages'**
  String get legacyUif6cf59106a;

  /// No description provided for @legacyUid7cb2b4eea.
  ///
  /// In en, this message translates to:
  /// **'Refresh report options'**
  String get legacyUid7cb2b4eea;

  /// No description provided for @legacyUi323540a087.
  ///
  /// In en, this message translates to:
  /// **'Refresh settings'**
  String get legacyUi323540a087;

  /// No description provided for @legacyUiade15a52e2.
  ///
  /// In en, this message translates to:
  /// **'Refresh status'**
  String get legacyUiade15a52e2;

  /// No description provided for @legacyUie4d3b8b5ff.
  ///
  /// In en, this message translates to:
  /// **'Refresh team'**
  String get legacyUie4d3b8b5ff;

  /// No description provided for @legacyUi12f92ceb6e.
  ///
  /// In en, this message translates to:
  /// **'Refresh tickets'**
  String get legacyUi12f92ceb6e;

  /// No description provided for @legacyUi3367ca735f.
  ///
  /// In en, this message translates to:
  /// **'Refresh transactions'**
  String get legacyUi3367ca735f;

  /// No description provided for @legacyUi892f6f322d.
  ///
  /// In en, this message translates to:
  /// **'Refresh users'**
  String get legacyUi892f6f322d;

  /// No description provided for @legacyUidf50facb6a.
  ///
  /// In en, this message translates to:
  /// **'Refresh vehicles'**
  String get legacyUidf50facb6a;

  /// No description provided for @legacyUid42d9c1932.
  ///
  /// In en, this message translates to:
  /// **'Refresh widget'**
  String get legacyUid42d9c1932;

  /// No description provided for @legacyUia844fcf834.
  ///
  /// In en, this message translates to:
  /// **'Registered'**
  String get legacyUia844fcf834;

  /// No description provided for @legacyUi9aba73febb.
  ///
  /// In en, this message translates to:
  /// **'Registered token last 10'**
  String get legacyUi9aba73febb;

  /// No description provided for @legacyUic498221a5a.
  ///
  /// In en, this message translates to:
  /// **'Registration date'**
  String get legacyUic498221a5a;

  /// No description provided for @legacyUi20e264f6a1.
  ///
  /// In en, this message translates to:
  /// **'Related stop'**
  String get legacyUi20e264f6a1;

  /// No description provided for @legacyUi62d14389b3.
  ///
  /// In en, this message translates to:
  /// **'Reload document types'**
  String get legacyUi62d14389b3;

  /// No description provided for @legacyUia2653dac4a.
  ///
  /// In en, this message translates to:
  /// **'Remark'**
  String get legacyUia2653dac4a;

  /// No description provided for @legacyUie963907dac.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get legacyUie963907dac;

  /// No description provided for @legacyUi0fcc6594fc.
  ///
  /// In en, this message translates to:
  /// **'Remove attachment'**
  String get legacyUi0fcc6594fc;

  /// No description provided for @legacyUi48666118ca.
  ///
  /// In en, this message translates to:
  /// **'Remove metadata row'**
  String get legacyUi48666118ca;

  /// No description provided for @legacyUif96ba1e583.
  ///
  /// In en, this message translates to:
  /// **'Remove vehicle assignment from this driver?'**
  String get legacyUif96ba1e583;

  /// No description provided for @legacyUi0165f7088a.
  ///
  /// In en, this message translates to:
  /// **'Renew'**
  String get legacyUi0165f7088a;

  /// No description provided for @legacyUib219a06163.
  ///
  /// In en, this message translates to:
  /// **'Renew Vehicle'**
  String get legacyUib219a06163;

  /// No description provided for @legacyUi4913250b6c.
  ///
  /// In en, this message translates to:
  /// **'Renew annual coverage'**
  String get legacyUi4913250b6c;

  /// No description provided for @legacyUif192fe3e94.
  ///
  /// In en, this message translates to:
  /// **'Renew annual coverage?'**
  String get legacyUif192fe3e94;

  /// No description provided for @legacyUi1cce449350.
  ///
  /// In en, this message translates to:
  /// **'Renew up to 100 vehicles at a time'**
  String get legacyUi1cce449350;

  /// No description provided for @legacyUi714c2b126f.
  ///
  /// In en, this message translates to:
  /// **'Renew up to 100 vehicles at a time.'**
  String get legacyUi714c2b126f;

  /// No description provided for @legacyUibb47b991fe.
  ///
  /// In en, this message translates to:
  /// **'Renewal requests'**
  String get legacyUibb47b991fe;

  /// No description provided for @legacyUiac2377c0dd.
  ///
  /// In en, this message translates to:
  /// **'Replay speed'**
  String get legacyUiac2377c0dd;

  /// No description provided for @legacyUi5cc45fda55.
  ///
  /// In en, this message translates to:
  /// **'Replies will appear here once the conversation starts.'**
  String get legacyUi5cc45fda55;

  /// No description provided for @legacyUid7a41420c8.
  ///
  /// In en, this message translates to:
  /// **'Replies will appear here once the ticket conversation starts.'**
  String get legacyUid7a41420c8;

  /// No description provided for @legacyUi1f21d9edca.
  ///
  /// In en, this message translates to:
  /// **'Reply is too long.'**
  String get legacyUi1f21d9edca;

  /// No description provided for @legacyUi4c7c79f6a9.
  ///
  /// In en, this message translates to:
  /// **'Reply message is required.'**
  String get legacyUi4c7c79f6a9;

  /// No description provided for @legacyUic9e8dd4159.
  ///
  /// In en, this message translates to:
  /// **'Reply sent successfully.'**
  String get legacyUic9e8dd4159;

  /// No description provided for @legacyUi5ce1bacd48.
  ///
  /// In en, this message translates to:
  /// **'Reply sent.'**
  String get legacyUi5ce1bacd48;

  /// No description provided for @legacyUi49072e5767.
  ///
  /// In en, this message translates to:
  /// **'Reply-To (optional)'**
  String get legacyUi49072e5767;

  /// No description provided for @legacyUi6e2c712363.
  ///
  /// In en, this message translates to:
  /// **'Report issue'**
  String get legacyUi6e2c712363;

  /// No description provided for @legacyUi0ca4fce136.
  ///
  /// In en, this message translates to:
  /// **'Report type'**
  String get legacyUi0ca4fce136;

  /// No description provided for @legacyUi4857497af3.
  ///
  /// In en, this message translates to:
  /// **'Request a new reset link'**
  String get legacyUi4857497af3;

  /// No description provided for @legacyUida30a140cc.
  ///
  /// In en, this message translates to:
  /// **'Request vehicle renewal?'**
  String get legacyUida30a140cc;

  /// No description provided for @legacyUic26bf60fed.
  ///
  /// In en, this message translates to:
  /// **'Requested'**
  String get legacyUic26bf60fed;

  /// No description provided for @legacyUi1d3cb8a962.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get legacyUi1d3cb8a962;

  /// No description provided for @legacyUi56553100b0.
  ///
  /// In en, this message translates to:
  /// **'Reset filters'**
  String get legacyUi56553100b0;

  /// No description provided for @legacyUibb02ea158c.
  ///
  /// In en, this message translates to:
  /// **'Reset link or token'**
  String get legacyUibb02ea158c;

  /// No description provided for @legacyUi3ddc852b26.
  ///
  /// In en, this message translates to:
  /// **'Reset north'**
  String get legacyUi3ddc852b26;

  /// No description provided for @legacyUi5c4bc97ee5.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get legacyUi5c4bc97ee5;

  /// No description provided for @legacyUi4f21821190.
  ///
  /// In en, this message translates to:
  /// **'Responded'**
  String get legacyUi4f21821190;

  /// No description provided for @legacyUi966ea65ee9.
  ///
  /// In en, this message translates to:
  /// **'Response hex'**
  String get legacyUi966ea65ee9;

  /// No description provided for @legacyUi3585d7553d.
  ///
  /// In en, this message translates to:
  /// **'Restaurant'**
  String get legacyUi3585d7553d;

  /// No description provided for @legacyUiab6d02bfbb.
  ///
  /// In en, this message translates to:
  /// **'Restricted by your administrator'**
  String get legacyUiab6d02bfbb;

  /// No description provided for @legacyUic7199d9e95.
  ///
  /// In en, this message translates to:
  /// **'Retention'**
  String get legacyUic7199d9e95;

  /// No description provided for @legacyUi9393bfa8e2.
  ///
  /// In en, this message translates to:
  /// **'Retention period'**
  String get legacyUi9393bfa8e2;

  /// No description provided for @legacyUibf1c27deea.
  ///
  /// In en, this message translates to:
  /// **'Retry loading currencies'**
  String get legacyUibf1c27deea;

  /// No description provided for @legacyUi2e84dd3c7d.
  ///
  /// In en, this message translates to:
  /// **'Retry registration'**
  String get legacyUi2e84dd3c7d;

  /// No description provided for @legacyUic507a566fc.
  ///
  /// In en, this message translates to:
  /// **'Reverse Geocoding Precision'**
  String get legacyUic507a566fc;

  /// No description provided for @legacyUi7148d08646.
  ///
  /// In en, this message translates to:
  /// **'Ripple'**
  String get legacyUi7148d08646;

  /// No description provided for @legacyUic3f104d136.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get legacyUic3f104d136;

  /// No description provided for @legacyUib1b392607d.
  ///
  /// In en, this message translates to:
  /// **'Run'**
  String get legacyUib1b392607d;

  /// No description provided for @legacyUi26c35575bf.
  ///
  /// In en, this message translates to:
  /// **'Run Sensor'**
  String get legacyUi26c35575bf;

  /// No description provided for @legacyUiba51f0a9fa.
  ///
  /// In en, this message translates to:
  /// **'Run a history search'**
  String get legacyUiba51f0a9fa;

  /// No description provided for @legacyUia84c30c93c.
  ///
  /// In en, this message translates to:
  /// **'Run cleanup'**
  String get legacyUia84c30c93c;

  /// No description provided for @legacyUibd4e4bc9f2.
  ///
  /// In en, this message translates to:
  /// **'SIM Number'**
  String get legacyUibd4e4bc9f2;

  /// No description provided for @legacyUi135447fb8f.
  ///
  /// In en, this message translates to:
  /// **'SIM Only'**
  String get legacyUi135447fb8f;

  /// No description provided for @legacyUi3454bbef7f.
  ///
  /// In en, this message translates to:
  /// **'SIM Provider'**
  String get legacyUi3454bbef7f;

  /// No description provided for @legacyUi0366e95ddf.
  ///
  /// In en, this message translates to:
  /// **'SIM Provider (optional)'**
  String get legacyUi0366e95ddf;

  /// No description provided for @legacyUi4636ab9e9a.
  ///
  /// In en, this message translates to:
  /// **'SIM card updated.'**
  String get legacyUi4636ab9e9a;

  /// No description provided for @legacyUi12897d0b88.
  ///
  /// In en, this message translates to:
  /// **'SIM status'**
  String get legacyUi12897d0b88;

  /// No description provided for @legacyUi1f4f5e7e3c.
  ///
  /// In en, this message translates to:
  /// **'SMTP account login.'**
  String get legacyUi1f4f5e7e3c;

  /// No description provided for @legacyUi7d08205aa6.
  ///
  /// In en, this message translates to:
  /// **'SMTP settings saved'**
  String get legacyUi7d08205aa6;

  /// No description provided for @legacyUia70c3bcf1d.
  ///
  /// In en, this message translates to:
  /// **'San Francisco'**
  String get legacyUia70c3bcf1d;

  /// No description provided for @legacyUi340bbc7875.
  ///
  /// In en, this message translates to:
  /// **'Satellites'**
  String get legacyUi340bbc7875;

  /// No description provided for @legacyUidb95397447.
  ///
  /// In en, this message translates to:
  /// **'Save .kml'**
  String get legacyUidb95397447;

  /// No description provided for @legacyUifa2984b367.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get legacyUifa2984b367;

  /// No description provided for @legacyUi78fe0922d6.
  ///
  /// In en, this message translates to:
  /// **'Save Company'**
  String get legacyUi78fe0922d6;

  /// No description provided for @legacyUic6606cd51c.
  ///
  /// In en, this message translates to:
  /// **'Save Config'**
  String get legacyUic6606cd51c;

  /// No description provided for @legacyUi909bf3e807.
  ///
  /// In en, this message translates to:
  /// **'Save Profile'**
  String get legacyUi909bf3e807;

  /// No description provided for @legacyUif2f3d66a79.
  ///
  /// In en, this message translates to:
  /// **'School'**
  String get legacyUif2f3d66a79;

  /// No description provided for @legacyUid09c8bca28.
  ///
  /// In en, this message translates to:
  /// **'Search SIM number…'**
  String get legacyUid09c8bca28;

  /// No description provided for @legacyUiabddbf1811.
  ///
  /// In en, this message translates to:
  /// **'Search activity logs...'**
  String get legacyUiabddbf1811;

  /// No description provided for @legacyUi9a99566535.
  ///
  /// In en, this message translates to:
  /// **'Search activity…'**
  String get legacyUi9a99566535;

  /// No description provided for @legacyUi1321daf435.
  ///
  /// In en, this message translates to:
  /// **'Search assigned drivers'**
  String get legacyUi1321daf435;

  /// No description provided for @legacyUie6ac2b6800.
  ///
  /// In en, this message translates to:
  /// **'Search assigned vehicles'**
  String get legacyUie6ac2b6800;

  /// No description provided for @legacyUi3a97577679.
  ///
  /// In en, this message translates to:
  /// **'Search available drivers'**
  String get legacyUi3a97577679;

  /// No description provided for @legacyUiacd1382ab4.
  ///
  /// In en, this message translates to:
  /// **'Search available vehicles'**
  String get legacyUiacd1382ab4;

  /// No description provided for @legacyUi03ef7546a9.
  ///
  /// In en, this message translates to:
  /// **'Search by IMEI...'**
  String get legacyUi03ef7546a9;

  /// No description provided for @legacyUia8854d5f97.
  ///
  /// In en, this message translates to:
  /// **'Search by code...'**
  String get legacyUia8854d5f97;

  /// No description provided for @legacyUi411482b8e7.
  ///
  /// In en, this message translates to:
  /// **'Search by date, activity, credits, vehicle…'**
  String get legacyUi411482b8e7;

  /// No description provided for @legacyUi28abc0313d.
  ///
  /// In en, this message translates to:
  /// **'Search by name'**
  String get legacyUi28abc0313d;

  /// No description provided for @legacyUi28f3d064ea.
  ///
  /// In en, this message translates to:
  /// **'Search by name or category'**
  String get legacyUi28f3d064ea;

  /// No description provided for @legacyUi4120e178da.
  ///
  /// In en, this message translates to:
  /// **'Search by name or plate…'**
  String get legacyUi4120e178da;

  /// No description provided for @legacyUibb6cfd804d.
  ///
  /// In en, this message translates to:
  /// **'Search by name, email…'**
  String get legacyUibb6cfd804d;

  /// No description provided for @legacyUi1c1d641fe8.
  ///
  /// In en, this message translates to:
  /// **'Search by name, plate, IMEI, or VIN'**
  String get legacyUi1c1d641fe8;

  /// No description provided for @legacyUife32b8f32a.
  ///
  /// In en, this message translates to:
  /// **'Search by name, plate, IMEI…'**
  String get legacyUife32b8f32a;

  /// No description provided for @legacyUibdc6551409.
  ///
  /// In en, this message translates to:
  /// **'Search by name, plate, VIN, IMEI, SIM...'**
  String get legacyUibdc6551409;

  /// No description provided for @legacyUiba20cfd893.
  ///
  /// In en, this message translates to:
  /// **'Search by reference or admin...'**
  String get legacyUiba20cfd893;

  /// No description provided for @legacyUi45b6baaad3.
  ///
  /// In en, this message translates to:
  /// **'Search daily records...'**
  String get legacyUi45b6baaad3;

  /// No description provided for @legacyUie43926680a.
  ///
  /// In en, this message translates to:
  /// **'Search device logs'**
  String get legacyUie43926680a;

  /// No description provided for @legacyUi26eb1d222b.
  ///
  /// In en, this message translates to:
  /// **'Search device type…'**
  String get legacyUi26eb1d222b;

  /// No description provided for @legacyUi98110e65a0.
  ///
  /// In en, this message translates to:
  /// **'Search loaded logs'**
  String get legacyUi98110e65a0;

  /// No description provided for @legacyUi48225af1f4.
  ///
  /// In en, this message translates to:
  /// **'Search logs'**
  String get legacyUi48225af1f4;

  /// No description provided for @legacyUi20f28ed35b.
  ///
  /// In en, this message translates to:
  /// **'Search name, IMEI, SIM, type'**
  String get legacyUi20f28ed35b;

  /// No description provided for @legacyUic60723c651.
  ///
  /// In en, this message translates to:
  /// **'Search name, plate or IMEI'**
  String get legacyUic60723c651;

  /// No description provided for @legacyUi3dadc5cddf.
  ///
  /// In en, this message translates to:
  /// **'Search name, username, email, mobile, vehicle, plate...'**
  String get legacyUi3dadc5cddf;

  /// No description provided for @legacyUi0417c5f97b.
  ///
  /// In en, this message translates to:
  /// **'Search name, username, email, mobile...'**
  String get legacyUi0417c5f97b;

  /// No description provided for @legacyUi5196e5c8da.
  ///
  /// In en, this message translates to:
  /// **'Search place or address...'**
  String get legacyUi5196e5c8da;

  /// No description provided for @legacyUic3290fb221.
  ///
  /// In en, this message translates to:
  /// **'Search place...'**
  String get legacyUic3290fb221;

  /// No description provided for @legacyUi60c8ce351b.
  ///
  /// In en, this message translates to:
  /// **'Search plans, currency, duration, price...'**
  String get legacyUi60c8ce351b;

  /// No description provided for @legacyUie5483c71e7.
  ///
  /// In en, this message translates to:
  /// **'Search provider…'**
  String get legacyUie5483c71e7;

  /// No description provided for @legacyUi98e27d7b41.
  ///
  /// In en, this message translates to:
  /// **'Search reference, provider, counterparty...'**
  String get legacyUi98e27d7b41;

  /// No description provided for @legacyUidd77f6ecc1.
  ///
  /// In en, this message translates to:
  /// **'Search reference, provider, user, vehicle'**
  String get legacyUidd77f6ecc1;

  /// No description provided for @legacyUi0066a752cb.
  ///
  /// In en, this message translates to:
  /// **'Search routes by name'**
  String get legacyUi0066a752cb;

  /// No description provided for @legacyUi502e6eaf2c.
  ///
  /// In en, this message translates to:
  /// **'Search sensors'**
  String get legacyUi502e6eaf2c;

  /// No description provided for @legacyUi0cfffb61af.
  ///
  /// In en, this message translates to:
  /// **'Search sensors...'**
  String get legacyUi0cfffb61af;

  /// No description provided for @legacyUi233ad2b14f.
  ///
  /// In en, this message translates to:
  /// **'Search subject, number, status'**
  String get legacyUi233ad2b14f;

  /// No description provided for @legacyUid320d41a03.
  ///
  /// In en, this message translates to:
  /// **'Search tickets'**
  String get legacyUid320d41a03;

  /// No description provided for @legacyUi65da39d5f0.
  ///
  /// In en, this message translates to:
  /// **'Search transactions...'**
  String get legacyUi65da39d5f0;

  /// No description provided for @legacyUi25dfae4e3a.
  ///
  /// In en, this message translates to:
  /// **'Search trips'**
  String get legacyUi25dfae4e3a;

  /// No description provided for @legacyUida80ead473.
  ///
  /// In en, this message translates to:
  /// **'Search unlinked users...'**
  String get legacyUida80ead473;

  /// No description provided for @legacyUie5b2404515.
  ///
  /// In en, this message translates to:
  /// **'Search users, vehicles…'**
  String get legacyUie5b2404515;

  /// No description provided for @legacyUi8cdc4c0930.
  ///
  /// In en, this message translates to:
  /// **'Search users...'**
  String get legacyUi8cdc4c0930;

  /// No description provided for @legacyUi2e4b72c10c.
  ///
  /// In en, this message translates to:
  /// **'Search vehicle'**
  String get legacyUi2e4b72c10c;

  /// No description provided for @legacyUi1bd54471c2.
  ///
  /// In en, this message translates to:
  /// **'Search vehicle events...'**
  String get legacyUi1bd54471c2;

  /// No description provided for @legacyUiba537c59ae.
  ///
  /// In en, this message translates to:
  /// **'Search vehicle, plate, VIN, IMEI, SIM, user…'**
  String get legacyUiba537c59ae;

  /// No description provided for @legacyUi4a54a9e6db.
  ///
  /// In en, this message translates to:
  /// **'Search vehicle, plate, VIN, IMEI, SIM...'**
  String get legacyUi4a54a9e6db;

  /// No description provided for @legacyUi5780b5d6bf.
  ///
  /// In en, this message translates to:
  /// **'Search vehicles'**
  String get legacyUi5780b5d6bf;

  /// No description provided for @legacyUi50efae1b5f.
  ///
  /// In en, this message translates to:
  /// **'Search vehicles by name, plate, plan...'**
  String get legacyUi50efae1b5f;

  /// No description provided for @legacyUib09b43245d.
  ///
  /// In en, this message translates to:
  /// **'Search vehicles...'**
  String get legacyUib09b43245d;

  /// No description provided for @legacyUif54fbca187.
  ///
  /// In en, this message translates to:
  /// **'Search…'**
  String get legacyUif54fbca187;

  /// No description provided for @legacyUifaaee5e23e.
  ///
  /// In en, this message translates to:
  /// **'Select SIM'**
  String get legacyUifaaee5e23e;

  /// No description provided for @legacyUi69cc521201.
  ///
  /// In en, this message translates to:
  /// **'Select a country'**
  String get legacyUi69cc521201;

  /// No description provided for @legacyUi400a58f1cc.
  ///
  /// In en, this message translates to:
  /// **'Select a range to load history.'**
  String get legacyUi400a58f1cc;

  /// No description provided for @legacyUie216b735f0.
  ///
  /// In en, this message translates to:
  /// **'Select a user first.'**
  String get legacyUie216b735f0;

  /// No description provided for @legacyUie965317576.
  ///
  /// In en, this message translates to:
  /// **'Select a vehicle first.'**
  String get legacyUie965317576;

  /// No description provided for @legacyUia72bd23c12.
  ///
  /// In en, this message translates to:
  /// **'Select a vehicle, stop threshold, and date time range.'**
  String get legacyUia72bd23c12;

  /// No description provided for @legacyUi29c9360313.
  ///
  /// In en, this message translates to:
  /// **'Select administrator'**
  String get legacyUi29c9360313;

  /// No description provided for @legacyUi8a152d2c3f.
  ///
  /// In en, this message translates to:
  /// **'Select at least one renewable vehicle'**
  String get legacyUi8a152d2c3f;

  /// No description provided for @legacyUi5573da8514.
  ///
  /// In en, this message translates to:
  /// **'Select at least one vehicle.'**
  String get legacyUi5573da8514;

  /// No description provided for @legacyUi42303635fc.
  ///
  /// In en, this message translates to:
  /// **'Select city'**
  String get legacyUi42303635fc;

  /// No description provided for @legacyUi9915f6e5c2.
  ///
  /// In en, this message translates to:
  /// **'Select color'**
  String get legacyUi9915f6e5c2;

  /// No description provided for @legacyUia96ce92893.
  ///
  /// In en, this message translates to:
  /// **'Select command template'**
  String get legacyUia96ce92893;

  /// No description provided for @legacyUi59ee76bad1.
  ///
  /// In en, this message translates to:
  /// **'Select country'**
  String get legacyUi59ee76bad1;

  /// No description provided for @legacyUi74c388ab91.
  ///
  /// In en, this message translates to:
  /// **'Select date time range'**
  String get legacyUi74c388ab91;

  /// No description provided for @legacyUi46bfa11b12.
  ///
  /// In en, this message translates to:
  /// **'Select device type'**
  String get legacyUi46bfa11b12;

  /// No description provided for @legacyUidba2e6bd04.
  ///
  /// In en, this message translates to:
  /// **'Select document type'**
  String get legacyUidba2e6bd04;

  /// No description provided for @legacyUi386f8ba9d0.
  ///
  /// In en, this message translates to:
  /// **'Select primary user'**
  String get legacyUi386f8ba9d0;

  /// No description provided for @legacyUic7a9e8ea6a.
  ///
  /// In en, this message translates to:
  /// **'Select provider'**
  String get legacyUic7a9e8ea6a;

  /// No description provided for @legacyUib350802ae1.
  ///
  /// In en, this message translates to:
  /// **'Select state'**
  String get legacyUib350802ae1;

  /// No description provided for @legacyUi905d012288.
  ///
  /// In en, this message translates to:
  /// **'Select type'**
  String get legacyUi905d012288;

  /// No description provided for @legacyUib8a1d9de7d.
  ///
  /// In en, this message translates to:
  /// **'Select user'**
  String get legacyUib8a1d9de7d;

  /// No description provided for @legacyUie574e3a29d.
  ///
  /// In en, this message translates to:
  /// **'Select vehicles with the same plan currency'**
  String get legacyUie574e3a29d;

  /// No description provided for @legacyUi07f0f61db9.
  ///
  /// In en, this message translates to:
  /// **'Selected file is empty.'**
  String get legacyUi07f0f61db9;

  /// No description provided for @legacyUi9bc2575c39.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get legacyUi9bc2575c39;

  /// No description provided for @legacyUi0ad7c21624.
  ///
  /// In en, this message translates to:
  /// **'Send Command'**
  String get legacyUi0ad7c21624;

  /// No description provided for @legacyUi9b48248439.
  ///
  /// In en, this message translates to:
  /// **'Send a command to see history.'**
  String get legacyUi9b48248439;

  /// No description provided for @legacyUi724aa54b02.
  ///
  /// In en, this message translates to:
  /// **'Send command to vehicle?'**
  String get legacyUi724aa54b02;

  /// No description provided for @legacyUic70a890d14.
  ///
  /// In en, this message translates to:
  /// **'Send message'**
  String get legacyUic70a890d14;

  /// No description provided for @legacyUia89d641794.
  ///
  /// In en, this message translates to:
  /// **'Send request'**
  String get legacyUia89d641794;

  /// No description provided for @legacyUib8ec554332.
  ///
  /// In en, this message translates to:
  /// **'Send reset link'**
  String get legacyUib8ec554332;

  /// No description provided for @legacyUi1aba33d6c2.
  ///
  /// In en, this message translates to:
  /// **'Send test'**
  String get legacyUi1aba33d6c2;

  /// No description provided for @legacyUifc552c754d.
  ///
  /// In en, this message translates to:
  /// **'Send test email'**
  String get legacyUifc552c754d;

  /// No description provided for @legacyUi17b874d289.
  ///
  /// In en, this message translates to:
  /// **'Sender'**
  String get legacyUi17b874d289;

  /// No description provided for @legacyUi679e8f61b9.
  ///
  /// In en, this message translates to:
  /// **'Sender Name'**
  String get legacyUi679e8f61b9;

  /// No description provided for @legacyUi73dcba5635.
  ///
  /// In en, this message translates to:
  /// **'Sensor History'**
  String get legacyUi73dcba5635;

  /// No description provided for @legacyUia14460cfb3.
  ///
  /// In en, this message translates to:
  /// **'Sensor History Range'**
  String get legacyUia14460cfb3;

  /// No description provided for @legacyUia9bc44292f.
  ///
  /// In en, this message translates to:
  /// **'Sensor actions'**
  String get legacyUia9bc44292f;

  /// No description provided for @legacyUi18d80b838f.
  ///
  /// In en, this message translates to:
  /// **'Sensor deleted.'**
  String get legacyUi18d80b838f;

  /// No description provided for @legacyUi711bf35988.
  ///
  /// In en, this message translates to:
  /// **'Sensors'**
  String get legacyUi711bf35988;

  /// No description provided for @legacyUi48380dd0e2.
  ///
  /// In en, this message translates to:
  /// **'Sensors unavailable'**
  String get legacyUi48380dd0e2;

  /// No description provided for @legacyUi35f49dcfbf.
  ///
  /// In en, this message translates to:
  /// **'Sent'**
  String get legacyUi35f49dcfbf;

  /// No description provided for @legacyUi2d7bb03171.
  ///
  /// In en, this message translates to:
  /// **'Sent commands and device responses appear here.'**
  String get legacyUi2d7bb03171;

  /// No description provided for @legacyUi1d5d1effa9.
  ///
  /// In en, this message translates to:
  /// **'Server URL'**
  String get legacyUi1d5d1effa9;

  /// No description provided for @legacyUif85e6f1bdc.
  ///
  /// In en, this message translates to:
  /// **'Server Uptime'**
  String get legacyUif85e6f1bdc;

  /// No description provided for @legacyUi10802e852c.
  ///
  /// In en, this message translates to:
  /// **'Server time'**
  String get legacyUi10802e852c;

  /// No description provided for @legacyUi7ef53dd844.
  ///
  /// In en, this message translates to:
  /// **'Service expiry must follow registration.'**
  String get legacyUi7ef53dd844;

  /// No description provided for @legacyUi2ad34ef4cf.
  ///
  /// In en, this message translates to:
  /// **'Service plan'**
  String get legacyUi2ad34ef4cf;

  /// No description provided for @legacyUi2bacd5f581.
  ///
  /// In en, this message translates to:
  /// **'Service starts'**
  String get legacyUi2bacd5f581;

  /// No description provided for @legacyUiaa02a8d843.
  ///
  /// In en, this message translates to:
  /// **'Set Engine Hours'**
  String get legacyUiaa02a8d843;

  /// No description provided for @legacyUi837c0d47b5.
  ///
  /// In en, this message translates to:
  /// **'Set Odometer'**
  String get legacyUi837c0d47b5;

  /// No description provided for @legacyUiaef97bb06a.
  ///
  /// In en, this message translates to:
  /// **'Settings saved'**
  String get legacyUiaef97bb06a;

  /// No description provided for @legacyUi96a0dc481b.
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get legacyUi96a0dc481b;

  /// No description provided for @legacyUi5e65ca08ed.
  ///
  /// In en, this message translates to:
  /// **'Short issue title'**
  String get legacyUi5e65ca08ed;

  /// No description provided for @legacyUi4c742d5133.
  ///
  /// In en, this message translates to:
  /// **'Show Geofence'**
  String get legacyUi4c742d5133;

  /// No description provided for @legacyUi5abbf34ba3.
  ///
  /// In en, this message translates to:
  /// **'Show History'**
  String get legacyUi5abbf34ba3;

  /// No description provided for @legacyUi8268618610.
  ///
  /// In en, this message translates to:
  /// **'Show animated pulse around running vehicles'**
  String get legacyUi8268618610;

  /// No description provided for @legacyUi25911d48e0.
  ///
  /// In en, this message translates to:
  /// **'Show more'**
  String get legacyUi25911d48e0;

  /// No description provided for @legacyUi50b47f1483.
  ///
  /// In en, this message translates to:
  /// **'Show points of interest markers'**
  String get legacyUi50b47f1483;

  /// No description provided for @legacyUib7f93469b9.
  ///
  /// In en, this message translates to:
  /// **'Show route trail'**
  String get legacyUib7f93469b9;

  /// No description provided for @legacyUi510904927e.
  ///
  /// In en, this message translates to:
  /// **'Show vehicle name next to the icon on the map'**
  String get legacyUi510904927e;

  /// No description provided for @legacyUi6e61e47d5c.
  ///
  /// In en, this message translates to:
  /// **'Shown on dark backgrounds. PNG, JPG, SVG, WEBP. Max 5 MB.'**
  String get legacyUi6e61e47d5c;

  /// No description provided for @legacyUi39e4052ecf.
  ///
  /// In en, this message translates to:
  /// **'Shown on light backgrounds. PNG, JPG, SVG, WEBP. Max 5 MB.'**
  String get legacyUi39e4052ecf;

  /// No description provided for @legacyUi894bc414e6.
  ///
  /// In en, this message translates to:
  /// **'Signup'**
  String get legacyUi894bc414e6;

  /// No description provided for @legacyUi69c2037890.
  ///
  /// In en, this message translates to:
  /// **'Skip end'**
  String get legacyUi69c2037890;

  /// No description provided for @legacyUia8522e4c9d.
  ///
  /// In en, this message translates to:
  /// **'Skip start'**
  String get legacyUia8522e4c9d;

  /// No description provided for @legacyUi33dcec9ce4.
  ///
  /// In en, this message translates to:
  /// **'Slow'**
  String get legacyUi33dcec9ce4;

  /// No description provided for @legacyUicf606d0913.
  ///
  /// In en, this message translates to:
  /// **'Slower'**
  String get legacyUicf606d0913;

  /// No description provided for @legacyUi339c1ea94b.
  ///
  /// In en, this message translates to:
  /// **'Social Links'**
  String get legacyUi339c1ea94b;

  /// No description provided for @legacyUi3db7211438.
  ///
  /// In en, this message translates to:
  /// **'Sort SIM cards'**
  String get legacyUi3db7211438;

  /// No description provided for @legacyUi66758a74bc.
  ///
  /// In en, this message translates to:
  /// **'Sort administrators'**
  String get legacyUi66758a74bc;

  /// No description provided for @legacyUi3655295cb4.
  ///
  /// In en, this message translates to:
  /// **'Sort devices'**
  String get legacyUi3655295cb4;

  /// No description provided for @legacyUi3a21e72182.
  ///
  /// In en, this message translates to:
  /// **'Sort drivers'**
  String get legacyUi3a21e72182;

  /// No description provided for @legacyUi1e891a0102.
  ///
  /// In en, this message translates to:
  /// **'Sort team'**
  String get legacyUi1e891a0102;

  /// No description provided for @legacyUi6d1ba980e8.
  ///
  /// In en, this message translates to:
  /// **'Sort users'**
  String get legacyUi6d1ba980e8;

  /// No description provided for @legacyUi2512bda9e7.
  ///
  /// In en, this message translates to:
  /// **'Sort vehicles'**
  String get legacyUi2512bda9e7;

  /// No description provided for @legacyUi6da13addb0.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get legacyUi6da13addb0;

  /// No description provided for @legacyUi6ace449732.
  ///
  /// In en, this message translates to:
  /// **'South'**
  String get legacyUi6ace449732;

  /// No description provided for @legacyUi2d2cb022bc.
  ///
  /// In en, this message translates to:
  /// **'Speed'**
  String get legacyUi2d2cb022bc;

  /// No description provided for @legacyUi8a14aeec13.
  ///
  /// In en, this message translates to:
  /// **'Speed Multiplier'**
  String get legacyUi8a14aeec13;

  /// No description provided for @legacyUid6a0aaa660.
  ///
  /// In en, this message translates to:
  /// **'Speed Variation'**
  String get legacyUid6a0aaa660;

  /// No description provided for @legacyUi09a7707087.
  ///
  /// In en, this message translates to:
  /// **'Start manually'**
  String get legacyUi09a7707087;

  /// No description provided for @legacyUi7e244fee11.
  ///
  /// In en, this message translates to:
  /// **'Start time must be before end time.'**
  String get legacyUi7e244fee11;

  /// No description provided for @legacyUia725020675.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get legacyUia725020675;

  /// No description provided for @legacyUi4e5c9805af.
  ///
  /// In en, this message translates to:
  /// **'State (optional)'**
  String get legacyUi4e5c9805af;

  /// No description provided for @legacyUic01247416e.
  ///
  /// In en, this message translates to:
  /// **'State is required.'**
  String get legacyUic01247416e;

  /// No description provided for @legacyUiedde30a0b6.
  ///
  /// In en, this message translates to:
  /// **'Status : '**
  String get legacyUiedde30a0b6;

  /// No description provided for @legacyUia0539c7e7a.
  ///
  /// In en, this message translates to:
  /// **'Status distribution is not available for this range.'**
  String get legacyUia0539c7e7a;

  /// No description provided for @legacyUie4fe064446.
  ///
  /// In en, this message translates to:
  /// **'Stop Minutes'**
  String get legacyUie4fe064446;

  /// No description provided for @legacyUif32715a2f1.
  ///
  /// In en, this message translates to:
  /// **'Stoppage marker'**
  String get legacyUif32715a2f1;

  /// No description provided for @legacyUi5ca845e914.
  ///
  /// In en, this message translates to:
  /// **'Street, building, area…'**
  String get legacyUi5ca845e914;

  /// No description provided for @legacyUi4d08ec5874.
  ///
  /// In en, this message translates to:
  /// **'Stripe'**
  String get legacyUi4d08ec5874;

  /// No description provided for @legacyUi8de713bd12.
  ///
  /// In en, this message translates to:
  /// **'Sub Users'**
  String get legacyUi8de713bd12;

  /// No description provided for @legacyUi97a0373212.
  ///
  /// In en, this message translates to:
  /// **'Sub user created.'**
  String get legacyUi97a0373212;

  /// No description provided for @legacyUi5cae4f427b.
  ///
  /// In en, this message translates to:
  /// **'Sub user deleted.'**
  String get legacyUi5cae4f427b;

  /// No description provided for @legacyUi2cc74ff5c3.
  ///
  /// In en, this message translates to:
  /// **'Sub user name'**
  String get legacyUi2cc74ff5c3;

  /// No description provided for @legacyUie44d50f72d.
  ///
  /// In en, this message translates to:
  /// **'Sub user updated.'**
  String get legacyUie44d50f72d;

  /// No description provided for @legacyUibd3159ff21.
  ///
  /// In en, this message translates to:
  /// **'Subject is required.'**
  String get legacyUibd3159ff21;

  /// No description provided for @legacyUi6844979e4f.
  ///
  /// In en, this message translates to:
  /// **'Subject must contain at least one letter or number.'**
  String get legacyUi6844979e4f;

  /// No description provided for @legacyUid6981f7476.
  ///
  /// In en, this message translates to:
  /// **'Subscribe'**
  String get legacyUid6981f7476;

  /// No description provided for @legacyUia547aab586.
  ///
  /// In en, this message translates to:
  /// **'Subscribed to email updates'**
  String get legacyUia547aab586;

  /// No description provided for @legacyUid7932a2917.
  ///
  /// In en, this message translates to:
  /// **'Successful'**
  String get legacyUid7932a2917;

  /// No description provided for @legacyUib879505819.
  ///
  /// In en, this message translates to:
  /// **'Support Ticket'**
  String get legacyUib879505819;

  /// No description provided for @legacyUi848eed0fbd.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get legacyUi848eed0fbd;

  /// No description provided for @legacyUi8c7e01ee22.
  ///
  /// In en, this message translates to:
  /// **'Tags (comma separated)'**
  String get legacyUi8c7e01ee22;

  /// No description provided for @legacyUi1df356a49e.
  ///
  /// In en, this message translates to:
  /// **'Tap the map or enter coordinates to place the POI.'**
  String get legacyUi1df356a49e;

  /// No description provided for @legacyUi61ad50a9b9.
  ///
  /// In en, this message translates to:
  /// **'Target'**
  String get legacyUi61ad50a9b9;

  /// No description provided for @legacyUi78560d88ef.
  ///
  /// In en, this message translates to:
  /// **'Team activated.'**
  String get legacyUi78560d88ef;

  /// No description provided for @legacyUid8f82f6030.
  ///
  /// In en, this message translates to:
  /// **'Team activity'**
  String get legacyUid8f82f6030;

  /// No description provided for @legacyUi8aef227384.
  ///
  /// In en, this message translates to:
  /// **'Team deactivated.'**
  String get legacyUi8aef227384;

  /// No description provided for @legacyUi72df525608.
  ///
  /// In en, this message translates to:
  /// **'Team member created.'**
  String get legacyUi72df525608;

  /// No description provided for @legacyUi07fed9d9b3.
  ///
  /// In en, this message translates to:
  /// **'Team member updated.'**
  String get legacyUi07fed9d9b3;

  /// No description provided for @legacyUi0194c31b6d.
  ///
  /// In en, this message translates to:
  /// **'Team permissions updated'**
  String get legacyUi0194c31b6d;

  /// No description provided for @legacyUi6730423d83.
  ///
  /// In en, this message translates to:
  /// **'Telemetry Detail'**
  String get legacyUi6730423d83;

  /// No description provided for @legacyUieef4095d19.
  ///
  /// In en, this message translates to:
  /// **'Telemetry Logs'**
  String get legacyUieef4095d19;

  /// No description provided for @legacyUif8d42e6122.
  ///
  /// In en, this message translates to:
  /// **'Telemetry date range'**
  String get legacyUif8d42e6122;

  /// No description provided for @legacyUi3ec1ae061c.
  ///
  /// In en, this message translates to:
  /// **'Template'**
  String get legacyUi3ec1ae061c;

  /// No description provided for @legacyUi7200f86ae5.
  ///
  /// In en, this message translates to:
  /// **'Test Mobile Push'**
  String get legacyUi7200f86ae5;

  /// No description provided for @legacyUi8b9bbdf230.
  ///
  /// In en, this message translates to:
  /// **'Test Push'**
  String get legacyUi8b9bbdf230;

  /// No description provided for @legacyUi8135cd8fa3.
  ///
  /// In en, this message translates to:
  /// **'The customer can create a fresh request. No vehicle service is extended.'**
  String get legacyUi8135cd8fa3;

  /// No description provided for @legacyUidc46c2859b.
  ///
  /// In en, this message translates to:
  /// **'The link expires automatically.'**
  String get legacyUidc46c2859b;

  /// No description provided for @legacyUic77eaa41ef.
  ///
  /// In en, this message translates to:
  /// **'The organisation this administrator manages within OpenVTS.'**
  String get legacyUic77eaa41ef;

  /// No description provided for @legacyUi461197e42e.
  ///
  /// In en, this message translates to:
  /// **'The organisation this user belongs to within OpenVTS.'**
  String get legacyUi461197e42e;

  /// No description provided for @legacyUia491398fbb.
  ///
  /// In en, this message translates to:
  /// **'The overview response does not include chart points yet.'**
  String get legacyUia491398fbb;

  /// No description provided for @legacyUi214cddfadb.
  ///
  /// In en, this message translates to:
  /// **'The overview response does not include recent vehicles yet.'**
  String get legacyUi214cddfadb;

  /// No description provided for @legacyUi9e4a7b1c4c.
  ///
  /// In en, this message translates to:
  /// **'The permission catalog is unavailable. Editing is disabled.'**
  String get legacyUi9e4a7b1c4c;

  /// No description provided for @legacyUiac4a475bbb.
  ///
  /// In en, this message translates to:
  /// **'The server returned an unsupported permission catalog. Editing is disabled.'**
  String get legacyUiac4a475bbb;

  /// No description provided for @legacyUi8895c1d4b6.
  ///
  /// In en, this message translates to:
  /// **'The upload finished, but the new profile photo was not returned by the server.'**
  String get legacyUi8895c1d4b6;

  /// No description provided for @legacyUidbc2f6bd85.
  ///
  /// In en, this message translates to:
  /// **'There are no alerts available right now.'**
  String get legacyUidbc2f6bd85;

  /// No description provided for @legacyUi9b519b14b9.
  ///
  /// In en, this message translates to:
  /// **'There are no events on this day'**
  String get legacyUi9b519b14b9;

  /// No description provided for @legacyUi354cfe028c.
  ///
  /// In en, this message translates to:
  /// **'These changes grant global or delete access. Apply them to this team member?'**
  String get legacyUi354cfe028c;

  /// No description provided for @legacyUi0f6cc3a89c.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get legacyUi0f6cc3a89c;

  /// No description provided for @legacyUi77528c94d9.
  ///
  /// In en, this message translates to:
  /// **'This Year'**
  String get legacyUi77528c94d9;

  /// No description provided for @legacyUi951f495b34.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get legacyUi951f495b34;

  /// No description provided for @legacyUi9b646010b8.
  ///
  /// In en, this message translates to:
  /// **'This file type is not allowed.'**
  String get legacyUi9b646010b8;

  /// No description provided for @legacyUi1b4785331d.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get legacyUi1b4785331d;

  /// No description provided for @legacyUi0e606e3993.
  ///
  /// In en, this message translates to:
  /// **'This saved dashboard has no widgets yet.'**
  String get legacyUi0e606e3993;

  /// No description provided for @legacyUi1e191e95f4.
  ///
  /// In en, this message translates to:
  /// **'This ticket is closed.'**
  String get legacyUi1e191e95f4;

  /// No description provided for @legacyUi8866cb1e0a.
  ///
  /// In en, this message translates to:
  /// **'This uses one account credit when the vehicle is eligible.'**
  String get legacyUi8866cb1e0a;

  /// No description provided for @legacyUi7b72883e07.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get legacyUi7b72883e07;

  /// No description provided for @legacyUi261bd2f51b.
  ///
  /// In en, this message translates to:
  /// **'Ticket Conversation'**
  String get legacyUi261bd2f51b;

  /// No description provided for @legacyUie1b858991f.
  ///
  /// In en, this message translates to:
  /// **'Ticket created.'**
  String get legacyUie1b858991f;

  /// No description provided for @legacyUi61322c9a86.
  ///
  /// In en, this message translates to:
  /// **'Ticket details'**
  String get legacyUi61322c9a86;

  /// No description provided for @legacyUif1e8e34245.
  ///
  /// In en, this message translates to:
  /// **'Ticket details are not available'**
  String get legacyUif1e8e34245;

  /// No description provided for @legacyUiaa27494c39.
  ///
  /// In en, this message translates to:
  /// **'Ticket status updated.'**
  String get legacyUiaa27494c39;

  /// No description provided for @legacyUiedcd363083.
  ///
  /// In en, this message translates to:
  /// **'Timed out'**
  String get legacyUiedcd363083;

  /// No description provided for @legacyUi768e0c1c69.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get legacyUi768e0c1c69;

  /// No description provided for @legacyUie39bf0152d.
  ///
  /// In en, this message translates to:
  /// **'Today Distance'**
  String get legacyUie39bf0152d;

  /// No description provided for @legacyUif43482f042.
  ///
  /// In en, this message translates to:
  /// **'Today Eng. Hours'**
  String get legacyUif43482f042;

  /// No description provided for @legacyUi7adacb5405.
  ///
  /// In en, this message translates to:
  /// **'Toggle Status'**
  String get legacyUi7adacb5405;

  /// No description provided for @legacyUi6d91e0bb03.
  ///
  /// In en, this message translates to:
  /// **'Tolerance'**
  String get legacyUi6d91e0bb03;

  /// No description provided for @legacyUid1bbcb6c01.
  ///
  /// In en, this message translates to:
  /// **'Tolerance (meters)'**
  String get legacyUid1bbcb6c01;

  /// No description provided for @legacyUi63cfb27f40.
  ///
  /// In en, this message translates to:
  /// **'Top Clients'**
  String get legacyUi63cfb27f40;

  /// No description provided for @legacyUibc6debbc28.
  ///
  /// In en, this message translates to:
  /// **'Top Performing Assets'**
  String get legacyUibc6debbc28;

  /// No description provided for @legacyUib25928c699.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get legacyUib25928c699;

  /// No description provided for @legacyUia672e7faed.
  ///
  /// In en, this message translates to:
  /// **'Total Eng. Hours'**
  String get legacyUia672e7faed;

  /// No description provided for @legacyUie9511a6560.
  ///
  /// In en, this message translates to:
  /// **'Total Received'**
  String get legacyUie9511a6560;

  /// No description provided for @legacyUia028fce203.
  ///
  /// In en, this message translates to:
  /// **'Total Users'**
  String get legacyUia028fce203;

  /// No description provided for @legacyUi5bcce6c936.
  ///
  /// In en, this message translates to:
  /// **'Total Vehicles'**
  String get legacyUi5bcce6c936;

  /// No description provided for @legacyUi7b777b27e0.
  ///
  /// In en, this message translates to:
  /// **'Total engine hours'**
  String get legacyUi7b777b27e0;

  /// No description provided for @legacyUi8578188376.
  ///
  /// In en, this message translates to:
  /// **'Total logs'**
  String get legacyUi8578188376;

  /// No description provided for @legacyUi0538b10824.
  ///
  /// In en, this message translates to:
  /// **'Track Link QR'**
  String get legacyUi0538b10824;

  /// No description provided for @legacyUi070fb0b6ea.
  ///
  /// In en, this message translates to:
  /// **'Track link deleted.'**
  String get legacyUi070fb0b6ea;

  /// No description provided for @legacyUief1f899cb2.
  ///
  /// In en, this message translates to:
  /// **'Transaction Details'**
  String get legacyUief1f899cb2;

  /// No description provided for @legacyUi06d8ffe653.
  ///
  /// In en, this message translates to:
  /// **'Transaction ID'**
  String get legacyUi06d8ffe653;

  /// No description provided for @legacyUi105b1510d9.
  ///
  /// In en, this message translates to:
  /// **'Transaction activity will appear here when available.'**
  String get legacyUi105b1510d9;

  /// No description provided for @legacyUid016e453e5.
  ///
  /// In en, this message translates to:
  /// **'Transaction details'**
  String get legacyUid016e453e5;

  /// No description provided for @legacyUiab39260fea.
  ///
  /// In en, this message translates to:
  /// **'Transitions'**
  String get legacyUiab39260fea;

  /// No description provided for @legacyUic10d76c9a4.
  ///
  /// In en, this message translates to:
  /// **'Transport'**
  String get legacyUic10d76c9a4;

  /// No description provided for @legacyUie82c27ca1d.
  ///
  /// In en, this message translates to:
  /// **'Trip cancelled'**
  String get legacyUie82c27ca1d;

  /// No description provided for @legacyUi4a9e77914e.
  ///
  /// In en, this message translates to:
  /// **'Try a different name or plate.'**
  String get legacyUi4a9e77914e;

  /// No description provided for @legacyUi4e653834fa.
  ///
  /// In en, this message translates to:
  /// **'Try a different search or filter.'**
  String get legacyUi4e653834fa;

  /// No description provided for @legacyUi39d6420eaa.
  ///
  /// In en, this message translates to:
  /// **'Try a different search term'**
  String get legacyUi39d6420eaa;

  /// No description provided for @legacyUi0ba628a33e.
  ///
  /// In en, this message translates to:
  /// **'Try a different search term.'**
  String get legacyUi0ba628a33e;

  /// No description provided for @legacyUi10239b38b5.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting the current filters or search query.'**
  String get legacyUi10239b38b5;

  /// No description provided for @legacyUi2253479cff.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your filters.'**
  String get legacyUi2253479cff;

  /// No description provided for @legacyUie3f4c649b5.
  ///
  /// In en, this message translates to:
  /// **'Try another name or plate number.'**
  String get legacyUie3f4c649b5;

  /// No description provided for @legacyUi10f570e880.
  ///
  /// In en, this message translates to:
  /// **'Try changing filters or search query.'**
  String get legacyUi10f570e880;

  /// No description provided for @legacyUif28432df1f.
  ///
  /// In en, this message translates to:
  /// **'Try changing filters.'**
  String get legacyUif28432df1f;

  /// No description provided for @legacyUi3c86b09439.
  ///
  /// In en, this message translates to:
  /// **'Try changing search or filters.'**
  String get legacyUi3c86b09439;

  /// No description provided for @legacyUi0ba0bd18bf.
  ///
  /// In en, this message translates to:
  /// **'Try clearing search or status filters.'**
  String get legacyUi0ba0bd18bf;

  /// No description provided for @legacyUi7a2fe508f6.
  ///
  /// In en, this message translates to:
  /// **'Try refreshing. If this persists, your account may not have notification preferences yet.'**
  String get legacyUi7a2fe508f6;

  /// No description provided for @legacyUia0b470cb00.
  ///
  /// In en, this message translates to:
  /// **'Twitter / X'**
  String get legacyUia0b470cb00;

  /// No description provided for @legacyUi8981df4d6a.
  ///
  /// In en, this message translates to:
  /// **'Twitter/X'**
  String get legacyUi8981df4d6a;

  /// No description provided for @legacyUi3deb745651.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get legacyUi3deb745651;

  /// No description provided for @legacyUie298b0ec36.
  ///
  /// In en, this message translates to:
  /// **'Type '**
  String get legacyUie298b0ec36;

  /// No description provided for @legacyUi4b3072dd4e.
  ///
  /// In en, this message translates to:
  /// **'Type command payload'**
  String get legacyUi4b3072dd4e;

  /// No description provided for @legacyUi5712bb4ea1.
  ///
  /// In en, this message translates to:
  /// **'Type manually'**
  String get legacyUi5712bb4ea1;

  /// No description provided for @legacyUi968be8d576.
  ///
  /// In en, this message translates to:
  /// **'Unable to change password.'**
  String get legacyUi968be8d576;

  /// No description provided for @legacyUi1da33a6b30.
  ///
  /// In en, this message translates to:
  /// **'Unable to load cities.'**
  String get legacyUi1da33a6b30;

  /// No description provided for @legacyUia4c5468d38.
  ///
  /// In en, this message translates to:
  /// **'Unable to load company details.'**
  String get legacyUia4c5468d38;

  /// No description provided for @legacyUicbae41853b.
  ///
  /// In en, this message translates to:
  /// **'Unable to load form options.'**
  String get legacyUicbae41853b;

  /// No description provided for @legacyUid06763ac1a.
  ///
  /// In en, this message translates to:
  /// **'Unable to load states.'**
  String get legacyUid06763ac1a;

  /// No description provided for @legacyUia471ebf750.
  ///
  /// In en, this message translates to:
  /// **'Unable to load users.'**
  String get legacyUia471ebf750;

  /// No description provided for @legacyUibf0bc28bdb.
  ///
  /// In en, this message translates to:
  /// **'Unable to load vehicles.'**
  String get legacyUibf0bc28bdb;

  /// No description provided for @legacyUid73d7a7c96.
  ///
  /// In en, this message translates to:
  /// **'Unable to open file.'**
  String get legacyUid73d7a7c96;

  /// No description provided for @legacyUi8ace6e9280.
  ///
  /// In en, this message translates to:
  /// **'Unable to open image picker.'**
  String get legacyUi8ace6e9280;

  /// No description provided for @legacyUidcbaa0588e.
  ///
  /// In en, this message translates to:
  /// **'Unable to open navigation for this vehicle.'**
  String get legacyUidcbaa0588e;

  /// No description provided for @legacyUi14fdbab84b.
  ///
  /// In en, this message translates to:
  /// **'Unable to open this attachment.'**
  String get legacyUi14fdbab84b;

  /// No description provided for @legacyUia457295e9f.
  ///
  /// In en, this message translates to:
  /// **'Unable to read the selected image.'**
  String get legacyUia457295e9f;

  /// No description provided for @legacyUi9e97e5bfed.
  ///
  /// In en, this message translates to:
  /// **'Unable to refresh users.'**
  String get legacyUi9e97e5bfed;

  /// No description provided for @legacyUi800f200671.
  ///
  /// In en, this message translates to:
  /// **'Unable to update status.'**
  String get legacyUi800f200671;

  /// No description provided for @legacyUice1c9c972b.
  ///
  /// In en, this message translates to:
  /// **'Unable to update team member status.'**
  String get legacyUice1c9c972b;

  /// No description provided for @legacyUib5f12c7d4f.
  ///
  /// In en, this message translates to:
  /// **'Unable to update team member.'**
  String get legacyUib5f12c7d4f;

  /// No description provided for @legacyUia046b8ac56.
  ///
  /// In en, this message translates to:
  /// **'Unable to update the server URL.'**
  String get legacyUia046b8ac56;

  /// No description provided for @legacyUi896bfd3a9a.
  ///
  /// In en, this message translates to:
  /// **'Unassign'**
  String get legacyUi896bfd3a9a;

  /// No description provided for @legacyUi7be6acc7f8.
  ///
  /// In en, this message translates to:
  /// **'Unassign User?'**
  String get legacyUi7be6acc7f8;

  /// No description provided for @legacyUi05027a8753.
  ///
  /// In en, this message translates to:
  /// **'Unassign user'**
  String get legacyUi05027a8753;

  /// No description provided for @legacyUi2d5a96092e.
  ///
  /// In en, this message translates to:
  /// **'Unassign vehicle'**
  String get legacyUi2d5a96092e;

  /// No description provided for @legacyUi39fc721248.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get legacyUi39fc721248;

  /// No description provided for @legacyUice77c2f42c.
  ///
  /// In en, this message translates to:
  /// **'Unique code'**
  String get legacyUice77c2f42c;

  /// No description provided for @legacyUif6b935ab33.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get legacyUif6b935ab33;

  /// No description provided for @legacyUi07b032b56f.
  ///
  /// In en, this message translates to:
  /// **'Unread'**
  String get legacyUi07b032b56f;

  /// No description provided for @legacyUi100cb4d890.
  ///
  /// In en, this message translates to:
  /// **'Unsupported file type.'**
  String get legacyUi100cb4d890;

  /// No description provided for @legacyUicb9925a338.
  ///
  /// In en, this message translates to:
  /// **'Unsupported format. Use PNG, JPG, JPEG or WEBP.'**
  String get legacyUicb9925a338;

  /// No description provided for @legacyUi99974d3476.
  ///
  /// In en, this message translates to:
  /// **'Unsupported widget'**
  String get legacyUi99974d3476;

  /// No description provided for @legacyUieb27a190c0.
  ///
  /// In en, this message translates to:
  /// **'Unverified'**
  String get legacyUieb27a190c0;

  /// No description provided for @legacyUi61dcf34e70.
  ///
  /// In en, this message translates to:
  /// **'Update Password'**
  String get legacyUi61dcf34e70;

  /// No description provided for @legacyUieae1f5caf5.
  ///
  /// In en, this message translates to:
  /// **'Update status'**
  String get legacyUieae1f5caf5;

  /// No description provided for @legacyUif2f8570ddd.
  ///
  /// In en, this message translates to:
  /// **'Updated'**
  String get legacyUif2f8570ddd;

  /// No description provided for @legacyUi22714274a4.
  ///
  /// In en, this message translates to:
  /// **'Updated At'**
  String get legacyUi22714274a4;

  /// No description provided for @legacyUi8bdf057f91.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get legacyUi8bdf057f91;

  /// No description provided for @legacyUi9e2628eec4.
  ///
  /// In en, this message translates to:
  /// **'Upload Document'**
  String get legacyUi9e2628eec4;

  /// No description provided for @legacyUidcad7d982a.
  ///
  /// In en, this message translates to:
  /// **'Upload a document to get started.'**
  String get legacyUidcad7d982a;

  /// No description provided for @legacyUi73183a7050.
  ///
  /// In en, this message translates to:
  /// **'Upload document'**
  String get legacyUi73183a7050;

  /// No description provided for @legacyUid714896782.
  ///
  /// In en, this message translates to:
  /// **'Upload documents for this vehicle.'**
  String get legacyUid714896782;

  /// No description provided for @legacyUi4b87ccd949.
  ///
  /// In en, this message translates to:
  /// **'Upload driver files like license or identity proofs.'**
  String get legacyUi4b87ccd949;

  /// No description provided for @legacyUi6aafa80cab.
  ///
  /// In en, this message translates to:
  /// **'Uptime'**
  String get legacyUi6aafa80cab;

  /// No description provided for @legacyUif1f71137de.
  ///
  /// In en, this message translates to:
  /// **'Use a strong, unique password'**
  String get legacyUif1f71137de;

  /// No description provided for @legacyUid81b6af542.
  ///
  /// In en, this message translates to:
  /// **'Use all'**
  String get legacyUid81b6af542;

  /// No description provided for @legacyUi5895bc72eb.
  ///
  /// In en, this message translates to:
  /// **'Used for regional defaults like currency, timezone, and routing.'**
  String get legacyUi5895bc72eb;

  /// No description provided for @legacyUi81c9245d46.
  ///
  /// In en, this message translates to:
  /// **'User Tickets'**
  String get legacyUi81c9245d46;

  /// No description provided for @legacyUi81939432dd.
  ///
  /// In en, this message translates to:
  /// **'User actions'**
  String get legacyUi81939432dd;

  /// No description provided for @legacyUi0abfc13cb8.
  ///
  /// In en, this message translates to:
  /// **'User assigned.'**
  String get legacyUi0abfc13cb8;

  /// No description provided for @legacyUi6188702f9e.
  ///
  /// In en, this message translates to:
  /// **'User created and selected'**
  String get legacyUi6188702f9e;

  /// No description provided for @legacyUi0ba72d0bce.
  ///
  /// In en, this message translates to:
  /// **'User deleted.'**
  String get legacyUi0ba72d0bce;

  /// No description provided for @legacyUi8fd72dd6f9.
  ///
  /// In en, this message translates to:
  /// **'User is required'**
  String get legacyUi8fd72dd6f9;

  /// No description provided for @legacyUi5ed13310cc.
  ///
  /// In en, this message translates to:
  /// **'User is required.'**
  String get legacyUi5ed13310cc;

  /// No description provided for @legacyUib0b238b57a.
  ///
  /// In en, this message translates to:
  /// **'User permissions updated'**
  String get legacyUib0b238b57a;

  /// No description provided for @legacyUia42cd2f9d5.
  ///
  /// In en, this message translates to:
  /// **'User unassigned.'**
  String get legacyUia42cd2f9d5;

  /// No description provided for @legacyUi2355aced23.
  ///
  /// In en, this message translates to:
  /// **'User updated.'**
  String get legacyUi2355aced23;

  /// No description provided for @legacyUi84c29015de.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get legacyUi84c29015de;

  /// No description provided for @legacyUib1974b83bc.
  ///
  /// In en, this message translates to:
  /// **'Username (optional)'**
  String get legacyUib1974b83bc;

  /// No description provided for @legacyUi2c7ab350b3.
  ///
  /// In en, this message translates to:
  /// **'Username or email'**
  String get legacyUi2c7ab350b3;

  /// No description provided for @legacyUi73dbef356e.
  ///
  /// In en, this message translates to:
  /// **'VIN (optional)'**
  String get legacyUi73dbef356e;

  /// No description provided for @legacyUi39852971ee.
  ///
  /// In en, this message translates to:
  /// **'VIN Number'**
  String get legacyUi39852971ee;

  /// No description provided for @legacyUia4aefa35c3.
  ///
  /// In en, this message translates to:
  /// **'Valid'**
  String get legacyUia4aefa35c3;

  /// No description provided for @legacyUi8dce170de2.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get legacyUi8dce170de2;

  /// No description provided for @legacyUi7bac966778.
  ///
  /// In en, this message translates to:
  /// **'Vehicle / Plan'**
  String get legacyUi7bac966778;

  /// No description provided for @legacyUi43188a5960.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Event Detail'**
  String get legacyUi43188a5960;

  /// No description provided for @legacyUi2d80c33ed3.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Events'**
  String get legacyUi2d80c33ed3;

  /// No description provided for @legacyUi4d461104bf.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Expiry'**
  String get legacyUi4d461104bf;

  /// No description provided for @legacyUi9e47ccbff4.
  ///
  /// In en, this message translates to:
  /// **'Vehicle IMEI is required to load events.'**
  String get legacyUi9e47ccbff4;

  /// No description provided for @legacyUi2b51e72835.
  ///
  /// In en, this message translates to:
  /// **'Vehicle IMEI is required to load sensors.'**
  String get legacyUi2b51e72835;

  /// No description provided for @legacyUief04c2235a.
  ///
  /// In en, this message translates to:
  /// **'Vehicle IMEI is required to load telemetry logs.'**
  String get legacyUief04c2235a;

  /// No description provided for @legacyUi62dc158d0e.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Label'**
  String get legacyUi62dc158d0e;

  /// No description provided for @legacyUicb4e4154e4.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Meta'**
  String get legacyUicb4e4154e4;

  /// No description provided for @legacyUi92dc53a1bc.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Name'**
  String get legacyUi92dc53a1bc;

  /// No description provided for @legacyUi441399c250.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Selection'**
  String get legacyUi441399c250;

  /// No description provided for @legacyUi2d6ca00998.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Type'**
  String get legacyUi2d6ca00998;

  /// No description provided for @legacyUi5c931770ef.
  ///
  /// In en, this message translates to:
  /// **'Vehicle actions'**
  String get legacyUi5c931770ef;

  /// No description provided for @legacyUi6ac26355c9.
  ///
  /// In en, this message translates to:
  /// **'Vehicle activity and system logs will appear here.'**
  String get legacyUi6ac26355c9;

  /// No description provided for @legacyUi4e4942337f.
  ///
  /// In en, this message translates to:
  /// **'Vehicle and Plan'**
  String get legacyUi4e4942337f;

  /// No description provided for @legacyUi6ec60a25f7.
  ///
  /// In en, this message translates to:
  /// **'Vehicle assigned.'**
  String get legacyUi6ec60a25f7;

  /// No description provided for @legacyUia31471cef9.
  ///
  /// In en, this message translates to:
  /// **'Vehicle assignment or vehicle updates will appear here.'**
  String get legacyUia31471cef9;

  /// No description provided for @legacyUib7975a2537.
  ///
  /// In en, this message translates to:
  /// **'Vehicle deleted.'**
  String get legacyUib7975a2537;

  /// No description provided for @legacyUiff47117f38.
  ///
  /// In en, this message translates to:
  /// **'Vehicle details'**
  String get legacyUiff47117f38;

  /// No description provided for @legacyUia1fbfba50c.
  ///
  /// In en, this message translates to:
  /// **'Vehicle details are unavailable.'**
  String get legacyUia1fbfba50c;

  /// No description provided for @legacyUi79c500fa20.
  ///
  /// In en, this message translates to:
  /// **'Vehicle event date range'**
  String get legacyUi79c500fa20;

  /// No description provided for @legacyUie981db4fa0.
  ///
  /// In en, this message translates to:
  /// **'Vehicle events will appear here.'**
  String get legacyUie981db4fa0;

  /// No description provided for @legacyUi7eefc642f4.
  ///
  /// In en, this message translates to:
  /// **'Vehicle group'**
  String get legacyUi7eefc642f4;

  /// No description provided for @legacyUi5cd0230ee5.
  ///
  /// In en, this message translates to:
  /// **'Vehicle id is missing.'**
  String get legacyUi5cd0230ee5;

  /// No description provided for @legacyUi39ea43c097.
  ///
  /// In en, this message translates to:
  /// **'Vehicle identification number'**
  String get legacyUi39ea43c097;

  /// No description provided for @legacyUida83429197.
  ///
  /// In en, this message translates to:
  /// **'Vehicle name'**
  String get legacyUida83429197;

  /// No description provided for @legacyUi750a5503ac.
  ///
  /// In en, this message translates to:
  /// **'Vehicle position'**
  String get legacyUi750a5503ac;

  /// No description provided for @legacyUi40a1e7dd80.
  ///
  /// In en, this message translates to:
  /// **'Vehicle record is not available.'**
  String get legacyUi40a1e7dd80;

  /// No description provided for @legacyUi686853d97d.
  ///
  /// In en, this message translates to:
  /// **'Vehicle renew payment submitted'**
  String get legacyUi686853d97d;

  /// No description provided for @legacyUie1071916e2.
  ///
  /// In en, this message translates to:
  /// **'Vehicle renewal recorded.'**
  String get legacyUie1071916e2;

  /// No description provided for @legacyUibf31403ac2.
  ///
  /// In en, this message translates to:
  /// **'Vehicle scope'**
  String get legacyUibf31403ac2;

  /// No description provided for @legacyUi3c760a5151.
  ///
  /// In en, this message translates to:
  /// **'Vehicle service'**
  String get legacyUi3c760a5151;

  /// No description provided for @legacyUi9aafada9ec.
  ///
  /// In en, this message translates to:
  /// **'Vehicle service revision unavailable. Reload before editing.'**
  String get legacyUi9aafada9ec;

  /// No description provided for @legacyUia0d9ad9324.
  ///
  /// In en, this message translates to:
  /// **'Vehicle service updated'**
  String get legacyUia0d9ad9324;

  /// No description provided for @legacyUi97d4120359.
  ///
  /// In en, this message translates to:
  /// **'Vehicle services'**
  String get legacyUi97d4120359;

  /// No description provided for @legacyUif9709ba7c4.
  ///
  /// In en, this message translates to:
  /// **'Vehicle telemetry updates progress automatically. Manual completion is available for the current stop only.'**
  String get legacyUif9709ba7c4;

  /// No description provided for @legacyUi9644381920.
  ///
  /// In en, this message translates to:
  /// **'Vehicle type'**
  String get legacyUi9644381920;

  /// No description provided for @legacyUi8b26242493.
  ///
  /// In en, this message translates to:
  /// **'Vehicle type filter'**
  String get legacyUi8b26242493;

  /// No description provided for @legacyUi2a37343d0a.
  ///
  /// In en, this message translates to:
  /// **'Vehicle unassigned.'**
  String get legacyUi2a37343d0a;

  /// No description provided for @legacyUif28657d034.
  ///
  /// In en, this message translates to:
  /// **'Vehicle unavailable'**
  String get legacyUif28657d034;

  /// No description provided for @legacyUi917981e400.
  ///
  /// In en, this message translates to:
  /// **'Vehicle updated.'**
  String get legacyUi917981e400;

  /// No description provided for @legacyUi02236966b5.
  ///
  /// In en, this message translates to:
  /// **'Vehicles Affected'**
  String get legacyUi02236966b5;

  /// No description provided for @legacyUi776abb6631.
  ///
  /// In en, this message translates to:
  /// **'Vehicles assigned.'**
  String get legacyUi776abb6631;

  /// No description provided for @legacyUi433457e28d.
  ///
  /// In en, this message translates to:
  /// **'Vehicles could not be loaded.'**
  String get legacyUi433457e28d;

  /// No description provided for @legacyUi03128bed90.
  ///
  /// In en, this message translates to:
  /// **'Verification'**
  String get legacyUi03128bed90;

  /// No description provided for @legacyUiaed3b8c6a7.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get legacyUiaed3b8c6a7;

  /// No description provided for @legacyUidda6ac27b9.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get legacyUidda6ac27b9;

  /// No description provided for @legacyUi69bd4ef9fb.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get legacyUi69bd4ef9fb;

  /// No description provided for @legacyUi5b9306d29c.
  ///
  /// In en, this message translates to:
  /// **'View Payments'**
  String get legacyUi5b9306d29c;

  /// No description provided for @legacyUie3c9374cd6.
  ///
  /// In en, this message translates to:
  /// **'View all trips'**
  String get legacyUie3c9374cd6;

  /// No description provided for @legacyUib1614cb4e6.
  ///
  /// In en, this message translates to:
  /// **'View/Download'**
  String get legacyUib1614cb4e6;

  /// No description provided for @legacyUi1b6cc58781.
  ///
  /// In en, this message translates to:
  /// **'Violations by Severity'**
  String get legacyUi1b6cc58781;

  /// No description provided for @legacyUi1fe59390ac.
  ///
  /// In en, this message translates to:
  /// **'Visible'**
  String get legacyUi1fe59390ac;

  /// No description provided for @legacyUi4fc5a421da.
  ///
  /// In en, this message translates to:
  /// **'Visible To Admin'**
  String get legacyUi4fc5a421da;

  /// No description provided for @legacyUi1448afee1d.
  ///
  /// In en, this message translates to:
  /// **'Visible To Driver'**
  String get legacyUi1448afee1d;

  /// No description provided for @legacyUib60862f485.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get legacyUib60862f485;

  /// No description provided for @legacyUic4fe2a7498.
  ///
  /// In en, this message translates to:
  /// **'Web Push'**
  String get legacyUic4fe2a7498;

  /// No description provided for @legacyUi2e8a57cc5c.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get legacyUi2e8a57cc5c;

  /// No description provided for @legacyUib32233ad82.
  ///
  /// In en, this message translates to:
  /// **'Website URL'**
  String get legacyUib32233ad82;

  /// No description provided for @legacyUica976c5dc6.
  ///
  /// In en, this message translates to:
  /// **'Weekly Comparison'**
  String get legacyUica976c5dc6;

  /// No description provided for @legacyUidd322f2dc7.
  ///
  /// In en, this message translates to:
  /// **'West'**
  String get legacyUidd322f2dc7;

  /// No description provided for @legacyUib336fc5587.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get legacyUib336fc5587;

  /// No description provided for @legacyUi16ec75e229.
  ///
  /// In en, this message translates to:
  /// **'Who recipients see in the inbox.'**
  String get legacyUi16ec75e229;

  /// No description provided for @legacyUi682d44be54.
  ///
  /// In en, this message translates to:
  /// **'With device'**
  String get legacyUi682d44be54;

  /// No description provided for @legacyUi0a58e1d0a2.
  ///
  /// In en, this message translates to:
  /// **'Write a reply'**
  String get legacyUi0a58e1d0a2;

  /// No description provided for @legacyUi126cd2cd36.
  ///
  /// In en, this message translates to:
  /// **'Write a reply...'**
  String get legacyUi126cd2cd36;

  /// No description provided for @legacyUib58c0082b4.
  ///
  /// In en, this message translates to:
  /// **'You are all caught up.'**
  String get legacyUib58c0082b4;

  /// No description provided for @legacyUi558865a16f.
  ///
  /// In en, this message translates to:
  /// **'YouTube'**
  String get legacyUi558865a16f;

  /// No description provided for @legacyUid3639ca4df.
  ///
  /// In en, this message translates to:
  /// **'Your account does not have permission to view this section.'**
  String get legacyUid3639ca4df;

  /// No description provided for @legacyUice100fe123.
  ///
  /// In en, this message translates to:
  /// **'Your changes will be lost. This action cannot be undone.'**
  String get legacyUice100fe123;

  /// No description provided for @legacyUi9b3cbed5c4.
  ///
  /// In en, this message translates to:
  /// **'Zoom'**
  String get legacyUi9b3cbed5c4;

  /// No description provided for @legacyUi4fc05f2763.
  ///
  /// In en, this message translates to:
  /// **'Zoom in'**
  String get legacyUi4fc05f2763;

  /// No description provided for @legacyUia4ae4b24a1.
  ///
  /// In en, this message translates to:
  /// **'Zoom out'**
  String get legacyUia4ae4b24a1;

  /// No description provided for @legacyUib6958e3c52.
  ///
  /// In en, this message translates to:
  /// **'apikey or username'**
  String get legacyUib6958e3c52;

  /// No description provided for @legacyUib5f203a910.
  ///
  /// In en, this message translates to:
  /// **'cmdId'**
  String get legacyUib5f203a910;

  /// No description provided for @legacyUif05135d639.
  ///
  /// In en, this message translates to:
  /// **'insurance, permit'**
  String get legacyUif05135d639;

  /// No description provided for @legacyUid127ec8ef2.
  ///
  /// In en, this message translates to:
  /// **'jane@company.com'**
  String get legacyUid127ec8ef2;

  /// No description provided for @legacyUi216fb6179a.
  ///
  /// In en, this message translates to:
  /// **'km/h, C, V'**
  String get legacyUi216fb6179a;

  /// No description provided for @legacyUi7252f9e8d5.
  ///
  /// In en, this message translates to:
  /// **'last 7 days'**
  String get legacyUi7252f9e8d5;

  /// No description provided for @legacyUibbdead93fb.
  ///
  /// In en, this message translates to:
  /// **'license, identity, permit'**
  String get legacyUibbdead93fb;

  /// No description provided for @legacyUid7cb0327fd.
  ///
  /// In en, this message translates to:
  /// **'license, insurance'**
  String get legacyUid7cb0327fd;

  /// No description provided for @legacyUica62660225.
  ///
  /// In en, this message translates to:
  /// **'noreply@example.com'**
  String get legacyUica62660225;

  /// No description provided for @legacyUid043e53c7d.
  ///
  /// In en, this message translates to:
  /// **'queueId'**
  String get legacyUid043e53c7d;

  /// No description provided for @legacyUi11c8ce1244.
  ///
  /// In en, this message translates to:
  /// **'recipient@example.com'**
  String get legacyUi11c8ce1244;

  /// No description provided for @legacyUi4b329f8934.
  ///
  /// In en, this message translates to:
  /// **'speed, fuel'**
  String get legacyUi4b329f8934;

  /// No description provided for @legacyUi65e012062c.
  ///
  /// In en, this message translates to:
  /// **'support@example.com'**
  String get legacyUi65e012062c;

  /// No description provided for @legacyUi0bd41b4761.
  ///
  /// In en, this message translates to:
  /// **'this month'**
  String get legacyUi0bd41b4761;

  /// No description provided for @legacyUie92d4d638a.
  ///
  /// In en, this message translates to:
  /// **'wk / mo'**
  String get legacyUie92d4d638a;

  /// No description provided for @legacyUia126722ec0.
  ///
  /// In en, this message translates to:
  /// **'Needs attention'**
  String get legacyUia126722ec0;

  /// No description provided for @legacyUi51eab2420d.
  ///
  /// In en, this message translates to:
  /// **'Dispatcher actions'**
  String get legacyUi51eab2420d;

  /// No description provided for @legacyUi8bdea32153.
  ///
  /// In en, this message translates to:
  /// **'No activity yet.'**
  String get legacyUi8bdea32153;

  /// No description provided for @legacyUi05e3a866c3.
  ///
  /// In en, this message translates to:
  /// **'The schedule was saved, but some trips could not be generated.'**
  String get legacyUi05e3a866c3;

  /// No description provided for @legacyUi2924d70976.
  ///
  /// In en, this message translates to:
  /// **'Date Only'**
  String get legacyUi2924d70976;

  /// No description provided for @legacyUi63f39eeeb7.
  ///
  /// In en, this message translates to:
  /// **'Fixed Time'**
  String get legacyUi63f39eeeb7;

  /// No description provided for @legacyUi6930391c64.
  ///
  /// In en, this message translates to:
  /// **'Time Slot'**
  String get legacyUi6930391c64;

  /// No description provided for @legacyUi601d153162.
  ///
  /// In en, this message translates to:
  /// **'Multi Day'**
  String get legacyUi601d153162;

  /// No description provided for @legacyUif61eadaf15.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get legacyUif61eadaf15;

  /// No description provided for @legacyUia1bf92eff4.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get legacyUia1bf92eff4;

  /// No description provided for @legacyUic7dfb6f1d9.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get legacyUic7dfb6f1d9;

  /// No description provided for @legacyUi90303d8df2.
  ///
  /// In en, this message translates to:
  /// **'Ended'**
  String get legacyUi90303d8df2;

  /// No description provided for @legacyUi59f1111618.
  ///
  /// In en, this message translates to:
  /// **'On Trip'**
  String get legacyUi59f1111618;

  /// No description provided for @legacyUi2b613fb829.
  ///
  /// In en, this message translates to:
  /// **'No Assignment'**
  String get legacyUi2b613fb829;

  /// No description provided for @legacyUib564001a58.
  ///
  /// In en, this message translates to:
  /// **'Missed'**
  String get legacyUib564001a58;

  /// No description provided for @legacyUi736d1eee8e.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Inactive'**
  String get legacyUi736d1eee8e;

  /// No description provided for @legacyUif4330844fd.
  ///
  /// In en, this message translates to:
  /// **'Vehicle License Blocked'**
  String get legacyUif4330844fd;

  /// No description provided for @legacyUiabf81c35d4.
  ///
  /// In en, this message translates to:
  /// **'Driver Required'**
  String get legacyUiabf81c35d4;

  /// No description provided for @legacyUi2c9c1f7914.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get legacyUi2c9c1f7914;

  /// No description provided for @legacyUi8e9f1d6e54.
  ///
  /// In en, this message translates to:
  /// **'Not Started'**
  String get legacyUi8e9f1d6e54;

  /// No description provided for @legacyUi4310ed540c.
  ///
  /// In en, this message translates to:
  /// **'Late'**
  String get legacyUi4310ed540c;

  /// No description provided for @legacyUiaccac60339.
  ///
  /// In en, this message translates to:
  /// **'Driver Exception'**
  String get legacyUiaccac60339;

  /// No description provided for @legacyUi6b535fa681.
  ///
  /// In en, this message translates to:
  /// **'No Telemetry'**
  String get legacyUi6b535fa681;

  /// No description provided for @legacyUi38a9e21ed9.
  ///
  /// In en, this message translates to:
  /// **'Route Deviation'**
  String get legacyUi38a9e21ed9;

  /// No description provided for @legacyUi1f5a1abf2f.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get legacyUi1f5a1abf2f;

  /// No description provided for @legacyUi5a436b7939.
  ///
  /// In en, this message translates to:
  /// **'Add Remark'**
  String get legacyUi5a436b7939;

  /// No description provided for @legacyUi65c821a596.
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get legacyUi65c821a596;

  /// No description provided for @legacyUi189cc40c22.
  ///
  /// In en, this message translates to:
  /// **'Stale'**
  String get legacyUi189cc40c22;

  /// No description provided for @legacyUi41c8e43d9e.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Gps'**
  String get legacyUi41c8e43d9e;

  /// No description provided for @legacyUic1220e845b.
  ///
  /// In en, this message translates to:
  /// **'Fleet Manager'**
  String get legacyUic1220e845b;

  /// No description provided for @legacyUi601f5ff70b.
  ///
  /// In en, this message translates to:
  /// **'System Automation'**
  String get legacyUi601f5ff70b;

  /// No description provided for @legacyUi8b57ec8c92.
  ///
  /// In en, this message translates to:
  /// **'Assignment Created'**
  String get legacyUi8b57ec8c92;

  /// No description provided for @legacyUi368e5b125f.
  ///
  /// In en, this message translates to:
  /// **'Assignment Acknowledged'**
  String get legacyUi368e5b125f;

  /// No description provided for @legacyUid00c8926f5.
  ///
  /// In en, this message translates to:
  /// **'Trip Auto Started'**
  String get legacyUid00c8926f5;

  /// No description provided for @legacyUic4b75c3924.
  ///
  /// In en, this message translates to:
  /// **'Trip Auto Completed'**
  String get legacyUic4b75c3924;

  /// No description provided for @legacyUif98c835c4f.
  ///
  /// In en, this message translates to:
  /// **'Trip Driver Completed'**
  String get legacyUif98c835c4f;

  /// No description provided for @legacyUi4bb573b356.
  ///
  /// In en, this message translates to:
  /// **'Stop Auto Arrived'**
  String get legacyUi4bb573b356;

  /// No description provided for @legacyUi52cd528ad4.
  ///
  /// In en, this message translates to:
  /// **'Stop Auto Completed'**
  String get legacyUi52cd528ad4;

  /// No description provided for @legacyUicf338ebe5c.
  ///
  /// In en, this message translates to:
  /// **'Stop Driver Completed'**
  String get legacyUicf338ebe5c;

  /// No description provided for @legacyUi7ef2940c95.
  ///
  /// In en, this message translates to:
  /// **'Route Deviation Started'**
  String get legacyUi7ef2940c95;

  /// No description provided for @legacyUi55d93aed45.
  ///
  /// In en, this message translates to:
  /// **'Route Deviation Cleared'**
  String get legacyUi55d93aed45;

  /// No description provided for @legacyUi654c568718.
  ///
  /// In en, this message translates to:
  /// **'No Telemetry Started'**
  String get legacyUi654c568718;

  /// No description provided for @legacyUi66676d64b0.
  ///
  /// In en, this message translates to:
  /// **'No Telemetry Cleared'**
  String get legacyUi66676d64b0;

  /// No description provided for @legacyUi2a398797b5.
  ///
  /// In en, this message translates to:
  /// **'Overspeed Started'**
  String get legacyUi2a398797b5;

  /// No description provided for @legacyUif7d315eb62.
  ///
  /// In en, this message translates to:
  /// **'Overspeed Cleared'**
  String get legacyUif7d315eb62;

  /// No description provided for @legacyUia22d66c857.
  ///
  /// In en, this message translates to:
  /// **'Arrived'**
  String get legacyUia22d66c857;

  /// No description provided for @legacyUi5a000ad7bd.
  ///
  /// In en, this message translates to:
  /// **'Skipped'**
  String get legacyUi5a000ad7bd;

  /// No description provided for @legacyUi4028c0c8b4.
  ///
  /// In en, this message translates to:
  /// **'Not Available'**
  String get legacyUi4028c0c8b4;

  /// No description provided for @legacyUi5f174de1cc.
  ///
  /// In en, this message translates to:
  /// **'Proof'**
  String get legacyUi5f174de1cc;

  /// No description provided for @legacyUi4e91ee6122.
  ///
  /// In en, this message translates to:
  /// **'Account timezone'**
  String get legacyUi4e91ee6122;

  /// No description provided for @legacyUi4dda6a4505.
  ///
  /// In en, this message translates to:
  /// **'Total Trips'**
  String get legacyUi4dda6a4505;

  /// No description provided for @legacyUi523baab918.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get legacyUi523baab918;

  /// No description provided for @legacyUicc6e7b6a29.
  ///
  /// In en, this message translates to:
  /// **'Delayed'**
  String get legacyUicc6e7b6a29;

  /// No description provided for @legacyUie9fab1cf3a.
  ///
  /// In en, this message translates to:
  /// **'On Time Completed Trips'**
  String get legacyUie9fab1cf3a;

  /// No description provided for @legacyUibbb47a7157.
  ///
  /// In en, this message translates to:
  /// **'On Time Percent'**
  String get legacyUibbb47a7157;

  /// No description provided for @legacyUi944b223791.
  ///
  /// In en, this message translates to:
  /// **'Distance Km'**
  String get legacyUi944b223791;

  /// No description provided for @legacyUi7c9352eed6.
  ///
  /// In en, this message translates to:
  /// **'A short message will be sent using the current SMTP config.'**
  String get legacyUi7c9352eed6;

  /// No description provided for @legacyUid173234df0.
  ///
  /// In en, this message translates to:
  /// **'ACC means wire/ACC. MOTION means motion fallback.'**
  String get legacyUid173234df0;

  /// No description provided for @legacyUi598ed2889b.
  ///
  /// In en, this message translates to:
  /// **'Access permissions'**
  String get legacyUi598ed2889b;

  /// No description provided for @legacyUi9a6d95b0c5.
  ///
  /// In en, this message translates to:
  /// **'Active account'**
  String get legacyUi9a6d95b0c5;

  /// No description provided for @legacyUi8d00c06a55.
  ///
  /// In en, this message translates to:
  /// **'Activity, vehicle event, and telemetry logs'**
  String get legacyUi8d00c06a55;

  /// No description provided for @legacyUi61cc55aa04.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get legacyUi61cc55aa04;

  /// No description provided for @legacyUiee01d7c402.
  ///
  /// In en, this message translates to:
  /// **'Add a new administrator'**
  String get legacyUiee01d7c402;

  /// No description provided for @legacyUib9b1e23f27.
  ///
  /// In en, this message translates to:
  /// **'Add a new user'**
  String get legacyUib9b1e23f27;

  /// No description provided for @legacyUif2f8674f8a.
  ///
  /// In en, this message translates to:
  /// **'Add a new vehicle'**
  String get legacyUif2f8674f8a;

  /// No description provided for @legacyUi23a75918ab.
  ///
  /// In en, this message translates to:
  /// **'Adoption & Growth'**
  String get legacyUi23a75918ab;

  /// No description provided for @legacyUi80643ec204.
  ///
  /// In en, this message translates to:
  /// **'Advanced Cleanup'**
  String get legacyUi80643ec204;

  /// No description provided for @legacyUicf963e5241.
  ///
  /// In en, this message translates to:
  /// **'Advanced Filters'**
  String get legacyUicf963e5241;

  /// No description provided for @legacyUi3aea7b29d9.
  ///
  /// In en, this message translates to:
  /// **'Advanced reporting features are not available in the public demo. Sign in with an OpenVTS account to run, page, visualise, and export fleet reports.'**
  String get legacyUi3aea7b29d9;

  /// No description provided for @legacyUi056677c12f.
  ///
  /// In en, this message translates to:
  /// **'Alerts by Severity'**
  String get legacyUi056677c12f;

  /// No description provided for @legacyUif89ae580e8.
  ///
  /// In en, this message translates to:
  /// **'All actors'**
  String get legacyUif89ae580e8;

  /// No description provided for @legacyUiaeae2d71be.
  ///
  /// In en, this message translates to:
  /// **'All alerts'**
  String get legacyUiaeae2d71be;

  /// No description provided for @legacyUic0e8e58c1a.
  ///
  /// In en, this message translates to:
  /// **'All sources'**
  String get legacyUic0e8e58c1a;

  /// No description provided for @legacyUic1cbbe0c5d.
  ///
  /// In en, this message translates to:
  /// **'Allowed deviation'**
  String get legacyUic1cbbe0c5d;

  /// No description provided for @legacyUi826499f6b1.
  ///
  /// In en, this message translates to:
  /// **'Annual coverage and customer service are separate.'**
  String get legacyUi826499f6b1;

  /// No description provided for @legacyUi40e69b5db3.
  ///
  /// In en, this message translates to:
  /// **'Assigned Vehicle'**
  String get legacyUi40e69b5db3;

  /// No description provided for @legacyUi6771ade6e8.
  ///
  /// In en, this message translates to:
  /// **'Attachments'**
  String get legacyUi6771ade6e8;

  /// No description provided for @legacyUi52b258c824.
  ///
  /// In en, this message translates to:
  /// **'Briefly describe the issue and attach files if needed.'**
  String get legacyUi52b258c824;

  /// No description provided for @legacyUi2f3b5c55bc.
  ///
  /// In en, this message translates to:
  /// **'Browse'**
  String get legacyUi2f3b5c55bc;

  /// No description provided for @legacyUi00189ab9b2.
  ///
  /// In en, this message translates to:
  /// **'CSV template'**
  String get legacyUi00189ab9b2;

  /// No description provided for @legacyUi19db82215d.
  ///
  /// In en, this message translates to:
  /// **'Change your password to secure account access.'**
  String get legacyUi19db82215d;

  /// No description provided for @legacyUi3f657f29e6.
  ///
  /// In en, this message translates to:
  /// **'Choose a new password'**
  String get legacyUi3f657f29e6;

  /// No description provided for @legacyUicbd1538094.
  ///
  /// In en, this message translates to:
  /// **'Choose how vehicle alerts, overspeed events, and geofence events reach you.'**
  String get legacyUicbd1538094;

  /// No description provided for @legacyUic7cd13c042.
  ///
  /// In en, this message translates to:
  /// **'Choose the pages and reports available to this user. Changes also limit the access they can grant to subusers.'**
  String get legacyUic7cd13c042;

  /// No description provided for @legacyUibe10f5c042.
  ///
  /// In en, this message translates to:
  /// **'Choose what this member can view, edit and delete. Own applies to their records; Global applies across your account.'**
  String get legacyUibe10f5c042;

  /// No description provided for @legacyUi7834f4a6f4.
  ///
  /// In en, this message translates to:
  /// **'Choose where alerts are delivered for this notification group.'**
  String get legacyUi7834f4a6f4;

  /// No description provided for @legacyUic23350ccde.
  ///
  /// In en, this message translates to:
  /// **'Command details'**
  String get legacyUic23350ccde;

  /// No description provided for @legacyUib2c253ba1c.
  ///
  /// In en, this message translates to:
  /// **'Complete the sections below. Required fields are marked with an asterisk (*).'**
  String get legacyUib2c253ba1c;

  /// No description provided for @legacyUia2b4ac96b2.
  ///
  /// In en, this message translates to:
  /// **'Completed trips by service date. Upcoming assignments are available in Trips.'**
  String get legacyUia2b4ac96b2;

  /// No description provided for @legacyUib3feb31fcb.
  ///
  /// In en, this message translates to:
  /// **'Configure your report'**
  String get legacyUib3feb31fcb;

  /// No description provided for @legacyUi878b163022.
  ///
  /// In en, this message translates to:
  /// **'Confirm cleanup'**
  String get legacyUi878b163022;

  /// No description provided for @legacyUi9041d3c666.
  ///
  /// In en, this message translates to:
  /// **'Contact your administrator to assign vehicles.'**
  String get legacyUi9041d3c666;

  /// No description provided for @legacyUi8e2fc0ffdc.
  ///
  /// In en, this message translates to:
  /// **'Create a compact login profile with controlled access.'**
  String get legacyUi8e2fc0ffdc;

  /// No description provided for @legacyUi93c1ed632d.
  ///
  /// In en, this message translates to:
  /// **'Create and manage geofences, points of interest, and routes.'**
  String get legacyUi93c1ed632d;

  /// No description provided for @legacyUie4781f0bde.
  ///
  /// In en, this message translates to:
  /// **'Create and manage operational route corridors.'**
  String get legacyUie4781f0bde;

  /// No description provided for @legacyUi6571e94148.
  ///
  /// In en, this message translates to:
  /// **'Create secure public links for live vehicle tracking.'**
  String get legacyUi6571e94148;

  /// No description provided for @legacyUie09271eeb7.
  ///
  /// In en, this message translates to:
  /// **'Created: '**
  String get legacyUie09271eeb7;

  /// No description provided for @legacyUidb0d2488de.
  ///
  /// In en, this message translates to:
  /// **'Current assignment'**
  String get legacyUidb0d2488de;

  /// No description provided for @legacyUif8ece934c7.
  ///
  /// In en, this message translates to:
  /// **'Daily Distance Totals'**
  String get legacyUif8ece934c7;

  /// No description provided for @legacyUicb47dca7e3.
  ///
  /// In en, this message translates to:
  /// **'Daily totals for selected range'**
  String get legacyUicb47dca7e3;

  /// No description provided for @legacyUi71d6e89bcc.
  ///
  /// In en, this message translates to:
  /// **'Day vs Night Driving'**
  String get legacyUi71d6e89bcc;

  /// No description provided for @legacyUi2f3c38363d.
  ///
  /// In en, this message translates to:
  /// **'Delete POI?'**
  String get legacyUi2f3c38363d;

  /// No description provided for @legacyUi30c6c6352a.
  ///
  /// In en, this message translates to:
  /// **'Delete geofence?'**
  String get legacyUi30c6c6352a;

  /// No description provided for @legacyUic6f82fca90.
  ///
  /// In en, this message translates to:
  /// **'Delete route?'**
  String get legacyUic6f82fca90;

  /// No description provided for @legacyUie543c4fd0c.
  ///
  /// In en, this message translates to:
  /// **'Demo workspace • Read-only'**
  String get legacyUie543c4fd0c;

  /// No description provided for @legacyUi50dd7fb720.
  ///
  /// In en, this message translates to:
  /// **'Device Config'**
  String get legacyUi50dd7fb720;

  /// No description provided for @legacyUi0cf40756a6.
  ///
  /// In en, this message translates to:
  /// **'Draw and manage operational boundaries.'**
  String get legacyUi0cf40756a6;

  /// No description provided for @legacyUi243f6cfeec.
  ///
  /// In en, this message translates to:
  /// **'Driven KM'**
  String get legacyUi243f6cfeec;

  /// No description provided for @legacyUie30d463652.
  ///
  /// In en, this message translates to:
  /// **'Driver details are unavailable.'**
  String get legacyUie30d463652;

  /// No description provided for @legacyUi251b80c58c.
  ///
  /// In en, this message translates to:
  /// **'Email Subscription'**
  String get legacyUi251b80c58c;

  /// No description provided for @legacyUibe482973b9.
  ///
  /// In en, this message translates to:
  /// **'Enable SMTP'**
  String get legacyUibe482973b9;

  /// No description provided for @legacyUi21685f000f.
  ///
  /// In en, this message translates to:
  /// **'End this session on this device.'**
  String get legacyUi21685f000f;

  /// No description provided for @legacyUide4f0c9387.
  ///
  /// In en, this message translates to:
  /// **'Event Filters'**
  String get legacyUide4f0c9387;

  /// No description provided for @legacyUi6e74f5ccbd.
  ///
  /// In en, this message translates to:
  /// **'Events by Type'**
  String get legacyUi6e74f5ccbd;

  /// No description provided for @legacyUi74bbe75120.
  ///
  /// In en, this message translates to:
  /// **'Expiring soon'**
  String get legacyUi74bbe75120;

  /// No description provided for @legacyUi8d00705083.
  ///
  /// In en, this message translates to:
  /// **'Expiry Date'**
  String get legacyUi8d00705083;

  /// No description provided for @legacyUi0da7bfa1a0.
  ///
  /// In en, this message translates to:
  /// **'Expiry date (optional)'**
  String get legacyUi0da7bfa1a0;

  /// No description provided for @legacyUi86baf678e1.
  ///
  /// In en, this message translates to:
  /// **'Failed rows'**
  String get legacyUi86baf678e1;

  /// No description provided for @legacyUi2b1d93a2c6.
  ///
  /// In en, this message translates to:
  /// **'Filter Activity Logs'**
  String get legacyUi2b1d93a2c6;

  /// No description provided for @legacyUi9a4184cef3.
  ///
  /// In en, this message translates to:
  /// **'Filter by administrator and date range.'**
  String get legacyUi9a4184cef3;

  /// No description provided for @legacyUi96e578211a.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get legacyUi96e578211a;

  /// No description provided for @legacyUi5360d40661.
  ///
  /// In en, this message translates to:
  /// **'Fleet OS'**
  String get legacyUi5360d40661;

  /// No description provided for @legacyUi03d25e01e5.
  ///
  /// In en, this message translates to:
  /// **'Generate from search'**
  String get legacyUi03d25e01e5;

  /// No description provided for @legacyUi4d8abbdc5d.
  ///
  /// In en, this message translates to:
  /// **'Generate report'**
  String get legacyUi4d8abbdc5d;

  /// No description provided for @legacyUie16305f8b0.
  ///
  /// In en, this message translates to:
  /// **'Generation failed'**
  String get legacyUie16305f8b0;

  /// No description provided for @legacyUid81feb6ae1.
  ///
  /// In en, this message translates to:
  /// **'Get History'**
  String get legacyUid81feb6ae1;

  /// No description provided for @legacyUi6fa6308619.
  ///
  /// In en, this message translates to:
  /// **'Get notified when assigned vehicles deviate.'**
  String get legacyUi6fa6308619;

  /// No description provided for @legacyUi4b6d6a3015.
  ///
  /// In en, this message translates to:
  /// **'Important'**
  String get legacyUi4b6d6a3015;

  /// No description provided for @legacyUic5288872fd.
  ///
  /// In en, this message translates to:
  /// **'Inactive routes stay archived but visible.'**
  String get legacyUic5288872fd;

  /// No description provided for @legacyUi44caf74675.
  ///
  /// In en, this message translates to:
  /// **'Inbox'**
  String get legacyUi44caf74675;

  /// No description provided for @legacyUi3f33f2e865.
  ///
  /// In en, this message translates to:
  /// **'Include the full path, e.g. http://192.168.1.10:3000/api'**
  String get legacyUi3f33f2e865;

  /// No description provided for @legacyUi1919090902.
  ///
  /// In en, this message translates to:
  /// **'Last login: '**
  String get legacyUi1919090902;

  /// No description provided for @legacyUi1c747b4f98.
  ///
  /// In en, this message translates to:
  /// **'Latest Server Action'**
  String get legacyUi1c747b4f98;

  /// No description provided for @legacyUi9e1bba7129.
  ///
  /// In en, this message translates to:
  /// **'Latest period'**
  String get legacyUi9e1bba7129;

  /// No description provided for @legacyUi72da77c7b7.
  ///
  /// In en, this message translates to:
  /// **'Live coordinates are unavailable for this vehicle.'**
  String get legacyUi72da77c7b7;

  /// No description provided for @legacyUi3e893cdfd5.
  ///
  /// In en, this message translates to:
  /// **'Loading device types and providers...'**
  String get legacyUi3e893cdfd5;

  /// No description provided for @legacyUi93fe7c05af.
  ///
  /// In en, this message translates to:
  /// **'Loading document types…'**
  String get legacyUi93fe7c05af;

  /// No description provided for @legacyUi75e940ee30.
  ///
  /// In en, this message translates to:
  /// **'Loading history'**
  String get legacyUi75e940ee30;

  /// No description provided for @legacyUi59c3981787.
  ///
  /// In en, this message translates to:
  /// **'Loading history...'**
  String get legacyUi59c3981787;

  /// No description provided for @legacyUibbe4cbd55c.
  ///
  /// In en, this message translates to:
  /// **'Loading profile'**
  String get legacyUibbe4cbd55c;

  /// No description provided for @legacyUica88017dfa.
  ///
  /// In en, this message translates to:
  /// **'Loading subscription status...'**
  String get legacyUica88017dfa;

  /// No description provided for @legacyUid1ccf4c3e4.
  ///
  /// In en, this message translates to:
  /// **'Loading vehicles…'**
  String get legacyUid1ccf4c3e4;

  /// No description provided for @legacyUif4e14815b1.
  ///
  /// In en, this message translates to:
  /// **'Login as admin'**
  String get legacyUif4e14815b1;

  /// No description provided for @legacyUi353bd1ef01.
  ///
  /// In en, this message translates to:
  /// **'Logs by Category'**
  String get legacyUi353bd1ef01;

  /// No description provided for @legacyUib2af2f11de.
  ///
  /// In en, this message translates to:
  /// **'Logs by Level'**
  String get legacyUib2af2f11de;

  /// No description provided for @legacyUi8c97e4f07d.
  ///
  /// In en, this message translates to:
  /// **'Manage drivers and sub users linked to your fleet.'**
  String get legacyUi8c97e4f07d;

  /// No description provided for @legacyUi41948edc3a.
  ///
  /// In en, this message translates to:
  /// **'Manage drivers, assignments, documents, and activity.'**
  String get legacyUi41948edc3a;

  /// No description provided for @legacyUi93b23afae0.
  ///
  /// In en, this message translates to:
  /// **'Manage important places and operational points.'**
  String get legacyUi93b23afae0;

  /// No description provided for @legacyUi68669149c0.
  ///
  /// In en, this message translates to:
  /// **'Manage sub users and vehicle access.'**
  String get legacyUi68669149c0;

  /// No description provided for @legacyUi9fcd87c64d.
  ///
  /// In en, this message translates to:
  /// **'Manage subscription pricing plans.'**
  String get legacyUi9fcd87c64d;

  /// No description provided for @legacyUi274ef56d8e.
  ///
  /// In en, this message translates to:
  /// **'Manage transactions and renew vehicle subscriptions'**
  String get legacyUi274ef56d8e;

  /// No description provided for @legacyUiff92dafaaf.
  ///
  /// In en, this message translates to:
  /// **'Manage users, login access, contacts, and assigned vehicles.'**
  String get legacyUiff92dafaaf;

  /// No description provided for @legacyUib42578bf99.
  ///
  /// In en, this message translates to:
  /// **'Manual payments update transactions and analytics after successful submission.'**
  String get legacyUib42578bf99;

  /// No description provided for @legacyUi421878a774.
  ///
  /// In en, this message translates to:
  /// **'Map data © Google'**
  String get legacyUi421878a774;

  /// No description provided for @legacyUi2cf55e0f5b.
  ///
  /// In en, this message translates to:
  /// **'Map details'**
  String get legacyUi2cf55e0f5b;

  /// No description provided for @legacyUi9a3aa11de5.
  ///
  /// In en, this message translates to:
  /// **'Map type'**
  String get legacyUi9a3aa11de5;

  /// No description provided for @legacyUi09d3670056.
  ///
  /// In en, this message translates to:
  /// **'Max 10MB. Blocked: exe, js, html, htm.'**
  String get legacyUi09d3670056;

  /// No description provided for @legacyUife0c6bc7dd.
  ///
  /// In en, this message translates to:
  /// **'Mobile Push Diagnostics'**
  String get legacyUife0c6bc7dd;

  /// No description provided for @legacyUif6f444180f.
  ///
  /// In en, this message translates to:
  /// **'Monitor uptime, dependencies, and safe service actions'**
  String get legacyUif6f444180f;

  /// No description provided for @legacyUi1a63cbf994.
  ///
  /// In en, this message translates to:
  /// **'New Link'**
  String get legacyUi1a63cbf994;

  /// No description provided for @legacyUia40ad15529.
  ///
  /// In en, this message translates to:
  /// **'New support ticket'**
  String get legacyUia40ad15529;

  /// No description provided for @legacyUi9f2d2d7331.
  ///
  /// In en, this message translates to:
  /// **'No USER document types configured.'**
  String get legacyUi9f2d2d7331;

  /// No description provided for @legacyUi9ec5ec0752.
  ///
  /// In en, this message translates to:
  /// **'No active geofences — all geofences included.'**
  String get legacyUi9ec5ec0752;

  /// No description provided for @legacyUi0a181de203.
  ///
  /// In en, this message translates to:
  /// **'No administrators available. Pull to refresh and try again.'**
  String get legacyUi0a181de203;

  /// No description provided for @legacyUi43f32b9b9d.
  ///
  /// In en, this message translates to:
  /// **'No contact information'**
  String get legacyUi43f32b9b9d;

  /// No description provided for @legacyUie55a0728f0.
  ///
  /// In en, this message translates to:
  /// **'No geofences to preview'**
  String get legacyUie55a0728f0;

  /// No description provided for @legacyUi115fe0fac7.
  ///
  /// In en, this message translates to:
  /// **'No groups found'**
  String get legacyUi115fe0fac7;

  /// No description provided for @legacyUida501f43fd.
  ///
  /// In en, this message translates to:
  /// **'No growth data yet.'**
  String get legacyUida501f43fd;

  /// No description provided for @legacyUi454fe267a7.
  ///
  /// In en, this message translates to:
  /// **'No metadata'**
  String get legacyUi454fe267a7;

  /// No description provided for @legacyUi2540cc1f1a.
  ///
  /// In en, this message translates to:
  /// **'No pending renewal requests.'**
  String get legacyUi2540cc1f1a;

  /// No description provided for @legacyUi7cd1d44b3c.
  ///
  /// In en, this message translates to:
  /// **'No records found.'**
  String get legacyUi7cd1d44b3c;

  /// No description provided for @legacyUi658e79f9dc.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get legacyUi658e79f9dc;

  /// No description provided for @legacyUif018f94f6e.
  ///
  /// In en, this message translates to:
  /// **'No rows matched the selected report filters.'**
  String get legacyUif018f94f6e;

  /// No description provided for @legacyUibddbb17fc4.
  ///
  /// In en, this message translates to:
  /// **'No selection = all'**
  String get legacyUibddbb17fc4;

  /// No description provided for @legacyUi9aba7bbe44.
  ///
  /// In en, this message translates to:
  /// **'No selection = all geofences.'**
  String get legacyUi9aba7bbe44;

  /// No description provided for @legacyUifd548f1c32.
  ///
  /// In en, this message translates to:
  /// **'No sensors configured for this vehicle'**
  String get legacyUifd548f1c32;

  /// No description provided for @legacyUi162d1ddec0.
  ///
  /// In en, this message translates to:
  /// **'No team activity found.'**
  String get legacyUi162d1ddec0;

  /// No description provided for @legacyUi8f91f15684.
  ///
  /// In en, this message translates to:
  /// **'No valid GPS location'**
  String get legacyUi8f91f15684;

  /// No description provided for @legacyUi74ac3b3d0d.
  ///
  /// In en, this message translates to:
  /// **'No vehicle assigned.'**
  String get legacyUi74ac3b3d0d;

  /// No description provided for @legacyUia26d9edac3.
  ///
  /// In en, this message translates to:
  /// **'No vehicles assigned to your account'**
  String get legacyUia26d9edac3;

  /// No description provided for @legacyUie4b1dbf423.
  ///
  /// In en, this message translates to:
  /// **'No vehicles found.'**
  String get legacyUie4b1dbf423;

  /// No description provided for @legacyUi6eef664840.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get legacyUi6eef664840;

  /// No description provided for @legacyUif8ae6c8bbe.
  ///
  /// In en, this message translates to:
  /// **'Not acknowledged'**
  String get legacyUif8ae6c8bbe;

  /// No description provided for @legacyUia92e15bc0a.
  ///
  /// In en, this message translates to:
  /// **'Notification Preferences'**
  String get legacyUia92e15bc0a;

  /// No description provided for @legacyUic71ffe5d22.
  ///
  /// In en, this message translates to:
  /// **'Notification cooldown'**
  String get legacyUic71ffe5d22;

  /// No description provided for @legacyUicb88cbc310.
  ///
  /// In en, this message translates to:
  /// **'Notify when vehicle leaves route'**
  String get legacyUicb88cbc310;

  /// No description provided for @legacyUi0049196b0b.
  ///
  /// In en, this message translates to:
  /// **'Nudge 10 m'**
  String get legacyUi0049196b0b;

  /// No description provided for @legacyUia49d76ddc1.
  ///
  /// In en, this message translates to:
  /// **'One vehicle'**
  String get legacyUia49d76ddc1;

  /// No description provided for @legacyUi0080aaa977.
  ///
  /// In en, this message translates to:
  /// **'Open VTS'**
  String get legacyUi0080aaa977;

  /// No description provided for @legacyUi032a6dcfd8.
  ///
  /// In en, this message translates to:
  /// **'Open a support ticket to review the full conversation.'**
  String get legacyUi032a6dcfd8;

  /// No description provided for @legacyUi50f8c47b2b.
  ///
  /// In en, this message translates to:
  /// **'Open in Navigation'**
  String get legacyUi50f8c47b2b;

  /// No description provided for @legacyUi89202c7fd8.
  ///
  /// In en, this message translates to:
  /// **'Other document'**
  String get legacyUi89202c7fd8;

  /// No description provided for @legacyUi27b4bf6d1b.
  ///
  /// In en, this message translates to:
  /// **'Outgoing mail uses this server when active.'**
  String get legacyUi27b4bf6d1b;

  /// No description provided for @legacyUi619d7adc2c.
  ///
  /// In en, this message translates to:
  /// **'Payment will appear immediately in transaction list.'**
  String get legacyUi619d7adc2c;

  /// No description provided for @legacyUidc32a816e9.
  ///
  /// In en, this message translates to:
  /// **'Permanently remove historical rows older than the retention period.'**
  String get legacyUidc32a816e9;

  /// No description provided for @legacyUic2ff2762ca.
  ///
  /// In en, this message translates to:
  /// **'Please select a file.'**
  String get legacyUic2ff2762ca;

  /// No description provided for @legacyUi3585d74456.
  ///
  /// In en, this message translates to:
  /// **'Preserve current expiry'**
  String get legacyUi3585d74456;

  /// No description provided for @legacyUia9a96ec019.
  ///
  /// In en, this message translates to:
  /// **'Primary'**
  String get legacyUia9a96ec019;

  /// No description provided for @legacyUi668c4636aa.
  ///
  /// In en, this message translates to:
  /// **'Proof of delivery'**
  String get legacyUi668c4636aa;

  /// No description provided for @legacyUif702b26481.
  ///
  /// In en, this message translates to:
  /// **'Ranked by transaction count'**
  String get legacyUif702b26481;

  /// No description provided for @legacyUid03c65244f.
  ///
  /// In en, this message translates to:
  /// **'Recalculate from plan'**
  String get legacyUid03c65244f;

  /// No description provided for @legacyUi72d5617f3f.
  ///
  /// In en, this message translates to:
  /// **'Recent activity'**
  String get legacyUi72d5617f3f;

  /// No description provided for @legacyUi255e5788a2.
  ///
  /// In en, this message translates to:
  /// **'Recover your account'**
  String get legacyUi255e5788a2;

  /// No description provided for @legacyUi505dddc915.
  ///
  /// In en, this message translates to:
  /// **'Refreshing'**
  String get legacyUi505dddc915;

  /// No description provided for @legacyUi54dd5046d0.
  ///
  /// In en, this message translates to:
  /// **'Refreshing will replace your current unsaved notification edits with the latest server settings.'**
  String get legacyUi54dd5046d0;

  /// No description provided for @legacyUi199ed09ba9.
  ///
  /// In en, this message translates to:
  /// **'Report access'**
  String get legacyUi199ed09ba9;

  /// No description provided for @legacyUibd7b4f006d.
  ///
  /// In en, this message translates to:
  /// **'Report an issue'**
  String get legacyUibd7b4f006d;

  /// No description provided for @legacyUi8115c55b47.
  ///
  /// In en, this message translates to:
  /// **'Reports are restricted in demo mode'**
  String get legacyUi8115c55b47;

  /// No description provided for @legacyUi6b5890ba0b.
  ///
  /// In en, this message translates to:
  /// **'Request and confirm OTP to verify email and WhatsApp number.'**
  String get legacyUi6b5890ba0b;

  /// No description provided for @legacyUif7194e6a0d.
  ///
  /// In en, this message translates to:
  /// **'Requests'**
  String get legacyUif7194e6a0d;

  /// No description provided for @legacyUif25bbab45d.
  ///
  /// In en, this message translates to:
  /// **'Revenue Forecast'**
  String get legacyUif25bbab45d;

  /// No description provided for @legacyUiec40affa3e.
  ///
  /// In en, this message translates to:
  /// **'Revenue Trend'**
  String get legacyUiec40affa3e;

  /// No description provided for @legacyUic53c3605a0.
  ///
  /// In en, this message translates to:
  /// **'Review customer renewal requests. Confirm only payments actually received outside the app.'**
  String get legacyUic53c3605a0;

  /// No description provided for @legacyUiffbfe1e822.
  ///
  /// In en, this message translates to:
  /// **'Route stops'**
  String get legacyUiffbfe1e822;

  /// No description provided for @legacyUi50eec1a359.
  ///
  /// In en, this message translates to:
  /// **'Run Result'**
  String get legacyUi50eec1a359;

  /// No description provided for @legacyUi339225895f.
  ///
  /// In en, this message translates to:
  /// **'Running cleanup deletes data permanently. Always preview first.'**
  String get legacyUi339225895f;

  /// No description provided for @legacyUifee1dff0c6.
  ///
  /// In en, this message translates to:
  /// **'Running vs Stopped'**
  String get legacyUifee1dff0c6;

  /// No description provided for @legacyUi0fb59422f6.
  ///
  /// In en, this message translates to:
  /// **'Samples'**
  String get legacyUi0fb59422f6;

  /// No description provided for @legacyUide6472b8d3.
  ///
  /// In en, this message translates to:
  /// **'Select Date Range'**
  String get legacyUide6472b8d3;

  /// No description provided for @legacyUia35cfe395a.
  ///
  /// In en, this message translates to:
  /// **'Select Group'**
  String get legacyUia35cfe395a;

  /// No description provided for @legacyUi2564e1a2c5.
  ///
  /// In en, this message translates to:
  /// **'Select Sensor'**
  String get legacyUi2564e1a2c5;

  /// No description provided for @legacyUifea7a520f3.
  ///
  /// In en, this message translates to:
  /// **'Select Vehicle'**
  String get legacyUifea7a520f3;

  /// No description provided for @legacyUi70037936c0.
  ///
  /// In en, this message translates to:
  /// **'Select a ticket'**
  String get legacyUi70037936c0;

  /// No description provided for @legacyUieeaf903bb8.
  ///
  /// In en, this message translates to:
  /// **'Select a vehicle first'**
  String get legacyUieeaf903bb8;

  /// No description provided for @legacyUiad7a8a1750.
  ///
  /// In en, this message translates to:
  /// **'Select an administrator, describe the issue, and attach files if needed.'**
  String get legacyUiad7a8a1750;

  /// No description provided for @legacyUi9bb7b69035.
  ///
  /// In en, this message translates to:
  /// **'Select at least one state'**
  String get legacyUi9bb7b69035;

  /// No description provided for @legacyUifcfe92e583.
  ///
  /// In en, this message translates to:
  /// **'Select dashboard'**
  String get legacyUifcfe92e583;

  /// No description provided for @legacyUif9f50c1c30.
  ///
  /// In en, this message translates to:
  /// **'Select vehicles, date range, and filters, then generate to view results.'**
  String get legacyUif9f50c1c30;

  /// No description provided for @legacyUi0e40d8b0bf.
  ///
  /// In en, this message translates to:
  /// **'Selected vehicles'**
  String get legacyUi0e40d8b0bf;

  /// No description provided for @legacyUi43e146fb62.
  ///
  /// In en, this message translates to:
  /// **'Server Health Monitoring'**
  String get legacyUi43e146fb62;

  /// No description provided for @legacyUi644899c565.
  ///
  /// In en, this message translates to:
  /// **'Service expiry controls live tracking. Contact your administrator for renewal. A renewal request does not extend service until payment is confirmed.'**
  String get legacyUi644899c565;

  /// No description provided for @legacyUi5cbd584046.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get legacyUi5cbd584046;

  /// No description provided for @legacyUi758d7f7281.
  ///
  /// In en, this message translates to:
  /// **'Set Active'**
  String get legacyUi758d7f7281;

  /// No description provided for @legacyUi7c9275ee4b.
  ///
  /// In en, this message translates to:
  /// **'Set Inactive'**
  String get legacyUi7c9275ee4b;

  /// No description provided for @legacyUiddbe3ed1a3.
  ///
  /// In en, this message translates to:
  /// **'Set custom expiry'**
  String get legacyUiddbe3ed1a3;

  /// No description provided for @legacyUi7b53693e94.
  ///
  /// In en, this message translates to:
  /// **'Share Track Links'**
  String get legacyUi7b53693e94;

  /// No description provided for @legacyUidc1649a16c.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get legacyUidc1649a16c;

  /// No description provided for @legacyUi2f32be1dc7.
  ///
  /// In en, this message translates to:
  /// **'Signature'**
  String get legacyUi2f32be1dc7;

  /// No description provided for @legacyUi51070e69d1.
  ///
  /// In en, this message translates to:
  /// **'Site photo'**
  String get legacyUi51070e69d1;

  /// No description provided for @legacyUi93773568cf.
  ///
  /// In en, this message translates to:
  /// **'Speed Limit'**
  String get legacyUi93773568cf;

  /// No description provided for @legacyUicb672694bb.
  ///
  /// In en, this message translates to:
  /// **'State Filter'**
  String get legacyUicb672694bb;

  /// No description provided for @legacyUi511404ce3b.
  ///
  /// In en, this message translates to:
  /// **'Status Distribution'**
  String get legacyUi511404ce3b;

  /// No description provided for @legacyUie54e98e0cb.
  ///
  /// In en, this message translates to:
  /// **'Stoppage'**
  String get legacyUie54e98e0cb;

  /// No description provided for @legacyUie48d04b2b6.
  ///
  /// In en, this message translates to:
  /// **'Stopping Frontend/Backend/Listener can lock you out of the application. This page allows Start and Restart for those services, but Stop is disabled.'**
  String get legacyUie48d04b2b6;

  /// No description provided for @legacyUi16b45ef102.
  ///
  /// In en, this message translates to:
  /// **'Success, pending, and failed share'**
  String get legacyUi16b45ef102;

  /// No description provided for @legacyUi12b71c3e0f.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get legacyUi12b71c3e0f;

  /// No description provided for @legacyUied9177cab1.
  ///
  /// In en, this message translates to:
  /// **'System Metrics'**
  String get legacyUied9177cab1;

  /// No description provided for @legacyUie20a879f45.
  ///
  /// In en, this message translates to:
  /// **'Tap to edit geofence notifications'**
  String get legacyUie20a879f45;

  /// No description provided for @legacyUiac8b906fca.
  ///
  /// In en, this message translates to:
  /// **'Target Vehicle'**
  String get legacyUiac8b906fca;

  /// No description provided for @legacyUib644561145.
  ///
  /// In en, this message translates to:
  /// **'Telemetry Log'**
  String get legacyUib644561145;

  /// No description provided for @legacyUi7840676a23.
  ///
  /// In en, this message translates to:
  /// **'Telemetry log'**
  String get legacyUi7840676a23;

  /// No description provided for @legacyUi4ee3736ca6.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone. The driver and related assignments will be removed.'**
  String get legacyUi4ee3736ca6;

  /// No description provided for @legacyUi3575c0aec8.
  ///
  /// In en, this message translates to:
  /// **'This action permanently removes the sub user and revokes vehicle access. This cannot be undone.'**
  String get legacyUi3575c0aec8;

  /// No description provided for @legacyUi7f3d98b829.
  ///
  /// In en, this message translates to:
  /// **'This link cannot be deleted because its id is missing.'**
  String get legacyUi7f3d98b829;

  /// No description provided for @legacyUi4e81e87c37.
  ///
  /// In en, this message translates to:
  /// **'This permanently deletes data older than the retention period. It cannot be undone.'**
  String get legacyUi4e81e87c37;

  /// No description provided for @legacyUid8b029df5c.
  ///
  /// In en, this message translates to:
  /// **'This public tracking link will stop working immediately. This action cannot be undone.'**
  String get legacyUid8b029df5c;

  /// No description provided for @legacyUida735ce16c.
  ///
  /// In en, this message translates to:
  /// **'This report is not available for your account.'**
  String get legacyUida735ce16c;

  /// No description provided for @legacyUidf3e8a5fdd.
  ///
  /// In en, this message translates to:
  /// **'This ticket is closed or resolved. Replies are disabled.'**
  String get legacyUidf3e8a5fdd;

  /// No description provided for @legacyUif9c732c3c6.
  ///
  /// In en, this message translates to:
  /// **'This ticket is closed. Reply may reopen or move it to In Progress based on backend behavior.'**
  String get legacyUif9c732c3c6;

  /// No description provided for @legacyUif3a8370f38.
  ///
  /// In en, this message translates to:
  /// **'Total Revenue'**
  String get legacyUif3a8370f38;

  /// No description provided for @legacyUie273941b29.
  ///
  /// In en, this message translates to:
  /// **'Totals by currency'**
  String get legacyUie273941b29;

  /// No description provided for @legacyUiaa7d3d7dd9.
  ///
  /// In en, this message translates to:
  /// **'Transaction history'**
  String get legacyUiaa7d3d7dd9;

  /// No description provided for @legacyUib174443b0e.
  ///
  /// In en, this message translates to:
  /// **'Transactions and revenue'**
  String get legacyUib174443b0e;

  /// No description provided for @legacyUi9dda9aa776.
  ///
  /// In en, this message translates to:
  /// **'Trip'**
  String get legacyUi9dda9aa776;

  /// No description provided for @legacyUic948ed8076.
  ///
  /// In en, this message translates to:
  /// **'Trip proofs'**
  String get legacyUic948ed8076;

  /// No description provided for @legacyUid67a44f68d.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your filters or date range.'**
  String get legacyUid67a44f68d;

  /// No description provided for @legacyUi078f02fe7b.
  ///
  /// In en, this message translates to:
  /// **'Unable to load documents'**
  String get legacyUi078f02fe7b;

  /// No description provided for @legacyUi3b37311cd6.
  ///
  /// In en, this message translates to:
  /// **'Unable to load history'**
  String get legacyUi3b37311cd6;

  /// No description provided for @legacyUicaa5bd27e5.
  ///
  /// In en, this message translates to:
  /// **'Unable to load logs'**
  String get legacyUicaa5bd27e5;

  /// No description provided for @legacyUi92078d350e.
  ///
  /// In en, this message translates to:
  /// **'Unable to load payments'**
  String get legacyUi92078d350e;

  /// No description provided for @legacyUi5db77ece1a.
  ///
  /// In en, this message translates to:
  /// **'Unable to load profile'**
  String get legacyUi5db77ece1a;

  /// No description provided for @legacyUi081863e321.
  ///
  /// In en, this message translates to:
  /// **'Unable to load tickets'**
  String get legacyUi081863e321;

  /// No description provided for @legacyUi11f14b7638.
  ///
  /// In en, this message translates to:
  /// **'Update company identity and social links.'**
  String get legacyUi11f14b7638;

  /// No description provided for @legacyUieb58c61a89.
  ///
  /// In en, this message translates to:
  /// **'Update personal and address details. Changes are saved only when you confirm.'**
  String get legacyUieb58c61a89;

  /// No description provided for @legacyUid19cf73ae1.
  ///
  /// In en, this message translates to:
  /// **'Updated: '**
  String get legacyUid19cf73ae1;

  /// No description provided for @legacyUi9db8e8ec0b.
  ///
  /// In en, this message translates to:
  /// **'Use the live map vehicle list, then choose the stop threshold and date time range.'**
  String get legacyUi9db8e8ec0b;

  /// No description provided for @legacyUid337d1a0d6.
  ///
  /// In en, this message translates to:
  /// **'Variable Preview'**
  String get legacyUid337d1a0d6;

  /// No description provided for @legacyUi63dfad55e0.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Information'**
  String get legacyUi63dfad55e0;

  /// No description provided for @legacyUi7f4567c8c2.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Live Status'**
  String get legacyUi7f4567c8c2;

  /// No description provided for @legacyUiceedc505bd.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Status'**
  String get legacyUiceedc505bd;

  /// No description provided for @legacyUi1f41948d84.
  ///
  /// In en, this message translates to:
  /// **'Vehicle event'**
  String get legacyUi1f41948d84;

  /// No description provided for @legacyUid3aee04e65.
  ///
  /// In en, this message translates to:
  /// **'Vehicle-Geofence Matrix'**
  String get legacyUid3aee04e65;

  /// No description provided for @legacyUiefd8355920.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get legacyUiefd8355920;

  /// No description provided for @legacyUi50ad3280e1.
  ///
  /// In en, this message translates to:
  /// **'View Vehicle'**
  String get legacyUi50ad3280e1;

  /// No description provided for @legacyUi2c3c7c93f8.
  ///
  /// In en, this message translates to:
  /// **'View payments, credits, debits, and billing records.'**
  String get legacyUi2c3c7c93f8;

  /// No description provided for @legacyUi7d9ff4f0de.
  ///
  /// In en, this message translates to:
  /// **'Visibility'**
  String get legacyUi7d9ff4f0de;

  /// No description provided for @legacyUi79c6a6033a.
  ///
  /// In en, this message translates to:
  /// **'Visible to admin'**
  String get legacyUi79c6a6033a;

  /// No description provided for @legacyUied0069155f.
  ///
  /// In en, this message translates to:
  /// **'Visible to user'**
  String get legacyUied0069155f;

  /// No description provided for @legacyUia56d85fb20.
  ///
  /// In en, this message translates to:
  /// **'Web browsers require the server to allow cross-origin requests (CORS). If login fails with a connection error, enable CORS on your server.'**
  String get legacyUia56d85fb20;

  /// No description provided for @legacyUi4dd079044f.
  ///
  /// In en, this message translates to:
  /// **'Whole trip'**
  String get legacyUi4dd079044f;

  /// No description provided for @legacyUi4515b6c7b7.
  ///
  /// In en, this message translates to:
  /// **'Your day'**
  String get legacyUi4515b6c7b7;

  /// No description provided for @legacyUi50f19ac0b4.
  ///
  /// In en, this message translates to:
  /// **'Your documents and documents shared by your fleet manager.'**
  String get legacyUi50f19ac0b4;

  /// No description provided for @legacyUi4e697d55ce.
  ///
  /// In en, this message translates to:
  /// **'Your transactions with the software owner.'**
  String get legacyUi4e697d55ce;

  /// No description provided for @legacyUi678830983a.
  ///
  /// In en, this message translates to:
  /// **'— payload truncated for display —'**
  String get legacyUi678830983a;

  /// No description provided for @legacyUi1e22f79cd9.
  ///
  /// In en, this message translates to:
  /// **'Loading {value1}'**
  String legacyUi1e22f79cd9(Object value1);

  /// No description provided for @legacyUi57fdb35e30.
  ///
  /// In en, this message translates to:
  /// **'{value1} unavailable'**
  String legacyUi57fdb35e30(Object value1);

  /// No description provided for @legacyUi1fd3e5084a.
  ///
  /// In en, this message translates to:
  /// **'No {value1} found'**
  String legacyUi1fd3e5084a(Object value1);

  /// No description provided for @legacyUie16f97dcfd.
  ///
  /// In en, this message translates to:
  /// **'Clear History'**
  String get legacyUie16f97dcfd;

  /// No description provided for @legacyUiabd4cd39b9.
  ///
  /// In en, this message translates to:
  /// **'{value1} points'**
  String legacyUiabd4cd39b9(Object value1);

  /// No description provided for @legacyUi90eaac7e8b.
  ///
  /// In en, this message translates to:
  /// **'{value1} stops'**
  String legacyUi90eaac7e8b(Object value1);

  /// No description provided for @legacyUi865d65baea.
  ///
  /// In en, this message translates to:
  /// **'{value1} overspeed'**
  String legacyUi865d65baea(Object value1);

  /// No description provided for @legacyUi7326be7e87.
  ///
  /// In en, this message translates to:
  /// **'{value1} {value2} max'**
  String legacyUi7326be7e87(Object value1, Object value2);

  /// No description provided for @legacyUi5fd7f54937.
  ///
  /// In en, this message translates to:
  /// **'{value1} {value2} avg'**
  String legacyUi5fd7f54937(Object value1, Object value2);

  /// No description provided for @legacyUi5f2ee53a4c.
  ///
  /// In en, this message translates to:
  /// **'{value1} running'**
  String legacyUi5f2ee53a4c(Object value1);

  /// No description provided for @legacyUi5c24a04874.
  ///
  /// In en, this message translates to:
  /// **'{value1} stopped'**
  String legacyUi5c24a04874(Object value1);

  /// No description provided for @legacyUi2b4b82c8bb.
  ///
  /// In en, this message translates to:
  /// **'Duration: {value1}'**
  String legacyUi2b4b82c8bb(Object value1);

  /// No description provided for @legacyUi27a82a7136.
  ///
  /// In en, this message translates to:
  /// **'{value1} driving'**
  String legacyUi27a82a7136(Object value1);

  /// No description provided for @legacyUi92edf7854b.
  ///
  /// In en, this message translates to:
  /// **'{value1} vehicles'**
  String legacyUi92edf7854b(Object value1);

  /// No description provided for @legacyUi5d12bd5355.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get legacyUi5d12bd5355;

  /// No description provided for @legacyUi4e39567064.
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get legacyUi4e39567064;

  /// No description provided for @legacyUi932fc13e7f.
  ///
  /// In en, this message translates to:
  /// **'Title (optional)'**
  String get legacyUi932fc13e7f;

  /// No description provided for @legacyUi2c904359f5.
  ///
  /// In en, this message translates to:
  /// **'File exceeds {value1} MB limit'**
  String legacyUi2c904359f5(Object value1);

  /// No description provided for @legacyUi66db457b99.
  ///
  /// In en, this message translates to:
  /// **'Unsupported format. Allowed: {value1}'**
  String legacyUi66db457b99(Object value1);

  /// No description provided for @legacyUia7cf7b25a7.
  ///
  /// In en, this message translates to:
  /// **'Replace'**
  String get legacyUia7cf7b25a7;

  /// No description provided for @legacyUidf1d5f2730.
  ///
  /// In en, this message translates to:
  /// **'Test email sent to {value1}'**
  String legacyUidf1d5f2730(Object value1);

  /// No description provided for @legacyUi044b852f30.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get legacyUi044b852f30;

  /// No description provided for @legacyUie40123b4e7.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get legacyUie40123b4e7;

  /// No description provided for @legacyUi82f47c3d4d.
  ///
  /// In en, this message translates to:
  /// **'Email verified'**
  String get legacyUi82f47c3d4d;

  /// No description provided for @legacyUib1a273086c.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp verified'**
  String get legacyUib1a273086c;

  /// No description provided for @legacyUi908e5c8ce5.
  ///
  /// In en, this message translates to:
  /// **'Logged out from {value1}'**
  String legacyUi908e5c8ce5(Object value1);

  /// No description provided for @legacyUi33ce417454.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get legacyUi33ce417454;

  /// No description provided for @legacyUi71ae0ec96e.
  ///
  /// In en, this message translates to:
  /// **'Failed to load — retry'**
  String get legacyUi71ae0ec96e;

  /// No description provided for @legacyUi67c4d0506a.
  ///
  /// In en, this message translates to:
  /// **'Not applicable'**
  String get legacyUi67c4d0506a;

  /// No description provided for @legacyUia0b1fb2afb.
  ///
  /// In en, this message translates to:
  /// **'Show confirm password'**
  String get legacyUia0b1fb2afb;

  /// No description provided for @legacyUie2196c3942.
  ///
  /// In en, this message translates to:
  /// **'Hide confirm password'**
  String get legacyUie2196c3942;

  /// No description provided for @legacyUi7c073937c6.
  ///
  /// In en, this message translates to:
  /// **'OTP sent to your email'**
  String get legacyUi7c073937c6;

  /// No description provided for @legacyUi8532209c49.
  ///
  /// In en, this message translates to:
  /// **'OTP sent via WhatsApp'**
  String get legacyUi8532209c49;

  /// No description provided for @legacyUi0d455a4e26.
  ///
  /// In en, this message translates to:
  /// **'Verify Email'**
  String get legacyUi0d455a4e26;

  /// No description provided for @legacyUi9cb68a6dd3.
  ///
  /// In en, this message translates to:
  /// **'Verify WhatsApp'**
  String get legacyUi9cb68a6dd3;

  /// No description provided for @legacyUi8cf58d99c1.
  ///
  /// In en, this message translates to:
  /// **'From {value1}'**
  String legacyUi8cf58d99c1(Object value1);

  /// No description provided for @legacyUif41a1a65a6.
  ///
  /// In en, this message translates to:
  /// **'To {value1}'**
  String legacyUif41a1a65a6(Object value1);

  /// No description provided for @legacyUia801634da8.
  ///
  /// In en, this message translates to:
  /// **'{value1} deleted.'**
  String legacyUia801634da8(Object value1);

  /// No description provided for @legacyUi73f15343e6.
  ///
  /// In en, this message translates to:
  /// **'Signed in as {value1}.'**
  String legacyUi73f15343e6(Object value1);

  /// No description provided for @legacyUi48138f08cd.
  ///
  /// In en, this message translates to:
  /// **'Deactivate administrator'**
  String get legacyUi48138f08cd;

  /// No description provided for @legacyUif9494a277e.
  ///
  /// In en, this message translates to:
  /// **'Activate administrator'**
  String get legacyUif9494a277e;

  /// No description provided for @legacyUi13a84a7390.
  ///
  /// In en, this message translates to:
  /// **'Administrator activated.'**
  String get legacyUi13a84a7390;

  /// No description provided for @legacyUi8181bbb7c7.
  ///
  /// In en, this message translates to:
  /// **'Administrator deactivated.'**
  String get legacyUi8181bbb7c7;

  /// No description provided for @legacyUid65ded9428.
  ///
  /// In en, this message translates to:
  /// **'Deactivate'**
  String get legacyUid65ded9428;

  /// No description provided for @legacyUi92ef08325a.
  ///
  /// In en, this message translates to:
  /// **'Activate'**
  String get legacyUi92ef08325a;

  /// No description provided for @legacyUiacfd05ab80.
  ///
  /// In en, this message translates to:
  /// **'Email unverified'**
  String get legacyUiacfd05ab80;

  /// No description provided for @legacyUi23c9dd8809.
  ///
  /// In en, this message translates to:
  /// **'Unable to load vehicles. Retry.'**
  String get legacyUi23c9dd8809;

  /// No description provided for @legacyUib089c07088.
  ///
  /// In en, this message translates to:
  /// **'GMT {value1}'**
  String legacyUib089c07088(Object value1);

  /// No description provided for @legacyUi73585fdb6f.
  ///
  /// In en, this message translates to:
  /// **'Added {value1}'**
  String legacyUi73585fdb6f(Object value1);

  /// No description provided for @legacyUi410bebb5ea.
  ///
  /// In en, this message translates to:
  /// **'Unable to load documents. Retry.'**
  String get legacyUi410bebb5ea;

  /// No description provided for @legacyUi7f10270c45.
  ///
  /// In en, this message translates to:
  /// **'Unable to load document types. Retry.'**
  String get legacyUi7f10270c45;

  /// No description provided for @legacyUid4c2792a72.
  ///
  /// In en, this message translates to:
  /// **'Hidden'**
  String get legacyUid4c2792a72;

  /// No description provided for @legacyUi1b7cd8a9bf.
  ///
  /// In en, this message translates to:
  /// **'Document updated.'**
  String get legacyUi1b7cd8a9bf;

  /// No description provided for @legacyUi895a77b095.
  ///
  /// In en, this message translates to:
  /// **'Document uploaded.'**
  String get legacyUi895a77b095;

  /// No description provided for @legacyUief6604a13d.
  ///
  /// In en, this message translates to:
  /// **'Edit document'**
  String get legacyUief6604a13d;

  /// No description provided for @legacyUif6769b696e.
  ///
  /// In en, this message translates to:
  /// **'Credits added.'**
  String get legacyUif6769b696e;

  /// No description provided for @legacyUib16dd3b790.
  ///
  /// In en, this message translates to:
  /// **'Credits deducted.'**
  String get legacyUib16dd3b790;

  /// No description provided for @legacyUie890b12b34.
  ///
  /// In en, this message translates to:
  /// **'No transactions match your filters'**
  String get legacyUie890b12b34;

  /// No description provided for @legacyUib71113c83a.
  ///
  /// In en, this message translates to:
  /// **'No payments found for this admin. Try clearing filters.'**
  String get legacyUib71113c83a;

  /// No description provided for @legacyUi472af48c6d.
  ///
  /// In en, this message translates to:
  /// **'Record a manual payment to get started.'**
  String get legacyUi472af48c6d;

  /// No description provided for @legacyUi46f7e02bd0.
  ///
  /// In en, this message translates to:
  /// **'{value1} copied'**
  String legacyUi46f7e02bd0(Object value1);

  /// No description provided for @legacyUi70d9eead51.
  ///
  /// In en, this message translates to:
  /// **'Subject must be {value1} characters or less.'**
  String legacyUi70d9eead51(Object value1);

  /// No description provided for @legacyUifee6584f1b.
  ///
  /// In en, this message translates to:
  /// **'Description must be {value1} characters or less.'**
  String legacyUifee6584f1b(Object value1);

  /// No description provided for @legacyUi830e676993.
  ///
  /// In en, this message translates to:
  /// **'You can upload up to {value1} files.'**
  String legacyUi830e676993(Object value1);

  /// No description provided for @legacyUi4e5f407ec5.
  ///
  /// In en, this message translates to:
  /// **'Blocked file removed: {value1}'**
  String legacyUi4e5f407ec5(Object value1);

  /// No description provided for @legacyUib5d0b873d0.
  ///
  /// In en, this message translates to:
  /// **'Unsupported file removed: {value1}'**
  String legacyUib5d0b873d0(Object value1);

  /// No description provided for @legacyUid1740cec1d.
  ///
  /// In en, this message translates to:
  /// **'File exceeds 5MB: {value1}'**
  String legacyUid1740cec1d(Object value1);

  /// No description provided for @legacyUie33e0ec27a.
  ///
  /// In en, this message translates to:
  /// **'Reply must be {value1} characters or less.'**
  String legacyUie33e0ec27a(Object value1);

  /// No description provided for @legacyUid9e484645b.
  ///
  /// In en, this message translates to:
  /// **'Ticket status is already {value1}.'**
  String legacyUid9e484645b(Object value1);

  /// No description provided for @legacyUiebbf66ef0e.
  ///
  /// In en, this message translates to:
  /// **'From: {value1}{value2}'**
  String legacyUiebbf66ef0e(Object value1, Object value2);

  /// No description provided for @legacyUi94cf932307.
  ///
  /// In en, this message translates to:
  /// **'Created {value1}'**
  String legacyUi94cf932307(Object value1);

  /// No description provided for @legacyUib5ae5701b9.
  ///
  /// In en, this message translates to:
  /// **'Updated {value1}'**
  String legacyUib5ae5701b9(Object value1);

  /// No description provided for @legacyUi1a150ff203.
  ///
  /// In en, this message translates to:
  /// **'Closed {value1}'**
  String legacyUi1a150ff203(Object value1);

  /// No description provided for @legacyUiec6952e09b.
  ///
  /// In en, this message translates to:
  /// **'Updating'**
  String get legacyUiec6952e09b;

  /// No description provided for @legacyUi190040d9d3.
  ///
  /// In en, this message translates to:
  /// **'Some files are over 5MB and were removed{value1}.'**
  String legacyUi190040d9d3(Object value1);

  /// No description provided for @legacyUi2a432bdd06.
  ///
  /// In en, this message translates to:
  /// **'Local agent: {value1}'**
  String legacyUi2a432bdd06(Object value1);

  /// No description provided for @legacyUi3adb8e50db.
  ///
  /// In en, this message translates to:
  /// **'Create a team member to get started.'**
  String get legacyUi3adb8e50db;

  /// No description provided for @legacyUiabad5c010f.
  ///
  /// In en, this message translates to:
  /// **'{value1} · Permissions'**
  String legacyUiabad5c010f(Object value1);

  /// No description provided for @legacyUifb91e24fa5.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get legacyUifb91e24fa5;

  /// No description provided for @legacyUia9d4f0d3b6.
  ///
  /// In en, this message translates to:
  /// **'Unable to update permissions'**
  String get legacyUia9d4f0d3b6;

  /// No description provided for @legacyUi918bffea2f.
  ///
  /// In en, this message translates to:
  /// **'Show current password'**
  String get legacyUi918bffea2f;

  /// No description provided for @legacyUifa0245c379.
  ///
  /// In en, this message translates to:
  /// **'Hide current password'**
  String get legacyUifa0245c379;

  /// No description provided for @legacyUi9a569782b5.
  ///
  /// In en, this message translates to:
  /// **'Show new password'**
  String get legacyUi9a569782b5;

  /// No description provided for @legacyUiaa10918381.
  ///
  /// In en, this message translates to:
  /// **'Hide new password'**
  String get legacyUiaa10918381;

  /// No description provided for @legacyUi39b0c83afa.
  ///
  /// In en, this message translates to:
  /// **'Show confirm new password'**
  String get legacyUi39b0c83afa;

  /// No description provided for @legacyUiea6f8ea221.
  ///
  /// In en, this message translates to:
  /// **'Hide confirm new password'**
  String get legacyUiea6f8ea221;

  /// No description provided for @legacyUie30362677c.
  ///
  /// In en, this message translates to:
  /// **'{value1} registered'**
  String legacyUie30362677c(Object value1);

  /// No description provided for @legacyUi060250e9ba.
  ///
  /// In en, this message translates to:
  /// **'{value1} invoices'**
  String legacyUi060250e9ba(Object value1);

  /// No description provided for @legacyUi53e337d44c.
  ///
  /// In en, this message translates to:
  /// **'Save Plan'**
  String get legacyUi53e337d44c;

  /// No description provided for @legacyUi4fc636d1bb.
  ///
  /// In en, this message translates to:
  /// **'Plan updated.'**
  String get legacyUi4fc636d1bb;

  /// No description provided for @legacyUidc5a367e83.
  ///
  /// In en, this message translates to:
  /// **'Plan created.'**
  String get legacyUidc5a367e83;

  /// No description provided for @legacyUi2325fc9152.
  ///
  /// In en, this message translates to:
  /// **'No vehicle types available'**
  String get legacyUi2325fc9152;

  /// No description provided for @legacyUi4e4664e8e9.
  ///
  /// In en, this message translates to:
  /// **'Select vehicle type'**
  String get legacyUi4e4664e8e9;

  /// No description provided for @legacyUi37282b63dd.
  ///
  /// In en, this message translates to:
  /// **'Loading users...'**
  String get legacyUi37282b63dd;

  /// No description provided for @legacyUide2b4561e4.
  ///
  /// In en, this message translates to:
  /// **'Failed to load users'**
  String get legacyUide2b4561e4;

  /// No description provided for @legacyUif1b918acaf.
  ///
  /// In en, this message translates to:
  /// **'Create or select primary user'**
  String get legacyUif1b918acaf;

  /// No description provided for @legacyUic96ec8c8a6.
  ///
  /// In en, this message translates to:
  /// **'No devices available'**
  String get legacyUic96ec8c8a6;

  /// No description provided for @legacyUieeed87c94b.
  ///
  /// In en, this message translates to:
  /// **'Select GPS device'**
  String get legacyUieeed87c94b;

  /// No description provided for @legacyUie5a3dc6c41.
  ///
  /// In en, this message translates to:
  /// **'No plans available'**
  String get legacyUie5a3dc6c41;

  /// No description provided for @legacyUi509d83b55f.
  ///
  /// In en, this message translates to:
  /// **'Select pricing plan'**
  String get legacyUi509d83b55f;

  /// No description provided for @legacyUi91c69c8c0d.
  ///
  /// In en, this message translates to:
  /// **'Vehicle \"{value1}\" created.'**
  String legacyUi91c69c8c0d(Object value1);

  /// No description provided for @legacyUi048e2d12ad.
  ///
  /// In en, this message translates to:
  /// **'Vehicle deactivated.'**
  String get legacyUi048e2d12ad;

  /// No description provided for @legacyUib042915cc0.
  ///
  /// In en, this message translates to:
  /// **'Vehicle activated.'**
  String get legacyUib042915cc0;

  /// No description provided for @legacyUi3741f56c60.
  ///
  /// In en, this message translates to:
  /// **'Create Sensor'**
  String get legacyUi3741f56c60;

  /// No description provided for @legacyUi996e719712.
  ///
  /// In en, this message translates to:
  /// **'Save Sensor'**
  String get legacyUi996e719712;

  /// No description provided for @legacyUiaa9bf6a127.
  ///
  /// In en, this message translates to:
  /// **'Service could not be updated'**
  String get legacyUiaa9bf6a127;

  /// No description provided for @legacyUif17fe09e18.
  ///
  /// In en, this message translates to:
  /// **'{value1} annual coverage renewed'**
  String legacyUif17fe09e18(Object value1);

  /// No description provided for @legacyUid55d13471f.
  ///
  /// In en, this message translates to:
  /// **'Annual renewal failed'**
  String get legacyUid55d13471f;

  /// No description provided for @legacyUi2caa5892b7.
  ///
  /// In en, this message translates to:
  /// **'Polling status...'**
  String get legacyUi2caa5892b7;

  /// No description provided for @legacyUid56ae084ba.
  ///
  /// In en, this message translates to:
  /// **'Edit Document'**
  String get legacyUid56ae084ba;

  /// No description provided for @legacyUi47396c4fcf.
  ///
  /// In en, this message translates to:
  /// **'Create a driver to get started.'**
  String get legacyUi47396c4fcf;

  /// No description provided for @legacyUie4c5584c2a.
  ///
  /// In en, this message translates to:
  /// **'Driver activated.'**
  String get legacyUie4c5584c2a;

  /// No description provided for @legacyUi255f9b5d50.
  ///
  /// In en, this message translates to:
  /// **'Driver deactivated.'**
  String get legacyUi255f9b5d50;

  /// No description provided for @legacyUi2c5ad08780.
  ///
  /// In en, this message translates to:
  /// **'Exp: {value1}'**
  String legacyUi2c5ad08780(Object value1);

  /// No description provided for @legacyUifc3606d535.
  ///
  /// In en, this message translates to:
  /// **'Deactivate driver'**
  String get legacyUifc3606d535;

  /// No description provided for @legacyUic82a768102.
  ///
  /// In en, this message translates to:
  /// **'Activate driver'**
  String get legacyUic82a768102;

  /// No description provided for @legacyUi3c2dd46009.
  ///
  /// In en, this message translates to:
  /// **'{value1} (current)'**
  String legacyUi3c2dd46009(Object value1);

  /// No description provided for @legacyUi9e9d25ea74.
  ///
  /// In en, this message translates to:
  /// **'Select country first'**
  String get legacyUi9e9d25ea74;

  /// No description provided for @legacyUi789073b300.
  ///
  /// In en, this message translates to:
  /// **'Select state first'**
  String get legacyUi789073b300;

  /// No description provided for @legacyUie0c7a349f8.
  ///
  /// In en, this message translates to:
  /// **'Deselect all filtered'**
  String get legacyUie0c7a349f8;

  /// No description provided for @legacyUi30a4c62f4d.
  ///
  /// In en, this message translates to:
  /// **'Select all filtered'**
  String get legacyUi30a4c62f4d;

  /// No description provided for @legacyUi303e32bfd9.
  ///
  /// In en, this message translates to:
  /// **'Payment confirmed and service renewed'**
  String get legacyUi303e32bfd9;

  /// No description provided for @legacyUiad3c7489f5.
  ///
  /// In en, this message translates to:
  /// **'Renewal request cancelled'**
  String get legacyUiad3c7489f5;

  /// No description provided for @legacyUi91027c0a9a.
  ///
  /// In en, this message translates to:
  /// **'Request could not be updated'**
  String get legacyUi91027c0a9a;

  /// No description provided for @legacyUi3fb82cbe4b.
  ///
  /// In en, this message translates to:
  /// **'Search user tickets'**
  String get legacyUi3fb82cbe4b;

  /// No description provided for @legacyUi3263ab8929.
  ///
  /// In en, this message translates to:
  /// **'Search my tickets'**
  String get legacyUi3263ab8929;

  /// No description provided for @legacyUi24cae41f13.
  ///
  /// In en, this message translates to:
  /// **'User activated.'**
  String get legacyUi24cae41f13;

  /// No description provided for @legacyUi48d348ab09.
  ///
  /// In en, this message translates to:
  /// **'User deactivated.'**
  String get legacyUi48d348ab09;

  /// No description provided for @legacyUi515200de54.
  ///
  /// In en, this message translates to:
  /// **'Minimum {value1} characters'**
  String legacyUi515200de54(Object value1);

  /// No description provided for @legacyUiea03fca475.
  ///
  /// In en, this message translates to:
  /// **'Select a country first'**
  String get legacyUiea03fca475;

  /// No description provided for @legacyUi01d9797a19.
  ///
  /// In en, this message translates to:
  /// **'No states available'**
  String get legacyUi01d9797a19;

  /// No description provided for @legacyUic234150a07.
  ///
  /// In en, this message translates to:
  /// **'Select a state'**
  String get legacyUic234150a07;

  /// No description provided for @legacyUida9ca145a1.
  ///
  /// In en, this message translates to:
  /// **'Select a state first'**
  String get legacyUida9ca145a1;

  /// No description provided for @legacyUi12fb8b7d21.
  ///
  /// In en, this message translates to:
  /// **'No cities available'**
  String get legacyUi12fb8b7d21;

  /// No description provided for @legacyUia8ab373cf7.
  ///
  /// In en, this message translates to:
  /// **'Select a city'**
  String get legacyUia8ab373cf7;

  /// No description provided for @legacyUi99c1db6636.
  ///
  /// In en, this message translates to:
  /// **'User \"{value1}\" created.'**
  String legacyUi99c1db6636(Object value1);

  /// No description provided for @legacyUi6ea66e7cf8.
  ///
  /// In en, this message translates to:
  /// **'No assigned drivers'**
  String get legacyUi6ea66e7cf8;

  /// No description provided for @legacyUi6b4d2e8347.
  ///
  /// In en, this message translates to:
  /// **'No drivers match your search'**
  String get legacyUi6b4d2e8347;

  /// No description provided for @legacyUic7a9755928.
  ///
  /// In en, this message translates to:
  /// **'License {value1}'**
  String legacyUic7a9755928(Object value1);

  /// No description provided for @legacyUi530530a405.
  ///
  /// In en, this message translates to:
  /// **'No available drivers'**
  String get legacyUi530530a405;

  /// No description provided for @legacyUied9f265a0a.
  ///
  /// In en, this message translates to:
  /// **'Search {value1}…'**
  String legacyUied9f265a0a(Object value1);

  /// No description provided for @legacyUia269afc99c.
  ///
  /// In en, this message translates to:
  /// **'No tickets found'**
  String get legacyUia269afc99c;

  /// No description provided for @legacyUifd0ab9a284.
  ///
  /// In en, this message translates to:
  /// **'No tickets match your search'**
  String get legacyUifd0ab9a284;

  /// No description provided for @legacyUic93cd16b9b.
  ///
  /// In en, this message translates to:
  /// **'Last {value1}'**
  String legacyUic93cd16b9b(Object value1);

  /// No description provided for @legacyUib68af38cf0.
  ///
  /// In en, this message translates to:
  /// **'Ticket is already {value1}.'**
  String legacyUib68af38cf0(Object value1);

  /// No description provided for @legacyUi9ddc709693.
  ///
  /// In en, this message translates to:
  /// **'Deactivate user'**
  String get legacyUi9ddc709693;

  /// No description provided for @legacyUiaebaaf50f8.
  ///
  /// In en, this message translates to:
  /// **'Activate user'**
  String get legacyUiaebaaf50f8;

  /// No description provided for @legacyUi8ed321fdf0.
  ///
  /// In en, this message translates to:
  /// **'Unable to save permissions'**
  String get legacyUi8ed321fdf0;

  /// No description provided for @legacyUi51c4b07667.
  ///
  /// In en, this message translates to:
  /// **'No vehicles match your search'**
  String get legacyUi51c4b07667;

  /// No description provided for @legacyUi83f7990857.
  ///
  /// In en, this message translates to:
  /// **'IMEI {value1}'**
  String legacyUi83f7990857(Object value1);

  /// No description provided for @legacyUid3544dd1fc.
  ///
  /// In en, this message translates to:
  /// **'SIM {value1}'**
  String legacyUid3544dd1fc(Object value1);

  /// No description provided for @legacyUiaed1ab73c8.
  ///
  /// In en, this message translates to:
  /// **'VIN {value1}'**
  String legacyUiaed1ab73c8(Object value1);

  /// No description provided for @legacyUi20400601e8.
  ///
  /// In en, this message translates to:
  /// **'Expiry {value1}'**
  String legacyUi20400601e8(Object value1);

  /// No description provided for @legacyUif0dc6b09f8.
  ///
  /// In en, this message translates to:
  /// **'No available vehicles'**
  String get legacyUif0dc6b09f8;

  /// No description provided for @legacyUi39d436aaba.
  ///
  /// In en, this message translates to:
  /// **'No expiry'**
  String get legacyUi39d436aaba;

  /// No description provided for @legacyUic15c47e4c9.
  ///
  /// In en, this message translates to:
  /// **'Search IMEI, device type, SIM number…'**
  String get legacyUic15c47e4c9;

  /// No description provided for @legacyUibc139b1c14.
  ///
  /// In en, this message translates to:
  /// **'Search SIM, IMSI, ICCID, provider…'**
  String get legacyUibc139b1c14;

  /// No description provided for @legacyUiaa729739dd.
  ///
  /// In en, this message translates to:
  /// **'No devices found'**
  String get legacyUiaa729739dd;

  /// No description provided for @legacyUi679d782d32.
  ///
  /// In en, this message translates to:
  /// **'No SIM cards found'**
  String get legacyUi679d782d32;

  /// No description provided for @legacyUi613b9215a5.
  ///
  /// In en, this message translates to:
  /// **'Add inventory to get started.'**
  String get legacyUi613b9215a5;

  /// No description provided for @legacyUi9f91b0dc33.
  ///
  /// In en, this message translates to:
  /// **'Loading device types...'**
  String get legacyUi9f91b0dc33;

  /// No description provided for @legacyUi9ba6bfee17.
  ///
  /// In en, this message translates to:
  /// **'Using safe defaults. {value1}'**
  String legacyUi9ba6bfee17(Object value1);

  /// No description provided for @legacyUi2919b3cdf5.
  ///
  /// In en, this message translates to:
  /// **'Email pending'**
  String get legacyUi2919b3cdf5;

  /// No description provided for @legacyUidfd4099c87.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp pending'**
  String get legacyUidfd4099c87;

  /// No description provided for @legacyUif0dd87cef8.
  ///
  /// In en, this message translates to:
  /// **'Switch to {value1} tab'**
  String legacyUif0dd87cef8(Object value1);

  /// No description provided for @legacyUi364cdce6f9.
  ///
  /// In en, this message translates to:
  /// **'{value1} credits'**
  String legacyUi364cdce6f9(Object value1);

  /// No description provided for @legacyUi070e328ec8.
  ///
  /// In en, this message translates to:
  /// **'Uploading...'**
  String get legacyUi070e328ec8;

  /// No description provided for @legacyUie8d33553f6.
  ///
  /// In en, this message translates to:
  /// **'Change Avatar'**
  String get legacyUie8d33553f6;

  /// No description provided for @legacyUi56b3825e50.
  ///
  /// In en, this message translates to:
  /// **'Apply preset {value1}'**
  String legacyUi56b3825e50(Object value1);

  /// No description provided for @legacyUi28e40daab7.
  ///
  /// In en, this message translates to:
  /// **'Resending...'**
  String get legacyUi28e40daab7;

  /// No description provided for @legacyUib707b694b2.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP'**
  String get legacyUib707b694b2;

  /// No description provided for @legacyUia648c7bbe2.
  ///
  /// In en, this message translates to:
  /// **'{value1} picker'**
  String legacyUia648c7bbe2(Object value1);

  /// No description provided for @legacyUidd1242a8fc.
  ///
  /// In en, this message translates to:
  /// **'Subscribed'**
  String get legacyUidd1242a8fc;

  /// No description provided for @legacyUibbf5d78203.
  ///
  /// In en, this message translates to:
  /// **'Not subscribed'**
  String get legacyUibbf5d78203;

  /// No description provided for @legacyUi0e42454279.
  ///
  /// In en, this message translates to:
  /// **'all vehicles'**
  String get legacyUi0e42454279;

  /// No description provided for @legacyUi12e7d6beac.
  ///
  /// In en, this message translates to:
  /// **'Source unknown'**
  String get legacyUi12e7d6beac;

  /// No description provided for @legacyUifb2269d326.
  ///
  /// In en, this message translates to:
  /// **'No operational vehicles available.'**
  String get legacyUifb2269d326;

  /// No description provided for @legacyUi9dd705b078.
  ///
  /// In en, this message translates to:
  /// **'No vehicles available.'**
  String get legacyUi9dd705b078;

  /// No description provided for @legacyUi8879fce2e7.
  ///
  /// In en, this message translates to:
  /// **'{value1} blocked vehicle{value2} excluded.'**
  String legacyUi8879fce2e7(Object value1, Object value2);

  /// No description provided for @legacyUif039d146e6.
  ///
  /// In en, this message translates to:
  /// **'{value1} assigned vehicles'**
  String legacyUif039d146e6(Object value1);

  /// No description provided for @legacyUi02b460b2cf.
  ///
  /// In en, this message translates to:
  /// **'No matching vehicles'**
  String get legacyUi02b460b2cf;

  /// No description provided for @legacyUi537da7f70e.
  ///
  /// In en, this message translates to:
  /// **'All vehicles are already assigned to this sub user.'**
  String get legacyUi537da7f70e;

  /// No description provided for @legacyUif614a2e6b5.
  ///
  /// In en, this message translates to:
  /// **'Try a different search query.'**
  String get legacyUif614a2e6b5;

  /// No description provided for @legacyUi28516f977e.
  ///
  /// In en, this message translates to:
  /// **'Sub user deactivated.'**
  String get legacyUi28516f977e;

  /// No description provided for @legacyUi7841e93192.
  ///
  /// In en, this message translates to:
  /// **'Sub user activated.'**
  String get legacyUi7841e93192;

  /// No description provided for @legacyUi87e328dc94.
  ///
  /// In en, this message translates to:
  /// **'Clear Search'**
  String get legacyUi87e328dc94;

  /// No description provided for @legacyUi72556ffa55.
  ///
  /// In en, this message translates to:
  /// **'Visible to Driver'**
  String get legacyUi72556ffa55;

  /// No description provided for @legacyUi355f129929.
  ///
  /// In en, this message translates to:
  /// **'Hidden from Driver'**
  String get legacyUi355f129929;

  /// No description provided for @legacyUib68e795ff9.
  ///
  /// In en, this message translates to:
  /// **'Change Vehicle'**
  String get legacyUib68e795ff9;

  /// No description provided for @legacyUi0cb329674a.
  ///
  /// In en, this message translates to:
  /// **'Visible in user documents'**
  String get legacyUi0cb329674a;

  /// No description provided for @legacyUi7ab98ca9b9.
  ///
  /// In en, this message translates to:
  /// **'Hidden from user documents'**
  String get legacyUi7ab98ca9b9;

  /// No description provided for @legacyUi5f22178640.
  ///
  /// In en, this message translates to:
  /// **'Driver can see this document'**
  String get legacyUi5f22178640;

  /// No description provided for @legacyUiaf7ad5ad5c.
  ///
  /// In en, this message translates to:
  /// **'Driver cannot see this document'**
  String get legacyUiaf7ad5ad5c;

  /// No description provided for @legacyUib544cc3e95.
  ///
  /// In en, this message translates to:
  /// **'No unassigned vehicles'**
  String get legacyUib544cc3e95;

  /// No description provided for @legacyUidf10a27148.
  ///
  /// In en, this message translates to:
  /// **'All vehicles are already assigned.'**
  String get legacyUidf10a27148;

  /// No description provided for @legacyUic3763af773.
  ///
  /// In en, this message translates to:
  /// **'Not updated'**
  String get legacyUic3763af773;

  /// No description provided for @legacyUia1f5a8dbd3.
  ///
  /// In en, this message translates to:
  /// **'No sensors found'**
  String get legacyUia1f5a8dbd3;

  /// No description provided for @legacyUi6a3625800c.
  ///
  /// In en, this message translates to:
  /// **'No sensors are configured for this vehicle.'**
  String get legacyUi6a3625800c;

  /// No description provided for @legacyUi5fdd1b0855.
  ///
  /// In en, this message translates to:
  /// **'Sensor Settings'**
  String get legacyUi5fdd1b0855;

  /// No description provided for @legacyUi2524c34a0d.
  ///
  /// In en, this message translates to:
  /// **'New Sensor'**
  String get legacyUi2524c34a0d;

  /// No description provided for @legacyUiae7e887517.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get legacyUiae7e887517;

  /// No description provided for @legacyUi126eda8b21.
  ///
  /// In en, this message translates to:
  /// **'Running...'**
  String get legacyUi126eda8b21;

  /// No description provided for @legacyUi7745774c38.
  ///
  /// In en, this message translates to:
  /// **'Sensor created.'**
  String get legacyUi7745774c38;

  /// No description provided for @legacyUi2a367dafb5.
  ///
  /// In en, this message translates to:
  /// **'Sensor updated.'**
  String get legacyUi2a367dafb5;

  /// No description provided for @legacyUi4abc320492.
  ///
  /// In en, this message translates to:
  /// **'Loading config'**
  String get legacyUi4abc320492;

  /// No description provided for @legacyUic0ae8f6ea8.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get legacyUic0ae8f6ea8;

  /// No description provided for @legacyUif352418f58.
  ///
  /// In en, this message translates to:
  /// **'Loading types…'**
  String get legacyUif352418f58;

  /// No description provided for @legacyUi82385d8917.
  ///
  /// In en, this message translates to:
  /// **'Loading timezones…'**
  String get legacyUi82385d8917;

  /// No description provided for @legacyUi22e6340f2c.
  ///
  /// In en, this message translates to:
  /// **'Select timezone'**
  String get legacyUi22e6340f2c;

  /// No description provided for @legacyUicc4889261c.
  ///
  /// In en, this message translates to:
  /// **'Reload History'**
  String get legacyUicc4889261c;

  /// No description provided for @legacyUi9e8a1c5b7b.
  ///
  /// In en, this message translates to:
  /// **'Loading sensors…'**
  String get legacyUi9e8a1c5b7b;

  /// No description provided for @legacyUic0a743750e.
  ///
  /// In en, this message translates to:
  /// **'Select {value1} report range'**
  String legacyUic0a743750e(Object value1);

  /// No description provided for @legacyUi26362a69a0.
  ///
  /// In en, this message translates to:
  /// **'Running: {value1}'**
  String legacyUi26362a69a0(Object value1);

  /// No description provided for @legacyUicbbef93382.
  ///
  /// In en, this message translates to:
  /// **'Stopped: {value1}'**
  String legacyUicbbef93382(Object value1);

  /// No description provided for @legacyUic1d252d58b.
  ///
  /// In en, this message translates to:
  /// **'{value1} — Overspeed'**
  String legacyUic1d252d58b(Object value1);

  /// No description provided for @legacyUidf3ab0c2d9.
  ///
  /// In en, this message translates to:
  /// **'Day: {value1}'**
  String legacyUidf3ab0c2d9(Object value1);

  /// No description provided for @legacyUi20076143b6.
  ///
  /// In en, this message translates to:
  /// **'Night: {value1}'**
  String legacyUi20076143b6(Object value1);

  /// No description provided for @legacyUie296339b1e.
  ///
  /// In en, this message translates to:
  /// **'{value1} trip{value2}'**
  String legacyUie296339b1e(Object value1, Object value2);

  /// No description provided for @legacyUib4c5c14ddb.
  ///
  /// In en, this message translates to:
  /// **'Max {value1} km/h'**
  String legacyUib4c5c14ddb(Object value1);

  /// No description provided for @legacyUi491fa657c5.
  ///
  /// In en, this message translates to:
  /// **'{value1}: {value2} km'**
  String legacyUi491fa657c5(Object value1, Object value2);

  /// No description provided for @legacyUia6587e8e7b.
  ///
  /// In en, this message translates to:
  /// **'Distance by Vehicle (top {value1})'**
  String legacyUia6587e8e7b(Object value1);

  /// No description provided for @legacyUi6eca89289b.
  ///
  /// In en, this message translates to:
  /// **'{value1} km/h'**
  String legacyUi6eca89289b(Object value1);

  /// No description provided for @legacyUib9a5d6824c.
  ///
  /// In en, this message translates to:
  /// **'Geofence {value1} for {value2}'**
  String legacyUib9a5d6824c(Object value1, Object value2);

  /// No description provided for @legacyUi4d24bcb058.
  ///
  /// In en, this message translates to:
  /// **'Overspeed limit ({value1}) for {value2}'**
  String legacyUi4d24bcb058(Object value1, Object value2);

  /// No description provided for @legacyUi56a2285c5b.
  ///
  /// In en, this message translates to:
  /// **'Saving…'**
  String get legacyUi56a2285c5b;

  /// No description provided for @legacyUia1f38b12bb.
  ///
  /// In en, this message translates to:
  /// **'{value1} toggle'**
  String legacyUia1f38b12bb(Object value1);

  /// No description provided for @legacyUic3b516d33c.
  ///
  /// In en, this message translates to:
  /// **'{value1} geofences'**
  String legacyUic3b516d33c(Object value1);

  /// No description provided for @legacyUi010f99630a.
  ///
  /// In en, this message translates to:
  /// **'Edit Track Link'**
  String get legacyUi010f99630a;

  /// No description provided for @legacyUibb53b1c483.
  ///
  /// In en, this message translates to:
  /// **'New Track Link'**
  String get legacyUibb53b1c483;

  /// No description provided for @legacyUi9287b718c6.
  ///
  /// In en, this message translates to:
  /// **'{value1} selected'**
  String legacyUi9287b718c6(Object value1);

  /// No description provided for @legacyUib948ff19e4.
  ///
  /// In en, this message translates to:
  /// **'Unlock square'**
  String get legacyUib948ff19e4;

  /// No description provided for @legacyUi85a3ef0c3f.
  ///
  /// In en, this message translates to:
  /// **'Lock square'**
  String get legacyUi85a3ef0c3f;

  /// No description provided for @legacyUi9dd7a6b201.
  ///
  /// In en, this message translates to:
  /// **'Create geofence'**
  String get legacyUi9dd7a6b201;

  /// No description provided for @legacyUidccb573a71.
  ///
  /// In en, this message translates to:
  /// **'Draw route'**
  String get legacyUidccb573a71;

  /// No description provided for @legacyUi4c91961249.
  ///
  /// In en, this message translates to:
  /// **'Upload {value1} rows'**
  String legacyUi4c91961249(Object value1);

  /// No description provided for @legacyUi0ff9c73519.
  ///
  /// In en, this message translates to:
  /// **'{value1} valid'**
  String legacyUi0ff9c73519(Object value1);

  /// No description provided for @legacyUifa7ec0ed62.
  ///
  /// In en, this message translates to:
  /// **'{value1} invalid'**
  String legacyUifa7ec0ed62(Object value1);

  /// No description provided for @legacyUi1483db1240.
  ///
  /// In en, this message translates to:
  /// **'{value1} ok'**
  String legacyUi1483db1240(Object value1);

  /// No description provided for @legacyUi2c661fac7f.
  ///
  /// In en, this message translates to:
  /// **'{value1} failed'**
  String legacyUi2c661fac7f(Object value1);

  /// No description provided for @legacyUi7e613c0b85.
  ///
  /// In en, this message translates to:
  /// **'Place POI'**
  String get legacyUi7e613c0b85;

  /// No description provided for @legacyUi4405592a72.
  ///
  /// In en, this message translates to:
  /// **'Move POI'**
  String get legacyUi4405592a72;

  /// No description provided for @legacyUi91fbb41bfb.
  ///
  /// In en, this message translates to:
  /// **'Use this location'**
  String get legacyUi91fbb41bfb;

  /// No description provided for @legacyUif05f282071.
  ///
  /// In en, this message translates to:
  /// **'Tap map to place POI'**
  String get legacyUif05f282071;

  /// No description provided for @legacyUie8f485c68a.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting the filters or date range.'**
  String get legacyUie8f485c68a;

  /// No description provided for @legacyUia0c0bb9e85.
  ///
  /// In en, this message translates to:
  /// **'No transactions available for this period.'**
  String get legacyUia0c0bb9e85;

  /// No description provided for @legacyUid7d6dade2a.
  ///
  /// In en, this message translates to:
  /// **'Success {value1}'**
  String legacyUid7d6dade2a(Object value1);

  /// No description provided for @legacyUi3a0d457cee.
  ///
  /// In en, this message translates to:
  /// **'Pending {value1}'**
  String legacyUi3a0d457cee(Object value1);

  /// No description provided for @legacyUi07d104432b.
  ///
  /// In en, this message translates to:
  /// **'Failed {value1}'**
  String legacyUi07d104432b(Object value1);

  /// No description provided for @legacyUi3fb75e3bfe.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get legacyUi3fb75e3bfe;

  /// No description provided for @legacyUif99d98e85f.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get legacyUif99d98e85f;

  /// No description provided for @legacyUi0d2afda86b.
  ///
  /// In en, this message translates to:
  /// **'Demo workspace opened'**
  String get legacyUi0d2afda86b;

  /// No description provided for @legacyUif06ccf010d.
  ///
  /// In en, this message translates to:
  /// **'Login successful'**
  String get legacyUif06ccf010d;

  /// No description provided for @legacyUifc45091249.
  ///
  /// In en, this message translates to:
  /// **'Switch to light mode'**
  String get legacyUifc45091249;

  /// No description provided for @legacyUic29220f958.
  ///
  /// In en, this message translates to:
  /// **'Switch to dark mode'**
  String get legacyUic29220f958;

  /// No description provided for @legacyUi257616b8e4.
  ///
  /// In en, this message translates to:
  /// **'No unread notifications'**
  String get legacyUi257616b8e4;

  /// No description provided for @legacyUid2609b6af1.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get legacyUid2609b6af1;

  /// No description provided for @legacyUi04d956a670.
  ///
  /// In en, this message translates to:
  /// **'Everything is marked as read. New alerts will appear here as they arrive.'**
  String get legacyUi04d956a670;

  /// No description provided for @legacyUi7fe220bd95.
  ///
  /// In en, this message translates to:
  /// **'Vehicle alerts, system events, and operational updates will appear here.'**
  String get legacyUi7fe220bd95;

  /// No description provided for @legacyUib2f3a86e84.
  ///
  /// In en, this message translates to:
  /// **'All read'**
  String get legacyUib2f3a86e84;

  /// No description provided for @legacyUicbf6939e9e.
  ///
  /// In en, this message translates to:
  /// **'Marking…'**
  String get legacyUicbf6939e9e;

  /// No description provided for @legacyUi8958e22c23.
  ///
  /// In en, this message translates to:
  /// **'Mark all read'**
  String get legacyUi8958e22c23;

  /// No description provided for @legacyUicb9ae54e8a.
  ///
  /// In en, this message translates to:
  /// **'Showing {value1} of {value2}'**
  String legacyUicb9ae54e8a(Object value1, Object value2);

  /// No description provided for @legacyUie5b28b8ae4.
  ///
  /// In en, this message translates to:
  /// **'Page {value1} of {value2}'**
  String legacyUie5b28b8ae4(Object value1, Object value2);

  /// No description provided for @legacyUic1d317a815.
  ///
  /// In en, this message translates to:
  /// **'No matching tickets'**
  String get legacyUic1d317a815;

  /// No description provided for @legacyUiae9e814889.
  ///
  /// In en, this message translates to:
  /// **'No tickets'**
  String get legacyUiae9e814889;

  /// No description provided for @legacyUicc80739f43.
  ///
  /// In en, this message translates to:
  /// **'Try a different search or status filter.'**
  String get legacyUicc80739f43;

  /// No description provided for @legacyUib1ac2d29f2.
  ///
  /// In en, this message translates to:
  /// **'Create a ticket and the team will follow up here.'**
  String get legacyUib1ac2d29f2;

  /// No description provided for @legacyUia6864fdac8.
  ///
  /// In en, this message translates to:
  /// **'{value1} rows'**
  String legacyUia6864fdac8(Object value1);

  /// No description provided for @legacyUi8f26c6520d.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get legacyUi8f26c6520d;

  /// No description provided for @legacyUie7a93c340a.
  ///
  /// In en, this message translates to:
  /// **'{value1} events'**
  String legacyUie7a93c340a(Object value1);

  /// No description provided for @legacyUia4ab77ad86.
  ///
  /// In en, this message translates to:
  /// **'OpenVTS event'**
  String get legacyUia4ab77ad86;

  /// No description provided for @legacyUif55aae5a86.
  ///
  /// In en, this message translates to:
  /// **'IMEI unavailable'**
  String get legacyUif55aae5a86;

  /// No description provided for @legacyUib8eb4a7ee3.
  ///
  /// In en, this message translates to:
  /// **'Loading commands…'**
  String get legacyUib8eb4a7ee3;

  /// No description provided for @legacyUif7933da683.
  ///
  /// In en, this message translates to:
  /// **'No compatible commands'**
  String get legacyUif7933da683;

  /// No description provided for @legacyUi4be4430e57.
  ///
  /// In en, this message translates to:
  /// **'Select command'**
  String get legacyUi4be4430e57;

  /// No description provided for @legacyUi70ac5dd63e.
  ///
  /// In en, this message translates to:
  /// **'TIMELINE ({value1})'**
  String legacyUi70ac5dd63e(Object value1);

  /// No description provided for @legacyUi24d8fbef9d.
  ///
  /// In en, this message translates to:
  /// **'{value1} {value2}x'**
  String legacyUi24d8fbef9d(Object value1, Object value2);

  /// No description provided for @legacyUibde2a7e880.
  ///
  /// In en, this message translates to:
  /// **'Page {value1} of {value2} · {value3} trips'**
  String legacyUibde2a7e880(Object value1, Object value2, Object value3);

  /// No description provided for @legacyUi08343b3fe7.
  ///
  /// In en, this message translates to:
  /// **'{value1} remaining'**
  String legacyUi08343b3fe7(Object value1);

  /// No description provided for @legacyUi843b148bbc.
  ///
  /// In en, this message translates to:
  /// **'ETA {value1}'**
  String legacyUi843b148bbc(Object value1);

  /// No description provided for @legacyUi46d11990c5.
  ///
  /// In en, this message translates to:
  /// **'Position updated {value1}'**
  String legacyUi46d11990c5(Object value1);

  /// No description provided for @legacyUiecd87f34a4.
  ///
  /// In en, this message translates to:
  /// **'Delete {value1}?'**
  String legacyUiecd87f34a4(Object value1);

  /// No description provided for @legacyUi666b616488.
  ///
  /// In en, this message translates to:
  /// **'Expires {value1}'**
  String legacyUi666b616488(Object value1);

  /// No description provided for @legacyUic7ac551ef0.
  ///
  /// In en, this message translates to:
  /// **'Deleting…'**
  String get legacyUic7ac551ef0;

  /// No description provided for @legacyUi27015ac78b.
  ///
  /// In en, this message translates to:
  /// **'{value1} unread · Latest {value2} notifications'**
  String legacyUi27015ac78b(Object value1, Object value2);

  /// No description provided for @legacyUi46b0a7d4ca.
  ///
  /// In en, this message translates to:
  /// **'{value1} / {value2} stops completed'**
  String legacyUi46b0a7d4ca(Object value1, Object value2);

  /// No description provided for @legacyUidc7f2c3785.
  ///
  /// In en, this message translates to:
  /// **'Date unavailable'**
  String get legacyUidc7f2c3785;

  /// No description provided for @legacyUib11b062b52.
  ///
  /// In en, this message translates to:
  /// **'Upload trip proof'**
  String get legacyUib11b062b52;

  /// No description provided for @legacyUi8f1a9ca44a.
  ///
  /// In en, this message translates to:
  /// **'PDF, JPG, PNG or WebP · Up to 5 MB'**
  String get legacyUi8f1a9ca44a;

  /// No description provided for @legacyUi91df716a6b.
  ///
  /// In en, this message translates to:
  /// **'PDF, JPG, PNG, WebP, DOC or DOCX · Up to 5 MB'**
  String get legacyUi91df716a6b;

  /// No description provided for @legacyUid921a79afa.
  ///
  /// In en, this message translates to:
  /// **'Uploading…'**
  String get legacyUid921a79afa;

  /// No description provided for @legacyUiba9b85b92a.
  ///
  /// In en, this message translates to:
  /// **'Last update {value1}'**
  String legacyUiba9b85b92a(Object value1);

  /// No description provided for @legacyUib9f8dfe265.
  ///
  /// In en, this message translates to:
  /// **'Distance today: {value1}'**
  String legacyUib9f8dfe265(Object value1);

  /// No description provided for @legacyUif0ea529a1a.
  ///
  /// In en, this message translates to:
  /// **'{value1} days'**
  String legacyUif0ea529a1a(Object value1);

  /// No description provided for @legacyUi387c4ee271.
  ///
  /// In en, this message translates to:
  /// **'{value1}  ·  {value2} days'**
  String legacyUi387c4ee271(Object value1, Object value2);

  /// No description provided for @legacyUideba3e1d0f.
  ///
  /// In en, this message translates to:
  /// **'Dry-run summary'**
  String get legacyUideba3e1d0f;

  /// No description provided for @legacyUia7d0c36803.
  ///
  /// In en, this message translates to:
  /// **'Last cleanup'**
  String get legacyUia7d0c36803;

  /// No description provided for @legacyUia24243eb0c.
  ///
  /// In en, this message translates to:
  /// **'Tables ({value1})'**
  String legacyUia24243eb0c(Object value1);

  /// No description provided for @legacyUic74a3012a0.
  ///
  /// In en, this message translates to:
  /// **'Checking status…'**
  String get legacyUic74a3012a0;

  /// No description provided for @legacyUie991a76914.
  ///
  /// In en, this message translates to:
  /// **'Status unknown'**
  String get legacyUie991a76914;

  /// No description provided for @legacyUia722bd6476.
  ///
  /// In en, this message translates to:
  /// **'Platform growth across users, vehicles, and licenses.'**
  String get legacyUia722bd6476;

  /// No description provided for @legacyUi852c487a99.
  ///
  /// In en, this message translates to:
  /// **'License peak {value1}'**
  String legacyUi852c487a99(Object value1);

  /// No description provided for @legacyUic44efcae53.
  ///
  /// In en, this message translates to:
  /// **'Remove {value1} from the platform? This action cannot be undone.'**
  String legacyUic44efcae53(Object value1);

  /// No description provided for @legacyUicac4f1ac56.
  ///
  /// In en, this message translates to:
  /// **'{value1} Admin'**
  String legacyUicac4f1ac56(Object value1);

  /// No description provided for @legacyUi68401f3c9e.
  ///
  /// In en, this message translates to:
  /// **'Avg {value1} {value2} per transaction'**
  String legacyUi68401f3c9e(Object value1, Object value2);

  /// No description provided for @legacyUi526698fef7.
  ///
  /// In en, this message translates to:
  /// **'Unable to refresh vehicles.'**
  String get legacyUi526698fef7;

  /// No description provided for @legacyUie9b7179dd3.
  ///
  /// In en, this message translates to:
  /// **'Documents ({value1})'**
  String legacyUie9b7179dd3(Object value1);

  /// No description provided for @legacyUiefd8314874.
  ///
  /// In en, this message translates to:
  /// **'Unable to refresh documents.'**
  String get legacyUiefd8314874;

  /// No description provided for @legacyUie214b8a299.
  ///
  /// In en, this message translates to:
  /// **'Document'**
  String get legacyUie214b8a299;

  /// No description provided for @legacyUidb4675bc22.
  ///
  /// In en, this message translates to:
  /// **'Balance {value1}'**
  String legacyUidb4675bc22(Object value1);

  /// No description provided for @legacyUi16be827cb6.
  ///
  /// In en, this message translates to:
  /// **'Vehicle {value1}'**
  String legacyUi16be827cb6(Object value1);

  /// No description provided for @legacyUibd5caf1601.
  ///
  /// In en, this message translates to:
  /// **'Tracking is blocked by the software license limit.'**
  String get legacyUibd5caf1601;

  /// No description provided for @legacyUid8663517be.
  ///
  /// In en, this message translates to:
  /// **'Last check: —'**
  String get legacyUid8663517be;

  /// No description provided for @legacyUi1be0035c25.
  ///
  /// In en, this message translates to:
  /// **'Own'**
  String get legacyUi1be0035c25;

  /// No description provided for @legacyUi5f1184f7df.
  ///
  /// In en, this message translates to:
  /// **'Global'**
  String get legacyUi5f1184f7df;

  /// No description provided for @legacyUif5f940cfe2.
  ///
  /// In en, this message translates to:
  /// **'Save permissions'**
  String get legacyUif5f940cfe2;

  /// No description provided for @legacyUi8a9135d5ad.
  ///
  /// In en, this message translates to:
  /// **'{value1}% collected'**
  String legacyUi8a9135d5ad(Object value1);

  /// No description provided for @legacyUi3b0c54fa00.
  ///
  /// In en, this message translates to:
  /// **'Projected {value1}'**
  String legacyUi3b0c54fa00(Object value1);

  /// No description provided for @legacyUi16ff2e7fa9.
  ///
  /// In en, this message translates to:
  /// **'Delta {value1}'**
  String legacyUi16ff2e7fa9(Object value1);

  /// No description provided for @legacyUi4956298616.
  ///
  /// In en, this message translates to:
  /// **'{value1} veh · {value2}'**
  String legacyUi4956298616(Object value1, Object value2);

  /// No description provided for @legacyUi120d777276.
  ///
  /// In en, this message translates to:
  /// **'Paid {value1}'**
  String legacyUi120d777276(Object value1);

  /// No description provided for @legacyUi617d0ebe3d.
  ///
  /// In en, this message translates to:
  /// **'{value1} of {value2} plans'**
  String legacyUi617d0ebe3d(Object value1, Object value2);

  /// No description provided for @legacyUi25422daedb.
  ///
  /// In en, this message translates to:
  /// **'Untitled Vehicle'**
  String get legacyUi25422daedb;

  /// No description provided for @legacyUicbbe928bb9.
  ///
  /// In en, this message translates to:
  /// **'Annual coverage: {value1}'**
  String legacyUicbbe928bb9(Object value1);

  /// No description provided for @legacyUiec60ebb81f.
  ///
  /// In en, this message translates to:
  /// **'Customer service: {value1}'**
  String legacyUiec60ebb81f(Object value1);

  /// No description provided for @legacyUiced28bc228.
  ///
  /// In en, this message translates to:
  /// **'Account credits: {value1}'**
  String legacyUiced28bc228(Object value1);

  /// No description provided for @legacyUic1a90693df.
  ///
  /// In en, this message translates to:
  /// **'Live tracking active'**
  String get legacyUic1a90693df;

  /// No description provided for @legacyUi4bdc33e519.
  ///
  /// In en, this message translates to:
  /// **'{value1} · {value2} days'**
  String legacyUi4bdc33e519(Object value1, Object value2);

  /// No description provided for @legacyUi889f282a7d.
  ///
  /// In en, this message translates to:
  /// **'Choose date and time'**
  String get legacyUi889f282a7d;

  /// No description provided for @legacyUi83cbbbc297.
  ///
  /// In en, this message translates to:
  /// **'Save service changes'**
  String get legacyUi83cbbbc297;

  /// No description provided for @legacyUi69feaaf8cd.
  ///
  /// In en, this message translates to:
  /// **'All dates'**
  String get legacyUi69feaaf8cd;

  /// No description provided for @legacyUi0c6c4102d4.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get legacyUi0c6c4102d4;

  /// No description provided for @legacyUic57882f9c9.
  ///
  /// In en, this message translates to:
  /// **'Status: {value1}'**
  String legacyUic57882f9c9(Object value1);

  /// No description provided for @legacyUiae3c1f8817.
  ///
  /// In en, this message translates to:
  /// **'Send this command to {value1}?'**
  String legacyUiae3c1f8817(Object value1);

  /// No description provided for @legacyUic51f739b4e.
  ///
  /// In en, this message translates to:
  /// **'Assigned Users ({value1})'**
  String legacyUic51f739b4e(Object value1);

  /// No description provided for @legacyUibc7819b34f.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get legacyUibc7819b34f;

  /// No description provided for @legacyUi46aece3259.
  ///
  /// In en, this message translates to:
  /// **'Remove {value1} from this vehicle?'**
  String legacyUi46aece3259(Object value1);

  /// No description provided for @legacyUi3d2bb84b75.
  ///
  /// In en, this message translates to:
  /// **'Live Value: {value1} {value2}'**
  String legacyUi3d2bb84b75(Object value1, Object value2);

  /// No description provided for @legacyUieb3a3daafa.
  ///
  /// In en, this message translates to:
  /// **'Code: {value1}'**
  String legacyUieb3a3daafa(Object value1);

  /// No description provided for @legacyUi93aa5178d6.
  ///
  /// In en, this message translates to:
  /// **'Document type: {value1}'**
  String legacyUi93aa5178d6(Object value1);

  /// No description provided for @legacyUi0e12da1c5e.
  ///
  /// In en, this message translates to:
  /// **'File: {value1}'**
  String legacyUi0e12da1c5e(Object value1);

  /// No description provided for @legacyUi3ce1585208.
  ///
  /// In en, this message translates to:
  /// **'Expiry: {value1}'**
  String legacyUi3ce1585208(Object value1);

  /// No description provided for @legacyUiaeafae8a12.
  ///
  /// In en, this message translates to:
  /// **'Visibility: {value1}'**
  String legacyUiaeafae8a12(Object value1);

  /// No description provided for @legacyUi39d7217391.
  ///
  /// In en, this message translates to:
  /// **'Tags: {value1}'**
  String legacyUi39d7217391(Object value1);

  /// No description provided for @legacyUi4439ddf5a2.
  ///
  /// In en, this message translates to:
  /// **'Created: {value1}'**
  String legacyUi4439ddf5a2(Object value1);

  /// No description provided for @legacyUid5c6adaee3.
  ///
  /// In en, this message translates to:
  /// **'Remove {value1} from this driver?'**
  String legacyUid5c6adaee3(Object value1);

  /// No description provided for @legacyUieb7eb7a819.
  ///
  /// In en, this message translates to:
  /// **'Choose file'**
  String get legacyUieb7eb7a819;

  /// No description provided for @legacyUi8f8dd8dbd3.
  ///
  /// In en, this message translates to:
  /// **'Hidden from admin'**
  String get legacyUi8f8dd8dbd3;

  /// No description provided for @legacyUi65d06317e9.
  ///
  /// In en, this message translates to:
  /// **'Admin users can see this document'**
  String get legacyUi65d06317e9;

  /// No description provided for @legacyUic0e9577a75.
  ///
  /// In en, this message translates to:
  /// **'Only owner can see'**
  String get legacyUic0e9577a75;

  /// No description provided for @legacyUi864cf8bc08.
  ///
  /// In en, this message translates to:
  /// **'Attributes: {value1}'**
  String legacyUi864cf8bc08(Object value1);

  /// No description provided for @legacyUi90d40c4249.
  ///
  /// In en, this message translates to:
  /// **'Raw: {value1}'**
  String legacyUi90d40c4249(Object value1);

  /// No description provided for @legacyUia4d06ed284.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Event'**
  String get legacyUia4d06ed284;

  /// No description provided for @legacyUifba61e1a50.
  ///
  /// In en, this message translates to:
  /// **'{value1} • {value2} • sent {value3} • delivered {value4} • retry {value5}{value6}'**
  String legacyUifba61e1a50(Object value1, Object value2, Object value3,
      Object value4, Object value5, Object value6);

  /// No description provided for @legacyUi9c07a085f8.
  ///
  /// In en, this message translates to:
  /// **'{value1} of {value2} transactions'**
  String legacyUi9c07a085f8(Object value1, Object value2);

  /// No description provided for @legacyUi26b3b5dfb3.
  ///
  /// In en, this message translates to:
  /// **'{value1} Retry'**
  String legacyUi26b3b5dfb3(Object value1);

  /// No description provided for @legacyUi05563fda41.
  ///
  /// In en, this message translates to:
  /// **'Plan: {value1} • {value2} {value3}'**
  String legacyUi05563fda41(Object value1, Object value2, Object value3);

  /// No description provided for @legacyUi26400a7353.
  ///
  /// In en, this message translates to:
  /// **'{value1} vehicle{value2} selected'**
  String legacyUi26400a7353(Object value1, Object value2);

  /// No description provided for @legacyUi8f4ab245d3.
  ///
  /// In en, this message translates to:
  /// **'Auto Total: {value1} {value2}'**
  String legacyUi8f4ab245d3(Object value1, Object value2);

  /// No description provided for @legacyUi493de0b548.
  ///
  /// In en, this message translates to:
  /// **'Quote expired'**
  String get legacyUi493de0b548;

  /// No description provided for @legacyUi78218dbd5f.
  ///
  /// In en, this message translates to:
  /// **'{value1} · {value2} · {value3} days'**
  String legacyUi78218dbd5f(Object value1, Object value2, Object value3);

  /// No description provided for @legacyUi13e7357d18.
  ///
  /// In en, this message translates to:
  /// **'I received {value1}'**
  String legacyUi13e7357d18(Object value1);

  /// No description provided for @legacyUi7e72a446c4.
  ///
  /// In en, this message translates to:
  /// **'Hide payment filters'**
  String get legacyUi7e72a446c4;

  /// No description provided for @legacyUi8f642c1d28.
  ///
  /// In en, this message translates to:
  /// **'Show payment filters'**
  String get legacyUi8f642c1d28;

  /// No description provided for @legacyUi184c3f0cbb.
  ///
  /// In en, this message translates to:
  /// **'Transaction ID: {value1}'**
  String legacyUi184c3f0cbb(Object value1);

  /// No description provided for @legacyUi281961b9ee.
  ///
  /// In en, this message translates to:
  /// **'Amount: {value1}'**
  String legacyUi281961b9ee(Object value1);

  /// No description provided for @legacyUib40416c0af.
  ///
  /// In en, this message translates to:
  /// **'Payment Type: {value1}'**
  String legacyUib40416c0af(Object value1);

  /// No description provided for @legacyUia0d65517a6.
  ///
  /// In en, this message translates to:
  /// **'Payment Mode: {value1}'**
  String legacyUia0d65517a6(Object value1);

  /// No description provided for @legacyUic2d62e9f71.
  ///
  /// In en, this message translates to:
  /// **'Reference: {value1}'**
  String legacyUic2d62e9f71(Object value1);

  /// No description provided for @legacyUib0f627962a.
  ///
  /// In en, this message translates to:
  /// **'Provider: {value1}'**
  String legacyUib0f627962a(Object value1);

  /// No description provided for @legacyUie802a1b0a0.
  ///
  /// In en, this message translates to:
  /// **'Provider Ref: {value1}'**
  String legacyUie802a1b0a0(Object value1);

  /// No description provided for @legacyUi2751887374.
  ///
  /// In en, this message translates to:
  /// **'From: {value1}'**
  String legacyUi2751887374(Object value1);

  /// No description provided for @legacyUi250106ee83.
  ///
  /// In en, this message translates to:
  /// **'To: {value1}'**
  String legacyUi250106ee83(Object value1);

  /// No description provided for @legacyUi5ff8e9357b.
  ///
  /// In en, this message translates to:
  /// **'Recorded By: {value1}'**
  String legacyUi5ff8e9357b(Object value1);

  /// No description provided for @legacyUi7565bbdff9.
  ///
  /// In en, this message translates to:
  /// **'Vehicle: {value1}'**
  String legacyUi7565bbdff9(Object value1);

  /// No description provided for @legacyUi2b542f8050.
  ///
  /// In en, this message translates to:
  /// **'IMEI: {value1}'**
  String legacyUi2b542f8050(Object value1);

  /// No description provided for @legacyUi76e24a00cf.
  ///
  /// In en, this message translates to:
  /// **'Plan: {value1}'**
  String legacyUi76e24a00cf(Object value1);

  /// No description provided for @legacyUi972db7d65e.
  ///
  /// In en, this message translates to:
  /// **'Failure Code: {value1}'**
  String legacyUi972db7d65e(Object value1);

  /// No description provided for @legacyUif147c11396.
  ///
  /// In en, this message translates to:
  /// **'Failure Message: {value1}'**
  String legacyUif147c11396(Object value1);

  /// No description provided for @legacyUic3146cdbec.
  ///
  /// In en, this message translates to:
  /// **'Create a ticket to start a support conversation.'**
  String get legacyUic3146cdbec;

  /// No description provided for @legacyUi2cbdc50885.
  ///
  /// In en, this message translates to:
  /// **'Remove {value1} from this administrator account?'**
  String legacyUi2cbdc50885(Object value1);

  /// No description provided for @legacyUi073ab8a05c.
  ///
  /// In en, this message translates to:
  /// **'{value1} assigned - {value2} available'**
  String legacyUi073ab8a05c(Object value1, Object value2);

  /// No description provided for @legacyUidcc59f9fcf.
  ///
  /// In en, this message translates to:
  /// **'Select {value1}'**
  String legacyUidcc59f9fcf(Object value1);

  /// No description provided for @legacyUi7a19b6deae.
  ///
  /// In en, this message translates to:
  /// **'No options available'**
  String get legacyUi7a19b6deae;

  /// No description provided for @legacyUif28cfb8eb0.
  ///
  /// In en, this message translates to:
  /// **'1 ticket'**
  String get legacyUif28cfb8eb0;

  /// No description provided for @legacyUidf08f563b7.
  ///
  /// In en, this message translates to:
  /// **'Optional files, up to {value1}.'**
  String legacyUidf08f563b7(Object value1);

  /// No description provided for @legacyUi5f2b4010d1.
  ///
  /// In en, this message translates to:
  /// **'1 payment'**
  String get legacyUi5f2b4010d1;

  /// No description provided for @legacyUi876081608a.
  ///
  /// In en, this message translates to:
  /// **'Renewal — 1 vehicle'**
  String get legacyUi876081608a;

  /// No description provided for @legacyUia034f3f5e5.
  ///
  /// In en, this message translates to:
  /// **'Estimated total {value1}'**
  String legacyUia034f3f5e5(Object value1);

  /// No description provided for @legacyUic07d143675.
  ///
  /// In en, this message translates to:
  /// **'Renewed Vehicles ({value1})'**
  String legacyUic07d143675(Object value1);

  /// No description provided for @legacyUiff384c8aa4.
  ///
  /// In en, this message translates to:
  /// **'Remove {value1} from this user?'**
  String legacyUiff384c8aa4(Object value1);

  /// No description provided for @legacyUicb6d241451.
  ///
  /// In en, this message translates to:
  /// **'{value1} files - {value2} user types'**
  String legacyUicb6d241451(Object value1, Object value2);

  /// No description provided for @legacyUif63f04564a.
  ///
  /// In en, this message translates to:
  /// **'Loading user types'**
  String get legacyUif63f04564a;

  /// No description provided for @legacyUi74b1d89d85.
  ///
  /// In en, this message translates to:
  /// **'Choose a file'**
  String get legacyUi74b1d89d85;

  /// No description provided for @legacyUi62783d600b.
  ///
  /// In en, this message translates to:
  /// **'Shown in user documents'**
  String get legacyUi62783d600b;

  /// No description provided for @legacyUi38fc177e28.
  ///
  /// In en, this message translates to:
  /// **'Hidden from user'**
  String get legacyUi38fc177e28;

  /// No description provided for @legacyUibce346e856.
  ///
  /// In en, this message translates to:
  /// **'{value1} User{value2}'**
  String legacyUibce346e856(Object value1, Object value2);

  /// No description provided for @legacyUi674b652fca.
  ///
  /// In en, this message translates to:
  /// **'Change dates'**
  String get legacyUi674b652fca;

  /// No description provided for @legacyUi08d0e4f72a.
  ///
  /// In en, this message translates to:
  /// **'Loading transactions…'**
  String get legacyUi08d0e4f72a;

  /// No description provided for @legacyUib3a56d64d2.
  ///
  /// In en, this message translates to:
  /// **'No transactions match these filters.'**
  String get legacyUib3a56d64d2;

  /// No description provided for @legacyUi049ac820da.
  ///
  /// In en, this message translates to:
  /// **'Working...'**
  String get legacyUi049ac820da;

  /// No description provided for @legacyUie783127bc1.
  ///
  /// In en, this message translates to:
  /// **'Joined {value1}'**
  String legacyUie783127bc1(Object value1);

  /// No description provided for @legacyUieb587f7802.
  ///
  /// In en, this message translates to:
  /// **'Profile updated {value1}'**
  String legacyUieb587f7802(Object value1);

  /// No description provided for @legacyUi1dfc507715.
  ///
  /// In en, this message translates to:
  /// **'Country and mobile prefix references are unavailable. You can still edit manually.'**
  String get legacyUi1dfc507715;

  /// No description provided for @legacyUia7c1498ab2.
  ///
  /// In en, this message translates to:
  /// **'You are subscribed to profile email notifications.'**
  String get legacyUia7c1498ab2;

  /// No description provided for @legacyUi77653a7db4.
  ///
  /// In en, this message translates to:
  /// **'Subscribe to receive profile and account email updates.'**
  String get legacyUi77653a7db4;

  /// No description provided for @legacyUid3b8add13e.
  ///
  /// In en, this message translates to:
  /// **'Options unavailable.'**
  String get legacyUid3b8add13e;

  /// No description provided for @legacyUi08b544b680.
  ///
  /// In en, this message translates to:
  /// **'Driven {value1}'**
  String legacyUi08b544b680(Object value1);

  /// No description provided for @legacyUi6c783ae69f.
  ///
  /// In en, this message translates to:
  /// **'Showing 10 of {value1} latest alerts'**
  String legacyUi6c783ae69f(Object value1);

  /// No description provided for @legacyUi45ef37a941.
  ///
  /// In en, this message translates to:
  /// **'No message provided.'**
  String get legacyUi45ef37a941;

  /// No description provided for @legacyUia2ae39a298.
  ///
  /// In en, this message translates to:
  /// **'Channel unknown'**
  String get legacyUia2ae39a298;

  /// No description provided for @legacyUiceafde86d6.
  ///
  /// In en, this message translates to:
  /// **'Sending'**
  String get legacyUiceafde86d6;

  /// No description provided for @legacyUi46cefb25e2.
  ///
  /// In en, this message translates to:
  /// **'Send command'**
  String get legacyUi46cefb25e2;

  /// No description provided for @legacyUib3d1704245.
  ///
  /// In en, this message translates to:
  /// **'Day window: {value1}'**
  String legacyUib3d1704245(Object value1);

  /// No description provided for @legacyUi735f148a9a.
  ///
  /// In en, this message translates to:
  /// **'type: {value1}'**
  String legacyUi735f148a9a(Object value1);

  /// No description provided for @legacyUi828a91effc.
  ///
  /// In en, this message translates to:
  /// **'{value1} of {value2} vehicles • {value3} selected'**
  String legacyUi828a91effc(Object value1, Object value2, Object value3);

  /// No description provided for @legacyUia0ebdc2307.
  ///
  /// In en, this message translates to:
  /// **'{value1} visible • {value2}/{value3} loaded'**
  String legacyUia0ebdc2307(Object value1, Object value2, Object value3);

  /// No description provided for @legacyUi1d483a1343.
  ///
  /// In en, this message translates to:
  /// **'Remove {value1} from this sub user?'**
  String legacyUi1d483a1343(Object value1);

  /// No description provided for @legacyUi02b84d460d.
  ///
  /// In en, this message translates to:
  /// **'{value1} available to assign'**
  String legacyUi02b84d460d(Object value1);

  /// No description provided for @legacyUi65ad788d45.
  ///
  /// In en, this message translates to:
  /// **'Plate unavailable'**
  String get legacyUi65ad788d45;

  /// No description provided for @legacyUi7bb4f2808b.
  ///
  /// In en, this message translates to:
  /// **'Sub user can access assigned vehicles'**
  String get legacyUi7bb4f2808b;

  /// No description provided for @legacyUi26b21a0d91.
  ///
  /// In en, this message translates to:
  /// **'Sub user is disabled'**
  String get legacyUi26b21a0d91;

  /// No description provided for @legacyUibceb1630f0.
  ///
  /// In en, this message translates to:
  /// **'{value1} files - {value2} document types'**
  String legacyUibceb1630f0(Object value1, Object value2);

  /// No description provided for @legacyUi107b9056eb.
  ///
  /// In en, this message translates to:
  /// **'Loading driver types'**
  String get legacyUi107b9056eb;

  /// No description provided for @legacyUifd7e37cf51.
  ///
  /// In en, this message translates to:
  /// **'{value1} of {value2} drivers'**
  String legacyUifd7e37cf51(Object value1, Object value2);

  /// No description provided for @legacyUi14b274c7ae.
  ///
  /// In en, this message translates to:
  /// **'{value1} of {value2} vehicles'**
  String legacyUi14b274c7ae(Object value1, Object value2);

  /// No description provided for @legacyUi79a100acf7.
  ///
  /// In en, this message translates to:
  /// **'Remove {value1}?'**
  String legacyUi79a100acf7(Object value1);

  /// No description provided for @legacyUi26875fe2e3.
  ///
  /// In en, this message translates to:
  /// **'{value1} files - {value2} vehicle types'**
  String legacyUi26875fe2e3(Object value1, Object value2);

  /// No description provided for @legacyUi7970bd3e0b.
  ///
  /// In en, this message translates to:
  /// **'{value1} could not be loaded.'**
  String legacyUi7970bd3e0b(Object value1);

  /// No description provided for @legacyUi5eaf2646c3.
  ///
  /// In en, this message translates to:
  /// **'Loading vehicle types'**
  String get legacyUi5eaf2646c3;

  /// No description provided for @legacyUi6ca60537ae.
  ///
  /// In en, this message translates to:
  /// **'Shown in vehicle documents'**
  String get legacyUi6ca60537ae;

  /// No description provided for @legacyUi4e3d045a97.
  ///
  /// In en, this message translates to:
  /// **'Hidden from users'**
  String get legacyUi4e3d045a97;

  /// No description provided for @legacyUid3ce77345e.
  ///
  /// In en, this message translates to:
  /// **'Sensor history'**
  String get legacyUid3ce77345e;

  /// No description provided for @legacyUi5aba89cd2f.
  ///
  /// In en, this message translates to:
  /// **'{value1} numeric points'**
  String legacyUi5aba89cd2f(Object value1);

  /// No description provided for @legacyUie86a33f16a.
  ///
  /// In en, this message translates to:
  /// **'All geofences'**
  String get legacyUie86a33f16a;

  /// No description provided for @legacyUi5321a316d0.
  ///
  /// In en, this message translates to:
  /// **'Source: {value1}'**
  String legacyUi5321a316d0(Object value1);

  /// No description provided for @legacyUifabeb88d9c.
  ///
  /// In en, this message translates to:
  /// **'Use {value1} selected'**
  String legacyUifabeb88d9c(Object value1);

  /// No description provided for @legacyUi343ceded71.
  ///
  /// In en, this message translates to:
  /// **'Events by Geofence (top {value1})'**
  String legacyUi343ceded71(Object value1);

  /// No description provided for @legacyUide36170209.
  ///
  /// In en, this message translates to:
  /// **'Alert Types (top {value1})'**
  String legacyUide36170209(Object value1);

  /// No description provided for @legacyUi019e5212ef.
  ///
  /// In en, this message translates to:
  /// **'{value1} km/h (limit {value2})'**
  String legacyUi019e5212ef(Object value1, Object value2);

  /// No description provided for @legacyUicaae0add4a.
  ///
  /// In en, this message translates to:
  /// **'{value1} active day{value2}'**
  String legacyUicaae0add4a(Object value1, Object value2);

  /// No description provided for @legacyUi7911e1ad0c.
  ///
  /// In en, this message translates to:
  /// **'{value1} result{value2}'**
  String legacyUi7911e1ad0c(Object value1, Object value2);

  /// No description provided for @legacyUi15b175bbc9.
  ///
  /// In en, this message translates to:
  /// **'Generated at {value1}'**
  String legacyUi15b175bbc9(Object value1);

  /// No description provided for @legacyUi92a50db48d.
  ///
  /// In en, this message translates to:
  /// **'Export {value1} Report'**
  String legacyUi92a50db48d(Object value1);

  /// No description provided for @legacyUida6472ea1a.
  ///
  /// In en, this message translates to:
  /// **'All {value1} vehicles will be included'**
  String legacyUida6472ea1a(Object value1);

  /// No description provided for @legacyUib0c379b2f8.
  ///
  /// In en, this message translates to:
  /// **'Select a vehicle group'**
  String get legacyUib0c379b2f8;

  /// No description provided for @legacyUi23d6943e8b.
  ///
  /// In en, this message translates to:
  /// **'Select Vehicles'**
  String get legacyUi23d6943e8b;

  /// No description provided for @legacyUi47b7508acb.
  ///
  /// In en, this message translates to:
  /// **'Done ({value1})'**
  String legacyUi47b7508acb(Object value1);

  /// No description provided for @legacyUid495bed9d8.
  ///
  /// In en, this message translates to:
  /// **'Select all visible ({value1})'**
  String legacyUid495bed9d8(Object value1);

  /// No description provided for @legacyUi096909f019.
  ///
  /// In en, this message translates to:
  /// **'{value1} vehicle{value2}'**
  String legacyUi096909f019(Object value1, Object value2);

  /// No description provided for @legacyUie003b8a491.
  ///
  /// In en, this message translates to:
  /// **'Max {value1} days for this report type'**
  String legacyUie003b8a491(Object value1);

  /// No description provided for @legacyUif386fe6e70.
  ///
  /// In en, this message translates to:
  /// **'Clear ({value1})'**
  String legacyUif386fe6e70(Object value1);

  /// No description provided for @legacyUi706049c6a9.
  ///
  /// In en, this message translates to:
  /// **'Select a sensor'**
  String get legacyUi706049c6a9;

  /// No description provided for @legacyUi2841c7f501.
  ///
  /// In en, this message translates to:
  /// **'No reports found for \"{value1}\"'**
  String legacyUi2841c7f501(Object value1);

  /// No description provided for @legacyUi8002c1aa36.
  ///
  /// In en, this message translates to:
  /// **'Times use {value1}.'**
  String legacyUi8002c1aa36(Object value1);

  /// No description provided for @legacyUieaa190f343.
  ///
  /// In en, this message translates to:
  /// **'{value1} enabled'**
  String legacyUieaa190f343(Object value1);

  /// No description provided for @legacyUidc179fe07f.
  ///
  /// In en, this message translates to:
  /// **'Speed limit must be at least 1 {value1}.'**
  String legacyUidc179fe07f(Object value1);

  /// No description provided for @legacyUi11003e8471.
  ///
  /// In en, this message translates to:
  /// **'{value1} Delivery Channels'**
  String legacyUi11003e8471(Object value1);

  /// No description provided for @legacyUidc7454d672.
  ///
  /// In en, this message translates to:
  /// **'Last saved {value1}'**
  String legacyUidc7454d672(Object value1);

  /// No description provided for @legacyUi7968beb979.
  ///
  /// In en, this message translates to:
  /// **'Code -'**
  String get legacyUi7968beb979;

  /// No description provided for @legacyUi0528ad37c9.
  ///
  /// In en, this message translates to:
  /// **'{value1} of {value2} links'**
  String legacyUi0528ad37c9(Object value1, Object value2);

  /// No description provided for @legacyUiac2a036e38.
  ///
  /// In en, this message translates to:
  /// **'No activity yet'**
  String get legacyUiac2a036e38;

  /// No description provided for @legacyUi3a4361ec75.
  ///
  /// In en, this message translates to:
  /// **'\"{value1}\" will be permanently removed.'**
  String legacyUi3a4361ec75(Object value1);

  /// No description provided for @legacyUi50a9e13fce.
  ///
  /// In en, this message translates to:
  /// **'Untitled geofence'**
  String get legacyUi50a9e13fce;

  /// No description provided for @legacyUi760cb5d683.
  ///
  /// In en, this message translates to:
  /// **'{value1} point{value2}'**
  String legacyUi760cb5d683(Object value1, Object value2);

  /// No description provided for @legacyUifa6e784713.
  ///
  /// In en, this message translates to:
  /// **'Remove #{value1}'**
  String legacyUifa6e784713(Object value1);

  /// No description provided for @legacyUi27a25269f5.
  ///
  /// In en, this message translates to:
  /// **'Fine-adjust ({value1} m)'**
  String legacyUi27a25269f5(Object value1);

  /// No description provided for @legacyUi39706b5a17.
  ///
  /// In en, this message translates to:
  /// **'No geometry yet'**
  String get legacyUi39706b5a17;

  /// No description provided for @legacyUi1bf6cb6c45.
  ///
  /// In en, this message translates to:
  /// **'Geometry ready'**
  String get legacyUi1bf6cb6c45;

  /// No description provided for @legacyUi5d437ca98b.
  ///
  /// In en, this message translates to:
  /// **'Events will trigger for this geofence.'**
  String get legacyUi5d437ca98b;

  /// No description provided for @legacyUi6d8b4724c6.
  ///
  /// In en, this message translates to:
  /// **'Geofence is paused.'**
  String get legacyUi6d8b4724c6;

  /// No description provided for @legacyUi7e9f5c3026.
  ///
  /// In en, this message translates to:
  /// **'Draw at least 2 points on the map.'**
  String get legacyUi7e9f5c3026;

  /// No description provided for @legacyUi28134edb87.
  ///
  /// In en, this message translates to:
  /// **'Edit on map'**
  String get legacyUi28134edb87;

  /// No description provided for @legacyUi0f873fbc31.
  ///
  /// In en, this message translates to:
  /// **'Draw on map'**
  String get legacyUi0f873fbc31;

  /// No description provided for @legacyUi48f6c8c8ac.
  ///
  /// In en, this message translates to:
  /// **'{value1}m'**
  String legacyUi48f6c8c8ac(Object value1);

  /// No description provided for @legacyUicde59da67c.
  ///
  /// In en, this message translates to:
  /// **'{value1}min'**
  String legacyUicde59da67c(Object value1);

  /// No description provided for @legacyUi4bd1e22ea7.
  ///
  /// In en, this message translates to:
  /// **'Untitled route'**
  String get legacyUi4bd1e22ea7;

  /// No description provided for @legacyUi198f442dfb.
  ///
  /// In en, this message translates to:
  /// **'Vertex {value1}'**
  String legacyUi198f442dfb(Object value1);

  /// No description provided for @legacyUibae08b3767.
  ///
  /// In en, this message translates to:
  /// **'Row {value1}: {value2}'**
  String legacyUibae08b3767(Object value1, Object value2);

  /// No description provided for @legacyUi93039e609d.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get legacyUi93039e609d;

  /// No description provided for @legacyUid33a96e366.
  ///
  /// In en, this message translates to:
  /// **'Pick on map'**
  String get legacyUid33a96e366;

  /// No description provided for @legacyUiecd575d434.
  ///
  /// In en, this message translates to:
  /// **'Visible on live map and proximity alerts.'**
  String get legacyUiecd575d434;

  /// No description provided for @legacyUi92a172ce15.
  ///
  /// In en, this message translates to:
  /// **'Hidden from alerts; stays in the list.'**
  String get legacyUi92a172ce15;

  /// No description provided for @legacyUi8019307fe5.
  ///
  /// In en, this message translates to:
  /// **'Untitled POI'**
  String get legacyUi8019307fe5;

  /// No description provided for @legacyUid14e0c02a9.
  ///
  /// In en, this message translates to:
  /// **'Live tracking available'**
  String get legacyUid14e0c02a9;

  /// No description provided for @legacyUic814ea2b6e.
  ///
  /// In en, this message translates to:
  /// **'Service starts: {value1}'**
  String legacyUic814ea2b6e(Object value1);

  /// No description provided for @legacyUic926abedfd.
  ///
  /// In en, this message translates to:
  /// **'Customer service expires: {value1}'**
  String legacyUic926abedfd(Object value1);

  /// No description provided for @legacyUiae0052da76.
  ///
  /// In en, this message translates to:
  /// **'Provider coverage expires: {value1}'**
  String legacyUiae0052da76(Object value1);

  /// No description provided for @legacyUi633ec01c21.
  ///
  /// In en, this message translates to:
  /// **'{value1} • {value2} days'**
  String legacyUi633ec01c21(Object value1, Object value2);

  /// No description provided for @legacyUicf765512cc.
  ///
  /// In en, this message translates to:
  /// **'Sending…'**
  String get legacyUicf765512cc;

  /// No description provided for @legacyUi50756f98a3.
  ///
  /// In en, this message translates to:
  /// **'Request renewal'**
  String get legacyUi50756f98a3;

  /// No description provided for @legacyUid52adacef9.
  ///
  /// In en, this message translates to:
  /// **'Request #{value1}'**
  String legacyUid52adacef9(Object value1);

  /// No description provided for @legacyUicfeb791a76.
  ///
  /// In en, this message translates to:
  /// **'Expired request'**
  String get legacyUicfeb791a76;

  /// No description provided for @legacyUif0d8958371.
  ///
  /// In en, this message translates to:
  /// **'{value1}\n{value2} • {value3} days\n{value4} {value5}\n\nYour administrator must confirm payment before service is extended.'**
  String legacyUif0d8958371(Object value1, Object value2, Object value3,
      Object value4, Object value5);

  /// No description provided for @legacyUifdb17036d5.
  ///
  /// In en, this message translates to:
  /// **'OpenVTS User'**
  String get legacyUifdb17036d5;

  /// No description provided for @legacyUif7e83b3f19.
  ///
  /// In en, this message translates to:
  /// **'Reset to default ({value1})'**
  String legacyUif7e83b3f19(Object value1);

  /// No description provided for @legacyUi54e519da7f.
  ///
  /// In en, this message translates to:
  /// **'Error: {value1}'**
  String legacyUi54e519da7f(Object value1);

  /// No description provided for @legacyUi7eb29d3565.
  ///
  /// In en, this message translates to:
  /// **'Date & time'**
  String get legacyUi7eb29d3565;

  /// No description provided for @legacyUib1deb07e61.
  ///
  /// In en, this message translates to:
  /// **'Open Geofence'**
  String get legacyUib1deb07e61;

  /// No description provided for @legacyUi1dce4bf43b.
  ///
  /// In en, this message translates to:
  /// **'Open POI'**
  String get legacyUi1dce4bf43b;

  /// No description provided for @legacyUi4a0d050737.
  ///
  /// In en, this message translates to:
  /// **'Open Route'**
  String get legacyUi4a0d050737;

  /// No description provided for @legacyUib6bd42e4e7.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get legacyUib6bd42e4e7;

  /// No description provided for @legacyUi91edf8aff9.
  ///
  /// In en, this message translates to:
  /// **'On a trip'**
  String get legacyUi91edf8aff9;

  /// No description provided for @legacyUi20c7c5522f.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get legacyUi20c7c5522f;

  /// No description provided for @legacyUi0a2b58e839.
  ///
  /// In en, this message translates to:
  /// **'No assignment'**
  String get legacyUi0a2b58e839;

  /// No description provided for @legacyUi6cf3d41f08.
  ///
  /// In en, this message translates to:
  /// **'All trips'**
  String get legacyUi6cf3d41f08;

  /// No description provided for @legacyUif7a616a336.
  ///
  /// In en, this message translates to:
  /// **'Access blocked'**
  String get legacyUif7a616a336;

  /// No description provided for @legacyUiac7b5dd3a8.
  ///
  /// In en, this message translates to:
  /// **'Recipient unavailable'**
  String get legacyUiac7b5dd3a8;

  /// No description provided for @legacyUi936d2e8552.
  ///
  /// In en, this message translates to:
  /// **'Vehicle issue'**
  String get legacyUi936d2e8552;

  /// No description provided for @legacyUi51cea59031.
  ///
  /// In en, this message translates to:
  /// **'Route issue'**
  String get legacyUi51cea59031;

  /// No description provided for @legacyUia972b55b1a.
  ///
  /// In en, this message translates to:
  /// **'Describe the issue for dispatch.'**
  String get legacyUia972b55b1a;

  /// No description provided for @legacyUie0cdc02f99.
  ///
  /// In en, this message translates to:
  /// **'12-hour time'**
  String get legacyUie0cdc02f99;

  /// No description provided for @legacyUif910251f7c.
  ///
  /// In en, this message translates to:
  /// **'24-hour time'**
  String get legacyUif910251f7c;

  /// No description provided for @legacyUi34ce147724.
  ///
  /// In en, this message translates to:
  /// **'Left to right'**
  String get legacyUi34ce147724;

  /// No description provided for @legacyUida502a644e.
  ///
  /// In en, this message translates to:
  /// **'Right to left'**
  String get legacyUida502a644e;

  /// No description provided for @legacyUiec45717e13.
  ///
  /// In en, this message translates to:
  /// **'Contact dispatch for details.'**
  String get legacyUiec45717e13;

  /// No description provided for @legacyUi8a783eb3d6.
  ///
  /// In en, this message translates to:
  /// **'Assignment acknowledged.'**
  String get legacyUi8a783eb3d6;

  /// No description provided for @legacyUi00e1e19595.
  ///
  /// In en, this message translates to:
  /// **'Start trip'**
  String get legacyUi00e1e19595;

  /// No description provided for @legacyUi0015b1903d.
  ///
  /// In en, this message translates to:
  /// **'Trips normally start from vehicle telemetry. Use this manual fallback only when beginning the trip.'**
  String get legacyUi0015b1903d;

  /// No description provided for @legacyUib20bd98ae2.
  ///
  /// In en, this message translates to:
  /// **'Add remark'**
  String get legacyUib20bd98ae2;

  /// No description provided for @legacyUi42477e82cf.
  ///
  /// In en, this message translates to:
  /// **'Unable to open navigation.'**
  String get legacyUi42477e82cf;

  /// No description provided for @legacyUiea0bd6ff3d.
  ///
  /// In en, this message translates to:
  /// **'Complete stop'**
  String get legacyUiea0bd6ff3d;

  /// No description provided for @legacyUi3d93beaa39.
  ///
  /// In en, this message translates to:
  /// **'Select a non-empty file up to 5 MB.'**
  String get legacyUi3d93beaa39;

  /// No description provided for @legacyUid2085cce0d.
  ///
  /// In en, this message translates to:
  /// **'Select a file to upload.'**
  String get legacyUid2085cce0d;

  /// No description provided for @legacyUid0193e6956.
  ///
  /// In en, this message translates to:
  /// **'Select a document type.'**
  String get legacyUid0193e6956;

  /// No description provided for @legacyUif378218081.
  ///
  /// In en, this message translates to:
  /// **'Enter at least 2 characters.'**
  String get legacyUif378218081;

  /// No description provided for @legacyUi63f72dce85.
  ///
  /// In en, this message translates to:
  /// **'Select file'**
  String get legacyUi63f72dce85;

  /// No description provided for @legacyUi1255774559.
  ///
  /// In en, this message translates to:
  /// **'Assignments today'**
  String get legacyUi1255774559;

  /// No description provided for @legacyUi3528465759.
  ///
  /// In en, this message translates to:
  /// **'Completed trips'**
  String get legacyUi3528465759;

  /// No description provided for @legacyUi28793a4155.
  ///
  /// In en, this message translates to:
  /// **'Completed stops'**
  String get legacyUi28793a4155;

  /// No description provided for @legacyUi1683af6ce8.
  ///
  /// In en, this message translates to:
  /// **'Pending stops'**
  String get legacyUi1683af6ce8;

  /// No description provided for @mobilePluralTrips.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} trip} other{{count} trips}}'**
  String mobilePluralTrips(num count);

  /// No description provided for @mobilePluralBlockedVehicles.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} blocked vehicle excluded.} other{{count} blocked vehicles excluded.}}'**
  String mobilePluralBlockedVehicles(num count);

  /// No description provided for @mobilePluralSelectedVehicles.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} vehicle selected} other{{count} vehicles selected}}'**
  String mobilePluralSelectedVehicles(num count);

  /// No description provided for @mobilePluralUsers.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} User} other{{count} Users}}'**
  String mobilePluralUsers(num count);

  /// No description provided for @mobilePluralActiveDays.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} active day} other{{count} active days}}'**
  String mobilePluralActiveDays(num count);

  /// No description provided for @mobilePluralResults.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} result} other{{count} results}}'**
  String mobilePluralResults(num count);

  /// No description provided for @mobilePluralVehicles.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} vehicle} other{{count} vehicles}}'**
  String mobilePluralVehicles(num count);

  /// No description provided for @mobilePluralPoints.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} point} other{{count} points}}'**
  String mobilePluralPoints(num count);

  /// No description provided for @relativeJustNow.
  ///
  /// In en, this message translates to:
  /// **'just now'**
  String get relativeJustNow;

  /// No description provided for @relativeMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}m ago'**
  String relativeMinutesAgo(int count);

  /// No description provided for @relativeHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}h ago'**
  String relativeHoursAgo(int count);

  /// No description provided for @relativeDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}d ago'**
  String relativeDaysAgo(int count);

  /// No description provided for @relativeYesterday.
  ///
  /// In en, this message translates to:
  /// **'yesterday'**
  String get relativeYesterday;

  /// No description provided for @savingChangesForTab.
  ///
  /// In en, this message translates to:
  /// **'Saving {tab} changes...'**
  String savingChangesForTab(String tab);

  /// No description provided for @unsavedChangesForTab.
  ///
  /// In en, this message translates to:
  /// **'You have unsaved {tab} changes.'**
  String unsavedChangesForTab(String tab);

  /// No description provided for @saving.
  ///
  /// In en, this message translates to:
  /// **'Saving…'**
  String get saving;

  /// No description provided for @validationRequired.
  ///
  /// In en, this message translates to:
  /// **'{field} is required'**
  String validationRequired(String field);

  /// No description provided for @validationAscii.
  ///
  /// In en, this message translates to:
  /// **'{field} must contain ASCII characters only'**
  String validationAscii(String field);

  /// No description provided for @validationMinCharacters.
  ///
  /// In en, this message translates to:
  /// **'{field} must be at least {count} characters'**
  String validationMinCharacters(String field, int count);

  /// No description provided for @validationMaxCharacters.
  ///
  /// In en, this message translates to:
  /// **'{field} must be {count} characters or fewer'**
  String validationMaxCharacters(String field, int count);

  /// No description provided for @validationMinDigits.
  ///
  /// In en, this message translates to:
  /// **'{field} must be at least {count} digits'**
  String validationMinDigits(String field, int count);

  /// No description provided for @validationMaxDigits.
  ///
  /// In en, this message translates to:
  /// **'{field} must be {count} digits or fewer'**
  String validationMaxDigits(String field, int count);

  /// No description provided for @validationNumeric.
  ///
  /// In en, this message translates to:
  /// **'{field} must be numeric'**
  String validationNumeric(String field);

  /// No description provided for @validationMinimumCharacters.
  ///
  /// In en, this message translates to:
  /// **'Minimum {count} characters'**
  String validationMinimumCharacters(int count);

  /// No description provided for @validationValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get validationValidEmail;

  /// No description provided for @validationValidNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid number'**
  String get validationValidNumber;

  /// No description provided for @validationNonnegativeCredits.
  ///
  /// In en, this message translates to:
  /// **'Credits cannot be negative'**
  String get validationNonnegativeCredits;

  /// No description provided for @validationConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Please confirm the password'**
  String get validationConfirmPassword;

  /// No description provided for @validationPasswordsMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get validationPasswordsMismatch;

  /// No description provided for @validationStandardVin.
  ///
  /// In en, this message translates to:
  /// **'VIN must be 17 alphanumeric characters (excluding I, O, Q)'**
  String get validationStandardVin;

  /// No description provided for @validationVinAlphanumeric.
  ///
  /// In en, this message translates to:
  /// **'VIN must contain only letters and numbers'**
  String get validationVinAlphanumeric;

  /// No description provided for @validationThisField.
  ///
  /// In en, this message translates to:
  /// **'This field'**
  String get validationThisField;

  /// No description provided for @validationFieldSimNumber.
  ///
  /// In en, this message translates to:
  /// **'SIM number'**
  String get validationFieldSimNumber;

  /// No description provided for @mobileDataBackup.
  ///
  /// In en, this message translates to:
  /// **'Data Backup'**
  String get mobileDataBackup;

  /// No description provided for @mobileEffectiveRetention.
  ///
  /// In en, this message translates to:
  /// **'Effective retention'**
  String get mobileEffectiveRetention;

  /// No description provided for @mobileAdministratorLimit.
  ///
  /// In en, this message translates to:
  /// **'Administrator limit'**
  String get mobileAdministratorLimit;

  /// No description provided for @mobilePolicySource.
  ///
  /// In en, this message translates to:
  /// **'Policy source'**
  String get mobilePolicySource;

  /// No description provided for @mobileUseAdministratorPolicy.
  ///
  /// In en, this message translates to:
  /// **'Use administrator policy ({value1})'**
  String mobileUseAdministratorPolicy(String value1);

  /// No description provided for @mobileRetentionCleanupNotice.
  ///
  /// In en, this message translates to:
  /// **'Historical telemetry older than the retention period is removed by scheduled cleanup. Increasing retention does not restore deleted data.'**
  String get mobileRetentionCleanupNotice;

  /// No description provided for @mobileRetentionLimitError.
  ///
  /// In en, this message translates to:
  /// **'The retention period cannot exceed {value1} days.'**
  String mobileRetentionLimitError(String value1);

  /// No description provided for @mobileRetentionLoadError.
  ///
  /// In en, this message translates to:
  /// **'Unable to load data retention'**
  String get mobileRetentionLoadError;

  /// No description provided for @mobileRetentionSaveError.
  ///
  /// In en, this message translates to:
  /// **'Unable to save data retention'**
  String get mobileRetentionSaveError;

  /// No description provided for @mobileRetentionSaved.
  ///
  /// In en, this message translates to:
  /// **'Data retention updated'**
  String get mobileRetentionSaved;

  /// No description provided for @mobileRetentionUnsupported.
  ///
  /// In en, this message translates to:
  /// **'The server returned an unsupported retention policy. Editing is disabled.'**
  String get mobileRetentionUnsupported;

  /// No description provided for @mobileDiscardDetailChanges.
  ///
  /// In en, this message translates to:
  /// **'Changes will be lost. Continue?'**
  String get mobileDiscardDetailChanges;

  /// No description provided for @mobileLiveTrackingReconnecting.
  ///
  /// In en, this message translates to:
  /// **'Live tracking reconnecting…'**
  String get mobileLiveTrackingReconnecting;

  /// No description provided for @mobileLastConnection.
  ///
  /// In en, this message translates to:
  /// **'Last connection'**
  String get mobileLastConnection;

  /// No description provided for @mobileTeamLoadError.
  ///
  /// In en, this message translates to:
  /// **'Team could not be loaded.'**
  String get mobileTeamLoadError;

  /// No description provided for @mobilePermissionsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Permissions could not be loaded.'**
  String get mobilePermissionsLoadError;

  /// No description provided for @mobileActivityLoadError.
  ///
  /// In en, this message translates to:
  /// **'Activity could not be loaded.'**
  String get mobileActivityLoadError;

  /// No description provided for @mobilePermissionsRetryError.
  ///
  /// In en, this message translates to:
  /// **'Unable to load or save permissions. Please try again.'**
  String get mobilePermissionsRetryError;

  /// No description provided for @mobilePermissionMaps.
  ///
  /// In en, this message translates to:
  /// **'Maps'**
  String get mobilePermissionMaps;

  /// No description provided for @mobilePermissionLandmarks.
  ///
  /// In en, this message translates to:
  /// **'Landmarks'**
  String get mobilePermissionLandmarks;

  /// No description provided for @mobilePermissionShareTracking.
  ///
  /// In en, this message translates to:
  /// **'Share tracking link'**
  String get mobilePermissionShareTracking;

  /// No description provided for @mobilePrivacyPolicyLink.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get mobilePrivacyPolicyLink;

  /// No description provided for @mobilePageLinkError.
  ///
  /// In en, this message translates to:
  /// **'Unable to open this page. Please try again.'**
  String get mobilePageLinkError;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'ar',
        'en',
        'es',
        'fr',
        'hi',
        'pt'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
