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
  String get reportsLoadingMore => 'Cargando más…';

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
  String get reportsScopeSelectVehicle => 'Seleccionar vehículo';

  @override
  String get reportsScopeSelectVehicles => 'Seleccionar vehículos';

  @override
  String get reportsScopeSelectGroup => 'Seleccionar grupo';

  @override
  String get reportsScopeSearchHint => 'Buscar por nombre, matrícula o IMEI…';

  @override
  String get reportsScopeSelectAll => 'Seleccionar todos los visibles';

  @override
  String get reportsScopeDone => 'Listo';

  @override
  String reportsScopeNVehiclesSelected(Object count) {
    return '$count vehículos seleccionados';
  }

  @override
  String get reportsDateStart => 'Fecha de inicio';

  @override
  String get reportsDateEnd => 'Fecha de fin';

  @override
  String get reportsDateFrom => 'Inicio';

  @override
  String get reportsDateTo => 'Fin';

  @override
  String reportsDateMaxDays(Object days) {
    return 'Máximo $days días para este tipo de informe';
  }

  @override
  String get reportsValidationScopeRequired =>
      'Selecciona al menos un vehículo.';

  @override
  String get reportsValidationStartRequired =>
      'La fecha de inicio es obligatoria.';

  @override
  String get reportsValidationEndRequired => 'La fecha de fin es obligatoria.';

  @override
  String get reportsValidationStartBeforeEnd =>
      'El inicio debe ser anterior al fin.';

  @override
  String reportsValidationMaxDays(Object days) {
    return 'El intervalo supera el límite de $days días de este informe.';
  }

  @override
  String get reportsValidationSensorVehicleRequired =>
      'Selecciona un vehículo para el informe del sensor.';

  @override
  String get reportsValidationSensorRequired => 'Selecciona un sensor.';

  @override
  String get reportsValidationTimelineStateRequired =>
      'Selecciona al menos un estado (en marcha o detenido).';

  @override
  String get reportsFilterSpeedLimit => 'Límite de velocidad (km/h)';

  @override
  String get reportsFilterSpeedCustom => 'Límite personalizado…';

  @override
  String get reportsFilterGeofenceHint => 'Buscar geocercas…';

  @override
  String get reportsFilterGeofenceAllNote =>
      'Sin selección se incluyen todas las geocercas.';

  @override
  String get reportsFilterAlertType => 'Tipo de alerta';

  @override
  String get reportsFilterAlertSeverity => 'Gravedad';

  @override
  String get reportsFilterAlertAck => 'Confirmación';

  @override
  String get reportsFilterAlertAckAll => 'Todos';

  @override
  String get reportsFilterAlertAckAcknowledged => 'Confirmado';

  @override
  String get reportsFilterAlertAckUnacknowledged => 'Sin confirmar';

  @override
  String get reportsFilterLogsVehicle => 'Vehículo';

  @override
  String get reportsFilterLogsCategory => 'Categoría';

  @override
  String get reportsFilterLogsLevel => 'Nivel';

  @override
  String get reportsFilterTimelineRunning => 'En marcha';

  @override
  String get reportsFilterTimelineStopped => 'Detenido';

  @override
  String get reportsFilterSensorVehicle => 'Vehículo';

  @override
  String get reportsFilterSensorSensor => 'Sensor';

  @override
  String get reportsCatalogDistanceTitle => 'Distancia';

  @override
  String get reportsCatalogDistanceDesc =>
      'Distancia diaria por vehículo, horas de motor y lecturas del odómetro.';

  @override
  String get reportsCatalogDrivenTitle => 'Días conducidos';

  @override
  String get reportsCatalogDrivenDesc =>
      'Matriz diaria de distancias: qué vehículos circularon, qué días y cuánto.';

  @override
  String get reportsCatalogDetailsTitle => 'Detalles del vehículo';

  @override
  String get reportsCatalogDetailsDesc =>
      'Resumen de flota: distancia, horas de motor, días activos y última ubicación por vehículo.';

  @override
  String get reportsCatalogOverspeedTitle => 'Exceso de velocidad';

  @override
  String get reportsCatalogOverspeedDesc =>
      'Excesos de velocidad con velocidad registrada, límite, exceso, duración y ubicación.';

  @override
  String get reportsCatalogGeofenceTitle => 'Geocerca';

  @override
  String get reportsCatalogGeofenceDesc =>
      'Entradas y salidas de las geocercas seleccionadas, con fechas y tiempo de permanencia.';

  @override
  String get reportsCatalogAlertsTitle => 'Alertas';

  @override
  String get reportsCatalogAlertsDesc =>
      'Alertas por tipo y gravedad, con estado de confirmación.';

  @override
  String get reportsCatalogSensorTitle => 'Sensor';

  @override
  String get reportsCatalogSensorDesc =>
      'Lecturas a lo largo del tiempo de un sensor en un vehículo, con gráfico.';

  @override
  String get reportsCatalogLogsTitle => 'Registros del dispositivo';

  @override
  String get reportsCatalogLogsDesc =>
      'Registros de comunicación de los dispositivos, agrupados por categoría y nivel.';

  @override
  String get reportsCatalogTimelineTitle => 'Línea de tiempo';

  @override
  String get reportsCatalogTimelineDesc =>
      'Tramos en marcha y detenidos, con duración, distancia y recorrido GPS.';

  @override
  String get reportsKpiTotalDistance => 'Distancia total';

  @override
  String get reportsKpiEngineHours => 'Horas de motor';

  @override
  String get reportsKpiActiveVehicles => 'Vehículos activos';

  @override
  String get reportsKpiAvgDistance => 'Distancia media';

  @override
  String get reportsKpiVehiclesDriven => 'Vehículos en circulación';

  @override
  String get reportsKpiAvgDaily => 'Promedio diario';

  @override
  String get reportsKpiPeakDay => 'Día de mayor actividad';

  @override
  String get reportsKpiViolations => 'Infracciones';

  @override
  String get reportsKpiAffectedVehicles => 'Vehículos afectados';

  @override
  String get reportsKpiHighestSpeed => 'Velocidad máxima';

  @override
  String get reportsKpiTotalDuration => 'Duración total';

  @override
  String get reportsKpiTotalEvents => 'Total de eventos';

  @override
  String get reportsKpiEntries => 'Entradas';

  @override
  String get reportsKpiExits => 'Salidas';

  @override
  String get reportsKpiTotalAlerts => 'Total de alertas';

  @override
  String get reportsKpiCritical => 'Crítico';

  @override
  String get reportsKpiAcknowledged => 'Confirmadas';

  @override
  String get reportsKpiReadings => 'Lecturas';

  @override
  String get reportsKpiOnEvents => 'Eventos de encendido';

  @override
  String get reportsKpiOffEvents => 'Eventos de apagado';

  @override
  String get reportsKpiTotalLogs => 'Total de registros';

  @override
  String get reportsKpiRunningDuration => 'Tiempo en marcha';

  @override
  String get reportsKpiStoppedDuration => 'Tiempo detenido';

  @override
  String get reportsKpiMovementDistance => 'Distancia recorrida';

  @override
  String get reportsKpiStopCount => 'Número de paradas';

  @override
  String get reportsDetailTitle => 'Detalles de la fila';

  @override
  String get reportsDetailRawPayload => 'Datos sin procesar';

  @override
  String get reportsDetailCopied => 'Copiado';

  @override
  String get reportsDetailCopy => 'Copiar';

  @override
  String get reportsDetailTruncated =>
      'Datos recortados para mostrar. Exporta para obtener todos los datos.';

  @override
  String get reportsRowDetailsViewMap => 'Ver mapa';

  @override
  String get reportsRowDetailsHideMap => 'Ocultar mapa';

  @override
  String get reportsRowDetailsNoGps => 'No hay datos GPS para este tramo.';

  @override
  String reportsWarningBanner(Object message) {
    return 'Advertencia: $message';
  }

  @override
  String reportsSourceLabel(Object source) {
    return 'Fuente: $source';
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

  @override
  String homeWorkspace(Object role) {
    return 'Espacio de trabajo de $role';
  }

  @override
  String get homeAccessUnavailable =>
      'No se pudo actualizar el acceso. Desliza hacia abajo para reintentar.';

  @override
  String get homeCopyright => '© 2026 Open VTS Todos los derechos reservados.';

  @override
  String get lightMode => 'Modo claro';

  @override
  String get darkMode => 'Modo oscuro';

  @override
  String get landmarksStudio => 'Gestión de lugares';

  @override
  String get trackLinks => 'Enlaces de seguimiento';

  @override
  String get messages => 'Mensajes';

  @override
  String get accounts => 'Cuentas';

  @override
  String get notifications => 'Notificaciones';

  @override
  String get operations => 'Operaciones';

  @override
  String get server => 'Servidor';

  @override
  String get trips => 'Viajes';

  @override
  String get documents => 'Documentos';

  @override
  String get userRole => 'Usuario';

  @override
  String get subuserRole => 'Subusuario';

  @override
  String get driverRole => 'Conductor';

  @override
  String get superadminRole => 'Superadministrador';

  @override
  String get demoReadOnly => 'Demostración • Solo lectura';

  @override
  String get security => 'Seguridad';

  @override
  String get routeBuilderCreate => 'Crear ruta';

  @override
  String get routeBuilderEdit => 'Editar ruta';

  @override
  String get routeBuilderName => 'Nombre de la ruta';

  @override
  String get routeBuilderNameHint => 'Por ejemplo, entregas de la mañana';

  @override
  String get routeBuilderNameError =>
      'Introduce un nombre de al menos 2 caracteres.';

  @override
  String get routeBuilderStops => 'Paradas';

  @override
  String get routeBuilderAddStop => 'Añadir parada';

  @override
  String get routeBuilderEditStop => 'Editar parada';

  @override
  String get routeBuilderStopName => 'Nombre de la parada';

  @override
  String get routeBuilderStopNameError =>
      'Introduce un nombre de entre 1 y 160 caracteres.';

  @override
  String get routeBuilderAddress => 'Dirección (opcional)';

  @override
  String get routeBuilderCoordinates => 'Coordenadas';

  @override
  String get routeBuilderLatitude => 'Latitud';

  @override
  String get routeBuilderLongitude => 'Longitud';

  @override
  String get routeBuilderCoordinateError =>
      'Introduce una latitud válida (−90 a 90) y una longitud válida (−180 a 180).';

  @override
  String get routeBuilderMap => 'Elegir en el mapa';

  @override
  String get routeBuilderMapHint =>
      'Toca el mapa para elegir la ubicación de la parada.';

  @override
  String get routeBuilderUseLocation => 'Usar ubicación';

  @override
  String get routeBuilderPoi => 'Punto de interés';

  @override
  String get routeBuilderGeofence => 'Geocerca';

  @override
  String get routeBuilderLandmarkSearch => 'Buscar lugares guardados';

  @override
  String get routeBuilderNoLandmarks =>
      'No hay lugares coincidentes con coordenadas válidas.';

  @override
  String get routeBuilderLandmarkError =>
      'No se pudieron cargar los lugares. Inténtalo de nuevo.';

  @override
  String get routeBuilderStopLimit =>
      'Una ruta puede tener hasta 100 paradas, incluida la de regreso.';

  @override
  String get routeBuilderMinimumStops => 'Añade al menos 2 paradas distintas.';

  @override
  String get routeBuilderRoundTrip => 'Volver al inicio';

  @override
  String get routeBuilderRoundTripHint =>
      'Añade el punto de inicio como destino final.';

  @override
  String get routeBuilderOptimize => 'Optimizar orden';

  @override
  String get routeBuilderOptimizeHint =>
      'Reordena las paradas por distancia geográfica, manteniendo inicio y destino. La distancia por carretera se calcula aparte.';

  @override
  String get routeBuilderRoadPath => 'Vista previa del recorrido';

  @override
  String get routeBuilderRouting => 'Calculando ruta por carretera…';

  @override
  String get routeBuilderRoutingError =>
      'No hay una ruta disponible. Revisa las paradas o la conexión e inténtalo de nuevo.';

  @override
  String get routeBuilderReady => 'Ruta lista';

  @override
  String get routeBuilderChanged =>
      'Las paradas cambiaron. Previsualiza la nueva ruta antes de guardar.';

  @override
  String get routeBuilderSaveError =>
      'No se pudo guardar la ruta. Inténtalo de nuevo.';

  @override
  String get routeBuilderAccessDenied =>
      'No tienes permiso para crear o editar rutas.';

  @override
  String get routeBuilderOrigin => 'Inicio';

  @override
  String get routeBuilderDestination => 'Destino';

  @override
  String get routeBuilderWaypoint => 'Parada';

  @override
  String get routeBuilderShapePoint => 'Forma de la ruta';

  @override
  String get routeBuilderMoveUp => 'Mover antes';

  @override
  String get routeBuilderMoveDown => 'Mover después';

  @override
  String get routeBuilderRemove => 'Quitar parada';

  @override
  String get routeBuilderNoStops =>
      'Añade inicio y destino, y después las paradas intermedias.';

  @override
  String get routeBuilderSavedGeometry => 'Recorrido guardado';

  @override
  String get routeBuilderEditingLoadError =>
      'No se pudo cargar la ruta completa. Vuelve atrás e inténtalo de nuevo.';

  @override
  String get routeBuilderDiscardTitle => '¿Descartar cambios de la ruta?';

  @override
  String get routeBuilderDiscardMessage =>
      'Se perderán los cambios no guardados.';

  @override
  String get routeBuilderDiscard => 'Descartar';

  @override
  String get routeBuilderKeepEditing => 'Seguir editando';

  @override
  String get routeBuilderClose => 'Cerrar';

  @override
  String get routeBuilderRetry => 'Reintentar';

  @override
  String get routeBuilderMapAttribution =>
      '© Colaboradores de OpenStreetMap · Rutas: OSRM';

  @override
  String get routeBuilderRouteDetails => 'Detalles de la ruta';

  @override
  String get routeBuilderMinutes => 'min';

  @override
  String get routeBuilderDistanceUnit => 'km';

  @override
  String get routeBuilderChooseSource => 'Añadir parada desde';

  @override
  String get routeBuilderLandmarksPermission =>
      'Los lugares guardados requieren el permiso de Lugares.';

  @override
  String get routeBuilderShapeHint =>
      'Los puntos de trazado guían el recorrido; no son paradas de entrega. La optimización los elimina.';

  @override
  String get routeBuilderGeofenceHint =>
      'Usa el centro de la geocerca. Confirma que se puede llegar por carretera.';

  @override
  String selectField(Object field) {
    return 'Seleccionar $field';
  }

  @override
  String searchField(Object field) {
    return 'Buscar $field';
  }

  @override
  String noMatchingField(Object field) {
    return 'Sin coincidencias en $field';
  }

  @override
  String fieldRequired(Object field) {
    return '$field es obligatorio.';
  }

  @override
  String get clearSelection => 'Borrar';

  @override
  String get clearSearch => 'Borrar búsqueda';

  @override
  String get noResults => 'Sin resultados';

  @override
  String get select => 'Seleccionar';

  @override
  String get unableToLoad => 'No se pudo cargar';

  @override
  String get mobileApiToken => 'Token de API';

  @override
  String get mobileTokenOnce =>
      'Este token se muestra una sola vez. Guárdalo de forma segura; quien lo tenga podrá usar los permisos seleccionados.';

  @override
  String get mobileSaveRecovery => 'Guarda tus códigos de recuperación';

  @override
  String get mobileRecoveryHelp =>
      'Cada código sirve una vez si pierdes el autenticador. Sustituyen a los anteriores. Guárdalos en un lugar seguro.';

  @override
  String get mobileCopiedSecurely => 'Copiado. Guárdalo de forma segura.';

  @override
  String get mobileSavedSecurely => 'Lo he guardado de forma segura';

  @override
  String get mobileDone => 'Listo';

  @override
  String get mobileRevokeTokenQuestion => '¿Revocar token de API?';

  @override
  String mobileTokenStops(Object name) {
    return '$name dejará de funcionar de inmediato.';
  }

  @override
  String get mobileRevoke => 'Revocar';

  @override
  String get mobileMfa => 'Autenticación multifactor';

  @override
  String get mobileMfaOn => 'MFA activada';

  @override
  String get mobileMfaOff => 'MFA desactivada';

  @override
  String get mobileMfaHelp =>
      'Protege el acceso con tu aplicación de autenticación.';

  @override
  String get mobileSecuritySessions =>
      'Los cambios de seguridad cierran las demás sesiones e invalidan los tokens de API existentes.';

  @override
  String mobileAddedDate(Object date) {
    return 'Añadido el $date';
  }

  @override
  String get mobileRemoveAuthenticator => 'Quitar autenticador';

  @override
  String get mobileAddAuthenticator => 'Añadir autenticador';

  @override
  String get mobileSetupMfa => 'Configurar MFA';

  @override
  String mobileRecoveryRemaining(Object count) {
    return '$count códigos de recuperación sin usar';
  }

  @override
  String get mobileReplaceRecovery => 'Reemplazar códigos de recuperación';

  @override
  String get mobileTurnOffMfa => 'Desactivar MFA';

  @override
  String get mobileApiAccess => 'Acceso a API';

  @override
  String get mobileApiHelp =>
      'Crea credenciales para integraciones con los permisos de tu cuenta.';

  @override
  String get mobileReadWrite => 'Lectura y escritura';

  @override
  String get mobileReadOnly => 'Solo lectura';

  @override
  String get mobileExpires => 'Caduca';

  @override
  String get mobileInactive => 'Inactivo';

  @override
  String get mobileRevokeToken => 'Revocar token';

  @override
  String get mobileCreateToken => 'Crear token de API';

  @override
  String get mobileDeleteAccount => 'Eliminar cuenta';

  @override
  String get mobileDeleteWorkspaceHelp =>
      'Elimina tu cuenta y el acceso al espacio, incluidos los subusuarios. Se cerrarán todas las sesiones. Esta acción no puede deshacerse en la aplicación.';

  @override
  String get mobileDeleteSelfHelp =>
      'Elimina tu cuenta y cierra sus sesiones. Esta acción no puede deshacerse en la aplicación.';

  @override
  String get mobileDeleteMyAccount => 'Eliminar mi cuenta';

  @override
  String get mobilePasswordOnly =>
      'Los próximos accesos solo necesitarán tu contraseña.';

  @override
  String get mobileRecoveryReplaced =>
      'Tus códigos de recuperación anteriores dejarán de funcionar.';

  @override
  String get mobileTokenName => 'Nombre del token';

  @override
  String get mobileAuthenticatorName => 'Nombre del autenticador';

  @override
  String get mobileEnterName => 'Introduce un nombre.';

  @override
  String get mobileAccess => 'Acceso';

  @override
  String get mobileExpiresAfter => 'Caduca después de';

  @override
  String mobileDays(Object count) {
    return '$count días';
  }

  @override
  String get mobileCurrentPassword => 'Contraseña actual';

  @override
  String get mobileEnterPassword => 'Introduce tu contraseña.';

  @override
  String get mobileAuthenticatorOrRecovery =>
      'Código de autenticación o recuperación';

  @override
  String get mobileEnterVerification => 'Introduce tu código de verificación.';

  @override
  String get mobileDeleteConfirmation =>
      'Entiendo que se eliminarán mi cuenta y el acceso al espacio de trabajo.';

  @override
  String get mobileContinue => 'Continuar';

  @override
  String get mobileSixDigits => 'Introduce los seis dígitos.';

  @override
  String get mobileConnectAuthenticator => 'Conecta tu autenticador';

  @override
  String get mobileScanQrHelp =>
      'Escanea el QR en otro dispositivo o copia la clave en tu autenticador. La configuración caduca en 10 minutos.';

  @override
  String get mobileCopySetup => 'Copiar clave de configuración';

  @override
  String get mobileNewAuthenticatorCode => 'Código del nuevo autenticador';

  @override
  String get mobileVerifying => 'Verificando…';

  @override
  String get mobileConfirm => 'Confirmar';

  @override
  String get mobileVerifySignIn => 'Verifica tu acceso';

  @override
  String get mobileUnusedRecovery =>
      'Introduce un código de recuperación sin usar.';

  @override
  String get mobileAuthenticatorInstructions =>
      'Introduce el código de seis dígitos de tu autenticador.';

  @override
  String get mobileRecoveryCode => 'Código de recuperación';

  @override
  String get mobileAuthenticatorCode => 'Código del autenticador';

  @override
  String get mobileCompleteRecovery =>
      'Introduce un código de recuperación completo.';

  @override
  String get mobileVerifyAndSignIn => 'Verificar e iniciar sesión';

  @override
  String get mobileUseAuthenticator => 'Usar código del autenticador';

  @override
  String get mobileUseRecovery => 'Usar código de recuperación';

  @override
  String get mobileBackSignIn => 'Volver al inicio de sesión';

  @override
  String get mobileName => 'Nombre';

  @override
  String get mobileCallingCode => 'Prefijo internacional';

  @override
  String get mobileMobileNumber => 'Número de móvil';

  @override
  String get mobileAddress => 'Dirección';

  @override
  String get mobileCountry => 'País';

  @override
  String get mobileState => 'Estado / Provincia';

  @override
  String get mobileCity => 'Ciudad';

  @override
  String get mobilePostcode => 'Código postal';

  @override
  String get mobileChangePassword => 'Cambiar contraseña';

  @override
  String get mobileRequired => 'Este campo es obligatorio.';

  @override
  String get mobileValidEmail =>
      'Introduce un correo válido con caracteres ASCII.';

  @override
  String get mobilePasswordSessions =>
      'Cambiar la contraseña cierra todas tus sesiones.';

  @override
  String get mobileNewPassword => 'Nueva contraseña';

  @override
  String get mobilePasswordCharacters => 'Usa de 6 a 72 caracteres ASCII.';

  @override
  String get mobileDifferentPassword => 'Elige una contraseña distinta.';

  @override
  String get mobileConfirmPassword => 'Confirmar nueva contraseña';

  @override
  String get mobilePasswordMismatch => 'Las contraseñas no coinciden.';

  @override
  String get mobileChangesSaved => 'Cambios guardados';

  @override
  String get mobileLanguageCodeHelp =>
      'Introduce un código de idioma, como en o hi.';

  @override
  String get mobileReload => 'Recargar';

  @override
  String get mobileEnterYourName => 'Introduce tu nombre.';

  @override
  String get mobileEnterCallingCode => 'Introduce un prefijo telefónico.';

  @override
  String get mobileValidMobile => 'Introduce un número de móvil válido.';

  @override
  String get mobileSaveProfile => 'Guardar perfil';

  @override
  String get mobileDisplayPreferences => 'Preferencias de visualización';

  @override
  String get mobileDateFormat => 'Formato de fecha';

  @override
  String get mobileTimeFormat => 'Formato de hora';

  @override
  String get mobileDistanceUnit => 'Unidad de distancia';

  @override
  String get mobileTextDirection => 'Dirección del texto';

  @override
  String get mobileTimeOffset => 'Desfase horario';

  @override
  String get mobileLanguageCode => 'Código de idioma';

  @override
  String get mobileSavePreferences => 'Guardar preferencias';

  @override
  String get mobileProofAccountChanged =>
      'El acceso cambió. Vuelve a abrir el comprobante del viaje.';

  @override
  String get mobileActivity => 'Actividad';

  @override
  String get mobileAllStatuses => 'Todos los estados';

  @override
  String get mobileApproximateRoute =>
      'Secuencia aproximada • paradas numeradas';

  @override
  String get mobileAttention => 'Atención';

  @override
  String get mobileChooseRoute => 'Elige una ruta';

  @override
  String get mobileValidSchedule => 'Elige un horario válido.';

  @override
  String get mobileValidStartTime => 'Elige una hora de inicio válida.';

  @override
  String get mobileChooseVehicle => 'Elige un vehículo';

  @override
  String get mobileChooseVehicleRoute => 'Elige un vehículo y una ruta.';

  @override
  String get mobileChooseEligibleVehicle => 'Elige un vehículo disponible';

  @override
  String get mobileEndDateAfterStart =>
      'Elige una fecha de fin igual o posterior al inicio.';

  @override
  String get mobileChooseWeekday => 'Elige al menos un día de la semana.';

  @override
  String get mobileChooseDate => 'Elegir fecha';

  @override
  String get mobileChooseDateRange => 'Elegir intervalo de fechas';

  @override
  String get mobileChooseDay => 'Elegir día';

  @override
  String get mobileMultiDayHelp =>
      'Elige inicio y finalización para un viaje de varios días.';

  @override
  String get mobileFutureDate => 'Elige hoy o una fecha posterior.';

  @override
  String get mobileCompleted => 'Completado';

  @override
  String get mobileCompletionAfterStart =>
      'La finalización debe ser posterior al inicio.';

  @override
  String get mobileCreateRouteFirst =>
      'Crea una ruta para empezar a planificar.';

  @override
  String get mobileCreateSchedule => 'Crear programación';

  @override
  String get mobileCreateTrip => 'Crear viaje';

  @override
  String get mobileDeleteSchedule => 'Eliminar programación';

  @override
  String get mobileDiscardChanges => 'Descartar cambios';

  @override
  String get mobileDiscardTrip => '¿Descartar cambios del viaje?';

  @override
  String get mobileEditRecurring => 'Editar programación recurrente';

  @override
  String get mobileEditSchedule => 'Editar programación';

  @override
  String get mobileEndDate => 'Fecha de fin';

  @override
  String get mobileEndSchedule => 'Finalizar programación';

  @override
  String get mobileEndTime => 'Hora de fin';

  @override
  String get mobileEndTimeAfterStart =>
      'La hora de fin debe ser posterior al inicio.';

  @override
  String get mobileEndsOptional => 'Finaliza (opcional)';

  @override
  String get mobileTripTitleLength =>
      'Introduce un título de 2 a 120 caracteres.';

  @override
  String get mobileAtLeastTwo => 'Introduce al menos 2 caracteres';

  @override
  String get mobileAtLeastThree => 'Introduce al menos 3 caracteres';

  @override
  String get mobileExpandRoute => 'Ampliar mapa de ruta';

  @override
  String get mobileFitRoute => 'Ajustar ruta';

  @override
  String get mobileNoGpsPlanning =>
      'GPS no vinculado. Se puede planificar el viaje, pero no habrá seguimiento en directo.';

  @override
  String get mobileKeepEditing => 'Seguir editando';

  @override
  String get mobileKeepSchedule => 'Conservar programación';

  @override
  String get mobileLastKnownPosition => 'Última posición conocida';

  @override
  String get mobileLatestStart => 'Última hora de inicio';

  @override
  String get mobileNextMonth => 'Mes siguiente';

  @override
  String get mobileNoEligible =>
      'No hay vehículos disponibles que cumplan los requisitos.';

  @override
  String get mobileNoEligibleHelp =>
      'No hay vehículos elegibles. Asigna un conductor activo a un vehículo activo antes de planificar.';

  @override
  String get mobileNoRecordsView => 'No hay registros para esta vista.';

  @override
  String get mobileNoRouteGps =>
      'No hay ruta ni coordenadas GPS para este viaje.';

  @override
  String get mobileStopsWithoutGeometry =>
      'Paradas numeradas • trazado no disponible';

  @override
  String get mobilePause => 'Pausar';

  @override
  String get mobilePlanTrip => 'Planificar viaje';

  @override
  String get mobilePlannedNumbered => 'Ruta planificada • paradas numeradas';

  @override
  String get mobilePreviousMonth => 'Mes anterior';

  @override
  String get mobileReasonRemark => 'Motivo / observación';

  @override
  String get mobileRecurring => 'Recurrente';

  @override
  String get mobileRecurringSchedule => 'Programación recurrente';

  @override
  String get mobileRecurringActions => 'Acciones de programación recurrente';

  @override
  String get mobileRefreshPlanning => 'Actualizar opciones de planificación';

  @override
  String get mobileRefreshSchedule =>
      'Actualiza esta programación antes de editarla.';

  @override
  String get mobileRemarkOptional => 'Observación (opcional)';

  @override
  String get mobileRemoveEndDate => 'Quitar fecha de fin';

  @override
  String get mobileRepeatOn => 'Repetir los';

  @override
  String get mobileResume => 'Reanudar';

  @override
  String get mobileRoute => 'Ruta';

  @override
  String get mobileRunning => 'En curso';

  @override
  String get mobileSaveShareProof => 'Guardar o compartir comprobante';

  @override
  String get mobileSaveSchedule => 'Guardar programación';

  @override
  String get mobileSchedule => 'Programación';

  @override
  String get mobileScheduleSaved => 'Programación guardada';

  @override
  String get mobileSearchRoutes => 'Buscar rutas';

  @override
  String get mobileSearchVehicleDriver =>
      'Buscar vehículo, matrícula o conductor';

  @override
  String get mobileSkipDates => 'Omitir fechas (opcional)';

  @override
  String get mobileSkipDatesRange =>
      'Las fechas omitidas deben estar dentro del período programado.';

  @override
  String get mobileStartTime => 'Hora de inicio';

  @override
  String get mobileStarts => 'Comienza';

  @override
  String get mobileStatus => 'Estado';

  @override
  String get mobileSubmittedProofs => 'Comprobantes enviados';

  @override
  String get mobileAnyTimeDay =>
      'El conductor puede empezar en cualquier momento del día elegido.';

  @override
  String get mobileStartWindowHelp =>
      'El conductor puede comenzar en este intervalo. Su fin no es la hora de finalización del viaje.';

  @override
  String get mobileRequestFailed =>
      'No se pudo completar la solicitud. Actualiza e inténtalo de nuevo.';

  @override
  String get mobileRouteUnavailable =>
      'La ruta guardada no está disponible. Actualiza las rutas e inténtalo de nuevo.';

  @override
  String get mobileAccountTimeHelp =>
      'El viaje empieza a una hora concreta en la zona horaria de la cuenta.';

  @override
  String get mobilePdfPreviewFailed =>
      'No se pudo previsualizar el PDF. Usa Guardar o compartir para abrirlo en otra aplicación.';

  @override
  String get mobileImagePreviewFailed =>
      'No se pudo previsualizar la imagen. Usa Guardar o compartir para abrirla en otra aplicación.';

  @override
  String get mobileToday => 'Hoy';

  @override
  String get mobileTripCreated => 'Viaje creado';

  @override
  String get mobileTripDetails => 'Detalles del viaje';

  @override
  String get mobileTripRoute => 'Ruta del viaje';

  @override
  String get mobileTripTitle => 'Título del viaje';

  @override
  String get mobileProofShareFailed =>
      'No se pudo compartir el comprobante. Inténtalo de nuevo.';

  @override
  String get mobileUnavailableVehicles => 'Vehículos no disponibles';

  @override
  String get mobileMaxSkipDates => 'Usa como máximo 100 fechas omitidas';

  @override
  String get mobileRemarkLength =>
      'Usa como máximo 600 caracteres en la observación.';

  @override
  String get mobileValidDates => 'Usa fechas válidas en formato YYYY-MM-DD';

  @override
  String get mobileVehicleGpsPosition => 'Posición GPS del vehículo';

  @override
  String get mobileVehicleDriver => 'Vehículo y conductor';

  @override
  String get mobileVehicleRoute => 'Vehículo y ruta';

  @override
  String get mobileViewTrip => 'Ver viaje';

  @override
  String get mobileDatesPerLine => 'YYYY-MM-DD, una fecha por línea';

  @override
  String get mobileDiscardPlanningHelp =>
      'Se perderán los cambios no guardados. Las rutas guardadas seguirán disponibles.';

  @override
  String mobileTimesTimezone(Object timezone) {
    return 'Las horas usan $timezone.';
  }

  @override
  String mobileStopsCount(Object count) {
    return '$count paradas';
  }

  @override
  String mobileTripsCount(Object count) {
    return '$count viajes';
  }

  @override
  String mobileLoadMoreCount(Object loaded, Object total) {
    return 'Cargar más ($loaded de $total)';
  }

  @override
  String mobileScheduledDate(Object date) {
    return 'Programado: $date';
  }

  @override
  String mobileEndsDate(Object date) {
    return 'Finaliza: $date';
  }

  @override
  String mobileNextDate(Object date) {
    return 'Siguiente: $date';
  }

  @override
  String mobileGpsStatus(Object status) {
    return 'GPS del vehículo: $status';
  }

  @override
  String mobileLastPosition(Object date) {
    return 'Última posición: $date';
  }

  @override
  String mobileActualDistance(Object distance) {
    return 'Distancia real: $distance km';
  }

  @override
  String mobileTripScore(Object value) {
    return 'Puntuación del viaje: $value';
  }

  @override
  String mobileStopsProgress(Object completed, Object total) {
    return '$completed/$total paradas';
  }

  @override
  String mobileScheduleAction(Object action) {
    return '¿$action programación recurrente?';
  }

  @override
  String get dateRangeSelect => 'Seleccionar intervalo de fechas';

  @override
  String get dateRangeChoose => 'Elegir intervalo de fechas';

  @override
  String get dateTimeRangeChoose => 'Elegir intervalo de fechas y horas';

  @override
  String get dateRangeFrom => 'Desde';

  @override
  String get dateRangeTo => 'Hasta';

  @override
  String get dateRangeSelected => 'Intervalo seleccionado';

  @override
  String get dateRangeStartTime => 'Hora de inicio';

  @override
  String get dateRangeEndTime => 'Hora de fin';

  @override
  String get dateRangeSelectStartTime => 'Seleccionar hora de inicio';

  @override
  String get dateRangeSelectEndTime => 'Seleccionar hora de fin';

  @override
  String get dateRangeInvalidTime =>
      'La hora de fin debe ser posterior al inicio.';

  @override
  String get dateRangeCustom => 'Personalizado';

  @override
  String get dateRangeLastHour => 'Última hora';

  @override
  String get dateRangeLast3Hours => 'Últimas 3 horas';

  @override
  String get dateRangeLast6Hours => 'Últimas 6 horas';

  @override
  String get dateRangeLast12Hours => 'Últimas 12 horas';

  @override
  String get dateRangeLast24Hours => 'Últimas 24 horas';

  @override
  String get dateRangeToday => 'Hoy';

  @override
  String get dateRangeYesterday => 'Ayer';

  @override
  String get dateRangeThisWeek => 'Esta semana';

  @override
  String get dateRangeLastWeek => 'Semana pasada';

  @override
  String get dateRangeLast7Days => 'Últimos 7 días';

  @override
  String get dateRangeLast30Days => 'Últimos 30 días';

  @override
  String get apply => 'Aplicar';

  @override
  String get calendarToday => 'Hoy';

  @override
  String get calendarPreviousMonth => 'Mes anterior';

  @override
  String get calendarNextMonth => 'Mes siguiente';

  @override
  String get calendarExpiry => 'Vencimiento';

  @override
  String get legacyUi869d62ddcd => ' para habilitar el botón.';

  @override
  String get legacyUi7f4f41c8c3 => '#RRGGBB';

  @override
  String get legacyUi9515360684 => '+ Añadir dispositivo';

  @override
  String get legacyUi6116c134de => '+ Crear plan';

  @override
  String get legacyUic10e9a1c41 => '+ Crear usuario';

  @override
  String get legacyUi5e9a7040e4 => '2 dígitos';

  @override
  String get legacyUia0483eec37 => '3 dígitos';

  @override
  String get legacyUi3994dbd48e => '6–35 caracteres';

  @override
  String get legacyUi250e268e83 => 'De 7 a 15 dígitos';

  @override
  String get legacyUie69a9a5ee9 => 'Uso de los últimos 7 días';

  @override
  String get legacyUib8cee60c75 =>
      'Un subusuario solo puede usar las funciones y los informes disponibles en tu cuenta. Los ajustes y la seguridad de la cuenta siguen disponibles.';

  @override
  String get legacyUif0ee13e963 => 'Acceso restringido';

  @override
  String get legacyUi6e702cb4e0 => 'Estado de la cuenta';

  @override
  String get legacyUi6d6eba9279 => 'Acceso a la cuenta';

  @override
  String get legacyUi82cf8a5fc7 => 'Ajustes de la cuenta';

  @override
  String get legacyUi9beb96dac8 => 'Confirmar recepción';

  @override
  String get legacyUibf539b1d10 => 'Acme Logistics Pvt. Ltd.';

  @override
  String get legacyUic3cd636a58 => 'Acciones';

  @override
  String get legacyUia733b809d2 => 'Activo';

  @override
  String get legacyUi15cf579b89 => 'Duración activa';

  @override
  String get legacyUifaa171bc07 => 'Vehículo activo';

  @override
  String get legacyUibde34d0278 => 'Estado activo';

  @override
  String get legacyUi14c5b09cd4 => 'Detalles de la actividad';

  @override
  String get legacyUifbed23bc25 => 'Registros de actividad';

  @override
  String get legacyUie35effbf63 => 'Intervalo de fechas de actividad';

  @override
  String get legacyUicbd19b5c39 => 'Autor';

  @override
  String get legacyUi7980ca2475 => 'Usuario que realizó la acción';

  @override
  String get legacyUi4ac5084db4 => 'Añadir dispositivo o SIM';

  @override
  String get legacyUiaa752d14b8 => 'Añadir conductor';

  @override
  String get legacyUi224f2486e6 => 'Añadir inventario';

  @override
  String get legacyUi1836b111cd => 'Añadir fila de metadatos';

  @override
  String get legacyUi31dd5bb29e => 'Añadir equipo';

  @override
  String get legacyUi47b2149c9c => 'Añadir plan';

  @override
  String get legacyUic08d1e9d3f => 'Añadir sensor';

  @override
  String get legacyUi12071f1c87 => 'Añade un plan o modifica la búsqueda.';

  @override
  String get legacyUic0c181937e => 'Añadir atributo';

  @override
  String get legacyUi5367d642e2 => 'Añadir créditos';

  @override
  String get legacyUi1fa55e4562 => 'Añadir fila de metadatos';

  @override
  String get legacyUi7be087b7a7 => 'Añadir comprobante';

  @override
  String get legacyUib68734c259 => 'Añadido';

  @override
  String get legacyUi41b5f2e6ae => 'Notas adicionales';

  @override
  String get legacyUid5e920a5cb => 'Dirección';

  @override
  String get legacyUi7748043229 => 'Datos de dirección y ubicación.';

  @override
  String get legacyUi4faa35048a =>
      'Solicitud de inicio de sesión del administrador completada.';

  @override
  String get legacyUi1eda23758b => 'Administrador';

  @override
  String get legacyUi3df513225f => 'Administrador creado.';

  @override
  String get legacyUif981236722 => 'Vehículos afectados';

  @override
  String get legacyUib7fb586ff2 => 'Aeropuerto';

  @override
  String get legacyUi25f8c55de8 => 'Alarma';

  @override
  String get legacyUib5faca3a78 => 'Tipo de alerta';

  @override
  String get legacyUic03d80790d => 'Todos los administradores';

  @override
  String get legacyUi0b313a76be => 'Todos los países';

  @override
  String get legacyUiffeed47b5a => 'Todos los proveedores';

  @override
  String get legacyUi4745c5dce5 => 'Todo el período';

  @override
  String get legacyUieb672cb3ba => 'Todos los tipos';

  @override
  String get legacyUib4f25a1426 => 'Todos los usuarios';

  @override
  String get legacyUidd9eb32418 => 'Todos los vehículos';

  @override
  String get legacyUi060be00f4f => 'Todas las categorías';

  @override
  String get legacyUi0aaede0bb1 =>
      'Todas las notificaciones se han marcado como leídas.';

  @override
  String get legacyUi30c8a0fc9c => 'Todos los tipos';

  @override
  String get legacyUice832d9b31 => 'Todos los usuarios';

  @override
  String get legacyUie512a2f10a => 'Permitir historial';

  @override
  String get legacyUif8f993b052 => 'Permitir el acceso al historial de rutas.';

  @override
  String get legacyUi1ffee134b1 =>
      'Permitir que los visitantes accedan a un espacio de demostración.';

  @override
  String get legacyUie5d30dc481 => 'Intervalo permitido: 10–300';

  @override
  String get legacyUi22786d42cc => 'Altitud';

  @override
  String get legacyUi43dc8532f7 => 'Importe';

  @override
  String get legacyUi76aa32f207 => 'Importe *';

  @override
  String get legacyUia01154a861 => 'Modificar importe';

  @override
  String get legacyUi7d66157b06 =>
      'El importe debe estar entre 0.01 y 9999999.99';

  @override
  String get legacyUib34440b2cd => 'Modificar importe';

  @override
  String get legacyUib757c50159 => 'El importe admite hasta 2 decimales';

  @override
  String get legacyUic8c3ba95bb =>
      'Las estadísticas aparecerán cuando haya pagos disponibles.';

  @override
  String get legacyUif6c665f4fe =>
      'Las estadísticas aparecerán cuando haya transacciones disponibles.';

  @override
  String get legacyUi6b2a78a8f7 => 'Aplicar filtros';

  @override
  String get legacyUi2444928438 => 'Asignar';

  @override
  String get legacyUi561f6317fe => 'Asignar conductor';

  @override
  String get legacyUi3d2183f9ae => 'Asignar seleccionados';

  @override
  String get legacyUi5e97289597 => 'Asignar usuario';

  @override
  String get legacyUib8db201262 => 'Asignar vehículo';

  @override
  String get legacyUi20b5675c39 => 'Asignar vehículos';

  @override
  String get legacyUic403a13c66 =>
      'Asigna uno o varios vehículos a este subusuario.';

  @override
  String get legacyUie12261bf18 => 'Asigna usuarios a este conductor.';

  @override
  String get legacyUi41c90cdeef => 'Asigna usuarios a este vehículo.';

  @override
  String get legacyUi32265d6dad =>
      'Asigna vehículos para configurar las notificaciones básicas.';

  @override
  String get legacyUi117326ffd2 =>
      'Asigna vehículos para configurar las notificaciones de duración.';

  @override
  String get legacyUi74dfd6593f =>
      'Asigna vehículos para configurar las notificaciones de geocercas.';

  @override
  String get legacyUi8c6586176a =>
      'Asigna vehículos para configurar las notificaciones por exceso de velocidad.';

  @override
  String get legacyUi086854873d =>
      'Asigna vehículos para configurar las notificaciones de rutas.';

  @override
  String get legacyUie24e824b68 => 'Asignado';

  @override
  String get legacyUie94ba984c3 => 'Vehículos asignados';

  @override
  String get legacyUie55df441e8 => 'Asignación';

  @override
  String get legacyUi0c686b74d7 =>
      'Mínimo 5 caracteres. Los cambios quedan registrados.';

  @override
  String get legacyUi1afff0157c => 'Adjuntar';

  @override
  String get legacyUi0c431f4969 => 'Adjuntar archivo';

  @override
  String get legacyUi137135dbf6 => 'Adjuntar archivos';

  @override
  String get legacyUi2286866966 =>
      'La URL del archivo adjunto no está disponible.';

  @override
  String get legacyUib6b6277691 =>
      'La ruta del archivo adjunto no está disponible.';

  @override
  String get legacyUi1b30607d41 =>
      'Las claves de los atributos deben ser únicas.';

  @override
  String get legacyUia6652617f2 => 'Atributos';

  @override
  String get legacyUi7c62a14244 => 'Disponible';

  @override
  String get legacyUicdc93143c6 => 'Promedio';

  @override
  String get legacyUib1ff8731de => 'Velocidad media';

  @override
  String get legacyUi3e6e9b59e4 => 'Tokens del servidor';

  @override
  String get legacyUib15950ccc9 => 'Tokens del servidor';

  @override
  String get legacyUief5c48114b => 'Verificado por el servidor';

  @override
  String get legacyUidd96994d01 => 'Copia de seguridad';

  @override
  String get legacyUi775fe0e609 => 'Copia de seguridad / Retención de datos';

  @override
  String get legacyUi17ef50d8f8 => 'Transferencia bancaria';

  @override
  String get legacyUi1007a1a728 =>
      'Referencia bancaria / UTR / ID de transacción';

  @override
  String get legacyUi5be1ae92e8 =>
      'Nota de transferencia / UTR / Referencia de transacción';

  @override
  String get legacyUi6b57349e97 => 'Ajustes de la URL base';

  @override
  String get legacyUiaa2c96dacf => 'Básico';

  @override
  String get legacyUic73c27be48 =>
      'Credenciales básicas para el acceso del conductor.';

  @override
  String get legacyUi904d23cb6a => 'Identificación básica del nuevo vehículo.';

  @override
  String get legacyUi99613c74ce => 'Bloqueado';

  @override
  String get legacyUi584522b903 => 'Datos de marca y contacto';

  @override
  String get legacyUibfc8921ede => 'Color de marca';

  @override
  String get legacyUi54a2cf5e63 => 'Navegador';

  @override
  String get legacyUi73e0b16797 =>
      'Icono de la pestaña del navegador. ICO, PNG o SVG. Máximo 2 MB.';

  @override
  String get legacyUicfadbd7a57 => 'Por';

  @override
  String get legacyUi42878ce3fa => 'Uso de CPU';

  @override
  String get legacyUi37efa8a990 => 'Cafetería';

  @override
  String get legacyUi26b937c51d => '¿Cancelar la solicitud de renovación?';

  @override
  String get legacyUi84837a2168 => 'Cancelar solicitud';

  @override
  String get legacyUi2738a0a1db =>
      'No se pueden cargar los comandos sin los datos del vehículo.';

  @override
  String get legacyUi4d4ce73b15 => 'Tarjeta';

  @override
  String get legacyUi758ec54e43 => 'Efectivo';

  @override
  String get legacyUi6ccb60071b => 'Categorías';

  @override
  String get legacyUi49289db43e => 'Cambiar contraseña';

  @override
  String get legacyUi6fc0529f2d => 'Cambiar estado';

  @override
  String get legacyUica5df1dad1 => 'Elegir intervalo de fecha y hora';

  @override
  String get legacyUid2174d8075 => 'Elegir intervalo de reproducción';

  @override
  String get legacyUi66542fe55c =>
      'Elige un plan, una fecha de registro y un motivo de entre 5 y 500 caracteres.';

  @override
  String get legacyUi7db804aa37 =>
      'Elige los vehículos, el vencimiento y las opciones para compartir.';

  @override
  String get legacyUi037c5eba86 => 'Ciudad (opcional)';

  @override
  String get legacyUief153831d1 => 'La ciudad es obligatoria.';

  @override
  String get legacyUi8da6bb0466 => 'Limpieza completada';

  @override
  String get legacyUi381c4bf1d4 => 'Borrar filtros';

  @override
  String get legacyUicdb64ef80e => 'Borrar intervalo de fechas';

  @override
  String get legacyUid3c69afc35 => 'Borrar fechas';

  @override
  String get legacyUi1bf7452cd6 => 'Borrar vencimiento';

  @override
  String get legacyUi40b66a41b8 => 'Borrar fecha de vencimiento';

  @override
  String get legacyUi92e60a4db3 => 'Borrar reproducción';

  @override
  String get legacyUi53dde4f2c0 =>
      'Los ingresos de los clientes aparecerán cuando se registren pagos.';

  @override
  String get legacyUide4e7f6fad => 'Cerrar menú lateral';

  @override
  String get legacyUi3dc631324c => 'Cerrar mapa';

  @override
  String get legacyUid75dc68bbd => 'Agrupación';

  @override
  String get legacyUiadac69379a => 'Código';

  @override
  String get legacyUiea6ac41a6a => 'El código es obligatorio.';

  @override
  String get legacyUi5b0f7590d0 => 'Cobrado';

  @override
  String get legacyUi8901895fb1 => 'Comando';

  @override
  String get legacyUif7e08456d0 => 'Detalles del comando';

  @override
  String get legacyUi6c4cb3de03 => 'Texto del comando';

  @override
  String get legacyUibfed234d46 => 'Comando no disponible';

  @override
  String get legacyUi45e5f3f72e => 'Comandos';

  @override
  String get legacyUi7a1994999d => 'Empresa';

  @override
  String get legacyUi8599f5cc48 => 'Nombre de la empresa';

  @override
  String get legacyUi1e5f7dc45c => 'Nombre de la empresa';

  @override
  String get legacyUib55887f633 => 'Empresa actualizada';

  @override
  String get legacyUi657063c67c => 'Empresa actualizada.';

  @override
  String get legacyUif1ab0a6f4e => 'Completar manualmente';

  @override
  String get legacyUif14ebb39ce => 'Versión de configuración';

  @override
  String get legacyUi755bea99c0 => 'Configuración actualizada.';

  @override
  String get legacyUic69463a5a9 => 'Configurar el envío de correo.';

  @override
  String get legacyUic2d404cb7b => 'Confirmar contraseña';

  @override
  String get legacyUiea3723a45c => 'Confirmar ampliación de acceso';

  @override
  String get legacyUi4a7c565d4c => 'Confirmar contraseña';

  @override
  String get legacyUi5febc18b54 => 'Confirmar pago';

  @override
  String get legacyUi05a7fffae1 => 'Confirmar pago recibido';

  @override
  String get legacyUi90d96c7cec => 'Frase de confirmación';

  @override
  String get legacyUic2f9b7b489 => 'Conectado';

  @override
  String get legacyUib37456c453 => 'Contacto';

  @override
  String get legacyUicc11b3a28f => 'Contexto';

  @override
  String get legacyUi3cf29aa7f5 => 'Ralentí continuo';

  @override
  String get legacyUic352b92e1f => 'Movimiento continuo';

  @override
  String get legacyUi347d3dbf17 => 'Parada continua';

  @override
  String get legacyUi49fdb038f4 => 'Controla lo que pueden ver los visitantes.';

  @override
  String get legacyUi02c6c04dec => 'Copiar KML';

  @override
  String get legacyUi44fe06869f => 'Copiar encabezado';

  @override
  String get legacyUi3a9d77c901 => 'No se pudo abrir la URL';

  @override
  String get legacyUi0c09a7eccc => 'No se pudo abrir el archivo adjunto.';

  @override
  String get legacyUif2344997aa => 'No se pudo abrir el documento.';

  @override
  String get legacyUi2209ab63ce => 'No se pudo abrir el archivo.';

  @override
  String get legacyUi5905ce4109 =>
      'No se pudo abrir el archivo. Enlace copiado.';

  @override
  String get legacyUi9b09f53bdd => 'No se pudo abrir el enlace.';

  @override
  String get legacyUi72be0e8616 => 'No se pudo seleccionar el archivo';

  @override
  String get legacyUi76e835f8c3 => 'No se pudo seleccionar el archivo.';

  @override
  String get legacyUiaef46d6729 => 'No se pudo leer el archivo seleccionado';

  @override
  String get legacyUi280c98ccef => 'Filtro de país';

  @override
  String get legacyUi1c9a9315c9 => 'El país es obligatorio.';

  @override
  String get legacyUid82b56cad9 => 'Rumbo';

  @override
  String get legacyUi6e157c5da4 => 'Crear';

  @override
  String get legacyUi318d1da4e0 => 'Crear administrador';

  @override
  String get legacyUi0a62dd4d37 => 'Crear conductor';

  @override
  String get legacyUie3429ab78d => 'Crear geocerca';

  @override
  String get legacyUidb7c457634 => 'Crear punto de interés';

  @override
  String get legacyUicdd060d443 => 'Crear plan de precios';

  @override
  String get legacyUi5d16c5ffd7 => 'Crear subusuario';

  @override
  String get legacyUiafe9a7ae15 => 'Crear solicitud de soporte';

  @override
  String get legacyUib25c91fe61 => 'Crear usuario';

  @override
  String get legacyUi705b0946b2 => 'Crear vehículo';

  @override
  String get legacyUi22a6b9d964 =>
      'Crea un panel en la aplicación web para verlo aquí.';

  @override
  String get legacyUi769479a4d5 =>
      'Crea un enlace público para compartir el seguimiento del vehículo en tiempo real.';

  @override
  String get legacyUi50aab1f7b5 => 'Crea un sensor para este vehículo.';

  @override
  String get legacyUi0d2cd08b59 => 'Crear administrador';

  @override
  String get legacyUi6f876ff9c0 =>
      'Crea al menos un elemento antes de exportar.';

  @override
  String get legacyUic42adee4d7 =>
      'Crear un dispositivo sin salir de este formulario';

  @override
  String get legacyUiaba922c9b5 => 'Crear conductor';

  @override
  String get legacyUi6efd8652f4 =>
      'Crea conductores y gestiona sus vehículos asignados, documentos y actividad.';

  @override
  String get legacyUiba98384ac3 =>
      'Crea geocercas para configurar las notificaciones de geocercas.';

  @override
  String get legacyUif7b868f7d4 =>
      'Crea puntos de interés con categoría, icono, color y radio de tolerancia.';

  @override
  String get legacyUie42ed33e33 =>
      'Crear un plan de precios sin salir de este formulario';

  @override
  String get legacyUie40f966076 =>
      'Crea líneas de ruta manualmente o a partir del origen y el destino, cuando esté disponible.';

  @override
  String get legacyUi567e040ce2 =>
      'Crea rutas para configurar las notificaciones por desvío de ruta.';

  @override
  String get legacyUica09bbf34d =>
      'Crea subusuarios y controla los vehículos a los que pueden acceder.';

  @override
  String get legacyUi3afcbed7e6 => 'Crear solicitud de soporte';

  @override
  String get legacyUibdbcfa0af0 => 'Crear usuario';

  @override
  String get legacyUie7358de58e =>
      'Crear un usuario sin salir de este formulario de vehículo';

  @override
  String get legacyUi505a950fbb => 'Crear vehículo';

  @override
  String get legacyUi1ef0c932b3 =>
      'Crea tu primer conductor para empezar a asignar tareas.';

  @override
  String get legacyUi7d3ca14313 =>
      'Crea tu primera geocerca para definir los límites operativos.';

  @override
  String get legacyUi60a39e1fde =>
      'Crea tu primer lugar para registrar puntos operativos.';

  @override
  String get legacyUi4fbf4f09cd =>
      'Crea tu primer subusuario para compartir el acceso seleccionado.';

  @override
  String get legacyUiaccf40c89b => 'Creado';

  @override
  String get legacyUia5682ef199 => 'Creado: ';

  @override
  String get legacyUi5db1542e68 => 'Fecha de creación';

  @override
  String get legacyUif1c69716be => 'Fecha de creación';

  @override
  String get legacyUidd097a2297 => 'Credenciales';

  @override
  String get legacyUi9f58b9e39b =>
      'Credenciales que usará el administrador para acceder a OpenVTS.';

  @override
  String get legacyUiec535bab6f =>
      'Credenciales que usará el usuario para acceder a OpenVTS.';

  @override
  String get legacyUi8a45d339a6 => 'Crédito';

  @override
  String get legacyUic3dc6e3ef9 =>
      'Las actualizaciones de créditos, pagos o facturación aparecerán aquí.';

  @override
  String get legacyUibfac50d642 => 'Créditos';

  @override
  String get legacyUie070de2244 => 'Moneda';

  @override
  String get legacyUiea4b114ac6 => 'Estado actual';

  @override
  String get legacyUieeed986410 => 'Créditos actuales';

  @override
  String get legacyUibe1ac4e322 => 'Paso actual';

  @override
  String get legacyUi9c378938cd => 'Comando personalizado';

  @override
  String get legacyUi28be3fd018 => 'Dominio personalizado';

  @override
  String get legacyUif130609dfc => 'Intervalo personalizado';

  @override
  String get legacyUia9d9e61bf2 =>
      'Categoría personalizada (p. ej., «proveedor»)';

  @override
  String get legacyUi0354c8896b => 'Dominio personalizado';

  @override
  String get legacyUi3a55eba66f => 'Dominio personalizado y color de marca.';

  @override
  String get legacyUi9f1d0368da => 'Vencimiento del cliente';

  @override
  String get legacyUi1588fe44aa => 'Fecha de vencimiento del cliente';

  @override
  String get legacyUib13a49701d => 'Solicitudes de renovación de clientes';

  @override
  String get legacyUi0c919bd08d => 'Vencimiento del servicio del cliente';

  @override
  String get legacyUidce04fd315 => 'Personalizado…';

  @override
  String get legacyUi118de3988f => 'Fecha límite';

  @override
  String get legacyUi5c487cb2d8 =>
      'No hay datos de ingresos diarios para este intervalo.';

  @override
  String get legacyUi99c0019cc6 => 'Logotipo para modo oscuro';

  @override
  String get legacyUia167278399 => 'Logotipo para modo oscuro actualizado';

  @override
  String get legacyUi2b197ef6be =>
      'Los registros de la base de datos y de telemetría en tiempo real aparecerán aquí.';

  @override
  String get legacyUi6bb4b674b3 => 'Intervalo de fechas';

  @override
  String get legacyUie3d06ca6a1 => 'Intervalo de fecha y hora';

  @override
  String get legacyUic65ea4ae01 => 'Intervalo de fechas';

  @override
  String get legacyUi853aab7f56 => 'Fecha y hora';

  @override
  String get legacyUi842b7b5d71 => 'Fechas';

  @override
  String get legacyUi987b9ced08 => 'Día';

  @override
  String get legacyUi82c29dd5fa => 'Comparación entre día y noche';

  @override
  String get legacyUibfb1ba6e3e => 'Intervalo diurno y nocturno';

  @override
  String get legacyUicf558941e0 => 'Débito';

  @override
  String get legacyUibb3cec5175 => 'Descontar créditos';

  @override
  String get legacyUi6bccca646f => 'Descontado';

  @override
  String get legacyUi1dcab135ef => 'Eliminar duplicados';

  @override
  String get legacyUi15462a4954 => 'Eliminar eventos duplicados';

  @override
  String get legacyUi6184deb041 => 'Plan predeterminado';

  @override
  String get legacyUiee1b9a9f23 => 'Eliminar cuenta';

  @override
  String get legacyUie81c14c990 => 'Eliminar conductor';

  @override
  String get legacyUi749f8e14e3 => 'Eliminar subusuario';

  @override
  String get legacyUi0a0a90f6c5 => 'Eliminar usuario';

  @override
  String get legacyUi4bcd1233a1 => 'Eliminar administrador';

  @override
  String get legacyUi6fd38c1fb9 => 'Eliminar administrador';

  @override
  String get legacyUie8df0b7902 => 'Eliminar documento';

  @override
  String get legacyUi4ecae3e148 => '¿Eliminar documento?';

  @override
  String get legacyUid1571af327 => 'Eliminar cuenta del conductor';

  @override
  String get legacyUia34ada32da => 'Eliminar sensor';

  @override
  String get legacyUi1ce5593800 => '¿Eliminar este documento?';

  @override
  String get legacyUi6a58093cab => 'Eliminar enlace de seguimiento';

  @override
  String get legacyUi9afe6c7b95 => 'Eliminar usuario';

  @override
  String get legacyUif7ff7065a9 => 'Eliminar vehículo';

  @override
  String get legacyUi441bda6cd8 => 'Eliminado';

  @override
  String get legacyUif7c094a571 => 'Filas eliminadas';

  @override
  String get legacyUic6bdaac949 => 'Delhi';

  @override
  String get legacyUibc4f986ecb => 'Entregas';

  @override
  String get legacyUi921a6f6b55 => 'Registros de entrega';

  @override
  String get legacyUib2c4e6cb46 => 'Acceso a la demostración';

  @override
  String get legacyUi4675a25777 => 'Acceso a la demostración';

  @override
  String get legacyUi59013d16af => 'Describe la solicitud o el problema';

  @override
  String get legacyUi55f8ebc805 => 'Descripción';

  @override
  String get legacyUi388de6fa3a => 'Descripción (opcional)';

  @override
  String get legacyUi763630a9ce => 'La descripción es obligatoria.';

  @override
  String get legacyUi8a96cce5e5 =>
      'La descripción debe contener al menos una letra o un número.';

  @override
  String get legacyUidc3decbb93 => 'Detalles';

  @override
  String get legacyUia5a74a6df0 => 'Dispositivo';

  @override
  String get legacyUid69ba8a9eb => 'Dispositivo + SIM';

  @override
  String get legacyUic587837fda => 'IMEI del dispositivo';

  @override
  String get legacyUif59a7a21bb => 'Instalaciones de dispositivos';

  @override
  String get legacyUi219288726d => 'Solo dispositivo';

  @override
  String get legacyUi554dd558bd => 'Resumen de dispositivos';

  @override
  String get legacyUi20d5df8b4a => 'Tipo de dispositivo';

  @override
  String get legacyUi30de920ef1 => 'Dispositivo creado y seleccionado';

  @override
  String get legacyUi3c47b57c83 => 'Respuesta del dispositivo';

  @override
  String get legacyUi6d2870160a => 'Hora del dispositivo';

  @override
  String get legacyUi21fe5a18d0 => 'Dispositivo actualizado.';

  @override
  String get legacyUidf485c8713 => 'Dispositivos';

  @override
  String get legacyUibb73469225 => 'Desactivar sin eliminar el enlace.';

  @override
  String get legacyUid3e4b30e10 => 'Descartar y actualizar';

  @override
  String get legacyUi427dc4f0cd => '¿Descartar el nuevo administrador?';

  @override
  String get legacyUid1b8679c63 => '¿Descartar el nuevo usuario?';

  @override
  String get legacyUi6012a2d760 => '¿Descartar el nuevo vehículo?';

  @override
  String get legacyUifb0a3e6787 => 'Uso del disco';

  @override
  String get legacyUi70afe9eff3 => 'Cerrar';

  @override
  String get legacyUi515aa7ad86 =>
      'Mostrar el contexto de las geocercas asignadas.';

  @override
  String get legacyUi37bbdde1a6 =>
      'Mostrar los límites de las geocercas en el mapa';

  @override
  String get legacyUi2eebf5225a => 'Mostrar las rutas guardadas en el mapa';

  @override
  String get legacyUifb71a3779e => 'Multiplicador de distancia';

  @override
  String get legacyUib3262ecb53 => 'Variación de distancia';

  @override
  String get legacyUiac3f0eb0ea => 'Distancia/horas';

  @override
  String get legacyUi2c21f68832 => 'Tipo de documento';

  @override
  String get legacyUi7615530d7a => 'La URL del documento no está disponible.';

  @override
  String get legacyUi6dad05c10e => 'Acciones del documento';

  @override
  String get legacyUibd9a0f027e => 'Documento eliminado.';

  @override
  String get legacyUi3859bdaa8c => 'Título del documento';

  @override
  String get legacyUi300b6ef0cd => 'Tipo de documento';

  @override
  String get legacyUi9b10914d8b => 'Dominio';

  @override
  String get legacyUifb349182fc => 'Dominio y color';

  @override
  String get legacyUi8b58eea04e => 'Dominio y color de marca guardados';

  @override
  String get legacyUi0ec2ae5cda =>
      'Dominio, logotipos, icono de pestaña y color de marca.';

  @override
  String get legacyUibfa50c7a38 => 'Dibujar';

  @override
  String get legacyUi2e617aeb36 =>
      'Dibuja círculos, polígonos, rectángulos y límites lineales en el mapa.';

  @override
  String get legacyUid952b9d3da =>
      'Dibuja tu primer corredor de ruta para iniciar el seguimiento.';

  @override
  String get legacyUi0ecf1d5bc0 => 'Recorrido';

  @override
  String get legacyUi845a6bd3ab => 'Perfil del conductor';

  @override
  String get legacyUi450d68e4fe => 'Acciones del conductor';

  @override
  String get legacyUid1ba6aea38 => 'Conductor asignado.';

  @override
  String get legacyUifbaa386fbc =>
      'Las asignaciones y la actividad del perfil del conductor aparecerán aquí.';

  @override
  String get legacyUi017bb97653 => 'Conductor creado.';

  @override
  String get legacyUif8acdd5348 =>
      'Las altas y las actualizaciones de conductores aparecerán aquí.';

  @override
  String get legacyUib057fefdc2 => 'Conductor eliminado.';

  @override
  String get legacyUi63a7342acd => 'Nombre del conductor';

  @override
  String get legacyUi8d30cc59a1 => 'Asignación del conductor eliminada.';

  @override
  String get legacyUia010b0a25f => 'Conductor actualizado.';

  @override
  String get legacyUifdd68e9960 => 'Espacio del conductor';

  @override
  String get legacyUi3d14659ca9 => 'Simulación';

  @override
  String get legacyUi87bd16c150 => 'Simulación completada';

  @override
  String get legacyUi91310be76f => 'Dubái';

  @override
  String get legacyUi1370004da7 => 'Duración';

  @override
  String get legacyUia051787af6 =>
      'Cada archivo adjunto debe ser de 5 MB o menos.';

  @override
  String get legacyUi9bb58b2d1b => 'Este';

  @override
  String get legacyUi7de491bedc => 'Editar empresa';

  @override
  String get legacyUi5b7faa9d61 => 'Editar dispositivo';

  @override
  String get legacyUicf5ddc10b3 => 'Editar conductor';

  @override
  String get legacyUi13a7a7c3a7 => 'Editar plan';

  @override
  String get legacyUicd280a41f7 => 'Editar perfil';

  @override
  String get legacyUi19d57bd021 => 'Editar SIM';

  @override
  String get legacyUi4a0fe224b9 => 'Editar sensor';

  @override
  String get legacyUic8e262db5b => 'Editar subusuario';

  @override
  String get legacyUi38a1cb0f89 => 'Editar miembro del equipo';

  @override
  String get legacyUi0e457253ad => 'Editar usuario';

  @override
  String get legacyUib213eb6d7b => 'Editar vehículo';

  @override
  String get legacyUid03750ccbf => 'Editar empresa';

  @override
  String get legacyUi15141eab3a => 'Editar perfil';

  @override
  String get legacyUi84add5b295 => 'Correo electrónico';

  @override
  String get legacyUi5c10b588a9 => 'Correo electrónico (opcional)';

  @override
  String get legacyUi094f6a5934 => 'Correo electrónico o nombre de usuario';

  @override
  String get legacyUi79d1feaf62 => 'Estado del correo electrónico';

  @override
  String get legacyUia674e88b73 => 'Verificación del correo electrónico';

  @override
  String get legacyUic1feb155ec => 'Habilitar acceso a la demostración';

  @override
  String get legacyUi7cf7a0d02a => 'Habilitar registro público';

  @override
  String get legacyUif6321257f1 => 'Habilitar este enlace público.';

  @override
  String get legacyUid093b28018 => 'Habilitar/Actualizar';

  @override
  String get legacyUi0af149c2ed => 'Cifrado';

  @override
  String get legacyUic1f65ddb75 => 'Motor';

  @override
  String get legacyUi49dda3d71a => 'Horas de motor';

  @override
  String get legacyUi4c9c7856d1 => 'Introduce el código de 6 dígitos';

  @override
  String get legacyUibc96ad8350 =>
      'Introduce un importe con un máximo de 2 decimales';

  @override
  String get legacyUib0e59c93d7 => 'Introduce un importe válido.';

  @override
  String get legacyUi6d59e6aee7 =>
      'Introduce un motivo de modificación de entre 5 y 500 caracteres';

  @override
  String get legacyUi571c7347b7 =>
      'Introduce un motivo de modificación de entre 5 y 500 caracteres.';

  @override
  String get legacyUi18b809c9fb => 'Introduce el texto del comando';

  @override
  String get legacyUid5cd51c7b9 => 'Introduce la cantidad de créditos';

  @override
  String get legacyUibe7572b6c5 => 'Introduce el estado o territorio';

  @override
  String get legacyUid148321ad7 => 'Introduce el código de 6 dígitos';

  @override
  String get legacyUi0d639c50f1 =>
      'Introduce el código de 6 dígitos que te enviamos';

  @override
  String get legacyUi6d1e849865 =>
      'Introduce el código de un solo uso enviado a tu contacto registrado.';

  @override
  String get legacyUied634c4edc =>
      'Introduce el correo electrónico o el nombre de usuario que utilizas para acceder. Si la cuenta existe, te enviaremos un enlace de restablecimiento con validez limitada.';

  @override
  String get legacyUi1378167d52 => 'Introduce tu contraseña';

  @override
  String get legacyUib6334ab817 =>
      'Introduce tu nombre de usuario o correo electrónico';

  @override
  String get legacyUic7fb317725 => 'Entidad';

  @override
  String get legacyUi04d694e298 => 'ID de entidad';

  @override
  String get legacyUi948542c1d6 => 'Error/Crítico';

  @override
  String get legacyUic250d77524 => 'Detalles del evento';

  @override
  String get legacyUi894b1c749d => 'ID de evento';

  @override
  String get legacyUif8e451a5d0 => 'Eventos no disponibles';

  @override
  String get legacyUief09596668 => 'Salir de la demostración';

  @override
  String get legacyUia689a999a5 => 'Vencido';

  @override
  String get legacyUib98d67213b => 'Próximo a vencer';

  @override
  String get legacyUi57fe01159c => 'Fecha de vencimiento (opcional)';

  @override
  String get legacyUi1275b51587 => 'Fecha y hora de vencimiento';

  @override
  String get legacyUi6b440cd506 => 'Fecha de vencimiento';

  @override
  String get legacyUic9f6710324 => 'La fecha de vencimiento debe ser futura.';

  @override
  String get legacyUif3e4fadb9e => 'Exportar';

  @override
  String get legacyUi416a52a386 => 'Exportar KML';

  @override
  String get legacyUi09b28aeb8d => 'Token de FCM';

  @override
  String get legacyUic2bf1a9df5 => 'Últimos 10 caracteres del token de FCM';

  @override
  String get legacyUi82da67b211 => 'Facebook';

  @override
  String get legacyUi09fef5d8d9 => 'Error';

  @override
  String get legacyUid68666787d => 'Tablas con errores';

  @override
  String get legacyUi706b9a59b6 => 'No se pudieron cargar las ciudades';

  @override
  String get legacyUi6eb9516fdf => 'No se pudieron cargar los países';

  @override
  String get legacyUi4bc4b2e555 => 'No se pudieron cargar los detalles';

  @override
  String get legacyUia7bc426a05 =>
      'No se pudieron cargar todos los datos del vehículo.';

  @override
  String get legacyUia17267ffa7 => 'No se pudieron cargar los estados';

  @override
  String get legacyUi6bb1f1d9fb => 'No se pudo actualizar el estado.';

  @override
  String get legacyUi1656649117 => 'Fallo';

  @override
  String get legacyUib7ef43c84d => 'Código de error';

  @override
  String get legacyUi41510b1b21 => 'Mensaje de error';

  @override
  String get legacyUi8db6a2f1d3 => 'Rápido';

  @override
  String get legacyUiadc7ac2ae5 => 'Más rápido';

  @override
  String get legacyUib0f47aaf77 => 'Icono de pestaña';

  @override
  String get legacyUi7d9baea15f => 'Icono de pestaña actualizado';

  @override
  String get legacyUi2c3cafa4db => 'Archivo';

  @override
  String get legacyUi55fee60744 => 'La URL del archivo no está disponible.';

  @override
  String get legacyUif76f22f075 => 'El archivo supera el límite de 10 MB.';

  @override
  String get legacyUi7e184124be => 'El archivo es obligatorio.';

  @override
  String get legacyUi36f2202687 => 'El archivo debe ser de 10 MB o menos.';

  @override
  String get legacyUi937fd74b36 => 'Filtrar tarjetas SIM';

  @override
  String get legacyUi15db08d15e => 'Filtrar registros de actividad';

  @override
  String get legacyUi582198fab2 => 'Filtrar administradores';

  @override
  String get legacyUi9911a4c0ed => 'Filtrar dispositivos';

  @override
  String get legacyUi6a7fe2dc2c => 'Filtrar conductores';

  @override
  String get legacyUi5439ccf95d => 'Filtrar geocercas';

  @override
  String get legacyUif1fe9835a2 => 'Filtrar equipo';

  @override
  String get legacyUi8cfc14a859 => 'Filtrar usuarios';

  @override
  String get legacyUia9d1432d0d => 'Filtrar vehículos';

  @override
  String get legacyUiaa234fb61d => 'Firebase';

  @override
  String get legacyUib15839eae8 => 'Firebase inicializado';

  @override
  String get legacyUi916a78d701 => 'Primero';

  @override
  String get legacyUic617ebad3b =>
      'Corrige los errores de validación antes de probar';

  @override
  String get legacyUi4d4e9621c4 => 'Estado de la flota';

  @override
  String get legacyUi1cc8d18151 => '¿Olvidaste tu contraseña?';

  @override
  String get legacyUibaa0e2872d => 'Créditos de registro gratuito';

  @override
  String get legacyUi236ddee138 => 'Del administrador';

  @override
  String get legacyUi19fe826cc8 => 'Correo del remitente';

  @override
  String get legacyUi64346b483c => 'Nombre completo';

  @override
  String get legacyUi9f8ce19bf4 => 'Dirección completa';

  @override
  String get legacyUieeb692087d => 'Nombre completo';

  @override
  String get legacyUifcee5b52cc => 'Desfase GMT';

  @override
  String get legacyUi590df4df1f =>
      'El desfase GMT debe tener el formato +05:30.';

  @override
  String get legacyUi0933ed5657 => 'Modelo GPS';

  @override
  String get legacyUicbb0014411 => 'Gasolinera';

  @override
  String get legacyUifc45f9b7a9 => 'Generar';

  @override
  String get legacyUi549f31c53e => 'Generar ruta';

  @override
  String get legacyUidfde035f40 => 'Geocodificación';

  @override
  String get legacyUi5cdf1dbd7e => 'Geocercas';

  @override
  String get legacyUic09b487feb => 'Obtener reproducción';

  @override
  String get legacyUi5442e2b64f => 'GitHub';

  @override
  String get legacyUi1efbf15894 =>
      'Agrupar vehículos cercanos al alejar el mapa';

  @override
  String get legacyUiac69db7d02 => 'Gráfico de crecimiento';

  @override
  String get legacyUibc4359231d => 'Gimnasio';

  @override
  String get legacyUifa8a6b01e3 => 'Encabezado copiado';

  @override
  String get legacyUi071c1366b0 =>
      'Una mayor precisión requiere más consultas.';

  @override
  String get legacyUi90ccd64974 => 'Historial';

  @override
  String get legacyUic3669ffe53 =>
      'El historial necesita un vehículo con IMEI procedente de la telemetría en tiempo real.';

  @override
  String get legacyUi8d4a22ea2b =>
      'Los valores del historial no son numéricos.';

  @override
  String get legacyUidbb927867e => 'Hospital';

  @override
  String get legacyUi3960ec4ca5 => 'Servidor';

  @override
  String get legacyUiadd03be31a => 'Servidor, puerto y cifrado.';

  @override
  String get legacyUi9c4ba7d047 => 'Hotel';

  @override
  String get legacyUi1e3beed01c =>
      'Tiempo de conservación del historial antes de la limpieza.';

  @override
  String get legacyUi2635a51635 =>
      'Cómo se identificará al administrador en la plataforma.';

  @override
  String get legacyUi0f053057ee =>
      'Cómo se identificará al usuario en la plataforma.';

  @override
  String get legacyUi077f5f9dad => 'Ya tengo un enlace de restablecimiento';

  @override
  String get legacyUibff7cfa991 => 'ICCID (opcional)';

  @override
  String get legacyUidc7458a51a =>
      'Se necesita el IMEI para cargar los registros de telemetría.';

  @override
  String get legacyUif4c88fb92e =>
      'Se necesita el IMEI para cargar los eventos del vehículo.';

  @override
  String get legacyUi7e77081c51 => 'Se necesita el IMEI para enviar comandos.';

  @override
  String get legacyUif44426c787 =>
      'Este vehículo no tiene un IMEI disponible. Solo se muestra el resumen del mapa en tiempo real.';

  @override
  String get legacyUi8a4b9cf4a9 => 'Falta el IMEI';

  @override
  String get legacyUi11da2cb7f0 => 'IMSI (opcional)';

  @override
  String get legacyUi716f63b96e => 'Icono';

  @override
  String get legacyUi7e5a975b6a => 'Identidad';

  @override
  String get legacyUi2d40c36445 => 'Encendido';

  @override
  String get legacyUif2d738d99c => 'Origen del estado de encendido';

  @override
  String get legacyUi4157fc56ab =>
      'La imagen es demasiado grande. Máximo 2 MB.';

  @override
  String get legacyUifcf7141427 =>
      'La imagen es demasiado grande. Máximo 5 MB.';

  @override
  String get legacyUieeec98db23 => 'Importar CSV';

  @override
  String get legacyUieebd26ef51 => 'Inactivo: 48 h';

  @override
  String get legacyUi4b631f6984 => 'Información';

  @override
  String get legacyUi29981bf033 =>
      'Saldo inicial de créditos asignado a esta cuenta de administrador.';

  @override
  String get legacyUi58984ab1ac => 'Créditos iniciales';

  @override
  String get legacyUi5721bbef40 => 'Instagram';

  @override
  String get legacyUi9b5ca633e8 => 'Créditos insuficientes en la cuenta';

  @override
  String get legacyUi2ab95a4afe => 'ID de administrador no válido.';

  @override
  String get legacyUicfa3e9c7e1 => 'Elemento de inventario creado.';

  @override
  String get legacyUi32091e3797 => 'Estado del inventario';

  @override
  String get legacyUia430dcf58c => 'Jane Smith';

  @override
  String get legacyUi049874e4f7 => 'KML copiado al portapapeles';

  @override
  String get legacyUi62fc561458 => 'Mantener solicitud';

  @override
  String get legacyUic67dd20ee8 => 'Clave';

  @override
  String get legacyUi52c4afe84f => 'Estudio de lugares';

  @override
  String get legacyUid1c69a859a => 'Último';

  @override
  String get legacyUi43df3046ba => 'Último cambio';

  @override
  String get legacyUi7a78ad49d8 => 'Ingresos del mes pasado';

  @override
  String get legacyUicec3d948d9 => 'Último pago';

  @override
  String get legacyUiada1b72559 => 'Última comprobación';

  @override
  String get legacyUi43dab84ff6 => 'Último acceso';

  @override
  String get legacyUib916a123cc => 'Ingresos del mes pasado';

  @override
  String get legacyUi76c1ed9309 => 'Semana pasada';

  @override
  String get legacyUieb3a622ae8 => 'Latitud / Longitud';

  @override
  String get legacyUi1e5421b5bc => 'Latitud/Longitud';

  @override
  String get legacyUidecd7ca800 => 'Más reciente';

  @override
  String get legacyUiefaed3a1b0 =>
      'Déjalo en blanco para conservar la contraseña actual';

  @override
  String get legacyUib8100f5ba8 => 'Biblioteca';

  @override
  String get legacyUi3229609e15 => 'Licencia';

  @override
  String get legacyUi99929a05d8 => 'Bloqueado por licencia';

  @override
  String get legacyUi7452738cf9 => 'Licencias emitidas';

  @override
  String get legacyUibbe96bcfaa => 'Licencias utilizadas';

  @override
  String get legacyUib957e7bd7b => 'Bloqueado por licencia';

  @override
  String get legacyUiee92c8a4b6 => 'Licencias';

  @override
  String get legacyUi6731d7cd1a => 'Logotipo para modo claro';

  @override
  String get legacyUi6a1c6c8807 => 'Logotipo para modo claro actualizado';

  @override
  String get legacyUi24d948e4bd => 'Límite';

  @override
  String get legacyUied1ed2b68d => 'Enlace copiado.';

  @override
  String get legacyUi36d1b59b88 =>
      'Vincula el vehículo a un usuario principal, un dispositivo GPS y un plan de precios.';

  @override
  String get legacyUi6b6390a441 => 'LinkedIn';

  @override
  String get legacyUi4ac08d16b8 => 'Cargar mensajes anteriores';

  @override
  String get legacyUidfe60ca92e => 'Cargar más';

  @override
  String get legacyUifc53db81a0 => 'Cargar más desde el servidor';

  @override
  String get legacyUi949d7ee41c => 'Cargar anteriores';

  @override
  String get legacyUi6db90a0ab6 => 'Cargado';

  @override
  String get legacyUi326ad2f9f8 => 'Cargando vehículos asignados';

  @override
  String get legacyUi8936529136 => 'Cargando vehículos disponibles';

  @override
  String get legacyUi9f1e0ce448 => 'Cargando documentos';

  @override
  String get legacyUide261e9b89 => 'Cargando registros';

  @override
  String get legacyUi324989adf0 => 'Cargando sensores';

  @override
  String get legacyUid219c68101 => 'Ubicación';

  @override
  String get legacyUi2350df02c2 => 'Detalles del registro';

  @override
  String get legacyUiaacbd6aa68 => 'ID de registro';

  @override
  String get legacyUia3d749050e => 'Acceder como usuario';

  @override
  String get legacyUi31a519ee99 =>
      'Los accesos y los cambios de contraseña o del estado de la cuenta aparecerán aquí.';

  @override
  String get legacyUi16b583cf21 => 'Registros no disponibles';

  @override
  String get legacyUi4c57f0c88d => 'Londres';

  @override
  String get legacyUi3bf98fa618 => 'Marcar como leído';

  @override
  String get legacyUia95e85aed5 => 'Máximo';

  @override
  String get legacyUi35f72dc38d => 'Velocidad máxima';

  @override
  String get legacyUi03a68b7d8b => 'Uso de memoria';

  @override
  String get legacyUi68f4145fee => 'Mensaje';

  @override
  String get legacyUi54a144c1dd => 'Envío de mensajes';

  @override
  String get legacyUi23b9e4546e =>
      'Envía aquí un mensaje al gestor de tu flota.';

  @override
  String get legacyUi8d546a6dea => 'Metadatos';

  @override
  String get legacyUi251edc0eb5 => 'Metadatos';

  @override
  String get legacyUic0b8960edf => 'Metadatos copiados';

  @override
  String get legacyUi7eb0cee888 => 'Mínimo';

  @override
  String get legacyUib6bcd4535a => 'Mínimo 3 caracteres…';

  @override
  String get legacyUi925c181c00 => 'Mínimo 6 caracteres';

  @override
  String get legacyUi092f99ea11 => 'Minutos';

  @override
  String get legacyUib1d7024593 => 'Teléfono móvil';

  @override
  String get legacyUia0d9c28a1e => 'Teléfono móvil (opcional)';

  @override
  String get legacyUi5968acfb01 => 'Número de móvil';

  @override
  String get legacyUic242b24d94 => 'Prefijo de móvil';

  @override
  String get legacyUi802cdad736 => 'Notificaciones push móviles';

  @override
  String get legacyUi00618b3856 =>
      'Teléfono móvil y correo electrónico de contacto.';

  @override
  String get legacyUi5d96299833 => 'Número de móvil (opcional)';

  @override
  String get legacyUi2ab961738f => 'Prefijo de móvil';

  @override
  String get legacyUi90ee975346 => 'Prefijo de móvil (opcional)';

  @override
  String get legacyUiaa6630b79b =>
      'Se ha vuelto a intentar el registro de notificaciones push móviles.';

  @override
  String get legacyUia1e34f9157 => 'Más acciones';

  @override
  String get legacyUi86c0a35ec8 => 'Más opciones';

  @override
  String get legacyUi69d9f3e5ae => 'Museo';

  @override
  String get legacyUi4ff2aa7688 => 'Mis solicitudes de soporte';

  @override
  String get legacyUi2e65b706ae => 'El nombre y el código son obligatorios.';

  @override
  String get legacyUi1eee3afea2 => 'Navegar';

  @override
  String get legacyUiccfb5f0286 => 'Nuevo punto de interés';

  @override
  String get legacyUi4894cb39ee => 'Nueva contraseña';

  @override
  String get legacyUidcaa5db473 => 'Nueva solicitud de soporte';

  @override
  String get legacyUib85e445f60 => 'Nuevo usuario';

  @override
  String get legacyUia273c96341 => 'Nuevo vehículo';

  @override
  String get legacyUie0725b6664 => 'Nueva geocerca';

  @override
  String get legacyUif39fa269a9 => 'Nueva ruta';

  @override
  String get legacyUi395e182389 => 'Los nuevos usuarios aparecerán aquí.';

  @override
  String get legacyUi2213317245 => 'Los nuevos vehículos aparecerán aquí.';

  @override
  String get legacyUi4bfc194b68 => 'Página siguiente';

  @override
  String get legacyUi1097b553dc => 'Noche';

  @override
  String get legacyUi4276e6ab2a => 'Sin datos';

  @override
  String get legacyUi3de93f521b => 'Sin dispositivo';

  @override
  String get legacyUi79858167e6 => 'Aún no hay puntos de interés';

  @override
  String get legacyUia434e9985c => 'Sin proveedor';

  @override
  String get legacyUi7094ba4f01 =>
      'No hay ninguna asignación activa. Los nuevos viajes aparecerán aquí cuando se asignen.';

  @override
  String get legacyUia9206f399a => 'Sin registros de actividad';

  @override
  String get legacyUi8bd5b910e5 => 'No se encontraron registros de actividad';

  @override
  String get legacyUic38a37a193 =>
      'Ninguna actividad coincide con los filtros.';

  @override
  String get legacyUibff9905096 => 'Aún no se ha registrado ninguna actividad.';

  @override
  String get legacyUi0f5cca70f8 => 'No se encontraron administradores';

  @override
  String get legacyUi31d3df94ab => 'No se encontraron administradores.';

  @override
  String get legacyUic0d322c2b0 => 'Sin datos de adopción';

  @override
  String get legacyUie5d64448e5 => 'Sin alertas';

  @override
  String get legacyUi501176c9f8 => 'Sin datos estadísticos';

  @override
  String get legacyUi63f5349bb8 => 'Sin usuarios asignados';

  @override
  String get legacyUi852751d61f => 'Sin vehículos asignados';

  @override
  String get legacyUi7546829892 => 'No se encontró actividad de facturación.';

  @override
  String get legacyUi657275c0c1 =>
      'No hay ciudades disponibles para este estado';

  @override
  String get legacyUia130e0f01b => 'Sin historial de comandos';

  @override
  String get legacyUi92db635f14 => 'Aún no hay comandos';

  @override
  String get legacyUi14a4bfc72c => 'No hay viajes completados este mes.';

  @override
  String get legacyUiee9c2e1df0 => 'Sin configuración';

  @override
  String get legacyUic3017a3316 => 'Aún no hay conversación';

  @override
  String get legacyUic140165b8f => 'Aún no hay historial de créditos.';

  @override
  String get legacyUic8114767e8 => 'No hay ningún panel configurado';

  @override
  String get legacyUi7be70212b0 =>
      'No hay datos diurnos ni nocturnos para este intervalo.';

  @override
  String get legacyUi2a4eb69350 => 'Sin detalles';

  @override
  String get legacyUi03ca0261ac => 'Sin dispositivo';

  @override
  String get legacyUi893d388d16 =>
      'Este vehículo no tiene ningún dispositivo asignado.';

  @override
  String get legacyUi8386fe15ef => 'Sin documentos';

  @override
  String get legacyUi017ce6604c => 'No se han subido documentos';

  @override
  String get legacyUiec7eb3c93e => 'Aún no se han subido documentos.';

  @override
  String get legacyUi54e1079e44 =>
      'Aún no hay documentos. Sube el primero con el botón de carga.';

  @override
  String get legacyUia419748e62 => 'No se encontró actividad de conductores.';

  @override
  String get legacyUi98e6629503 =>
      'No hay tipos de documento configurados para conductores. Pide al administrador que añada uno.';

  @override
  String get legacyUi36f5cbf894 => 'Sin documentos del conductor';

  @override
  String get legacyUic5dc9718a6 => 'Sin conductores';

  @override
  String get legacyUi7a127d70b3 => 'No hay conductores disponibles';

  @override
  String get legacyUi9c8198d34d => 'No se encontraron conductores';

  @override
  String get legacyUi208ffc64d1 => 'No se encontraron detalles del evento';

  @override
  String get legacyUiec11a02374 =>
      'No hay eventos para el intervalo de fechas y los filtros seleccionados.';

  @override
  String get legacyUia48cbba615 => 'No se encontraron eventos';

  @override
  String get legacyUi81ab95b9f0 => 'Aún no hay eventos';

  @override
  String get legacyUi774a252215 => 'No hay ningún archivo disponible.';

  @override
  String get legacyUi35f65e1e57 => 'No hay geocercas disponibles.';

  @override
  String get legacyUi019549899f => 'Aún no hay geocercas';

  @override
  String get legacyUi5358cec56d => 'Sin puntos de historial';

  @override
  String get legacyUia0ed9c8031 =>
      'No hay puntos de historial para este intervalo.';

  @override
  String get legacyUi8bf09d954a => 'No hay vehículos vinculados disponibles';

  @override
  String get legacyUif48787eb30 => 'No se encontraron registros';

  @override
  String get legacyUi6b68d448a0 =>
      'No se encontraron registros de este vehículo';

  @override
  String get legacyUic7462a9dac => 'Aún no hay registros';

  @override
  String get legacyUi1db215fbaa => 'No hay coincidencias para tu búsqueda.';

  @override
  String get legacyUia734fde29a => 'No hay puntos de interés coincidentes';

  @override
  String get legacyUi2d928306c1 => 'No hay conductores coincidentes';

  @override
  String get legacyUid6e8839481 => 'No hay geocercas coincidentes';

  @override
  String get legacyUif6830db2e7 => 'No hay registros coincidentes';

  @override
  String get legacyUi748bd377da => 'No hay datos coincidentes';

  @override
  String get legacyUi6590e5eab8 => 'No hay rutas coincidentes';

  @override
  String get legacyUid17e9558cf => 'No hay subusuarios coincidentes';

  @override
  String get legacyUif1d8690cd7 =>
      'No se encontraron vehículos coincidentes. Prueba con otra búsqueda o filtro.';

  @override
  String get legacyUic04921f8d9 => 'Aún no hay mensajes';

  @override
  String get legacyUi2449a03436 => 'Sin datos de modalidad';

  @override
  String get legacyUi50806db52e =>
      'No se encontraron ajustes de notificaciones';

  @override
  String get legacyUic1f531f996 => 'No se encontraron pagos';

  @override
  String get legacyUiaf4a7f06d0 => 'No se encontraron planes';

  @override
  String get legacyUi4ae157aff3 => 'No hay alertas recientes.';

  @override
  String get legacyUi26776d0320 => 'No hay usuarios recientes';

  @override
  String get legacyUi42ec1ecf96 => 'No hay vehículos recientes';

  @override
  String get legacyUi9833364a35 => 'No hay rutas disponibles.';

  @override
  String get legacyUid233dd5d9f => 'Aún no hay rutas';

  @override
  String get legacyUic9bfb1492b => 'No se encontró actividad de seguridad.';

  @override
  String get legacyUid07b6b93d6 => 'No hay vehículos que se puedan seleccionar';

  @override
  String get legacyUi5653bf7251 =>
      'No hay datos del sensor para este intervalo.';

  @override
  String get legacyUi1ef59c9c2b => 'Sin sensores';

  @override
  String get legacyUi3c30b80f16 =>
      'Este vehículo no tiene sensores configurados.';

  @override
  String get legacyUicbae766d34 => 'No se encontró actividad de ajustes.';

  @override
  String get legacyUicd0c79d188 => 'Sin enlaces para compartir';

  @override
  String get legacyUi9eac2f6695 => 'No hay estados disponibles para este país';

  @override
  String get legacyUid05ab60501 => 'Sin datos de estado';

  @override
  String get legacyUi4b78e836ec => 'Sin subusuarios';

  @override
  String get legacyUib30adf9758 => 'No hay subusuarios disponibles';

  @override
  String get legacyUi3a1fa8f145 => 'No se encontraron miembros del equipo';

  @override
  String get legacyUi12c6f10a41 => 'No se encontraron detalles de telemetría';

  @override
  String get legacyUi429d6e6ece => 'No se encontraron registros de telemetría';

  @override
  String get legacyUiea04e18b66 =>
      'No hay vehículos destacados para este intervalo.';

  @override
  String get legacyUi48d2d8da35 => 'Sin transacciones';

  @override
  String get legacyUid60c045dd2 => 'No se encontraron transacciones';

  @override
  String get legacyUif794b6c6d1 => 'Aún no hay transacciones.';

  @override
  String get legacyUi8d92589518 => 'Sin datos de tendencias';

  @override
  String get legacyUi7d3e5f72b8 => 'No hay viajes en esta vista.';

  @override
  String get legacyUib4c96ae04e => 'No se encontraron usuarios sin vincular.';

  @override
  String get legacyUi4b3155e704 =>
      'Ningún usuario sin vincular coincide con tu búsqueda.';

  @override
  String get legacyUid9c71203a5 =>
      'No hay datos de uso para el intervalo seleccionado.';

  @override
  String get legacyUic4b060bd59 => 'Sin usuarios';

  @override
  String get legacyUi5cc2b29f54 => 'Sin usuarios asignados';

  @override
  String get legacyUi3b614a59c7 => 'No hay usuarios disponibles';

  @override
  String get legacyUi612eb3c64c => 'No se encontraron usuarios';

  @override
  String get legacyUie611ef5702 => 'No se encontraron usuarios.';

  @override
  String get legacyUif800dfd722 =>
      'No se recibió ningún trazado GPS ni marcador de parada válido.';

  @override
  String get legacyUib96ee669b0 => 'No se encontró actividad de vehículos.';

  @override
  String get legacyUi748eafd21d => 'Sin vehículos';

  @override
  String get legacyUi8fbc8deb7a =>
      'Ahora mismo no hay vehículos visibles en el mapa.';

  @override
  String get legacyUi72ed5bbcdf => 'Aún no hay vehículos asignados.';

  @override
  String get legacyUi7223e6b8cb => 'No hay vehículos asignados.';

  @override
  String get legacyUiac0e4dbd5b => 'No hay vehículos disponibles';

  @override
  String get legacyUic578cfdbd5 => 'No se encontraron vehículos';

  @override
  String get legacyUie1de5f8ce2 => 'Ningún vehículo coincide con tu búsqueda.';

  @override
  String get legacyUia41b297cf1 => 'No hay datos de comparación semanal.';

  @override
  String get legacyUi35163920f3 => 'No hay widgets configurados';

  @override
  String get legacyUi45e118d056 => 'Normal';

  @override
  String get legacyUif8e45b2be2 => 'Norte';

  @override
  String get legacyUi2c924e3088 => 'Nota';

  @override
  String get legacyUi2fd5716446 => 'Notas (opcional)';

  @override
  String get legacyUicf62dbc83d => 'Notas / Descripción';

  @override
  String get legacyUi3e56dbb775 => 'Notas sobre este documento';

  @override
  String get legacyUi7faf33fcca => 'No hay nada que exportar';

  @override
  String get legacyUi76544814eb => 'Acciones de notificaciones';

  @override
  String get legacyUi4eb32de6c9 =>
      'Los ajustes de notificaciones se guardaron correctamente.';

  @override
  String get legacyUi8ca2cb9290 => 'Odómetro';

  @override
  String get legacyUi6c3a72eaf6 => 'Oficina';

  @override
  String get legacyUi63f34dd211 => 'Anteriores';

  @override
  String get legacyUi35c5d4307a => 'Filas anteriores';

  @override
  String get legacyUi9f8f7411e8 =>
      'Uno o varios vehículos seleccionados no son válidos.';

  @override
  String get legacyUie81cd61ea1 =>
      'Solo se pueden compartir los vehículos asignados al usuario.';

  @override
  String get legacyUicf9b77061f => 'Abrir';

  @override
  String get legacyUi8f5f529938 => 'Abrir / Guardar';

  @override
  String get legacyUi55d00c31ab => 'Abrir vehículos';

  @override
  String get legacyUicc6b7ec50c => 'Abrir CSV de filas con errores';

  @override
  String get legacyUi99bd9c01d7 => 'Notificaciones de OpenVTS';

  @override
  String get legacyUic1b94f880c => 'Importe opcional';

  @override
  String get legacyUi7afdcf3257 => 'Correo electrónico opcional';

  @override
  String get legacyUic553137ef5 => 'Teléfono móvil opcional';

  @override
  String get legacyUi410d481882 => 'Notas opcionales';

  @override
  String get legacyUi4f8f9c2bba => 'Recibo o nota opcional';

  @override
  String get legacyUi3494a60f96 => 'Nombre de usuario opcional';

  @override
  String get legacyUia493c04fb5 => 'Opcional; introduce al menos 3 caracteres';

  @override
  String get legacyUi6bf5da9c08 => 'Opciones';

  @override
  String get legacyUidefe0db589 => 'Ordenar por';

  @override
  String get legacyUi6e6a6f2086 => 'Otro';

  @override
  String get legacyUi4bed336194 => 'Salida';

  @override
  String get legacyUi9e339da256 => 'Alerta de exceso de velocidad habilitada';

  @override
  String get legacyUi0efc2e6be4 => 'Resumen';

  @override
  String get legacyUi3e90e4cbf4 => 'Titularidad';

  @override
  String get legacyUi07afcc61d8 => 'Tipo de paquete';

  @override
  String get legacyUif92c24e8df => 'Parque';

  @override
  String get legacyUi07ba1bef85 => 'Partes';

  @override
  String get legacyUi8be3c943b1 => 'Contraseña';

  @override
  String get legacyUi408255ed02 => 'Contraseña (opcional)';

  @override
  String get legacyUi092a16e7af => 'Contraseña cambiada';

  @override
  String get legacyUi47fa528931 => 'Contraseña cambiada.';

  @override
  String get legacyUi3efdbb2011 => 'Contraseña actualizada.';

  @override
  String get legacyUi8ac0c75d5e =>
      'Pega el enlace completo o el token de restablecimiento de tu correo. Los enlaces son de un solo uso y vencen automáticamente.';

  @override
  String get legacyUi5616b61bb7 => 'Contenido JSON';

  @override
  String get legacyUif8c3596eab =>
      'El contenido debe ser un objeto JSON válido.';

  @override
  String get legacyUi23b35c414a => 'Método de pago';

  @override
  String get legacyUi670d2a76c7 => 'Método de pago *';

  @override
  String get legacyUi662210d869 => 'Desglose por método de pago';

  @override
  String get legacyUia629fd8a2e => 'Tipo de pago';

  @override
  String get legacyUi43f8c9c90f => 'La actividad de pagos aparecerá aquí.';

  @override
  String get legacyUi8fbf2ec0dd => 'Método de pago';

  @override
  String get legacyUi653c04fc42 =>
      'No hay desglose por método de pago para este intervalo.';

  @override
  String get legacyUidbc3c0ca72 => 'Pago registrado';

  @override
  String get legacyUi197b45d161 => 'Referencia de pago';

  @override
  String get legacyUi96f608c16c => 'Pendiente';

  @override
  String get legacyUid1240d2832 => 'Pendiente / Fallido';

  @override
  String get legacyUi9126c119ae => 'Pagos pendientes';

  @override
  String get legacyUib4ebfb2f75 => 'Pagos pendientes';

  @override
  String get legacyUi167a47ff3e => 'Realizado por';

  @override
  String get legacyUi1785713451 => 'Permiso';

  @override
  String get legacyUid06d555709 => 'Permisos';

  @override
  String get legacyUi1e99c04657 => 'Permisos actualizados';

  @override
  String get legacyUi0219adf447 => 'Datos personales y dirección';

  @override
  String get legacyUib1b9e59387 => 'Información personal';

  @override
  String get legacyUi77064d5265 => 'Teléfono';

  @override
  String get legacyUi26730cddc4 => 'Seleccionar CSV';

  @override
  String get legacyUif2c5ca7b8c => 'Código postal';

  @override
  String get legacyUifd25c49d56 => 'Código postal (opcional)';

  @override
  String get legacyUiae2f98a099 => 'Plan';

  @override
  String get legacyUiec0632cbbf => 'Nombre del plan';

  @override
  String get legacyUi2b366a2f95 => 'Precio del plan';

  @override
  String get legacyUi7f97f6a268 => 'Plan creado y seleccionado';

  @override
  String get legacyUi2db331cefa => 'Matrícula';

  @override
  String get legacyUi7d86677521 => 'Número de matrícula';

  @override
  String get legacyUia6b7aa4d9c => 'Número de matrícula (opcional)';

  @override
  String get legacyUif2ce282e2d => 'Número de matrícula';

  @override
  String get legacyUi09d9c23846 => 'Número de matrícula (opcional)';

  @override
  String get legacyUi123a7f2fcc => 'Plataforma';

  @override
  String get legacyUi16596c477e =>
      'Funcionamiento de la plataforma, registro, geocodificación y retención de datos.';

  @override
  String get legacyUid095e279b3 =>
      'Corrige los campos resaltados antes de continuar.';

  @override
  String get legacyUi51668149ea => 'Selecciona un administrador.';

  @override
  String get legacyUife035157cd => 'Puerto';

  @override
  String get legacyUi16c2eb4dbb => 'Puertos';

  @override
  String get legacyUib629d4165b => 'Código postal';

  @override
  String get legacyUib86b6a2b3b => 'Código postal (opcional)';

  @override
  String get legacyUi90eceb016c => 'Prefijo';

  @override
  String get legacyUif1fbb2b43d => 'Vista previa';

  @override
  String get legacyUiba3e0b4a86 => 'Vista previa actualizada';

  @override
  String get legacyUi81f547195b => 'Página anterior';

  @override
  String get legacyUi3e8248e32e => 'Precio';

  @override
  String get legacyUi15ac0c0a27 => 'Plan de precios';

  @override
  String get legacyUid3dcce7d10 => 'Color principal';

  @override
  String get legacyUi170f443f36 => 'Usuario principal';

  @override
  String get legacyUia1055f11a9 => 'Color principal';

  @override
  String get legacyUic1ee865b42 => 'Color principal (hexadecimal)';

  @override
  String get legacyUi0554f68465 => 'Usuario principal';

  @override
  String get legacyUi1e5947a051 =>
      'El usuario principal, el dispositivo, el tipo de vehículo y el plan de precios son obligatorios.';

  @override
  String get legacyUi886cbff9d9 => 'Prioridad';

  @override
  String get legacyUi7e7302bb73 => 'El perfil aún no se ha cargado.';

  @override
  String get legacyUi5049e8f42b => 'Foto de perfil actualizada';

  @override
  String get legacyUi49ba5b4d7b =>
      'Los ajustes del perfil no están disponibles';

  @override
  String get legacyUibcf7629607 => 'Perfil actualizado.';

  @override
  String get legacyUibda244507b =>
      'Los cambios de perfil, empresa o configuración aparecerán aquí.';

  @override
  String get legacyUi204be1a53a => 'Estimado';

  @override
  String get legacyUi5c620cdb78 => 'Tipo de comprobante';

  @override
  String get legacyUi1ed77c3f7f => 'Protocolo';

  @override
  String get legacyUi7ceee3f361 => 'Proveedor';

  @override
  String get legacyUi767359109d => 'Referencia del proveedor';

  @override
  String get legacyUi8d80f9c731 => 'Vencimiento de la cobertura del proveedor';

  @override
  String get legacyUi8a87202949 => 'La URL pública no está disponible.';

  @override
  String get legacyUi411c13db3b => 'Registro público y créditos de bienvenida.';

  @override
  String get legacyUicf0a64d03d =>
      'Desliza hacia abajo para actualizar e intentar cargar el perfil de nuevo.';

  @override
  String get legacyUic8f58b21ae =>
      'Desliza hacia abajo para actualizar o añade un conductor.';

  @override
  String get legacyUi011bc421c2 =>
      'Desliza hacia abajo para actualizar o crea un subusuario.';

  @override
  String get legacyUi6a599877d7 => 'En cola';

  @override
  String get legacyUia16c5bbe4b => 'Intervalo';

  @override
  String get legacyUida433cd41e => 'Sin procesar';

  @override
  String get legacyUice09c15f57 => 'Paquete sin procesar';

  @override
  String get legacyUia3ccb33027 => 'Razorpay';

  @override
  String get legacyUi2af51c3e17 => 'Vuelve a introducir la contraseña';

  @override
  String get legacyUi852b438f91 => 'Leído';

  @override
  String get legacyUid14d593883 => 'Marcar todo como leído';

  @override
  String get legacyUi00db810078 => 'Motivo del ajuste';

  @override
  String get legacyUid4835a2d13 =>
      'Motivo de la modificación del importe (5–500 caracteres)';

  @override
  String get legacyUi03c3ccd3ff => 'Alertas recientes';

  @override
  String get legacyUi3abf211c93 => 'Pagos recientes';

  @override
  String get legacyUi93c62de33f => 'Usuarios recientes';

  @override
  String get legacyUi6b33999078 => 'Vehículos recientes';

  @override
  String get legacyUi790a1b9e7b =>
      'La actividad reciente aparecerá aquí cuando el servidor la devuelva.';

  @override
  String get legacyUic1541851a1 => 'Actividad reciente del servicio';

  @override
  String get legacyUi204110a010 =>
      'Los usuarios recientes aparecerán aquí cuando los devuelva el resumen del panel.';

  @override
  String get legacyUida67fde0f7 => 'Centrar de nuevo';

  @override
  String get legacyUi7df7c0bb40 => 'Correo electrónico del destinatario';

  @override
  String get legacyUi8ee92c936a => 'Destinatario/Usuario';

  @override
  String get legacyUi6577ced3c0 => 'Registrar pago';

  @override
  String get legacyUib19313692e => 'Registrado por';

  @override
  String get legacyUi471b94d402 => 'Rehacer';

  @override
  String get legacyUidb1c784524 => 'Referencia';

  @override
  String get legacyUic9dc8442d5 => 'Referencia (opcional)';

  @override
  String get legacyUie3039b8476 => 'Referencia (opcional)';

  @override
  String get legacyUid8b2ee1dcd =>
      'La referencia admite un máximo de 200 caracteres';

  @override
  String get legacyUi7a8e2a362c =>
      'La referencia debe tener 100 caracteres o menos.';

  @override
  String get legacyUi483e715402 => 'Actualizar administradores';

  @override
  String get legacyUif2b5787c06 => 'Actualizar panel';

  @override
  String get legacyUie75f05fced => 'Actualizar conductores';

  @override
  String get legacyUiebbc55f9ce => 'Actualizar historial';

  @override
  String get legacyUid0512701b2 => 'Actualizar inventario';

  @override
  String get legacyUif6cf59106a => 'Actualizar mensajes';

  @override
  String get legacyUid7cb2b4eea => 'Actualizar opciones del informe';

  @override
  String get legacyUi323540a087 => 'Actualizar ajustes';

  @override
  String get legacyUiade15a52e2 => 'Actualizar estado';

  @override
  String get legacyUie4d3b8b5ff => 'Actualizar equipo';

  @override
  String get legacyUi12f92ceb6e => 'Actualizar solicitudes de soporte';

  @override
  String get legacyUi3367ca735f => 'Actualizar transacciones';

  @override
  String get legacyUi892f6f322d => 'Actualizar usuarios';

  @override
  String get legacyUidf50facb6a => 'Actualizar vehículos';

  @override
  String get legacyUid42d9c1932 => 'Actualizar widget';

  @override
  String get legacyUia844fcf834 => 'Registrado';

  @override
  String get legacyUi9aba73febb => 'Últimos 10 caracteres del token registrado';

  @override
  String get legacyUic498221a5a => 'Fecha de registro';

  @override
  String get legacyUi20e264f6a1 => 'Parada relacionada';

  @override
  String get legacyUi62d14389b3 => 'Volver a cargar los tipos de documento';

  @override
  String get legacyUia2653dac4a => 'Observación';

  @override
  String get legacyUie963907dac => 'Eliminar';

  @override
  String get legacyUi0fcc6594fc => 'Quitar archivo adjunto';

  @override
  String get legacyUi48666118ca => 'Eliminar fila de metadatos';

  @override
  String get legacyUif96ba1e583 =>
      '¿Quitar la asignación del vehículo a este conductor?';

  @override
  String get legacyUi0165f7088a => 'Renovar';

  @override
  String get legacyUib219a06163 => 'Renovar vehículo';

  @override
  String get legacyUi4913250b6c => 'Renovar cobertura anual';

  @override
  String get legacyUif192fe3e94 => '¿Renovar la cobertura anual?';

  @override
  String get legacyUi1cce449350 => 'Renueva hasta 100 vehículos a la vez';

  @override
  String get legacyUi714c2b126f => 'Renueva hasta 100 vehículos a la vez.';

  @override
  String get legacyUibb47b991fe => 'Solicitudes de renovación';

  @override
  String get legacyUiac2377c0dd => 'Velocidad de reproducción';

  @override
  String get legacyUi5cc45fda55 =>
      'Las respuestas aparecerán aquí cuando se inicie la conversación.';

  @override
  String get legacyUid7a41420c8 =>
      'Las respuestas aparecerán aquí cuando se inicie la conversación de soporte.';

  @override
  String get legacyUi1f21d9edca => 'La respuesta es demasiado larga.';

  @override
  String get legacyUi4c7c79f6a9 => 'El mensaje de respuesta es obligatorio.';

  @override
  String get legacyUic9e8dd4159 => 'Respuesta enviada correctamente.';

  @override
  String get legacyUi5ce1bacd48 => 'Respuesta enviada.';

  @override
  String get legacyUi49072e5767 => 'Dirección de respuesta (opcional)';

  @override
  String get legacyUi6e2c712363 => 'Informar de un problema';

  @override
  String get legacyUi0ca4fce136 => 'Tipo de informe';

  @override
  String get legacyUi4857497af3 =>
      'Solicitar un nuevo enlace de restablecimiento';

  @override
  String get legacyUida30a140cc => '¿Solicitar la renovación del vehículo?';

  @override
  String get legacyUic26bf60fed => 'Solicitado';

  @override
  String get legacyUi1d3cb8a962 => 'Reenviar código';

  @override
  String get legacyUi56553100b0 => 'Restablecer filtros';

  @override
  String get legacyUibb02ea158c => 'Enlace o token de restablecimiento';

  @override
  String get legacyUi3ddc852b26 => 'Orientar al norte';

  @override
  String get legacyUi5c4bc97ee5 => 'Restablecer contraseña';

  @override
  String get legacyUi4f21821190 => 'Respondido';

  @override
  String get legacyUi966ea65ee9 => 'Respuesta hexadecimal';

  @override
  String get legacyUi3585d7553d => 'Restaurante';

  @override
  String get legacyUiab6d02bfbb => 'Restringido por tu administrador';

  @override
  String get legacyUic7199d9e95 => 'Retención';

  @override
  String get legacyUi9393bfa8e2 => 'Período de retención';

  @override
  String get legacyUibf1c27deea => 'Reintentar carga de monedas';

  @override
  String get legacyUi2e84dd3c7d => 'Reintentar registro';

  @override
  String get legacyUic507a566fc => 'Precisión de geocodificación inversa';

  @override
  String get legacyUi7148d08646 => 'Efecto de ondas';

  @override
  String get legacyUic3f104d136 => 'Rol';

  @override
  String get legacyUib1b392607d => 'Ejecutar';

  @override
  String get legacyUi26c35575bf => 'Ejecutar sensor';

  @override
  String get legacyUiba51f0a9fa => 'Buscar en el historial';

  @override
  String get legacyUia84c30c93c => 'Ejecutar limpieza';

  @override
  String get legacyUibd4e4bc9f2 => 'Número de SIM';

  @override
  String get legacyUi135447fb8f => 'Solo SIM';

  @override
  String get legacyUi3454bbef7f => 'Proveedor de SIM';

  @override
  String get legacyUi0366e95ddf => 'Proveedor de SIM (opcional)';

  @override
  String get legacyUi4636ab9e9a => 'Tarjeta SIM actualizada.';

  @override
  String get legacyUi12897d0b88 => 'Estado de la SIM';

  @override
  String get legacyUi1f4f5e7e3c => 'Acceso a la cuenta SMTP.';

  @override
  String get legacyUi7d08205aa6 => 'Ajustes SMTP guardados';

  @override
  String get legacyUia70c3bcf1d => 'San Francisco';

  @override
  String get legacyUi340bbc7875 => 'Satélites';

  @override
  String get legacyUidb95397447 => 'Guardar .kml';

  @override
  String get legacyUifa2984b367 => 'Guardar cambios';

  @override
  String get legacyUi78fe0922d6 => 'Guardar empresa';

  @override
  String get legacyUic6606cd51c => 'Guardar configuración';

  @override
  String get legacyUi909bf3e807 => 'Guardar perfil';

  @override
  String get legacyUif2f3d66a79 => 'Escuela';

  @override
  String get legacyUid09c8bca28 => 'Buscar número de SIM…';

  @override
  String get legacyUiabddbf1811 => 'Buscar registros de actividad...';

  @override
  String get legacyUi9a99566535 => 'Buscar actividad…';

  @override
  String get legacyUi1321daf435 => 'Buscar conductores asignados';

  @override
  String get legacyUie6ac2b6800 => 'Buscar vehículos asignados';

  @override
  String get legacyUi3a97577679 => 'Buscar conductores disponibles';

  @override
  String get legacyUiacd1382ab4 => 'Buscar vehículos disponibles';

  @override
  String get legacyUi03ef7546a9 => 'Buscar por IMEI...';

  @override
  String get legacyUia8854d5f97 => 'Buscar por código...';

  @override
  String get legacyUi411482b8e7 =>
      'Buscar por fecha, actividad, créditos o vehículo…';

  @override
  String get legacyUi28abc0313d => 'Buscar por nombre';

  @override
  String get legacyUi28f3d064ea => 'Buscar por nombre o categoría';

  @override
  String get legacyUi4120e178da => 'Buscar por nombre o matrícula…';

  @override
  String get legacyUibb6cfd804d => 'Buscar por nombre o correo electrónico…';

  @override
  String get legacyUi1c1d641fe8 => 'Buscar por nombre, matrícula, IMEI o VIN';

  @override
  String get legacyUife32b8f32a => 'Buscar por nombre, matrícula o IMEI…';

  @override
  String get legacyUibdc6551409 =>
      'Buscar por nombre, matrícula, VIN, IMEI o SIM...';

  @override
  String get legacyUiba20cfd893 => 'Buscar por referencia o administrador...';

  @override
  String get legacyUi45b6baaad3 => 'Buscar registros diarios...';

  @override
  String get legacyUie43926680a => 'Buscar registros del dispositivo';

  @override
  String get legacyUi26eb1d222b => 'Buscar tipo de dispositivo…';

  @override
  String get legacyUi98110e65a0 => 'Buscar en los registros cargados';

  @override
  String get legacyUi48225af1f4 => 'Buscar registros';

  @override
  String get legacyUi20f28ed35b => 'Buscar nombre, IMEI, SIM o tipo';

  @override
  String get legacyUic60723c651 => 'Buscar nombre, matrícula o IMEI';

  @override
  String get legacyUi3dadc5cddf =>
      'Buscar nombre, usuario, correo, móvil, vehículo o matrícula...';

  @override
  String get legacyUi0417c5f97b =>
      'Buscar nombre, usuario, correo electrónico o móvil...';

  @override
  String get legacyUi5196e5c8da => 'Buscar lugar o dirección...';

  @override
  String get legacyUic3290fb221 => 'Buscar lugar...';

  @override
  String get legacyUi60c8ce351b =>
      'Buscar planes, moneda, duración o precio...';

  @override
  String get legacyUie5483c71e7 => 'Buscar proveedor…';

  @override
  String get legacyUi98e27d7b41 =>
      'Buscar referencia, proveedor o contraparte...';

  @override
  String get legacyUidd77f6ecc1 =>
      'Buscar referencia, proveedor, usuario o vehículo';

  @override
  String get legacyUi0066a752cb => 'Buscar rutas por nombre';

  @override
  String get legacyUi502e6eaf2c => 'Buscar sensores';

  @override
  String get legacyUi0cfffb61af => 'Buscar sensores...';

  @override
  String get legacyUi233ad2b14f => 'Buscar asunto, número o estado';

  @override
  String get legacyUid320d41a03 => 'Buscar solicitudes de soporte';

  @override
  String get legacyUi65da39d5f0 => 'Buscar transacciones...';

  @override
  String get legacyUi25dfae4e3a => 'Buscar viajes';

  @override
  String get legacyUida80ead473 => 'Buscar usuarios sin vincular...';

  @override
  String get legacyUie5b2404515 => 'Buscar usuarios o vehículos…';

  @override
  String get legacyUi8cdc4c0930 => 'Buscar usuarios...';

  @override
  String get legacyUi2e4b72c10c => 'Buscar vehículo';

  @override
  String get legacyUi1bd54471c2 => 'Buscar eventos del vehículo...';

  @override
  String get legacyUiba537c59ae =>
      'Buscar vehículo, matrícula, VIN, IMEI, SIM o usuario…';

  @override
  String get legacyUi4a54a9e6db =>
      'Buscar vehículo, matrícula, VIN, IMEI o SIM...';

  @override
  String get legacyUi5780b5d6bf => 'Buscar vehículos';

  @override
  String get legacyUi50efae1b5f =>
      'Buscar vehículos por nombre, matrícula o plan...';

  @override
  String get legacyUib09b43245d => 'Buscar vehículos...';

  @override
  String get legacyUif54fbca187 => 'Buscar…';

  @override
  String get legacyUifaaee5e23e => 'Seleccionar SIM';

  @override
  String get legacyUi69cc521201 => 'Selecciona un país';

  @override
  String get legacyUi400a58f1cc =>
      'Selecciona un intervalo para cargar el historial.';

  @override
  String get legacyUie216b735f0 => 'Selecciona primero un usuario.';

  @override
  String get legacyUie965317576 => 'Selecciona primero un vehículo.';

  @override
  String get legacyUia72bd23c12 =>
      'Selecciona un vehículo, el umbral de parada y el intervalo de fecha y hora.';

  @override
  String get legacyUi29c9360313 => 'Seleccionar administrador';

  @override
  String get legacyUi8a152d2c3f =>
      'Selecciona al menos un vehículo que se pueda renovar';

  @override
  String get legacyUi5573da8514 => 'Selecciona al menos un vehículo.';

  @override
  String get legacyUi42303635fc => 'Seleccionar ciudad';

  @override
  String get legacyUi9915f6e5c2 => 'Seleccionar color';

  @override
  String get legacyUia96ce92893 => 'Seleccionar plantilla de comando';

  @override
  String get legacyUi59ee76bad1 => 'Seleccionar país';

  @override
  String get legacyUi74c388ab91 => 'Seleccionar intervalo de fecha y hora';

  @override
  String get legacyUi46bfa11b12 => 'Seleccionar tipo de dispositivo';

  @override
  String get legacyUidba2e6bd04 => 'Seleccionar tipo de documento';

  @override
  String get legacyUi386f8ba9d0 => 'Seleccionar usuario principal';

  @override
  String get legacyUic7a9e8ea6a => 'Seleccionar proveedor';

  @override
  String get legacyUib350802ae1 => 'Seleccionar estado';

  @override
  String get legacyUi905d012288 => 'Seleccionar tipo';

  @override
  String get legacyUib8a1d9de7d => 'Seleccionar usuario';

  @override
  String get legacyUie574e3a29d =>
      'Selecciona vehículos cuyos planes tengan la misma moneda';

  @override
  String get legacyUi07f0f61db9 => 'El archivo seleccionado está vacío.';

  @override
  String get legacyUi9bc2575c39 => 'Enviar';

  @override
  String get legacyUi0ad7c21624 => 'Enviar comando';

  @override
  String get legacyUi9b48248439 => 'Envía un comando para ver el historial.';

  @override
  String get legacyUi724aa54b02 => '¿Enviar el comando al vehículo?';

  @override
  String get legacyUic70a890d14 => 'Enviar mensaje';

  @override
  String get legacyUia89d641794 => 'Enviar solicitud';

  @override
  String get legacyUib8ec554332 => 'Enviar enlace de restablecimiento';

  @override
  String get legacyUi1aba33d6c2 => 'Enviar prueba';

  @override
  String get legacyUifc552c754d => 'Enviar correo de prueba';

  @override
  String get legacyUi17b874d289 => 'Remitente';

  @override
  String get legacyUi679e8f61b9 => 'Nombre del remitente';

  @override
  String get legacyUi73dcba5635 => 'Historial del sensor';

  @override
  String get legacyUia14460cfb3 => 'Intervalo del historial del sensor';

  @override
  String get legacyUia9bc44292f => 'Acciones del sensor';

  @override
  String get legacyUi18d80b838f => 'Sensor eliminado.';

  @override
  String get legacyUi711bf35988 => 'Sensores';

  @override
  String get legacyUi48380dd0e2 => 'Sensores no disponibles';

  @override
  String get legacyUi35f49dcfbf => 'Enviado';

  @override
  String get legacyUi2d7bb03171 =>
      'Los comandos enviados y las respuestas de los dispositivos aparecen aquí.';

  @override
  String get legacyUi1d5d1effa9 => 'URL del servidor';

  @override
  String get legacyUif85e6f1bdc => 'Tiempo de actividad del servidor';

  @override
  String get legacyUi10802e852c => 'Hora del servidor';

  @override
  String get legacyUi7ef53dd844 =>
      'El vencimiento del servicio debe ser posterior al registro.';

  @override
  String get legacyUi2ad34ef4cf => 'Plan de servicio';

  @override
  String get legacyUi2bacd5f581 => 'Inicio del servicio';

  @override
  String get legacyUiaa02a8d843 => 'Establecer horas de motor';

  @override
  String get legacyUi837c0d47b5 => 'Establecer odómetro';

  @override
  String get legacyUiaef97bb06a => 'Ajustes guardados';

  @override
  String get legacyUi96a0dc481b => 'Compras';

  @override
  String get legacyUi5e65ca08ed => 'Título breve del problema';

  @override
  String get legacyUi4c742d5133 => 'Mostrar geocerca';

  @override
  String get legacyUi5abbf34ba3 => 'Mostrar historial';

  @override
  String get legacyUi8268618610 =>
      'Mostrar un pulso animado alrededor de los vehículos en movimiento';

  @override
  String get legacyUi25911d48e0 => 'Mostrar más';

  @override
  String get legacyUi50b47f1483 => 'Mostrar marcadores de puntos de interés';

  @override
  String get legacyUib7f93469b9 => 'Mostrar trazado de ruta';

  @override
  String get legacyUi510904927e =>
      'Mostrar el nombre del vehículo junto al icono en el mapa';

  @override
  String get legacyUi6e61e47d5c =>
      'Se muestra sobre fondos oscuros. PNG, JPG, SVG o WEBP. Máximo 5 MB.';

  @override
  String get legacyUi39e4052ecf =>
      'Se muestra sobre fondos claros. PNG, JPG, SVG o WEBP. Máximo 5 MB.';

  @override
  String get legacyUi894bc414e6 => 'Registro';

  @override
  String get legacyUi69c2037890 => 'Ir al final';

  @override
  String get legacyUia8522e4c9d => 'Ir al inicio';

  @override
  String get legacyUi33dcec9ce4 => 'Lento';

  @override
  String get legacyUicf606d0913 => 'Más lento';

  @override
  String get legacyUi339c1ea94b => 'Enlaces a redes sociales';

  @override
  String get legacyUi3db7211438 => 'Ordenar tarjetas SIM';

  @override
  String get legacyUi66758a74bc => 'Ordenar administradores';

  @override
  String get legacyUi3655295cb4 => 'Ordenar dispositivos';

  @override
  String get legacyUi3a21e72182 => 'Ordenar conductores';

  @override
  String get legacyUi1e891a0102 => 'Ordenar equipo';

  @override
  String get legacyUi6d1ba980e8 => 'Ordenar usuarios';

  @override
  String get legacyUi2512bda9e7 => 'Ordenar vehículos';

  @override
  String get legacyUi6da13addb0 => 'Origen';

  @override
  String get legacyUi6ace449732 => 'Sur';

  @override
  String get legacyUi2d2cb022bc => 'Velocidad';

  @override
  String get legacyUi8a14aeec13 => 'Multiplicador de velocidad';

  @override
  String get legacyUid6a0aaa660 => 'Variación de velocidad';

  @override
  String get legacyUi09a7707087 => 'Iniciar manualmente';

  @override
  String get legacyUi7e244fee11 =>
      'La hora de inicio debe ser anterior a la hora de finalización.';

  @override
  String get legacyUia725020675 => 'Estado';

  @override
  String get legacyUi4e5c9805af => 'Estado (opcional)';

  @override
  String get legacyUic01247416e => 'El estado es obligatorio.';

  @override
  String get legacyUiedde30a0b6 => 'Estado: ';

  @override
  String get legacyUia0539c7e7a =>
      'La distribución de estados no está disponible para este intervalo.';

  @override
  String get legacyUie4fe064446 => 'Minutos de parada';

  @override
  String get legacyUif32715a2f1 => 'Marcador de parada';

  @override
  String get legacyUi5ca845e914 => 'Calle, edificio, zona…';

  @override
  String get legacyUi4d08ec5874 => 'Stripe';

  @override
  String get legacyUi8de713bd12 => 'Subusuarios';

  @override
  String get legacyUi97a0373212 => 'Subusuario creado.';

  @override
  String get legacyUi5cae4f427b => 'Subusuario eliminado.';

  @override
  String get legacyUi2cc74ff5c3 => 'Nombre del subusuario';

  @override
  String get legacyUie44d50f72d => 'Subusuario actualizado.';

  @override
  String get legacyUibd3159ff21 => 'El asunto es obligatorio.';

  @override
  String get legacyUi6844979e4f =>
      'El asunto debe contener al menos una letra o un número.';

  @override
  String get legacyUid6981f7476 => 'Suscribirse';

  @override
  String get legacyUia547aab586 =>
      'Suscrito a las novedades por correo electrónico';

  @override
  String get legacyUid7932a2917 => 'Completado correctamente';

  @override
  String get legacyUib879505819 => 'Solicitud de soporte';

  @override
  String get legacyUi848eed0fbd => 'Etiquetas';

  @override
  String get legacyUi8c7e01ee22 => 'Etiquetas (separadas por comas)';

  @override
  String get legacyUi1df356a49e =>
      'Toca el mapa o introduce las coordenadas para colocar el punto de interés.';

  @override
  String get legacyUi61ad50a9b9 => 'Destino';

  @override
  String get legacyUi78560d88ef => 'Equipo activado.';

  @override
  String get legacyUid8f82f6030 => 'Actividad del equipo';

  @override
  String get legacyUi8aef227384 => 'Equipo desactivado.';

  @override
  String get legacyUi72df525608 => 'Miembro del equipo creado.';

  @override
  String get legacyUi07fed9d9b3 => 'Miembro del equipo actualizado.';

  @override
  String get legacyUi0194c31b6d => 'Permisos del equipo actualizados';

  @override
  String get legacyUi6730423d83 => 'Detalles de telemetría';

  @override
  String get legacyUieef4095d19 => 'Registros de telemetría';

  @override
  String get legacyUif8d42e6122 => 'Intervalo de fechas de telemetría';

  @override
  String get legacyUi3ec1ae061c => 'Plantilla';

  @override
  String get legacyUi7200f86ae5 => 'Probar notificaciones push móviles';

  @override
  String get legacyUi8b9bbdf230 => 'Probar notificación push';

  @override
  String get legacyUi8135cd8fa3 =>
      'El cliente puede crear una nueva solicitud. No se amplía el servicio de ningún vehículo.';

  @override
  String get legacyUidc46c2859b => 'El enlace vence automáticamente.';

  @override
  String get legacyUic77eaa41ef =>
      'La organización que administra esta persona en OpenVTS.';

  @override
  String get legacyUi461197e42e =>
      'La organización a la que pertenece este usuario en OpenVTS.';

  @override
  String get legacyUia491398fbb =>
      'La respuesta del resumen aún no incluye puntos para el gráfico.';

  @override
  String get legacyUi214cddfadb =>
      'La respuesta del resumen aún no incluye vehículos recientes.';

  @override
  String get legacyUi9e4a7b1c4c =>
      'El catálogo de permisos no está disponible. La edición está deshabilitada.';

  @override
  String get legacyUiac4a475bbb =>
      'El servidor devolvió un catálogo de permisos no compatible. La edición está deshabilitada.';

  @override
  String get legacyUi8895c1d4b6 =>
      'La carga terminó, pero el servidor no devolvió la nueva foto de perfil.';

  @override
  String get legacyUidbc2f6bd85 =>
      'No hay alertas disponibles en este momento.';

  @override
  String get legacyUi9b519b14b9 => 'No hay eventos en este día';

  @override
  String get legacyUi354cfe028c =>
      'Estos cambios conceden acceso global o permiso de eliminación. ¿Aplicarlos a este miembro del equipo?';

  @override
  String get legacyUi0f6cc3a89c => 'Este mes';

  @override
  String get legacyUi77528c94d9 => 'Este año';

  @override
  String get legacyUi951f495b34 => 'Esta acción no se puede deshacer.';

  @override
  String get legacyUi9b646010b8 => 'Este tipo de archivo no está permitido.';

  @override
  String get legacyUi1b4785331d => 'Este mes';

  @override
  String get legacyUi0e606e3993 => 'Este panel guardado aún no tiene widgets.';

  @override
  String get legacyUi1e191e95f4 => 'Esta solicitud de soporte está cerrada.';

  @override
  String get legacyUi8866cb1e0a =>
      'Se utiliza un crédito de la cuenta cuando el vehículo cumple los requisitos.';

  @override
  String get legacyUi7b72883e07 => 'Esta semana';

  @override
  String get legacyUi261bd2f51b => 'Conversación de soporte';

  @override
  String get legacyUie1b858991f => 'Solicitud de soporte creada.';

  @override
  String get legacyUi61322c9a86 => 'Detalles de la solicitud de soporte';

  @override
  String get legacyUif1e8e34245 =>
      'Los detalles de la solicitud no están disponibles';

  @override
  String get legacyUiaa27494c39 => 'Estado de la solicitud actualizado.';

  @override
  String get legacyUiedcd363083 => 'Tiempo de espera agotado';

  @override
  String get legacyUi768e0c1c69 => 'Título';

  @override
  String get legacyUie39bf0152d => 'Distancia de hoy';

  @override
  String get legacyUif43482f042 => 'Horas de motor de hoy';

  @override
  String get legacyUi7adacb5405 => 'Cambiar estado';

  @override
  String get legacyUi6d91e0bb03 => 'Tolerancia';

  @override
  String get legacyUid1bbcb6c01 => 'Tolerancia (metros)';

  @override
  String get legacyUi63cfb27f40 => 'Principales clientes';

  @override
  String get legacyUibc6debbc28 => 'Vehículos con mejor rendimiento';

  @override
  String get legacyUib25928c699 => 'Total';

  @override
  String get legacyUia672e7faed => 'Horas totales de motor';

  @override
  String get legacyUie9511a6560 => 'Total recibido';

  @override
  String get legacyUia028fce203 => 'Total de usuarios';

  @override
  String get legacyUi5bcce6c936 => 'Total de vehículos';

  @override
  String get legacyUi7b777b27e0 => 'Horas totales de motor';

  @override
  String get legacyUi8578188376 => 'Total de registros';

  @override
  String get legacyUi0538b10824 => 'QR del enlace de seguimiento';

  @override
  String get legacyUi070fb0b6ea => 'Enlace de seguimiento eliminado.';

  @override
  String get legacyUief1f899cb2 => 'Detalles de la transacción';

  @override
  String get legacyUi06d8ffe653 => 'ID de transacción';

  @override
  String get legacyUi105b1510d9 =>
      'La actividad de transacciones aparecerá aquí cuando esté disponible.';

  @override
  String get legacyUid016e453e5 => 'Detalles de la transacción';

  @override
  String get legacyUiab39260fea => 'Transiciones';

  @override
  String get legacyUic10d76c9a4 => 'Transporte';

  @override
  String get legacyUie82c27ca1d => 'Viaje cancelado';

  @override
  String get legacyUi4a9e77914e => 'Prueba con otro nombre o matrícula.';

  @override
  String get legacyUi4e653834fa => 'Prueba con otra búsqueda o filtro.';

  @override
  String get legacyUi39d6420eaa => 'Prueba con otro término de búsqueda';

  @override
  String get legacyUi0ba628a33e => 'Prueba con otro término de búsqueda.';

  @override
  String get legacyUi10239b38b5 =>
      'Prueba a modificar los filtros o la búsqueda actual.';

  @override
  String get legacyUi2253479cff => 'Prueba a modificar los filtros.';

  @override
  String get legacyUie3f4c649b5 =>
      'Prueba con otro nombre o número de matrícula.';

  @override
  String get legacyUi10f570e880 =>
      'Prueba a cambiar los filtros o la búsqueda.';

  @override
  String get legacyUif28432df1f => 'Prueba a cambiar los filtros.';

  @override
  String get legacyUi3c86b09439 =>
      'Prueba a cambiar la búsqueda o los filtros.';

  @override
  String get legacyUi0ba0bd18bf =>
      'Prueba a borrar la búsqueda o los filtros de estado.';

  @override
  String get legacyUi7a2fe508f6 =>
      'Prueba a actualizar. Si el problema continúa, es posible que tu cuenta aún no tenga preferencias de notificaciones.';

  @override
  String get legacyUia0b470cb00 => 'Twitter / X';

  @override
  String get legacyUi8981df4d6a => 'Twitter/X';

  @override
  String get legacyUi3deb745651 => 'Tipo';

  @override
  String get legacyUie298b0ec36 => 'Escribe ';

  @override
  String get legacyUi4b3072dd4e => 'Introduce el contenido del comando';

  @override
  String get legacyUi5712bb4ea1 => 'Introducir manualmente';

  @override
  String get legacyUi968be8d576 => 'No se pudo cambiar la contraseña.';

  @override
  String get legacyUi1da33a6b30 => 'No se pudieron cargar las ciudades.';

  @override
  String get legacyUia4c5468d38 =>
      'No se pudieron cargar los datos de la empresa.';

  @override
  String get legacyUicbae41853b =>
      'No se pudieron cargar las opciones del formulario.';

  @override
  String get legacyUid06763ac1a => 'No se pudieron cargar los estados.';

  @override
  String get legacyUia471ebf750 => 'No se pudieron cargar los usuarios.';

  @override
  String get legacyUibf0bc28bdb => 'No se pudieron cargar los vehículos.';

  @override
  String get legacyUid73d7a7c96 => 'No se pudo abrir el archivo.';

  @override
  String get legacyUi8ace6e9280 => 'No se pudo abrir el selector de imágenes.';

  @override
  String get legacyUidcbaa0588e =>
      'No se pudo abrir la navegación para este vehículo.';

  @override
  String get legacyUi14fdbab84b => 'No se pudo abrir este archivo adjunto.';

  @override
  String get legacyUia457295e9f => 'No se pudo leer la imagen seleccionada.';

  @override
  String get legacyUi9e97e5bfed => 'No se pudieron actualizar los usuarios.';

  @override
  String get legacyUi800f200671 => 'No se pudo actualizar el estado.';

  @override
  String get legacyUice1c9c972b =>
      'No se pudo actualizar el estado del miembro del equipo.';

  @override
  String get legacyUib5f12c7d4f =>
      'No se pudo actualizar el miembro del equipo.';

  @override
  String get legacyUia046b8ac56 => 'No se pudo actualizar la URL del servidor.';

  @override
  String get legacyUi896bfd3a9a => 'Quitar asignación';

  @override
  String get legacyUi7be6acc7f8 => '¿Quitar la asignación del usuario?';

  @override
  String get legacyUi05027a8753 => 'Quitar asignación del usuario';

  @override
  String get legacyUi2d5a96092e => 'Quitar asignación del vehículo';

  @override
  String get legacyUi39fc721248 => 'Deshacer';

  @override
  String get legacyUice77c2f42c => 'Código único';

  @override
  String get legacyUif6b935ab33 => 'Unidad';

  @override
  String get legacyUi07b032b56f => 'No leído';

  @override
  String get legacyUi100cb4d890 => 'Tipo de archivo no compatible.';

  @override
  String get legacyUicb9925a338 =>
      'Formato no compatible. Usa PNG, JPG, JPEG o WEBP.';

  @override
  String get legacyUi99974d3476 => 'Widget no compatible';

  @override
  String get legacyUieb27a190c0 => 'Sin verificar';

  @override
  String get legacyUi61dcf34e70 => 'Actualizar contraseña';

  @override
  String get legacyUieae1f5caf5 => 'Actualizar estado';

  @override
  String get legacyUif2f8570ddd => 'Actualizado';

  @override
  String get legacyUi22714274a4 => 'Fecha de actualización';

  @override
  String get legacyUi8bdf057f91 => 'Subir';

  @override
  String get legacyUi9e2628eec4 => 'Subir documento';

  @override
  String get legacyUidcad7d982a => 'Sube un documento para empezar.';

  @override
  String get legacyUi73183a7050 => 'Subir documento';

  @override
  String get legacyUid714896782 => 'Sube documentos de este vehículo.';

  @override
  String get legacyUi4b87ccd949 =>
      'Sube archivos del conductor, como el permiso de conducir o documentos de identidad.';

  @override
  String get legacyUi6aafa80cab => 'Tiempo de actividad';

  @override
  String get legacyUif1f71137de => 'Usa una contraseña segura y única';

  @override
  String get legacyUid81b6af542 => 'Usar todos';

  @override
  String get legacyUi5895bc72eb =>
      'Se utiliza para los valores regionales predeterminados, como moneda, zona horaria y enrutamiento.';

  @override
  String get legacyUi81c9245d46 => 'Solicitudes de soporte de usuarios';

  @override
  String get legacyUi81939432dd => 'Acciones del usuario';

  @override
  String get legacyUi0abfc13cb8 => 'Usuario asignado.';

  @override
  String get legacyUi6188702f9e => 'Usuario creado y seleccionado';

  @override
  String get legacyUi0ba72d0bce => 'Usuario eliminado.';

  @override
  String get legacyUi8fd72dd6f9 => 'El usuario es obligatorio';

  @override
  String get legacyUi5ed13310cc => 'El usuario es obligatorio.';

  @override
  String get legacyUib0b238b57a => 'Permisos del usuario actualizados';

  @override
  String get legacyUia42cd2f9d5 => 'Asignación del usuario eliminada.';

  @override
  String get legacyUi2355aced23 => 'Usuario actualizado.';

  @override
  String get legacyUi84c29015de => 'Nombre de usuario';

  @override
  String get legacyUib1974b83bc => 'Nombre de usuario (opcional)';

  @override
  String get legacyUi2c7ab350b3 => 'Nombre de usuario o correo electrónico';

  @override
  String get legacyUi73dbef356e => 'VIN (opcional)';

  @override
  String get legacyUi39852971ee => 'Número VIN';

  @override
  String get legacyUia4aefa35c3 => 'Válido';

  @override
  String get legacyUi8dce170de2 => 'Valor';

  @override
  String get legacyUi7bac966778 => 'Vehículo / Plan';

  @override
  String get legacyUi43188a5960 => 'Detalles del evento del vehículo';

  @override
  String get legacyUi2d80c33ed3 => 'Eventos del vehículo';

  @override
  String get legacyUi4d461104bf => 'Vencimiento del vehículo';

  @override
  String get legacyUi9e47ccbff4 =>
      'Se necesita el IMEI del vehículo para cargar los eventos.';

  @override
  String get legacyUi2b51e72835 =>
      'Se necesita el IMEI del vehículo para cargar los sensores.';

  @override
  String get legacyUief04c2235a =>
      'Se necesita el IMEI del vehículo para cargar los registros de telemetría.';

  @override
  String get legacyUi62dc158d0e => 'Etiqueta del vehículo';

  @override
  String get legacyUicb4e4154e4 => 'Metadatos del vehículo';

  @override
  String get legacyUi92dc53a1bc => 'Nombre del vehículo';

  @override
  String get legacyUi441399c250 => 'Selección de vehículos';

  @override
  String get legacyUi2d6ca00998 => 'Tipo de vehículo';

  @override
  String get legacyUi5c931770ef => 'Acciones del vehículo';

  @override
  String get legacyUi6ac26355c9 =>
      'La actividad del vehículo y los registros del sistema aparecerán aquí.';

  @override
  String get legacyUi4e4942337f => 'Vehículo y plan';

  @override
  String get legacyUi6ec60a25f7 => 'Vehículo asignado.';

  @override
  String get legacyUia31471cef9 =>
      'Las asignaciones y las actualizaciones de vehículos aparecerán aquí.';

  @override
  String get legacyUib7975a2537 => 'Vehículo eliminado.';

  @override
  String get legacyUiff47117f38 => 'Datos del vehículo';

  @override
  String get legacyUia1fbfba50c =>
      'Los datos del vehículo no están disponibles.';

  @override
  String get legacyUi79c500fa20 =>
      'Intervalo de fechas de eventos del vehículo';

  @override
  String get legacyUie981db4fa0 => 'Los eventos del vehículo aparecerán aquí.';

  @override
  String get legacyUi7eefc642f4 => 'Grupo de vehículos';

  @override
  String get legacyUi5cd0230ee5 => 'Falta el ID del vehículo.';

  @override
  String get legacyUi39ea43c097 => 'Número de identificación del vehículo';

  @override
  String get legacyUida83429197 => 'Nombre del vehículo';

  @override
  String get legacyUi750a5503ac => 'Posición del vehículo';

  @override
  String get legacyUi40a1e7dd80 =>
      'El registro del vehículo no está disponible.';

  @override
  String get legacyUi686853d97d => 'Pago de renovación del vehículo enviado';

  @override
  String get legacyUie1071916e2 => 'Renovación del vehículo registrada.';

  @override
  String get legacyUibf31403ac2 => 'Ámbito de vehículos';

  @override
  String get legacyUi3c760a5151 => 'Servicio del vehículo';

  @override
  String get legacyUi9aafada9ec =>
      'La revisión del servicio del vehículo no está disponible. Vuelve a cargar antes de editar.';

  @override
  String get legacyUia0d9ad9324 => 'Servicio del vehículo actualizado';

  @override
  String get legacyUi97d4120359 => 'Servicios de vehículos';

  @override
  String get legacyUif9709ba7c4 =>
      'La telemetría del vehículo actualiza el progreso automáticamente. Solo se puede completar manualmente la parada actual.';

  @override
  String get legacyUi9644381920 => 'Tipo de vehículo';

  @override
  String get legacyUi8b26242493 => 'Filtro de tipo de vehículo';

  @override
  String get legacyUi2a37343d0a => 'Asignación del vehículo eliminada.';

  @override
  String get legacyUif28657d034 => 'Vehículo no disponible';

  @override
  String get legacyUi917981e400 => 'Vehículo actualizado.';

  @override
  String get legacyUi02236966b5 => 'Vehículos afectados';

  @override
  String get legacyUi776abb6631 => 'Vehículos asignados.';

  @override
  String get legacyUi433457e28d => 'No se pudieron cargar los vehículos.';

  @override
  String get legacyUi03128bed90 => 'Verificación';

  @override
  String get legacyUiaed3b8c6a7 => 'Verificado';

  @override
  String get legacyUidda6ac27b9 => 'Verificar';

  @override
  String get legacyUi69bd4ef9fb => 'Ver';

  @override
  String get legacyUi5b9306d29c => 'Ver pagos';

  @override
  String get legacyUie3c9374cd6 => 'Ver todos los viajes';

  @override
  String get legacyUib1614cb4e6 => 'Ver/Descargar';

  @override
  String get legacyUi1b6cc58781 => 'Infracciones por gravedad';

  @override
  String get legacyUi1fe59390ac => 'Visible';

  @override
  String get legacyUi4fc5a421da => 'Visible para el administrador';

  @override
  String get legacyUi1448afee1d => 'Visible para el conductor';

  @override
  String get legacyUib60862f485 => 'Monedero';

  @override
  String get legacyUic4fe2a7498 => 'Notificaciones push web';

  @override
  String get legacyUi2e8a57cc5c => 'Sitio web';

  @override
  String get legacyUib32233ad82 => 'URL del sitio web';

  @override
  String get legacyUica976c5dc6 => 'Comparación semanal';

  @override
  String get legacyUidd322f2dc7 => 'Oeste';

  @override
  String get legacyUib336fc5587 => 'WhatsApp';

  @override
  String get legacyUi16ec75e229 =>
      'Nombre que ven los destinatarios en su bandeja de entrada.';

  @override
  String get legacyUi682d44be54 => 'Con dispositivo';

  @override
  String get legacyUi0a58e1d0a2 => 'Escribir una respuesta';

  @override
  String get legacyUi126cd2cd36 => 'Escribe una respuesta...';

  @override
  String get legacyUib58c0082b4 => 'Estás al día.';

  @override
  String get legacyUi558865a16f => 'YouTube';

  @override
  String get legacyUid3639ca4df =>
      'Tu cuenta no tiene permiso para ver esta sección.';

  @override
  String get legacyUice100fe123 =>
      'Se perderán tus cambios. Esta acción no se puede deshacer.';

  @override
  String get legacyUi9b3cbed5c4 => 'Zoom';

  @override
  String get legacyUi4fc05f2763 => 'Acercar';

  @override
  String get legacyUia4ae4b24a1 => 'Alejar';

  @override
  String get legacyUib6958e3c52 => 'Clave API o nombre de usuario';

  @override
  String get legacyUib5f203a910 => 'cmdId';

  @override
  String get legacyUif05135d639 => 'seguro, permiso';

  @override
  String get legacyUid127ec8ef2 => 'jane@company.com';

  @override
  String get legacyUi216fb6179a => 'km/h, C, V';

  @override
  String get legacyUi7252f9e8d5 => 'últimos 7 días';

  @override
  String get legacyUibbdead93fb => 'licencia, identidad, permiso';

  @override
  String get legacyUid7cb0327fd => 'licencia, seguro';

  @override
  String get legacyUica62660225 => 'noreply@example.com';

  @override
  String get legacyUid043e53c7d => 'queueId';

  @override
  String get legacyUi11c8ce1244 => 'recipient@example.com';

  @override
  String get legacyUi4b329f8934 => 'velocidad, combustible';

  @override
  String get legacyUi65e012062c => 'support@example.com';

  @override
  String get legacyUi0bd41b4761 => 'este mes';

  @override
  String get legacyUie92d4d638a => 'sem. / mes';

  @override
  String get legacyUia126722ec0 => 'Requiere atención';

  @override
  String get legacyUi51eab2420d => 'Acciones del responsable de asignaciones';

  @override
  String get legacyUi8bdea32153 => 'Aún no hay actividad.';

  @override
  String get legacyUi05e3a866c3 =>
      'Se guardó la programación, pero no se pudieron generar algunos viajes.';

  @override
  String get legacyUi2924d70976 => 'Solo fecha';

  @override
  String get legacyUi63f39eeeb7 => 'Hora fija';

  @override
  String get legacyUi6930391c64 => 'Franja horaria';

  @override
  String get legacyUi601d153162 => 'Varios días';

  @override
  String get legacyUif61eadaf15 => 'En curso';

  @override
  String get legacyUia1bf92eff4 => 'Cancelado';

  @override
  String get legacyUic7dfb6f1d9 => 'En pausa';

  @override
  String get legacyUi90303d8df2 => 'Finalizado';

  @override
  String get legacyUi59f1111618 => 'En viaje';

  @override
  String get legacyUi2b613fb829 => 'Sin asignación';

  @override
  String get legacyUib564001a58 => 'Omitido';

  @override
  String get legacyUi736d1eee8e => 'Vehículo inactivo';

  @override
  String get legacyUif4330844fd => 'Vehículo bloqueado por licencia';

  @override
  String get legacyUiabf81c35d4 => 'Se requiere conductor';

  @override
  String get legacyUi2c9c1f7914 => 'No disponible';

  @override
  String get legacyUi8e9f1d6e54 => 'Sin iniciar';

  @override
  String get legacyUi4310ed540c => 'Con retraso';

  @override
  String get legacyUiaccac60339 => 'Incidencia del conductor';

  @override
  String get legacyUi6b535fa681 => 'Sin telemetría';

  @override
  String get legacyUi38a9e21ed9 => 'Desvío de ruta';

  @override
  String get legacyUi1f5a1abf2f => 'Completar';

  @override
  String get legacyUi5a436b7939 => 'Añadir observación';

  @override
  String get legacyUi65c821a596 => 'En tiempo real';

  @override
  String get legacyUi189cc40c22 => 'Desactualizado';

  @override
  String get legacyUi41c8e43d9e => 'GPS del vehículo';

  @override
  String get legacyUic1220e845b => 'Gestor de flota';

  @override
  String get legacyUi601f5ff70b => 'Automatización del sistema';

  @override
  String get legacyUi8b57ec8c92 => 'Asignación creada';

  @override
  String get legacyUi368e5b125f => 'Asignación confirmada';

  @override
  String get legacyUid00c8926f5 => 'Viaje iniciado automáticamente';

  @override
  String get legacyUic4b75c3924 => 'Viaje completado automáticamente';

  @override
  String get legacyUif98c835c4f => 'Viaje completado por el conductor';

  @override
  String get legacyUi4bb573b356 =>
      'Llegada a la parada detectada automáticamente';

  @override
  String get legacyUi52cd528ad4 => 'Parada completada automáticamente';

  @override
  String get legacyUicf338ebe5c => 'Parada completada por el conductor';

  @override
  String get legacyUi7ef2940c95 => 'Inicio del desvío de ruta';

  @override
  String get legacyUi55d93aed45 => 'Fin del desvío de ruta';

  @override
  String get legacyUi654c568718 => 'Inicio de la falta de telemetría';

  @override
  String get legacyUi66676d64b0 => 'Telemetría restablecida';

  @override
  String get legacyUi2a398797b5 => 'Inicio del exceso de velocidad';

  @override
  String get legacyUif7d315eb62 => 'Fin del exceso de velocidad';

  @override
  String get legacyUia22d66c857 => 'Llegada registrada';

  @override
  String get legacyUi5a000ad7bd => 'Omitido';

  @override
  String get legacyUi4028c0c8b4 => 'No disponible';

  @override
  String get legacyUi5f174de1cc => 'Comprobante';

  @override
  String get legacyUi4e91ee6122 => 'Zona horaria de la cuenta';

  @override
  String get legacyUi4dda6a4505 => 'Total de viajes';

  @override
  String get legacyUi523baab918 => 'Próximos';

  @override
  String get legacyUicc6e7b6a29 => 'Con retraso';

  @override
  String get legacyUie9fab1cf3a => 'Viajes completados a tiempo';

  @override
  String get legacyUibbb47a7157 => 'Porcentaje de puntualidad';

  @override
  String get legacyUi944b223791 => 'Distancia en km';

  @override
  String get legacyUi7c9352eed6 =>
      'Se enviará un mensaje breve con la configuración SMTP actual.';

  @override
  String get legacyUid173234df0 =>
      'ACC indica la señal del cable de encendido. MOTION indica la detección alternativa por movimiento.';

  @override
  String get legacyUi598ed2889b => 'Permisos de acceso';

  @override
  String get legacyUi9a6d95b0c5 => 'Cuenta activa';

  @override
  String get legacyUi8d00c06a55 =>
      'Registros de actividad, eventos del vehículo y telemetría';

  @override
  String get legacyUi61cc55aa04 => 'Añadir';

  @override
  String get legacyUiee01d7c402 => 'Añadir un administrador';

  @override
  String get legacyUib9b1e23f27 => 'Añadir un usuario';

  @override
  String get legacyUif2f8674f8a => 'Añadir un vehículo';

  @override
  String get legacyUi23a75918ab => 'Adopción y crecimiento';

  @override
  String get legacyUi80643ec204 => 'Limpieza avanzada';

  @override
  String get legacyUicf963e5241 => 'Filtros avanzados';

  @override
  String get legacyUi3aea7b29d9 =>
      'Los informes avanzados no están disponibles en la demostración pública. Accede con una cuenta de OpenVTS para generar, paginar, visualizar y exportar informes de la flota.';

  @override
  String get legacyUi056677c12f => 'Alertas por gravedad';

  @override
  String get legacyUif89ae580e8 => 'Todos los autores';

  @override
  String get legacyUiaeae2d71be => 'Todas las alertas';

  @override
  String get legacyUic0e8e58c1a => 'Todos los orígenes';

  @override
  String get legacyUic1cbbe0c5d => 'Desvío permitido';

  @override
  String get legacyUi826499f6b1 =>
      'La cobertura anual y el servicio del cliente son independientes.';

  @override
  String get legacyUi40e69b5db3 => 'Vehículo asignado';

  @override
  String get legacyUi6771ade6e8 => 'Archivos adjuntos';

  @override
  String get legacyUi52b258c824 =>
      'Describe brevemente el problema y adjunta archivos si es necesario.';

  @override
  String get legacyUi2f3b5c55bc => 'Examinar';

  @override
  String get legacyUi00189ab9b2 => 'Plantilla CSV';

  @override
  String get legacyUi19db82215d =>
      'Cambia tu contraseña para proteger el acceso a la cuenta.';

  @override
  String get legacyUi3f657f29e6 => 'Elige una nueva contraseña';

  @override
  String get legacyUicbd1538094 =>
      'Elige cómo recibir las alertas de vehículos, los eventos de exceso de velocidad y los eventos de geocercas.';

  @override
  String get legacyUic7cd13c042 =>
      'Elige las páginas y los informes disponibles para este usuario. Los cambios también limitan el acceso que puede conceder a los subusuarios.';

  @override
  String get legacyUibe10f5c042 =>
      'Elige lo que este miembro puede ver, editar y eliminar. Propio se aplica a sus registros; Global se aplica a toda tu cuenta.';

  @override
  String get legacyUi7834f4a6f4 =>
      'Elige dónde se entregan las alertas de este grupo de notificaciones.';

  @override
  String get legacyUic23350ccde => 'Detalles del comando';

  @override
  String get legacyUib2c253ba1c =>
      'Completa las siguientes secciones. Los campos obligatorios están marcados con un asterisco (*).';

  @override
  String get legacyUia2b4ac96b2 =>
      'Viajes completados por fecha de servicio. Las próximas asignaciones están disponibles en Viajes.';

  @override
  String get legacyUib3feb31fcb => 'Configura tu informe';

  @override
  String get legacyUi878b163022 => 'Confirmar limpieza';

  @override
  String get legacyUi9041d3c666 =>
      'Ponte en contacto con tu administrador para asignar vehículos.';

  @override
  String get legacyUi8e2fc0ffdc =>
      'Crea un perfil de acceso sencillo con permisos controlados.';

  @override
  String get legacyUi93c1ed632d =>
      'Crea y gestiona geocercas, puntos de interés y rutas.';

  @override
  String get legacyUie4781f0bde =>
      'Crea y gestiona corredores de rutas operativas.';

  @override
  String get legacyUi6571e94148 =>
      'Crea enlaces públicos seguros para el seguimiento de vehículos en tiempo real.';

  @override
  String get legacyUie09271eeb7 => 'Creado: ';

  @override
  String get legacyUidb0d2488de => 'Asignación actual';

  @override
  String get legacyUif8ece934c7 => 'Totales diarios de distancia';

  @override
  String get legacyUicb47dca7e3 => 'Totales diarios del intervalo seleccionado';

  @override
  String get legacyUi71d6e89bcc => 'Conducción diurna frente a nocturna';

  @override
  String get legacyUi2f3c38363d => '¿Eliminar el punto de interés?';

  @override
  String get legacyUi30c6c6352a => '¿Eliminar la geocerca?';

  @override
  String get legacyUic6f82fca90 => '¿Eliminar la ruta?';

  @override
  String get legacyUie543c4fd0c => 'Espacio de demostración • Solo lectura';

  @override
  String get legacyUi50dd7fb720 => 'Configuración del dispositivo';

  @override
  String get legacyUi0cf40756a6 => 'Dibuja y gestiona límites operativos.';

  @override
  String get legacyUi243f6cfeec => 'Km recorridos';

  @override
  String get legacyUie30d463652 =>
      'Los datos del conductor no están disponibles.';

  @override
  String get legacyUi251b80c58c => 'Suscripción por correo electrónico';

  @override
  String get legacyUibe482973b9 => 'Habilitar SMTP';

  @override
  String get legacyUi21685f000f => 'Finalizar esta sesión en este dispositivo.';

  @override
  String get legacyUide4f0c9387 => 'Filtros de eventos';

  @override
  String get legacyUi6e74f5ccbd => 'Eventos por tipo';

  @override
  String get legacyUi74bbe75120 => 'Próximo a vencer';

  @override
  String get legacyUi8d00705083 => 'Fecha de vencimiento';

  @override
  String get legacyUi0da7bfa1a0 => 'Fecha de vencimiento (opcional)';

  @override
  String get legacyUi86baf678e1 => 'Filas con errores';

  @override
  String get legacyUi2b1d93a2c6 => 'Filtrar registros de actividad';

  @override
  String get legacyUi9a4184cef3 =>
      'Filtrar por administrador e intervalo de fechas.';

  @override
  String get legacyUi96e578211a => 'Filtros';

  @override
  String get legacyUi5360d40661 => 'Fleet OS';

  @override
  String get legacyUi03d25e01e5 => 'Generar a partir de la búsqueda';

  @override
  String get legacyUi4d8abbdc5d => 'Generar informe';

  @override
  String get legacyUie16305f8b0 => 'Error al generar';

  @override
  String get legacyUid81feb6ae1 => 'Obtener historial';

  @override
  String get legacyUi6fa6308619 =>
      'Recibe notificaciones cuando los vehículos asignados se desvíen.';

  @override
  String get legacyUi4b6d6a3015 => 'Importante';

  @override
  String get legacyUic5288872fd =>
      'Las rutas inactivas se mantienen archivadas y visibles.';

  @override
  String get legacyUi44caf74675 => 'Bandeja de entrada';

  @override
  String get legacyUi3f33f2e865 =>
      'Incluye la ruta completa, p. ej., http://192.168.1.10:3000/api';

  @override
  String get legacyUi1919090902 => 'Último acceso: ';

  @override
  String get legacyUi1c747b4f98 => 'Última acción del servidor';

  @override
  String get legacyUi9e1bba7129 => 'Último período';

  @override
  String get legacyUi72da77c7b7 =>
      'Las coordenadas en tiempo real no están disponibles para este vehículo.';

  @override
  String get legacyUi3e893cdfd5 =>
      'Cargando tipos de dispositivo y proveedores...';

  @override
  String get legacyUi93fe7c05af => 'Cargando tipos de documento…';

  @override
  String get legacyUi75e940ee30 => 'Cargando historial';

  @override
  String get legacyUi59c3981787 => 'Cargando historial...';

  @override
  String get legacyUibbe4cbd55c => 'Cargando perfil';

  @override
  String get legacyUica88017dfa => 'Cargando estado de la suscripción...';

  @override
  String get legacyUid1ccf4c3e4 => 'Cargando vehículos…';

  @override
  String get legacyUif4e14815b1 => 'Acceder como administrador';

  @override
  String get legacyUi353bd1ef01 => 'Registros por categoría';

  @override
  String get legacyUib2af2f11de => 'Registros por nivel';

  @override
  String get legacyUi8c97e4f07d =>
      'Gestiona los conductores y subusuarios vinculados a tu flota.';

  @override
  String get legacyUi41948edc3a =>
      'Gestiona conductores, asignaciones, documentos y actividad.';

  @override
  String get legacyUi93b23afae0 =>
      'Gestiona lugares importantes y puntos operativos.';

  @override
  String get legacyUi68669149c0 =>
      'Gestiona subusuarios y su acceso a vehículos.';

  @override
  String get legacyUi9fcd87c64d =>
      'Gestiona los planes de precios de las suscripciones.';

  @override
  String get legacyUi274ef56d8e =>
      'Gestiona transacciones y renueva las suscripciones de vehículos';

  @override
  String get legacyUiff92dafaaf =>
      'Gestiona usuarios, acceso, contactos y vehículos asignados.';

  @override
  String get legacyUib42578bf99 =>
      'Los pagos manuales actualizan las transacciones y las estadísticas tras registrarse correctamente.';

  @override
  String get legacyUi421878a774 => 'Datos del mapa © Google';

  @override
  String get legacyUi2cf55e0f5b => 'Detalles del mapa';

  @override
  String get legacyUi9a3aa11de5 => 'Tipo de mapa';

  @override
  String get legacyUi09d3670056 =>
      'Máximo 10 MB. Bloqueados: exe, js, html, htm.';

  @override
  String get legacyUife0c6bc7dd => 'Diagnóstico de notificaciones push móviles';

  @override
  String get legacyUif6f444180f =>
      'Supervisa el tiempo de actividad, las dependencias y las acciones seguras de los servicios';

  @override
  String get legacyUi1a63cbf994 => 'Nuevo enlace';

  @override
  String get legacyUia40ad15529 => 'Nueva solicitud de soporte';

  @override
  String get legacyUi9f2d2d7331 =>
      'No hay tipos de documento configurados para usuarios.';

  @override
  String get legacyUi9ec5ec0752 =>
      'No hay geocercas activas: se incluyen todas.';

  @override
  String get legacyUi0a181de203 =>
      'No hay administradores disponibles. Desliza hacia abajo para actualizar y vuelve a intentarlo.';

  @override
  String get legacyUi43f32b9b9d => 'Sin información de contacto';

  @override
  String get legacyUie55a0728f0 => 'No hay geocercas para la vista previa';

  @override
  String get legacyUi115fe0fac7 => 'No se encontraron grupos';

  @override
  String get legacyUida501f43fd => 'Aún no hay datos de crecimiento.';

  @override
  String get legacyUi454fe267a7 => 'Sin metadatos';

  @override
  String get legacyUi2540cc1f1a =>
      'No hay solicitudes de renovación pendientes.';

  @override
  String get legacyUi7cd1d44b3c => 'No se encontraron registros.';

  @override
  String get legacyUi658e79f9dc => 'No se encontraron resultados';

  @override
  String get legacyUif018f94f6e =>
      'Ninguna fila coincide con los filtros del informe seleccionados.';

  @override
  String get legacyUibddbb17fc4 => 'Sin selección = todos';

  @override
  String get legacyUi9aba7bbe44 => 'Sin selección = todas las geocercas.';

  @override
  String get legacyUifd548f1c32 =>
      'Este vehículo no tiene sensores configurados';

  @override
  String get legacyUi162d1ddec0 => 'No se encontró actividad del equipo.';

  @override
  String get legacyUi8f91f15684 => 'Sin ubicación GPS válida';

  @override
  String get legacyUi74ac3b3d0d => 'No hay ningún vehículo asignado.';

  @override
  String get legacyUia26d9edac3 => 'No hay vehículos asignados a tu cuenta';

  @override
  String get legacyUie4b1dbf423 => 'No se encontraron vehículos.';

  @override
  String get legacyUi6eef664840 => 'Ninguno';

  @override
  String get legacyUif8ae6c8bbe => 'Sin confirmar';

  @override
  String get legacyUia92e15bc0a => 'Preferencias de notificaciones';

  @override
  String get legacyUic71ffe5d22 => 'Intervalo mínimo entre notificaciones';

  @override
  String get legacyUicb88cbc310 =>
      'Notificar cuando el vehículo se salga de la ruta';

  @override
  String get legacyUi0049196b0b => 'Desplazar 10 m';

  @override
  String get legacyUia49d76ddc1 => 'Un vehículo';

  @override
  String get legacyUi0080aaa977 => 'Open VTS';

  @override
  String get legacyUi032a6dcfd8 =>
      'Abre una solicitud de soporte para revisar la conversación completa.';

  @override
  String get legacyUi50f8c47b2b => 'Abrir en navegación';

  @override
  String get legacyUi89202c7fd8 => 'Otro documento';

  @override
  String get legacyUi27b4bf6d1b =>
      'El correo saliente utiliza este servidor cuando está activo.';

  @override
  String get legacyUi619d7adc2c =>
      'El pago aparecerá inmediatamente en la lista de transacciones.';

  @override
  String get legacyUidc32a816e9 =>
      'Eliminar permanentemente los registros anteriores al período de retención.';

  @override
  String get legacyUic2ff2762ca => 'Selecciona un archivo.';

  @override
  String get legacyUi3585d74456 => 'Conservar el vencimiento actual';

  @override
  String get legacyUia9a96ec019 => 'Principal';

  @override
  String get legacyUi668c4636aa => 'Comprobante de entrega';

  @override
  String get legacyUif702b26481 => 'Ordenados por número de transacciones';

  @override
  String get legacyUid03c65244f => 'Recalcular a partir del plan';

  @override
  String get legacyUi72d5617f3f => 'Actividad reciente';

  @override
  String get legacyUi255e5788a2 => 'Recupera tu cuenta';

  @override
  String get legacyUi505dddc915 => 'Actualizando';

  @override
  String get legacyUi54dd5046d0 =>
      'Al actualizar, los cambios de notificaciones sin guardar se sustituirán por los ajustes más recientes del servidor.';

  @override
  String get legacyUi199ed09ba9 => 'Acceso a informes';

  @override
  String get legacyUibd7b4f006d => 'Informar de un problema';

  @override
  String get legacyUi8115c55b47 =>
      'Los informes están restringidos en el modo de demostración';

  @override
  String get legacyUi6b5890ba0b =>
      'Solicita y confirma un código de un solo uso para verificar el correo electrónico y el número de WhatsApp.';

  @override
  String get legacyUif7194e6a0d => 'Solicitudes';

  @override
  String get legacyUif25bbab45d => 'Previsión de ingresos';

  @override
  String get legacyUiec40affa3e => 'Tendencia de ingresos';

  @override
  String get legacyUic53c3605a0 =>
      'Revisa las solicitudes de renovación de los clientes. Confirma únicamente los pagos recibidos realmente fuera de la aplicación.';

  @override
  String get legacyUiffbfe1e822 => 'Paradas de la ruta';

  @override
  String get legacyUi50eec1a359 => 'Resultado de la ejecución';

  @override
  String get legacyUi339225895f =>
      'La limpieza elimina datos de forma permanente. Revisa siempre la vista previa primero.';

  @override
  String get legacyUifee1dff0c6 => 'En movimiento frente a detenido';

  @override
  String get legacyUi0fb59422f6 => 'Muestras';

  @override
  String get legacyUide6472b8d3 => 'Seleccionar intervalo de fechas';

  @override
  String get legacyUia35cfe395a => 'Seleccionar grupo';

  @override
  String get legacyUi2564e1a2c5 => 'Seleccionar sensor';

  @override
  String get legacyUifea7a520f3 => 'Seleccionar vehículo';

  @override
  String get legacyUi70037936c0 => 'Selecciona una solicitud de soporte';

  @override
  String get legacyUieeaf903bb8 => 'Selecciona primero un vehículo';

  @override
  String get legacyUiad7a8a1750 =>
      'Selecciona un administrador, describe el problema y adjunta archivos si es necesario.';

  @override
  String get legacyUi9bb7b69035 => 'Selecciona al menos un estado';

  @override
  String get legacyUifcfe92e583 => 'Seleccionar panel';

  @override
  String get legacyUif9f50c1c30 =>
      'Selecciona vehículos, intervalo de fechas y filtros; después genera el informe para ver los resultados.';

  @override
  String get legacyUi0e40d8b0bf => 'Vehículos seleccionados';

  @override
  String get legacyUi43e146fb62 => 'Supervisión del estado del servidor';

  @override
  String get legacyUi644899c565 =>
      'El vencimiento del servicio controla el seguimiento en tiempo real. Contacta con tu administrador para renovarlo. Una solicitud de renovación no amplía el servicio hasta que se confirme el pago.';

  @override
  String get legacyUi5cbd584046 => 'Servicios';

  @override
  String get legacyUi758d7f7281 => 'Activar';

  @override
  String get legacyUi7c9275ee4b => 'Desactivar';

  @override
  String get legacyUiddbe3ed1a3 => 'Establecer vencimiento personalizado';

  @override
  String get legacyUi7b53693e94 => 'Compartir enlaces de seguimiento';

  @override
  String get legacyUidc1649a16c => 'Cerrar sesión';

  @override
  String get legacyUi2f32be1dc7 => 'Firma';

  @override
  String get legacyUi51070e69d1 => 'Foto del lugar';

  @override
  String get legacyUi93773568cf => 'Límite de velocidad';

  @override
  String get legacyUicb672694bb => 'Filtro de estado';

  @override
  String get legacyUi511404ce3b => 'Distribución de estados';

  @override
  String get legacyUie54e98e0cb => 'Parada';

  @override
  String get legacyUie48d04b2b6 =>
      'Detener Frontend, Backend o Listener puede impedirte acceder a la aplicación. Esta página permite iniciar y reiniciar esos servicios, pero la opción de detener está deshabilitada.';

  @override
  String get legacyUi16b45ef102 =>
      'Proporción de operaciones correctas, pendientes y fallidas';

  @override
  String get legacyUi12b71c3e0f => 'Resumen';

  @override
  String get legacyUied9177cab1 => 'Métricas del sistema';

  @override
  String get legacyUie20a879f45 =>
      'Toca para editar las notificaciones de geocercas';

  @override
  String get legacyUiac8b906fca => 'Vehículo de destino';

  @override
  String get legacyUib644561145 => 'Registro de telemetría';

  @override
  String get legacyUi7840676a23 => 'Registro de telemetría';

  @override
  String get legacyUi4ee3736ca6 =>
      'Esta acción no se puede deshacer. Se eliminarán el conductor y sus asignaciones relacionadas.';

  @override
  String get legacyUi3575c0aec8 =>
      'Esta acción elimina permanentemente el subusuario y revoca su acceso a vehículos. No se puede deshacer.';

  @override
  String get legacyUi7f3d98b829 =>
      'No se puede eliminar este enlace porque falta su ID.';

  @override
  String get legacyUi4e81e87c37 =>
      'Se eliminarán permanentemente los datos anteriores al período de retención. Esta acción no se puede deshacer.';

  @override
  String get legacyUid8b029df5c =>
      'Este enlace público de seguimiento dejará de funcionar inmediatamente. Esta acción no se puede deshacer.';

  @override
  String get legacyUida735ce16c =>
      'Este informe no está disponible para tu cuenta.';

  @override
  String get legacyUidf3e8a5fdd =>
      'Esta solicitud está cerrada o resuelta. Las respuestas están deshabilitadas.';

  @override
  String get legacyUif9c732c3c6 =>
      'Esta solicitud está cerrada. Responder puede volver a abrirla o pasarla a En curso, según el comportamiento del servidor.';

  @override
  String get legacyUif3a8370f38 => 'Ingresos totales';

  @override
  String get legacyUie273941b29 => 'Totales por moneda';

  @override
  String get legacyUiaa7d3d7dd9 => 'Historial de transacciones';

  @override
  String get legacyUib174443b0e => 'Transacciones e ingresos';

  @override
  String get legacyUi9dda9aa776 => 'Viaje';

  @override
  String get legacyUic948ed8076 => 'Comprobantes del viaje';

  @override
  String get legacyUid67a44f68d =>
      'Prueba a modificar los filtros o el intervalo de fechas.';

  @override
  String get legacyUi078f02fe7b => 'No se pudieron cargar los documentos';

  @override
  String get legacyUi3b37311cd6 => 'No se pudo cargar el historial';

  @override
  String get legacyUicaa5bd27e5 => 'No se pudieron cargar los registros';

  @override
  String get legacyUi92078d350e => 'No se pudieron cargar los pagos';

  @override
  String get legacyUi5db77ece1a => 'No se pudo cargar el perfil';

  @override
  String get legacyUi081863e321 =>
      'No se pudieron cargar las solicitudes de soporte';

  @override
  String get legacyUi11f14b7638 =>
      'Actualiza los datos de la empresa y los enlaces a redes sociales.';

  @override
  String get legacyUieb58c61a89 =>
      'Actualiza los datos personales y la dirección. Los cambios se guardan únicamente cuando los confirmas.';

  @override
  String get legacyUid19cf73ae1 => 'Actualizado: ';

  @override
  String get legacyUi9db8e8ec0b =>
      'Usa la lista de vehículos del mapa en tiempo real y elige el umbral de parada y el intervalo de fecha y hora.';

  @override
  String get legacyUid337d1a0d6 => 'Vista previa de variables';

  @override
  String get legacyUi63dfad55e0 => 'Información del vehículo';

  @override
  String get legacyUi7f4567c8c2 => 'Estado del vehículo en tiempo real';

  @override
  String get legacyUiceedc505bd => 'Estado del vehículo';

  @override
  String get legacyUi1f41948d84 => 'Evento del vehículo';

  @override
  String get legacyUid3aee04e65 => 'Matriz de vehículos y geocercas';

  @override
  String get legacyUiefd8355920 => 'Ver todo';

  @override
  String get legacyUi50ad3280e1 => 'Ver vehículo';

  @override
  String get legacyUi2c3c7c93f8 =>
      'Consulta pagos, créditos, débitos y registros de facturación.';

  @override
  String get legacyUi7d9ff4f0de => 'Visibilidad';

  @override
  String get legacyUi79c6a6033a => 'Visible para el administrador';

  @override
  String get legacyUied0069155f => 'Visible para el usuario';

  @override
  String get legacyUia56d85fb20 =>
      'Los navegadores web requieren que el servidor permita solicitudes entre orígenes (CORS). Si el acceso falla por un error de conexión, habilita CORS en el servidor.';

  @override
  String get legacyUi4dd079044f => 'Viaje completo';

  @override
  String get legacyUi4515b6c7b7 => 'Tu jornada';

  @override
  String get legacyUi50f19ac0b4 =>
      'Tus documentos y los que comparte el gestor de tu flota.';

  @override
  String get legacyUi4e697d55ce =>
      'Tus transacciones con el propietario del software.';

  @override
  String get legacyUi678830983a =>
      '— contenido recortado para su visualización —';

  @override
  String legacyUi1e22f79cd9(Object value1) {
    return 'Cargando $value1';
  }

  @override
  String legacyUi57fdb35e30(Object value1) {
    return '$value1 no disponible';
  }

  @override
  String legacyUi1fd3e5084a(Object value1) {
    return 'No se encontró $value1';
  }

  @override
  String get legacyUie16f97dcfd => 'Borrar historial';

  @override
  String legacyUiabd4cd39b9(Object value1) {
    return '$value1 puntos';
  }

  @override
  String legacyUi90eaac7e8b(Object value1) {
    return '$value1 paradas';
  }

  @override
  String legacyUi865d65baea(Object value1) {
    return '$value1 excesos de velocidad';
  }

  @override
  String legacyUi7326be7e87(Object value1, Object value2) {
    return '$value1 $value2 máx.';
  }

  @override
  String legacyUi5fd7f54937(Object value1, Object value2) {
    return '$value1 $value2 de media';
  }

  @override
  String legacyUi5f2ee53a4c(Object value1) {
    return '$value1 en movimiento';
  }

  @override
  String legacyUi5c24a04874(Object value1) {
    return '$value1 detenido';
  }

  @override
  String legacyUi2b4b82c8bb(Object value1) {
    return 'Duración: $value1';
  }

  @override
  String legacyUi27a82a7136(Object value1) {
    return '$value1 en conducción';
  }

  @override
  String legacyUi92edf7854b(Object value1) {
    return '$value1 vehículos';
  }

  @override
  String get legacyUi5d12bd5355 => 'Reproducir';

  @override
  String get legacyUi4e39567064 => 'Nota (opcional)';

  @override
  String get legacyUi932fc13e7f => 'Título (opcional)';

  @override
  String legacyUi2c904359f5(Object value1) {
    return 'El archivo supera el límite de $value1 MB';
  }

  @override
  String legacyUi66db457b99(Object value1) {
    return 'Formato no compatible. Permitidos: $value1';
  }

  @override
  String get legacyUia7cf7b25a7 => 'Sustituir';

  @override
  String legacyUidf1d5f2730(Object value1) {
    return 'Correo de prueba enviado a $value1';
  }

  @override
  String get legacyUi044b852f30 => 'Mostrar contraseña';

  @override
  String get legacyUie40123b4e7 => 'Ocultar contraseña';

  @override
  String get legacyUi82f47c3d4d => 'Correo electrónico verificado';

  @override
  String get legacyUib1a273086c => 'WhatsApp verificado';

  @override
  String legacyUi908e5c8ce5(Object value1) {
    return 'Sesión cerrada en $value1';
  }

  @override
  String get legacyUi33ce417454 => 'Cargando…';

  @override
  String get legacyUi71ae0ec96e => 'Error al cargar: reintentar';

  @override
  String get legacyUi67c4d0506a => 'No aplicable';

  @override
  String get legacyUia0b1fb2afb => 'Mostrar confirmación de contraseña';

  @override
  String get legacyUie2196c3942 => 'Ocultar confirmación de contraseña';

  @override
  String get legacyUi7c073937c6 => 'Código enviado a tu correo electrónico';

  @override
  String get legacyUi8532209c49 => 'Código enviado por WhatsApp';

  @override
  String get legacyUi0d455a4e26 => 'Verificar correo electrónico';

  @override
  String get legacyUi9cb68a6dd3 => 'Verificar WhatsApp';

  @override
  String legacyUi8cf58d99c1(Object value1) {
    return 'Desde $value1';
  }

  @override
  String legacyUif41a1a65a6(Object value1) {
    return 'Hasta $value1';
  }

  @override
  String legacyUia801634da8(Object value1) {
    return '$value1 eliminado.';
  }

  @override
  String legacyUi73f15343e6(Object value1) {
    return 'Has accedido como $value1.';
  }

  @override
  String get legacyUi48138f08cd => 'Desactivar administrador';

  @override
  String get legacyUif9494a277e => 'Activar administrador';

  @override
  String get legacyUi13a84a7390 => 'Administrador activado.';

  @override
  String get legacyUi8181bbb7c7 => 'Administrador desactivado.';

  @override
  String get legacyUid65ded9428 => 'Desactivar';

  @override
  String get legacyUi92ef08325a => 'Activar';

  @override
  String get legacyUiacfd05ab80 => 'Correo electrónico sin verificar';

  @override
  String get legacyUi23c9dd8809 =>
      'No se pudieron cargar los vehículos. Reintentar.';

  @override
  String legacyUib089c07088(Object value1) {
    return 'GMT $value1';
  }

  @override
  String legacyUi73585fdb6f(Object value1) {
    return 'Añadido $value1';
  }

  @override
  String get legacyUi410bebb5ea =>
      'No se pudieron cargar los documentos. Reintentar.';

  @override
  String get legacyUi7f10270c45 =>
      'No se pudieron cargar los tipos de documento. Reintentar.';

  @override
  String get legacyUid4c2792a72 => 'Oculto';

  @override
  String get legacyUi1b7cd8a9bf => 'Documento actualizado.';

  @override
  String get legacyUi895a77b095 => 'Documento subido.';

  @override
  String get legacyUief6604a13d => 'Editar documento';

  @override
  String get legacyUif6769b696e => 'Créditos añadidos.';

  @override
  String get legacyUib16dd3b790 => 'Créditos descontados.';

  @override
  String get legacyUie890b12b34 =>
      'Ninguna transacción coincide con los filtros';

  @override
  String get legacyUib71113c83a =>
      'No se encontraron pagos de este administrador. Prueba a borrar los filtros.';

  @override
  String get legacyUi472af48c6d => 'Registra un pago manual para empezar.';

  @override
  String legacyUi46f7e02bd0(Object value1) {
    return '$value1 copiado';
  }

  @override
  String legacyUi70d9eead51(Object value1) {
    return 'El asunto debe tener $value1 caracteres o menos.';
  }

  @override
  String legacyUifee6584f1b(Object value1) {
    return 'La descripción debe tener $value1 caracteres o menos.';
  }

  @override
  String legacyUi830e676993(Object value1) {
    return 'Puedes subir hasta $value1 archivos.';
  }

  @override
  String legacyUi4e5f407ec5(Object value1) {
    return 'Archivo bloqueado eliminado: $value1';
  }

  @override
  String legacyUib5d0b873d0(Object value1) {
    return 'Archivo no compatible eliminado: $value1';
  }

  @override
  String legacyUid1740cec1d(Object value1) {
    return 'El archivo supera los 5 MB: $value1';
  }

  @override
  String legacyUie33e0ec27a(Object value1) {
    return 'La respuesta debe tener $value1 caracteres o menos.';
  }

  @override
  String legacyUid9e484645b(Object value1) {
    return 'La solicitud ya tiene el estado $value1.';
  }

  @override
  String legacyUiebbf66ef0e(Object value1, Object value2) {
    return 'De: $value1$value2';
  }

  @override
  String legacyUi94cf932307(Object value1) {
    return 'Creado $value1';
  }

  @override
  String legacyUib5ae5701b9(Object value1) {
    return 'Actualizado $value1';
  }

  @override
  String legacyUi1a150ff203(Object value1) {
    return 'Cerrado $value1';
  }

  @override
  String get legacyUiec6952e09b => 'Actualizando';

  @override
  String legacyUi190040d9d3(Object value1) {
    return 'Algunos archivos superan los 5 MB y se han eliminado$value1.';
  }

  @override
  String legacyUi2a432bdd06(Object value1) {
    return 'Agente local: $value1';
  }

  @override
  String get legacyUi3adb8e50db => 'Crea un miembro del equipo para empezar.';

  @override
  String legacyUiabad5c010f(Object value1) {
    return '$value1 · Permisos';
  }

  @override
  String get legacyUifb91e24fa5 => 'Actualizar';

  @override
  String get legacyUia9d4f0d3b6 => 'No se pudieron actualizar los permisos';

  @override
  String get legacyUi918bffea2f => 'Mostrar contraseña actual';

  @override
  String get legacyUifa0245c379 => 'Ocultar contraseña actual';

  @override
  String get legacyUi9a569782b5 => 'Mostrar nueva contraseña';

  @override
  String get legacyUiaa10918381 => 'Ocultar nueva contraseña';

  @override
  String get legacyUi39b0c83afa => 'Mostrar confirmación de nueva contraseña';

  @override
  String get legacyUiea6f8ea221 => 'Ocultar confirmación de nueva contraseña';

  @override
  String legacyUie30362677c(Object value1) {
    return '$value1 registrados';
  }

  @override
  String legacyUi060250e9ba(Object value1) {
    return '$value1 facturas';
  }

  @override
  String get legacyUi53e337d44c => 'Guardar plan';

  @override
  String get legacyUi4fc636d1bb => 'Plan actualizado.';

  @override
  String get legacyUidc5a367e83 => 'Plan creado.';

  @override
  String get legacyUi2325fc9152 => 'No hay tipos de vehículo disponibles';

  @override
  String get legacyUi4e4664e8e9 => 'Seleccionar tipo de vehículo';

  @override
  String get legacyUi37282b63dd => 'Cargando usuarios...';

  @override
  String get legacyUide2b4561e4 => 'No se pudieron cargar los usuarios';

  @override
  String get legacyUif1b918acaf => 'Crear o seleccionar usuario principal';

  @override
  String get legacyUic96ec8c8a6 => 'No hay dispositivos disponibles';

  @override
  String get legacyUieeed87c94b => 'Seleccionar dispositivo GPS';

  @override
  String get legacyUie5a3dc6c41 => 'No hay planes disponibles';

  @override
  String get legacyUi509d83b55f => 'Seleccionar plan de precios';

  @override
  String legacyUi91c69c8c0d(Object value1) {
    return 'Vehículo «$value1» creado.';
  }

  @override
  String get legacyUi048e2d12ad => 'Vehículo desactivado.';

  @override
  String get legacyUib042915cc0 => 'Vehículo activado.';

  @override
  String get legacyUi3741f56c60 => 'Crear sensor';

  @override
  String get legacyUi996e719712 => 'Guardar sensor';

  @override
  String get legacyUiaa9bf6a127 => 'No se pudo actualizar el servicio';

  @override
  String legacyUif17fe09e18(Object value1) {
    return 'Cobertura anual de $value1 renovada';
  }

  @override
  String get legacyUid55d13471f => 'Error en la renovación anual';

  @override
  String get legacyUi2caa5892b7 => 'Consultando estado...';

  @override
  String get legacyUid56ae084ba => 'Editar documento';

  @override
  String get legacyUi47396c4fcf => 'Crea un conductor para empezar.';

  @override
  String get legacyUie4c5584c2a => 'Conductor activado.';

  @override
  String get legacyUi255f9b5d50 => 'Conductor desactivado.';

  @override
  String legacyUi2c5ad08780(Object value1) {
    return 'Vence: $value1';
  }

  @override
  String get legacyUifc3606d535 => 'Desactivar conductor';

  @override
  String get legacyUic82a768102 => 'Activar conductor';

  @override
  String legacyUi3c2dd46009(Object value1) {
    return '$value1 (actual)';
  }

  @override
  String get legacyUi9e9d25ea74 => 'Selecciona primero el país';

  @override
  String get legacyUi789073b300 => 'Selecciona primero el estado';

  @override
  String get legacyUie0c7a349f8 => 'Deseleccionar todos los filtrados';

  @override
  String get legacyUi30a4c62f4d => 'Seleccionar todos los filtrados';

  @override
  String get legacyUi303e32bfd9 => 'Pago confirmado y servicio renovado';

  @override
  String get legacyUiad3c7489f5 => 'Solicitud de renovación cancelada';

  @override
  String get legacyUi91027c0a9a => 'No se pudo actualizar la solicitud';

  @override
  String get legacyUi3fb82cbe4b => 'Buscar solicitudes de soporte de usuarios';

  @override
  String get legacyUi3263ab8929 => 'Buscar mis solicitudes de soporte';

  @override
  String get legacyUi24cae41f13 => 'Usuario activado.';

  @override
  String get legacyUi48d348ab09 => 'Usuario desactivado.';

  @override
  String legacyUi515200de54(Object value1) {
    return 'Mínimo $value1 caracteres';
  }

  @override
  String get legacyUiea03fca475 => 'Selecciona primero un país';

  @override
  String get legacyUi01d9797a19 => 'No hay estados disponibles';

  @override
  String get legacyUic234150a07 => 'Selecciona un estado';

  @override
  String get legacyUida9ca145a1 => 'Selecciona primero un estado';

  @override
  String get legacyUi12fb8b7d21 => 'No hay ciudades disponibles';

  @override
  String get legacyUia8ab373cf7 => 'Selecciona una ciudad';

  @override
  String legacyUi99c1db6636(Object value1) {
    return 'Usuario «$value1» creado.';
  }

  @override
  String get legacyUi6ea66e7cf8 => 'Sin conductores asignados';

  @override
  String get legacyUi6b4d2e8347 => 'Ningún conductor coincide con tu búsqueda';

  @override
  String legacyUic7a9755928(Object value1) {
    return 'Licencia $value1';
  }

  @override
  String get legacyUi530530a405 => 'No hay conductores disponibles';

  @override
  String legacyUied9f265a0a(Object value1) {
    return 'Buscar $value1…';
  }

  @override
  String get legacyUia269afc99c => 'No se encontraron solicitudes de soporte';

  @override
  String get legacyUifd0ab9a284 => 'Ninguna solicitud coincide con tu búsqueda';

  @override
  String legacyUic93cd16b9b(Object value1) {
    return 'Últimos $value1';
  }

  @override
  String legacyUib68af38cf0(Object value1) {
    return 'La solicitud ya tiene el estado $value1.';
  }

  @override
  String get legacyUi9ddc709693 => 'Desactivar usuario';

  @override
  String get legacyUiaebaaf50f8 => 'Activar usuario';

  @override
  String get legacyUi8ed321fdf0 => 'No se pudieron guardar los permisos';

  @override
  String get legacyUi51c4b07667 => 'Ningún vehículo coincide con tu búsqueda';

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
    return 'Vencimiento $value1';
  }

  @override
  String get legacyUif0dc6b09f8 => 'No hay vehículos disponibles';

  @override
  String get legacyUi39d436aaba => 'Sin vencimiento';

  @override
  String get legacyUic15c47e4c9 =>
      'Buscar IMEI, tipo de dispositivo o número de SIM…';

  @override
  String get legacyUibc139b1c14 => 'Buscar SIM, IMSI, ICCID o proveedor…';

  @override
  String get legacyUiaa729739dd => 'No se encontraron dispositivos';

  @override
  String get legacyUi679d782d32 => 'No se encontraron tarjetas SIM';

  @override
  String get legacyUi613b9215a5 => 'Añade inventario para empezar.';

  @override
  String get legacyUi9f91b0dc33 => 'Cargando tipos de dispositivo...';

  @override
  String legacyUi9ba6bfee17(Object value1) {
    return 'Se usan valores predeterminados seguros. $value1';
  }

  @override
  String get legacyUi2919b3cdf5 => 'Correo electrónico pendiente';

  @override
  String get legacyUidfd4099c87 => 'WhatsApp pendiente';

  @override
  String legacyUif0dd87cef8(Object value1) {
    return 'Cambiar a la pestaña $value1';
  }

  @override
  String legacyUi364cdce6f9(Object value1) {
    return '$value1 créditos';
  }

  @override
  String get legacyUi070e328ec8 => 'Subiendo...';

  @override
  String get legacyUie8d33553f6 => 'Cambiar foto';

  @override
  String legacyUi56b3825e50(Object value1) {
    return 'Aplicar preajuste $value1';
  }

  @override
  String get legacyUi28e40daab7 => 'Reenviando...';

  @override
  String get legacyUib707b694b2 => 'Reenviar código';

  @override
  String legacyUia648c7bbe2(Object value1) {
    return 'Selector de $value1';
  }

  @override
  String get legacyUidd1242a8fc => 'Suscrito';

  @override
  String get legacyUibbf5d78203 => 'Sin suscripción';

  @override
  String get legacyUi0e42454279 => 'todos los vehículos';

  @override
  String get legacyUi12e7d6beac => 'Origen desconocido';

  @override
  String get legacyUifb2269d326 => 'No hay vehículos operativos disponibles.';

  @override
  String get legacyUi9dd705b078 => 'No hay vehículos disponibles.';

  @override
  String legacyUi8879fce2e7(Object value1, Object value2) {
    return '$value1 vehículo$value2 con bloqueo fuera de la selección.';
  }

  @override
  String legacyUif039d146e6(Object value1) {
    return '$value1 vehículos asignados';
  }

  @override
  String get legacyUi02b460b2cf => 'No hay vehículos coincidentes';

  @override
  String get legacyUi537da7f70e =>
      'Todos los vehículos ya están asignados a este subusuario.';

  @override
  String get legacyUif614a2e6b5 => 'Prueba con otra búsqueda.';

  @override
  String get legacyUi28516f977e => 'Subusuario desactivado.';

  @override
  String get legacyUi7841e93192 => 'Subusuario activado.';

  @override
  String get legacyUi87e328dc94 => 'Borrar búsqueda';

  @override
  String get legacyUi72556ffa55 => 'Visible para el conductor';

  @override
  String get legacyUi355f129929 => 'Oculto para el conductor';

  @override
  String get legacyUib68e795ff9 => 'Cambiar vehículo';

  @override
  String get legacyUi0cb329674a => 'Visible en los documentos del usuario';

  @override
  String get legacyUi7ab98ca9b9 => 'Oculto en los documentos del usuario';

  @override
  String get legacyUi5f22178640 => 'El conductor puede ver este documento';

  @override
  String get legacyUiaf7ad5ad5c => 'El conductor no puede ver este documento';

  @override
  String get legacyUib544cc3e95 => 'No hay vehículos sin asignar';

  @override
  String get legacyUidf10a27148 => 'Todos los vehículos ya están asignados.';

  @override
  String get legacyUic3763af773 => 'Sin actualizar';

  @override
  String get legacyUia1f5a8dbd3 => 'No se encontraron sensores';

  @override
  String get legacyUi6a3625800c =>
      'Este vehículo no tiene sensores configurados.';

  @override
  String get legacyUi5fdd1b0855 => 'Ajustes del sensor';

  @override
  String get legacyUi2524c34a0d => 'Nuevo sensor';

  @override
  String get legacyUiae7e887517 => 'Guardando...';

  @override
  String get legacyUi126eda8b21 => 'Ejecutando...';

  @override
  String get legacyUi7745774c38 => 'Sensor creado.';

  @override
  String get legacyUi2a367dafb5 => 'Sensor actualizado.';

  @override
  String get legacyUi4abc320492 => 'Cargando configuración';

  @override
  String get legacyUic0ae8f6ea8 => 'Guardado';

  @override
  String get legacyUif352418f58 => 'Cargando tipos…';

  @override
  String get legacyUi82385d8917 => 'Cargando zonas horarias…';

  @override
  String get legacyUi22e6340f2c => 'Seleccionar zona horaria';

  @override
  String get legacyUicc4889261c => 'Volver a cargar el historial';

  @override
  String get legacyUi9e8a1c5b7b => 'Cargando sensores…';

  @override
  String legacyUic0a743750e(Object value1) {
    return 'Seleccionar intervalo del informe de $value1';
  }

  @override
  String legacyUi26362a69a0(Object value1) {
    return 'En movimiento: $value1';
  }

  @override
  String legacyUicbbef93382(Object value1) {
    return 'Detenido: $value1';
  }

  @override
  String legacyUic1d252d58b(Object value1) {
    return '$value1 — Exceso de velocidad';
  }

  @override
  String legacyUidf3ab0c2d9(Object value1) {
    return 'Día: $value1';
  }

  @override
  String legacyUi20076143b6(Object value1) {
    return 'Noche: $value1';
  }

  @override
  String legacyUie296339b1e(Object value1, Object value2) {
    return '$value1 viaje$value2';
  }

  @override
  String legacyUib4c5c14ddb(Object value1) {
    return 'Máx. $value1 km/h';
  }

  @override
  String legacyUi491fa657c5(Object value1, Object value2) {
    return '$value1: $value2 km';
  }

  @override
  String legacyUia6587e8e7b(Object value1) {
    return 'Distancia por vehículo (los $value1 primeros)';
  }

  @override
  String legacyUi6eca89289b(Object value1) {
    return '$value1 km/h';
  }

  @override
  String legacyUib9a5d6824c(Object value1, Object value2) {
    return 'Geocerca $value1 para $value2';
  }

  @override
  String legacyUi4d24bcb058(Object value1, Object value2) {
    return 'Límite de velocidad ($value1) para $value2';
  }

  @override
  String get legacyUi56a2285c5b => 'Guardando…';

  @override
  String legacyUia1f38b12bb(Object value1) {
    return 'Activar o desactivar $value1';
  }

  @override
  String legacyUic3b516d33c(Object value1) {
    return '$value1 geocercas';
  }

  @override
  String get legacyUi010f99630a => 'Editar enlace de seguimiento';

  @override
  String get legacyUibb53b1c483 => 'Nuevo enlace de seguimiento';

  @override
  String legacyUi9287b718c6(Object value1) {
    return 'Selección: $value1';
  }

  @override
  String get legacyUib948ff19e4 => 'Desbloquear cuadrado';

  @override
  String get legacyUi85a3ef0c3f => 'Bloquear cuadrado';

  @override
  String get legacyUi9dd7a6b201 => 'Crear geocerca';

  @override
  String get legacyUidccb573a71 => 'Dibujar ruta';

  @override
  String legacyUi4c91961249(Object value1) {
    return 'Subir $value1 filas';
  }

  @override
  String legacyUi0ff9c73519(Object value1) {
    return '$value1 válidos';
  }

  @override
  String legacyUifa7ec0ed62(Object value1) {
    return '$value1 no válidos';
  }

  @override
  String legacyUi1483db1240(Object value1) {
    return '$value1 correctos';
  }

  @override
  String legacyUi2c661fac7f(Object value1) {
    return '$value1 fallidos';
  }

  @override
  String get legacyUi7e613c0b85 => 'Colocar punto de interés';

  @override
  String get legacyUi4405592a72 => 'Mover punto de interés';

  @override
  String get legacyUi91fbb41bfb => 'Usar esta ubicación';

  @override
  String get legacyUif05f282071 =>
      'Toca el mapa para colocar el punto de interés';

  @override
  String get legacyUie8f485c68a =>
      'Prueba a modificar los filtros o el intervalo de fechas.';

  @override
  String get legacyUia0c0bb9e85 =>
      'No hay transacciones disponibles para este período.';

  @override
  String legacyUid7d6dade2a(Object value1) {
    return 'Correctas: $value1';
  }

  @override
  String legacyUi3a0d457cee(Object value1) {
    return 'Pendientes: $value1';
  }

  @override
  String legacyUi07d104432b(Object value1) {
    return 'Fallidas: $value1';
  }

  @override
  String get legacyUi3fb75e3bfe => 'Restablecer contraseña';

  @override
  String get legacyUif99d98e85f => 'Contraseña olvidada';

  @override
  String get legacyUi0d2afda86b => 'Espacio de demostración abierto';

  @override
  String get legacyUif06ccf010d => 'Acceso correcto';

  @override
  String get legacyUifc45091249 => 'Cambiar al modo claro';

  @override
  String get legacyUic29220f958 => 'Cambiar al modo oscuro';

  @override
  String get legacyUi257616b8e4 => 'No hay notificaciones sin leer';

  @override
  String get legacyUid2609b6af1 => 'Aún no hay notificaciones';

  @override
  String get legacyUi04d956a670 =>
      'Todo está marcado como leído. Las nuevas alertas aparecerán aquí cuando lleguen.';

  @override
  String get legacyUi7fe220bd95 =>
      'Las alertas de vehículos, los eventos del sistema y las novedades operativas aparecerán aquí.';

  @override
  String get legacyUib2f3a86e84 => 'Todo leído';

  @override
  String get legacyUicbf6939e9e => 'Marcando…';

  @override
  String get legacyUi8958e22c23 => 'Marcar todo como leído';

  @override
  String legacyUicb9ae54e8a(Object value1, Object value2) {
    return 'Mostrando $value1 de $value2';
  }

  @override
  String legacyUie5b28b8ae4(Object value1, Object value2) {
    return 'Página $value1 de $value2';
  }

  @override
  String get legacyUic1d317a815 => 'No hay solicitudes de soporte coincidentes';

  @override
  String get legacyUiae9e814889 => 'No hay solicitudes de soporte';

  @override
  String get legacyUicc80739f43 =>
      'Prueba con otra búsqueda o filtro de estado.';

  @override
  String get legacyUib1ac2d29f2 =>
      'Crea una solicitud de soporte y el equipo te responderá aquí.';

  @override
  String legacyUia6864fdac8(Object value1) {
    return '$value1 filas';
  }

  @override
  String get legacyUi8f26c6520d => 'Cargando';

  @override
  String legacyUie7a93c340a(Object value1) {
    return '$value1 eventos';
  }

  @override
  String get legacyUia4ab77ad86 => 'Evento de OpenVTS';

  @override
  String get legacyUif55aae5a86 => 'IMEI no disponible';

  @override
  String get legacyUib8eb4a7ee3 => 'Cargando comandos…';

  @override
  String get legacyUif7933da683 => 'No hay comandos compatibles';

  @override
  String get legacyUi4be4430e57 => 'Seleccionar comando';

  @override
  String legacyUi70ac5dd63e(Object value1) {
    return 'CRONOLOGÍA ($value1)';
  }

  @override
  String legacyUi24d8fbef9d(Object value1, Object value2) {
    return '$value1 ${value2}x';
  }

  @override
  String legacyUibde2a7e880(Object value1, Object value2, Object value3) {
    return 'Página $value1 de $value2 · $value3 viajes';
  }

  @override
  String legacyUi08343b3fe7(Object value1) {
    return '$value1 restantes';
  }

  @override
  String legacyUi843b148bbc(Object value1) {
    return 'Llegada estimada: $value1';
  }

  @override
  String legacyUi46d11990c5(Object value1) {
    return 'Posición actualizada $value1';
  }

  @override
  String legacyUiecd87f34a4(Object value1) {
    return '¿Eliminar $value1?';
  }

  @override
  String legacyUi666b616488(Object value1) {
    return 'Vence $value1';
  }

  @override
  String get legacyUic7ac551ef0 => 'Eliminando…';

  @override
  String legacyUi27015ac78b(Object value1, Object value2) {
    return '$value1 sin leer · Últimas $value2 notificaciones';
  }

  @override
  String legacyUi46b0a7d4ca(Object value1, Object value2) {
    return '$value1 / $value2 paradas completadas';
  }

  @override
  String get legacyUidc7f2c3785 => 'Fecha no disponible';

  @override
  String get legacyUib11b062b52 => 'Subir comprobante del viaje';

  @override
  String get legacyUi8f1a9ca44a => 'PDF, JPG, PNG o WebP · Hasta 5 MB';

  @override
  String get legacyUi91df716a6b =>
      'PDF, JPG, PNG, WebP, DOC o DOCX · Hasta 5 MB';

  @override
  String get legacyUid921a79afa => 'Subiendo…';

  @override
  String legacyUiba9b85b92a(Object value1) {
    return 'Última actualización $value1';
  }

  @override
  String legacyUib9f8dfe265(Object value1) {
    return 'Distancia de hoy: $value1';
  }

  @override
  String legacyUif0ea529a1a(Object value1) {
    return '$value1 días';
  }

  @override
  String legacyUi387c4ee271(Object value1, Object value2) {
    return '$value1  ·  $value2 días';
  }

  @override
  String get legacyUideba3e1d0f => 'Resumen de la simulación';

  @override
  String get legacyUia7d0c36803 => 'Última limpieza';

  @override
  String legacyUia24243eb0c(Object value1) {
    return 'Tablas ($value1)';
  }

  @override
  String get legacyUic74a3012a0 => 'Comprobando estado…';

  @override
  String get legacyUie991a76914 => 'Estado desconocido';

  @override
  String get legacyUia722bd6476 =>
      'Crecimiento de la plataforma en usuarios, vehículos y licencias.';

  @override
  String legacyUi852c487a99(Object value1) {
    return 'Máximo de licencias: $value1';
  }

  @override
  String legacyUic44efcae53(Object value1) {
    return '¿Eliminar $value1 de la plataforma? Esta acción no se puede deshacer.';
  }

  @override
  String legacyUicac4f1ac56(Object value1) {
    return '$value1 administrador';
  }

  @override
  String legacyUi68401f3c9e(Object value1, Object value2) {
    return 'Media de $value1 $value2 por transacción';
  }

  @override
  String get legacyUi526698fef7 => 'No se pudieron actualizar los vehículos.';

  @override
  String legacyUie9b7179dd3(Object value1) {
    return 'Documentos ($value1)';
  }

  @override
  String get legacyUiefd8314874 => 'No se pudieron actualizar los documentos.';

  @override
  String get legacyUie214b8a299 => 'Documento';

  @override
  String legacyUidb4675bc22(Object value1) {
    return 'Saldo: $value1';
  }

  @override
  String legacyUi16be827cb6(Object value1) {
    return 'Vehículo $value1';
  }

  @override
  String get legacyUibd5caf1601 =>
      'El seguimiento está bloqueado por el límite de la licencia del software.';

  @override
  String get legacyUid8663517be => 'Última comprobación: —';

  @override
  String get legacyUi1be0035c25 => 'Propio';

  @override
  String get legacyUi5f1184f7df => 'Global';

  @override
  String get legacyUif5f940cfe2 => 'Guardar permisos';

  @override
  String legacyUi8a9135d5ad(Object value1) {
    return '$value1% cobrado';
  }

  @override
  String legacyUi3b0c54fa00(Object value1) {
    return 'Estimado: $value1';
  }

  @override
  String legacyUi16ff2e7fa9(Object value1) {
    return 'Diferencia: $value1';
  }

  @override
  String legacyUi4956298616(Object value1, Object value2) {
    return '$value1 veh. · $value2';
  }

  @override
  String legacyUi120d777276(Object value1) {
    return 'Pagado: $value1';
  }

  @override
  String legacyUi617d0ebe3d(Object value1, Object value2) {
    return '$value1 de $value2 planes';
  }

  @override
  String get legacyUi25422daedb => 'Vehículo sin nombre';

  @override
  String legacyUicbbe928bb9(Object value1) {
    return 'Cobertura anual: $value1';
  }

  @override
  String legacyUiec60ebb81f(Object value1) {
    return 'Servicio del cliente: $value1';
  }

  @override
  String legacyUiced28bc228(Object value1) {
    return 'Créditos de la cuenta: $value1';
  }

  @override
  String get legacyUic1a90693df => 'Seguimiento en tiempo real activo';

  @override
  String legacyUi4bdc33e519(Object value1, Object value2) {
    return '$value1 · $value2 días';
  }

  @override
  String get legacyUi889f282a7d => 'Elegir fecha y hora';

  @override
  String get legacyUi83cbbbc297 => 'Guardar cambios del servicio';

  @override
  String get legacyUi69feaaf8cd => 'Todas las fechas';

  @override
  String get legacyUi0c6c4102d4 => 'Opcional';

  @override
  String legacyUic57882f9c9(Object value1) {
    return 'Estado: $value1';
  }

  @override
  String legacyUiae3c1f8817(Object value1) {
    return '¿Enviar este comando a $value1?';
  }

  @override
  String legacyUic51f739b4e(Object value1) {
    return 'Usuarios asignados ($value1)';
  }

  @override
  String get legacyUibc7819b34f => 'Desconocido';

  @override
  String legacyUi46aece3259(Object value1) {
    return '¿Quitar $value1 de este vehículo?';
  }

  @override
  String legacyUi3d2bb84b75(Object value1, Object value2) {
    return 'Valor en tiempo real: $value1 $value2';
  }

  @override
  String legacyUieb3a3daafa(Object value1) {
    return 'Código: $value1';
  }

  @override
  String legacyUi93aa5178d6(Object value1) {
    return 'Tipo de documento: $value1';
  }

  @override
  String legacyUi0e12da1c5e(Object value1) {
    return 'Archivo: $value1';
  }

  @override
  String legacyUi3ce1585208(Object value1) {
    return 'Vencimiento: $value1';
  }

  @override
  String legacyUiaeafae8a12(Object value1) {
    return 'Visibilidad: $value1';
  }

  @override
  String legacyUi39d7217391(Object value1) {
    return 'Etiquetas: $value1';
  }

  @override
  String legacyUi4439ddf5a2(Object value1) {
    return 'Creado: $value1';
  }

  @override
  String legacyUid5c6adaee3(Object value1) {
    return '¿Quitar $value1 de este conductor?';
  }

  @override
  String get legacyUieb7eb7a819 => 'Elegir archivo';

  @override
  String get legacyUi8f8dd8dbd3 => 'Oculto para el administrador';

  @override
  String get legacyUi65d06317e9 =>
      'Los administradores pueden ver este documento';

  @override
  String get legacyUic0e9577a75 => 'Solo puede verlo el propietario';

  @override
  String legacyUi864cf8bc08(Object value1) {
    return 'Atributos: $value1';
  }

  @override
  String legacyUi90d40c4249(Object value1) {
    return 'Datos sin procesar: $value1';
  }

  @override
  String get legacyUia4d06ed284 => 'Evento del vehículo';

  @override
  String legacyUifba61e1a50(Object value1, Object value2, Object value3,
      Object value4, Object value5, Object value6) {
    return '$value1 • $value2 • enviados $value3 • entregados $value4 • reintento $value5$value6';
  }

  @override
  String legacyUi9c07a085f8(Object value1, Object value2) {
    return '$value1 de $value2 transacciones';
  }

  @override
  String legacyUi26b3b5dfb3(Object value1) {
    return '$value1 Reintentar';
  }

  @override
  String legacyUi05563fda41(Object value1, Object value2, Object value3) {
    return 'Plan: $value1 • $value2 $value3';
  }

  @override
  String legacyUi26400a7353(Object value1, Object value2) {
    return 'Selección: $value1 vehículo$value2';
  }

  @override
  String legacyUi8f4ab245d3(Object value1, Object value2) {
    return 'Total automático: $value1 $value2';
  }

  @override
  String get legacyUi493de0b548 => 'Cotización vencida';

  @override
  String legacyUi78218dbd5f(Object value1, Object value2, Object value3) {
    return '$value1 · $value2 · $value3 días';
  }

  @override
  String legacyUi13e7357d18(Object value1) {
    return 'He recibido $value1';
  }

  @override
  String get legacyUi7e72a446c4 => 'Ocultar filtros de pagos';

  @override
  String get legacyUi8f642c1d28 => 'Mostrar filtros de pagos';

  @override
  String legacyUi184c3f0cbb(Object value1) {
    return 'ID de transacción: $value1';
  }

  @override
  String legacyUi281961b9ee(Object value1) {
    return 'Importe: $value1';
  }

  @override
  String legacyUib40416c0af(Object value1) {
    return 'Tipo de pago: $value1';
  }

  @override
  String legacyUia0d65517a6(Object value1) {
    return 'Método de pago: $value1';
  }

  @override
  String legacyUic2d62e9f71(Object value1) {
    return 'Referencia: $value1';
  }

  @override
  String legacyUib0f627962a(Object value1) {
    return 'Proveedor: $value1';
  }

  @override
  String legacyUie802a1b0a0(Object value1) {
    return 'Referencia del proveedor: $value1';
  }

  @override
  String legacyUi2751887374(Object value1) {
    return 'De: $value1';
  }

  @override
  String legacyUi250106ee83(Object value1) {
    return 'Para: $value1';
  }

  @override
  String legacyUi5ff8e9357b(Object value1) {
    return 'Registrado por: $value1';
  }

  @override
  String legacyUi7565bbdff9(Object value1) {
    return 'Vehículo: $value1';
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
    return 'Código de error: $value1';
  }

  @override
  String legacyUif147c11396(Object value1) {
    return 'Mensaje de error: $value1';
  }

  @override
  String get legacyUic3146cdbec =>
      'Crea una solicitud para iniciar una conversación de soporte.';

  @override
  String legacyUi2cbdc50885(Object value1) {
    return '¿Quitar $value1 de esta cuenta de administrador?';
  }

  @override
  String legacyUi073ab8a05c(Object value1, Object value2) {
    return '$value1 asignados - $value2 disponibles';
  }

  @override
  String legacyUidcc59f9fcf(Object value1) {
    return 'Seleccionar $value1';
  }

  @override
  String get legacyUi7a19b6deae => 'No hay opciones disponibles';

  @override
  String get legacyUif28cfb8eb0 => '1 solicitud de soporte';

  @override
  String legacyUidf08f563b7(Object value1) {
    return 'Archivos opcionales, hasta $value1.';
  }

  @override
  String get legacyUi5f2b4010d1 => '1 pago';

  @override
  String get legacyUi876081608a => 'Renovación — 1 vehículo';

  @override
  String legacyUia034f3f5e5(Object value1) {
    return 'Total estimado: $value1';
  }

  @override
  String legacyUic07d143675(Object value1) {
    return 'Vehículos renovados ($value1)';
  }

  @override
  String legacyUiff384c8aa4(Object value1) {
    return '¿Quitar $value1 de este usuario?';
  }

  @override
  String legacyUicb6d241451(Object value1, Object value2) {
    return '$value1 archivos - $value2 tipos de usuario';
  }

  @override
  String get legacyUif63f04564a => 'Cargando tipos de usuario';

  @override
  String get legacyUi74b1d89d85 => 'Elige un archivo';

  @override
  String get legacyUi62783d600b => 'Se muestra en los documentos del usuario';

  @override
  String get legacyUi38fc177e28 => 'Oculto para el usuario';

  @override
  String legacyUibce346e856(Object value1, Object value2) {
    return '$value1 usuario$value2';
  }

  @override
  String get legacyUi674b652fca => 'Cambiar fechas';

  @override
  String get legacyUi08d0e4f72a => 'Cargando transacciones…';

  @override
  String get legacyUib3a56d64d2 =>
      'Ninguna transacción coincide con estos filtros.';

  @override
  String get legacyUi049ac820da => 'Procesando...';

  @override
  String legacyUie783127bc1(Object value1) {
    return 'Se unió $value1';
  }

  @override
  String legacyUieb587f7802(Object value1) {
    return 'Perfil actualizado $value1';
  }

  @override
  String get legacyUi1dfc507715 =>
      'Las referencias de países y prefijos móviles no están disponibles. Puedes editarlas manualmente.';

  @override
  String get legacyUia7c1498ab2 =>
      'Estás suscrito a las notificaciones de perfil por correo electrónico.';

  @override
  String get legacyUi77653a7db4 =>
      'Suscríbete para recibir novedades del perfil y de la cuenta por correo electrónico.';

  @override
  String get legacyUid3b8add13e => 'Opciones no disponibles.';

  @override
  String legacyUi08b544b680(Object value1) {
    return 'Recorrido: $value1';
  }

  @override
  String legacyUi6c783ae69f(Object value1) {
    return 'Mostrando 10 de las últimas $value1 alertas';
  }

  @override
  String get legacyUi45ef37a941 => 'No se ha proporcionado ningún mensaje.';

  @override
  String get legacyUia2ae39a298 => 'Canal desconocido';

  @override
  String get legacyUiceafde86d6 => 'Enviando';

  @override
  String get legacyUi46cefb25e2 => 'Enviar comando';

  @override
  String legacyUib3d1704245(Object value1) {
    return 'Franja diurna: $value1';
  }

  @override
  String legacyUi735f148a9a(Object value1) {
    return 'tipo: $value1';
  }

  @override
  String legacyUi828a91effc(Object value1, Object value2, Object value3) {
    return '$value1 de $value2 vehículos • $value3 seleccionados';
  }

  @override
  String legacyUia0ebdc2307(Object value1, Object value2, Object value3) {
    return '$value1 visibles • $value2/$value3 cargados';
  }

  @override
  String legacyUi1d483a1343(Object value1) {
    return '¿Quitar $value1 de este subusuario?';
  }

  @override
  String legacyUi02b84d460d(Object value1) {
    return '$value1 disponibles para asignar';
  }

  @override
  String get legacyUi65ad788d45 => 'Matrícula no disponible';

  @override
  String get legacyUi7bb4f2808b =>
      'El subusuario puede acceder a los vehículos asignados';

  @override
  String get legacyUi26b21a0d91 => 'El subusuario está deshabilitado';

  @override
  String legacyUibceb1630f0(Object value1, Object value2) {
    return '$value1 archivos - $value2 tipos de documento';
  }

  @override
  String get legacyUi107b9056eb => 'Cargando tipos de conductor';

  @override
  String legacyUifd7e37cf51(Object value1, Object value2) {
    return '$value1 de $value2 conductores';
  }

  @override
  String legacyUi14b274c7ae(Object value1, Object value2) {
    return '$value1 de $value2 vehículos';
  }

  @override
  String legacyUi79a100acf7(Object value1) {
    return '¿Eliminar $value1?';
  }

  @override
  String legacyUi26875fe2e3(Object value1, Object value2) {
    return '$value1 archivos - $value2 tipos de vehículo';
  }

  @override
  String legacyUi7970bd3e0b(Object value1) {
    return 'No se pudo cargar $value1.';
  }

  @override
  String get legacyUi5eaf2646c3 => 'Cargando tipos de vehículo';

  @override
  String get legacyUi6ca60537ae => 'Se muestra en los documentos del vehículo';

  @override
  String get legacyUi4e3d045a97 => 'Oculto para los usuarios';

  @override
  String get legacyUid3ce77345e => 'Historial del sensor';

  @override
  String legacyUi5aba89cd2f(Object value1) {
    return '$value1 puntos numéricos';
  }

  @override
  String get legacyUie86a33f16a => 'Todas las geocercas';

  @override
  String legacyUi5321a316d0(Object value1) {
    return 'Origen: $value1';
  }

  @override
  String legacyUifabeb88d9c(Object value1) {
    return 'Usar la selección de $value1';
  }

  @override
  String legacyUi343ceded71(Object value1) {
    return 'Eventos por geocerca (las $value1 primeras)';
  }

  @override
  String legacyUide36170209(Object value1) {
    return 'Tipos de alerta (los $value1 primeros)';
  }

  @override
  String legacyUi019e5212ef(Object value1, Object value2) {
    return '$value1 km/h (límite $value2)';
  }

  @override
  String legacyUicaae0add4a(Object value1, Object value2) {
    return '$value1 día$value2 de actividad';
  }

  @override
  String legacyUi7911e1ad0c(Object value1, Object value2) {
    return '$value1 resultado$value2';
  }

  @override
  String legacyUi15b175bbc9(Object value1) {
    return 'Generado a las $value1';
  }

  @override
  String legacyUi92a50db48d(Object value1) {
    return 'Exportar informe de $value1';
  }

  @override
  String legacyUida6472ea1a(Object value1) {
    return 'Se incluirán los $value1 vehículos';
  }

  @override
  String get legacyUib0c379b2f8 => 'Selecciona un grupo de vehículos';

  @override
  String get legacyUi23d6943e8b => 'Seleccionar vehículos';

  @override
  String legacyUi47b7508acb(Object value1) {
    return 'Listo ($value1)';
  }

  @override
  String legacyUid495bed9d8(Object value1) {
    return 'Seleccionar todos los visibles ($value1)';
  }

  @override
  String legacyUi096909f019(Object value1, Object value2) {
    return '$value1 vehículo$value2';
  }

  @override
  String legacyUie003b8a491(Object value1) {
    return 'Máximo $value1 días para este tipo de informe';
  }

  @override
  String legacyUif386fe6e70(Object value1) {
    return 'Borrar ($value1)';
  }

  @override
  String get legacyUi706049c6a9 => 'Selecciona un sensor';

  @override
  String legacyUi2841c7f501(Object value1) {
    return 'No se encontraron informes para «$value1»';
  }

  @override
  String legacyUi8002c1aa36(Object value1) {
    return 'Los horarios usan $value1.';
  }

  @override
  String legacyUieaa190f343(Object value1) {
    return '$value1 habilitados';
  }

  @override
  String legacyUidc179fe07f(Object value1) {
    return 'El límite de velocidad debe ser de al menos 1 $value1.';
  }

  @override
  String legacyUi11003e8471(Object value1) {
    return 'Canales de entrega de $value1';
  }

  @override
  String legacyUidc7454d672(Object value1) {
    return 'Guardado por última vez $value1';
  }

  @override
  String get legacyUi7968beb979 => 'Código -';

  @override
  String legacyUi0528ad37c9(Object value1, Object value2) {
    return '$value1 de $value2 enlaces';
  }

  @override
  String get legacyUiac2a036e38 => 'Aún no hay actividad';

  @override
  String legacyUi3a4361ec75(Object value1) {
    return '«$value1» se eliminará permanentemente.';
  }

  @override
  String get legacyUi50a9e13fce => 'Geocerca sin nombre';

  @override
  String legacyUi760cb5d683(Object value1, Object value2) {
    return '$value1 punto$value2';
  }

  @override
  String legacyUifa6e784713(Object value1) {
    return 'Eliminar n.º $value1';
  }

  @override
  String legacyUi27a25269f5(Object value1) {
    return 'Ajuste preciso ($value1 m)';
  }

  @override
  String get legacyUi39706b5a17 => 'Aún no hay geometría';

  @override
  String get legacyUi1bf6cb6c45 => 'Geometría lista';

  @override
  String get legacyUi5d437ca98b => 'Se activarán eventos para esta geocerca.';

  @override
  String get legacyUi6d8b4724c6 => 'La geocerca está en pausa.';

  @override
  String get legacyUi7e9f5c3026 => 'Dibuja al menos 2 puntos en el mapa.';

  @override
  String get legacyUi28134edb87 => 'Editar en el mapa';

  @override
  String get legacyUi0f873fbc31 => 'Dibujar en el mapa';

  @override
  String legacyUi48f6c8c8ac(Object value1) {
    return '$value1 m';
  }

  @override
  String legacyUicde59da67c(Object value1) {
    return '$value1 min';
  }

  @override
  String get legacyUi4bd1e22ea7 => 'Ruta sin nombre';

  @override
  String legacyUi198f442dfb(Object value1) {
    return 'Vértice $value1';
  }

  @override
  String legacyUibae08b3767(Object value1, Object value2) {
    return 'Fila $value1: $value2';
  }

  @override
  String get legacyUi93039e609d => 'Sin definir';

  @override
  String get legacyUid33a96e366 => 'Elegir en el mapa';

  @override
  String get legacyUiecd575d434 =>
      'Visible en el mapa en tiempo real y en las alertas de proximidad.';

  @override
  String get legacyUi92a172ce15 =>
      'Oculto en las alertas; permanece en la lista.';

  @override
  String get legacyUi8019307fe5 => 'Punto de interés sin nombre';

  @override
  String get legacyUid14e0c02a9 => 'Seguimiento en tiempo real disponible';

  @override
  String legacyUic814ea2b6e(Object value1) {
    return 'Inicio del servicio: $value1';
  }

  @override
  String legacyUic926abedfd(Object value1) {
    return 'Vencimiento del servicio del cliente: $value1';
  }

  @override
  String legacyUiae0052da76(Object value1) {
    return 'Vencimiento de la cobertura del proveedor: $value1';
  }

  @override
  String legacyUi633ec01c21(Object value1, Object value2) {
    return '$value1 • $value2 días';
  }

  @override
  String get legacyUicf765512cc => 'Enviando…';

  @override
  String get legacyUi50756f98a3 => 'Solicitar renovación';

  @override
  String legacyUid52adacef9(Object value1) {
    return 'Solicitud n.º $value1';
  }

  @override
  String get legacyUicfeb791a76 => 'Solicitud vencida';

  @override
  String legacyUif0d8958371(Object value1, Object value2, Object value3,
      Object value4, Object value5) {
    return '$value1\n$value2 • $value3 días\n$value4 $value5\n\nTu administrador debe confirmar el pago antes de ampliar el servicio.';
  }

  @override
  String get legacyUifdb17036d5 => 'Usuario de OpenVTS';

  @override
  String legacyUif7e83b3f19(Object value1) {
    return 'Restablecer valor predeterminado ($value1)';
  }

  @override
  String legacyUi54e519da7f(Object value1) {
    return 'Error: $value1';
  }

  @override
  String get legacyUi7eb29d3565 => 'Fecha y hora';

  @override
  String get legacyUib1deb07e61 => 'Abrir geocerca';

  @override
  String get legacyUi1dce4bf43b => 'Abrir punto de interés';

  @override
  String get legacyUi4a0d050737 => 'Abrir ruta';

  @override
  String get legacyUib6bd42e4e7 => 'En curso';

  @override
  String get legacyUi91edf8aff9 => 'En un viaje';

  @override
  String get legacyUi20c7c5522f => 'Listo';

  @override
  String get legacyUi0a2b58e839 => 'Sin asignación';

  @override
  String get legacyUi6cf3d41f08 => 'Todos los viajes';

  @override
  String get legacyUif7a616a336 => 'Acceso bloqueado';

  @override
  String get legacyUiac7b5dd3a8 => 'Destinatario no disponible';

  @override
  String get legacyUi936d2e8552 => 'Problema del vehículo';

  @override
  String get legacyUi51cea59031 => 'Problema de la ruta';

  @override
  String get legacyUia972b55b1a =>
      'Describe el problema para el responsable de asignaciones.';

  @override
  String get legacyUie0cdc02f99 => 'Formato de 12 horas';

  @override
  String get legacyUif910251f7c => 'Formato de 24 horas';

  @override
  String get legacyUi34ce147724 => 'De izquierda a derecha';

  @override
  String get legacyUida502a644e => 'De derecha a izquierda';

  @override
  String get legacyUiec45717e13 =>
      'Contacta con el responsable de asignaciones para obtener más información.';

  @override
  String get legacyUi8a783eb3d6 => 'Asignación confirmada.';

  @override
  String get legacyUi00e1e19595 => 'Iniciar viaje';

  @override
  String get legacyUi0015b1903d =>
      'Los viajes suelen iniciarse con la telemetría del vehículo. Utiliza esta alternativa manual solo al comenzar el viaje.';

  @override
  String get legacyUib20bd98ae2 => 'Añadir observación';

  @override
  String get legacyUi42477e82cf => 'No se pudo abrir la navegación.';

  @override
  String get legacyUiea0bd6ff3d => 'Completar parada';

  @override
  String get legacyUi3d93beaa39 =>
      'Selecciona un archivo no vacío de hasta 5 MB.';

  @override
  String get legacyUid2085cce0d => 'Selecciona un archivo para subir.';

  @override
  String get legacyUid0193e6956 => 'Selecciona un tipo de documento.';

  @override
  String get legacyUif378218081 => 'Introduce al menos 2 caracteres.';

  @override
  String get legacyUi63f72dce85 => 'Seleccionar archivo';

  @override
  String get legacyUi1255774559 => 'Asignaciones de hoy';

  @override
  String get legacyUi3528465759 => 'Viajes completados';

  @override
  String get legacyUi28793a4155 => 'Paradas completadas';

  @override
  String get legacyUi1683af6ce8 => 'Paradas pendientes';

  @override
  String mobilePluralTrips(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count viajes',
      one: '$count viaje',
    );
    return '$_temp0';
  }

  @override
  String mobilePluralBlockedVehicles(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vehículos bloqueados excluidos.',
      one: '$count vehículo bloqueado excluido.',
    );
    return '$_temp0';
  }

  @override
  String mobilePluralSelectedVehicles(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vehículos seleccionados',
      one: '$count vehículo seleccionado',
    );
    return '$_temp0';
  }

  @override
  String mobilePluralUsers(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count usuarios',
      one: '$count usuario',
    );
    return '$_temp0';
  }

  @override
  String mobilePluralActiveDays(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count días activos',
      one: '$count día activo',
    );
    return '$_temp0';
  }

  @override
  String mobilePluralResults(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count resultados',
      one: '$count resultado',
    );
    return '$_temp0';
  }

  @override
  String mobilePluralVehicles(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vehículos',
      one: '$count vehículo',
    );
    return '$_temp0';
  }

  @override
  String mobilePluralPoints(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count puntos',
      one: '$count punto',
    );
    return '$_temp0';
  }

  @override
  String get relativeJustNow => 'ahora';

  @override
  String relativeMinutesAgo(int count) {
    return 'hace $count min';
  }

  @override
  String relativeHoursAgo(int count) {
    return 'hace $count h';
  }

  @override
  String relativeDaysAgo(int count) {
    return 'hace $count d';
  }

  @override
  String get relativeYesterday => 'ayer';

  @override
  String savingChangesForTab(String tab) {
    return 'Guardando cambios de $tab…';
  }

  @override
  String unsavedChangesForTab(String tab) {
    return 'Tienes cambios sin guardar en $tab.';
  }

  @override
  String get saving => 'Guardando…';

  @override
  String validationRequired(String field) {
    return '$field es obligatorio';
  }

  @override
  String validationAscii(String field) {
    return '$field debe contener solo caracteres ASCII';
  }

  @override
  String validationMinCharacters(String field, int count) {
    return '$field debe tener al menos $count caracteres';
  }

  @override
  String validationMaxCharacters(String field, int count) {
    return '$field debe tener como máximo $count caracteres';
  }

  @override
  String validationMinDigits(String field, int count) {
    return '$field debe tener al menos $count dígitos';
  }

  @override
  String validationMaxDigits(String field, int count) {
    return '$field debe tener como máximo $count dígitos';
  }

  @override
  String validationNumeric(String field) {
    return '$field debe ser numérico';
  }

  @override
  String validationMinimumCharacters(int count) {
    return 'Mínimo $count caracteres';
  }

  @override
  String get validationValidEmail => 'Introduce un correo electrónico válido';

  @override
  String get validationValidNumber => 'Introduce un número válido';

  @override
  String get validationNonnegativeCredits =>
      'Los créditos no pueden ser negativos';

  @override
  String get validationConfirmPassword => 'Confirma la contraseña';

  @override
  String get validationPasswordsMismatch => 'Las contraseñas no coinciden';

  @override
  String get validationStandardVin =>
      'El VIN debe tener 17 caracteres alfanuméricos, excepto I, O y Q';

  @override
  String get validationVinAlphanumeric =>
      'El VIN solo puede contener letras y números';

  @override
  String get validationThisField => 'Este campo';

  @override
  String get validationFieldSimNumber => 'Número de SIM';

  @override
  String get mobileDataBackup => 'Copia de seguridad de datos';

  @override
  String get mobileEffectiveRetention => 'Retención efectiva';

  @override
  String get mobileAdministratorLimit => 'Límite del administrador';

  @override
  String get mobilePolicySource => 'Origen de la política';

  @override
  String mobileUseAdministratorPolicy(String value1) {
    return 'Usar la política del administrador ($value1)';
  }

  @override
  String get mobileRetentionCleanupNotice =>
      'La limpieza programada elimina la telemetría histórica anterior al período de retención. Aumentar la retención no restaura los datos eliminados.';

  @override
  String mobileRetentionLimitError(String value1) {
    return 'El período de retención no puede superar los $value1 días.';
  }

  @override
  String get mobileRetentionLoadError =>
      'No se pudo cargar la retención de datos';

  @override
  String get mobileRetentionSaveError =>
      'No se pudo guardar la retención de datos';

  @override
  String get mobileRetentionSaved => 'Retención de datos actualizada';

  @override
  String get mobileRetentionUnsupported =>
      'El servidor devolvió una política de retención no compatible. La edición está deshabilitada.';

  @override
  String get mobileDiscardDetailChanges =>
      'Se perderán los cambios. ¿Continuar?';

  @override
  String get mobileLiveTrackingReconnecting =>
      'Reconectando el seguimiento en directo…';

  @override
  String get mobileLastConnection => 'Última conexión';

  @override
  String get mobileTeamLoadError => 'No se pudo cargar el miembro del equipo.';

  @override
  String get mobilePermissionsLoadError =>
      'No se pudieron cargar los permisos.';

  @override
  String get mobileActivityLoadError => 'No se pudo cargar la actividad.';

  @override
  String get mobilePermissionsRetryError =>
      'No se pudieron cargar o guardar los permisos. Inténtalo de nuevo.';

  @override
  String get mobilePermissionMaps => 'Mapas';

  @override
  String get mobilePermissionLandmarks => 'Lugares de referencia';

  @override
  String get mobilePermissionShareTracking => 'Compartir enlace de seguimiento';

  @override
  String get mobilePrivacyPolicyLink => 'Política de privacidad';

  @override
  String get mobilePageLinkError =>
      'No se pudo abrir esta página. Inténtalo de nuevo.';
}
