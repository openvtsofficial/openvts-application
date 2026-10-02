// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get date => 'Date';

  @override
  String get time => 'Heure';

  @override
  String get direction => 'Direction';

  @override
  String get units => 'Unités';

  @override
  String get appTitle => 'OpenVTS';

  @override
  String get settings => 'Paramètres';

  @override
  String get localization => 'Localisation';

  @override
  String get language => 'Langue';

  @override
  String get theme => 'Thème';

  @override
  String get dateFormat => 'Format de date';

  @override
  String get timeFormat => 'Format de l\'heure';

  @override
  String get timezone => 'Fuseau horaire';

  @override
  String get use24Hour => 'Heure 24 heures';

  @override
  String get save => 'Enregistrer';

  @override
  String get cancel => 'Annuler';

  @override
  String get edit => 'Modifier';

  @override
  String get search => 'Rechercher';

  @override
  String get delete => 'Supprimer';

  @override
  String get reset => 'Réinitialiser';

  @override
  String get close => 'Fermer';

  @override
  String get back => 'Retour';

  @override
  String get next => 'Suivant';

  @override
  String get prev => 'Précédent';

  @override
  String get loading => 'Chargement...';

  @override
  String get error => 'Erreur';

  @override
  String get success => 'Succès';

  @override
  String get warning => 'Avertissement';

  @override
  String get light => 'Clair';

  @override
  String get dark => 'Sombre';

  @override
  String get system => 'Système';

  @override
  String get en => 'Anglais';

  @override
  String get hi => 'Hindi';

  @override
  String get ar => 'Arabe';

  @override
  String get es => 'Espagnol';

  @override
  String get fr => 'Français';

  @override
  String get pt => 'Portugais';

  @override
  String get profile => 'Profil';

  @override
  String get logout => 'Déconnexion';

  @override
  String get login => 'Connexion';

  @override
  String get register => 'S\'inscrire';

  @override
  String get administrators => 'Administrateurs';

  @override
  String get payments => 'Paiements';

  @override
  String get support => 'Support';

  @override
  String get tickets => 'Tickets';

  @override
  String get home => 'Accueil';

  @override
  String get dashboard => 'Tableau de bord';

  @override
  String get keepEditing => 'Continuer la modification';

  @override
  String get discardChanges => 'Abandonner les modifications';

  @override
  String get unsavedChanges => 'Modifications non enregistrées';

  @override
  String get refresh => 'Actualiser';

  @override
  String get selectLanguage => 'Sélectionner une langue';

  @override
  String get selectTheme => 'Sélectionner un thème';

  @override
  String get selectDateFormat => 'Sélectionner un format de date';

  @override
  String get selectTimeFormat => 'Sélectionner un format d\'heure';

  @override
  String get selectTimezone => 'Sélectionner un fuseau horaire';

  @override
  String previewDate(String date) {
    return 'Aperçu: $date';
  }

  @override
  String previewTime(String time) {
    return 'Aperçu: $time';
  }

  @override
  String get settingsUpdated => 'Paramètres mis à jour';

  @override
  String get profileUpdated => 'Profil mis à jour';

  @override
  String get localizationUpdated => 'Paramètres de localisation mis à jour';

  @override
  String get failedToUpdate => 'Échec de la mise à jour. Veuillez réessayer.';

  @override
  String get noData => 'Aucune donnée disponible';

  @override
  String get retry => 'Réessayer';

  @override
  String get confirmDiscard => 'Abandonner les modifications non enregistrées?';

  @override
  String confirmDiscardMessage(String tab) {
    return '$tab contient des modifications non enregistrées. L\'abandon perdra ces modifications.';
  }

  @override
  String get reportsTitle => 'Rapports';

  @override
  String get reportsSearchHint => 'Rechercher des rapports…';

  @override
  String reportsNoResultsFor(Object query) {
    return 'Aucun rapport trouvé pour \"$query\"';
  }

  @override
  String get reportsGenerate => 'Générer le rapport';

  @override
  String get reportsGenerating => 'Génération…';

  @override
  String get reportsReset => 'Réinitialiser';

  @override
  String get reportsConfigureHint =>
      'Configurez le rapport ci-dessus et appuyez sur Générer.';

  @override
  String get reportsNoResults =>
      'Aucun résultat pour les filtres sélectionnés.';

  @override
  String get reportsErrorRetry => 'Réessayer';

  @override
  String reportsRowCount(Object count) {
    return '$count lignes chargées';
  }

  @override
  String get reportsLoadMore => 'Charger plus';

  @override
  String get reportsLoadingMore => 'Loading more…';

  @override
  String reportsGeneratedAt(Object time) {
    return 'Généré $time';
  }

  @override
  String get reportsExportTitle => 'Exporter le rapport';

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
  String get reportsScopeAll => 'Tous les véhicules';

  @override
  String get reportsScopeSingle => 'Un véhicule';

  @override
  String get reportsScopeMultiple => 'Plusieurs véhicules';

  @override
  String get reportsScopeGroup => 'Groupe';

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
  String get reportsCatalogDrivenTitle => 'Jours conduits';

  @override
  String get reportsCatalogDrivenDesc =>
      'Daily distance matrix — which vehicles moved on which days and how far.';

  @override
  String get reportsCatalogDetailsTitle => 'Détails du véhicule';

  @override
  String get reportsCatalogDetailsDesc =>
      'Fleet summary: total distance, engine hours, active days, last known location per vehicle.';

  @override
  String get reportsCatalogOverspeedTitle => 'Excès de vitesse';

  @override
  String get reportsCatalogOverspeedDesc =>
      'Speeding events with observed speed, configured limit, excess, duration, and location.';

  @override
  String get reportsCatalogGeofenceTitle => 'Géofence';

  @override
  String get reportsCatalogGeofenceDesc =>
      'Entry and exit events for selected geofences with timestamps and dwell duration.';

  @override
  String get reportsCatalogAlertsTitle => 'Alertes';

  @override
  String get reportsCatalogAlertsDesc =>
      'Alert events by type and severity with acknowledgement status.';

  @override
  String get reportsCatalogSensorTitle => 'Capteur';

  @override
  String get reportsCatalogSensorDesc =>
      'Time-series readings for a specific sensor on a single vehicle with chart visualisation.';

  @override
  String get reportsCatalogLogsTitle => 'Journaux du dispositif';

  @override
  String get reportsCatalogLogsDesc =>
      'Raw communication logs from vehicle devices grouped by category and level.';

  @override
  String get reportsCatalogTimelineTitle => 'Chronologie';

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
  String get adminRole => 'Administrateur';

  @override
  String get users => 'Utilisateurs';

  @override
  String get vehicles => 'Véhicules';

  @override
  String get drivers => 'Conducteurs';

  @override
  String get team => 'Équipe';

  @override
  String get inventory => 'Inventaire';

  @override
  String get map => 'Carte';

  @override
  String get transactions => 'Transactions';

  @override
  String get calendar => 'Calendrier';

  @override
  String get logs => 'Journaux';

  @override
  String get plans => 'Forfaits';

  @override
  String get roles => 'Rôles';

  @override
  String get smtp => 'SMTP';

  @override
  String get settingsDescription =>
      'Gérez le profil, la localisation et les paramètres SMTP.';

  @override
  String get localizationDescription =>
      'Langue, date/heure, unités et centrage par défaut de la carte.';

  @override
  String get whiteLabel => 'Marque Blanche';

  @override
  String get saveChanges => 'Enregistrer les modifications';

  @override
  String get textDirection => 'Direction du texte';

  @override
  String get languageAndDirection => 'Langue et Direction';

  @override
  String get languageAndDirectionSubtitle =>
      'Langue de l\'interface et direction du texte.';

  @override
  String get dateAndTime => 'Date et Heure';

  @override
  String get dateAndTimeSubtitle =>
      'Format de date, style de l\'heure et fuseau horaire.';

  @override
  String get unitsAndTheme => 'Unités et Thème';

  @override
  String get unitsAndThemeSubtitle =>
      'Unités de distance et apparence de l\'application.';

  @override
  String get defaultMapFocus => 'Centrage Carte par Défaut';

  @override
  String get defaultMapFocusSubtitle =>
      'Centre initial de la carte et niveau de zoom.';

  @override
  String get couldNotLoadLocalization =>
      'Impossible de charger la localisation.';

  @override
  String get localizationSaved => 'Localisation enregistrée';

  @override
  String get quickPresets => 'Présélections rapides';

  @override
  String get settingsHeaderSubtitle =>
      'Profil, marque, courrier, localisation et préférences de plateforme.';

  @override
  String get localizationPreview => 'Aperçu de la localisation';

  @override
  String get latitude => 'Latitude';

  @override
  String get longitude => 'Longitude';

  @override
  String get mapZoom => 'Zoom de la carte';

  @override
  String get mapCenter => 'Centre de la carte';

  @override
  String get kilometers => 'Kilomètres';

  @override
  String get miles => 'Miles';

  @override
  String get latitudeRequired => 'La latitude est requise.';

  @override
  String get validLatitude => 'Saisissez une latitude valide.';

  @override
  String get latitudeRange => 'La latitude doit être comprise entre -90 et 90.';

  @override
  String get longitudeRequired => 'La longitude est requise.';

  @override
  String get validLongitude => 'Saisissez une longitude valide.';

  @override
  String get longitudeRange =>
      'La longitude doit être comprise entre -180 et 180.';

  @override
  String get mapZoomRequired => 'Le zoom de la carte est requis.';

  @override
  String get validMapZoom => 'Saisissez un niveau de zoom valide.';

  @override
  String get mapZoomRange =>
      'Le zoom de la carte doit être compris entre 1 et 22.';

  @override
  String get unsupportedLanguageFallback =>
      'La langue enregistrée n\'est pas disponible dans l\'application. Sélectionnez une langue prise en charge ; l\'anglais est utilisé pour le moment.';
}
