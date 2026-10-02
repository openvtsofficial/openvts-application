// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get date => 'Fecha';

  @override
  String get time => 'Hora';

  @override
  String get direction => 'Dirección';

  @override
  String get units => 'Unidades';

  @override
  String get appTitle => 'OpenVTS';

  @override
  String get settings => 'Configuración';

  @override
  String get localization => 'Localización';

  @override
  String get language => 'Idioma';

  @override
  String get theme => 'Tema';

  @override
  String get dateFormat => 'Formato de fecha';

  @override
  String get timeFormat => 'Formato de hora';

  @override
  String get timezone => 'Zona horaria';

  @override
  String get use24Hour => 'Hora de 24 horas';

  @override
  String get save => 'Guardar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get edit => 'Editar';

  @override
  String get search => 'Buscar';

  @override
  String get delete => 'Eliminar';

  @override
  String get reset => 'Restablecer';

  @override
  String get close => 'Cerrar';

  @override
  String get back => 'Atrás';

  @override
  String get next => 'Siguiente';

  @override
  String get prev => 'Anterior';

  @override
  String get loading => 'Cargando...';

  @override
  String get error => 'Error';

  @override
  String get success => 'Éxito';

  @override
  String get warning => 'Advertencia';

  @override
  String get light => 'Claro';

  @override
  String get dark => 'Oscuro';

  @override
  String get system => 'Sistema';

  @override
  String get en => 'Inglés';

  @override
  String get hi => 'Hindi';

  @override
  String get ar => 'Árabe';

  @override
  String get es => 'Español';

  @override
  String get fr => 'Francés';

  @override
  String get pt => 'Portugués';

  @override
  String get profile => 'Perfil';

  @override
  String get logout => 'Cerrar sesión';

  @override
  String get login => 'Iniciar sesión';

  @override
  String get register => 'Registrarse';

  @override
  String get administrators => 'Administradores';

  @override
  String get payments => 'Pagos';

  @override
  String get support => 'Soporte';

  @override
  String get tickets => 'Entradas';

  @override
  String get home => 'Inicio';

  @override
  String get dashboard => 'Panel';

  @override
  String get keepEditing => 'Seguir editando';

  @override
  String get discardChanges => 'Descartar cambios';

  @override
  String get unsavedChanges => 'Cambios no guardados';

  @override
  String get refresh => 'Actualizar';

  @override
  String get selectLanguage => 'Seleccionar idioma';

  @override
  String get selectTheme => 'Seleccionar tema';

  @override
  String get selectDateFormat => 'Seleccionar formato de fecha';

  @override
  String get selectTimeFormat => 'Seleccionar formato de hora';

  @override
  String get selectTimezone => 'Seleccionar zona horaria';

  @override
  String previewDate(String date) {
    return 'Vista previa: $date';
  }

  @override
  String previewTime(String time) {
    return 'Vista previa: $time';
  }

  @override
  String get settingsUpdated => 'Configuración actualizada';

  @override
  String get profileUpdated => 'Perfil actualizado';

  @override
  String get localizationUpdated => 'Configuración de localización actualizada';

  @override
  String get failedToUpdate =>
      'Error al actualizar. Por favor, intente de nuevo.';

  @override
  String get noData => 'No hay datos disponibles';

  @override
  String get retry => 'Reintentar';

  @override
  String get confirmDiscard => '¿Descartar cambios no guardados?';

  @override
  String confirmDiscardMessage(String tab) {
    return '$tab tiene ediciones sin guardar. Descartar perderá estos cambios.';
  }

  @override
  String get reportsTitle => 'Informes';

  @override
  String get reportsSearchHint => 'Buscar informes…';

  @override
  String reportsNoResultsFor(Object query) {
    return 'No se encontraron informes para \"$query\"';
  }

  @override
  String get reportsGenerate => 'Generar informe';

  @override
  String get reportsGenerating => 'Generando…';

  @override
  String get reportsReset => 'Restablecer';

  @override
  String get reportsConfigureHint =>
      'Configure el informe arriba y toque Generar.';

  @override
  String get reportsNoResults =>
      'No se encontraron resultados para los filtros seleccionados.';

  @override
  String get reportsErrorRetry => 'Reintentar';

  @override
  String reportsRowCount(Object count) {
    return '$count filas cargadas';
  }

  @override
  String get reportsLoadMore => 'Cargar más';

  @override
  String get reportsLoadingMore => 'Loading more…';

  @override
  String reportsGeneratedAt(Object time) {
    return 'Generado $time';
  }

  @override
  String get reportsExportTitle => 'Exportar informe';

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
  String get reportsScopeAll => 'Todos los vehículos';

  @override
  String get reportsScopeSingle => 'Un vehículo';

  @override
  String get reportsScopeMultiple => 'Múltiples vehículos';

  @override
  String get reportsScopeGroup => 'Grupo';

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
  String get reportsCatalogDistanceTitle => 'Distancia';

  @override
  String get reportsCatalogDistanceDesc =>
      'Total distance driven per vehicle per day with engine hours and odometer readings.';

  @override
  String get reportsCatalogDrivenTitle => 'Días conducidos';

  @override
  String get reportsCatalogDrivenDesc =>
      'Daily distance matrix — which vehicles moved on which days and how far.';

  @override
  String get reportsCatalogDetailsTitle => 'Detalles del vehículo';

  @override
  String get reportsCatalogDetailsDesc =>
      'Fleet summary: total distance, engine hours, active days, last known location per vehicle.';

  @override
  String get reportsCatalogOverspeedTitle => 'Exceso de velocidad';

  @override
  String get reportsCatalogOverspeedDesc =>
      'Speeding events with observed speed, configured limit, excess, duration, and location.';

  @override
  String get reportsCatalogGeofenceTitle => 'Geocerca';

  @override
  String get reportsCatalogGeofenceDesc =>
      'Entry and exit events for selected geofences with timestamps and dwell duration.';

  @override
  String get reportsCatalogAlertsTitle => 'Alertas';

  @override
  String get reportsCatalogAlertsDesc =>
      'Alert events by type and severity with acknowledgement status.';

  @override
  String get reportsCatalogSensorTitle => 'Sensor';

  @override
  String get reportsCatalogSensorDesc =>
      'Time-series readings for a specific sensor on a single vehicle with chart visualisation.';

  @override
  String get reportsCatalogLogsTitle => 'Registros del dispositivo';

  @override
  String get reportsCatalogLogsDesc =>
      'Raw communication logs from vehicle devices grouped by category and level.';

  @override
  String get reportsCatalogTimelineTitle => 'Línea de tiempo';

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
  String get adminRole => 'Administrador';

  @override
  String get users => 'Usuarios';

  @override
  String get vehicles => 'Vehículos';

  @override
  String get drivers => 'Conductores';

  @override
  String get team => 'Equipo';

  @override
  String get inventory => 'Inventario';

  @override
  String get map => 'Mapa';

  @override
  String get transactions => 'Transacciones';

  @override
  String get calendar => 'Calendario';

  @override
  String get logs => 'Registros';

  @override
  String get plans => 'Planes';

  @override
  String get roles => 'Roles';

  @override
  String get smtp => 'SMTP';

  @override
  String get settingsDescription =>
      'Gestiona el perfil, la localización y la configuración SMTP.';

  @override
  String get localizationDescription =>
      'Idioma, fecha y hora, unidades y enfoque predeterminado del mapa.';

  @override
  String get whiteLabel => 'Marca Blanca';

  @override
  String get saveChanges => 'Guardar cambios';

  @override
  String get textDirection => 'Dirección del texto';

  @override
  String get languageAndDirection => 'Idioma y Dirección';

  @override
  String get languageAndDirectionSubtitle =>
      'Idioma de interfaz y dirección del texto.';

  @override
  String get dateAndTime => 'Fecha y Hora';

  @override
  String get dateAndTimeSubtitle =>
      'Formato de fecha, estilo de hora y zona horaria.';

  @override
  String get unitsAndTheme => 'Unidades y Tema';

  @override
  String get unitsAndThemeSubtitle =>
      'Unidades de distancia y apariencia de la app.';

  @override
  String get defaultMapFocus => 'Enfoque Predeterminado del Mapa';

  @override
  String get defaultMapFocusSubtitle =>
      'Centro inicial del mapa y nivel de zoom.';

  @override
  String get couldNotLoadLocalization => 'No se pudo cargar la localización.';

  @override
  String get localizationSaved => 'Localización guardada';

  @override
  String get quickPresets => 'Preajustes rápidos';

  @override
  String get settingsHeaderSubtitle =>
      'Perfil, marca, correo, localización y preferencias de plataforma.';

  @override
  String get localizationPreview => 'Vista previa de localización';

  @override
  String get latitude => 'Latitud';

  @override
  String get longitude => 'Longitud';

  @override
  String get mapZoom => 'Zoom del mapa';

  @override
  String get mapCenter => 'Centro del mapa';

  @override
  String get kilometers => 'Kilómetros';

  @override
  String get miles => 'Millas';

  @override
  String get latitudeRequired => 'La latitud es obligatoria.';

  @override
  String get validLatitude => 'Introduce una latitud válida.';

  @override
  String get latitudeRange => 'La latitud debe estar entre -90 y 90.';

  @override
  String get longitudeRequired => 'La longitud es obligatoria.';

  @override
  String get validLongitude => 'Introduce una longitud válida.';

  @override
  String get longitudeRange => 'La longitud debe estar entre -180 y 180.';

  @override
  String get mapZoomRequired => 'El zoom del mapa es obligatorio.';

  @override
  String get validMapZoom => 'Introduce un nivel de zoom válido.';

  @override
  String get mapZoomRange => 'El zoom del mapa debe estar entre 1 y 22.';

  @override
  String get unsupportedLanguageFallback =>
      'El idioma guardado no está disponible en la aplicación. Selecciona un idioma compatible; mientras tanto se usa inglés.';
}
