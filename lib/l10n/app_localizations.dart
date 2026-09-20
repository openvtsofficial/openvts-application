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
