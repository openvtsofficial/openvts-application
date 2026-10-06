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

  @override
  String homeWorkspace(Object role) {
    return '$role workspace';
  }

  @override
  String get homeAccessUnavailable =>
      'Workspace access could not be refreshed. Pull down to retry.';

  @override
  String get homeCopyright => '© 2026 Open VTS All rights reserved.';

  @override
  String get lightMode => 'Light mode';

  @override
  String get darkMode => 'Dark mode';

  @override
  String get landmarksStudio => 'Landmarks Studio';

  @override
  String get trackLinks => 'Track Links';

  @override
  String get messages => 'Messages';

  @override
  String get accounts => 'Accounts';

  @override
  String get notifications => 'Notifications';

  @override
  String get operations => 'Operations';

  @override
  String get server => 'Server';

  @override
  String get trips => 'Trips';

  @override
  String get documents => 'Documents';

  @override
  String get userRole => 'User';

  @override
  String get subuserRole => 'Subuser';

  @override
  String get driverRole => 'Driver';

  @override
  String get superadminRole => 'Superadmin';

  @override
  String get demoReadOnly => 'Demo • Read-only';

  @override
  String get security => 'Security';

  @override
  String get routeBuilderCreate => 'Create route';

  @override
  String get routeBuilderEdit => 'Edit route';

  @override
  String get routeBuilderName => 'Route name';

  @override
  String get routeBuilderNameHint => 'For example, morning deliveries';

  @override
  String get routeBuilderNameError =>
      'Enter a route name with at least 2 characters.';

  @override
  String get routeBuilderStops => 'Stops';

  @override
  String get routeBuilderAddStop => 'Add stop';

  @override
  String get routeBuilderEditStop => 'Edit stop';

  @override
  String get routeBuilderStopName => 'Stop name';

  @override
  String get routeBuilderStopNameError =>
      'Enter a name between 1 and 160 characters.';

  @override
  String get routeBuilderAddress => 'Address (optional)';

  @override
  String get routeBuilderCoordinates => 'Coordinates';

  @override
  String get routeBuilderLatitude => 'Latitude';

  @override
  String get routeBuilderLongitude => 'Longitude';

  @override
  String get routeBuilderCoordinateError =>
      'Enter a valid latitude (−90 to 90) and longitude (−180 to 180).';

  @override
  String get routeBuilderMap => 'Choose on map';

  @override
  String get routeBuilderMapHint => 'Tap the map to choose a stop location.';

  @override
  String get routeBuilderUseLocation => 'Use location';

  @override
  String get routeBuilderPoi => 'Point of interest';

  @override
  String get routeBuilderGeofence => 'Geofence';

  @override
  String get routeBuilderLandmarkSearch => 'Search saved landmarks';

  @override
  String get routeBuilderNoLandmarks =>
      'No matching landmarks with valid coordinates.';

  @override
  String get routeBuilderLandmarkError =>
      'Could not load saved landmarks. Please try again.';

  @override
  String get routeBuilderStopLimit =>
      'A route can contain up to 100 stops, including the return stop.';

  @override
  String get routeBuilderMinimumStops => 'Add at least 2 distinct stops.';

  @override
  String get routeBuilderRoundTrip => 'Return to start';

  @override
  String get routeBuilderRoundTripHint =>
      'Add the starting point as the final destination.';

  @override
  String get routeBuilderOptimize => 'Optimize order';

  @override
  String get routeBuilderOptimizeHint =>
      'Reorders stops using geographic distance, keeping your start and destination. Road distance is calculated separately.';

  @override
  String get routeBuilderRoadPath => 'Preview road path';

  @override
  String get routeBuilderRouting => 'Calculating driving route…';

  @override
  String get routeBuilderRoutingError =>
      'No driving route is available. Check the stop locations or your connection, then try again.';

  @override
  String get routeBuilderReady => 'Driving route ready';

  @override
  String get routeBuilderChanged =>
      'Stops changed. Preview the new driving route before saving.';

  @override
  String get routeBuilderSaveError =>
      'Could not save the route. Please try again.';

  @override
  String get routeBuilderAccessDenied =>
      'You do not have permission to create or edit routes.';

  @override
  String get routeBuilderOrigin => 'Start';

  @override
  String get routeBuilderDestination => 'Destination';

  @override
  String get routeBuilderWaypoint => 'Stop';

  @override
  String get routeBuilderShapePoint => 'Route shape';

  @override
  String get routeBuilderMoveUp => 'Move earlier';

  @override
  String get routeBuilderMoveDown => 'Move later';

  @override
  String get routeBuilderRemove => 'Remove stop';

  @override
  String get routeBuilderNoStops =>
      'Add your starting point and destination, then any stops along the way.';

  @override
  String get routeBuilderSavedGeometry => 'Saved route path';

  @override
  String get routeBuilderEditingLoadError =>
      'Could not load the complete route. Go back and try again.';

  @override
  String get routeBuilderDiscardTitle => 'Discard route changes?';

  @override
  String get routeBuilderDiscardMessage =>
      'Your unsaved route changes will be lost.';

  @override
  String get routeBuilderDiscard => 'Discard';

  @override
  String get routeBuilderKeepEditing => 'Keep editing';

  @override
  String get routeBuilderClose => 'Close';

  @override
  String get routeBuilderRetry => 'Try again';

  @override
  String get routeBuilderMapAttribution =>
      '© OpenStreetMap contributors · Routing: OSRM';

  @override
  String get routeBuilderRouteDetails => 'Route details';

  @override
  String get routeBuilderMinutes => 'min';

  @override
  String get routeBuilderDistanceUnit => 'km';

  @override
  String get routeBuilderChooseSource => 'Add a stop from';

  @override
  String get routeBuilderLandmarksPermission =>
      'Saved landmarks require the Landmarks permission.';

  @override
  String get routeBuilderShapeHint =>
      'Shape points guide the road path. They are not delivery stops. Optimizing removes shape points.';

  @override
  String get routeBuilderGeofenceHint =>
      'Uses the geofence centre. Confirm that it is reachable by road.';

  @override
  String selectField(Object field) {
    return 'Select $field';
  }

  @override
  String searchField(Object field) {
    return 'Search $field';
  }

  @override
  String noMatchingField(Object field) {
    return 'No matching $field';
  }

  @override
  String fieldRequired(Object field) {
    return '$field is required.';
  }

  @override
  String get clearSelection => 'Clear';

  @override
  String get clearSearch => 'Clear search';

  @override
  String get noResults => 'No results';

  @override
  String get select => 'Select';

  @override
  String get unableToLoad => 'Unable to load';

  @override
  String get mobileApiToken => 'API token';

  @override
  String get mobileTokenOnce =>
      'This token is shown only once. Store it securely. Anyone with it can access the selected API permissions.';

  @override
  String get mobileSaveRecovery => 'Save your recovery codes';

  @override
  String get mobileRecoveryHelp =>
      'Each code works once if you lose your authenticator. These replace previous recovery codes. Keep them in a safe place.';

  @override
  String get mobileCopiedSecurely => 'Copied. Store this securely.';

  @override
  String get mobileSavedSecurely => 'I have saved this securely';

  @override
  String get mobileDone => 'Done';

  @override
  String get mobileRevokeTokenQuestion => 'Revoke API token?';

  @override
  String mobileTokenStops(Object name) {
    return '$name will stop working immediately.';
  }

  @override
  String get mobileRevoke => 'Revoke';

  @override
  String get mobileMfa => 'Multi-factor authentication';

  @override
  String get mobileMfaOn => 'MFA is on';

  @override
  String get mobileMfaOff => 'MFA is off';

  @override
  String get mobileMfaHelp => 'Protect sign-in with your authenticator app.';

  @override
  String get mobileSecuritySessions =>
      'Security changes sign out other sessions and invalidate existing API tokens.';

  @override
  String mobileAddedDate(Object date) {
    return 'Added $date';
  }

  @override
  String get mobileRemoveAuthenticator => 'Remove authenticator';

  @override
  String get mobileAddAuthenticator => 'Add authenticator';

  @override
  String get mobileSetupMfa => 'Set up MFA';

  @override
  String mobileRecoveryRemaining(Object count) {
    return '$count unused recovery codes';
  }

  @override
  String get mobileReplaceRecovery => 'Replace recovery codes';

  @override
  String get mobileTurnOffMfa => 'Turn off MFA';

  @override
  String get mobileApiAccess => 'API access';

  @override
  String get mobileApiHelp =>
      'Create credentials for integrations with the permissions of your account.';

  @override
  String get mobileReadWrite => 'Read and write';

  @override
  String get mobileReadOnly => 'Read only';

  @override
  String get mobileExpires => 'Expires';

  @override
  String get mobileInactive => 'Inactive';

  @override
  String get mobileRevokeToken => 'Revoke token';

  @override
  String get mobileCreateToken => 'Create API token';

  @override
  String get mobileDeleteAccount => 'Delete account';

  @override
  String get mobileDeleteWorkspaceHelp =>
      'Delete your account and its workspace access, including subusers. All sessions will end. This action cannot be undone in the app.';

  @override
  String get mobileDeleteSelfHelp =>
      'Delete your account and end its sessions. This action cannot be undone in the app.';

  @override
  String get mobileDeleteMyAccount => 'Delete my account';

  @override
  String get mobilePasswordOnly =>
      'Future sign-ins will need only your password.';

  @override
  String get mobileRecoveryReplaced =>
      'Your previous recovery codes will stop working.';

  @override
  String get mobileTokenName => 'Token name';

  @override
  String get mobileAuthenticatorName => 'Authenticator name';

  @override
  String get mobileEnterName => 'Enter a name.';

  @override
  String get mobileAccess => 'Access';

  @override
  String get mobileExpiresAfter => 'Expires after';

  @override
  String mobileDays(Object count) {
    return '$count days';
  }

  @override
  String get mobileCurrentPassword => 'Current password';

  @override
  String get mobileEnterPassword => 'Enter your password.';

  @override
  String get mobileAuthenticatorOrRecovery => 'Authenticator or recovery code';

  @override
  String get mobileEnterVerification => 'Enter your verification code.';

  @override
  String get mobileDeleteConfirmation =>
      'I understand that my account and workspace access will be deleted.';

  @override
  String get mobileContinue => 'Continue';

  @override
  String get mobileSixDigits => 'Enter all six digits.';

  @override
  String get mobileConnectAuthenticator => 'Connect your authenticator';

  @override
  String get mobileScanQrHelp =>
      'Scan the QR code on another device, or copy the setup key into your authenticator app. Setup expires in 10 minutes.';

  @override
  String get mobileCopySetup => 'Copy setup key';

  @override
  String get mobileNewAuthenticatorCode => 'New authenticator code';

  @override
  String get mobileVerifying => 'Verifying…';

  @override
  String get mobileConfirm => 'Confirm';

  @override
  String get mobileVerifySignIn => 'Verify your sign-in';

  @override
  String get mobileUnusedRecovery => 'Enter one of your unused recovery codes.';

  @override
  String get mobileAuthenticatorInstructions =>
      'Enter the six-digit code from your authenticator app.';

  @override
  String get mobileRecoveryCode => 'Recovery code';

  @override
  String get mobileAuthenticatorCode => 'Authenticator code';

  @override
  String get mobileCompleteRecovery => 'Enter a complete recovery code.';

  @override
  String get mobileVerifyAndSignIn => 'Verify and sign in';

  @override
  String get mobileUseAuthenticator => 'Use authenticator code';

  @override
  String get mobileUseRecovery => 'Use recovery code';

  @override
  String get mobileBackSignIn => 'Back to sign in';

  @override
  String get mobileName => 'Name';

  @override
  String get mobileCallingCode => 'Country calling code';

  @override
  String get mobileMobileNumber => 'Mobile number';

  @override
  String get mobileAddress => 'Address';

  @override
  String get mobileCountry => 'Country';

  @override
  String get mobileState => 'State / Province';

  @override
  String get mobileCity => 'City';

  @override
  String get mobilePostcode => 'Postal code';

  @override
  String get mobileChangePassword => 'Change password';

  @override
  String get mobileRequired => 'This field is required.';

  @override
  String get mobileValidEmail => 'Enter a valid English email address.';

  @override
  String get mobilePasswordSessions =>
      'Changing your password signs you out of all sessions.';

  @override
  String get mobileNewPassword => 'New password';

  @override
  String get mobilePasswordCharacters => 'Use 6–72 English characters.';

  @override
  String get mobileDifferentPassword => 'Choose a different password.';

  @override
  String get mobileConfirmPassword => 'Confirm new password';

  @override
  String get mobilePasswordMismatch => 'Passwords do not match.';

  @override
  String get mobileChangesSaved => 'Changes saved';

  @override
  String get mobileLanguageCodeHelp =>
      'Enter a language code such as en or hi.';

  @override
  String get mobileReload => 'Reload';

  @override
  String get mobileEnterYourName => 'Enter your name.';

  @override
  String get mobileEnterCallingCode => 'Enter a calling code.';

  @override
  String get mobileValidMobile => 'Enter a valid mobile number.';

  @override
  String get mobileSaveProfile => 'Save profile';

  @override
  String get mobileDisplayPreferences => 'Display preferences';

  @override
  String get mobileDateFormat => 'Date format';

  @override
  String get mobileTimeFormat => 'Time format';

  @override
  String get mobileDistanceUnit => 'Distance unit';

  @override
  String get mobileTextDirection => 'Text direction';

  @override
  String get mobileTimeOffset => 'Time zone offset';

  @override
  String get mobileLanguageCode => 'Language code';

  @override
  String get mobileSavePreferences => 'Save preferences';

  @override
  String get mobileProofAccountChanged =>
      'Account access changed. Reopen this trip proof.';

  @override
  String get mobileActivity => 'Activity';

  @override
  String get mobileAllStatuses => 'All statuses';

  @override
  String get mobileApproximateRoute =>
      'Approximate stop sequence • numbered stops';

  @override
  String get mobileAttention => 'Attention';

  @override
  String get mobileChooseRoute => 'Choose a route';

  @override
  String get mobileValidSchedule => 'Choose a valid schedule.';

  @override
  String get mobileValidStartTime => 'Choose a valid start time.';

  @override
  String get mobileChooseVehicle => 'Choose a vehicle';

  @override
  String get mobileChooseVehicleRoute => 'Choose a vehicle and route.';

  @override
  String get mobileChooseEligibleVehicle => 'Choose an eligible vehicle';

  @override
  String get mobileEndDateAfterStart =>
      'Choose an end date on or after the start date.';

  @override
  String get mobileChooseWeekday => 'Choose at least one weekday.';

  @override
  String get mobileChooseDate => 'Choose date';

  @override
  String get mobileChooseDateRange => 'Choose date range';

  @override
  String get mobileChooseDay => 'Choose day';

  @override
  String get mobileMultiDayHelp =>
      'Choose the start and completion date and time for a multi-day trip.';

  @override
  String get mobileFutureDate => 'Choose today or a later date.';

  @override
  String get mobileCompleted => 'Completed';

  @override
  String get mobileCompletionAfterStart =>
      'Completion must be after the start.';

  @override
  String get mobileCreateRouteFirst => 'Create a route to start planning.';

  @override
  String get mobileCreateSchedule => 'Create schedule';

  @override
  String get mobileCreateTrip => 'Create trip';

  @override
  String get mobileDeleteSchedule => 'Delete schedule';

  @override
  String get mobileDiscardChanges => 'Discard changes';

  @override
  String get mobileDiscardTrip => 'Discard trip changes?';

  @override
  String get mobileEditRecurring => 'Edit recurring schedule';

  @override
  String get mobileEditSchedule => 'Edit schedule';

  @override
  String get mobileEndDate => 'End date';

  @override
  String get mobileEndSchedule => 'End schedule';

  @override
  String get mobileEndTime => 'End time';

  @override
  String get mobileEndTimeAfterStart =>
      'End time must be later than start time.';

  @override
  String get mobileEndsOptional => 'Ends (optional)';

  @override
  String get mobileTripTitleLength =>
      'Enter a title between 2 and 120 characters.';

  @override
  String get mobileAtLeastTwo => 'Enter at least 2 characters';

  @override
  String get mobileAtLeastThree => 'Enter at least 3 characters';

  @override
  String get mobileExpandRoute => 'Expand route map';

  @override
  String get mobileFitRoute => 'Fit route';

  @override
  String get mobileNoGpsPlanning =>
      'GPS is not linked. The trip can be planned, but live tracking will be unavailable.';

  @override
  String get mobileKeepEditing => 'Keep editing';

  @override
  String get mobileKeepSchedule => 'Keep schedule';

  @override
  String get mobileLastKnownPosition => 'Last known vehicle position';

  @override
  String get mobileLatestStart => 'Latest start time';

  @override
  String get mobileNextMonth => 'Next month';

  @override
  String get mobileNoEligible => 'No eligible vehicle is available.';

  @override
  String get mobileNoEligibleHelp =>
      'No eligible vehicle is available. Assign an active driver to an active vehicle before planning.';

  @override
  String get mobileNoRecordsView => 'No records for this view.';

  @override
  String get mobileNoRouteGps =>
      'No route or GPS coordinates are available for this trip.';

  @override
  String get mobileStopsWithoutGeometry =>
      'Numbered stops • route geometry unavailable';

  @override
  String get mobilePause => 'Pause';

  @override
  String get mobilePlanTrip => 'Plan trip';

  @override
  String get mobilePlannedNumbered => 'Planned route • numbered stops';

  @override
  String get mobilePreviousMonth => 'Previous month';

  @override
  String get mobileReasonRemark => 'Reason / remark';

  @override
  String get mobileRecurring => 'Recurring';

  @override
  String get mobileRecurringSchedule => 'Recurring schedule';

  @override
  String get mobileRecurringActions => 'Recurring schedule actions';

  @override
  String get mobileRefreshPlanning => 'Refresh planning options';

  @override
  String get mobileRefreshSchedule =>
      'Refresh this schedule before editing it.';

  @override
  String get mobileRemarkOptional => 'Remark (optional)';

  @override
  String get mobileRemoveEndDate => 'Remove end date';

  @override
  String get mobileRepeatOn => 'Repeat on';

  @override
  String get mobileResume => 'Resume';

  @override
  String get mobileRoute => 'Route';

  @override
  String get mobileRunning => 'Running';

  @override
  String get mobileSaveShareProof => 'Save or share proof';

  @override
  String get mobileSaveSchedule => 'Save schedule';

  @override
  String get mobileSchedule => 'Schedule';

  @override
  String get mobileScheduleSaved => 'Schedule saved';

  @override
  String get mobileSearchRoutes => 'Search routes';

  @override
  String get mobileSearchVehicleDriver => 'Search vehicle, plate or driver';

  @override
  String get mobileSkipDates => 'Skip dates (optional)';

  @override
  String get mobileSkipDatesRange =>
      'Skip dates must be inside the schedule date range.';

  @override
  String get mobileStartTime => 'Start time';

  @override
  String get mobileStarts => 'Starts';

  @override
  String get mobileStatus => 'Status';

  @override
  String get mobileSubmittedProofs => 'Submitted proofs';

  @override
  String get mobileAnyTimeDay =>
      'The driver can start any time on the selected day.';

  @override
  String get mobileStartWindowHelp =>
      'The driver can start within this time window. The end of the window is not the trip completion time.';

  @override
  String get mobileRequestFailed =>
      'The request could not be completed. Please refresh and try again.';

  @override
  String get mobileRouteUnavailable =>
      'The saved route is unavailable for planning. Refresh routes and try again.';

  @override
  String get mobileAccountTimeHelp =>
      'The trip starts at a specific time in the account timezone.';

  @override
  String get mobilePdfPreviewFailed =>
      'This PDF could not be previewed. Use Save or share to open it in another app.';

  @override
  String get mobileImagePreviewFailed =>
      'This image could not be previewed. Use Save or share to open it in another app.';

  @override
  String get mobileToday => 'Today';

  @override
  String get mobileTripCreated => 'Trip created';

  @override
  String get mobileTripDetails => 'Trip details';

  @override
  String get mobileTripRoute => 'Trip route';

  @override
  String get mobileTripTitle => 'Trip title';

  @override
  String get mobileProofShareFailed =>
      'Unable to share this proof. Please try again.';

  @override
  String get mobileUnavailableVehicles => 'Unavailable vehicles';

  @override
  String get mobileMaxSkipDates => 'Use at most 100 skip dates';

  @override
  String get mobileRemarkLength => 'Use at most 600 characters for the remark.';

  @override
  String get mobileValidDates => 'Use valid dates in YYYY-MM-DD format';

  @override
  String get mobileVehicleGpsPosition => 'Vehicle GPS position';

  @override
  String get mobileVehicleDriver => 'Vehicle and driver';

  @override
  String get mobileVehicleRoute => 'Vehicle and route';

  @override
  String get mobileViewTrip => 'View trip';

  @override
  String get mobileDatesPerLine => 'YYYY-MM-DD, one date per line';

  @override
  String get mobileDiscardPlanningHelp =>
      'Your unsaved planning changes will be lost. Saved routes will remain available.';

  @override
  String mobileTimesTimezone(Object timezone) {
    return 'Times use $timezone.';
  }

  @override
  String mobileStopsCount(Object count) {
    return '$count stops';
  }

  @override
  String mobileTripsCount(Object count) {
    return '$count trips';
  }

  @override
  String mobileLoadMoreCount(Object loaded, Object total) {
    return 'Load more ($loaded of $total)';
  }

  @override
  String mobileScheduledDate(Object date) {
    return 'Scheduled: $date';
  }

  @override
  String mobileEndsDate(Object date) {
    return 'Ends: $date';
  }

  @override
  String mobileNextDate(Object date) {
    return 'Next: $date';
  }

  @override
  String mobileGpsStatus(Object status) {
    return 'Vehicle GPS: $status';
  }

  @override
  String mobileLastPosition(Object date) {
    return 'Last position: $date';
  }

  @override
  String mobileActualDistance(Object distance) {
    return 'Actual distance: $distance km';
  }

  @override
  String mobileTripScore(Object value) {
    return 'Trip score: $value';
  }

  @override
  String mobileStopsProgress(Object completed, Object total) {
    return '$completed/$total stops';
  }

  @override
  String mobileScheduleAction(Object action) {
    return '$action recurring schedule?';
  }

  @override
  String get dateRangeSelect => 'Select date range';

  @override
  String get dateRangeChoose => 'Choose Date Range';

  @override
  String get dateTimeRangeChoose => 'Choose Date & Time Range';

  @override
  String get dateRangeFrom => 'From';

  @override
  String get dateRangeTo => 'To';

  @override
  String get dateRangeSelected => 'Selected Range';

  @override
  String get dateRangeStartTime => 'Start Time';

  @override
  String get dateRangeEndTime => 'End Time';

  @override
  String get dateRangeSelectStartTime => 'Select start time';

  @override
  String get dateRangeSelectEndTime => 'Select end time';

  @override
  String get dateRangeInvalidTime => 'End time must be after start time.';

  @override
  String get dateRangeCustom => 'Custom';

  @override
  String get dateRangeLastHour => 'Last Hour';

  @override
  String get dateRangeLast3Hours => 'Last 3 Hours';

  @override
  String get dateRangeLast6Hours => 'Last 6 Hours';

  @override
  String get dateRangeLast12Hours => 'Last 12 Hours';

  @override
  String get dateRangeLast24Hours => 'Last 24 Hours';

  @override
  String get dateRangeToday => 'Today';

  @override
  String get dateRangeYesterday => 'Yesterday';

  @override
  String get dateRangeThisWeek => 'This Week';

  @override
  String get dateRangeLastWeek => 'Last Week';

  @override
  String get dateRangeLast7Days => 'Last 7 Days';

  @override
  String get dateRangeLast30Days => 'Last 30 Days';

  @override
  String get apply => 'Apply';

  @override
  String get calendarToday => 'Today';

  @override
  String get calendarPreviousMonth => 'Previous month';

  @override
  String get calendarNextMonth => 'Next month';

  @override
  String get calendarExpiry => 'Expiry';

  @override
  String get legacyUi869d62ddcd => ' to enable the button.';

  @override
  String get legacyUi7f4f41c8c3 => '#RRGGBB';

  @override
  String get legacyUi9515360684 => '+ Add new device';

  @override
  String get legacyUi6116c134de => '+ Create new plan';

  @override
  String get legacyUic10e9a1c41 => '+ Create new user';

  @override
  String get legacyUi5e9a7040e4 => '2 digits';

  @override
  String get legacyUia0483eec37 => '3 digits';

  @override
  String get legacyUi3994dbd48e => '6–35 characters';

  @override
  String get legacyUi250e268e83 => '7 to 15 digits';

  @override
  String get legacyUie69a9a5ee9 => '7-Day Usage';

  @override
  String get legacyUib8cee60c75 =>
      'A sub user can only use features and reports available to your account. Settings and account security remain available.';

  @override
  String get legacyUif0ee13e963 => 'Access restricted';

  @override
  String get legacyUi6e702cb4e0 => 'Account Status';

  @override
  String get legacyUi6d6eba9279 => 'Account access';

  @override
  String get legacyUi82cf8a5fc7 => 'Account settings';

  @override
  String get legacyUi9beb96dac8 => 'Acknowledge';

  @override
  String get legacyUibf539b1d10 => 'Acme Logistics Pvt. Ltd.';

  @override
  String get legacyUic3cd636a58 => 'Actions';

  @override
  String get legacyUia733b809d2 => 'Active';

  @override
  String get legacyUi15cf579b89 => 'Active Duration';

  @override
  String get legacyUifaa171bc07 => 'Active Vehicle';

  @override
  String get legacyUibde34d0278 => 'Active status';

  @override
  String get legacyUi14c5b09cd4 => 'Activity Detail';

  @override
  String get legacyUifbed23bc25 => 'Activity Logs';

  @override
  String get legacyUie35effbf63 => 'Activity date range';

  @override
  String get legacyUicbd19b5c39 => 'Actor';

  @override
  String get legacyUi7980ca2475 => 'Actor User';

  @override
  String get legacyUi4ac5084db4 => 'Add Device or SIM';

  @override
  String get legacyUiaa752d14b8 => 'Add Driver';

  @override
  String get legacyUi224f2486e6 => 'Add Inventory';

  @override
  String get legacyUi1836b111cd => 'Add Meta Row';

  @override
  String get legacyUi31dd5bb29e => 'Add New Team';

  @override
  String get legacyUi47b2149c9c => 'Add Plan';

  @override
  String get legacyUic08d1e9d3f => 'Add Sensor';

  @override
  String get legacyUi12071f1c87 => 'Add a new plan or change your search.';

  @override
  String get legacyUic0c181937e => 'Add attribute';

  @override
  String get legacyUi5367d642e2 => 'Add credits';

  @override
  String get legacyUi1fa55e4562 => 'Add metadata row';

  @override
  String get legacyUi7be087b7a7 => 'Add proof';

  @override
  String get legacyUib68734c259 => 'Added';

  @override
  String get legacyUi41b5f2e6ae => 'Additional notes';

  @override
  String get legacyUid5e920a5cb => 'Address Line';

  @override
  String get legacyUi7748043229 => 'Address and geography details.';

  @override
  String get legacyUi4faa35048a => 'Admin login request completed.';

  @override
  String get legacyUi1eda23758b => 'Administrator';

  @override
  String get legacyUi3df513225f => 'Administrator created.';

  @override
  String get legacyUif981236722 => 'Affected vehicles';

  @override
  String get legacyUib7fb586ff2 => 'Airport';

  @override
  String get legacyUi25f8c55de8 => 'Alarm';

  @override
  String get legacyUib5faca3a78 => 'Alert Type';

  @override
  String get legacyUic03d80790d => 'All Admins';

  @override
  String get legacyUi0b313a76be => 'All Countries';

  @override
  String get legacyUiffeed47b5a => 'All Providers';

  @override
  String get legacyUi4745c5dce5 => 'All Time';

  @override
  String get legacyUieb672cb3ba => 'All Types';

  @override
  String get legacyUib4f25a1426 => 'All Users';

  @override
  String get legacyUidd9eb32418 => 'All Vehicles';

  @override
  String get legacyUi060be00f4f => 'All categories';

  @override
  String get legacyUi0aaede0bb1 => 'All notifications marked as read.';

  @override
  String get legacyUi30c8a0fc9c => 'All types';

  @override
  String get legacyUice832d9b31 => 'All users';

  @override
  String get legacyUie512a2f10a => 'Allow History';

  @override
  String get legacyUif8f993b052 => 'Allow route history access.';

  @override
  String get legacyUi1ffee134b1 =>
      'Allow visitors to log in to a demo workspace.';

  @override
  String get legacyUie5d30dc481 => 'Allowed range: 10–300';

  @override
  String get legacyUi22786d42cc => 'Altitude';

  @override
  String get legacyUi43dc8532f7 => 'Amount';

  @override
  String get legacyUi76aa32f207 => 'Amount *';

  @override
  String get legacyUia01154a861 => 'Amount Override';

  @override
  String get legacyUi7d66157b06 => 'Amount must be between 0.01 and 9999999.99';

  @override
  String get legacyUib34440b2cd => 'Amount override';

  @override
  String get legacyUib757c50159 => 'Amount supports up to 2 decimal places';

  @override
  String get legacyUic8c3ba95bb =>
      'Analytics will appear once payments are available.';

  @override
  String get legacyUif6c665f4fe =>
      'Analytics will appear once transactions are available.';

  @override
  String get legacyUi6b2a78a8f7 => 'Apply Filters';

  @override
  String get legacyUi2444928438 => 'Assign';

  @override
  String get legacyUi561f6317fe => 'Assign Driver';

  @override
  String get legacyUi3d2183f9ae => 'Assign Selected';

  @override
  String get legacyUi5e97289597 => 'Assign User';

  @override
  String get legacyUib8db201262 => 'Assign Vehicle';

  @override
  String get legacyUi20b5675c39 => 'Assign Vehicles';

  @override
  String get legacyUic403a13c66 =>
      'Assign one or more vehicles to this sub user.';

  @override
  String get legacyUie12261bf18 => 'Assign users to this driver.';

  @override
  String get legacyUi41c90cdeef => 'Assign users to this vehicle.';

  @override
  String get legacyUi32265d6dad =>
      'Assign vehicles to configure basic notifications.';

  @override
  String get legacyUi117326ffd2 =>
      'Assign vehicles to configure duration notifications.';

  @override
  String get legacyUi74dfd6593f =>
      'Assign vehicles to configure geofence notifications.';

  @override
  String get legacyUi8c6586176a =>
      'Assign vehicles to configure overspeed notifications.';

  @override
  String get legacyUi086854873d =>
      'Assign vehicles to configure route notifications.';

  @override
  String get legacyUie24e824b68 => 'Assigned';

  @override
  String get legacyUie94ba984c3 => 'Assigned vehicles';

  @override
  String get legacyUie55df441e8 => 'Assignment';

  @override
  String get legacyUi0c686b74d7 =>
      'At least 5 characters. Changes are audited.';

  @override
  String get legacyUi1afff0157c => 'Attach';

  @override
  String get legacyUi0c431f4969 => 'Attach file';

  @override
  String get legacyUi137135dbf6 => 'Attach files';

  @override
  String get legacyUi2286866966 => 'Attachment URL is not available.';

  @override
  String get legacyUib6b6277691 => 'Attachment path is not available.';

  @override
  String get legacyUi1b30607d41 => 'Attribute keys must be unique.';

  @override
  String get legacyUia6652617f2 => 'Attributes';

  @override
  String get legacyUi7c62a14244 => 'Available';

  @override
  String get legacyUicdc93143c6 => 'Avg';

  @override
  String get legacyUib1ff8731de => 'Avg Speed';

  @override
  String get legacyUi3e6e9b59e4 => 'Backend Tokens';

  @override
  String get legacyUib15950ccc9 => 'Backend tokens';

  @override
  String get legacyUief5c48114b => 'Backend verified';

  @override
  String get legacyUidd96994d01 => 'Backup';

  @override
  String get legacyUi775fe0e609 => 'Backup / Data Retention';

  @override
  String get legacyUi17ef50d8f8 => 'Bank Transfer';

  @override
  String get legacyUi1007a1a728 => 'Bank ref / UTR / transaction ID';

  @override
  String get legacyUi5be1ae92e8 => 'Bank transfer note / UTR / transaction ref';

  @override
  String get legacyUi6b57349e97 => 'Base URL settings';

  @override
  String get legacyUiaa2c96dacf => 'Basic';

  @override
  String get legacyUic73c27be48 =>
      'Basic account credentials for driver login.';

  @override
  String get legacyUi904d23cb6a => 'Basic identification for the new vehicle.';

  @override
  String get legacyUi99613c74ce => 'Blocked';

  @override
  String get legacyUi584522b903 => 'Brand and contact details';

  @override
  String get legacyUibfc8921ede => 'Brand color';

  @override
  String get legacyUi54a2cf5e63 => 'Browser';

  @override
  String get legacyUi73e0b16797 =>
      'Browser tab icon. ICO, PNG or SVG. Max 2 MB.';

  @override
  String get legacyUicfadbd7a57 => 'By';

  @override
  String get legacyUi42878ce3fa => 'CPU Usage';

  @override
  String get legacyUi37efa8a990 => 'Cafe';

  @override
  String get legacyUi26b937c51d => 'Cancel renewal request?';

  @override
  String get legacyUi84837a2168 => 'Cancel request';

  @override
  String get legacyUi2738a0a1db =>
      'Cannot load commands without vehicle details.';

  @override
  String get legacyUi4d4ce73b15 => 'Card';

  @override
  String get legacyUi758ec54e43 => 'Cash';

  @override
  String get legacyUi6ccb60071b => 'Categories';

  @override
  String get legacyUi49289db43e => 'Change Password';

  @override
  String get legacyUi6fc0529f2d => 'Change status';

  @override
  String get legacyUica5df1dad1 => 'Choose Date Time Range';

  @override
  String get legacyUid2174d8075 => 'Choose Replay Range';

  @override
  String get legacyUi66542fe55c =>
      'Choose a plan, registration date and reason of 5–500 characters.';

  @override
  String get legacyUi7db804aa37 =>
      'Choose vehicles, expiry, and sharing options.';

  @override
  String get legacyUi037c5eba86 => 'City (optional)';

  @override
  String get legacyUief153831d1 => 'City is required.';

  @override
  String get legacyUi8da6bb0466 => 'Cleanup completed';

  @override
  String get legacyUi381c4bf1d4 => 'Clear Filters';

  @override
  String get legacyUicdb64ef80e => 'Clear date range';

  @override
  String get legacyUid3c69afc35 => 'Clear dates';

  @override
  String get legacyUi1bf7452cd6 => 'Clear expiry';

  @override
  String get legacyUi40b66a41b8 => 'Clear expiry date';

  @override
  String get legacyUi92e60a4db3 => 'Clear replay';

  @override
  String get legacyUi53dde4f2c0 =>
      'Client revenue will appear after payments are recorded.';

  @override
  String get legacyUide4e7f6fad => 'Close drawer';

  @override
  String get legacyUi3dc631324c => 'Close map';

  @override
  String get legacyUid75dc68bbd => 'Cluster';

  @override
  String get legacyUiadac69379a => 'Code';

  @override
  String get legacyUiea6ac41a6a => 'Code is required.';

  @override
  String get legacyUi5b0f7590d0 => 'Collected';

  @override
  String get legacyUi8901895fb1 => 'Command';

  @override
  String get legacyUif7e08456d0 => 'Command Details';

  @override
  String get legacyUi6c4cb3de03 => 'Command Text';

  @override
  String get legacyUibfed234d46 => 'Command unavailable';

  @override
  String get legacyUi45e5f3f72e => 'Commands';

  @override
  String get legacyUi7a1994999d => 'Company';

  @override
  String get legacyUi8599f5cc48 => 'Company Name';

  @override
  String get legacyUi1e5f7dc45c => 'Company name';

  @override
  String get legacyUib55887f633 => 'Company updated';

  @override
  String get legacyUi657063c67c => 'Company updated.';

  @override
  String get legacyUif1ab0a6f4e => 'Complete manually';

  @override
  String get legacyUif14ebb39ce => 'Config Version';

  @override
  String get legacyUi755bea99c0 => 'Config updated.';

  @override
  String get legacyUic69463a5a9 => 'Configure outgoing mail delivery.';

  @override
  String get legacyUic2d404cb7b => 'Confirm Password';

  @override
  String get legacyUiea3723a45c => 'Confirm increased access';

  @override
  String get legacyUi4a7c565d4c => 'Confirm password';

  @override
  String get legacyUi5febc18b54 => 'Confirm payment';

  @override
  String get legacyUi05a7fffae1 => 'Confirm received payment';

  @override
  String get legacyUi90d96c7cec => 'Confirmation phrase';

  @override
  String get legacyUic2f9b7b489 => 'Connected';

  @override
  String get legacyUib37456c453 => 'Contact';

  @override
  String get legacyUicc11b3a28f => 'Context';

  @override
  String get legacyUi3cf29aa7f5 => 'Continuous Idle';

  @override
  String get legacyUic352b92e1f => 'Continuous Running';

  @override
  String get legacyUi347d3dbf17 => 'Continuous Stop';

  @override
  String get legacyUi49fdb038f4 => 'Control what viewers can see.';

  @override
  String get legacyUi02c6c04dec => 'Copy KML';

  @override
  String get legacyUi44fe06869f => 'Copy header';

  @override
  String get legacyUi3a9d77c901 => 'Could not open URL';

  @override
  String get legacyUi0c09a7eccc => 'Could not open attachment.';

  @override
  String get legacyUif2344997aa => 'Could not open document.';

  @override
  String get legacyUi2209ab63ce => 'Could not open file.';

  @override
  String get legacyUi5905ce4109 => 'Could not open file. Link copied.';

  @override
  String get legacyUi9b09f53bdd => 'Could not open link.';

  @override
  String get legacyUi72be0e8616 => 'Could not pick file';

  @override
  String get legacyUi76e835f8c3 => 'Could not pick file.';

  @override
  String get legacyUiaef46d6729 => 'Could not read selected file';

  @override
  String get legacyUi280c98ccef => 'Country filter';

  @override
  String get legacyUi1c9a9315c9 => 'Country is required.';

  @override
  String get legacyUid82b56cad9 => 'Course';

  @override
  String get legacyUi6e157c5da4 => 'Create';

  @override
  String get legacyUi318d1da4e0 => 'Create Admin';

  @override
  String get legacyUi0a62dd4d37 => 'Create Driver';

  @override
  String get legacyUie3429ab78d => 'Create Geofence';

  @override
  String get legacyUidb7c457634 => 'Create POI';

  @override
  String get legacyUicdd060d443 => 'Create Pricing Plan';

  @override
  String get legacyUi5d16c5ffd7 => 'Create Sub User';

  @override
  String get legacyUiafe9a7ae15 => 'Create Ticket';

  @override
  String get legacyUib25c91fe61 => 'Create User';

  @override
  String get legacyUi705b0946b2 => 'Create Vehicle';

  @override
  String get legacyUi22a6b9d964 =>
      'Create a dashboard from the web application to view it here.';

  @override
  String get legacyUi769479a4d5 =>
      'Create a public track link to share live vehicle tracking.';

  @override
  String get legacyUi50aab1f7b5 => 'Create a sensor for this vehicle.';

  @override
  String get legacyUi0d2cd08b59 => 'Create administrator';

  @override
  String get legacyUi6f876ff9c0 => 'Create at least one item before exporting.';

  @override
  String get legacyUic42adee4d7 => 'Create device without leaving this form';

  @override
  String get legacyUiaba922c9b5 => 'Create driver';

  @override
  String get legacyUi6efd8652f4 =>
      'Create drivers, manage assigned vehicles, documents, and driver activity.';

  @override
  String get legacyUiba98384ac3 =>
      'Create geofences to configure geofence notifications.';

  @override
  String get legacyUif7b868f7d4 =>
      'Create points of interest with category, icon, color, and tolerance radius.';

  @override
  String get legacyUie42ed33e33 =>
      'Create pricing plan without leaving this form';

  @override
  String get legacyUie40f966076 =>
      'Create route lines manually or from source and destination where supported.';

  @override
  String get legacyUi567e040ce2 =>
      'Create routes to configure route deviation notifications.';

  @override
  String get legacyUica09bbf34d =>
      'Create sub users and control which vehicles they can access.';

  @override
  String get legacyUi3afcbed7e6 => 'Create ticket';

  @override
  String get legacyUibdbcfa0af0 => 'Create user';

  @override
  String get legacyUie7358de58e =>
      'Create user without leaving this vehicle form';

  @override
  String get legacyUi505a950fbb => 'Create vehicle';

  @override
  String get legacyUi1ef0c932b3 =>
      'Create your first driver to start assignments.';

  @override
  String get legacyUi7d3ca14313 =>
      'Create your first geofence to define operational boundaries.';

  @override
  String get legacyUi60a39e1fde =>
      'Create your first place to track operational points.';

  @override
  String get legacyUi4fbf4f09cd =>
      'Create your first sub user to share selected access.';

  @override
  String get legacyUiaccf40c89b => 'Created';

  @override
  String get legacyUia5682ef199 => 'Created : ';

  @override
  String get legacyUi5db1542e68 => 'Created At';

  @override
  String get legacyUif1c69716be => 'Created at';

  @override
  String get legacyUidd097a2297 => 'Credentials';

  @override
  String get legacyUi9f58b9e39b =>
      'Credentials the administrator will use to sign into OpenVTS.';

  @override
  String get legacyUiec535bab6f =>
      'Credentials the user will use to sign into OpenVTS.';

  @override
  String get legacyUi8a45d339a6 => 'Credit';

  @override
  String get legacyUic3dc6e3ef9 =>
      'Credit, payment, or billing updates will appear here.';

  @override
  String get legacyUibfac50d642 => 'Credits';

  @override
  String get legacyUie070de2244 => 'Currency';

  @override
  String get legacyUiea4b114ac6 => 'Current State';

  @override
  String get legacyUieeed986410 => 'Current credits';

  @override
  String get legacyUibe1ac4e322 => 'Current step';

  @override
  String get legacyUi9c378938cd => 'Custom Command';

  @override
  String get legacyUi28be3fd018 => 'Custom Domain';

  @override
  String get legacyUif130609dfc => 'Custom Range';

  @override
  String get legacyUia9d9e61bf2 => 'Custom category (e.g. \"vendor\")';

  @override
  String get legacyUi0354c8896b => 'Custom domain';

  @override
  String get legacyUi3a55eba66f => 'Custom domain and brand color.';

  @override
  String get legacyUi9f1d0368da => 'Customer expiry';

  @override
  String get legacyUi1588fe44aa => 'Customer expiry date';

  @override
  String get legacyUib13a49701d => 'Customer renewal requests';

  @override
  String get legacyUi0c919bd08d => 'Customer service expires';

  @override
  String get legacyUidce04fd315 => 'Custom…';

  @override
  String get legacyUi118de3988f => 'Cutoff';

  @override
  String get legacyUi5c487cb2d8 =>
      'Daily revenue points are not available for this range.';

  @override
  String get legacyUi99c0019cc6 => 'Dark Logo';

  @override
  String get legacyUia167278399 => 'Dark logo updated';

  @override
  String get legacyUi2b197ef6be =>
      'Database and live telemetry logs will appear here.';

  @override
  String get legacyUi6bb4b674b3 => 'Date Range';

  @override
  String get legacyUie3d06ca6a1 => 'Date Time Range';

  @override
  String get legacyUic65ea4ae01 => 'Date range';

  @override
  String get legacyUi853aab7f56 => 'Date/Time';

  @override
  String get legacyUi842b7b5d71 => 'Dates';

  @override
  String get legacyUi987b9ced08 => 'Day';

  @override
  String get legacyUi82c29dd5fa => 'Day / Night Comparison';

  @override
  String get legacyUibfb1ba6e3e => 'Day / Night Range';

  @override
  String get legacyUicf558941e0 => 'Debit';

  @override
  String get legacyUibb3cec5175 => 'Deduct credits';

  @override
  String get legacyUi6bccca646f => 'Deducted';

  @override
  String get legacyUi1dcab135ef => 'Dedupe';

  @override
  String get legacyUi15462a4954 => 'Dedupe duplicate events';

  @override
  String get legacyUi6184deb041 => 'Default plan';

  @override
  String get legacyUiee1b9a9f23 => 'Delete Account';

  @override
  String get legacyUie81c14c990 => 'Delete Driver';

  @override
  String get legacyUi749f8e14e3 => 'Delete Sub User';

  @override
  String get legacyUi0a0a90f6c5 => 'Delete User';

  @override
  String get legacyUi4bcd1233a1 => 'Delete admin';

  @override
  String get legacyUi6fd38c1fb9 => 'Delete administrator';

  @override
  String get legacyUie8df0b7902 => 'Delete document';

  @override
  String get legacyUi4ecae3e148 => 'Delete document?';

  @override
  String get legacyUid1571af327 => 'Delete driver account';

  @override
  String get legacyUia34ada32da => 'Delete sensor';

  @override
  String get legacyUi1ce5593800 => 'Delete this document?';

  @override
  String get legacyUi6a58093cab => 'Delete track link';

  @override
  String get legacyUi9afe6c7b95 => 'Delete user';

  @override
  String get legacyUif7ff7065a9 => 'Delete vehicle';

  @override
  String get legacyUi441bda6cd8 => 'Deleted';

  @override
  String get legacyUif7c094a571 => 'Deleted rows';

  @override
  String get legacyUic6bdaac949 => 'Delhi';

  @override
  String get legacyUibc4f986ecb => 'Deliveries';

  @override
  String get legacyUi921a6f6b55 => 'Delivery Logs';

  @override
  String get legacyUib2c4e6cb46 => 'Demo Login';

  @override
  String get legacyUi4675a25777 => 'Demo login';

  @override
  String get legacyUi59013d16af => 'Describe the request or issue';

  @override
  String get legacyUi55f8ebc805 => 'Description';

  @override
  String get legacyUi388de6fa3a => 'Description (optional)';

  @override
  String get legacyUi763630a9ce => 'Description is required.';

  @override
  String get legacyUi8a96cce5e5 =>
      'Description must contain at least one letter or number.';

  @override
  String get legacyUidc3decbb93 => 'Details';

  @override
  String get legacyUia5a74a6df0 => 'Device';

  @override
  String get legacyUid69ba8a9eb => 'Device + SIM';

  @override
  String get legacyUic587837fda => 'Device IMEI';

  @override
  String get legacyUif59a7a21bb => 'Device Installs';

  @override
  String get legacyUi219288726d => 'Device Only';

  @override
  String get legacyUi554dd558bd => 'Device Summary';

  @override
  String get legacyUi20d5df8b4a => 'Device Type';

  @override
  String get legacyUi30de920ef1 => 'Device created and selected';

  @override
  String get legacyUi3c47b57c83 => 'Device response';

  @override
  String get legacyUi6d2870160a => 'Device time';

  @override
  String get legacyUi21fe5a18d0 => 'Device updated.';

  @override
  String get legacyUidf485c8713 => 'Devices';

  @override
  String get legacyUibb73469225 => 'Disable without deleting the link.';

  @override
  String get legacyUid3e4b30e10 => 'Discard & Refresh';

  @override
  String get legacyUi427dc4f0cd => 'Discard new administrator?';

  @override
  String get legacyUid1b8679c63 => 'Discard new user?';

  @override
  String get legacyUi6012a2d760 => 'Discard new vehicle?';

  @override
  String get legacyUifb0a3e6787 => 'Disk Usage';

  @override
  String get legacyUi70afe9eff3 => 'Dismiss';

  @override
  String get legacyUi515aa7ad86 => 'Display assigned geofence context.';

  @override
  String get legacyUi37bbdde1a6 => 'Display geofence boundaries on the map';

  @override
  String get legacyUi2eebf5225a => 'Display saved routes on the map';

  @override
  String get legacyUifb71a3779e => 'Distance Multiplier';

  @override
  String get legacyUib3262ecb53 => 'Distance Variation';

  @override
  String get legacyUiac3f0eb0ea => 'Distance/Hours';

  @override
  String get legacyUi2c21f68832 => 'Document Type';

  @override
  String get legacyUi7615530d7a => 'Document URL is unavailable.';

  @override
  String get legacyUi6dad05c10e => 'Document actions';

  @override
  String get legacyUibd9a0f027e => 'Document deleted.';

  @override
  String get legacyUi3859bdaa8c => 'Document title';

  @override
  String get legacyUi300b6ef0cd => 'Document type';

  @override
  String get legacyUi9b10914d8b => 'Domain';

  @override
  String get legacyUifb349182fc => 'Domain & Color';

  @override
  String get legacyUi8b58eea04e => 'Domain and brand color saved';

  @override
  String get legacyUi0ec2ae5cda => 'Domain, logos, favicon, and brand color.';

  @override
  String get legacyUibfa50c7a38 => 'Draw';

  @override
  String get legacyUi2e617aeb36 =>
      'Draw circles, polygons, rectangles, and line boundaries on the map.';

  @override
  String get legacyUid952b9d3da =>
      'Draw your first route corridor to start tracking.';

  @override
  String get legacyUi0ecf1d5bc0 => 'Driven';

  @override
  String get legacyUi845a6bd3ab => 'Driver Profile';

  @override
  String get legacyUi450d68e4fe => 'Driver actions';

  @override
  String get legacyUid1ba6aea38 => 'Driver assigned.';

  @override
  String get legacyUifbaa386fbc =>
      'Driver assignment and profile activity will appear here.';

  @override
  String get legacyUi017bb97653 => 'Driver created.';

  @override
  String get legacyUif8acdd5348 =>
      'Driver creation or driver updates will appear here.';

  @override
  String get legacyUib057fefdc2 => 'Driver deleted.';

  @override
  String get legacyUi63a7342acd => 'Driver name';

  @override
  String get legacyUi8d30cc59a1 => 'Driver unassigned.';

  @override
  String get legacyUia010b0a25f => 'Driver updated.';

  @override
  String get legacyUifdd68e9960 => 'Driver workspace';

  @override
  String get legacyUi3d14659ca9 => 'Dry-run';

  @override
  String get legacyUi87bd16c150 => 'Dry-run completed';

  @override
  String get legacyUi91310be76f => 'Dubai';

  @override
  String get legacyUi1370004da7 => 'Duration';

  @override
  String get legacyUia051787af6 => 'Each attachment must be 5MB or smaller.';

  @override
  String get legacyUi9bb58b2d1b => 'East';

  @override
  String get legacyUi7de491bedc => 'Edit Company';

  @override
  String get legacyUi5b7faa9d61 => 'Edit Device';

  @override
  String get legacyUicf5ddc10b3 => 'Edit Driver';

  @override
  String get legacyUi13a7a7c3a7 => 'Edit Plan';

  @override
  String get legacyUicd280a41f7 => 'Edit Profile';

  @override
  String get legacyUi19d57bd021 => 'Edit SIM';

  @override
  String get legacyUi4a0fe224b9 => 'Edit Sensor';

  @override
  String get legacyUic8e262db5b => 'Edit Sub User';

  @override
  String get legacyUi38a1cb0f89 => 'Edit Team Member';

  @override
  String get legacyUi0e457253ad => 'Edit User';

  @override
  String get legacyUib213eb6d7b => 'Edit Vehicle';

  @override
  String get legacyUid03750ccbf => 'Edit company';

  @override
  String get legacyUi15141eab3a => 'Edit profile';

  @override
  String get legacyUi84add5b295 => 'Email';

  @override
  String get legacyUi5c10b588a9 => 'Email (optional)';

  @override
  String get legacyUi094f6a5934 => 'Email or username';

  @override
  String get legacyUi79d1feaf62 => 'Email status';

  @override
  String get legacyUia674e88b73 => 'Email verification';

  @override
  String get legacyUic1feb155ec => 'Enable demo login';

  @override
  String get legacyUi7cf7a0d02a => 'Enable public signup';

  @override
  String get legacyUif6321257f1 => 'Enable this public link.';

  @override
  String get legacyUid093b28018 => 'Enable/Refresh';

  @override
  String get legacyUi0af149c2ed => 'Encryption';

  @override
  String get legacyUic1f65ddb75 => 'Engine';

  @override
  String get legacyUi49dda3d71a => 'Engine hours';

  @override
  String get legacyUi4c9c7856d1 => 'Enter 6-digit code';

  @override
  String get legacyUibc96ad8350 =>
      'Enter a decimal amount with at most 2 decimal places';

  @override
  String get legacyUib0e59c93d7 => 'Enter a valid amount.';

  @override
  String get legacyUi6d59e6aee7 =>
      'Enter an override reason of 5–500 characters';

  @override
  String get legacyUi571c7347b7 =>
      'Enter an override reason of 5–500 characters.';

  @override
  String get legacyUi18b809c9fb => 'Enter command text';

  @override
  String get legacyUid5cd51c7b9 => 'Enter credit amount';

  @override
  String get legacyUibe7572b6c5 => 'Enter state or territory';

  @override
  String get legacyUid148321ad7 => 'Enter the 6-digit code';

  @override
  String get legacyUi0d639c50f1 => 'Enter the 6-digit code we sent you';

  @override
  String get legacyUi6d1e849865 =>
      'Enter the OTP sent to your registered contact.';

  @override
  String get legacyUied634c4edc =>
      'Enter the email address or username used to sign in. If the account exists, we will send a time-limited reset link.';

  @override
  String get legacyUi1378167d52 => 'Enter your password';

  @override
  String get legacyUib6334ab817 => 'Enter your username or email';

  @override
  String get legacyUic7fb317725 => 'Entity';

  @override
  String get legacyUi04d694e298 => 'Entity ID';

  @override
  String get legacyUi948542c1d6 => 'Error/Critical';

  @override
  String get legacyUic250d77524 => 'Event Details';

  @override
  String get legacyUi894b1c749d => 'Event ID';

  @override
  String get legacyUif8e451a5d0 => 'Events unavailable';

  @override
  String get legacyUief09596668 => 'Exit Demo';

  @override
  String get legacyUia689a999a5 => 'Expired';

  @override
  String get legacyUib98d67213b => 'Expiring';

  @override
  String get legacyUi57fe01159c => 'Expiry Date (Optional)';

  @override
  String get legacyUi1275b51587 => 'Expiry Date/Time';

  @override
  String get legacyUi6b440cd506 => 'Expiry date';

  @override
  String get legacyUic9f6710324 => 'Expiry must be in the future.';

  @override
  String get legacyUif3e4fadb9e => 'Export';

  @override
  String get legacyUi416a52a386 => 'Export KML';

  @override
  String get legacyUi09b28aeb8d => 'FCM Token';

  @override
  String get legacyUic2bf1a9df5 => 'FCM token last 10';

  @override
  String get legacyUi82da67b211 => 'Facebook';

  @override
  String get legacyUi09fef5d8d9 => 'Failed';

  @override
  String get legacyUid68666787d => 'Failed tables';

  @override
  String get legacyUi706b9a59b6 => 'Failed to load cities';

  @override
  String get legacyUi6eb9516fdf => 'Failed to load countries';

  @override
  String get legacyUi4bc4b2e555 => 'Failed to load details';

  @override
  String get legacyUia7bc426a05 => 'Failed to load full vehicle details.';

  @override
  String get legacyUia17267ffa7 => 'Failed to load states';

  @override
  String get legacyUi6bb1f1d9fb => 'Failed to update status.';

  @override
  String get legacyUi1656649117 => 'Failure';

  @override
  String get legacyUib7ef43c84d => 'Failure Code';

  @override
  String get legacyUi41510b1b21 => 'Failure Message';

  @override
  String get legacyUi8db6a2f1d3 => 'Fast';

  @override
  String get legacyUiadc7ac2ae5 => 'Faster';

  @override
  String get legacyUib0f47aaf77 => 'Favicon';

  @override
  String get legacyUi7d9baea15f => 'Favicon updated';

  @override
  String get legacyUi2c3cafa4db => 'File';

  @override
  String get legacyUi55fee60744 => 'File URL is not available.';

  @override
  String get legacyUif76f22f075 => 'File exceeds 10MB limit.';

  @override
  String get legacyUi7e184124be => 'File is required.';

  @override
  String get legacyUi36f2202687 => 'File must be 10MB or smaller.';

  @override
  String get legacyUi937fd74b36 => 'Filter SIM cards';

  @override
  String get legacyUi15db08d15e => 'Filter activity logs';

  @override
  String get legacyUi582198fab2 => 'Filter administrators';

  @override
  String get legacyUi9911a4c0ed => 'Filter devices';

  @override
  String get legacyUi6a7fe2dc2c => 'Filter drivers';

  @override
  String get legacyUi5439ccf95d => 'Filter geofences';

  @override
  String get legacyUif1fe9835a2 => 'Filter team';

  @override
  String get legacyUi8cfc14a859 => 'Filter users';

  @override
  String get legacyUia9d1432d0d => 'Filter vehicles';

  @override
  String get legacyUiaa234fb61d => 'Firebase';

  @override
  String get legacyUib15839eae8 => 'Firebase initialized';

  @override
  String get legacyUi916a78d701 => 'First';

  @override
  String get legacyUic617ebad3b => 'Fix validation issues before testing';

  @override
  String get legacyUi4d4e9621c4 => 'Fleet Status';

  @override
  String get legacyUi1cc8d18151 => 'Forgot Password?';

  @override
  String get legacyUibaa0e2872d => 'Free signup credits';

  @override
  String get legacyUi236ddee138 => 'From Admin';

  @override
  String get legacyUi19fe826cc8 => 'From Email';

  @override
  String get legacyUi64346b483c => 'Full Name';

  @override
  String get legacyUi9f8ce19bf4 => 'Full address';

  @override
  String get legacyUieeb692087d => 'Full name';

  @override
  String get legacyUifcee5b52cc => 'GMT Offset';

  @override
  String get legacyUi590df4df1f => 'GMT offset must use +05:30 format.';

  @override
  String get legacyUi0933ed5657 => 'GPS Model';

  @override
  String get legacyUicbb0014411 => 'Gas Station';

  @override
  String get legacyUifc45f9b7a9 => 'Generate';

  @override
  String get legacyUi549f31c53e => 'Generate route';

  @override
  String get legacyUidfde035f40 => 'Geocoding';

  @override
  String get legacyUi5cdf1dbd7e => 'Geofences';

  @override
  String get legacyUic09b487feb => 'Get Replay';

  @override
  String get legacyUi5442e2b64f => 'GitHub';

  @override
  String get legacyUi1efbf15894 =>
      'Group nearby vehicles into clusters at lower zoom';

  @override
  String get legacyUiac69db7d02 => 'Growth Chart';

  @override
  String get legacyUibc4359231d => 'Gym';

  @override
  String get legacyUifa8a6b01e3 => 'Header copied';

  @override
  String get legacyUi071c1366b0 => 'Higher precision uses more lookups.';

  @override
  String get legacyUi90ccd64974 => 'History';

  @override
  String get legacyUic3669ffe53 =>
      'History needs a vehicle with an IMEI from live telemetry.';

  @override
  String get legacyUi8d4a22ea2b => 'History values are not numeric.';

  @override
  String get legacyUidbb927867e => 'Hospital';

  @override
  String get legacyUi3960ec4ca5 => 'Host';

  @override
  String get legacyUiadd03be31a => 'Host, port and encryption.';

  @override
  String get legacyUi9c4ba7d047 => 'Hotel';

  @override
  String get legacyUi1e3beed01c =>
      'How long historical data is kept before cleanup.';

  @override
  String get legacyUi2635a51635 =>
      'How the administrator will be identified on the platform.';

  @override
  String get legacyUi0f053057ee =>
      'How the user will be identified on the platform.';

  @override
  String get legacyUi077f5f9dad => 'I already have a reset link';

  @override
  String get legacyUibff7cfa991 => 'ICCID (optional)';

  @override
  String get legacyUidc7458a51a => 'IMEI is required to load telemetry logs.';

  @override
  String get legacyUif4c88fb92e => 'IMEI is required to load vehicle events.';

  @override
  String get legacyUi7e77081c51 => 'IMEI is required to send commands.';

  @override
  String get legacyUif44426c787 =>
      'IMEI is unavailable for this vehicle. Showing the live map summary only.';

  @override
  String get legacyUi8a4b9cf4a9 => 'IMEI missing';

  @override
  String get legacyUi11da2cb7f0 => 'IMSI (optional)';

  @override
  String get legacyUi716f63b96e => 'Icon';

  @override
  String get legacyUi7e5a975b6a => 'Identity';

  @override
  String get legacyUi2d40c36445 => 'Ignition';

  @override
  String get legacyUif2d738d99c => 'Ignition Source';

  @override
  String get legacyUi4157fc56ab => 'Image too large. Max 2 MB.';

  @override
  String get legacyUifcf7141427 => 'Image too large. Max 5 MB.';

  @override
  String get legacyUieeec98db23 => 'Import CSV';

  @override
  String get legacyUieebd26ef51 => 'Inactive - 48H';

  @override
  String get legacyUi4b631f6984 => 'Info';

  @override
  String get legacyUi29981bf033 =>
      'Initial credit balance assigned to this administrator account.';

  @override
  String get legacyUi58984ab1ac => 'Initial credits';

  @override
  String get legacyUi5721bbef40 => 'Instagram';

  @override
  String get legacyUi9b5ca633e8 => 'Insufficient account credits';

  @override
  String get legacyUi2ab95a4afe => 'Invalid administrator id.';

  @override
  String get legacyUicfa3e9c7e1 => 'Inventory item created.';

  @override
  String get legacyUi32091e3797 => 'Inventory status';

  @override
  String get legacyUia430dcf58c => 'Jane Smith';

  @override
  String get legacyUi049874e4f7 => 'KML copied to clipboard';

  @override
  String get legacyUi62fc561458 => 'Keep request';

  @override
  String get legacyUic67dd20ee8 => 'Key';

  @override
  String get legacyUi52c4afe84f => 'Landmark Studio';

  @override
  String get legacyUid1c69a859a => 'Last';

  @override
  String get legacyUi43df3046ba => 'Last Change';

  @override
  String get legacyUi7a78ad49d8 => 'Last Month Revenue';

  @override
  String get legacyUicec3d948d9 => 'Last Payment';

  @override
  String get legacyUiada1b72559 => 'Last checked';

  @override
  String get legacyUi43dab84ff6 => 'Last login';

  @override
  String get legacyUib916a123cc => 'Last month revenue';

  @override
  String get legacyUi76c1ed9309 => 'Last week';

  @override
  String get legacyUieb3a622ae8 => 'Lat / Long';

  @override
  String get legacyUi1e5421b5bc => 'Lat/Lng';

  @override
  String get legacyUidecd7ca800 => 'Latest';

  @override
  String get legacyUiefaed3a1b0 => 'Leave blank to keep current password';

  @override
  String get legacyUib8100f5ba8 => 'Library';

  @override
  String get legacyUi3229609e15 => 'License';

  @override
  String get legacyUi99929a05d8 => 'License Blocked';

  @override
  String get legacyUi7452738cf9 => 'License Issued';

  @override
  String get legacyUibbe96bcfaa => 'License Used';

  @override
  String get legacyUib957e7bd7b => 'License blocked';

  @override
  String get legacyUiee92c8a4b6 => 'Licenses';

  @override
  String get legacyUi6731d7cd1a => 'Light Logo';

  @override
  String get legacyUi6a1c6c8807 => 'Light logo updated';

  @override
  String get legacyUi24d948e4bd => 'Limit';

  @override
  String get legacyUied1ed2b68d => 'Link copied.';

  @override
  String get legacyUi36d1b59b88 =>
      'Link the vehicle to a primary user, GPS device, and pricing plan.';

  @override
  String get legacyUi6b6390a441 => 'LinkedIn';

  @override
  String get legacyUi4ac08d16b8 => 'Load earlier messages';

  @override
  String get legacyUidfe60ca92e => 'Load more';

  @override
  String get legacyUifc53db81a0 => 'Load more from server';

  @override
  String get legacyUi949d7ee41c => 'Load older';

  @override
  String get legacyUi6db90a0ab6 => 'Loaded';

  @override
  String get legacyUi326ad2f9f8 => 'Loading assigned vehicles';

  @override
  String get legacyUi8936529136 => 'Loading available vehicles';

  @override
  String get legacyUi9f1e0ce448 => 'Loading documents';

  @override
  String get legacyUide261e9b89 => 'Loading logs';

  @override
  String get legacyUi324989adf0 => 'Loading sensors';

  @override
  String get legacyUid219c68101 => 'Location';

  @override
  String get legacyUi2350df02c2 => 'Log Details';

  @override
  String get legacyUiaacbd6aa68 => 'Log ID';

  @override
  String get legacyUia3d749050e => 'Login as User';

  @override
  String get legacyUi31a519ee99 =>
      'Login, password, or account status changes will appear here.';

  @override
  String get legacyUi16b583cf21 => 'Logs unavailable';

  @override
  String get legacyUi4c57f0c88d => 'London';

  @override
  String get legacyUi3bf98fa618 => 'Mark read';

  @override
  String get legacyUia95e85aed5 => 'Max';

  @override
  String get legacyUi35f72dc38d => 'Max Speed';

  @override
  String get legacyUi03a68b7d8b => 'Memory Usage';

  @override
  String get legacyUi68f4145fee => 'Message';

  @override
  String get legacyUi54a144c1dd => 'Message dispatch';

  @override
  String get legacyUi23b9e4546e => 'Message your fleet manager here.';

  @override
  String get legacyUi8d546a6dea => 'Meta';

  @override
  String get legacyUi251edc0eb5 => 'Metadata';

  @override
  String get legacyUic0b8960edf => 'Metadata copied';

  @override
  String get legacyUi7eb0cee888 => 'Min';

  @override
  String get legacyUib6bcd4535a => 'Min 3 characters…';

  @override
  String get legacyUi925c181c00 => 'Minimum 6 characters';

  @override
  String get legacyUi092f99ea11 => 'Minutes';

  @override
  String get legacyUib1d7024593 => 'Mobile';

  @override
  String get legacyUia0d9c28a1e => 'Mobile (optional)';

  @override
  String get legacyUi5968acfb01 => 'Mobile Number';

  @override
  String get legacyUic242b24d94 => 'Mobile Prefix';

  @override
  String get legacyUi802cdad736 => 'Mobile Push';

  @override
  String get legacyUi00618b3856 => 'Mobile and email used for communication.';

  @override
  String get legacyUi5d96299833 => 'Mobile number (optional)';

  @override
  String get legacyUi2ab961738f => 'Mobile prefix';

  @override
  String get legacyUi90ee975346 => 'Mobile prefix (optional)';

  @override
  String get legacyUiaa6630b79b => 'Mobile push registration retried.';

  @override
  String get legacyUia1e34f9157 => 'More actions';

  @override
  String get legacyUi86c0a35ec8 => 'More options';

  @override
  String get legacyUi69d9f3e5ae => 'Museum';

  @override
  String get legacyUi4ff2aa7688 => 'My Tickets';

  @override
  String get legacyUi2e65b706ae => 'Name and code are required.';

  @override
  String get legacyUi1eee3afea2 => 'Navigate';

  @override
  String get legacyUiccfb5f0286 => 'New POI';

  @override
  String get legacyUi4894cb39ee => 'New Password';

  @override
  String get legacyUidcaa5db473 => 'New Ticket';

  @override
  String get legacyUib85e445f60 => 'New User';

  @override
  String get legacyUia273c96341 => 'New Vehicle';

  @override
  String get legacyUie0725b6664 => 'New geofence';

  @override
  String get legacyUif39fa269a9 => 'New route';

  @override
  String get legacyUi395e182389 => 'New users will appear here.';

  @override
  String get legacyUi2213317245 => 'New vehicles will appear here.';

  @override
  String get legacyUi4bfc194b68 => 'Next page';

  @override
  String get legacyUi1097b553dc => 'Night';

  @override
  String get legacyUi4276e6ab2a => 'No Data';

  @override
  String get legacyUi3de93f521b => 'No Device';

  @override
  String get legacyUi79858167e6 => 'No POIs yet';

  @override
  String get legacyUia434e9985c => 'No Provider';

  @override
  String get legacyUi7094ba4f01 =>
      'No active assignment. New trips appear here when dispatch assigns them.';

  @override
  String get legacyUia9206f399a => 'No activity logs';

  @override
  String get legacyUi8bd5b910e5 => 'No activity logs found';

  @override
  String get legacyUic38a37a193 => 'No activity matches your filters.';

  @override
  String get legacyUibff9905096 => 'No activity recorded yet.';

  @override
  String get legacyUi0f5cca70f8 => 'No administrators found';

  @override
  String get legacyUi31d3df94ab => 'No administrators found.';

  @override
  String get legacyUic0d322c2b0 => 'No adoption data';

  @override
  String get legacyUie5d64448e5 => 'No alerts';

  @override
  String get legacyUi501176c9f8 => 'No analytics data';

  @override
  String get legacyUi63f5349bb8 => 'No assigned users';

  @override
  String get legacyUi852751d61f => 'No assigned vehicles';

  @override
  String get legacyUi7546829892 => 'No billing activity found.';

  @override
  String get legacyUi657275c0c1 => 'No cities available for this state';

  @override
  String get legacyUia130e0f01b => 'No command history';

  @override
  String get legacyUi92db635f14 => 'No commands yet';

  @override
  String get legacyUi14a4bfc72c => 'No completed trips this month.';

  @override
  String get legacyUiee9c2e1df0 => 'No config';

  @override
  String get legacyUic3017a3316 => 'No conversation yet';

  @override
  String get legacyUic140165b8f => 'No credit history yet.';

  @override
  String get legacyUic8114767e8 => 'No dashboard configured';

  @override
  String get legacyUi7be70212b0 => 'No day or night data for this range.';

  @override
  String get legacyUi2a4eb69350 => 'No details';

  @override
  String get legacyUi03ca0261ac => 'No device';

  @override
  String get legacyUi893d388d16 => 'No device assigned to this vehicle.';

  @override
  String get legacyUi8386fe15ef => 'No documents';

  @override
  String get legacyUi017ce6604c => 'No documents uploaded';

  @override
  String get legacyUiec7eb3c93e => 'No documents uploaded yet.';

  @override
  String get legacyUi54e1079e44 =>
      'No documents yet. Upload your first document using the upload button.';

  @override
  String get legacyUia419748e62 => 'No driver activity found.';

  @override
  String get legacyUi98e6629503 =>
      'No driver document types are configured. Ask your administrator to add one.';

  @override
  String get legacyUi36f5cbf894 => 'No driver documents';

  @override
  String get legacyUic5dc9718a6 => 'No drivers';

  @override
  String get legacyUi7a127d70b3 => 'No drivers available';

  @override
  String get legacyUi9c8198d34d => 'No drivers found';

  @override
  String get legacyUi208ffc64d1 => 'No event detail found';

  @override
  String get legacyUiec11a02374 =>
      'No events exist for the selected date range and filters.';

  @override
  String get legacyUia48cbba615 => 'No events found';

  @override
  String get legacyUi81ab95b9f0 => 'No events yet';

  @override
  String get legacyUi774a252215 => 'No file available.';

  @override
  String get legacyUi35f65e1e57 => 'No geofences available.';

  @override
  String get legacyUi019549899f => 'No geofences yet';

  @override
  String get legacyUi5358cec56d => 'No history points';

  @override
  String get legacyUia0ed9c8031 => 'No history points for this range.';

  @override
  String get legacyUi8bf09d954a => 'No linked vehicles available';

  @override
  String get legacyUif48787eb30 => 'No logs found';

  @override
  String get legacyUi6b68d448a0 => 'No logs found for this vehicle';

  @override
  String get legacyUic7462a9dac => 'No logs yet';

  @override
  String get legacyUi1db215fbaa => 'No matches for your search.';

  @override
  String get legacyUia734fde29a => 'No matching POIs';

  @override
  String get legacyUi2d928306c1 => 'No matching drivers';

  @override
  String get legacyUid6e8839481 => 'No matching geofences';

  @override
  String get legacyUif6830db2e7 => 'No matching logs';

  @override
  String get legacyUi748bd377da => 'No matching records';

  @override
  String get legacyUi6590e5eab8 => 'No matching routes';

  @override
  String get legacyUid17e9558cf => 'No matching sub users';

  @override
  String get legacyUif1d8690cd7 =>
      'No matching vehicles found. Try a different search or filter.';

  @override
  String get legacyUic04921f8d9 => 'No messages yet';

  @override
  String get legacyUi2449a03436 => 'No mode data';

  @override
  String get legacyUi50806db52e => 'No notification settings found';

  @override
  String get legacyUic1f531f996 => 'No payments found';

  @override
  String get legacyUiaf4a7f06d0 => 'No plans found';

  @override
  String get legacyUi4ae157aff3 => 'No recent alerts.';

  @override
  String get legacyUi26776d0320 => 'No recent users';

  @override
  String get legacyUi42ec1ecf96 => 'No recent vehicles';

  @override
  String get legacyUi9833364a35 => 'No routes available.';

  @override
  String get legacyUid233dd5d9f => 'No routes yet';

  @override
  String get legacyUic9bfb1492b => 'No security activity found.';

  @override
  String get legacyUid07b6b93d6 => 'No selectable vehicles';

  @override
  String get legacyUi5653bf7251 => 'No sensor points for this range.';

  @override
  String get legacyUi1ef59c9c2b => 'No sensors';

  @override
  String get legacyUi3c30b80f16 => 'No sensors configured for this vehicle.';

  @override
  String get legacyUicbae766d34 => 'No settings activity found.';

  @override
  String get legacyUicd0c79d188 => 'No share links';

  @override
  String get legacyUi9eac2f6695 => 'No states available for this country';

  @override
  String get legacyUid05ab60501 => 'No status data';

  @override
  String get legacyUi4b78e836ec => 'No sub users';

  @override
  String get legacyUib30adf9758 => 'No sub users available';

  @override
  String get legacyUi3a1fa8f145 => 'No team members found';

  @override
  String get legacyUi12c6f10a41 => 'No telemetry detail found';

  @override
  String get legacyUi429d6e6ece => 'No telemetry logs found';

  @override
  String get legacyUiea04e18b66 => 'No top assets for this range.';

  @override
  String get legacyUi48d2d8da35 => 'No transactions';

  @override
  String get legacyUid60c045dd2 => 'No transactions found';

  @override
  String get legacyUif794b6c6d1 => 'No transactions yet.';

  @override
  String get legacyUi8d92589518 => 'No trend data';

  @override
  String get legacyUi7d3e5f72b8 => 'No trips in this view.';

  @override
  String get legacyUib4c96ae04e => 'No unlinked users found.';

  @override
  String get legacyUi4b3155e704 => 'No unlinked users match your search.';

  @override
  String get legacyUid9c71203a5 => 'No usage data for the selected range.';

  @override
  String get legacyUic4b060bd59 => 'No users';

  @override
  String get legacyUi5cc2b29f54 => 'No users assigned';

  @override
  String get legacyUi3b614a59c7 => 'No users available';

  @override
  String get legacyUi612eb3c64c => 'No users found';

  @override
  String get legacyUie611ef5702 => 'No users found.';

  @override
  String get legacyUif800dfd722 =>
      'No valid GPS path or stop markers were returned.';

  @override
  String get legacyUib96ee669b0 => 'No vehicle activity found.';

  @override
  String get legacyUi748eafd21d => 'No vehicles';

  @override
  String get legacyUi8fbc8deb7a =>
      'No vehicles are visible on the map right now.';

  @override
  String get legacyUi72ed5bbcdf => 'No vehicles assigned yet.';

  @override
  String get legacyUi7223e6b8cb => 'No vehicles assigned.';

  @override
  String get legacyUiac0e4dbd5b => 'No vehicles available';

  @override
  String get legacyUic578cfdbd5 => 'No vehicles found';

  @override
  String get legacyUie1de5f8ce2 => 'No vehicles match your search.';

  @override
  String get legacyUia41b297cf1 => 'No weekly comparison data.';

  @override
  String get legacyUi35163920f3 => 'No widgets configured';

  @override
  String get legacyUi45e118d056 => 'Normal';

  @override
  String get legacyUif8e45b2be2 => 'North';

  @override
  String get legacyUi2c924e3088 => 'Note';

  @override
  String get legacyUi2fd5716446 => 'Notes (Optional)';

  @override
  String get legacyUicf62dbc83d => 'Notes / Description';

  @override
  String get legacyUi3e56dbb775 => 'Notes about this document';

  @override
  String get legacyUi7faf33fcca => 'Nothing to export';

  @override
  String get legacyUi76544814eb => 'Notification actions';

  @override
  String get legacyUi4eb32de6c9 => 'Notification settings saved successfully.';

  @override
  String get legacyUi8ca2cb9290 => 'Odometer';

  @override
  String get legacyUi6c3a72eaf6 => 'Office';

  @override
  String get legacyUi63f34dd211 => 'Older';

  @override
  String get legacyUi35c5d4307a => 'Older rows';

  @override
  String get legacyUi9f8f7411e8 => 'One or more selected vehicles are invalid.';

  @override
  String get legacyUie81cd61ea1 => 'Only assigned user vehicles can be shared.';

  @override
  String get legacyUicf9b77061f => 'Open';

  @override
  String get legacyUi8f5f529938 => 'Open / save';

  @override
  String get legacyUi55d00c31ab => 'Open Vehicles';

  @override
  String get legacyUicc6b7ec50c => 'Open failed rows CSV';

  @override
  String get legacyUi99bd9c01d7 => 'OpenVTS Notifications';

  @override
  String get legacyUic1b94f880c => 'Optional amount';

  @override
  String get legacyUi7afdcf3257 => 'Optional email';

  @override
  String get legacyUic553137ef5 => 'Optional mobile';

  @override
  String get legacyUi410d481882 => 'Optional notes';

  @override
  String get legacyUi4f8f9c2bba => 'Optional receipt or note';

  @override
  String get legacyUi3494a60f96 => 'Optional username';

  @override
  String get legacyUia493c04fb5 => 'Optional; enter at least 3 characters';

  @override
  String get legacyUi6bf5da9c08 => 'Options';

  @override
  String get legacyUidefe0db589 => 'Order by';

  @override
  String get legacyUi6e6a6f2086 => 'Other';

  @override
  String get legacyUi4bed336194 => 'Output';

  @override
  String get legacyUi9e339da256 => 'Overspeed Enabled';

  @override
  String get legacyUi0efc2e6be4 => 'Overview';

  @override
  String get legacyUi3e90e4cbf4 => 'Ownership';

  @override
  String get legacyUi07afcc61d8 => 'Packet type';

  @override
  String get legacyUif92c24e8df => 'Park';

  @override
  String get legacyUi07ba1bef85 => 'Parties';

  @override
  String get legacyUi8be3c943b1 => 'Password';

  @override
  String get legacyUi408255ed02 => 'Password (optional)';

  @override
  String get legacyUi092a16e7af => 'Password changed';

  @override
  String get legacyUi47fa528931 => 'Password changed.';

  @override
  String get legacyUi3efdbb2011 => 'Password updated.';

  @override
  String get legacyUi8ac0c75d5e =>
      'Paste the complete reset link or token from your email. Reset links are single-use and expire automatically.';

  @override
  String get legacyUi5616b61bb7 => 'Payload JSON';

  @override
  String get legacyUif8c3596eab => 'Payload must be valid JSON object.';

  @override
  String get legacyUi23b35c414a => 'Payment Mode';

  @override
  String get legacyUi670d2a76c7 => 'Payment Mode *';

  @override
  String get legacyUi662210d869 => 'Payment Mode Breakdown';

  @override
  String get legacyUia629fd8a2e => 'Payment Type';

  @override
  String get legacyUi43f8c9c90f => 'Payment activity will appear here.';

  @override
  String get legacyUi8fbf2ec0dd => 'Payment mode';

  @override
  String get legacyUi653c04fc42 =>
      'Payment mode breakdown is not available for this range.';

  @override
  String get legacyUidbc3c0ca72 => 'Payment recorded';

  @override
  String get legacyUi197b45d161 => 'Payment reference';

  @override
  String get legacyUi96f608c16c => 'Pending';

  @override
  String get legacyUid1240d2832 => 'Pending / Failed';

  @override
  String get legacyUi9126c119ae => 'Pending Payments';

  @override
  String get legacyUib4ebfb2f75 => 'Pending payments';

  @override
  String get legacyUi167a47ff3e => 'Performed by';

  @override
  String get legacyUi1785713451 => 'Permission';

  @override
  String get legacyUid06d555709 => 'Permissions';

  @override
  String get legacyUi1e99c04657 => 'Permissions updated';

  @override
  String get legacyUi0219adf447 => 'Personal details and address';

  @override
  String get legacyUib1b9e59387 => 'Personal information';

  @override
  String get legacyUi77064d5265 => 'Phone';

  @override
  String get legacyUi26730cddc4 => 'Pick CSV';

  @override
  String get legacyUif2c5ca7b8c => 'Pincode';

  @override
  String get legacyUifd25c49d56 => 'Pincode (optional)';

  @override
  String get legacyUiae2f98a099 => 'Plan';

  @override
  String get legacyUiec0632cbbf => 'Plan Name';

  @override
  String get legacyUi2b366a2f95 => 'Plan Price';

  @override
  String get legacyUi7f97f6a268 => 'Plan created and selected';

  @override
  String get legacyUi2db331cefa => 'Plate';

  @override
  String get legacyUi7d86677521 => 'Plate Number';

  @override
  String get legacyUia6b7aa4d9c => 'Plate Number (optional)';

  @override
  String get legacyUif2ce282e2d => 'Plate number';

  @override
  String get legacyUi09d9c23846 => 'Plate number (optional)';

  @override
  String get legacyUi123a7f2fcc => 'Platform';

  @override
  String get legacyUi16596c477e =>
      'Platform behavior, signup, geocoding, and retention.';

  @override
  String get legacyUid095e279b3 =>
      'Please fix the highlighted fields before continuing.';

  @override
  String get legacyUi51668149ea => 'Please select an administrator.';

  @override
  String get legacyUife035157cd => 'Port';

  @override
  String get legacyUi16c2eb4dbb => 'Ports';

  @override
  String get legacyUib629d4165b => 'Postal / ZIP code';

  @override
  String get legacyUib86b6a2b3b => 'Postal code (optional)';

  @override
  String get legacyUi90eceb016c => 'Prefix';

  @override
  String get legacyUif1fbb2b43d => 'Preview';

  @override
  String get legacyUiba3e0b4a86 => 'Preview updated';

  @override
  String get legacyUi81f547195b => 'Previous page';

  @override
  String get legacyUi3e8248e32e => 'Price';

  @override
  String get legacyUi15ac0c0a27 => 'Pricing plan';

  @override
  String get legacyUid3dcce7d10 => 'Primary Color';

  @override
  String get legacyUi170f443f36 => 'Primary User';

  @override
  String get legacyUia1055f11a9 => 'Primary color';

  @override
  String get legacyUic1ee865b42 => 'Primary color (hex)';

  @override
  String get legacyUi0554f68465 => 'Primary user';

  @override
  String get legacyUi1e5947a051 =>
      'Primary user, device, vehicle type, and pricing plan are required.';

  @override
  String get legacyUi886cbff9d9 => 'Priority';

  @override
  String get legacyUi7e7302bb73 => 'Profile not loaded yet.';

  @override
  String get legacyUi5049e8f42b => 'Profile photo updated';

  @override
  String get legacyUi49ba5b4d7b => 'Profile settings unavailable';

  @override
  String get legacyUibcf7629607 => 'Profile updated.';

  @override
  String get legacyUibda244507b =>
      'Profile, company, or configuration changes will appear here.';

  @override
  String get legacyUi204be1a53a => 'Projected';

  @override
  String get legacyUi5c620cdb78 => 'Proof type';

  @override
  String get legacyUi1ed77c3f7f => 'Protocol';

  @override
  String get legacyUi7ceee3f361 => 'Provider';

  @override
  String get legacyUi767359109d => 'Provider Ref';

  @override
  String get legacyUi8d80f9c731 => 'Provider coverage expires';

  @override
  String get legacyUi8a87202949 => 'Public URL is not available.';

  @override
  String get legacyUi411c13db3b => 'Public signup and welcome credits.';

  @override
  String get legacyUicf0a64d03d =>
      'Pull to refresh and try loading your profile again.';

  @override
  String get legacyUic8f58b21ae => 'Pull to refresh or add a new driver.';

  @override
  String get legacyUi011bc421c2 => 'Pull to refresh or create a new sub user.';

  @override
  String get legacyUi6a599877d7 => 'Queued';

  @override
  String get legacyUia16c5bbe4b => 'Range';

  @override
  String get legacyUida433cd41e => 'Raw';

  @override
  String get legacyUice09c15f57 => 'Raw packet';

  @override
  String get legacyUia3ccb33027 => 'Razorpay';

  @override
  String get legacyUi2af51c3e17 => 'Re-enter the password';

  @override
  String get legacyUi852b438f91 => 'Read';

  @override
  String get legacyUid14d593883 => 'Read all';

  @override
  String get legacyUi00db810078 => 'Reason for adjustment';

  @override
  String get legacyUid4835a2d13 =>
      'Reason for amount override (5–500 characters)';

  @override
  String get legacyUi03c3ccd3ff => 'Recent Alerts';

  @override
  String get legacyUi3abf211c93 => 'Recent Payments';

  @override
  String get legacyUi93c62de33f => 'Recent Users';

  @override
  String get legacyUi6b33999078 => 'Recent Vehicles';

  @override
  String get legacyUi790a1b9e7b =>
      'Recent activity will appear here once the backend returns it.';

  @override
  String get legacyUic1541851a1 => 'Recent service activity';

  @override
  String get legacyUi204110a010 =>
      'Recent users will appear here when the dashboard overview returns them.';

  @override
  String get legacyUida67fde0f7 => 'Recenter';

  @override
  String get legacyUi7df7c0bb40 => 'Recipient email';

  @override
  String get legacyUi8ee92c936a => 'Recipient/User';

  @override
  String get legacyUi6577ced3c0 => 'Record Payment';

  @override
  String get legacyUib19313692e => 'Recorded By';

  @override
  String get legacyUi471b94d402 => 'Redo';

  @override
  String get legacyUidb1c784524 => 'Reference';

  @override
  String get legacyUic9dc8442d5 => 'Reference (Optional)';

  @override
  String get legacyUie3039b8476 => 'Reference (optional)';

  @override
  String get legacyUid8b2ee1dcd => 'Reference max length is 200';

  @override
  String get legacyUi7a8e2a362c => 'Reference must be 100 characters or less.';

  @override
  String get legacyUi483e715402 => 'Refresh administrators';

  @override
  String get legacyUif2b5787c06 => 'Refresh dashboard';

  @override
  String get legacyUie75f05fced => 'Refresh drivers';

  @override
  String get legacyUiebbc55f9ce => 'Refresh history';

  @override
  String get legacyUid0512701b2 => 'Refresh inventory';

  @override
  String get legacyUif6cf59106a => 'Refresh messages';

  @override
  String get legacyUid7cb2b4eea => 'Refresh report options';

  @override
  String get legacyUi323540a087 => 'Refresh settings';

  @override
  String get legacyUiade15a52e2 => 'Refresh status';

  @override
  String get legacyUie4d3b8b5ff => 'Refresh team';

  @override
  String get legacyUi12f92ceb6e => 'Refresh tickets';

  @override
  String get legacyUi3367ca735f => 'Refresh transactions';

  @override
  String get legacyUi892f6f322d => 'Refresh users';

  @override
  String get legacyUidf50facb6a => 'Refresh vehicles';

  @override
  String get legacyUid42d9c1932 => 'Refresh widget';

  @override
  String get legacyUia844fcf834 => 'Registered';

  @override
  String get legacyUi9aba73febb => 'Registered token last 10';

  @override
  String get legacyUic498221a5a => 'Registration date';

  @override
  String get legacyUi20e264f6a1 => 'Related stop';

  @override
  String get legacyUi62d14389b3 => 'Reload document types';

  @override
  String get legacyUia2653dac4a => 'Remark';

  @override
  String get legacyUie963907dac => 'Remove';

  @override
  String get legacyUi0fcc6594fc => 'Remove attachment';

  @override
  String get legacyUi48666118ca => 'Remove metadata row';

  @override
  String get legacyUif96ba1e583 =>
      'Remove vehicle assignment from this driver?';

  @override
  String get legacyUi0165f7088a => 'Renew';

  @override
  String get legacyUib219a06163 => 'Renew Vehicle';

  @override
  String get legacyUi4913250b6c => 'Renew annual coverage';

  @override
  String get legacyUif192fe3e94 => 'Renew annual coverage?';

  @override
  String get legacyUi1cce449350 => 'Renew up to 100 vehicles at a time';

  @override
  String get legacyUi714c2b126f => 'Renew up to 100 vehicles at a time.';

  @override
  String get legacyUibb47b991fe => 'Renewal requests';

  @override
  String get legacyUiac2377c0dd => 'Replay speed';

  @override
  String get legacyUi5cc45fda55 =>
      'Replies will appear here once the conversation starts.';

  @override
  String get legacyUid7a41420c8 =>
      'Replies will appear here once the ticket conversation starts.';

  @override
  String get legacyUi1f21d9edca => 'Reply is too long.';

  @override
  String get legacyUi4c7c79f6a9 => 'Reply message is required.';

  @override
  String get legacyUic9e8dd4159 => 'Reply sent successfully.';

  @override
  String get legacyUi5ce1bacd48 => 'Reply sent.';

  @override
  String get legacyUi49072e5767 => 'Reply-To (optional)';

  @override
  String get legacyUi6e2c712363 => 'Report issue';

  @override
  String get legacyUi0ca4fce136 => 'Report type';

  @override
  String get legacyUi4857497af3 => 'Request a new reset link';

  @override
  String get legacyUida30a140cc => 'Request vehicle renewal?';

  @override
  String get legacyUic26bf60fed => 'Requested';

  @override
  String get legacyUi1d3cb8a962 => 'Resend code';

  @override
  String get legacyUi56553100b0 => 'Reset filters';

  @override
  String get legacyUibb02ea158c => 'Reset link or token';

  @override
  String get legacyUi3ddc852b26 => 'Reset north';

  @override
  String get legacyUi5c4bc97ee5 => 'Reset password';

  @override
  String get legacyUi4f21821190 => 'Responded';

  @override
  String get legacyUi966ea65ee9 => 'Response hex';

  @override
  String get legacyUi3585d7553d => 'Restaurant';

  @override
  String get legacyUiab6d02bfbb => 'Restricted by your administrator';

  @override
  String get legacyUic7199d9e95 => 'Retention';

  @override
  String get legacyUi9393bfa8e2 => 'Retention period';

  @override
  String get legacyUibf1c27deea => 'Retry loading currencies';

  @override
  String get legacyUi2e84dd3c7d => 'Retry registration';

  @override
  String get legacyUic507a566fc => 'Reverse Geocoding Precision';

  @override
  String get legacyUi7148d08646 => 'Ripple';

  @override
  String get legacyUic3f104d136 => 'Role';

  @override
  String get legacyUib1b392607d => 'Run';

  @override
  String get legacyUi26c35575bf => 'Run Sensor';

  @override
  String get legacyUiba51f0a9fa => 'Run a history search';

  @override
  String get legacyUia84c30c93c => 'Run cleanup';

  @override
  String get legacyUibd4e4bc9f2 => 'SIM Number';

  @override
  String get legacyUi135447fb8f => 'SIM Only';

  @override
  String get legacyUi3454bbef7f => 'SIM Provider';

  @override
  String get legacyUi0366e95ddf => 'SIM Provider (optional)';

  @override
  String get legacyUi4636ab9e9a => 'SIM card updated.';

  @override
  String get legacyUi12897d0b88 => 'SIM status';

  @override
  String get legacyUi1f4f5e7e3c => 'SMTP account login.';

  @override
  String get legacyUi7d08205aa6 => 'SMTP settings saved';

  @override
  String get legacyUia70c3bcf1d => 'San Francisco';

  @override
  String get legacyUi340bbc7875 => 'Satellites';

  @override
  String get legacyUidb95397447 => 'Save .kml';

  @override
  String get legacyUifa2984b367 => 'Save Changes';

  @override
  String get legacyUi78fe0922d6 => 'Save Company';

  @override
  String get legacyUic6606cd51c => 'Save Config';

  @override
  String get legacyUi909bf3e807 => 'Save Profile';

  @override
  String get legacyUif2f3d66a79 => 'School';

  @override
  String get legacyUid09c8bca28 => 'Search SIM number…';

  @override
  String get legacyUiabddbf1811 => 'Search activity logs...';

  @override
  String get legacyUi9a99566535 => 'Search activity…';

  @override
  String get legacyUi1321daf435 => 'Search assigned drivers';

  @override
  String get legacyUie6ac2b6800 => 'Search assigned vehicles';

  @override
  String get legacyUi3a97577679 => 'Search available drivers';

  @override
  String get legacyUiacd1382ab4 => 'Search available vehicles';

  @override
  String get legacyUi03ef7546a9 => 'Search by IMEI...';

  @override
  String get legacyUia8854d5f97 => 'Search by code...';

  @override
  String get legacyUi411482b8e7 =>
      'Search by date, activity, credits, vehicle…';

  @override
  String get legacyUi28abc0313d => 'Search by name';

  @override
  String get legacyUi28f3d064ea => 'Search by name or category';

  @override
  String get legacyUi4120e178da => 'Search by name or plate…';

  @override
  String get legacyUibb6cfd804d => 'Search by name, email…';

  @override
  String get legacyUi1c1d641fe8 => 'Search by name, plate, IMEI, or VIN';

  @override
  String get legacyUife32b8f32a => 'Search by name, plate, IMEI…';

  @override
  String get legacyUibdc6551409 => 'Search by name, plate, VIN, IMEI, SIM...';

  @override
  String get legacyUiba20cfd893 => 'Search by reference or admin...';

  @override
  String get legacyUi45b6baaad3 => 'Search daily records...';

  @override
  String get legacyUie43926680a => 'Search device logs';

  @override
  String get legacyUi26eb1d222b => 'Search device type…';

  @override
  String get legacyUi98110e65a0 => 'Search loaded logs';

  @override
  String get legacyUi48225af1f4 => 'Search logs';

  @override
  String get legacyUi20f28ed35b => 'Search name, IMEI, SIM, type';

  @override
  String get legacyUic60723c651 => 'Search name, plate or IMEI';

  @override
  String get legacyUi3dadc5cddf =>
      'Search name, username, email, mobile, vehicle, plate...';

  @override
  String get legacyUi0417c5f97b => 'Search name, username, email, mobile...';

  @override
  String get legacyUi5196e5c8da => 'Search place or address...';

  @override
  String get legacyUic3290fb221 => 'Search place...';

  @override
  String get legacyUi60c8ce351b => 'Search plans, currency, duration, price...';

  @override
  String get legacyUie5483c71e7 => 'Search provider…';

  @override
  String get legacyUi98e27d7b41 =>
      'Search reference, provider, counterparty...';

  @override
  String get legacyUidd77f6ecc1 => 'Search reference, provider, user, vehicle';

  @override
  String get legacyUi0066a752cb => 'Search routes by name';

  @override
  String get legacyUi502e6eaf2c => 'Search sensors';

  @override
  String get legacyUi0cfffb61af => 'Search sensors...';

  @override
  String get legacyUi233ad2b14f => 'Search subject, number, status';

  @override
  String get legacyUid320d41a03 => 'Search tickets';

  @override
  String get legacyUi65da39d5f0 => 'Search transactions...';

  @override
  String get legacyUi25dfae4e3a => 'Search trips';

  @override
  String get legacyUida80ead473 => 'Search unlinked users...';

  @override
  String get legacyUie5b2404515 => 'Search users, vehicles…';

  @override
  String get legacyUi8cdc4c0930 => 'Search users...';

  @override
  String get legacyUi2e4b72c10c => 'Search vehicle';

  @override
  String get legacyUi1bd54471c2 => 'Search vehicle events...';

  @override
  String get legacyUiba537c59ae =>
      'Search vehicle, plate, VIN, IMEI, SIM, user…';

  @override
  String get legacyUi4a54a9e6db => 'Search vehicle, plate, VIN, IMEI, SIM...';

  @override
  String get legacyUi5780b5d6bf => 'Search vehicles';

  @override
  String get legacyUi50efae1b5f => 'Search vehicles by name, plate, plan...';

  @override
  String get legacyUib09b43245d => 'Search vehicles...';

  @override
  String get legacyUif54fbca187 => 'Search…';

  @override
  String get legacyUifaaee5e23e => 'Select SIM';

  @override
  String get legacyUi69cc521201 => 'Select a country';

  @override
  String get legacyUi400a58f1cc => 'Select a range to load history.';

  @override
  String get legacyUie216b735f0 => 'Select a user first.';

  @override
  String get legacyUie965317576 => 'Select a vehicle first.';

  @override
  String get legacyUia72bd23c12 =>
      'Select a vehicle, stop threshold, and date time range.';

  @override
  String get legacyUi29c9360313 => 'Select administrator';

  @override
  String get legacyUi8a152d2c3f => 'Select at least one renewable vehicle';

  @override
  String get legacyUi5573da8514 => 'Select at least one vehicle.';

  @override
  String get legacyUi42303635fc => 'Select city';

  @override
  String get legacyUi9915f6e5c2 => 'Select color';

  @override
  String get legacyUia96ce92893 => 'Select command template';

  @override
  String get legacyUi59ee76bad1 => 'Select country';

  @override
  String get legacyUi74c388ab91 => 'Select date time range';

  @override
  String get legacyUi46bfa11b12 => 'Select device type';

  @override
  String get legacyUidba2e6bd04 => 'Select document type';

  @override
  String get legacyUi386f8ba9d0 => 'Select primary user';

  @override
  String get legacyUic7a9e8ea6a => 'Select provider';

  @override
  String get legacyUib350802ae1 => 'Select state';

  @override
  String get legacyUi905d012288 => 'Select type';

  @override
  String get legacyUib8a1d9de7d => 'Select user';

  @override
  String get legacyUie574e3a29d =>
      'Select vehicles with the same plan currency';

  @override
  String get legacyUi07f0f61db9 => 'Selected file is empty.';

  @override
  String get legacyUi9bc2575c39 => 'Send';

  @override
  String get legacyUi0ad7c21624 => 'Send Command';

  @override
  String get legacyUi9b48248439 => 'Send a command to see history.';

  @override
  String get legacyUi724aa54b02 => 'Send command to vehicle?';

  @override
  String get legacyUic70a890d14 => 'Send message';

  @override
  String get legacyUia89d641794 => 'Send request';

  @override
  String get legacyUib8ec554332 => 'Send reset link';

  @override
  String get legacyUi1aba33d6c2 => 'Send test';

  @override
  String get legacyUifc552c754d => 'Send test email';

  @override
  String get legacyUi17b874d289 => 'Sender';

  @override
  String get legacyUi679e8f61b9 => 'Sender Name';

  @override
  String get legacyUi73dcba5635 => 'Sensor History';

  @override
  String get legacyUia14460cfb3 => 'Sensor History Range';

  @override
  String get legacyUia9bc44292f => 'Sensor actions';

  @override
  String get legacyUi18d80b838f => 'Sensor deleted.';

  @override
  String get legacyUi711bf35988 => 'Sensors';

  @override
  String get legacyUi48380dd0e2 => 'Sensors unavailable';

  @override
  String get legacyUi35f49dcfbf => 'Sent';

  @override
  String get legacyUi2d7bb03171 =>
      'Sent commands and device responses appear here.';

  @override
  String get legacyUi1d5d1effa9 => 'Server URL';

  @override
  String get legacyUif85e6f1bdc => 'Server Uptime';

  @override
  String get legacyUi10802e852c => 'Server time';

  @override
  String get legacyUi7ef53dd844 => 'Service expiry must follow registration.';

  @override
  String get legacyUi2ad34ef4cf => 'Service plan';

  @override
  String get legacyUi2bacd5f581 => 'Service starts';

  @override
  String get legacyUiaa02a8d843 => 'Set Engine Hours';

  @override
  String get legacyUi837c0d47b5 => 'Set Odometer';

  @override
  String get legacyUiaef97bb06a => 'Settings saved';

  @override
  String get legacyUi96a0dc481b => 'Shopping';

  @override
  String get legacyUi5e65ca08ed => 'Short issue title';

  @override
  String get legacyUi4c742d5133 => 'Show Geofence';

  @override
  String get legacyUi5abbf34ba3 => 'Show History';

  @override
  String get legacyUi8268618610 =>
      'Show animated pulse around running vehicles';

  @override
  String get legacyUi25911d48e0 => 'Show more';

  @override
  String get legacyUi50b47f1483 => 'Show points of interest markers';

  @override
  String get legacyUib7f93469b9 => 'Show route trail';

  @override
  String get legacyUi510904927e =>
      'Show vehicle name next to the icon on the map';

  @override
  String get legacyUi6e61e47d5c =>
      'Shown on dark backgrounds. PNG, JPG, SVG, WEBP. Max 5 MB.';

  @override
  String get legacyUi39e4052ecf =>
      'Shown on light backgrounds. PNG, JPG, SVG, WEBP. Max 5 MB.';

  @override
  String get legacyUi894bc414e6 => 'Signup';

  @override
  String get legacyUi69c2037890 => 'Skip end';

  @override
  String get legacyUia8522e4c9d => 'Skip start';

  @override
  String get legacyUi33dcec9ce4 => 'Slow';

  @override
  String get legacyUicf606d0913 => 'Slower';

  @override
  String get legacyUi339c1ea94b => 'Social Links';

  @override
  String get legacyUi3db7211438 => 'Sort SIM cards';

  @override
  String get legacyUi66758a74bc => 'Sort administrators';

  @override
  String get legacyUi3655295cb4 => 'Sort devices';

  @override
  String get legacyUi3a21e72182 => 'Sort drivers';

  @override
  String get legacyUi1e891a0102 => 'Sort team';

  @override
  String get legacyUi6d1ba980e8 => 'Sort users';

  @override
  String get legacyUi2512bda9e7 => 'Sort vehicles';

  @override
  String get legacyUi6da13addb0 => 'Source';

  @override
  String get legacyUi6ace449732 => 'South';

  @override
  String get legacyUi2d2cb022bc => 'Speed';

  @override
  String get legacyUi8a14aeec13 => 'Speed Multiplier';

  @override
  String get legacyUid6a0aaa660 => 'Speed Variation';

  @override
  String get legacyUi09a7707087 => 'Start manually';

  @override
  String get legacyUi7e244fee11 => 'Start time must be before end time.';

  @override
  String get legacyUia725020675 => 'State';

  @override
  String get legacyUi4e5c9805af => 'State (optional)';

  @override
  String get legacyUic01247416e => 'State is required.';

  @override
  String get legacyUiedde30a0b6 => 'Status : ';

  @override
  String get legacyUia0539c7e7a =>
      'Status distribution is not available for this range.';

  @override
  String get legacyUie4fe064446 => 'Stop Minutes';

  @override
  String get legacyUif32715a2f1 => 'Stoppage marker';

  @override
  String get legacyUi5ca845e914 => 'Street, building, area…';

  @override
  String get legacyUi4d08ec5874 => 'Stripe';

  @override
  String get legacyUi8de713bd12 => 'Sub Users';

  @override
  String get legacyUi97a0373212 => 'Sub user created.';

  @override
  String get legacyUi5cae4f427b => 'Sub user deleted.';

  @override
  String get legacyUi2cc74ff5c3 => 'Sub user name';

  @override
  String get legacyUie44d50f72d => 'Sub user updated.';

  @override
  String get legacyUibd3159ff21 => 'Subject is required.';

  @override
  String get legacyUi6844979e4f =>
      'Subject must contain at least one letter or number.';

  @override
  String get legacyUid6981f7476 => 'Subscribe';

  @override
  String get legacyUia547aab586 => 'Subscribed to email updates';

  @override
  String get legacyUid7932a2917 => 'Successful';

  @override
  String get legacyUib879505819 => 'Support Ticket';

  @override
  String get legacyUi848eed0fbd => 'Tags';

  @override
  String get legacyUi8c7e01ee22 => 'Tags (comma separated)';

  @override
  String get legacyUi1df356a49e =>
      'Tap the map or enter coordinates to place the POI.';

  @override
  String get legacyUi61ad50a9b9 => 'Target';

  @override
  String get legacyUi78560d88ef => 'Team activated.';

  @override
  String get legacyUid8f82f6030 => 'Team activity';

  @override
  String get legacyUi8aef227384 => 'Team deactivated.';

  @override
  String get legacyUi72df525608 => 'Team member created.';

  @override
  String get legacyUi07fed9d9b3 => 'Team member updated.';

  @override
  String get legacyUi0194c31b6d => 'Team permissions updated';

  @override
  String get legacyUi6730423d83 => 'Telemetry Detail';

  @override
  String get legacyUieef4095d19 => 'Telemetry Logs';

  @override
  String get legacyUif8d42e6122 => 'Telemetry date range';

  @override
  String get legacyUi3ec1ae061c => 'Template';

  @override
  String get legacyUi7200f86ae5 => 'Test Mobile Push';

  @override
  String get legacyUi8b9bbdf230 => 'Test Push';

  @override
  String get legacyUi8135cd8fa3 =>
      'The customer can create a fresh request. No vehicle service is extended.';

  @override
  String get legacyUidc46c2859b => 'The link expires automatically.';

  @override
  String get legacyUic77eaa41ef =>
      'The organisation this administrator manages within OpenVTS.';

  @override
  String get legacyUi461197e42e =>
      'The organisation this user belongs to within OpenVTS.';

  @override
  String get legacyUia491398fbb =>
      'The overview response does not include chart points yet.';

  @override
  String get legacyUi214cddfadb =>
      'The overview response does not include recent vehicles yet.';

  @override
  String get legacyUi9e4a7b1c4c =>
      'The permission catalog is unavailable. Editing is disabled.';

  @override
  String get legacyUiac4a475bbb =>
      'The server returned an unsupported permission catalog. Editing is disabled.';

  @override
  String get legacyUi8895c1d4b6 =>
      'The upload finished, but the new profile photo was not returned by the server.';

  @override
  String get legacyUidbc2f6bd85 => 'There are no alerts available right now.';

  @override
  String get legacyUi9b519b14b9 => 'There are no events on this day';

  @override
  String get legacyUi354cfe028c =>
      'These changes grant global or delete access. Apply them to this team member?';

  @override
  String get legacyUi0f6cc3a89c => 'This Month';

  @override
  String get legacyUi77528c94d9 => 'This Year';

  @override
  String get legacyUi951f495b34 => 'This action cannot be undone.';

  @override
  String get legacyUi9b646010b8 => 'This file type is not allowed.';

  @override
  String get legacyUi1b4785331d => 'This month';

  @override
  String get legacyUi0e606e3993 => 'This saved dashboard has no widgets yet.';

  @override
  String get legacyUi1e191e95f4 => 'This ticket is closed.';

  @override
  String get legacyUi8866cb1e0a =>
      'This uses one account credit when the vehicle is eligible.';

  @override
  String get legacyUi7b72883e07 => 'This week';

  @override
  String get legacyUi261bd2f51b => 'Ticket Conversation';

  @override
  String get legacyUie1b858991f => 'Ticket created.';

  @override
  String get legacyUi61322c9a86 => 'Ticket details';

  @override
  String get legacyUif1e8e34245 => 'Ticket details are not available';

  @override
  String get legacyUiaa27494c39 => 'Ticket status updated.';

  @override
  String get legacyUiedcd363083 => 'Timed out';

  @override
  String get legacyUi768e0c1c69 => 'Title';

  @override
  String get legacyUie39bf0152d => 'Today Distance';

  @override
  String get legacyUif43482f042 => 'Today Eng. Hours';

  @override
  String get legacyUi7adacb5405 => 'Toggle Status';

  @override
  String get legacyUi6d91e0bb03 => 'Tolerance';

  @override
  String get legacyUid1bbcb6c01 => 'Tolerance (meters)';

  @override
  String get legacyUi63cfb27f40 => 'Top Clients';

  @override
  String get legacyUibc6debbc28 => 'Top Performing Assets';

  @override
  String get legacyUib25928c699 => 'Total';

  @override
  String get legacyUia672e7faed => 'Total Eng. Hours';

  @override
  String get legacyUie9511a6560 => 'Total Received';

  @override
  String get legacyUia028fce203 => 'Total Users';

  @override
  String get legacyUi5bcce6c936 => 'Total Vehicles';

  @override
  String get legacyUi7b777b27e0 => 'Total engine hours';

  @override
  String get legacyUi8578188376 => 'Total logs';

  @override
  String get legacyUi0538b10824 => 'Track Link QR';

  @override
  String get legacyUi070fb0b6ea => 'Track link deleted.';

  @override
  String get legacyUief1f899cb2 => 'Transaction Details';

  @override
  String get legacyUi06d8ffe653 => 'Transaction ID';

  @override
  String get legacyUi105b1510d9 =>
      'Transaction activity will appear here when available.';

  @override
  String get legacyUid016e453e5 => 'Transaction details';

  @override
  String get legacyUiab39260fea => 'Transitions';

  @override
  String get legacyUic10d76c9a4 => 'Transport';

  @override
  String get legacyUie82c27ca1d => 'Trip cancelled';

  @override
  String get legacyUi4a9e77914e => 'Try a different name or plate.';

  @override
  String get legacyUi4e653834fa => 'Try a different search or filter.';

  @override
  String get legacyUi39d6420eaa => 'Try a different search term';

  @override
  String get legacyUi0ba628a33e => 'Try a different search term.';

  @override
  String get legacyUi10239b38b5 =>
      'Try adjusting the current filters or search query.';

  @override
  String get legacyUi2253479cff => 'Try adjusting your filters.';

  @override
  String get legacyUie3f4c649b5 => 'Try another name or plate number.';

  @override
  String get legacyUi10f570e880 => 'Try changing filters or search query.';

  @override
  String get legacyUif28432df1f => 'Try changing filters.';

  @override
  String get legacyUi3c86b09439 => 'Try changing search or filters.';

  @override
  String get legacyUi0ba0bd18bf => 'Try clearing search or status filters.';

  @override
  String get legacyUi7a2fe508f6 =>
      'Try refreshing. If this persists, your account may not have notification preferences yet.';

  @override
  String get legacyUia0b470cb00 => 'Twitter / X';

  @override
  String get legacyUi8981df4d6a => 'Twitter/X';

  @override
  String get legacyUi3deb745651 => 'Type';

  @override
  String get legacyUie298b0ec36 => 'Type ';

  @override
  String get legacyUi4b3072dd4e => 'Type command payload';

  @override
  String get legacyUi5712bb4ea1 => 'Type manually';

  @override
  String get legacyUi968be8d576 => 'Unable to change password.';

  @override
  String get legacyUi1da33a6b30 => 'Unable to load cities.';

  @override
  String get legacyUia4c5468d38 => 'Unable to load company details.';

  @override
  String get legacyUicbae41853b => 'Unable to load form options.';

  @override
  String get legacyUid06763ac1a => 'Unable to load states.';

  @override
  String get legacyUia471ebf750 => 'Unable to load users.';

  @override
  String get legacyUibf0bc28bdb => 'Unable to load vehicles.';

  @override
  String get legacyUid73d7a7c96 => 'Unable to open file.';

  @override
  String get legacyUi8ace6e9280 => 'Unable to open image picker.';

  @override
  String get legacyUidcbaa0588e =>
      'Unable to open navigation for this vehicle.';

  @override
  String get legacyUi14fdbab84b => 'Unable to open this attachment.';

  @override
  String get legacyUia457295e9f => 'Unable to read the selected image.';

  @override
  String get legacyUi9e97e5bfed => 'Unable to refresh users.';

  @override
  String get legacyUi800f200671 => 'Unable to update status.';

  @override
  String get legacyUice1c9c972b => 'Unable to update team member status.';

  @override
  String get legacyUib5f12c7d4f => 'Unable to update team member.';

  @override
  String get legacyUia046b8ac56 => 'Unable to update the server URL.';

  @override
  String get legacyUi896bfd3a9a => 'Unassign';

  @override
  String get legacyUi7be6acc7f8 => 'Unassign User?';

  @override
  String get legacyUi05027a8753 => 'Unassign user';

  @override
  String get legacyUi2d5a96092e => 'Unassign vehicle';

  @override
  String get legacyUi39fc721248 => 'Undo';

  @override
  String get legacyUice77c2f42c => 'Unique code';

  @override
  String get legacyUif6b935ab33 => 'Unit';

  @override
  String get legacyUi07b032b56f => 'Unread';

  @override
  String get legacyUi100cb4d890 => 'Unsupported file type.';

  @override
  String get legacyUicb9925a338 =>
      'Unsupported format. Use PNG, JPG, JPEG or WEBP.';

  @override
  String get legacyUi99974d3476 => 'Unsupported widget';

  @override
  String get legacyUieb27a190c0 => 'Unverified';

  @override
  String get legacyUi61dcf34e70 => 'Update Password';

  @override
  String get legacyUieae1f5caf5 => 'Update status';

  @override
  String get legacyUif2f8570ddd => 'Updated';

  @override
  String get legacyUi22714274a4 => 'Updated At';

  @override
  String get legacyUi8bdf057f91 => 'Upload';

  @override
  String get legacyUi9e2628eec4 => 'Upload Document';

  @override
  String get legacyUidcad7d982a => 'Upload a document to get started.';

  @override
  String get legacyUi73183a7050 => 'Upload document';

  @override
  String get legacyUid714896782 => 'Upload documents for this vehicle.';

  @override
  String get legacyUi4b87ccd949 =>
      'Upload driver files like license or identity proofs.';

  @override
  String get legacyUi6aafa80cab => 'Uptime';

  @override
  String get legacyUif1f71137de => 'Use a strong, unique password';

  @override
  String get legacyUid81b6af542 => 'Use all';

  @override
  String get legacyUi5895bc72eb =>
      'Used for regional defaults like currency, timezone, and routing.';

  @override
  String get legacyUi81c9245d46 => 'User Tickets';

  @override
  String get legacyUi81939432dd => 'User actions';

  @override
  String get legacyUi0abfc13cb8 => 'User assigned.';

  @override
  String get legacyUi6188702f9e => 'User created and selected';

  @override
  String get legacyUi0ba72d0bce => 'User deleted.';

  @override
  String get legacyUi8fd72dd6f9 => 'User is required';

  @override
  String get legacyUi5ed13310cc => 'User is required.';

  @override
  String get legacyUib0b238b57a => 'User permissions updated';

  @override
  String get legacyUia42cd2f9d5 => 'User unassigned.';

  @override
  String get legacyUi2355aced23 => 'User updated.';

  @override
  String get legacyUi84c29015de => 'Username';

  @override
  String get legacyUib1974b83bc => 'Username (optional)';

  @override
  String get legacyUi2c7ab350b3 => 'Username or email';

  @override
  String get legacyUi73dbef356e => 'VIN (optional)';

  @override
  String get legacyUi39852971ee => 'VIN Number';

  @override
  String get legacyUia4aefa35c3 => 'Valid';

  @override
  String get legacyUi8dce170de2 => 'Value';

  @override
  String get legacyUi7bac966778 => 'Vehicle / Plan';

  @override
  String get legacyUi43188a5960 => 'Vehicle Event Detail';

  @override
  String get legacyUi2d80c33ed3 => 'Vehicle Events';

  @override
  String get legacyUi4d461104bf => 'Vehicle Expiry';

  @override
  String get legacyUi9e47ccbff4 => 'Vehicle IMEI is required to load events.';

  @override
  String get legacyUi2b51e72835 => 'Vehicle IMEI is required to load sensors.';

  @override
  String get legacyUief04c2235a =>
      'Vehicle IMEI is required to load telemetry logs.';

  @override
  String get legacyUi62dc158d0e => 'Vehicle Label';

  @override
  String get legacyUicb4e4154e4 => 'Vehicle Meta';

  @override
  String get legacyUi92dc53a1bc => 'Vehicle Name';

  @override
  String get legacyUi441399c250 => 'Vehicle Selection';

  @override
  String get legacyUi2d6ca00998 => 'Vehicle Type';

  @override
  String get legacyUi5c931770ef => 'Vehicle actions';

  @override
  String get legacyUi6ac26355c9 =>
      'Vehicle activity and system logs will appear here.';

  @override
  String get legacyUi4e4942337f => 'Vehicle and Plan';

  @override
  String get legacyUi6ec60a25f7 => 'Vehicle assigned.';

  @override
  String get legacyUia31471cef9 =>
      'Vehicle assignment or vehicle updates will appear here.';

  @override
  String get legacyUib7975a2537 => 'Vehicle deleted.';

  @override
  String get legacyUiff47117f38 => 'Vehicle details';

  @override
  String get legacyUia1fbfba50c => 'Vehicle details are unavailable.';

  @override
  String get legacyUi79c500fa20 => 'Vehicle event date range';

  @override
  String get legacyUie981db4fa0 => 'Vehicle events will appear here.';

  @override
  String get legacyUi7eefc642f4 => 'Vehicle group';

  @override
  String get legacyUi5cd0230ee5 => 'Vehicle id is missing.';

  @override
  String get legacyUi39ea43c097 => 'Vehicle identification number';

  @override
  String get legacyUida83429197 => 'Vehicle name';

  @override
  String get legacyUi750a5503ac => 'Vehicle position';

  @override
  String get legacyUi40a1e7dd80 => 'Vehicle record is not available.';

  @override
  String get legacyUi686853d97d => 'Vehicle renew payment submitted';

  @override
  String get legacyUie1071916e2 => 'Vehicle renewal recorded.';

  @override
  String get legacyUibf31403ac2 => 'Vehicle scope';

  @override
  String get legacyUi3c760a5151 => 'Vehicle service';

  @override
  String get legacyUi9aafada9ec =>
      'Vehicle service revision unavailable. Reload before editing.';

  @override
  String get legacyUia0d9ad9324 => 'Vehicle service updated';

  @override
  String get legacyUi97d4120359 => 'Vehicle services';

  @override
  String get legacyUif9709ba7c4 =>
      'Vehicle telemetry updates progress automatically. Manual completion is available for the current stop only.';

  @override
  String get legacyUi9644381920 => 'Vehicle type';

  @override
  String get legacyUi8b26242493 => 'Vehicle type filter';

  @override
  String get legacyUi2a37343d0a => 'Vehicle unassigned.';

  @override
  String get legacyUif28657d034 => 'Vehicle unavailable';

  @override
  String get legacyUi917981e400 => 'Vehicle updated.';

  @override
  String get legacyUi02236966b5 => 'Vehicles Affected';

  @override
  String get legacyUi776abb6631 => 'Vehicles assigned.';

  @override
  String get legacyUi433457e28d => 'Vehicles could not be loaded.';

  @override
  String get legacyUi03128bed90 => 'Verification';

  @override
  String get legacyUiaed3b8c6a7 => 'Verified';

  @override
  String get legacyUidda6ac27b9 => 'Verify';

  @override
  String get legacyUi69bd4ef9fb => 'View';

  @override
  String get legacyUi5b9306d29c => 'View Payments';

  @override
  String get legacyUie3c9374cd6 => 'View all trips';

  @override
  String get legacyUib1614cb4e6 => 'View/Download';

  @override
  String get legacyUi1b6cc58781 => 'Violations by Severity';

  @override
  String get legacyUi1fe59390ac => 'Visible';

  @override
  String get legacyUi4fc5a421da => 'Visible To Admin';

  @override
  String get legacyUi1448afee1d => 'Visible To Driver';

  @override
  String get legacyUib60862f485 => 'Wallet';

  @override
  String get legacyUic4fe2a7498 => 'Web Push';

  @override
  String get legacyUi2e8a57cc5c => 'Website';

  @override
  String get legacyUib32233ad82 => 'Website URL';

  @override
  String get legacyUica976c5dc6 => 'Weekly Comparison';

  @override
  String get legacyUidd322f2dc7 => 'West';

  @override
  String get legacyUib336fc5587 => 'WhatsApp';

  @override
  String get legacyUi16ec75e229 => 'Who recipients see in the inbox.';

  @override
  String get legacyUi682d44be54 => 'With device';

  @override
  String get legacyUi0a58e1d0a2 => 'Write a reply';

  @override
  String get legacyUi126cd2cd36 => 'Write a reply...';

  @override
  String get legacyUib58c0082b4 => 'You are all caught up.';

  @override
  String get legacyUi558865a16f => 'YouTube';

  @override
  String get legacyUid3639ca4df =>
      'Your account does not have permission to view this section.';

  @override
  String get legacyUice100fe123 =>
      'Your changes will be lost. This action cannot be undone.';

  @override
  String get legacyUi9b3cbed5c4 => 'Zoom';

  @override
  String get legacyUi4fc05f2763 => 'Zoom in';

  @override
  String get legacyUia4ae4b24a1 => 'Zoom out';

  @override
  String get legacyUib6958e3c52 => 'apikey or username';

  @override
  String get legacyUib5f203a910 => 'cmdId';

  @override
  String get legacyUif05135d639 => 'insurance, permit';

  @override
  String get legacyUid127ec8ef2 => 'jane@company.com';

  @override
  String get legacyUi216fb6179a => 'km/h, C, V';

  @override
  String get legacyUi7252f9e8d5 => 'last 7 days';

  @override
  String get legacyUibbdead93fb => 'license, identity, permit';

  @override
  String get legacyUid7cb0327fd => 'license, insurance';

  @override
  String get legacyUica62660225 => 'noreply@example.com';

  @override
  String get legacyUid043e53c7d => 'queueId';

  @override
  String get legacyUi11c8ce1244 => 'recipient@example.com';

  @override
  String get legacyUi4b329f8934 => 'speed, fuel';

  @override
  String get legacyUi65e012062c => 'support@example.com';

  @override
  String get legacyUi0bd41b4761 => 'this month';

  @override
  String get legacyUie92d4d638a => 'wk / mo';

  @override
  String get legacyUia126722ec0 => 'Needs attention';

  @override
  String get legacyUi51eab2420d => 'Dispatcher actions';

  @override
  String get legacyUi8bdea32153 => 'No activity yet.';

  @override
  String get legacyUi05e3a866c3 =>
      'The schedule was saved, but some trips could not be generated.';

  @override
  String get legacyUi2924d70976 => 'Date Only';

  @override
  String get legacyUi63f39eeeb7 => 'Fixed Time';

  @override
  String get legacyUi6930391c64 => 'Time Slot';

  @override
  String get legacyUi601d153162 => 'Multi Day';

  @override
  String get legacyUif61eadaf15 => 'In Progress';

  @override
  String get legacyUia1bf92eff4 => 'Cancelled';

  @override
  String get legacyUic7dfb6f1d9 => 'Paused';

  @override
  String get legacyUi90303d8df2 => 'Ended';

  @override
  String get legacyUi59f1111618 => 'On Trip';

  @override
  String get legacyUi2b613fb829 => 'No Assignment';

  @override
  String get legacyUib564001a58 => 'Missed';

  @override
  String get legacyUi736d1eee8e => 'Vehicle Inactive';

  @override
  String get legacyUif4330844fd => 'Vehicle License Blocked';

  @override
  String get legacyUiabf81c35d4 => 'Driver Required';

  @override
  String get legacyUi2c9c1f7914 => 'Unavailable';

  @override
  String get legacyUi8e9f1d6e54 => 'Not Started';

  @override
  String get legacyUi4310ed540c => 'Late';

  @override
  String get legacyUiaccac60339 => 'Driver Exception';

  @override
  String get legacyUi6b535fa681 => 'No Telemetry';

  @override
  String get legacyUi38a9e21ed9 => 'Route Deviation';

  @override
  String get legacyUi1f5a1abf2f => 'Complete';

  @override
  String get legacyUi5a436b7939 => 'Add Remark';

  @override
  String get legacyUi65c821a596 => 'Live';

  @override
  String get legacyUi189cc40c22 => 'Stale';

  @override
  String get legacyUi41c8e43d9e => 'Vehicle Gps';

  @override
  String get legacyUic1220e845b => 'Fleet Manager';

  @override
  String get legacyUi601f5ff70b => 'System Automation';

  @override
  String get legacyUi8b57ec8c92 => 'Assignment Created';

  @override
  String get legacyUi368e5b125f => 'Assignment Acknowledged';

  @override
  String get legacyUid00c8926f5 => 'Trip Auto Started';

  @override
  String get legacyUic4b75c3924 => 'Trip Auto Completed';

  @override
  String get legacyUif98c835c4f => 'Trip Driver Completed';

  @override
  String get legacyUi4bb573b356 => 'Stop Auto Arrived';

  @override
  String get legacyUi52cd528ad4 => 'Stop Auto Completed';

  @override
  String get legacyUicf338ebe5c => 'Stop Driver Completed';

  @override
  String get legacyUi7ef2940c95 => 'Route Deviation Started';

  @override
  String get legacyUi55d93aed45 => 'Route Deviation Cleared';

  @override
  String get legacyUi654c568718 => 'No Telemetry Started';

  @override
  String get legacyUi66676d64b0 => 'No Telemetry Cleared';

  @override
  String get legacyUi2a398797b5 => 'Overspeed Started';

  @override
  String get legacyUif7d315eb62 => 'Overspeed Cleared';

  @override
  String get legacyUia22d66c857 => 'Arrived';

  @override
  String get legacyUi5a000ad7bd => 'Skipped';

  @override
  String get legacyUi4028c0c8b4 => 'Not Available';

  @override
  String get legacyUi5f174de1cc => 'Proof';

  @override
  String get legacyUi4e91ee6122 => 'Account timezone';

  @override
  String get legacyUi4dda6a4505 => 'Total Trips';

  @override
  String get legacyUi523baab918 => 'Upcoming';

  @override
  String get legacyUicc6e7b6a29 => 'Delayed';

  @override
  String get legacyUie9fab1cf3a => 'On Time Completed Trips';

  @override
  String get legacyUibbb47a7157 => 'On Time Percent';

  @override
  String get legacyUi944b223791 => 'Distance Km';

  @override
  String get legacyUi7c9352eed6 =>
      'A short message will be sent using the current SMTP config.';

  @override
  String get legacyUid173234df0 =>
      'ACC means wire/ACC. MOTION means motion fallback.';

  @override
  String get legacyUi598ed2889b => 'Access permissions';

  @override
  String get legacyUi9a6d95b0c5 => 'Active account';

  @override
  String get legacyUi8d00c06a55 =>
      'Activity, vehicle event, and telemetry logs';

  @override
  String get legacyUi61cc55aa04 => 'Add';

  @override
  String get legacyUiee01d7c402 => 'Add a new administrator';

  @override
  String get legacyUib9b1e23f27 => 'Add a new user';

  @override
  String get legacyUif2f8674f8a => 'Add a new vehicle';

  @override
  String get legacyUi23a75918ab => 'Adoption & Growth';

  @override
  String get legacyUi80643ec204 => 'Advanced Cleanup';

  @override
  String get legacyUicf963e5241 => 'Advanced Filters';

  @override
  String get legacyUi3aea7b29d9 =>
      'Advanced reporting features are not available in the public demo. Sign in with an OpenVTS account to run, page, visualise, and export fleet reports.';

  @override
  String get legacyUi056677c12f => 'Alerts by Severity';

  @override
  String get legacyUif89ae580e8 => 'All actors';

  @override
  String get legacyUiaeae2d71be => 'All alerts';

  @override
  String get legacyUic0e8e58c1a => 'All sources';

  @override
  String get legacyUic1cbbe0c5d => 'Allowed deviation';

  @override
  String get legacyUi826499f6b1 =>
      'Annual coverage and customer service are separate.';

  @override
  String get legacyUi40e69b5db3 => 'Assigned Vehicle';

  @override
  String get legacyUi6771ade6e8 => 'Attachments';

  @override
  String get legacyUi52b258c824 =>
      'Briefly describe the issue and attach files if needed.';

  @override
  String get legacyUi2f3b5c55bc => 'Browse';

  @override
  String get legacyUi00189ab9b2 => 'CSV template';

  @override
  String get legacyUi19db82215d =>
      'Change your password to secure account access.';

  @override
  String get legacyUi3f657f29e6 => 'Choose a new password';

  @override
  String get legacyUicbd1538094 =>
      'Choose how vehicle alerts, overspeed events, and geofence events reach you.';

  @override
  String get legacyUic7cd13c042 =>
      'Choose the pages and reports available to this user. Changes also limit the access they can grant to subusers.';

  @override
  String get legacyUibe10f5c042 =>
      'Choose what this member can view, edit and delete. Own applies to their records; Global applies across your account.';

  @override
  String get legacyUi7834f4a6f4 =>
      'Choose where alerts are delivered for this notification group.';

  @override
  String get legacyUic23350ccde => 'Command details';

  @override
  String get legacyUib2c253ba1c =>
      'Complete the sections below. Required fields are marked with an asterisk (*).';

  @override
  String get legacyUia2b4ac96b2 =>
      'Completed trips by service date. Upcoming assignments are available in Trips.';

  @override
  String get legacyUib3feb31fcb => 'Configure your report';

  @override
  String get legacyUi878b163022 => 'Confirm cleanup';

  @override
  String get legacyUi9041d3c666 =>
      'Contact your administrator to assign vehicles.';

  @override
  String get legacyUi8e2fc0ffdc =>
      'Create a compact login profile with controlled access.';

  @override
  String get legacyUi93c1ed632d =>
      'Create and manage geofences, points of interest, and routes.';

  @override
  String get legacyUie4781f0bde =>
      'Create and manage operational route corridors.';

  @override
  String get legacyUi6571e94148 =>
      'Create secure public links for live vehicle tracking.';

  @override
  String get legacyUie09271eeb7 => 'Created: ';

  @override
  String get legacyUidb0d2488de => 'Current assignment';

  @override
  String get legacyUif8ece934c7 => 'Daily Distance Totals';

  @override
  String get legacyUicb47dca7e3 => 'Daily totals for selected range';

  @override
  String get legacyUi71d6e89bcc => 'Day vs Night Driving';

  @override
  String get legacyUi2f3c38363d => 'Delete POI?';

  @override
  String get legacyUi30c6c6352a => 'Delete geofence?';

  @override
  String get legacyUic6f82fca90 => 'Delete route?';

  @override
  String get legacyUie543c4fd0c => 'Demo workspace • Read-only';

  @override
  String get legacyUi50dd7fb720 => 'Device Config';

  @override
  String get legacyUi0cf40756a6 => 'Draw and manage operational boundaries.';

  @override
  String get legacyUi243f6cfeec => 'Driven KM';

  @override
  String get legacyUie30d463652 => 'Driver details are unavailable.';

  @override
  String get legacyUi251b80c58c => 'Email Subscription';

  @override
  String get legacyUibe482973b9 => 'Enable SMTP';

  @override
  String get legacyUi21685f000f => 'End this session on this device.';

  @override
  String get legacyUide4f0c9387 => 'Event Filters';

  @override
  String get legacyUi6e74f5ccbd => 'Events by Type';

  @override
  String get legacyUi74bbe75120 => 'Expiring soon';

  @override
  String get legacyUi8d00705083 => 'Expiry Date';

  @override
  String get legacyUi0da7bfa1a0 => 'Expiry date (optional)';

  @override
  String get legacyUi86baf678e1 => 'Failed rows';

  @override
  String get legacyUi2b1d93a2c6 => 'Filter Activity Logs';

  @override
  String get legacyUi9a4184cef3 => 'Filter by administrator and date range.';

  @override
  String get legacyUi96e578211a => 'Filters';

  @override
  String get legacyUi5360d40661 => 'Fleet OS';

  @override
  String get legacyUi03d25e01e5 => 'Generate from search';

  @override
  String get legacyUi4d8abbdc5d => 'Generate report';

  @override
  String get legacyUie16305f8b0 => 'Generation failed';

  @override
  String get legacyUid81feb6ae1 => 'Get History';

  @override
  String get legacyUi6fa6308619 =>
      'Get notified when assigned vehicles deviate.';

  @override
  String get legacyUi4b6d6a3015 => 'Important';

  @override
  String get legacyUic5288872fd => 'Inactive routes stay archived but visible.';

  @override
  String get legacyUi44caf74675 => 'Inbox';

  @override
  String get legacyUi3f33f2e865 =>
      'Include the full path, e.g. http://192.168.1.10:3000/api';

  @override
  String get legacyUi1919090902 => 'Last login: ';

  @override
  String get legacyUi1c747b4f98 => 'Latest Server Action';

  @override
  String get legacyUi9e1bba7129 => 'Latest period';

  @override
  String get legacyUi72da77c7b7 =>
      'Live coordinates are unavailable for this vehicle.';

  @override
  String get legacyUi3e893cdfd5 => 'Loading device types and providers...';

  @override
  String get legacyUi93fe7c05af => 'Loading document types…';

  @override
  String get legacyUi75e940ee30 => 'Loading history';

  @override
  String get legacyUi59c3981787 => 'Loading history...';

  @override
  String get legacyUibbe4cbd55c => 'Loading profile';

  @override
  String get legacyUica88017dfa => 'Loading subscription status...';

  @override
  String get legacyUid1ccf4c3e4 => 'Loading vehicles…';

  @override
  String get legacyUif4e14815b1 => 'Login as admin';

  @override
  String get legacyUi353bd1ef01 => 'Logs by Category';

  @override
  String get legacyUib2af2f11de => 'Logs by Level';

  @override
  String get legacyUi8c97e4f07d =>
      'Manage drivers and sub users linked to your fleet.';

  @override
  String get legacyUi41948edc3a =>
      'Manage drivers, assignments, documents, and activity.';

  @override
  String get legacyUi93b23afae0 =>
      'Manage important places and operational points.';

  @override
  String get legacyUi68669149c0 => 'Manage sub users and vehicle access.';

  @override
  String get legacyUi9fcd87c64d => 'Manage subscription pricing plans.';

  @override
  String get legacyUi274ef56d8e =>
      'Manage transactions and renew vehicle subscriptions';

  @override
  String get legacyUiff92dafaaf =>
      'Manage users, login access, contacts, and assigned vehicles.';

  @override
  String get legacyUib42578bf99 =>
      'Manual payments update transactions and analytics after successful submission.';

  @override
  String get legacyUi421878a774 => 'Map data © Google';

  @override
  String get legacyUi2cf55e0f5b => 'Map details';

  @override
  String get legacyUi9a3aa11de5 => 'Map type';

  @override
  String get legacyUi09d3670056 => 'Max 10MB. Blocked: exe, js, html, htm.';

  @override
  String get legacyUife0c6bc7dd => 'Mobile Push Diagnostics';

  @override
  String get legacyUif6f444180f =>
      'Monitor uptime, dependencies, and safe service actions';

  @override
  String get legacyUi1a63cbf994 => 'New Link';

  @override
  String get legacyUia40ad15529 => 'New support ticket';

  @override
  String get legacyUi9f2d2d7331 => 'No USER document types configured.';

  @override
  String get legacyUi9ec5ec0752 =>
      'No active geofences — all geofences included.';

  @override
  String get legacyUi0a181de203 =>
      'No administrators available. Pull to refresh and try again.';

  @override
  String get legacyUi43f32b9b9d => 'No contact information';

  @override
  String get legacyUie55a0728f0 => 'No geofences to preview';

  @override
  String get legacyUi115fe0fac7 => 'No groups found';

  @override
  String get legacyUida501f43fd => 'No growth data yet.';

  @override
  String get legacyUi454fe267a7 => 'No metadata';

  @override
  String get legacyUi2540cc1f1a => 'No pending renewal requests.';

  @override
  String get legacyUi7cd1d44b3c => 'No records found.';

  @override
  String get legacyUi658e79f9dc => 'No results found';

  @override
  String get legacyUif018f94f6e =>
      'No rows matched the selected report filters.';

  @override
  String get legacyUibddbb17fc4 => 'No selection = all';

  @override
  String get legacyUi9aba7bbe44 => 'No selection = all geofences.';

  @override
  String get legacyUifd548f1c32 => 'No sensors configured for this vehicle';

  @override
  String get legacyUi162d1ddec0 => 'No team activity found.';

  @override
  String get legacyUi8f91f15684 => 'No valid GPS location';

  @override
  String get legacyUi74ac3b3d0d => 'No vehicle assigned.';

  @override
  String get legacyUia26d9edac3 => 'No vehicles assigned to your account';

  @override
  String get legacyUie4b1dbf423 => 'No vehicles found.';

  @override
  String get legacyUi6eef664840 => 'None';

  @override
  String get legacyUif8ae6c8bbe => 'Not acknowledged';

  @override
  String get legacyUia92e15bc0a => 'Notification Preferences';

  @override
  String get legacyUic71ffe5d22 => 'Notification cooldown';

  @override
  String get legacyUicb88cbc310 => 'Notify when vehicle leaves route';

  @override
  String get legacyUi0049196b0b => 'Nudge 10 m';

  @override
  String get legacyUia49d76ddc1 => 'One vehicle';

  @override
  String get legacyUi0080aaa977 => 'Open VTS';

  @override
  String get legacyUi032a6dcfd8 =>
      'Open a support ticket to review the full conversation.';

  @override
  String get legacyUi50f8c47b2b => 'Open in Navigation';

  @override
  String get legacyUi89202c7fd8 => 'Other document';

  @override
  String get legacyUi27b4bf6d1b =>
      'Outgoing mail uses this server when active.';

  @override
  String get legacyUi619d7adc2c =>
      'Payment will appear immediately in transaction list.';

  @override
  String get legacyUidc32a816e9 =>
      'Permanently remove historical rows older than the retention period.';

  @override
  String get legacyUic2ff2762ca => 'Please select a file.';

  @override
  String get legacyUi3585d74456 => 'Preserve current expiry';

  @override
  String get legacyUia9a96ec019 => 'Primary';

  @override
  String get legacyUi668c4636aa => 'Proof of delivery';

  @override
  String get legacyUif702b26481 => 'Ranked by transaction count';

  @override
  String get legacyUid03c65244f => 'Recalculate from plan';

  @override
  String get legacyUi72d5617f3f => 'Recent activity';

  @override
  String get legacyUi255e5788a2 => 'Recover your account';

  @override
  String get legacyUi505dddc915 => 'Refreshing';

  @override
  String get legacyUi54dd5046d0 =>
      'Refreshing will replace your current unsaved notification edits with the latest server settings.';

  @override
  String get legacyUi199ed09ba9 => 'Report access';

  @override
  String get legacyUibd7b4f006d => 'Report an issue';

  @override
  String get legacyUi8115c55b47 => 'Reports are restricted in demo mode';

  @override
  String get legacyUi6b5890ba0b =>
      'Request and confirm OTP to verify email and WhatsApp number.';

  @override
  String get legacyUif7194e6a0d => 'Requests';

  @override
  String get legacyUif25bbab45d => 'Revenue Forecast';

  @override
  String get legacyUiec40affa3e => 'Revenue Trend';

  @override
  String get legacyUic53c3605a0 =>
      'Review customer renewal requests. Confirm only payments actually received outside the app.';

  @override
  String get legacyUiffbfe1e822 => 'Route stops';

  @override
  String get legacyUi50eec1a359 => 'Run Result';

  @override
  String get legacyUi339225895f =>
      'Running cleanup deletes data permanently. Always preview first.';

  @override
  String get legacyUifee1dff0c6 => 'Running vs Stopped';

  @override
  String get legacyUi0fb59422f6 => 'Samples';

  @override
  String get legacyUide6472b8d3 => 'Select Date Range';

  @override
  String get legacyUia35cfe395a => 'Select Group';

  @override
  String get legacyUi2564e1a2c5 => 'Select Sensor';

  @override
  String get legacyUifea7a520f3 => 'Select Vehicle';

  @override
  String get legacyUi70037936c0 => 'Select a ticket';

  @override
  String get legacyUieeaf903bb8 => 'Select a vehicle first';

  @override
  String get legacyUiad7a8a1750 =>
      'Select an administrator, describe the issue, and attach files if needed.';

  @override
  String get legacyUi9bb7b69035 => 'Select at least one state';

  @override
  String get legacyUifcfe92e583 => 'Select dashboard';

  @override
  String get legacyUif9f50c1c30 =>
      'Select vehicles, date range, and filters, then generate to view results.';

  @override
  String get legacyUi0e40d8b0bf => 'Selected vehicles';

  @override
  String get legacyUi43e146fb62 => 'Server Health Monitoring';

  @override
  String get legacyUi644899c565 =>
      'Service expiry controls live tracking. Contact your administrator for renewal. A renewal request does not extend service until payment is confirmed.';

  @override
  String get legacyUi5cbd584046 => 'Services';

  @override
  String get legacyUi758d7f7281 => 'Set Active';

  @override
  String get legacyUi7c9275ee4b => 'Set Inactive';

  @override
  String get legacyUiddbe3ed1a3 => 'Set custom expiry';

  @override
  String get legacyUi7b53693e94 => 'Share Track Links';

  @override
  String get legacyUidc1649a16c => 'Sign out';

  @override
  String get legacyUi2f32be1dc7 => 'Signature';

  @override
  String get legacyUi51070e69d1 => 'Site photo';

  @override
  String get legacyUi93773568cf => 'Speed Limit';

  @override
  String get legacyUicb672694bb => 'State Filter';

  @override
  String get legacyUi511404ce3b => 'Status Distribution';

  @override
  String get legacyUie54e98e0cb => 'Stoppage';

  @override
  String get legacyUie48d04b2b6 =>
      'Stopping Frontend/Backend/Listener can lock you out of the application. This page allows Start and Restart for those services, but Stop is disabled.';

  @override
  String get legacyUi16b45ef102 => 'Success, pending, and failed share';

  @override
  String get legacyUi12b71c3e0f => 'Summary';

  @override
  String get legacyUied9177cab1 => 'System Metrics';

  @override
  String get legacyUie20a879f45 => 'Tap to edit geofence notifications';

  @override
  String get legacyUiac8b906fca => 'Target Vehicle';

  @override
  String get legacyUib644561145 => 'Telemetry Log';

  @override
  String get legacyUi7840676a23 => 'Telemetry log';

  @override
  String get legacyUi4ee3736ca6 =>
      'This action cannot be undone. The driver and related assignments will be removed.';

  @override
  String get legacyUi3575c0aec8 =>
      'This action permanently removes the sub user and revokes vehicle access. This cannot be undone.';

  @override
  String get legacyUi7f3d98b829 =>
      'This link cannot be deleted because its id is missing.';

  @override
  String get legacyUi4e81e87c37 =>
      'This permanently deletes data older than the retention period. It cannot be undone.';

  @override
  String get legacyUid8b029df5c =>
      'This public tracking link will stop working immediately. This action cannot be undone.';

  @override
  String get legacyUida735ce16c =>
      'This report is not available for your account.';

  @override
  String get legacyUidf3e8a5fdd =>
      'This ticket is closed or resolved. Replies are disabled.';

  @override
  String get legacyUif9c732c3c6 =>
      'This ticket is closed. Reply may reopen or move it to In Progress based on backend behavior.';

  @override
  String get legacyUif3a8370f38 => 'Total Revenue';

  @override
  String get legacyUie273941b29 => 'Totals by currency';

  @override
  String get legacyUiaa7d3d7dd9 => 'Transaction history';

  @override
  String get legacyUib174443b0e => 'Transactions and revenue';

  @override
  String get legacyUi9dda9aa776 => 'Trip';

  @override
  String get legacyUic948ed8076 => 'Trip proofs';

  @override
  String get legacyUid67a44f68d => 'Try adjusting your filters or date range.';

  @override
  String get legacyUi078f02fe7b => 'Unable to load documents';

  @override
  String get legacyUi3b37311cd6 => 'Unable to load history';

  @override
  String get legacyUicaa5bd27e5 => 'Unable to load logs';

  @override
  String get legacyUi92078d350e => 'Unable to load payments';

  @override
  String get legacyUi5db77ece1a => 'Unable to load profile';

  @override
  String get legacyUi081863e321 => 'Unable to load tickets';

  @override
  String get legacyUi11f14b7638 => 'Update company identity and social links.';

  @override
  String get legacyUieb58c61a89 =>
      'Update personal and address details. Changes are saved only when you confirm.';

  @override
  String get legacyUid19cf73ae1 => 'Updated: ';

  @override
  String get legacyUi9db8e8ec0b =>
      'Use the live map vehicle list, then choose the stop threshold and date time range.';

  @override
  String get legacyUid337d1a0d6 => 'Variable Preview';

  @override
  String get legacyUi63dfad55e0 => 'Vehicle Information';

  @override
  String get legacyUi7f4567c8c2 => 'Vehicle Live Status';

  @override
  String get legacyUiceedc505bd => 'Vehicle Status';

  @override
  String get legacyUi1f41948d84 => 'Vehicle event';

  @override
  String get legacyUid3aee04e65 => 'Vehicle-Geofence Matrix';

  @override
  String get legacyUiefd8355920 => 'View All';

  @override
  String get legacyUi50ad3280e1 => 'View Vehicle';

  @override
  String get legacyUi2c3c7c93f8 =>
      'View payments, credits, debits, and billing records.';

  @override
  String get legacyUi7d9ff4f0de => 'Visibility';

  @override
  String get legacyUi79c6a6033a => 'Visible to admin';

  @override
  String get legacyUied0069155f => 'Visible to user';

  @override
  String get legacyUia56d85fb20 =>
      'Web browsers require the server to allow cross-origin requests (CORS). If login fails with a connection error, enable CORS on your server.';

  @override
  String get legacyUi4dd079044f => 'Whole trip';

  @override
  String get legacyUi4515b6c7b7 => 'Your day';

  @override
  String get legacyUi50f19ac0b4 =>
      'Your documents and documents shared by your fleet manager.';

  @override
  String get legacyUi4e697d55ce => 'Your transactions with the software owner.';

  @override
  String get legacyUi678830983a => '— payload truncated for display —';

  @override
  String legacyUi1e22f79cd9(Object value1) {
    return 'Loading $value1';
  }

  @override
  String legacyUi57fdb35e30(Object value1) {
    return '$value1 unavailable';
  }

  @override
  String legacyUi1fd3e5084a(Object value1) {
    return 'No $value1 found';
  }

  @override
  String get legacyUie16f97dcfd => 'Clear History';

  @override
  String legacyUiabd4cd39b9(Object value1) {
    return '$value1 points';
  }

  @override
  String legacyUi90eaac7e8b(Object value1) {
    return '$value1 stops';
  }

  @override
  String legacyUi865d65baea(Object value1) {
    return '$value1 overspeed';
  }

  @override
  String legacyUi7326be7e87(Object value1, Object value2) {
    return '$value1 $value2 max';
  }

  @override
  String legacyUi5fd7f54937(Object value1, Object value2) {
    return '$value1 $value2 avg';
  }

  @override
  String legacyUi5f2ee53a4c(Object value1) {
    return '$value1 running';
  }

  @override
  String legacyUi5c24a04874(Object value1) {
    return '$value1 stopped';
  }

  @override
  String legacyUi2b4b82c8bb(Object value1) {
    return 'Duration: $value1';
  }

  @override
  String legacyUi27a82a7136(Object value1) {
    return '$value1 driving';
  }

  @override
  String legacyUi92edf7854b(Object value1) {
    return '$value1 vehicles';
  }

  @override
  String get legacyUi5d12bd5355 => 'Play';

  @override
  String get legacyUi4e39567064 => 'Note (optional)';

  @override
  String get legacyUi932fc13e7f => 'Title (optional)';

  @override
  String legacyUi2c904359f5(Object value1) {
    return 'File exceeds $value1 MB limit';
  }

  @override
  String legacyUi66db457b99(Object value1) {
    return 'Unsupported format. Allowed: $value1';
  }

  @override
  String get legacyUia7cf7b25a7 => 'Replace';

  @override
  String legacyUidf1d5f2730(Object value1) {
    return 'Test email sent to $value1';
  }

  @override
  String get legacyUi044b852f30 => 'Show password';

  @override
  String get legacyUie40123b4e7 => 'Hide password';

  @override
  String get legacyUi82f47c3d4d => 'Email verified';

  @override
  String get legacyUib1a273086c => 'WhatsApp verified';

  @override
  String legacyUi908e5c8ce5(Object value1) {
    return 'Logged out from $value1';
  }

  @override
  String get legacyUi33ce417454 => 'Loading…';

  @override
  String get legacyUi71ae0ec96e => 'Failed to load — retry';

  @override
  String get legacyUi67c4d0506a => 'Not applicable';

  @override
  String get legacyUia0b1fb2afb => 'Show confirm password';

  @override
  String get legacyUie2196c3942 => 'Hide confirm password';

  @override
  String get legacyUi7c073937c6 => 'OTP sent to your email';

  @override
  String get legacyUi8532209c49 => 'OTP sent via WhatsApp';

  @override
  String get legacyUi0d455a4e26 => 'Verify Email';

  @override
  String get legacyUi9cb68a6dd3 => 'Verify WhatsApp';

  @override
  String legacyUi8cf58d99c1(Object value1) {
    return 'From $value1';
  }

  @override
  String legacyUif41a1a65a6(Object value1) {
    return 'To $value1';
  }

  @override
  String legacyUia801634da8(Object value1) {
    return '$value1 deleted.';
  }

  @override
  String legacyUi73f15343e6(Object value1) {
    return 'Signed in as $value1.';
  }

  @override
  String get legacyUi48138f08cd => 'Deactivate administrator';

  @override
  String get legacyUif9494a277e => 'Activate administrator';

  @override
  String get legacyUi13a84a7390 => 'Administrator activated.';

  @override
  String get legacyUi8181bbb7c7 => 'Administrator deactivated.';

  @override
  String get legacyUid65ded9428 => 'Deactivate';

  @override
  String get legacyUi92ef08325a => 'Activate';

  @override
  String get legacyUiacfd05ab80 => 'Email unverified';

  @override
  String get legacyUi23c9dd8809 => 'Unable to load vehicles. Retry.';

  @override
  String legacyUib089c07088(Object value1) {
    return 'GMT $value1';
  }

  @override
  String legacyUi73585fdb6f(Object value1) {
    return 'Added $value1';
  }

  @override
  String get legacyUi410bebb5ea => 'Unable to load documents. Retry.';

  @override
  String get legacyUi7f10270c45 => 'Unable to load document types. Retry.';

  @override
  String get legacyUid4c2792a72 => 'Hidden';

  @override
  String get legacyUi1b7cd8a9bf => 'Document updated.';

  @override
  String get legacyUi895a77b095 => 'Document uploaded.';

  @override
  String get legacyUief6604a13d => 'Edit document';

  @override
  String get legacyUif6769b696e => 'Credits added.';

  @override
  String get legacyUib16dd3b790 => 'Credits deducted.';

  @override
  String get legacyUie890b12b34 => 'No transactions match your filters';

  @override
  String get legacyUib71113c83a =>
      'No payments found for this admin. Try clearing filters.';

  @override
  String get legacyUi472af48c6d => 'Record a manual payment to get started.';

  @override
  String legacyUi46f7e02bd0(Object value1) {
    return '$value1 copied';
  }

  @override
  String legacyUi70d9eead51(Object value1) {
    return 'Subject must be $value1 characters or less.';
  }

  @override
  String legacyUifee6584f1b(Object value1) {
    return 'Description must be $value1 characters or less.';
  }

  @override
  String legacyUi830e676993(Object value1) {
    return 'You can upload up to $value1 files.';
  }

  @override
  String legacyUi4e5f407ec5(Object value1) {
    return 'Blocked file removed: $value1';
  }

  @override
  String legacyUib5d0b873d0(Object value1) {
    return 'Unsupported file removed: $value1';
  }

  @override
  String legacyUid1740cec1d(Object value1) {
    return 'File exceeds 5MB: $value1';
  }

  @override
  String legacyUie33e0ec27a(Object value1) {
    return 'Reply must be $value1 characters or less.';
  }

  @override
  String legacyUid9e484645b(Object value1) {
    return 'Ticket status is already $value1.';
  }

  @override
  String legacyUiebbf66ef0e(Object value1, Object value2) {
    return 'From: $value1$value2';
  }

  @override
  String legacyUi94cf932307(Object value1) {
    return 'Created $value1';
  }

  @override
  String legacyUib5ae5701b9(Object value1) {
    return 'Updated $value1';
  }

  @override
  String legacyUi1a150ff203(Object value1) {
    return 'Closed $value1';
  }

  @override
  String get legacyUiec6952e09b => 'Updating';

  @override
  String legacyUi190040d9d3(Object value1) {
    return 'Some files are over 5MB and were removed$value1.';
  }

  @override
  String legacyUi2a432bdd06(Object value1) {
    return 'Local agent: $value1';
  }

  @override
  String get legacyUi3adb8e50db => 'Create a team member to get started.';

  @override
  String legacyUiabad5c010f(Object value1) {
    return '$value1 · Permissions';
  }

  @override
  String get legacyUifb91e24fa5 => 'Update';

  @override
  String get legacyUia9d4f0d3b6 => 'Unable to update permissions';

  @override
  String get legacyUi918bffea2f => 'Show current password';

  @override
  String get legacyUifa0245c379 => 'Hide current password';

  @override
  String get legacyUi9a569782b5 => 'Show new password';

  @override
  String get legacyUiaa10918381 => 'Hide new password';

  @override
  String get legacyUi39b0c83afa => 'Show confirm new password';

  @override
  String get legacyUiea6f8ea221 => 'Hide confirm new password';

  @override
  String legacyUie30362677c(Object value1) {
    return '$value1 registered';
  }

  @override
  String legacyUi060250e9ba(Object value1) {
    return '$value1 invoices';
  }

  @override
  String get legacyUi53e337d44c => 'Save Plan';

  @override
  String get legacyUi4fc636d1bb => 'Plan updated.';

  @override
  String get legacyUidc5a367e83 => 'Plan created.';

  @override
  String get legacyUi2325fc9152 => 'No vehicle types available';

  @override
  String get legacyUi4e4664e8e9 => 'Select vehicle type';

  @override
  String get legacyUi37282b63dd => 'Loading users...';

  @override
  String get legacyUide2b4561e4 => 'Failed to load users';

  @override
  String get legacyUif1b918acaf => 'Create or select primary user';

  @override
  String get legacyUic96ec8c8a6 => 'No devices available';

  @override
  String get legacyUieeed87c94b => 'Select GPS device';

  @override
  String get legacyUie5a3dc6c41 => 'No plans available';

  @override
  String get legacyUi509d83b55f => 'Select pricing plan';

  @override
  String legacyUi91c69c8c0d(Object value1) {
    return 'Vehicle \"$value1\" created.';
  }

  @override
  String get legacyUi048e2d12ad => 'Vehicle deactivated.';

  @override
  String get legacyUib042915cc0 => 'Vehicle activated.';

  @override
  String get legacyUi3741f56c60 => 'Create Sensor';

  @override
  String get legacyUi996e719712 => 'Save Sensor';

  @override
  String get legacyUiaa9bf6a127 => 'Service could not be updated';

  @override
  String legacyUif17fe09e18(Object value1) {
    return '$value1 annual coverage renewed';
  }

  @override
  String get legacyUid55d13471f => 'Annual renewal failed';

  @override
  String get legacyUi2caa5892b7 => 'Polling status...';

  @override
  String get legacyUid56ae084ba => 'Edit Document';

  @override
  String get legacyUi47396c4fcf => 'Create a driver to get started.';

  @override
  String get legacyUie4c5584c2a => 'Driver activated.';

  @override
  String get legacyUi255f9b5d50 => 'Driver deactivated.';

  @override
  String legacyUi2c5ad08780(Object value1) {
    return 'Exp: $value1';
  }

  @override
  String get legacyUifc3606d535 => 'Deactivate driver';

  @override
  String get legacyUic82a768102 => 'Activate driver';

  @override
  String legacyUi3c2dd46009(Object value1) {
    return '$value1 (current)';
  }

  @override
  String get legacyUi9e9d25ea74 => 'Select country first';

  @override
  String get legacyUi789073b300 => 'Select state first';

  @override
  String get legacyUie0c7a349f8 => 'Deselect all filtered';

  @override
  String get legacyUi30a4c62f4d => 'Select all filtered';

  @override
  String get legacyUi303e32bfd9 => 'Payment confirmed and service renewed';

  @override
  String get legacyUiad3c7489f5 => 'Renewal request cancelled';

  @override
  String get legacyUi91027c0a9a => 'Request could not be updated';

  @override
  String get legacyUi3fb82cbe4b => 'Search user tickets';

  @override
  String get legacyUi3263ab8929 => 'Search my tickets';

  @override
  String get legacyUi24cae41f13 => 'User activated.';

  @override
  String get legacyUi48d348ab09 => 'User deactivated.';

  @override
  String legacyUi515200de54(Object value1) {
    return 'Minimum $value1 characters';
  }

  @override
  String get legacyUiea03fca475 => 'Select a country first';

  @override
  String get legacyUi01d9797a19 => 'No states available';

  @override
  String get legacyUic234150a07 => 'Select a state';

  @override
  String get legacyUida9ca145a1 => 'Select a state first';

  @override
  String get legacyUi12fb8b7d21 => 'No cities available';

  @override
  String get legacyUia8ab373cf7 => 'Select a city';

  @override
  String legacyUi99c1db6636(Object value1) {
    return 'User \"$value1\" created.';
  }

  @override
  String get legacyUi6ea66e7cf8 => 'No assigned drivers';

  @override
  String get legacyUi6b4d2e8347 => 'No drivers match your search';

  @override
  String legacyUic7a9755928(Object value1) {
    return 'License $value1';
  }

  @override
  String get legacyUi530530a405 => 'No available drivers';

  @override
  String legacyUied9f265a0a(Object value1) {
    return 'Search $value1…';
  }

  @override
  String get legacyUia269afc99c => 'No tickets found';

  @override
  String get legacyUifd0ab9a284 => 'No tickets match your search';

  @override
  String legacyUic93cd16b9b(Object value1) {
    return 'Last $value1';
  }

  @override
  String legacyUib68af38cf0(Object value1) {
    return 'Ticket is already $value1.';
  }

  @override
  String get legacyUi9ddc709693 => 'Deactivate user';

  @override
  String get legacyUiaebaaf50f8 => 'Activate user';

  @override
  String get legacyUi8ed321fdf0 => 'Unable to save permissions';

  @override
  String get legacyUi51c4b07667 => 'No vehicles match your search';

  @override
  String legacyUi83f7990857(Object value1) {
    return 'IMEI $value1';
  }

  @override
  String legacyUid3544dd1fc(Object value1) {
    return 'SIM $value1';
  }

  @override
  String legacyUiaed1ab73c8(Object value1) {
    return 'VIN $value1';
  }

  @override
  String legacyUi20400601e8(Object value1) {
    return 'Expiry $value1';
  }

  @override
  String get legacyUif0dc6b09f8 => 'No available vehicles';

  @override
  String get legacyUi39d436aaba => 'No expiry';

  @override
  String get legacyUic15c47e4c9 => 'Search IMEI, device type, SIM number…';

  @override
  String get legacyUibc139b1c14 => 'Search SIM, IMSI, ICCID, provider…';

  @override
  String get legacyUiaa729739dd => 'No devices found';

  @override
  String get legacyUi679d782d32 => 'No SIM cards found';

  @override
  String get legacyUi613b9215a5 => 'Add inventory to get started.';

  @override
  String get legacyUi9f91b0dc33 => 'Loading device types...';

  @override
  String legacyUi9ba6bfee17(Object value1) {
    return 'Using safe defaults. $value1';
  }

  @override
  String get legacyUi2919b3cdf5 => 'Email pending';

  @override
  String get legacyUidfd4099c87 => 'WhatsApp pending';

  @override
  String legacyUif0dd87cef8(Object value1) {
    return 'Switch to $value1 tab';
  }

  @override
  String legacyUi364cdce6f9(Object value1) {
    return '$value1 credits';
  }

  @override
  String get legacyUi070e328ec8 => 'Uploading...';

  @override
  String get legacyUie8d33553f6 => 'Change Avatar';

  @override
  String legacyUi56b3825e50(Object value1) {
    return 'Apply preset $value1';
  }

  @override
  String get legacyUi28e40daab7 => 'Resending...';

  @override
  String get legacyUib707b694b2 => 'Resend OTP';

  @override
  String legacyUia648c7bbe2(Object value1) {
    return '$value1 picker';
  }

  @override
  String get legacyUidd1242a8fc => 'Subscribed';

  @override
  String get legacyUibbf5d78203 => 'Not subscribed';

  @override
  String get legacyUi0e42454279 => 'all vehicles';

  @override
  String get legacyUi12e7d6beac => 'Source unknown';

  @override
  String get legacyUifb2269d326 => 'No operational vehicles available.';

  @override
  String get legacyUi9dd705b078 => 'No vehicles available.';

  @override
  String legacyUi8879fce2e7(Object value1, Object value2) {
    return '$value1 blocked vehicle$value2 excluded.';
  }

  @override
  String legacyUif039d146e6(Object value1) {
    return '$value1 assigned vehicles';
  }

  @override
  String get legacyUi02b460b2cf => 'No matching vehicles';

  @override
  String get legacyUi537da7f70e =>
      'All vehicles are already assigned to this sub user.';

  @override
  String get legacyUif614a2e6b5 => 'Try a different search query.';

  @override
  String get legacyUi28516f977e => 'Sub user deactivated.';

  @override
  String get legacyUi7841e93192 => 'Sub user activated.';

  @override
  String get legacyUi87e328dc94 => 'Clear Search';

  @override
  String get legacyUi72556ffa55 => 'Visible to Driver';

  @override
  String get legacyUi355f129929 => 'Hidden from Driver';

  @override
  String get legacyUib68e795ff9 => 'Change Vehicle';

  @override
  String get legacyUi0cb329674a => 'Visible in user documents';

  @override
  String get legacyUi7ab98ca9b9 => 'Hidden from user documents';

  @override
  String get legacyUi5f22178640 => 'Driver can see this document';

  @override
  String get legacyUiaf7ad5ad5c => 'Driver cannot see this document';

  @override
  String get legacyUib544cc3e95 => 'No unassigned vehicles';

  @override
  String get legacyUidf10a27148 => 'All vehicles are already assigned.';

  @override
  String get legacyUic3763af773 => 'Not updated';

  @override
  String get legacyUia1f5a8dbd3 => 'No sensors found';

  @override
  String get legacyUi6a3625800c =>
      'No sensors are configured for this vehicle.';

  @override
  String get legacyUi5fdd1b0855 => 'Sensor Settings';

  @override
  String get legacyUi2524c34a0d => 'New Sensor';

  @override
  String get legacyUiae7e887517 => 'Saving...';

  @override
  String get legacyUi126eda8b21 => 'Running...';

  @override
  String get legacyUi7745774c38 => 'Sensor created.';

  @override
  String get legacyUi2a367dafb5 => 'Sensor updated.';

  @override
  String get legacyUi4abc320492 => 'Loading config';

  @override
  String get legacyUic0ae8f6ea8 => 'Saved';

  @override
  String get legacyUif352418f58 => 'Loading types…';

  @override
  String get legacyUi82385d8917 => 'Loading timezones…';

  @override
  String get legacyUi22e6340f2c => 'Select timezone';

  @override
  String get legacyUicc4889261c => 'Reload History';

  @override
  String get legacyUi9e8a1c5b7b => 'Loading sensors…';

  @override
  String legacyUic0a743750e(Object value1) {
    return 'Select $value1 report range';
  }

  @override
  String legacyUi26362a69a0(Object value1) {
    return 'Running: $value1';
  }

  @override
  String legacyUicbbef93382(Object value1) {
    return 'Stopped: $value1';
  }

  @override
  String legacyUic1d252d58b(Object value1) {
    return '$value1 — Overspeed';
  }

  @override
  String legacyUidf3ab0c2d9(Object value1) {
    return 'Day: $value1';
  }

  @override
  String legacyUi20076143b6(Object value1) {
    return 'Night: $value1';
  }

  @override
  String legacyUie296339b1e(Object value1, Object value2) {
    return '$value1 trip$value2';
  }

  @override
  String legacyUib4c5c14ddb(Object value1) {
    return 'Max $value1 km/h';
  }

  @override
  String legacyUi491fa657c5(Object value1, Object value2) {
    return '$value1: $value2 km';
  }

  @override
  String legacyUia6587e8e7b(Object value1) {
    return 'Distance by Vehicle (top $value1)';
  }

  @override
  String legacyUi6eca89289b(Object value1) {
    return '$value1 km/h';
  }

  @override
  String legacyUib9a5d6824c(Object value1, Object value2) {
    return 'Geofence $value1 for $value2';
  }

  @override
  String legacyUi4d24bcb058(Object value1, Object value2) {
    return 'Overspeed limit ($value1) for $value2';
  }

  @override
  String get legacyUi56a2285c5b => 'Saving…';

  @override
  String legacyUia1f38b12bb(Object value1) {
    return '$value1 toggle';
  }

  @override
  String legacyUic3b516d33c(Object value1) {
    return '$value1 geofences';
  }

  @override
  String get legacyUi010f99630a => 'Edit Track Link';

  @override
  String get legacyUibb53b1c483 => 'New Track Link';

  @override
  String legacyUi9287b718c6(Object value1) {
    return '$value1 selected';
  }

  @override
  String get legacyUib948ff19e4 => 'Unlock square';

  @override
  String get legacyUi85a3ef0c3f => 'Lock square';

  @override
  String get legacyUi9dd7a6b201 => 'Create geofence';

  @override
  String get legacyUidccb573a71 => 'Draw route';

  @override
  String legacyUi4c91961249(Object value1) {
    return 'Upload $value1 rows';
  }

  @override
  String legacyUi0ff9c73519(Object value1) {
    return '$value1 valid';
  }

  @override
  String legacyUifa7ec0ed62(Object value1) {
    return '$value1 invalid';
  }

  @override
  String legacyUi1483db1240(Object value1) {
    return '$value1 ok';
  }

  @override
  String legacyUi2c661fac7f(Object value1) {
    return '$value1 failed';
  }

  @override
  String get legacyUi7e613c0b85 => 'Place POI';

  @override
  String get legacyUi4405592a72 => 'Move POI';

  @override
  String get legacyUi91fbb41bfb => 'Use this location';

  @override
  String get legacyUif05f282071 => 'Tap map to place POI';

  @override
  String get legacyUie8f485c68a => 'Try adjusting the filters or date range.';

  @override
  String get legacyUia0c0bb9e85 => 'No transactions available for this period.';

  @override
  String legacyUid7d6dade2a(Object value1) {
    return 'Success $value1';
  }

  @override
  String legacyUi3a0d457cee(Object value1) {
    return 'Pending $value1';
  }

  @override
  String legacyUi07d104432b(Object value1) {
    return 'Failed $value1';
  }

  @override
  String get legacyUi3fb75e3bfe => 'Reset Password';

  @override
  String get legacyUif99d98e85f => 'Forgot Password';

  @override
  String get legacyUi0d2afda86b => 'Demo workspace opened';

  @override
  String get legacyUif06ccf010d => 'Login successful';

  @override
  String get legacyUifc45091249 => 'Switch to light mode';

  @override
  String get legacyUic29220f958 => 'Switch to dark mode';

  @override
  String get legacyUi257616b8e4 => 'No unread notifications';

  @override
  String get legacyUid2609b6af1 => 'No notifications yet';

  @override
  String get legacyUi04d956a670 =>
      'Everything is marked as read. New alerts will appear here as they arrive.';

  @override
  String get legacyUi7fe220bd95 =>
      'Vehicle alerts, system events, and operational updates will appear here.';

  @override
  String get legacyUib2f3a86e84 => 'All read';

  @override
  String get legacyUicbf6939e9e => 'Marking…';

  @override
  String get legacyUi8958e22c23 => 'Mark all read';

  @override
  String legacyUicb9ae54e8a(Object value1, Object value2) {
    return 'Showing $value1 of $value2';
  }

  @override
  String legacyUie5b28b8ae4(Object value1, Object value2) {
    return 'Page $value1 of $value2';
  }

  @override
  String get legacyUic1d317a815 => 'No matching tickets';

  @override
  String get legacyUiae9e814889 => 'No tickets';

  @override
  String get legacyUicc80739f43 => 'Try a different search or status filter.';

  @override
  String get legacyUib1ac2d29f2 =>
      'Create a ticket and the team will follow up here.';

  @override
  String legacyUia6864fdac8(Object value1) {
    return '$value1 rows';
  }

  @override
  String get legacyUi8f26c6520d => 'Loading';

  @override
  String legacyUie7a93c340a(Object value1) {
    return '$value1 events';
  }

  @override
  String get legacyUia4ab77ad86 => 'OpenVTS event';

  @override
  String get legacyUif55aae5a86 => 'IMEI unavailable';

  @override
  String get legacyUib8eb4a7ee3 => 'Loading commands…';

  @override
  String get legacyUif7933da683 => 'No compatible commands';

  @override
  String get legacyUi4be4430e57 => 'Select command';

  @override
  String legacyUi70ac5dd63e(Object value1) {
    return 'TIMELINE ($value1)';
  }

  @override
  String legacyUi24d8fbef9d(Object value1, Object value2) {
    return '$value1 ${value2}x';
  }

  @override
  String legacyUibde2a7e880(Object value1, Object value2, Object value3) {
    return 'Page $value1 of $value2 · $value3 trips';
  }

  @override
  String legacyUi08343b3fe7(Object value1) {
    return '$value1 remaining';
  }

  @override
  String legacyUi843b148bbc(Object value1) {
    return 'ETA $value1';
  }

  @override
  String legacyUi46d11990c5(Object value1) {
    return 'Position updated $value1';
  }

  @override
  String legacyUiecd87f34a4(Object value1) {
    return 'Delete $value1?';
  }

  @override
  String legacyUi666b616488(Object value1) {
    return 'Expires $value1';
  }

  @override
  String get legacyUic7ac551ef0 => 'Deleting…';

  @override
  String legacyUi27015ac78b(Object value1, Object value2) {
    return '$value1 unread · Latest $value2 notifications';
  }

  @override
  String legacyUi46b0a7d4ca(Object value1, Object value2) {
    return '$value1 / $value2 stops completed';
  }

  @override
  String get legacyUidc7f2c3785 => 'Date unavailable';

  @override
  String get legacyUib11b062b52 => 'Upload trip proof';

  @override
  String get legacyUi8f1a9ca44a => 'PDF, JPG, PNG or WebP · Up to 5 MB';

  @override
  String get legacyUi91df716a6b =>
      'PDF, JPG, PNG, WebP, DOC or DOCX · Up to 5 MB';

  @override
  String get legacyUid921a79afa => 'Uploading…';

  @override
  String legacyUiba9b85b92a(Object value1) {
    return 'Last update $value1';
  }

  @override
  String legacyUib9f8dfe265(Object value1) {
    return 'Distance today: $value1';
  }

  @override
  String legacyUif0ea529a1a(Object value1) {
    return '$value1 days';
  }

  @override
  String legacyUi387c4ee271(Object value1, Object value2) {
    return '$value1  ·  $value2 days';
  }

  @override
  String get legacyUideba3e1d0f => 'Dry-run summary';

  @override
  String get legacyUia7d0c36803 => 'Last cleanup';

  @override
  String legacyUia24243eb0c(Object value1) {
    return 'Tables ($value1)';
  }

  @override
  String get legacyUic74a3012a0 => 'Checking status…';

  @override
  String get legacyUie991a76914 => 'Status unknown';

  @override
  String get legacyUia722bd6476 =>
      'Platform growth across users, vehicles, and licenses.';

  @override
  String legacyUi852c487a99(Object value1) {
    return 'License peak $value1';
  }

  @override
  String legacyUic44efcae53(Object value1) {
    return 'Remove $value1 from the platform? This action cannot be undone.';
  }

  @override
  String legacyUicac4f1ac56(Object value1) {
    return '$value1 Admin';
  }

  @override
  String legacyUi68401f3c9e(Object value1, Object value2) {
    return 'Avg $value1 $value2 per transaction';
  }

  @override
  String get legacyUi526698fef7 => 'Unable to refresh vehicles.';

  @override
  String legacyUie9b7179dd3(Object value1) {
    return 'Documents ($value1)';
  }

  @override
  String get legacyUiefd8314874 => 'Unable to refresh documents.';

  @override
  String get legacyUie214b8a299 => 'Document';

  @override
  String legacyUidb4675bc22(Object value1) {
    return 'Balance $value1';
  }

  @override
  String legacyUi16be827cb6(Object value1) {
    return 'Vehicle $value1';
  }

  @override
  String get legacyUibd5caf1601 =>
      'Tracking is blocked by the software license limit.';

  @override
  String get legacyUid8663517be => 'Last check: —';

  @override
  String get legacyUi1be0035c25 => 'Own';

  @override
  String get legacyUi5f1184f7df => 'Global';

  @override
  String get legacyUif5f940cfe2 => 'Save permissions';

  @override
  String legacyUi8a9135d5ad(Object value1) {
    return '$value1% collected';
  }

  @override
  String legacyUi3b0c54fa00(Object value1) {
    return 'Projected $value1';
  }

  @override
  String legacyUi16ff2e7fa9(Object value1) {
    return 'Delta $value1';
  }

  @override
  String legacyUi4956298616(Object value1, Object value2) {
    return '$value1 veh · $value2';
  }

  @override
  String legacyUi120d777276(Object value1) {
    return 'Paid $value1';
  }

  @override
  String legacyUi617d0ebe3d(Object value1, Object value2) {
    return '$value1 of $value2 plans';
  }

  @override
  String get legacyUi25422daedb => 'Untitled Vehicle';

  @override
  String legacyUicbbe928bb9(Object value1) {
    return 'Annual coverage: $value1';
  }

  @override
  String legacyUiec60ebb81f(Object value1) {
    return 'Customer service: $value1';
  }

  @override
  String legacyUiced28bc228(Object value1) {
    return 'Account credits: $value1';
  }

  @override
  String get legacyUic1a90693df => 'Live tracking active';

  @override
  String legacyUi4bdc33e519(Object value1, Object value2) {
    return '$value1 · $value2 days';
  }

  @override
  String get legacyUi889f282a7d => 'Choose date and time';

  @override
  String get legacyUi83cbbbc297 => 'Save service changes';

  @override
  String get legacyUi69feaaf8cd => 'All dates';

  @override
  String get legacyUi0c6c4102d4 => 'Optional';

  @override
  String legacyUic57882f9c9(Object value1) {
    return 'Status: $value1';
  }

  @override
  String legacyUiae3c1f8817(Object value1) {
    return 'Send this command to $value1?';
  }

  @override
  String legacyUic51f739b4e(Object value1) {
    return 'Assigned Users ($value1)';
  }

  @override
  String get legacyUibc7819b34f => 'Unknown';

  @override
  String legacyUi46aece3259(Object value1) {
    return 'Remove $value1 from this vehicle?';
  }

  @override
  String legacyUi3d2bb84b75(Object value1, Object value2) {
    return 'Live Value: $value1 $value2';
  }

  @override
  String legacyUieb3a3daafa(Object value1) {
    return 'Code: $value1';
  }

  @override
  String legacyUi93aa5178d6(Object value1) {
    return 'Document type: $value1';
  }

  @override
  String legacyUi0e12da1c5e(Object value1) {
    return 'File: $value1';
  }

  @override
  String legacyUi3ce1585208(Object value1) {
    return 'Expiry: $value1';
  }

  @override
  String legacyUiaeafae8a12(Object value1) {
    return 'Visibility: $value1';
  }

  @override
  String legacyUi39d7217391(Object value1) {
    return 'Tags: $value1';
  }

  @override
  String legacyUi4439ddf5a2(Object value1) {
    return 'Created: $value1';
  }

  @override
  String legacyUid5c6adaee3(Object value1) {
    return 'Remove $value1 from this driver?';
  }

  @override
  String get legacyUieb7eb7a819 => 'Choose file';

  @override
  String get legacyUi8f8dd8dbd3 => 'Hidden from admin';

  @override
  String get legacyUi65d06317e9 => 'Admin users can see this document';

  @override
  String get legacyUic0e9577a75 => 'Only owner can see';

  @override
  String legacyUi864cf8bc08(Object value1) {
    return 'Attributes: $value1';
  }

  @override
  String legacyUi90d40c4249(Object value1) {
    return 'Raw: $value1';
  }

  @override
  String get legacyUia4d06ed284 => 'Vehicle Event';

  @override
  String legacyUifba61e1a50(Object value1, Object value2, Object value3,
      Object value4, Object value5, Object value6) {
    return '$value1 • $value2 • sent $value3 • delivered $value4 • retry $value5$value6';
  }

  @override
  String legacyUi9c07a085f8(Object value1, Object value2) {
    return '$value1 of $value2 transactions';
  }

  @override
  String legacyUi26b3b5dfb3(Object value1) {
    return '$value1 Retry';
  }

  @override
  String legacyUi05563fda41(Object value1, Object value2, Object value3) {
    return 'Plan: $value1 • $value2 $value3';
  }

  @override
  String legacyUi26400a7353(Object value1, Object value2) {
    return '$value1 vehicle$value2 selected';
  }

  @override
  String legacyUi8f4ab245d3(Object value1, Object value2) {
    return 'Auto Total: $value1 $value2';
  }

  @override
  String get legacyUi493de0b548 => 'Quote expired';

  @override
  String legacyUi78218dbd5f(Object value1, Object value2, Object value3) {
    return '$value1 · $value2 · $value3 days';
  }

  @override
  String legacyUi13e7357d18(Object value1) {
    return 'I received $value1';
  }

  @override
  String get legacyUi7e72a446c4 => 'Hide payment filters';

  @override
  String get legacyUi8f642c1d28 => 'Show payment filters';

  @override
  String legacyUi184c3f0cbb(Object value1) {
    return 'Transaction ID: $value1';
  }

  @override
  String legacyUi281961b9ee(Object value1) {
    return 'Amount: $value1';
  }

  @override
  String legacyUib40416c0af(Object value1) {
    return 'Payment Type: $value1';
  }

  @override
  String legacyUia0d65517a6(Object value1) {
    return 'Payment Mode: $value1';
  }

  @override
  String legacyUic2d62e9f71(Object value1) {
    return 'Reference: $value1';
  }

  @override
  String legacyUib0f627962a(Object value1) {
    return 'Provider: $value1';
  }

  @override
  String legacyUie802a1b0a0(Object value1) {
    return 'Provider Ref: $value1';
  }

  @override
  String legacyUi2751887374(Object value1) {
    return 'From: $value1';
  }

  @override
  String legacyUi250106ee83(Object value1) {
    return 'To: $value1';
  }

  @override
  String legacyUi5ff8e9357b(Object value1) {
    return 'Recorded By: $value1';
  }

  @override
  String legacyUi7565bbdff9(Object value1) {
    return 'Vehicle: $value1';
  }

  @override
  String legacyUi2b542f8050(Object value1) {
    return 'IMEI: $value1';
  }

  @override
  String legacyUi76e24a00cf(Object value1) {
    return 'Plan: $value1';
  }

  @override
  String legacyUi972db7d65e(Object value1) {
    return 'Failure Code: $value1';
  }

  @override
  String legacyUif147c11396(Object value1) {
    return 'Failure Message: $value1';
  }

  @override
  String get legacyUic3146cdbec =>
      'Create a ticket to start a support conversation.';

  @override
  String legacyUi2cbdc50885(Object value1) {
    return 'Remove $value1 from this administrator account?';
  }

  @override
  String legacyUi073ab8a05c(Object value1, Object value2) {
    return '$value1 assigned - $value2 available';
  }

  @override
  String legacyUidcc59f9fcf(Object value1) {
    return 'Select $value1';
  }

  @override
  String get legacyUi7a19b6deae => 'No options available';

  @override
  String get legacyUif28cfb8eb0 => '1 ticket';

  @override
  String legacyUidf08f563b7(Object value1) {
    return 'Optional files, up to $value1.';
  }

  @override
  String get legacyUi5f2b4010d1 => '1 payment';

  @override
  String get legacyUi876081608a => 'Renewal — 1 vehicle';

  @override
  String legacyUia034f3f5e5(Object value1) {
    return 'Estimated total $value1';
  }

  @override
  String legacyUic07d143675(Object value1) {
    return 'Renewed Vehicles ($value1)';
  }

  @override
  String legacyUiff384c8aa4(Object value1) {
    return 'Remove $value1 from this user?';
  }

  @override
  String legacyUicb6d241451(Object value1, Object value2) {
    return '$value1 files - $value2 user types';
  }

  @override
  String get legacyUif63f04564a => 'Loading user types';

  @override
  String get legacyUi74b1d89d85 => 'Choose a file';

  @override
  String get legacyUi62783d600b => 'Shown in user documents';

  @override
  String get legacyUi38fc177e28 => 'Hidden from user';

  @override
  String legacyUibce346e856(Object value1, Object value2) {
    return '$value1 User$value2';
  }

  @override
  String get legacyUi674b652fca => 'Change dates';

  @override
  String get legacyUi08d0e4f72a => 'Loading transactions…';

  @override
  String get legacyUib3a56d64d2 => 'No transactions match these filters.';

  @override
  String get legacyUi049ac820da => 'Working...';

  @override
  String legacyUie783127bc1(Object value1) {
    return 'Joined $value1';
  }

  @override
  String legacyUieb587f7802(Object value1) {
    return 'Profile updated $value1';
  }

  @override
  String get legacyUi1dfc507715 =>
      'Country and mobile prefix references are unavailable. You can still edit manually.';

  @override
  String get legacyUia7c1498ab2 =>
      'You are subscribed to profile email notifications.';

  @override
  String get legacyUi77653a7db4 =>
      'Subscribe to receive profile and account email updates.';

  @override
  String get legacyUid3b8add13e => 'Options unavailable.';

  @override
  String legacyUi08b544b680(Object value1) {
    return 'Driven $value1';
  }

  @override
  String legacyUi6c783ae69f(Object value1) {
    return 'Showing 10 of $value1 latest alerts';
  }

  @override
  String get legacyUi45ef37a941 => 'No message provided.';

  @override
  String get legacyUia2ae39a298 => 'Channel unknown';

  @override
  String get legacyUiceafde86d6 => 'Sending';

  @override
  String get legacyUi46cefb25e2 => 'Send command';

  @override
  String legacyUib3d1704245(Object value1) {
    return 'Day window: $value1';
  }

  @override
  String legacyUi735f148a9a(Object value1) {
    return 'type: $value1';
  }

  @override
  String legacyUi828a91effc(Object value1, Object value2, Object value3) {
    return '$value1 of $value2 vehicles • $value3 selected';
  }

  @override
  String legacyUia0ebdc2307(Object value1, Object value2, Object value3) {
    return '$value1 visible • $value2/$value3 loaded';
  }

  @override
  String legacyUi1d483a1343(Object value1) {
    return 'Remove $value1 from this sub user?';
  }

  @override
  String legacyUi02b84d460d(Object value1) {
    return '$value1 available to assign';
  }

  @override
  String get legacyUi65ad788d45 => 'Plate unavailable';

  @override
  String get legacyUi7bb4f2808b => 'Sub user can access assigned vehicles';

  @override
  String get legacyUi26b21a0d91 => 'Sub user is disabled';

  @override
  String legacyUibceb1630f0(Object value1, Object value2) {
    return '$value1 files - $value2 document types';
  }

  @override
  String get legacyUi107b9056eb => 'Loading driver types';

  @override
  String legacyUifd7e37cf51(Object value1, Object value2) {
    return '$value1 of $value2 drivers';
  }

  @override
  String legacyUi14b274c7ae(Object value1, Object value2) {
    return '$value1 of $value2 vehicles';
  }

  @override
  String legacyUi79a100acf7(Object value1) {
    return 'Remove $value1?';
  }

  @override
  String legacyUi26875fe2e3(Object value1, Object value2) {
    return '$value1 files - $value2 vehicle types';
  }

  @override
  String legacyUi7970bd3e0b(Object value1) {
    return '$value1 could not be loaded.';
  }

  @override
  String get legacyUi5eaf2646c3 => 'Loading vehicle types';

  @override
  String get legacyUi6ca60537ae => 'Shown in vehicle documents';

  @override
  String get legacyUi4e3d045a97 => 'Hidden from users';

  @override
  String get legacyUid3ce77345e => 'Sensor history';

  @override
  String legacyUi5aba89cd2f(Object value1) {
    return '$value1 numeric points';
  }

  @override
  String get legacyUie86a33f16a => 'All geofences';

  @override
  String legacyUi5321a316d0(Object value1) {
    return 'Source: $value1';
  }

  @override
  String legacyUifabeb88d9c(Object value1) {
    return 'Use $value1 selected';
  }

  @override
  String legacyUi343ceded71(Object value1) {
    return 'Events by Geofence (top $value1)';
  }

  @override
  String legacyUide36170209(Object value1) {
    return 'Alert Types (top $value1)';
  }

  @override
  String legacyUi019e5212ef(Object value1, Object value2) {
    return '$value1 km/h (limit $value2)';
  }

  @override
  String legacyUicaae0add4a(Object value1, Object value2) {
    return '$value1 active day$value2';
  }

  @override
  String legacyUi7911e1ad0c(Object value1, Object value2) {
    return '$value1 result$value2';
  }

  @override
  String legacyUi15b175bbc9(Object value1) {
    return 'Generated at $value1';
  }

  @override
  String legacyUi92a50db48d(Object value1) {
    return 'Export $value1 Report';
  }

  @override
  String legacyUida6472ea1a(Object value1) {
    return 'All $value1 vehicles will be included';
  }

  @override
  String get legacyUib0c379b2f8 => 'Select a vehicle group';

  @override
  String get legacyUi23d6943e8b => 'Select Vehicles';

  @override
  String legacyUi47b7508acb(Object value1) {
    return 'Done ($value1)';
  }

  @override
  String legacyUid495bed9d8(Object value1) {
    return 'Select all visible ($value1)';
  }

  @override
  String legacyUi096909f019(Object value1, Object value2) {
    return '$value1 vehicle$value2';
  }

  @override
  String legacyUie003b8a491(Object value1) {
    return 'Max $value1 days for this report type';
  }

  @override
  String legacyUif386fe6e70(Object value1) {
    return 'Clear ($value1)';
  }

  @override
  String get legacyUi706049c6a9 => 'Select a sensor';

  @override
  String legacyUi2841c7f501(Object value1) {
    return 'No reports found for \"$value1\"';
  }

  @override
  String legacyUi8002c1aa36(Object value1) {
    return 'Times use $value1.';
  }

  @override
  String legacyUieaa190f343(Object value1) {
    return '$value1 enabled';
  }

  @override
  String legacyUidc179fe07f(Object value1) {
    return 'Speed limit must be at least 1 $value1.';
  }

  @override
  String legacyUi11003e8471(Object value1) {
    return '$value1 Delivery Channels';
  }

  @override
  String legacyUidc7454d672(Object value1) {
    return 'Last saved $value1';
  }

  @override
  String get legacyUi7968beb979 => 'Code -';

  @override
  String legacyUi0528ad37c9(Object value1, Object value2) {
    return '$value1 of $value2 links';
  }

  @override
  String get legacyUiac2a036e38 => 'No activity yet';

  @override
  String legacyUi3a4361ec75(Object value1) {
    return '\"$value1\" will be permanently removed.';
  }

  @override
  String get legacyUi50a9e13fce => 'Untitled geofence';

  @override
  String legacyUi760cb5d683(Object value1, Object value2) {
    return '$value1 point$value2';
  }

  @override
  String legacyUifa6e784713(Object value1) {
    return 'Remove #$value1';
  }

  @override
  String legacyUi27a25269f5(Object value1) {
    return 'Fine-adjust ($value1 m)';
  }

  @override
  String get legacyUi39706b5a17 => 'No geometry yet';

  @override
  String get legacyUi1bf6cb6c45 => 'Geometry ready';

  @override
  String get legacyUi5d437ca98b => 'Events will trigger for this geofence.';

  @override
  String get legacyUi6d8b4724c6 => 'Geofence is paused.';

  @override
  String get legacyUi7e9f5c3026 => 'Draw at least 2 points on the map.';

  @override
  String get legacyUi28134edb87 => 'Edit on map';

  @override
  String get legacyUi0f873fbc31 => 'Draw on map';

  @override
  String legacyUi48f6c8c8ac(Object value1) {
    return '${value1}m';
  }

  @override
  String legacyUicde59da67c(Object value1) {
    return '${value1}min';
  }

  @override
  String get legacyUi4bd1e22ea7 => 'Untitled route';

  @override
  String legacyUi198f442dfb(Object value1) {
    return 'Vertex $value1';
  }

  @override
  String legacyUibae08b3767(Object value1, Object value2) {
    return 'Row $value1: $value2';
  }

  @override
  String get legacyUi93039e609d => 'Not set';

  @override
  String get legacyUid33a96e366 => 'Pick on map';

  @override
  String get legacyUiecd575d434 => 'Visible on live map and proximity alerts.';

  @override
  String get legacyUi92a172ce15 => 'Hidden from alerts; stays in the list.';

  @override
  String get legacyUi8019307fe5 => 'Untitled POI';

  @override
  String get legacyUid14e0c02a9 => 'Live tracking available';

  @override
  String legacyUic814ea2b6e(Object value1) {
    return 'Service starts: $value1';
  }

  @override
  String legacyUic926abedfd(Object value1) {
    return 'Customer service expires: $value1';
  }

  @override
  String legacyUiae0052da76(Object value1) {
    return 'Provider coverage expires: $value1';
  }

  @override
  String legacyUi633ec01c21(Object value1, Object value2) {
    return '$value1 • $value2 days';
  }

  @override
  String get legacyUicf765512cc => 'Sending…';

  @override
  String get legacyUi50756f98a3 => 'Request renewal';

  @override
  String legacyUid52adacef9(Object value1) {
    return 'Request #$value1';
  }

  @override
  String get legacyUicfeb791a76 => 'Expired request';

  @override
  String legacyUif0d8958371(Object value1, Object value2, Object value3,
      Object value4, Object value5) {
    return '$value1\n$value2 • $value3 days\n$value4 $value5\n\nYour administrator must confirm payment before service is extended.';
  }

  @override
  String get legacyUifdb17036d5 => 'OpenVTS User';

  @override
  String legacyUif7e83b3f19(Object value1) {
    return 'Reset to default ($value1)';
  }

  @override
  String legacyUi54e519da7f(Object value1) {
    return 'Error: $value1';
  }

  @override
  String get legacyUi7eb29d3565 => 'Date & time';

  @override
  String get legacyUib1deb07e61 => 'Open Geofence';

  @override
  String get legacyUi1dce4bf43b => 'Open POI';

  @override
  String get legacyUi4a0d050737 => 'Open Route';

  @override
  String get legacyUib6bd42e4e7 => 'In progress';

  @override
  String get legacyUi91edf8aff9 => 'On a trip';

  @override
  String get legacyUi20c7c5522f => 'Ready';

  @override
  String get legacyUi0a2b58e839 => 'No assignment';

  @override
  String get legacyUi6cf3d41f08 => 'All trips';

  @override
  String get legacyUif7a616a336 => 'Access blocked';

  @override
  String get legacyUiac7b5dd3a8 => 'Recipient unavailable';

  @override
  String get legacyUi936d2e8552 => 'Vehicle issue';

  @override
  String get legacyUi51cea59031 => 'Route issue';

  @override
  String get legacyUia972b55b1a => 'Describe the issue for dispatch.';

  @override
  String get legacyUie0cdc02f99 => '12-hour time';

  @override
  String get legacyUif910251f7c => '24-hour time';

  @override
  String get legacyUi34ce147724 => 'Left to right';

  @override
  String get legacyUida502a644e => 'Right to left';

  @override
  String get legacyUiec45717e13 => 'Contact dispatch for details.';

  @override
  String get legacyUi8a783eb3d6 => 'Assignment acknowledged.';

  @override
  String get legacyUi00e1e19595 => 'Start trip';

  @override
  String get legacyUi0015b1903d =>
      'Trips normally start from vehicle telemetry. Use this manual fallback only when beginning the trip.';

  @override
  String get legacyUib20bd98ae2 => 'Add remark';

  @override
  String get legacyUi42477e82cf => 'Unable to open navigation.';

  @override
  String get legacyUiea0bd6ff3d => 'Complete stop';

  @override
  String get legacyUi3d93beaa39 => 'Select a non-empty file up to 5 MB.';

  @override
  String get legacyUid2085cce0d => 'Select a file to upload.';

  @override
  String get legacyUid0193e6956 => 'Select a document type.';

  @override
  String get legacyUif378218081 => 'Enter at least 2 characters.';

  @override
  String get legacyUi63f72dce85 => 'Select file';

  @override
  String get legacyUi1255774559 => 'Assignments today';

  @override
  String get legacyUi3528465759 => 'Completed trips';

  @override
  String get legacyUi28793a4155 => 'Completed stops';

  @override
  String get legacyUi1683af6ce8 => 'Pending stops';

  @override
  String mobilePluralTrips(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count trips',
      one: '$count trip',
    );
    return '$_temp0';
  }

  @override
  String mobilePluralBlockedVehicles(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count blocked vehicles excluded.',
      one: '$count blocked vehicle excluded.',
    );
    return '$_temp0';
  }

  @override
  String mobilePluralSelectedVehicles(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vehicles selected',
      one: '$count vehicle selected',
    );
    return '$_temp0';
  }

  @override
  String mobilePluralUsers(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Users',
      one: '$count User',
    );
    return '$_temp0';
  }

  @override
  String mobilePluralActiveDays(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count active days',
      one: '$count active day',
    );
    return '$_temp0';
  }

  @override
  String mobilePluralResults(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count results',
      one: '$count result',
    );
    return '$_temp0';
  }

  @override
  String mobilePluralVehicles(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vehicles',
      one: '$count vehicle',
    );
    return '$_temp0';
  }

  @override
  String mobilePluralPoints(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count points',
      one: '$count point',
    );
    return '$_temp0';
  }

  @override
  String get relativeJustNow => 'just now';

  @override
  String relativeMinutesAgo(int count) {
    return '${count}m ago';
  }

  @override
  String relativeHoursAgo(int count) {
    return '${count}h ago';
  }

  @override
  String relativeDaysAgo(int count) {
    return '${count}d ago';
  }

  @override
  String get relativeYesterday => 'yesterday';

  @override
  String savingChangesForTab(String tab) {
    return 'Saving $tab changes...';
  }

  @override
  String unsavedChangesForTab(String tab) {
    return 'You have unsaved $tab changes.';
  }

  @override
  String get saving => 'Saving…';

  @override
  String validationRequired(String field) {
    return '$field is required';
  }

  @override
  String validationAscii(String field) {
    return '$field must contain ASCII characters only';
  }

  @override
  String validationMinCharacters(String field, int count) {
    return '$field must be at least $count characters';
  }

  @override
  String validationMaxCharacters(String field, int count) {
    return '$field must be $count characters or fewer';
  }

  @override
  String validationMinDigits(String field, int count) {
    return '$field must be at least $count digits';
  }

  @override
  String validationMaxDigits(String field, int count) {
    return '$field must be $count digits or fewer';
  }

  @override
  String validationNumeric(String field) {
    return '$field must be numeric';
  }

  @override
  String validationMinimumCharacters(int count) {
    return 'Minimum $count characters';
  }

  @override
  String get validationValidEmail => 'Enter a valid email address';

  @override
  String get validationValidNumber => 'Enter a valid number';

  @override
  String get validationNonnegativeCredits => 'Credits cannot be negative';

  @override
  String get validationConfirmPassword => 'Please confirm the password';

  @override
  String get validationPasswordsMismatch => 'Passwords do not match';

  @override
  String get validationStandardVin =>
      'VIN must be 17 alphanumeric characters (excluding I, O, Q)';

  @override
  String get validationVinAlphanumeric =>
      'VIN must contain only letters and numbers';

  @override
  String get validationThisField => 'This field';

  @override
  String get validationFieldSimNumber => 'SIM number';

  @override
  String get mobileDataBackup => 'Data Backup';

  @override
  String get mobileEffectiveRetention => 'Effective retention';

  @override
  String get mobileAdministratorLimit => 'Administrator limit';

  @override
  String get mobilePolicySource => 'Policy source';

  @override
  String mobileUseAdministratorPolicy(String value1) {
    return 'Use administrator policy ($value1)';
  }

  @override
  String get mobileRetentionCleanupNotice =>
      'Historical telemetry older than the retention period is removed by scheduled cleanup. Increasing retention does not restore deleted data.';

  @override
  String mobileRetentionLimitError(String value1) {
    return 'The retention period cannot exceed $value1 days.';
  }

  @override
  String get mobileRetentionLoadError => 'Unable to load data retention';

  @override
  String get mobileRetentionSaveError => 'Unable to save data retention';

  @override
  String get mobileRetentionSaved => 'Data retention updated';

  @override
  String get mobileRetentionUnsupported =>
      'The server returned an unsupported retention policy. Editing is disabled.';

  @override
  String get mobileDiscardDetailChanges => 'Changes will be lost. Continue?';

  @override
  String get mobileLiveTrackingReconnecting => 'Live tracking reconnecting…';

  @override
  String get mobileLastConnection => 'Last connection';

  @override
  String get mobileTeamLoadError => 'Team could not be loaded.';

  @override
  String get mobilePermissionsLoadError => 'Permissions could not be loaded.';

  @override
  String get mobileActivityLoadError => 'Activity could not be loaded.';

  @override
  String get mobilePermissionsRetryError =>
      'Unable to load or save permissions. Please try again.';

  @override
  String get mobilePermissionMaps => 'Maps';

  @override
  String get mobilePermissionLandmarks => 'Landmarks';

  @override
  String get mobilePermissionShareTracking => 'Share tracking link';

  @override
  String get mobilePrivacyPolicyLink => 'Privacy policy';

  @override
  String get mobilePageLinkError =>
      'Unable to open this page. Please try again.';
}
