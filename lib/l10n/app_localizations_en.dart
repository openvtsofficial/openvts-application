// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get date => 'Date';

  @override
  String get time => 'Time';

  @override
  String get direction => 'Direction';

  @override
  String get units => 'Units';

  @override
  String get appTitle => 'OpenVTS';

  @override
  String get settings => 'Settings';

  @override
  String get localization => 'Localization';

  @override
  String get language => 'Language';

  @override
  String get theme => 'Theme';

  @override
  String get dateFormat => 'Date Format';

  @override
  String get timeFormat => 'Time Format';

  @override
  String get timezone => 'Timezone';

  @override
  String get use24Hour => '24-Hour Time';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get edit => 'Edit';

  @override
  String get search => 'Search';

  @override
  String get delete => 'Delete';

  @override
  String get reset => 'Reset';

  @override
  String get close => 'Close';

  @override
  String get back => 'Back';

  @override
  String get next => 'Next';

  @override
  String get prev => 'Previous';

  @override
  String get loading => 'Loading...';

  @override
  String get error => 'Error';

  @override
  String get success => 'Success';

  @override
  String get warning => 'Warning';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get system => 'System';

  @override
  String get en => 'English';

  @override
  String get hi => 'Hindi';

  @override
  String get ar => 'Arabic';

  @override
  String get es => 'Spanish';

  @override
  String get fr => 'French';

  @override
  String get pt => 'Portuguese';

  @override
  String get profile => 'Profile';

  @override
  String get logout => 'Logout';

  @override
  String get login => 'Login';

  @override
  String get register => 'Register';

  @override
  String get administrators => 'Administrators';

  @override
  String get payments => 'Payments';

  @override
  String get support => 'Support';

  @override
  String get tickets => 'Tickets';

  @override
  String get home => 'Home';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get keepEditing => 'Keep Editing';

  @override
  String get discardChanges => 'Discard Changes';

  @override
  String get unsavedChanges => 'Unsaved changes';

  @override
  String get refresh => 'Refresh';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get selectTheme => 'Select Theme';

  @override
  String get selectDateFormat => 'Select Date Format';

  @override
  String get selectTimeFormat => 'Select Time Format';

  @override
  String get selectTimezone => 'Select Timezone';

  @override
  String previewDate(String date) {
    return 'Preview: $date';
  }

  @override
  String previewTime(String time) {
    return 'Preview: $time';
  }

  @override
  String get settingsUpdated => 'Settings updated';

  @override
  String get profileUpdated => 'Profile updated';

  @override
  String get localizationUpdated => 'Localization settings updated';

  @override
  String get failedToUpdate => 'Failed to update. Please try again.';

  @override
  String get noData => 'No data available';

  @override
  String get retry => 'Retry';

  @override
  String get confirmDiscard => 'Discard unsaved changes?';

  @override
  String confirmDiscardMessage(String tab) {
    return '$tab has unsaved edits. Discarding will lose these changes.';
  }

  @override
  String get reportsTitle => 'Reports';

  @override
  String get reportsSearchHint => 'Search reports…';

  @override
  String reportsNoResultsFor(Object query) {
    return 'No reports found for \"$query\"';
  }

  @override
  String get reportsGenerate => 'Generate Report';

  @override
  String get reportsGenerating => 'Generating…';

  @override
  String get reportsReset => 'Reset';

  @override
  String get reportsConfigureHint =>
      'Configure your report above and tap Generate.';

  @override
  String get reportsNoResults => 'No results found for the selected filters.';

  @override
  String get reportsErrorRetry => 'Retry';

  @override
  String reportsRowCount(Object count) {
    return '$count rows loaded';
  }

  @override
  String get reportsLoadMore => 'Load More';

  @override
  String get reportsLoadingMore => 'Loading more…';

  @override
  String reportsGeneratedAt(Object time) {
    return 'Generated $time';
  }

  @override
  String get reportsExportTitle => 'Export Report';

  @override
  String get reportsExportCsv => 'CSV';

  @override
  String get reportsExportXlsx => 'Excel (XLSX)';

  @override
  String get reportsExportJson => 'JSON';

  @override
  String get reportsExportPdf => 'PDF';

  @override
  String get reportsExportHtml => 'HTML';

  @override
  String get reportsScopeAll => 'All vehicles';

  @override
  String get reportsScopeSingle => 'Single vehicle';

  @override
  String get reportsScopeMultiple => 'Multiple vehicles';

  @override
  String get reportsScopeGroup => 'Group';

  @override
  String get reportsScopeSelectVehicle => 'Select vehicle';

  @override
  String get reportsScopeSelectVehicles => 'Select vehicles';

  @override
  String get reportsScopeSelectGroup => 'Select group';

  @override
  String get reportsScopeSearchHint => 'Search by name, plate or IMEI…';

  @override
  String get reportsScopeSelectAll => 'Select all visible';

  @override
  String get reportsScopeDone => 'Done';

  @override
  String reportsScopeNVehiclesSelected(Object count) {
    return '$count vehicles selected';
  }

  @override
  String get reportsDateStart => 'Start date';

  @override
  String get reportsDateEnd => 'End date';

  @override
  String get reportsDateFrom => 'Start';

  @override
  String get reportsDateTo => 'End';

  @override
  String reportsDateMaxDays(Object days) {
    return 'Max $days days for this report type';
  }

  @override
  String get reportsValidationScopeRequired =>
      'Please select at least one vehicle.';

  @override
  String get reportsValidationStartRequired => 'Start date is required.';

  @override
  String get reportsValidationEndRequired => 'End date is required.';

  @override
  String get reportsValidationStartBeforeEnd => 'Start must be before end.';

  @override
  String reportsValidationMaxDays(Object days) {
    return 'Date range exceeds the $days-day limit for this report.';
  }

  @override
  String get reportsValidationSensorVehicleRequired =>
      'Please select a vehicle for the sensor report.';

  @override
  String get reportsValidationSensorRequired => 'Please select a sensor.';

  @override
  String get reportsValidationTimelineStateRequired =>
      'Select at least one state (Running or Stopped).';

  @override
  String get reportsFilterSpeedLimit => 'Speed limit (km/h)';

  @override
  String get reportsFilterSpeedCustom => 'Custom limit…';

  @override
  String get reportsFilterGeofenceHint => 'Search geofences…';

  @override
  String get reportsFilterGeofenceAllNote =>
      'No selection includes all geofences.';

  @override
  String get reportsFilterAlertType => 'Alert type';

  @override
  String get reportsFilterAlertSeverity => 'Severity';

  @override
  String get reportsFilterAlertAck => 'Acknowledgement';

  @override
  String get reportsFilterAlertAckAll => 'All';

  @override
  String get reportsFilterAlertAckAcknowledged => 'Acknowledged';

  @override
  String get reportsFilterAlertAckUnacknowledged => 'Unacknowledged';

  @override
  String get reportsFilterLogsVehicle => 'Vehicle';

  @override
  String get reportsFilterLogsCategory => 'Category';

  @override
  String get reportsFilterLogsLevel => 'Level';

  @override
  String get reportsFilterTimelineRunning => 'Running';

  @override
  String get reportsFilterTimelineStopped => 'Stopped';

  @override
  String get reportsFilterSensorVehicle => 'Vehicle';

  @override
  String get reportsFilterSensorSensor => 'Sensor';

  @override
  String get reportsCatalogDistanceTitle => 'Distance';

  @override
  String get reportsCatalogDistanceDesc =>
      'Total distance driven per vehicle per day with engine hours and odometer readings.';

  @override
  String get reportsCatalogDrivenTitle => 'Driven Days';

  @override
  String get reportsCatalogDrivenDesc =>
      'Daily distance matrix — which vehicles moved on which days and how far.';

  @override
  String get reportsCatalogDetailsTitle => 'Vehicle Details';

  @override
  String get reportsCatalogDetailsDesc =>
      'Fleet summary: total distance, engine hours, active days, last known location per vehicle.';

  @override
  String get reportsCatalogOverspeedTitle => 'Overspeed';

  @override
  String get reportsCatalogOverspeedDesc =>
      'Speeding events with observed speed, configured limit, excess, duration, and location.';

  @override
  String get reportsCatalogGeofenceTitle => 'Geofence';

  @override
  String get reportsCatalogGeofenceDesc =>
      'Entry and exit events for selected geofences with timestamps and dwell duration.';

  @override
  String get reportsCatalogAlertsTitle => 'Alerts';

  @override
  String get reportsCatalogAlertsDesc =>
      'Alert events by type and severity with acknowledgement status.';

  @override
  String get reportsCatalogSensorTitle => 'Sensor';

  @override
  String get reportsCatalogSensorDesc =>
      'Time-series readings for a specific sensor on a single vehicle with chart visualisation.';

  @override
  String get reportsCatalogLogsTitle => 'Device Logs';

  @override
  String get reportsCatalogLogsDesc =>
      'Raw communication logs from vehicle devices grouped by category and level.';

  @override
  String get reportsCatalogTimelineTitle => 'Timeline';

  @override
  String get reportsCatalogTimelineDesc =>
      'Running and stopped segments with duration, distance, and GPS map trace per segment.';

  @override
  String get reportsKpiTotalDistance => 'Total Distance';

  @override
  String get reportsKpiEngineHours => 'Engine Hours';

  @override
  String get reportsKpiActiveVehicles => 'Active Vehicles';

  @override
  String get reportsKpiAvgDistance => 'Avg Distance';

  @override
  String get reportsKpiVehiclesDriven => 'Vehicles Driven';

  @override
  String get reportsKpiAvgDaily => 'Avg Daily';

  @override
  String get reportsKpiPeakDay => 'Peak Day';

  @override
  String get reportsKpiViolations => 'Violations';

  @override
  String get reportsKpiAffectedVehicles => 'Affected Vehicles';

  @override
  String get reportsKpiHighestSpeed => 'Highest Speed';

  @override
  String get reportsKpiTotalDuration => 'Total Duration';

  @override
  String get reportsKpiTotalEvents => 'Total Events';

  @override
  String get reportsKpiEntries => 'Entries';

  @override
  String get reportsKpiExits => 'Exits';

  @override
  String get reportsKpiTotalAlerts => 'Total Alerts';

  @override
  String get reportsKpiCritical => 'Critical';

  @override
  String get reportsKpiAcknowledged => 'Acknowledged';

  @override
  String get reportsKpiReadings => 'Readings';

  @override
  String get reportsKpiOnEvents => 'ON Events';

  @override
  String get reportsKpiOffEvents => 'OFF Events';

  @override
  String get reportsKpiTotalLogs => 'Total Logs';

  @override
  String get reportsKpiRunningDuration => 'Running Duration';

  @override
  String get reportsKpiStoppedDuration => 'Stopped Duration';

  @override
  String get reportsKpiMovementDistance => 'Movement Distance';

  @override
  String get reportsKpiStopCount => 'Stop Count';

  @override
  String get reportsDetailTitle => 'Row Details';

  @override
  String get reportsDetailRawPayload => 'Raw Payload';

  @override
  String get reportsDetailCopied => 'Copied';

  @override
  String get reportsDetailCopy => 'Copy';

  @override
  String get reportsDetailTruncated =>
      'Payload truncated for display. Export for full data.';

  @override
  String get reportsRowDetailsViewMap => 'View Map';

  @override
  String get reportsRowDetailsHideMap => 'Hide Map';

  @override
  String get reportsRowDetailsNoGps =>
      'No GPS data available for this segment.';

  @override
  String reportsWarningBanner(Object message) {
    return 'Warning: $message';
  }

  @override
  String reportsSourceLabel(Object source) {
    return 'Source: $source';
  }

  @override
  String get adminRole => 'Admin';

  @override
  String get users => 'Users';

  @override
  String get vehicles => 'Vehicles';

  @override
  String get drivers => 'Drivers';

  @override
  String get team => 'Team';

  @override
  String get inventory => 'Inventory';

  @override
  String get map => 'Map';

  @override
  String get transactions => 'Transactions';

  @override
  String get calendar => 'Calendar';

  @override
  String get logs => 'Logs';

  @override
  String get plans => 'Plans';

  @override
  String get roles => 'Roles';

  @override
  String get smtp => 'SMTP';

  @override
  String get settingsDescription =>
      'Manage profile, localization and SMTP settings.';

  @override
  String get localizationDescription =>
      'Language, date/time, units, and default map focus.';

  @override
  String get whiteLabel => 'White Label';

  @override
  String get saveChanges => 'Save changes';

  @override
  String get textDirection => 'Text direction';

  @override
  String get languageAndDirection => 'Language & Direction';

  @override
  String get languageAndDirectionSubtitle =>
      'Interface language and text direction.';

  @override
  String get dateAndTime => 'Date & Time';

  @override
  String get dateAndTimeSubtitle => 'Date format, time style, and timezone.';

  @override
  String get unitsAndTheme => 'Units & Theme';

  @override
  String get unitsAndThemeSubtitle => 'Distance units and app appearance.';

  @override
  String get defaultMapFocus => 'Default Map Focus';

  @override
  String get defaultMapFocusSubtitle => 'Initial map center and zoom level.';

  @override
  String get couldNotLoadLocalization => 'Could not load localization.';

  @override
  String get localizationSaved => 'Localization saved';

  @override
  String get quickPresets => 'Quick presets';

  @override
  String get settingsHeaderSubtitle =>
      'Profile, branding, mail, localization, and platform preferences.';

  @override
  String get localizationPreview => 'Localization Preview';

  @override
  String get latitude => 'Latitude';

  @override
  String get longitude => 'Longitude';

  @override
  String get mapZoom => 'Map Zoom';

  @override
  String get mapCenter => 'Map Center';

  @override
  String get kilometers => 'Kilometers';

  @override
  String get miles => 'Miles';

  @override
  String get latitudeRequired => 'Latitude is required.';

  @override
  String get validLatitude => 'Enter a valid latitude.';

  @override
  String get latitudeRange => 'Latitude must be between -90 and 90.';

  @override
  String get longitudeRequired => 'Longitude is required.';

  @override
  String get validLongitude => 'Enter a valid longitude.';

  @override
  String get longitudeRange => 'Longitude must be between -180 and 180.';

  @override
  String get mapZoomRequired => 'Map zoom is required.';

  @override
  String get validMapZoom => 'Enter a valid zoom level.';

  @override
  String get mapZoomRange => 'Map zoom must be between 1 and 22.';

  @override
  String get unsupportedLanguageFallback =>
      'The saved language is not available in the app. Select a supported language; English is used for now.';
}
