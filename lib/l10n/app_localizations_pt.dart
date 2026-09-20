// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get date => 'Data';

  @override
  String get time => 'Hora';

  @override
  String get direction => 'Direção';

  @override
  String get units => 'Unidades';

  @override
  String get appTitle => 'OpenVTS';

  @override
  String get settings => 'Configurações';

  @override
  String get localization => 'Localização';

  @override
  String get language => 'Idioma';

  @override
  String get theme => 'Tema';

  @override
  String get dateFormat => 'Formato de Data';

  @override
  String get timeFormat => 'Formato de Hora';

  @override
  String get timezone => 'Fuso Horário';

  @override
  String get use24Hour => 'Hora em 24 Horas';

  @override
  String get save => 'Salvar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get edit => 'Editar';

  @override
  String get search => 'Pesquisar';

  @override
  String get delete => 'Excluir';

  @override
  String get reset => 'Redefinir';

  @override
  String get close => 'Fechar';

  @override
  String get back => 'Voltar';

  @override
  String get next => 'Próximo';

  @override
  String get prev => 'Anterior';

  @override
  String get loading => 'Carregando...';

  @override
  String get error => 'Erro';

  @override
  String get success => 'Sucesso';

  @override
  String get warning => 'Aviso';

  @override
  String get light => 'Claro';

  @override
  String get dark => 'Escuro';

  @override
  String get system => 'Sistema';

  @override
  String get en => 'Inglês';

  @override
  String get hi => 'Hindi';

  @override
  String get ar => 'Árabe';

  @override
  String get es => 'Espanhol';

  @override
  String get fr => 'Francês';

  @override
  String get pt => 'Português';

  @override
  String get profile => 'Perfil';

  @override
  String get logout => 'Sair';

  @override
  String get login => 'Entrar';

  @override
  String get register => 'Registrar';

  @override
  String get administrators => 'Administradores';

  @override
  String get payments => 'Pagamentos';

  @override
  String get support => 'Suporte';

  @override
  String get tickets => 'Tickets';

  @override
  String get home => 'Início';

  @override
  String get dashboard => 'Painel';

  @override
  String get keepEditing => 'Continuar Editando';

  @override
  String get discardChanges => 'Descartar Alterações';

  @override
  String get unsavedChanges => 'Alterações não salvas';

  @override
  String get refresh => 'Atualizar';

  @override
  String get selectLanguage => 'Selecionar Idioma';

  @override
  String get selectTheme => 'Selecionar Tema';

  @override
  String get selectDateFormat => 'Selecionar Formato de Data';

  @override
  String get selectTimeFormat => 'Selecionar Formato de Hora';

  @override
  String get selectTimezone => 'Selecionar Fuso Horário';

  @override
  String previewDate(String date) {
    return 'Visualizar: $date';
  }

  @override
  String previewTime(String time) {
    return 'Visualizar: $time';
  }

  @override
  String get settingsUpdated => 'Configurações atualizadas';

  @override
  String get profileUpdated => 'Perfil atualizado';

  @override
  String get localizationUpdated => 'Configurações de localização atualizadas';

  @override
  String get failedToUpdate => 'Falha ao atualizar. Tente novamente.';

  @override
  String get noData => 'Nenhum dado disponível';

  @override
  String get retry => 'Tentar Novamente';

  @override
  String get confirmDiscard => 'Descartar alterações não salvas?';

  @override
  String confirmDiscardMessage(String tab) {
    return '$tab tem edições não salvas. Descartar perderá essas alterações.';
  }

  @override
  String get reportsTitle => 'Relatórios';

  @override
  String get reportsSearchHint => 'Pesquisar relatórios…';

  @override
  String reportsNoResultsFor(Object query) {
    return 'Nenhum relatório encontrado para \"$query\"';
  }

  @override
  String get reportsGenerate => 'Gerar relatório';

  @override
  String get reportsGenerating => 'Gerando…';

  @override
  String get reportsReset => 'Redefinir';

  @override
  String get reportsConfigureHint =>
      'Configure o relatório acima e toque em Gerar.';

  @override
  String get reportsNoResults =>
      'Nenhum resultado para os filtros selecionados.';

  @override
  String get reportsErrorRetry => 'Tentar novamente';

  @override
  String reportsRowCount(Object count) {
    return '$count linhas carregadas';
  }

  @override
  String get reportsLoadMore => 'Carregar mais';

  @override
  String get reportsLoadingMore => 'Loading more…';

  @override
  String reportsGeneratedAt(Object time) {
    return 'Gerado $time';
  }

  @override
  String get reportsExportTitle => 'Exportar relatório';

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
  String get reportsScopeAll => 'Todos os veículos';

  @override
  String get reportsScopeSingle => 'Um veículo';

  @override
  String get reportsScopeMultiple => 'Vários veículos';

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
  String get reportsCatalogDistanceTitle => 'Distância';

  @override
  String get reportsCatalogDistanceDesc =>
      'Total distance driven per vehicle per day with engine hours and odometer readings.';

  @override
  String get reportsCatalogDrivenTitle => 'Dias dirigidos';

  @override
  String get reportsCatalogDrivenDesc =>
      'Daily distance matrix — which vehicles moved on which days and how far.';

  @override
  String get reportsCatalogDetailsTitle => 'Detalhes do veículo';

  @override
  String get reportsCatalogDetailsDesc =>
      'Fleet summary: total distance, engine hours, active days, last known location per vehicle.';

  @override
  String get reportsCatalogOverspeedTitle => 'Excesso de velocidade';

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
  String get reportsCatalogLogsTitle => 'Logs do dispositivo';

  @override
  String get reportsCatalogLogsDesc =>
      'Raw communication logs from vehicle devices grouped by category and level.';

  @override
  String get reportsCatalogTimelineTitle => 'Linha do tempo';

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
  String get users => 'Usuários';

  @override
  String get vehicles => 'Veículos';

  @override
  String get drivers => 'Motoristas';

  @override
  String get team => 'Equipe';

  @override
  String get inventory => 'Inventário';

  @override
  String get map => 'Mapa';

  @override
  String get transactions => 'Transações';

  @override
  String get calendar => 'Calendário';

  @override
  String get logs => 'Registros';

  @override
  String get plans => 'Planos';

  @override
  String get roles => 'Funções';

  @override
  String get smtp => 'SMTP';

  @override
  String get settingsDescription =>
      'Gerencie o perfil, a localização e as configurações SMTP.';

  @override
  String get localizationDescription =>
      'Idioma, data/hora, unidades e foco padrão do mapa.';

  @override
  String get whiteLabel => 'Marca Branca';

  @override
  String get saveChanges => 'Salvar alterações';

  @override
  String get textDirection => 'Direção do texto';

  @override
  String get languageAndDirection => 'Idioma e Direção';

  @override
  String get languageAndDirectionSubtitle =>
      'Idioma da interface e direção do texto.';

  @override
  String get dateAndTime => 'Data e Hora';

  @override
  String get dateAndTimeSubtitle =>
      'Formato de data, estilo de hora e fuso horário.';

  @override
  String get unitsAndTheme => 'Unidades e Tema';

  @override
  String get unitsAndThemeSubtitle =>
      'Unidades de distância e aparência do aplicativo.';

  @override
  String get defaultMapFocus => 'Foco Padrão do Mapa';

  @override
  String get defaultMapFocusSubtitle =>
      'Centro inicial do mapa e nível de zoom.';

  @override
  String get couldNotLoadLocalization =>
      'Não foi possível carregar a localização.';

  @override
  String get localizationSaved => 'Localização salva';

  @override
  String get quickPresets => 'Predefinições rápidas';

  @override
  String get settingsHeaderSubtitle =>
      'Perfil, marca, correio, localização e preferências de plataforma.';

  @override
  String get localizationPreview => 'Prévia de localização';

  @override
  String get latitude => 'Latitude';

  @override
  String get longitude => 'Longitude';

  @override
  String get mapZoom => 'Zoom do mapa';

  @override
  String get mapCenter => 'Centro do mapa';

  @override
  String get kilometers => 'Quilômetros';

  @override
  String get miles => 'Milhas';

  @override
  String get latitudeRequired => 'A latitude é obrigatória.';

  @override
  String get validLatitude => 'Insira uma latitude válida.';

  @override
  String get latitudeRange => 'A latitude deve estar entre -90 e 90.';

  @override
  String get longitudeRequired => 'A longitude é obrigatória.';

  @override
  String get validLongitude => 'Insira uma longitude válida.';

  @override
  String get longitudeRange => 'A longitude deve estar entre -180 e 180.';

  @override
  String get mapZoomRequired => 'O zoom do mapa é obrigatório.';

  @override
  String get validMapZoom => 'Insira um nível de zoom válido.';

  @override
  String get mapZoomRange => 'O zoom do mapa deve estar entre 1 e 22.';

  @override
  String get unsupportedLanguageFallback =>
      'O idioma salvo não está disponível no aplicativo. Selecione um idioma compatível; o inglês será usado por enquanto.';
}
