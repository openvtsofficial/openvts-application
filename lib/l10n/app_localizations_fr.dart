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
  String get reportsLoadingMore => 'Chargement…';

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
  String get reportsScopeSelectVehicle => 'Sélectionner un véhicule';

  @override
  String get reportsScopeSelectVehicles => 'Sélectionner des véhicules';

  @override
  String get reportsScopeSelectGroup => 'Sélectionner un groupe';

  @override
  String get reportsScopeSearchHint =>
      'Rechercher par nom, immatriculation ou IMEI…';

  @override
  String get reportsScopeSelectAll =>
      'Tout sélectionner parmi les éléments visibles';

  @override
  String get reportsScopeDone => 'Terminé';

  @override
  String reportsScopeNVehiclesSelected(Object count) {
    return '$count véhicules sélectionnés';
  }

  @override
  String get reportsDateStart => 'Date de début';

  @override
  String get reportsDateEnd => 'Date de fin';

  @override
  String get reportsDateFrom => 'Début';

  @override
  String get reportsDateTo => 'Fin';

  @override
  String reportsDateMaxDays(Object days) {
    return 'Maximum de $days jours pour ce type de rapport';
  }

  @override
  String get reportsValidationScopeRequired =>
      'Sélectionnez au moins un véhicule.';

  @override
  String get reportsValidationStartRequired =>
      'La date de début est obligatoire.';

  @override
  String get reportsValidationEndRequired => 'La date de fin est obligatoire.';

  @override
  String get reportsValidationStartBeforeEnd =>
      'Le début doit précéder la fin.';

  @override
  String reportsValidationMaxDays(Object days) {
    return 'La période dépasse la limite de $days jours de ce rapport.';
  }

  @override
  String get reportsValidationSensorVehicleRequired =>
      'Sélectionnez un véhicule pour le rapport du capteur.';

  @override
  String get reportsValidationSensorRequired => 'Sélectionnez un capteur.';

  @override
  String get reportsValidationTimelineStateRequired =>
      'Sélectionnez au moins un état (en mouvement ou à l’arrêt).';

  @override
  String get reportsFilterSpeedLimit => 'Limite de vitesse (km/h)';

  @override
  String get reportsFilterSpeedCustom => 'Limite personnalisée…';

  @override
  String get reportsFilterGeofenceHint => 'Rechercher des zones géographiques…';

  @override
  String get reportsFilterGeofenceAllNote =>
      'Sans sélection, toutes les zones sont incluses.';

  @override
  String get reportsFilterAlertType => 'Type d’alerte';

  @override
  String get reportsFilterAlertSeverity => 'Gravité';

  @override
  String get reportsFilterAlertAck => 'Acquittement';

  @override
  String get reportsFilterAlertAckAll => 'Tous';

  @override
  String get reportsFilterAlertAckAcknowledged => 'Acquitté';

  @override
  String get reportsFilterAlertAckUnacknowledged => 'Non acquitté';

  @override
  String get reportsFilterLogsVehicle => 'Véhicule';

  @override
  String get reportsFilterLogsCategory => 'Catégorie';

  @override
  String get reportsFilterLogsLevel => 'Niveau';

  @override
  String get reportsFilterTimelineRunning => 'En mouvement';

  @override
  String get reportsFilterTimelineStopped => 'À l’arrêt';

  @override
  String get reportsFilterSensorVehicle => 'Véhicule';

  @override
  String get reportsFilterSensorSensor => 'Capteur';

  @override
  String get reportsCatalogDistanceTitle => 'Distance';

  @override
  String get reportsCatalogDistanceDesc =>
      'Distance quotidienne par véhicule, heures moteur et relevés du compteur kilométrique.';

  @override
  String get reportsCatalogDrivenTitle => 'Jours conduits';

  @override
  String get reportsCatalogDrivenDesc =>
      'Tableau des distances quotidiennes : véhicules en déplacement, jours et distances.';

  @override
  String get reportsCatalogDetailsTitle => 'Détails du véhicule';

  @override
  String get reportsCatalogDetailsDesc =>
      'Synthèse de flotte : distance, heures moteur, jours d’activité et dernière position par véhicule.';

  @override
  String get reportsCatalogOverspeedTitle => 'Excès de vitesse';

  @override
  String get reportsCatalogOverspeedDesc =>
      'Excès de vitesse avec vitesse relevée, limite, dépassement, durée et position.';

  @override
  String get reportsCatalogGeofenceTitle => 'Géofence';

  @override
  String get reportsCatalogGeofenceDesc =>
      'Entrées et sorties des zones sélectionnées, avec horodatage et durée de présence.';

  @override
  String get reportsCatalogAlertsTitle => 'Alertes';

  @override
  String get reportsCatalogAlertsDesc =>
      'Alertes par type et gravité, avec état d’acquittement.';

  @override
  String get reportsCatalogSensorTitle => 'Capteur';

  @override
  String get reportsCatalogSensorDesc =>
      'Relevés chronologiques d’un capteur sur un véhicule, avec graphique.';

  @override
  String get reportsCatalogLogsTitle => 'Journaux du dispositif';

  @override
  String get reportsCatalogLogsDesc =>
      'Journaux bruts des appareils des véhicules, regroupés par catégorie et niveau.';

  @override
  String get reportsCatalogTimelineTitle => 'Chronologie';

  @override
  String get reportsCatalogTimelineDesc =>
      'Segments de mouvement et d’arrêt, avec durée, distance et trace GPS.';

  @override
  String get reportsKpiTotalDistance => 'Distance totale';

  @override
  String get reportsKpiEngineHours => 'Heures moteur';

  @override
  String get reportsKpiActiveVehicles => 'Véhicules actifs';

  @override
  String get reportsKpiAvgDistance => 'Distance moyenne';

  @override
  String get reportsKpiVehiclesDriven => 'Véhicules en circulation';

  @override
  String get reportsKpiAvgDaily => 'Moyenne quotidienne';

  @override
  String get reportsKpiPeakDay => 'Jour de pointe';

  @override
  String get reportsKpiViolations => 'Infractions';

  @override
  String get reportsKpiAffectedVehicles => 'Véhicules concernés';

  @override
  String get reportsKpiHighestSpeed => 'Vitesse maximale';

  @override
  String get reportsKpiTotalDuration => 'Durée totale';

  @override
  String get reportsKpiTotalEvents => 'Total des événements';

  @override
  String get reportsKpiEntries => 'Entrées';

  @override
  String get reportsKpiExits => 'Sorties';

  @override
  String get reportsKpiTotalAlerts => 'Total des alertes';

  @override
  String get reportsKpiCritical => 'Critique';

  @override
  String get reportsKpiAcknowledged => 'Acquittées';

  @override
  String get reportsKpiReadings => 'Relevés';

  @override
  String get reportsKpiOnEvents => 'Événements d’activation';

  @override
  String get reportsKpiOffEvents => 'Événements de désactivation';

  @override
  String get reportsKpiTotalLogs => 'Total des journaux';

  @override
  String get reportsKpiRunningDuration => 'Durée en mouvement';

  @override
  String get reportsKpiStoppedDuration => 'Durée à l’arrêt';

  @override
  String get reportsKpiMovementDistance => 'Distance parcourue';

  @override
  String get reportsKpiStopCount => 'Nombre d’arrêts';

  @override
  String get reportsDetailTitle => 'Détails de la ligne';

  @override
  String get reportsDetailRawPayload => 'Données brutes';

  @override
  String get reportsDetailCopied => 'Copié';

  @override
  String get reportsDetailCopy => 'Copier';

  @override
  String get reportsDetailTruncated =>
      'Données abrégées pour l’affichage. Exportez pour obtenir les données complètes.';

  @override
  String get reportsRowDetailsViewMap => 'Afficher la carte';

  @override
  String get reportsRowDetailsHideMap => 'Masquer la carte';

  @override
  String get reportsRowDetailsNoGps => 'Aucune donnée GPS pour ce segment.';

  @override
  String reportsWarningBanner(Object message) {
    return 'Avertissement : $message';
  }

  @override
  String reportsSourceLabel(Object source) {
    return 'Source : $source';
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

  @override
  String homeWorkspace(Object role) {
    return 'Espace de travail $role';
  }

  @override
  String get homeAccessUnavailable =>
      'Impossible d’actualiser les accès. Faites glisser vers le bas pour réessayer.';

  @override
  String get homeCopyright => '© 2026 Open VTS Tous droits réservés.';

  @override
  String get lightMode => 'Mode clair';

  @override
  String get darkMode => 'Mode sombre';

  @override
  String get landmarksStudio => 'Gestion des lieux';

  @override
  String get trackLinks => 'Liens de suivi';

  @override
  String get messages => 'Messages';

  @override
  String get accounts => 'Comptes';

  @override
  String get notifications => 'Notifications';

  @override
  String get operations => 'Opérations';

  @override
  String get server => 'Serveur';

  @override
  String get trips => 'Trajets';

  @override
  String get documents => 'Documents';

  @override
  String get userRole => 'Utilisateur';

  @override
  String get subuserRole => 'Sous-utilisateur';

  @override
  String get driverRole => 'Conducteur';

  @override
  String get superadminRole => 'Superadministrateur';

  @override
  String get demoReadOnly => 'Démo • Lecture seule';

  @override
  String get security => 'Sécurité';

  @override
  String get routeBuilderCreate => 'Créer un itinéraire';

  @override
  String get routeBuilderEdit => 'Modifier l’itinéraire';

  @override
  String get routeBuilderName => 'Nom de l’itinéraire';

  @override
  String get routeBuilderNameHint => 'Par exemple, livraisons du matin';

  @override
  String get routeBuilderNameError =>
      'Saisissez un nom d’au moins 2 caractères.';

  @override
  String get routeBuilderStops => 'Arrêts';

  @override
  String get routeBuilderAddStop => 'Ajouter un arrêt';

  @override
  String get routeBuilderEditStop => 'Modifier l’arrêt';

  @override
  String get routeBuilderStopName => 'Nom de l’arrêt';

  @override
  String get routeBuilderStopNameError =>
      'Saisissez un nom de 1 à 160 caractères.';

  @override
  String get routeBuilderAddress => 'Adresse (facultative)';

  @override
  String get routeBuilderCoordinates => 'Coordonnées';

  @override
  String get routeBuilderLatitude => 'Latitude';

  @override
  String get routeBuilderLongitude => 'Longitude';

  @override
  String get routeBuilderCoordinateError =>
      'Saisissez une latitude valide (−90 à 90) et une longitude valide (−180 à 180).';

  @override
  String get routeBuilderMap => 'Choisir sur la carte';

  @override
  String get routeBuilderMapHint =>
      'Touchez la carte pour choisir l’emplacement de l’arrêt.';

  @override
  String get routeBuilderUseLocation => 'Utiliser cette position';

  @override
  String get routeBuilderPoi => 'Point d’intérêt';

  @override
  String get routeBuilderGeofence => 'Zone géographique';

  @override
  String get routeBuilderLandmarkSearch => 'Rechercher des lieux enregistrés';

  @override
  String get routeBuilderNoLandmarks =>
      'Aucun lieu correspondant avec des coordonnées valides.';

  @override
  String get routeBuilderLandmarkError =>
      'Impossible de charger les lieux. Réessayez.';

  @override
  String get routeBuilderStopLimit =>
      'Un itinéraire peut contenir jusqu’à 100 arrêts, y compris le retour.';

  @override
  String get routeBuilderMinimumStops => 'Ajoutez au moins 2 arrêts distincts.';

  @override
  String get routeBuilderRoundTrip => 'Retour au départ';

  @override
  String get routeBuilderRoundTripHint =>
      'Ajoutez le point de départ comme destination finale.';

  @override
  String get routeBuilderOptimize => 'Optimiser l’ordre';

  @override
  String get routeBuilderOptimizeHint =>
      'Réordonne les arrêts selon la distance géographique, en conservant le départ et la destination. La distance routière est calculée séparément.';

  @override
  String get routeBuilderRoadPath => 'Aperçu du trajet routier';

  @override
  String get routeBuilderRouting => 'Calcul de l’itinéraire routier…';

  @override
  String get routeBuilderRoutingError =>
      'Aucun itinéraire routier disponible. Vérifiez les arrêts ou votre connexion, puis réessayez.';

  @override
  String get routeBuilderReady => 'Itinéraire routier prêt';

  @override
  String get routeBuilderChanged =>
      'Les arrêts ont changé. Prévisualisez le nouvel itinéraire avant d’enregistrer.';

  @override
  String get routeBuilderSaveError =>
      'Impossible d’enregistrer l’itinéraire. Réessayez.';

  @override
  String get routeBuilderAccessDenied =>
      'Vous n’avez pas l’autorisation de créer ou modifier des itinéraires.';

  @override
  String get routeBuilderOrigin => 'Départ';

  @override
  String get routeBuilderDestination => 'Destination';

  @override
  String get routeBuilderWaypoint => 'Arrêt';

  @override
  String get routeBuilderShapePoint => 'Tracé de l’itinéraire';

  @override
  String get routeBuilderMoveUp => 'Déplacer avant';

  @override
  String get routeBuilderMoveDown => 'Déplacer après';

  @override
  String get routeBuilderRemove => 'Supprimer l’arrêt';

  @override
  String get routeBuilderNoStops =>
      'Ajoutez le départ et la destination, puis les arrêts intermédiaires.';

  @override
  String get routeBuilderSavedGeometry => 'Tracé enregistré';

  @override
  String get routeBuilderEditingLoadError =>
      'Impossible de charger l’itinéraire complet. Revenez en arrière et réessayez.';

  @override
  String get routeBuilderDiscardTitle => 'Abandonner les modifications ?';

  @override
  String get routeBuilderDiscardMessage =>
      'Les modifications non enregistrées seront perdues.';

  @override
  String get routeBuilderDiscard => 'Abandonner';

  @override
  String get routeBuilderKeepEditing => 'Continuer à modifier';

  @override
  String get routeBuilderClose => 'Fermer';

  @override
  String get routeBuilderRetry => 'Réessayer';

  @override
  String get routeBuilderMapAttribution =>
      '© Contributeurs OpenStreetMap · Itinéraires : OSRM';

  @override
  String get routeBuilderRouteDetails => 'Détails de l’itinéraire';

  @override
  String get routeBuilderMinutes => 'min';

  @override
  String get routeBuilderDistanceUnit => 'km';

  @override
  String get routeBuilderChooseSource => 'Ajouter un arrêt depuis';

  @override
  String get routeBuilderLandmarksPermission =>
      'Les lieux enregistrés nécessitent l’autorisation Lieux.';

  @override
  String get routeBuilderShapeHint =>
      'Les points de tracé guident le trajet sans être des arrêts de livraison. L’optimisation les supprime.';

  @override
  String get routeBuilderGeofenceHint =>
      'Utilise le centre de la zone. Vérifiez qu’il est accessible par la route.';

  @override
  String selectField(Object field) {
    return 'Sélectionner $field';
  }

  @override
  String searchField(Object field) {
    return 'Rechercher $field';
  }

  @override
  String noMatchingField(Object field) {
    return 'Aucune correspondance pour $field';
  }

  @override
  String fieldRequired(Object field) {
    return '$field est obligatoire.';
  }

  @override
  String get clearSelection => 'Effacer';

  @override
  String get clearSearch => 'Effacer la recherche';

  @override
  String get noResults => 'Aucun résultat';

  @override
  String get select => 'Sélectionner';

  @override
  String get unableToLoad => 'Impossible de charger';

  @override
  String get mobileApiToken => 'Jeton API';

  @override
  String get mobileTokenOnce =>
      'Ce jeton n’est affiché qu’une fois. Conservez-le en sécurité ; son détenteur peut utiliser les autorisations API sélectionnées.';

  @override
  String get mobileSaveRecovery => 'Conservez vos codes de récupération';

  @override
  String get mobileRecoveryHelp =>
      'Chaque code est utilisable une fois en cas de perte de l’authentificateur. Ils remplacent les anciens codes. Conservez-les en lieu sûr.';

  @override
  String get mobileCopiedSecurely => 'Copié. Conservez-le en sécurité.';

  @override
  String get mobileSavedSecurely => 'Je l’ai conservé en sécurité';

  @override
  String get mobileDone => 'Terminé';

  @override
  String get mobileRevokeTokenQuestion => 'Révoquer le jeton API ?';

  @override
  String mobileTokenStops(Object name) {
    return '$name cessera de fonctionner immédiatement.';
  }

  @override
  String get mobileRevoke => 'Révoquer';

  @override
  String get mobileMfa => 'Authentification multifacteur';

  @override
  String get mobileMfaOn => 'MFA activée';

  @override
  String get mobileMfaOff => 'MFA désactivée';

  @override
  String get mobileMfaHelp =>
      'Protégez la connexion avec votre application d’authentification.';

  @override
  String get mobileSecuritySessions =>
      'Les modifications de sécurité ferment les autres sessions et invalident les jetons API existants.';

  @override
  String mobileAddedDate(Object date) {
    return 'Ajouté le $date';
  }

  @override
  String get mobileRemoveAuthenticator => 'Supprimer l’authentificateur';

  @override
  String get mobileAddAuthenticator => 'Ajouter un authentificateur';

  @override
  String get mobileSetupMfa => 'Configurer la MFA';

  @override
  String mobileRecoveryRemaining(Object count) {
    return '$count codes de récupération inutilisés';
  }

  @override
  String get mobileReplaceRecovery => 'Remplacer les codes de récupération';

  @override
  String get mobileTurnOffMfa => 'Désactiver la MFA';

  @override
  String get mobileApiAccess => 'Accès API';

  @override
  String get mobileApiHelp =>
      'Créez des identifiants d’intégration avec les autorisations de votre compte.';

  @override
  String get mobileReadWrite => 'Lecture et écriture';

  @override
  String get mobileReadOnly => 'Lecture seule';

  @override
  String get mobileExpires => 'Expire';

  @override
  String get mobileInactive => 'Inactif';

  @override
  String get mobileRevokeToken => 'Révoquer le jeton';

  @override
  String get mobileCreateToken => 'Créer un jeton API';

  @override
  String get mobileDeleteAccount => 'Supprimer le compte';

  @override
  String get mobileDeleteWorkspaceHelp =>
      'Supprimez votre compte et les accès à l’espace, y compris les sous-utilisateurs. Toutes les sessions seront fermées. Cette action est irréversible dans l’application.';

  @override
  String get mobileDeleteSelfHelp =>
      'Supprimez votre compte et fermez ses sessions. Cette action est irréversible dans l’application.';

  @override
  String get mobileDeleteMyAccount => 'Supprimer mon compte';

  @override
  String get mobilePasswordOnly =>
      'Les prochaines connexions nécessiteront uniquement votre mot de passe.';

  @override
  String get mobileRecoveryReplaced =>
      'Vos anciens codes de récupération ne fonctionneront plus.';

  @override
  String get mobileTokenName => 'Nom du jeton';

  @override
  String get mobileAuthenticatorName => 'Nom de l’authentificateur';

  @override
  String get mobileEnterName => 'Saisissez un nom.';

  @override
  String get mobileAccess => 'Accès';

  @override
  String get mobileExpiresAfter => 'Expire après';

  @override
  String mobileDays(Object count) {
    return '$count jours';
  }

  @override
  String get mobileCurrentPassword => 'Mot de passe actuel';

  @override
  String get mobileEnterPassword => 'Saisissez votre mot de passe.';

  @override
  String get mobileAuthenticatorOrRecovery =>
      'Code d’authentification ou de récupération';

  @override
  String get mobileEnterVerification => 'Saisissez votre code de vérification.';

  @override
  String get mobileDeleteConfirmation =>
      'Je comprends que mon compte et l’accès à l’espace seront supprimés.';

  @override
  String get mobileContinue => 'Continuer';

  @override
  String get mobileSixDigits => 'Saisissez les six chiffres.';

  @override
  String get mobileConnectAuthenticator => 'Connectez votre authentificateur';

  @override
  String get mobileScanQrHelp =>
      'Scannez le QR sur un autre appareil ou copiez la clé dans l’authentificateur. La configuration expire dans 10 minutes.';

  @override
  String get mobileCopySetup => 'Copier la clé de configuration';

  @override
  String get mobileNewAuthenticatorCode => 'Code du nouvel authentificateur';

  @override
  String get mobileVerifying => 'Vérification…';

  @override
  String get mobileConfirm => 'Confirmer';

  @override
  String get mobileVerifySignIn => 'Vérifiez votre connexion';

  @override
  String get mobileUnusedRecovery =>
      'Saisissez un code de récupération inutilisé.';

  @override
  String get mobileAuthenticatorInstructions =>
      'Saisissez le code à six chiffres de votre authentificateur.';

  @override
  String get mobileRecoveryCode => 'Code de récupération';

  @override
  String get mobileAuthenticatorCode => 'Code d’authentification';

  @override
  String get mobileCompleteRecovery =>
      'Saisissez un code de récupération complet.';

  @override
  String get mobileVerifyAndSignIn => 'Vérifier et se connecter';

  @override
  String get mobileUseAuthenticator => 'Utiliser le code d’authentification';

  @override
  String get mobileUseRecovery => 'Utiliser un code de récupération';

  @override
  String get mobileBackSignIn => 'Retour à la connexion';

  @override
  String get mobileName => 'Nom';

  @override
  String get mobileCallingCode => 'Indicatif téléphonique';

  @override
  String get mobileMobileNumber => 'Numéro de portable';

  @override
  String get mobileAddress => 'Adresse';

  @override
  String get mobileCountry => 'Pays';

  @override
  String get mobileState => 'État / Province';

  @override
  String get mobileCity => 'Ville';

  @override
  String get mobilePostcode => 'Code postal';

  @override
  String get mobileChangePassword => 'Changer le mot de passe';

  @override
  String get mobileRequired => 'Ce champ est obligatoire.';

  @override
  String get mobileValidEmail =>
      'Saisissez une adresse e-mail valide en caractères ASCII.';

  @override
  String get mobilePasswordSessions =>
      'Changer le mot de passe ferme toutes vos sessions.';

  @override
  String get mobileNewPassword => 'Nouveau mot de passe';

  @override
  String get mobilePasswordCharacters => 'Utilisez 6 à 72 caractères ASCII.';

  @override
  String get mobileDifferentPassword => 'Choisissez un mot de passe différent.';

  @override
  String get mobileConfirmPassword => 'Confirmer le nouveau mot de passe';

  @override
  String get mobilePasswordMismatch =>
      'Les mots de passe ne correspondent pas.';

  @override
  String get mobileChangesSaved => 'Modifications enregistrées';

  @override
  String get mobileLanguageCodeHelp =>
      'Saisissez un code de langue, comme en ou hi.';

  @override
  String get mobileReload => 'Recharger';

  @override
  String get mobileEnterYourName => 'Saisissez votre nom.';

  @override
  String get mobileEnterCallingCode => 'Saisissez un indicatif téléphonique.';

  @override
  String get mobileValidMobile => 'Saisissez un numéro de portable valide.';

  @override
  String get mobileSaveProfile => 'Enregistrer le profil';

  @override
  String get mobileDisplayPreferences => 'Préférences d’affichage';

  @override
  String get mobileDateFormat => 'Format de date';

  @override
  String get mobileTimeFormat => 'Format d’heure';

  @override
  String get mobileDistanceUnit => 'Unité de distance';

  @override
  String get mobileTextDirection => 'Sens du texte';

  @override
  String get mobileTimeOffset => 'Décalage horaire';

  @override
  String get mobileLanguageCode => 'Code de langue';

  @override
  String get mobileSavePreferences => 'Enregistrer les préférences';

  @override
  String get mobileProofAccountChanged =>
      'Les accès ont changé. Rouvrez le justificatif du trajet.';

  @override
  String get mobileActivity => 'Activité';

  @override
  String get mobileAllStatuses => 'Tous les états';

  @override
  String get mobileApproximateRoute =>
      'Séquence approximative • arrêts numérotés';

  @override
  String get mobileAttention => 'Attention';

  @override
  String get mobileChooseRoute => 'Choisissez un itinéraire';

  @override
  String get mobileValidSchedule => 'Choisissez un planning valide.';

  @override
  String get mobileValidStartTime => 'Choisissez une heure de début valide.';

  @override
  String get mobileChooseVehicle => 'Choisissez un véhicule';

  @override
  String get mobileChooseVehicleRoute =>
      'Choisissez un véhicule et un itinéraire.';

  @override
  String get mobileChooseEligibleVehicle => 'Choisissez un véhicule admissible';

  @override
  String get mobileEndDateAfterStart =>
      'Choisissez une fin égale ou postérieure au début.';

  @override
  String get mobileChooseWeekday =>
      'Choisissez au moins un jour de la semaine.';

  @override
  String get mobileChooseDate => 'Choisir une date';

  @override
  String get mobileChooseDateRange => 'Choisir une période';

  @override
  String get mobileChooseDay => 'Choisir un jour';

  @override
  String get mobileMultiDayHelp =>
      'Choisissez les dates et heures de départ et de fin pour un trajet de plusieurs jours.';

  @override
  String get mobileFutureDate =>
      'Choisissez aujourd’hui ou une date ultérieure.';

  @override
  String get mobileCompleted => 'Terminé';

  @override
  String get mobileCompletionAfterStart =>
      'La fin doit être postérieure au début.';

  @override
  String get mobileCreateRouteFirst =>
      'Créez un itinéraire pour commencer la planification.';

  @override
  String get mobileCreateSchedule => 'Créer un planning';

  @override
  String get mobileCreateTrip => 'Créer un trajet';

  @override
  String get mobileDeleteSchedule => 'Supprimer le planning';

  @override
  String get mobileDiscardChanges => 'Abandonner les modifications';

  @override
  String get mobileDiscardTrip => 'Abandonner les modifications du trajet ?';

  @override
  String get mobileEditRecurring => 'Modifier le planning récurrent';

  @override
  String get mobileEditSchedule => 'Modifier le planning';

  @override
  String get mobileEndDate => 'Date de fin';

  @override
  String get mobileEndSchedule => 'Terminer le planning';

  @override
  String get mobileEndTime => 'Heure de fin';

  @override
  String get mobileEndTimeAfterStart =>
      'L’heure de fin doit être postérieure au début.';

  @override
  String get mobileEndsOptional => 'Fin (facultative)';

  @override
  String get mobileTripTitleLength =>
      'Saisissez un titre de 2 à 120 caractères.';

  @override
  String get mobileAtLeastTwo => 'Saisissez au moins 2 caractères';

  @override
  String get mobileAtLeastThree => 'Saisissez au moins 3 caractères';

  @override
  String get mobileExpandRoute => 'Agrandir la carte du trajet';

  @override
  String get mobileFitRoute => 'Ajuster au trajet';

  @override
  String get mobileNoGpsPlanning =>
      'GPS non lié. Le trajet peut être planifié, mais le suivi en direct sera indisponible.';

  @override
  String get mobileKeepEditing => 'Continuer à modifier';

  @override
  String get mobileKeepSchedule => 'Conserver le planning';

  @override
  String get mobileLastKnownPosition => 'Dernière position connue du véhicule';

  @override
  String get mobileLatestStart => 'Heure limite de départ';

  @override
  String get mobileNextMonth => 'Mois suivant';

  @override
  String get mobileNoEligible => 'Aucun véhicule admissible n’est disponible.';

  @override
  String get mobileNoEligibleHelp =>
      'Aucun véhicule admissible. Affectez un conducteur actif à un véhicule actif avant de planifier.';

  @override
  String get mobileNoRecordsView => 'Aucun enregistrement pour cette vue.';

  @override
  String get mobileNoRouteGps =>
      'Aucun itinéraire ni coordonnées GPS pour ce trajet.';

  @override
  String get mobileStopsWithoutGeometry =>
      'Arrêts numérotés • tracé indisponible';

  @override
  String get mobilePause => 'Suspendre';

  @override
  String get mobilePlanTrip => 'Planifier un trajet';

  @override
  String get mobilePlannedNumbered => 'Trajet planifié • arrêts numérotés';

  @override
  String get mobilePreviousMonth => 'Mois précédent';

  @override
  String get mobileReasonRemark => 'Motif / remarque';

  @override
  String get mobileRecurring => 'Récurrent';

  @override
  String get mobileRecurringSchedule => 'Planning récurrent';

  @override
  String get mobileRecurringActions => 'Actions du planning récurrent';

  @override
  String get mobileRefreshPlanning => 'Actualiser les options de planification';

  @override
  String get mobileRefreshSchedule =>
      'Actualisez ce planning avant de le modifier.';

  @override
  String get mobileRemarkOptional => 'Remarque (facultative)';

  @override
  String get mobileRemoveEndDate => 'Supprimer la date de fin';

  @override
  String get mobileRepeatOn => 'Répéter les';

  @override
  String get mobileResume => 'Reprendre';

  @override
  String get mobileRoute => 'Itinéraire';

  @override
  String get mobileRunning => 'En cours';

  @override
  String get mobileSaveShareProof => 'Enregistrer ou partager le justificatif';

  @override
  String get mobileSaveSchedule => 'Enregistrer le planning';

  @override
  String get mobileSchedule => 'Planning';

  @override
  String get mobileScheduleSaved => 'Planning enregistré';

  @override
  String get mobileSearchRoutes => 'Rechercher des itinéraires';

  @override
  String get mobileSearchVehicleDriver =>
      'Rechercher véhicule, immatriculation ou conducteur';

  @override
  String get mobileSkipDates => 'Dates à exclure (facultatif)';

  @override
  String get mobileSkipDatesRange =>
      'Les dates exclues doivent être comprises dans la période du planning.';

  @override
  String get mobileStartTime => 'Heure de début';

  @override
  String get mobileStarts => 'Début';

  @override
  String get mobileStatus => 'État';

  @override
  String get mobileSubmittedProofs => 'Justificatifs envoyés';

  @override
  String get mobileAnyTimeDay =>
      'Le conducteur peut partir à tout moment le jour choisi.';

  @override
  String get mobileStartWindowHelp =>
      'Le conducteur peut partir dans cette plage horaire. Sa fin n’est pas l’heure de fin du trajet.';

  @override
  String get mobileRequestFailed =>
      'La demande n’a pas abouti. Actualisez et réessayez.';

  @override
  String get mobileRouteUnavailable =>
      'L’itinéraire enregistré est indisponible. Actualisez les itinéraires et réessayez.';

  @override
  String get mobileAccountTimeHelp =>
      'Le trajet commence à une heure précise dans le fuseau du compte.';

  @override
  String get mobilePdfPreviewFailed =>
      'Impossible de prévisualiser le PDF. Enregistrez-le ou partagez-le pour l’ouvrir ailleurs.';

  @override
  String get mobileImagePreviewFailed =>
      'Impossible de prévisualiser l’image. Enregistrez-la ou partagez-la pour l’ouvrir ailleurs.';

  @override
  String get mobileToday => 'Aujourd’hui';

  @override
  String get mobileTripCreated => 'Trajet créé';

  @override
  String get mobileTripDetails => 'Détails du trajet';

  @override
  String get mobileTripRoute => 'Itinéraire du trajet';

  @override
  String get mobileTripTitle => 'Titre du trajet';

  @override
  String get mobileProofShareFailed =>
      'Impossible de partager le justificatif. Réessayez.';

  @override
  String get mobileUnavailableVehicles => 'Véhicules indisponibles';

  @override
  String get mobileMaxSkipDates => 'Utilisez au maximum 100 dates exclues';

  @override
  String get mobileRemarkLength =>
      'Utilisez au maximum 600 caractères pour la remarque.';

  @override
  String get mobileValidDates =>
      'Utilisez des dates valides au format YYYY-MM-DD';

  @override
  String get mobileVehicleGpsPosition => 'Position GPS du véhicule';

  @override
  String get mobileVehicleDriver => 'Véhicule et conducteur';

  @override
  String get mobileVehicleRoute => 'Véhicule et itinéraire';

  @override
  String get mobileViewTrip => 'Voir le trajet';

  @override
  String get mobileDatesPerLine => 'YYYY-MM-DD, une date par ligne';

  @override
  String get mobileDiscardPlanningHelp =>
      'Les modifications non enregistrées seront perdues. Les itinéraires enregistrés resteront disponibles.';

  @override
  String mobileTimesTimezone(Object timezone) {
    return 'Les heures utilisent $timezone.';
  }

  @override
  String mobileStopsCount(Object count) {
    return '$count arrêts';
  }

  @override
  String mobileTripsCount(Object count) {
    return '$count trajets';
  }

  @override
  String mobileLoadMoreCount(Object loaded, Object total) {
    return 'Charger plus ($loaded sur $total)';
  }

  @override
  String mobileScheduledDate(Object date) {
    return 'Planifié : $date';
  }

  @override
  String mobileEndsDate(Object date) {
    return 'Fin : $date';
  }

  @override
  String mobileNextDate(Object date) {
    return 'Suivant : $date';
  }

  @override
  String mobileGpsStatus(Object status) {
    return 'GPS du véhicule : $status';
  }

  @override
  String mobileLastPosition(Object date) {
    return 'Dernière position : $date';
  }

  @override
  String mobileActualDistance(Object distance) {
    return 'Distance réelle : $distance km';
  }

  @override
  String mobileTripScore(Object value) {
    return 'Score du trajet : $value';
  }

  @override
  String mobileStopsProgress(Object completed, Object total) {
    return '$completed/$total arrêts';
  }

  @override
  String mobileScheduleAction(Object action) {
    return '$action le planning récurrent ?';
  }

  @override
  String get dateRangeSelect => 'Sélectionner une période';

  @override
  String get dateRangeChoose => 'Choisir une période';

  @override
  String get dateTimeRangeChoose => 'Choisir une période et des heures';

  @override
  String get dateRangeFrom => 'Du';

  @override
  String get dateRangeTo => 'Au';

  @override
  String get dateRangeSelected => 'Période sélectionnée';

  @override
  String get dateRangeStartTime => 'Heure de début';

  @override
  String get dateRangeEndTime => 'Heure de fin';

  @override
  String get dateRangeSelectStartTime => 'Sélectionner l’heure de début';

  @override
  String get dateRangeSelectEndTime => 'Sélectionner l’heure de fin';

  @override
  String get dateRangeInvalidTime =>
      'L’heure de fin doit être postérieure au début.';

  @override
  String get dateRangeCustom => 'Personnalisé';

  @override
  String get dateRangeLastHour => 'Dernière heure';

  @override
  String get dateRangeLast3Hours => '3 dernières heures';

  @override
  String get dateRangeLast6Hours => '6 dernières heures';

  @override
  String get dateRangeLast12Hours => '12 dernières heures';

  @override
  String get dateRangeLast24Hours => '24 dernières heures';

  @override
  String get dateRangeToday => 'Aujourd’hui';

  @override
  String get dateRangeYesterday => 'Hier';

  @override
  String get dateRangeThisWeek => 'Cette semaine';

  @override
  String get dateRangeLastWeek => 'Semaine dernière';

  @override
  String get dateRangeLast7Days => '7 derniers jours';

  @override
  String get dateRangeLast30Days => '30 derniers jours';

  @override
  String get apply => 'Appliquer';

  @override
  String get calendarToday => 'Aujourd’hui';

  @override
  String get calendarPreviousMonth => 'Mois précédent';

  @override
  String get calendarNextMonth => 'Mois suivant';

  @override
  String get calendarExpiry => 'Expiration';

  @override
  String get legacyUi869d62ddcd => ' pour activer le bouton.';

  @override
  String get legacyUi7f4f41c8c3 => '#RRGGBB';

  @override
  String get legacyUi9515360684 => '+ Ajouter un appareil';

  @override
  String get legacyUi6116c134de => '+ Créer un forfait';

  @override
  String get legacyUic10e9a1c41 => '+ Créer un utilisateur';

  @override
  String get legacyUi5e9a7040e4 => '2 chiffres';

  @override
  String get legacyUia0483eec37 => '3 chiffres';

  @override
  String get legacyUi3994dbd48e => '6 à 35 caractères';

  @override
  String get legacyUi250e268e83 => '7 à 15 chiffres';

  @override
  String get legacyUie69a9a5ee9 => 'Utilisation sur 7 jours';

  @override
  String get legacyUib8cee60c75 =>
      'Un sous-utilisateur ne peut utiliser que les fonctionnalités et les rapports disponibles pour votre compte. Les paramètres et la sécurité du compte restent accessibles.';

  @override
  String get legacyUif0ee13e963 => 'Accès restreint';

  @override
  String get legacyUi6e702cb4e0 => 'Statut du compte';

  @override
  String get legacyUi6d6eba9279 => 'Accès au compte';

  @override
  String get legacyUi82cf8a5fc7 => 'Paramètres du compte';

  @override
  String get legacyUi9beb96dac8 => 'Accuser réception';

  @override
  String get legacyUibf539b1d10 => 'Acme Logistics Pvt. Ltd.';

  @override
  String get legacyUic3cd636a58 => 'Actions';

  @override
  String get legacyUia733b809d2 => 'Actif';

  @override
  String get legacyUi15cf579b89 => 'Durée d’activité';

  @override
  String get legacyUifaa171bc07 => 'Véhicule actif';

  @override
  String get legacyUibde34d0278 => 'Statut actif';

  @override
  String get legacyUi14c5b09cd4 => 'Détail de l’activité';

  @override
  String get legacyUifbed23bc25 => 'Journaux d’activité';

  @override
  String get legacyUie35effbf63 => 'Période d’activité';

  @override
  String get legacyUicbd19b5c39 => 'Auteur';

  @override
  String get legacyUi7980ca2475 => 'Utilisateur à l’origine de l’action';

  @override
  String get legacyUi4ac5084db4 => 'Ajouter un appareil ou une SIM';

  @override
  String get legacyUiaa752d14b8 => 'Ajouter un conducteur';

  @override
  String get legacyUi224f2486e6 => 'Ajouter au stock';

  @override
  String get legacyUi1836b111cd => 'Ajouter une ligne de métadonnées';

  @override
  String get legacyUi31dd5bb29e => 'Ajouter une équipe';

  @override
  String get legacyUi47b2149c9c => 'Ajouter un forfait';

  @override
  String get legacyUic08d1e9d3f => 'Ajouter un capteur';

  @override
  String get legacyUi12071f1c87 =>
      'Ajoutez un forfait ou modifiez votre recherche.';

  @override
  String get legacyUic0c181937e => 'Ajouter un attribut';

  @override
  String get legacyUi5367d642e2 => 'Ajouter des crédits';

  @override
  String get legacyUi1fa55e4562 => 'Ajouter une ligne de métadonnées';

  @override
  String get legacyUi7be087b7a7 => 'Ajouter un justificatif';

  @override
  String get legacyUib68734c259 => 'Ajouté';

  @override
  String get legacyUi41b5f2e6ae => 'Remarques supplémentaires';

  @override
  String get legacyUid5e920a5cb => 'Ligne d’adresse';

  @override
  String get legacyUi7748043229 => 'Adresse et informations géographiques.';

  @override
  String get legacyUi4faa35048a =>
      'Demande de connexion administrateur terminée.';

  @override
  String get legacyUi1eda23758b => 'Administrateur';

  @override
  String get legacyUi3df513225f => 'Administrateur créé.';

  @override
  String get legacyUif981236722 => 'Véhicules concernés';

  @override
  String get legacyUib7fb586ff2 => 'Aéroport';

  @override
  String get legacyUi25f8c55de8 => 'Alarme';

  @override
  String get legacyUib5faca3a78 => 'Type d’alerte';

  @override
  String get legacyUic03d80790d => 'Tous les administrateurs';

  @override
  String get legacyUi0b313a76be => 'Tous les pays';

  @override
  String get legacyUiffeed47b5a => 'Tous les fournisseurs';

  @override
  String get legacyUi4745c5dce5 => 'Toute la période';

  @override
  String get legacyUieb672cb3ba => 'Tous les types';

  @override
  String get legacyUib4f25a1426 => 'Tous les utilisateurs';

  @override
  String get legacyUidd9eb32418 => 'Tous les véhicules';

  @override
  String get legacyUi060be00f4f => 'Toutes les catégories';

  @override
  String get legacyUi0aaede0bb1 =>
      'Toutes les notifications ont été marquées comme lues.';

  @override
  String get legacyUi30c8a0fc9c => 'Tous les types';

  @override
  String get legacyUice832d9b31 => 'Tous les utilisateurs';

  @override
  String get legacyUie512a2f10a => 'Autoriser l’historique';

  @override
  String get legacyUif8f993b052 =>
      'Autoriser l’accès à l’historique des trajets.';

  @override
  String get legacyUi1ffee134b1 =>
      'Autoriser les visiteurs à se connecter à un espace de démonstration.';

  @override
  String get legacyUie5d30dc481 => 'Plage autorisée : 10 à 300';

  @override
  String get legacyUi22786d42cc => 'Altitude';

  @override
  String get legacyUi43dc8532f7 => 'Montant';

  @override
  String get legacyUi76aa32f207 => 'Montant *';

  @override
  String get legacyUia01154a861 => 'Montant personnalisé';

  @override
  String get legacyUi7d66157b06 =>
      'Le montant doit être compris entre 0,01 et 9 999 999,99';

  @override
  String get legacyUib34440b2cd => 'Montant personnalisé';

  @override
  String get legacyUib757c50159 => 'Le montant accepte jusqu’à 2 décimales';

  @override
  String get legacyUic8c3ba95bb =>
      'Les statistiques apparaîtront lorsque des paiements seront disponibles.';

  @override
  String get legacyUif6c665f4fe =>
      'Les statistiques apparaîtront lorsque des transactions seront disponibles.';

  @override
  String get legacyUi6b2a78a8f7 => 'Appliquer les filtres';

  @override
  String get legacyUi2444928438 => 'Affecter';

  @override
  String get legacyUi561f6317fe => 'Affecter un conducteur';

  @override
  String get legacyUi3d2183f9ae => 'Affecter la sélection';

  @override
  String get legacyUi5e97289597 => 'Affecter un utilisateur';

  @override
  String get legacyUib8db201262 => 'Affecter un véhicule';

  @override
  String get legacyUi20b5675c39 => 'Affecter des véhicules';

  @override
  String get legacyUic403a13c66 =>
      'Affectez un ou plusieurs véhicules à ce sous-utilisateur.';

  @override
  String get legacyUie12261bf18 => 'Affectez des utilisateurs à ce conducteur.';

  @override
  String get legacyUi41c90cdeef => 'Affectez des utilisateurs à ce véhicule.';

  @override
  String get legacyUi32265d6dad =>
      'Affectez des véhicules pour configurer les notifications de base.';

  @override
  String get legacyUi117326ffd2 =>
      'Affectez des véhicules pour configurer les notifications de durée.';

  @override
  String get legacyUi74dfd6593f =>
      'Affectez des véhicules pour configurer les notifications de géozone.';

  @override
  String get legacyUi8c6586176a =>
      'Affectez des véhicules pour configurer les notifications de survitesse.';

  @override
  String get legacyUi086854873d =>
      'Affectez des véhicules pour configurer les notifications d’itinéraire.';

  @override
  String get legacyUie24e824b68 => 'Affecté';

  @override
  String get legacyUie94ba984c3 => 'Véhicules affectés';

  @override
  String get legacyUie55df441e8 => 'Affectation';

  @override
  String get legacyUi0c686b74d7 =>
      'Au moins 5 caractères. Les modifications sont consignées.';

  @override
  String get legacyUi1afff0157c => 'Joindre';

  @override
  String get legacyUi0c431f4969 => 'Joindre un fichier';

  @override
  String get legacyUi137135dbf6 => 'Joindre des fichiers';

  @override
  String get legacyUi2286866966 =>
      'L’URL de la pièce jointe n’est pas disponible.';

  @override
  String get legacyUib6b6277691 =>
      'Le chemin de la pièce jointe n’est pas disponible.';

  @override
  String get legacyUi1b30607d41 =>
      'Les clés des attributs doivent être uniques.';

  @override
  String get legacyUia6652617f2 => 'Attributs';

  @override
  String get legacyUi7c62a14244 => 'Disponible';

  @override
  String get legacyUicdc93143c6 => 'Moy.';

  @override
  String get legacyUib1ff8731de => 'Vitesse moyenne';

  @override
  String get legacyUi3e6e9b59e4 => 'Jetons du serveur';

  @override
  String get legacyUib15950ccc9 => 'Jetons du serveur';

  @override
  String get legacyUief5c48114b => 'Vérifié par le serveur';

  @override
  String get legacyUidd96994d01 => 'Sauvegarde';

  @override
  String get legacyUi775fe0e609 => 'Sauvegarde / Conservation des données';

  @override
  String get legacyUi17ef50d8f8 => 'Virement bancaire';

  @override
  String get legacyUi1007a1a728 =>
      'Référence bancaire / UTR / ID de transaction';

  @override
  String get legacyUi5be1ae92e8 =>
      'Note de virement / UTR / Référence de transaction';

  @override
  String get legacyUi6b57349e97 => 'Paramètres de l’URL de base';

  @override
  String get legacyUiaa2c96dacf => 'Général';

  @override
  String get legacyUic73c27be48 => 'Identifiants de connexion du conducteur.';

  @override
  String get legacyUi904d23cb6a => 'Identification du nouveau véhicule.';

  @override
  String get legacyUi99613c74ce => 'Bloqué';

  @override
  String get legacyUi584522b903 => 'Identité et coordonnées de l’entreprise';

  @override
  String get legacyUibfc8921ede => 'Couleur de la marque';

  @override
  String get legacyUi54a2cf5e63 => 'Navigateur';

  @override
  String get legacyUi73e0b16797 =>
      'Icône de l’onglet du navigateur. ICO, PNG ou SVG. 2 Mo maximum.';

  @override
  String get legacyUicfadbd7a57 => 'Par';

  @override
  String get legacyUi42878ce3fa => 'Utilisation du processeur';

  @override
  String get legacyUi37efa8a990 => 'Café';

  @override
  String get legacyUi26b937c51d => 'Annuler la demande de renouvellement ?';

  @override
  String get legacyUi84837a2168 => 'Annuler la demande';

  @override
  String get legacyUi2738a0a1db =>
      'Impossible de charger les commandes sans les détails du véhicule.';

  @override
  String get legacyUi4d4ce73b15 => 'Carte';

  @override
  String get legacyUi758ec54e43 => 'Espèces';

  @override
  String get legacyUi6ccb60071b => 'Catégories';

  @override
  String get legacyUi49289db43e => 'Modifier le mot de passe';

  @override
  String get legacyUi6fc0529f2d => 'Modifier le statut';

  @override
  String get legacyUica5df1dad1 => 'Choisir la période';

  @override
  String get legacyUid2174d8075 => 'Choisir la période de lecture';

  @override
  String get legacyUi66542fe55c =>
      'Choisissez un forfait, une date d’inscription et un motif de 5 à 500 caractères.';

  @override
  String get legacyUi7db804aa37 =>
      'Choisissez les véhicules, l’expiration et les options de partage.';

  @override
  String get legacyUi037c5eba86 => 'Ville (facultatif)';

  @override
  String get legacyUief153831d1 => 'La ville est obligatoire.';

  @override
  String get legacyUi8da6bb0466 => 'Nettoyage terminé';

  @override
  String get legacyUi381c4bf1d4 => 'Effacer les filtres';

  @override
  String get legacyUicdb64ef80e => 'Effacer la période';

  @override
  String get legacyUid3c69afc35 => 'Effacer les dates';

  @override
  String get legacyUi1bf7452cd6 => 'Effacer l’expiration';

  @override
  String get legacyUi40b66a41b8 => 'Effacer la date d’expiration';

  @override
  String get legacyUi92e60a4db3 => 'Effacer la lecture';

  @override
  String get legacyUi53dde4f2c0 =>
      'Les revenus clients apparaîtront après l’enregistrement des paiements.';

  @override
  String get legacyUide4e7f6fad => 'Fermer le menu latéral';

  @override
  String get legacyUi3dc631324c => 'Fermer la carte';

  @override
  String get legacyUid75dc68bbd => 'Regroupement';

  @override
  String get legacyUiadac69379a => 'Code';

  @override
  String get legacyUiea6ac41a6a => 'Le code est obligatoire.';

  @override
  String get legacyUi5b0f7590d0 => 'Encaissé';

  @override
  String get legacyUi8901895fb1 => 'Commande';

  @override
  String get legacyUif7e08456d0 => 'Détails de la commande';

  @override
  String get legacyUi6c4cb3de03 => 'Texte de la commande';

  @override
  String get legacyUibfed234d46 => 'Commande indisponible';

  @override
  String get legacyUi45e5f3f72e => 'Commandes';

  @override
  String get legacyUi7a1994999d => 'Entreprise';

  @override
  String get legacyUi8599f5cc48 => 'Nom de l’entreprise';

  @override
  String get legacyUi1e5f7dc45c => 'Nom de l’entreprise';

  @override
  String get legacyUib55887f633 => 'Entreprise mise à jour';

  @override
  String get legacyUi657063c67c => 'Entreprise mise à jour.';

  @override
  String get legacyUif1ab0a6f4e => 'Terminer manuellement';

  @override
  String get legacyUif14ebb39ce => 'Version de configuration';

  @override
  String get legacyUi755bea99c0 => 'Configuration mise à jour.';

  @override
  String get legacyUic69463a5a9 => 'Configurer l’envoi des e-mails.';

  @override
  String get legacyUic2d404cb7b => 'Confirmer le mot de passe';

  @override
  String get legacyUiea3723a45c => 'Confirmer l’élargissement de l’accès';

  @override
  String get legacyUi4a7c565d4c => 'Confirmer le mot de passe';

  @override
  String get legacyUi5febc18b54 => 'Confirmer le paiement';

  @override
  String get legacyUi05a7fffae1 => 'Confirmer le paiement reçu';

  @override
  String get legacyUi90d96c7cec => 'Phrase de confirmation';

  @override
  String get legacyUic2f9b7b489 => 'Connecté';

  @override
  String get legacyUib37456c453 => 'Contact';

  @override
  String get legacyUicc11b3a28f => 'Contexte';

  @override
  String get legacyUi3cf29aa7f5 => 'Ralenti continu';

  @override
  String get legacyUic352b92e1f => 'Marche continue';

  @override
  String get legacyUi347d3dbf17 => 'Arrêt continu';

  @override
  String get legacyUi49fdb038f4 =>
      'Contrôlez ce que les destinataires peuvent voir.';

  @override
  String get legacyUi02c6c04dec => 'Copier le KML';

  @override
  String get legacyUi44fe06869f => 'Copier l’en-tête';

  @override
  String get legacyUi3a9d77c901 => 'Impossible d’ouvrir l’URL';

  @override
  String get legacyUi0c09a7eccc => 'Impossible d’ouvrir la pièce jointe.';

  @override
  String get legacyUif2344997aa => 'Impossible d’ouvrir le document.';

  @override
  String get legacyUi2209ab63ce => 'Impossible d’ouvrir le fichier.';

  @override
  String get legacyUi5905ce4109 =>
      'Impossible d’ouvrir le fichier. Lien copié.';

  @override
  String get legacyUi9b09f53bdd => 'Impossible d’ouvrir le lien.';

  @override
  String get legacyUi72be0e8616 => 'Impossible de sélectionner le fichier';

  @override
  String get legacyUi76e835f8c3 => 'Impossible de sélectionner le fichier.';

  @override
  String get legacyUiaef46d6729 => 'Impossible de lire le fichier sélectionné';

  @override
  String get legacyUi280c98ccef => 'Filtre par pays';

  @override
  String get legacyUi1c9a9315c9 => 'Le pays est obligatoire.';

  @override
  String get legacyUid82b56cad9 => 'Cap';

  @override
  String get legacyUi6e157c5da4 => 'Créer';

  @override
  String get legacyUi318d1da4e0 => 'Créer un administrateur';

  @override
  String get legacyUi0a62dd4d37 => 'Créer un conducteur';

  @override
  String get legacyUie3429ab78d => 'Créer une géozone';

  @override
  String get legacyUidb7c457634 => 'Créer un point d’intérêt';

  @override
  String get legacyUicdd060d443 => 'Créer un forfait tarifaire';

  @override
  String get legacyUi5d16c5ffd7 => 'Créer un sous-utilisateur';

  @override
  String get legacyUiafe9a7ae15 => 'Créer un ticket';

  @override
  String get legacyUib25c91fe61 => 'Créer un utilisateur';

  @override
  String get legacyUi705b0946b2 => 'Créer un véhicule';

  @override
  String get legacyUi22a6b9d964 =>
      'Créez un tableau de bord dans l’application web pour l’afficher ici.';

  @override
  String get legacyUi769479a4d5 =>
      'Créez un lien public pour partager le suivi du véhicule en direct.';

  @override
  String get legacyUi50aab1f7b5 => 'Créez un capteur pour ce véhicule.';

  @override
  String get legacyUi0d2cd08b59 => 'Créer un administrateur';

  @override
  String get legacyUi6f876ff9c0 =>
      'Créez au moins un élément avant l’exportation.';

  @override
  String get legacyUic42adee4d7 =>
      'Créer un appareil sans quitter ce formulaire';

  @override
  String get legacyUiaba922c9b5 => 'Créer un conducteur';

  @override
  String get legacyUi6efd8652f4 =>
      'Créez des conducteurs, gérez leurs véhicules, documents et activités.';

  @override
  String get legacyUiba98384ac3 =>
      'Créez des géozones pour configurer les notifications associées.';

  @override
  String get legacyUif7b868f7d4 =>
      'Créez des points d’intérêt avec une catégorie, une icône, une couleur et un rayon de tolérance.';

  @override
  String get legacyUie42ed33e33 =>
      'Créer un forfait tarifaire sans quitter ce formulaire';

  @override
  String get legacyUie40f966076 =>
      'Créez des itinéraires manuellement ou à partir d’un départ et d’une destination, si cette fonction est disponible.';

  @override
  String get legacyUi567e040ce2 =>
      'Créez des itinéraires pour configurer les notifications d’écart.';

  @override
  String get legacyUica09bbf34d =>
      'Créez des sous-utilisateurs et contrôlez les véhicules auxquels ils ont accès.';

  @override
  String get legacyUi3afcbed7e6 => 'Créer un ticket';

  @override
  String get legacyUibdbcfa0af0 => 'Créer un utilisateur';

  @override
  String get legacyUie7358de58e =>
      'Créer un utilisateur sans quitter ce formulaire de véhicule';

  @override
  String get legacyUi505a950fbb => 'Créer un véhicule';

  @override
  String get legacyUi1ef0c932b3 =>
      'Créez votre premier conducteur pour commencer les affectations.';

  @override
  String get legacyUi7d3ca14313 =>
      'Créez votre première géozone pour définir vos limites opérationnelles.';

  @override
  String get legacyUi60a39e1fde =>
      'Créez votre premier lieu pour suivre vos points opérationnels.';

  @override
  String get legacyUi4fbf4f09cd =>
      'Créez votre premier sous-utilisateur pour partager certains accès.';

  @override
  String get legacyUiaccf40c89b => 'Créé';

  @override
  String get legacyUia5682ef199 => 'Créé : ';

  @override
  String get legacyUi5db1542e68 => 'Créé le';

  @override
  String get legacyUif1c69716be => 'Créé le';

  @override
  String get legacyUidd097a2297 => 'Identifiants';

  @override
  String get legacyUi9f58b9e39b =>
      'Identifiants que l’administrateur utilisera pour se connecter à OpenVTS.';

  @override
  String get legacyUiec535bab6f =>
      'Identifiants que l’utilisateur utilisera pour se connecter à OpenVTS.';

  @override
  String get legacyUi8a45d339a6 => 'Crédit';

  @override
  String get legacyUic3dc6e3ef9 =>
      'Les mises à jour de crédits, de paiements ou de facturation apparaîtront ici.';

  @override
  String get legacyUibfac50d642 => 'Crédits';

  @override
  String get legacyUie070de2244 => 'Devise';

  @override
  String get legacyUiea4b114ac6 => 'État actuel';

  @override
  String get legacyUieeed986410 => 'Crédits actuels';

  @override
  String get legacyUibe1ac4e322 => 'Étape actuelle';

  @override
  String get legacyUi9c378938cd => 'Commande personnalisée';

  @override
  String get legacyUi28be3fd018 => 'Domaine personnalisé';

  @override
  String get legacyUif130609dfc => 'Période personnalisée';

  @override
  String get legacyUia9d9e61bf2 =>
      'Catégorie personnalisée (ex. : « fournisseur »)';

  @override
  String get legacyUi0354c8896b => 'Domaine personnalisé';

  @override
  String get legacyUi3a55eba66f => 'Domaine personnalisé et couleur de marque.';

  @override
  String get legacyUi9f1d0368da => 'Expiration client';

  @override
  String get legacyUi1588fe44aa => 'Date d’expiration client';

  @override
  String get legacyUib13a49701d => 'Demandes de renouvellement client';

  @override
  String get legacyUi0c919bd08d => 'Expiration du service client';

  @override
  String get legacyUidce04fd315 => 'Personnaliser…';

  @override
  String get legacyUi118de3988f => 'Date limite';

  @override
  String get legacyUi5c487cb2d8 =>
      'Les revenus quotidiens ne sont pas disponibles pour cette période.';

  @override
  String get legacyUi99c0019cc6 => 'Logo sombre';

  @override
  String get legacyUia167278399 => 'Logo sombre mis à jour';

  @override
  String get legacyUi2b197ef6be =>
      'Les journaux de base de données et de télémétrie en direct apparaîtront ici.';

  @override
  String get legacyUi6bb4b674b3 => 'Période';

  @override
  String get legacyUie3d06ca6a1 => 'Période avec heures';

  @override
  String get legacyUic65ea4ae01 => 'Période';

  @override
  String get legacyUi853aab7f56 => 'Date/heure';

  @override
  String get legacyUi842b7b5d71 => 'Dates';

  @override
  String get legacyUi987b9ced08 => 'Jour';

  @override
  String get legacyUi82c29dd5fa => 'Comparaison jour / nuit';

  @override
  String get legacyUibfb1ba6e3e => 'Période jour / nuit';

  @override
  String get legacyUicf558941e0 => 'Débit';

  @override
  String get legacyUibb3cec5175 => 'Déduire des crédits';

  @override
  String get legacyUi6bccca646f => 'Déduit';

  @override
  String get legacyUi1dcab135ef => 'Dédupliquer';

  @override
  String get legacyUi15462a4954 => 'Supprimer les événements en double';

  @override
  String get legacyUi6184deb041 => 'Forfait par défaut';

  @override
  String get legacyUiee1b9a9f23 => 'Supprimer le compte';

  @override
  String get legacyUie81c14c990 => 'Supprimer le conducteur';

  @override
  String get legacyUi749f8e14e3 => 'Supprimer le sous-utilisateur';

  @override
  String get legacyUi0a0a90f6c5 => 'Supprimer l’utilisateur';

  @override
  String get legacyUi4bcd1233a1 => 'Supprimer l’administrateur';

  @override
  String get legacyUi6fd38c1fb9 => 'Supprimer l’administrateur';

  @override
  String get legacyUie8df0b7902 => 'Supprimer le document';

  @override
  String get legacyUi4ecae3e148 => 'Supprimer le document ?';

  @override
  String get legacyUid1571af327 => 'Supprimer le compte conducteur';

  @override
  String get legacyUia34ada32da => 'Supprimer le capteur';

  @override
  String get legacyUi1ce5593800 => 'Supprimer ce document ?';

  @override
  String get legacyUi6a58093cab => 'Supprimer le lien de suivi';

  @override
  String get legacyUi9afe6c7b95 => 'Supprimer l’utilisateur';

  @override
  String get legacyUif7ff7065a9 => 'Supprimer le véhicule';

  @override
  String get legacyUi441bda6cd8 => 'Supprimé';

  @override
  String get legacyUif7c094a571 => 'Lignes supprimées';

  @override
  String get legacyUic6bdaac949 => 'Delhi';

  @override
  String get legacyUibc4f986ecb => 'Envois';

  @override
  String get legacyUi921a6f6b55 => 'Journaux d’envoi';

  @override
  String get legacyUib2c4e6cb46 => 'Connexion de démonstration';

  @override
  String get legacyUi4675a25777 => 'Connexion de démonstration';

  @override
  String get legacyUi59013d16af => 'Décrivez la demande ou le problème';

  @override
  String get legacyUi55f8ebc805 => 'Description';

  @override
  String get legacyUi388de6fa3a => 'Description (facultatif)';

  @override
  String get legacyUi763630a9ce => 'La description est obligatoire.';

  @override
  String get legacyUi8a96cce5e5 =>
      'La description doit contenir au moins une lettre ou un chiffre.';

  @override
  String get legacyUidc3decbb93 => 'Détails';

  @override
  String get legacyUia5a74a6df0 => 'Appareil';

  @override
  String get legacyUid69ba8a9eb => 'Appareil + SIM';

  @override
  String get legacyUic587837fda => 'IMEI de l’appareil';

  @override
  String get legacyUif59a7a21bb => 'Installations d’appareils';

  @override
  String get legacyUi219288726d => 'Appareil seul';

  @override
  String get legacyUi554dd558bd => 'Résumé de l’appareil';

  @override
  String get legacyUi20d5df8b4a => 'Type d’appareil';

  @override
  String get legacyUi30de920ef1 => 'Appareil créé et sélectionné';

  @override
  String get legacyUi3c47b57c83 => 'Réponse de l’appareil';

  @override
  String get legacyUi6d2870160a => 'Heure de l’appareil';

  @override
  String get legacyUi21fe5a18d0 => 'Appareil mis à jour.';

  @override
  String get legacyUidf485c8713 => 'Appareils';

  @override
  String get legacyUibb73469225 => 'Désactiver sans supprimer le lien.';

  @override
  String get legacyUid3e4b30e10 => 'Abandonner et actualiser';

  @override
  String get legacyUi427dc4f0cd =>
      'Abandonner la création de l’administrateur ?';

  @override
  String get legacyUid1b8679c63 => 'Abandonner la création de l’utilisateur ?';

  @override
  String get legacyUi6012a2d760 => 'Abandonner la création du véhicule ?';

  @override
  String get legacyUifb0a3e6787 => 'Utilisation du disque';

  @override
  String get legacyUi70afe9eff3 => 'Fermer';

  @override
  String get legacyUi515aa7ad86 => 'Afficher les géozones affectées.';

  @override
  String get legacyUi37bbdde1a6 =>
      'Afficher les limites des géozones sur la carte';

  @override
  String get legacyUi2eebf5225a =>
      'Afficher les itinéraires enregistrés sur la carte';

  @override
  String get legacyUifb71a3779e => 'Multiplicateur de distance';

  @override
  String get legacyUib3262ecb53 => 'Variation de distance';

  @override
  String get legacyUiac3f0eb0ea => 'Distance/heures';

  @override
  String get legacyUi2c21f68832 => 'Type de document';

  @override
  String get legacyUi7615530d7a => 'L’URL du document n’est pas disponible.';

  @override
  String get legacyUi6dad05c10e => 'Actions du document';

  @override
  String get legacyUibd9a0f027e => 'Document supprimé.';

  @override
  String get legacyUi3859bdaa8c => 'Titre du document';

  @override
  String get legacyUi300b6ef0cd => 'Type de document';

  @override
  String get legacyUi9b10914d8b => 'Domaine';

  @override
  String get legacyUifb349182fc => 'Domaine et couleur';

  @override
  String get legacyUi8b58eea04e => 'Domaine et couleur de marque enregistrés';

  @override
  String get legacyUi0ec2ae5cda =>
      'Domaine, logos, favicon et couleur de marque.';

  @override
  String get legacyUibfa50c7a38 => 'Dessiner';

  @override
  String get legacyUi2e617aeb36 =>
      'Dessinez des cercles, polygones, rectangles et limites linéaires sur la carte.';

  @override
  String get legacyUid952b9d3da =>
      'Dessinez votre premier couloir d’itinéraire pour commencer le suivi.';

  @override
  String get legacyUi0ecf1d5bc0 => 'Parcouru';

  @override
  String get legacyUi845a6bd3ab => 'Profil du conducteur';

  @override
  String get legacyUi450d68e4fe => 'Actions du conducteur';

  @override
  String get legacyUid1ba6aea38 => 'Conducteur affecté.';

  @override
  String get legacyUifbaa386fbc =>
      'Les affectations et l’activité du profil du conducteur apparaîtront ici.';

  @override
  String get legacyUi017bb97653 => 'Conducteur créé.';

  @override
  String get legacyUif8acdd5348 =>
      'Les créations et mises à jour de conducteurs apparaîtront ici.';

  @override
  String get legacyUib057fefdc2 => 'Conducteur supprimé.';

  @override
  String get legacyUi63a7342acd => 'Nom du conducteur';

  @override
  String get legacyUi8d30cc59a1 => 'Affectation du conducteur supprimée.';

  @override
  String get legacyUia010b0a25f => 'Conducteur mis à jour.';

  @override
  String get legacyUifdd68e9960 => 'Espace conducteur';

  @override
  String get legacyUi3d14659ca9 => 'Simulation';

  @override
  String get legacyUi87bd16c150 => 'Simulation terminée';

  @override
  String get legacyUi91310be76f => 'Dubaï';

  @override
  String get legacyUi1370004da7 => 'Durée';

  @override
  String get legacyUia051787af6 =>
      'Chaque pièce jointe doit faire 5 Mo maximum.';

  @override
  String get legacyUi9bb58b2d1b => 'Est';

  @override
  String get legacyUi7de491bedc => 'Modifier l’entreprise';

  @override
  String get legacyUi5b7faa9d61 => 'Modifier l’appareil';

  @override
  String get legacyUicf5ddc10b3 => 'Modifier le conducteur';

  @override
  String get legacyUi13a7a7c3a7 => 'Modifier le forfait';

  @override
  String get legacyUicd280a41f7 => 'Modifier le profil';

  @override
  String get legacyUi19d57bd021 => 'Modifier la SIM';

  @override
  String get legacyUi4a0fe224b9 => 'Modifier le capteur';

  @override
  String get legacyUic8e262db5b => 'Modifier le sous-utilisateur';

  @override
  String get legacyUi38a1cb0f89 => 'Modifier le membre de l’équipe';

  @override
  String get legacyUi0e457253ad => 'Modifier l’utilisateur';

  @override
  String get legacyUib213eb6d7b => 'Modifier le véhicule';

  @override
  String get legacyUid03750ccbf => 'Modifier l’entreprise';

  @override
  String get legacyUi15141eab3a => 'Modifier le profil';

  @override
  String get legacyUi84add5b295 => 'E-mail';

  @override
  String get legacyUi5c10b588a9 => 'E-mail (facultatif)';

  @override
  String get legacyUi094f6a5934 => 'E-mail ou nom d’utilisateur';

  @override
  String get legacyUi79d1feaf62 => 'Statut de l’e-mail';

  @override
  String get legacyUia674e88b73 => 'Vérification de l’e-mail';

  @override
  String get legacyUic1feb155ec => 'Activer la connexion de démonstration';

  @override
  String get legacyUi7cf7a0d02a => 'Activer l’inscription publique';

  @override
  String get legacyUif6321257f1 => 'Activer ce lien public.';

  @override
  String get legacyUid093b28018 => 'Activer/Actualiser';

  @override
  String get legacyUi0af149c2ed => 'Chiffrement';

  @override
  String get legacyUic1f65ddb75 => 'Moteur';

  @override
  String get legacyUi49dda3d71a => 'Heures moteur';

  @override
  String get legacyUi4c9c7856d1 => 'Saisir le code à 6 chiffres';

  @override
  String get legacyUibc96ad8350 =>
      'Saisissez un montant avec au maximum 2 décimales';

  @override
  String get legacyUib0e59c93d7 => 'Saisissez un montant valide.';

  @override
  String get legacyUi6d59e6aee7 =>
      'Saisissez un motif de personnalisation de 5 à 500 caractères';

  @override
  String get legacyUi571c7347b7 =>
      'Saisissez un motif de personnalisation de 5 à 500 caractères.';

  @override
  String get legacyUi18b809c9fb => 'Saisir le texte de la commande';

  @override
  String get legacyUid5cd51c7b9 => 'Saisir le montant des crédits';

  @override
  String get legacyUibe7572b6c5 => 'Saisir l’État ou le territoire';

  @override
  String get legacyUid148321ad7 => 'Saisir le code à 6 chiffres';

  @override
  String get legacyUi0d639c50f1 =>
      'Saisissez le code à 6 chiffres qui vous a été envoyé';

  @override
  String get legacyUi6d1e849865 =>
      'Saisissez le code à usage unique envoyé à votre contact enregistré.';

  @override
  String get legacyUied634c4edc =>
      'Saisissez l’adresse e-mail ou le nom d’utilisateur utilisé pour vous connecter. Si le compte existe, nous vous enverrons un lien de réinitialisation à durée limitée.';

  @override
  String get legacyUi1378167d52 => 'Saisissez votre mot de passe';

  @override
  String get legacyUib6334ab817 =>
      'Saisissez votre nom d’utilisateur ou e-mail';

  @override
  String get legacyUic7fb317725 => 'Entité';

  @override
  String get legacyUi04d694e298 => 'ID de l’entité';

  @override
  String get legacyUi948542c1d6 => 'Erreur/Critique';

  @override
  String get legacyUic250d77524 => 'Détails de l’événement';

  @override
  String get legacyUi894b1c749d => 'ID de l’événement';

  @override
  String get legacyUif8e451a5d0 => 'Événements indisponibles';

  @override
  String get legacyUief09596668 => 'Quitter la démonstration';

  @override
  String get legacyUia689a999a5 => 'Expiré';

  @override
  String get legacyUib98d67213b => 'Expire bientôt';

  @override
  String get legacyUi57fe01159c => 'Date d’expiration (facultatif)';

  @override
  String get legacyUi1275b51587 => 'Date/heure d’expiration';

  @override
  String get legacyUi6b440cd506 => 'Date d’expiration';

  @override
  String get legacyUic9f6710324 => 'L’expiration doit être dans le futur.';

  @override
  String get legacyUif3e4fadb9e => 'Exporter';

  @override
  String get legacyUi416a52a386 => 'Exporter en KML';

  @override
  String get legacyUi09b28aeb8d => 'Jeton FCM';

  @override
  String get legacyUic2bf1a9df5 => '10 derniers caractères du jeton FCM';

  @override
  String get legacyUi82da67b211 => 'Facebook';

  @override
  String get legacyUi09fef5d8d9 => 'Échec';

  @override
  String get legacyUid68666787d => 'Tables en échec';

  @override
  String get legacyUi706b9a59b6 => 'Impossible de charger les villes';

  @override
  String get legacyUi6eb9516fdf => 'Impossible de charger les pays';

  @override
  String get legacyUi4bc4b2e555 => 'Impossible de charger les détails';

  @override
  String get legacyUia7bc426a05 =>
      'Impossible de charger tous les détails du véhicule.';

  @override
  String get legacyUia17267ffa7 => 'Impossible de charger les États';

  @override
  String get legacyUi6bb1f1d9fb => 'Impossible de mettre à jour le statut.';

  @override
  String get legacyUi1656649117 => 'Échec';

  @override
  String get legacyUib7ef43c84d => 'Code d’échec';

  @override
  String get legacyUi41510b1b21 => 'Message d’échec';

  @override
  String get legacyUi8db6a2f1d3 => 'Rapide';

  @override
  String get legacyUiadc7ac2ae5 => 'Plus rapide';

  @override
  String get legacyUib0f47aaf77 => 'Favicon';

  @override
  String get legacyUi7d9baea15f => 'Favicon mis à jour';

  @override
  String get legacyUi2c3cafa4db => 'Fichier';

  @override
  String get legacyUi55fee60744 => 'L’URL du fichier n’est pas disponible.';

  @override
  String get legacyUif76f22f075 => 'Le fichier dépasse la limite de 10 Mo.';

  @override
  String get legacyUi7e184124be => 'Le fichier est obligatoire.';

  @override
  String get legacyUi36f2202687 => 'Le fichier doit faire 10 Mo maximum.';

  @override
  String get legacyUi937fd74b36 => 'Filtrer les cartes SIM';

  @override
  String get legacyUi15db08d15e => 'Filtrer les journaux d’activité';

  @override
  String get legacyUi582198fab2 => 'Filtrer les administrateurs';

  @override
  String get legacyUi9911a4c0ed => 'Filtrer les appareils';

  @override
  String get legacyUi6a7fe2dc2c => 'Filtrer les conducteurs';

  @override
  String get legacyUi5439ccf95d => 'Filtrer les géozones';

  @override
  String get legacyUif1fe9835a2 => 'Filtrer l’équipe';

  @override
  String get legacyUi8cfc14a859 => 'Filtrer les utilisateurs';

  @override
  String get legacyUia9d1432d0d => 'Filtrer les véhicules';

  @override
  String get legacyUiaa234fb61d => 'Firebase';

  @override
  String get legacyUib15839eae8 => 'Firebase initialisé';

  @override
  String get legacyUi916a78d701 => 'Premier';

  @override
  String get legacyUic617ebad3b =>
      'Corrigez les erreurs de validation avant le test';

  @override
  String get legacyUi4d4e9621c4 => 'État de la flotte';

  @override
  String get legacyUi1cc8d18151 => 'Mot de passe oublié ?';

  @override
  String get legacyUibaa0e2872d => 'Crédits d’inscription offerts';

  @override
  String get legacyUi236ddee138 => 'De l’administrateur';

  @override
  String get legacyUi19fe826cc8 => 'E-mail de l’expéditeur';

  @override
  String get legacyUi64346b483c => 'Nom complet';

  @override
  String get legacyUi9f8ce19bf4 => 'Adresse complète';

  @override
  String get legacyUieeb692087d => 'Nom complet';

  @override
  String get legacyUifcee5b52cc => 'Décalage GMT';

  @override
  String get legacyUi590df4df1f =>
      'Le décalage GMT doit respecter le format +05:30.';

  @override
  String get legacyUi0933ed5657 => 'Modèle GPS';

  @override
  String get legacyUicbb0014411 => 'Station-service';

  @override
  String get legacyUifc45f9b7a9 => 'Générer';

  @override
  String get legacyUi549f31c53e => 'Générer l’itinéraire';

  @override
  String get legacyUidfde035f40 => 'Géocodage';

  @override
  String get legacyUi5cdf1dbd7e => 'Géozones';

  @override
  String get legacyUic09b487feb => 'Charger la lecture';

  @override
  String get legacyUi5442e2b64f => 'GitHub';

  @override
  String get legacyUi1efbf15894 =>
      'Regrouper les véhicules proches lorsque le zoom est faible';

  @override
  String get legacyUiac69db7d02 => 'Graphique de croissance';

  @override
  String get legacyUibc4359231d => 'Salle de sport';

  @override
  String get legacyUifa8a6b01e3 => 'En-tête copié';

  @override
  String get legacyUi071c1366b0 =>
      'Une précision supérieure nécessite davantage de recherches.';

  @override
  String get legacyUi90ccd64974 => 'Historique';

  @override
  String get legacyUic3669ffe53 =>
      'L’historique nécessite un véhicule avec un IMEI issu de la télémétrie en direct.';

  @override
  String get legacyUi8d4a22ea2b =>
      'Les valeurs de l’historique ne sont pas numériques.';

  @override
  String get legacyUidbb927867e => 'Hôpital';

  @override
  String get legacyUi3960ec4ca5 => 'Hôte';

  @override
  String get legacyUiadd03be31a => 'Hôte, port et chiffrement.';

  @override
  String get legacyUi9c4ba7d047 => 'Hôtel';

  @override
  String get legacyUi1e3beed01c =>
      'Durée de conservation de l’historique avant nettoyage.';

  @override
  String get legacyUi2635a51635 =>
      'Identité de l’administrateur sur la plateforme.';

  @override
  String get legacyUi0f053057ee =>
      'Identité de l’utilisateur sur la plateforme.';

  @override
  String get legacyUi077f5f9dad => 'J’ai déjà un lien de réinitialisation';

  @override
  String get legacyUibff7cfa991 => 'ICCID (facultatif)';

  @override
  String get legacyUidc7458a51a =>
      'L’IMEI est nécessaire pour charger les journaux de télémétrie.';

  @override
  String get legacyUif4c88fb92e =>
      'L’IMEI est nécessaire pour charger les événements du véhicule.';

  @override
  String get legacyUi7e77081c51 =>
      'L’IMEI est nécessaire pour envoyer des commandes.';

  @override
  String get legacyUif44426c787 =>
      'L’IMEI n’est pas disponible pour ce véhicule. Seul le résumé de la carte en direct est affiché.';

  @override
  String get legacyUi8a4b9cf4a9 => 'IMEI manquant';

  @override
  String get legacyUi11da2cb7f0 => 'IMSI (facultatif)';

  @override
  String get legacyUi716f63b96e => 'Icône';

  @override
  String get legacyUi7e5a975b6a => 'Identité';

  @override
  String get legacyUi2d40c36445 => 'Contact';

  @override
  String get legacyUif2d738d99c => 'Source du contact';

  @override
  String get legacyUi4157fc56ab => 'Image trop volumineuse. 2 Mo maximum.';

  @override
  String get legacyUifcf7141427 => 'Image trop volumineuse. 5 Mo maximum.';

  @override
  String get legacyUieeec98db23 => 'Importer un CSV';

  @override
  String get legacyUieebd26ef51 => 'Inactif - 48 h';

  @override
  String get legacyUi4b631f6984 => 'Informations';

  @override
  String get legacyUi29981bf033 =>
      'Solde initial de crédits affecté à ce compte administrateur.';

  @override
  String get legacyUi58984ab1ac => 'Crédits initiaux';

  @override
  String get legacyUi5721bbef40 => 'Instagram';

  @override
  String get legacyUi9b5ca633e8 => 'Crédits du compte insuffisants';

  @override
  String get legacyUi2ab95a4afe => 'Identifiant d’administrateur invalide.';

  @override
  String get legacyUicfa3e9c7e1 => 'Article ajouté au stock.';

  @override
  String get legacyUi32091e3797 => 'Statut du stock';

  @override
  String get legacyUia430dcf58c => 'Jane Smith';

  @override
  String get legacyUi049874e4f7 => 'KML copié dans le presse-papiers';

  @override
  String get legacyUi62fc561458 => 'Conserver la demande';

  @override
  String get legacyUic67dd20ee8 => 'Clé';

  @override
  String get legacyUi52c4afe84f => 'Atelier des repères';

  @override
  String get legacyUid1c69a859a => 'Dernier';

  @override
  String get legacyUi43df3046ba => 'Dernière modification';

  @override
  String get legacyUi7a78ad49d8 => 'Revenus du mois dernier';

  @override
  String get legacyUicec3d948d9 => 'Dernier paiement';

  @override
  String get legacyUiada1b72559 => 'Dernière vérification';

  @override
  String get legacyUi43dab84ff6 => 'Dernière connexion';

  @override
  String get legacyUib916a123cc => 'Revenus du mois dernier';

  @override
  String get legacyUi76c1ed9309 => 'Semaine dernière';

  @override
  String get legacyUieb3a622ae8 => 'Lat. / Long.';

  @override
  String get legacyUi1e5421b5bc => 'Lat./Long.';

  @override
  String get legacyUidecd7ca800 => 'Le plus récent';

  @override
  String get legacyUiefaed3a1b0 =>
      'Laissez vide pour conserver le mot de passe actuel';

  @override
  String get legacyUib8100f5ba8 => 'Bibliothèque';

  @override
  String get legacyUi3229609e15 => 'Licence';

  @override
  String get legacyUi99929a05d8 => 'Licence bloquée';

  @override
  String get legacyUi7452738cf9 => 'Licence émise';

  @override
  String get legacyUibbe96bcfaa => 'Licence utilisée';

  @override
  String get legacyUib957e7bd7b => 'Licence bloquée';

  @override
  String get legacyUiee92c8a4b6 => 'Licences';

  @override
  String get legacyUi6731d7cd1a => 'Logo clair';

  @override
  String get legacyUi6a1c6c8807 => 'Logo clair mis à jour';

  @override
  String get legacyUi24d948e4bd => 'Limite';

  @override
  String get legacyUied1ed2b68d => 'Lien copié.';

  @override
  String get legacyUi36d1b59b88 =>
      'Associez le véhicule à un utilisateur principal, un appareil GPS et un forfait tarifaire.';

  @override
  String get legacyUi6b6390a441 => 'LinkedIn';

  @override
  String get legacyUi4ac08d16b8 => 'Charger les messages précédents';

  @override
  String get legacyUidfe60ca92e => 'Charger plus';

  @override
  String get legacyUifc53db81a0 => 'Charger davantage depuis le serveur';

  @override
  String get legacyUi949d7ee41c => 'Charger les éléments précédents';

  @override
  String get legacyUi6db90a0ab6 => 'Chargé';

  @override
  String get legacyUi326ad2f9f8 => 'Chargement des véhicules affectés';

  @override
  String get legacyUi8936529136 => 'Chargement des véhicules disponibles';

  @override
  String get legacyUi9f1e0ce448 => 'Chargement des documents';

  @override
  String get legacyUide261e9b89 => 'Chargement des journaux';

  @override
  String get legacyUi324989adf0 => 'Chargement des capteurs';

  @override
  String get legacyUid219c68101 => 'Position';

  @override
  String get legacyUi2350df02c2 => 'Détails du journal';

  @override
  String get legacyUiaacbd6aa68 => 'ID du journal';

  @override
  String get legacyUia3d749050e => 'Se connecter en tant qu’utilisateur';

  @override
  String get legacyUi31a519ee99 =>
      'Les connexions et modifications de mot de passe ou de statut du compte apparaîtront ici.';

  @override
  String get legacyUi16b583cf21 => 'Journaux indisponibles';

  @override
  String get legacyUi4c57f0c88d => 'Londres';

  @override
  String get legacyUi3bf98fa618 => 'Marquer comme lu';

  @override
  String get legacyUia95e85aed5 => 'Max.';

  @override
  String get legacyUi35f72dc38d => 'Vitesse maximale';

  @override
  String get legacyUi03a68b7d8b => 'Utilisation de la mémoire';

  @override
  String get legacyUi68f4145fee => 'Message';

  @override
  String get legacyUi54a144c1dd => 'Envoi du message';

  @override
  String get legacyUi23b9e4546e =>
      'Écrivez ici à votre gestionnaire de flotte.';

  @override
  String get legacyUi8d546a6dea => 'Métadonnées';

  @override
  String get legacyUi251edc0eb5 => 'Métadonnées';

  @override
  String get legacyUic0b8960edf => 'Métadonnées copiées';

  @override
  String get legacyUi7eb0cee888 => 'Min.';

  @override
  String get legacyUib6bcd4535a => '3 caractères minimum…';

  @override
  String get legacyUi925c181c00 => '6 caractères minimum';

  @override
  String get legacyUi092f99ea11 => 'Minutes';

  @override
  String get legacyUib1d7024593 => 'Mobile';

  @override
  String get legacyUia0d9c28a1e => 'Mobile (facultatif)';

  @override
  String get legacyUi5968acfb01 => 'Numéro de mobile';

  @override
  String get legacyUic242b24d94 => 'Indicatif mobile';

  @override
  String get legacyUi802cdad736 => 'Notifications mobiles';

  @override
  String get legacyUi00618b3856 =>
      'Mobile et e-mail utilisés pour les communications.';

  @override
  String get legacyUi5d96299833 => 'Numéro de mobile (facultatif)';

  @override
  String get legacyUi2ab961738f => 'Indicatif mobile';

  @override
  String get legacyUi90ee975346 => 'Indicatif mobile (facultatif)';

  @override
  String get legacyUiaa6630b79b =>
      'Nouvelle tentative d’inscription aux notifications mobiles effectuée.';

  @override
  String get legacyUia1e34f9157 => 'Autres actions';

  @override
  String get legacyUi86c0a35ec8 => 'Autres options';

  @override
  String get legacyUi69d9f3e5ae => 'Musée';

  @override
  String get legacyUi4ff2aa7688 => 'Mes tickets';

  @override
  String get legacyUi2e65b706ae => 'Le nom et le code sont obligatoires.';

  @override
  String get legacyUi1eee3afea2 => 'Naviguer';

  @override
  String get legacyUiccfb5f0286 => 'Nouveau point d’intérêt';

  @override
  String get legacyUi4894cb39ee => 'Nouveau mot de passe';

  @override
  String get legacyUidcaa5db473 => 'Nouveau ticket';

  @override
  String get legacyUib85e445f60 => 'Nouvel utilisateur';

  @override
  String get legacyUia273c96341 => 'Nouveau véhicule';

  @override
  String get legacyUie0725b6664 => 'Nouvelle géozone';

  @override
  String get legacyUif39fa269a9 => 'Nouvel itinéraire';

  @override
  String get legacyUi395e182389 =>
      'Les nouveaux utilisateurs apparaîtront ici.';

  @override
  String get legacyUi2213317245 => 'Les nouveaux véhicules apparaîtront ici.';

  @override
  String get legacyUi4bfc194b68 => 'Page suivante';

  @override
  String get legacyUi1097b553dc => 'Nuit';

  @override
  String get legacyUi4276e6ab2a => 'Aucune donnée';

  @override
  String get legacyUi3de93f521b => 'Aucun appareil';

  @override
  String get legacyUi79858167e6 => 'Aucun point d’intérêt pour le moment';

  @override
  String get legacyUia434e9985c => 'Aucun fournisseur';

  @override
  String get legacyUi7094ba4f01 =>
      'Aucune affectation active. Les nouveaux trajets apparaîtront ici après leur attribution.';

  @override
  String get legacyUia9206f399a => 'Aucun journal d’activité';

  @override
  String get legacyUi8bd5b910e5 => 'Aucun journal d’activité trouvé';

  @override
  String get legacyUic38a37a193 =>
      'Aucune activité ne correspond à vos filtres.';

  @override
  String get legacyUibff9905096 =>
      'Aucune activité enregistrée pour le moment.';

  @override
  String get legacyUi0f5cca70f8 => 'Aucun administrateur trouvé';

  @override
  String get legacyUi31d3df94ab => 'Aucun administrateur trouvé.';

  @override
  String get legacyUic0d322c2b0 => 'Aucune donnée d’adoption';

  @override
  String get legacyUie5d64448e5 => 'Aucune alerte';

  @override
  String get legacyUi501176c9f8 => 'Aucune donnée statistique';

  @override
  String get legacyUi63f5349bb8 => 'Aucun utilisateur affecté';

  @override
  String get legacyUi852751d61f => 'Aucun véhicule affecté';

  @override
  String get legacyUi7546829892 => 'Aucune activité de facturation trouvée.';

  @override
  String get legacyUi657275c0c1 => 'Aucune ville disponible pour cet État';

  @override
  String get legacyUia130e0f01b => 'Aucun historique de commandes';

  @override
  String get legacyUi92db635f14 => 'Aucune commande pour le moment';

  @override
  String get legacyUi14a4bfc72c => 'Aucun trajet terminé ce mois-ci.';

  @override
  String get legacyUiee9c2e1df0 => 'Aucune configuration';

  @override
  String get legacyUic3017a3316 => 'Aucune conversation pour le moment';

  @override
  String get legacyUic140165b8f =>
      'Aucun historique de crédits pour le moment.';

  @override
  String get legacyUic8114767e8 => 'Aucun tableau de bord configuré';

  @override
  String get legacyUi7be70212b0 =>
      'Aucune donnée de jour ou de nuit pour cette période.';

  @override
  String get legacyUi2a4eb69350 => 'Aucun détail';

  @override
  String get legacyUi03ca0261ac => 'Aucun appareil';

  @override
  String get legacyUi893d388d16 => 'Aucun appareil affecté à ce véhicule.';

  @override
  String get legacyUi8386fe15ef => 'Aucun document';

  @override
  String get legacyUi017ce6604c => 'Aucun document téléversé';

  @override
  String get legacyUiec7eb3c93e => 'Aucun document téléversé pour le moment.';

  @override
  String get legacyUi54e1079e44 =>
      'Aucun document pour le moment. Ajoutez votre premier document avec le bouton de téléversement.';

  @override
  String get legacyUia419748e62 => 'Aucune activité de conducteur trouvée.';

  @override
  String get legacyUi98e6629503 =>
      'Aucun type de document conducteur n’est configuré. Demandez à votre administrateur d’en ajouter un.';

  @override
  String get legacyUi36f5cbf894 => 'Aucun document conducteur';

  @override
  String get legacyUic5dc9718a6 => 'Aucun conducteur';

  @override
  String get legacyUi7a127d70b3 => 'Aucun conducteur disponible';

  @override
  String get legacyUi9c8198d34d => 'Aucun conducteur trouvé';

  @override
  String get legacyUi208ffc64d1 => 'Aucun détail d’événement trouvé';

  @override
  String get legacyUiec11a02374 =>
      'Aucun événement ne correspond à la période et aux filtres sélectionnés.';

  @override
  String get legacyUia48cbba615 => 'Aucun événement trouvé';

  @override
  String get legacyUi81ab95b9f0 => 'Aucun événement pour le moment';

  @override
  String get legacyUi774a252215 => 'Aucun fichier disponible.';

  @override
  String get legacyUi35f65e1e57 => 'Aucune géozone disponible.';

  @override
  String get legacyUi019549899f => 'Aucune géozone pour le moment';

  @override
  String get legacyUi5358cec56d => 'Aucun point d’historique';

  @override
  String get legacyUia0ed9c8031 =>
      'Aucun point d’historique pour cette période.';

  @override
  String get legacyUi8bf09d954a => 'Aucun véhicule associé disponible';

  @override
  String get legacyUif48787eb30 => 'Aucun journal trouvé';

  @override
  String get legacyUi6b68d448a0 => 'Aucun journal trouvé pour ce véhicule';

  @override
  String get legacyUic7462a9dac => 'Aucun journal pour le moment';

  @override
  String get legacyUi1db215fbaa => 'Aucun résultat pour votre recherche.';

  @override
  String get legacyUia734fde29a => 'Aucun point d’intérêt correspondant';

  @override
  String get legacyUi2d928306c1 => 'Aucun conducteur correspondant';

  @override
  String get legacyUid6e8839481 => 'Aucune géozone correspondante';

  @override
  String get legacyUif6830db2e7 => 'Aucun journal correspondant';

  @override
  String get legacyUi748bd377da => 'Aucun enregistrement correspondant';

  @override
  String get legacyUi6590e5eab8 => 'Aucun itinéraire correspondant';

  @override
  String get legacyUid17e9558cf => 'Aucun sous-utilisateur correspondant';

  @override
  String get legacyUif1d8690cd7 =>
      'Aucun véhicule correspondant. Essayez une autre recherche ou un autre filtre.';

  @override
  String get legacyUic04921f8d9 => 'Aucun message pour le moment';

  @override
  String get legacyUi2449a03436 => 'Aucune donnée de mode';

  @override
  String get legacyUi50806db52e => 'Aucun paramètre de notification trouvé';

  @override
  String get legacyUic1f531f996 => 'Aucun paiement trouvé';

  @override
  String get legacyUiaf4a7f06d0 => 'Aucun forfait trouvé';

  @override
  String get legacyUi4ae157aff3 => 'Aucune alerte récente.';

  @override
  String get legacyUi26776d0320 => 'Aucun utilisateur récent';

  @override
  String get legacyUi42ec1ecf96 => 'Aucun véhicule récent';

  @override
  String get legacyUi9833364a35 => 'Aucun itinéraire disponible.';

  @override
  String get legacyUid233dd5d9f => 'Aucun itinéraire pour le moment';

  @override
  String get legacyUic9bfb1492b => 'Aucune activité de sécurité trouvée.';

  @override
  String get legacyUid07b6b93d6 => 'Aucun véhicule sélectionnable';

  @override
  String get legacyUi5653bf7251 =>
      'Aucune donnée de capteur pour cette période.';

  @override
  String get legacyUi1ef59c9c2b => 'Aucun capteur';

  @override
  String get legacyUi3c30b80f16 => 'Aucun capteur configuré pour ce véhicule.';

  @override
  String get legacyUicbae766d34 => 'Aucune modification de paramètres trouvée.';

  @override
  String get legacyUicd0c79d188 => 'Aucun lien de partage';

  @override
  String get legacyUi9eac2f6695 => 'Aucun État disponible pour ce pays';

  @override
  String get legacyUid05ab60501 => 'Aucune donnée de statut';

  @override
  String get legacyUi4b78e836ec => 'Aucun sous-utilisateur';

  @override
  String get legacyUib30adf9758 => 'Aucun sous-utilisateur disponible';

  @override
  String get legacyUi3a1fa8f145 => 'Aucun membre d’équipe trouvé';

  @override
  String get legacyUi12c6f10a41 => 'Aucun détail de télémétrie trouvé';

  @override
  String get legacyUi429d6e6ece => 'Aucun journal de télémétrie trouvé';

  @override
  String get legacyUiea04e18b66 => 'Aucun actif principal pour cette période.';

  @override
  String get legacyUi48d2d8da35 => 'Aucune transaction';

  @override
  String get legacyUid60c045dd2 => 'Aucune transaction trouvée';

  @override
  String get legacyUif794b6c6d1 => 'Aucune transaction pour le moment.';

  @override
  String get legacyUi8d92589518 => 'Aucune donnée de tendance';

  @override
  String get legacyUi7d3e5f72b8 => 'Aucun trajet dans cette vue.';

  @override
  String get legacyUib4c96ae04e => 'Aucun utilisateur non associé trouvé.';

  @override
  String get legacyUi4b3155e704 =>
      'Aucun utilisateur non associé ne correspond à votre recherche.';

  @override
  String get legacyUid9c71203a5 =>
      'Aucune donnée d’utilisation pour la période sélectionnée.';

  @override
  String get legacyUic4b060bd59 => 'Aucun utilisateur';

  @override
  String get legacyUi5cc2b29f54 => 'Aucun utilisateur affecté';

  @override
  String get legacyUi3b614a59c7 => 'Aucun utilisateur disponible';

  @override
  String get legacyUi612eb3c64c => 'Aucun utilisateur trouvé';

  @override
  String get legacyUie611ef5702 => 'Aucun utilisateur trouvé.';

  @override
  String get legacyUif800dfd722 =>
      'Aucun tracé GPS ni repère d’arrêt valide n’a été retourné.';

  @override
  String get legacyUib96ee669b0 => 'Aucune activité de véhicule trouvée.';

  @override
  String get legacyUi748eafd21d => 'Aucun véhicule';

  @override
  String get legacyUi8fbc8deb7a =>
      'Aucun véhicule n’est visible sur la carte pour le moment.';

  @override
  String get legacyUi72ed5bbcdf => 'Aucun véhicule affecté pour le moment.';

  @override
  String get legacyUi7223e6b8cb => 'Aucun véhicule affecté.';

  @override
  String get legacyUiac0e4dbd5b => 'Aucun véhicule disponible';

  @override
  String get legacyUic578cfdbd5 => 'Aucun véhicule trouvé';

  @override
  String get legacyUie1de5f8ce2 =>
      'Aucun véhicule ne correspond à votre recherche.';

  @override
  String get legacyUia41b297cf1 => 'Aucune donnée de comparaison hebdomadaire.';

  @override
  String get legacyUi35163920f3 => 'Aucun widget configuré';

  @override
  String get legacyUi45e118d056 => 'Normal';

  @override
  String get legacyUif8e45b2be2 => 'Nord';

  @override
  String get legacyUi2c924e3088 => 'Remarque';

  @override
  String get legacyUi2fd5716446 => 'Remarques (facultatif)';

  @override
  String get legacyUicf62dbc83d => 'Remarques / Description';

  @override
  String get legacyUi3e56dbb775 => 'Remarques sur ce document';

  @override
  String get legacyUi7faf33fcca => 'Rien à exporter';

  @override
  String get legacyUi76544814eb => 'Actions de notification';

  @override
  String get legacyUi4eb32de6c9 => 'Paramètres de notification enregistrés.';

  @override
  String get legacyUi8ca2cb9290 => 'Compteur kilométrique';

  @override
  String get legacyUi6c3a72eaf6 => 'Bureau';

  @override
  String get legacyUi63f34dd211 => 'Plus ancien';

  @override
  String get legacyUi35c5d4307a => 'Lignes antérieures';

  @override
  String get legacyUi9f8f7411e8 =>
      'Un ou plusieurs véhicules sélectionnés sont invalides.';

  @override
  String get legacyUie81cd61ea1 =>
      'Seuls les véhicules affectés à l’utilisateur peuvent être partagés.';

  @override
  String get legacyUicf9b77061f => 'Ouvert';

  @override
  String get legacyUi8f5f529938 => 'Ouvrir / enregistrer';

  @override
  String get legacyUi55d00c31ab => 'Ouvert Véhicules';

  @override
  String get legacyUicc6b7ec50c => 'Ouvrir le CSV des lignes en échec';

  @override
  String get legacyUi99bd9c01d7 => 'Notifications OpenVTS';

  @override
  String get legacyUic1b94f880c => 'Montant facultatif';

  @override
  String get legacyUi7afdcf3257 => 'E-mail facultatif';

  @override
  String get legacyUic553137ef5 => 'Mobile facultatif';

  @override
  String get legacyUi410d481882 => 'Remarques facultatives';

  @override
  String get legacyUi4f8f9c2bba => 'Reçu ou remarque facultatif';

  @override
  String get legacyUi3494a60f96 => 'Nom d’utilisateur facultatif';

  @override
  String get legacyUia493c04fb5 =>
      'Facultatif ; saisissez au moins 3 caractères';

  @override
  String get legacyUi6bf5da9c08 => 'Options';

  @override
  String get legacyUidefe0db589 => 'Trier par';

  @override
  String get legacyUi6e6a6f2086 => 'Autre';

  @override
  String get legacyUi4bed336194 => 'Sortie';

  @override
  String get legacyUi9e339da256 => 'Survitesse activée';

  @override
  String get legacyUi0efc2e6be4 => 'Vue d’ensemble';

  @override
  String get legacyUi3e90e4cbf4 => 'Propriété';

  @override
  String get legacyUi07afcc61d8 => 'Type de paquet';

  @override
  String get legacyUif92c24e8df => 'Parc';

  @override
  String get legacyUi07ba1bef85 => 'Parties concernées';

  @override
  String get legacyUi8be3c943b1 => 'Mot de passe';

  @override
  String get legacyUi408255ed02 => 'Mot de passe (facultatif)';

  @override
  String get legacyUi092a16e7af => 'Mot de passe modifié';

  @override
  String get legacyUi47fa528931 => 'Mot de passe modifié.';

  @override
  String get legacyUi3efdbb2011 => 'Mot de passe mis à jour.';

  @override
  String get legacyUi8ac0c75d5e =>
      'Collez le lien complet de réinitialisation ou le jeton reçu par e-mail. Les liens ne sont utilisables qu’une fois et expirent automatiquement.';

  @override
  String get legacyUi5616b61bb7 => 'Contenu JSON';

  @override
  String get legacyUif8c3596eab => 'Le contenu doit être un objet JSON valide.';

  @override
  String get legacyUi23b35c414a => 'Mode de paiement';

  @override
  String get legacyUi670d2a76c7 => 'Mode de paiement *';

  @override
  String get legacyUi662210d869 => 'Répartition des modes de paiement';

  @override
  String get legacyUia629fd8a2e => 'Type de paiement';

  @override
  String get legacyUi43f8c9c90f => 'L’activité des paiements apparaîtra ici.';

  @override
  String get legacyUi8fbf2ec0dd => 'Mode de paiement';

  @override
  String get legacyUi653c04fc42 =>
      'La répartition des modes de paiement n’est pas disponible pour cette période.';

  @override
  String get legacyUidbc3c0ca72 => 'Paiement enregistré';

  @override
  String get legacyUi197b45d161 => 'Référence du paiement';

  @override
  String get legacyUi96f608c16c => 'En attente';

  @override
  String get legacyUid1240d2832 => 'En attente / Échec';

  @override
  String get legacyUi9126c119ae => 'Paiements en attente';

  @override
  String get legacyUib4ebfb2f75 => 'Paiements en attente';

  @override
  String get legacyUi167a47ff3e => 'Effectué par';

  @override
  String get legacyUi1785713451 => 'Autorisation';

  @override
  String get legacyUid06d555709 => 'Autorisations';

  @override
  String get legacyUi1e99c04657 => 'Autorisations mises à jour';

  @override
  String get legacyUi0219adf447 => 'Informations personnelles et adresse';

  @override
  String get legacyUib1b9e59387 => 'Informations personnelles';

  @override
  String get legacyUi77064d5265 => 'Téléphone';

  @override
  String get legacyUi26730cddc4 => 'Choisir un CSV';

  @override
  String get legacyUif2c5ca7b8c => 'Code postal';

  @override
  String get legacyUifd25c49d56 => 'Code postal (optional)';

  @override
  String get legacyUiae2f98a099 => 'Forfait';

  @override
  String get legacyUiec0632cbbf => 'Nom du forfait';

  @override
  String get legacyUi2b366a2f95 => 'Prix du forfait';

  @override
  String get legacyUi7f97f6a268 => 'Forfait créé et sélectionné';

  @override
  String get legacyUi2db331cefa => 'Plaque';

  @override
  String get legacyUi7d86677521 => 'Numéro d’immatriculation';

  @override
  String get legacyUia6b7aa4d9c => 'Numéro d’immatriculation (facultatif)';

  @override
  String get legacyUif2ce282e2d => 'Numéro d’immatriculation';

  @override
  String get legacyUi09d9c23846 => 'Numéro d’immatriculation (facultatif)';

  @override
  String get legacyUi123a7f2fcc => 'Plateforme';

  @override
  String get legacyUi16596c477e =>
      'Fonctionnement de la plateforme, inscription, géocodage et conservation.';

  @override
  String get legacyUid095e279b3 =>
      'Corrigez les champs signalés avant de continuer.';

  @override
  String get legacyUi51668149ea => 'Sélectionnez un administrateur.';

  @override
  String get legacyUife035157cd => 'Port';

  @override
  String get legacyUi16c2eb4dbb => 'Ports';

  @override
  String get legacyUib629d4165b => 'Code postal';

  @override
  String get legacyUib86b6a2b3b => 'Code postal (facultatif)';

  @override
  String get legacyUi90eceb016c => 'Indicatif';

  @override
  String get legacyUif1fbb2b43d => 'Aperçu';

  @override
  String get legacyUiba3e0b4a86 => 'Aperçu mis à jour';

  @override
  String get legacyUi81f547195b => 'Page précédente';

  @override
  String get legacyUi3e8248e32e => 'Prix';

  @override
  String get legacyUi15ac0c0a27 => 'Forfait tarifaire';

  @override
  String get legacyUid3dcce7d10 => 'Couleur principale';

  @override
  String get legacyUi170f443f36 => 'Utilisateur principal';

  @override
  String get legacyUia1055f11a9 => 'Couleur principale';

  @override
  String get legacyUic1ee865b42 => 'Couleur principale (hex)';

  @override
  String get legacyUi0554f68465 => 'Utilisateur principal';

  @override
  String get legacyUi1e5947a051 =>
      'L’utilisateur principal, l’appareil, le type de véhicule et le forfait tarifaire sont obligatoires.';

  @override
  String get legacyUi886cbff9d9 => 'Priorité';

  @override
  String get legacyUi7e7302bb73 => 'Profil pas encore chargé.';

  @override
  String get legacyUi5049e8f42b => 'Profil photo mis à jour.';

  @override
  String get legacyUi49ba5b4d7b => 'Paramètres du profil indisponibles';

  @override
  String get legacyUibcf7629607 => 'Profil mis à jour.';

  @override
  String get legacyUibda244507b =>
      'Les modifications du profil, de l’entreprise ou de la configuration apparaîtront ici.';

  @override
  String get legacyUi204be1a53a => 'Prévisionnel';

  @override
  String get legacyUi5c620cdb78 => 'Type de justificatif';

  @override
  String get legacyUi1ed77c3f7f => 'Protocole';

  @override
  String get legacyUi7ceee3f361 => 'Fournisseur';

  @override
  String get legacyUi767359109d => 'Réf. fournisseur';

  @override
  String get legacyUi8d80f9c731 => 'Expiration de la couverture fournisseur';

  @override
  String get legacyUi8a87202949 => 'L’URL publique n’est pas disponible.';

  @override
  String get legacyUi411c13db3b =>
      'Inscription publique et crédits de bienvenue.';

  @override
  String get legacyUicf0a64d03d =>
      'Tirez vers le bas pour actualiser et recharger votre profil.';

  @override
  String get legacyUic8f58b21ae =>
      'Tirez vers le bas pour actualiser ou ajoutez un conducteur.';

  @override
  String get legacyUi011bc421c2 =>
      'Tirez vers le bas pour actualiser ou créez un sous-utilisateur.';

  @override
  String get legacyUi6a599877d7 => 'En file d’attente';

  @override
  String get legacyUia16c5bbe4b => 'Plage';

  @override
  String get legacyUida433cd41e => 'Raw';

  @override
  String get legacyUice09c15f57 => 'Paquet brut';

  @override
  String get legacyUia3ccb33027 => 'Razorpay';

  @override
  String get legacyUi2af51c3e17 => 'Saisissez à nouveau le mot de passe';

  @override
  String get legacyUi852b438f91 => 'Lu';

  @override
  String get legacyUid14d593883 => 'Tout marquer comme lu';

  @override
  String get legacyUi00db810078 => 'Motif de l’ajustement';

  @override
  String get legacyUid4835a2d13 =>
      'Motif du montant personnalisé (5 à 500 caractères)';

  @override
  String get legacyUi03c3ccd3ff => 'Recent Alertes';

  @override
  String get legacyUi3abf211c93 => 'Paiements récents';

  @override
  String get legacyUi93c62de33f => 'Utilisateurs récents';

  @override
  String get legacyUi6b33999078 => 'Recent Véhicules';

  @override
  String get legacyUi790a1b9e7b =>
      'L’activité récente apparaîtra ici dès que le serveur la fournira.';

  @override
  String get legacyUic1541851a1 => 'Activité récente du service';

  @override
  String get legacyUi204110a010 =>
      'Les utilisateurs récents apparaîtront ici dès que le tableau de bord les fournira.';

  @override
  String get legacyUida67fde0f7 => 'Recentrer';

  @override
  String get legacyUi7df7c0bb40 => 'E-mail du destinataire';

  @override
  String get legacyUi8ee92c936a => 'Destinataire/Utilisateur';

  @override
  String get legacyUi6577ced3c0 => 'Enregistrer un paiement';

  @override
  String get legacyUib19313692e => 'Enregistré par';

  @override
  String get legacyUi471b94d402 => 'Rétablir';

  @override
  String get legacyUidb1c784524 => 'Référence';

  @override
  String get legacyUic9dc8442d5 => 'Référence (facultatif)';

  @override
  String get legacyUie3039b8476 => 'Référence (optional)';

  @override
  String get legacyUid8b2ee1dcd => 'La référence est limitée à 200 caractères';

  @override
  String get legacyUi7a8e2a362c =>
      'La référence doit contenir au maximum 100 caractères.';

  @override
  String get legacyUi483e715402 => 'Actualiser les administrateurs';

  @override
  String get legacyUif2b5787c06 => 'Actualiser Tableau de bord';

  @override
  String get legacyUie75f05fced => 'Actualiser les conducteurs';

  @override
  String get legacyUiebbc55f9ce => 'Actualiser l’historique';

  @override
  String get legacyUid0512701b2 => 'Actualiser le stock';

  @override
  String get legacyUif6cf59106a => 'Actualiser les messages';

  @override
  String get legacyUid7cb2b4eea => 'Actualiser les options de rapport';

  @override
  String get legacyUi323540a087 => 'Actualiser les paramètres';

  @override
  String get legacyUiade15a52e2 => 'Actualiser le statut';

  @override
  String get legacyUie4d3b8b5ff => 'Actualiser l’équipe';

  @override
  String get legacyUi12f92ceb6e => 'Actualiser les tickets';

  @override
  String get legacyUi3367ca735f => 'Actualiser les transactions';

  @override
  String get legacyUi892f6f322d => 'Actualiser les utilisateurs';

  @override
  String get legacyUidf50facb6a => 'Actualiser les véhicules';

  @override
  String get legacyUid42d9c1932 => 'Actualiser le widget';

  @override
  String get legacyUia844fcf834 => 'Enregistré';

  @override
  String get legacyUi9aba73febb => '10 derniers caractères du jeton enregistré';

  @override
  String get legacyUic498221a5a => 'Date d’inscription';

  @override
  String get legacyUi20e264f6a1 => 'Arrêt associé';

  @override
  String get legacyUi62d14389b3 => 'Recharger les types de documents';

  @override
  String get legacyUia2653dac4a => 'Remarque';

  @override
  String get legacyUie963907dac => 'Retirer';

  @override
  String get legacyUi0fcc6594fc => 'Retirer la pièce jointe';

  @override
  String get legacyUi48666118ca => 'Supprimer la ligne de métadonnées';

  @override
  String get legacyUif96ba1e583 =>
      'Retirer l’affectation du véhicule à ce conducteur ?';

  @override
  String get legacyUi0165f7088a => 'Renouveler';

  @override
  String get legacyUib219a06163 => 'Renew Véhicule';

  @override
  String get legacyUi4913250b6c => 'Renouveler la couverture annuelle';

  @override
  String get legacyUif192fe3e94 => 'Renouveler la couverture annuelle ?';

  @override
  String get legacyUi1cce449350 => 'Renouvelez jusqu’à 100 véhicules à la fois';

  @override
  String get legacyUi714c2b126f =>
      'Renouvelez jusqu’à 100 véhicules à la fois.';

  @override
  String get legacyUibb47b991fe => 'Demandes de renouvellement';

  @override
  String get legacyUiac2377c0dd => 'Vitesse de lecture';

  @override
  String get legacyUi5cc45fda55 =>
      'Les réponses apparaîtront ici une fois la conversation commencée.';

  @override
  String get legacyUid7a41420c8 =>
      'Les réponses apparaîtront ici une fois la conversation du ticket commencée.';

  @override
  String get legacyUi1f21d9edca => 'La réponse est trop longue.';

  @override
  String get legacyUi4c7c79f6a9 => 'Le message de réponse est obligatoire.';

  @override
  String get legacyUic9e8dd4159 => 'Réponse envoyée.';

  @override
  String get legacyUi5ce1bacd48 => 'Réponse envoyée.';

  @override
  String get legacyUi49072e5767 => 'Adresse de réponse (facultatif)';

  @override
  String get legacyUi6e2c712363 => 'Signaler un problème';

  @override
  String get legacyUi0ca4fce136 => 'Type de rapport';

  @override
  String get legacyUi4857497af3 =>
      'Demander un nouveau lien de réinitialisation';

  @override
  String get legacyUida30a140cc => 'Demander le renouvellement du véhicule ?';

  @override
  String get legacyUic26bf60fed => 'Demandé';

  @override
  String get legacyUi1d3cb8a962 => 'Renvoyer le code';

  @override
  String get legacyUi56553100b0 => 'Réinitialiser les filtres';

  @override
  String get legacyUibb02ea158c => 'Lien ou jeton de réinitialisation';

  @override
  String get legacyUi3ddc852b26 => 'Orienter vers le nord';

  @override
  String get legacyUi5c4bc97ee5 => 'Réinitialiser le mot de passe';

  @override
  String get legacyUi4f21821190 => 'Répondu';

  @override
  String get legacyUi966ea65ee9 => 'Réponse hexadécimale';

  @override
  String get legacyUi3585d7553d => 'Restaurant';

  @override
  String get legacyUiab6d02bfbb => 'Limité par votre administrateur';

  @override
  String get legacyUic7199d9e95 => 'Conservation';

  @override
  String get legacyUi9393bfa8e2 => 'Durée de conservation';

  @override
  String get legacyUibf1c27deea => 'Recharger les devises';

  @override
  String get legacyUi2e84dd3c7d => 'Réessayer l’inscription';

  @override
  String get legacyUic507a566fc => 'Précision du géocodage inversé';

  @override
  String get legacyUi7148d08646 => 'Ondulation';

  @override
  String get legacyUic3f104d136 => 'Rôle';

  @override
  String get legacyUib1b392607d => 'Run';

  @override
  String get legacyUi26c35575bf => 'Exécuter le capteur';

  @override
  String get legacyUiba51f0a9fa => 'Rechercher dans l’historique';

  @override
  String get legacyUia84c30c93c => 'Lancer le nettoyage';

  @override
  String get legacyUibd4e4bc9f2 => 'Numéro SIM';

  @override
  String get legacyUi135447fb8f => 'SIM seule';

  @override
  String get legacyUi3454bbef7f => 'Fournisseur SIM';

  @override
  String get legacyUi0366e95ddf => 'Fournisseur SIM (facultatif)';

  @override
  String get legacyUi4636ab9e9a => 'Carte SIM mise à jour.';

  @override
  String get legacyUi12897d0b88 => 'Statut de la SIM';

  @override
  String get legacyUi1f4f5e7e3c => 'Identifiants du compte SMTP.';

  @override
  String get legacyUi7d08205aa6 => 'Paramètres SMTP enregistrés';

  @override
  String get legacyUia70c3bcf1d => 'San Francisco';

  @override
  String get legacyUi340bbc7875 => 'Satellites';

  @override
  String get legacyUidb95397447 => 'Enregistrer en .kml';

  @override
  String get legacyUifa2984b367 => 'Enregistrer les modifications';

  @override
  String get legacyUi78fe0922d6 => 'Enregistrer l’entreprise';

  @override
  String get legacyUic6606cd51c => 'Enregistrer la configuration';

  @override
  String get legacyUi909bf3e807 => 'Enregistrer le profil';

  @override
  String get legacyUif2f3d66a79 => 'École';

  @override
  String get legacyUid09c8bca28 => 'Rechercher un numéro SIM…';

  @override
  String get legacyUiabddbf1811 => 'Rechercher dans les journaux d’activité…';

  @override
  String get legacyUi9a99566535 => 'Rechercher une activité…';

  @override
  String get legacyUi1321daf435 => 'Rechercher parmi les conducteurs affectés';

  @override
  String get legacyUie6ac2b6800 => 'Rechercher parmi les véhicules affectés';

  @override
  String get legacyUi3a97577679 =>
      'Rechercher parmi les conducteurs disponibles';

  @override
  String get legacyUiacd1382ab4 => 'Rechercher parmi les véhicules disponibles';

  @override
  String get legacyUi03ef7546a9 => 'Rechercher by IMEI...';

  @override
  String get legacyUia8854d5f97 => 'Rechercher par code…';

  @override
  String get legacyUi411482b8e7 =>
      'Rechercher par date, activité, crédits, véhicule…';

  @override
  String get legacyUi28abc0313d => 'Rechercher par nom';

  @override
  String get legacyUi28f3d064ea => 'Rechercher par nom ou catégorie';

  @override
  String get legacyUi4120e178da => 'Rechercher par nom ou immatriculation…';

  @override
  String get legacyUibb6cfd804d => 'Rechercher par nom, e-mail…';

  @override
  String get legacyUi1c1d641fe8 =>
      'Rechercher par nom, immatriculation, IMEI ou VIN';

  @override
  String get legacyUife32b8f32a => 'Rechercher par nom, immatriculation, IMEI…';

  @override
  String get legacyUibdc6551409 =>
      'Rechercher par nom, immatriculation, VIN, IMEI, SIM…';

  @override
  String get legacyUiba20cfd893 =>
      'Rechercher par référence ou administrateur…';

  @override
  String get legacyUi45b6baaad3 => 'Rechercher dans les données quotidiennes…';

  @override
  String get legacyUie43926680a => 'Rechercher dans les journaux de l’appareil';

  @override
  String get legacyUi26eb1d222b => 'Rechercher un type d’appareil…';

  @override
  String get legacyUi98110e65a0 => 'Rechercher dans les journaux chargés';

  @override
  String get legacyUi48225af1f4 => 'Rechercher dans les journaux';

  @override
  String get legacyUi20f28ed35b => 'Rechercher par nom, IMEI, SIM ou type';

  @override
  String get legacyUic60723c651 =>
      'Rechercher par nom, immatriculation ou IMEI';

  @override
  String get legacyUi3dadc5cddf =>
      'Rechercher par nom, identifiant, e-mail, mobile, véhicule, immatriculation…';

  @override
  String get legacyUi0417c5f97b =>
      'Rechercher par nom, identifiant, e-mail, mobile…';

  @override
  String get legacyUi5196e5c8da => 'Rechercher un lieu ou une adresse…';

  @override
  String get legacyUic3290fb221 => 'Rechercher un lieu…';

  @override
  String get legacyUi60c8ce351b =>
      'Rechercher par forfait, devise, durée, prix…';

  @override
  String get legacyUie5483c71e7 => 'Rechercher un fournisseur…';

  @override
  String get legacyUi98e27d7b41 =>
      'Rechercher par référence, fournisseur, contrepartie…';

  @override
  String get legacyUidd77f6ecc1 =>
      'Rechercher par référence, fournisseur, utilisateur, véhicule';

  @override
  String get legacyUi0066a752cb => 'Rechercher des itinéraires par nom';

  @override
  String get legacyUi502e6eaf2c => 'Rechercher des capteurs';

  @override
  String get legacyUi0cfffb61af => 'Rechercher Capteurs...';

  @override
  String get legacyUi233ad2b14f => 'Rechercher par objet, numéro ou statut';

  @override
  String get legacyUid320d41a03 => 'Rechercher des tickets';

  @override
  String get legacyUi65da39d5f0 => 'Rechercher des transactions…';

  @override
  String get legacyUi25dfae4e3a => 'Rechercher des trajets';

  @override
  String get legacyUida80ead473 => 'Rechercher des utilisateurs non associés…';

  @override
  String get legacyUie5b2404515 => 'Rechercher des utilisateurs, véhicules…';

  @override
  String get legacyUi8cdc4c0930 => 'Rechercher Users...';

  @override
  String get legacyUi2e4b72c10c => 'Rechercher un véhicule';

  @override
  String get legacyUi1bd54471c2 => 'Rechercher des événements de véhicule…';

  @override
  String get legacyUiba537c59ae =>
      'Rechercher par véhicule, immatriculation, VIN, IMEI, SIM, utilisateur…';

  @override
  String get legacyUi4a54a9e6db =>
      'Rechercher par véhicule, immatriculation, VIN, IMEI, SIM…';

  @override
  String get legacyUi5780b5d6bf => 'Rechercher Véhicules';

  @override
  String get legacyUi50efae1b5f =>
      'Rechercher des véhicules par nom, immatriculation, forfait…';

  @override
  String get legacyUib09b43245d => 'Rechercher Véhicules...';

  @override
  String get legacyUif54fbca187 => 'Rechercher…';

  @override
  String get legacyUifaaee5e23e => 'Sélectionner SIM';

  @override
  String get legacyUi69cc521201 => 'Sélectionnez un pays';

  @override
  String get legacyUi400a58f1cc =>
      'Sélectionnez une période pour charger l’historique.';

  @override
  String get legacyUie216b735f0 => 'Sélectionnez d’abord un utilisateur.';

  @override
  String get legacyUie965317576 => 'Sélectionnez d’abord un véhicule.';

  @override
  String get legacyUia72bd23c12 =>
      'Sélectionnez un véhicule, un seuil d’arrêt et une période avec heures.';

  @override
  String get legacyUi29c9360313 => 'Sélectionner un administrateur';

  @override
  String get legacyUi8a152d2c3f =>
      'Sélectionnez au moins un véhicule renouvelable';

  @override
  String get legacyUi5573da8514 => 'Sélectionnez au moins un véhicule.';

  @override
  String get legacyUi42303635fc => 'Sélectionner Ville';

  @override
  String get legacyUi9915f6e5c2 => 'Sélectionner une couleur';

  @override
  String get legacyUia96ce92893 => 'Sélectionner un modèle de commande';

  @override
  String get legacyUi59ee76bad1 => 'Sélectionner Pays';

  @override
  String get legacyUi74c388ab91 => 'Sélectionner la période avec heures';

  @override
  String get legacyUi46bfa11b12 => 'Sélectionner Type d’appareil';

  @override
  String get legacyUidba2e6bd04 => 'Sélectionner Document Type';

  @override
  String get legacyUi386f8ba9d0 => 'Sélectionner l’utilisateur principal';

  @override
  String get legacyUic7a9e8ea6a => 'Sélectionner un fournisseur';

  @override
  String get legacyUib350802ae1 => 'Sélectionner État';

  @override
  String get legacyUi905d012288 => 'Sélectionner Type';

  @override
  String get legacyUib8a1d9de7d => 'Sélectionner User';

  @override
  String get legacyUie574e3a29d =>
      'Sélectionnez des véhicules dont les forfaits utilisent la même devise';

  @override
  String get legacyUi07f0f61db9 => 'Le fichier sélectionné est vide.';

  @override
  String get legacyUi9bc2575c39 => 'Envoyer';

  @override
  String get legacyUi0ad7c21624 => 'Envoyer Command';

  @override
  String get legacyUi9b48248439 =>
      'Envoyez une commande pour afficher l’historique.';

  @override
  String get legacyUi724aa54b02 => 'Envoyer la commande au véhicule ?';

  @override
  String get legacyUic70a890d14 => 'Envoyer le message';

  @override
  String get legacyUia89d641794 => 'Envoyer la demande';

  @override
  String get legacyUib8ec554332 => 'Envoyer le lien de réinitialisation';

  @override
  String get legacyUi1aba33d6c2 => 'Envoyer un test';

  @override
  String get legacyUifc552c754d => 'Envoyer un e-mail de test';

  @override
  String get legacyUi17b874d289 => 'Expéditeur';

  @override
  String get legacyUi679e8f61b9 => 'Sender Nom';

  @override
  String get legacyUi73dcba5635 => 'Sensor Historique';

  @override
  String get legacyUia14460cfb3 => 'Période d’historique du capteur';

  @override
  String get legacyUia9bc44292f => 'Actions du capteur';

  @override
  String get legacyUi18d80b838f => 'Capteur supprimé.';

  @override
  String get legacyUi711bf35988 => 'Capteurs';

  @override
  String get legacyUi48380dd0e2 => 'Capteurs indisponibles';

  @override
  String get legacyUi35f49dcfbf => 'Envoyé';

  @override
  String get legacyUi2d7bb03171 =>
      'Les commandes envoyées et les réponses des appareils apparaissent ici.';

  @override
  String get legacyUi1d5d1effa9 => 'URL du serveur';

  @override
  String get legacyUif85e6f1bdc => 'Serveur Uptime';

  @override
  String get legacyUi10802e852c => 'Heure du serveur';

  @override
  String get legacyUi7ef53dd844 =>
      'L’expiration du service doit être postérieure à l’inscription.';

  @override
  String get legacyUi2ad34ef4cf => 'Forfait de service';

  @override
  String get legacyUi2bacd5f581 => 'Début du service';

  @override
  String get legacyUiaa02a8d843 => 'Définir les heures moteur';

  @override
  String get legacyUi837c0d47b5 => 'Définir le compteur kilométrique';

  @override
  String get legacyUiaef97bb06a => 'Paramètres enregistrés';

  @override
  String get legacyUi96a0dc481b => 'Commerces';

  @override
  String get legacyUi5e65ca08ed => 'Titre court du problème';

  @override
  String get legacyUi4c742d5133 => 'Afficher la géozone';

  @override
  String get legacyUi5abbf34ba3 => 'Show Historique';

  @override
  String get legacyUi8268618610 =>
      'Afficher une pulsation animée autour des véhicules en marche';

  @override
  String get legacyUi25911d48e0 => 'Afficher plus';

  @override
  String get legacyUi50b47f1483 => 'Afficher les repères des points d’intérêt';

  @override
  String get legacyUib7f93469b9 => 'Afficher le tracé de l’itinéraire';

  @override
  String get legacyUi510904927e =>
      'Show Véhicule Nom Suivant to the icon on the Carte';

  @override
  String get legacyUi6e61e47d5c =>
      'Affiché sur les arrière-plans sombres. PNG, JPG, SVG, WEBP. 5 Mo maximum.';

  @override
  String get legacyUi39e4052ecf =>
      'Affiché sur les arrière-plans clairs. PNG, JPG, SVG, WEBP. 5 Mo maximum.';

  @override
  String get legacyUi894bc414e6 => 'Inscription';

  @override
  String get legacyUi69c2037890 => 'Aller à la fin';

  @override
  String get legacyUia8522e4c9d => 'Aller au début';

  @override
  String get legacyUi33dcec9ce4 => 'Lent';

  @override
  String get legacyUicf606d0913 => 'Plus lent';

  @override
  String get legacyUi339c1ea94b => 'Liens sociaux';

  @override
  String get legacyUi3db7211438 => 'Trier les cartes SIM';

  @override
  String get legacyUi66758a74bc => 'Trier les administrateurs';

  @override
  String get legacyUi3655295cb4 => 'Trier les appareils';

  @override
  String get legacyUi3a21e72182 => 'Trier les conducteurs';

  @override
  String get legacyUi1e891a0102 => 'Trier l’équipe';

  @override
  String get legacyUi6d1ba980e8 => 'Trier les utilisateurs';

  @override
  String get legacyUi2512bda9e7 => 'Trier les véhicules';

  @override
  String get legacyUi6da13addb0 => 'Source';

  @override
  String get legacyUi6ace449732 => 'Sud';

  @override
  String get legacyUi2d2cb022bc => 'Vitesse';

  @override
  String get legacyUi8a14aeec13 => 'Vitesse Multiplier';

  @override
  String get legacyUid6a0aaa660 => 'Variation de vitesse';

  @override
  String get legacyUi09a7707087 => 'Démarrer manuellement';

  @override
  String get legacyUi7e244fee11 =>
      'L’heure de début doit précéder l’heure de fin.';

  @override
  String get legacyUia725020675 => 'État';

  @override
  String get legacyUi4e5c9805af => 'État (optional)';

  @override
  String get legacyUic01247416e => 'L’État est obligatoire.';

  @override
  String get legacyUiedde30a0b6 => 'Statut : ';

  @override
  String get legacyUia0539c7e7a =>
      'La répartition des statuts n’est pas disponible pour cette période.';

  @override
  String get legacyUie4fe064446 => 'Durée d’arrêt en minutes';

  @override
  String get legacyUif32715a2f1 => 'Repère d’arrêt';

  @override
  String get legacyUi5ca845e914 => 'Rue, bâtiment, quartier…';

  @override
  String get legacyUi4d08ec5874 => 'Stripe';

  @override
  String get legacyUi8de713bd12 => 'Sous-utilisateurs';

  @override
  String get legacyUi97a0373212 => 'Sous-utilisateur créé.';

  @override
  String get legacyUi5cae4f427b => 'Sous-utilisateur supprimé.';

  @override
  String get legacyUi2cc74ff5c3 => 'Nom du sous-utilisateur';

  @override
  String get legacyUie44d50f72d => 'Sous-utilisateur mis à jour.';

  @override
  String get legacyUibd3159ff21 => 'L’objet est obligatoire.';

  @override
  String get legacyUi6844979e4f =>
      'L’objet doit contenir au moins une lettre ou un chiffre.';

  @override
  String get legacyUid6981f7476 => 'S’abonner';

  @override
  String get legacyUia547aab586 =>
      'Abonnement aux mises à jour par e-mail activé';

  @override
  String get legacyUid7932a2917 => 'Réussi';

  @override
  String get legacyUib879505819 => 'Ticket d’assistance';

  @override
  String get legacyUi848eed0fbd => 'Étiquettes';

  @override
  String get legacyUi8c7e01ee22 => 'Étiquettes (séparées par des virgules)';

  @override
  String get legacyUi1df356a49e =>
      'Touchez la carte ou saisissez des coordonnées pour placer le point d’intérêt.';

  @override
  String get legacyUi61ad50a9b9 => 'Cible';

  @override
  String get legacyUi78560d88ef => 'Équipe activée.';

  @override
  String get legacyUid8f82f6030 => 'Activité de l’équipe';

  @override
  String get legacyUi8aef227384 => 'Équipe désactivée.';

  @override
  String get legacyUi72df525608 => 'Membre d’équipe créé.';

  @override
  String get legacyUi07fed9d9b3 => 'Membre d’équipe mis à jour.';

  @override
  String get legacyUi0194c31b6d => 'Autorisations de l’équipe mises à jour';

  @override
  String get legacyUi6730423d83 => 'Détails de télémétrie';

  @override
  String get legacyUieef4095d19 => 'Télémétrie Logs';

  @override
  String get legacyUif8d42e6122 => 'Période de télémétrie';

  @override
  String get legacyUi3ec1ae061c => 'Modèle';

  @override
  String get legacyUi7200f86ae5 => 'Tester les notifications mobiles';

  @override
  String get legacyUi8b9bbdf230 => 'Tester les notifications';

  @override
  String get legacyUi8135cd8fa3 =>
      'Le client peut créer une nouvelle demande. Aucun service de véhicule n’est prolongé.';

  @override
  String get legacyUidc46c2859b => 'Le lien expire automatiquement.';

  @override
  String get legacyUic77eaa41ef =>
      'Organisation gérée par cet administrateur dans OpenVTS.';

  @override
  String get legacyUi461197e42e =>
      'Organisation à laquelle appartient cet utilisateur dans OpenVTS.';

  @override
  String get legacyUia491398fbb =>
      'La réponse de synthèse ne contient pas encore de données graphiques.';

  @override
  String get legacyUi214cddfadb =>
      'La réponse de synthèse ne contient pas encore de véhicules récents.';

  @override
  String get legacyUi9e4a7b1c4c =>
      'Le catalogue des autorisations est indisponible. La modification est désactivée.';

  @override
  String get legacyUiac4a475bbb =>
      'Le serveur a retourné un catalogue d’autorisations non pris en charge. La modification est désactivée.';

  @override
  String get legacyUi8895c1d4b6 =>
      'Le téléversement est terminé, mais le serveur n’a pas retourné la nouvelle photo de profil.';

  @override
  String get legacyUidbc2f6bd85 =>
      'Aucune alerte n’est disponible pour le moment.';

  @override
  String get legacyUi9b519b14b9 => 'Aucun événement ce jour-là';

  @override
  String get legacyUi354cfe028c =>
      'Ces modifications accordent un accès global ou un droit de suppression. Les appliquer à ce membre d’équipe ?';

  @override
  String get legacyUi0f6cc3a89c => 'Ce mois-ci';

  @override
  String get legacyUi77528c94d9 => 'Cette année';

  @override
  String get legacyUi951f495b34 => 'This Action cannot be undone.';

  @override
  String get legacyUi9b646010b8 => 'Ce type de fichier n’est pas autorisé.';

  @override
  String get legacyUi1b4785331d => 'Ce mois-ci';

  @override
  String get legacyUi0e606e3993 =>
      'Ce tableau de bord enregistré ne contient pas encore de widgets.';

  @override
  String get legacyUi1e191e95f4 => 'Ce ticket est fermé.';

  @override
  String get legacyUi8866cb1e0a =>
      'Cette action utilise un crédit du compte lorsque le véhicule est éligible.';

  @override
  String get legacyUi7b72883e07 => 'Cette semaine';

  @override
  String get legacyUi261bd2f51b => 'Conversation du ticket';

  @override
  String get legacyUie1b858991f => 'Ticket créé.';

  @override
  String get legacyUi61322c9a86 => 'Détails du ticket';

  @override
  String get legacyUif1e8e34245 =>
      'Les détails du ticket ne sont pas disponibles';

  @override
  String get legacyUiaa27494c39 => 'Statut du ticket mis à jour.';

  @override
  String get legacyUiedcd363083 => 'Délai dépassé';

  @override
  String get legacyUi768e0c1c69 => 'Titre';

  @override
  String get legacyUie39bf0152d => 'Distance du jour';

  @override
  String get legacyUif43482f042 => 'Heures moteur du jour';

  @override
  String get legacyUi7adacb5405 => 'Changer le statut';

  @override
  String get legacyUi6d91e0bb03 => 'Tolérance';

  @override
  String get legacyUid1bbcb6c01 => 'Tolérance (mètres)';

  @override
  String get legacyUi63cfb27f40 => 'Principaux clients';

  @override
  String get legacyUibc6debbc28 => 'Actifs les plus performants';

  @override
  String get legacyUib25928c699 => 'Total';

  @override
  String get legacyUia672e7faed => 'Total des heures moteur';

  @override
  String get legacyUie9511a6560 => 'Total reçu';

  @override
  String get legacyUia028fce203 => 'Nombre total d’utilisateurs';

  @override
  String get legacyUi5bcce6c936 => 'Nombre total de véhicules';

  @override
  String get legacyUi7b777b27e0 => 'Total des heures moteur';

  @override
  String get legacyUi8578188376 => 'Total des journaux';

  @override
  String get legacyUi0538b10824 => 'QR du lien de suivi';

  @override
  String get legacyUi070fb0b6ea => 'Lien de suivi supprimé.';

  @override
  String get legacyUief1f899cb2 => 'Transaction Détails';

  @override
  String get legacyUi06d8ffe653 => 'ID de transaction';

  @override
  String get legacyUi105b1510d9 =>
      'L’activité des transactions apparaîtra ici lorsqu’elle sera disponible.';

  @override
  String get legacyUid016e453e5 => 'Détails de la transaction';

  @override
  String get legacyUiab39260fea => 'Transitions';

  @override
  String get legacyUic10d76c9a4 => 'Transport';

  @override
  String get legacyUie82c27ca1d => 'Trajet annulé';

  @override
  String get legacyUi4a9e77914e =>
      'Essayez un autre nom ou numéro d’immatriculation.';

  @override
  String get legacyUi4e653834fa =>
      'Essayez une autre recherche ou un autre filtre.';

  @override
  String get legacyUi39d6420eaa => 'Essayez un autre terme de recherche';

  @override
  String get legacyUi0ba628a33e => 'Try a different Rechercher term.';

  @override
  String get legacyUi10239b38b5 =>
      'Essayez de modifier les filtres ou la recherche.';

  @override
  String get legacyUi2253479cff => 'Essayez de modifier vos filtres.';

  @override
  String get legacyUie3f4c649b5 =>
      'Essayez un autre nom ou numéro d’immatriculation.';

  @override
  String get legacyUi10f570e880 =>
      'Essayez de modifier les filtres ou la recherche.';

  @override
  String get legacyUif28432df1f => 'Essayez de modifier les filtres.';

  @override
  String get legacyUi3c86b09439 =>
      'Essayez de modifier la recherche ou les filtres.';

  @override
  String get legacyUi0ba0bd18bf =>
      'Essayez d’effacer la recherche ou les filtres de statut.';

  @override
  String get legacyUi7a2fe508f6 =>
      'Essayez d’actualiser. Si le problème persiste, les préférences de notification de votre compte ne sont peut-être pas encore définies.';

  @override
  String get legacyUia0b470cb00 => 'Twitter / X';

  @override
  String get legacyUi8981df4d6a => 'Twitter/X';

  @override
  String get legacyUi3deb745651 => 'Type';

  @override
  String get legacyUie298b0ec36 => 'Type ';

  @override
  String get legacyUi4b3072dd4e => 'Saisir le contenu de la commande';

  @override
  String get legacyUi5712bb4ea1 => 'Saisir manuellement';

  @override
  String get legacyUi968be8d576 => 'Impossible de modifier le mot de passe.';

  @override
  String get legacyUi1da33a6b30 => 'Impossible de charger les villes.';

  @override
  String get legacyUia4c5468d38 =>
      'Impossible de charger les informations de l’entreprise.';

  @override
  String get legacyUicbae41853b =>
      'Impossible de charger les options du formulaire.';

  @override
  String get legacyUid06763ac1a => 'Impossible de charger les États.';

  @override
  String get legacyUia471ebf750 => 'Impossible de charger les utilisateurs.';

  @override
  String get legacyUibf0bc28bdb => 'Impossible de charger les véhicules.';

  @override
  String get legacyUid73d7a7c96 => 'Impossible de Ouvert Fichier.';

  @override
  String get legacyUi8ace6e9280 => 'Impossible d’ouvrir le sélecteur d’image.';

  @override
  String get legacyUidcbaa0588e =>
      'Impossible d’ouvrir la navigation pour ce véhicule.';

  @override
  String get legacyUi14fdbab84b => 'Impossible d’ouvrir cette pièce jointe.';

  @override
  String get legacyUia457295e9f => 'Impossible de lire l’image sélectionnée.';

  @override
  String get legacyUi9e97e5bfed => 'Impossible d’actualiser les utilisateurs.';

  @override
  String get legacyUi800f200671 => 'Impossible de mettre à jour le statut.';

  @override
  String get legacyUice1c9c972b =>
      'Impossible de mettre à jour le statut du membre d’équipe.';

  @override
  String get legacyUib5f12c7d4f =>
      'Impossible de mettre à jour le membre d’équipe.';

  @override
  String get legacyUia046b8ac56 =>
      'Impossible de mettre à jour l’URL du serveur.';

  @override
  String get legacyUi896bfd3a9a => 'Retirer l’affectation';

  @override
  String get legacyUi7be6acc7f8 => 'Retirer l’affectation de l’utilisateur ?';

  @override
  String get legacyUi05027a8753 => 'Retirer l’affectation de l’utilisateur';

  @override
  String get legacyUi2d5a96092e => 'Retirer l’affectation du véhicule';

  @override
  String get legacyUi39fc721248 => 'Annuler';

  @override
  String get legacyUice77c2f42c => 'Code unique';

  @override
  String get legacyUif6b935ab33 => 'Unité';

  @override
  String get legacyUi07b032b56f => 'Non lu';

  @override
  String get legacyUi100cb4d890 => 'Type de fichier non pris en charge.';

  @override
  String get legacyUicb9925a338 =>
      'Format non pris en charge. Utilisez PNG, JPG, JPEG ou WEBP.';

  @override
  String get legacyUi99974d3476 => 'Widget non pris en charge';

  @override
  String get legacyUieb27a190c0 => 'Non vérifié';

  @override
  String get legacyUi61dcf34e70 => 'Mettre à jour Mot de passe';

  @override
  String get legacyUieae1f5caf5 => 'Mettre à jour le statut';

  @override
  String get legacyUif2f8570ddd => 'mis à jour';

  @override
  String get legacyUi22714274a4 => 'Mis à jour le';

  @override
  String get legacyUi8bdf057f91 => 'Téléverser';

  @override
  String get legacyUi9e2628eec4 => 'Téléverser Document';

  @override
  String get legacyUidcad7d982a => 'Téléversez un document pour commencer.';

  @override
  String get legacyUi73183a7050 => 'Téléverser Document';

  @override
  String get legacyUid714896782 => 'Téléversez les documents de ce véhicule.';

  @override
  String get legacyUi4b87ccd949 =>
      'Téléversez les documents du conducteur, comme son permis ou ses justificatifs d’identité.';

  @override
  String get legacyUi6aafa80cab => 'Durée de fonctionnement';

  @override
  String get legacyUif1f71137de => 'Utilisez un mot de passe fort et unique';

  @override
  String get legacyUid81b6af542 => 'Tout utiliser';

  @override
  String get legacyUi5895bc72eb =>
      'Utilisé pour les valeurs régionales par défaut, comme la devise, le fuseau horaire et les itinéraires.';

  @override
  String get legacyUi81c9245d46 => 'Tickets utilisateur';

  @override
  String get legacyUi81939432dd => 'Actions de l’utilisateur';

  @override
  String get legacyUi0abfc13cb8 => 'Utilisateur affecté.';

  @override
  String get legacyUi6188702f9e => 'Utilisateur créé et sélectionné';

  @override
  String get legacyUi0ba72d0bce => 'Utilisateur supprimé.';

  @override
  String get legacyUi8fd72dd6f9 => 'L’utilisateur est obligatoire';

  @override
  String get legacyUi5ed13310cc => 'L’utilisateur est obligatoire.';

  @override
  String get legacyUib0b238b57a => 'Autorisations utilisateur mises à jour';

  @override
  String get legacyUia42cd2f9d5 => 'Affectation de l’utilisateur retirée.';

  @override
  String get legacyUi2355aced23 => 'Utilisateur mis à jour.';

  @override
  String get legacyUi84c29015de => 'Nom d’utilisateur';

  @override
  String get legacyUib1974b83bc => 'Nom d’utilisateur (facultatif)';

  @override
  String get legacyUi2c7ab350b3 => 'Nom d’utilisateur ou e-mail';

  @override
  String get legacyUi73dbef356e => 'VIN (facultatif)';

  @override
  String get legacyUi39852971ee => 'Numéro VIN';

  @override
  String get legacyUia4aefa35c3 => 'valide';

  @override
  String get legacyUi8dce170de2 => 'Valeur';

  @override
  String get legacyUi7bac966778 => 'Véhicule / Forfait';

  @override
  String get legacyUi43188a5960 => 'Détails d’événement du véhicule';

  @override
  String get legacyUi2d80c33ed3 => 'Véhicule Events';

  @override
  String get legacyUi4d461104bf => 'Véhicule Expiry';

  @override
  String get legacyUi9e47ccbff4 =>
      'L’IMEI du véhicule est nécessaire pour charger les événements.';

  @override
  String get legacyUi2b51e72835 =>
      'L’IMEI du véhicule est nécessaire pour charger les capteurs.';

  @override
  String get legacyUief04c2235a =>
      'L’IMEI du véhicule est nécessaire pour charger les journaux de télémétrie.';

  @override
  String get legacyUi62dc158d0e => 'Véhicule Label';

  @override
  String get legacyUicb4e4154e4 => 'Véhicule Meta';

  @override
  String get legacyUi92dc53a1bc => 'Véhicule Nom';

  @override
  String get legacyUi441399c250 => 'Sélection des véhicules';

  @override
  String get legacyUi2d6ca00998 => 'Type de véhicule';

  @override
  String get legacyUi5c931770ef => 'Actions du véhicule';

  @override
  String get legacyUi6ac26355c9 =>
      'L’activité du véhicule et les journaux système apparaîtront ici.';

  @override
  String get legacyUi4e4942337f => 'Véhicule et forfait';

  @override
  String get legacyUi6ec60a25f7 => 'Véhicule affecté.';

  @override
  String get legacyUia31471cef9 =>
      'Les affectations et mises à jour de véhicules apparaîtront ici.';

  @override
  String get legacyUib7975a2537 => 'Véhicule supprimé.';

  @override
  String get legacyUiff47117f38 => 'Détails du véhicule';

  @override
  String get legacyUia1fbfba50c =>
      'Les détails du véhicule sont indisponibles.';

  @override
  String get legacyUi79c500fa20 => 'Période des événements du véhicule';

  @override
  String get legacyUie981db4fa0 => 'Véhicule events will appear here.';

  @override
  String get legacyUi7eefc642f4 => 'Groupe de véhicules';

  @override
  String get legacyUi5cd0230ee5 => 'L’identifiant du véhicule est manquant.';

  @override
  String get legacyUi39ea43c097 => 'Numéro d’identification du véhicule';

  @override
  String get legacyUida83429197 => 'Véhicule Nom';

  @override
  String get legacyUi750a5503ac => 'Position du véhicule';

  @override
  String get legacyUi40a1e7dd80 => 'La fiche du véhicule n’est pas disponible.';

  @override
  String get legacyUi686853d97d =>
      'Paiement du renouvellement du véhicule envoyé';

  @override
  String get legacyUie1071916e2 => 'Renouvellement du véhicule enregistré.';

  @override
  String get legacyUibf31403ac2 => 'Périmètre de véhicules';

  @override
  String get legacyUi3c760a5151 => 'Service du véhicule';

  @override
  String get legacyUi9aafada9ec =>
      'La version du service du véhicule est indisponible. Rechargez avant de modifier.';

  @override
  String get legacyUia0d9ad9324 => 'Service du véhicule mis à jour';

  @override
  String get legacyUi97d4120359 => 'Services des véhicules';

  @override
  String get legacyUif9709ba7c4 =>
      'La télémétrie du véhicule met automatiquement à jour la progression. La validation manuelle n’est disponible que pour l’arrêt actuel.';

  @override
  String get legacyUi9644381920 => 'Type de véhicule';

  @override
  String get legacyUi8b26242493 => 'Filtre par type de véhicule';

  @override
  String get legacyUi2a37343d0a => 'Affectation du véhicule retirée.';

  @override
  String get legacyUif28657d034 => 'Véhicule indisponible';

  @override
  String get legacyUi917981e400 => 'Véhicule mis à jour.';

  @override
  String get legacyUi02236966b5 => 'Véhicules concernés';

  @override
  String get legacyUi776abb6631 => 'Véhicules affectés.';

  @override
  String get legacyUi433457e28d => 'Impossible de charger les véhicules.';

  @override
  String get legacyUi03128bed90 => 'Vérification';

  @override
  String get legacyUiaed3b8c6a7 => 'Vérifié';

  @override
  String get legacyUidda6ac27b9 => 'Vérifier';

  @override
  String get legacyUi69bd4ef9fb => 'Voir';

  @override
  String get legacyUi5b9306d29c => 'Voir Payments';

  @override
  String get legacyUie3c9374cd6 => 'Afficher tous les trajets';

  @override
  String get legacyUib1614cb4e6 => 'Afficher/Télécharger';

  @override
  String get legacyUi1b6cc58781 => 'Infractions par gravité';

  @override
  String get legacyUi1fe59390ac => 'Visible';

  @override
  String get legacyUi4fc5a421da => 'Visible par l’administrateur';

  @override
  String get legacyUi1448afee1d => 'Visible par le conducteur';

  @override
  String get legacyUib60862f485 => 'Portefeuille';

  @override
  String get legacyUic4fe2a7498 => 'Notifications web';

  @override
  String get legacyUi2e8a57cc5c => 'Site web';

  @override
  String get legacyUib32233ad82 => 'Site web URL';

  @override
  String get legacyUica976c5dc6 => 'Comparaison hebdomadaire';

  @override
  String get legacyUidd322f2dc7 => 'Ouest';

  @override
  String get legacyUib336fc5587 => 'WhatsApp';

  @override
  String get legacyUi16ec75e229 =>
      'Identité affichée dans la boîte de réception des destinataires.';

  @override
  String get legacyUi682d44be54 => 'Avec appareil';

  @override
  String get legacyUi0a58e1d0a2 => 'Écrire une réponse';

  @override
  String get legacyUi126cd2cd36 => 'Écrire une réponse…';

  @override
  String get legacyUib58c0082b4 => 'Vous êtes à jour.';

  @override
  String get legacyUi558865a16f => 'YouTube';

  @override
  String get legacyUid3639ca4df =>
      'Votre compte n’est pas autorisé à consulter cette section.';

  @override
  String get legacyUice100fe123 =>
      'Vos modifications seront perdues. Cette action est irréversible.';

  @override
  String get legacyUi9b3cbed5c4 => 'Zoom';

  @override
  String get legacyUi4fc05f2763 => 'Zoom avant';

  @override
  String get legacyUia4ae4b24a1 => 'Zoom arrière';

  @override
  String get legacyUib6958e3c52 => 'clé API ou nom d’utilisateur';

  @override
  String get legacyUib5f203a910 => 'cmdId';

  @override
  String get legacyUif05135d639 => 'assurance, autorisation';

  @override
  String get legacyUid127ec8ef2 => 'jane@company.com';

  @override
  String get legacyUi216fb6179a => 'km/h, C, V';

  @override
  String get legacyUi7252f9e8d5 => '7 derniers jours';

  @override
  String get legacyUibbdead93fb => 'permis, identité, autorisation';

  @override
  String get legacyUid7cb0327fd => 'permis, assurance';

  @override
  String get legacyUica62660225 => 'noreply@example.com';

  @override
  String get legacyUid043e53c7d => 'queueId';

  @override
  String get legacyUi11c8ce1244 => 'recipient@example.com';

  @override
  String get legacyUi4b329f8934 => 'vitesse, carburant';

  @override
  String get legacyUi65e012062c => 'support@example.com';

  @override
  String get legacyUi0bd41b4761 => 'ce mois-ci';

  @override
  String get legacyUie92d4d638a => 'wk / mo';

  @override
  String get legacyUia126722ec0 => 'À traiter';

  @override
  String get legacyUi51eab2420d => 'Actions du répartiteur';

  @override
  String get legacyUi8bdea32153 => 'Aucune activité pour le moment.';

  @override
  String get legacyUi05e3a866c3 =>
      'Le planning a été enregistré, mais certains trajets n’ont pas pu être générés.';

  @override
  String get legacyUi2924d70976 => 'Date uniquement';

  @override
  String get legacyUi63f39eeeb7 => 'Heure fixe';

  @override
  String get legacyUi6930391c64 => 'Créneau horaire';

  @override
  String get legacyUi601d153162 => 'Sur plusieurs jours';

  @override
  String get legacyUif61eadaf15 => 'En cours';

  @override
  String get legacyUia1bf92eff4 => 'Annulé';

  @override
  String get legacyUic7dfb6f1d9 => 'En pause';

  @override
  String get legacyUi90303d8df2 => 'Terminé';

  @override
  String get legacyUi59f1111618 => 'En trajet';

  @override
  String get legacyUi2b613fb829 => 'Aucune affectation';

  @override
  String get legacyUib564001a58 => 'Manqué';

  @override
  String get legacyUi736d1eee8e => 'Véhicule inactif';

  @override
  String get legacyUif4330844fd => 'Licence du véhicule bloquée';

  @override
  String get legacyUiabf81c35d4 => 'Conducteur requis';

  @override
  String get legacyUi2c9c1f7914 => 'Indisponible';

  @override
  String get legacyUi8e9f1d6e54 => 'Non commencé';

  @override
  String get legacyUi4310ed540c => 'En retard';

  @override
  String get legacyUiaccac60339 => 'Exception du conducteur';

  @override
  String get legacyUi6b535fa681 => 'Aucune télémétrie';

  @override
  String get legacyUi38a9e21ed9 => 'Écart d’itinéraire';

  @override
  String get legacyUi1f5a1abf2f => 'Terminer';

  @override
  String get legacyUi5a436b7939 => 'Ajouter une remarque';

  @override
  String get legacyUi65c821a596 => 'En direct';

  @override
  String get legacyUi189cc40c22 => 'Obsolète';

  @override
  String get legacyUi41c8e43d9e => 'GPS du véhicule';

  @override
  String get legacyUic1220e845b => 'Gestionnaire de flotte';

  @override
  String get legacyUi601f5ff70b => 'Automatisation système';

  @override
  String get legacyUi8b57ec8c92 => 'Affectation créée';

  @override
  String get legacyUi368e5b125f => 'Affectation confirmée';

  @override
  String get legacyUid00c8926f5 => 'Trajet démarré automatiquement';

  @override
  String get legacyUic4b75c3924 => 'Trajet terminé automatiquement';

  @override
  String get legacyUif98c835c4f => 'Trajet terminé par le conducteur';

  @override
  String get legacyUi4bb573b356 => 'Arrivée à l’arrêt détectée automatiquement';

  @override
  String get legacyUi52cd528ad4 => 'Arrêt terminé automatiquement';

  @override
  String get legacyUicf338ebe5c => 'Arrêt terminé par le conducteur';

  @override
  String get legacyUi7ef2940c95 => 'Début de l’écart d’itinéraire';

  @override
  String get legacyUi55d93aed45 => 'Fin de l’écart d’itinéraire';

  @override
  String get legacyUi654c568718 => 'Début de l’absence de télémétrie';

  @override
  String get legacyUi66676d64b0 => 'Fin de l’absence de télémétrie';

  @override
  String get legacyUi2a398797b5 => 'Début de la survitesse';

  @override
  String get legacyUif7d315eb62 => 'Fin de la survitesse';

  @override
  String get legacyUia22d66c857 => 'Arrivé';

  @override
  String get legacyUi5a000ad7bd => 'Ignoré';

  @override
  String get legacyUi4028c0c8b4 => 'Non disponible';

  @override
  String get legacyUi5f174de1cc => 'Justificatif';

  @override
  String get legacyUi4e91ee6122 => 'Fuseau horaire du compte';

  @override
  String get legacyUi4dda6a4505 => 'Nombre total de trajets';

  @override
  String get legacyUi523baab918 => 'À venir';

  @override
  String get legacyUicc6e7b6a29 => 'Retardé';

  @override
  String get legacyUie9fab1cf3a => 'Trajets terminés à l’heure';

  @override
  String get legacyUibbb47a7157 => 'Pourcentage de ponctualité';

  @override
  String get legacyUi944b223791 => 'Distance en km';

  @override
  String get legacyUi7c9352eed6 =>
      'Un court message sera envoyé avec la configuration SMTP actuelle.';

  @override
  String get legacyUid173234df0 =>
      'ACC correspond au câblage/ACC. MOTION correspond à la détection de mouvement utilisée en secours.';

  @override
  String get legacyUi598ed2889b => 'Autorisations d’accès';

  @override
  String get legacyUi9a6d95b0c5 => 'Compte actif';

  @override
  String get legacyUi8d00c06a55 =>
      'Journaux d’activité, d’événements des véhicules et de télémétrie';

  @override
  String get legacyUi61cc55aa04 => 'Ajouter';

  @override
  String get legacyUiee01d7c402 => 'Ajouter un administrateur';

  @override
  String get legacyUib9b1e23f27 => 'Ajouter un utilisateur';

  @override
  String get legacyUif2f8674f8a => 'Ajouter un véhicule';

  @override
  String get legacyUi23a75918ab => 'Adoption et croissance';

  @override
  String get legacyUi80643ec204 => 'Nettoyage avancé';

  @override
  String get legacyUicf963e5241 => 'Filtres avancés';

  @override
  String get legacyUi3aea7b29d9 =>
      'Les rapports avancés ne sont pas disponibles dans la démonstration publique. Connectez-vous avec un compte OpenVTS pour créer, parcourir, visualiser et exporter les rapports de flotte.';

  @override
  String get legacyUi056677c12f => 'Alertes par gravité';

  @override
  String get legacyUif89ae580e8 => 'Tous actors';

  @override
  String get legacyUiaeae2d71be => 'Toutes les alertes';

  @override
  String get legacyUic0e8e58c1a => 'Tous sources';

  @override
  String get legacyUic1cbbe0c5d => 'Écart autorisé';

  @override
  String get legacyUi826499f6b1 =>
      'La couverture annuelle et le service client sont distincts.';

  @override
  String get legacyUi40e69b5db3 => 'Assigned Véhicule';

  @override
  String get legacyUi6771ade6e8 => 'Pièces jointes';

  @override
  String get legacyUi52b258c824 =>
      'Décrivez brièvement le problème et joignez des fichiers si nécessaire.';

  @override
  String get legacyUi2f3b5c55bc => 'Parcourir';

  @override
  String get legacyUi00189ab9b2 => 'Modèle CSV';

  @override
  String get legacyUi19db82215d =>
      'Modifiez votre mot de passe pour sécuriser l’accès au compte.';

  @override
  String get legacyUi3f657f29e6 => 'Choisissez un nouveau mot de passe';

  @override
  String get legacyUicbd1538094 =>
      'Choisissez comment recevoir les alertes des véhicules, de survitesse et de géozone.';

  @override
  String get legacyUic7cd13c042 =>
      'Choisissez les pages et rapports accessibles à cet utilisateur. Les modifications limitent également les accès qu’il peut accorder aux sous-utilisateurs.';

  @override
  String get legacyUibe10f5c042 =>
      'Choisissez ce que ce membre peut consulter, modifier et supprimer. « Propres » s’applique à ses enregistrements ; « Global » s’applique à tout votre compte.';

  @override
  String get legacyUi7834f4a6f4 =>
      'Choisissez les canaux de réception des alertes pour ce groupe de notifications.';

  @override
  String get legacyUic23350ccde => 'Détails de la commande';

  @override
  String get legacyUib2c253ba1c =>
      'Remplissez les sections ci-dessous. Les champs obligatoires sont marqués d’un astérisque (*).';

  @override
  String get legacyUia2b4ac96b2 =>
      'Trajets terminés par date de service. Les affectations à venir sont disponibles dans Trajets.';

  @override
  String get legacyUib3feb31fcb => 'Configurer votre rapport';

  @override
  String get legacyUi878b163022 => 'Confirmer le nettoyage';

  @override
  String get legacyUi9041d3c666 =>
      'Contactez votre administrateur pour affecter des véhicules.';

  @override
  String get legacyUi8e2fc0ffdc =>
      'Créez un profil de connexion simple avec un accès contrôlé.';

  @override
  String get legacyUi93c1ed632d =>
      'Créez et gérez des géozones, points d’intérêt et itinéraires.';

  @override
  String get legacyUie4781f0bde =>
      'Créez et gérez les couloirs d’itinéraires opérationnels.';

  @override
  String get legacyUi6571e94148 =>
      'Créez des liens publics sécurisés pour le suivi des véhicules en direct.';

  @override
  String get legacyUie09271eeb7 => 'Créé : ';

  @override
  String get legacyUidb0d2488de => 'Affectation actuelle';

  @override
  String get legacyUif8ece934c7 => 'Totaux quotidiens de distance';

  @override
  String get legacyUicb47dca7e3 =>
      'Totaux quotidiens pour la période sélectionnée';

  @override
  String get legacyUi71d6e89bcc => 'Conduite de jour et de nuit';

  @override
  String get legacyUi2f3c38363d => 'Supprimer le point d’intérêt ?';

  @override
  String get legacyUi30c6c6352a => 'Supprimer la géozone ?';

  @override
  String get legacyUic6f82fca90 => 'Supprimer l’itinéraire ?';

  @override
  String get legacyUie543c4fd0c => 'Espace de démonstration • Lecture seule';

  @override
  String get legacyUi50dd7fb720 => 'Configuration de l’appareil';

  @override
  String get legacyUi0cf40756a6 =>
      'Dessinez et gérez les limites opérationnelles.';

  @override
  String get legacyUi243f6cfeec => 'Kilomètres parcourus';

  @override
  String get legacyUie30d463652 =>
      'Les détails du conducteur sont indisponibles.';

  @override
  String get legacyUi251b80c58c => 'Abonnement aux e-mails';

  @override
  String get legacyUibe482973b9 => 'Activer SMTP';

  @override
  String get legacyUi21685f000f => 'Terminer cette session sur cet appareil.';

  @override
  String get legacyUide4f0c9387 => 'Filtres d’événements';

  @override
  String get legacyUi6e74f5ccbd => 'Événements par type';

  @override
  String get legacyUi74bbe75120 => 'Expire bientôt';

  @override
  String get legacyUi8d00705083 => 'Date d’expiration';

  @override
  String get legacyUi0da7bfa1a0 => 'Date d’expiration (facultatif)';

  @override
  String get legacyUi86baf678e1 => 'Lignes en échec';

  @override
  String get legacyUi2b1d93a2c6 => 'Filtrer les journaux d’activité';

  @override
  String get legacyUi9a4184cef3 => 'Filtrer par administrateur et période.';

  @override
  String get legacyUi96e578211a => 'Filtres';

  @override
  String get legacyUi5360d40661 => 'Flotte OS';

  @override
  String get legacyUi03d25e01e5 => 'Générer à partir de la recherche';

  @override
  String get legacyUi4d8abbdc5d => 'Générer le rapport';

  @override
  String get legacyUie16305f8b0 => 'Échec de la génération';

  @override
  String get legacyUid81feb6ae1 => 'Charger l’historique';

  @override
  String get legacyUi6fa6308619 =>
      'Recevez une notification lorsque les véhicules affectés s’écartent de l’itinéraire.';

  @override
  String get legacyUi4b6d6a3015 => 'Important';

  @override
  String get legacyUic5288872fd =>
      'Les itinéraires inactifs restent archivés et visibles.';

  @override
  String get legacyUi44caf74675 => 'Boîte de réception';

  @override
  String get legacyUi3f33f2e865 =>
      'Indiquez le chemin complet, par exemple http://192.168.1.10:3000/api';

  @override
  String get legacyUi1919090902 => 'Dernière connexion : ';

  @override
  String get legacyUi1c747b4f98 => 'Dernière action du serveur';

  @override
  String get legacyUi9e1bba7129 => 'Dernière période';

  @override
  String get legacyUi72da77c7b7 =>
      'Les coordonnées en direct ne sont pas disponibles pour ce véhicule.';

  @override
  String get legacyUi3e893cdfd5 =>
      'Chargement des types d’appareils et des fournisseurs…';

  @override
  String get legacyUi93fe7c05af => 'Chargement des types de documents…';

  @override
  String get legacyUi75e940ee30 => 'Chargement de l’historique';

  @override
  String get legacyUi59c3981787 => 'Chargement de l’historique…';

  @override
  String get legacyUibbe4cbd55c => 'Chargement du profil';

  @override
  String get legacyUica88017dfa => 'Chargement du statut d’abonnement…';

  @override
  String get legacyUid1ccf4c3e4 => 'Chargement de Véhicules…';

  @override
  String get legacyUif4e14815b1 => 'Se connecter en tant qu’administrateur';

  @override
  String get legacyUi353bd1ef01 => 'Journaux par catégorie';

  @override
  String get legacyUib2af2f11de => 'Journaux par niveau';

  @override
  String get legacyUi8c97e4f07d =>
      'Gérez les conducteurs et sous-utilisateurs liés à votre flotte.';

  @override
  String get legacyUi41948edc3a =>
      'Gérez les conducteurs, affectations, documents et activités.';

  @override
  String get legacyUi93b23afae0 =>
      'Gérez les lieux importants et les points opérationnels.';

  @override
  String get legacyUi68669149c0 =>
      'Gérez les sous-utilisateurs et leur accès aux véhicules.';

  @override
  String get legacyUi9fcd87c64d =>
      'Gérez les forfaits tarifaires d’abonnement.';

  @override
  String get legacyUi274ef56d8e =>
      'Gérer transactions et renew Véhicule subscriptions';

  @override
  String get legacyUiff92dafaaf =>
      'Gérez les utilisateurs, accès de connexion, contacts et véhicules affectés.';

  @override
  String get legacyUib42578bf99 =>
      'Les paiements manuels mettent à jour les transactions et les statistiques après validation de l’enregistrement.';

  @override
  String get legacyUi421878a774 => 'Données cartographiques © Google';

  @override
  String get legacyUi2cf55e0f5b => 'Détails de la carte';

  @override
  String get legacyUi9a3aa11de5 => 'Type de carte';

  @override
  String get legacyUi09d3670056 =>
      '10 Mo maximum. Formats bloqués : exe, js, html, htm.';

  @override
  String get legacyUife0c6bc7dd => 'Diagnostic des notifications mobiles';

  @override
  String get legacyUif6f444180f =>
      'Monitor uptime, dependencies, et safe service Actions';

  @override
  String get legacyUi1a63cbf994 => 'Nouveau lien';

  @override
  String get legacyUia40ad15529 => 'Nouveau ticket d’assistance';

  @override
  String get legacyUi9f2d2d7331 => 'Aucun type de document USER configuré.';

  @override
  String get legacyUi9ec5ec0752 =>
      'Aucune géozone active : toutes les géozones sont incluses.';

  @override
  String get legacyUi0a181de203 =>
      'Aucun administrateur disponible. Tirez vers le bas pour actualiser et réessayez.';

  @override
  String get legacyUi43f32b9b9d => 'Aucune coordonnée de contact';

  @override
  String get legacyUie55a0728f0 => 'Aucune géozone à prévisualiser';

  @override
  String get legacyUi115fe0fac7 => 'Aucun groupe trouvé';

  @override
  String get legacyUida501f43fd =>
      'Aucune donnée de croissance pour le moment.';

  @override
  String get legacyUi454fe267a7 => 'Aucune métadonnée';

  @override
  String get legacyUi2540cc1f1a =>
      'Aucune demande de renouvellement en attente.';

  @override
  String get legacyUi7cd1d44b3c => 'Aucun enregistrement trouvé.';

  @override
  String get legacyUi658e79f9dc => 'Aucun results trouvé';

  @override
  String get legacyUif018f94f6e =>
      'Aucune ligne ne correspond aux filtres du rapport.';

  @override
  String get legacyUibddbb17fc4 => 'Aucune sélection = tout';

  @override
  String get legacyUi9aba7bbe44 => 'Aucune sélection = toutes les géozones.';

  @override
  String get legacyUifd548f1c32 => 'Aucun capteur configuré pour ce véhicule';

  @override
  String get legacyUi162d1ddec0 => 'Aucune activité d’équipe trouvée.';

  @override
  String get legacyUi8f91f15684 => 'Aucune position GPS valide';

  @override
  String get legacyUi74ac3b3d0d => 'Aucun véhicule affecté.';

  @override
  String get legacyUia26d9edac3 => 'Aucun véhicule affecté à votre compte';

  @override
  String get legacyUie4b1dbf423 => 'Aucun véhicule trouvé.';

  @override
  String get legacyUi6eef664840 => 'Aucun';

  @override
  String get legacyUif8ae6c8bbe => 'Non confirmé';

  @override
  String get legacyUia92e15bc0a => 'Préférences de notification';

  @override
  String get legacyUic71ffe5d22 => 'Délai entre les notifications';

  @override
  String get legacyUicb88cbc310 =>
      'Notifier lorsque le véhicule quitte l’itinéraire';

  @override
  String get legacyUi0049196b0b => 'Déplacer de 10 m';

  @override
  String get legacyUia49d76ddc1 => 'Un véhicule';

  @override
  String get legacyUi0080aaa977 => 'Open VTS';

  @override
  String get legacyUi032a6dcfd8 =>
      'Ouvrez un ticket d’assistance pour consulter toute la conversation.';

  @override
  String get legacyUi50f8c47b2b => 'Ouvrir dans la navigation';

  @override
  String get legacyUi89202c7fd8 => 'Autre document';

  @override
  String get legacyUi27b4bf6d1b =>
      'Les e-mails sortants utilisent ce serveur lorsqu’il est actif.';

  @override
  String get legacyUi619d7adc2c =>
      'Le paiement apparaîtra immédiatement dans la liste des transactions.';

  @override
  String get legacyUidc32a816e9 =>
      'Supprimer définitivement les données historiques antérieures à la durée de conservation.';

  @override
  String get legacyUic2ff2762ca => 'Sélectionnez un fichier.';

  @override
  String get legacyUi3585d74456 => 'Conserver l’expiration actuelle';

  @override
  String get legacyUia9a96ec019 => 'Principal';

  @override
  String get legacyUi668c4636aa => 'Preuve de livraison';

  @override
  String get legacyUif702b26481 => 'Classé par nombre de transactions';

  @override
  String get legacyUid03c65244f => 'Recalculer à partir du forfait';

  @override
  String get legacyUi72d5617f3f => 'Activité récente';

  @override
  String get legacyUi255e5788a2 => 'Récupérer votre compte';

  @override
  String get legacyUi505dddc915 => 'Actualisation';

  @override
  String get legacyUi54dd5046d0 =>
      'L’actualisation remplacera vos modifications de notifications non enregistrées par les derniers paramètres du serveur.';

  @override
  String get legacyUi199ed09ba9 => 'Accès aux rapports';

  @override
  String get legacyUibd7b4f006d => 'Signaler un problème';

  @override
  String get legacyUi8115c55b47 =>
      'Les rapports sont limités en mode démonstration';

  @override
  String get legacyUi6b5890ba0b =>
      'Demandez et confirmez le code à usage unique pour vérifier l’e-mail et le numéro WhatsApp.';

  @override
  String get legacyUif7194e6a0d => 'Demandes';

  @override
  String get legacyUif25bbab45d => 'Prévisions de revenus';

  @override
  String get legacyUiec40affa3e => 'Évolution des revenus';

  @override
  String get legacyUic53c3605a0 =>
      'Examinez les demandes de renouvellement des clients. Confirmez uniquement les paiements réellement reçus en dehors de l’application.';

  @override
  String get legacyUiffbfe1e822 => 'Arrêts de l’itinéraire';

  @override
  String get legacyUi50eec1a359 => 'Résultat de l’exécution';

  @override
  String get legacyUi339225895f =>
      'Le nettoyage supprime les données définitivement. Prévisualisez toujours le résultat avant de lancer l’opération.';

  @override
  String get legacyUifee1dff0c6 => 'En marche et à l’arrêt';

  @override
  String get legacyUi0fb59422f6 => 'Échantillons';

  @override
  String get legacyUide6472b8d3 => 'Sélectionner une période';

  @override
  String get legacyUia35cfe395a => 'Sélectionner un groupe';

  @override
  String get legacyUi2564e1a2c5 => 'Sélectionner un capteur';

  @override
  String get legacyUifea7a520f3 => 'Sélectionner un véhicule';

  @override
  String get legacyUi70037936c0 => 'Sélectionner a ticket';

  @override
  String get legacyUieeaf903bb8 => 'Sélectionnez d’abord un véhicule';

  @override
  String get legacyUiad7a8a1750 =>
      'Sélectionnez un administrateur, décrivez le problème et joignez des fichiers si nécessaire.';

  @override
  String get legacyUi9bb7b69035 => 'Sélectionnez au moins un état';

  @override
  String get legacyUifcfe92e583 => 'Sélectionner le tableau de bord';

  @override
  String get legacyUif9f50c1c30 =>
      'Sélectionnez les véhicules, la période et les filtres, puis générez le rapport pour afficher les résultats.';

  @override
  String get legacyUi0e40d8b0bf => 'Véhicules sélectionnés';

  @override
  String get legacyUi43e146fb62 => 'Serveur Health Monitoring';

  @override
  String get legacyUi644899c565 =>
      'L’expiration du service contrôle le suivi en direct. Contactez votre administrateur pour renouveler. Une demande de renouvellement ne prolonge pas le service tant que le paiement n’est pas confirmé.';

  @override
  String get legacyUi5cbd584046 => 'Services';

  @override
  String get legacyUi758d7f7281 => 'Set Actif';

  @override
  String get legacyUi7c9275ee4b => 'Set Inactif';

  @override
  String get legacyUiddbe3ed1a3 => 'Définir une expiration personnalisée';

  @override
  String get legacyUi7b53693e94 => 'Liens de partage du suivi';

  @override
  String get legacyUidc1649a16c => 'Se déconnecter';

  @override
  String get legacyUi2f32be1dc7 => 'Signature';

  @override
  String get legacyUi51070e69d1 => 'Photo du site';

  @override
  String get legacyUi93773568cf => 'Limite de vitesse';

  @override
  String get legacyUicb672694bb => 'Filtre d’état';

  @override
  String get legacyUi511404ce3b => 'Répartition des statuts';

  @override
  String get legacyUie54e98e0cb => 'Arrêt';

  @override
  String get legacyUie48d04b2b6 =>
      'L’arrêt du Frontend, du Backend ou du Listener peut vous empêcher d’accéder à l’application. Cette page permet de démarrer et redémarrer ces services ; leur arrêt est désactivé.';

  @override
  String get legacyUi16b45ef102 =>
      'Répartition des réussites, attentes et échecs';

  @override
  String get legacyUi12b71c3e0f => 'Résumé';

  @override
  String get legacyUied9177cab1 => 'Mesures système';

  @override
  String get legacyUie20a879f45 =>
      'Touchez pour modifier les notifications de géozone';

  @override
  String get legacyUiac8b906fca => 'Véhicule cible';

  @override
  String get legacyUib644561145 => 'Journal de télémétrie';

  @override
  String get legacyUi7840676a23 => 'Journal de télémétrie';

  @override
  String get legacyUi4ee3736ca6 =>
      'Cette action est irréversible. Le conducteur et ses affectations seront supprimés.';

  @override
  String get legacyUi3575c0aec8 =>
      'Cette action supprime définitivement le sous-utilisateur et révoque son accès aux véhicules. Elle est irréversible.';

  @override
  String get legacyUi7f3d98b829 =>
      'Ce lien ne peut pas être supprimé, car son identifiant est manquant.';

  @override
  String get legacyUi4e81e87c37 =>
      'Cette action supprime définitivement les données antérieures à la durée de conservation. Elle est irréversible.';

  @override
  String get legacyUid8b029df5c =>
      'Ce lien public de suivi cessera immédiatement de fonctionner. Cette action est irréversible.';

  @override
  String get legacyUida735ce16c =>
      'Ce rapport n’est pas disponible pour votre compte.';

  @override
  String get legacyUidf3e8a5fdd =>
      'Ce ticket est fermé ou résolu. Les réponses sont désactivées.';

  @override
  String get legacyUif9c732c3c6 =>
      'Ce ticket est fermé. Une réponse peut le rouvrir ou le passer en cours selon le fonctionnement du serveur.';

  @override
  String get legacyUif3a8370f38 => 'Revenus totaux';

  @override
  String get legacyUie273941b29 => 'Totaux par devise';

  @override
  String get legacyUiaa7d3d7dd9 => 'Historique des transactions';

  @override
  String get legacyUib174443b0e => 'Transactions et revenus';

  @override
  String get legacyUi9dda9aa776 => 'Trajet';

  @override
  String get legacyUic948ed8076 => 'Justificatifs du trajet';

  @override
  String get legacyUid67a44f68d =>
      'Essayez de modifier vos filtres ou la période.';

  @override
  String get legacyUi078f02fe7b => 'Impossible de charger les documents';

  @override
  String get legacyUi3b37311cd6 => 'Impossible de charger l’historique';

  @override
  String get legacyUicaa5bd27e5 => 'Impossible de charger les journaux';

  @override
  String get legacyUi92078d350e => 'Impossible de charger les paiements';

  @override
  String get legacyUi5db77ece1a => 'Impossible de charger le profil';

  @override
  String get legacyUi081863e321 => 'Impossible de charger les tickets';

  @override
  String get legacyUi11f14b7638 =>
      'Mettez à jour l’identité de l’entreprise et ses liens sociaux.';

  @override
  String get legacyUieb58c61a89 =>
      'Mettez à jour vos informations personnelles et votre adresse. Les modifications ne sont enregistrées qu’après confirmation.';

  @override
  String get legacyUid19cf73ae1 => 'Mis à jour : ';

  @override
  String get legacyUi9db8e8ec0b =>
      'Utilisez la liste des véhicules sur la carte en direct, puis choisissez le seuil d’arrêt et la période avec heures.';

  @override
  String get legacyUid337d1a0d6 => 'Aperçu des variables';

  @override
  String get legacyUi63dfad55e0 => 'Informations sur le véhicule';

  @override
  String get legacyUi7f4567c8c2 => 'Véhicule En direct Statut';

  @override
  String get legacyUiceedc505bd => 'Véhicule Statut';

  @override
  String get legacyUi1f41948d84 => 'Événement du véhicule';

  @override
  String get legacyUid3aee04e65 => 'Matrice véhicules-géozones';

  @override
  String get legacyUiefd8355920 => 'Voir Tous';

  @override
  String get legacyUi50ad3280e1 => 'Voir le véhicule';

  @override
  String get legacyUi2c3c7c93f8 =>
      'Consultez les paiements, crédits, débits et données de facturation.';

  @override
  String get legacyUi7d9ff4f0de => 'Visibilité';

  @override
  String get legacyUi79c6a6033a => 'Visible par l’administrateur';

  @override
  String get legacyUied0069155f => 'Visible par l’utilisateur';

  @override
  String get legacyUia56d85fb20 =>
      'Les navigateurs web exigent que le serveur autorise les requêtes inter-origines (CORS). Si la connexion échoue avec une erreur réseau, activez CORS sur votre serveur.';

  @override
  String get legacyUi4dd079044f => 'Trajet complet';

  @override
  String get legacyUi4515b6c7b7 => 'Votre journée';

  @override
  String get legacyUi50f19ac0b4 =>
      'Vos documents et ceux partagés par votre gestionnaire de flotte.';

  @override
  String get legacyUi4e697d55ce =>
      'Vos transactions avec le propriétaire du logiciel.';

  @override
  String get legacyUi678830983a => '— contenu tronqué pour l’affichage —';

  @override
  String legacyUi1e22f79cd9(Object value1) {
    return 'Chargement de $value1';
  }

  @override
  String legacyUi57fdb35e30(Object value1) {
    return '$value1 indisponible';
  }

  @override
  String legacyUi1fd3e5084a(Object value1) {
    return 'Aucun résultat pour $value1';
  }

  @override
  String get legacyUie16f97dcfd => 'Effacer l’historique';

  @override
  String legacyUiabd4cd39b9(Object value1) {
    return '$value1 points';
  }

  @override
  String legacyUi90eaac7e8b(Object value1) {
    return '$value1 arrêts';
  }

  @override
  String legacyUi865d65baea(Object value1) {
    return '$value1 survitesses';
  }

  @override
  String legacyUi7326be7e87(Object value1, Object value2) {
    return '$value1 $value2 max.';
  }

  @override
  String legacyUi5fd7f54937(Object value1, Object value2) {
    return '$value1 $value2 moy.';
  }

  @override
  String legacyUi5f2ee53a4c(Object value1) {
    return '$value1 en marche';
  }

  @override
  String legacyUi5c24a04874(Object value1) {
    return '$value1 à l’arrêt';
  }

  @override
  String legacyUi2b4b82c8bb(Object value1) {
    return 'Durée : $value1';
  }

  @override
  String legacyUi27a82a7136(Object value1) {
    return '$value1 en conduite';
  }

  @override
  String legacyUi92edf7854b(Object value1) {
    return '$value1 véhicules';
  }

  @override
  String get legacyUi5d12bd5355 => 'Lire';

  @override
  String get legacyUi4e39567064 => 'Remarque (facultatif)';

  @override
  String get legacyUi932fc13e7f => 'Titre (facultatif)';

  @override
  String legacyUi2c904359f5(Object value1) {
    return 'Le fichier dépasse la limite de $value1 Mo';
  }

  @override
  String legacyUi66db457b99(Object value1) {
    return 'Format non pris en charge. Formats autorisés : $value1';
  }

  @override
  String get legacyUia7cf7b25a7 => 'Remplacer';

  @override
  String legacyUidf1d5f2730(Object value1) {
    return 'E-mail de test envoyé à $value1';
  }

  @override
  String get legacyUi044b852f30 => 'Afficher le mot de passe';

  @override
  String get legacyUie40123b4e7 => 'Masquer le mot de passe';

  @override
  String get legacyUi82f47c3d4d => 'E-mail verified';

  @override
  String get legacyUib1a273086c => 'WhatsApp vérifié';

  @override
  String legacyUi908e5c8ce5(Object value1) {
    return 'Déconnecté de $value1';
  }

  @override
  String get legacyUi33ce417454 => 'Chargement…';

  @override
  String get legacyUi71ae0ec96e => 'Échec du chargement — réessayer';

  @override
  String get legacyUi67c4d0506a => 'Sans objet';

  @override
  String get legacyUia0b1fb2afb => 'Afficher la confirmation du mot de passe';

  @override
  String get legacyUie2196c3942 => 'Masquer la confirmation du mot de passe';

  @override
  String get legacyUi7c073937c6 => 'Code à usage unique envoyé par e-mail';

  @override
  String get legacyUi8532209c49 => 'Code à usage unique envoyé via WhatsApp';

  @override
  String get legacyUi0d455a4e26 => 'Vérifier l’e-mail';

  @override
  String get legacyUi9cb68a6dd3 => 'Vérifier WhatsApp';

  @override
  String legacyUi8cf58d99c1(Object value1) {
    return 'De $value1';
  }

  @override
  String legacyUif41a1a65a6(Object value1) {
    return 'À $value1';
  }

  @override
  String legacyUia801634da8(Object value1) {
    return '$value1 supprimé.';
  }

  @override
  String legacyUi73f15343e6(Object value1) {
    return 'Connecté en tant que $value1.';
  }

  @override
  String get legacyUi48138f08cd => 'Désactiver l’administrateur';

  @override
  String get legacyUif9494a277e => 'Activer l’administrateur';

  @override
  String get legacyUi13a84a7390 => 'Administrateur activé.';

  @override
  String get legacyUi8181bbb7c7 => 'Administrateur désactivé.';

  @override
  String get legacyUid65ded9428 => 'Désactiver';

  @override
  String get legacyUi92ef08325a => 'Activer';

  @override
  String get legacyUiacfd05ab80 => 'E-mail non vérifié';

  @override
  String get legacyUi23c9dd8809 =>
      'Impossible de charger les véhicules. Réessayez.';

  @override
  String legacyUib089c07088(Object value1) {
    return 'GMT $value1';
  }

  @override
  String legacyUi73585fdb6f(Object value1) {
    return 'Ajouté $value1';
  }

  @override
  String get legacyUi410bebb5ea =>
      'Impossible de charger les documents. Réessayez.';

  @override
  String get legacyUi7f10270c45 =>
      'Impossible de charger les types de documents. Réessayez.';

  @override
  String get legacyUid4c2792a72 => 'Masqué';

  @override
  String get legacyUi1b7cd8a9bf => 'Document mis à jour.';

  @override
  String get legacyUi895a77b095 => 'Document téléversé.';

  @override
  String get legacyUief6604a13d => 'Modifier Document';

  @override
  String get legacyUif6769b696e => 'Crédits ajoutés.';

  @override
  String get legacyUib16dd3b790 => 'Crédits déduits.';

  @override
  String get legacyUie890b12b34 =>
      'Aucune transaction ne correspond à vos filtres';

  @override
  String get legacyUib71113c83a =>
      'Aucun paiement trouvé pour cet administrateur. Essayez d’effacer les filtres.';

  @override
  String get legacyUi472af48c6d =>
      'Enregistrez un paiement manuel pour commencer.';

  @override
  String legacyUi46f7e02bd0(Object value1) {
    return '$value1 copié';
  }

  @override
  String legacyUi70d9eead51(Object value1) {
    return 'L’objet doit contenir au maximum $value1 caractères.';
  }

  @override
  String legacyUifee6584f1b(Object value1) {
    return 'La description doit contenir au maximum $value1 caractères.';
  }

  @override
  String legacyUi830e676993(Object value1) {
    return 'Vous pouvez téléverser jusqu’à $value1 fichiers.';
  }

  @override
  String legacyUi4e5f407ec5(Object value1) {
    return 'Fichier bloqué retiré : $value1';
  }

  @override
  String legacyUib5d0b873d0(Object value1) {
    return 'Fichier non pris en charge retiré : $value1';
  }

  @override
  String legacyUid1740cec1d(Object value1) {
    return 'Le fichier dépasse 5 Mo : $value1';
  }

  @override
  String legacyUie33e0ec27a(Object value1) {
    return 'La réponse doit contenir au maximum $value1 caractères.';
  }

  @override
  String legacyUid9e484645b(Object value1) {
    return 'Le statut du ticket est déjà $value1.';
  }

  @override
  String legacyUiebbf66ef0e(Object value1, Object value2) {
    return 'De : $value1$value2';
  }

  @override
  String legacyUi94cf932307(Object value1) {
    return 'Créé $value1';
  }

  @override
  String legacyUib5ae5701b9(Object value1) {
    return 'Mis à jour $value1';
  }

  @override
  String legacyUi1a150ff203(Object value1) {
    return 'Fermé $value1';
  }

  @override
  String get legacyUiec6952e09b => 'Mise à jour';

  @override
  String legacyUi190040d9d3(Object value1) {
    return 'Certains fichiers dépassent 5 Mo et ont été retirés$value1.';
  }

  @override
  String legacyUi2a432bdd06(Object value1) {
    return 'Agent local : $value1';
  }

  @override
  String get legacyUi3adb8e50db => 'Créez un membre d’équipe pour commencer.';

  @override
  String legacyUiabad5c010f(Object value1) {
    return '$value1 · Autorisations';
  }

  @override
  String get legacyUifb91e24fa5 => 'Mettre à jour';

  @override
  String get legacyUia9d4f0d3b6 =>
      'Impossible de mettre à jour les autorisations';

  @override
  String get legacyUi918bffea2f => 'Afficher le mot de passe actuel';

  @override
  String get legacyUifa0245c379 => 'Masquer le mot de passe actuel';

  @override
  String get legacyUi9a569782b5 => 'Afficher le nouveau mot de passe';

  @override
  String get legacyUiaa10918381 => 'Masquer le nouveau mot de passe';

  @override
  String get legacyUi39b0c83afa =>
      'Afficher la confirmation du nouveau mot de passe';

  @override
  String get legacyUiea6f8ea221 =>
      'Masquer la confirmation du nouveau mot de passe';

  @override
  String legacyUie30362677c(Object value1) {
    return '$value1 enregistrés';
  }

  @override
  String legacyUi060250e9ba(Object value1) {
    return '$value1 factures';
  }

  @override
  String get legacyUi53e337d44c => 'Enregistrer Plan';

  @override
  String get legacyUi4fc636d1bb => 'Forfait mis à jour.';

  @override
  String get legacyUidc5a367e83 => 'Forfait créé.';

  @override
  String get legacyUi2325fc9152 => 'Aucun type de véhicule disponible';

  @override
  String get legacyUi4e4664e8e9 => 'Sélectionner Type de véhicule';

  @override
  String get legacyUi37282b63dd => 'Chargement de Users...';

  @override
  String get legacyUide2b4561e4 => 'Échec de load users';

  @override
  String get legacyUif1b918acaf =>
      'Créer ou sélectionner l’utilisateur principal';

  @override
  String get legacyUic96ec8c8a6 => 'Aucun appareil disponible';

  @override
  String get legacyUieeed87c94b => 'Sélectionner l’appareil GPS';

  @override
  String get legacyUie5a3dc6c41 => 'Aucun forfait disponible';

  @override
  String get legacyUi509d83b55f => 'Sélectionner le forfait tarifaire';

  @override
  String legacyUi91c69c8c0d(Object value1) {
    return 'Véhicule « $value1 » créé.';
  }

  @override
  String get legacyUi048e2d12ad => 'Véhicule désactivé.';

  @override
  String get legacyUib042915cc0 => 'Véhicule activé.';

  @override
  String get legacyUi3741f56c60 => 'Créer Sensor';

  @override
  String get legacyUi996e719712 => 'Enregistrer le capteur';

  @override
  String get legacyUiaa9bf6a127 => 'Impossible de mettre à jour le service';

  @override
  String legacyUif17fe09e18(Object value1) {
    return 'Couverture annuelle renouvelée pour $value1';
  }

  @override
  String get legacyUid55d13471f => 'Échec du renouvellement annuel';

  @override
  String get legacyUi2caa5892b7 => 'Vérification du statut…';

  @override
  String get legacyUid56ae084ba => 'Modifier Document';

  @override
  String get legacyUi47396c4fcf => 'Créez un conducteur pour commencer.';

  @override
  String get legacyUie4c5584c2a => 'Conducteur activé.';

  @override
  String get legacyUi255f9b5d50 => 'Conducteur désactivé.';

  @override
  String legacyUi2c5ad08780(Object value1) {
    return 'Exp. : $value1';
  }

  @override
  String get legacyUifc3606d535 => 'Désactiver le conducteur';

  @override
  String get legacyUic82a768102 => 'Activer le conducteur';

  @override
  String legacyUi3c2dd46009(Object value1) {
    return '$value1 (actuel)';
  }

  @override
  String get legacyUi9e9d25ea74 => 'Sélectionnez d’abord le pays';

  @override
  String get legacyUi789073b300 => 'Sélectionnez d’abord l’État';

  @override
  String get legacyUie0c7a349f8 => 'Désélectionner tous les résultats filtrés';

  @override
  String get legacyUi30a4c62f4d => 'Sélectionner tous les résultats filtrés';

  @override
  String get legacyUi303e32bfd9 => 'Paiement confirmé et service renouvelé';

  @override
  String get legacyUiad3c7489f5 => 'Demande de renouvellement annulée';

  @override
  String get legacyUi91027c0a9a => 'Impossible de mettre à jour la demande';

  @override
  String get legacyUi3fb82cbe4b => 'Rechercher les tickets utilisateur';

  @override
  String get legacyUi3263ab8929 => 'Rechercher dans mes tickets';

  @override
  String get legacyUi24cae41f13 => 'Utilisateur activé.';

  @override
  String get legacyUi48d348ab09 => 'Utilisateur désactivé.';

  @override
  String legacyUi515200de54(Object value1) {
    return '$value1 caractères minimum';
  }

  @override
  String get legacyUiea03fca475 => 'Sélectionnez d’abord un pays';

  @override
  String get legacyUi01d9797a19 => 'Aucun État disponible';

  @override
  String get legacyUic234150a07 => 'Sélectionnez un État';

  @override
  String get legacyUida9ca145a1 => 'Sélectionnez d’abord un État';

  @override
  String get legacyUi12fb8b7d21 => 'Aucune ville disponible';

  @override
  String get legacyUia8ab373cf7 => 'Sélectionnez une ville';

  @override
  String legacyUi99c1db6636(Object value1) {
    return 'Utilisateur « $value1 » créé.';
  }

  @override
  String get legacyUi6ea66e7cf8 => 'Aucun conducteur affecté';

  @override
  String get legacyUi6b4d2e8347 =>
      'Aucun conducteur ne correspond à votre recherche';

  @override
  String legacyUic7a9755928(Object value1) {
    return 'Permis $value1';
  }

  @override
  String get legacyUi530530a405 => 'Aucun conducteur disponible';

  @override
  String legacyUied9f265a0a(Object value1) {
    return 'Rechercher $value1…';
  }

  @override
  String get legacyUia269afc99c => 'Aucun Tickets trouvé';

  @override
  String get legacyUifd0ab9a284 =>
      'Aucun ticket ne correspond à votre recherche';

  @override
  String legacyUic93cd16b9b(Object value1) {
    return 'Dernier : $value1';
  }

  @override
  String legacyUib68af38cf0(Object value1) {
    return 'Le ticket est déjà $value1.';
  }

  @override
  String get legacyUi9ddc709693 => 'Désactiver l’utilisateur';

  @override
  String get legacyUiaebaaf50f8 => 'Activer l’utilisateur';

  @override
  String get legacyUi8ed321fdf0 => 'Impossible d’enregistrer les autorisations';

  @override
  String get legacyUi51c4b07667 => 'Aucun Véhicules match your Rechercher';

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
    return 'Expiration $value1';
  }

  @override
  String get legacyUif0dc6b09f8 => 'Aucun véhicule disponible';

  @override
  String get legacyUi39d436aaba => 'Sans expiration';

  @override
  String get legacyUic15c47e4c9 =>
      'Rechercher par IMEI, type d’appareil, numéro SIM…';

  @override
  String get legacyUibc139b1c14 =>
      'Rechercher par SIM, IMSI, ICCID, fournisseur…';

  @override
  String get legacyUiaa729739dd => 'Aucun appareil trouvé';

  @override
  String get legacyUi679d782d32 => 'Aucune carte SIM trouvée';

  @override
  String get legacyUi613b9215a5 =>
      'Ajoutez des articles au stock pour commencer.';

  @override
  String get legacyUi9f91b0dc33 => 'Chargement de Appareil types...';

  @override
  String legacyUi9ba6bfee17(Object value1) {
    return 'Valeurs sûres par défaut utilisées. $value1';
  }

  @override
  String get legacyUi2919b3cdf5 => 'E-mail en attente';

  @override
  String get legacyUidfd4099c87 => 'WhatsApp en attente';

  @override
  String legacyUif0dd87cef8(Object value1) {
    return 'Passer à l’onglet $value1';
  }

  @override
  String legacyUi364cdce6f9(Object value1) {
    return '$value1 crédits';
  }

  @override
  String get legacyUi070e328ec8 => 'Téléversement…';

  @override
  String get legacyUie8d33553f6 => 'Modifier l’avatar';

  @override
  String legacyUi56b3825e50(Object value1) {
    return 'Appliquer le préréglage $value1';
  }

  @override
  String get legacyUi28e40daab7 => 'Nouvel envoi…';

  @override
  String get legacyUib707b694b2 => 'Renvoyer le code';

  @override
  String legacyUia648c7bbe2(Object value1) {
    return 'Sélecteur de $value1';
  }

  @override
  String get legacyUidd1242a8fc => 'Abonné';

  @override
  String get legacyUibbf5d78203 => 'Non abonné';

  @override
  String get legacyUi0e42454279 => 'Tous les véhicules';

  @override
  String get legacyUi12e7d6beac => 'Source inconnue';

  @override
  String get legacyUifb2269d326 => 'Aucun véhicule opérationnel disponible.';

  @override
  String get legacyUi9dd705b078 => 'Aucun véhicule disponible.';

  @override
  String legacyUi8879fce2e7(Object value1, Object value2) {
    return '$value1 véhicule$value2 bloqué(s) exclu(s).';
  }

  @override
  String legacyUif039d146e6(Object value1) {
    return '$value1 véhicules affectés';
  }

  @override
  String get legacyUi02b460b2cf => 'Aucun véhicule correspondant';

  @override
  String get legacyUi537da7f70e =>
      'Tous les véhicules sont déjà affectés à ce sous-utilisateur.';

  @override
  String get legacyUif614a2e6b5 => 'Essayez une autre recherche.';

  @override
  String get legacyUi28516f977e => 'Sous-utilisateur désactivé.';

  @override
  String get legacyUi7841e93192 => 'Sous-utilisateur activé.';

  @override
  String get legacyUi87e328dc94 => 'Effacer la recherche';

  @override
  String get legacyUi72556ffa55 => 'Visible par le conducteur';

  @override
  String get legacyUi355f129929 => 'Masqué pour le conducteur';

  @override
  String get legacyUib68e795ff9 => 'Changer de véhicule';

  @override
  String get legacyUi0cb329674a => 'Visible dans les documents utilisateur';

  @override
  String get legacyUi7ab98ca9b9 => 'Masqué dans les documents utilisateur';

  @override
  String get legacyUi5f22178640 => 'Le conducteur peut voir ce document';

  @override
  String get legacyUiaf7ad5ad5c => 'Le conducteur ne peut pas voir ce document';

  @override
  String get legacyUib544cc3e95 => 'Aucun véhicule non affecté';

  @override
  String get legacyUidf10a27148 => 'Tous les véhicules sont déjà affectés.';

  @override
  String get legacyUic3763af773 => 'Non mis à jour';

  @override
  String get legacyUia1f5a8dbd3 => 'Aucun capteur trouvé';

  @override
  String get legacyUi6a3625800c =>
      'Aucun capteur n’est configuré pour ce véhicule.';

  @override
  String get legacyUi5fdd1b0855 => 'Paramètres du capteur';

  @override
  String get legacyUi2524c34a0d => 'Nouveau capteur';

  @override
  String get legacyUiae7e887517 => 'Enregistrement...';

  @override
  String get legacyUi126eda8b21 => 'En marche...';

  @override
  String get legacyUi7745774c38 => 'Capteur créé.';

  @override
  String get legacyUi2a367dafb5 => 'Capteur mis à jour.';

  @override
  String get legacyUi4abc320492 => 'Chargement de la configuration';

  @override
  String get legacyUic0ae8f6ea8 => 'Enregistré';

  @override
  String get legacyUif352418f58 => 'Chargement des types…';

  @override
  String get legacyUi82385d8917 => 'Chargement des fuseaux horaires…';

  @override
  String get legacyUi22e6340f2c => 'Sélectionner timezone';

  @override
  String get legacyUicc4889261c => 'Recharger l’historique';

  @override
  String get legacyUi9e8a1c5b7b => 'Chargement de Capteurs…';

  @override
  String legacyUic0a743750e(Object value1) {
    return 'Sélectionnez la période du rapport $value1';
  }

  @override
  String legacyUi26362a69a0(Object value1) {
    return 'En marche : $value1';
  }

  @override
  String legacyUicbbef93382(Object value1) {
    return 'À l’arrêt : $value1';
  }

  @override
  String legacyUic1d252d58b(Object value1) {
    return '$value1 — Survitesse';
  }

  @override
  String legacyUidf3ab0c2d9(Object value1) {
    return 'Jour : $value1';
  }

  @override
  String legacyUi20076143b6(Object value1) {
    return 'Nuit : $value1';
  }

  @override
  String legacyUie296339b1e(Object value1, Object value2) {
    return '$value1 trajet$value2';
  }

  @override
  String legacyUib4c5c14ddb(Object value1) {
    return 'Max. $value1 km/h';
  }

  @override
  String legacyUi491fa657c5(Object value1, Object value2) {
    return '$value1 : $value2 km';
  }

  @override
  String legacyUia6587e8e7b(Object value1) {
    return 'Distance par véhicule (les $value1 premiers)';
  }

  @override
  String legacyUi6eca89289b(Object value1) {
    return '$value1 km/h';
  }

  @override
  String legacyUib9a5d6824c(Object value1, Object value2) {
    return 'Géozone $value1 pour $value2';
  }

  @override
  String legacyUi4d24bcb058(Object value1, Object value2) {
    return 'Limite de survitesse ($value1) pour $value2';
  }

  @override
  String get legacyUi56a2285c5b => 'Enregistrement…';

  @override
  String legacyUia1f38b12bb(Object value1) {
    return 'Commutateur $value1';
  }

  @override
  String legacyUic3b516d33c(Object value1) {
    return '$value1 géozones';
  }

  @override
  String get legacyUi010f99630a => 'Modifier le lien de suivi';

  @override
  String get legacyUibb53b1c483 => 'Nouveau lien de suivi';

  @override
  String legacyUi9287b718c6(Object value1) {
    return '$value1 sélectionné(s)';
  }

  @override
  String get legacyUib948ff19e4 => 'Déverrouiller le carré';

  @override
  String get legacyUi85a3ef0c3f => 'Verrouiller le carré';

  @override
  String get legacyUi9dd7a6b201 => 'Créer une géozone';

  @override
  String get legacyUidccb573a71 => 'Dessiner un itinéraire';

  @override
  String legacyUi4c91961249(Object value1) {
    return 'Téléverser $value1 lignes';
  }

  @override
  String legacyUi0ff9c73519(Object value1) {
    return '$value1 valides';
  }

  @override
  String legacyUifa7ec0ed62(Object value1) {
    return '$value1 invalides';
  }

  @override
  String legacyUi1483db1240(Object value1) {
    return '$value1 réussies';
  }

  @override
  String legacyUi2c661fac7f(Object value1) {
    return '$value1 en échec';
  }

  @override
  String get legacyUi7e613c0b85 => 'Placer un point d’intérêt';

  @override
  String get legacyUi4405592a72 => 'Déplacer le point d’intérêt';

  @override
  String get legacyUi91fbb41bfb => 'Utiliser cette position';

  @override
  String get legacyUif05f282071 =>
      'Touchez la carte pour placer un point d’intérêt';

  @override
  String get legacyUie8f485c68a =>
      'Essayez de modifier les filtres ou la période.';

  @override
  String get legacyUia0c0bb9e85 =>
      'Aucune transaction disponible pour cette période.';

  @override
  String legacyUid7d6dade2a(Object value1) {
    return 'Réussite $value1';
  }

  @override
  String legacyUi3a0d457cee(Object value1) {
    return 'En attente $value1';
  }

  @override
  String legacyUi07d104432b(Object value1) {
    return 'Échec $value1';
  }

  @override
  String get legacyUi3fb75e3bfe => 'Réinitialiser le mot de passe';

  @override
  String get legacyUif99d98e85f => 'Mot de passe oublié';

  @override
  String get legacyUi0d2afda86b => 'Espace de démonstration ouvert';

  @override
  String get legacyUif06ccf010d => 'Connexion réussie';

  @override
  String get legacyUifc45091249 => 'Passer au mode clair';

  @override
  String get legacyUic29220f958 => 'Passer au mode sombre';

  @override
  String get legacyUi257616b8e4 => 'Aucune notification non lue';

  @override
  String get legacyUid2609b6af1 => 'Aucun Notifications pour le moment.';

  @override
  String get legacyUi04d956a670 =>
      'Tout est marqué comme lu. Les nouvelles alertes apparaîtront ici dès leur réception.';

  @override
  String get legacyUi7fe220bd95 =>
      'Les alertes des véhicules, événements système et mises à jour opérationnelles apparaîtront ici.';

  @override
  String get legacyUib2f3a86e84 => 'Tout est lu';

  @override
  String get legacyUicbf6939e9e => 'Marquage…';

  @override
  String get legacyUi8958e22c23 => 'Tout marquer comme lu';

  @override
  String legacyUicb9ae54e8a(Object value1, Object value2) {
    return 'Affichage de $value1 sur $value2';
  }

  @override
  String legacyUie5b28b8ae4(Object value1, Object value2) {
    return 'Page $value1 sur $value2';
  }

  @override
  String get legacyUic1d317a815 => 'Aucun ticket correspondant';

  @override
  String get legacyUiae9e814889 => 'Aucun Tickets';

  @override
  String get legacyUicc80739f43 =>
      'Essayez une autre recherche ou un autre filtre de statut.';

  @override
  String get legacyUib1ac2d29f2 =>
      'Créez un ticket et l’équipe vous répondra ici.';

  @override
  String legacyUia6864fdac8(Object value1) {
    return '$value1 lignes';
  }

  @override
  String get legacyUi8f26c6520d => 'Chargement';

  @override
  String legacyUie7a93c340a(Object value1) {
    return '$value1 événements';
  }

  @override
  String get legacyUia4ab77ad86 => 'Événement OpenVTS';

  @override
  String get legacyUif55aae5a86 => 'IMEI indisponible';

  @override
  String get legacyUib8eb4a7ee3 => 'Chargement des commandes…';

  @override
  String get legacyUif7933da683 => 'Aucune commande compatible';

  @override
  String get legacyUi4be4430e57 => 'Sélectionner une commande';

  @override
  String legacyUi70ac5dd63e(Object value1) {
    return 'CHRONOLOGIE ($value1)';
  }

  @override
  String legacyUi24d8fbef9d(Object value1, Object value2) {
    return '$value1 ${value2}x';
  }

  @override
  String legacyUibde2a7e880(Object value1, Object value2, Object value3) {
    return 'Page $value1 sur $value2 · $value3 trajets';
  }

  @override
  String legacyUi08343b3fe7(Object value1) {
    return '$value1 restants';
  }

  @override
  String legacyUi843b148bbc(Object value1) {
    return 'Arrivée prévue : $value1';
  }

  @override
  String legacyUi46d11990c5(Object value1) {
    return 'Position mise à jour $value1';
  }

  @override
  String legacyUiecd87f34a4(Object value1) {
    return 'Supprimer $value1 ?';
  }

  @override
  String legacyUi666b616488(Object value1) {
    return 'Expire $value1';
  }

  @override
  String get legacyUic7ac551ef0 => 'Suppression...';

  @override
  String legacyUi27015ac78b(Object value1, Object value2) {
    return '$value1 non lues · $value2 dernières notifications';
  }

  @override
  String legacyUi46b0a7d4ca(Object value1, Object value2) {
    return '$value1 / $value2 arrêts terminés';
  }

  @override
  String get legacyUidc7f2c3785 => 'Date indisponible';

  @override
  String get legacyUib11b062b52 => 'Téléverser un justificatif de trajet';

  @override
  String get legacyUi8f1a9ca44a => 'PDF, JPG, PNG ou WebP · Jusqu’à 5 Mo';

  @override
  String get legacyUi91df716a6b =>
      'PDF, JPG, PNG, WebP, DOC ou DOCX · Jusqu’à 5 Mo';

  @override
  String get legacyUid921a79afa => 'Téléversement…';

  @override
  String legacyUiba9b85b92a(Object value1) {
    return 'Dernière mise à jour $value1';
  }

  @override
  String legacyUib9f8dfe265(Object value1) {
    return 'Distance du jour : $value1';
  }

  @override
  String legacyUif0ea529a1a(Object value1) {
    return '$value1 jours';
  }

  @override
  String legacyUi387c4ee271(Object value1, Object value2) {
    return '$value1  ·  $value2 jours';
  }

  @override
  String get legacyUideba3e1d0f => 'Résumé de la simulation';

  @override
  String get legacyUia7d0c36803 => 'Dernier nettoyage';

  @override
  String legacyUia24243eb0c(Object value1) {
    return 'Tables ($value1)';
  }

  @override
  String get legacyUic74a3012a0 => 'Vérification du statut…';

  @override
  String get legacyUie991a76914 => 'Statut inconnu';

  @override
  String get legacyUia722bd6476 =>
      'Croissance des utilisateurs, véhicules et licences de la plateforme.';

  @override
  String legacyUi852c487a99(Object value1) {
    return 'Pic de licences : $value1';
  }

  @override
  String legacyUic44efcae53(Object value1) {
    return 'Supprimer $value1 de la plateforme ? Cette action est irréversible.';
  }

  @override
  String legacyUicac4f1ac56(Object value1) {
    return '$value1 administrateur';
  }

  @override
  String legacyUi68401f3c9e(Object value1, Object value2) {
    return 'Moyenne de $value1 $value2 par transaction';
  }

  @override
  String get legacyUi526698fef7 => 'Impossible d’actualiser les véhicules.';

  @override
  String legacyUie9b7179dd3(Object value1) {
    return 'Documents ($value1)';
  }

  @override
  String get legacyUiefd8314874 => 'Impossible d’actualiser les documents.';

  @override
  String get legacyUie214b8a299 => 'Document';

  @override
  String legacyUidb4675bc22(Object value1) {
    return 'Solde : $value1';
  }

  @override
  String legacyUi16be827cb6(Object value1) {
    return 'Véhicule $value1';
  }

  @override
  String get legacyUibd5caf1601 =>
      'Le suivi est bloqué par la limite de licence du logiciel.';

  @override
  String get legacyUid8663517be => 'Dernière vérification : —';

  @override
  String get legacyUi1be0035c25 => 'Propres';

  @override
  String get legacyUi5f1184f7df => 'Global';

  @override
  String get legacyUif5f940cfe2 => 'Enregistrer les autorisations';

  @override
  String legacyUi8a9135d5ad(Object value1) {
    return '$value1 % encaissés';
  }

  @override
  String legacyUi3b0c54fa00(Object value1) {
    return 'Prévisionnel : $value1';
  }

  @override
  String legacyUi16ff2e7fa9(Object value1) {
    return 'Écart : $value1';
  }

  @override
  String legacyUi4956298616(Object value1, Object value2) {
    return '$value1 véh. · $value2';
  }

  @override
  String legacyUi120d777276(Object value1) {
    return 'Payé : $value1';
  }

  @override
  String legacyUi617d0ebe3d(Object value1, Object value2) {
    return '$value1 forfaits sur $value2';
  }

  @override
  String get legacyUi25422daedb => 'Véhicule sans nom';

  @override
  String legacyUicbbe928bb9(Object value1) {
    return 'Couverture annuelle : $value1';
  }

  @override
  String legacyUiec60ebb81f(Object value1) {
    return 'Service client : $value1';
  }

  @override
  String legacyUiced28bc228(Object value1) {
    return 'Crédits du compte : $value1';
  }

  @override
  String get legacyUic1a90693df => 'Suivi en direct actif';

  @override
  String legacyUi4bdc33e519(Object value1, Object value2) {
    return '$value1 · $value2 jours';
  }

  @override
  String get legacyUi889f282a7d => 'Choisir la date et l’heure';

  @override
  String get legacyUi83cbbbc297 => 'Enregistrer les modifications du service';

  @override
  String get legacyUi69feaaf8cd => 'Toutes les dates';

  @override
  String get legacyUi0c6c4102d4 => 'Facultatif';

  @override
  String legacyUic57882f9c9(Object value1) {
    return 'Statut : $value1';
  }

  @override
  String legacyUiae3c1f8817(Object value1) {
    return 'Envoyer cette commande à $value1 ?';
  }

  @override
  String legacyUic51f739b4e(Object value1) {
    return 'Utilisateurs affectés ($value1)';
  }

  @override
  String get legacyUibc7819b34f => 'Inconnu';

  @override
  String legacyUi46aece3259(Object value1) {
    return 'Retirer $value1 de ce véhicule ?';
  }

  @override
  String legacyUi3d2bb84b75(Object value1, Object value2) {
    return 'Valeur en direct : $value1 $value2';
  }

  @override
  String legacyUieb3a3daafa(Object value1) {
    return 'Code : $value1';
  }

  @override
  String legacyUi93aa5178d6(Object value1) {
    return 'Type de document : $value1';
  }

  @override
  String legacyUi0e12da1c5e(Object value1) {
    return 'Fichier : $value1';
  }

  @override
  String legacyUi3ce1585208(Object value1) {
    return 'Expiration : $value1';
  }

  @override
  String legacyUiaeafae8a12(Object value1) {
    return 'Visibilité : $value1';
  }

  @override
  String legacyUi39d7217391(Object value1) {
    return 'Étiquettes : $value1';
  }

  @override
  String legacyUi4439ddf5a2(Object value1) {
    return 'Créé : $value1';
  }

  @override
  String legacyUid5c6adaee3(Object value1) {
    return 'Retirer $value1 de ce conducteur ?';
  }

  @override
  String get legacyUieb7eb7a819 => 'Choisir un fichier';

  @override
  String get legacyUi8f8dd8dbd3 => 'Masqué pour l’administrateur';

  @override
  String get legacyUi65d06317e9 =>
      'Les administrateurs peuvent voir ce document';

  @override
  String get legacyUic0e9577a75 => 'Visible uniquement par le propriétaire';

  @override
  String legacyUi864cf8bc08(Object value1) {
    return 'Attributs : $value1';
  }

  @override
  String legacyUi90d40c4249(Object value1) {
    return 'Données brutes : $value1';
  }

  @override
  String get legacyUia4d06ed284 => 'Événement du véhicule';

  @override
  String legacyUifba61e1a50(Object value1, Object value2, Object value3,
      Object value4, Object value5, Object value6) {
    return '$value1 • $value2 • envoyé $value3 • livré $value4 • nouvelle tentative $value5$value6';
  }

  @override
  String legacyUi9c07a085f8(Object value1, Object value2) {
    return '$value1 transactions sur $value2';
  }

  @override
  String legacyUi26b3b5dfb3(Object value1) {
    return '$value1 nouvelle tentative';
  }

  @override
  String legacyUi05563fda41(Object value1, Object value2, Object value3) {
    return 'Forfait : $value1 • $value2 $value3';
  }

  @override
  String legacyUi26400a7353(Object value1, Object value2) {
    return '$value1 véhicule$value2 sélectionné(s)';
  }

  @override
  String legacyUi8f4ab245d3(Object value1, Object value2) {
    return 'Total automatique : $value1 $value2';
  }

  @override
  String get legacyUi493de0b548 => 'Devis expiré';

  @override
  String legacyUi78218dbd5f(Object value1, Object value2, Object value3) {
    return '$value1 · $value2 · $value3 jours';
  }

  @override
  String legacyUi13e7357d18(Object value1) {
    return 'J’ai reçu $value1';
  }

  @override
  String get legacyUi7e72a446c4 => 'Masquer les filtres de paiement';

  @override
  String get legacyUi8f642c1d28 => 'Afficher les filtres de paiement';

  @override
  String legacyUi184c3f0cbb(Object value1) {
    return 'ID de transaction : $value1';
  }

  @override
  String legacyUi281961b9ee(Object value1) {
    return 'Montant : $value1';
  }

  @override
  String legacyUib40416c0af(Object value1) {
    return 'Type de paiement : $value1';
  }

  @override
  String legacyUia0d65517a6(Object value1) {
    return 'Mode de paiement : $value1';
  }

  @override
  String legacyUic2d62e9f71(Object value1) {
    return 'Référence : $value1';
  }

  @override
  String legacyUib0f627962a(Object value1) {
    return 'Fournisseur : $value1';
  }

  @override
  String legacyUie802a1b0a0(Object value1) {
    return 'Réf. fournisseur : $value1';
  }

  @override
  String legacyUi2751887374(Object value1) {
    return 'De : $value1';
  }

  @override
  String legacyUi250106ee83(Object value1) {
    return 'À : $value1';
  }

  @override
  String legacyUi5ff8e9357b(Object value1) {
    return 'Enregistré par : $value1';
  }

  @override
  String legacyUi7565bbdff9(Object value1) {
    return 'Véhicule : $value1';
  }

  @override
  String legacyUi2b542f8050(Object value1) {
    return 'IMEI : $value1';
  }

  @override
  String legacyUi76e24a00cf(Object value1) {
    return 'Forfait : $value1';
  }

  @override
  String legacyUi972db7d65e(Object value1) {
    return 'Code d’échec : $value1';
  }

  @override
  String legacyUif147c11396(Object value1) {
    return 'Message d’échec : $value1';
  }

  @override
  String get legacyUic3146cdbec =>
      'Créez un ticket pour démarrer une conversation avec l’assistance.';

  @override
  String legacyUi2cbdc50885(Object value1) {
    return 'Retirer $value1 de ce compte administrateur ?';
  }

  @override
  String legacyUi073ab8a05c(Object value1, Object value2) {
    return '$value1 affectés - $value2 disponibles';
  }

  @override
  String legacyUidcc59f9fcf(Object value1) {
    return 'Sélectionner $value1';
  }

  @override
  String get legacyUi7a19b6deae => 'Aucune option disponible';

  @override
  String get legacyUif28cfb8eb0 => '1 ticket';

  @override
  String legacyUidf08f563b7(Object value1) {
    return 'Fichiers facultatifs, jusqu’à $value1.';
  }

  @override
  String get legacyUi5f2b4010d1 => '1 paiement';

  @override
  String get legacyUi876081608a => 'Renouvellement — 1 véhicule';

  @override
  String legacyUia034f3f5e5(Object value1) {
    return 'Total estimé : $value1';
  }

  @override
  String legacyUic07d143675(Object value1) {
    return 'Véhicules renouvelés ($value1)';
  }

  @override
  String legacyUiff384c8aa4(Object value1) {
    return 'Retirer $value1 de cet utilisateur ?';
  }

  @override
  String legacyUicb6d241451(Object value1, Object value2) {
    return '$value1 fichiers - $value2 types utilisateur';
  }

  @override
  String get legacyUif63f04564a => 'Chargement des types utilisateur';

  @override
  String get legacyUi74b1d89d85 => 'Choisir un fichier';

  @override
  String get legacyUi62783d600b => 'Affiché dans les documents utilisateur';

  @override
  String get legacyUi38fc177e28 => 'Masqué pour l’utilisateur';

  @override
  String legacyUibce346e856(Object value1, Object value2) {
    return '$value1 utilisateur$value2';
  }

  @override
  String get legacyUi674b652fca => 'Modifier les dates';

  @override
  String get legacyUi08d0e4f72a => 'Chargement des transactions…';

  @override
  String get legacyUib3a56d64d2 =>
      'Aucune transaction ne correspond à ces filtres.';

  @override
  String get legacyUi049ac820da => 'Traitement…';

  @override
  String legacyUie783127bc1(Object value1) {
    return 'Inscrit $value1';
  }

  @override
  String legacyUieb587f7802(Object value1) {
    return 'Profil mis à jour $value1';
  }

  @override
  String get legacyUi1dfc507715 =>
      'Les listes de pays et d’indicatifs mobiles sont indisponibles. La saisie manuelle reste possible.';

  @override
  String get legacyUia7c1498ab2 =>
      'Vous êtes abonné aux notifications de profil par e-mail.';

  @override
  String get legacyUi77653a7db4 =>
      'Abonnez-vous pour recevoir les mises à jour de profil et de compte par e-mail.';

  @override
  String get legacyUid3b8add13e => 'Options indisponibles.';

  @override
  String legacyUi08b544b680(Object value1) {
    return 'Parcouru : $value1';
  }

  @override
  String legacyUi6c783ae69f(Object value1) {
    return 'Affichage de 10 des $value1 dernières alertes';
  }

  @override
  String get legacyUi45ef37a941 => 'Aucun message fourni.';

  @override
  String get legacyUia2ae39a298 => 'Canal inconnu';

  @override
  String get legacyUiceafde86d6 => 'Envoi';

  @override
  String get legacyUi46cefb25e2 => 'Envoyer command';

  @override
  String legacyUib3d1704245(Object value1) {
    return 'Plage de jour : $value1';
  }

  @override
  String legacyUi735f148a9a(Object value1) {
    return 'Type : $value1';
  }

  @override
  String legacyUi828a91effc(Object value1, Object value2, Object value3) {
    return '$value1 véhicules sur $value2 • $value3 sélectionnés';
  }

  @override
  String legacyUia0ebdc2307(Object value1, Object value2, Object value3) {
    return '$value1 visibles • $value2/$value3 chargés';
  }

  @override
  String legacyUi1d483a1343(Object value1) {
    return 'Retirer $value1 de ce sous-utilisateur ?';
  }

  @override
  String legacyUi02b84d460d(Object value1) {
    return '$value1 disponibles à affecter';
  }

  @override
  String get legacyUi65ad788d45 => 'Immatriculation indisponible';

  @override
  String get legacyUi7bb4f2808b =>
      'Le sous-utilisateur peut accéder aux véhicules affectés';

  @override
  String get legacyUi26b21a0d91 => 'Le sous-utilisateur est désactivé';

  @override
  String legacyUibceb1630f0(Object value1, Object value2) {
    return '$value1 fichiers - $value2 types de documents';
  }

  @override
  String get legacyUi107b9056eb => 'Chargement des types conducteur';

  @override
  String legacyUifd7e37cf51(Object value1, Object value2) {
    return '$value1 conducteurs sur $value2';
  }

  @override
  String legacyUi14b274c7ae(Object value1, Object value2) {
    return '$value1 véhicules sur $value2';
  }

  @override
  String legacyUi79a100acf7(Object value1) {
    return 'Retirer $value1 ?';
  }

  @override
  String legacyUi26875fe2e3(Object value1, Object value2) {
    return '$value1 fichiers - $value2 types de véhicules';
  }

  @override
  String legacyUi7970bd3e0b(Object value1) {
    return 'Impossible de charger $value1.';
  }

  @override
  String get legacyUi5eaf2646c3 => 'Chargement des types de véhicules';

  @override
  String get legacyUi6ca60537ae => 'Affiché dans les documents du véhicule';

  @override
  String get legacyUi4e3d045a97 => 'Masqué pour les utilisateurs';

  @override
  String get legacyUid3ce77345e => 'Historique du capteur';

  @override
  String legacyUi5aba89cd2f(Object value1) {
    return '$value1 points numériques';
  }

  @override
  String get legacyUie86a33f16a => 'Toutes les géozones';

  @override
  String legacyUi5321a316d0(Object value1) {
    return 'Source : $value1';
  }

  @override
  String legacyUifabeb88d9c(Object value1) {
    return 'Utiliser les $value1 éléments sélectionnés';
  }

  @override
  String legacyUi343ceded71(Object value1) {
    return 'Événements par géozone (les $value1 premières)';
  }

  @override
  String legacyUide36170209(Object value1) {
    return 'Types d’alertes (les $value1 premiers)';
  }

  @override
  String legacyUi019e5212ef(Object value1, Object value2) {
    return '$value1 km/h (limite $value2)';
  }

  @override
  String legacyUicaae0add4a(Object value1, Object value2) {
    return '$value1 jour$value2 actif(s)';
  }

  @override
  String legacyUi7911e1ad0c(Object value1, Object value2) {
    return '$value1 résultat$value2';
  }

  @override
  String legacyUi15b175bbc9(Object value1) {
    return 'Généré à $value1';
  }

  @override
  String legacyUi92a50db48d(Object value1) {
    return 'Exporter le rapport $value1';
  }

  @override
  String legacyUida6472ea1a(Object value1) {
    return 'Les $value1 véhicules seront tous inclus';
  }

  @override
  String get legacyUib0c379b2f8 => 'Sélectionnez un groupe de véhicules';

  @override
  String get legacyUi23d6943e8b => 'Sélectionner les véhicules';

  @override
  String legacyUi47b7508acb(Object value1) {
    return 'Terminé ($value1)';
  }

  @override
  String legacyUid495bed9d8(Object value1) {
    return 'Tout sélectionner parmi les éléments visibles ($value1)';
  }

  @override
  String legacyUi096909f019(Object value1, Object value2) {
    return '$value1 véhicule$value2';
  }

  @override
  String legacyUie003b8a491(Object value1) {
    return '$value1 jours maximum pour ce type de rapport';
  }

  @override
  String legacyUif386fe6e70(Object value1) {
    return 'Effacer ($value1)';
  }

  @override
  String get legacyUi706049c6a9 => 'Sélectionnez un capteur';

  @override
  String legacyUi2841c7f501(Object value1) {
    return 'Aucun rapport trouvé pour « $value1 »';
  }

  @override
  String legacyUi8002c1aa36(Object value1) {
    return 'Les heures utilisent $value1.';
  }

  @override
  String legacyUieaa190f343(Object value1) {
    return '$value1 activés';
  }

  @override
  String legacyUidc179fe07f(Object value1) {
    return 'La limite de vitesse doit être d’au moins 1 $value1.';
  }

  @override
  String legacyUi11003e8471(Object value1) {
    return 'Canaux de réception pour $value1';
  }

  @override
  String legacyUidc7454d672(Object value1) {
    return 'Dernier enregistrement $value1';
  }

  @override
  String get legacyUi7968beb979 => 'Code -';

  @override
  String legacyUi0528ad37c9(Object value1, Object value2) {
    return '$value1 liens sur $value2';
  }

  @override
  String get legacyUiac2a036e38 => 'Aucune activité pour le moment';

  @override
  String legacyUi3a4361ec75(Object value1) {
    return '« $value1 » sera supprimé définitivement.';
  }

  @override
  String get legacyUi50a9e13fce => 'Géozone sans nom';

  @override
  String legacyUi760cb5d683(Object value1, Object value2) {
    return '$value1 point$value2';
  }

  @override
  String legacyUifa6e784713(Object value1) {
    return 'Supprimer n° $value1';
  }

  @override
  String legacyUi27a25269f5(Object value1) {
    return 'Ajustement précis ($value1 m)';
  }

  @override
  String get legacyUi39706b5a17 => 'Aucune géométrie pour le moment';

  @override
  String get legacyUi1bf6cb6c45 => 'Géométrie prête';

  @override
  String get legacyUi5d437ca98b =>
      'Les événements se déclencheront pour cette géozone.';

  @override
  String get legacyUi6d8b4724c6 => 'La géozone est en pause.';

  @override
  String get legacyUi7e9f5c3026 => 'Tracez au moins 2 points sur la carte.';

  @override
  String get legacyUi28134edb87 => 'Modifier sur la carte';

  @override
  String get legacyUi0f873fbc31 => 'Dessiner sur la carte';

  @override
  String legacyUi48f6c8c8ac(Object value1) {
    return '$value1 m';
  }

  @override
  String legacyUicde59da67c(Object value1) {
    return '$value1 min';
  }

  @override
  String get legacyUi4bd1e22ea7 => 'Itinéraire sans nom';

  @override
  String legacyUi198f442dfb(Object value1) {
    return 'Sommet $value1';
  }

  @override
  String legacyUibae08b3767(Object value1, Object value2) {
    return 'Ligne $value1 : $value2';
  }

  @override
  String get legacyUi93039e609d => 'Non défini';

  @override
  String get legacyUid33a96e366 => 'Choisir sur la carte';

  @override
  String get legacyUiecd575d434 =>
      'Visible sur la carte en direct et dans les alertes de proximité.';

  @override
  String get legacyUi92a172ce15 =>
      'Masqué dans les alertes ; conservé dans la liste.';

  @override
  String get legacyUi8019307fe5 => 'Point d’intérêt sans nom';

  @override
  String get legacyUid14e0c02a9 => 'Suivi en direct disponible';

  @override
  String legacyUic814ea2b6e(Object value1) {
    return 'Début du service : $value1';
  }

  @override
  String legacyUic926abedfd(Object value1) {
    return 'Expiration du service client : $value1';
  }

  @override
  String legacyUiae0052da76(Object value1) {
    return 'Expiration de la couverture fournisseur : $value1';
  }

  @override
  String legacyUi633ec01c21(Object value1, Object value2) {
    return '$value1 • $value2 jours';
  }

  @override
  String get legacyUicf765512cc => 'Envoi…';

  @override
  String get legacyUi50756f98a3 => 'Demander le renouvellement';

  @override
  String legacyUid52adacef9(Object value1) {
    return 'Demande n° $value1';
  }

  @override
  String get legacyUicfeb791a76 => 'Demande expirée';

  @override
  String legacyUif0d8958371(Object value1, Object value2, Object value3,
      Object value4, Object value5) {
    return '$value1\n$value2 • $value3 jours\n$value4 $value5\n\nVotre administrateur doit confirmer le paiement avant la prolongation du service.';
  }

  @override
  String get legacyUifdb17036d5 => 'Utilisateur OpenVTS';

  @override
  String legacyUif7e83b3f19(Object value1) {
    return 'Rétablir la valeur par défaut ($value1)';
  }

  @override
  String legacyUi54e519da7f(Object value1) {
    return 'Erreur : $value1';
  }

  @override
  String get legacyUi7eb29d3565 => 'Date et heure';

  @override
  String get legacyUib1deb07e61 => 'Ouvrir la géozone';

  @override
  String get legacyUi1dce4bf43b => 'Ouvrir le point d’intérêt';

  @override
  String get legacyUi4a0d050737 => 'Ouvrir l’itinéraire';

  @override
  String get legacyUib6bd42e4e7 => 'En cours';

  @override
  String get legacyUi91edf8aff9 => 'En trajet';

  @override
  String get legacyUi20c7c5522f => 'Prêt';

  @override
  String get legacyUi0a2b58e839 => 'Aucune affectation';

  @override
  String get legacyUi6cf3d41f08 => 'Tous les trajets';

  @override
  String get legacyUif7a616a336 => 'Accès bloqué';

  @override
  String get legacyUiac7b5dd3a8 => 'Destinataire indisponible';

  @override
  String get legacyUi936d2e8552 => 'Problème de véhicule';

  @override
  String get legacyUi51cea59031 => 'Problème d’itinéraire';

  @override
  String get legacyUia972b55b1a =>
      'Décrivez le problème au service de répartition.';

  @override
  String get legacyUie0cdc02f99 => 'Format 12 heures';

  @override
  String get legacyUif910251f7c => 'Format 24 heures';

  @override
  String get legacyUi34ce147724 => 'De gauche à droite';

  @override
  String get legacyUida502a644e => 'De droite à gauche';

  @override
  String get legacyUiec45717e13 =>
      'Contactez le service de répartition pour plus de détails.';

  @override
  String get legacyUi8a783eb3d6 => 'Affectation confirmée.';

  @override
  String get legacyUi00e1e19595 => 'Démarrer le trajet';

  @override
  String get legacyUi0015b1903d =>
      'Les trajets démarrent normalement à partir de la télémétrie du véhicule. Utilisez ce démarrage manuel uniquement au début du trajet.';

  @override
  String get legacyUib20bd98ae2 => 'Ajouter une remarque';

  @override
  String get legacyUi42477e82cf => 'Impossible d’ouvrir la navigation.';

  @override
  String get legacyUiea0bd6ff3d => 'Terminer l’arrêt';

  @override
  String get legacyUi3d93beaa39 =>
      'Sélectionnez un fichier non vide de 5 Mo maximum.';

  @override
  String get legacyUid2085cce0d => 'Sélectionnez un fichier à téléverser.';

  @override
  String get legacyUid0193e6956 => 'Sélectionnez un type de document.';

  @override
  String get legacyUif378218081 => 'Saisissez au moins 2 caractères.';

  @override
  String get legacyUi63f72dce85 => 'Sélectionner un fichier';

  @override
  String get legacyUi1255774559 => 'Affectations du jour';

  @override
  String get legacyUi3528465759 => 'Trajets terminés';

  @override
  String get legacyUi28793a4155 => 'Arrêts terminés';

  @override
  String get legacyUi1683af6ce8 => 'Arrêts en attente';

  @override
  String mobilePluralTrips(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count trajets',
      one: '$count trajet',
    );
    return '$_temp0';
  }

  @override
  String mobilePluralBlockedVehicles(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count véhicules bloqués exclus.',
      one: '$count véhicule bloqué exclu.',
    );
    return '$_temp0';
  }

  @override
  String mobilePluralSelectedVehicles(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count véhicules sélectionnés',
      one: '$count véhicule sélectionné',
    );
    return '$_temp0';
  }

  @override
  String mobilePluralUsers(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count utilisateurs',
      one: '$count utilisateur',
    );
    return '$_temp0';
  }

  @override
  String mobilePluralActiveDays(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jours actifs',
      one: '$count jour actif',
    );
    return '$_temp0';
  }

  @override
  String mobilePluralResults(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count résultats',
      one: '$count résultat',
    );
    return '$_temp0';
  }

  @override
  String mobilePluralVehicles(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count véhicules',
      one: '$count véhicule',
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
  String get relativeJustNow => 'à l’instant';

  @override
  String relativeMinutesAgo(int count) {
    return 'il y a $count min';
  }

  @override
  String relativeHoursAgo(int count) {
    return 'il y a $count h';
  }

  @override
  String relativeDaysAgo(int count) {
    return 'il y a $count j';
  }

  @override
  String get relativeYesterday => 'hier';

  @override
  String savingChangesForTab(String tab) {
    return 'Enregistrement des modifications de $tab…';
  }

  @override
  String unsavedChangesForTab(String tab) {
    return 'Vous avez des modifications non enregistrées dans $tab.';
  }

  @override
  String get saving => 'Enregistrement…';

  @override
  String validationRequired(String field) {
    return '$field est obligatoire';
  }

  @override
  String validationAscii(String field) {
    return '$field doit contenir uniquement des caractères ASCII';
  }

  @override
  String validationMinCharacters(String field, int count) {
    return '$field doit comporter au moins $count caractères';
  }

  @override
  String validationMaxCharacters(String field, int count) {
    return '$field doit comporter au maximum $count caractères';
  }

  @override
  String validationMinDigits(String field, int count) {
    return '$field doit comporter au moins $count chiffres';
  }

  @override
  String validationMaxDigits(String field, int count) {
    return '$field doit comporter au maximum $count chiffres';
  }

  @override
  String validationNumeric(String field) {
    return '$field doit contenir uniquement des chiffres';
  }

  @override
  String validationMinimumCharacters(int count) {
    return 'Minimum $count caractères';
  }

  @override
  String get validationValidEmail => 'Saisissez une adresse e-mail valide';

  @override
  String get validationValidNumber => 'Saisissez un nombre valide';

  @override
  String get validationNonnegativeCredits =>
      'Les crédits ne peuvent pas être négatifs';

  @override
  String get validationConfirmPassword => 'Confirmez le mot de passe';

  @override
  String get validationPasswordsMismatch =>
      'Les mots de passe ne correspondent pas';

  @override
  String get validationStandardVin =>
      'Le VIN doit comporter 17 caractères alphanumériques, sauf I, O et Q';

  @override
  String get validationVinAlphanumeric =>
      'Le VIN doit contenir uniquement des lettres et des chiffres';

  @override
  String get validationThisField => 'Ce champ';

  @override
  String get validationFieldSimNumber => 'Numéro de SIM';
}
