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
  String get reportsLoadingMore => 'Carregando mais…';

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
  String get reportsScopeSelectVehicle => 'Selecionar veículo';

  @override
  String get reportsScopeSelectVehicles => 'Selecionar veículos';

  @override
  String get reportsScopeSelectGroup => 'Selecionar grupo';

  @override
  String get reportsScopeSearchHint => 'Pesquisar por nome, placa ou IMEI…';

  @override
  String get reportsScopeSelectAll => 'Selecionar todos os visíveis';

  @override
  String get reportsScopeDone => 'Concluído';

  @override
  String reportsScopeNVehiclesSelected(Object count) {
    return '$count veículos selecionados';
  }

  @override
  String get reportsDateStart => 'Data de início';

  @override
  String get reportsDateEnd => 'Data de término';

  @override
  String get reportsDateFrom => 'Início';

  @override
  String get reportsDateTo => 'Fim';

  @override
  String reportsDateMaxDays(Object days) {
    return 'Máximo de $days dias para este tipo de relatório';
  }

  @override
  String get reportsValidationScopeRequired =>
      'Selecione pelo menos um veículo.';

  @override
  String get reportsValidationStartRequired =>
      'A data de início é obrigatória.';

  @override
  String get reportsValidationEndRequired => 'A data de término é obrigatória.';

  @override
  String get reportsValidationStartBeforeEnd =>
      'O início deve ser anterior ao fim.';

  @override
  String reportsValidationMaxDays(Object days) {
    return 'O período excede o limite de $days dias deste relatório.';
  }

  @override
  String get reportsValidationSensorVehicleRequired =>
      'Selecione um veículo para o relatório do sensor.';

  @override
  String get reportsValidationSensorRequired => 'Selecione um sensor.';

  @override
  String get reportsValidationTimelineStateRequired =>
      'Selecione pelo menos um estado (em movimento ou parado).';

  @override
  String get reportsFilterSpeedLimit => 'Limite de velocidade (km/h)';

  @override
  String get reportsFilterSpeedCustom => 'Limite personalizado…';

  @override
  String get reportsFilterGeofenceHint => 'Pesquisar cercas virtuais…';

  @override
  String get reportsFilterGeofenceAllNote =>
      'Sem seleção, todas as cercas virtuais são incluídas.';

  @override
  String get reportsFilterAlertType => 'Tipo de alerta';

  @override
  String get reportsFilterAlertSeverity => 'Gravidade';

  @override
  String get reportsFilterAlertAck => 'Confirmação';

  @override
  String get reportsFilterAlertAckAll => 'Todos';

  @override
  String get reportsFilterAlertAckAcknowledged => 'Confirmado';

  @override
  String get reportsFilterAlertAckUnacknowledged => 'Não confirmado';

  @override
  String get reportsFilterLogsVehicle => 'Veículo';

  @override
  String get reportsFilterLogsCategory => 'Categoria';

  @override
  String get reportsFilterLogsLevel => 'Nível';

  @override
  String get reportsFilterTimelineRunning => 'Em movimento';

  @override
  String get reportsFilterTimelineStopped => 'Parado';

  @override
  String get reportsFilterSensorVehicle => 'Veículo';

  @override
  String get reportsFilterSensorSensor => 'Sensor';

  @override
  String get reportsCatalogDistanceTitle => 'Distância';

  @override
  String get reportsCatalogDistanceDesc =>
      'Distância diária por veículo, horas do motor e leituras do odômetro.';

  @override
  String get reportsCatalogDrivenTitle => 'Dias dirigidos';

  @override
  String get reportsCatalogDrivenDesc =>
      'Tabela de distâncias diárias: quais veículos se moveram, em quais dias e quanto.';

  @override
  String get reportsCatalogDetailsTitle => 'Detalhes do veículo';

  @override
  String get reportsCatalogDetailsDesc =>
      'Resumo da frota: distância, horas do motor, dias ativos e última localização por veículo.';

  @override
  String get reportsCatalogOverspeedTitle => 'Excesso de velocidade';

  @override
  String get reportsCatalogOverspeedDesc =>
      'Eventos de excesso de velocidade com velocidade, limite, excesso, duração e localização.';

  @override
  String get reportsCatalogGeofenceTitle => 'Geocerca';

  @override
  String get reportsCatalogGeofenceDesc =>
      'Entradas e saídas das cercas selecionadas, com horários e tempo de permanência.';

  @override
  String get reportsCatalogAlertsTitle => 'Alertas';

  @override
  String get reportsCatalogAlertsDesc =>
      'Alertas por tipo e gravidade, com estado de confirmação.';

  @override
  String get reportsCatalogSensorTitle => 'Sensor';

  @override
  String get reportsCatalogSensorDesc =>
      'Leituras ao longo do tempo de um sensor em um veículo, com gráfico.';

  @override
  String get reportsCatalogLogsTitle => 'Logs do dispositivo';

  @override
  String get reportsCatalogLogsDesc =>
      'Registros brutos dos dispositivos dos veículos, por categoria e nível.';

  @override
  String get reportsCatalogTimelineTitle => 'Linha do tempo';

  @override
  String get reportsCatalogTimelineDesc =>
      'Trechos em movimento e parados, com duração, distância e trajeto GPS.';

  @override
  String get reportsKpiTotalDistance => 'Distância total';

  @override
  String get reportsKpiEngineHours => 'Horas do motor';

  @override
  String get reportsKpiActiveVehicles => 'Veículos ativos';

  @override
  String get reportsKpiAvgDistance => 'Distância média';

  @override
  String get reportsKpiVehiclesDriven => 'Veículos em circulação';

  @override
  String get reportsKpiAvgDaily => 'Média diária';

  @override
  String get reportsKpiPeakDay => 'Dia de maior atividade';

  @override
  String get reportsKpiViolations => 'Infrações';

  @override
  String get reportsKpiAffectedVehicles => 'Veículos afetados';

  @override
  String get reportsKpiHighestSpeed => 'Velocidade máxima';

  @override
  String get reportsKpiTotalDuration => 'Duração total';

  @override
  String get reportsKpiTotalEvents => 'Total de eventos';

  @override
  String get reportsKpiEntries => 'Entradas';

  @override
  String get reportsKpiExits => 'Saídas';

  @override
  String get reportsKpiTotalAlerts => 'Total de alertas';

  @override
  String get reportsKpiCritical => 'Crítico';

  @override
  String get reportsKpiAcknowledged => 'Confirmados';

  @override
  String get reportsKpiReadings => 'Leituras';

  @override
  String get reportsKpiOnEvents => 'Eventos de ativação';

  @override
  String get reportsKpiOffEvents => 'Eventos de desativação';

  @override
  String get reportsKpiTotalLogs => 'Total de registros';

  @override
  String get reportsKpiRunningDuration => 'Tempo em movimento';

  @override
  String get reportsKpiStoppedDuration => 'Tempo parado';

  @override
  String get reportsKpiMovementDistance => 'Distância percorrida';

  @override
  String get reportsKpiStopCount => 'Número de paradas';

  @override
  String get reportsDetailTitle => 'Detalhes da linha';

  @override
  String get reportsDetailRawPayload => 'Dados brutos';

  @override
  String get reportsDetailCopied => 'Copiado';

  @override
  String get reportsDetailCopy => 'Copiar';

  @override
  String get reportsDetailTruncated =>
      'Dados reduzidos para exibição. Exporte para obter os dados completos.';

  @override
  String get reportsRowDetailsViewMap => 'Ver mapa';

  @override
  String get reportsRowDetailsHideMap => 'Ocultar mapa';

  @override
  String get reportsRowDetailsNoGps => 'Não há dados GPS para este trecho.';

  @override
  String reportsWarningBanner(Object message) {
    return 'Aviso: $message';
  }

  @override
  String reportsSourceLabel(Object source) {
    return 'Fonte: $source';
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

  @override
  String homeWorkspace(Object role) {
    return 'Área de trabalho de $role';
  }

  @override
  String get homeAccessUnavailable =>
      'Não foi possível atualizar o acesso. Puxe para baixo para tentar novamente.';

  @override
  String get homeCopyright => '© 2026 Open VTS Todos os direitos reservados.';

  @override
  String get lightMode => 'Modo claro';

  @override
  String get darkMode => 'Modo escuro';

  @override
  String get landmarksStudio => 'Gestão de locais';

  @override
  String get trackLinks => 'Links de rastreamento';

  @override
  String get messages => 'Mensagens';

  @override
  String get accounts => 'Contas';

  @override
  String get notifications => 'Notificações';

  @override
  String get operations => 'Operações';

  @override
  String get server => 'Servidor';

  @override
  String get trips => 'Viagens';

  @override
  String get documents => 'Documentos';

  @override
  String get userRole => 'Usuário';

  @override
  String get subuserRole => 'Subusuário';

  @override
  String get driverRole => 'Motorista';

  @override
  String get superadminRole => 'Superadministrador';

  @override
  String get demoReadOnly => 'Demonstração • Somente leitura';

  @override
  String get security => 'Segurança';

  @override
  String get routeBuilderCreate => 'Criar rota';

  @override
  String get routeBuilderEdit => 'Editar rota';

  @override
  String get routeBuilderName => 'Nome da rota';

  @override
  String get routeBuilderNameHint => 'Por exemplo, entregas da manhã';

  @override
  String get routeBuilderNameError =>
      'Insira um nome com pelo menos 2 caracteres.';

  @override
  String get routeBuilderStops => 'Paradas';

  @override
  String get routeBuilderAddStop => 'Adicionar parada';

  @override
  String get routeBuilderEditStop => 'Editar parada';

  @override
  String get routeBuilderStopName => 'Nome da parada';

  @override
  String get routeBuilderStopNameError =>
      'Insira um nome entre 1 e 160 caracteres.';

  @override
  String get routeBuilderAddress => 'Endereço (opcional)';

  @override
  String get routeBuilderCoordinates => 'Coordenadas';

  @override
  String get routeBuilderLatitude => 'Latitude';

  @override
  String get routeBuilderLongitude => 'Longitude';

  @override
  String get routeBuilderCoordinateError =>
      'Insira latitude válida (−90 a 90) e longitude válida (−180 a 180).';

  @override
  String get routeBuilderMap => 'Escolher no mapa';

  @override
  String get routeBuilderMapHint =>
      'Toque no mapa para escolher a localização da parada.';

  @override
  String get routeBuilderUseLocation => 'Usar localização';

  @override
  String get routeBuilderPoi => 'Ponto de interesse';

  @override
  String get routeBuilderGeofence => 'Cerca virtual';

  @override
  String get routeBuilderLandmarkSearch => 'Pesquisar locais salvos';

  @override
  String get routeBuilderNoLandmarks =>
      'Nenhum local correspondente com coordenadas válidas.';

  @override
  String get routeBuilderLandmarkError =>
      'Não foi possível carregar os locais. Tente novamente.';

  @override
  String get routeBuilderStopLimit =>
      'Uma rota pode ter até 100 paradas, incluindo o retorno.';

  @override
  String get routeBuilderMinimumStops =>
      'Adicione pelo menos 2 paradas distintas.';

  @override
  String get routeBuilderRoundTrip => 'Voltar ao início';

  @override
  String get routeBuilderRoundTripHint =>
      'Adicione o ponto inicial como destino final.';

  @override
  String get routeBuilderOptimize => 'Otimizar ordem';

  @override
  String get routeBuilderOptimizeHint =>
      'Reordena as paradas pela distância geográfica, mantendo início e destino. A distância rodoviária é calculada separadamente.';

  @override
  String get routeBuilderRoadPath => 'Visualizar trajeto rodoviário';

  @override
  String get routeBuilderRouting => 'Calculando rota rodoviária…';

  @override
  String get routeBuilderRoutingError =>
      'Nenhuma rota rodoviária disponível. Verifique as paradas ou a conexão e tente novamente.';

  @override
  String get routeBuilderReady => 'Rota rodoviária pronta';

  @override
  String get routeBuilderChanged =>
      'As paradas mudaram. Visualize a nova rota antes de salvar.';

  @override
  String get routeBuilderSaveError =>
      'Não foi possível salvar a rota. Tente novamente.';

  @override
  String get routeBuilderAccessDenied =>
      'Você não tem permissão para criar ou editar rotas.';

  @override
  String get routeBuilderOrigin => 'Início';

  @override
  String get routeBuilderDestination => 'Destino';

  @override
  String get routeBuilderWaypoint => 'Parada';

  @override
  String get routeBuilderShapePoint => 'Traçado da rota';

  @override
  String get routeBuilderMoveUp => 'Mover para antes';

  @override
  String get routeBuilderMoveDown => 'Mover para depois';

  @override
  String get routeBuilderRemove => 'Remover parada';

  @override
  String get routeBuilderNoStops =>
      'Adicione início e destino, depois as paradas intermediárias.';

  @override
  String get routeBuilderSavedGeometry => 'Trajeto salvo';

  @override
  String get routeBuilderEditingLoadError =>
      'Não foi possível carregar a rota completa. Volte e tente novamente.';

  @override
  String get routeBuilderDiscardTitle => 'Descartar alterações da rota?';

  @override
  String get routeBuilderDiscardMessage =>
      'As alterações não salvas serão perdidas.';

  @override
  String get routeBuilderDiscard => 'Descartar';

  @override
  String get routeBuilderKeepEditing => 'Continuar editando';

  @override
  String get routeBuilderClose => 'Fechar';

  @override
  String get routeBuilderRetry => 'Tentar novamente';

  @override
  String get routeBuilderMapAttribution =>
      '© Colaboradores do OpenStreetMap · Rotas: OSRM';

  @override
  String get routeBuilderRouteDetails => 'Detalhes da rota';

  @override
  String get routeBuilderMinutes => 'min';

  @override
  String get routeBuilderDistanceUnit => 'km';

  @override
  String get routeBuilderChooseSource => 'Adicionar parada a partir de';

  @override
  String get routeBuilderLandmarksPermission =>
      'Os locais salvos exigem a permissão de Locais.';

  @override
  String get routeBuilderShapeHint =>
      'Os pontos de traçado guiam o caminho; não são paradas de entrega. A otimização os remove.';

  @override
  String get routeBuilderGeofenceHint =>
      'Usa o centro da cerca virtual. Confirme que é acessível por estrada.';

  @override
  String selectField(Object field) {
    return 'Selecionar $field';
  }

  @override
  String searchField(Object field) {
    return 'Pesquisar $field';
  }

  @override
  String noMatchingField(Object field) {
    return 'Nenhuma correspondência em $field';
  }

  @override
  String fieldRequired(Object field) {
    return '$field é obrigatório.';
  }

  @override
  String get clearSelection => 'Limpar';

  @override
  String get clearSearch => 'Limpar pesquisa';

  @override
  String get noResults => 'Nenhum resultado';

  @override
  String get select => 'Selecionar';

  @override
  String get unableToLoad => 'Não foi possível carregar';

  @override
  String get mobileApiToken => 'Token de API';

  @override
  String get mobileTokenOnce =>
      'Este token é exibido apenas uma vez. Guarde-o com segurança; quem o possuir poderá usar as permissões de API selecionadas.';

  @override
  String get mobileSaveRecovery => 'Salve seus códigos de recuperação';

  @override
  String get mobileRecoveryHelp =>
      'Cada código funciona uma vez se você perder o autenticador. Eles substituem os anteriores. Guarde-os em local seguro.';

  @override
  String get mobileCopiedSecurely => 'Copiado. Guarde com segurança.';

  @override
  String get mobileSavedSecurely => 'Salvei com segurança';

  @override
  String get mobileDone => 'Concluído';

  @override
  String get mobileRevokeTokenQuestion => 'Revogar token de API?';

  @override
  String mobileTokenStops(Object name) {
    return '$name deixará de funcionar imediatamente.';
  }

  @override
  String get mobileRevoke => 'Revogar';

  @override
  String get mobileMfa => 'Autenticação multifator';

  @override
  String get mobileMfaOn => 'MFA ativada';

  @override
  String get mobileMfaOff => 'MFA desativada';

  @override
  String get mobileMfaHelp =>
      'Proteja o acesso com seu aplicativo autenticador.';

  @override
  String get mobileSecuritySessions =>
      'Alterações de segurança encerram outras sessões e invalidam os tokens de API existentes.';

  @override
  String mobileAddedDate(Object date) {
    return 'Adicionado em $date';
  }

  @override
  String get mobileRemoveAuthenticator => 'Remover autenticador';

  @override
  String get mobileAddAuthenticator => 'Adicionar autenticador';

  @override
  String get mobileSetupMfa => 'Configurar MFA';

  @override
  String mobileRecoveryRemaining(Object count) {
    return '$count códigos de recuperação não utilizados';
  }

  @override
  String get mobileReplaceRecovery => 'Substituir códigos de recuperação';

  @override
  String get mobileTurnOffMfa => 'Desativar MFA';

  @override
  String get mobileApiAccess => 'Acesso à API';

  @override
  String get mobileApiHelp =>
      'Crie credenciais para integrações com as permissões da sua conta.';

  @override
  String get mobileReadWrite => 'Leitura e gravação';

  @override
  String get mobileReadOnly => 'Somente leitura';

  @override
  String get mobileExpires => 'Expira';

  @override
  String get mobileInactive => 'Inativo';

  @override
  String get mobileRevokeToken => 'Revogar token';

  @override
  String get mobileCreateToken => 'Criar token de API';

  @override
  String get mobileDeleteAccount => 'Excluir conta';

  @override
  String get mobileDeleteWorkspaceHelp =>
      'Exclua sua conta e o acesso ao espaço, incluindo subusuários. Todas as sessões serão encerradas. A ação não pode ser desfeita no aplicativo.';

  @override
  String get mobileDeleteSelfHelp =>
      'Exclua sua conta e encerre suas sessões. A ação não pode ser desfeita no aplicativo.';

  @override
  String get mobileDeleteMyAccount => 'Excluir minha conta';

  @override
  String get mobilePasswordOnly =>
      'Os próximos acessos precisarão apenas da sua senha.';

  @override
  String get mobileRecoveryReplaced =>
      'Seus códigos de recuperação anteriores deixarão de funcionar.';

  @override
  String get mobileTokenName => 'Nome do token';

  @override
  String get mobileAuthenticatorName => 'Nome do autenticador';

  @override
  String get mobileEnterName => 'Insira um nome.';

  @override
  String get mobileAccess => 'Acesso';

  @override
  String get mobileExpiresAfter => 'Expira após';

  @override
  String mobileDays(Object count) {
    return '$count dias';
  }

  @override
  String get mobileCurrentPassword => 'Senha atual';

  @override
  String get mobileEnterPassword => 'Insira sua senha.';

  @override
  String get mobileAuthenticatorOrRecovery =>
      'Código do autenticador ou de recuperação';

  @override
  String get mobileEnterVerification => 'Insira seu código de verificação.';

  @override
  String get mobileDeleteConfirmation =>
      'Entendo que minha conta e o acesso ao espaço serão excluídos.';

  @override
  String get mobileContinue => 'Continuar';

  @override
  String get mobileSixDigits => 'Insira os seis dígitos.';

  @override
  String get mobileConnectAuthenticator => 'Conecte seu autenticador';

  @override
  String get mobileScanQrHelp =>
      'Leia o QR em outro dispositivo ou copie a chave no autenticador. A configuração expira em 10 minutos.';

  @override
  String get mobileCopySetup => 'Copiar chave de configuração';

  @override
  String get mobileNewAuthenticatorCode => 'Código do novo autenticador';

  @override
  String get mobileVerifying => 'Verificando…';

  @override
  String get mobileConfirm => 'Confirmar';

  @override
  String get mobileVerifySignIn => 'Verifique seu acesso';

  @override
  String get mobileUnusedRecovery =>
      'Insira um código de recuperação não utilizado.';

  @override
  String get mobileAuthenticatorInstructions =>
      'Insira o código de seis dígitos do autenticador.';

  @override
  String get mobileRecoveryCode => 'Código de recuperação';

  @override
  String get mobileAuthenticatorCode => 'Código do autenticador';

  @override
  String get mobileCompleteRecovery =>
      'Insira um código de recuperação completo.';

  @override
  String get mobileVerifyAndSignIn => 'Verificar e entrar';

  @override
  String get mobileUseAuthenticator => 'Usar código do autenticador';

  @override
  String get mobileUseRecovery => 'Usar código de recuperação';

  @override
  String get mobileBackSignIn => 'Voltar ao acesso';

  @override
  String get mobileName => 'Nome';

  @override
  String get mobileCallingCode => 'Código de chamada do país';

  @override
  String get mobileMobileNumber => 'Número de celular';

  @override
  String get mobileAddress => 'Endereço';

  @override
  String get mobileCountry => 'País';

  @override
  String get mobileState => 'Estado / Província';

  @override
  String get mobileCity => 'Cidade';

  @override
  String get mobilePostcode => 'Código postal';

  @override
  String get mobileChangePassword => 'Alterar senha';

  @override
  String get mobileRequired => 'Este campo é obrigatório.';

  @override
  String get mobileValidEmail =>
      'Insira um e-mail válido com caracteres ASCII.';

  @override
  String get mobilePasswordSessions =>
      'Alterar a senha encerra todas as suas sessões.';

  @override
  String get mobileNewPassword => 'Nova senha';

  @override
  String get mobilePasswordCharacters => 'Use de 6 a 72 caracteres ASCII.';

  @override
  String get mobileDifferentPassword => 'Escolha uma senha diferente.';

  @override
  String get mobileConfirmPassword => 'Confirmar nova senha';

  @override
  String get mobilePasswordMismatch => 'As senhas não coincidem.';

  @override
  String get mobileChangesSaved => 'Alterações salvas';

  @override
  String get mobileLanguageCodeHelp =>
      'Insira um código de idioma, como en ou hi.';

  @override
  String get mobileReload => 'Recarregar';

  @override
  String get mobileEnterYourName => 'Insira seu nome.';

  @override
  String get mobileEnterCallingCode => 'Insira um código de chamada.';

  @override
  String get mobileValidMobile => 'Insira um número de celular válido.';

  @override
  String get mobileSaveProfile => 'Salvar perfil';

  @override
  String get mobileDisplayPreferences => 'Preferências de exibição';

  @override
  String get mobileDateFormat => 'Formato de data';

  @override
  String get mobileTimeFormat => 'Formato de hora';

  @override
  String get mobileDistanceUnit => 'Unidade de distância';

  @override
  String get mobileTextDirection => 'Direção do texto';

  @override
  String get mobileTimeOffset => 'Diferença de fuso horário';

  @override
  String get mobileLanguageCode => 'Código do idioma';

  @override
  String get mobileSavePreferences => 'Salvar preferências';

  @override
  String get mobileProofAccountChanged =>
      'O acesso mudou. Reabra o comprovante da viagem.';

  @override
  String get mobileActivity => 'Atividade';

  @override
  String get mobileAllStatuses => 'Todos os estados';

  @override
  String get mobileApproximateRoute =>
      'Sequência aproximada • paradas numeradas';

  @override
  String get mobileAttention => 'Atenção';

  @override
  String get mobileChooseRoute => 'Escolha uma rota';

  @override
  String get mobileValidSchedule => 'Escolha uma programação válida.';

  @override
  String get mobileValidStartTime => 'Escolha um horário de início válido.';

  @override
  String get mobileChooseVehicle => 'Escolha um veículo';

  @override
  String get mobileChooseVehicleRoute => 'Escolha um veículo e uma rota.';

  @override
  String get mobileChooseEligibleVehicle => 'Escolha um veículo elegível';

  @override
  String get mobileEndDateAfterStart =>
      'Escolha uma data final igual ou posterior à inicial.';

  @override
  String get mobileChooseWeekday => 'Escolha pelo menos um dia da semana.';

  @override
  String get mobileChooseDate => 'Escolher data';

  @override
  String get mobileChooseDateRange => 'Escolher período';

  @override
  String get mobileChooseDay => 'Escolher dia';

  @override
  String get mobileMultiDayHelp =>
      'Escolha datas e horários de início e conclusão para uma viagem de vários dias.';

  @override
  String get mobileFutureDate => 'Escolha hoje ou uma data futura.';

  @override
  String get mobileCompleted => 'Concluído';

  @override
  String get mobileCompletionAfterStart =>
      'A conclusão deve ser posterior ao início.';

  @override
  String get mobileCreateRouteFirst => 'Crie uma rota para começar a planejar.';

  @override
  String get mobileCreateSchedule => 'Criar programação';

  @override
  String get mobileCreateTrip => 'Criar viagem';

  @override
  String get mobileDeleteSchedule => 'Excluir programação';

  @override
  String get mobileDiscardChanges => 'Descartar alterações';

  @override
  String get mobileDiscardTrip => 'Descartar alterações da viagem?';

  @override
  String get mobileEditRecurring => 'Editar programação recorrente';

  @override
  String get mobileEditSchedule => 'Editar programação';

  @override
  String get mobileEndDate => 'Data de término';

  @override
  String get mobileEndSchedule => 'Encerrar programação';

  @override
  String get mobileEndTime => 'Horário de término';

  @override
  String get mobileEndTimeAfterStart =>
      'O horário final deve ser posterior ao inicial.';

  @override
  String get mobileEndsOptional => 'Término (opcional)';

  @override
  String get mobileTripTitleLength => 'Insira um título de 2 a 120 caracteres.';

  @override
  String get mobileAtLeastTwo => 'Insira pelo menos 2 caracteres';

  @override
  String get mobileAtLeastThree => 'Insira pelo menos 3 caracteres';

  @override
  String get mobileExpandRoute => 'Ampliar mapa da rota';

  @override
  String get mobileFitRoute => 'Enquadrar rota';

  @override
  String get mobileNoGpsPlanning =>
      'GPS não vinculado. A viagem pode ser planejada, mas o rastreamento ao vivo ficará indisponível.';

  @override
  String get mobileKeepEditing => 'Continuar editando';

  @override
  String get mobileKeepSchedule => 'Manter programação';

  @override
  String get mobileLastKnownPosition => 'Última posição conhecida do veículo';

  @override
  String get mobileLatestStart => 'Horário limite de início';

  @override
  String get mobileNextMonth => 'Próximo mês';

  @override
  String get mobileNoEligible => 'Nenhum veículo elegível disponível.';

  @override
  String get mobileNoEligibleHelp =>
      'Nenhum veículo elegível. Atribua um motorista ativo a um veículo ativo antes de planejar.';

  @override
  String get mobileNoRecordsView => 'Nenhum registro nesta visualização.';

  @override
  String get mobileNoRouteGps =>
      'Não há rota nem coordenadas GPS para esta viagem.';

  @override
  String get mobileStopsWithoutGeometry =>
      'Paradas numeradas • traçado indisponível';

  @override
  String get mobilePause => 'Pausar';

  @override
  String get mobilePlanTrip => 'Planejar viagem';

  @override
  String get mobilePlannedNumbered => 'Rota planejada • paradas numeradas';

  @override
  String get mobilePreviousMonth => 'Mês anterior';

  @override
  String get mobileReasonRemark => 'Motivo / observação';

  @override
  String get mobileRecurring => 'Recorrente';

  @override
  String get mobileRecurringSchedule => 'Programação recorrente';

  @override
  String get mobileRecurringActions => 'Ações da programação recorrente';

  @override
  String get mobileRefreshPlanning => 'Atualizar opções de planejamento';

  @override
  String get mobileRefreshSchedule =>
      'Atualize esta programação antes de editar.';

  @override
  String get mobileRemarkOptional => 'Observação (opcional)';

  @override
  String get mobileRemoveEndDate => 'Remover data de término';

  @override
  String get mobileRepeatOn => 'Repetir em';

  @override
  String get mobileResume => 'Retomar';

  @override
  String get mobileRoute => 'Rota';

  @override
  String get mobileRunning => 'Em andamento';

  @override
  String get mobileSaveShareProof => 'Salvar ou compartilhar comprovante';

  @override
  String get mobileSaveSchedule => 'Salvar programação';

  @override
  String get mobileSchedule => 'Programação';

  @override
  String get mobileScheduleSaved => 'Programação salva';

  @override
  String get mobileSearchRoutes => 'Pesquisar rotas';

  @override
  String get mobileSearchVehicleDriver =>
      'Pesquisar veículo, placa ou motorista';

  @override
  String get mobileSkipDates => 'Ignorar datas (opcional)';

  @override
  String get mobileSkipDatesRange =>
      'As datas ignoradas devem estar dentro do período da programação.';

  @override
  String get mobileStartTime => 'Horário de início';

  @override
  String get mobileStarts => 'Início';

  @override
  String get mobileStatus => 'Estado';

  @override
  String get mobileSubmittedProofs => 'Comprovantes enviados';

  @override
  String get mobileAnyTimeDay =>
      'O motorista pode começar a qualquer hora do dia selecionado.';

  @override
  String get mobileStartWindowHelp =>
      'O motorista pode iniciar nesta janela. O fim da janela não é o horário de conclusão da viagem.';

  @override
  String get mobileRequestFailed =>
      'Não foi possível concluir a solicitação. Atualize e tente novamente.';

  @override
  String get mobileRouteUnavailable =>
      'A rota salva não está disponível. Atualize as rotas e tente novamente.';

  @override
  String get mobileAccountTimeHelp =>
      'A viagem começa em horário específico no fuso da conta.';

  @override
  String get mobilePdfPreviewFailed =>
      'Não foi possível visualizar o PDF. Salve ou compartilhe para abrir em outro aplicativo.';

  @override
  String get mobileImagePreviewFailed =>
      'Não foi possível visualizar a imagem. Salve ou compartilhe para abrir em outro aplicativo.';

  @override
  String get mobileToday => 'Hoje';

  @override
  String get mobileTripCreated => 'Viagem criada';

  @override
  String get mobileTripDetails => 'Detalhes da viagem';

  @override
  String get mobileTripRoute => 'Rota da viagem';

  @override
  String get mobileTripTitle => 'Título da viagem';

  @override
  String get mobileProofShareFailed =>
      'Não foi possível compartilhar o comprovante. Tente novamente.';

  @override
  String get mobileUnavailableVehicles => 'Veículos indisponíveis';

  @override
  String get mobileMaxSkipDates => 'Use no máximo 100 datas ignoradas';

  @override
  String get mobileRemarkLength =>
      'Use no máximo 600 caracteres na observação.';

  @override
  String get mobileValidDates => 'Use datas válidas no formato YYYY-MM-DD';

  @override
  String get mobileVehicleGpsPosition => 'Posição GPS do veículo';

  @override
  String get mobileVehicleDriver => 'Veículo e motorista';

  @override
  String get mobileVehicleRoute => 'Veículo e rota';

  @override
  String get mobileViewTrip => 'Ver viagem';

  @override
  String get mobileDatesPerLine => 'YYYY-MM-DD, uma data por linha';

  @override
  String get mobileDiscardPlanningHelp =>
      'As alterações não salvas serão perdidas. As rotas salvas continuarão disponíveis.';

  @override
  String mobileTimesTimezone(Object timezone) {
    return 'Os horários usam $timezone.';
  }

  @override
  String mobileStopsCount(Object count) {
    return '$count paradas';
  }

  @override
  String mobileTripsCount(Object count) {
    return '$count viagens';
  }

  @override
  String mobileLoadMoreCount(Object loaded, Object total) {
    return 'Carregar mais ($loaded de $total)';
  }

  @override
  String mobileScheduledDate(Object date) {
    return 'Programado: $date';
  }

  @override
  String mobileEndsDate(Object date) {
    return 'Término: $date';
  }

  @override
  String mobileNextDate(Object date) {
    return 'Próximo: $date';
  }

  @override
  String mobileGpsStatus(Object status) {
    return 'GPS do veículo: $status';
  }

  @override
  String mobileLastPosition(Object date) {
    return 'Última posição: $date';
  }

  @override
  String mobileActualDistance(Object distance) {
    return 'Distância real: $distance km';
  }

  @override
  String mobileTripScore(Object value) {
    return 'Pontuação da viagem: $value';
  }

  @override
  String mobileStopsProgress(Object completed, Object total) {
    return '$completed/$total paradas';
  }

  @override
  String mobileScheduleAction(Object action) {
    return '$action programação recorrente?';
  }

  @override
  String get dateRangeSelect => 'Selecionar período';

  @override
  String get dateRangeChoose => 'Escolher período';

  @override
  String get dateTimeRangeChoose => 'Escolher período de datas e horários';

  @override
  String get dateRangeFrom => 'De';

  @override
  String get dateRangeTo => 'Até';

  @override
  String get dateRangeSelected => 'Período selecionado';

  @override
  String get dateRangeStartTime => 'Horário de início';

  @override
  String get dateRangeEndTime => 'Horário de término';

  @override
  String get dateRangeSelectStartTime => 'Selecionar horário de início';

  @override
  String get dateRangeSelectEndTime => 'Selecionar horário de término';

  @override
  String get dateRangeInvalidTime =>
      'O horário final deve ser posterior ao inicial.';

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
  String get dateRangeToday => 'Hoje';

  @override
  String get dateRangeYesterday => 'Ontem';

  @override
  String get dateRangeThisWeek => 'Esta semana';

  @override
  String get dateRangeLastWeek => 'Semana passada';

  @override
  String get dateRangeLast7Days => 'Últimos 7 dias';

  @override
  String get dateRangeLast30Days => 'Últimos 30 dias';

  @override
  String get apply => 'Aplicar';

  @override
  String get calendarToday => 'Hoje';

  @override
  String get calendarPreviousMonth => 'Mês anterior';

  @override
  String get calendarNextMonth => 'Próximo mês';

  @override
  String get calendarExpiry => 'Vencimento';

  @override
  String get legacyUi869d62ddcd => ' para ativar o botão.';

  @override
  String get legacyUi7f4f41c8c3 => '#RRGGBB';

  @override
  String get legacyUi9515360684 => '+ Adicionar dispositivo';

  @override
  String get legacyUi6116c134de => '+ Criar plano';

  @override
  String get legacyUic10e9a1c41 => '+ Criar usuário';

  @override
  String get legacyUi5e9a7040e4 => '2 dígitos';

  @override
  String get legacyUia0483eec37 => '3 dígitos';

  @override
  String get legacyUi3994dbd48e => '6 a 35 caracteres';

  @override
  String get legacyUi250e268e83 => '7 a 15 dígitos';

  @override
  String get legacyUie69a9a5ee9 => 'Uso em 7 dias';

  @override
  String get legacyUib8cee60c75 =>
      'Um subusuário só pode usar os recursos e relatórios disponíveis na sua conta. As configurações e a segurança da conta continuam disponíveis.';

  @override
  String get legacyUif0ee13e963 => 'Acesso restrito';

  @override
  String get legacyUi6e702cb4e0 => 'Status da conta';

  @override
  String get legacyUi6d6eba9279 => 'Acesso à conta';

  @override
  String get legacyUi82cf8a5fc7 => 'Configurações da conta';

  @override
  String get legacyUi9beb96dac8 => 'Confirmar recebimento';

  @override
  String get legacyUibf539b1d10 => 'Acme Logistics Pvt. Ltd.';

  @override
  String get legacyUic3cd636a58 => 'Ações';

  @override
  String get legacyUia733b809d2 => 'Ativo';

  @override
  String get legacyUi15cf579b89 => 'Tempo em atividade';

  @override
  String get legacyUifaa171bc07 => 'Veículo ativo';

  @override
  String get legacyUibde34d0278 => 'Status de atividade';

  @override
  String get legacyUi14c5b09cd4 => 'Detalhes da atividade';

  @override
  String get legacyUifbed23bc25 => 'Registros de atividade';

  @override
  String get legacyUie35effbf63 => 'Período de atividade';

  @override
  String get legacyUicbd19b5c39 => 'Responsável pela ação';

  @override
  String get legacyUi7980ca2475 => 'Usuário responsável';

  @override
  String get legacyUi4ac5084db4 => 'Adicionar dispositivo ou SIM';

  @override
  String get legacyUiaa752d14b8 => 'Adicionar motorista';

  @override
  String get legacyUi224f2486e6 => 'Adicionar estoque';

  @override
  String get legacyUi1836b111cd => 'Adicionar linha de metadados';

  @override
  String get legacyUi31dd5bb29e => 'Adicionar equipe';

  @override
  String get legacyUi47b2149c9c => 'Adicionar plano';

  @override
  String get legacyUic08d1e9d3f => 'Adicionar sensor';

  @override
  String get legacyUi12071f1c87 => 'Adicione um plano ou altere sua busca.';

  @override
  String get legacyUic0c181937e => 'Adicionar atributo';

  @override
  String get legacyUi5367d642e2 => 'Adicionar créditos';

  @override
  String get legacyUi1fa55e4562 => 'Adicionar linha de metadados';

  @override
  String get legacyUi7be087b7a7 => 'Adicionar comprovante';

  @override
  String get legacyUib68734c259 => 'Adicionado';

  @override
  String get legacyUi41b5f2e6ae => 'Observações adicionais';

  @override
  String get legacyUid5e920a5cb => 'Endereço';

  @override
  String get legacyUi7748043229 => 'Endereço e dados geográficos.';

  @override
  String get legacyUi4faa35048a =>
      'Solicitação de login do administrador concluída.';

  @override
  String get legacyUi1eda23758b => 'Administrador';

  @override
  String get legacyUi3df513225f => 'Administrador criado.';

  @override
  String get legacyUif981236722 => 'Veículos afetados';

  @override
  String get legacyUib7fb586ff2 => 'Aeroporto';

  @override
  String get legacyUi25f8c55de8 => 'Alarme';

  @override
  String get legacyUib5faca3a78 => 'Tipo de alerta';

  @override
  String get legacyUic03d80790d => 'Todos os administradores';

  @override
  String get legacyUi0b313a76be => 'Todos os países';

  @override
  String get legacyUiffeed47b5a => 'Todos os provedores';

  @override
  String get legacyUi4745c5dce5 => 'Todo o período';

  @override
  String get legacyUieb672cb3ba => 'Todos os tipos';

  @override
  String get legacyUib4f25a1426 => 'Todos os usuários';

  @override
  String get legacyUidd9eb32418 => 'Todos os veículos';

  @override
  String get legacyUi060be00f4f => 'Todas as categorias';

  @override
  String get legacyUi0aaede0bb1 =>
      'Todas as notificações foram marcadas como lidas.';

  @override
  String get legacyUi30c8a0fc9c => 'Todos os tipos';

  @override
  String get legacyUice832d9b31 => 'Todos os usuários';

  @override
  String get legacyUie512a2f10a => 'Permitir histórico';

  @override
  String get legacyUif8f993b052 => 'Permitir acesso ao histórico de rotas.';

  @override
  String get legacyUi1ffee134b1 =>
      'Permitir que visitantes entrem em um ambiente de demonstração.';

  @override
  String get legacyUie5d30dc481 => 'Intervalo permitido: 10–300';

  @override
  String get legacyUi22786d42cc => 'Altitude';

  @override
  String get legacyUi43dc8532f7 => 'Valor';

  @override
  String get legacyUi76aa32f207 => 'Valor *';

  @override
  String get legacyUia01154a861 => 'Valor personalizado';

  @override
  String get legacyUi7d66157b06 => 'O valor deve estar entre 0,01 e 9999999,99';

  @override
  String get legacyUib34440b2cd => 'Valor personalizado';

  @override
  String get legacyUib757c50159 => 'O valor aceita até 2 casas decimais';

  @override
  String get legacyUic8c3ba95bb =>
      'As análises aparecerão quando houver pagamentos.';

  @override
  String get legacyUif6c665f4fe =>
      'As análises aparecerão quando houver transações.';

  @override
  String get legacyUi6b2a78a8f7 => 'Aplicar filtros';

  @override
  String get legacyUi2444928438 => 'Atribuir';

  @override
  String get legacyUi561f6317fe => 'Atribuir motorista';

  @override
  String get legacyUi3d2183f9ae => 'Atribuir selecionados';

  @override
  String get legacyUi5e97289597 => 'Atribuir usuário';

  @override
  String get legacyUib8db201262 => 'Atribuir veículo';

  @override
  String get legacyUi20b5675c39 => 'Atribuir veículos';

  @override
  String get legacyUic403a13c66 =>
      'Atribua um ou mais veículos a este subusuário.';

  @override
  String get legacyUie12261bf18 => 'Atribua usuários a este motorista.';

  @override
  String get legacyUi41c90cdeef => 'Atribua usuários a este veículo.';

  @override
  String get legacyUi32265d6dad =>
      'Atribua veículos para configurar notificações básicas.';

  @override
  String get legacyUi117326ffd2 =>
      'Atribua veículos para configurar notificações de duração.';

  @override
  String get legacyUi74dfd6593f =>
      'Atribua veículos para configurar notificações de cercas virtuais.';

  @override
  String get legacyUi8c6586176a =>
      'Atribua veículos para configurar notificações de excesso de velocidade.';

  @override
  String get legacyUi086854873d =>
      'Atribua veículos para configurar notificações de rotas.';

  @override
  String get legacyUie24e824b68 => 'Atribuído';

  @override
  String get legacyUie94ba984c3 => 'Veículos atribuídos';

  @override
  String get legacyUie55df441e8 => 'Atribuição';

  @override
  String get legacyUi0c686b74d7 =>
      'Pelo menos 5 caracteres. As alterações são auditadas.';

  @override
  String get legacyUi1afff0157c => 'Anexar';

  @override
  String get legacyUi0c431f4969 => 'Anexar arquivo';

  @override
  String get legacyUi137135dbf6 => 'Anexar arquivos';

  @override
  String get legacyUi2286866966 => 'A URL do anexo não está disponível.';

  @override
  String get legacyUib6b6277691 => 'O caminho do anexo não está disponível.';

  @override
  String get legacyUi1b30607d41 => 'As chaves dos atributos devem ser únicas.';

  @override
  String get legacyUia6652617f2 => 'Atributos';

  @override
  String get legacyUi7c62a14244 => 'Disponível';

  @override
  String get legacyUicdc93143c6 => 'Média';

  @override
  String get legacyUib1ff8731de => 'Velocidade média';

  @override
  String get legacyUi3e6e9b59e4 => 'Tokens do servidor';

  @override
  String get legacyUib15950ccc9 => 'Tokens do servidor';

  @override
  String get legacyUief5c48114b => 'Verificado pelo servidor';

  @override
  String get legacyUidd96994d01 => 'Backup';

  @override
  String get legacyUi775fe0e609 => 'Backup / Retenção de dados';

  @override
  String get legacyUi17ef50d8f8 => 'Transferência bancária';

  @override
  String get legacyUi1007a1a728 =>
      'Referência bancária / UTR / ID da transação';

  @override
  String get legacyUi5be1ae92e8 =>
      'Observação da transferência / UTR / Referência da transação';

  @override
  String get legacyUi6b57349e97 => 'Configurações da URL base';

  @override
  String get legacyUiaa2c96dacf => 'Básico';

  @override
  String get legacyUic73c27be48 =>
      'Credenciais básicas para o login do motorista.';

  @override
  String get legacyUi904d23cb6a => 'Identificação básica do novo veículo.';

  @override
  String get legacyUi99613c74ce => 'Bloqueado';

  @override
  String get legacyUi584522b903 => 'Marca e dados de contato';

  @override
  String get legacyUibfc8921ede => 'Cor da marca';

  @override
  String get legacyUi54a2cf5e63 => 'Navegador';

  @override
  String get legacyUi73e0b16797 =>
      'Ícone da aba do navegador. ICO, PNG ou SVG. Máximo de 2 MB.';

  @override
  String get legacyUicfadbd7a57 => 'Por';

  @override
  String get legacyUi42878ce3fa => 'Uso da CPU';

  @override
  String get legacyUi37efa8a990 => 'Café';

  @override
  String get legacyUi26b937c51d => 'Cancelar solicitação de renovação?';

  @override
  String get legacyUi84837a2168 => 'Cancelar solicitação';

  @override
  String get legacyUi2738a0a1db =>
      'Não é possível carregar comandos sem os dados do veículo.';

  @override
  String get legacyUi4d4ce73b15 => 'Cartão';

  @override
  String get legacyUi758ec54e43 => 'Dinheiro';

  @override
  String get legacyUi6ccb60071b => 'Categorias';

  @override
  String get legacyUi49289db43e => 'Alterar senha';

  @override
  String get legacyUi6fc0529f2d => 'Alterar status';

  @override
  String get legacyUica5df1dad1 => 'Escolher período de data e hora';

  @override
  String get legacyUid2174d8075 => 'Escolher período de reprodução';

  @override
  String get legacyUi66542fe55c =>
      'Escolha um plano, uma data de registro e um motivo de 5 a 500 caracteres.';

  @override
  String get legacyUi7db804aa37 =>
      'Escolha os veículos, a validade e as opções de compartilhamento.';

  @override
  String get legacyUi037c5eba86 => 'Cidade (opcional)';

  @override
  String get legacyUief153831d1 => 'A cidade é obrigatória.';

  @override
  String get legacyUi8da6bb0466 => 'Limpeza concluída';

  @override
  String get legacyUi381c4bf1d4 => 'Limpar filtros';

  @override
  String get legacyUicdb64ef80e => 'Limpar período';

  @override
  String get legacyUid3c69afc35 => 'Limpar datas';

  @override
  String get legacyUi1bf7452cd6 => 'Limpar validade';

  @override
  String get legacyUi40b66a41b8 => 'Limpar data de validade';

  @override
  String get legacyUi92e60a4db3 => 'Limpar reprodução';

  @override
  String get legacyUi53dde4f2c0 =>
      'A receita de clientes aparecerá após o registro de pagamentos.';

  @override
  String get legacyUide4e7f6fad => 'Fechar menu lateral';

  @override
  String get legacyUi3dc631324c => 'Fechar mapa';

  @override
  String get legacyUid75dc68bbd => 'Agrupar';

  @override
  String get legacyUiadac69379a => 'Código';

  @override
  String get legacyUiea6ac41a6a => 'O código é obrigatório.';

  @override
  String get legacyUi5b0f7590d0 => 'Recebido';

  @override
  String get legacyUi8901895fb1 => 'Comando';

  @override
  String get legacyUif7e08456d0 => 'Detalhes do comando';

  @override
  String get legacyUi6c4cb3de03 => 'Texto do comando';

  @override
  String get legacyUibfed234d46 => 'Comando indisponível';

  @override
  String get legacyUi45e5f3f72e => 'Comandos';

  @override
  String get legacyUi7a1994999d => 'Empresa';

  @override
  String get legacyUi8599f5cc48 => 'Nome da empresa';

  @override
  String get legacyUi1e5f7dc45c => 'Nome da empresa';

  @override
  String get legacyUib55887f633 => 'Empresa atualizada';

  @override
  String get legacyUi657063c67c => 'Empresa atualizada.';

  @override
  String get legacyUif1ab0a6f4e => 'Concluir manualmente';

  @override
  String get legacyUif14ebb39ce => 'Versão da configuração';

  @override
  String get legacyUi755bea99c0 => 'Configuração atualizada.';

  @override
  String get legacyUic69463a5a9 => 'Configure o envio de e-mails.';

  @override
  String get legacyUic2d404cb7b => 'Confirmar senha';

  @override
  String get legacyUiea3723a45c => 'Confirmar ampliação de acesso';

  @override
  String get legacyUi4a7c565d4c => 'Confirmar senha';

  @override
  String get legacyUi5febc18b54 => 'Confirmar pagamento';

  @override
  String get legacyUi05a7fffae1 => 'Confirmar pagamento recebido';

  @override
  String get legacyUi90d96c7cec => 'Frase de confirmação';

  @override
  String get legacyUic2f9b7b489 => 'Conectado';

  @override
  String get legacyUib37456c453 => 'Contato';

  @override
  String get legacyUicc11b3a28f => 'Contexto';

  @override
  String get legacyUi3cf29aa7f5 => 'Motor ocioso contínuo';

  @override
  String get legacyUic352b92e1f => 'Movimento contínuo';

  @override
  String get legacyUi347d3dbf17 => 'Parada contínua';

  @override
  String get legacyUi49fdb038f4 => 'Controle o que os espectadores podem ver.';

  @override
  String get legacyUi02c6c04dec => 'Copiar KML';

  @override
  String get legacyUi44fe06869f => 'Copiar cabeçalho';

  @override
  String get legacyUi3a9d77c901 => 'Não foi possível abrir a URL';

  @override
  String get legacyUi0c09a7eccc => 'Não foi possível abrir o anexo.';

  @override
  String get legacyUif2344997aa => 'Não foi possível abrir o documento.';

  @override
  String get legacyUi2209ab63ce => 'Não foi possível abrir o arquivo.';

  @override
  String get legacyUi5905ce4109 =>
      'Não foi possível abrir o arquivo. Link copiado.';

  @override
  String get legacyUi9b09f53bdd => 'Não foi possível abrir o link.';

  @override
  String get legacyUi72be0e8616 => 'Não foi possível selecionar o arquivo';

  @override
  String get legacyUi76e835f8c3 => 'Não foi possível selecionar o arquivo.';

  @override
  String get legacyUiaef46d6729 => 'Não foi possível ler o arquivo selecionado';

  @override
  String get legacyUi280c98ccef => 'Filtro de país';

  @override
  String get legacyUi1c9a9315c9 => 'O país é obrigatório.';

  @override
  String get legacyUid82b56cad9 => 'Direção';

  @override
  String get legacyUi6e157c5da4 => 'Criar';

  @override
  String get legacyUi318d1da4e0 => 'Criar administrador';

  @override
  String get legacyUi0a62dd4d37 => 'Criar motorista';

  @override
  String get legacyUie3429ab78d => 'Criar cerca virtual';

  @override
  String get legacyUidb7c457634 => 'Criar POI';

  @override
  String get legacyUicdd060d443 => 'Criar plano de preços';

  @override
  String get legacyUi5d16c5ffd7 => 'Criar subusuário';

  @override
  String get legacyUiafe9a7ae15 => 'Criar chamado';

  @override
  String get legacyUib25c91fe61 => 'Criar usuário';

  @override
  String get legacyUi705b0946b2 => 'Criar veículo';

  @override
  String get legacyUi22a6b9d964 =>
      'Crie um painel na aplicação web para visualizá-lo aqui.';

  @override
  String get legacyUi769479a4d5 =>
      'Crie um link público para compartilhar o rastreamento de veículos ao vivo.';

  @override
  String get legacyUi50aab1f7b5 => 'Crie um sensor para este veículo.';

  @override
  String get legacyUi0d2cd08b59 => 'Criar administrador';

  @override
  String get legacyUi6f876ff9c0 => 'Crie pelo menos um item antes de exportar.';

  @override
  String get legacyUic42adee4d7 =>
      'Criar dispositivo sem sair deste formulário';

  @override
  String get legacyUiaba922c9b5 => 'Criar motorista';

  @override
  String get legacyUi6efd8652f4 =>
      'Crie motoristas e gerencie veículos atribuídos, documentos e atividades.';

  @override
  String get legacyUiba98384ac3 =>
      'Crie cercas virtuais para configurar suas notificações.';

  @override
  String get legacyUif7b868f7d4 =>
      'Crie pontos de interesse com categoria, ícone, cor e raio de tolerância.';

  @override
  String get legacyUie42ed33e33 =>
      'Criar plano de preços sem sair deste formulário';

  @override
  String get legacyUie40f966076 =>
      'Crie linhas de rota manualmente ou a partir da origem e do destino, quando disponível.';

  @override
  String get legacyUi567e040ce2 =>
      'Crie rotas para configurar notificações de desvio.';

  @override
  String get legacyUica09bbf34d =>
      'Crie subusuários e controle quais veículos eles podem acessar.';

  @override
  String get legacyUi3afcbed7e6 => 'Criar chamado';

  @override
  String get legacyUibdbcfa0af0 => 'Criar usuário';

  @override
  String get legacyUie7358de58e =>
      'Criar usuário sem sair deste formulário de veículo';

  @override
  String get legacyUi505a950fbb => 'Criar veículo';

  @override
  String get legacyUi1ef0c932b3 =>
      'Crie seu primeiro motorista para começar as atribuições.';

  @override
  String get legacyUi7d3ca14313 =>
      'Crie sua primeira cerca virtual para definir limites operacionais.';

  @override
  String get legacyUi60a39e1fde =>
      'Crie seu primeiro local para acompanhar pontos operacionais.';

  @override
  String get legacyUi4fbf4f09cd =>
      'Crie seu primeiro subusuário para compartilhar acessos específicos.';

  @override
  String get legacyUiaccf40c89b => 'Criado';

  @override
  String get legacyUia5682ef199 => 'Criado: ';

  @override
  String get legacyUi5db1542e68 => 'Criado em';

  @override
  String get legacyUif1c69716be => 'Criado em';

  @override
  String get legacyUidd097a2297 => 'Credenciais';

  @override
  String get legacyUi9f58b9e39b =>
      'Credenciais que o administrador usará para entrar no OpenVTS.';

  @override
  String get legacyUiec535bab6f =>
      'Credenciais que o usuário usará para entrar no OpenVTS.';

  @override
  String get legacyUi8a45d339a6 => 'Crédito';

  @override
  String get legacyUic3dc6e3ef9 =>
      'Atualizações de créditos, pagamentos ou cobranças aparecerão aqui.';

  @override
  String get legacyUibfac50d642 => 'Créditos';

  @override
  String get legacyUie070de2244 => 'Moeda';

  @override
  String get legacyUiea4b114ac6 => 'Estado atual';

  @override
  String get legacyUieeed986410 => 'Créditos atuais';

  @override
  String get legacyUibe1ac4e322 => 'Etapa atual';

  @override
  String get legacyUi9c378938cd => 'Comando personalizado';

  @override
  String get legacyUi28be3fd018 => 'Domínio personalizado';

  @override
  String get legacyUif130609dfc => 'Período personalizado';

  @override
  String get legacyUia9d9e61bf2 =>
      'Categoria personalizada (ex.: \"fornecedor\")';

  @override
  String get legacyUi0354c8896b => 'Domínio personalizado';

  @override
  String get legacyUi3a55eba66f => 'Domínio personalizado e cor da marca.';

  @override
  String get legacyUi9f1d0368da => 'Validade do cliente';

  @override
  String get legacyUi1588fe44aa => 'Data de validade do cliente';

  @override
  String get legacyUib13a49701d => 'Solicitações de renovação de clientes';

  @override
  String get legacyUi0c919bd08d => 'O serviço do cliente expira em';

  @override
  String get legacyUidce04fd315 => 'Personalizado…';

  @override
  String get legacyUi118de3988f => 'Limite';

  @override
  String get legacyUi5c487cb2d8 =>
      'Os valores diários de receita não estão disponíveis neste período.';

  @override
  String get legacyUi99c0019cc6 => 'Logotipo para tema escuro';

  @override
  String get legacyUia167278399 => 'Logotipo para tema escuro atualizado';

  @override
  String get legacyUi2b197ef6be =>
      'Os registros do banco de dados e da telemetria ao vivo aparecerão aqui.';

  @override
  String get legacyUi6bb4b674b3 => 'Período de datas';

  @override
  String get legacyUie3d06ca6a1 => 'Período de data e hora';

  @override
  String get legacyUic65ea4ae01 => 'Período de datas';

  @override
  String get legacyUi853aab7f56 => 'Data/Hora';

  @override
  String get legacyUi842b7b5d71 => 'Datas';

  @override
  String get legacyUi987b9ced08 => 'Dia';

  @override
  String get legacyUi82c29dd5fa => 'Comparação dia / noite';

  @override
  String get legacyUibfb1ba6e3e => 'Período diurno / noturno';

  @override
  String get legacyUicf558941e0 => 'Débito';

  @override
  String get legacyUibb3cec5175 => 'Deduzir créditos';

  @override
  String get legacyUi6bccca646f => 'Deduzido';

  @override
  String get legacyUi1dcab135ef => 'Eliminar duplicatas';

  @override
  String get legacyUi15462a4954 => 'Eliminar eventos duplicados';

  @override
  String get legacyUi6184deb041 => 'Plano padrão';

  @override
  String get legacyUiee1b9a9f23 => 'Excluir conta';

  @override
  String get legacyUie81c14c990 => 'Excluir motorista';

  @override
  String get legacyUi749f8e14e3 => 'Excluir subusuário';

  @override
  String get legacyUi0a0a90f6c5 => 'Excluir usuário';

  @override
  String get legacyUi4bcd1233a1 => 'Excluir administrador';

  @override
  String get legacyUi6fd38c1fb9 => 'Excluir administrador';

  @override
  String get legacyUie8df0b7902 => 'Excluir documento';

  @override
  String get legacyUi4ecae3e148 => 'Excluir documento?';

  @override
  String get legacyUid1571af327 => 'Excluir conta do motorista';

  @override
  String get legacyUia34ada32da => 'Excluir sensor';

  @override
  String get legacyUi1ce5593800 => 'Excluir este documento?';

  @override
  String get legacyUi6a58093cab => 'Excluir link de rastreamento';

  @override
  String get legacyUi9afe6c7b95 => 'Excluir usuário';

  @override
  String get legacyUif7ff7065a9 => 'Excluir veículo';

  @override
  String get legacyUi441bda6cd8 => 'Excluído';

  @override
  String get legacyUif7c094a571 => 'Linhas excluídas';

  @override
  String get legacyUic6bdaac949 => 'Délhi';

  @override
  String get legacyUibc4f986ecb => 'Entregas';

  @override
  String get legacyUi921a6f6b55 => 'Registros de entrega';

  @override
  String get legacyUib2c4e6cb46 => 'Login de demonstração';

  @override
  String get legacyUi4675a25777 => 'Login de demonstração';

  @override
  String get legacyUi59013d16af => 'Descreva a solicitação ou o problema';

  @override
  String get legacyUi55f8ebc805 => 'Descrição';

  @override
  String get legacyUi388de6fa3a => 'Descrição (opcional)';

  @override
  String get legacyUi763630a9ce => 'A descrição é obrigatória.';

  @override
  String get legacyUi8a96cce5e5 =>
      'A descrição deve conter pelo menos uma letra ou um número.';

  @override
  String get legacyUidc3decbb93 => 'Detalhes';

  @override
  String get legacyUia5a74a6df0 => 'Dispositivo';

  @override
  String get legacyUid69ba8a9eb => 'Dispositivo + SIM';

  @override
  String get legacyUic587837fda => 'IMEI do dispositivo';

  @override
  String get legacyUif59a7a21bb => 'Instalações de dispositivos';

  @override
  String get legacyUi219288726d => 'Somente dispositivo';

  @override
  String get legacyUi554dd558bd => 'Resumo do dispositivo';

  @override
  String get legacyUi20d5df8b4a => 'Tipo de dispositivo';

  @override
  String get legacyUi30de920ef1 => 'Dispositivo criado e selecionado';

  @override
  String get legacyUi3c47b57c83 => 'Resposta do dispositivo';

  @override
  String get legacyUi6d2870160a => 'Hora do dispositivo';

  @override
  String get legacyUi21fe5a18d0 => 'Dispositivo atualizado.';

  @override
  String get legacyUidf485c8713 => 'Dispositivos';

  @override
  String get legacyUibb73469225 => 'Desativar sem excluir o link.';

  @override
  String get legacyUid3e4b30e10 => 'Descartar e atualizar';

  @override
  String get legacyUi427dc4f0cd => 'Descartar novo administrador?';

  @override
  String get legacyUid1b8679c63 => 'Descartar novo usuário?';

  @override
  String get legacyUi6012a2d760 => 'Descartar novo veículo?';

  @override
  String get legacyUifb0a3e6787 => 'Uso do disco';

  @override
  String get legacyUi70afe9eff3 => 'Dispensar';

  @override
  String get legacyUi515aa7ad86 =>
      'Exibir o contexto da cerca virtual atribuída.';

  @override
  String get legacyUi37bbdde1a6 => 'Exibir limites de cercas virtuais no mapa';

  @override
  String get legacyUi2eebf5225a => 'Exibir rotas salvas no mapa';

  @override
  String get legacyUifb71a3779e => 'Multiplicador de distância';

  @override
  String get legacyUib3262ecb53 => 'Variação de distância';

  @override
  String get legacyUiac3f0eb0ea => 'Distância/Horas';

  @override
  String get legacyUi2c21f68832 => 'Tipo de documento';

  @override
  String get legacyUi7615530d7a => 'A URL do documento não está disponível.';

  @override
  String get legacyUi6dad05c10e => 'Ações do documento';

  @override
  String get legacyUibd9a0f027e => 'Documento excluído.';

  @override
  String get legacyUi3859bdaa8c => 'Título do documento';

  @override
  String get legacyUi300b6ef0cd => 'Tipo de documento';

  @override
  String get legacyUi9b10914d8b => 'Domínio';

  @override
  String get legacyUifb349182fc => 'Domínio e cor';

  @override
  String get legacyUi8b58eea04e => 'Domínio e cor da marca salvos';

  @override
  String get legacyUi0ec2ae5cda =>
      'Domínio, logotipos, favicon e cor da marca.';

  @override
  String get legacyUibfa50c7a38 => 'Desenhar';

  @override
  String get legacyUi2e617aeb36 =>
      'Desenhe círculos, polígonos, retângulos e limites em linha no mapa.';

  @override
  String get legacyUid952b9d3da =>
      'Desenhe seu primeiro corredor de rota para iniciar o rastreamento.';

  @override
  String get legacyUi0ecf1d5bc0 => 'Percorrido';

  @override
  String get legacyUi845a6bd3ab => 'Perfil do motorista';

  @override
  String get legacyUi450d68e4fe => 'Ações do motorista';

  @override
  String get legacyUid1ba6aea38 => 'Motorista atribuído.';

  @override
  String get legacyUifbaa386fbc =>
      'As atribuições e as atividades do perfil do motorista aparecerão aqui.';

  @override
  String get legacyUi017bb97653 => 'Motorista criado.';

  @override
  String get legacyUif8acdd5348 =>
      'A criação e as atualizações de motoristas aparecerão aqui.';

  @override
  String get legacyUib057fefdc2 => 'Motorista excluído.';

  @override
  String get legacyUi63a7342acd => 'Nome do motorista';

  @override
  String get legacyUi8d30cc59a1 => 'Atribuição do motorista removida.';

  @override
  String get legacyUia010b0a25f => 'Motorista atualizado.';

  @override
  String get legacyUifdd68e9960 => 'Área de trabalho do motorista';

  @override
  String get legacyUi3d14659ca9 => 'Simulação';

  @override
  String get legacyUi87bd16c150 => 'Simulação concluída';

  @override
  String get legacyUi91310be76f => 'Dubai';

  @override
  String get legacyUi1370004da7 => 'Duração';

  @override
  String get legacyUia051787af6 => 'Cada anexo deve ter no máximo 5 MB.';

  @override
  String get legacyUi9bb58b2d1b => 'Leste';

  @override
  String get legacyUi7de491bedc => 'Editar empresa';

  @override
  String get legacyUi5b7faa9d61 => 'Editar dispositivo';

  @override
  String get legacyUicf5ddc10b3 => 'Editar motorista';

  @override
  String get legacyUi13a7a7c3a7 => 'Editar plano';

  @override
  String get legacyUicd280a41f7 => 'Editar perfil';

  @override
  String get legacyUi19d57bd021 => 'Editar SIM';

  @override
  String get legacyUi4a0fe224b9 => 'Editar sensor';

  @override
  String get legacyUic8e262db5b => 'Editar subusuário';

  @override
  String get legacyUi38a1cb0f89 => 'Editar membro da equipe';

  @override
  String get legacyUi0e457253ad => 'Editar usuário';

  @override
  String get legacyUib213eb6d7b => 'Editar veículo';

  @override
  String get legacyUid03750ccbf => 'Editar empresa';

  @override
  String get legacyUi15141eab3a => 'Editar perfil';

  @override
  String get legacyUi84add5b295 => 'E-mail';

  @override
  String get legacyUi5c10b588a9 => 'E-mail (opcional)';

  @override
  String get legacyUi094f6a5934 => 'E-mail ou nome de usuário';

  @override
  String get legacyUi79d1feaf62 => 'Status do e-mail';

  @override
  String get legacyUia674e88b73 => 'Verificação de e-mail';

  @override
  String get legacyUic1feb155ec => 'Ativar login de demonstração';

  @override
  String get legacyUi7cf7a0d02a => 'Ativar cadastro público';

  @override
  String get legacyUif6321257f1 => 'Ativar este link público.';

  @override
  String get legacyUid093b28018 => 'Ativar/Atualizar';

  @override
  String get legacyUi0af149c2ed => 'Criptografia';

  @override
  String get legacyUic1f65ddb75 => 'Motor';

  @override
  String get legacyUi49dda3d71a => 'Horas do motor';

  @override
  String get legacyUi4c9c7856d1 => 'Digite o código de 6 dígitos';

  @override
  String get legacyUibc96ad8350 =>
      'Digite um valor decimal com até 2 casas decimais';

  @override
  String get legacyUib0e59c93d7 => 'Digite um valor válido.';

  @override
  String get legacyUi6d59e6aee7 =>
      'Digite um motivo de 5 a 500 caracteres para a substituição';

  @override
  String get legacyUi571c7347b7 =>
      'Digite um motivo de 5 a 500 caracteres para a substituição.';

  @override
  String get legacyUi18b809c9fb => 'Digite o texto do comando';

  @override
  String get legacyUid5cd51c7b9 => 'Digite o valor dos créditos';

  @override
  String get legacyUibe7572b6c5 => 'Digite o estado ou território';

  @override
  String get legacyUid148321ad7 => 'Digite o código de 6 dígitos';

  @override
  String get legacyUi0d639c50f1 => 'Digite o código de 6 dígitos que enviamos';

  @override
  String get legacyUi6d1e849865 =>
      'Digite o código de uso único enviado ao seu contato cadastrado.';

  @override
  String get legacyUied634c4edc =>
      'Digite o e-mail ou nome de usuário usado para entrar. Se a conta existir, enviaremos um link de redefinição com validade limitada.';

  @override
  String get legacyUi1378167d52 => 'Digite sua senha';

  @override
  String get legacyUib6334ab817 => 'Digite seu nome de usuário ou e-mail';

  @override
  String get legacyUic7fb317725 => 'Entidade';

  @override
  String get legacyUi04d694e298 => 'ID da entidade';

  @override
  String get legacyUi948542c1d6 => 'Erro/Crítico';

  @override
  String get legacyUic250d77524 => 'Detalhes do evento';

  @override
  String get legacyUi894b1c749d => 'ID do evento';

  @override
  String get legacyUif8e451a5d0 => 'Eventos indisponíveis';

  @override
  String get legacyUief09596668 => 'Sair da demonstração';

  @override
  String get legacyUia689a999a5 => 'Expirado';

  @override
  String get legacyUib98d67213b => 'A vencer';

  @override
  String get legacyUi57fe01159c => 'Data de validade (opcional)';

  @override
  String get legacyUi1275b51587 => 'Data/hora de validade';

  @override
  String get legacyUi6b440cd506 => 'Data de validade';

  @override
  String get legacyUic9f6710324 => 'A validade deve ser uma data futura.';

  @override
  String get legacyUif3e4fadb9e => 'Exportar';

  @override
  String get legacyUi416a52a386 => 'Exportar KML';

  @override
  String get legacyUi09b28aeb8d => 'Token FCM';

  @override
  String get legacyUic2bf1a9df5 => 'Últimos 10 caracteres do token FCM';

  @override
  String get legacyUi82da67b211 => 'Facebook';

  @override
  String get legacyUi09fef5d8d9 => 'Falhou';

  @override
  String get legacyUid68666787d => 'Tabelas com falha';

  @override
  String get legacyUi706b9a59b6 => 'Falha ao carregar cidades';

  @override
  String get legacyUi6eb9516fdf => 'Falha ao carregar países';

  @override
  String get legacyUi4bc4b2e555 => 'Falha ao carregar detalhes';

  @override
  String get legacyUia7bc426a05 =>
      'Falha ao carregar os dados completos do veículo.';

  @override
  String get legacyUia17267ffa7 => 'Falha ao carregar estados';

  @override
  String get legacyUi6bb1f1d9fb => 'Falha ao atualizar o status.';

  @override
  String get legacyUi1656649117 => 'Falha';

  @override
  String get legacyUib7ef43c84d => 'Código da falha';

  @override
  String get legacyUi41510b1b21 => 'Mensagem da falha';

  @override
  String get legacyUi8db6a2f1d3 => 'Rápido';

  @override
  String get legacyUiadc7ac2ae5 => 'Mais rápido';

  @override
  String get legacyUib0f47aaf77 => 'Favicon';

  @override
  String get legacyUi7d9baea15f => 'Favicon atualizado';

  @override
  String get legacyUi2c3cafa4db => 'Arquivo';

  @override
  String get legacyUi55fee60744 => 'A URL do arquivo não está disponível.';

  @override
  String get legacyUif76f22f075 => 'O arquivo excede o limite de 10 MB.';

  @override
  String get legacyUi7e184124be => 'O arquivo é obrigatório.';

  @override
  String get legacyUi36f2202687 => 'O arquivo deve ter no máximo 10 MB.';

  @override
  String get legacyUi937fd74b36 => 'Filtrar cartões SIM';

  @override
  String get legacyUi15db08d15e => 'Filtrar registros de atividade';

  @override
  String get legacyUi582198fab2 => 'Filtrar administradores';

  @override
  String get legacyUi9911a4c0ed => 'Filtrar dispositivos';

  @override
  String get legacyUi6a7fe2dc2c => 'Filtrar motoristas';

  @override
  String get legacyUi5439ccf95d => 'Filtrar cercas virtuais';

  @override
  String get legacyUif1fe9835a2 => 'Filtrar equipe';

  @override
  String get legacyUi8cfc14a859 => 'Filtrar usuários';

  @override
  String get legacyUia9d1432d0d => 'Filtrar veículos';

  @override
  String get legacyUiaa234fb61d => 'Firebase';

  @override
  String get legacyUib15839eae8 => 'Firebase inicializado';

  @override
  String get legacyUi916a78d701 => 'Primeiro';

  @override
  String get legacyUic617ebad3b =>
      'Corrija os erros de validação antes de testar';

  @override
  String get legacyUi4d4e9621c4 => 'Status da frota';

  @override
  String get legacyUi1cc8d18151 => 'Esqueceu a senha?';

  @override
  String get legacyUibaa0e2872d => 'Créditos gratuitos de cadastro';

  @override
  String get legacyUi236ddee138 => 'Do administrador';

  @override
  String get legacyUi19fe826cc8 => 'E-mail do remetente';

  @override
  String get legacyUi64346b483c => 'Nome completo';

  @override
  String get legacyUi9f8ce19bf4 => 'Endereço completo';

  @override
  String get legacyUieeb692087d => 'Nome completo';

  @override
  String get legacyUifcee5b52cc => 'Diferença em relação ao GMT';

  @override
  String get legacyUi590df4df1f =>
      'A diferença em relação ao GMT deve usar o formato +05:30.';

  @override
  String get legacyUi0933ed5657 => 'Modelo GPS';

  @override
  String get legacyUicbb0014411 => 'Posto de combustível';

  @override
  String get legacyUifc45f9b7a9 => 'Gerar';

  @override
  String get legacyUi549f31c53e => 'Gerar rota';

  @override
  String get legacyUidfde035f40 => 'Geocodificação';

  @override
  String get legacyUi5cdf1dbd7e => 'Cercas virtuais';

  @override
  String get legacyUic09b487feb => 'Carregar reprodução';

  @override
  String get legacyUi5442e2b64f => 'GitHub';

  @override
  String get legacyUi1efbf15894 =>
      'Agrupar veículos próximos nos níveis de zoom mais afastados';

  @override
  String get legacyUiac69db7d02 => 'Gráfico de crescimento';

  @override
  String get legacyUibc4359231d => 'Academia';

  @override
  String get legacyUifa8a6b01e3 => 'Cabeçalho copiado';

  @override
  String get legacyUi071c1366b0 => 'Maior precisão requer mais consultas.';

  @override
  String get legacyUi90ccd64974 => 'Histórico';

  @override
  String get legacyUic3669ffe53 =>
      'O histórico requer um veículo com IMEI na telemetria ao vivo.';

  @override
  String get legacyUi8d4a22ea2b => 'Os valores do histórico não são numéricos.';

  @override
  String get legacyUidbb927867e => 'Hospital';

  @override
  String get legacyUi3960ec4ca5 => 'Servidor';

  @override
  String get legacyUiadd03be31a => 'Servidor, porta e criptografia.';

  @override
  String get legacyUi9c4ba7d047 => 'Hotel';

  @override
  String get legacyUi1e3beed01c =>
      'Tempo de retenção dos dados históricos antes da limpeza.';

  @override
  String get legacyUi2635a51635 =>
      'Como o administrador será identificado na plataforma.';

  @override
  String get legacyUi0f053057ee =>
      'Como o usuário será identificado na plataforma.';

  @override
  String get legacyUi077f5f9dad => 'Já tenho um link de redefinição';

  @override
  String get legacyUibff7cfa991 => 'ICCID (opcional)';

  @override
  String get legacyUidc7458a51a =>
      'É necessário um IMEI para carregar os registros de telemetria.';

  @override
  String get legacyUif4c88fb92e =>
      'É necessário um IMEI para carregar os eventos do veículo.';

  @override
  String get legacyUi7e77081c51 => 'É necessário um IMEI para enviar comandos.';

  @override
  String get legacyUif44426c787 =>
      'O IMEI deste veículo não está disponível. Exibindo apenas o resumo do mapa ao vivo.';

  @override
  String get legacyUi8a4b9cf4a9 => 'IMEI ausente';

  @override
  String get legacyUi11da2cb7f0 => 'IMSI (opcional)';

  @override
  String get legacyUi716f63b96e => 'Ícone';

  @override
  String get legacyUi7e5a975b6a => 'Identidade';

  @override
  String get legacyUi2d40c36445 => 'Ignição';

  @override
  String get legacyUif2d738d99c => 'Origem da ignição';

  @override
  String get legacyUi4157fc56ab => 'Imagem muito grande. Máximo de 2 MB.';

  @override
  String get legacyUifcf7141427 => 'Imagem muito grande. Máximo de 5 MB.';

  @override
  String get legacyUieeec98db23 => 'Importar CSV';

  @override
  String get legacyUieebd26ef51 => 'Inativo - 48 h';

  @override
  String get legacyUi4b631f6984 => 'Informações';

  @override
  String get legacyUi29981bf033 =>
      'Saldo inicial de créditos atribuído a esta conta de administrador.';

  @override
  String get legacyUi58984ab1ac => 'Créditos iniciais';

  @override
  String get legacyUi5721bbef40 => 'Instagram';

  @override
  String get legacyUi9b5ca633e8 => 'Créditos insuficientes na conta';

  @override
  String get legacyUi2ab95a4afe => 'ID de administrador inválido.';

  @override
  String get legacyUicfa3e9c7e1 => 'Item de estoque criado.';

  @override
  String get legacyUi32091e3797 => 'Status do estoque';

  @override
  String get legacyUia430dcf58c => 'Jane Smith';

  @override
  String get legacyUi049874e4f7 => 'KML copiado para a área de transferência';

  @override
  String get legacyUi62fc561458 => 'Manter solicitação';

  @override
  String get legacyUic67dd20ee8 => 'Chave';

  @override
  String get legacyUi52c4afe84f => 'Editor de locais';

  @override
  String get legacyUid1c69a859a => 'Último';

  @override
  String get legacyUi43df3046ba => 'Última alteração';

  @override
  String get legacyUi7a78ad49d8 => 'Receita do mês anterior';

  @override
  String get legacyUicec3d948d9 => 'Último pagamento';

  @override
  String get legacyUiada1b72559 => 'Última verificação';

  @override
  String get legacyUi43dab84ff6 => 'Último login';

  @override
  String get legacyUib916a123cc => 'Receita do mês anterior';

  @override
  String get legacyUi76c1ed9309 => 'Semana passada';

  @override
  String get legacyUieb3a622ae8 => 'Lat. / Long.';

  @override
  String get legacyUi1e5421b5bc => 'Lat./Long.';

  @override
  String get legacyUidecd7ca800 => 'Mais recente';

  @override
  String get legacyUiefaed3a1b0 => 'Deixe em branco para manter a senha atual';

  @override
  String get legacyUib8100f5ba8 => 'Biblioteca';

  @override
  String get legacyUi3229609e15 => 'Licença';

  @override
  String get legacyUi99929a05d8 => 'Licença bloqueada';

  @override
  String get legacyUi7452738cf9 => 'Licença emitida';

  @override
  String get legacyUibbe96bcfaa => 'Licença utilizada';

  @override
  String get legacyUib957e7bd7b => 'Licença bloqueada';

  @override
  String get legacyUiee92c8a4b6 => 'Licenças';

  @override
  String get legacyUi6731d7cd1a => 'Logotipo para tema claro';

  @override
  String get legacyUi6a1c6c8807 => 'Logotipo para tema claro atualizado';

  @override
  String get legacyUi24d948e4bd => 'Limite';

  @override
  String get legacyUied1ed2b68d => 'Link copiado.';

  @override
  String get legacyUi36d1b59b88 =>
      'Vincule o veículo a um usuário principal, dispositivo GPS e plano de preços.';

  @override
  String get legacyUi6b6390a441 => 'LinkedIn';

  @override
  String get legacyUi4ac08d16b8 => 'Carregar mensagens anteriores';

  @override
  String get legacyUidfe60ca92e => 'Carregar mais';

  @override
  String get legacyUifc53db81a0 => 'Carregar mais do servidor';

  @override
  String get legacyUi949d7ee41c => 'Carregar anteriores';

  @override
  String get legacyUi6db90a0ab6 => 'Carregado';

  @override
  String get legacyUi326ad2f9f8 => 'Carregando veículos atribuídos';

  @override
  String get legacyUi8936529136 => 'Carregando veículos disponíveis';

  @override
  String get legacyUi9f1e0ce448 => 'Carregando documentos';

  @override
  String get legacyUide261e9b89 => 'Carregando registros';

  @override
  String get legacyUi324989adf0 => 'Carregando sensores';

  @override
  String get legacyUid219c68101 => 'Localização';

  @override
  String get legacyUi2350df02c2 => 'Detalhes do registro';

  @override
  String get legacyUiaacbd6aa68 => 'ID do registro';

  @override
  String get legacyUia3d749050e => 'Entrar como usuário';

  @override
  String get legacyUi31a519ee99 =>
      'Alterações de login, senha ou status da conta aparecerão aqui.';

  @override
  String get legacyUi16b583cf21 => 'Registros indisponíveis';

  @override
  String get legacyUi4c57f0c88d => 'Londres';

  @override
  String get legacyUi3bf98fa618 => 'Marcar como lido';

  @override
  String get legacyUia95e85aed5 => 'Máx.';

  @override
  String get legacyUi35f72dc38d => 'Velocidade máxima';

  @override
  String get legacyUi03a68b7d8b => 'Uso de memória';

  @override
  String get legacyUi68f4145fee => 'Mensagem';

  @override
  String get legacyUi54a144c1dd => 'Envio de mensagens';

  @override
  String get legacyUi23b9e4546e =>
      'Envie uma mensagem ao gestor da sua frota aqui.';

  @override
  String get legacyUi8d546a6dea => 'Metadados';

  @override
  String get legacyUi251edc0eb5 => 'Metadados';

  @override
  String get legacyUic0b8960edf => 'Metadados copiados';

  @override
  String get legacyUi7eb0cee888 => 'Mín.';

  @override
  String get legacyUib6bcd4535a => 'Mínimo de 3 caracteres…';

  @override
  String get legacyUi925c181c00 => 'Mínimo de 6 caracteres';

  @override
  String get legacyUi092f99ea11 => 'Minutos';

  @override
  String get legacyUib1d7024593 => 'Celular';

  @override
  String get legacyUia0d9c28a1e => 'Celular (opcional)';

  @override
  String get legacyUi5968acfb01 => 'Número de celular';

  @override
  String get legacyUic242b24d94 => 'Prefixo de celular';

  @override
  String get legacyUi802cdad736 => 'Notificações push';

  @override
  String get legacyUi00618b3856 => 'Celular e e-mail usados para comunicação.';

  @override
  String get legacyUi5d96299833 => 'Número de celular (opcional)';

  @override
  String get legacyUi2ab961738f => 'Prefixo de celular';

  @override
  String get legacyUi90ee975346 => 'Prefixo de celular (opcional)';

  @override
  String get legacyUiaa6630b79b =>
      'Nova tentativa de registro das notificações push concluída.';

  @override
  String get legacyUia1e34f9157 => 'Mais ações';

  @override
  String get legacyUi86c0a35ec8 => 'Mais opções';

  @override
  String get legacyUi69d9f3e5ae => 'Museu';

  @override
  String get legacyUi4ff2aa7688 => 'Meus chamados';

  @override
  String get legacyUi2e65b706ae => 'Nome e código são obrigatórios.';

  @override
  String get legacyUi1eee3afea2 => 'Navegar';

  @override
  String get legacyUiccfb5f0286 => 'Novo POI';

  @override
  String get legacyUi4894cb39ee => 'Nova senha';

  @override
  String get legacyUidcaa5db473 => 'Novo chamado';

  @override
  String get legacyUib85e445f60 => 'Novo usuário';

  @override
  String get legacyUia273c96341 => 'Novo veículo';

  @override
  String get legacyUie0725b6664 => 'Nova cerca virtual';

  @override
  String get legacyUif39fa269a9 => 'Nova rota';

  @override
  String get legacyUi395e182389 => 'Novos usuários aparecerão aqui.';

  @override
  String get legacyUi2213317245 => 'Novos veículos aparecerão aqui.';

  @override
  String get legacyUi4bfc194b68 => 'Próxima página';

  @override
  String get legacyUi1097b553dc => 'Noite';

  @override
  String get legacyUi4276e6ab2a => 'Sem dados';

  @override
  String get legacyUi3de93f521b => 'Sem dispositivo';

  @override
  String get legacyUi79858167e6 => 'Nenhum POI ainda';

  @override
  String get legacyUia434e9985c => 'Sem provedor';

  @override
  String get legacyUi7094ba4f01 =>
      'Nenhuma atribuição ativa. Novas viagens aparecerão aqui quando a central as atribuir.';

  @override
  String get legacyUia9206f399a => 'Nenhum registro de atividade';

  @override
  String get legacyUi8bd5b910e5 => 'Nenhum registro de atividade encontrado';

  @override
  String get legacyUic38a37a193 => 'Nenhuma atividade corresponde aos filtros.';

  @override
  String get legacyUibff9905096 => 'Nenhuma atividade registrada ainda.';

  @override
  String get legacyUi0f5cca70f8 => 'Nenhum administrador encontrado';

  @override
  String get legacyUi31d3df94ab => 'Nenhum administrador encontrado.';

  @override
  String get legacyUic0d322c2b0 => 'Sem dados de adoção';

  @override
  String get legacyUie5d64448e5 => 'Nenhum alerta';

  @override
  String get legacyUi501176c9f8 => 'Sem dados de análise';

  @override
  String get legacyUi63f5349bb8 => 'Nenhum usuário atribuído';

  @override
  String get legacyUi852751d61f => 'Nenhum veículo atribuído';

  @override
  String get legacyUi7546829892 => 'Nenhuma atividade de cobrança encontrada.';

  @override
  String get legacyUi657275c0c1 => 'Nenhuma cidade disponível para este estado';

  @override
  String get legacyUia130e0f01b => 'Sem histórico de comandos';

  @override
  String get legacyUi92db635f14 => 'Nenhum comando ainda';

  @override
  String get legacyUi14a4bfc72c => 'Nenhuma viagem concluída neste mês.';

  @override
  String get legacyUiee9c2e1df0 => 'Sem configuração';

  @override
  String get legacyUic3017a3316 => 'Nenhuma conversa ainda';

  @override
  String get legacyUic140165b8f => 'Sem histórico de créditos ainda.';

  @override
  String get legacyUic8114767e8 => 'Nenhum painel configurado';

  @override
  String get legacyUi7be70212b0 =>
      'Sem dados diurnos ou noturnos para este período.';

  @override
  String get legacyUi2a4eb69350 => 'Sem detalhes';

  @override
  String get legacyUi03ca0261ac => 'Sem dispositivo';

  @override
  String get legacyUi893d388d16 =>
      'Nenhum dispositivo atribuído a este veículo.';

  @override
  String get legacyUi8386fe15ef => 'Nenhum documento';

  @override
  String get legacyUi017ce6604c => 'Nenhum documento enviado';

  @override
  String get legacyUiec7eb3c93e => 'Nenhum documento enviado ainda.';

  @override
  String get legacyUi54e1079e44 =>
      'Nenhum documento ainda. Envie o primeiro usando o botão de envio.';

  @override
  String get legacyUia419748e62 => 'Nenhuma atividade de motorista encontrada.';

  @override
  String get legacyUi98e6629503 =>
      'Nenhum tipo de documento de motorista configurado. Peça ao administrador para adicionar um.';

  @override
  String get legacyUi36f5cbf894 => 'Nenhum documento de motorista';

  @override
  String get legacyUic5dc9718a6 => 'Nenhum motorista';

  @override
  String get legacyUi7a127d70b3 => 'Nenhum motorista disponível';

  @override
  String get legacyUi9c8198d34d => 'Nenhum motorista encontrado';

  @override
  String get legacyUi208ffc64d1 => 'Nenhum detalhe de evento encontrado';

  @override
  String get legacyUiec11a02374 =>
      'Nenhum evento corresponde ao período e aos filtros selecionados.';

  @override
  String get legacyUia48cbba615 => 'Nenhum evento encontrado';

  @override
  String get legacyUi81ab95b9f0 => 'Nenhum evento ainda';

  @override
  String get legacyUi774a252215 => 'Nenhum arquivo disponível.';

  @override
  String get legacyUi35f65e1e57 => 'Nenhuma cerca virtual disponível.';

  @override
  String get legacyUi019549899f => 'Nenhuma cerca virtual ainda';

  @override
  String get legacyUi5358cec56d => 'Nenhum ponto de histórico';

  @override
  String get legacyUia0ed9c8031 =>
      'Nenhum ponto de histórico para este período.';

  @override
  String get legacyUi8bf09d954a => 'Nenhum veículo vinculado disponível';

  @override
  String get legacyUif48787eb30 => 'Nenhum registro encontrado';

  @override
  String get legacyUi6b68d448a0 =>
      'Nenhum registro encontrado para este veículo';

  @override
  String get legacyUic7462a9dac => 'Nenhum registro ainda';

  @override
  String get legacyUi1db215fbaa => 'Nenhum resultado para sua busca.';

  @override
  String get legacyUia734fde29a => 'Nenhum POI correspondente';

  @override
  String get legacyUi2d928306c1 => 'Nenhum motorista correspondente';

  @override
  String get legacyUid6e8839481 => 'Nenhuma cerca virtual correspondente';

  @override
  String get legacyUif6830db2e7 => 'Nenhum registro correspondente';

  @override
  String get legacyUi748bd377da => 'Nenhum registro correspondente';

  @override
  String get legacyUi6590e5eab8 => 'Nenhuma rota correspondente';

  @override
  String get legacyUid17e9558cf => 'Nenhum subusuário correspondente';

  @override
  String get legacyUif1d8690cd7 =>
      'Nenhum veículo correspondente encontrado. Tente outra busca ou filtro.';

  @override
  String get legacyUic04921f8d9 => 'Nenhuma mensagem ainda';

  @override
  String get legacyUi2449a03436 => 'Sem dados de modalidade';

  @override
  String get legacyUi50806db52e =>
      'Nenhuma configuração de notificação encontrada';

  @override
  String get legacyUic1f531f996 => 'Nenhum pagamento encontrado';

  @override
  String get legacyUiaf4a7f06d0 => 'Nenhum plano encontrado';

  @override
  String get legacyUi4ae157aff3 => 'Nenhum alerta recente.';

  @override
  String get legacyUi26776d0320 => 'Nenhum usuário recente';

  @override
  String get legacyUi42ec1ecf96 => 'Nenhum veículo recente';

  @override
  String get legacyUi9833364a35 => 'Nenhuma rota disponível.';

  @override
  String get legacyUid233dd5d9f => 'Nenhuma rota ainda';

  @override
  String get legacyUic9bfb1492b => 'Nenhuma atividade de segurança encontrada.';

  @override
  String get legacyUid07b6b93d6 => 'Nenhum veículo selecionável';

  @override
  String get legacyUi5653bf7251 => 'Nenhum ponto de sensor para este período.';

  @override
  String get legacyUi1ef59c9c2b => 'Nenhum sensor';

  @override
  String get legacyUi3c30b80f16 =>
      'Nenhum sensor configurado para este veículo.';

  @override
  String get legacyUicbae766d34 =>
      'Nenhuma atividade de configuração encontrada.';

  @override
  String get legacyUicd0c79d188 => 'Nenhum link de compartilhamento';

  @override
  String get legacyUi9eac2f6695 => 'Nenhum estado disponível para este país';

  @override
  String get legacyUid05ab60501 => 'Sem dados de status';

  @override
  String get legacyUi4b78e836ec => 'Nenhum subusuário';

  @override
  String get legacyUib30adf9758 => 'Nenhum subusuário disponível';

  @override
  String get legacyUi3a1fa8f145 => 'Nenhum membro da equipe encontrado';

  @override
  String get legacyUi12c6f10a41 => 'Nenhum detalhe de telemetria encontrado';

  @override
  String get legacyUi429d6e6ece => 'Nenhum registro de telemetria encontrado';

  @override
  String get legacyUiea04e18b66 =>
      'Nenhum ativo em destaque para este período.';

  @override
  String get legacyUi48d2d8da35 => 'Nenhuma transação';

  @override
  String get legacyUid60c045dd2 => 'Nenhuma transação encontrada';

  @override
  String get legacyUif794b6c6d1 => 'Nenhuma transação ainda.';

  @override
  String get legacyUi8d92589518 => 'Sem dados de tendência';

  @override
  String get legacyUi7d3e5f72b8 => 'Nenhuma viagem nesta visualização.';

  @override
  String get legacyUib4c96ae04e => 'Nenhum usuário sem vínculo encontrado.';

  @override
  String get legacyUi4b3155e704 =>
      'Nenhum usuário sem vínculo corresponde à busca.';

  @override
  String get legacyUid9c71203a5 =>
      'Sem dados de uso para o período selecionado.';

  @override
  String get legacyUic4b060bd59 => 'Nenhum usuário';

  @override
  String get legacyUi5cc2b29f54 => 'Nenhum usuário atribuído';

  @override
  String get legacyUi3b614a59c7 => 'Nenhum usuário disponível';

  @override
  String get legacyUi612eb3c64c => 'Nenhum usuário encontrado';

  @override
  String get legacyUie611ef5702 => 'Nenhum usuário encontrado.';

  @override
  String get legacyUif800dfd722 =>
      'Nenhum trajeto GPS ou marcador de parada válido foi retornado.';

  @override
  String get legacyUib96ee669b0 => 'Nenhuma atividade de veículo encontrada.';

  @override
  String get legacyUi748eafd21d => 'Nenhum veículo';

  @override
  String get legacyUi8fbc8deb7a =>
      'Nenhum veículo visível no mapa neste momento.';

  @override
  String get legacyUi72ed5bbcdf => 'Nenhum veículo atribuído ainda.';

  @override
  String get legacyUi7223e6b8cb => 'Nenhum veículo atribuído.';

  @override
  String get legacyUiac0e4dbd5b => 'Nenhum veículo disponível';

  @override
  String get legacyUic578cfdbd5 => 'Nenhum veículo encontrado';

  @override
  String get legacyUie1de5f8ce2 => 'Nenhum veículo corresponde à busca.';

  @override
  String get legacyUia41b297cf1 => 'Sem dados de comparação semanal.';

  @override
  String get legacyUi35163920f3 => 'Nenhum widget configurado';

  @override
  String get legacyUi45e118d056 => 'Normal';

  @override
  String get legacyUif8e45b2be2 => 'Norte';

  @override
  String get legacyUi2c924e3088 => 'Observação';

  @override
  String get legacyUi2fd5716446 => 'Observações (opcional)';

  @override
  String get legacyUicf62dbc83d => 'Observações / Descrição';

  @override
  String get legacyUi3e56dbb775 => 'Observações sobre este documento';

  @override
  String get legacyUi7faf33fcca => 'Nada para exportar';

  @override
  String get legacyUi76544814eb => 'Ações de notificação';

  @override
  String get legacyUi4eb32de6c9 => 'Configurações de notificação salvas.';

  @override
  String get legacyUi8ca2cb9290 => 'Odômetro';

  @override
  String get legacyUi6c3a72eaf6 => 'Escritório';

  @override
  String get legacyUi63f34dd211 => 'Mais antigos';

  @override
  String get legacyUi35c5d4307a => 'Linhas anteriores';

  @override
  String get legacyUi9f8f7411e8 =>
      'Um ou mais veículos selecionados são inválidos.';

  @override
  String get legacyUie81cd61ea1 =>
      'Somente veículos atribuídos ao usuário podem ser compartilhados.';

  @override
  String get legacyUicf9b77061f => 'Abrir';

  @override
  String get legacyUi8f5f529938 => 'Abrir / salvar';

  @override
  String get legacyUi55d00c31ab => 'Abrir veículos';

  @override
  String get legacyUicc6b7ec50c => 'Abrir CSV de linhas com falha';

  @override
  String get legacyUi99bd9c01d7 => 'Notificações OpenVTS';

  @override
  String get legacyUic1b94f880c => 'Valor opcional';

  @override
  String get legacyUi7afdcf3257 => 'E-mail opcional';

  @override
  String get legacyUic553137ef5 => 'Celular opcional';

  @override
  String get legacyUi410d481882 => 'Observações opcionais';

  @override
  String get legacyUi4f8f9c2bba => 'Comprovante ou observação opcional';

  @override
  String get legacyUi3494a60f96 => 'Nome de usuário opcional';

  @override
  String get legacyUia493c04fb5 => 'Opcional; digite pelo menos 3 caracteres';

  @override
  String get legacyUi6bf5da9c08 => 'Opções';

  @override
  String get legacyUidefe0db589 => 'Ordenar por';

  @override
  String get legacyUi6e6a6f2086 => 'Outro';

  @override
  String get legacyUi4bed336194 => 'Saída';

  @override
  String get legacyUi9e339da256 => 'Alerta de excesso de velocidade ativado';

  @override
  String get legacyUi0efc2e6be4 => 'Visão geral';

  @override
  String get legacyUi3e90e4cbf4 => 'Titularidade';

  @override
  String get legacyUi07afcc61d8 => 'Tipo de pacote';

  @override
  String get legacyUif92c24e8df => 'Parque';

  @override
  String get legacyUi07ba1bef85 => 'Partes envolvidas';

  @override
  String get legacyUi8be3c943b1 => 'Senha';

  @override
  String get legacyUi408255ed02 => 'Senha (opcional)';

  @override
  String get legacyUi092a16e7af => 'Senha alterada';

  @override
  String get legacyUi47fa528931 => 'Senha alterada.';

  @override
  String get legacyUi3efdbb2011 => 'Senha atualizada.';

  @override
  String get legacyUi8ac0c75d5e =>
      'Cole o link completo de redefinição ou o token recebido por e-mail. Os links são de uso único e expiram automaticamente.';

  @override
  String get legacyUi5616b61bb7 => 'Dados JSON';

  @override
  String get legacyUif8c3596eab => 'Os dados devem ser um objeto JSON válido.';

  @override
  String get legacyUi23b35c414a => 'Forma de pagamento';

  @override
  String get legacyUi670d2a76c7 => 'Forma de pagamento *';

  @override
  String get legacyUi662210d869 => 'Distribuição por forma de pagamento';

  @override
  String get legacyUia629fd8a2e => 'Tipo de pagamento';

  @override
  String get legacyUi43f8c9c90f =>
      'As atividades de pagamento aparecerão aqui.';

  @override
  String get legacyUi8fbf2ec0dd => 'Forma de pagamento';

  @override
  String get legacyUi653c04fc42 =>
      'A distribuição por forma de pagamento não está disponível para este período.';

  @override
  String get legacyUidbc3c0ca72 => 'Pagamento registrado';

  @override
  String get legacyUi197b45d161 => 'Referência do pagamento';

  @override
  String get legacyUi96f608c16c => 'Pendente';

  @override
  String get legacyUid1240d2832 => 'Pendente / Falhou';

  @override
  String get legacyUi9126c119ae => 'Pagamentos pendentes';

  @override
  String get legacyUib4ebfb2f75 => 'Pagamentos pendentes';

  @override
  String get legacyUi167a47ff3e => 'Realizado por';

  @override
  String get legacyUi1785713451 => 'Permissão';

  @override
  String get legacyUid06d555709 => 'Permissões';

  @override
  String get legacyUi1e99c04657 => 'Permissões atualizadas';

  @override
  String get legacyUi0219adf447 => 'Dados pessoais e endereço';

  @override
  String get legacyUib1b9e59387 => 'Informações pessoais';

  @override
  String get legacyUi77064d5265 => 'Telefone';

  @override
  String get legacyUi26730cddc4 => 'Selecionar CSV';

  @override
  String get legacyUif2c5ca7b8c => 'CEP';

  @override
  String get legacyUifd25c49d56 => 'CEP (opcional)';

  @override
  String get legacyUiae2f98a099 => 'Plano';

  @override
  String get legacyUiec0632cbbf => 'Nome do plano';

  @override
  String get legacyUi2b366a2f95 => 'Preço do plano';

  @override
  String get legacyUi7f97f6a268 => 'Plano criado e selecionado';

  @override
  String get legacyUi2db331cefa => 'Placa';

  @override
  String get legacyUi7d86677521 => 'Número da placa';

  @override
  String get legacyUia6b7aa4d9c => 'Número da placa (opcional)';

  @override
  String get legacyUif2ce282e2d => 'Número da placa';

  @override
  String get legacyUi09d9c23846 => 'Número da placa (opcional)';

  @override
  String get legacyUi123a7f2fcc => 'Plataforma';

  @override
  String get legacyUi16596c477e =>
      'Comportamento da plataforma, cadastro, geocodificação e retenção.';

  @override
  String get legacyUid095e279b3 =>
      'Corrija os campos destacados antes de continuar.';

  @override
  String get legacyUi51668149ea => 'Selecione um administrador.';

  @override
  String get legacyUife035157cd => 'Porta';

  @override
  String get legacyUi16c2eb4dbb => 'Portas';

  @override
  String get legacyUib629d4165b => 'Código postal / CEP';

  @override
  String get legacyUib86b6a2b3b => 'Código postal (opcional)';

  @override
  String get legacyUi90eceb016c => 'Prefixo';

  @override
  String get legacyUif1fbb2b43d => 'Prévia';

  @override
  String get legacyUiba3e0b4a86 => 'Prévia atualizada';

  @override
  String get legacyUi81f547195b => 'Página anterior';

  @override
  String get legacyUi3e8248e32e => 'Preço';

  @override
  String get legacyUi15ac0c0a27 => 'Plano de preços';

  @override
  String get legacyUid3dcce7d10 => 'Cor principal';

  @override
  String get legacyUi170f443f36 => 'Usuário principal';

  @override
  String get legacyUia1055f11a9 => 'Cor principal';

  @override
  String get legacyUic1ee865b42 => 'Cor principal (hexadecimal)';

  @override
  String get legacyUi0554f68465 => 'Usuário principal';

  @override
  String get legacyUi1e5947a051 =>
      'Usuário principal, dispositivo, tipo de veículo e plano de preços são obrigatórios.';

  @override
  String get legacyUi886cbff9d9 => 'Prioridade';

  @override
  String get legacyUi7e7302bb73 => 'O perfil ainda não foi carregado.';

  @override
  String get legacyUi5049e8f42b => 'Foto do perfil atualizada';

  @override
  String get legacyUi49ba5b4d7b => 'Configurações do perfil indisponíveis';

  @override
  String get legacyUibcf7629607 => 'Perfil atualizado.';

  @override
  String get legacyUibda244507b =>
      'Alterações de perfil, empresa ou configuração aparecerão aqui.';

  @override
  String get legacyUi204be1a53a => 'Projetado';

  @override
  String get legacyUi5c620cdb78 => 'Tipo de comprovante';

  @override
  String get legacyUi1ed77c3f7f => 'Protocolo';

  @override
  String get legacyUi7ceee3f361 => 'Provedor';

  @override
  String get legacyUi767359109d => 'Referência do provedor';

  @override
  String get legacyUi8d80f9c731 => 'Cobertura do provedor expira em';

  @override
  String get legacyUi8a87202949 => 'A URL pública não está disponível.';

  @override
  String get legacyUi411c13db3b =>
      'Cadastro público e créditos de boas-vindas.';

  @override
  String get legacyUicf0a64d03d =>
      'Puxe para atualizar e tente carregar seu perfil novamente.';

  @override
  String get legacyUic8f58b21ae =>
      'Puxe para atualizar ou adicione um motorista.';

  @override
  String get legacyUi011bc421c2 => 'Puxe para atualizar ou crie um subusuário.';

  @override
  String get legacyUi6a599877d7 => 'Na fila';

  @override
  String get legacyUia16c5bbe4b => 'Intervalo';

  @override
  String get legacyUida433cd41e => 'Bruto';

  @override
  String get legacyUice09c15f57 => 'Pacote bruto';

  @override
  String get legacyUia3ccb33027 => 'Razorpay';

  @override
  String get legacyUi2af51c3e17 => 'Digite a senha novamente';

  @override
  String get legacyUi852b438f91 => 'Lido';

  @override
  String get legacyUid14d593883 => 'Marcar todos como lidos';

  @override
  String get legacyUi00db810078 => 'Motivo do ajuste';

  @override
  String get legacyUid4835a2d13 =>
      'Motivo do valor personalizado (5 a 500 caracteres)';

  @override
  String get legacyUi03c3ccd3ff => 'Alertas recentes';

  @override
  String get legacyUi3abf211c93 => 'Pagamentos recentes';

  @override
  String get legacyUi93c62de33f => 'Usuários recentes';

  @override
  String get legacyUi6b33999078 => 'Veículos recentes';

  @override
  String get legacyUi790a1b9e7b =>
      'As atividades recentes aparecerão aqui quando forem retornadas pelo servidor.';

  @override
  String get legacyUic1541851a1 => 'Atividades recentes de serviço';

  @override
  String get legacyUi204110a010 =>
      'Os usuários recentes aparecerão aqui quando forem retornados pelo resumo do painel.';

  @override
  String get legacyUida67fde0f7 => 'Centralizar';

  @override
  String get legacyUi7df7c0bb40 => 'E-mail do destinatário';

  @override
  String get legacyUi8ee92c936a => 'Destinatário/Usuário';

  @override
  String get legacyUi6577ced3c0 => 'Registrar pagamento';

  @override
  String get legacyUib19313692e => 'Registrado por';

  @override
  String get legacyUi471b94d402 => 'Refazer';

  @override
  String get legacyUidb1c784524 => 'Referência';

  @override
  String get legacyUic9dc8442d5 => 'Referência (opcional)';

  @override
  String get legacyUie3039b8476 => 'Referência (opcional)';

  @override
  String get legacyUid8b2ee1dcd =>
      'A referência deve ter no máximo 200 caracteres';

  @override
  String get legacyUi7a8e2a362c =>
      'A referência deve ter no máximo 100 caracteres.';

  @override
  String get legacyUi483e715402 => 'Atualizar administradores';

  @override
  String get legacyUif2b5787c06 => 'Atualizar painel';

  @override
  String get legacyUie75f05fced => 'Atualizar motoristas';

  @override
  String get legacyUiebbc55f9ce => 'Atualizar histórico';

  @override
  String get legacyUid0512701b2 => 'Atualizar estoque';

  @override
  String get legacyUif6cf59106a => 'Atualizar mensagens';

  @override
  String get legacyUid7cb2b4eea => 'Atualizar opções do relatório';

  @override
  String get legacyUi323540a087 => 'Atualizar configurações';

  @override
  String get legacyUiade15a52e2 => 'Atualizar status';

  @override
  String get legacyUie4d3b8b5ff => 'Atualizar equipe';

  @override
  String get legacyUi12f92ceb6e => 'Atualizar chamados';

  @override
  String get legacyUi3367ca735f => 'Atualizar transações';

  @override
  String get legacyUi892f6f322d => 'Atualizar usuários';

  @override
  String get legacyUidf50facb6a => 'Atualizar veículos';

  @override
  String get legacyUid42d9c1932 => 'Atualizar widget';

  @override
  String get legacyUia844fcf834 => 'Registrado';

  @override
  String get legacyUi9aba73febb => 'Últimos 10 caracteres do token registrado';

  @override
  String get legacyUic498221a5a => 'Data de registro';

  @override
  String get legacyUi20e264f6a1 => 'Parada relacionada';

  @override
  String get legacyUi62d14389b3 => 'Recarregar tipos de documento';

  @override
  String get legacyUia2653dac4a => 'Observação';

  @override
  String get legacyUie963907dac => 'Remover';

  @override
  String get legacyUi0fcc6594fc => 'Remover anexo';

  @override
  String get legacyUi48666118ca => 'Remover linha de metadados';

  @override
  String get legacyUif96ba1e583 =>
      'Remover a atribuição deste veículo ao motorista?';

  @override
  String get legacyUi0165f7088a => 'Renovar';

  @override
  String get legacyUib219a06163 => 'Renovar veículo';

  @override
  String get legacyUi4913250b6c => 'Renovar cobertura anual';

  @override
  String get legacyUif192fe3e94 => 'Renovar cobertura anual?';

  @override
  String get legacyUi1cce449350 => 'Renove até 100 veículos por vez';

  @override
  String get legacyUi714c2b126f => 'Renove até 100 veículos por vez.';

  @override
  String get legacyUibb47b991fe => 'Solicitações de renovação';

  @override
  String get legacyUiac2377c0dd => 'Velocidade de reprodução';

  @override
  String get legacyUi5cc45fda55 =>
      'As respostas aparecerão aqui quando a conversa começar.';

  @override
  String get legacyUid7a41420c8 =>
      'As respostas aparecerão aqui quando a conversa do chamado começar.';

  @override
  String get legacyUi1f21d9edca => 'A resposta é muito longa.';

  @override
  String get legacyUi4c7c79f6a9 => 'A mensagem de resposta é obrigatória.';

  @override
  String get legacyUic9e8dd4159 => 'Resposta enviada.';

  @override
  String get legacyUi5ce1bacd48 => 'Resposta enviada.';

  @override
  String get legacyUi49072e5767 => 'Responder para (opcional)';

  @override
  String get legacyUi6e2c712363 => 'Relatar problema';

  @override
  String get legacyUi0ca4fce136 => 'Tipo de relatório';

  @override
  String get legacyUi4857497af3 => 'Solicitar novo link de redefinição';

  @override
  String get legacyUida30a140cc => 'Solicitar renovação do veículo?';

  @override
  String get legacyUic26bf60fed => 'Solicitado';

  @override
  String get legacyUi1d3cb8a962 => 'Reenviar código';

  @override
  String get legacyUi56553100b0 => 'Redefinir filtros';

  @override
  String get legacyUibb02ea158c => 'Link ou token de redefinição';

  @override
  String get legacyUi3ddc852b26 => 'Reorientar para o norte';

  @override
  String get legacyUi5c4bc97ee5 => 'Redefinir senha';

  @override
  String get legacyUi4f21821190 => 'Respondido';

  @override
  String get legacyUi966ea65ee9 => 'Resposta hexadecimal';

  @override
  String get legacyUi3585d7553d => 'Restaurante';

  @override
  String get legacyUiab6d02bfbb => 'Restrito pelo administrador';

  @override
  String get legacyUic7199d9e95 => 'Retenção';

  @override
  String get legacyUi9393bfa8e2 => 'Período de retenção';

  @override
  String get legacyUibf1c27deea => 'Tentar carregar moedas novamente';

  @override
  String get legacyUi2e84dd3c7d => 'Tentar registrar novamente';

  @override
  String get legacyUic507a566fc => 'Precisão da geocodificação reversa';

  @override
  String get legacyUi7148d08646 => 'Ondulação';

  @override
  String get legacyUic3f104d136 => 'Função';

  @override
  String get legacyUib1b392607d => 'Executar';

  @override
  String get legacyUi26c35575bf => 'Sensor de movimento';

  @override
  String get legacyUiba51f0a9fa => 'Consultar histórico';

  @override
  String get legacyUia84c30c93c => 'Executar limpeza';

  @override
  String get legacyUibd4e4bc9f2 => 'Número do SIM';

  @override
  String get legacyUi135447fb8f => 'Somente SIM';

  @override
  String get legacyUi3454bbef7f => 'Operadora do SIM';

  @override
  String get legacyUi0366e95ddf => 'Operadora do SIM (opcional)';

  @override
  String get legacyUi4636ab9e9a => 'Cartão SIM atualizado.';

  @override
  String get legacyUi12897d0b88 => 'Status do SIM';

  @override
  String get legacyUi1f4f5e7e3c => 'Login da conta SMTP.';

  @override
  String get legacyUi7d08205aa6 => 'Configurações SMTP salvas';

  @override
  String get legacyUia70c3bcf1d => 'São Francisco';

  @override
  String get legacyUi340bbc7875 => 'Satélites';

  @override
  String get legacyUidb95397447 => 'Salvar .kml';

  @override
  String get legacyUifa2984b367 => 'Salvar alterações';

  @override
  String get legacyUi78fe0922d6 => 'Salvar empresa';

  @override
  String get legacyUic6606cd51c => 'Salvar configuração';

  @override
  String get legacyUi909bf3e807 => 'Salvar perfil';

  @override
  String get legacyUif2f3d66a79 => 'Escola';

  @override
  String get legacyUid09c8bca28 => 'Buscar número do SIM…';

  @override
  String get legacyUiabddbf1811 => 'Buscar registros de atividade...';

  @override
  String get legacyUi9a99566535 => 'Buscar atividades…';

  @override
  String get legacyUi1321daf435 => 'Buscar motoristas atribuídos';

  @override
  String get legacyUie6ac2b6800 => 'Buscar veículos atribuídos';

  @override
  String get legacyUi3a97577679 => 'Buscar motoristas disponíveis';

  @override
  String get legacyUiacd1382ab4 => 'Buscar veículos disponíveis';

  @override
  String get legacyUi03ef7546a9 => 'Buscar por IMEI...';

  @override
  String get legacyUia8854d5f97 => 'Buscar por código...';

  @override
  String get legacyUi411482b8e7 =>
      'Buscar por data, atividade, créditos, veículo…';

  @override
  String get legacyUi28abc0313d => 'Buscar por nome';

  @override
  String get legacyUi28f3d064ea => 'Buscar por nome ou categoria';

  @override
  String get legacyUi4120e178da => 'Buscar por nome ou placa…';

  @override
  String get legacyUibb6cfd804d => 'Buscar por nome, e-mail…';

  @override
  String get legacyUi1c1d641fe8 => 'Buscar por nome, placa, IMEI ou VIN';

  @override
  String get legacyUife32b8f32a => 'Buscar por nome, placa, IMEI…';

  @override
  String get legacyUibdc6551409 => 'Buscar por nome, placa, VIN, IMEI, SIM...';

  @override
  String get legacyUiba20cfd893 => 'Buscar por referência ou administrador...';

  @override
  String get legacyUi45b6baaad3 => 'Buscar registros diários...';

  @override
  String get legacyUie43926680a => 'Buscar registros do dispositivo';

  @override
  String get legacyUi26eb1d222b => 'Buscar tipo de dispositivo…';

  @override
  String get legacyUi98110e65a0 => 'Buscar nos registros carregados';

  @override
  String get legacyUi48225af1f4 => 'Buscar registros';

  @override
  String get legacyUi20f28ed35b => 'Buscar nome, IMEI, SIM, tipo';

  @override
  String get legacyUic60723c651 => 'Buscar nome, placa ou IMEI';

  @override
  String get legacyUi3dadc5cddf =>
      'Buscar nome, usuário, e-mail, celular, veículo, placa...';

  @override
  String get legacyUi0417c5f97b => 'Buscar nome, usuário, e-mail, celular...';

  @override
  String get legacyUi5196e5c8da => 'Buscar local ou endereço...';

  @override
  String get legacyUic3290fb221 => 'Buscar local...';

  @override
  String get legacyUi60c8ce351b => 'Buscar planos, moeda, duração, preço...';

  @override
  String get legacyUie5483c71e7 => 'Buscar provedor…';

  @override
  String get legacyUi98e27d7b41 =>
      'Buscar referência, provedor, contraparte...';

  @override
  String get legacyUidd77f6ecc1 =>
      'Buscar referência, provedor, usuário, veículo';

  @override
  String get legacyUi0066a752cb => 'Buscar rotas por nome';

  @override
  String get legacyUi502e6eaf2c => 'Buscar sensores';

  @override
  String get legacyUi0cfffb61af => 'Buscar sensores...';

  @override
  String get legacyUi233ad2b14f => 'Buscar assunto, número, status';

  @override
  String get legacyUid320d41a03 => 'Buscar chamados';

  @override
  String get legacyUi65da39d5f0 => 'Buscar transações...';

  @override
  String get legacyUi25dfae4e3a => 'Buscar viagens';

  @override
  String get legacyUida80ead473 => 'Buscar usuários sem vínculo...';

  @override
  String get legacyUie5b2404515 => 'Buscar usuários, veículos…';

  @override
  String get legacyUi8cdc4c0930 => 'Buscar usuários...';

  @override
  String get legacyUi2e4b72c10c => 'Buscar veículo';

  @override
  String get legacyUi1bd54471c2 => 'Buscar eventos do veículo...';

  @override
  String get legacyUiba537c59ae =>
      'Buscar veículo, placa, VIN, IMEI, SIM, usuário…';

  @override
  String get legacyUi4a54a9e6db => 'Buscar veículo, placa, VIN, IMEI, SIM...';

  @override
  String get legacyUi5780b5d6bf => 'Buscar veículos';

  @override
  String get legacyUi50efae1b5f => 'Buscar veículos por nome, placa, plano...';

  @override
  String get legacyUib09b43245d => 'Buscar veículos...';

  @override
  String get legacyUif54fbca187 => 'Buscar…';

  @override
  String get legacyUifaaee5e23e => 'Selecionar SIM';

  @override
  String get legacyUi69cc521201 => 'Selecione um país';

  @override
  String get legacyUi400a58f1cc =>
      'Selecione um período para carregar o histórico.';

  @override
  String get legacyUie216b735f0 => 'Selecione um usuário primeiro.';

  @override
  String get legacyUie965317576 => 'Selecione um veículo primeiro.';

  @override
  String get legacyUia72bd23c12 =>
      'Selecione um veículo, o limite de parada e o período de data e hora.';

  @override
  String get legacyUi29c9360313 => 'Selecionar administrador';

  @override
  String get legacyUi8a152d2c3f =>
      'Selecione pelo menos um veículo que possa ser renovado';

  @override
  String get legacyUi5573da8514 => 'Selecione pelo menos um veículo.';

  @override
  String get legacyUi42303635fc => 'Selecionar cidade';

  @override
  String get legacyUi9915f6e5c2 => 'Selecionar cor';

  @override
  String get legacyUia96ce92893 => 'Selecionar modelo de comando';

  @override
  String get legacyUi59ee76bad1 => 'Selecionar país';

  @override
  String get legacyUi74c388ab91 => 'Selecionar período de data e hora';

  @override
  String get legacyUi46bfa11b12 => 'Selecionar tipo de dispositivo';

  @override
  String get legacyUidba2e6bd04 => 'Selecionar tipo de documento';

  @override
  String get legacyUi386f8ba9d0 => 'Selecionar usuário principal';

  @override
  String get legacyUic7a9e8ea6a => 'Selecionar provedor';

  @override
  String get legacyUib350802ae1 => 'Selecionar estado';

  @override
  String get legacyUi905d012288 => 'Selecionar tipo';

  @override
  String get legacyUib8a1d9de7d => 'Selecionar usuário';

  @override
  String get legacyUie574e3a29d =>
      'Selecione veículos com a mesma moeda de plano';

  @override
  String get legacyUi07f0f61db9 => 'O arquivo selecionado está vazio.';

  @override
  String get legacyUi9bc2575c39 => 'Enviar';

  @override
  String get legacyUi0ad7c21624 => 'Enviar comando';

  @override
  String get legacyUi9b48248439 => 'Envie um comando para ver o histórico.';

  @override
  String get legacyUi724aa54b02 => 'Enviar comando ao veículo?';

  @override
  String get legacyUic70a890d14 => 'Enviar mensagem';

  @override
  String get legacyUia89d641794 => 'Enviar solicitação';

  @override
  String get legacyUib8ec554332 => 'Enviar link de redefinição';

  @override
  String get legacyUi1aba33d6c2 => 'Enviar teste';

  @override
  String get legacyUifc552c754d => 'Enviar e-mail de teste';

  @override
  String get legacyUi17b874d289 => 'Remetente';

  @override
  String get legacyUi679e8f61b9 => 'Nome do remetente';

  @override
  String get legacyUi73dcba5635 => 'Histórico do sensor';

  @override
  String get legacyUia14460cfb3 => 'Período do histórico do sensor';

  @override
  String get legacyUia9bc44292f => 'Ações do sensor';

  @override
  String get legacyUi18d80b838f => 'Sensor excluído.';

  @override
  String get legacyUi711bf35988 => 'Sensores';

  @override
  String get legacyUi48380dd0e2 => 'Sensores indisponíveis';

  @override
  String get legacyUi35f49dcfbf => 'Enviado';

  @override
  String get legacyUi2d7bb03171 =>
      'Os comandos enviados e as respostas dos dispositivos aparecem aqui.';

  @override
  String get legacyUi1d5d1effa9 => 'URL do servidor';

  @override
  String get legacyUif85e6f1bdc => 'Tempo de atividade do servidor';

  @override
  String get legacyUi10802e852c => 'Hora do servidor';

  @override
  String get legacyUi7ef53dd844 =>
      'A validade do serviço deve ser posterior ao registro.';

  @override
  String get legacyUi2ad34ef4cf => 'Plano de serviço';

  @override
  String get legacyUi2bacd5f581 => 'Início do serviço';

  @override
  String get legacyUiaa02a8d843 => 'Definir horas do motor';

  @override
  String get legacyUi837c0d47b5 => 'Definir odômetro';

  @override
  String get legacyUiaef97bb06a => 'Configurações salvas';

  @override
  String get legacyUi96a0dc481b => 'Compras';

  @override
  String get legacyUi5e65ca08ed => 'Título curto do problema';

  @override
  String get legacyUi4c742d5133 => 'Mostrar cerca virtual';

  @override
  String get legacyUi5abbf34ba3 => 'Mostrar histórico';

  @override
  String get legacyUi8268618610 =>
      'Mostrar pulsação animada ao redor dos veículos em movimento';

  @override
  String get legacyUi25911d48e0 => 'Mostrar mais';

  @override
  String get legacyUi50b47f1483 => 'Mostrar marcadores de pontos de interesse';

  @override
  String get legacyUib7f93469b9 => 'Mostrar trilha da rota';

  @override
  String get legacyUi510904927e =>
      'Mostrar o nome do veículo ao lado do ícone no mapa';

  @override
  String get legacyUi6e61e47d5c =>
      'Exibido em fundos escuros. PNG, JPG, SVG, WEBP. Máximo de 5 MB.';

  @override
  String get legacyUi39e4052ecf =>
      'Exibido em fundos claros. PNG, JPG, SVG, WEBP. Máximo de 5 MB.';

  @override
  String get legacyUi894bc414e6 => 'Cadastro';

  @override
  String get legacyUi69c2037890 => 'Fim da exceção';

  @override
  String get legacyUia8522e4c9d => 'Início da exceção';

  @override
  String get legacyUi33dcec9ce4 => 'Lento';

  @override
  String get legacyUicf606d0913 => 'Mais lento';

  @override
  String get legacyUi339c1ea94b => 'Links de redes sociais';

  @override
  String get legacyUi3db7211438 => 'Ordenar cartões SIM';

  @override
  String get legacyUi66758a74bc => 'Ordenar administradores';

  @override
  String get legacyUi3655295cb4 => 'Ordenar dispositivos';

  @override
  String get legacyUi3a21e72182 => 'Ordenar motoristas';

  @override
  String get legacyUi1e891a0102 => 'Ordenar equipe';

  @override
  String get legacyUi6d1ba980e8 => 'Ordenar usuários';

  @override
  String get legacyUi2512bda9e7 => 'Ordenar veículos';

  @override
  String get legacyUi6da13addb0 => 'Origem';

  @override
  String get legacyUi6ace449732 => 'Sul';

  @override
  String get legacyUi2d2cb022bc => 'Velocidade';

  @override
  String get legacyUi8a14aeec13 => 'Multiplicador de velocidade';

  @override
  String get legacyUid6a0aaa660 => 'Variação de velocidade';

  @override
  String get legacyUi09a7707087 => 'Iniciar manualmente';

  @override
  String get legacyUi7e244fee11 =>
      'O horário inicial deve ser anterior ao final.';

  @override
  String get legacyUia725020675 => 'Estado';

  @override
  String get legacyUi4e5c9805af => 'Estado (opcional)';

  @override
  String get legacyUic01247416e => 'O estado é obrigatório.';

  @override
  String get legacyUiedde30a0b6 => 'Status: ';

  @override
  String get legacyUia0539c7e7a =>
      'A distribuição por status não está disponível para este período.';

  @override
  String get legacyUie4fe064446 => 'Minutos de parada';

  @override
  String get legacyUif32715a2f1 => 'Marcador de parada';

  @override
  String get legacyUi5ca845e914 => 'Rua, edifício, bairro…';

  @override
  String get legacyUi4d08ec5874 => 'Stripe';

  @override
  String get legacyUi8de713bd12 => 'Subusuários';

  @override
  String get legacyUi97a0373212 => 'Subusuário criado.';

  @override
  String get legacyUi5cae4f427b => 'Subusuário excluído.';

  @override
  String get legacyUi2cc74ff5c3 => 'Nome do subusuário';

  @override
  String get legacyUie44d50f72d => 'Subusuário atualizado.';

  @override
  String get legacyUibd3159ff21 => 'O assunto é obrigatório.';

  @override
  String get legacyUi6844979e4f =>
      'O assunto deve conter pelo menos uma letra ou um número.';

  @override
  String get legacyUid6981f7476 => 'Inscrever-se';

  @override
  String get legacyUia547aab586 => 'Inscrito nas atualizações por e-mail';

  @override
  String get legacyUid7932a2917 => 'Bem-sucedido';

  @override
  String get legacyUib879505819 => 'Chamado de suporte';

  @override
  String get legacyUi848eed0fbd => 'Etiquetas';

  @override
  String get legacyUi8c7e01ee22 => 'Etiquetas (separadas por vírgulas)';

  @override
  String get legacyUi1df356a49e =>
      'Toque no mapa ou insira coordenadas para posicionar o POI.';

  @override
  String get legacyUi61ad50a9b9 => 'Destino';

  @override
  String get legacyUi78560d88ef => 'Equipe ativada.';

  @override
  String get legacyUid8f82f6030 => 'Atividade da equipe';

  @override
  String get legacyUi8aef227384 => 'Equipe desativada.';

  @override
  String get legacyUi72df525608 => 'Membro da equipe criado.';

  @override
  String get legacyUi07fed9d9b3 => 'Membro da equipe atualizado.';

  @override
  String get legacyUi0194c31b6d => 'Permissões da equipe atualizadas';

  @override
  String get legacyUi6730423d83 => 'Detalhes de telemetria';

  @override
  String get legacyUieef4095d19 => 'Registros de telemetria';

  @override
  String get legacyUif8d42e6122 => 'Período de telemetria';

  @override
  String get legacyUi3ec1ae061c => 'Modelo';

  @override
  String get legacyUi7200f86ae5 => 'Testar notificações push';

  @override
  String get legacyUi8b9bbdf230 => 'Testar push';

  @override
  String get legacyUi8135cd8fa3 =>
      'O cliente pode criar uma nova solicitação. Nenhum serviço de veículo será prorrogado.';

  @override
  String get legacyUidc46c2859b => 'O link expira automaticamente.';

  @override
  String get legacyUic77eaa41ef =>
      'A organização que este administrador gerencia no OpenVTS.';

  @override
  String get legacyUi461197e42e =>
      'A organização à qual este usuário pertence no OpenVTS.';

  @override
  String get legacyUia491398fbb =>
      'A resposta do resumo ainda não inclui pontos do gráfico.';

  @override
  String get legacyUi214cddfadb =>
      'A resposta do resumo ainda não inclui veículos recentes.';

  @override
  String get legacyUi9e4a7b1c4c =>
      'O catálogo de permissões está indisponível. A edição está desativada.';

  @override
  String get legacyUiac4a475bbb =>
      'O servidor retornou um catálogo de permissões incompatível. A edição está desativada.';

  @override
  String get legacyUi8895c1d4b6 =>
      'O envio foi concluído, mas o servidor não retornou a nova foto do perfil.';

  @override
  String get legacyUidbc2f6bd85 => 'Nenhum alerta disponível neste momento.';

  @override
  String get legacyUi9b519b14b9 => 'Não há eventos neste dia';

  @override
  String get legacyUi354cfe028c =>
      'Estas alterações concedem acesso global ou permissão de exclusão. Aplicar a este membro da equipe?';

  @override
  String get legacyUi0f6cc3a89c => 'Este mês';

  @override
  String get legacyUi77528c94d9 => 'Este ano';

  @override
  String get legacyUi951f495b34 => 'Esta ação não pode ser desfeita.';

  @override
  String get legacyUi9b646010b8 => 'Este tipo de arquivo não é permitido.';

  @override
  String get legacyUi1b4785331d => 'Este mês';

  @override
  String get legacyUi0e606e3993 => 'Este painel salvo ainda não tem widgets.';

  @override
  String get legacyUi1e191e95f4 => 'Este chamado está fechado.';

  @override
  String get legacyUi8866cb1e0a =>
      'Esta ação usa um crédito da conta quando o veículo é elegível.';

  @override
  String get legacyUi7b72883e07 => 'Esta semana';

  @override
  String get legacyUi261bd2f51b => 'Conversa do chamado';

  @override
  String get legacyUie1b858991f => 'Chamado criado.';

  @override
  String get legacyUi61322c9a86 => 'Detalhes do chamado';

  @override
  String get legacyUif1e8e34245 =>
      'Os detalhes do chamado não estão disponíveis';

  @override
  String get legacyUiaa27494c39 => 'Status do chamado atualizado.';

  @override
  String get legacyUiedcd363083 => 'Tempo limite excedido';

  @override
  String get legacyUi768e0c1c69 => 'Título';

  @override
  String get legacyUie39bf0152d => 'Distância de hoje';

  @override
  String get legacyUif43482f042 => 'Horas do motor hoje';

  @override
  String get legacyUi7adacb5405 => 'Alternar status';

  @override
  String get legacyUi6d91e0bb03 => 'Tolerância';

  @override
  String get legacyUid1bbcb6c01 => 'Tolerância (metros)';

  @override
  String get legacyUi63cfb27f40 => 'Principais clientes';

  @override
  String get legacyUibc6debbc28 => 'Ativos com melhor desempenho';

  @override
  String get legacyUib25928c699 => 'Total';

  @override
  String get legacyUia672e7faed => 'Total de horas do motor';

  @override
  String get legacyUie9511a6560 => 'Total recebido';

  @override
  String get legacyUia028fce203 => 'Total de usuários';

  @override
  String get legacyUi5bcce6c936 => 'Total de veículos';

  @override
  String get legacyUi7b777b27e0 => 'Total de horas do motor';

  @override
  String get legacyUi8578188376 => 'Total de registros';

  @override
  String get legacyUi0538b10824 => 'QR do link de rastreamento';

  @override
  String get legacyUi070fb0b6ea => 'Link de rastreamento excluído.';

  @override
  String get legacyUief1f899cb2 => 'Detalhes da transação';

  @override
  String get legacyUi06d8ffe653 => 'ID da transação';

  @override
  String get legacyUi105b1510d9 =>
      'As atividades de transações aparecerão aqui quando disponíveis.';

  @override
  String get legacyUid016e453e5 => 'Detalhes da transação';

  @override
  String get legacyUiab39260fea => 'Transições';

  @override
  String get legacyUic10d76c9a4 => 'Transporte';

  @override
  String get legacyUie82c27ca1d => 'Viagem cancelada';

  @override
  String get legacyUi4a9e77914e => 'Tente outro nome ou placa.';

  @override
  String get legacyUi4e653834fa => 'Tente outra busca ou filtro.';

  @override
  String get legacyUi39d6420eaa => 'Tente outro termo de busca';

  @override
  String get legacyUi0ba628a33e => 'Tente outro termo de busca.';

  @override
  String get legacyUi10239b38b5 =>
      'Tente ajustar os filtros atuais ou a busca.';

  @override
  String get legacyUi2253479cff => 'Tente ajustar os filtros.';

  @override
  String get legacyUie3f4c649b5 => 'Tente outro nome ou número de placa.';

  @override
  String get legacyUi10f570e880 => 'Tente alterar os filtros ou a busca.';

  @override
  String get legacyUif28432df1f => 'Tente alterar os filtros.';

  @override
  String get legacyUi3c86b09439 => 'Tente alterar a busca ou os filtros.';

  @override
  String get legacyUi0ba0bd18bf =>
      'Tente limpar a busca ou os filtros de status.';

  @override
  String get legacyUi7a2fe508f6 =>
      'Tente atualizar. Se o problema persistir, talvez sua conta ainda não tenha preferências de notificação.';

  @override
  String get legacyUia0b470cb00 => 'Twitter / X';

  @override
  String get legacyUi8981df4d6a => 'Twitter/X';

  @override
  String get legacyUi3deb745651 => 'Tipo';

  @override
  String get legacyUie298b0ec36 => 'Digite ';

  @override
  String get legacyUi4b3072dd4e => 'Digite os dados do comando';

  @override
  String get legacyUi5712bb4ea1 => 'Digitar manualmente';

  @override
  String get legacyUi968be8d576 => 'Não foi possível alterar a senha.';

  @override
  String get legacyUi1da33a6b30 => 'Não foi possível carregar as cidades.';

  @override
  String get legacyUia4c5468d38 =>
      'Não foi possível carregar os dados da empresa.';

  @override
  String get legacyUicbae41853b =>
      'Não foi possível carregar as opções do formulário.';

  @override
  String get legacyUid06763ac1a => 'Não foi possível carregar os estados.';

  @override
  String get legacyUia471ebf750 => 'Não foi possível carregar os usuários.';

  @override
  String get legacyUibf0bc28bdb => 'Não foi possível carregar os veículos.';

  @override
  String get legacyUid73d7a7c96 => 'Não foi possível abrir o arquivo.';

  @override
  String get legacyUi8ace6e9280 =>
      'Não foi possível abrir o seletor de imagens.';

  @override
  String get legacyUidcbaa0588e =>
      'Não foi possível abrir a navegação para este veículo.';

  @override
  String get legacyUi14fdbab84b => 'Não foi possível abrir este anexo.';

  @override
  String get legacyUia457295e9f => 'Não foi possível ler a imagem selecionada.';

  @override
  String get legacyUi9e97e5bfed => 'Não foi possível atualizar os usuários.';

  @override
  String get legacyUi800f200671 => 'Não foi possível atualizar o status.';

  @override
  String get legacyUice1c9c972b =>
      'Não foi possível atualizar o status do membro da equipe.';

  @override
  String get legacyUib5f12c7d4f =>
      'Não foi possível atualizar o membro da equipe.';

  @override
  String get legacyUia046b8ac56 =>
      'Não foi possível atualizar a URL do servidor.';

  @override
  String get legacyUi896bfd3a9a => 'Remover atribuição';

  @override
  String get legacyUi7be6acc7f8 => 'Remover atribuição do usuário?';

  @override
  String get legacyUi05027a8753 => 'Remover atribuição do usuário';

  @override
  String get legacyUi2d5a96092e => 'Remover atribuição do veículo';

  @override
  String get legacyUi39fc721248 => 'Desfazer';

  @override
  String get legacyUice77c2f42c => 'Código único';

  @override
  String get legacyUif6b935ab33 => 'Unidade';

  @override
  String get legacyUi07b032b56f => 'Não lido';

  @override
  String get legacyUi100cb4d890 => 'Tipo de arquivo incompatível.';

  @override
  String get legacyUicb9925a338 =>
      'Formato incompatível. Use PNG, JPG, JPEG ou WEBP.';

  @override
  String get legacyUi99974d3476 => 'Widget incompatível';

  @override
  String get legacyUieb27a190c0 => 'Não verificado';

  @override
  String get legacyUi61dcf34e70 => 'Atualizar senha';

  @override
  String get legacyUieae1f5caf5 => 'Atualizar status';

  @override
  String get legacyUif2f8570ddd => 'Atualizado';

  @override
  String get legacyUi22714274a4 => 'Atualizado em';

  @override
  String get legacyUi8bdf057f91 => 'Enviar';

  @override
  String get legacyUi9e2628eec4 => 'Enviar documento';

  @override
  String get legacyUidcad7d982a => 'Envie um documento para começar.';

  @override
  String get legacyUi73183a7050 => 'Enviar documento';

  @override
  String get legacyUid714896782 => 'Envie documentos deste veículo.';

  @override
  String get legacyUi4b87ccd949 =>
      'Envie arquivos do motorista, como habilitação ou documentos de identidade.';

  @override
  String get legacyUi6aafa80cab => 'Tempo de atividade';

  @override
  String get legacyUif1f71137de => 'Use uma senha forte e exclusiva';

  @override
  String get legacyUid81b6af542 => 'Usar todos';

  @override
  String get legacyUi5895bc72eb =>
      'Usado para padrões regionais, como moeda, fuso horário e roteamento.';

  @override
  String get legacyUi81c9245d46 => 'Chamados do usuário';

  @override
  String get legacyUi81939432dd => 'Ações do usuário';

  @override
  String get legacyUi0abfc13cb8 => 'Usuário atribuído.';

  @override
  String get legacyUi6188702f9e => 'Usuário criado e selecionado';

  @override
  String get legacyUi0ba72d0bce => 'Usuário excluído.';

  @override
  String get legacyUi8fd72dd6f9 => 'O usuário é obrigatório';

  @override
  String get legacyUi5ed13310cc => 'O usuário é obrigatório.';

  @override
  String get legacyUib0b238b57a => 'Permissões do usuário atualizadas';

  @override
  String get legacyUia42cd2f9d5 => 'Atribuição do usuário removida.';

  @override
  String get legacyUi2355aced23 => 'Usuário atualizado.';

  @override
  String get legacyUi84c29015de => 'Nome de usuário';

  @override
  String get legacyUib1974b83bc => 'Nome de usuário (opcional)';

  @override
  String get legacyUi2c7ab350b3 => 'Nome de usuário ou e-mail';

  @override
  String get legacyUi73dbef356e => 'VIN (opcional)';

  @override
  String get legacyUi39852971ee => 'Número VIN';

  @override
  String get legacyUia4aefa35c3 => 'Válido';

  @override
  String get legacyUi8dce170de2 => 'Valor';

  @override
  String get legacyUi7bac966778 => 'Veículo / Plano';

  @override
  String get legacyUi43188a5960 => 'Detalhes do evento do veículo';

  @override
  String get legacyUi2d80c33ed3 => 'Eventos do veículo';

  @override
  String get legacyUi4d461104bf => 'Validade do veículo';

  @override
  String get legacyUi9e47ccbff4 =>
      'O IMEI do veículo é obrigatório para carregar eventos.';

  @override
  String get legacyUi2b51e72835 =>
      'O IMEI do veículo é obrigatório para carregar sensores.';

  @override
  String get legacyUief04c2235a =>
      'O IMEI do veículo é obrigatório para carregar registros de telemetria.';

  @override
  String get legacyUi62dc158d0e => 'Rótulo do veículo';

  @override
  String get legacyUicb4e4154e4 => 'Metadados do veículo';

  @override
  String get legacyUi92dc53a1bc => 'Nome do veículo';

  @override
  String get legacyUi441399c250 => 'Seleção de veículo';

  @override
  String get legacyUi2d6ca00998 => 'Tipo de veículo';

  @override
  String get legacyUi5c931770ef => 'Ações do veículo';

  @override
  String get legacyUi6ac26355c9 =>
      'As atividades do veículo e os registros do sistema aparecerão aqui.';

  @override
  String get legacyUi4e4942337f => 'Veículo e plano';

  @override
  String get legacyUi6ec60a25f7 => 'Veículo atribuído.';

  @override
  String get legacyUia31471cef9 =>
      'As atribuições e atualizações de veículos aparecerão aqui.';

  @override
  String get legacyUib7975a2537 => 'Veículo excluído.';

  @override
  String get legacyUiff47117f38 => 'Detalhes do veículo';

  @override
  String get legacyUia1fbfba50c =>
      'Os detalhes do veículo estão indisponíveis.';

  @override
  String get legacyUi79c500fa20 => 'Período dos eventos do veículo';

  @override
  String get legacyUie981db4fa0 => 'Os eventos do veículo aparecerão aqui.';

  @override
  String get legacyUi7eefc642f4 => 'Grupo de veículos';

  @override
  String get legacyUi5cd0230ee5 => 'O ID do veículo está ausente.';

  @override
  String get legacyUi39ea43c097 => 'Número de identificação do veículo';

  @override
  String get legacyUida83429197 => 'Nome do veículo';

  @override
  String get legacyUi750a5503ac => 'Posição do veículo';

  @override
  String get legacyUi40a1e7dd80 => 'O registro do veículo não está disponível.';

  @override
  String get legacyUi686853d97d => 'Pagamento de renovação do veículo enviado';

  @override
  String get legacyUie1071916e2 => 'Renovação do veículo registrada.';

  @override
  String get legacyUibf31403ac2 => 'Escopo de veículos';

  @override
  String get legacyUi3c760a5151 => 'Serviço do veículo';

  @override
  String get legacyUi9aafada9ec =>
      'A versão do serviço do veículo está indisponível. Recarregue antes de editar.';

  @override
  String get legacyUia0d9ad9324 => 'Serviço do veículo atualizado';

  @override
  String get legacyUi97d4120359 => 'Serviços de veículos';

  @override
  String get legacyUif9709ba7c4 =>
      'A telemetria do veículo atualiza o progresso automaticamente. A conclusão manual está disponível apenas para a parada atual.';

  @override
  String get legacyUi9644381920 => 'Tipo de veículo';

  @override
  String get legacyUi8b26242493 => 'Filtro de tipo de veículo';

  @override
  String get legacyUi2a37343d0a => 'Atribuição do veículo removida.';

  @override
  String get legacyUif28657d034 => 'Veículo indisponível';

  @override
  String get legacyUi917981e400 => 'Veículo atualizado.';

  @override
  String get legacyUi02236966b5 => 'Veículos afetados';

  @override
  String get legacyUi776abb6631 => 'Veículos atribuídos.';

  @override
  String get legacyUi433457e28d => 'Não foi possível carregar os veículos.';

  @override
  String get legacyUi03128bed90 => 'Verificação';

  @override
  String get legacyUiaed3b8c6a7 => 'Verificado';

  @override
  String get legacyUidda6ac27b9 => 'Verificar';

  @override
  String get legacyUi69bd4ef9fb => 'Visualizar';

  @override
  String get legacyUi5b9306d29c => 'Ver pagamentos';

  @override
  String get legacyUie3c9374cd6 => 'Ver todas as viagens';

  @override
  String get legacyUib1614cb4e6 => 'Visualizar/Baixar';

  @override
  String get legacyUi1b6cc58781 => 'Infrações por gravidade';

  @override
  String get legacyUi1fe59390ac => 'Visível';

  @override
  String get legacyUi4fc5a421da => 'Visível ao administrador';

  @override
  String get legacyUi1448afee1d => 'Visível ao motorista';

  @override
  String get legacyUib60862f485 => 'Carteira';

  @override
  String get legacyUic4fe2a7498 => 'Notificações push da web';

  @override
  String get legacyUi2e8a57cc5c => 'Site';

  @override
  String get legacyUib32233ad82 => 'URL do site';

  @override
  String get legacyUica976c5dc6 => 'Comparação semanal';

  @override
  String get legacyUidd322f2dc7 => 'Oeste';

  @override
  String get legacyUib336fc5587 => 'WhatsApp';

  @override
  String get legacyUi16ec75e229 =>
      'Quem os destinatários veem na caixa de entrada.';

  @override
  String get legacyUi682d44be54 => 'Com dispositivo';

  @override
  String get legacyUi0a58e1d0a2 => 'Escrever resposta';

  @override
  String get legacyUi126cd2cd36 => 'Escrever resposta...';

  @override
  String get legacyUib58c0082b4 => 'Está tudo em dia.';

  @override
  String get legacyUi558865a16f => 'YouTube';

  @override
  String get legacyUid3639ca4df =>
      'Sua conta não tem permissão para visualizar esta seção.';

  @override
  String get legacyUice100fe123 =>
      'Suas alterações serão perdidas. Esta ação não pode ser desfeita.';

  @override
  String get legacyUi9b3cbed5c4 => 'Zoom';

  @override
  String get legacyUi4fc05f2763 => 'Aproximar';

  @override
  String get legacyUia4ae4b24a1 => 'Afastar';

  @override
  String get legacyUib6958e3c52 => 'Chave de API ou nome de usuário';

  @override
  String get legacyUib5f203a910 => 'cmdId';

  @override
  String get legacyUif05135d639 => 'seguro, autorização';

  @override
  String get legacyUid127ec8ef2 => 'jane@company.com';

  @override
  String get legacyUi216fb6179a => 'km/h, C, V';

  @override
  String get legacyUi7252f9e8d5 => 'últimos 7 dias';

  @override
  String get legacyUibbdead93fb => 'habilitação, identidade, autorização';

  @override
  String get legacyUid7cb0327fd => 'habilitação, seguro';

  @override
  String get legacyUica62660225 => 'noreply@example.com';

  @override
  String get legacyUid043e53c7d => 'queueId';

  @override
  String get legacyUi11c8ce1244 => 'recipient@example.com';

  @override
  String get legacyUi4b329f8934 => 'velocidade, combustível';

  @override
  String get legacyUi65e012062c => 'support@example.com';

  @override
  String get legacyUi0bd41b4761 => 'este mês';

  @override
  String get legacyUie92d4d638a => 'sem. / mês';

  @override
  String get legacyUia126722ec0 => 'Requer atenção';

  @override
  String get legacyUi51eab2420d => 'Ações da central';

  @override
  String get legacyUi8bdea32153 => 'Nenhuma atividade ainda.';

  @override
  String get legacyUi05e3a866c3 =>
      'A programação foi salva, mas não foi possível gerar algumas viagens.';

  @override
  String get legacyUi2924d70976 => 'Somente data';

  @override
  String get legacyUi63f39eeeb7 => 'Horário fixo';

  @override
  String get legacyUi6930391c64 => 'Faixa de horário';

  @override
  String get legacyUi601d153162 => 'Vários dias';

  @override
  String get legacyUif61eadaf15 => 'Em andamento';

  @override
  String get legacyUia1bf92eff4 => 'Cancelado';

  @override
  String get legacyUic7dfb6f1d9 => 'Pausado';

  @override
  String get legacyUi90303d8df2 => 'Encerrado';

  @override
  String get legacyUi59f1111618 => 'Em viagem';

  @override
  String get legacyUi2b613fb829 => 'Sem atribuição';

  @override
  String get legacyUib564001a58 => 'Não realizado';

  @override
  String get legacyUi736d1eee8e => 'Veículo inativo';

  @override
  String get legacyUif4330844fd => 'Licença do veículo bloqueada';

  @override
  String get legacyUiabf81c35d4 => 'Motorista obrigatório';

  @override
  String get legacyUi2c9c1f7914 => 'Indisponível';

  @override
  String get legacyUi8e9f1d6e54 => 'Não iniciado';

  @override
  String get legacyUi4310ed540c => 'Atrasado';

  @override
  String get legacyUiaccac60339 => 'Exceção do motorista';

  @override
  String get legacyUi6b535fa681 => 'Sem telemetria';

  @override
  String get legacyUi38a9e21ed9 => 'Desvio de rota';

  @override
  String get legacyUi1f5a1abf2f => 'Concluir';

  @override
  String get legacyUi5a436b7939 => 'Adicionar observação';

  @override
  String get legacyUi65c821a596 => 'Ao vivo';

  @override
  String get legacyUi189cc40c22 => 'Desatualizado';

  @override
  String get legacyUi41c8e43d9e => 'GPS do veículo';

  @override
  String get legacyUic1220e845b => 'Gestor de frota';

  @override
  String get legacyUi601f5ff70b => 'Automação do sistema';

  @override
  String get legacyUi8b57ec8c92 => 'Atribuição criada';

  @override
  String get legacyUi368e5b125f => 'Atribuição confirmada';

  @override
  String get legacyUid00c8926f5 => 'Viagem iniciada automaticamente';

  @override
  String get legacyUic4b75c3924 => 'Viagem concluída automaticamente';

  @override
  String get legacyUif98c835c4f => 'Viagem concluída pelo motorista';

  @override
  String get legacyUi4bb573b356 => 'Chegada à parada detectada automaticamente';

  @override
  String get legacyUi52cd528ad4 => 'Parada concluída automaticamente';

  @override
  String get legacyUicf338ebe5c => 'Parada concluída pelo motorista';

  @override
  String get legacyUi7ef2940c95 => 'Desvio de rota iniciado';

  @override
  String get legacyUi55d93aed45 => 'Desvio de rota resolvido';

  @override
  String get legacyUi654c568718 => 'Ausência de telemetria iniciada';

  @override
  String get legacyUi66676d64b0 => 'Ausência de telemetria resolvida';

  @override
  String get legacyUi2a398797b5 => 'Excesso de velocidade iniciado';

  @override
  String get legacyUif7d315eb62 => 'Excesso de velocidade resolvido';

  @override
  String get legacyUia22d66c857 => 'Chegou';

  @override
  String get legacyUi5a000ad7bd => 'Ignorado';

  @override
  String get legacyUi4028c0c8b4 => 'Não disponível';

  @override
  String get legacyUi5f174de1cc => 'Comprovante';

  @override
  String get legacyUi4e91ee6122 => 'Fuso horário da conta';

  @override
  String get legacyUi4dda6a4505 => 'Total de viagens';

  @override
  String get legacyUi523baab918 => 'Próximas';

  @override
  String get legacyUicc6e7b6a29 => 'Atrasado';

  @override
  String get legacyUie9fab1cf3a => 'Viagens concluídas no prazo';

  @override
  String get legacyUibbb47a7157 => 'Percentual no prazo';

  @override
  String get legacyUi944b223791 => 'Distância em km';

  @override
  String get legacyUi7c9352eed6 =>
      'Uma mensagem curta será enviada usando a configuração SMTP atual.';

  @override
  String get legacyUid173234df0 =>
      'ACC indica fio/ACC. MOTION indica o uso de movimento como alternativa.';

  @override
  String get legacyUi598ed2889b => 'Permissões de acesso';

  @override
  String get legacyUi9a6d95b0c5 => 'Conta ativa';

  @override
  String get legacyUi8d00c06a55 =>
      'Registros de atividade, eventos de veículos e telemetria';

  @override
  String get legacyUi61cc55aa04 => 'Adicionar';

  @override
  String get legacyUiee01d7c402 => 'Adicionar administrador';

  @override
  String get legacyUib9b1e23f27 => 'Adicionar usuário';

  @override
  String get legacyUif2f8674f8a => 'Adicionar veículo';

  @override
  String get legacyUi23a75918ab => 'Adoção e crescimento';

  @override
  String get legacyUi80643ec204 => 'Limpeza avançada';

  @override
  String get legacyUicf963e5241 => 'Filtros avançados';

  @override
  String get legacyUi3aea7b29d9 =>
      'Os relatórios avançados não estão disponíveis na demonstração pública. Entre com uma conta OpenVTS para gerar, paginar, visualizar e exportar relatórios da frota.';

  @override
  String get legacyUi056677c12f => 'Alertas por gravidade';

  @override
  String get legacyUif89ae580e8 => 'Todos os responsáveis';

  @override
  String get legacyUiaeae2d71be => 'Todos os alertas';

  @override
  String get legacyUic0e8e58c1a => 'Todas as origens';

  @override
  String get legacyUic1cbbe0c5d => 'Desvio permitido';

  @override
  String get legacyUi826499f6b1 =>
      'A cobertura anual e o serviço ao cliente são separados.';

  @override
  String get legacyUi40e69b5db3 => 'Veículo atribuído';

  @override
  String get legacyUi6771ade6e8 => 'Anexos';

  @override
  String get legacyUi52b258c824 =>
      'Descreva brevemente o problema e anexe arquivos, se necessário.';

  @override
  String get legacyUi2f3b5c55bc => 'Procurar';

  @override
  String get legacyUi00189ab9b2 => 'Modelo CSV';

  @override
  String get legacyUi19db82215d =>
      'Altere sua senha para proteger o acesso à conta.';

  @override
  String get legacyUi3f657f29e6 => 'Escolha uma nova senha';

  @override
  String get legacyUicbd1538094 =>
      'Escolha como receber alertas de veículos, excesso de velocidade e eventos de cercas virtuais.';

  @override
  String get legacyUic7cd13c042 =>
      'Escolha as páginas e os relatórios disponíveis para este usuário. As alterações também limitam os acessos que ele pode conceder a subusuários.';

  @override
  String get legacyUibe10f5c042 =>
      'Escolha o que este membro pode visualizar, editar e excluir. Próprio se aplica aos registros dele; Global se aplica a toda a conta.';

  @override
  String get legacyUi7834f4a6f4 =>
      'Escolha onde receber os alertas deste grupo de notificações.';

  @override
  String get legacyUic23350ccde => 'Detalhes do comando';

  @override
  String get legacyUib2c253ba1c =>
      'Preencha as seções abaixo. Os campos obrigatórios estão marcados com asterisco (*).';

  @override
  String get legacyUia2b4ac96b2 =>
      'Viagens concluídas por data de serviço. As próximas atribuições estão disponíveis em Viagens.';

  @override
  String get legacyUib3feb31fcb => 'Configure seu relatório';

  @override
  String get legacyUi878b163022 => 'Confirmar limpeza';

  @override
  String get legacyUi9041d3c666 =>
      'Entre em contato com o administrador para atribuir veículos.';

  @override
  String get legacyUi8e2fc0ffdc =>
      'Crie um perfil de login compacto com acesso controlado.';

  @override
  String get legacyUi93c1ed632d =>
      'Crie e gerencie cercas virtuais, pontos de interesse e rotas.';

  @override
  String get legacyUie4781f0bde =>
      'Crie e gerencie corredores de rotas operacionais.';

  @override
  String get legacyUi6571e94148 =>
      'Crie links públicos seguros para rastrear veículos ao vivo.';

  @override
  String get legacyUie09271eeb7 => 'Criado: ';

  @override
  String get legacyUidb0d2488de => 'Atribuição atual';

  @override
  String get legacyUif8ece934c7 => 'Totais diários de distância';

  @override
  String get legacyUicb47dca7e3 => 'Totais diários do período selecionado';

  @override
  String get legacyUi71d6e89bcc => 'Condução diurna e noturna';

  @override
  String get legacyUi2f3c38363d => 'Excluir POI?';

  @override
  String get legacyUi30c6c6352a => 'Excluir cerca virtual?';

  @override
  String get legacyUic6f82fca90 => 'Excluir rota?';

  @override
  String get legacyUie543c4fd0c => 'Ambiente de demonstração • Somente leitura';

  @override
  String get legacyUi50dd7fb720 => 'Configuração do dispositivo';

  @override
  String get legacyUi0cf40756a6 => 'Desenhe e gerencie limites operacionais.';

  @override
  String get legacyUi243f6cfeec => 'Quilômetros percorridos';

  @override
  String get legacyUie30d463652 => 'Os dados do motorista estão indisponíveis.';

  @override
  String get legacyUi251b80c58c => 'Assinatura de e-mails';

  @override
  String get legacyUibe482973b9 => 'Ativar SMTP';

  @override
  String get legacyUi21685f000f => 'Encerrar esta sessão neste dispositivo.';

  @override
  String get legacyUide4f0c9387 => 'Filtros de eventos';

  @override
  String get legacyUi6e74f5ccbd => 'Eventos por tipo';

  @override
  String get legacyUi74bbe75120 => 'Vence em breve';

  @override
  String get legacyUi8d00705083 => 'Data de validade';

  @override
  String get legacyUi0da7bfa1a0 => 'Data de validade (opcional)';

  @override
  String get legacyUi86baf678e1 => 'Linhas com falha';

  @override
  String get legacyUi2b1d93a2c6 => 'Filtrar registros de atividade';

  @override
  String get legacyUi9a4184cef3 => 'Filtre por administrador e período.';

  @override
  String get legacyUi96e578211a => 'Filtros';

  @override
  String get legacyUi5360d40661 => 'Fleet OS';

  @override
  String get legacyUi03d25e01e5 => 'Gerar a partir da busca';

  @override
  String get legacyUi4d8abbdc5d => 'Gerar relatório';

  @override
  String get legacyUie16305f8b0 => 'Falha na geração';

  @override
  String get legacyUid81feb6ae1 => 'Carregar histórico';

  @override
  String get legacyUi6fa6308619 =>
      'Receba notificações quando os veículos atribuídos se desviarem.';

  @override
  String get legacyUi4b6d6a3015 => 'Importante';

  @override
  String get legacyUic5288872fd =>
      'As rotas inativas permanecem arquivadas, mas visíveis.';

  @override
  String get legacyUi44caf74675 => 'Caixa de entrada';

  @override
  String get legacyUi3f33f2e865 =>
      'Inclua o caminho completo, por exemplo: http://192.168.1.10:3000/api';

  @override
  String get legacyUi1919090902 => 'Último login: ';

  @override
  String get legacyUi1c747b4f98 => 'Última ação do servidor';

  @override
  String get legacyUi9e1bba7129 => 'Período mais recente';

  @override
  String get legacyUi72da77c7b7 =>
      'As coordenadas ao vivo deste veículo estão indisponíveis.';

  @override
  String get legacyUi3e893cdfd5 =>
      'Carregando tipos de dispositivo e provedores...';

  @override
  String get legacyUi93fe7c05af => 'Carregando tipos de documento…';

  @override
  String get legacyUi75e940ee30 => 'Carregando histórico';

  @override
  String get legacyUi59c3981787 => 'Carregando histórico...';

  @override
  String get legacyUibbe4cbd55c => 'Carregando perfil';

  @override
  String get legacyUica88017dfa => 'Carregando status da assinatura...';

  @override
  String get legacyUid1ccf4c3e4 => 'Carregando veículos…';

  @override
  String get legacyUif4e14815b1 => 'Entrar como administrador';

  @override
  String get legacyUi353bd1ef01 => 'Registros por categoria';

  @override
  String get legacyUib2af2f11de => 'Registros por nível';

  @override
  String get legacyUi8c97e4f07d =>
      'Gerencie motoristas e subusuários vinculados à sua frota.';

  @override
  String get legacyUi41948edc3a =>
      'Gerencie motoristas, atribuições, documentos e atividades.';

  @override
  String get legacyUi93b23afae0 =>
      'Gerencie locais importantes e pontos operacionais.';

  @override
  String get legacyUi68669149c0 =>
      'Gerencie subusuários e o acesso a veículos.';

  @override
  String get legacyUi9fcd87c64d => 'Gerencie planos de preços de assinaturas.';

  @override
  String get legacyUi274ef56d8e =>
      'Gerencie transações e renove assinaturas de veículos';

  @override
  String get legacyUiff92dafaaf =>
      'Gerencie usuários, acesso de login, contatos e veículos atribuídos.';

  @override
  String get legacyUib42578bf99 =>
      'Os pagamentos manuais atualizam as transações e as análises após o envio bem-sucedido.';

  @override
  String get legacyUi421878a774 => 'Dados do mapa © Google';

  @override
  String get legacyUi2cf55e0f5b => 'Detalhes do mapa';

  @override
  String get legacyUi9a3aa11de5 => 'Tipo de mapa';

  @override
  String get legacyUi09d3670056 =>
      'Máximo de 10 MB. Bloqueados: exe, js, html, htm.';

  @override
  String get legacyUife0c6bc7dd => 'Diagnóstico de notificações push';

  @override
  String get legacyUif6f444180f =>
      'Monitore o tempo de atividade, as dependências e as ações seguras de serviço';

  @override
  String get legacyUi1a63cbf994 => 'Novo link';

  @override
  String get legacyUia40ad15529 => 'Novo chamado de suporte';

  @override
  String get legacyUi9f2d2d7331 =>
      'Nenhum tipo de documento de USER configurado.';

  @override
  String get legacyUi9ec5ec0752 =>
      'Nenhuma cerca virtual ativa — todas estão incluídas.';

  @override
  String get legacyUi0a181de203 =>
      'Nenhum administrador disponível. Puxe para atualizar e tente novamente.';

  @override
  String get legacyUi43f32b9b9d => 'Sem informações de contato';

  @override
  String get legacyUie55a0728f0 => 'Nenhuma cerca virtual para visualizar';

  @override
  String get legacyUi115fe0fac7 => 'Nenhum grupo encontrado';

  @override
  String get legacyUida501f43fd => 'Ainda não há dados de crescimento.';

  @override
  String get legacyUi454fe267a7 => 'Sem metadados';

  @override
  String get legacyUi2540cc1f1a => 'Nenhuma solicitação de renovação pendente.';

  @override
  String get legacyUi7cd1d44b3c => 'Nenhum registro encontrado.';

  @override
  String get legacyUi658e79f9dc => 'Nenhum resultado encontrado';

  @override
  String get legacyUif018f94f6e =>
      'Nenhuma linha corresponde aos filtros do relatório.';

  @override
  String get legacyUibddbb17fc4 => 'Nenhuma seleção = todos';

  @override
  String get legacyUi9aba7bbe44 =>
      'Nenhuma seleção = todas as cercas virtuais.';

  @override
  String get legacyUifd548f1c32 =>
      'Nenhum sensor configurado para este veículo';

  @override
  String get legacyUi162d1ddec0 => 'Nenhuma atividade da equipe encontrada.';

  @override
  String get legacyUi8f91f15684 => 'Nenhuma localização GPS válida';

  @override
  String get legacyUi74ac3b3d0d => 'Nenhum veículo atribuído.';

  @override
  String get legacyUia26d9edac3 => 'Nenhum veículo atribuído à sua conta';

  @override
  String get legacyUie4b1dbf423 => 'Nenhum veículo encontrado.';

  @override
  String get legacyUi6eef664840 => 'Nenhum';

  @override
  String get legacyUif8ae6c8bbe => 'Não confirmado';

  @override
  String get legacyUia92e15bc0a => 'Preferências de notificação';

  @override
  String get legacyUic71ffe5d22 => 'Intervalo entre notificações';

  @override
  String get legacyUicb88cbc310 => 'Notificar quando o veículo sair da rota';

  @override
  String get legacyUi0049196b0b => 'Mover 10 m';

  @override
  String get legacyUia49d76ddc1 => 'Um veículo';

  @override
  String get legacyUi0080aaa977 => 'Open VTS';

  @override
  String get legacyUi032a6dcfd8 =>
      'Abra um chamado de suporte para revisar a conversa completa.';

  @override
  String get legacyUi50f8c47b2b => 'Abrir na navegação';

  @override
  String get legacyUi89202c7fd8 => 'Outro documento';

  @override
  String get legacyUi27b4bf6d1b =>
      'O envio de e-mails usa este servidor quando ativado.';

  @override
  String get legacyUi619d7adc2c =>
      'O pagamento aparecerá imediatamente na lista de transações.';

  @override
  String get legacyUidc32a816e9 =>
      'Remover permanentemente registros históricos anteriores ao período de retenção.';

  @override
  String get legacyUic2ff2762ca => 'Selecione um arquivo.';

  @override
  String get legacyUi3585d74456 => 'Manter validade atual';

  @override
  String get legacyUia9a96ec019 => 'Principal';

  @override
  String get legacyUi668c4636aa => 'Comprovante de entrega';

  @override
  String get legacyUif702b26481 => 'Classificado por número de transações';

  @override
  String get legacyUid03c65244f => 'Recalcular a partir do plano';

  @override
  String get legacyUi72d5617f3f => 'Atividade recente';

  @override
  String get legacyUi255e5788a2 => 'Recupere sua conta';

  @override
  String get legacyUi505dddc915 => 'Atualizando';

  @override
  String get legacyUi54dd5046d0 =>
      'A atualização substituirá suas edições de notificações não salvas pelas configurações mais recentes do servidor.';

  @override
  String get legacyUi199ed09ba9 => 'Acesso a relatórios';

  @override
  String get legacyUibd7b4f006d => 'Relatar problema';

  @override
  String get legacyUi8115c55b47 =>
      'Os relatórios são restritos no modo de demonstração';

  @override
  String get legacyUi6b5890ba0b =>
      'Solicite e confirme o código de uso único para verificar o e-mail e o número do WhatsApp.';

  @override
  String get legacyUif7194e6a0d => 'Solicitações';

  @override
  String get legacyUif25bbab45d => 'Previsão de receita';

  @override
  String get legacyUiec40affa3e => 'Tendência de receita';

  @override
  String get legacyUic53c3605a0 =>
      'Revise as solicitações de renovação de clientes. Confirme apenas os pagamentos realmente recebidos fora do aplicativo.';

  @override
  String get legacyUiffbfe1e822 => 'Paradas da rota';

  @override
  String get legacyUi50eec1a359 => 'Resultado da execução';

  @override
  String get legacyUi339225895f =>
      'A limpeza exclui dados permanentemente. Sempre visualize a simulação primeiro.';

  @override
  String get legacyUifee1dff0c6 => 'Em movimento e parados';

  @override
  String get legacyUi0fb59422f6 => 'Amostras';

  @override
  String get legacyUide6472b8d3 => 'Selecionar período';

  @override
  String get legacyUia35cfe395a => 'Selecionar grupo';

  @override
  String get legacyUi2564e1a2c5 => 'Selecionar sensor';

  @override
  String get legacyUifea7a520f3 => 'Selecionar veículo';

  @override
  String get legacyUi70037936c0 => 'Selecione um chamado';

  @override
  String get legacyUieeaf903bb8 => 'Selecione um veículo primeiro';

  @override
  String get legacyUiad7a8a1750 =>
      'Selecione um administrador, descreva o problema e anexe arquivos, se necessário.';

  @override
  String get legacyUi9bb7b69035 => 'Selecione pelo menos um estado';

  @override
  String get legacyUifcfe92e583 => 'Selecionar painel';

  @override
  String get legacyUif9f50c1c30 =>
      'Selecione veículos, período e filtros e, em seguida, gere o relatório para ver os resultados.';

  @override
  String get legacyUi0e40d8b0bf => 'Veículos selecionados';

  @override
  String get legacyUi43e146fb62 => 'Monitoramento da integridade do servidor';

  @override
  String get legacyUi644899c565 =>
      'A validade do serviço controla o rastreamento ao vivo. Entre em contato com o administrador para renovar. Uma solicitação de renovação não estende o serviço até que o pagamento seja confirmado.';

  @override
  String get legacyUi5cbd584046 => 'Serviços';

  @override
  String get legacyUi758d7f7281 => 'Ativar';

  @override
  String get legacyUi7c9275ee4b => 'Desativar';

  @override
  String get legacyUiddbe3ed1a3 => 'Definir validade personalizada';

  @override
  String get legacyUi7b53693e94 => 'Links de rastreamento compartilhados';

  @override
  String get legacyUidc1649a16c => 'Sair';

  @override
  String get legacyUi2f32be1dc7 => 'Assinatura';

  @override
  String get legacyUi51070e69d1 => 'Foto do local';

  @override
  String get legacyUi93773568cf => 'Limite de velocidade';

  @override
  String get legacyUicb672694bb => 'Filtro de estado';

  @override
  String get legacyUi511404ce3b => 'Distribuição por status';

  @override
  String get legacyUie54e98e0cb => 'Parada';

  @override
  String get legacyUie48d04b2b6 =>
      'Parar o Frontend, Backend ou Listener pode impedir o acesso à aplicação. Esta página permite iniciar e reiniciar esses serviços, mas a ação de parar está desativada.';

  @override
  String get legacyUi16b45ef102 =>
      'Distribuição entre sucesso, pendência e falha';

  @override
  String get legacyUi12b71c3e0f => 'Resumo';

  @override
  String get legacyUied9177cab1 => 'Métricas do sistema';

  @override
  String get legacyUie20a879f45 =>
      'Toque para editar notificações de cercas virtuais';

  @override
  String get legacyUiac8b906fca => 'Veículo de destino';

  @override
  String get legacyUib644561145 => 'Registro de telemetria';

  @override
  String get legacyUi7840676a23 => 'Registro de telemetria';

  @override
  String get legacyUi4ee3736ca6 =>
      'Esta ação não pode ser desfeita. O motorista e as atribuições relacionadas serão removidos.';

  @override
  String get legacyUi3575c0aec8 =>
      'Esta ação remove permanentemente o subusuário e revoga o acesso aos veículos. Não pode ser desfeita.';

  @override
  String get legacyUi7f3d98b829 =>
      'Este link não pode ser excluído porque seu ID está ausente.';

  @override
  String get legacyUi4e81e87c37 =>
      'Esta ação exclui permanentemente os dados anteriores ao período de retenção. Não pode ser desfeita.';

  @override
  String get legacyUid8b029df5c =>
      'Este link público de rastreamento deixará de funcionar imediatamente. Esta ação não pode ser desfeita.';

  @override
  String get legacyUida735ce16c =>
      'Este relatório não está disponível para sua conta.';

  @override
  String get legacyUidf3e8a5fdd =>
      'Este chamado está fechado ou resolvido. As respostas estão desativadas.';

  @override
  String get legacyUif9c732c3c6 =>
      'Este chamado está fechado. Uma resposta pode reabri-lo ou movê-lo para Em andamento, conforme o comportamento do servidor.';

  @override
  String get legacyUif3a8370f38 => 'Receita total';

  @override
  String get legacyUie273941b29 => 'Totais por moeda';

  @override
  String get legacyUiaa7d3d7dd9 => 'Histórico de transações';

  @override
  String get legacyUib174443b0e => 'Transações e receita';

  @override
  String get legacyUi9dda9aa776 => 'Viagem';

  @override
  String get legacyUic948ed8076 => 'Comprovantes de viagem';

  @override
  String get legacyUid67a44f68d => 'Tente ajustar os filtros ou o período.';

  @override
  String get legacyUi078f02fe7b => 'Não foi possível carregar os documentos';

  @override
  String get legacyUi3b37311cd6 => 'Não foi possível carregar o histórico';

  @override
  String get legacyUicaa5bd27e5 => 'Não foi possível carregar os registros';

  @override
  String get legacyUi92078d350e => 'Não foi possível carregar os pagamentos';

  @override
  String get legacyUi5db77ece1a => 'Não foi possível carregar o perfil';

  @override
  String get legacyUi081863e321 => 'Não foi possível carregar os chamados';

  @override
  String get legacyUi11f14b7638 =>
      'Atualize a identidade da empresa e os links de redes sociais.';

  @override
  String get legacyUieb58c61a89 =>
      'Atualize os dados pessoais e de endereço. As alterações só serão salvas após sua confirmação.';

  @override
  String get legacyUid19cf73ae1 => 'Atualizado: ';

  @override
  String get legacyUi9db8e8ec0b =>
      'Use a lista de veículos do mapa ao vivo e escolha o limite de parada e o período de data e hora.';

  @override
  String get legacyUid337d1a0d6 => 'Prévia de variáveis';

  @override
  String get legacyUi63dfad55e0 => 'Informações do veículo';

  @override
  String get legacyUi7f4567c8c2 => 'Status do veículo ao vivo';

  @override
  String get legacyUiceedc505bd => 'Status do veículo';

  @override
  String get legacyUi1f41948d84 => 'Evento do veículo';

  @override
  String get legacyUid3aee04e65 => 'Matriz veículo-cerca virtual';

  @override
  String get legacyUiefd8355920 => 'Ver todos';

  @override
  String get legacyUi50ad3280e1 => 'Ver veículo';

  @override
  String get legacyUi2c3c7c93f8 =>
      'Visualize pagamentos, créditos, débitos e registros de cobrança.';

  @override
  String get legacyUi7d9ff4f0de => 'Visibilidade';

  @override
  String get legacyUi79c6a6033a => 'Visível ao administrador';

  @override
  String get legacyUied0069155f => 'Visível ao usuário';

  @override
  String get legacyUia56d85fb20 =>
      'Os navegadores exigem que o servidor permita solicitações de outras origens (CORS). Se o login falhar com um erro de conexão, ative o CORS no servidor.';

  @override
  String get legacyUi4dd079044f => 'Viagem completa';

  @override
  String get legacyUi4515b6c7b7 => 'Seu dia';

  @override
  String get legacyUi50f19ac0b4 =>
      'Seus documentos e os documentos compartilhados pelo gestor da frota.';

  @override
  String get legacyUi4e697d55ce =>
      'Suas transações com o proprietário do software.';

  @override
  String get legacyUi678830983a => '— dados truncados para exibição —';

  @override
  String legacyUi1e22f79cd9(Object value1) {
    return 'Carregando $value1';
  }

  @override
  String legacyUi57fdb35e30(Object value1) {
    return '$value1 indisponível';
  }

  @override
  String legacyUi1fd3e5084a(Object value1) {
    return 'Nenhum resultado de $value1';
  }

  @override
  String get legacyUie16f97dcfd => 'Limpar histórico';

  @override
  String legacyUiabd4cd39b9(Object value1) {
    return '$value1 pontos';
  }

  @override
  String legacyUi90eaac7e8b(Object value1) {
    return '$value1 paradas';
  }

  @override
  String legacyUi865d65baea(Object value1) {
    return '$value1 em excesso de velocidade';
  }

  @override
  String legacyUi7326be7e87(Object value1, Object value2) {
    return '$value1 $value2 máx.';
  }

  @override
  String legacyUi5fd7f54937(Object value1, Object value2) {
    return '$value1 $value2 em média';
  }

  @override
  String legacyUi5f2ee53a4c(Object value1) {
    return '$value1 em movimento';
  }

  @override
  String legacyUi5c24a04874(Object value1) {
    return '$value1 parado';
  }

  @override
  String legacyUi2b4b82c8bb(Object value1) {
    return 'Duração: $value1';
  }

  @override
  String legacyUi27a82a7136(Object value1) {
    return '$value1 dirigindo';
  }

  @override
  String legacyUi92edf7854b(Object value1) {
    return '$value1 veículos';
  }

  @override
  String get legacyUi5d12bd5355 => 'Reproduzir';

  @override
  String get legacyUi4e39567064 => 'Observação (opcional)';

  @override
  String get legacyUi932fc13e7f => 'Título (opcional)';

  @override
  String legacyUi2c904359f5(Object value1) {
    return 'O arquivo excede o limite de $value1 MB';
  }

  @override
  String legacyUi66db457b99(Object value1) {
    return 'Formato incompatível. Permitidos: $value1';
  }

  @override
  String get legacyUia7cf7b25a7 => 'Substituir';

  @override
  String legacyUidf1d5f2730(Object value1) {
    return 'E-mail de teste enviado para $value1';
  }

  @override
  String get legacyUi044b852f30 => 'Mostrar senha';

  @override
  String get legacyUie40123b4e7 => 'Ocultar senha';

  @override
  String get legacyUi82f47c3d4d => 'E-mail verificado';

  @override
  String get legacyUib1a273086c => 'WhatsApp verificado';

  @override
  String legacyUi908e5c8ce5(Object value1) {
    return 'Sessão encerrada em $value1';
  }

  @override
  String get legacyUi33ce417454 => 'Carregando…';

  @override
  String get legacyUi71ae0ec96e => 'Falha ao carregar — tentar novamente';

  @override
  String get legacyUi67c4d0506a => 'Não se aplica';

  @override
  String get legacyUia0b1fb2afb => 'Mostrar confirmação de senha';

  @override
  String get legacyUie2196c3942 => 'Ocultar confirmação de senha';

  @override
  String get legacyUi7c073937c6 => 'Código de uso único enviado ao seu e-mail';

  @override
  String get legacyUi8532209c49 => 'Código de uso único enviado pelo WhatsApp';

  @override
  String get legacyUi0d455a4e26 => 'Verificar e-mail';

  @override
  String get legacyUi9cb68a6dd3 => 'Verificar WhatsApp';

  @override
  String legacyUi8cf58d99c1(Object value1) {
    return 'De $value1';
  }

  @override
  String legacyUif41a1a65a6(Object value1) {
    return 'Para $value1';
  }

  @override
  String legacyUia801634da8(Object value1) {
    return '$value1 excluído.';
  }

  @override
  String legacyUi73f15343e6(Object value1) {
    return 'Conectado como $value1.';
  }

  @override
  String get legacyUi48138f08cd => 'Desativar administrador';

  @override
  String get legacyUif9494a277e => 'Ativar administrador';

  @override
  String get legacyUi13a84a7390 => 'Administrador ativado.';

  @override
  String get legacyUi8181bbb7c7 => 'Administrador desativado.';

  @override
  String get legacyUid65ded9428 => 'Desativar';

  @override
  String get legacyUi92ef08325a => 'Ativar';

  @override
  String get legacyUiacfd05ab80 => 'E-mail não verificado';

  @override
  String get legacyUi23c9dd8809 =>
      'Não foi possível carregar os veículos. Tente novamente.';

  @override
  String legacyUib089c07088(Object value1) {
    return 'GMT $value1';
  }

  @override
  String legacyUi73585fdb6f(Object value1) {
    return 'Adicionado $value1';
  }

  @override
  String get legacyUi410bebb5ea =>
      'Não foi possível carregar os documentos. Tente novamente.';

  @override
  String get legacyUi7f10270c45 =>
      'Não foi possível carregar os tipos de documento. Tente novamente.';

  @override
  String get legacyUid4c2792a72 => 'Oculto';

  @override
  String get legacyUi1b7cd8a9bf => 'Documento atualizado.';

  @override
  String get legacyUi895a77b095 => 'Documento enviado.';

  @override
  String get legacyUief6604a13d => 'Editar documento';

  @override
  String get legacyUif6769b696e => 'Créditos adicionados.';

  @override
  String get legacyUib16dd3b790 => 'Créditos deduzidos.';

  @override
  String get legacyUie890b12b34 => 'Nenhuma transação corresponde aos filtros';

  @override
  String get legacyUib71113c83a =>
      'Nenhum pagamento encontrado para este administrador. Tente limpar os filtros.';

  @override
  String get legacyUi472af48c6d => 'Registre um pagamento manual para começar.';

  @override
  String legacyUi46f7e02bd0(Object value1) {
    return '$value1 copiado';
  }

  @override
  String legacyUi70d9eead51(Object value1) {
    return 'O assunto deve ter no máximo $value1 caracteres.';
  }

  @override
  String legacyUifee6584f1b(Object value1) {
    return 'A descrição deve ter no máximo $value1 caracteres.';
  }

  @override
  String legacyUi830e676993(Object value1) {
    return 'Você pode enviar até $value1 arquivos.';
  }

  @override
  String legacyUi4e5f407ec5(Object value1) {
    return 'Arquivo bloqueado removido: $value1';
  }

  @override
  String legacyUib5d0b873d0(Object value1) {
    return 'Arquivo incompatível removido: $value1';
  }

  @override
  String legacyUid1740cec1d(Object value1) {
    return 'O arquivo excede 5 MB: $value1';
  }

  @override
  String legacyUie33e0ec27a(Object value1) {
    return 'A resposta deve ter no máximo $value1 caracteres.';
  }

  @override
  String legacyUid9e484645b(Object value1) {
    return 'O status do chamado já é $value1.';
  }

  @override
  String legacyUiebbf66ef0e(Object value1, Object value2) {
    return 'De: $value1$value2';
  }

  @override
  String legacyUi94cf932307(Object value1) {
    return 'Criado $value1';
  }

  @override
  String legacyUib5ae5701b9(Object value1) {
    return 'Atualizado $value1';
  }

  @override
  String legacyUi1a150ff203(Object value1) {
    return 'Fechado $value1';
  }

  @override
  String get legacyUiec6952e09b => 'Atualizando';

  @override
  String legacyUi190040d9d3(Object value1) {
    return 'Alguns arquivos excedem 5 MB e foram removidos$value1.';
  }

  @override
  String legacyUi2a432bdd06(Object value1) {
    return 'Agente local: $value1';
  }

  @override
  String get legacyUi3adb8e50db => 'Crie um membro da equipe para começar.';

  @override
  String legacyUiabad5c010f(Object value1) {
    return '$value1 · Permissões';
  }

  @override
  String get legacyUifb91e24fa5 => 'Atualizar';

  @override
  String get legacyUia9d4f0d3b6 => 'Não foi possível atualizar as permissões';

  @override
  String get legacyUi918bffea2f => 'Mostrar senha atual';

  @override
  String get legacyUifa0245c379 => 'Ocultar senha atual';

  @override
  String get legacyUi9a569782b5 => 'Mostrar nova senha';

  @override
  String get legacyUiaa10918381 => 'Ocultar nova senha';

  @override
  String get legacyUi39b0c83afa => 'Mostrar confirmação da nova senha';

  @override
  String get legacyUiea6f8ea221 => 'Ocultar confirmação da nova senha';

  @override
  String legacyUie30362677c(Object value1) {
    return '$value1 registrado';
  }

  @override
  String legacyUi060250e9ba(Object value1) {
    return '$value1 faturas';
  }

  @override
  String get legacyUi53e337d44c => 'Salvar plano';

  @override
  String get legacyUi4fc636d1bb => 'Plano atualizado.';

  @override
  String get legacyUidc5a367e83 => 'Plano criado.';

  @override
  String get legacyUi2325fc9152 => 'Nenhum tipo de veículo disponível';

  @override
  String get legacyUi4e4664e8e9 => 'Selecionar tipo de veículo';

  @override
  String get legacyUi37282b63dd => 'Carregando usuários...';

  @override
  String get legacyUide2b4561e4 => 'Falha ao carregar usuários';

  @override
  String get legacyUif1b918acaf => 'Criar ou selecionar usuário principal';

  @override
  String get legacyUic96ec8c8a6 => 'Nenhum dispositivo disponível';

  @override
  String get legacyUieeed87c94b => 'Selecionar dispositivo GPS';

  @override
  String get legacyUie5a3dc6c41 => 'Nenhum plano disponível';

  @override
  String get legacyUi509d83b55f => 'Selecionar plano de preços';

  @override
  String legacyUi91c69c8c0d(Object value1) {
    return 'Veículo \"$value1\" criado.';
  }

  @override
  String get legacyUi048e2d12ad => 'Veículo desativado.';

  @override
  String get legacyUib042915cc0 => 'Veículo ativado.';

  @override
  String get legacyUi3741f56c60 => 'Criar sensor';

  @override
  String get legacyUi996e719712 => 'Salvar sensor';

  @override
  String get legacyUiaa9bf6a127 => 'Não foi possível atualizar o serviço';

  @override
  String legacyUif17fe09e18(Object value1) {
    return 'Cobertura anual de $value1 renovada';
  }

  @override
  String get legacyUid55d13471f => 'Falha na renovação anual';

  @override
  String get legacyUi2caa5892b7 => 'Consultando status...';

  @override
  String get legacyUid56ae084ba => 'Editar documento';

  @override
  String get legacyUi47396c4fcf => 'Crie um motorista para começar.';

  @override
  String get legacyUie4c5584c2a => 'Motorista ativado.';

  @override
  String get legacyUi255f9b5d50 => 'Motorista desativado.';

  @override
  String legacyUi2c5ad08780(Object value1) {
    return 'Validade: $value1';
  }

  @override
  String get legacyUifc3606d535 => 'Desativar motorista';

  @override
  String get legacyUic82a768102 => 'Ativar motorista';

  @override
  String legacyUi3c2dd46009(Object value1) {
    return '$value1 (atual)';
  }

  @override
  String get legacyUi9e9d25ea74 => 'Selecione o país primeiro';

  @override
  String get legacyUi789073b300 => 'Selecione o estado primeiro';

  @override
  String get legacyUie0c7a349f8 => 'Desmarcar todos os filtrados';

  @override
  String get legacyUi30a4c62f4d => 'Selecionar todos os filtrados';

  @override
  String get legacyUi303e32bfd9 => 'Pagamento confirmado e serviço renovado';

  @override
  String get legacyUiad3c7489f5 => 'Solicitação de renovação cancelada';

  @override
  String get legacyUi91027c0a9a => 'Não foi possível atualizar a solicitação';

  @override
  String get legacyUi3fb82cbe4b => 'Buscar chamados de usuários';

  @override
  String get legacyUi3263ab8929 => 'Buscar meus chamados';

  @override
  String get legacyUi24cae41f13 => 'Usuário ativado.';

  @override
  String get legacyUi48d348ab09 => 'Usuário desativado.';

  @override
  String legacyUi515200de54(Object value1) {
    return 'Mínimo de $value1 caracteres';
  }

  @override
  String get legacyUiea03fca475 => 'Selecione um país primeiro';

  @override
  String get legacyUi01d9797a19 => 'Nenhum estado disponível';

  @override
  String get legacyUic234150a07 => 'Selecione um estado';

  @override
  String get legacyUida9ca145a1 => 'Selecione um estado primeiro';

  @override
  String get legacyUi12fb8b7d21 => 'Nenhuma cidade disponível';

  @override
  String get legacyUia8ab373cf7 => 'Selecione uma cidade';

  @override
  String legacyUi99c1db6636(Object value1) {
    return 'Usuário \"$value1\" criado.';
  }

  @override
  String get legacyUi6ea66e7cf8 => 'Nenhum motorista atribuído';

  @override
  String get legacyUi6b4d2e8347 => 'Nenhum motorista corresponde à busca';

  @override
  String legacyUic7a9755928(Object value1) {
    return 'Licença $value1';
  }

  @override
  String get legacyUi530530a405 => 'Nenhum motorista disponível';

  @override
  String legacyUied9f265a0a(Object value1) {
    return 'Buscar $value1…';
  }

  @override
  String get legacyUia269afc99c => 'Nenhum chamado encontrado';

  @override
  String get legacyUifd0ab9a284 => 'Nenhum chamado corresponde à busca';

  @override
  String legacyUic93cd16b9b(Object value1) {
    return 'Último $value1';
  }

  @override
  String legacyUib68af38cf0(Object value1) {
    return 'O chamado já está $value1.';
  }

  @override
  String get legacyUi9ddc709693 => 'Desativar usuário';

  @override
  String get legacyUiaebaaf50f8 => 'Ativar usuário';

  @override
  String get legacyUi8ed321fdf0 => 'Não foi possível salvar as permissões';

  @override
  String get legacyUi51c4b07667 => 'Nenhum veículo corresponde à busca';

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
    return 'Validade $value1';
  }

  @override
  String get legacyUif0dc6b09f8 => 'Nenhum veículo disponível';

  @override
  String get legacyUi39d436aaba => 'Sem validade';

  @override
  String get legacyUic15c47e4c9 =>
      'Buscar IMEI, tipo de dispositivo, número do SIM…';

  @override
  String get legacyUibc139b1c14 => 'Buscar SIM, IMSI, ICCID, operadora…';

  @override
  String get legacyUiaa729739dd => 'Nenhum dispositivo encontrado';

  @override
  String get legacyUi679d782d32 => 'Nenhum cartão SIM encontrado';

  @override
  String get legacyUi613b9215a5 => 'Adicione itens ao estoque para começar.';

  @override
  String get legacyUi9f91b0dc33 => 'Carregando tipos de dispositivo...';

  @override
  String legacyUi9ba6bfee17(Object value1) {
    return 'Usando valores padrão seguros. $value1';
  }

  @override
  String get legacyUi2919b3cdf5 => 'E-mail pendente';

  @override
  String get legacyUidfd4099c87 => 'WhatsApp pendente';

  @override
  String legacyUif0dd87cef8(Object value1) {
    return 'Mudar para a aba $value1';
  }

  @override
  String legacyUi364cdce6f9(Object value1) {
    return '$value1 créditos';
  }

  @override
  String get legacyUi070e328ec8 => 'Enviando...';

  @override
  String get legacyUie8d33553f6 => 'Alterar avatar';

  @override
  String legacyUi56b3825e50(Object value1) {
    return 'Aplicar predefinição $value1';
  }

  @override
  String get legacyUi28e40daab7 => 'Reenviando...';

  @override
  String get legacyUib707b694b2 => 'Reenviar código de uso único';

  @override
  String legacyUia648c7bbe2(Object value1) {
    return 'Seletor de $value1';
  }

  @override
  String get legacyUidd1242a8fc => 'Inscrito';

  @override
  String get legacyUibbf5d78203 => 'Não inscrito';

  @override
  String get legacyUi0e42454279 => 'todos os veículos';

  @override
  String get legacyUi12e7d6beac => 'Origem desconhecida';

  @override
  String get legacyUifb2269d326 => 'Nenhum veículo operacional disponível.';

  @override
  String get legacyUi9dd705b078 => 'Nenhum veículo disponível.';

  @override
  String legacyUi8879fce2e7(Object value1, Object value2) {
    return '$value1 veículo$value2 bloqueado excluído.';
  }

  @override
  String legacyUif039d146e6(Object value1) {
    return '$value1 veículos atribuídos';
  }

  @override
  String get legacyUi02b460b2cf => 'Nenhum veículo correspondente';

  @override
  String get legacyUi537da7f70e =>
      'Todos os veículos já estão atribuídos a este subusuário.';

  @override
  String get legacyUif614a2e6b5 => 'Tente outra busca.';

  @override
  String get legacyUi28516f977e => 'Subusuário desativado.';

  @override
  String get legacyUi7841e93192 => 'Subusuário ativado.';

  @override
  String get legacyUi87e328dc94 => 'Limpar busca';

  @override
  String get legacyUi72556ffa55 => 'Visível ao motorista';

  @override
  String get legacyUi355f129929 => 'Oculto para o motorista';

  @override
  String get legacyUib68e795ff9 => 'Alterar veículo';

  @override
  String get legacyUi0cb329674a => 'Visível nos documentos do usuário';

  @override
  String get legacyUi7ab98ca9b9 => 'Oculto nos documentos do usuário';

  @override
  String get legacyUi5f22178640 => 'O motorista pode ver este documento';

  @override
  String get legacyUiaf7ad5ad5c => 'O motorista não pode ver este documento';

  @override
  String get legacyUib544cc3e95 => 'Nenhum veículo sem atribuição';

  @override
  String get legacyUidf10a27148 => 'Todos os veículos já estão atribuídos.';

  @override
  String get legacyUic3763af773 => 'Não atualizado';

  @override
  String get legacyUia1f5a8dbd3 => 'Nenhum sensor encontrado';

  @override
  String get legacyUi6a3625800c =>
      'Nenhum sensor configurado para este veículo.';

  @override
  String get legacyUi5fdd1b0855 => 'Configurações do sensor';

  @override
  String get legacyUi2524c34a0d => 'Novo sensor';

  @override
  String get legacyUiae7e887517 => 'Salvando...';

  @override
  String get legacyUi126eda8b21 => 'Executando...';

  @override
  String get legacyUi7745774c38 => 'Sensor criado.';

  @override
  String get legacyUi2a367dafb5 => 'Sensor atualizado.';

  @override
  String get legacyUi4abc320492 => 'Carregando configuração';

  @override
  String get legacyUic0ae8f6ea8 => 'Salvo';

  @override
  String get legacyUif352418f58 => 'Carregando tipos…';

  @override
  String get legacyUi82385d8917 => 'Carregando fusos horários…';

  @override
  String get legacyUi22e6340f2c => 'Selecionar fuso horário';

  @override
  String get legacyUicc4889261c => 'Recarregar histórico';

  @override
  String get legacyUi9e8a1c5b7b => 'Carregando sensores…';

  @override
  String legacyUic0a743750e(Object value1) {
    return 'Selecionar período do relatório $value1';
  }

  @override
  String legacyUi26362a69a0(Object value1) {
    return 'Em movimento: $value1';
  }

  @override
  String legacyUicbbef93382(Object value1) {
    return 'Parado: $value1';
  }

  @override
  String legacyUic1d252d58b(Object value1) {
    return '$value1 — Excesso de velocidade';
  }

  @override
  String legacyUidf3ab0c2d9(Object value1) {
    return 'Dia: $value1';
  }

  @override
  String legacyUi20076143b6(Object value1) {
    return 'Noite: $value1';
  }

  @override
  String legacyUie296339b1e(Object value1, Object value2) {
    return '$value1 viagem$value2';
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
    return 'Distância por veículo ($value1 maiores)';
  }

  @override
  String legacyUi6eca89289b(Object value1) {
    return '$value1 km/h';
  }

  @override
  String legacyUib9a5d6824c(Object value1, Object value2) {
    return 'Cerca virtual $value1 para $value2';
  }

  @override
  String legacyUi4d24bcb058(Object value1, Object value2) {
    return 'Limite de velocidade ($value1) para $value2';
  }

  @override
  String get legacyUi56a2285c5b => 'Salvando…';

  @override
  String legacyUia1f38b12bb(Object value1) {
    return 'Alternar $value1';
  }

  @override
  String legacyUic3b516d33c(Object value1) {
    return '$value1 cercas virtuais';
  }

  @override
  String get legacyUi010f99630a => 'Editar link de rastreamento';

  @override
  String get legacyUibb53b1c483 => 'Novo link de rastreamento';

  @override
  String legacyUi9287b718c6(Object value1) {
    return '$value1 selecionados';
  }

  @override
  String get legacyUib948ff19e4 => 'Desbloquear quadrado';

  @override
  String get legacyUi85a3ef0c3f => 'Bloquear quadrado';

  @override
  String get legacyUi9dd7a6b201 => 'Criar cerca virtual';

  @override
  String get legacyUidccb573a71 => 'Desenhar rota';

  @override
  String legacyUi4c91961249(Object value1) {
    return 'Enviar $value1 linhas';
  }

  @override
  String legacyUi0ff9c73519(Object value1) {
    return '$value1 válidos';
  }

  @override
  String legacyUifa7ec0ed62(Object value1) {
    return '$value1 inválidos';
  }

  @override
  String legacyUi1483db1240(Object value1) {
    return '$value1 corretos';
  }

  @override
  String legacyUi2c661fac7f(Object value1) {
    return '$value1 com falha';
  }

  @override
  String get legacyUi7e613c0b85 => 'Posicionar POI';

  @override
  String get legacyUi4405592a72 => 'Mover POI';

  @override
  String get legacyUi91fbb41bfb => 'Usar esta localização';

  @override
  String get legacyUif05f282071 => 'Toque no mapa para posicionar o POI';

  @override
  String get legacyUie8f485c68a => 'Tente ajustar os filtros ou o período.';

  @override
  String get legacyUia0c0bb9e85 =>
      'Nenhuma transação disponível para este período.';

  @override
  String legacyUid7d6dade2a(Object value1) {
    return 'Sucesso $value1';
  }

  @override
  String legacyUi3a0d457cee(Object value1) {
    return 'Pendente $value1';
  }

  @override
  String legacyUi07d104432b(Object value1) {
    return 'Falhou $value1';
  }

  @override
  String get legacyUi3fb75e3bfe => 'Redefinir senha';

  @override
  String get legacyUif99d98e85f => 'Esqueceu a senha';

  @override
  String get legacyUi0d2afda86b => 'Ambiente de demonstração aberto';

  @override
  String get legacyUif06ccf010d => 'Login realizado';

  @override
  String get legacyUifc45091249 => 'Mudar para o tema claro';

  @override
  String get legacyUic29220f958 => 'Mudar para o tema escuro';

  @override
  String get legacyUi257616b8e4 => 'Nenhuma notificação não lida';

  @override
  String get legacyUid2609b6af1 => 'Nenhuma notificação ainda';

  @override
  String get legacyUi04d956a670 =>
      'Tudo está marcado como lido. Novos alertas aparecerão aqui quando chegarem.';

  @override
  String get legacyUi7fe220bd95 =>
      'Alertas de veículos, eventos do sistema e atualizações operacionais aparecerão aqui.';

  @override
  String get legacyUib2f3a86e84 => 'Tudo lido';

  @override
  String get legacyUicbf6939e9e => 'Marcando…';

  @override
  String get legacyUi8958e22c23 => 'Marcar todas como lidas';

  @override
  String legacyUicb9ae54e8a(Object value1, Object value2) {
    return 'Mostrando $value1 de $value2';
  }

  @override
  String legacyUie5b28b8ae4(Object value1, Object value2) {
    return 'Página $value1 de $value2';
  }

  @override
  String get legacyUic1d317a815 => 'Nenhum chamado correspondente';

  @override
  String get legacyUiae9e814889 => 'Nenhum chamado';

  @override
  String get legacyUicc80739f43 => 'Tente outra busca ou filtro de status.';

  @override
  String get legacyUib1ac2d29f2 =>
      'Crie um chamado e a equipe dará continuidade aqui.';

  @override
  String legacyUia6864fdac8(Object value1) {
    return '$value1 linhas';
  }

  @override
  String get legacyUi8f26c6520d => 'Carregando';

  @override
  String legacyUie7a93c340a(Object value1) {
    return '$value1 eventos';
  }

  @override
  String get legacyUia4ab77ad86 => 'Evento OpenVTS';

  @override
  String get legacyUif55aae5a86 => 'IMEI indisponível';

  @override
  String get legacyUib8eb4a7ee3 => 'Carregando comandos…';

  @override
  String get legacyUif7933da683 => 'Nenhum comando compatível';

  @override
  String get legacyUi4be4430e57 => 'Selecionar comando';

  @override
  String legacyUi70ac5dd63e(Object value1) {
    return 'LINHA DO TEMPO ($value1)';
  }

  @override
  String legacyUi24d8fbef9d(Object value1, Object value2) {
    return '$value1 ${value2}x';
  }

  @override
  String legacyUibde2a7e880(Object value1, Object value2, Object value3) {
    return 'Página $value1 de $value2 · $value3 viagens';
  }

  @override
  String legacyUi08343b3fe7(Object value1) {
    return '$value1 restantes';
  }

  @override
  String legacyUi843b148bbc(Object value1) {
    return 'Chegada prevista $value1';
  }

  @override
  String legacyUi46d11990c5(Object value1) {
    return 'Posição atualizada $value1';
  }

  @override
  String legacyUiecd87f34a4(Object value1) {
    return 'Excluir $value1?';
  }

  @override
  String legacyUi666b616488(Object value1) {
    return 'Expira $value1';
  }

  @override
  String get legacyUic7ac551ef0 => 'Excluindo…';

  @override
  String legacyUi27015ac78b(Object value1, Object value2) {
    return '$value1 não lidas · $value2 notificações mais recentes';
  }

  @override
  String legacyUi46b0a7d4ca(Object value1, Object value2) {
    return '$value1 / $value2 paradas concluídas';
  }

  @override
  String get legacyUidc7f2c3785 => 'Data indisponível';

  @override
  String get legacyUib11b062b52 => 'Enviar comprovante de viagem';

  @override
  String get legacyUi8f1a9ca44a => 'PDF, JPG, PNG ou WebP · Até 5 MB';

  @override
  String get legacyUi91df716a6b =>
      'PDF, JPG, PNG, WebP, DOC ou DOCX · Até 5 MB';

  @override
  String get legacyUid921a79afa => 'Enviando…';

  @override
  String legacyUiba9b85b92a(Object value1) {
    return 'Última atualização $value1';
  }

  @override
  String legacyUib9f8dfe265(Object value1) {
    return 'Distância hoje: $value1';
  }

  @override
  String legacyUif0ea529a1a(Object value1) {
    return '$value1 dias';
  }

  @override
  String legacyUi387c4ee271(Object value1, Object value2) {
    return '$value1  ·  $value2 dias';
  }

  @override
  String get legacyUideba3e1d0f => 'Resumo da simulação';

  @override
  String get legacyUia7d0c36803 => 'Última limpeza';

  @override
  String legacyUia24243eb0c(Object value1) {
    return 'Tabelas ($value1)';
  }

  @override
  String get legacyUic74a3012a0 => 'Verificando status…';

  @override
  String get legacyUie991a76914 => 'Status desconhecido';

  @override
  String get legacyUia722bd6476 =>
      'Crescimento da plataforma em usuários, veículos e licenças.';

  @override
  String legacyUi852c487a99(Object value1) {
    return 'Pico de licenças $value1';
  }

  @override
  String legacyUic44efcae53(Object value1) {
    return 'Remover $value1 da plataforma? Esta ação não pode ser desfeita.';
  }

  @override
  String legacyUicac4f1ac56(Object value1) {
    return 'Administrador $value1';
  }

  @override
  String legacyUi68401f3c9e(Object value1, Object value2) {
    return 'Média de $value1 $value2 por transação';
  }

  @override
  String get legacyUi526698fef7 => 'Não foi possível atualizar os veículos.';

  @override
  String legacyUie9b7179dd3(Object value1) {
    return 'Documentos ($value1)';
  }

  @override
  String get legacyUiefd8314874 => 'Não foi possível atualizar os documentos.';

  @override
  String get legacyUie214b8a299 => 'Documento';

  @override
  String legacyUidb4675bc22(Object value1) {
    return 'Saldo $value1';
  }

  @override
  String legacyUi16be827cb6(Object value1) {
    return 'Veículo $value1';
  }

  @override
  String get legacyUibd5caf1601 =>
      'O rastreamento está bloqueado pelo limite da licença do software.';

  @override
  String get legacyUid8663517be => 'Última verificação: —';

  @override
  String get legacyUi1be0035c25 => 'Próprio';

  @override
  String get legacyUi5f1184f7df => 'Global';

  @override
  String get legacyUif5f940cfe2 => 'Salvar permissões';

  @override
  String legacyUi8a9135d5ad(Object value1) {
    return '$value1% recebido';
  }

  @override
  String legacyUi3b0c54fa00(Object value1) {
    return 'Projetado $value1';
  }

  @override
  String legacyUi16ff2e7fa9(Object value1) {
    return 'Diferença $value1';
  }

  @override
  String legacyUi4956298616(Object value1, Object value2) {
    return '$value1 veíc. · $value2';
  }

  @override
  String legacyUi120d777276(Object value1) {
    return 'Pago $value1';
  }

  @override
  String legacyUi617d0ebe3d(Object value1, Object value2) {
    return '$value1 de $value2 planos';
  }

  @override
  String get legacyUi25422daedb => 'Veículo sem nome';

  @override
  String legacyUicbbe928bb9(Object value1) {
    return 'Cobertura anual: $value1';
  }

  @override
  String legacyUiec60ebb81f(Object value1) {
    return 'Serviço ao cliente: $value1';
  }

  @override
  String legacyUiced28bc228(Object value1) {
    return 'Créditos da conta: $value1';
  }

  @override
  String get legacyUic1a90693df => 'Rastreamento ao vivo ativo';

  @override
  String legacyUi4bdc33e519(Object value1, Object value2) {
    return '$value1 · $value2 dias';
  }

  @override
  String get legacyUi889f282a7d => 'Escolher data e hora';

  @override
  String get legacyUi83cbbbc297 => 'Salvar alterações do serviço';

  @override
  String get legacyUi69feaaf8cd => 'Todas as datas';

  @override
  String get legacyUi0c6c4102d4 => 'Opcional';

  @override
  String legacyUic57882f9c9(Object value1) {
    return 'Status: $value1';
  }

  @override
  String legacyUiae3c1f8817(Object value1) {
    return 'Enviar este comando para $value1?';
  }

  @override
  String legacyUic51f739b4e(Object value1) {
    return 'Usuários atribuídos ($value1)';
  }

  @override
  String get legacyUibc7819b34f => 'Desconhecido';

  @override
  String legacyUi46aece3259(Object value1) {
    return 'Remover $value1 deste veículo?';
  }

  @override
  String legacyUi3d2bb84b75(Object value1, Object value2) {
    return 'Valor ao vivo: $value1 $value2';
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
    return 'Arquivo: $value1';
  }

  @override
  String legacyUi3ce1585208(Object value1) {
    return 'Validade: $value1';
  }

  @override
  String legacyUiaeafae8a12(Object value1) {
    return 'Visibilidade: $value1';
  }

  @override
  String legacyUi39d7217391(Object value1) {
    return 'Etiquetas: $value1';
  }

  @override
  String legacyUi4439ddf5a2(Object value1) {
    return 'Criado: $value1';
  }

  @override
  String legacyUid5c6adaee3(Object value1) {
    return 'Remover $value1 deste motorista?';
  }

  @override
  String get legacyUieb7eb7a819 => 'Escolher arquivo';

  @override
  String get legacyUi8f8dd8dbd3 => 'Oculto para o administrador';

  @override
  String get legacyUi65d06317e9 =>
      'Os administradores podem ver este documento';

  @override
  String get legacyUic0e9577a75 => 'Somente o proprietário pode ver';

  @override
  String legacyUi864cf8bc08(Object value1) {
    return 'Atributos: $value1';
  }

  @override
  String legacyUi90d40c4249(Object value1) {
    return 'Bruto: $value1';
  }

  @override
  String get legacyUia4d06ed284 => 'Evento do veículo';

  @override
  String legacyUifba61e1a50(Object value1, Object value2, Object value3,
      Object value4, Object value5, Object value6) {
    return '$value1 • $value2 • enviado $value3 • entregue $value4 • nova tentativa $value5$value6';
  }

  @override
  String legacyUi9c07a085f8(Object value1, Object value2) {
    return '$value1 de $value2 transações';
  }

  @override
  String legacyUi26b3b5dfb3(Object value1) {
    return '$value1 Tentar novamente';
  }

  @override
  String legacyUi05563fda41(Object value1, Object value2, Object value3) {
    return 'Plano: $value1 • $value2 $value3';
  }

  @override
  String legacyUi26400a7353(Object value1, Object value2) {
    return '$value1 veículo$value2 selecionado';
  }

  @override
  String legacyUi8f4ab245d3(Object value1, Object value2) {
    return 'Total automático: $value1 $value2';
  }

  @override
  String get legacyUi493de0b548 => 'Cotação expirada';

  @override
  String legacyUi78218dbd5f(Object value1, Object value2, Object value3) {
    return '$value1 · $value2 · $value3 dias';
  }

  @override
  String legacyUi13e7357d18(Object value1) {
    return 'Recebi $value1';
  }

  @override
  String get legacyUi7e72a446c4 => 'Ocultar filtros de pagamento';

  @override
  String get legacyUi8f642c1d28 => 'Mostrar filtros de pagamento';

  @override
  String legacyUi184c3f0cbb(Object value1) {
    return 'ID da transação: $value1';
  }

  @override
  String legacyUi281961b9ee(Object value1) {
    return 'Valor: $value1';
  }

  @override
  String legacyUib40416c0af(Object value1) {
    return 'Tipo de pagamento: $value1';
  }

  @override
  String legacyUia0d65517a6(Object value1) {
    return 'Forma de pagamento: $value1';
  }

  @override
  String legacyUic2d62e9f71(Object value1) {
    return 'Referência: $value1';
  }

  @override
  String legacyUib0f627962a(Object value1) {
    return 'Provedor: $value1';
  }

  @override
  String legacyUie802a1b0a0(Object value1) {
    return 'Referência do provedor: $value1';
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
    return 'Veículo: $value1';
  }

  @override
  String legacyUi2b542f8050(Object value1) {
    return 'IMEI: $value1';
  }

  @override
  String legacyUi76e24a00cf(Object value1) {
    return 'Plano: $value1';
  }

  @override
  String legacyUi972db7d65e(Object value1) {
    return 'Código da falha: $value1';
  }

  @override
  String legacyUif147c11396(Object value1) {
    return 'Mensagem da falha: $value1';
  }

  @override
  String get legacyUic3146cdbec =>
      'Crie um chamado para iniciar uma conversa com o suporte.';

  @override
  String legacyUi2cbdc50885(Object value1) {
    return 'Remover $value1 desta conta de administrador?';
  }

  @override
  String legacyUi073ab8a05c(Object value1, Object value2) {
    return '$value1 atribuídos - $value2 disponíveis';
  }

  @override
  String legacyUidcc59f9fcf(Object value1) {
    return 'Selecionar $value1';
  }

  @override
  String get legacyUi7a19b6deae => 'Nenhuma opção disponível';

  @override
  String get legacyUif28cfb8eb0 => '1 chamado';

  @override
  String legacyUidf08f563b7(Object value1) {
    return 'Arquivos opcionais, até $value1.';
  }

  @override
  String get legacyUi5f2b4010d1 => '1 pagamento';

  @override
  String get legacyUi876081608a => 'Renovação — 1 veículo';

  @override
  String legacyUia034f3f5e5(Object value1) {
    return 'Total estimado $value1';
  }

  @override
  String legacyUic07d143675(Object value1) {
    return 'Veículos renovados ($value1)';
  }

  @override
  String legacyUiff384c8aa4(Object value1) {
    return 'Remover $value1 deste usuário?';
  }

  @override
  String legacyUicb6d241451(Object value1, Object value2) {
    return '$value1 arquivos - $value2 tipos de usuário';
  }

  @override
  String get legacyUif63f04564a => 'Carregando tipos de usuário';

  @override
  String get legacyUi74b1d89d85 => 'Escolha um arquivo';

  @override
  String get legacyUi62783d600b => 'Exibido nos documentos do usuário';

  @override
  String get legacyUi38fc177e28 => 'Oculto para o usuário';

  @override
  String legacyUibce346e856(Object value1, Object value2) {
    return '$value1 usuário$value2';
  }

  @override
  String get legacyUi674b652fca => 'Alterar datas';

  @override
  String get legacyUi08d0e4f72a => 'Carregando transações…';

  @override
  String get legacyUib3a56d64d2 =>
      'Nenhuma transação corresponde a estes filtros.';

  @override
  String get legacyUi049ac820da => 'Processando...';

  @override
  String legacyUie783127bc1(Object value1) {
    return 'Ingressou $value1';
  }

  @override
  String legacyUieb587f7802(Object value1) {
    return 'Perfil atualizado $value1';
  }

  @override
  String get legacyUi1dfc507715 =>
      'As referências de país e prefixo de celular estão indisponíveis. Você ainda pode editar manualmente.';

  @override
  String get legacyUia7c1498ab2 =>
      'Você está inscrito nas notificações de perfil por e-mail.';

  @override
  String get legacyUi77653a7db4 =>
      'Inscreva-se para receber atualizações de perfil e conta por e-mail.';

  @override
  String get legacyUid3b8add13e => 'Opções indisponíveis.';

  @override
  String legacyUi08b544b680(Object value1) {
    return 'Percorrido $value1';
  }

  @override
  String legacyUi6c783ae69f(Object value1) {
    return 'Mostrando 10 dos $value1 alertas mais recentes';
  }

  @override
  String get legacyUi45ef37a941 => 'Nenhuma mensagem fornecida.';

  @override
  String get legacyUia2ae39a298 => 'Canal desconhecido';

  @override
  String get legacyUiceafde86d6 => 'Enviando';

  @override
  String get legacyUi46cefb25e2 => 'Enviar comando';

  @override
  String legacyUib3d1704245(Object value1) {
    return 'Período diurno: $value1';
  }

  @override
  String legacyUi735f148a9a(Object value1) {
    return 'tipo: $value1';
  }

  @override
  String legacyUi828a91effc(Object value1, Object value2, Object value3) {
    return '$value1 de $value2 veículos • $value3 selecionados';
  }

  @override
  String legacyUia0ebdc2307(Object value1, Object value2, Object value3) {
    return '$value1 visíveis • $value2/$value3 carregados';
  }

  @override
  String legacyUi1d483a1343(Object value1) {
    return 'Remover $value1 deste subusuário?';
  }

  @override
  String legacyUi02b84d460d(Object value1) {
    return '$value1 disponíveis para atribuição';
  }

  @override
  String get legacyUi65ad788d45 => 'Placa indisponível';

  @override
  String get legacyUi7bb4f2808b =>
      'O subusuário pode acessar os veículos atribuídos';

  @override
  String get legacyUi26b21a0d91 => 'O subusuário está desativado';

  @override
  String legacyUibceb1630f0(Object value1, Object value2) {
    return '$value1 arquivos - $value2 tipos de documento';
  }

  @override
  String get legacyUi107b9056eb => 'Carregando tipos de motorista';

  @override
  String legacyUifd7e37cf51(Object value1, Object value2) {
    return '$value1 de $value2 motoristas';
  }

  @override
  String legacyUi14b274c7ae(Object value1, Object value2) {
    return '$value1 de $value2 veículos';
  }

  @override
  String legacyUi79a100acf7(Object value1) {
    return 'Remover $value1?';
  }

  @override
  String legacyUi26875fe2e3(Object value1, Object value2) {
    return '$value1 arquivos - $value2 tipos de veículo';
  }

  @override
  String legacyUi7970bd3e0b(Object value1) {
    return 'Não foi possível carregar $value1.';
  }

  @override
  String get legacyUi5eaf2646c3 => 'Carregando tipos de veículo';

  @override
  String get legacyUi6ca60537ae => 'Exibido nos documentos do veículo';

  @override
  String get legacyUi4e3d045a97 => 'Oculto para os usuários';

  @override
  String get legacyUid3ce77345e => 'Histórico do sensor';

  @override
  String legacyUi5aba89cd2f(Object value1) {
    return '$value1 pontos numéricos';
  }

  @override
  String get legacyUie86a33f16a => 'Todas as cercas virtuais';

  @override
  String legacyUi5321a316d0(Object value1) {
    return 'Origem: $value1';
  }

  @override
  String legacyUifabeb88d9c(Object value1) {
    return 'Usar $value1 selecionados';
  }

  @override
  String legacyUi343ceded71(Object value1) {
    return 'Eventos por cerca virtual ($value1 principais)';
  }

  @override
  String legacyUide36170209(Object value1) {
    return 'Tipos de alerta ($value1 principais)';
  }

  @override
  String legacyUi019e5212ef(Object value1, Object value2) {
    return '$value1 km/h (limite $value2)';
  }

  @override
  String legacyUicaae0add4a(Object value1, Object value2) {
    return '$value1 dia$value2 ativo';
  }

  @override
  String legacyUi7911e1ad0c(Object value1, Object value2) {
    return '$value1 resultado$value2';
  }

  @override
  String legacyUi15b175bbc9(Object value1) {
    return 'Gerado em $value1';
  }

  @override
  String legacyUi92a50db48d(Object value1) {
    return 'Exportar relatório $value1';
  }

  @override
  String legacyUida6472ea1a(Object value1) {
    return 'Todos os $value1 veículos serão incluídos';
  }

  @override
  String get legacyUib0c379b2f8 => 'Selecione um grupo de veículos';

  @override
  String get legacyUi23d6943e8b => 'Selecionar veículos';

  @override
  String legacyUi47b7508acb(Object value1) {
    return 'Concluir ($value1)';
  }

  @override
  String legacyUid495bed9d8(Object value1) {
    return 'Selecionar todos os visíveis ($value1)';
  }

  @override
  String legacyUi096909f019(Object value1, Object value2) {
    return '$value1 veículo$value2';
  }

  @override
  String legacyUie003b8a491(Object value1) {
    return 'Máximo de $value1 dias para este tipo de relatório';
  }

  @override
  String legacyUif386fe6e70(Object value1) {
    return 'Limpar ($value1)';
  }

  @override
  String get legacyUi706049c6a9 => 'Selecione um sensor';

  @override
  String legacyUi2841c7f501(Object value1) {
    return 'Nenhum relatório encontrado para \"$value1\"';
  }

  @override
  String legacyUi8002c1aa36(Object value1) {
    return 'Os horários usam $value1.';
  }

  @override
  String legacyUieaa190f343(Object value1) {
    return '$value1 ativados';
  }

  @override
  String legacyUidc179fe07f(Object value1) {
    return 'O limite de velocidade deve ser de pelo menos 1 $value1.';
  }

  @override
  String legacyUi11003e8471(Object value1) {
    return 'Canais de entrega de $value1';
  }

  @override
  String legacyUidc7454d672(Object value1) {
    return 'Último salvamento $value1';
  }

  @override
  String get legacyUi7968beb979 => 'Código -';

  @override
  String legacyUi0528ad37c9(Object value1, Object value2) {
    return '$value1 de $value2 links';
  }

  @override
  String get legacyUiac2a036e38 => 'Nenhuma atividade ainda';

  @override
  String legacyUi3a4361ec75(Object value1) {
    return '\"$value1\" será removido permanentemente.';
  }

  @override
  String get legacyUi50a9e13fce => 'Cerca virtual sem nome';

  @override
  String legacyUi760cb5d683(Object value1, Object value2) {
    return '$value1 ponto$value2';
  }

  @override
  String legacyUifa6e784713(Object value1) {
    return 'Remover nº $value1';
  }

  @override
  String legacyUi27a25269f5(Object value1) {
    return 'Ajuste fino ($value1 m)';
  }

  @override
  String get legacyUi39706b5a17 => 'Ainda sem geometria';

  @override
  String get legacyUi1bf6cb6c45 => 'Geometria pronta';

  @override
  String get legacyUi5d437ca98b =>
      'Os eventos serão acionados para esta cerca virtual.';

  @override
  String get legacyUi6d8b4724c6 => 'A cerca virtual está pausada.';

  @override
  String get legacyUi7e9f5c3026 => 'Desenhe pelo menos 2 pontos no mapa.';

  @override
  String get legacyUi28134edb87 => 'Editar no mapa';

  @override
  String get legacyUi0f873fbc31 => 'Desenhar no mapa';

  @override
  String legacyUi48f6c8c8ac(Object value1) {
    return '$value1 m';
  }

  @override
  String legacyUicde59da67c(Object value1) {
    return '$value1 min';
  }

  @override
  String get legacyUi4bd1e22ea7 => 'Rota sem nome';

  @override
  String legacyUi198f442dfb(Object value1) {
    return 'Vértice $value1';
  }

  @override
  String legacyUibae08b3767(Object value1, Object value2) {
    return 'Linha $value1: $value2';
  }

  @override
  String get legacyUi93039e609d => 'Não definido';

  @override
  String get legacyUid33a96e366 => 'Selecionar no mapa';

  @override
  String get legacyUiecd575d434 =>
      'Visível no mapa ao vivo e nos alertas de proximidade.';

  @override
  String get legacyUi92a172ce15 => 'Oculto dos alertas; permanece na lista.';

  @override
  String get legacyUi8019307fe5 => 'POI sem nome';

  @override
  String get legacyUid14e0c02a9 => 'Rastreamento ao vivo disponível';

  @override
  String legacyUic814ea2b6e(Object value1) {
    return 'Início do serviço: $value1';
  }

  @override
  String legacyUic926abedfd(Object value1) {
    return 'Serviço ao cliente expira em: $value1';
  }

  @override
  String legacyUiae0052da76(Object value1) {
    return 'Cobertura do provedor expira em: $value1';
  }

  @override
  String legacyUi633ec01c21(Object value1, Object value2) {
    return '$value1 • $value2 dias';
  }

  @override
  String get legacyUicf765512cc => 'Enviando…';

  @override
  String get legacyUi50756f98a3 => 'Solicitar renovação';

  @override
  String legacyUid52adacef9(Object value1) {
    return 'Solicitação nº $value1';
  }

  @override
  String get legacyUicfeb791a76 => 'Solicitação expirada';

  @override
  String legacyUif0d8958371(Object value1, Object value2, Object value3,
      Object value4, Object value5) {
    return '$value1\n$value2 • $value3 dias\n$value4 $value5\n\nO administrador deve confirmar o pagamento antes que o serviço seja prorrogado.';
  }

  @override
  String get legacyUifdb17036d5 => 'Usuário OpenVTS';

  @override
  String legacyUif7e83b3f19(Object value1) {
    return 'Restaurar padrão ($value1)';
  }

  @override
  String legacyUi54e519da7f(Object value1) {
    return 'Erro: $value1';
  }

  @override
  String get legacyUi7eb29d3565 => 'Data e hora';

  @override
  String get legacyUib1deb07e61 => 'Abrir cerca virtual';

  @override
  String get legacyUi1dce4bf43b => 'Abrir POI';

  @override
  String get legacyUi4a0d050737 => 'Abrir rota';

  @override
  String get legacyUib6bd42e4e7 => 'Em andamento';

  @override
  String get legacyUi91edf8aff9 => 'Em viagem';

  @override
  String get legacyUi20c7c5522f => 'Pronto';

  @override
  String get legacyUi0a2b58e839 => 'Sem atribuição';

  @override
  String get legacyUi6cf3d41f08 => 'Todas as viagens';

  @override
  String get legacyUif7a616a336 => 'Acesso bloqueado';

  @override
  String get legacyUiac7b5dd3a8 => 'Destinatário indisponível';

  @override
  String get legacyUi936d2e8552 => 'Problema com o veículo';

  @override
  String get legacyUi51cea59031 => 'Problema com a rota';

  @override
  String get legacyUia972b55b1a => 'Descreva o problema para a central.';

  @override
  String get legacyUie0cdc02f99 => 'Horário de 12 horas';

  @override
  String get legacyUif910251f7c => 'Horário de 24 horas';

  @override
  String get legacyUi34ce147724 => 'Da esquerda para a direita';

  @override
  String get legacyUida502a644e => 'Da direita para a esquerda';

  @override
  String get legacyUiec45717e13 =>
      'Entre em contato com a central para obter detalhes.';

  @override
  String get legacyUi8a783eb3d6 => 'Atribuição confirmada.';

  @override
  String get legacyUi00e1e19595 => 'Iniciar viagem';

  @override
  String get legacyUi0015b1903d =>
      'As viagens normalmente começam pela telemetria do veículo. Use esta alternativa manual apenas ao iniciar a viagem.';

  @override
  String get legacyUib20bd98ae2 => 'Adicionar observação';

  @override
  String get legacyUi42477e82cf => 'Não foi possível abrir a navegação.';

  @override
  String get legacyUiea0bd6ff3d => 'Concluir parada';

  @override
  String get legacyUi3d93beaa39 =>
      'Selecione um arquivo não vazio de até 5 MB.';

  @override
  String get legacyUid2085cce0d => 'Selecione um arquivo para enviar.';

  @override
  String get legacyUid0193e6956 => 'Selecione um tipo de documento.';

  @override
  String get legacyUif378218081 => 'Digite pelo menos 2 caracteres.';

  @override
  String get legacyUi63f72dce85 => 'Selecionar arquivo';

  @override
  String get legacyUi1255774559 => 'Atribuições de hoje';

  @override
  String get legacyUi3528465759 => 'Viagens concluídas';

  @override
  String get legacyUi28793a4155 => 'Paradas concluídas';

  @override
  String get legacyUi1683af6ce8 => 'Paradas pendentes';

  @override
  String mobilePluralTrips(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count viagens',
      one: '$count viagem',
      zero: '0 viagens',
    );
    return '$_temp0';
  }

  @override
  String mobilePluralBlockedVehicles(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count veículos bloqueados excluídos.',
      one: '$count veículo bloqueado excluído.',
      zero: 'Nenhum veículo bloqueado excluído.',
    );
    return '$_temp0';
  }

  @override
  String mobilePluralSelectedVehicles(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count veículos selecionados',
      one: '$count veículo selecionado',
      zero: '0 veículos selecionados',
    );
    return '$_temp0';
  }

  @override
  String mobilePluralUsers(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count usuários',
      one: '$count usuário',
      zero: '0 usuários',
    );
    return '$_temp0';
  }

  @override
  String mobilePluralActiveDays(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dias ativos',
      one: '$count dia ativo',
      zero: '0 dias ativos',
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
      zero: '0 resultados',
    );
    return '$_temp0';
  }

  @override
  String mobilePluralVehicles(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count veículos',
      one: '$count veículo',
      zero: '0 veículos',
    );
    return '$_temp0';
  }

  @override
  String mobilePluralPoints(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pontos',
      one: '$count ponto',
      zero: '0 pontos',
    );
    return '$_temp0';
  }

  @override
  String get relativeJustNow => 'agora';

  @override
  String relativeMinutesAgo(int count) {
    return 'há $count min';
  }

  @override
  String relativeHoursAgo(int count) {
    return 'há $count h';
  }

  @override
  String relativeDaysAgo(int count) {
    return 'há $count d';
  }

  @override
  String get relativeYesterday => 'ontem';

  @override
  String savingChangesForTab(String tab) {
    return 'Salvando alterações de $tab…';
  }

  @override
  String unsavedChangesForTab(String tab) {
    return 'Você tem alterações não salvas em $tab.';
  }

  @override
  String get saving => 'Salvando…';

  @override
  String validationRequired(String field) {
    return '$field é obrigatório';
  }

  @override
  String validationAscii(String field) {
    return '$field deve conter apenas caracteres ASCII';
  }

  @override
  String validationMinCharacters(String field, int count) {
    return '$field deve ter pelo menos $count caracteres';
  }

  @override
  String validationMaxCharacters(String field, int count) {
    return '$field deve ter no máximo $count caracteres';
  }

  @override
  String validationMinDigits(String field, int count) {
    return '$field deve ter pelo menos $count dígitos';
  }

  @override
  String validationMaxDigits(String field, int count) {
    return '$field deve ter no máximo $count dígitos';
  }

  @override
  String validationNumeric(String field) {
    return '$field deve conter apenas números';
  }

  @override
  String validationMinimumCharacters(int count) {
    return 'Mínimo de $count caracteres';
  }

  @override
  String get validationValidEmail => 'Insira um endereço de e-mail válido';

  @override
  String get validationValidNumber => 'Insira um número válido';

  @override
  String get validationNonnegativeCredits =>
      'Os créditos não podem ser negativos';

  @override
  String get validationConfirmPassword => 'Confirme a senha';

  @override
  String get validationPasswordsMismatch => 'As senhas não coincidem';

  @override
  String get validationStandardVin =>
      'O VIN deve ter 17 caracteres alfanuméricos, exceto I, O e Q';

  @override
  String get validationVinAlphanumeric =>
      'O VIN deve conter apenas letras e números';

  @override
  String get validationThisField => 'Este campo';

  @override
  String get validationFieldSimNumber => 'Número do SIM';

  @override
  String get mobileDataBackup => 'Cópia de segurança dos dados';

  @override
  String get mobileEffectiveRetention => 'Retenção efetiva';

  @override
  String get mobileAdministratorLimit => 'Limite do administrador';

  @override
  String get mobilePolicySource => 'Origem da política';

  @override
  String mobileUseAdministratorPolicy(String value1) {
    return 'Usar a política do administrador ($value1)';
  }

  @override
  String get mobileRetentionCleanupNotice =>
      'A limpeza programada remove a telemetria histórica anterior ao período de retenção. Aumentar a retenção não restaura os dados excluídos.';

  @override
  String mobileRetentionLimitError(String value1) {
    return 'O período de retenção não pode exceder $value1 dias.';
  }

  @override
  String get mobileRetentionLoadError =>
      'Não foi possível carregar a retenção de dados';

  @override
  String get mobileRetentionSaveError =>
      'Não foi possível salvar a retenção de dados';

  @override
  String get mobileRetentionSaved => 'Retenção de dados atualizada';

  @override
  String get mobileRetentionUnsupported =>
      'O servidor retornou uma política de retenção não compatível. A edição está desativada.';

  @override
  String get mobileDiscardDetailChanges =>
      'As alterações serão perdidas. Continuar?';

  @override
  String get mobileLiveTrackingReconnecting =>
      'Reconectando o rastreamento ao vivo…';

  @override
  String get mobileLastConnection => 'Última conexão';

  @override
  String get mobileTeamLoadError =>
      'Não foi possível carregar o membro da equipe.';

  @override
  String get mobilePermissionsLoadError =>
      'Não foi possível carregar as permissões.';

  @override
  String get mobileActivityLoadError =>
      'Não foi possível carregar a atividade.';

  @override
  String get mobilePermissionsRetryError =>
      'Não foi possível carregar ou salvar as permissões. Tente novamente.';

  @override
  String get mobilePermissionMaps => 'Mapas';

  @override
  String get mobilePermissionLandmarks => 'Pontos de referência';

  @override
  String get mobilePermissionShareTracking =>
      'Compartilhar link de rastreamento';

  @override
  String get mobilePrivacyPolicyLink => 'Política de privacidade';

  @override
  String get mobilePageLinkError =>
      'Não foi possível abrir esta página. Tente novamente.';
}
