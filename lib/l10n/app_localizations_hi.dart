// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get date => 'दिनांक';

  @override
  String get time => 'समय';

  @override
  String get direction => 'दिशा';

  @override
  String get units => 'इकाइयाँ';

  @override
  String get appTitle => 'OpenVTS';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get localization => 'स्थानीयकरण';

  @override
  String get language => 'भाषा';

  @override
  String get theme => 'थीम';

  @override
  String get dateFormat => 'तारीख प्रारूप';

  @override
  String get timeFormat => 'समय प्रारूप';

  @override
  String get timezone => 'समय क्षेत्र';

  @override
  String get use24Hour => '24-घंटे का समय';

  @override
  String get save => 'सहेजें';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get edit => 'संपादित करें';

  @override
  String get search => 'खोज';

  @override
  String get delete => 'हटाएं';

  @override
  String get reset => 'रीसेट करें';

  @override
  String get close => 'बंद करें';

  @override
  String get back => 'पीछे';

  @override
  String get next => 'अगला';

  @override
  String get prev => 'पिछला';

  @override
  String get loading => 'लोड हो रहा है...';

  @override
  String get error => 'त्रुटि';

  @override
  String get success => 'सफल';

  @override
  String get warning => 'चेतावनी';

  @override
  String get light => 'हल्का';

  @override
  String get dark => 'गहरा';

  @override
  String get system => 'सिस्टम';

  @override
  String get en => 'अंग्रेजी';

  @override
  String get hi => 'हिंदी';

  @override
  String get ar => 'अरबी';

  @override
  String get es => 'स्पेनिश';

  @override
  String get fr => 'फ्रेंच';

  @override
  String get pt => 'पुर्तगाली';

  @override
  String get profile => 'प्रोफाइल';

  @override
  String get logout => 'लॉगआउट';

  @override
  String get login => 'लॉगिन';

  @override
  String get register => 'पंजीकरण';

  @override
  String get administrators => 'प्रशासक';

  @override
  String get payments => 'भुगतान';

  @override
  String get support => 'समर्थन';

  @override
  String get tickets => 'टिकट';

  @override
  String get home => 'होम';

  @override
  String get dashboard => 'डैशबोर्ड';

  @override
  String get keepEditing => 'संपादन जारी रखें';

  @override
  String get discardChanges => 'परिवर्तन हटाएं';

  @override
  String get unsavedChanges => 'बिना सहेजे गए परिवर्तन';

  @override
  String get refresh => 'ताज़ा करें';

  @override
  String get selectLanguage => 'भाषा चुनें';

  @override
  String get selectTheme => 'थीम चुनें';

  @override
  String get selectDateFormat => 'तारीख प्रारूप चुनें';

  @override
  String get selectTimeFormat => 'समय प्रारूप चुनें';

  @override
  String get selectTimezone => 'समय क्षेत्र चुनें';

  @override
  String previewDate(String date) {
    return 'पूर्वावलोकन: $date';
  }

  @override
  String previewTime(String time) {
    return 'पूर्वावलोकन: $time';
  }

  @override
  String get settingsUpdated => 'सेटिंग्स अपडेट की गई';

  @override
  String get profileUpdated => 'प्रोफाइल अपडेट की गई';

  @override
  String get localizationUpdated => 'स्थानीयकरण सेटिंग्स अपडेट की गई';

  @override
  String get failedToUpdate => 'अपडेट करने में विफल। कृपया दोबारा प्रयास करें।';

  @override
  String get noData => 'कोई डेटा उपलब्ध नहीं है';

  @override
  String get retry => 'पुनः प्रयास करें';

  @override
  String get confirmDiscard => 'बिना सहेजे गए परिवर्तन हटाएं?';

  @override
  String confirmDiscardMessage(String tab) {
    return '$tab के अनसेव किए गए संपादन हैं। हटाने से ये परिवर्तन खो जाएंगे।';
  }

  @override
  String get reportsTitle => 'रिपोर्ट';

  @override
  String get reportsSearchHint => 'रिपोर्ट खोजें…';

  @override
  String reportsNoResultsFor(Object query) {
    return '\"$query\" के लिए कोई रिपोर्ट नहीं मिली';
  }

  @override
  String get reportsGenerate => 'रिपोर्ट बनाएं';

  @override
  String get reportsGenerating => 'बना रहा है…';

  @override
  String get reportsReset => 'रीसेट';

  @override
  String get reportsConfigureHint =>
      'उपर रिपोर्ट कॉन्फ़िगर करें और जनरेट दबाएं।';

  @override
  String get reportsNoResults => 'चुने गए फ़िल्टर के लिए कोई परिणाम नहीं मिला।';

  @override
  String get reportsErrorRetry => 'पुनः प्रयास';

  @override
  String reportsRowCount(Object count) {
    return '$count पंक्ति लोड की गई';
  }

  @override
  String get reportsLoadMore => 'और लोड करें';

  @override
  String get reportsLoadingMore => 'और लोड हो रहा है…';

  @override
  String reportsGeneratedAt(Object time) {
    return '$time को बनाया गया';
  }

  @override
  String get reportsExportTitle => 'रिपोर्ट एक्सपोर्ट';

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
  String get reportsScopeAll => 'सभी वाहन';

  @override
  String get reportsScopeSingle => 'एकल वाहन';

  @override
  String get reportsScopeMultiple => 'कई वाहन';

  @override
  String get reportsScopeGroup => 'समूह';

  @override
  String get reportsScopeSelectVehicle => 'वाहन चुनें';

  @override
  String get reportsScopeSelectVehicles => 'वाहन चुनें';

  @override
  String get reportsScopeSelectGroup => 'समूह चुनें';

  @override
  String get reportsScopeSearchHint => 'नाम, नंबर प्लेट या IMEI से खोजें…';

  @override
  String get reportsScopeSelectAll => 'सभी दिखाई देने वाले चुनें';

  @override
  String get reportsScopeDone => 'हो गया';

  @override
  String reportsScopeNVehiclesSelected(Object count) {
    return '$count वाहन चुने गए';
  }

  @override
  String get reportsDateStart => 'आरंभ की तारीख';

  @override
  String get reportsDateEnd => 'समाप्ति की तारीख';

  @override
  String get reportsDateFrom => 'आरंभ';

  @override
  String get reportsDateTo => 'समाप्ति';

  @override
  String reportsDateMaxDays(Object days) {
    return 'इस रिपोर्ट के लिए अधिकतम $days दिन';
  }

  @override
  String get reportsValidationScopeRequired => 'कृपया कम से कम एक वाहन चुनें।';

  @override
  String get reportsValidationStartRequired => 'आरंभ की तारीख ज़रूरी है।';

  @override
  String get reportsValidationEndRequired => 'समाप्ति की तारीख ज़रूरी है।';

  @override
  String get reportsValidationStartBeforeEnd =>
      'आरंभ का समय समाप्ति से पहले होना चाहिए।';

  @override
  String reportsValidationMaxDays(Object days) {
    return 'तारीख की सीमा इस रिपोर्ट की $days दिन की सीमा से अधिक है।';
  }

  @override
  String get reportsValidationSensorVehicleRequired =>
      'सेंसर रिपोर्ट के लिए वाहन चुनें।';

  @override
  String get reportsValidationSensorRequired => 'कृपया सेंसर चुनें।';

  @override
  String get reportsValidationTimelineStateRequired =>
      'कम से कम एक स्थिति (चल रहा या रुका हुआ) चुनें।';

  @override
  String get reportsFilterSpeedLimit => 'गति सीमा (किमी/घंटा)';

  @override
  String get reportsFilterSpeedCustom => 'कस्टम सीमा…';

  @override
  String get reportsFilterGeofenceHint => 'जियोफ़ेंस खोजें…';

  @override
  String get reportsFilterGeofenceAllNote =>
      'कुछ नहीं चुनने पर सभी जियोफ़ेंस शामिल होंगे।';

  @override
  String get reportsFilterAlertType => 'अलर्ट का प्रकार';

  @override
  String get reportsFilterAlertSeverity => 'गंभीरता';

  @override
  String get reportsFilterAlertAck => 'पुष्टि';

  @override
  String get reportsFilterAlertAckAll => 'सभी';

  @override
  String get reportsFilterAlertAckAcknowledged => 'पुष्टि की गई';

  @override
  String get reportsFilterAlertAckUnacknowledged => 'पुष्टि नहीं की गई';

  @override
  String get reportsFilterLogsVehicle => 'वाहन';

  @override
  String get reportsFilterLogsCategory => 'श्रेणी';

  @override
  String get reportsFilterLogsLevel => 'स्तर';

  @override
  String get reportsFilterTimelineRunning => 'चल रहा है';

  @override
  String get reportsFilterTimelineStopped => 'रुका हुआ';

  @override
  String get reportsFilterSensorVehicle => 'वाहन';

  @override
  String get reportsFilterSensorSensor => 'सेंसर';

  @override
  String get reportsCatalogDistanceTitle => 'दूरी';

  @override
  String get reportsCatalogDistanceDesc =>
      'हर वाहन की दैनिक कुल दूरी, इंजन घंटे और ओडोमीटर रीडिंग।';

  @override
  String get reportsCatalogDrivenTitle => 'चलाए गए दिन';

  @override
  String get reportsCatalogDrivenDesc =>
      'दैनिक दूरी तालिका — कौन से वाहन किन दिनों कितनी दूर चले।';

  @override
  String get reportsCatalogDetailsTitle => 'वाहन विवरण';

  @override
  String get reportsCatalogDetailsDesc =>
      'बेड़े का सारांश: हर वाहन की कुल दूरी, इंजन घंटे, सक्रिय दिन और अंतिम ज्ञात स्थान।';

  @override
  String get reportsCatalogOverspeedTitle => 'ओवरस्पीड';

  @override
  String get reportsCatalogOverspeedDesc =>
      'तेज़ गति की घटनाएँ: दर्ज गति, निर्धारित सीमा, अतिरिक्त गति, अवधि और स्थान।';

  @override
  String get reportsCatalogGeofenceTitle => 'जियोफेंस';

  @override
  String get reportsCatalogGeofenceDesc =>
      'चुने गए जियोफ़ेंस में प्रवेश और निकास, समय और रुकने की अवधि के साथ।';

  @override
  String get reportsCatalogAlertsTitle => 'अलर्ट';

  @override
  String get reportsCatalogAlertsDesc =>
      'प्रकार और गंभीरता के अनुसार अलर्ट, पुष्टि की स्थिति के साथ।';

  @override
  String get reportsCatalogSensorTitle => 'सेंसर';

  @override
  String get reportsCatalogSensorDesc =>
      'एक वाहन के विशिष्ट सेंसर की समयानुसार रीडिंग और चार्ट।';

  @override
  String get reportsCatalogLogsTitle => 'डिवाइस लॉग';

  @override
  String get reportsCatalogLogsDesc =>
      'वाहन उपकरणों के मूल संचार लॉग, श्रेणी और स्तर के अनुसार।';

  @override
  String get reportsCatalogTimelineTitle => 'समयरेखा';

  @override
  String get reportsCatalogTimelineDesc =>
      'चलने और रुकने के खंड, हर खंड की अवधि, दूरी और GPS पथ के साथ।';

  @override
  String get reportsKpiTotalDistance => 'कुल दूरी';

  @override
  String get reportsKpiEngineHours => 'इंजन घंटे';

  @override
  String get reportsKpiActiveVehicles => 'सक्रिय वाहन';

  @override
  String get reportsKpiAvgDistance => 'औसत दूरी';

  @override
  String get reportsKpiVehiclesDriven => 'चलाए गए वाहन';

  @override
  String get reportsKpiAvgDaily => 'दैनिक औसत';

  @override
  String get reportsKpiPeakDay => 'सर्वाधिक गतिविधि वाला दिन';

  @override
  String get reportsKpiViolations => 'उल्लंघन';

  @override
  String get reportsKpiAffectedVehicles => 'प्रभावित वाहन';

  @override
  String get reportsKpiHighestSpeed => 'अधिकतम गति';

  @override
  String get reportsKpiTotalDuration => 'कुल अवधि';

  @override
  String get reportsKpiTotalEvents => 'कुल घटनाएँ';

  @override
  String get reportsKpiEntries => 'प्रवेश';

  @override
  String get reportsKpiExits => 'निकास';

  @override
  String get reportsKpiTotalAlerts => 'कुल अलर्ट';

  @override
  String get reportsKpiCritical => 'अति गंभीर';

  @override
  String get reportsKpiAcknowledged => 'पुष्टि की गई';

  @override
  String get reportsKpiReadings => 'रीडिंग';

  @override
  String get reportsKpiOnEvents => 'चालू होने की घटनाएँ';

  @override
  String get reportsKpiOffEvents => 'बंद होने की घटनाएँ';

  @override
  String get reportsKpiTotalLogs => 'कुल लॉग';

  @override
  String get reportsKpiRunningDuration => 'चलने की अवधि';

  @override
  String get reportsKpiStoppedDuration => 'रुकने की अवधि';

  @override
  String get reportsKpiMovementDistance => 'चली गई दूरी';

  @override
  String get reportsKpiStopCount => 'रुकने की संख्या';

  @override
  String get reportsDetailTitle => 'पंक्ति का विवरण';

  @override
  String get reportsDetailRawPayload => 'मूल डेटा';

  @override
  String get reportsDetailCopied => 'कॉपी किया गया';

  @override
  String get reportsDetailCopy => 'कॉपी करें';

  @override
  String get reportsDetailTruncated =>
      'दिखाने के लिए डेटा छोटा किया गया है। पूरे डेटा के लिए निर्यात करें।';

  @override
  String get reportsRowDetailsViewMap => 'नक्शा देखें';

  @override
  String get reportsRowDetailsHideMap => 'नक्शा छिपाएँ';

  @override
  String get reportsRowDetailsNoGps => 'इस खंड के लिए GPS डेटा उपलब्ध नहीं है।';

  @override
  String reportsWarningBanner(Object message) {
    return 'चेतावनी: $message';
  }

  @override
  String reportsSourceLabel(Object source) {
    return 'स्रोत: $source';
  }

  @override
  String get adminRole => 'प्रशासक';

  @override
  String get users => 'उपयोगकर्ता';

  @override
  String get vehicles => 'वाहन';

  @override
  String get drivers => 'चालक';

  @override
  String get team => 'टीम';

  @override
  String get inventory => 'इन्वेंटरी';

  @override
  String get map => 'मानचित्र';

  @override
  String get transactions => 'लेन-देन';

  @override
  String get calendar => 'कैलेंडर';

  @override
  String get logs => 'लॉग';

  @override
  String get plans => 'योजनाएँ';

  @override
  String get roles => 'भूमिकाएँ';

  @override
  String get smtp => 'SMTP';

  @override
  String get settingsDescription =>
      'प्रोफ़ाइल, स्थानीयकरण और SMTP सेटिंग प्रबंधित करें।';

  @override
  String get localizationDescription =>
      'भाषा, दिनांक/समय, इकाइयाँ और डिफ़ॉल्ट मानचित्र केंद्र।';

  @override
  String get whiteLabel => 'व्हाइट लेबल';

  @override
  String get saveChanges => 'परिवर्तन सहेजें';

  @override
  String get textDirection => 'पाठ दिशा';

  @override
  String get languageAndDirection => 'भाषा और दिशा';

  @override
  String get languageAndDirectionSubtitle => 'इंटरफ़ेस भाषा और पाठ दिशा।';

  @override
  String get dateAndTime => 'दिनांक और समय';

  @override
  String get dateAndTimeSubtitle => 'दिनांक प्रारूप, समय शैली और समय क्षेत्र।';

  @override
  String get unitsAndTheme => 'इकाइयाँ और थीम';

  @override
  String get unitsAndThemeSubtitle => 'दूरी इकाइयाँ और ऐप स्वरूप।';

  @override
  String get defaultMapFocus => 'डिफ़ॉल्ट मानचित्र केंद्र';

  @override
  String get defaultMapFocusSubtitle =>
      'प्रारंभिक मानचित्र केंद्र और ज़ूम स्तर।';

  @override
  String get couldNotLoadLocalization => 'स्थानीयकरण लोड नहीं हो सका।';

  @override
  String get localizationSaved => 'स्थानीयकरण सहेजा गया';

  @override
  String get quickPresets => 'त्वरित प्रीसेट';

  @override
  String get settingsHeaderSubtitle =>
      'प्रोफ़ाइल, ब्रांडिंग, मेल, स्थानीयकरण और प्लेटफ़ॉर्म प्राथमिकताएँ।';

  @override
  String get localizationPreview => 'स्थानीयकरण पूर्वावलोकन';

  @override
  String get latitude => 'अक्षांश';

  @override
  String get longitude => 'देशांतर';

  @override
  String get mapZoom => 'मानचित्र ज़ूम';

  @override
  String get mapCenter => 'मानचित्र केंद्र';

  @override
  String get kilometers => 'किलोमीटर';

  @override
  String get miles => 'मील';

  @override
  String get latitudeRequired => 'अक्षांश आवश्यक है।';

  @override
  String get validLatitude => 'मान्य अक्षांश दर्ज करें।';

  @override
  String get latitudeRange => 'अक्षांश -90 और 90 के बीच होना चाहिए।';

  @override
  String get longitudeRequired => 'देशांतर आवश्यक है।';

  @override
  String get validLongitude => 'मान्य देशांतर दर्ज करें।';

  @override
  String get longitudeRange => 'देशांतर -180 और 180 के बीच होना चाहिए।';

  @override
  String get mapZoomRequired => 'मानचित्र ज़ूम आवश्यक है।';

  @override
  String get validMapZoom => 'मान्य ज़ूम स्तर दर्ज करें।';

  @override
  String get mapZoomRange => 'मानचित्र ज़ूम 1 और 22 के बीच होना चाहिए।';

  @override
  String get unsupportedLanguageFallback =>
      'सहेजी गई भाषा ऐप में उपलब्ध नहीं है। समर्थित भाषा चुनें; अभी अंग्रेज़ी का उपयोग किया जा रहा है।';

  @override
  String homeWorkspace(Object role) {
    return '$role कार्यक्षेत्र';
  }

  @override
  String get homeAccessUnavailable =>
      'कार्यक्षेत्र की पहुँच अपडेट नहीं हुई। दोबारा कोशिश के लिए नीचे खींचें।';

  @override
  String get homeCopyright => '© 2026 Open VTS सर्वाधिकार सुरक्षित।';

  @override
  String get lightMode => 'लाइट मोड';

  @override
  String get darkMode => 'डार्क मोड';

  @override
  String get landmarksStudio => 'स्थान प्रबंधन';

  @override
  String get trackLinks => 'ट्रैकिंग लिंक';

  @override
  String get messages => 'संदेश';

  @override
  String get accounts => 'खाते';

  @override
  String get notifications => 'सूचनाएँ';

  @override
  String get operations => 'संचालन';

  @override
  String get server => 'सर्वर';

  @override
  String get trips => 'यात्राएँ';

  @override
  String get documents => 'दस्तावेज़';

  @override
  String get userRole => 'उपयोगकर्ता';

  @override
  String get subuserRole => 'उप-उपयोगकर्ता';

  @override
  String get driverRole => 'ड्राइवर';

  @override
  String get superadminRole => 'सुपरएडमिन';

  @override
  String get demoReadOnly => 'डेमो • केवल देखने के लिए';

  @override
  String get security => 'सुरक्षा';

  @override
  String get routeBuilderCreate => 'रूट बनाएँ';

  @override
  String get routeBuilderEdit => 'रूट बदलें';

  @override
  String get routeBuilderName => 'रूट का नाम';

  @override
  String get routeBuilderNameHint => 'जैसे, सुबह की डिलीवरी';

  @override
  String get routeBuilderNameError =>
      'कम से कम 2 अक्षरों का रूट नाम दर्ज करें।';

  @override
  String get routeBuilderStops => 'ठहराव';

  @override
  String get routeBuilderAddStop => 'ठहराव जोड़ें';

  @override
  String get routeBuilderEditStop => 'ठहराव बदलें';

  @override
  String get routeBuilderStopName => 'ठहराव का नाम';

  @override
  String get routeBuilderStopNameError => '1 से 160 अक्षरों का नाम दर्ज करें।';

  @override
  String get routeBuilderAddress => 'पता (वैकल्पिक)';

  @override
  String get routeBuilderCoordinates => 'निर्देशांक';

  @override
  String get routeBuilderLatitude => 'अक्षांश';

  @override
  String get routeBuilderLongitude => 'देशांतर';

  @override
  String get routeBuilderCoordinateError =>
      'सही अक्षांश (−90 से 90) और देशांतर (−180 से 180) दर्ज करें।';

  @override
  String get routeBuilderMap => 'नक्शे पर चुनें';

  @override
  String get routeBuilderMapHint =>
      'ठहराव का स्थान चुनने के लिए नक्शे पर टैप करें।';

  @override
  String get routeBuilderUseLocation => 'यह स्थान चुनें';

  @override
  String get routeBuilderPoi => 'रुचि का स्थान';

  @override
  String get routeBuilderGeofence => 'जियोफ़ेंस';

  @override
  String get routeBuilderLandmarkSearch => 'सहेजे गए स्थान खोजें';

  @override
  String get routeBuilderNoLandmarks =>
      'सही निर्देशांक वाला कोई मिलता-जुलता स्थान नहीं है।';

  @override
  String get routeBuilderLandmarkError =>
      'सहेजे गए स्थान लोड नहीं हुए। दोबारा कोशिश करें।';

  @override
  String get routeBuilderStopLimit =>
      'रूट में वापसी के ठहराव सहित अधिकतम 100 ठहराव हो सकते हैं।';

  @override
  String get routeBuilderMinimumStops => 'कम से कम 2 अलग ठहराव जोड़ें।';

  @override
  String get routeBuilderRoundTrip => 'शुरुआत पर वापस जाएँ';

  @override
  String get routeBuilderRoundTripHint =>
      'शुरुआती स्थान को अंतिम गंतव्य बनाएँ।';

  @override
  String get routeBuilderOptimize => 'क्रम बेहतर करें';

  @override
  String get routeBuilderOptimizeHint =>
      'भौगोलिक दूरी से ठहरावों का क्रम बदलता है; शुरुआत और गंतव्य वही रहते हैं। सड़क की दूरी अलग से गिनी जाती है।';

  @override
  String get routeBuilderRoadPath => 'सड़क मार्ग देखें';

  @override
  String get routeBuilderRouting => 'सड़क का रूट निकाला जा रहा है…';

  @override
  String get routeBuilderRoutingError =>
      'सड़क का रूट उपलब्ध नहीं है। ठहराव के स्थान या कनेक्शन जाँचें और दोबारा कोशिश करें।';

  @override
  String get routeBuilderReady => 'सड़क का रूट तैयार है';

  @override
  String get routeBuilderChanged =>
      'ठहराव बदल गए हैं। सहेजने से पहले नया सड़क मार्ग देखें।';

  @override
  String get routeBuilderSaveError => 'रूट सहेजा नहीं गया। दोबारा कोशिश करें।';

  @override
  String get routeBuilderAccessDenied =>
      'आपको रूट बनाने या बदलने की अनुमति नहीं है।';

  @override
  String get routeBuilderOrigin => 'शुरुआत';

  @override
  String get routeBuilderDestination => 'गंतव्य';

  @override
  String get routeBuilderWaypoint => 'ठहराव';

  @override
  String get routeBuilderShapePoint => 'रूट का आकार';

  @override
  String get routeBuilderMoveUp => 'पहले रखें';

  @override
  String get routeBuilderMoveDown => 'बाद में रखें';

  @override
  String get routeBuilderRemove => 'ठहराव हटाएँ';

  @override
  String get routeBuilderNoStops =>
      'शुरुआत और गंतव्य जोड़ें, फिर बीच के ठहराव जोड़ें।';

  @override
  String get routeBuilderSavedGeometry => 'सहेजा गया रूट पथ';

  @override
  String get routeBuilderEditingLoadError =>
      'पूरा रूट लोड नहीं हुआ। वापस जाकर दोबारा कोशिश करें।';

  @override
  String get routeBuilderDiscardTitle => 'रूट के बदलाव छोड़ें?';

  @override
  String get routeBuilderDiscardMessage => 'रूट के बिना सहेजे बदलाव खो जाएँगे।';

  @override
  String get routeBuilderDiscard => 'छोड़ें';

  @override
  String get routeBuilderKeepEditing => 'बदलाव जारी रखें';

  @override
  String get routeBuilderClose => 'बंद करें';

  @override
  String get routeBuilderRetry => 'दोबारा कोशिश करें';

  @override
  String get routeBuilderMapAttribution =>
      '© OpenStreetMap योगदानकर्ता · रूट: OSRM';

  @override
  String get routeBuilderRouteDetails => 'रूट का विवरण';

  @override
  String get routeBuilderMinutes => 'मिनट';

  @override
  String get routeBuilderDistanceUnit => 'किमी';

  @override
  String get routeBuilderChooseSource => 'यहाँ से ठहराव जोड़ें';

  @override
  String get routeBuilderLandmarksPermission =>
      'सहेजे गए स्थानों के लिए स्थानों की अनुमति चाहिए।';

  @override
  String get routeBuilderShapeHint =>
      'आकार बिंदु सड़क के पथ को दिशा देते हैं; ये डिलीवरी ठहराव नहीं हैं। क्रम बेहतर करने पर ये बिंदु हटते हैं।';

  @override
  String get routeBuilderGeofenceHint =>
      'जियोफ़ेंस का केंद्र इस्तेमाल होता है। पुष्टि करें कि वहाँ सड़क से पहुँचा जा सकता है।';

  @override
  String selectField(Object field) {
    return '$field चुनें';
  }

  @override
  String searchField(Object field) {
    return '$field खोजें';
  }

  @override
  String noMatchingField(Object field) {
    return 'कोई मिलता-जुलता $field नहीं';
  }

  @override
  String fieldRequired(Object field) {
    return '$field ज़रूरी है।';
  }

  @override
  String get clearSelection => 'साफ़ करें';

  @override
  String get clearSearch => 'खोज साफ़ करें';

  @override
  String get noResults => 'कोई परिणाम नहीं';

  @override
  String get select => 'चुनें';

  @override
  String get unableToLoad => 'लोड नहीं हुआ';

  @override
  String get mobileApiToken => 'API टोकन';

  @override
  String get mobileTokenOnce =>
      'यह टोकन केवल एक बार दिखेगा। इसे सुरक्षित रखें। इसके धारक को चुनी गई API अनुमतियों से पहुँच मिलेगी।';

  @override
  String get mobileSaveRecovery => 'अपने रिकवरी कोड सहेजें';

  @override
  String get mobileRecoveryHelp =>
      'ऑथेंटिकेटर खोने पर हर कोड एक बार काम करेगा। ये पिछले कोड की जगह लेंगे। इन्हें सुरक्षित रखें।';

  @override
  String get mobileCopiedSecurely => 'कॉपी किया गया। इसे सुरक्षित रखें।';

  @override
  String get mobileSavedSecurely => 'मैंने इसे सुरक्षित सहेज लिया है';

  @override
  String get mobileDone => 'हो गया';

  @override
  String get mobileRevokeTokenQuestion => 'API टोकन रद्द करें?';

  @override
  String mobileTokenStops(Object name) {
    return '$name तुरंत काम करना बंद कर देगा।';
  }

  @override
  String get mobileRevoke => 'रद्द करें';

  @override
  String get mobileMfa => 'बहु-स्तरीय प्रमाणीकरण';

  @override
  String get mobileMfaOn => 'MFA चालू है';

  @override
  String get mobileMfaOff => 'MFA बंद है';

  @override
  String get mobileMfaHelp => 'ऑथेंटिकेटर ऐप से अपना लॉगिन सुरक्षित करें।';

  @override
  String get mobileSecuritySessions =>
      'सुरक्षा बदलाव अन्य सत्रों से लॉगआउट करेंगे और मौजूदा API टोकन अमान्य करेंगे।';

  @override
  String mobileAddedDate(Object date) {
    return '$date को जोड़ा गया';
  }

  @override
  String get mobileRemoveAuthenticator => 'ऑथेंटिकेटर हटाएँ';

  @override
  String get mobileAddAuthenticator => 'ऑथेंटिकेटर जोड़ें';

  @override
  String get mobileSetupMfa => 'MFA सेट करें';

  @override
  String mobileRecoveryRemaining(Object count) {
    return '$count अप्रयुक्त रिकवरी कोड';
  }

  @override
  String get mobileReplaceRecovery => 'रिकवरी कोड बदलें';

  @override
  String get mobileTurnOffMfa => 'MFA बंद करें';

  @override
  String get mobileApiAccess => 'API पहुँच';

  @override
  String get mobileApiHelp =>
      'अपने खाते की अनुमतियों के साथ इंटीग्रेशन के लिए क्रेडेंशियल बनाएँ।';

  @override
  String get mobileReadWrite => 'पढ़ें और लिखें';

  @override
  String get mobileReadOnly => 'केवल पढ़ें';

  @override
  String get mobileExpires => 'समाप्ति';

  @override
  String get mobileInactive => 'निष्क्रिय';

  @override
  String get mobileRevokeToken => 'टोकन रद्द करें';

  @override
  String get mobileCreateToken => 'API टोकन बनाएँ';

  @override
  String get mobileDeleteAccount => 'खाता हटाएँ';

  @override
  String get mobileDeleteWorkspaceHelp =>
      'अपना खाता और उप-उपयोगकर्ताओं सहित कार्यक्षेत्र की पहुँच हटाएँ। सभी सत्र बंद होंगे। ऐप में इसे वापस नहीं किया जा सकता।';

  @override
  String get mobileDeleteSelfHelp =>
      'अपना खाता हटाएँ और उसके सत्र बंद करें। ऐप में इसे वापस नहीं किया जा सकता।';

  @override
  String get mobileDeleteMyAccount => 'मेरा खाता हटाएँ';

  @override
  String get mobilePasswordOnly => 'आगे लॉगिन के लिए केवल पासवर्ड चाहिए होगा।';

  @override
  String get mobileRecoveryReplaced =>
      'आपके पुराने रिकवरी कोड काम करना बंद कर देंगे।';

  @override
  String get mobileTokenName => 'टोकन का नाम';

  @override
  String get mobileAuthenticatorName => 'ऑथेंटिकेटर का नाम';

  @override
  String get mobileEnterName => 'नाम दर्ज करें।';

  @override
  String get mobileAccess => 'पहुँच';

  @override
  String get mobileExpiresAfter => 'इसके बाद समाप्त';

  @override
  String mobileDays(Object count) {
    return '$count दिन';
  }

  @override
  String get mobileCurrentPassword => 'मौजूदा पासवर्ड';

  @override
  String get mobileEnterPassword => 'अपना पासवर्ड दर्ज करें।';

  @override
  String get mobileAuthenticatorOrRecovery => 'ऑथेंटिकेटर या रिकवरी कोड';

  @override
  String get mobileEnterVerification => 'अपना सत्यापन कोड दर्ज करें।';

  @override
  String get mobileDeleteConfirmation =>
      'मैं समझता हूँ कि मेरा खाता और कार्यक्षेत्र की पहुँच हट जाएगी।';

  @override
  String get mobileContinue => 'जारी रखें';

  @override
  String get mobileSixDigits => 'सभी छह अंक दर्ज करें।';

  @override
  String get mobileConnectAuthenticator => 'अपना ऑथेंटिकेटर जोड़ें';

  @override
  String get mobileScanQrHelp =>
      'दूसरे डिवाइस पर QR कोड स्कैन करें या सेटअप कुंजी ऑथेंटिकेटर ऐप में कॉपी करें। सेटअप 10 मिनट में समाप्त होगा।';

  @override
  String get mobileCopySetup => 'सेटअप कुंजी कॉपी करें';

  @override
  String get mobileNewAuthenticatorCode => 'नए ऑथेंटिकेटर का कोड';

  @override
  String get mobileVerifying => 'सत्यापन हो रहा है…';

  @override
  String get mobileConfirm => 'पुष्टि करें';

  @override
  String get mobileVerifySignIn => 'अपने लॉगिन का सत्यापन करें';

  @override
  String get mobileUnusedRecovery => 'अपना एक अप्रयुक्त रिकवरी कोड दर्ज करें।';

  @override
  String get mobileAuthenticatorInstructions =>
      'ऑथेंटिकेटर ऐप का छह अंकों वाला कोड दर्ज करें।';

  @override
  String get mobileRecoveryCode => 'रिकवरी कोड';

  @override
  String get mobileAuthenticatorCode => 'ऑथेंटिकेटर कोड';

  @override
  String get mobileCompleteRecovery => 'पूरा रिकवरी कोड दर्ज करें।';

  @override
  String get mobileVerifyAndSignIn => 'सत्यापित करें और लॉगिन करें';

  @override
  String get mobileUseAuthenticator => 'ऑथेंटिकेटर कोड इस्तेमाल करें';

  @override
  String get mobileUseRecovery => 'रिकवरी कोड इस्तेमाल करें';

  @override
  String get mobileBackSignIn => 'लॉगिन पर वापस जाएँ';

  @override
  String get mobileName => 'नाम';

  @override
  String get mobileCallingCode => 'देश का कॉलिंग कोड';

  @override
  String get mobileMobileNumber => 'मोबाइल नंबर';

  @override
  String get mobileAddress => 'पता';

  @override
  String get mobileCountry => 'देश';

  @override
  String get mobileState => 'राज्य / प्रांत';

  @override
  String get mobileCity => 'शहर';

  @override
  String get mobilePostcode => 'पिन कोड';

  @override
  String get mobileChangePassword => 'पासवर्ड बदलें';

  @override
  String get mobileRequired => 'यह फ़ील्ड ज़रूरी है।';

  @override
  String get mobileValidEmail =>
      'अंग्रेज़ी अक्षरों में सही ईमेल पता दर्ज करें।';

  @override
  String get mobilePasswordSessions =>
      'पासवर्ड बदलने से आपके सभी सत्र लॉगआउट हो जाएँगे।';

  @override
  String get mobileNewPassword => 'नया पासवर्ड';

  @override
  String get mobilePasswordCharacters => '6–72 अंग्रेज़ी अक्षर इस्तेमाल करें।';

  @override
  String get mobileDifferentPassword => 'अलग पासवर्ड चुनें।';

  @override
  String get mobileConfirmPassword => 'नए पासवर्ड की पुष्टि करें';

  @override
  String get mobilePasswordMismatch => 'पासवर्ड मेल नहीं खाते।';

  @override
  String get mobileChangesSaved => 'बदलाव सहेजे गए';

  @override
  String get mobileLanguageCodeHelp => 'en या hi जैसा भाषा कोड दर्ज करें।';

  @override
  String get mobileReload => 'फिर लोड करें';

  @override
  String get mobileEnterYourName => 'अपना नाम दर्ज करें।';

  @override
  String get mobileEnterCallingCode => 'कॉलिंग कोड दर्ज करें।';

  @override
  String get mobileValidMobile => 'सही मोबाइल नंबर दर्ज करें।';

  @override
  String get mobileSaveProfile => 'प्रोफ़ाइल सहेजें';

  @override
  String get mobileDisplayPreferences => 'दिखाने की प्राथमिकताएँ';

  @override
  String get mobileDateFormat => 'तारीख का प्रारूप';

  @override
  String get mobileTimeFormat => 'समय का प्रारूप';

  @override
  String get mobileDistanceUnit => 'दूरी की इकाई';

  @override
  String get mobileTextDirection => 'लिखने की दिशा';

  @override
  String get mobileTimeOffset => 'समय क्षेत्र का अंतर';

  @override
  String get mobileLanguageCode => 'भाषा कोड';

  @override
  String get mobileSavePreferences => 'प्राथमिकताएँ सहेजें';

  @override
  String get mobileProofAccountChanged =>
      'खाते की पहुँच बदल गई है। यात्रा का प्रमाण फिर खोलें।';

  @override
  String get mobileActivity => 'गतिविधि';

  @override
  String get mobileAllStatuses => 'सभी स्थितियाँ';

  @override
  String get mobileApproximateRoute => 'अनुमानित क्रम • क्रमांकित ठहराव';

  @override
  String get mobileAttention => 'ध्यान दें';

  @override
  String get mobileChooseRoute => 'रूट चुनें';

  @override
  String get mobileValidSchedule => 'सही समय-सारणी चुनें।';

  @override
  String get mobileValidStartTime => 'सही शुरुआती समय चुनें।';

  @override
  String get mobileChooseVehicle => 'वाहन चुनें';

  @override
  String get mobileChooseVehicleRoute => 'वाहन और रूट चुनें।';

  @override
  String get mobileChooseEligibleVehicle => 'पात्र वाहन चुनें';

  @override
  String get mobileEndDateAfterStart =>
      'आरंभ की तारीख या उसके बाद की समाप्ति तारीख चुनें।';

  @override
  String get mobileChooseWeekday => 'सप्ताह का कम से कम एक दिन चुनें।';

  @override
  String get mobileChooseDate => 'तारीख चुनें';

  @override
  String get mobileChooseDateRange => 'तारीखों की सीमा चुनें';

  @override
  String get mobileChooseDay => 'दिन चुनें';

  @override
  String get mobileMultiDayHelp =>
      'कई दिनों की यात्रा के लिए शुरुआत और समाप्ति की तारीख व समय चुनें।';

  @override
  String get mobileFutureDate => 'आज या आगे की तारीख चुनें।';

  @override
  String get mobileCompleted => 'पूरी हुई';

  @override
  String get mobileCompletionAfterStart => 'समाप्ति शुरुआत के बाद होनी चाहिए।';

  @override
  String get mobileCreateRouteFirst => 'योजना शुरू करने के लिए रूट बनाएँ।';

  @override
  String get mobileCreateSchedule => 'समय-सारणी बनाएँ';

  @override
  String get mobileCreateTrip => 'यात्रा बनाएँ';

  @override
  String get mobileDeleteSchedule => 'समय-सारणी हटाएँ';

  @override
  String get mobileDiscardChanges => 'बदलाव छोड़ें';

  @override
  String get mobileDiscardTrip => 'यात्रा के बदलाव छोड़ें?';

  @override
  String get mobileEditRecurring => 'दोहराने वाली समय-सारणी बदलें';

  @override
  String get mobileEditSchedule => 'समय-सारणी बदलें';

  @override
  String get mobileEndDate => 'समाप्ति की तारीख';

  @override
  String get mobileEndSchedule => 'समय-सारणी समाप्त करें';

  @override
  String get mobileEndTime => 'समाप्ति का समय';

  @override
  String get mobileEndTimeAfterStart =>
      'समाप्ति का समय शुरुआत के बाद होना चाहिए।';

  @override
  String get mobileEndsOptional => 'समाप्ति (वैकल्पिक)';

  @override
  String get mobileTripTitleLength => '2 से 120 अक्षरों का शीर्षक दर्ज करें।';

  @override
  String get mobileAtLeastTwo => 'कम से कम 2 अक्षर दर्ज करें';

  @override
  String get mobileAtLeastThree => 'कम से कम 3 अक्षर दर्ज करें';

  @override
  String get mobileExpandRoute => 'रूट का नक्शा बड़ा करें';

  @override
  String get mobileFitRoute => 'पूरा रूट दिखाएँ';

  @override
  String get mobileNoGpsPlanning =>
      'GPS जुड़ा नहीं है। यात्रा बना सकते हैं, लेकिन लाइव ट्रैकिंग उपलब्ध नहीं होगी।';

  @override
  String get mobileKeepEditing => 'बदलाव जारी रखें';

  @override
  String get mobileKeepSchedule => 'समय-सारणी रखें';

  @override
  String get mobileLastKnownPosition => 'वाहन का अंतिम ज्ञात स्थान';

  @override
  String get mobileLatestStart => 'शुरू करने का अंतिम समय';

  @override
  String get mobileNextMonth => 'अगला महीना';

  @override
  String get mobileNoEligible => 'कोई पात्र वाहन उपलब्ध नहीं है।';

  @override
  String get mobileNoEligibleHelp =>
      'कोई पात्र वाहन नहीं है। योजना से पहले सक्रिय वाहन को सक्रिय ड्राइवर सौंपें।';

  @override
  String get mobileNoRecordsView => 'इस दृश्य के लिए कोई रिकॉर्ड नहीं है।';

  @override
  String get mobileNoRouteGps =>
      'इस यात्रा के लिए रूट या GPS निर्देशांक उपलब्ध नहीं हैं।';

  @override
  String get mobileStopsWithoutGeometry =>
      'क्रमांकित ठहराव • रूट पथ उपलब्ध नहीं';

  @override
  String get mobilePause => 'रोकें';

  @override
  String get mobilePlanTrip => 'यात्रा की योजना बनाएँ';

  @override
  String get mobilePlannedNumbered => 'नियोजित रूट • क्रमांकित ठहराव';

  @override
  String get mobilePreviousMonth => 'पिछला महीना';

  @override
  String get mobileReasonRemark => 'कारण / टिप्पणी';

  @override
  String get mobileRecurring => 'दोहराव';

  @override
  String get mobileRecurringSchedule => 'दोहराने वाली समय-सारणी';

  @override
  String get mobileRecurringActions => 'दोहराने वाली समय-सारणी की कार्रवाइयाँ';

  @override
  String get mobileRefreshPlanning => 'योजना के विकल्प ताज़ा करें';

  @override
  String get mobileRefreshSchedule => 'बदलने से पहले समय-सारणी ताज़ा करें।';

  @override
  String get mobileRemarkOptional => 'टिप्पणी (वैकल्पिक)';

  @override
  String get mobileRemoveEndDate => 'समाप्ति की तारीख हटाएँ';

  @override
  String get mobileRepeatOn => 'इन दिनों दोहराएँ';

  @override
  String get mobileResume => 'फिर शुरू करें';

  @override
  String get mobileRoute => 'रूट';

  @override
  String get mobileRunning => 'चल रही है';

  @override
  String get mobileSaveShareProof => 'प्रमाण सहेजें या साझा करें';

  @override
  String get mobileSaveSchedule => 'समय-सारणी सहेजें';

  @override
  String get mobileSchedule => 'समय-सारणी';

  @override
  String get mobileScheduleSaved => 'समय-सारणी सहेजी गई';

  @override
  String get mobileSearchRoutes => 'रूट खोजें';

  @override
  String get mobileSearchVehicleDriver => 'वाहन, नंबर प्लेट या ड्राइवर खोजें';

  @override
  String get mobileSkipDates => 'छोड़ने की तारीखें (वैकल्पिक)';

  @override
  String get mobileSkipDatesRange =>
      'छोड़ने की तारीखें समय-सारणी की अवधि में होनी चाहिए।';

  @override
  String get mobileStartTime => 'आरंभ का समय';

  @override
  String get mobileStarts => 'आरंभ';

  @override
  String get mobileStatus => 'स्थिति';

  @override
  String get mobileSubmittedProofs => 'भेजे गए प्रमाण';

  @override
  String get mobileAnyTimeDay =>
      'ड्राइवर चुने गए दिन किसी भी समय शुरू कर सकता है।';

  @override
  String get mobileStartWindowHelp =>
      'ड्राइवर इस समय-सीमा में शुरू कर सकता है। सीमा का अंत यात्रा की समाप्ति का समय नहीं है।';

  @override
  String get mobileRequestFailed =>
      'अनुरोध पूरा नहीं हुआ। ताज़ा करके दोबारा कोशिश करें।';

  @override
  String get mobileRouteUnavailable =>
      'सहेजा गया रूट योजना के लिए उपलब्ध नहीं है। रूट ताज़ा करके दोबारा कोशिश करें।';

  @override
  String get mobileAccountTimeHelp =>
      'यात्रा खाते के समय क्षेत्र के अनुसार तय समय पर शुरू होती है।';

  @override
  String get mobilePdfPreviewFailed =>
      'PDF का पूर्वावलोकन नहीं हुआ। दूसरे ऐप में खोलने के लिए सहेजें या साझा करें।';

  @override
  String get mobileImagePreviewFailed =>
      'चित्र का पूर्वावलोकन नहीं हुआ। दूसरे ऐप में खोलने के लिए सहेजें या साझा करें।';

  @override
  String get mobileToday => 'आज';

  @override
  String get mobileTripCreated => 'यात्रा बनाई गई';

  @override
  String get mobileTripDetails => 'यात्रा का विवरण';

  @override
  String get mobileTripRoute => 'यात्रा का रूट';

  @override
  String get mobileTripTitle => 'यात्रा का शीर्षक';

  @override
  String get mobileProofShareFailed =>
      'प्रमाण साझा नहीं हुआ। दोबारा कोशिश करें।';

  @override
  String get mobileUnavailableVehicles => 'अनुपलब्ध वाहन';

  @override
  String get mobileMaxSkipDates => 'अधिकतम 100 छोड़ने की तारीखें चुनें';

  @override
  String get mobileRemarkLength => 'टिप्पणी में अधिकतम 600 अक्षर लिखें।';

  @override
  String get mobileValidDates => 'YYYY-MM-DD प्रारूप में सही तारीखें लिखें';

  @override
  String get mobileVehicleGpsPosition => 'वाहन का GPS स्थान';

  @override
  String get mobileVehicleDriver => 'वाहन और ड्राइवर';

  @override
  String get mobileVehicleRoute => 'वाहन और रूट';

  @override
  String get mobileViewTrip => 'यात्रा देखें';

  @override
  String get mobileDatesPerLine => 'YYYY-MM-DD, हर पंक्ति में एक तारीख';

  @override
  String get mobileDiscardPlanningHelp =>
      'बिना सहेजे योजना के बदलाव खो जाएँगे। सहेजे रूट उपलब्ध रहेंगे।';

  @override
  String mobileTimesTimezone(Object timezone) {
    return 'समय $timezone के अनुसार हैं।';
  }

  @override
  String mobileStopsCount(Object count) {
    return '$count ठहराव';
  }

  @override
  String mobileTripsCount(Object count) {
    return '$count यात्राएँ';
  }

  @override
  String mobileLoadMoreCount(Object loaded, Object total) {
    return 'और लोड करें ($total में से $loaded)';
  }

  @override
  String mobileScheduledDate(Object date) {
    return 'निर्धारित: $date';
  }

  @override
  String mobileEndsDate(Object date) {
    return 'समाप्ति: $date';
  }

  @override
  String mobileNextDate(Object date) {
    return 'अगली: $date';
  }

  @override
  String mobileGpsStatus(Object status) {
    return 'वाहन GPS: $status';
  }

  @override
  String mobileLastPosition(Object date) {
    return 'अंतिम स्थान: $date';
  }

  @override
  String mobileActualDistance(Object distance) {
    return 'वास्तविक दूरी: $distance किमी';
  }

  @override
  String mobileTripScore(Object value) {
    return 'यात्रा स्कोर: $value';
  }

  @override
  String mobileStopsProgress(Object completed, Object total) {
    return '$completed/$total ठहराव';
  }

  @override
  String mobileScheduleAction(Object action) {
    return 'दोहराने वाली समय-सारणी $action?';
  }

  @override
  String get dateRangeSelect => 'तारीखों की सीमा चुनें';

  @override
  String get dateRangeChoose => 'तारीखों की सीमा चुनें';

  @override
  String get dateTimeRangeChoose => 'तारीख और समय की सीमा चुनें';

  @override
  String get dateRangeFrom => 'से';

  @override
  String get dateRangeTo => 'तक';

  @override
  String get dateRangeSelected => 'चुनी गई सीमा';

  @override
  String get dateRangeStartTime => 'शुरुआती समय';

  @override
  String get dateRangeEndTime => 'समाप्ति का समय';

  @override
  String get dateRangeSelectStartTime => 'शुरुआती समय चुनें';

  @override
  String get dateRangeSelectEndTime => 'समाप्ति का समय चुनें';

  @override
  String get dateRangeInvalidTime => 'समाप्ति का समय शुरुआत के बाद होना चाहिए।';

  @override
  String get dateRangeCustom => 'कस्टम';

  @override
  String get dateRangeLastHour => 'पिछला घंटा';

  @override
  String get dateRangeLast3Hours => 'पिछले 3 घंटे';

  @override
  String get dateRangeLast6Hours => 'पिछले 6 घंटे';

  @override
  String get dateRangeLast12Hours => 'पिछले 12 घंटे';

  @override
  String get dateRangeLast24Hours => 'पिछले 24 घंटे';

  @override
  String get dateRangeToday => 'आज';

  @override
  String get dateRangeYesterday => 'कल';

  @override
  String get dateRangeThisWeek => 'यह सप्ताह';

  @override
  String get dateRangeLastWeek => 'पिछला सप्ताह';

  @override
  String get dateRangeLast7Days => 'पिछले 7 दिन';

  @override
  String get dateRangeLast30Days => 'पिछले 30 दिन';

  @override
  String get apply => 'लागू करें';

  @override
  String get calendarToday => 'आज';

  @override
  String get calendarPreviousMonth => 'पिछला महीना';

  @override
  String get calendarNextMonth => 'अगला महीना';

  @override
  String get calendarExpiry => 'समाप्ति';

  @override
  String get legacyUi869d62ddcd => ' बटन चालू करने के लिए।';

  @override
  String get legacyUi7f4f41c8c3 => '#RRGGBB';

  @override
  String get legacyUi9515360684 => 'नया डिवाइस जोड़ें';

  @override
  String get legacyUi6116c134de => '+ नया प्लान बनाएँ';

  @override
  String get legacyUic10e9a1c41 => '+ नया उपयोगकर्ता बनाएँ';

  @override
  String get legacyUi5e9a7040e4 => '2 अंक';

  @override
  String get legacyUia0483eec37 => '3 अंक';

  @override
  String get legacyUi3994dbd48e => '6–35 अक्षर';

  @override
  String get legacyUi250e268e83 => '7 से 15 अंक';

  @override
  String get legacyUie69a9a5ee9 => '7 दिनों का उपयोग';

  @override
  String get legacyUib8cee60c75 =>
      'उप-उपयोगकर्ता केवल आपके खाते में उपलब्ध सुविधाओं और रिपोर्ट का उपयोग कर सकता है। सेटिंग्स और खाते की सुरक्षा उपलब्ध रहती हैं।';

  @override
  String get legacyUif0ee13e963 => 'पहुँच प्रतिबंधित है';

  @override
  String get legacyUi6e702cb4e0 => 'खाते की स्थिति';

  @override
  String get legacyUi6d6eba9279 => 'खाते की पहुँच';

  @override
  String get legacyUi82cf8a5fc7 => 'खाते की सेटिंग्स';

  @override
  String get legacyUi9beb96dac8 => 'देखा गया चिह्नित करें';

  @override
  String get legacyUibf539b1d10 => 'Acme Logistics Pvt. Ltd.';

  @override
  String get legacyUic3cd636a58 => 'कार्य';

  @override
  String get legacyUia733b809d2 => 'सक्रिय';

  @override
  String get legacyUi15cf579b89 => 'सक्रिय अवधि';

  @override
  String get legacyUifaa171bc07 => 'सक्रिय वाहन';

  @override
  String get legacyUibde34d0278 => 'सक्रिय स्थिति';

  @override
  String get legacyUi14c5b09cd4 => 'गतिविधि का विवरण';

  @override
  String get legacyUifbed23bc25 => 'एक्टिविटी लॉग';

  @override
  String get legacyUie35effbf63 => 'गतिविधि की तारीख सीमा';

  @override
  String get legacyUicbd19b5c39 => 'कार्रवाईकर्ता';

  @override
  String get legacyUi7980ca2475 => 'कार्रवाई करने वाला उपयोगकर्ता';

  @override
  String get legacyUi4ac5084db4 => 'डिवाइस या SIM जोड़ें';

  @override
  String get legacyUiaa752d14b8 => 'ड्राइवर जोड़ें';

  @override
  String get legacyUi224f2486e6 => 'इन्वेंटरी जोड़ें';

  @override
  String get legacyUi1836b111cd => 'मेटा पंक्ति जोड़ें';

  @override
  String get legacyUi31dd5bb29e => 'नई टीम जोड़ें';

  @override
  String get legacyUi47b2149c9c => 'प्लान जोड़ें';

  @override
  String get legacyUic08d1e9d3f => 'सेंसर जोड़ें';

  @override
  String get legacyUi12071f1c87 => 'नया प्लान जोड़ें या अपनी खोज बदलें।';

  @override
  String get legacyUic0c181937e => 'एट्रिब्यूट जोड़ें';

  @override
  String get legacyUi5367d642e2 => 'क्रेडिट जोड़ें';

  @override
  String get legacyUi1fa55e4562 => 'मेटाडेटा पंक्ति जोड़ें';

  @override
  String get legacyUi7be087b7a7 => 'प्रमाण जोड़ें';

  @override
  String get legacyUib68734c259 => 'जोड़ा गया';

  @override
  String get legacyUi41b5f2e6ae => 'अतिरिक्त नोट्स';

  @override
  String get legacyUid5e920a5cb => 'पता रेखा';

  @override
  String get legacyUi7748043229 => 'पते और भौगोलिक क्षेत्र का विवरण।';

  @override
  String get legacyUi4faa35048a => 'व्यवस्थापक लॉगिन अनुरोध पूरा हुआ।';

  @override
  String get legacyUi1eda23758b => 'व्यवस्थापक';

  @override
  String get legacyUi3df513225f => 'व्यवस्थापक बनाया गया।';

  @override
  String get legacyUif981236722 => 'प्रभावित वाहन';

  @override
  String get legacyUib7fb586ff2 => 'हवाई अड्डा';

  @override
  String get legacyUi25f8c55de8 => 'अलार्म';

  @override
  String get legacyUib5faca3a78 => 'अलर्ट का प्रकार';

  @override
  String get legacyUic03d80790d => 'सभी एडमिन';

  @override
  String get legacyUi0b313a76be => 'सभी देश';

  @override
  String get legacyUiffeed47b5a => 'सभी प्रदाता';

  @override
  String get legacyUi4745c5dce5 => 'पूरी अवधि';

  @override
  String get legacyUieb672cb3ba => 'सभी प्रकार';

  @override
  String get legacyUib4f25a1426 => 'सभी उपयोगकर्ता';

  @override
  String get legacyUidd9eb32418 => 'सभी वाहन';

  @override
  String get legacyUi060be00f4f => 'सभी श्रेणियाँ';

  @override
  String get legacyUi0aaede0bb1 => 'सभी सूचनाएँ पढ़ी हुई चिह्नित की गईं।';

  @override
  String get legacyUi30c8a0fc9c => 'सभी प्रकार';

  @override
  String get legacyUice832d9b31 => 'सभी उपयोगकर्ता';

  @override
  String get legacyUie512a2f10a => 'इतिहास की अनुमति दें';

  @override
  String get legacyUif8f993b052 => 'रूट इतिहास तक पहुँच दें।';

  @override
  String get legacyUi1ffee134b1 =>
      'आगंतुकों को डेमो कार्यक्षेत्र में लॉगिन करने दें।';

  @override
  String get legacyUie5d30dc481 => 'स्वीकृत सीमा: 10–300';

  @override
  String get legacyUi22786d42cc => 'ऊंचाई:';

  @override
  String get legacyUi43dc8532f7 => 'राशि';

  @override
  String get legacyUi76aa32f207 => 'राशि';

  @override
  String get legacyUia01154a861 => 'राशि में बदलाव';

  @override
  String get legacyUi7d66157b06 => 'राशि 0.01 और 9999999.99 के बीच होनी चाहिए';

  @override
  String get legacyUib34440b2cd => 'राशि में बदलाव';

  @override
  String get legacyUib757c50159 => 'राशि में अधिकतम 2 दशमलव स्थान हो सकते हैं';

  @override
  String get legacyUic8c3ba95bb => 'भुगतान उपलब्ध होने पर विश्लेषण दिखाई देगा।';

  @override
  String get legacyUif6c665f4fe => 'लेनदेन उपलब्ध होने पर विश्लेषण दिखाई देगा।';

  @override
  String get legacyUi6b2a78a8f7 => 'लागू करें फ़िल्टर';

  @override
  String get legacyUi2444928438 => 'असाइन करें';

  @override
  String get legacyUi561f6317fe => 'ड्राइवर असाइन करें';

  @override
  String get legacyUi3d2183f9ae => 'चयनित असाइन करें';

  @override
  String get legacyUi5e97289597 => 'असाइन करें उपयोगकर्ता';

  @override
  String get legacyUib8db201262 => 'वाहन असाइन करें';

  @override
  String get legacyUi20b5675c39 => 'असाइन करें वाहन';

  @override
  String get legacyUic403a13c66 =>
      'इस उप-उपयोगकर्ता को एक या अधिक वाहन असाइन करें।';

  @override
  String get legacyUie12261bf18 => 'इस ड्राइवर को उपयोगकर्ता असाइन करें।';

  @override
  String get legacyUi41c90cdeef => 'इस वाहन को उपयोगकर्ता असाइन करें।';

  @override
  String get legacyUi32265d6dad =>
      'बुनियादी सूचनाएँ सेट करने के लिए वाहन असाइन करें।';

  @override
  String get legacyUi117326ffd2 =>
      'अवधि की सूचनाएँ सेट करने के लिए वाहन असाइन करें।';

  @override
  String get legacyUi74dfd6593f =>
      'जियोफेंस सूचनाएँ सेट करने के लिए वाहन असाइन करें।';

  @override
  String get legacyUi8c6586176a =>
      'अधिक गति की सूचनाएँ सेट करने के लिए वाहन असाइन करें।';

  @override
  String get legacyUi086854873d =>
      'रूट सूचनाएँ सेट करने के लिए वाहन असाइन करें।';

  @override
  String get legacyUie24e824b68 => 'असाइन किया गया';

  @override
  String get legacyUie94ba984c3 => 'असाइन किया गया वाहन';

  @override
  String get legacyUie55df441e8 => 'असाइनमेंट';

  @override
  String get legacyUi0c686b74d7 => 'कम से कम 5 अक्षर। बदलावों का ऑडिट होता है।';

  @override
  String get legacyUi1afff0157c => 'संलग्न करें';

  @override
  String get legacyUi0c431f4969 => 'फ़ाइल संलग्न करें';

  @override
  String get legacyUi137135dbf6 => 'फाइलें संलग्न करें';

  @override
  String get legacyUi2286866966 => 'अटैचमेंट का URL उपलब्ध नहीं है।';

  @override
  String get legacyUib6b6277691 => 'अटैचमेंट का पथ उपलब्ध नहीं है।';

  @override
  String get legacyUi1b30607d41 => 'विशेषता की कुंजियाँ अलग-अलग होनी चाहिए।';

  @override
  String get legacyUia6652617f2 => 'एट्रिब्यूट';

  @override
  String get legacyUi7c62a14244 => 'उपलब्ध';

  @override
  String get legacyUicdc93143c6 => 'औसत';

  @override
  String get legacyUib1ff8731de => 'औसत गति';

  @override
  String get legacyUi3e6e9b59e4 => 'बैकएंड टोकन';

  @override
  String get legacyUib15950ccc9 => 'बैकएंड टोकन';

  @override
  String get legacyUief5c48114b => 'बैकएंड द्वारा सत्यापित';

  @override
  String get legacyUidd96994d01 => 'बैकअप';

  @override
  String get legacyUi775fe0e609 => 'बैकअप / डेटा संरक्षण';

  @override
  String get legacyUi17ef50d8f8 => 'बैंक ट्रांसफर';

  @override
  String get legacyUi1007a1a728 => 'बैंक संदर्भ / UTR / लेनदेन ID';

  @override
  String get legacyUi5be1ae92e8 => 'बैंक ट्रांसफ़र नोट / UTR / लेनदेन संदर्भ';

  @override
  String get legacyUi6b57349e97 => 'बेस URL सेटिंग्स';

  @override
  String get legacyUiaa2c96dacf => 'बेसिक';

  @override
  String get legacyUic73c27be48 =>
      'ड्राइवर लॉगिन के लिए खाते के बुनियादी विवरण।';

  @override
  String get legacyUi904d23cb6a => 'नए वाहन की बुनियादी पहचान।';

  @override
  String get legacyUi99613c74ce => 'ब्लॉक किया गया';

  @override
  String get legacyUi584522b903 => 'ब्रांड और संपर्क विवरण';

  @override
  String get legacyUibfc8921ede => 'ब्रांड का रंग';

  @override
  String get legacyUi54a2cf5e63 => 'ब्राउज़र';

  @override
  String get legacyUi73e0b16797 =>
      'ब्राउज़र टैब आइकन। ICO, PNG या SVG। अधिकतम 2 MB।';

  @override
  String get legacyUicfadbd7a57 => 'द्वारा';

  @override
  String get legacyUi42878ce3fa => 'CPU उपयोग';

  @override
  String get legacyUi37efa8a990 => 'कैफ़े';

  @override
  String get legacyUi26b937c51d => 'नवीनीकरण अनुरोध रद्द करें?';

  @override
  String get legacyUi84837a2168 => 'अनुरोध रद्द करें';

  @override
  String get legacyUi2738a0a1db =>
      'वाहन के विवरण के बिना कमांड लोड नहीं हो सकते।';

  @override
  String get legacyUi4d4ce73b15 => 'कार्ड';

  @override
  String get legacyUi758ec54e43 => 'कैश';

  @override
  String get legacyUi6ccb60071b => 'श्रेणियाँ';

  @override
  String get legacyUi49289db43e => 'बदलाव पासवर्ड';

  @override
  String get legacyUi6fc0529f2d => 'स्थिति बदलें';

  @override
  String get legacyUica5df1dad1 => 'तारीख और समय सीमा चुनें';

  @override
  String get legacyUid2174d8075 => 'रीप्ले सीमा चुनें';

  @override
  String get legacyUi66542fe55c =>
      'प्लान, पंजीकरण की तारीख और 5–500 अक्षरों का कारण चुनें।';

  @override
  String get legacyUi7db804aa37 =>
      'वाहन, समाप्ति और साझा करने के विकल्प चुनें।';

  @override
  String get legacyUi037c5eba86 => 'शहर (वैकल्पिक)';

  @override
  String get legacyUief153831d1 => 'शहर आवश्यक है';

  @override
  String get legacyUi8da6bb0466 => 'सफ़ाई पूरी हुई';

  @override
  String get legacyUi381c4bf1d4 => 'फ़िल्टर हटाएँ';

  @override
  String get legacyUicdb64ef80e => 'तारीख सीमा हटाएँ';

  @override
  String get legacyUid3c69afc35 => 'तारीखें हटाएँ';

  @override
  String get legacyUi1bf7452cd6 => 'समाप्ति हटाएँ';

  @override
  String get legacyUi40b66a41b8 => 'समाप्ति की तारीख हटाएँ';

  @override
  String get legacyUi92e60a4db3 => 'साफ़ करें रीप्ले';

  @override
  String get legacyUi53dde4f2c0 =>
      'भुगतान दर्ज होने के बाद ग्राहक राजस्व दिखाई देगा।';

  @override
  String get legacyUide4e7f6fad => 'बंद करें ड्रॉअर';

  @override
  String get legacyUi3dc631324c => 'मानचित्र बंद करें';

  @override
  String get legacyUid75dc68bbd => 'समूह';

  @override
  String get legacyUiadac69379a => 'कोड';

  @override
  String get legacyUiea6ac41a6a => 'कोड आवश्यक है।';

  @override
  String get legacyUi5b0f7590d0 => 'एकत्रित';

  @override
  String get legacyUi8901895fb1 => 'कमांड';

  @override
  String get legacyUif7e08456d0 => 'कमांड विवरण';

  @override
  String get legacyUi6c4cb3de03 => 'कमांड टेक्स्ट';

  @override
  String get legacyUibfed234d46 => 'कमांड उपलब्ध नहीं है';

  @override
  String get legacyUi45e5f3f72e => 'कमांड';

  @override
  String get legacyUi7a1994999d => 'कंपनी';

  @override
  String get legacyUi8599f5cc48 => 'कंपनी का नाम';

  @override
  String get legacyUi1e5f7dc45c => 'कंपनी का नाम';

  @override
  String get legacyUib55887f633 => 'कंपनी अपडेट हुआ';

  @override
  String get legacyUi657063c67c => 'कंपनी अपडेट हुआ';

  @override
  String get legacyUif1ab0a6f4e => 'मैन्युअल रूप से पूरा करें';

  @override
  String get legacyUif14ebb39ce => 'कॉन्फ़िगरेशन संस्करण';

  @override
  String get legacyUi755bea99c0 => 'कॉन्फ़िगरेशन अपडेट हुआ।';

  @override
  String get legacyUic69463a5a9 => 'भेजे जाने वाले ईमेल की सेटिंग्स तय करें।';

  @override
  String get legacyUic2d404cb7b => 'पासवर्ड की पुष्टि करें';

  @override
  String get legacyUiea3723a45c => 'बढ़ी हुई पहुँच की पुष्टि करें';

  @override
  String get legacyUi4a7c565d4c => 'पासवर्ड की पुष्टि करें';

  @override
  String get legacyUi5febc18b54 => 'भुगतान की पुष्टि करें';

  @override
  String get legacyUi05a7fffae1 => 'प्राप्त भुगतान की पुष्टि करें';

  @override
  String get legacyUi90d96c7cec => 'पुष्टि वाक्यांश';

  @override
  String get legacyUic2f9b7b489 => 'कनेक्टेड';

  @override
  String get legacyUib37456c453 => 'संपर्क';

  @override
  String get legacyUicc11b3a28f => 'संदर्भ';

  @override
  String get legacyUi3cf29aa7f5 => 'लगातार निष्क्रिय';

  @override
  String get legacyUic352b92e1f => 'लगातार चालू';

  @override
  String get legacyUi347d3dbf17 => 'लगातार बंद';

  @override
  String get legacyUi49fdb038f4 => 'दर्शक क्या देख सकते हैं, यह तय करें।';

  @override
  String get legacyUi02c6c04dec => 'KML कॉपी करें';

  @override
  String get legacyUi44fe06869f => 'हेडर कॉपी करें';

  @override
  String get legacyUi3a9d77c901 => 'URL नहीं खुल सका';

  @override
  String get legacyUi0c09a7eccc => 'अटैचमेंट नहीं खुल सका।';

  @override
  String get legacyUif2344997aa => 'दस्तावेज़ नहीं खुल सका।';

  @override
  String get legacyUi2209ab63ce => 'फ़ाइल नहीं खुल सकी।';

  @override
  String get legacyUi5905ce4109 => 'फ़ाइल नहीं खुल सकी। लिंक कॉपी हुआ।';

  @override
  String get legacyUi9b09f53bdd => 'लिंक नहीं खुल सका।';

  @override
  String get legacyUi72be0e8616 => 'फ़ाइल नहीं चुनी जा सकी';

  @override
  String get legacyUi76e835f8c3 => 'फ़ाइल नहीं चुनी जा सकी।';

  @override
  String get legacyUiaef46d6729 => 'चुनी गई फ़ाइल नहीं पढ़ी जा सकी';

  @override
  String get legacyUi280c98ccef => 'देश का फ़िल्टर';

  @override
  String get legacyUi1c9a9315c9 => 'देश आवश्यक है';

  @override
  String get legacyUid82b56cad9 => 'दिशा';

  @override
  String get legacyUi6e157c5da4 => 'बनाएं';

  @override
  String get legacyUi318d1da4e0 => 'एडमिन बनाएं';

  @override
  String get legacyUi0a62dd4d37 => 'ड्राइवर बनाएं';

  @override
  String get legacyUie3429ab78d => 'जियोफेंस बनाएँ';

  @override
  String get legacyUidb7c457634 => 'POI बनाएँ';

  @override
  String get legacyUicdd060d443 => 'मूल्य निर्धारण प्लान बनाएँ';

  @override
  String get legacyUi5d16c5ffd7 => 'उप-उपयोगकर्ता बनाएँ';

  @override
  String get legacyUiafe9a7ae15 => 'टिकट बनाएं';

  @override
  String get legacyUib25c91fe61 => 'उपयोगकर्ता बनाएं';

  @override
  String get legacyUi705b0946b2 => 'वाहन बनाएँ';

  @override
  String get legacyUi22a6b9d964 =>
      'यहाँ देखने के लिए वेब ऐप से डैशबोर्ड बनाएँ।';

  @override
  String get legacyUi769479a4d5 =>
      'वाहन की लाइव ट्रैकिंग साझा करने के लिए सार्वजनिक ट्रैक लिंक बनाएँ।';

  @override
  String get legacyUi50aab1f7b5 => 'इस वाहन के लिए सेंसर बनाएँ।';

  @override
  String get legacyUi0d2cd08b59 => 'व्यवस्थापक बनाएँ';

  @override
  String get legacyUi6f876ff9c0 =>
      'निर्यात करने से पहले कम से कम एक आइटम बनाएँ।';

  @override
  String get legacyUic42adee4d7 => 'इस फ़ॉर्म से बाहर निकले बिना डिवाइस बनाएँ';

  @override
  String get legacyUiaba922c9b5 => 'ड्राइवर बनाएं';

  @override
  String get legacyUi6efd8652f4 =>
      'ड्राइवर बनाएँ और असाइन किए गए वाहन, दस्तावेज़ तथा गतिविधि प्रबंधित करें।';

  @override
  String get legacyUiba98384ac3 =>
      'जियोफेंस सूचनाएँ सेट करने के लिए जियोफेंस बनाएँ।';

  @override
  String get legacyUif7b868f7d4 =>
      'श्रेणी, आइकन, रंग और सहनशीलता त्रिज्या सहित रुचि के स्थान बनाएँ।';

  @override
  String get legacyUie42ed33e33 =>
      'इस फ़ॉर्म से बाहर निकले बिना मूल्य निर्धारण प्लान बनाएँ';

  @override
  String get legacyUie40f966076 =>
      'रूट मैन्युअल रूप से बनाएँ या जहाँ उपलब्ध हो, प्रारंभ और गंतव्य से बनाएँ।';

  @override
  String get legacyUi567e040ce2 =>
      'रूट से विचलन की सूचनाएँ सेट करने के लिए रूट बनाएँ।';

  @override
  String get legacyUica09bbf34d =>
      'उप-उपयोगकर्ता बनाएँ और उनके वाहनों की पहुँच तय करें।';

  @override
  String get legacyUi3afcbed7e6 => 'टिकट बनाएं';

  @override
  String get legacyUibdbcfa0af0 => 'उपयोगकर्ता बनाएं';

  @override
  String get legacyUie7358de58e =>
      'इस वाहन फ़ॉर्म से बाहर निकले बिना उपयोगकर्ता बनाएँ';

  @override
  String get legacyUi505a950fbb => 'वाहन बनाएँ';

  @override
  String get legacyUi1ef0c932b3 =>
      'असाइनमेंट शुरू करने के लिए पहला ड्राइवर बनाएँ।';

  @override
  String get legacyUi7d3ca14313 =>
      'परिचालन की सीमाएँ तय करने के लिए पहला जियोफेंस बनाएँ।';

  @override
  String get legacyUi60a39e1fde =>
      'परिचालन बिंदुओं की ट्रैकिंग के लिए पहला स्थान बनाएँ।';

  @override
  String get legacyUi4fbf4f09cd =>
      'चुनिंदा पहुँच साझा करने के लिए पहला उप-उपयोगकर्ता बनाएँ।';

  @override
  String get legacyUiaccf40c89b => 'बनाया गया:';

  @override
  String get legacyUia5682ef199 => 'बनाया गया:';

  @override
  String get legacyUi5db1542e68 => 'बनाया गया';

  @override
  String get legacyUif1c69716be => 'बनाया गया';

  @override
  String get legacyUidd097a2297 => 'क्रेडेंशियल';

  @override
  String get legacyUi9f58b9e39b =>
      'वे विवरण जिनसे व्यवस्थापक OpenVTS में साइन इन करेगा।';

  @override
  String get legacyUiec535bab6f =>
      'वे विवरण जिनसे उपयोगकर्ता OpenVTS में साइन इन करेगा।';

  @override
  String get legacyUi8a45d339a6 => 'क्रेडिट';

  @override
  String get legacyUic3dc6e3ef9 =>
      'क्रेडिट, भुगतान या बिलिंग अपडेट यहाँ दिखाई देंगे।';

  @override
  String get legacyUibfac50d642 => 'क्रेडिट';

  @override
  String get legacyUie070de2244 => 'मुद्रा';

  @override
  String get legacyUiea4b114ac6 => 'वर्तमान स्थिति';

  @override
  String get legacyUieeed986410 => 'वर्तमान क्रेडिट';

  @override
  String get legacyUibe1ac4e322 => 'वर्तमान चरण';

  @override
  String get legacyUi9c378938cd => 'कस्टम कमांड';

  @override
  String get legacyUi28be3fd018 => 'कस्टम डोमेन';

  @override
  String get legacyUif130609dfc => 'कस्टम रेंज';

  @override
  String get legacyUia9d9e61bf2 => 'कस्टम श्रेणी (जैसे \"विक्रेता\")';

  @override
  String get legacyUi0354c8896b => 'कस्टम डोमेन';

  @override
  String get legacyUi3a55eba66f => 'कस्टम डोमेन और ब्रांड का रंग।';

  @override
  String get legacyUi9f1d0368da => 'ग्राहक की समाप्ति';

  @override
  String get legacyUi1588fe44aa => 'ग्राहक की समाप्ति तारीख';

  @override
  String get legacyUib13a49701d => 'ग्राहक नवीनीकरण अनुरोध';

  @override
  String get legacyUi0c919bd08d => 'ग्राहक सेवा समाप्त होगी';

  @override
  String get legacyUidce04fd315 => 'कस्टम';

  @override
  String get legacyUi118de3988f => 'कटऑफ़';

  @override
  String get legacyUi5c487cb2d8 =>
      'इस अवधि के दैनिक राजस्व आँकड़े उपलब्ध नहीं हैं।';

  @override
  String get legacyUi99c0019cc6 => 'डार्क लोगो';

  @override
  String get legacyUia167278399 => 'डार्क लोगो अपडेट हुआ';

  @override
  String get legacyUi2b197ef6be =>
      'डेटाबेस और लाइव टेलीमेट्री लॉग यहाँ दिखाई देंगे।';

  @override
  String get legacyUi6bb4b674b3 => 'दिनांक सीमा';

  @override
  String get legacyUie3d06ca6a1 => 'तारीख और समय सीमा';

  @override
  String get legacyUic65ea4ae01 => 'दिनांक सीमा';

  @override
  String get legacyUi853aab7f56 => 'दिनांक & समय';

  @override
  String get legacyUi842b7b5d71 => 'तारीखें';

  @override
  String get legacyUi987b9ced08 => 'दिन';

  @override
  String get legacyUi82c29dd5fa => 'दिन / रात की तुलना';

  @override
  String get legacyUibfb1ba6e3e => 'दिन / रात की सीमा';

  @override
  String get legacyUicf558941e0 => 'डेबिट';

  @override
  String get legacyUibb3cec5175 => 'क्रेडिट घटाएँ';

  @override
  String get legacyUi6bccca646f => 'कटौती की गई';

  @override
  String get legacyUi1dcab135ef => 'डुप्लिकेट हटाएँ';

  @override
  String get legacyUi15462a4954 => 'दोहराई गई घटनाएँ हटाएँ';

  @override
  String get legacyUi6184deb041 => 'डिफ़ॉल्ट प्लान';

  @override
  String get legacyUiee1b9a9f23 => 'खाता हटाएं';

  @override
  String get legacyUie81c14c990 => 'ड्राइवर? हटाएं';

  @override
  String get legacyUi749f8e14e3 => 'उप-उपयोगकर्ता हटाएँ';

  @override
  String get legacyUi0a0a90f6c5 => 'उपयोगकर्ता? हटाएं';

  @override
  String get legacyUi4bcd1233a1 => 'व्यवस्थापक हटाएँ';

  @override
  String get legacyUi6fd38c1fb9 => 'व्यवस्थापक हटाएँ?';

  @override
  String get legacyUie8df0b7902 => 'दस्तावेज़? हटाएं';

  @override
  String get legacyUi4ecae3e148 => 'दस्तावेज़? हटाएं';

  @override
  String get legacyUid1571af327 => 'ड्राइवर खाता हटाएँ';

  @override
  String get legacyUia34ada32da => 'सेंसर? हटाएं';

  @override
  String get legacyUi1ce5593800 => 'यह दस्तावेज़ हटाएँ?';

  @override
  String get legacyUi6a58093cab => 'ट्रैक लिंक हटाएँ';

  @override
  String get legacyUi9afe6c7b95 => 'उपयोगकर्ता? हटाएं';

  @override
  String get legacyUif7ff7065a9 => 'वाहन हटाएं';

  @override
  String get legacyUi441bda6cd8 => 'हटाया गया';

  @override
  String get legacyUif7c094a571 => 'हटाई गई पंक्तियाँ';

  @override
  String get legacyUic6bdaac949 => 'दिल्ली';

  @override
  String get legacyUibc4f986ecb => 'डिलीवरी';

  @override
  String get legacyUi921a6f6b55 => 'डिलीवरी लॉग';

  @override
  String get legacyUib2c4e6cb46 => 'डेमो लॉगिन';

  @override
  String get legacyUi4675a25777 => 'डेमो लॉगिन';

  @override
  String get legacyUi59013d16af => 'अनुरोध या समस्या का विवरण दें';

  @override
  String get legacyUi55f8ebc805 => 'विवरण';

  @override
  String get legacyUi388de6fa3a => 'विवरण (वैकल्पिक)';

  @override
  String get legacyUi763630a9ce => 'विवरण आवश्यक है।';

  @override
  String get legacyUi8a96cce5e5 =>
      'विवरण में कम से कम एक अक्षर या अंक होना चाहिए।';

  @override
  String get legacyUidc3decbb93 => 'विवरण';

  @override
  String get legacyUia5a74a6df0 => 'डिवाइस';

  @override
  String get legacyUid69ba8a9eb => 'डिवाइस और SIM';

  @override
  String get legacyUic587837fda => 'डिवाइस IMEI';

  @override
  String get legacyUif59a7a21bb => 'डिवाइस इंस्टॉल';

  @override
  String get legacyUi219288726d => 'केवल डिवाइस';

  @override
  String get legacyUi554dd558bd => 'डिवाइस सारांश';

  @override
  String get legacyUi20d5df8b4a => 'डिवाइस प्रकार';

  @override
  String get legacyUi30de920ef1 => 'डिवाइस बनाया और चुना गया';

  @override
  String get legacyUi3c47b57c83 => 'डिवाइस प्रतिक्रिया';

  @override
  String get legacyUi6d2870160a => 'डिवाइस समय:';

  @override
  String get legacyUi21fe5a18d0 => 'डिवाइस अपडेट हुआ';

  @override
  String get legacyUidf485c8713 => 'डिवाइस';

  @override
  String get legacyUibb73469225 => 'लिंक हटाए बिना बंद करें।';

  @override
  String get legacyUid3e4b30e10 => 'बदलाव छोड़ें और रीफ़्रेश करें';

  @override
  String get legacyUi427dc4f0cd => 'नया व्यवस्थापक छोड़ें?';

  @override
  String get legacyUid1b8679c63 => 'नया उपयोगकर्ता छोड़ें?';

  @override
  String get legacyUi6012a2d760 => 'नया वाहन छोड़ें?';

  @override
  String get legacyUifb0a3e6787 => 'डिस्क उपयोग';

  @override
  String get legacyUi70afe9eff3 => 'बंद करें';

  @override
  String get legacyUi515aa7ad86 => 'असाइन किए गए जियोफेंस का संदर्भ दिखाएँ।';

  @override
  String get legacyUi37bbdde1a6 => 'मानचित्र पर जियोफेंस की सीमाएँ दिखाएँ';

  @override
  String get legacyUi2eebf5225a => 'दिखाएं सेव हुआ मार्ग पर मैप';

  @override
  String get legacyUifb71a3779e => 'दूरी मल्टीप्लायर';

  @override
  String get legacyUib3262ecb53 => 'दूरी में अंतर';

  @override
  String get legacyUiac3f0eb0ea => 'दूरी/घंटे';

  @override
  String get legacyUi2c21f68832 => 'दस्तावेज़ प्रकार';

  @override
  String get legacyUi7615530d7a => 'दस्तावेज़ का URL उपलब्ध नहीं है।';

  @override
  String get legacyUi6dad05c10e => 'दस्तावेज़ की कार्रवाइयाँ';

  @override
  String get legacyUibd9a0f027e => 'दस्तावेज़ हटाया गया।';

  @override
  String get legacyUi3859bdaa8c => 'दस्तावेज़ का शीर्षक';

  @override
  String get legacyUi300b6ef0cd => 'दस्तावेज़ प्रकार';

  @override
  String get legacyUi9b10914d8b => 'डोमेन';

  @override
  String get legacyUifb349182fc => 'डोमेन और रंग';

  @override
  String get legacyUi8b58eea04e => 'डोमेन और ब्रांड का रंग सहेजा गया';

  @override
  String get legacyUi0ec2ae5cda => 'डोमेन, लोगो, फ़ेविकॉन और ब्रांड का रंग।';

  @override
  String get legacyUibfa50c7a38 => 'बनाएँ';

  @override
  String get legacyUi2e617aeb36 =>
      'मानचित्र पर वृत्त, बहुभुज, आयत और रेखा सीमाएँ बनाएँ।';

  @override
  String get legacyUid952b9d3da =>
      'ट्रैकिंग शुरू करने के लिए पहला रूट कॉरिडोर बनाएँ।';

  @override
  String get legacyUi0ecf1d5bc0 => 'तय की गई दूरी';

  @override
  String get legacyUi845a6bd3ab => 'ड्राइवर प्रोफ़ाइल';

  @override
  String get legacyUi450d68e4fe => 'ड्राइवर की कार्रवाइयाँ';

  @override
  String get legacyUid1ba6aea38 => 'ड्राइवर असाइन किया गया।';

  @override
  String get legacyUifbaa386fbc =>
      'ड्राइवर असाइनमेंट और प्रोफ़ाइल गतिविधि यहाँ दिखाई देगी।';

  @override
  String get legacyUi017bb97653 => 'ड्राइवर बनाया गया।';

  @override
  String get legacyUif8acdd5348 =>
      'ड्राइवर बनाने या अपडेट करने की गतिविधि यहाँ दिखाई देगी।';

  @override
  String get legacyUib057fefdc2 => 'ड्राइवर हटाया गया';

  @override
  String get legacyUi63a7342acd => 'ड्राइवर नाम';

  @override
  String get legacyUi8d30cc59a1 => 'ड्राइवर का असाइनमेंट हटाया गया।';

  @override
  String get legacyUia010b0a25f => 'ड्राइवर अपडेट हुआ।';

  @override
  String get legacyUifdd68e9960 => 'ड्राइवर कार्यक्षेत्र';

  @override
  String get legacyUi3d14659ca9 => 'पूर्वाभ्यास';

  @override
  String get legacyUi87bd16c150 => 'पूर्वाभ्यास पूरा हुआ';

  @override
  String get legacyUi91310be76f => 'दुबई';

  @override
  String get legacyUi1370004da7 => 'अवधि';

  @override
  String get legacyUia051787af6 => 'हर अटैचमेंट 5 MB या उससे छोटा होना चाहिए।';

  @override
  String get legacyUi9bb58b2d1b => 'पूर्व';

  @override
  String get legacyUi7de491bedc => 'कंपनी संपादित करें';

  @override
  String get legacyUi5b7faa9d61 => 'डिवाइस संपादित करें';

  @override
  String get legacyUicf5ddc10b3 => 'ड्राइवर संपादित करें';

  @override
  String get legacyUi13a7a7c3a7 => 'प्लान संपादित करें';

  @override
  String get legacyUicd280a41f7 => 'प्रोफाइल संपादित करें';

  @override
  String get legacyUi19d57bd021 => 'SIM संपादित करें';

  @override
  String get legacyUi4a0fe224b9 => 'सेंसर संपादित करें';

  @override
  String get legacyUic8e262db5b => 'उप-उपयोगकर्ता संपादित करें';

  @override
  String get legacyUi38a1cb0f89 => 'टीम सदस्य संपादित करें';

  @override
  String get legacyUi0e457253ad => 'उपयोगकर्ता संपादित करें';

  @override
  String get legacyUib213eb6d7b => 'वाहन संपादित करें';

  @override
  String get legacyUid03750ccbf => 'कंपनी संपादित करें';

  @override
  String get legacyUi15141eab3a => 'प्रोफाइल संपादित करें';

  @override
  String get legacyUi84add5b295 => 'ईमेल';

  @override
  String get legacyUi5c10b588a9 => 'ईमेल (वैकल्पिक)';

  @override
  String get legacyUi094f6a5934 => 'ईमेल या उपयोगकर्ता नाम';

  @override
  String get legacyUi79d1feaf62 => 'ईमेल स्थिति';

  @override
  String get legacyUia674e88b73 => 'ईमेल सत्यापन';

  @override
  String get legacyUic1feb155ec => 'डेमो लॉगिन चालू करें';

  @override
  String get legacyUi7cf7a0d02a => 'सार्वजनिक साइनअप चालू करें';

  @override
  String get legacyUif6321257f1 => 'यह सार्वजनिक लिंक चालू करें।';

  @override
  String get legacyUid093b28018 => 'चालू करें/रीफ़्रेश करें';

  @override
  String get legacyUi0af149c2ed => 'एन्क्रिप्शन';

  @override
  String get legacyUic1f65ddb75 => 'इंजन';

  @override
  String get legacyUi49dda3d71a => 'इंजन घंटे';

  @override
  String get legacyUi4c9c7856d1 => '6 अंकों का कोड दर्ज करें';

  @override
  String get legacyUibc96ad8350 => 'अधिकतम 2 दशमलव स्थान वाली राशि दर्ज करें';

  @override
  String get legacyUib0e59c93d7 => 'मान्य राशि दर्ज करें।';

  @override
  String get legacyUi6d59e6aee7 => 'बदलाव का कारण 5–500 अक्षरों में दर्ज करें';

  @override
  String get legacyUi571c7347b7 => 'बदलाव का कारण 5–500 अक्षरों में दर्ज करें।';

  @override
  String get legacyUi18b809c9fb => 'कमांड टेक्स्ट दर्ज करें';

  @override
  String get legacyUid5cd51c7b9 => 'क्रेडिट राशि दर्ज करें';

  @override
  String get legacyUibe7572b6c5 => 'राज्य या क्षेत्र दर्ज करें';

  @override
  String get legacyUid148321ad7 => '6 अंकों का कोड दर्ज करें';

  @override
  String get legacyUi0d639c50f1 => 'हमारे भेजे गए 6 अंकों का कोड दर्ज करें';

  @override
  String get legacyUi6d1e849865 =>
      'अपने पंजीकृत संपर्क पर भेजा गया OTP दर्ज करें।';

  @override
  String get legacyUied634c4edc =>
      'साइन इन के लिए उपयोग होने वाला ईमेल पता या उपयोगकर्ता नाम दर्ज करें। खाता मौजूद होने पर हम सीमित समय के लिए मान्य रीसेट लिंक भेजेंगे।';

  @override
  String get legacyUi1378167d52 => 'अपना पासवर्ड दर्ज करें';

  @override
  String get legacyUib6334ab817 => 'अपना उपयोगकर्ता नाम या ईमेल दर्ज करें';

  @override
  String get legacyUic7fb317725 => 'एंटिटी';

  @override
  String get legacyUi04d694e298 => 'एंटिटी ID';

  @override
  String get legacyUi948542c1d6 => 'त्रुटि/गंभीर';

  @override
  String get legacyUic250d77524 => 'इवेंट विवरण';

  @override
  String get legacyUi894b1c749d => 'घटना ID';

  @override
  String get legacyUif8e451a5d0 => 'घटनाएँ उपलब्ध नहीं हैं';

  @override
  String get legacyUief09596668 => 'डेमो से बाहर निकलें';

  @override
  String get legacyUia689a999a5 => 'समाप्त';

  @override
  String get legacyUib98d67213b => 'समाप्त होने वाला';

  @override
  String get legacyUi57fe01159c => 'समाप्ति दिनांक (वैकल्पिक)';

  @override
  String get legacyUi1275b51587 => 'समाप्ति तारीख/समय';

  @override
  String get legacyUi6b440cd506 => 'समाप्ति दिनांक';

  @override
  String get legacyUic9f6710324 => 'समाप्ति होना चाहिए हो में भविष्य';

  @override
  String get legacyUif3e4fadb9e => 'निर्यात करें';

  @override
  String get legacyUi416a52a386 => 'KML निर्यात करें';

  @override
  String get legacyUi09b28aeb8d => 'FCM टोकन';

  @override
  String get legacyUic2bf1a9df5 => 'FCM टोकन के अंतिम 10 अक्षर';

  @override
  String get legacyUi82da67b211 => 'Facebook';

  @override
  String get legacyUi09fef5d8d9 => 'असफल';

  @override
  String get legacyUid68666787d => 'असफल टेबल';

  @override
  String get legacyUi706b9a59b6 => 'शहर लोड नहीं हुए';

  @override
  String get legacyUi6eb9516fdf => 'देश लोड नहीं हुए';

  @override
  String get legacyUi4bc4b2e555 => 'विवरण लोड नहीं हुआ';

  @override
  String get legacyUia7bc426a05 => 'वाहन का पूरा विवरण लोड नहीं हुआ।';

  @override
  String get legacyUia17267ffa7 => 'राज्य लोड नहीं हुए';

  @override
  String get legacyUi6bb1f1d9fb => 'स्थिति अपडेट करने में विफल';

  @override
  String get legacyUi1656649117 => 'विफलता';

  @override
  String get legacyUib7ef43c84d => 'विफलता कोड';

  @override
  String get legacyUi41510b1b21 => 'विफलता संदेश';

  @override
  String get legacyUi8db6a2f1d3 => 'तेज़';

  @override
  String get legacyUiadc7ac2ae5 => 'और तेज़';

  @override
  String get legacyUib0f47aaf77 => 'फ़ेविकॉन';

  @override
  String get legacyUi7d9baea15f => 'फ़ेविकॉन अपडेट हुआ';

  @override
  String get legacyUi2c3cafa4db => 'फाइल:';

  @override
  String get legacyUi55fee60744 => 'फ़ाइल का URL उपलब्ध नहीं है।';

  @override
  String get legacyUif76f22f075 => 'फ़ाइल 10 MB की सीमा से बड़ी है।';

  @override
  String get legacyUi7e184124be => 'फ़ाइल आवश्यक है।';

  @override
  String get legacyUi36f2202687 => 'फ़ाइल 10 MB या उससे छोटी होनी चाहिए।';

  @override
  String get legacyUi937fd74b36 => 'SIM कार्ड फ़िल्टर करें';

  @override
  String get legacyUi15db08d15e => 'फ़िल्टर एक्टिविटी लॉग';

  @override
  String get legacyUi582198fab2 => 'व्यवस्थापक फ़िल्टर करें';

  @override
  String get legacyUi9911a4c0ed => 'डिवाइस फ़िल्टर करें';

  @override
  String get legacyUi6a7fe2dc2c => 'ड्राइवर फ़िल्टर करें';

  @override
  String get legacyUi5439ccf95d => 'जियोफेंस फ़िल्टर करें';

  @override
  String get legacyUif1fe9835a2 => 'टीम फ़िल्टर करें';

  @override
  String get legacyUi8cfc14a859 => 'उपयोगकर्ता फ़िल्टर करें';

  @override
  String get legacyUia9d1432d0d => 'वाहन फ़िल्टर करें';

  @override
  String get legacyUiaa234fb61d => 'Firebase';

  @override
  String get legacyUib15839eae8 => 'Firebase शुरू हुआ';

  @override
  String get legacyUi916a78d701 => 'पहला';

  @override
  String get legacyUic617ebad3b =>
      'परीक्षण से पहले सत्यापन की समस्याएँ ठीक करें';

  @override
  String get legacyUi4d4e9621c4 => 'फ़्लीट की स्थिति';

  @override
  String get legacyUi1cc8d18151 => 'पासवर्ड भूल गए?';

  @override
  String get legacyUibaa0e2872d => 'मुफ़्त साइनअप क्रेडिट';

  @override
  String get legacyUi236ddee138 => 'प्रेषक व्यवस्थापक';

  @override
  String get legacyUi19fe826cc8 => 'प्रेषक ईमेल';

  @override
  String get legacyUi64346b483c => 'पूरा नाम';

  @override
  String get legacyUi9f8ce19bf4 => 'पूरा पता';

  @override
  String get legacyUieeb692087d => 'पूरा नाम';

  @override
  String get legacyUifcee5b52cc => 'GMT ऑफसेट';

  @override
  String get legacyUi590df4df1f => 'GMT अंतर +05:30 प्रारूप में होना चाहिए।';

  @override
  String get legacyUi0933ed5657 => 'GPS मॉडल';

  @override
  String get legacyUicbb0014411 => 'पेट्रोल पंप';

  @override
  String get legacyUifc45f9b7a9 => 'बनाएँ';

  @override
  String get legacyUi549f31c53e => 'रूट बनाएँ';

  @override
  String get legacyUidfde035f40 => 'जियोकोडिंग';

  @override
  String get legacyUi5cdf1dbd7e => 'जियोफेंस';

  @override
  String get legacyUic09b487feb => 'रीप्ले प्राप्त करें';

  @override
  String get legacyUi5442e2b64f => 'GitHub';

  @override
  String get legacyUi1efbf15894 =>
      'कम ज़ूम पर पास के वाहनों को समूह में दिखाएँ';

  @override
  String get legacyUiac69db7d02 => 'वृद्धि चार्ट';

  @override
  String get legacyUibc4359231d => 'जिम';

  @override
  String get legacyUifa8a6b01e3 => 'हेडर कॉपी हुआ';

  @override
  String get legacyUi071c1366b0 => 'अधिक सटीकता के लिए अधिक खोज की जाती है।';

  @override
  String get legacyUi90ccd64974 => 'इतिहास';

  @override
  String get legacyUic3669ffe53 =>
      'इतिहास के लिए लाइव टेलीमेट्री से IMEI वाला वाहन चाहिए।';

  @override
  String get legacyUi8d4a22ea2b => 'इतिहास के मान संख्यात्मक नहीं हैं।';

  @override
  String get legacyUidbb927867e => 'अस्पताल';

  @override
  String get legacyUi3960ec4ca5 => 'होस्ट';

  @override
  String get legacyUiadd03be31a => 'होस्ट, पोर्ट और एन्क्रिप्शन।';

  @override
  String get legacyUi9c4ba7d047 => 'होटल';

  @override
  String get legacyUi1e3beed01c =>
      'सफ़ाई से पहले ऐतिहासिक डेटा कितने समय तक रखा जाएगा।';

  @override
  String get legacyUi2635a51635 =>
      'प्लेटफ़ॉर्म पर व्यवस्थापक की पहचान कैसे होगी।';

  @override
  String get legacyUi0f053057ee =>
      'प्लेटफ़ॉर्म पर उपयोगकर्ता की पहचान कैसे होगी।';

  @override
  String get legacyUi077f5f9dad => 'मेरे पास पहले से रीसेट लिंक है';

  @override
  String get legacyUibff7cfa991 => 'ICCID (वैकल्पिक)';

  @override
  String get legacyUidc7458a51a =>
      'टेलीमेट्री लॉग लोड करने के लिए IMEI आवश्यक है।';

  @override
  String get legacyUif4c88fb92e =>
      'वाहन की घटनाएँ लोड करने के लिए IMEI आवश्यक है।';

  @override
  String get legacyUi7e77081c51 => 'कमांड भेजने के लिए IMEI आवश्यक है।';

  @override
  String get legacyUif44426c787 =>
      'इस वाहन का IMEI उपलब्ध नहीं है। केवल लाइव मानचित्र का सारांश दिखाया जा रहा है।';

  @override
  String get legacyUi8a4b9cf4a9 => 'IMEI नहीं है';

  @override
  String get legacyUi11da2cb7f0 => 'IMSI (वैकल्पिक)';

  @override
  String get legacyUi716f63b96e => 'आइकन';

  @override
  String get legacyUi7e5a975b6a => 'पहचान';

  @override
  String get legacyUi2d40c36445 => 'इग्निशन';

  @override
  String get legacyUif2d738d99c => 'इग्निशन स्रोत';

  @override
  String get legacyUi4157fc56ab => 'चित्र बहुत बड़ा है। अधिकतम 2 MB।';

  @override
  String get legacyUifcf7141427 => 'चित्र बहुत बड़ा है। अधिकतम 5 MB।';

  @override
  String get legacyUieeec98db23 => 'CSV आयात करें';

  @override
  String get legacyUieebd26ef51 => 'निष्क्रिय · 48H';

  @override
  String get legacyUi4b631f6984 => 'जानकारी';

  @override
  String get legacyUi29981bf033 =>
      'इस व्यवस्थापक खाते को असाइन की गई शुरुआती क्रेडिट राशि।';

  @override
  String get legacyUi58984ab1ac => 'शुरुआती क्रेडिट';

  @override
  String get legacyUi5721bbef40 => 'Instagram';

  @override
  String get legacyUi9b5ca633e8 => 'खाते में पर्याप्त क्रेडिट नहीं हैं';

  @override
  String get legacyUi2ab95a4afe => 'व्यवस्थापक ID अमान्य है।';

  @override
  String get legacyUicfa3e9c7e1 => 'इन्वेंटरी आइटम बनाया गया।';

  @override
  String get legacyUi32091e3797 => 'इन्वेंटरी स्थिति';

  @override
  String get legacyUia430dcf58c => 'Jane Smith';

  @override
  String get legacyUi049874e4f7 => 'KML क्लिपबोर्ड पर कॉपी हुआ';

  @override
  String get legacyUi62fc561458 => 'अनुरोध रखें';

  @override
  String get legacyUic67dd20ee8 => 'कुंजी';

  @override
  String get legacyUi52c4afe84f => 'लैंडमार्क स्टूडियो';

  @override
  String get legacyUid1c69a859a => 'अंतिम';

  @override
  String get legacyUi43df3046ba => 'अंतिम बदलाव';

  @override
  String get legacyUi7a78ad49d8 => 'पिछले महीने का राजस्व';

  @override
  String get legacyUicec3d948d9 => 'अंतिम पेमेंट';

  @override
  String get legacyUiada1b72559 => 'अंतिम जाँच';

  @override
  String get legacyUi43dab84ff6 => 'अंतिम लॉगिन';

  @override
  String get legacyUib916a123cc => 'पिछले महीने का राजस्व';

  @override
  String get legacyUi76c1ed9309 => 'पिछला सप्ताह';

  @override
  String get legacyUieb3a622ae8 => 'अक्षांश / देशांतर';

  @override
  String get legacyUi1e5421b5bc => 'अक्षांश/देशांतर';

  @override
  String get legacyUidecd7ca800 => 'नवीनतम';

  @override
  String get legacyUiefaed3a1b0 => 'मौजूदा पासवर्ड रखने के लिए खाली छोड़ें';

  @override
  String get legacyUib8100f5ba8 => 'लाइब्रेरी';

  @override
  String get legacyUi3229609e15 => 'लाइसेंस';

  @override
  String get legacyUi99929a05d8 => 'लाइसेंस द्वारा अवरुद्ध';

  @override
  String get legacyUi7452738cf9 => 'जारी लाइसेंस';

  @override
  String get legacyUibbe96bcfaa => 'उपयोग किए गए लाइसेंस';

  @override
  String get legacyUib957e7bd7b => 'लाइसेंस द्वारा अवरुद्ध';

  @override
  String get legacyUiee92c8a4b6 => 'लाइसेंस';

  @override
  String get legacyUi6731d7cd1a => 'लाइट लोगो';

  @override
  String get legacyUi6a1c6c8807 => 'लाइट लोगो अपडेट हुआ';

  @override
  String get legacyUi24d948e4bd => 'सीमा';

  @override
  String get legacyUied1ed2b68d => 'लिंक कॉपी हुआ।';

  @override
  String get legacyUi36d1b59b88 =>
      'वाहन को प्राथमिक उपयोगकर्ता, GPS डिवाइस और मूल्य निर्धारण प्लान से जोड़ें।';

  @override
  String get legacyUi6b6390a441 => 'LinkedIn';

  @override
  String get legacyUi4ac08d16b8 => 'पुराने संदेश लोड करें';

  @override
  String get legacyUidfe60ca92e => 'लोड अधिक';

  @override
  String get legacyUifc53db81a0 => 'सर्वर से और लोड करें';

  @override
  String get legacyUi949d7ee41c => 'पुराने लोड करें';

  @override
  String get legacyUi6db90a0ab6 => 'लोड हुआ';

  @override
  String get legacyUi326ad2f9f8 => 'असाइन किए गए वाहन लोड हो रहे हैं';

  @override
  String get legacyUi8936529136 => 'उपलब्ध वाहन लोड हो रहे हैं';

  @override
  String get legacyUi9f1e0ce448 => 'दस्तावेज़ लोड हो रहे हैं';

  @override
  String get legacyUide261e9b89 => 'लॉग लोड हो रहा है…';

  @override
  String get legacyUi324989adf0 => 'सेंसर लोड हो रहा है…';

  @override
  String get legacyUid219c68101 => 'लोकेशन';

  @override
  String get legacyUi2350df02c2 => 'लॉग विवरण';

  @override
  String get legacyUiaacbd6aa68 => 'लॉग ID';

  @override
  String get legacyUia3d749050e => 'उपयोगकर्ता के रूप में लॉगिन करें';

  @override
  String get legacyUi31a519ee99 =>
      'लॉगिन, पासवर्ड या खाते की स्थिति के बदलाव यहाँ दिखाई देंगे।';

  @override
  String get legacyUi16b583cf21 => 'लॉग उपलब्ध नहीं हैं';

  @override
  String get legacyUi4c57f0c88d => 'लंदन';

  @override
  String get legacyUi3bf98fa618 => 'पढ़ा हुआ चिह्नित करें';

  @override
  String get legacyUia95e85aed5 => 'अधिकतम';

  @override
  String get legacyUi35f72dc38d => 'अधिकतम गति';

  @override
  String get legacyUi03a68b7d8b => 'मेमोरी उपयोग';

  @override
  String get legacyUi68f4145fee => 'संदेश';

  @override
  String get legacyUi54a144c1dd => 'संदेश भेजना';

  @override
  String get legacyUi23b9e4546e => 'अपने फ़्लीट मैनेजर को यहाँ संदेश भेजें।';

  @override
  String get legacyUi8d546a6dea => 'मेटा';

  @override
  String get legacyUi251edc0eb5 => 'मेटाडेटा';

  @override
  String get legacyUic0b8960edf => 'मेटाडेटा कॉपी हुआ';

  @override
  String get legacyUi7eb0cee888 => 'न्यूनतम';

  @override
  String get legacyUib6bcd4535a => 'कम से कम 3 अक्षर…';

  @override
  String get legacyUi925c181c00 => 'न्यूनतम 6 अक्षर';

  @override
  String get legacyUi092f99ea11 => 'मिनट';

  @override
  String get legacyUib1d7024593 => 'मोबाइल';

  @override
  String get legacyUia0d9c28a1e => 'मोबाइल (वैकल्पिक)';

  @override
  String get legacyUi5968acfb01 => 'मोबाइल नंबर';

  @override
  String get legacyUic242b24d94 => 'मोबाइल कोड';

  @override
  String get legacyUi802cdad736 => 'मोबाइल पुश';

  @override
  String get legacyUi00618b3856 =>
      'संचार के लिए उपयोग होने वाला मोबाइल और ईमेल।';

  @override
  String get legacyUi5d96299833 => 'मोबाइल नंबर (वैकल्पिक)';

  @override
  String get legacyUi2ab961738f => 'मोबाइल कोड';

  @override
  String get legacyUi90ee975346 => 'मोबाइल कोड (वैकल्पिक)';

  @override
  String get legacyUiaa6630b79b => 'मोबाइल पुश पंजीकरण दोबारा किया गया।';

  @override
  String get legacyUia1e34f9157 => 'और कार्रवाइयाँ';

  @override
  String get legacyUi86c0a35ec8 => 'और विकल्प';

  @override
  String get legacyUi69d9f3e5ae => 'संग्रहालय';

  @override
  String get legacyUi4ff2aa7688 => 'मेरे टिकट';

  @override
  String get legacyUi2e65b706ae => 'नाम और कोड आवश्यक हैं।';

  @override
  String get legacyUi1eee3afea2 => 'नेविगेट करें';

  @override
  String get legacyUiccfb5f0286 => 'नया POI';

  @override
  String get legacyUi4894cb39ee => 'नया पासवर्ड';

  @override
  String get legacyUidcaa5db473 => 'नया टिकट';

  @override
  String get legacyUib85e445f60 => 'नया उपयोगकर्ता';

  @override
  String get legacyUia273c96341 => 'नया वाहन';

  @override
  String get legacyUie0725b6664 => 'नया जियोफेंस';

  @override
  String get legacyUif39fa269a9 => 'नया मार्ग';

  @override
  String get legacyUi395e182389 => 'नए उपयोगकर्ता यहाँ दिखाई देंगे।';

  @override
  String get legacyUi2213317245 => 'नए वाहन यहाँ दिखाई देंगे।';

  @override
  String get legacyUi4bfc194b68 => 'अगला पृष्ठ';

  @override
  String get legacyUi1097b553dc => 'रात';

  @override
  String get legacyUi4276e6ab2a => 'कोई डेटा नहीं';

  @override
  String get legacyUi3de93f521b => 'कोई डिवाइस नहीं';

  @override
  String get legacyUi79858167e6 => 'अभी कोई POI नहीं है';

  @override
  String get legacyUia434e9985c => 'कोई प्रदाता नहीं';

  @override
  String get legacyUi7094ba4f01 =>
      'कोई सक्रिय असाइनमेंट नहीं है। डिस्पैच द्वारा असाइन की गई नई यात्राएँ यहाँ दिखाई देंगी।';

  @override
  String get legacyUia9206f399a => 'कोई एक्टिविटी लॉग नहीं';

  @override
  String get legacyUi8bd5b910e5 => 'कोई एक्टिविटी लॉग नहीं मिला';

  @override
  String get legacyUic38a37a193 => 'आपके फ़िल्टर से कोई गतिविधि मेल नहीं खाती।';

  @override
  String get legacyUibff9905096 => 'अभी कोई गतिविधि दर्ज नहीं है।';

  @override
  String get legacyUi0f5cca70f8 => 'कोई व्यवस्थापक नहीं मिला';

  @override
  String get legacyUi31d3df94ab => 'कोई व्यवस्थापक नहीं मिला।';

  @override
  String get legacyUic0d322c2b0 => 'अपनाने का डेटा नहीं है';

  @override
  String get legacyUie5d64448e5 => 'कोई अलर्ट नहीं';

  @override
  String get legacyUi501176c9f8 => 'विश्लेषण डेटा नहीं है';

  @override
  String get legacyUi63f5349bb8 => 'कोई उपयोगकर्ता असाइन नहीं है';

  @override
  String get legacyUi852751d61f => 'कोई वाहन असाइन नहीं है';

  @override
  String get legacyUi7546829892 => 'कोई बिलिंग गतिविधि नहीं मिली।';

  @override
  String get legacyUi657275c0c1 => 'इस राज्य के शहर उपलब्ध नहीं हैं';

  @override
  String get legacyUia130e0f01b => 'कमांड इतिहास नहीं है';

  @override
  String get legacyUi92db635f14 => 'कोई कमांड अभी तक नहीं';

  @override
  String get legacyUi14a4bfc72c => 'इस महीने कोई यात्रा पूरी नहीं हुई।';

  @override
  String get legacyUiee9c2e1df0 => 'कॉन्फ़िगरेशन नहीं है';

  @override
  String get legacyUic3017a3316 => 'अभी कोई बातचीत नहीं है';

  @override
  String get legacyUic140165b8f => 'अभी कोई क्रेडिट इतिहास नहीं है।';

  @override
  String get legacyUic8114767e8 => 'कोई डैशबोर्ड सेट नहीं है';

  @override
  String get legacyUi7be70212b0 => 'इस अवधि का दिन या रात का डेटा नहीं है।';

  @override
  String get legacyUi2a4eb69350 => 'कोई विवरण नहीं';

  @override
  String get legacyUi03ca0261ac => 'कोई डिवाइस नहीं';

  @override
  String get legacyUi893d388d16 => 'इस वाहन को कोई डिवाइस असाइन नहीं है।';

  @override
  String get legacyUi8386fe15ef => 'कोई दस्तावेज़ नहीं';

  @override
  String get legacyUi017ce6604c => 'कोई दस्तावेज़ अपलोड नहीं किया गया';

  @override
  String get legacyUiec7eb3c93e => 'कोई दस्तावेज़ अपलोड किया गया अभी तक नहीं';

  @override
  String get legacyUi54e1079e44 =>
      'अभी कोई दस्तावेज़ नहीं है। अपलोड बटन से अपना पहला दस्तावेज़ अपलोड करें।';

  @override
  String get legacyUia419748e62 => 'ड्राइवर की कोई गतिविधि नहीं मिली।';

  @override
  String get legacyUi98e6629503 =>
      'ड्राइवर दस्तावेज़ के प्रकार सेट नहीं हैं। अपने व्यवस्थापक से प्रकार जोड़ने को कहें।';

  @override
  String get legacyUi36f5cbf894 => 'ड्राइवर के दस्तावेज़ नहीं हैं';

  @override
  String get legacyUic5dc9718a6 => 'कोई ड्राइवर नहीं';

  @override
  String get legacyUi7a127d70b3 => 'कोई ड्राइवर उपलब्ध नहीं';

  @override
  String get legacyUi9c8198d34d => 'कोई ड्राइवर नहीं मिला';

  @override
  String get legacyUi208ffc64d1 => 'घटना का विवरण नहीं मिला';

  @override
  String get legacyUiec11a02374 =>
      'चुनी गई तारीख सीमा और फ़िल्टर के लिए कोई घटना नहीं है।';

  @override
  String get legacyUia48cbba615 => 'कोई घटना नहीं मिली';

  @override
  String get legacyUi81ab95b9f0 => 'अभी कोई घटना नहीं है';

  @override
  String get legacyUi774a252215 => 'कोई फ़ाइल उपलब्ध नहीं है।';

  @override
  String get legacyUi35f65e1e57 => 'कोई जियोफेंस उपलब्ध नहीं है।';

  @override
  String get legacyUi019549899f => 'अभी कोई जियोफेंस नहीं है';

  @override
  String get legacyUi5358cec56d => 'इतिहास बिंदु नहीं हैं';

  @override
  String get legacyUia0ed9c8031 => 'इस अवधि के इतिहास बिंदु नहीं हैं।';

  @override
  String get legacyUi8bf09d954a => 'कोई जुड़ा हुआ वाहन उपलब्ध नहीं है';

  @override
  String get legacyUif48787eb30 => 'कोई लॉग नहीं मिला';

  @override
  String get legacyUi6b68d448a0 => 'इस वाहन के लॉग नहीं मिले';

  @override
  String get legacyUic7462a9dac => 'अभी कोई लॉग नहीं है';

  @override
  String get legacyUi1db215fbaa => 'आपकी खोज से कुछ मेल नहीं खाता।';

  @override
  String get legacyUia734fde29a => 'कोई मेल खाता POI नहीं';

  @override
  String get legacyUi2d928306c1 => 'कोई मेल खाता ड्राइवर नहीं';

  @override
  String get legacyUid6e8839481 => 'कोई मेल खाता जियोफेंस नहीं';

  @override
  String get legacyUif6830db2e7 => 'कोई मेल खाता लॉग नहीं';

  @override
  String get legacyUi748bd377da => 'कोई मेल खाता रिकॉर्ड नहीं';

  @override
  String get legacyUi6590e5eab8 => 'कोई मेल खाता रूट नहीं';

  @override
  String get legacyUid17e9558cf => 'कोई मेल खाता उप-उपयोगकर्ता नहीं';

  @override
  String get legacyUif1d8690cd7 =>
      'कोई मेल खाता वाहन नहीं मिला। दूसरी खोज या फ़िल्टर आज़माएँ।';

  @override
  String get legacyUic04921f8d9 => 'अभी कोई संदेश नहीं है';

  @override
  String get legacyUi2449a03436 => 'मोड डेटा नहीं है';

  @override
  String get legacyUi50806db52e => 'सूचना सेटिंग्स नहीं मिलीं';

  @override
  String get legacyUic1f531f996 => 'कोई भुगतान नहीं मिला';

  @override
  String get legacyUiaf4a7f06d0 => 'कोई प्लान नहीं मिला';

  @override
  String get legacyUi4ae157aff3 => 'हाल के अलर्ट नहीं हैं।';

  @override
  String get legacyUi26776d0320 => 'हाल के उपयोगकर्ता नहीं हैं';

  @override
  String get legacyUi42ec1ecf96 => 'हाल के वाहन नहीं हैं';

  @override
  String get legacyUi9833364a35 => 'कोई रूट उपलब्ध नहीं है।';

  @override
  String get legacyUid233dd5d9f => 'अभी कोई रूट नहीं है';

  @override
  String get legacyUic9bfb1492b => 'सुरक्षा संबंधी कोई गतिविधि नहीं मिली।';

  @override
  String get legacyUid07b6b93d6 => 'चुनने योग्य वाहन नहीं हैं';

  @override
  String get legacyUi5653bf7251 => 'इस अवधि के सेंसर बिंदु नहीं हैं।';

  @override
  String get legacyUi1ef59c9c2b => 'कोई सेंसर नहीं';

  @override
  String get legacyUi3c30b80f16 => 'इस वाहन के सेंसर सेट नहीं हैं।';

  @override
  String get legacyUicbae766d34 => 'सेटिंग्स संबंधी कोई गतिविधि नहीं मिली।';

  @override
  String get legacyUicd0c79d188 => 'साझा लिंक नहीं हैं';

  @override
  String get legacyUi9eac2f6695 => 'इस देश के राज्य उपलब्ध नहीं हैं';

  @override
  String get legacyUid05ab60501 => 'स्थिति डेटा नहीं है';

  @override
  String get legacyUi4b78e836ec => 'कोई उप-उपयोगकर्ता नहीं';

  @override
  String get legacyUib30adf9758 => 'कोई उप-उपयोगकर्ता उपलब्ध नहीं है';

  @override
  String get legacyUi3a1fa8f145 => 'टीम के सदस्य नहीं मिले';

  @override
  String get legacyUi12c6f10a41 => 'टेलीमेट्री विवरण नहीं मिला';

  @override
  String get legacyUi429d6e6ece => 'टेलीमेट्री लॉग नहीं मिले';

  @override
  String get legacyUiea04e18b66 => 'इस अवधि की शीर्ष परिसंपत्तियाँ नहीं हैं।';

  @override
  String get legacyUi48d2d8da35 => 'कोई लेनदेन नहीं';

  @override
  String get legacyUid60c045dd2 => 'कोई लेनदेन नहीं मिला';

  @override
  String get legacyUif794b6c6d1 => 'कोई लेन-देन अभी तक नहीं';

  @override
  String get legacyUi8d92589518 => 'रुझान डेटा नहीं है';

  @override
  String get legacyUi7d3e5f72b8 => 'इस दृश्य में यात्राएँ नहीं हैं।';

  @override
  String get legacyUib4c96ae04e => 'कोई असंबद्ध उपयोगकर्ता नहीं मिला।';

  @override
  String get legacyUi4b3155e704 =>
      'आपकी खोज से कोई असंबद्ध उपयोगकर्ता मेल नहीं खाता।';

  @override
  String get legacyUid9c71203a5 => 'चुनी गई अवधि का उपयोग डेटा नहीं है।';

  @override
  String get legacyUic4b060bd59 => 'कोई उपयोगकर्ता नहीं';

  @override
  String get legacyUi5cc2b29f54 => 'कोई उपयोगकर्ता असाइन नहीं है';

  @override
  String get legacyUi3b614a59c7 => 'कोई उपयोगकर्ता उपलब्ध नहीं';

  @override
  String get legacyUi612eb3c64c => 'कोई उपयोगकर्ता नहीं मिला';

  @override
  String get legacyUie611ef5702 => 'कोई उपयोगकर्ता नहीं मिला';

  @override
  String get legacyUif800dfd722 => 'मान्य GPS पथ या ठहराव चिह्न नहीं मिले।';

  @override
  String get legacyUib96ee669b0 => 'वाहन की कोई गतिविधि नहीं मिली।';

  @override
  String get legacyUi748eafd21d => 'कोई वाहन नहीं';

  @override
  String get legacyUi8fbc8deb7a =>
      'इस समय मानचित्र पर कोई वाहन नहीं दिख रहा है।';

  @override
  String get legacyUi72ed5bbcdf => 'अभी कोई वाहन असाइन नहीं है।';

  @override
  String get legacyUi7223e6b8cb => 'कोई वाहन असाइन किया गया नहीं';

  @override
  String get legacyUiac0e4dbd5b => 'कोई वाहन उपलब्ध नहीं';

  @override
  String get legacyUic578cfdbd5 => 'कोई वाहन नहीं मिला';

  @override
  String get legacyUie1de5f8ce2 => 'आपकी खोज से कोई वाहन मेल नहीं खाता';

  @override
  String get legacyUia41b297cf1 => 'साप्ताहिक तुलना डेटा नहीं है।';

  @override
  String get legacyUi35163920f3 => 'कोई विजेट सेट नहीं है';

  @override
  String get legacyUi45e118d056 => 'सामान्य';

  @override
  String get legacyUif8e45b2be2 => 'उत्तर';

  @override
  String get legacyUi2c924e3088 => 'नोट:';

  @override
  String get legacyUi2fd5716446 => 'नोट्स (वैकल्पिक)';

  @override
  String get legacyUicf62dbc83d => 'नोट्स / विवरण';

  @override
  String get legacyUi3e56dbb775 => 'इस दस्तावेज़ के बारे में नोट्स';

  @override
  String get legacyUi7faf33fcca => 'निर्यात करने के लिए कुछ नहीं है';

  @override
  String get legacyUi76544814eb => 'सूचना की कार्रवाइयाँ';

  @override
  String get legacyUi4eb32de6c9 => 'सूचना सेटिंग्स सफलतापूर्वक सहेजी गईं।';

  @override
  String get legacyUi8ca2cb9290 => 'ओडोमीटर';

  @override
  String get legacyUi6c3a72eaf6 => 'कार्यालय';

  @override
  String get legacyUi63f34dd211 => 'पुराने';

  @override
  String get legacyUi35c5d4307a => 'पुरानी पंक्तियाँ';

  @override
  String get legacyUi9f8f7411e8 => 'एक या अधिक चुने गए वाहन अमान्य हैं।';

  @override
  String get legacyUie81cd61ea1 =>
      'केवल असाइन किए गए उपयोगकर्ता वाहनों को साझा किया जा सकता है।';

  @override
  String get legacyUicf9b77061f => 'खुला';

  @override
  String get legacyUi8f5f529938 => 'खोलें / सहेजें';

  @override
  String get legacyUi55d00c31ab => 'वाहन खोलें';

  @override
  String get legacyUicc6b7ec50c => 'असफल पंक्तियों की CSV खोलें';

  @override
  String get legacyUi99bd9c01d7 => 'OpenVTS सूचनाएँ';

  @override
  String get legacyUic1b94f880c => 'वैकल्पिक राशि';

  @override
  String get legacyUi7afdcf3257 => 'वैकल्पिक ईमेल';

  @override
  String get legacyUic553137ef5 => 'वैकल्पिक मोबाइल';

  @override
  String get legacyUi410d481882 => 'वैकल्पिक नोट्स';

  @override
  String get legacyUi4f8f9c2bba => 'वैकल्पिक रसीद या नोट';

  @override
  String get legacyUi3494a60f96 => 'वैकल्पिक उपयोगकर्ता नाम';

  @override
  String get legacyUia493c04fb5 => 'वैकल्पिक; कम से कम 3 अक्षर दर्ज करें';

  @override
  String get legacyUi6bf5da9c08 => 'विकल्प';

  @override
  String get legacyUidefe0db589 => 'क्रम तय करें';

  @override
  String get legacyUi6e6a6f2086 => 'अन्य';

  @override
  String get legacyUi4bed336194 => 'आउटपुट';

  @override
  String get legacyUi9e339da256 => 'अधिक गति चालू है';

  @override
  String get legacyUi0efc2e6be4 => 'अवलोकन';

  @override
  String get legacyUi3e90e4cbf4 => 'स्वामित्व';

  @override
  String get legacyUi07afcc61d8 => 'पैकेट प्रकार';

  @override
  String get legacyUif92c24e8df => 'पार्क';

  @override
  String get legacyUi07ba1bef85 => 'पक्ष';

  @override
  String get legacyUi8be3c943b1 => 'पासवर्ड';

  @override
  String get legacyUi408255ed02 => 'पासवर्ड (वैकल्पिक)';

  @override
  String get legacyUi092a16e7af => 'पासवर्ड बदला गया';

  @override
  String get legacyUi47fa528931 => 'पासवर्ड बदला गया।';

  @override
  String get legacyUi3efdbb2011 => 'पासवर्ड अपडेट हुआ';

  @override
  String get legacyUi8ac0c75d5e =>
      'ईमेल से पूरा रीसेट लिंक या टोकन चिपकाएँ। रीसेट लिंक केवल एक बार उपयोग किए जा सकते हैं और अपने आप समाप्त हो जाते हैं।';

  @override
  String get legacyUi5616b61bb7 => 'पेलोड JSON';

  @override
  String get legacyUif8c3596eab => 'पेलोड एक मान्य JSON ऑब्जेक्ट होना चाहिए।';

  @override
  String get legacyUi23b35c414a => 'पेमेंट मोड';

  @override
  String get legacyUi670d2a76c7 => 'पेमेंट मोड';

  @override
  String get legacyUi662210d869 => 'भुगतान माध्यम का विवरण';

  @override
  String get legacyUia629fd8a2e => 'पेमेंट प्रकार';

  @override
  String get legacyUi43f8c9c90f => 'भुगतान गतिविधि यहाँ दिखाई देगी।';

  @override
  String get legacyUi8fbf2ec0dd => 'पेमेंट मोड';

  @override
  String get legacyUi653c04fc42 =>
      'इस अवधि के भुगतान माध्यम का विवरण उपलब्ध नहीं है।';

  @override
  String get legacyUidbc3c0ca72 => 'भुगतान दर्ज किया गया';

  @override
  String get legacyUi197b45d161 => 'भुगतान संदर्भ';

  @override
  String get legacyUi96f608c16c => 'लंबित';

  @override
  String get legacyUid1240d2832 => 'लंबित / असफल';

  @override
  String get legacyUi9126c119ae => 'लंबित पेमेंट';

  @override
  String get legacyUib4ebfb2f75 => 'लंबित पेमेंट';

  @override
  String get legacyUi167a47ff3e => 'द्वारा किया गया';

  @override
  String get legacyUi1785713451 => 'अनुमति';

  @override
  String get legacyUid06d555709 => 'अनुमतियाँ';

  @override
  String get legacyUi1e99c04657 => 'अनुमतियाँ अपडेट हुईं';

  @override
  String get legacyUi0219adf447 => 'व्यक्तिगत विवरण और पता';

  @override
  String get legacyUib1b9e59387 => 'व्यक्तिगत जानकारी';

  @override
  String get legacyUi77064d5265 => 'फोन';

  @override
  String get legacyUi26730cddc4 => 'CSV चुनें';

  @override
  String get legacyUif2c5ca7b8c => 'पिनकोड';

  @override
  String get legacyUifd25c49d56 => 'पिनकोड (वैकल्पिक)';

  @override
  String get legacyUiae2f98a099 => 'प्लान';

  @override
  String get legacyUiec0632cbbf => 'प्लान का नाम';

  @override
  String get legacyUi2b366a2f95 => 'प्लान का मूल्य';

  @override
  String get legacyUi7f97f6a268 => 'प्लान बनाया और चुना गया';

  @override
  String get legacyUi2db331cefa => 'नंबर प्लेट';

  @override
  String get legacyUi7d86677521 => 'नंबर प्लेट नंबर';

  @override
  String get legacyUia6b7aa4d9c => 'नंबर प्लेट (वैकल्पिक)';

  @override
  String get legacyUif2ce282e2d => 'नंबर प्लेट नंबर';

  @override
  String get legacyUi09d9c23846 => 'नंबर प्लेट (वैकल्पिक)';

  @override
  String get legacyUi123a7f2fcc => 'प्लेटफॉर्म';

  @override
  String get legacyUi16596c477e =>
      'प्लेटफ़ॉर्म व्यवहार, साइनअप, जियोकोडिंग और डेटा संरक्षण।';

  @override
  String get legacyUid095e279b3 =>
      'आगे बढ़ने से पहले हाइलाइट किए गए फ़ील्ड ठीक करें।';

  @override
  String get legacyUi51668149ea => 'कृपया व्यवस्थापक चुनें।';

  @override
  String get legacyUife035157cd => 'पोर्ट';

  @override
  String get legacyUi16c2eb4dbb => 'पोर्ट';

  @override
  String get legacyUib629d4165b => 'डाक / ZIP कोड';

  @override
  String get legacyUib86b6a2b3b => 'डाक कोड (वैकल्पिक)';

  @override
  String get legacyUi90eceb016c => 'कोड';

  @override
  String get legacyUif1fbb2b43d => 'पूर्वावलोकन';

  @override
  String get legacyUiba3e0b4a86 => 'पूर्वावलोकन अपडेट हुआ';

  @override
  String get legacyUi81f547195b => 'पिछला पृष्ठ';

  @override
  String get legacyUi3e8248e32e => 'कीमत';

  @override
  String get legacyUi15ac0c0a27 => 'मूल्य निर्धारण प्लान';

  @override
  String get legacyUid3dcce7d10 => 'प्राथमिक रंग';

  @override
  String get legacyUi170f443f36 => 'प्राथमिक उपयोगकर्ता';

  @override
  String get legacyUia1055f11a9 => 'प्राथमिक रंग';

  @override
  String get legacyUic1ee865b42 => 'प्राथमिक रंग (हेक्स)';

  @override
  String get legacyUi0554f68465 => 'प्राथमिक उपयोगकर्ता';

  @override
  String get legacyUi1e5947a051 =>
      'प्राथमिक उपयोगकर्ता, डिवाइस, वाहन प्रकार और मूल्य निर्धारण प्लान आवश्यक हैं।';

  @override
  String get legacyUi886cbff9d9 => 'प्राथमिकता';

  @override
  String get legacyUi7e7302bb73 => 'प्रोफाइल नहीं लोड हुआ अभी तक';

  @override
  String get legacyUi5049e8f42b => 'प्रोफ़ाइल चित्र अपडेट हुआ';

  @override
  String get legacyUi49ba5b4d7b => 'प्रोफ़ाइल सेटिंग्स उपलब्ध नहीं हैं';

  @override
  String get legacyUibcf7629607 => 'प्रोफाइल अपडेट हुआ';

  @override
  String get legacyUibda244507b =>
      'प्रोफ़ाइल, कंपनी या कॉन्फ़िगरेशन के बदलाव यहाँ दिखाई देंगे।';

  @override
  String get legacyUi204be1a53a => 'अनुमानित';

  @override
  String get legacyUi5c620cdb78 => 'प्रमाण का प्रकार';

  @override
  String get legacyUi1ed77c3f7f => 'प्रोटोकॉल';

  @override
  String get legacyUi7ceee3f361 => 'प्रदाता';

  @override
  String get legacyUi767359109d => 'प्रदाता संदर्भ';

  @override
  String get legacyUi8d80f9c731 => 'प्रदाता कवरेज समाप्त होगा';

  @override
  String get legacyUi8a87202949 => 'सार्वजनिक URL उपलब्ध नहीं है।';

  @override
  String get legacyUi411c13db3b => 'सार्वजनिक साइनअप और स्वागत क्रेडिट।';

  @override
  String get legacyUicf0a64d03d =>
      'रीफ़्रेश करने के लिए नीचे खींचें और प्रोफ़ाइल दोबारा लोड करें।';

  @override
  String get legacyUic8f58b21ae =>
      'रीफ़्रेश करने के लिए नीचे खींचें या नया ड्राइवर जोड़ें।';

  @override
  String get legacyUi011bc421c2 =>
      'रीफ़्रेश करने के लिए नीचे खींचें या नया उप-उपयोगकर्ता बनाएँ।';

  @override
  String get legacyUi6a599877d7 => 'कतार में';

  @override
  String get legacyUia16c5bbe4b => 'सीमा';

  @override
  String get legacyUida433cd41e => 'रॉ';

  @override
  String get legacyUice09c15f57 => 'मूल पैकेट';

  @override
  String get legacyUia3ccb33027 => 'Razorpay';

  @override
  String get legacyUi2af51c3e17 => 'पासवर्ड दोबारा दर्ज करें';

  @override
  String get legacyUi852b438f91 => 'पढ़ा हुआ';

  @override
  String get legacyUid14d593883 => 'सभी पढ़े हुए चिह्नित करें';

  @override
  String get legacyUi00db810078 => 'समायोजन का कारण';

  @override
  String get legacyUid4835a2d13 => 'राशि बदलने का कारण (5–500 अक्षर)';

  @override
  String get legacyUi03c3ccd3ff => 'हाल की अलर्ट';

  @override
  String get legacyUi3abf211c93 => 'हाल की पेमेंट';

  @override
  String get legacyUi93c62de33f => 'हाल की उपयोगकर्ता';

  @override
  String get legacyUi6b33999078 => 'हाल की वाहन';

  @override
  String get legacyUi790a1b9e7b =>
      'बैकएंड से मिलने पर हाल की गतिविधि यहाँ दिखाई देगी।';

  @override
  String get legacyUic1541851a1 => 'हाल की सेवा गतिविधि';

  @override
  String get legacyUi204110a010 =>
      'डैशबोर्ड सारांश से मिलने पर हाल के उपयोगकर्ता यहाँ दिखाई देंगे।';

  @override
  String get legacyUida67fde0f7 => 'फिर केंद्र में लाएँ';

  @override
  String get legacyUi7df7c0bb40 => 'प्राप्तकर्ता ईमेल';

  @override
  String get legacyUi8ee92c936a => 'प्राप्तकर्ता/उपयोगकर्ता';

  @override
  String get legacyUi6577ced3c0 => 'भुगतान दर्ज करें';

  @override
  String get legacyUib19313692e => 'दर्ज करने वाला';

  @override
  String get legacyUi471b94d402 => 'फिर से करें';

  @override
  String get legacyUidb1c784524 => 'संदर्भ';

  @override
  String get legacyUic9dc8442d5 => 'संदर्भ (वैकल्पिक)';

  @override
  String get legacyUie3039b8476 => 'संदर्भ (वैकल्पिक)';

  @override
  String get legacyUid8b2ee1dcd => 'संदर्भ की अधिकतम लंबाई 200 है';

  @override
  String get legacyUi7a8e2a362c => 'संदर्भ 100 अक्षर या उससे कम होना चाहिए।';

  @override
  String get legacyUi483e715402 => 'व्यवस्थापक रीफ़्रेश करें';

  @override
  String get legacyUif2b5787c06 => 'रीफ्रेश डैशबोर्ड';

  @override
  String get legacyUie75f05fced => 'ड्राइवर रीफ़्रेश करें';

  @override
  String get legacyUiebbc55f9ce => 'इतिहास रीफ़्रेश करें';

  @override
  String get legacyUid0512701b2 => 'इन्वेंटरी रीफ़्रेश करें';

  @override
  String get legacyUif6cf59106a => 'संदेश रीफ़्रेश करें';

  @override
  String get legacyUid7cb2b4eea => 'रिपोर्ट विकल्प रीफ़्रेश करें';

  @override
  String get legacyUi323540a087 => 'सेटिंग्स रीफ़्रेश करें';

  @override
  String get legacyUiade15a52e2 => 'स्थिति रीफ़्रेश करें';

  @override
  String get legacyUie4d3b8b5ff => 'टीम रीफ़्रेश करें';

  @override
  String get legacyUi12f92ceb6e => 'टिकट रीफ़्रेश करें';

  @override
  String get legacyUi3367ca735f => 'लेनदेन रीफ़्रेश करें';

  @override
  String get legacyUi892f6f322d => 'उपयोगकर्ता रीफ़्रेश करें';

  @override
  String get legacyUidf50facb6a => 'वाहन रीफ़्रेश करें';

  @override
  String get legacyUid42d9c1932 => 'विजेट रीफ़्रेश करें';

  @override
  String get legacyUia844fcf834 => 'पंजीकृत';

  @override
  String get legacyUi9aba73febb => 'पंजीकृत टोकन के अंतिम 10 अक्षर';

  @override
  String get legacyUic498221a5a => 'पंजीकरण तारीख';

  @override
  String get legacyUi20e264f6a1 => 'संबंधित ठहराव';

  @override
  String get legacyUi62d14389b3 => 'दस्तावेज़ प्रकार दोबारा लोड करें';

  @override
  String get legacyUia2653dac4a => 'टिप्पणी';

  @override
  String get legacyUie963907dac => 'हटाएं';

  @override
  String get legacyUi0fcc6594fc => 'अटैचमेंट हटाएँ';

  @override
  String get legacyUi48666118ca => 'मेटाडेटा पंक्ति हटाएँ';

  @override
  String get legacyUif96ba1e583 => 'इस ड्राइवर से वाहन का असाइनमेंट हटाएँ?';

  @override
  String get legacyUi0165f7088a => 'नवीनीकरण करें';

  @override
  String get legacyUib219a06163 => 'वाहन रिन्यू करें';

  @override
  String get legacyUi4913250b6c => 'वार्षिक कवरेज का नवीनीकरण करें';

  @override
  String get legacyUif192fe3e94 => 'वार्षिक कवरेज का नवीनीकरण करें?';

  @override
  String get legacyUi1cce449350 =>
      'एक बार में अधिकतम 100 वाहनों का नवीनीकरण करें';

  @override
  String get legacyUi714c2b126f =>
      'एक बार में अधिकतम 100 वाहनों का नवीनीकरण करें।';

  @override
  String get legacyUibb47b991fe => 'नवीनीकरण अनुरोध';

  @override
  String get legacyUiac2377c0dd => 'रीप्ले की गति';

  @override
  String get legacyUi5cc45fda55 => 'बातचीत शुरू होने पर जवाब यहाँ दिखाई देंगे।';

  @override
  String get legacyUid7a41420c8 =>
      'टिकट पर बातचीत शुरू होने पर जवाब यहाँ दिखाई देंगे।';

  @override
  String get legacyUi1f21d9edca => 'जवाब बहुत लंबा है।';

  @override
  String get legacyUi4c7c79f6a9 => 'जवाब का संदेश आवश्यक है।';

  @override
  String get legacyUic9e8dd4159 => 'जवाब सफलतापूर्वक भेजा गया।';

  @override
  String get legacyUi5ce1bacd48 => 'जवाब भेजा गया।';

  @override
  String get legacyUi49072e5767 => 'जवाब का ईमेल पता (वैकल्पिक)';

  @override
  String get legacyUi6e2c712363 => 'समस्या की रिपोर्ट करें';

  @override
  String get legacyUi0ca4fce136 => 'रिपोर्ट का प्रकार';

  @override
  String get legacyUi4857497af3 => 'नया रीसेट लिंक माँगें';

  @override
  String get legacyUida30a140cc => 'वाहन के नवीनीकरण का अनुरोध करें?';

  @override
  String get legacyUic26bf60fed => 'अनुरोध किया गया';

  @override
  String get legacyUi1d3cb8a962 => 'कोड दोबारा भेजें';

  @override
  String get legacyUi56553100b0 => 'फ़िल्टर रीसेट करें';

  @override
  String get legacyUibb02ea158c => 'रीसेट लिंक या टोकन';

  @override
  String get legacyUi3ddc852b26 => 'उत्तर दिशा रीसेट करें';

  @override
  String get legacyUi5c4bc97ee5 => 'पासवर्ड रीसेट करें';

  @override
  String get legacyUi4f21821190 => 'जवाब दिया गया';

  @override
  String get legacyUi966ea65ee9 => 'जवाब हेक्स में';

  @override
  String get legacyUi3585d7553d => 'रेस्तराँ';

  @override
  String get legacyUiab6d02bfbb => 'आपके व्यवस्थापक द्वारा प्रतिबंधित';

  @override
  String get legacyUic7199d9e95 => 'डेटा संरक्षण';

  @override
  String get legacyUi9393bfa8e2 => 'डेटा संरक्षण अवधि';

  @override
  String get legacyUibf1c27deea => 'मुद्राएँ फिर लोड करें';

  @override
  String get legacyUi2e84dd3c7d => 'पंजीकरण फिर करें';

  @override
  String get legacyUic507a566fc => 'रिवर्स जियोकोडिंग सटीकता';

  @override
  String get legacyUi7148d08646 => 'तरंग';

  @override
  String get legacyUic3f104d136 => 'भूमिका';

  @override
  String get legacyUib1b392607d => 'चलाएं';

  @override
  String get legacyUi26c35575bf => 'सेंसर चलाएँ';

  @override
  String get legacyUiba51f0a9fa => 'इतिहास खोजें';

  @override
  String get legacyUia84c30c93c => 'सफ़ाई चलाएँ';

  @override
  String get legacyUibd4e4bc9f2 => 'SIM नंबर';

  @override
  String get legacyUi135447fb8f => 'केवल SIM';

  @override
  String get legacyUi3454bbef7f => 'SIM प्रदाता';

  @override
  String get legacyUi0366e95ddf => 'SIM प्रदाता (वैकल्पिक)';

  @override
  String get legacyUi4636ab9e9a => 'SIM कार्ड अपडेट हुआ।';

  @override
  String get legacyUi12897d0b88 => 'SIM स्थिति';

  @override
  String get legacyUi1f4f5e7e3c => 'SMTP खाते का लॉगिन।';

  @override
  String get legacyUi7d08205aa6 => 'SMTP सेटिंग्स सेव हुआ।';

  @override
  String get legacyUia70c3bcf1d => 'सैन फ़्रांसिस्को';

  @override
  String get legacyUi340bbc7875 => 'सैटेलाइट';

  @override
  String get legacyUidb95397447 => '.kml सहेजें';

  @override
  String get legacyUifa2984b367 => 'बदलाव सेव करें';

  @override
  String get legacyUi78fe0922d6 => 'कंपनी सहेजें';

  @override
  String get legacyUic6606cd51c => 'कॉन्फ़िगरेशन सहेजें';

  @override
  String get legacyUi909bf3e807 => 'प्रोफ़ाइल सहेजें';

  @override
  String get legacyUif2f3d66a79 => 'स्कूल';

  @override
  String get legacyUid09c8bca28 => 'SIM नंबर खोजें…';

  @override
  String get legacyUiabddbf1811 => 'गतिविधि लॉग खोजें...';

  @override
  String get legacyUi9a99566535 => 'गतिविधि खोजें…';

  @override
  String get legacyUi1321daf435 => 'असाइन किए गए ड्राइवर खोजें';

  @override
  String get legacyUie6ac2b6800 => 'असाइन किए गए वाहन खोजें';

  @override
  String get legacyUi3a97577679 => 'उपलब्ध ड्राइवर खोजें';

  @override
  String get legacyUiacd1382ab4 => 'उपलब्ध वाहन खोजें…';

  @override
  String get legacyUi03ef7546a9 => 'IMEI से खोजें…';

  @override
  String get legacyUia8854d5f97 => 'कोड से खोजें...';

  @override
  String get legacyUi411482b8e7 => 'तारीख, गतिविधि, क्रेडिट या वाहन से खोजें…';

  @override
  String get legacyUi28abc0313d => 'नाम से खोजें';

  @override
  String get legacyUi28f3d064ea => 'नाम या श्रेणी से खोजें';

  @override
  String get legacyUi4120e178da => 'नाम या नंबर प्लेट से खोजें…';

  @override
  String get legacyUibb6cfd804d => 'नाम या ईमेल से खोजें…';

  @override
  String get legacyUi1c1d641fe8 => 'नाम, नंबर प्लेट, IMEI या VIN से खोजें';

  @override
  String get legacyUife32b8f32a => 'नाम, नंबर प्लेट या IMEI से खोजें…';

  @override
  String get legacyUibdc6551409 =>
      'नाम, नंबर प्लेट, VIN, IMEI या SIM से खोजें...';

  @override
  String get legacyUiba20cfd893 => 'संदर्भ या व्यवस्थापक से खोजें...';

  @override
  String get legacyUi45b6baaad3 => 'दैनिक रिकॉर्ड खोजें...';

  @override
  String get legacyUie43926680a => 'डिवाइस लॉग खोजें';

  @override
  String get legacyUi26eb1d222b => 'डिवाइस का प्रकार खोजें…';

  @override
  String get legacyUi98110e65a0 => 'लोड किए गए लॉग खोजें';

  @override
  String get legacyUi48225af1f4 => 'लॉग खोजें';

  @override
  String get legacyUi20f28ed35b => 'नाम, IMEI, SIM या प्रकार खोजें';

  @override
  String get legacyUic60723c651 => 'नाम, नंबर प्लेट या IMEI खोजें';

  @override
  String get legacyUi3dadc5cddf =>
      'नाम, उपयोगकर्ता नाम, ईमेल, मोबाइल, वाहन या नंबर प्लेट खोजें...';

  @override
  String get legacyUi0417c5f97b =>
      'नाम, उपयोगकर्ता नाम, ईमेल या मोबाइल खोजें...';

  @override
  String get legacyUi5196e5c8da => 'स्थान या पता खोजें...';

  @override
  String get legacyUic3290fb221 => 'स्थान खोजें...';

  @override
  String get legacyUi60c8ce351b => 'प्लान, मुद्रा, अवधि या मूल्य खोजें...';

  @override
  String get legacyUie5483c71e7 => 'प्रदाता खोजें…';

  @override
  String get legacyUi98e27d7b41 => 'संदर्भ, प्रदाता या अन्य पक्ष खोजें...';

  @override
  String get legacyUidd77f6ecc1 => 'संदर्भ, प्रदाता, उपयोगकर्ता या वाहन खोजें';

  @override
  String get legacyUi0066a752cb => 'रूट नाम से खोजें';

  @override
  String get legacyUi502e6eaf2c => 'सेंसर खोजें…';

  @override
  String get legacyUi0cfffb61af => 'सेंसर खोजें…';

  @override
  String get legacyUi233ad2b14f => 'विषय, नंबर या स्थिति खोजें';

  @override
  String get legacyUid320d41a03 => 'टिकट खोजें…';

  @override
  String get legacyUi65da39d5f0 => 'लेनदेन खोजें...';

  @override
  String get legacyUi25dfae4e3a => 'यात्राएँ खोजें';

  @override
  String get legacyUida80ead473 => 'असंबद्ध उपयोगकर्ता खोजें...';

  @override
  String get legacyUie5b2404515 => 'उपयोगकर्ता/वाहन खोजें…';

  @override
  String get legacyUi8cdc4c0930 => 'उपयोगकर्ता खोजें…';

  @override
  String get legacyUi2e4b72c10c => 'वाहन खोजें';

  @override
  String get legacyUi1bd54471c2 => 'वाहन की घटनाएँ खोजें...';

  @override
  String get legacyUiba537c59ae =>
      'वाहन, नंबर प्लेट, VIN, IMEI, SIM या उपयोगकर्ता खोजें…';

  @override
  String get legacyUi4a54a9e6db =>
      'वाहन, नंबर प्लेट, VIN, IMEI या SIM खोजें...';

  @override
  String get legacyUi5780b5d6bf => 'वाहन खोजें…';

  @override
  String get legacyUi50efae1b5f => 'वाहन नाम, नंबर प्लेट या प्लान से खोजें...';

  @override
  String get legacyUib09b43245d => 'वाहन खोजें…';

  @override
  String get legacyUif54fbca187 => 'खोजें';

  @override
  String get legacyUifaaee5e23e => 'SIM चुनें';

  @override
  String get legacyUi69cc521201 => 'देश चुनें';

  @override
  String get legacyUi400a58f1cc => 'इतिहास लोड करने के लिए अवधि चुनें।';

  @override
  String get legacyUie216b735f0 => 'पहले उपयोगकर्ता चुनें।';

  @override
  String get legacyUie965317576 => 'पहले वाहन चुनें।';

  @override
  String get legacyUia72bd23c12 =>
      'वाहन, रुकने की सीमा और तारीख व समय सीमा चुनें।';

  @override
  String get legacyUi29c9360313 => 'व्यवस्थापक चुनें';

  @override
  String get legacyUi8a152d2c3f => 'नवीनीकरण योग्य कम से कम एक वाहन चुनें';

  @override
  String get legacyUi5573da8514 => 'कम से कम एक वाहन चुनें';

  @override
  String get legacyUi42303635fc => 'शहर चुनें';

  @override
  String get legacyUi9915f6e5c2 => 'रंग चुनें';

  @override
  String get legacyUia96ce92893 => 'कमांड टेम्पलेट चुनें';

  @override
  String get legacyUi59ee76bad1 => 'देश चुनें';

  @override
  String get legacyUi74c388ab91 => 'दिनांक-समय रेंज चुनें';

  @override
  String get legacyUi46bfa11b12 => 'डिवाइस प्रकार चुनें';

  @override
  String get legacyUidba2e6bd04 => 'दस्तावेज़ प्रकार चुनें';

  @override
  String get legacyUi386f8ba9d0 => 'प्राथमिक उपयोगकर्ता चुनें';

  @override
  String get legacyUic7a9e8ea6a => 'प्रदाता चुनें';

  @override
  String get legacyUib350802ae1 => 'राज्य चुनें';

  @override
  String get legacyUi905d012288 => 'प्रकार चुनें';

  @override
  String get legacyUib8a1d9de7d => 'उपयोगकर्ता चुनें';

  @override
  String get legacyUie574e3a29d => 'एक ही प्लान मुद्रा वाले वाहन चुनें';

  @override
  String get legacyUi07f0f61db9 => 'चुनी गई फ़ाइल खाली है।';

  @override
  String get legacyUi9bc2575c39 => 'भेजें';

  @override
  String get legacyUi0ad7c21624 => 'कमांड? भेजें';

  @override
  String get legacyUi9b48248439 => 'इतिहास देखने के लिए कमांड भेजें।';

  @override
  String get legacyUi724aa54b02 => 'वाहन को कमांड भेजें?';

  @override
  String get legacyUic70a890d14 => 'संदेश भेजें';

  @override
  String get legacyUia89d641794 => 'अनुरोध भेजें';

  @override
  String get legacyUib8ec554332 => 'रीसेट लिंक भेजें';

  @override
  String get legacyUi1aba33d6c2 => 'परीक्षण भेजें';

  @override
  String get legacyUifc552c754d => 'परीक्षण ईमेल भेजें';

  @override
  String get legacyUi17b874d289 => 'प्रेषक';

  @override
  String get legacyUi679e8f61b9 => 'प्रेषक का नाम';

  @override
  String get legacyUi73dcba5635 => 'सेंसर इतिहास';

  @override
  String get legacyUia14460cfb3 => 'सेंसर इतिहास की अवधि';

  @override
  String get legacyUia9bc44292f => 'सेंसर की कार्रवाइयाँ';

  @override
  String get legacyUi18d80b838f => 'सेंसर हटाया गया';

  @override
  String get legacyUi711bf35988 => 'सेंसर';

  @override
  String get legacyUi48380dd0e2 => 'सेंसर उपलब्ध नहीं हैं';

  @override
  String get legacyUi35f49dcfbf => 'भेजा गया';

  @override
  String get legacyUi2d7bb03171 =>
      'भेजे गए कमांड और डिवाइस के जवाब यहाँ दिखाई देते हैं।';

  @override
  String get legacyUi1d5d1effa9 => 'सर्वर URL';

  @override
  String get legacyUif85e6f1bdc => 'सर्वर का सक्रिय समय';

  @override
  String get legacyUi10802e852c => 'सर्वर समय';

  @override
  String get legacyUi7ef53dd844 => 'सेवा की समाप्ति पंजीकरण के बाद होनी चाहिए।';

  @override
  String get legacyUi2ad34ef4cf => 'सेवा प्लान';

  @override
  String get legacyUi2bacd5f581 => 'सेवा शुरू होगी';

  @override
  String get legacyUiaa02a8d843 => 'इंजन घंटे सेट करें';

  @override
  String get legacyUi837c0d47b5 => 'ओडोमीटर सेट करें';

  @override
  String get legacyUiaef97bb06a => 'सेटिंग्स सेव हुआ।';

  @override
  String get legacyUi96a0dc481b => 'खरीदारी';

  @override
  String get legacyUi5e65ca08ed => 'समस्या का छोटा शीर्षक';

  @override
  String get legacyUi4c742d5133 => 'जियोफेंस दिखाएँ';

  @override
  String get legacyUi5abbf34ba3 => 'दिखाएं इतिहास';

  @override
  String get legacyUi8268618610 => 'चलते वाहनों के आसपास एनिमेटेड तरंग दिखाएँ';

  @override
  String get legacyUi25911d48e0 => 'और दिखाएँ';

  @override
  String get legacyUi50b47f1483 => 'रुचि के स्थानों के चिह्न दिखाएँ';

  @override
  String get legacyUib7f93469b9 => 'रूट का निशान दिखाएँ';

  @override
  String get legacyUi510904927e => 'दिखाएं वाहन नाम अगला को आइकन पर मैप';

  @override
  String get legacyUi6e61e47d5c =>
      'गहरे बैकग्राउंड पर दिखता है। PNG, JPG, SVG, WEBP। अधिकतम 5 MB।';

  @override
  String get legacyUi39e4052ecf =>
      'हल्के बैकग्राउंड पर दिखता है। PNG, JPG, SVG, WEBP। अधिकतम 5 MB।';

  @override
  String get legacyUi894bc414e6 => 'साइनअप';

  @override
  String get legacyUi69c2037890 => 'अंत छोड़ें';

  @override
  String get legacyUia8522e4c9d => 'शुरुआत छोड़ें';

  @override
  String get legacyUi33dcec9ce4 => 'धीमा';

  @override
  String get legacyUicf606d0913 => 'और धीमा';

  @override
  String get legacyUi339c1ea94b => 'सोशल लिंक';

  @override
  String get legacyUi3db7211438 => 'SIM कार्ड क्रमबद्ध करें';

  @override
  String get legacyUi66758a74bc => 'व्यवस्थापक क्रमबद्ध करें';

  @override
  String get legacyUi3655295cb4 => 'डिवाइस क्रमबद्ध करें';

  @override
  String get legacyUi3a21e72182 => 'ड्राइवर क्रमबद्ध करें';

  @override
  String get legacyUi1e891a0102 => 'टीम क्रमबद्ध करें';

  @override
  String get legacyUi6d1ba980e8 => 'उपयोगकर्ता क्रमबद्ध करें';

  @override
  String get legacyUi2512bda9e7 => 'वाहन क्रमबद्ध करें';

  @override
  String get legacyUi6da13addb0 => 'स्रोत';

  @override
  String get legacyUi6ace449732 => 'दक्षिण';

  @override
  String get legacyUi2d2cb022bc => 'गति';

  @override
  String get legacyUi8a14aeec13 => 'गति मल्टीप्लायर';

  @override
  String get legacyUid6a0aaa660 => 'गति में अंतर';

  @override
  String get legacyUi09a7707087 => 'मैन्युअल रूप से शुरू करें';

  @override
  String get legacyUi7e244fee11 =>
      'शुरू होने का समय समाप्ति से पहले होना चाहिए।';

  @override
  String get legacyUia725020675 => 'राज्य';

  @override
  String get legacyUi4e5c9805af => 'राज्य (वैकल्पिक)';

  @override
  String get legacyUic01247416e => 'राज्य आवश्यक है';

  @override
  String get legacyUiedde30a0b6 => 'स्थिति';

  @override
  String get legacyUia0539c7e7a => 'इस अवधि का स्थिति वितरण उपलब्ध नहीं है।';

  @override
  String get legacyUie4fe064446 => 'रुकने के मिनट';

  @override
  String get legacyUif32715a2f1 => 'रुकने का चिह्न';

  @override
  String get legacyUi5ca845e914 => 'सड़क, इमारत, क्षेत्र…';

  @override
  String get legacyUi4d08ec5874 => 'Stripe';

  @override
  String get legacyUi8de713bd12 => 'उप-उपयोगकर्ता';

  @override
  String get legacyUi97a0373212 => 'उप-उपयोगकर्ता बनाया गया।';

  @override
  String get legacyUi5cae4f427b => 'उप-उपयोगकर्ता हटाया गया';

  @override
  String get legacyUi2cc74ff5c3 => 'उप-उपयोगकर्ता का नाम';

  @override
  String get legacyUie44d50f72d => 'उप-उपयोगकर्ता अपडेट हुआ।';

  @override
  String get legacyUibd3159ff21 => 'विषय आवश्यक है।';

  @override
  String get legacyUi6844979e4f =>
      'विषय में कम से कम एक अक्षर या अंक होना चाहिए।';

  @override
  String get legacyUid6981f7476 => 'सदस्यता लें';

  @override
  String get legacyUia547aab586 => 'ईमेल अपडेट की सदस्यता ली गई';

  @override
  String get legacyUid7932a2917 => 'सफल';

  @override
  String get legacyUib879505819 => 'सहायता टिकट';

  @override
  String get legacyUi848eed0fbd => 'टैग';

  @override
  String get legacyUi8c7e01ee22 => 'टैग (कॉमा से अलग करें)';

  @override
  String get legacyUi1df356a49e =>
      'POI रखने के लिए मानचित्र पर टैप करें या निर्देशांक दर्ज करें।';

  @override
  String get legacyUi61ad50a9b9 => 'लक्ष्य';

  @override
  String get legacyUi78560d88ef => 'टीम सक्रिय हुई।';

  @override
  String get legacyUid8f82f6030 => 'टीम की गतिविधि';

  @override
  String get legacyUi8aef227384 => 'टीम निष्क्रिय हुई।';

  @override
  String get legacyUi72df525608 => 'टीम सदस्य बनाया गया।';

  @override
  String get legacyUi07fed9d9b3 => 'टीम सदस्य अपडेट हुआ।';

  @override
  String get legacyUi0194c31b6d => 'टीम की अनुमतियाँ अपडेट हुईं';

  @override
  String get legacyUi6730423d83 => 'टेलीमेट्री विवरण';

  @override
  String get legacyUieef4095d19 => 'टेलीमेट्री लॉग';

  @override
  String get legacyUif8d42e6122 => 'टेलीमेट्री की तारीख सीमा';

  @override
  String get legacyUi3ec1ae061c => 'टेम्पलेट';

  @override
  String get legacyUi7200f86ae5 => 'मोबाइल पुश का परीक्षण करें';

  @override
  String get legacyUi8b9bbdf230 => 'पुश का परीक्षण करें';

  @override
  String get legacyUi8135cd8fa3 =>
      'ग्राहक नया अनुरोध बना सकता है। किसी वाहन की सेवा अवधि नहीं बढ़ेगी।';

  @override
  String get legacyUidc46c2859b => 'लिंक अपने आप समाप्त हो जाता है।';

  @override
  String get legacyUic77eaa41ef => 'OpenVTS में इस व्यवस्थापक के अधीन संगठन।';

  @override
  String get legacyUi461197e42e => 'OpenVTS में इस उपयोगकर्ता का संगठन।';

  @override
  String get legacyUia491398fbb =>
      'सारांश के जवाब में अभी चार्ट बिंदु शामिल नहीं हैं।';

  @override
  String get legacyUi214cddfadb =>
      'सारांश के जवाब में अभी हाल के वाहन शामिल नहीं हैं।';

  @override
  String get legacyUi9e4a7b1c4c => 'अनुमति सूची उपलब्ध नहीं है। संपादन बंद है।';

  @override
  String get legacyUiac4a475bbb =>
      'सर्वर से असमर्थित अनुमति सूची मिली है। संपादन बंद है।';

  @override
  String get legacyUi8895c1d4b6 =>
      'अपलोड पूरा हुआ, लेकिन सर्वर ने नया प्रोफ़ाइल चित्र नहीं लौटाया।';

  @override
  String get legacyUidbc2f6bd85 => 'इस समय कोई अलर्ट उपलब्ध नहीं है।';

  @override
  String get legacyUi9b519b14b9 => 'इस दिन कोई घटना नहीं है';

  @override
  String get legacyUi354cfe028c =>
      'इन बदलावों से संपूर्ण पहुँच या हटाने की अनुमति मिलेगी। इस टीम सदस्य पर लागू करें?';

  @override
  String get legacyUi0f6cc3a89c => 'यह महीना';

  @override
  String get legacyUi77528c94d9 => 'यह वर्ष';

  @override
  String get legacyUi951f495b34 => 'यह कार्य पूर्ववत नहीं किया जा सकता।';

  @override
  String get legacyUi9b646010b8 => 'इस फ़ाइल प्रकार की अनुमति नहीं है।';

  @override
  String get legacyUi1b4785331d => 'यह महीना';

  @override
  String get legacyUi0e606e3993 =>
      'इस सहेजे गए डैशबोर्ड में अभी विजेट नहीं हैं।';

  @override
  String get legacyUi1e191e95f4 => 'यह टिकट बंद है।';

  @override
  String get legacyUi8866cb1e0a =>
      'वाहन पात्र होने पर खाते का एक क्रेडिट उपयोग होगा।';

  @override
  String get legacyUi7b72883e07 => 'यह सप्ताह';

  @override
  String get legacyUi261bd2f51b => 'टिकट की बातचीत';

  @override
  String get legacyUie1b858991f => 'टिकट बनाया गया।';

  @override
  String get legacyUi61322c9a86 => 'टिकट विवरण';

  @override
  String get legacyUif1e8e34245 => 'टिकट विवरण उपलब्ध नहीं है';

  @override
  String get legacyUiaa27494c39 => 'टिकट की स्थिति अपडेट हुई।';

  @override
  String get legacyUiedcd363083 => 'समय समाप्त';

  @override
  String get legacyUi768e0c1c69 => 'शीर्षक';

  @override
  String get legacyUie39bf0152d => 'आज की दूरी';

  @override
  String get legacyUif43482f042 => 'आज के इंजन घंटे';

  @override
  String get legacyUi7adacb5405 => 'स्थिति टॉगल करें';

  @override
  String get legacyUi6d91e0bb03 => 'सहनशीलता';

  @override
  String get legacyUid1bbcb6c01 => 'सहनशीलता (मीटर) *';

  @override
  String get legacyUi63cfb27f40 => 'शीर्ष ग्राहक';

  @override
  String get legacyUibc6debbc28 => 'शीर्ष प्रदर्शन वाली परिसंपत्तियाँ';

  @override
  String get legacyUib25928c699 => 'कुल';

  @override
  String get legacyUia672e7faed => 'कुल इंजन घंटे';

  @override
  String get legacyUie9511a6560 => 'कुल प्राप्त';

  @override
  String get legacyUia028fce203 => 'कुल उपयोगकर्ता';

  @override
  String get legacyUi5bcce6c936 => 'कुल वाहन';

  @override
  String get legacyUi7b777b27e0 => 'कुल इंजन घंटे';

  @override
  String get legacyUi8578188376 => 'कुल लॉग';

  @override
  String get legacyUi0538b10824 => 'ट्रैक लिंक QR';

  @override
  String get legacyUi070fb0b6ea => 'ट्रैक लिंक हटाया गया।';

  @override
  String get legacyUief1f899cb2 => 'लेन-देन विवरण';

  @override
  String get legacyUi06d8ffe653 => 'लेन-देन ID';

  @override
  String get legacyUi105b1510d9 =>
      'उपलब्ध होने पर लेनदेन गतिविधि यहाँ दिखाई देगी।';

  @override
  String get legacyUid016e453e5 => 'लेन-देन विवरण';

  @override
  String get legacyUiab39260fea => 'बदलाव';

  @override
  String get legacyUic10d76c9a4 => 'परिवहन';

  @override
  String get legacyUie82c27ca1d => 'यात्रा रद्द हुई';

  @override
  String get legacyUi4a9e77914e => 'दूसरा नाम या नंबर प्लेट आज़माएँ।';

  @override
  String get legacyUi4e653834fa => 'दूसरी खोज या फ़िल्टर आज़माएँ।';

  @override
  String get legacyUi39d6420eaa => 'दूसरे शब्दों से खोजें।';

  @override
  String get legacyUi0ba628a33e => 'दूसरे शब्दों से खोजें।';

  @override
  String get legacyUi10239b38b5 => 'मौजूदा फ़िल्टर या खोज बदलकर देखें।';

  @override
  String get legacyUi2253479cff => 'अपने फ़िल्टर बदलकर देखें।';

  @override
  String get legacyUie3f4c649b5 => 'दूसरा नाम या नंबर प्लेट आज़माएँ।';

  @override
  String get legacyUi10f570e880 => 'फ़िल्टर या खोज बदलकर देखें।';

  @override
  String get legacyUif28432df1f => 'फ़िल्टर बदलकर देखें।';

  @override
  String get legacyUi3c86b09439 => 'खोज या फ़िल्टर बदलकर देखें।';

  @override
  String get legacyUi0ba0bd18bf => 'खोज या स्थिति के फ़िल्टर हटाकर देखें।';

  @override
  String get legacyUi7a2fe508f6 =>
      'रीफ़्रेश करके देखें। समस्या बनी रहे तो शायद आपके खाते की सूचना प्राथमिकताएँ अभी तय नहीं हैं।';

  @override
  String get legacyUia0b470cb00 => 'Twitter / X';

  @override
  String get legacyUi8981df4d6a => 'Twitter/X';

  @override
  String get legacyUi3deb745651 => 'प्रकार';

  @override
  String get legacyUie298b0ec36 => 'प्रकार';

  @override
  String get legacyUi4b3072dd4e => 'कमांड पेलोड लिखें';

  @override
  String get legacyUi5712bb4ea1 => 'मैन्युअल रूप से लिखें';

  @override
  String get legacyUi968be8d576 => 'पासवर्ड नहीं बदला जा सका।';

  @override
  String get legacyUi1da33a6b30 => 'शहर लोड नहीं हो सके।';

  @override
  String get legacyUia4c5468d38 => 'कंपनी का विवरण लोड नहीं हो सका।';

  @override
  String get legacyUicbae41853b => 'फ़ॉर्म के विकल्प लोड नहीं हो सके।';

  @override
  String get legacyUid06763ac1a => 'राज्य लोड नहीं हो सके।';

  @override
  String get legacyUia471ebf750 => 'उपयोगकर्ता लोड नहीं हो सके।';

  @override
  String get legacyUibf0bc28bdb => 'वाहन लोड नहीं हो सके।';

  @override
  String get legacyUid73d7a7c96 => 'फ़ाइल नहीं खुल सकी।';

  @override
  String get legacyUi8ace6e9280 => 'चित्र चुनने का विकल्प नहीं खुल सका।';

  @override
  String get legacyUidcbaa0588e => 'इस वाहन का नेविगेशन नहीं खुल सका।';

  @override
  String get legacyUi14fdbab84b => 'यह अटैचमेंट नहीं खुल सका।';

  @override
  String get legacyUia457295e9f => 'चुना गया चित्र नहीं पढ़ा जा सका।';

  @override
  String get legacyUi9e97e5bfed => 'उपयोगकर्ता रीफ़्रेश नहीं हो सके।';

  @override
  String get legacyUi800f200671 => 'स्थिति अपडेट नहीं हो सकी।';

  @override
  String get legacyUice1c9c972b => 'टीम सदस्य की स्थिति अपडेट नहीं हो सकी।';

  @override
  String get legacyUib5f12c7d4f => 'टीम सदस्य अपडेट नहीं हो सका।';

  @override
  String get legacyUia046b8ac56 => 'सर्वर URL अपडेट नहीं हो सका।';

  @override
  String get legacyUi896bfd3a9a => 'अनअसाइन करें';

  @override
  String get legacyUi7be6acc7f8 => 'उपयोगकर्ता का असाइनमेंट हटाएँ?';

  @override
  String get legacyUi05027a8753 => 'उपयोगकर्ता का असाइनमेंट हटाएँ';

  @override
  String get legacyUi2d5a96092e => 'वाहन का असाइनमेंट हटाएँ';

  @override
  String get legacyUi39fc721248 => 'पहले जैसा करें';

  @override
  String get legacyUice77c2f42c => 'अद्वितीय कोड';

  @override
  String get legacyUif6b935ab33 => 'यूनिट';

  @override
  String get legacyUi07b032b56f => 'अपठित';

  @override
  String get legacyUi100cb4d890 => 'असमर्थित फ़ाइल प्रकार।';

  @override
  String get legacyUicb9925a338 =>
      'असमर्थित प्रारूप। PNG, JPG, JPEG या WEBP उपयोग करें।';

  @override
  String get legacyUi99974d3476 => 'असमर्थित विजेट';

  @override
  String get legacyUieb27a190c0 => 'असत्यापित';

  @override
  String get legacyUi61dcf34e70 => 'पासवर्ड अपडेट करें';

  @override
  String get legacyUieae1f5caf5 => 'स्थिति अपडेट करें';

  @override
  String get legacyUif2f8570ddd => 'अपडेट हुआ';

  @override
  String get legacyUi22714274a4 => 'अपडेट का समय';

  @override
  String get legacyUi8bdf057f91 => 'अपलोड';

  @override
  String get legacyUi9e2628eec4 => 'अपलोड दस्तावेज़';

  @override
  String get legacyUidcad7d982a => 'शुरू करने के लिए दस्तावेज़ अपलोड करें।';

  @override
  String get legacyUi73183a7050 => 'अपलोड दस्तावेज़';

  @override
  String get legacyUid714896782 => 'इस वाहन के दस्तावेज़ अपलोड करें।';

  @override
  String get legacyUi4b87ccd949 =>
      'लाइसेंस या पहचान प्रमाण जैसे ड्राइवर दस्तावेज़ अपलोड करें।';

  @override
  String get legacyUi6aafa80cab => 'सक्रिय रहने का समय';

  @override
  String get legacyUif1f71137de => 'मज़बूत और अलग पासवर्ड उपयोग करें';

  @override
  String get legacyUid81b6af542 => 'सभी उपयोग करें';

  @override
  String get legacyUi5895bc72eb =>
      'मुद्रा, समयक्षेत्र और रूटिंग जैसी क्षेत्रीय डिफ़ॉल्ट सेटिंग्स के लिए उपयोग होता है।';

  @override
  String get legacyUi81c9245d46 => 'उपयोगकर्ता टिकट';

  @override
  String get legacyUi81939432dd => 'उपयोगकर्ता की कार्रवाइयाँ';

  @override
  String get legacyUi0abfc13cb8 => 'उपयोगकर्ता असाइन हुआ।';

  @override
  String get legacyUi6188702f9e => 'उपयोगकर्ता बनाया और चुना गया';

  @override
  String get legacyUi0ba72d0bce => 'उपयोगकर्ता हटाया गया';

  @override
  String get legacyUi8fd72dd6f9 => 'उपयोगकर्ता आवश्यक है';

  @override
  String get legacyUi5ed13310cc => 'उपयोगकर्ता आवश्यक है।';

  @override
  String get legacyUib0b238b57a => 'उपयोगकर्ता की अनुमतियाँ अपडेट हुईं';

  @override
  String get legacyUia42cd2f9d5 => 'उपयोगकर्ता का असाइनमेंट हटाया गया।';

  @override
  String get legacyUi2355aced23 => 'उपयोगकर्ता अपडेट हुआ।';

  @override
  String get legacyUi84c29015de => 'उपयोगकर्ता नाम';

  @override
  String get legacyUib1974b83bc => 'उपयोगकर्ता नाम (वैकल्पिक)';

  @override
  String get legacyUi2c7ab350b3 => 'उपयोगकर्ता नाम या ईमेल';

  @override
  String get legacyUi73dbef356e => 'VIN (वैकल्पिक)';

  @override
  String get legacyUi39852971ee => 'VIN नंबर';

  @override
  String get legacyUia4aefa35c3 => 'मान्य:';

  @override
  String get legacyUi8dce170de2 => 'मान';

  @override
  String get legacyUi7bac966778 => 'वाहन / प्लान';

  @override
  String get legacyUi43188a5960 => 'वाहन की घटना का विवरण';

  @override
  String get legacyUi2d80c33ed3 => 'वाहन इवेंट';

  @override
  String get legacyUi4d461104bf => 'वाहन समाप्ति';

  @override
  String get legacyUi9e47ccbff4 =>
      'घटनाएँ लोड करने के लिए वाहन का IMEI आवश्यक है।';

  @override
  String get legacyUi2b51e72835 =>
      'सेंसर लोड करने के लिए वाहन का IMEI आवश्यक है।';

  @override
  String get legacyUief04c2235a =>
      'टेलीमेट्री लॉग लोड करने के लिए वाहन का IMEI आवश्यक है।';

  @override
  String get legacyUi62dc158d0e => 'वाहन लेबल';

  @override
  String get legacyUicb4e4154e4 => 'वाहन मेटा';

  @override
  String get legacyUi92dc53a1bc => 'वाहन नाम';

  @override
  String get legacyUi441399c250 => 'वाहन चयन';

  @override
  String get legacyUi2d6ca00998 => 'वाहन प्रकार';

  @override
  String get legacyUi5c931770ef => 'वाहन की कार्रवाइयाँ';

  @override
  String get legacyUi6ac26355c9 =>
      'वाहन की गतिविधि और सिस्टम लॉग यहाँ दिखाई देंगे।';

  @override
  String get legacyUi4e4942337f => 'वाहन और प्लान';

  @override
  String get legacyUi6ec60a25f7 => 'वाहन असाइन हुआ।';

  @override
  String get legacyUia31471cef9 =>
      'वाहन असाइनमेंट या वाहन के अपडेट यहाँ दिखाई देंगे।';

  @override
  String get legacyUib7975a2537 => 'वाहन हटाया गया';

  @override
  String get legacyUiff47117f38 => 'वाहन विवरण';

  @override
  String get legacyUia1fbfba50c => 'वाहन विवरण उपलब्ध नहीं है।';

  @override
  String get legacyUi79c500fa20 => 'वाहन की घटना की तारीख सीमा';

  @override
  String get legacyUie981db4fa0 => 'वाहन इवेंट होगा दिखाई दें यहां।';

  @override
  String get legacyUi7eefc642f4 => 'वाहन समूह';

  @override
  String get legacyUi5cd0230ee5 => 'वाहन ID नहीं है।';

  @override
  String get legacyUi39ea43c097 => 'वाहन पहचान नंबर';

  @override
  String get legacyUida83429197 => 'वाहन नाम';

  @override
  String get legacyUi750a5503ac => 'वाहन की स्थिति';

  @override
  String get legacyUi40a1e7dd80 => 'वाहन रिकॉर्ड उपलब्ध नहीं है।';

  @override
  String get legacyUi686853d97d => 'वाहन नवीनीकरण भुगतान जमा हुआ';

  @override
  String get legacyUie1071916e2 => 'वाहन का नवीनीकरण दर्ज हुआ।';

  @override
  String get legacyUibf31403ac2 => 'वाहन की पहुँच सीमा';

  @override
  String get legacyUi3c760a5151 => 'वाहन सेवा';

  @override
  String get legacyUi9aafada9ec =>
      'वाहन सेवा का संस्करण उपलब्ध नहीं है। संपादन से पहले दोबारा लोड करें।';

  @override
  String get legacyUia0d9ad9324 => 'वाहन सेवा अपडेट हुई';

  @override
  String get legacyUi97d4120359 => 'वाहन सेवाएँ';

  @override
  String get legacyUif9709ba7c4 =>
      'वाहन टेलीमेट्री से प्रगति अपने आप अपडेट होती है। केवल वर्तमान ठहराव को मैन्युअल रूप से पूरा किया जा सकता है।';

  @override
  String get legacyUi9644381920 => 'वाहन प्रकार';

  @override
  String get legacyUi8b26242493 => 'वाहन प्रकार का फ़िल्टर';

  @override
  String get legacyUi2a37343d0a => 'वाहन का असाइनमेंट हटाया गया।';

  @override
  String get legacyUif28657d034 => 'वाहन उपलब्ध नहीं है';

  @override
  String get legacyUi917981e400 => 'वाहन अपडेट हुआ।';

  @override
  String get legacyUi02236966b5 => 'प्रभावित वाहन';

  @override
  String get legacyUi776abb6631 => 'वाहन असाइन किया गया';

  @override
  String get legacyUi433457e28d => 'वाहन लोड नहीं हो सके।';

  @override
  String get legacyUi03128bed90 => 'सत्यापन';

  @override
  String get legacyUiaed3b8c6a7 => 'सत्यापित';

  @override
  String get legacyUidda6ac27b9 => 'सत्यापित करें';

  @override
  String get legacyUi69bd4ef9fb => 'देखें';

  @override
  String get legacyUi5b9306d29c => 'पेमेंट देखें';

  @override
  String get legacyUie3c9374cd6 => 'सभी यात्राएँ देखें';

  @override
  String get legacyUib1614cb4e6 => 'देखें/डाउनलोड करें';

  @override
  String get legacyUi1b6cc58781 => 'गंभीरता के अनुसार उल्लंघन';

  @override
  String get legacyUi1fe59390ac => 'दृश्यमान';

  @override
  String get legacyUi4fc5a421da => 'एडमिन को दिखाई दे';

  @override
  String get legacyUi1448afee1d => 'ड्राइवर को दिखाई देगा';

  @override
  String get legacyUib60862f485 => 'वॉलेट';

  @override
  String get legacyUic4fe2a7498 => 'वेब पुश';

  @override
  String get legacyUi2e8a57cc5c => 'वेबसाइट';

  @override
  String get legacyUib32233ad82 => 'वेबसाइट URL';

  @override
  String get legacyUica976c5dc6 => 'साप्ताहिक तुलना';

  @override
  String get legacyUidd322f2dc7 => 'पश्चिम';

  @override
  String get legacyUib336fc5587 => 'WhatsApp';

  @override
  String get legacyUi16ec75e229 =>
      'प्राप्तकर्ताओं के इनबॉक्स में दिखने वाला प्रेषक।';

  @override
  String get legacyUi682d44be54 => 'डिवाइस सहित';

  @override
  String get legacyUi0a58e1d0a2 => 'जवाब लिखें';

  @override
  String get legacyUi126cd2cd36 => 'जवाब लिखें...';

  @override
  String get legacyUib58c0082b4 => 'आपने सभी अपडेट देख लिए हैं।';

  @override
  String get legacyUi558865a16f => 'YouTube';

  @override
  String get legacyUid3639ca4df =>
      'आपके खाते को यह अनुभाग देखने की अनुमति नहीं है।';

  @override
  String get legacyUice100fe123 =>
      'आपके बदलाव खो जाएँगे। इस कार्रवाई को वापस नहीं लिया जा सकता।';

  @override
  String get legacyUi9b3cbed5c4 => 'ज़ूम';

  @override
  String get legacyUi4fc05f2763 => 'ज़ूम में';

  @override
  String get legacyUia4ae4b24a1 => 'ज़ूम समाप्त';

  @override
  String get legacyUib6958e3c52 => 'API कुंजी या उपयोगकर्ता नाम';

  @override
  String get legacyUib5f203a910 => 'cmdId';

  @override
  String get legacyUif05135d639 => 'बीमा, परमिट';

  @override
  String get legacyUid127ec8ef2 => 'jane@company.com';

  @override
  String get legacyUi216fb6179a => 'km/h, C, V';

  @override
  String get legacyUi7252f9e8d5 => 'पिछले 7 दिन';

  @override
  String get legacyUibbdead93fb => 'लाइसेंस, पहचान, परमिट';

  @override
  String get legacyUid7cb0327fd => 'लाइसेंस, बीमा';

  @override
  String get legacyUica62660225 => 'noreply@example.com';

  @override
  String get legacyUid043e53c7d => 'queueId';

  @override
  String get legacyUi11c8ce1244 => 'recipient@example.com';

  @override
  String get legacyUi4b329f8934 => 'गति, ईंधन';

  @override
  String get legacyUi65e012062c => 'support@example.com';

  @override
  String get legacyUi0bd41b4761 => 'यह महीना';

  @override
  String get legacyUie92d4d638a => 'सप्ताह / माह';

  @override
  String get legacyUia126722ec0 => 'ध्यान देना आवश्यक है';

  @override
  String get legacyUi51eab2420d => 'डिस्पैचर की कार्रवाइयाँ';

  @override
  String get legacyUi8bdea32153 => 'अभी कोई गतिविधि नहीं है।';

  @override
  String get legacyUi05e3a866c3 =>
      'शेड्यूल सहेजा गया, लेकिन कुछ यात्राएँ नहीं बनाई जा सकीं।';

  @override
  String get legacyUi2924d70976 => 'केवल तारीख';

  @override
  String get legacyUi63f39eeeb7 => 'निश्चित समय';

  @override
  String get legacyUi6930391c64 => 'समय अंतराल';

  @override
  String get legacyUi601d153162 => 'एकाधिक दिन';

  @override
  String get legacyUif61eadaf15 => 'प्रगति में';

  @override
  String get legacyUia1bf92eff4 => 'रद्द';

  @override
  String get legacyUic7dfb6f1d9 => 'रुका हुआ';

  @override
  String get legacyUi90303d8df2 => 'समाप्त';

  @override
  String get legacyUi59f1111618 => 'यात्रा पर';

  @override
  String get legacyUi2b613fb829 => 'कोई असाइनमेंट नहीं';

  @override
  String get legacyUib564001a58 => 'छूटा हुआ';

  @override
  String get legacyUi736d1eee8e => 'वाहन निष्क्रिय';

  @override
  String get legacyUif4330844fd => 'वाहन लाइसेंस द्वारा अवरुद्ध';

  @override
  String get legacyUiabf81c35d4 => 'ड्राइवर आवश्यक है';

  @override
  String get legacyUi2c9c1f7914 => 'उपलब्ध नहीं';

  @override
  String get legacyUi8e9f1d6e54 => 'शुरू नहीं हुआ';

  @override
  String get legacyUi4310ed540c => 'देरी से';

  @override
  String get legacyUiaccac60339 => 'ड्राइवर की समस्या';

  @override
  String get legacyUi6b535fa681 => 'कोई टेलीमेट्री नहीं';

  @override
  String get legacyUi38a9e21ed9 => 'रूट से विचलन';

  @override
  String get legacyUi1f5a1abf2f => 'पूरा';

  @override
  String get legacyUi5a436b7939 => 'टिप्पणी जोड़ें';

  @override
  String get legacyUi65c821a596 => 'लाइव';

  @override
  String get legacyUi189cc40c22 => 'पुराना डेटा';

  @override
  String get legacyUi41c8e43d9e => 'वाहन GPS';

  @override
  String get legacyUic1220e845b => 'फ़्लीट मैनेजर';

  @override
  String get legacyUi601f5ff70b => 'सिस्टम स्वचालन';

  @override
  String get legacyUi8b57ec8c92 => 'असाइनमेंट बनाया गया';

  @override
  String get legacyUi368e5b125f => 'असाइनमेंट स्वीकार किया गया';

  @override
  String get legacyUid00c8926f5 => 'यात्रा अपने आप शुरू हुई';

  @override
  String get legacyUic4b75c3924 => 'यात्रा अपने आप पूरी हुई';

  @override
  String get legacyUif98c835c4f => 'ड्राइवर ने यात्रा पूरी की';

  @override
  String get legacyUi4bb573b356 => 'ठहराव पर आगमन अपने आप दर्ज हुआ';

  @override
  String get legacyUi52cd528ad4 => 'ठहराव अपने आप पूरा हुआ';

  @override
  String get legacyUicf338ebe5c => 'ड्राइवर ने ठहराव पूरा किया';

  @override
  String get legacyUi7ef2940c95 => 'रूट से विचलन शुरू हुआ';

  @override
  String get legacyUi55d93aed45 => 'रूट से विचलन समाप्त हुआ';

  @override
  String get legacyUi654c568718 => 'टेलीमेट्री मिलना बंद हुआ';

  @override
  String get legacyUi66676d64b0 => 'टेलीमेट्री फिर मिलने लगी';

  @override
  String get legacyUi2a398797b5 => 'अधिक गति शुरू हुई';

  @override
  String get legacyUif7d315eb62 => 'अधिक गति समाप्त हुई';

  @override
  String get legacyUia22d66c857 => 'पहुँच गया';

  @override
  String get legacyUi5a000ad7bd => 'छोड़ा गया';

  @override
  String get legacyUi4028c0c8b4 => 'नहीं उपलब्ध';

  @override
  String get legacyUi5f174de1cc => 'प्रमाण';

  @override
  String get legacyUi4e91ee6122 => 'खाते का समयक्षेत्र';

  @override
  String get legacyUi4dda6a4505 => 'कुल यात्राएँ';

  @override
  String get legacyUi523baab918 => 'आगामी';

  @override
  String get legacyUicc6e7b6a29 => 'विलंबित';

  @override
  String get legacyUie9fab1cf3a => 'समय पर पूरी हुई यात्राएँ';

  @override
  String get legacyUibbb47a7157 => 'समय पर होने का प्रतिशत';

  @override
  String get legacyUi944b223791 => 'दूरी किमी में';

  @override
  String get legacyUi7c9352eed6 =>
      'मौजूदा SMTP कॉन्फ़िगरेशन से एक छोटा संदेश भेजा जाएगा।';

  @override
  String get legacyUid173234df0 =>
      'ACC का अर्थ वायर/ACC है। MOTION का अर्थ गति आधारित वैकल्पिक पहचान है।';

  @override
  String get legacyUi598ed2889b => 'पहुँच की अनुमतियाँ';

  @override
  String get legacyUi9a6d95b0c5 => 'सक्रिय खाता';

  @override
  String get legacyUi8d00c06a55 => 'गतिविधि, वाहन घटना और टेलीमेट्री लॉग';

  @override
  String get legacyUi61cc55aa04 => 'जोड़ें';

  @override
  String get legacyUiee01d7c402 => 'नया व्यवस्थापक जोड़ें';

  @override
  String get legacyUib9b1e23f27 => 'नया उपयोगकर्ता जोड़ें';

  @override
  String get legacyUif2f8674f8a => 'नया वाहन जोड़ें';

  @override
  String get legacyUi23a75918ab => 'उपयोग और वृद्धि';

  @override
  String get legacyUi80643ec204 => 'उन्नत सफ़ाई';

  @override
  String get legacyUicf963e5241 => 'उन्नत फ़िल्टर';

  @override
  String get legacyUi3aea7b29d9 =>
      'सार्वजनिक डेमो में उन्नत रिपोर्टिंग उपलब्ध नहीं है। फ़्लीट रिपोर्ट चलाने, पृष्ठ देखने, चार्ट बनाने और निर्यात करने के लिए OpenVTS खाते से साइन इन करें।';

  @override
  String get legacyUi056677c12f => 'गंभीरता के अनुसार अलर्ट';

  @override
  String get legacyUif89ae580e8 => 'सभी एक्टर';

  @override
  String get legacyUiaeae2d71be => 'सभी अलर्ट';

  @override
  String get legacyUic0e8e58c1a => 'सभी स्रोत';

  @override
  String get legacyUic1cbbe0c5d => 'अनुमत विचलन';

  @override
  String get legacyUi826499f6b1 => 'वार्षिक कवरेज और ग्राहक सेवा अलग-अलग हैं।';

  @override
  String get legacyUi40e69b5db3 => 'असाइन किया गया वाहन';

  @override
  String get legacyUi6771ade6e8 => 'अटैचमेंट';

  @override
  String get legacyUi52b258c824 =>
      'समस्या का संक्षिप्त विवरण दें और आवश्यक हो तो फ़ाइलें संलग्न करें।';

  @override
  String get legacyUi2f3b5c55bc => 'ब्राउज़ करें';

  @override
  String get legacyUi00189ab9b2 => 'CSV टेम्पलेट';

  @override
  String get legacyUi19db82215d =>
      'खाते की पहुँच सुरक्षित करने के लिए पासवर्ड बदलें।';

  @override
  String get legacyUi3f657f29e6 => 'नया पासवर्ड चुनें';

  @override
  String get legacyUicbd1538094 =>
      'वाहन, अधिक गति और जियोफेंस के अलर्ट आप तक कैसे पहुँचें, यह चुनें।';

  @override
  String get legacyUic7cd13c042 =>
      'इस उपयोगकर्ता के लिए उपलब्ध पृष्ठ और रिपोर्ट चुनें। बदलावों से उप-उपयोगकर्ताओं को दी जा सकने वाली पहुँच भी सीमित होगी।';

  @override
  String get legacyUibe10f5c042 =>
      'यह सदस्य क्या देख, संपादित और हटा सकता है, यह चुनें। निजी पहुँच उनके रिकॉर्ड पर और संपूर्ण पहुँच आपके पूरे खाते पर लागू होती है।';

  @override
  String get legacyUi7834f4a6f4 =>
      'इस सूचना समूह के अलर्ट कहाँ भेजे जाएँ, यह चुनें।';

  @override
  String get legacyUic23350ccde => 'कमांड विवरण';

  @override
  String get legacyUib2c253ba1c =>
      'नीचे के अनुभाग भरें। आवश्यक फ़ील्ड पर तारक (*) का चिह्न है।';

  @override
  String get legacyUia2b4ac96b2 =>
      'सेवा तारीख के अनुसार पूरी हुई यात्राएँ। आगामी असाइनमेंट यात्रा अनुभाग में उपलब्ध हैं।';

  @override
  String get legacyUib3feb31fcb => 'अपनी रिपोर्ट सेट करें';

  @override
  String get legacyUi878b163022 => 'सफ़ाई की पुष्टि करें';

  @override
  String get legacyUi9041d3c666 =>
      'वाहन असाइन कराने के लिए व्यवस्थापक से संपर्क करें।';

  @override
  String get legacyUi8e2fc0ffdc =>
      'नियंत्रित पहुँच वाली संक्षिप्त लॉगिन प्रोफ़ाइल बनाएँ।';

  @override
  String get legacyUi93c1ed632d =>
      'जियोफेंस, रुचि के स्थान और रूट बनाएँ तथा प्रबंधित करें।';

  @override
  String get legacyUie4781f0bde =>
      'परिचालन रूट कॉरिडोर बनाएँ और प्रबंधित करें।';

  @override
  String get legacyUi6571e94148 =>
      'वाहन की लाइव ट्रैकिंग के लिए सुरक्षित सार्वजनिक लिंक बनाएँ।';

  @override
  String get legacyUie09271eeb7 => 'बनाया गया:';

  @override
  String get legacyUidb0d2488de => 'वर्तमान असाइनमेंट';

  @override
  String get legacyUif8ece934c7 => 'दैनिक कुल दूरी';

  @override
  String get legacyUicb47dca7e3 => 'चुनी गई अवधि के दैनिक योग';

  @override
  String get legacyUi71d6e89bcc => 'दिन बनाम रात की ड्राइविंग';

  @override
  String get legacyUi2f3c38363d => 'POI हटाएं';

  @override
  String get legacyUi30c6c6352a => 'जियोफेंस हटाएं';

  @override
  String get legacyUic6f82fca90 => 'मार्ग हटाएं';

  @override
  String get legacyUie543c4fd0c => 'डेमो कार्यक्षेत्र • केवल देखने के लिए';

  @override
  String get legacyUi50dd7fb720 => 'डिवाइस कॉन्फ़िगरेशन';

  @override
  String get legacyUi0cf40756a6 => 'परिचालन सीमाएँ बनाएँ और प्रबंधित करें।';

  @override
  String get legacyUi243f6cfeec => 'चलाई गई दूरी (किमी)';

  @override
  String get legacyUie30d463652 => 'ड्राइवर विवरण उपलब्ध नहीं है।';

  @override
  String get legacyUi251b80c58c => 'ईमेल सदस्यता';

  @override
  String get legacyUibe482973b9 => 'SMTP चालू करें';

  @override
  String get legacyUi21685f000f => 'इस डिवाइस पर यह सत्र समाप्त करें।';

  @override
  String get legacyUide4f0c9387 => 'घटना फ़िल्टर';

  @override
  String get legacyUi6e74f5ccbd => 'प्रकार के अनुसार घटनाएँ';

  @override
  String get legacyUi74bbe75120 => 'जल्द समाप्त होगा';

  @override
  String get legacyUi8d00705083 => 'समाप्ति दिनांक';

  @override
  String get legacyUi0da7bfa1a0 => 'समाप्ति दिनांक (वैकल्पिक)';

  @override
  String get legacyUi86baf678e1 => 'असफल पंक्तियाँ';

  @override
  String get legacyUi2b1d93a2c6 => 'फ़िल्टर एक्टिविटी लॉग';

  @override
  String get legacyUi9a4184cef3 =>
      'व्यवस्थापक और तारीख सीमा के अनुसार फ़िल्टर करें।';

  @override
  String get legacyUi96e578211a => 'फ़िल्टर';

  @override
  String get legacyUi5360d40661 => 'फ़्लीट OS';

  @override
  String get legacyUi03d25e01e5 => 'खोज से बनाएँ';

  @override
  String get legacyUi4d8abbdc5d => 'रिपोर्ट बनाएँ';

  @override
  String get legacyUie16305f8b0 => 'बनाने में विफल';

  @override
  String get legacyUid81feb6ae1 => 'इतिहास प्राप्त करें';

  @override
  String get legacyUi6fa6308619 =>
      'असाइन किए गए वाहनों के विचलन पर सूचना पाएँ।';

  @override
  String get legacyUi4b6d6a3015 => 'महत्वपूर्ण';

  @override
  String get legacyUic5288872fd =>
      'निष्क्रिय रूट संग्रहित रहते हैं और दिखाई देते हैं।';

  @override
  String get legacyUi44caf74675 => 'इनबॉक्स';

  @override
  String get legacyUi3f33f2e865 =>
      'पूरा पथ शामिल करें, जैसे http://192.168.1.10:3000/api';

  @override
  String get legacyUi1919090902 => 'अंतिम लॉगिन';

  @override
  String get legacyUi1c747b4f98 => 'सर्वर की नवीनतम कार्रवाई';

  @override
  String get legacyUi9e1bba7129 => 'नवीनतम अवधि';

  @override
  String get legacyUi72da77c7b7 =>
      'इस वाहन के लाइव निर्देशांक उपलब्ध नहीं हैं।';

  @override
  String get legacyUi3e893cdfd5 => 'डिवाइस प्रकार और प्रदाता लोड हो रहे हैं...';

  @override
  String get legacyUi93fe7c05af => 'दस्तावेज़ प्रकार लोड हो रहा है…';

  @override
  String get legacyUi75e940ee30 => 'इतिहास लोड हो रहा है';

  @override
  String get legacyUi59c3981787 => 'इतिहास लोड हो रहा है...';

  @override
  String get legacyUibbe4cbd55c => 'प्रोफाइल लोड हो रहा है…';

  @override
  String get legacyUica88017dfa => 'सदस्यता स्थिति लोड हो रही है...';

  @override
  String get legacyUid1ccf4c3e4 => 'वाहन लोड हो रहा है…';

  @override
  String get legacyUif4e14815b1 => 'व्यवस्थापक के रूप में लॉगिन करें';

  @override
  String get legacyUi353bd1ef01 => 'श्रेणी के अनुसार लॉग';

  @override
  String get legacyUib2af2f11de => 'स्तर के अनुसार लॉग';

  @override
  String get legacyUi8c97e4f07d =>
      'अपने फ़्लीट से जुड़े ड्राइवर और उप-उपयोगकर्ता प्रबंधित करें।';

  @override
  String get legacyUi41948edc3a =>
      'ड्राइवर, असाइनमेंट, दस्तावेज़ और गतिविधि प्रबंधित करें।';

  @override
  String get legacyUi93b23afae0 =>
      'महत्वपूर्ण स्थान और परिचालन बिंदु प्रबंधित करें।';

  @override
  String get legacyUi68669149c0 =>
      'उप-उपयोगकर्ता और वाहन की पहुँच प्रबंधित करें।';

  @override
  String get legacyUi9fcd87c64d =>
      'सदस्यता के मूल्य निर्धारण प्लान प्रबंधित करें।';

  @override
  String get legacyUi274ef56d8e =>
      'प्रबंधित करें लेन-देन और वाहन रिन्यू करें सब्सक्रिप्शन';

  @override
  String get legacyUiff92dafaaf =>
      'उपयोगकर्ता, लॉगिन पहुँच, संपर्क और असाइन किए गए वाहन प्रबंधित करें।';

  @override
  String get legacyUib42578bf99 =>
      'मैन्युअल भुगतान सफलतापूर्वक जमा होने पर लेनदेन और विश्लेषण अपडेट होते हैं।';

  @override
  String get legacyUi421878a774 => 'मानचित्र डेटा © Google';

  @override
  String get legacyUi2cf55e0f5b => 'मानचित्र विवरण';

  @override
  String get legacyUi9a3aa11de5 => 'मानचित्र प्रकार';

  @override
  String get legacyUi09d3670056 =>
      'अधिकतम 10 MB। प्रतिबंधित: exe, js, html, htm।';

  @override
  String get legacyUife0c6bc7dd => 'मोबाइल पुश निदान';

  @override
  String get legacyUif6f444180f =>
      'सक्रिय समय, निर्भरताएँ और सुरक्षित सेवा कार्रवाइयाँ देखें';

  @override
  String get legacyUi1a63cbf994 => '+ नया लिंक';

  @override
  String get legacyUia40ad15529 => 'नया सहायता टिकट';

  @override
  String get legacyUi9f2d2d7331 => 'USER दस्तावेज़ प्रकार सेट नहीं हैं।';

  @override
  String get legacyUi9ec5ec0752 =>
      'कोई सक्रिय जियोफेंस नहीं — सभी जियोफेंस शामिल हैं।';

  @override
  String get legacyUi0a181de203 =>
      'व्यवस्थापक उपलब्ध नहीं हैं। रीफ़्रेश करने के लिए नीचे खींचें और फिर प्रयास करें।';

  @override
  String get legacyUi43f32b9b9d => 'संपर्क जानकारी नहीं है';

  @override
  String get legacyUie55a0728f0 => 'पूर्वावलोकन के लिए जियोफेंस नहीं हैं';

  @override
  String get legacyUi115fe0fac7 => 'कोई समूह नहीं मिला';

  @override
  String get legacyUida501f43fd => 'अभी वृद्धि का डेटा नहीं है';

  @override
  String get legacyUi454fe267a7 => 'मेटाडेटा नहीं है';

  @override
  String get legacyUi2540cc1f1a => 'कोई लंबित नवीनीकरण अनुरोध नहीं है।';

  @override
  String get legacyUi7cd1d44b3c => 'कोई रिकॉर्ड नहीं मिला।';

  @override
  String get legacyUi658e79f9dc => 'कोई परिणाम नहीं मिला';

  @override
  String get legacyUif018f94f6e =>
      'चुने गए रिपोर्ट फ़िल्टर से कोई पंक्ति मेल नहीं खाती।';

  @override
  String get legacyUibddbb17fc4 => 'कोई चयन नहीं = सभी';

  @override
  String get legacyUi9aba7bbe44 => 'कोई चयन नहीं = सभी जियोफेंस।';

  @override
  String get legacyUifd548f1c32 => 'इस वाहन के सेंसर सेट नहीं हैं।';

  @override
  String get legacyUi162d1ddec0 => 'टीम की कोई गतिविधि नहीं मिली।';

  @override
  String get legacyUi8f91f15684 => 'मान्य GPS स्थान नहीं है';

  @override
  String get legacyUi74ac3b3d0d => 'कोई वाहन असाइन नहीं है।';

  @override
  String get legacyUia26d9edac3 => 'आपके खाते को कोई वाहन असाइन नहीं है';

  @override
  String get legacyUie4b1dbf423 => 'कोई वाहन नहीं मिला';

  @override
  String get legacyUi6eef664840 => 'कोई नहीं';

  @override
  String get legacyUif8ae6c8bbe => 'स्वीकार नहीं किया गया';

  @override
  String get legacyUia92e15bc0a => 'नोटिफिकेशन प्राथमिकताएं';

  @override
  String get legacyUic71ffe5d22 => 'सूचनाओं के बीच अंतराल';

  @override
  String get legacyUicb88cbc310 => 'वाहन के रूट छोड़ने पर सूचित करें';

  @override
  String get legacyUi0049196b0b => '10 मीटर खिसकाएँ';

  @override
  String get legacyUia49d76ddc1 => 'एक वाहन';

  @override
  String get legacyUi0080aaa977 => 'Open VTS';

  @override
  String get legacyUi032a6dcfd8 =>
      'पूरी बातचीत देखने के लिए सहायता टिकट खोलें।';

  @override
  String get legacyUi50f8c47b2b => 'नेविगेशन में खोलें';

  @override
  String get legacyUi89202c7fd8 => 'अन्य दस्तावेज़';

  @override
  String get legacyUi27b4bf6d1b =>
      'सक्रिय होने पर भेजे जाने वाले ईमेल इस सर्वर का उपयोग करते हैं।';

  @override
  String get legacyUi619d7adc2c => 'भुगतान तुरंत लेनदेन सूची में दिखाई देगा।';

  @override
  String get legacyUidc32a816e9 =>
      'संरक्षण अवधि से पुराने ऐतिहासिक रिकॉर्ड स्थायी रूप से हटाएँ।';

  @override
  String get legacyUic2ff2762ca => 'कृपया फाइल चुनें';

  @override
  String get legacyUi3585d74456 => 'मौजूदा समाप्ति रखें';

  @override
  String get legacyUia9a96ec019 => 'प्राथमिक';

  @override
  String get legacyUi668c4636aa => 'डिलीवरी का प्रमाण';

  @override
  String get legacyUif702b26481 => 'लेनदेन संख्या के अनुसार क्रम';

  @override
  String get legacyUid03c65244f => 'प्लान से दोबारा गणना करें';

  @override
  String get legacyUi72d5617f3f => 'हाल की गतिविधि';

  @override
  String get legacyUi255e5788a2 => 'अपना खाता पुनर्प्राप्त करें';

  @override
  String get legacyUi505dddc915 => 'रीफ्रेश हो रहा…';

  @override
  String get legacyUi54dd5046d0 =>
      'रीफ़्रेश करने से सूचनाओं के आपके अनसहेजे बदलाव हट जाएँगे और सर्वर की नवीनतम सेटिंग्स आ जाएँगी।';

  @override
  String get legacyUi199ed09ba9 => 'रिपोर्ट की पहुँच';

  @override
  String get legacyUibd7b4f006d => 'समस्या की रिपोर्ट करें';

  @override
  String get legacyUi8115c55b47 => 'डेमो मोड में रिपोर्ट प्रतिबंधित हैं';

  @override
  String get legacyUi6b5890ba0b =>
      'ईमेल और WhatsApp नंबर सत्यापित करने के लिए OTP माँगें और उसकी पुष्टि करें।';

  @override
  String get legacyUif7194e6a0d => 'अनुरोध';

  @override
  String get legacyUif25bbab45d => 'राजस्व का पूर्वानुमान';

  @override
  String get legacyUiec40affa3e => 'राजस्व का रुझान';

  @override
  String get legacyUic53c3605a0 =>
      'ग्राहक नवीनीकरण अनुरोध देखें। केवल ऐप के बाहर वास्तव में प्राप्त भुगतान की पुष्टि करें।';

  @override
  String get legacyUiffbfe1e822 => 'रूट के ठहराव';

  @override
  String get legacyUi50eec1a359 => 'चलाने का परिणाम';

  @override
  String get legacyUi339225895f =>
      'सफ़ाई चलाने से डेटा स्थायी रूप से हटता है। पहले पूर्वावलोकन अवश्य देखें।';

  @override
  String get legacyUifee1dff0c6 => 'चालू बनाम बंद';

  @override
  String get legacyUi0fb59422f6 => 'नमूने';

  @override
  String get legacyUide6472b8d3 => 'दिनांक सीमा चुनें';

  @override
  String get legacyUia35cfe395a => 'समूह चुनें';

  @override
  String get legacyUi2564e1a2c5 => 'सेंसर चुनें';

  @override
  String get legacyUifea7a520f3 => 'वाहन चुनें';

  @override
  String get legacyUi70037936c0 => 'टिकट चुनें';

  @override
  String get legacyUieeaf903bb8 => 'पहले वाहन चुनें।';

  @override
  String get legacyUiad7a8a1750 =>
      'व्यवस्थापक चुनें, समस्या बताएँ और आवश्यक हो तो फ़ाइलें संलग्न करें।';

  @override
  String get legacyUi9bb7b69035 => 'कम से कम एक राज्य चुनें';

  @override
  String get legacyUifcfe92e583 => 'डैशबोर्ड चुनें';

  @override
  String get legacyUif9f50c1c30 =>
      'वाहन, तारीख सीमा और फ़िल्टर चुनें, फिर परिणाम देखने के लिए रिपोर्ट बनाएँ।';

  @override
  String get legacyUi0e40d8b0bf => 'चुने गए वाहन';

  @override
  String get legacyUi43e146fb62 => 'सर्वर की स्थिति की निगरानी';

  @override
  String get legacyUi644899c565 =>
      'सेवा की समाप्ति से लाइव ट्रैकिंग नियंत्रित होती है। नवीनीकरण के लिए व्यवस्थापक से संपर्क करें। भुगतान की पुष्टि तक नवीनीकरण अनुरोध से सेवा नहीं बढ़ती।';

  @override
  String get legacyUi5cbd584046 => 'सेवा';

  @override
  String get legacyUi758d7f7281 => 'सक्रिय सेट करें';

  @override
  String get legacyUi7c9275ee4b => 'निष्क्रिय सेट करें';

  @override
  String get legacyUiddbe3ed1a3 => 'कस्टम समाप्ति सेट करें';

  @override
  String get legacyUi7b53693e94 => 'ट्रैक लिंक साझा करें';

  @override
  String get legacyUidc1649a16c => 'साइन आउट करें';

  @override
  String get legacyUi2f32be1dc7 => 'हस्ताक्षर';

  @override
  String get legacyUi51070e69d1 => 'स्थल का चित्र';

  @override
  String get legacyUi93773568cf => 'गति सीमा';

  @override
  String get legacyUicb672694bb => 'राज्य फ़िल्टर';

  @override
  String get legacyUi511404ce3b => 'स्थिति वितरण';

  @override
  String get legacyUie54e98e0cb => 'ठहराव';

  @override
  String get legacyUie48d04b2b6 =>
      'Frontend/Backend/Listener बंद करने से ऐप की पहुँच खो सकती है। इस पृष्ठ से इन सेवाओं को शुरू और फिर शुरू किया जा सकता है, लेकिन बंद करना निष्क्रिय है।';

  @override
  String get legacyUi16b45ef102 => 'सफल, लंबित और असफल का अनुपात';

  @override
  String get legacyUi12b71c3e0f => 'सारांश';

  @override
  String get legacyUied9177cab1 => 'सिस्टम के आँकड़े';

  @override
  String get legacyUie20a879f45 =>
      'जियोफेंस सूचनाएँ संपादित करने के लिए टैप करें';

  @override
  String get legacyUiac8b906fca => 'लक्षित वाहन';

  @override
  String get legacyUib644561145 => 'टेलीमेट्री लॉग';

  @override
  String get legacyUi7840676a23 => 'टेलीमेट्री लॉग';

  @override
  String get legacyUi4ee3736ca6 =>
      'इस कार्रवाई को वापस नहीं लिया जा सकता। ड्राइवर और संबंधित असाइनमेंट हटा दिए जाएँगे।';

  @override
  String get legacyUi3575c0aec8 =>
      'इस कार्रवाई से उप-उपयोगकर्ता स्थायी रूप से हटेगा और वाहन की पहुँच रद्द होगी। इसे वापस नहीं लिया जा सकता।';

  @override
  String get legacyUi7f3d98b829 =>
      'ID नहीं होने के कारण यह लिंक हटाया नहीं जा सकता।';

  @override
  String get legacyUi4e81e87c37 =>
      'इससे संरक्षण अवधि से पुराना डेटा स्थायी रूप से हटता है। इसे वापस नहीं लिया जा सकता।';

  @override
  String get legacyUid8b029df5c =>
      'यह सार्वजनिक ट्रैकिंग लिंक तुरंत काम करना बंद कर देगा। इस कार्रवाई को वापस नहीं लिया जा सकता।';

  @override
  String get legacyUida735ce16c =>
      'यह रिपोर्ट आपके खाते के लिए उपलब्ध नहीं है।';

  @override
  String get legacyUidf3e8a5fdd =>
      'यह टिकट बंद या हल हो चुका है। जवाब भेजना बंद है।';

  @override
  String get legacyUif9c732c3c6 =>
      'यह टिकट बंद है। बैकएंड के व्यवहार के अनुसार जवाब देने पर यह दोबारा खुल सकता है या प्रगति में जा सकता है।';

  @override
  String get legacyUif3a8370f38 => 'कुल राजस्व';

  @override
  String get legacyUie273941b29 => 'मुद्रा के अनुसार योग';

  @override
  String get legacyUiaa7d3d7dd9 => 'लेनदेन इतिहास';

  @override
  String get legacyUib174443b0e => 'लेनदेन और राजस्व';

  @override
  String get legacyUi9dda9aa776 => 'यात्रा';

  @override
  String get legacyUic948ed8076 => 'यात्रा के प्रमाण';

  @override
  String get legacyUid67a44f68d => 'फ़िल्टर या तारीख सीमा बदलकर देखें।';

  @override
  String get legacyUi078f02fe7b => 'दस्तावेज़ लोड नहीं हो सके';

  @override
  String get legacyUi3b37311cd6 => 'इतिहास लोड नहीं हो सका';

  @override
  String get legacyUicaa5bd27e5 => 'लॉग लोड नहीं हो सके';

  @override
  String get legacyUi92078d350e => 'भुगतान लोड नहीं हो सके';

  @override
  String get legacyUi5db77ece1a => 'प्रोफ़ाइल लोड नहीं हो सकी';

  @override
  String get legacyUi081863e321 => 'टिकट लोड नहीं हो सके';

  @override
  String get legacyUi11f14b7638 => 'कंपनी की पहचान और सोशल लिंक अपडेट करें।';

  @override
  String get legacyUieb58c61a89 =>
      'व्यक्तिगत और पते के विवरण अपडेट करें। पुष्टि करने पर ही बदलाव सहेजे जाते हैं।';

  @override
  String get legacyUid19cf73ae1 => 'अपडेट हुआ';

  @override
  String get legacyUi9db8e8ec0b =>
      'लाइव मानचित्र की वाहन सूची का उपयोग करें, फिर रुकने की सीमा और तारीख व समय सीमा चुनें।';

  @override
  String get legacyUid337d1a0d6 => 'वैरिएबल पूर्वावलोकन';

  @override
  String get legacyUi63dfad55e0 => 'वाहन जानकारी';

  @override
  String get legacyUi7f4567c8c2 => 'वाहन लाइव स्थिति';

  @override
  String get legacyUiceedc505bd => 'वाहन स्थिति';

  @override
  String get legacyUi1f41948d84 => 'वाहन की घटना';

  @override
  String get legacyUid3aee04e65 => 'वाहन-जियोफेंस मैट्रिक्स';

  @override
  String get legacyUiefd8355920 => 'सभी देखें';

  @override
  String get legacyUi50ad3280e1 => 'वाहन देखें';

  @override
  String get legacyUi2c3c7c93f8 =>
      'भुगतान, क्रेडिट, डेबिट और बिलिंग रिकॉर्ड देखें।';

  @override
  String get legacyUi7d9ff4f0de => 'दृश्यता';

  @override
  String get legacyUi79c6a6033a => 'एडमिन को दिखाई दे';

  @override
  String get legacyUied0069155f => 'उपयोगकर्ता को दिखाई देगा';

  @override
  String get legacyUia56d85fb20 =>
      'वेब ब्राउज़र में सर्वर को क्रॉस-ओरिजिन अनुरोध (CORS) की अनुमति देनी होती है। कनेक्शन त्रुटि से लॉगिन विफल हो तो अपने सर्वर पर CORS चालू करें।';

  @override
  String get legacyUi4dd079044f => 'पूरी यात्रा';

  @override
  String get legacyUi4515b6c7b7 => 'आपका दिन';

  @override
  String get legacyUi50f19ac0b4 =>
      'आपके दस्तावेज़ और फ़्लीट मैनेजर द्वारा साझा दस्तावेज़।';

  @override
  String get legacyUi4e697d55ce => 'सॉफ़्टवेयर मालिक के साथ आपके लेनदेन।';

  @override
  String get legacyUi678830983a => '— दिखाने के लिए पेलोड छोटा किया गया —';

  @override
  String legacyUi1e22f79cd9(Object value1) {
    return '$value1 लोड हो रहा है';
  }

  @override
  String legacyUi57fdb35e30(Object value1) {
    return '$value1 उपलब्ध नहीं है';
  }

  @override
  String legacyUi1fd3e5084a(Object value1) {
    return 'कोई $value1 नहीं मिला';
  }

  @override
  String get legacyUie16f97dcfd => 'इतिहास साफ़ करें';

  @override
  String legacyUiabd4cd39b9(Object value1) {
    return '$value1 बिंदु';
  }

  @override
  String legacyUi90eaac7e8b(Object value1) {
    return '$value1 ठहराव';
  }

  @override
  String legacyUi865d65baea(Object value1) {
    return '$value1 अधिक गति';
  }

  @override
  String legacyUi7326be7e87(Object value1, Object value2) {
    return 'अधिकतम $value1 $value2';
  }

  @override
  String legacyUi5fd7f54937(Object value1, Object value2) {
    return 'औसत $value1 $value2';
  }

  @override
  String legacyUi5f2ee53a4c(Object value1) {
    return '$value1 चालू';
  }

  @override
  String legacyUi5c24a04874(Object value1) {
    return '$value1 बंद';
  }

  @override
  String legacyUi2b4b82c8bb(Object value1) {
    return 'अवधि: $value1';
  }

  @override
  String legacyUi27a82a7136(Object value1) {
    return '$value1 ड्राइविंग';
  }

  @override
  String legacyUi92edf7854b(Object value1) {
    return '$value1 वाहन';
  }

  @override
  String get legacyUi5d12bd5355 => 'चलाएँ';

  @override
  String get legacyUi4e39567064 => 'नोट (वैकल्पिक)';

  @override
  String get legacyUi932fc13e7f => 'शीर्षक (वैकल्पिक)';

  @override
  String legacyUi2c904359f5(Object value1) {
    return 'फ़ाइल $value1 MB की सीमा से बड़ी है';
  }

  @override
  String legacyUi66db457b99(Object value1) {
    return 'असमर्थित प्रारूप। अनुमत: $value1';
  }

  @override
  String get legacyUia7cf7b25a7 => 'बदलें';

  @override
  String legacyUidf1d5f2730(Object value1) {
    return 'टेस्ट ईमेल भेजा गया को $value1।';
  }

  @override
  String get legacyUi044b852f30 => 'पासवर्ड दिखाएँ';

  @override
  String get legacyUie40123b4e7 => 'पासवर्ड छिपाएँ';

  @override
  String get legacyUi82f47c3d4d => 'ईमेल सत्यापित';

  @override
  String get legacyUib1a273086c => 'WhatsApp सत्यापित है';

  @override
  String legacyUi908e5c8ce5(Object value1) {
    return '$value1 से लॉगआउट हुआ';
  }

  @override
  String get legacyUi33ce417454 => 'लोड हो रहा है…';

  @override
  String get legacyUi71ae0ec96e => 'लोड नहीं हुआ — फिर प्रयास करें';

  @override
  String get legacyUi67c4d0506a => 'लागू नहीं';

  @override
  String get legacyUia0b1fb2afb => 'पुष्टि पासवर्ड दिखाएँ';

  @override
  String get legacyUie2196c3942 => 'पुष्टि पासवर्ड छिपाएँ';

  @override
  String get legacyUi7c073937c6 => 'आपके ईमेल पर OTP भेजा गया';

  @override
  String get legacyUi8532209c49 => 'WhatsApp से OTP भेजा गया';

  @override
  String get legacyUi0d455a4e26 => 'ईमेल सत्यापित करें';

  @override
  String get legacyUi9cb68a6dd3 => 'WhatsApp सत्यापित करें';

  @override
  String legacyUi8cf58d99c1(Object value1) {
    return 'से: $value1';
  }

  @override
  String legacyUif41a1a65a6(Object value1) {
    return 'प्रति: $value1';
  }

  @override
  String legacyUia801634da8(Object value1) {
    return '$value1 हटाया गया।';
  }

  @override
  String legacyUi73f15343e6(Object value1) {
    return '$value1 के रूप में साइन इन है।';
  }

  @override
  String get legacyUi48138f08cd => 'व्यवस्थापक निष्क्रिय करें';

  @override
  String get legacyUif9494a277e => 'व्यवस्थापक सक्रिय करें';

  @override
  String get legacyUi13a84a7390 => 'व्यवस्थापक सक्रिय हुआ।';

  @override
  String get legacyUi8181bbb7c7 => 'व्यवस्थापक निष्क्रिय हुआ।';

  @override
  String get legacyUid65ded9428 => 'निष्क्रिय करें';

  @override
  String get legacyUi92ef08325a => 'सक्रिय करें';

  @override
  String get legacyUiacfd05ab80 => 'ईमेल असत्यापित है';

  @override
  String get legacyUi23c9dd8809 => 'वाहन लोड नहीं हुए। फिर प्रयास करें।';

  @override
  String legacyUib089c07088(Object value1) {
    return 'GMT $value1';
  }

  @override
  String legacyUi73585fdb6f(Object value1) {
    return '$value1 को जोड़ा गया';
  }

  @override
  String get legacyUi410bebb5ea => 'दस्तावेज़ लोड नहीं हुए। फिर प्रयास करें।';

  @override
  String get legacyUi7f10270c45 =>
      'दस्तावेज़ प्रकार लोड नहीं हुए। फिर प्रयास करें।';

  @override
  String get legacyUid4c2792a72 => 'छिपा हुआ';

  @override
  String get legacyUi1b7cd8a9bf => 'दस्तावेज़ अपडेट हुआ।';

  @override
  String get legacyUi895a77b095 => 'दस्तावेज़ अपलोड किया गया।';

  @override
  String get legacyUief6604a13d => 'दस्तावेज़ संपादित करें';

  @override
  String get legacyUif6769b696e => 'क्रेडिट जोड़े गए।';

  @override
  String get legacyUib16dd3b790 => 'क्रेडिट घटाए गए';

  @override
  String get legacyUie890b12b34 => 'आपके फ़िल्टर से कोई लेनदेन मेल नहीं खाता';

  @override
  String get legacyUib71113c83a =>
      'इस व्यवस्थापक का भुगतान नहीं मिला। फ़िल्टर हटाकर देखें।';

  @override
  String get legacyUi472af48c6d =>
      'शुरू करने के लिए मैन्युअल भुगतान दर्ज करें।';

  @override
  String legacyUi46f7e02bd0(Object value1) {
    return '$value1 कॉपी हुआ';
  }

  @override
  String legacyUi70d9eead51(Object value1) {
    return 'विषय $value1 अक्षर या उससे कम होना चाहिए।';
  }

  @override
  String legacyUifee6584f1b(Object value1) {
    return 'विवरण $value1 अक्षर या उससे कम होना चाहिए।';
  }

  @override
  String legacyUi830e676993(Object value1) {
    return 'आप अधिकतम $value1 फ़ाइलें अपलोड कर सकते हैं।';
  }

  @override
  String legacyUi4e5f407ec5(Object value1) {
    return 'प्रतिबंधित फ़ाइल हटाई गई: $value1';
  }

  @override
  String legacyUib5d0b873d0(Object value1) {
    return 'असमर्थित फ़ाइल हटाई गई: $value1';
  }

  @override
  String legacyUid1740cec1d(Object value1) {
    return 'फ़ाइल 5 MB से बड़ी है: $value1';
  }

  @override
  String legacyUie33e0ec27a(Object value1) {
    return 'जवाब $value1 अक्षर या उससे कम होना चाहिए।';
  }

  @override
  String legacyUid9e484645b(Object value1) {
    return 'टिकट की स्थिति पहले से $value1 है।';
  }

  @override
  String legacyUiebbf66ef0e(Object value1, Object value2) {
    return 'प्रेषक: $value1$value2';
  }

  @override
  String legacyUi94cf932307(Object value1) {
    return 'बनाया गया $value1';
  }

  @override
  String legacyUib5ae5701b9(Object value1) {
    return 'अपडेट हुआ $value1';
  }

  @override
  String legacyUi1a150ff203(Object value1) {
    return 'बंद हुआ $value1';
  }

  @override
  String get legacyUiec6952e09b => 'अपडेट हो रहा..।';

  @override
  String legacyUi190040d9d3(Object value1) {
    return 'कुछ फ़ाइलें 5 MB से बड़ी थीं और हटा दी गईं$value1।';
  }

  @override
  String legacyUi2a432bdd06(Object value1) {
    return 'स्थानीय एजेंट: $value1';
  }

  @override
  String get legacyUi3adb8e50db => 'शुरू करने के लिए टीम सदस्य बनाएँ।';

  @override
  String legacyUiabad5c010f(Object value1) {
    return '$value1 · अनुमतियाँ';
  }

  @override
  String get legacyUifb91e24fa5 => 'अपडेट';

  @override
  String get legacyUia9d4f0d3b6 => 'अनुमतियाँ अपडेट नहीं हो सकीं';

  @override
  String get legacyUi918bffea2f => 'मौजूदा पासवर्ड दिखाएँ';

  @override
  String get legacyUifa0245c379 => 'मौजूदा पासवर्ड छिपाएँ';

  @override
  String get legacyUi9a569782b5 => 'नया पासवर्ड दिखाएँ';

  @override
  String get legacyUiaa10918381 => 'नया पासवर्ड छिपाएँ';

  @override
  String get legacyUi39b0c83afa => 'नए पासवर्ड की पुष्टि दिखाएँ';

  @override
  String get legacyUiea6f8ea221 => 'नए पासवर्ड की पुष्टि छिपाएँ';

  @override
  String legacyUie30362677c(Object value1) {
    return '$value1 पंजीकृत';
  }

  @override
  String legacyUi060250e9ba(Object value1) {
    return '$value1 इनवॉइस';
  }

  @override
  String get legacyUi53e337d44c => 'प्लान सेव करें';

  @override
  String get legacyUi4fc636d1bb => 'प्लान अपडेट हुआ।';

  @override
  String get legacyUidc5a367e83 => 'प्लान बनाया गया।';

  @override
  String get legacyUi2325fc9152 => 'वाहन प्रकार उपलब्ध नहीं हैं';

  @override
  String get legacyUi4e4664e8e9 => 'वाहन प्रकार चुनें';

  @override
  String get legacyUi37282b63dd => 'उपयोगकर्ता लोड हो रहा है';

  @override
  String get legacyUide2b4561e4 => 'लोड उपयोगकर्ता में विफल';

  @override
  String get legacyUif1b918acaf => 'प्राथमिक उपयोगकर्ता बनाएँ या चुनें';

  @override
  String get legacyUic96ec8c8a6 => 'डिवाइस उपलब्ध नहीं हैं';

  @override
  String get legacyUieeed87c94b => 'GPS डिवाइस चुनें';

  @override
  String get legacyUie5a3dc6c41 => 'प्लान उपलब्ध नहीं हैं';

  @override
  String get legacyUi509d83b55f => 'मूल्य निर्धारण प्लान चुनें';

  @override
  String legacyUi91c69c8c0d(Object value1) {
    return 'वाहन \"$value1\" बनाया गया।';
  }

  @override
  String get legacyUi048e2d12ad => 'वाहन निष्क्रिय हुआ।';

  @override
  String get legacyUib042915cc0 => 'वाहन सक्रिय हुआ।';

  @override
  String get legacyUi3741f56c60 => 'सेंसर बनाएं';

  @override
  String get legacyUi996e719712 => 'सेंसर सहेजें';

  @override
  String get legacyUiaa9bf6a127 => 'सेवा अपडेट नहीं हो सकी';

  @override
  String legacyUif17fe09e18(Object value1) {
    return '$value1 का वार्षिक कवरेज नवीनीकृत हुआ';
  }

  @override
  String get legacyUid55d13471f => 'वार्षिक नवीनीकरण विफल हुआ';

  @override
  String get legacyUi2caa5892b7 => 'स्थिति जाँची जा रही है...';

  @override
  String get legacyUid56ae084ba => 'दस्तावेज़ संपादित करें';

  @override
  String get legacyUi47396c4fcf => 'शुरू करने के लिए ड्राइवर बनाएँ।';

  @override
  String get legacyUie4c5584c2a => 'ड्राइवर सक्रिय हुआ।';

  @override
  String get legacyUi255f9b5d50 => 'ड्राइवर निष्क्रिय हुआ।';

  @override
  String legacyUi2c5ad08780(Object value1) {
    return 'समाप्ति: $value1';
  }

  @override
  String get legacyUifc3606d535 => 'ड्राइवर निष्क्रिय करें';

  @override
  String get legacyUic82a768102 => 'ड्राइवर सक्रिय करें';

  @override
  String legacyUi3c2dd46009(Object value1) {
    return '$value1 (वर्तमान)';
  }

  @override
  String get legacyUi9e9d25ea74 => 'पहले देश चुनें';

  @override
  String get legacyUi789073b300 => 'पहले राज्य चुनें';

  @override
  String get legacyUie0c7a349f8 => 'फ़िल्टर किए गए सभी चयन हटाएँ';

  @override
  String get legacyUi30a4c62f4d => 'फ़िल्टर किए गए सभी चुनें';

  @override
  String get legacyUi303e32bfd9 => 'भुगतान की पुष्टि हुई और सेवा नवीनीकृत हुई';

  @override
  String get legacyUiad3c7489f5 => 'नवीनीकरण अनुरोध रद्द हुआ';

  @override
  String get legacyUi91027c0a9a => 'अनुरोध अपडेट नहीं हो सका';

  @override
  String get legacyUi3fb82cbe4b => 'उपयोगकर्ता टिकट खोजें';

  @override
  String get legacyUi3263ab8929 => 'मेरे टिकट खोजें';

  @override
  String get legacyUi24cae41f13 => 'उपयोगकर्ता सक्रिय हुआ।';

  @override
  String get legacyUi48d348ab09 => 'उपयोगकर्ता निष्क्रिय हुआ।';

  @override
  String legacyUi515200de54(Object value1) {
    return 'कम से कम $value1 अक्षर';
  }

  @override
  String get legacyUiea03fca475 => 'पहले देश चुनें';

  @override
  String get legacyUi01d9797a19 => 'राज्य उपलब्ध नहीं हैं';

  @override
  String get legacyUic234150a07 => 'राज्य चुनें';

  @override
  String get legacyUida9ca145a1 => 'पहले राज्य चुनें';

  @override
  String get legacyUi12fb8b7d21 => 'शहर उपलब्ध नहीं हैं';

  @override
  String get legacyUia8ab373cf7 => 'शहर चुनें';

  @override
  String legacyUi99c1db6636(Object value1) {
    return 'उपयोगकर्ता \"$value1\" बनाया गया।';
  }

  @override
  String get legacyUi6ea66e7cf8 => 'कोई ड्राइवर असाइन नहीं है';

  @override
  String get legacyUi6b4d2e8347 => 'आपकी खोज से कोई ड्राइवर मेल नहीं खाता';

  @override
  String legacyUic7a9755928(Object value1) {
    return 'लाइसेंस $value1';
  }

  @override
  String get legacyUi530530a405 => 'ड्राइवर उपलब्ध नहीं हैं';

  @override
  String legacyUied9f265a0a(Object value1) {
    return '$value1 खोजें';
  }

  @override
  String get legacyUia269afc99c => 'कोई टिकट नहीं मिला';

  @override
  String get legacyUifd0ab9a284 => 'आपकी खोज से कोई टिकट मेल नहीं खाता';

  @override
  String legacyUic93cd16b9b(Object value1) {
    return 'पिछला $value1';
  }

  @override
  String legacyUib68af38cf0(Object value1) {
    return 'टिकट पहले से $value1 है।';
  }

  @override
  String get legacyUi9ddc709693 => 'उपयोगकर्ता निष्क्रिय करें';

  @override
  String get legacyUiaebaaf50f8 => 'उपयोगकर्ता सक्रिय करें';

  @override
  String get legacyUi8ed321fdf0 => 'अनुमतियाँ सहेजी नहीं जा सकीं';

  @override
  String get legacyUi51c4b07667 => 'आपकी खोज से कोई वाहन मेल नहीं खाता';

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
    return 'समाप्ति: $value1';
  }

  @override
  String get legacyUif0dc6b09f8 => 'वाहन उपलब्ध नहीं हैं';

  @override
  String get legacyUi39d436aaba => 'समाप्ति नहीं है';

  @override
  String get legacyUic15c47e4c9 => 'IMEI, डिवाइस प्रकार या SIM नंबर खोजें…';

  @override
  String get legacyUibc139b1c14 => 'SIM, IMSI, ICCID या प्रदाता खोजें…';

  @override
  String get legacyUiaa729739dd => 'डिवाइस नहीं मिले';

  @override
  String get legacyUi679d782d32 => 'SIM कार्ड नहीं मिले';

  @override
  String get legacyUi613b9215a5 => 'शुरू करने के लिए इन्वेंटरी जोड़ें।';

  @override
  String get legacyUi9f91b0dc33 => 'डिवाइस प्रकार लोड हो रहे हैं...';

  @override
  String legacyUi9ba6bfee17(Object value1) {
    return 'सुरक्षित डिफ़ॉल्ट उपयोग हो रहे हैं। $value1';
  }

  @override
  String get legacyUi2919b3cdf5 => 'ईमेल लंबित है';

  @override
  String get legacyUidfd4099c87 => 'WhatsApp लंबित है';

  @override
  String legacyUif0dd87cef8(Object value1) {
    return '$value1 टैब पर जाएँ';
  }

  @override
  String legacyUi364cdce6f9(Object value1) {
    return '$value1 क्रेडिट';
  }

  @override
  String get legacyUi070e328ec8 => 'अपलोड हो रहा है...';

  @override
  String get legacyUie8d33553f6 => 'प्रोफ़ाइल चित्र बदलें';

  @override
  String legacyUi56b3825e50(Object value1) {
    return 'प्रीसेट $value1 लागू करें';
  }

  @override
  String get legacyUi28e40daab7 => 'दोबारा भेजा जा रहा है...';

  @override
  String get legacyUib707b694b2 => 'OTP दोबारा भेजें';

  @override
  String legacyUia648c7bbe2(Object value1) {
    return '$value1 चयन';
  }

  @override
  String get legacyUidd1242a8fc => 'सदस्यता सक्रिय है';

  @override
  String get legacyUibbf5d78203 => 'सदस्यता नहीं है';

  @override
  String get legacyUi0e42454279 => 'सभी वाहन';

  @override
  String get legacyUi12e7d6beac => 'स्रोत अज्ञात है';

  @override
  String get legacyUifb2269d326 => 'परिचालन के लिए वाहन उपलब्ध नहीं हैं।';

  @override
  String get legacyUi9dd705b078 => 'कोई वाहन उपलब्ध नहीं';

  @override
  String legacyUi8879fce2e7(Object value1, Object value2) {
    return '$value1 अवरुद्ध वाहन$value2 बाहर रखे गए।';
  }

  @override
  String legacyUif039d146e6(Object value1) {
    return '$value1 असाइन किया गया वाहन';
  }

  @override
  String get legacyUi02b460b2cf => 'मेल खाते वाहन नहीं हैं';

  @override
  String get legacyUi537da7f70e =>
      'सभी वाहन पहले से इस उप-उपयोगकर्ता को असाइन हैं।';

  @override
  String get legacyUif614a2e6b5 => 'दूसरी खोज आज़माएँ।';

  @override
  String get legacyUi28516f977e => 'उप-उपयोगकर्ता निष्क्रिय हुआ।';

  @override
  String get legacyUi7841e93192 => 'उप-उपयोगकर्ता सक्रिय हुआ।';

  @override
  String get legacyUi87e328dc94 => 'साफ़ करें खोजें';

  @override
  String get legacyUi72556ffa55 => 'ड्राइवर को दिखाई देगा';

  @override
  String get legacyUi355f129929 => 'ड्राइवर से छिपा है';

  @override
  String get legacyUib68e795ff9 => 'वाहन बदलें';

  @override
  String get legacyUi0cb329674a => 'उपयोगकर्ता दस्तावेज़ों में दिखाई देगा';

  @override
  String get legacyUi7ab98ca9b9 => 'उपयोगकर्ता दस्तावेज़ों से छिपा है';

  @override
  String get legacyUi5f22178640 => 'ड्राइवर यह दस्तावेज़ देख सकता है';

  @override
  String get legacyUiaf7ad5ad5c => 'ड्राइवर यह दस्तावेज़ नहीं देख सकता';

  @override
  String get legacyUib544cc3e95 => 'असाइनमेंट रहित वाहन नहीं हैं';

  @override
  String get legacyUidf10a27148 => 'सभी वाहन पहले से असाइन हैं।';

  @override
  String get legacyUic3763af773 => 'अपडेट नहीं हुआ';

  @override
  String get legacyUia1f5a8dbd3 => 'सेंसर नहीं मिले';

  @override
  String get legacyUi6a3625800c => 'इस वाहन के सेंसर सेट नहीं हैं।';

  @override
  String get legacyUi5fdd1b0855 => 'सेंसर सेटिंग्स';

  @override
  String get legacyUi2524c34a0d => 'नया सेंसर';

  @override
  String get legacyUiae7e887517 => 'सेव हो रहा…';

  @override
  String get legacyUi126eda8b21 => 'चल रहा है...';

  @override
  String get legacyUi7745774c38 => 'सेंसर बनाया गया';

  @override
  String get legacyUi2a367dafb5 => 'सेंसर अपडेट हुआ';

  @override
  String get legacyUi4abc320492 => 'कॉन्फ़िगरेशन लोड हो रहा है';

  @override
  String get legacyUic0ae8f6ea8 => 'सेव हुआ';

  @override
  String get legacyUif352418f58 => 'प्रकार लोड हो रहा है…';

  @override
  String get legacyUi82385d8917 => 'समय क्षेत्र लोड हो रहे हैं…';

  @override
  String get legacyUi22e6340f2c => 'टाइमज़ोन चुनें';

  @override
  String get legacyUicc4889261c => 'इतिहास दोबारा लोड करें';

  @override
  String get legacyUi9e8a1c5b7b => 'सेंसर लोड हो रहा है…';

  @override
  String legacyUic0a743750e(Object value1) {
    return '$value1 रिपोर्ट की अवधि चुनें';
  }

  @override
  String legacyUi26362a69a0(Object value1) {
    return 'चालू: $value1';
  }

  @override
  String legacyUicbbef93382(Object value1) {
    return 'बंद: $value1';
  }

  @override
  String legacyUic1d252d58b(Object value1) {
    return '$value1 — अधिक गति';
  }

  @override
  String legacyUidf3ab0c2d9(Object value1) {
    return 'दिन: $value1';
  }

  @override
  String legacyUi20076143b6(Object value1) {
    return 'रात: $value1';
  }

  @override
  String legacyUie296339b1e(Object value1, Object value2) {
    return '$value1 यात्रा$value2';
  }

  @override
  String legacyUib4c5c14ddb(Object value1) {
    return 'अधिकतम $value1 किमी/घंटा';
  }

  @override
  String legacyUi491fa657c5(Object value1, Object value2) {
    return '$value1: $value2 किमी';
  }

  @override
  String legacyUia6587e8e7b(Object value1) {
    return 'वाहन के अनुसार दूरी (शीर्ष $value1)';
  }

  @override
  String legacyUi6eca89289b(Object value1) {
    return '$value1 किमी/घंटा';
  }

  @override
  String legacyUib9a5d6824c(Object value1, Object value2) {
    return '$value2 के लिए जियोफेंस $value1';
  }

  @override
  String legacyUi4d24bcb058(Object value1, Object value2) {
    return '$value2 के लिए अधिक गति सीमा ($value1)';
  }

  @override
  String get legacyUi56a2285c5b => 'सेव हो रहा…';

  @override
  String legacyUia1f38b12bb(Object value1) {
    return '$value1 स्विच';
  }

  @override
  String legacyUic3b516d33c(Object value1) {
    return '$value1 जियोफेंस';
  }

  @override
  String get legacyUi010f99630a => 'ट्रैक लिंक संपादित करें';

  @override
  String get legacyUibb53b1c483 => 'नया ट्रैक लिंक';

  @override
  String legacyUi9287b718c6(Object value1) {
    return '$value1 चुना गया';
  }

  @override
  String get legacyUib948ff19e4 => 'वर्ग का लॉक हटाएँ';

  @override
  String get legacyUi85a3ef0c3f => 'वर्ग लॉक करें';

  @override
  String get legacyUi9dd7a6b201 => 'जियोफेंस बनाएँ';

  @override
  String get legacyUidccb573a71 => 'रूट बनाएँ';

  @override
  String legacyUi4c91961249(Object value1) {
    return '$value1 पंक्तियाँ अपलोड करें';
  }

  @override
  String legacyUi0ff9c73519(Object value1) {
    return '$value1 मान्य';
  }

  @override
  String legacyUifa7ec0ed62(Object value1) {
    return '$value1 अमान्य';
  }

  @override
  String legacyUi1483db1240(Object value1) {
    return '$value1 ठीक';
  }

  @override
  String legacyUi2c661fac7f(Object value1) {
    return '$value1 विफल';
  }

  @override
  String get legacyUi7e613c0b85 => 'POI रखें';

  @override
  String get legacyUi4405592a72 => 'POI खिसकाएँ';

  @override
  String get legacyUi91fbb41bfb => 'यह स्थान उपयोग करें';

  @override
  String get legacyUif05f282071 => 'POI रखने के लिए मानचित्र पर टैप करें';

  @override
  String get legacyUie8f485c68a => 'फ़िल्टर या तारीख सीमा बदलकर देखें।';

  @override
  String get legacyUia0c0bb9e85 => 'इस अवधि के लेनदेन उपलब्ध नहीं हैं।';

  @override
  String legacyUid7d6dade2a(Object value1) {
    return 'सफल: $value1';
  }

  @override
  String legacyUi3a0d457cee(Object value1) {
    return 'लंबित: $value1';
  }

  @override
  String legacyUi07d104432b(Object value1) {
    return 'असफल: $value1';
  }

  @override
  String get legacyUi3fb75e3bfe => 'पासवर्ड रीसेट करें';

  @override
  String get legacyUif99d98e85f => 'पासवर्ड भूल गए?';

  @override
  String get legacyUi0d2afda86b => 'डेमो कार्यक्षेत्र खुला';

  @override
  String get legacyUif06ccf010d => 'लॉगिन सफल हुआ';

  @override
  String get legacyUifc45091249 => 'लाइट मोड पर जाएँ';

  @override
  String get legacyUic29220f958 => 'डार्क मोड पर जाएँ';

  @override
  String get legacyUi257616b8e4 => 'अपठित सूचनाएँ नहीं हैं';

  @override
  String get legacyUid2609b6af1 => 'कोई नोटिफिकेशन अभी तक नहीं';

  @override
  String get legacyUi04d956a670 =>
      'सब पढ़ा हुआ चिह्नित है। नए अलर्ट आते ही यहाँ दिखाई देंगे।';

  @override
  String get legacyUi7fe220bd95 =>
      'वाहन अलर्ट, सिस्टम घटनाएँ और परिचालन अपडेट यहाँ दिखाई देंगे।';

  @override
  String get legacyUib2f3a86e84 => 'सब पढ़ा हुआ है';

  @override
  String get legacyUicbf6939e9e => 'चिह्नित हो रहा है…';

  @override
  String get legacyUi8958e22c23 => 'सभी पढ़े हुए चिह्नित करें';

  @override
  String legacyUicb9ae54e8a(Object value1, Object value2) {
    return '$value2 में से $value1 दिख रहे हैं';
  }

  @override
  String legacyUie5b28b8ae4(Object value1, Object value2) {
    return 'पृष्ठ $value1 / $value2';
  }

  @override
  String get legacyUic1d317a815 => 'मेल खाते टिकट नहीं हैं';

  @override
  String get legacyUiae9e814889 => 'कोई टिकट नहीं';

  @override
  String get legacyUicc80739f43 => 'दूसरी खोज या स्थिति फ़िल्टर आज़माएँ।';

  @override
  String get legacyUib1ac2d29f2 => 'टिकट बनाएँ, टीम यहाँ जवाब देगी।';

  @override
  String legacyUia6864fdac8(Object value1) {
    return '$value1 पंक्तियाँ';
  }

  @override
  String get legacyUi8f26c6520d => 'लोड हो रहा है…';

  @override
  String legacyUie7a93c340a(Object value1) {
    return '$value1 घटनाएँ';
  }

  @override
  String get legacyUia4ab77ad86 => 'OpenVTS घटना';

  @override
  String get legacyUif55aae5a86 => 'IMEI उपलब्ध नहीं है';

  @override
  String get legacyUib8eb4a7ee3 => 'कमांड लोड हो रहे हैं…';

  @override
  String get legacyUif7933da683 => 'संगत कमांड नहीं हैं';

  @override
  String get legacyUi4be4430e57 => 'कमांड चुनें';

  @override
  String legacyUi70ac5dd63e(Object value1) {
    return 'समयरेखा ($value1)';
  }

  @override
  String legacyUi24d8fbef9d(Object value1, Object value2) {
    return '$value1 ${value2}x';
  }

  @override
  String legacyUibde2a7e880(Object value1, Object value2, Object value3) {
    return 'पृष्ठ $value1 / $value2 · $value3 यात्राएँ';
  }

  @override
  String legacyUi08343b3fe7(Object value1) {
    return '$value1 शेष';
  }

  @override
  String legacyUi843b148bbc(Object value1) {
    return 'अनुमानित आगमन $value1';
  }

  @override
  String legacyUi46d11990c5(Object value1) {
    return 'स्थिति अपडेट हुई $value1';
  }

  @override
  String legacyUiecd87f34a4(Object value1) {
    return '$value1 हटाएँ?';
  }

  @override
  String legacyUi666b616488(Object value1) {
    return 'समाप्ति $value1';
  }

  @override
  String get legacyUic7ac551ef0 => 'हटाया जा रहा..।';

  @override
  String legacyUi27015ac78b(Object value1, Object value2) {
    return '$value1 अपठित · नवीनतम $value2 सूचनाएँ';
  }

  @override
  String legacyUi46b0a7d4ca(Object value1, Object value2) {
    return '$value1 / $value2 ठहराव पूरे हुए';
  }

  @override
  String get legacyUidc7f2c3785 => 'तारीख उपलब्ध नहीं है';

  @override
  String get legacyUib11b062b52 => 'यात्रा का प्रमाण अपलोड करें';

  @override
  String get legacyUi8f1a9ca44a => 'PDF, JPG, PNG या WebP · अधिकतम 5 MB';

  @override
  String get legacyUi91df716a6b =>
      'PDF, JPG, PNG, WebP, DOC या DOCX · अधिकतम 5 MB';

  @override
  String get legacyUid921a79afa => 'अपलोड हो रहा है…';

  @override
  String legacyUiba9b85b92a(Object value1) {
    return 'अंतिम अपडेट $value1';
  }

  @override
  String legacyUib9f8dfe265(Object value1) {
    return 'आज की दूरी: $value1';
  }

  @override
  String legacyUif0ea529a1a(Object value1) {
    return '$value1 दिन';
  }

  @override
  String legacyUi387c4ee271(Object value1, Object value2) {
    return '$value1  ·  $value2 दिन';
  }

  @override
  String get legacyUideba3e1d0f => 'पूर्वाभ्यास सारांश';

  @override
  String get legacyUia7d0c36803 => 'अंतिम सफ़ाई';

  @override
  String legacyUia24243eb0c(Object value1) {
    return 'टेबल ($value1)';
  }

  @override
  String get legacyUic74a3012a0 => 'स्थिति जाँची जा रही है…';

  @override
  String get legacyUie991a76914 => 'स्थिति अज्ञात है';

  @override
  String get legacyUia722bd6476 =>
      'उपयोगकर्ता, वाहन और लाइसेंस में प्लेटफ़ॉर्म की वृद्धि।';

  @override
  String legacyUi852c487a99(Object value1) {
    return 'लाइसेंस का अधिकतम उपयोग $value1';
  }

  @override
  String legacyUic44efcae53(Object value1) {
    return '$value1 को प्लेटफ़ॉर्म से हटाएँ? इस कार्रवाई को वापस नहीं लिया जा सकता।';
  }

  @override
  String legacyUicac4f1ac56(Object value1) {
    return '$value1 व्यवस्थापक';
  }

  @override
  String legacyUi68401f3c9e(Object value1, Object value2) {
    return 'प्रति लेनदेन औसत $value1 $value2';
  }

  @override
  String get legacyUi526698fef7 => 'वाहन रीफ़्रेश नहीं हो सके।';

  @override
  String legacyUie9b7179dd3(Object value1) {
    return 'दस्तावेज़ ($value1)';
  }

  @override
  String get legacyUiefd8314874 => 'दस्तावेज़ रीफ़्रेश नहीं हो सके।';

  @override
  String get legacyUie214b8a299 => 'दस्तावेज़';

  @override
  String legacyUidb4675bc22(Object value1) {
    return 'शेष $value1';
  }

  @override
  String legacyUi16be827cb6(Object value1) {
    return 'वाहन #$value1';
  }

  @override
  String get legacyUibd5caf1601 =>
      'सॉफ़्टवेयर लाइसेंस की सीमा के कारण ट्रैकिंग अवरुद्ध है।';

  @override
  String get legacyUid8663517be => 'अंतिम जाँच: —';

  @override
  String get legacyUi1be0035c25 => 'निजी';

  @override
  String get legacyUi5f1184f7df => 'संपूर्ण';

  @override
  String get legacyUif5f940cfe2 => 'अनुमतियाँ सहेजें';

  @override
  String legacyUi8a9135d5ad(Object value1) {
    return '$value1% एकत्रित';
  }

  @override
  String legacyUi3b0c54fa00(Object value1) {
    return 'अनुमानित $value1';
  }

  @override
  String legacyUi16ff2e7fa9(Object value1) {
    return 'अंतर $value1';
  }

  @override
  String legacyUi4956298616(Object value1, Object value2) {
    return '$value1 वाहन · $value2';
  }

  @override
  String legacyUi120d777276(Object value1) {
    return 'भुगतान हुआ $value1';
  }

  @override
  String legacyUi617d0ebe3d(Object value1, Object value2) {
    return '$value2 में से $value1 प्लान';
  }

  @override
  String get legacyUi25422daedb => 'बिना नाम का वाहन';

  @override
  String legacyUicbbe928bb9(Object value1) {
    return 'वार्षिक कवरेज: $value1';
  }

  @override
  String legacyUiec60ebb81f(Object value1) {
    return 'ग्राहक सेवा: $value1';
  }

  @override
  String legacyUiced28bc228(Object value1) {
    return 'खाते के क्रेडिट: $value1';
  }

  @override
  String get legacyUic1a90693df => 'लाइव ट्रैकिंग सक्रिय है';

  @override
  String legacyUi4bdc33e519(Object value1, Object value2) {
    return '$value1 · $value2 दिन';
  }

  @override
  String get legacyUi889f282a7d => 'तारीख और समय चुनें';

  @override
  String get legacyUi83cbbbc297 => 'सेवा बदलाव सहेजें';

  @override
  String get legacyUi69feaaf8cd => 'सभी तारीखें';

  @override
  String get legacyUi0c6c4102d4 => 'वैकल्पिक';

  @override
  String legacyUic57882f9c9(Object value1) {
    return 'स्थिति: $value1';
  }

  @override
  String legacyUiae3c1f8817(Object value1) {
    return 'यह कमांड $value1 को भेजें?';
  }

  @override
  String legacyUic51f739b4e(Object value1) {
    return 'असाइन किए गए उपयोगकर्ता ($value1)';
  }

  @override
  String get legacyUibc7819b34f => 'अज्ञात';

  @override
  String legacyUi46aece3259(Object value1) {
    return 'इस वाहन से $value1 हटाएँ?';
  }

  @override
  String legacyUi3d2bb84b75(Object value1, Object value2) {
    return 'लाइव मान: $value1 $value2';
  }

  @override
  String legacyUieb3a3daafa(Object value1) {
    return 'कोड: $value1';
  }

  @override
  String legacyUi93aa5178d6(Object value1) {
    return 'दस्तावेज़ प्रकार: $value1';
  }

  @override
  String legacyUi0e12da1c5e(Object value1) {
    return 'फ़ाइल: $value1';
  }

  @override
  String legacyUi3ce1585208(Object value1) {
    return 'समाप्ति: $value1';
  }

  @override
  String legacyUiaeafae8a12(Object value1) {
    return 'दृश्यता: $value1';
  }

  @override
  String legacyUi39d7217391(Object value1) {
    return 'टैग: $value1';
  }

  @override
  String legacyUi4439ddf5a2(Object value1) {
    return 'बनाया गया: $value1';
  }

  @override
  String legacyUid5c6adaee3(Object value1) {
    return 'इस ड्राइवर से $value1 हटाएँ?';
  }

  @override
  String get legacyUieb7eb7a819 => 'फाइल चुनें';

  @override
  String get legacyUi8f8dd8dbd3 => 'व्यवस्थापक से छिपा है';

  @override
  String get legacyUi65d06317e9 =>
      'व्यवस्थापक उपयोगकर्ता यह दस्तावेज़ देख सकते हैं';

  @override
  String get legacyUic0e9577a75 => 'केवल मालिक देख सकता है';

  @override
  String legacyUi864cf8bc08(Object value1) {
    return 'विशेषताएँ: $value1';
  }

  @override
  String legacyUi90d40c4249(Object value1) {
    return 'मूल डेटा: $value1';
  }

  @override
  String get legacyUia4d06ed284 => 'वाहन की घटना';

  @override
  String legacyUifba61e1a50(Object value1, Object value2, Object value3,
      Object value4, Object value5, Object value6) {
    return '$value1 • $value2 • भेजा $value3 • पहुँचा $value4 • फिर प्रयास $value5$value6';
  }

  @override
  String legacyUi9c07a085f8(Object value1, Object value2) {
    return '$value2 में से $value1 लेनदेन';
  }

  @override
  String legacyUi26b3b5dfb3(Object value1) {
    return '$value1 फिर प्रयास';
  }

  @override
  String legacyUi05563fda41(Object value1, Object value2, Object value3) {
    return 'प्लान: $value1 • $value2 $value3';
  }

  @override
  String legacyUi26400a7353(Object value1, Object value2) {
    return '$value1 वाहन$value2 चुने गए';
  }

  @override
  String legacyUi8f4ab245d3(Object value1, Object value2) {
    return 'स्वचालित योग: $value1 $value2';
  }

  @override
  String get legacyUi493de0b548 => 'मूल्य प्रस्ताव समाप्त हुआ';

  @override
  String legacyUi78218dbd5f(Object value1, Object value2, Object value3) {
    return '$value1 · $value2 · $value3 दिन';
  }

  @override
  String legacyUi13e7357d18(Object value1) {
    return 'मुझे $value1 प्राप्त हुए';
  }

  @override
  String get legacyUi7e72a446c4 => 'भुगतान फ़िल्टर छिपाएँ';

  @override
  String get legacyUi8f642c1d28 => 'भुगतान फ़िल्टर दिखाएँ';

  @override
  String legacyUi184c3f0cbb(Object value1) {
    return 'लेनदेन ID: $value1';
  }

  @override
  String legacyUi281961b9ee(Object value1) {
    return 'राशि: $value1';
  }

  @override
  String legacyUib40416c0af(Object value1) {
    return 'भुगतान प्रकार: $value1';
  }

  @override
  String legacyUia0d65517a6(Object value1) {
    return 'भुगतान माध्यम: $value1';
  }

  @override
  String legacyUic2d62e9f71(Object value1) {
    return 'संदर्भ: $value1';
  }

  @override
  String legacyUib0f627962a(Object value1) {
    return 'प्रदाता: $value1';
  }

  @override
  String legacyUie802a1b0a0(Object value1) {
    return 'प्रदाता संदर्भ: $value1';
  }

  @override
  String legacyUi2751887374(Object value1) {
    return 'से: $value1';
  }

  @override
  String legacyUi250106ee83(Object value1) {
    return 'प्रति: $value1';
  }

  @override
  String legacyUi5ff8e9357b(Object value1) {
    return 'दर्ज किया: $value1';
  }

  @override
  String legacyUi7565bbdff9(Object value1) {
    return 'वाहन #$value1';
  }

  @override
  String legacyUi2b542f8050(Object value1) {
    return 'IMEI: $value1';
  }

  @override
  String legacyUi76e24a00cf(Object value1) {
    return 'प्लान: $value1';
  }

  @override
  String legacyUi972db7d65e(Object value1) {
    return 'विफलता कोड: $value1';
  }

  @override
  String legacyUif147c11396(Object value1) {
    return 'विफलता संदेश: $value1';
  }

  @override
  String get legacyUic3146cdbec => 'सहायता बातचीत शुरू करने के लिए टिकट बनाएँ।';

  @override
  String legacyUi2cbdc50885(Object value1) {
    return 'इस व्यवस्थापक खाते से $value1 हटाएँ?';
  }

  @override
  String legacyUi073ab8a05c(Object value1, Object value2) {
    return '$value1 असाइन - $value2 उपलब्ध';
  }

  @override
  String legacyUidcc59f9fcf(Object value1) {
    return '$value1 चुनें';
  }

  @override
  String get legacyUi7a19b6deae => 'विकल्प उपलब्ध नहीं हैं';

  @override
  String get legacyUif28cfb8eb0 => '1 टिकट';

  @override
  String legacyUidf08f563b7(Object value1) {
    return 'वैकल्पिक फ़ाइलें, अधिकतम $value1।';
  }

  @override
  String get legacyUi5f2b4010d1 => '1 भुगतान';

  @override
  String get legacyUi876081608a => 'नवीनीकरण — 1 वाहन';

  @override
  String legacyUia034f3f5e5(Object value1) {
    return 'अनुमानित योग $value1';
  }

  @override
  String legacyUic07d143675(Object value1) {
    return 'नवीनीकृत वाहन ($value1)';
  }

  @override
  String legacyUiff384c8aa4(Object value1) {
    return 'इस उपयोगकर्ता से $value1 हटाएँ?';
  }

  @override
  String legacyUicb6d241451(Object value1, Object value2) {
    return '$value1 फ़ाइलें - $value2 उपयोगकर्ता प्रकार';
  }

  @override
  String get legacyUif63f04564a => 'उपयोगकर्ता प्रकार लोड हो रहे हैं';

  @override
  String get legacyUi74b1d89d85 => 'फ़ाइल चुनें';

  @override
  String get legacyUi62783d600b => 'उपयोगकर्ता दस्तावेज़ों में दिखता है';

  @override
  String get legacyUi38fc177e28 => 'उपयोगकर्ता से छिपा है';

  @override
  String legacyUibce346e856(Object value1, Object value2) {
    return '$value1 उपयोगकर्ता$value2';
  }

  @override
  String get legacyUi674b652fca => 'तारीखें बदलें';

  @override
  String get legacyUi08d0e4f72a => 'लेन-देन लोड हो रहा है…';

  @override
  String get legacyUib3a56d64d2 => 'इन फ़िल्टर से कोई लेनदेन मेल नहीं खाता।';

  @override
  String get legacyUi049ac820da => 'काम जारी है...';

  @override
  String legacyUie783127bc1(Object value1) {
    return 'शामिल हुआ $value1';
  }

  @override
  String legacyUieb587f7802(Object value1) {
    return 'प्रोफ़ाइल अपडेट हुई $value1';
  }

  @override
  String get legacyUi1dfc507715 =>
      'देश और मोबाइल कोड के संदर्भ उपलब्ध नहीं हैं। आप मैन्युअल संपादन कर सकते हैं।';

  @override
  String get legacyUia7c1498ab2 =>
      'आपने प्रोफ़ाइल ईमेल सूचनाओं की सदस्यता ली है।';

  @override
  String get legacyUi77653a7db4 =>
      'प्रोफ़ाइल और खाते के ईमेल अपडेट पाने के लिए सदस्यता लें।';

  @override
  String get legacyUid3b8add13e => 'विकल्प उपलब्ध नहीं हैं।';

  @override
  String legacyUi08b544b680(Object value1) {
    return 'तय की गई दूरी $value1';
  }

  @override
  String legacyUi6c783ae69f(Object value1) {
    return 'नवीनतम $value1 अलर्ट में से 10 दिख रहे हैं';
  }

  @override
  String get legacyUi45ef37a941 => 'कोई संदेश नहीं दिया गया।';

  @override
  String get legacyUia2ae39a298 => 'माध्यम अज्ञात है';

  @override
  String get legacyUiceafde86d6 => 'भेजा जा रहा है...';

  @override
  String get legacyUi46cefb25e2 => 'कमांड? भेजें';

  @override
  String legacyUib3d1704245(Object value1) {
    return 'दिन की अवधि: $value1';
  }

  @override
  String legacyUi735f148a9a(Object value1) {
    return 'प्रकार: $value1';
  }

  @override
  String legacyUi828a91effc(Object value1, Object value2, Object value3) {
    return '$value2 में से $value1 वाहन • $value3 चुने गए';
  }

  @override
  String legacyUia0ebdc2307(Object value1, Object value2, Object value3) {
    return '$value1 दिखाई दे रहे हैं • $value2/$value3 लोड हुए';
  }

  @override
  String legacyUi1d483a1343(Object value1) {
    return 'इस उप-उपयोगकर्ता से $value1 हटाएँ?';
  }

  @override
  String legacyUi02b84d460d(Object value1) {
    return 'असाइन करने के लिए $value1 उपलब्ध';
  }

  @override
  String get legacyUi65ad788d45 => 'नंबर प्लेट उपलब्ध नहीं है';

  @override
  String get legacyUi7bb4f2808b =>
      'उप-उपयोगकर्ता असाइन किए गए वाहनों तक पहुँच सकता है';

  @override
  String get legacyUi26b21a0d91 => 'उप-उपयोगकर्ता निष्क्रिय है';

  @override
  String legacyUibceb1630f0(Object value1, Object value2) {
    return '$value1 फ़ाइलें - $value2 दस्तावेज़ प्रकार';
  }

  @override
  String get legacyUi107b9056eb => 'ड्राइवर प्रकार लोड हो रहे हैं';

  @override
  String legacyUifd7e37cf51(Object value1, Object value2) {
    return '$value2 में से $value1 ड्राइवर';
  }

  @override
  String legacyUi14b274c7ae(Object value1, Object value2) {
    return '$value2 में से $value1 वाहन';
  }

  @override
  String legacyUi79a100acf7(Object value1) {
    return '$value1 हटाएँ?';
  }

  @override
  String legacyUi26875fe2e3(Object value1, Object value2) {
    return '$value1 फ़ाइलें - $value2 वाहन प्रकार';
  }

  @override
  String legacyUi7970bd3e0b(Object value1) {
    return '$value1 लोड नहीं हो सका।';
  }

  @override
  String get legacyUi5eaf2646c3 => 'वाहन प्रकार लोड हो रहा है…';

  @override
  String get legacyUi6ca60537ae => 'वाहन दस्तावेज़ों में दिखता है';

  @override
  String get legacyUi4e3d045a97 => 'उपयोगकर्ताओं से छिपा है';

  @override
  String get legacyUid3ce77345e => 'सेंसर इतिहास';

  @override
  String legacyUi5aba89cd2f(Object value1) {
    return '$value1 संख्यात्मक बिंदु';
  }

  @override
  String get legacyUie86a33f16a => 'सभी जियोफेंस';

  @override
  String legacyUi5321a316d0(Object value1) {
    return 'स्रोत: $value1';
  }

  @override
  String legacyUifabeb88d9c(Object value1) {
    return 'चुने गए $value1 उपयोग करें';
  }

  @override
  String legacyUi343ceded71(Object value1) {
    return 'जियोफेंस के अनुसार घटनाएँ (शीर्ष $value1)';
  }

  @override
  String legacyUide36170209(Object value1) {
    return 'अलर्ट प्रकार (शीर्ष $value1)';
  }

  @override
  String legacyUi019e5212ef(Object value1, Object value2) {
    return '$value1 किमी/घंटा (सीमा $value2)';
  }

  @override
  String legacyUicaae0add4a(Object value1, Object value2) {
    return '$value1 सक्रिय दिन$value2';
  }

  @override
  String legacyUi7911e1ad0c(Object value1, Object value2) {
    return '$value1 परिणाम$value2';
  }

  @override
  String legacyUi15b175bbc9(Object value1) {
    return 'बनाया गया $value1';
  }

  @override
  String legacyUi92a50db48d(Object value1) {
    return '$value1 रिपोर्ट निर्यात करें';
  }

  @override
  String legacyUida6472ea1a(Object value1) {
    return 'सभी $value1 वाहन शामिल होंगे';
  }

  @override
  String get legacyUib0c379b2f8 => 'वाहन समूह चुनें';

  @override
  String get legacyUi23d6943e8b => 'वाहन चुनें';

  @override
  String legacyUi47b7508acb(Object value1) {
    return 'पूर्ण ($value1)';
  }

  @override
  String legacyUid495bed9d8(Object value1) {
    return 'सभी दिखाई दे रहे चुनें ($value1)';
  }

  @override
  String legacyUi096909f019(Object value1, Object value2) {
    return '$value1 वाहन$value2';
  }

  @override
  String legacyUie003b8a491(Object value1) {
    return 'इस रिपोर्ट के लिए अधिकतम $value1 दिन';
  }

  @override
  String legacyUif386fe6e70(Object value1) {
    return 'साफ़ करें ($value1)';
  }

  @override
  String get legacyUi706049c6a9 => 'सेंसर चुनें';

  @override
  String legacyUi2841c7f501(Object value1) {
    return '\"$value1\" के लिए कोई रिपोर्ट नहीं मिली';
  }

  @override
  String legacyUi8002c1aa36(Object value1) {
    return 'समय $value1 के अनुसार हैं।';
  }

  @override
  String legacyUieaa190f343(Object value1) {
    return '$value1 चालू है';
  }

  @override
  String legacyUidc179fe07f(Object value1) {
    return 'गति सीमा कम से कम 1 $value1 होनी चाहिए।';
  }

  @override
  String legacyUi11003e8471(Object value1) {
    return '$value1 — डिलीवरी चैनल';
  }

  @override
  String legacyUidc7454d672(Object value1) {
    return 'अंतिम बार सहेजा गया $value1';
  }

  @override
  String get legacyUi7968beb979 => 'कोड';

  @override
  String legacyUi0528ad37c9(Object value1, Object value2) {
    return '$value2 में से $value1 लिंक';
  }

  @override
  String get legacyUiac2a036e38 => 'अभी कोई गतिविधि नहीं है।';

  @override
  String legacyUi3a4361ec75(Object value1) {
    return '\"$value1\" स्थायी रूप से हटा दिया जाएगा।';
  }

  @override
  String get legacyUi50a9e13fce => 'बिना नाम का जियोफेंस';

  @override
  String legacyUi760cb5d683(Object value1, Object value2) {
    return '$value1 बिंदु$value2';
  }

  @override
  String legacyUifa6e784713(Object value1) {
    return '#$value1 हटाएँ';
  }

  @override
  String legacyUi27a25269f5(Object value1) {
    return 'बारीक समायोजन ($value1 मीटर)';
  }

  @override
  String get legacyUi39706b5a17 => 'अभी आकृति नहीं है';

  @override
  String get legacyUi1bf6cb6c45 => 'आकृति तैयार है';

  @override
  String get legacyUi5d437ca98b => 'इस जियोफेंस के लिए घटनाएँ सक्रिय होंगी।';

  @override
  String get legacyUi6d8b4724c6 => 'जियोफेंस रुका हुआ है।';

  @override
  String get legacyUi7e9f5c3026 => 'मानचित्र पर कम से कम 2 बिंदु बनाएँ।';

  @override
  String get legacyUi28134edb87 => 'मानचित्र पर संपादित करें';

  @override
  String get legacyUi0f873fbc31 => 'मानचित्र पर बनाएँ';

  @override
  String legacyUi48f6c8c8ac(Object value1) {
    return '$value1 मीटर';
  }

  @override
  String legacyUicde59da67c(Object value1) {
    return '$value1 मिनट';
  }

  @override
  String get legacyUi4bd1e22ea7 => 'बिना नाम का रूट';

  @override
  String legacyUi198f442dfb(Object value1) {
    return 'शीर्ष बिंदु $value1';
  }

  @override
  String legacyUibae08b3767(Object value1, Object value2) {
    return 'पंक्ति $value1: $value2';
  }

  @override
  String get legacyUi93039e609d => 'नहीं सेट';

  @override
  String get legacyUid33a96e366 => 'मानचित्र पर चुनें';

  @override
  String get legacyUiecd575d434 =>
      'लाइव मानचित्र और निकटता अलर्ट में दिखाई देगा।';

  @override
  String get legacyUi92a172ce15 => 'अलर्ट से छिपा है; सूची में रहेगा।';

  @override
  String get legacyUi8019307fe5 => 'बिना नाम का POI';

  @override
  String get legacyUid14e0c02a9 => 'लाइव ट्रैकिंग उपलब्ध है';

  @override
  String legacyUic814ea2b6e(Object value1) {
    return 'सेवा शुरू होगी: $value1';
  }

  @override
  String legacyUic926abedfd(Object value1) {
    return 'ग्राहक सेवा समाप्त होगी: $value1';
  }

  @override
  String legacyUiae0052da76(Object value1) {
    return 'प्रदाता कवरेज समाप्त होगा: $value1';
  }

  @override
  String legacyUi633ec01c21(Object value1, Object value2) {
    return '$value1 • $value2 दिन';
  }

  @override
  String get legacyUicf765512cc => 'भेजा जा रहा है...';

  @override
  String get legacyUi50756f98a3 => 'नवीनीकरण का अनुरोध करें';

  @override
  String legacyUid52adacef9(Object value1) {
    return 'अनुरोध #$value1';
  }

  @override
  String get legacyUicfeb791a76 => 'अनुरोध समाप्त हुआ';

  @override
  String legacyUif0d8958371(Object value1, Object value2, Object value3,
      Object value4, Object value5) {
    return '$value1\n$value2 • $value3 दिन\n$value4 $value5\n\nसेवा बढ़ने से पहले आपके व्यवस्थापक को भुगतान की पुष्टि करनी होगी।';
  }

  @override
  String get legacyUifdb17036d5 => 'OpenVTS उपयोगकर्ता';

  @override
  String legacyUif7e83b3f19(Object value1) {
    return 'डिफ़ॉल्ट पर रीसेट करें ($value1)';
  }

  @override
  String legacyUi54e519da7f(Object value1) {
    return 'त्रुटि: $value1';
  }

  @override
  String get legacyUi7eb29d3565 => 'दिनांक & समय';

  @override
  String get legacyUib1deb07e61 => 'जियोफेंस खोलें';

  @override
  String get legacyUi1dce4bf43b => 'POI खोलें';

  @override
  String get legacyUi4a0d050737 => 'रूट खोलें';

  @override
  String get legacyUib6bd42e4e7 => 'प्रगति में';

  @override
  String get legacyUi91edf8aff9 => 'यात्रा पर';

  @override
  String get legacyUi20c7c5522f => 'तैयार';

  @override
  String get legacyUi0a2b58e839 => 'कोई असाइनमेंट नहीं';

  @override
  String get legacyUi6cf3d41f08 => 'सभी यात्राएँ';

  @override
  String get legacyUif7a616a336 => 'पहुँच अवरुद्ध है';

  @override
  String get legacyUiac7b5dd3a8 => 'प्राप्तकर्ता उपलब्ध नहीं है';

  @override
  String get legacyUi936d2e8552 => 'वाहन की समस्या';

  @override
  String get legacyUi51cea59031 => 'रूट की समस्या';

  @override
  String get legacyUia972b55b1a => 'डिस्पैच के लिए समस्या का विवरण दें।';

  @override
  String get legacyUie0cdc02f99 => '12 घंटे का समय';

  @override
  String get legacyUif910251f7c => '24-घंटे का समय';

  @override
  String get legacyUi34ce147724 => 'बाएँ से दाएँ';

  @override
  String get legacyUida502a644e => 'दाएँ से बाएँ';

  @override
  String get legacyUiec45717e13 => 'विवरण के लिए डिस्पैच से संपर्क करें।';

  @override
  String get legacyUi8a783eb3d6 => 'असाइनमेंट स्वीकार किया गया';

  @override
  String get legacyUi00e1e19595 => 'यात्रा शुरू करें';

  @override
  String get legacyUi0015b1903d =>
      'यात्राएँ सामान्यतः वाहन टेलीमेट्री से शुरू होती हैं। यात्रा शुरू करते समय ही इस मैन्युअल विकल्प का उपयोग करें।';

  @override
  String get legacyUib20bd98ae2 => 'टिप्पणी जोड़ें';

  @override
  String get legacyUi42477e82cf => 'नेविगेशन नहीं खुल सका।';

  @override
  String get legacyUiea0bd6ff3d => 'ठहराव पूरा करें';

  @override
  String get legacyUi3d93beaa39 => 'अधिकतम 5 MB की गैर-खाली फ़ाइल चुनें।';

  @override
  String get legacyUid2085cce0d => 'अपलोड करने के लिए फ़ाइल चुनें।';

  @override
  String get legacyUid0193e6956 => 'दस्तावेज़ प्रकार चुनें।';

  @override
  String get legacyUif378218081 => 'कम से कम 2 अक्षर दर्ज करें';

  @override
  String get legacyUi63f72dce85 => 'फ़ाइल चुनें';

  @override
  String get legacyUi1255774559 => 'आज के असाइनमेंट';

  @override
  String get legacyUi3528465759 => 'पूरी हुई यात्राएँ';

  @override
  String get legacyUi28793a4155 => 'पूरे हुए ठहराव';

  @override
  String get legacyUi1683af6ce8 => 'लंबित ठहराव';

  @override
  String mobilePluralTrips(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count यात्राएँ',
      one: '$count यात्रा',
    );
    return '$_temp0';
  }

  @override
  String mobilePluralBlockedVehicles(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count अवरुद्ध वाहन बाहर रखे गए।',
      one: '$count अवरुद्ध वाहन बाहर रखा गया।',
    );
    return '$_temp0';
  }

  @override
  String mobilePluralSelectedVehicles(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count वाहन चुने गए',
      one: '$count वाहन चुना गया',
    );
    return '$_temp0';
  }

  @override
  String mobilePluralUsers(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count उपयोगकर्ता',
      one: '$count उपयोगकर्ता',
    );
    return '$_temp0';
  }

  @override
  String mobilePluralActiveDays(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count सक्रिय दिन',
      one: '$count सक्रिय दिन',
    );
    return '$_temp0';
  }

  @override
  String mobilePluralResults(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count परिणाम',
      one: '$count परिणाम',
    );
    return '$_temp0';
  }

  @override
  String mobilePluralVehicles(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count वाहन',
      one: '$count वाहन',
    );
    return '$_temp0';
  }

  @override
  String mobilePluralPoints(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count बिंदु',
      one: '$count बिंदु',
    );
    return '$_temp0';
  }

  @override
  String get relativeJustNow => 'अभी';

  @override
  String relativeMinutesAgo(int count) {
    return '$count मिनट पहले';
  }

  @override
  String relativeHoursAgo(int count) {
    return '$count घंटे पहले';
  }

  @override
  String relativeDaysAgo(int count) {
    return '$count दिन पहले';
  }

  @override
  String get relativeYesterday => 'कल';

  @override
  String savingChangesForTab(String tab) {
    return '$tab के बदलाव सहेजे जा रहे हैं…';
  }

  @override
  String unsavedChangesForTab(String tab) {
    return '$tab में आपके बदलाव अभी सहेजे नहीं गए हैं।';
  }

  @override
  String get saving => 'सहेजा जा रहा है…';

  @override
  String validationRequired(String field) {
    return '$field ज़रूरी है';
  }

  @override
  String validationAscii(String field) {
    return '$field में केवल ASCII अक्षर होने चाहिए';
  }

  @override
  String validationMinCharacters(String field, int count) {
    return '$field में कम से कम $count अक्षर होने चाहिए';
  }

  @override
  String validationMaxCharacters(String field, int count) {
    return '$field में अधिकतम $count अक्षर होने चाहिए';
  }

  @override
  String validationMinDigits(String field, int count) {
    return '$field में कम से कम $count अंक होने चाहिए';
  }

  @override
  String validationMaxDigits(String field, int count) {
    return '$field में अधिकतम $count अंक होने चाहिए';
  }

  @override
  String validationNumeric(String field) {
    return '$field में केवल अंक होने चाहिए';
  }

  @override
  String validationMinimumCharacters(int count) {
    return 'कम से कम $count अक्षर';
  }

  @override
  String get validationValidEmail => 'सही ईमेल पता दर्ज करें';

  @override
  String get validationValidNumber => 'सही संख्या दर्ज करें';

  @override
  String get validationNonnegativeCredits => 'क्रेडिट ऋणात्मक नहीं हो सकते';

  @override
  String get validationConfirmPassword => 'कृपया पासवर्ड की पुष्टि करें';

  @override
  String get validationPasswordsMismatch => 'पासवर्ड मेल नहीं खाते';

  @override
  String get validationStandardVin =>
      'VIN में 17 अक्षर और अंक होने चाहिए; I, O, Q मान्य नहीं हैं';

  @override
  String get validationVinAlphanumeric =>
      'VIN में केवल अक्षर और अंक होने चाहिए';

  @override
  String get validationThisField => 'यह फ़ील्ड';

  @override
  String get validationFieldSimNumber => 'SIM नंबर';

  @override
  String get mobileDataBackup => 'डेटा बैकअप';

  @override
  String get mobileEffectiveRetention => 'लागू डेटा संरक्षण अवधि';

  @override
  String get mobileAdministratorLimit => 'व्यवस्थापक की सीमा';

  @override
  String get mobilePolicySource => 'नीति का स्रोत';

  @override
  String mobileUseAdministratorPolicy(String value1) {
    return 'व्यवस्थापक की नीति इस्तेमाल करें ($value1)';
  }

  @override
  String get mobileRetentionCleanupNotice =>
      'निर्धारित सफाई में संरक्षण अवधि से पुराने ट्रैकिंग डेटा हटा दिए जाते हैं। अवधि बढ़ाने से हटाया गया डेटा वापस नहीं आता।';

  @override
  String mobileRetentionLimitError(String value1) {
    return 'डेटा संरक्षण अवधि $value1 दिनों से अधिक नहीं हो सकती।';
  }

  @override
  String get mobileRetentionLoadError => 'डेटा संरक्षण नीति लोड नहीं हो सकी';

  @override
  String get mobileRetentionSaveError => 'डेटा संरक्षण नीति सहेजी नहीं जा सकी';

  @override
  String get mobileRetentionSaved => 'डेटा संरक्षण नीति अपडेट हो गई';

  @override
  String get mobileRetentionUnsupported =>
      'सर्वर ने असमर्थित डेटा संरक्षण नीति भेजी है। संपादन बंद है।';

  @override
  String get mobileDiscardDetailChanges => 'बदलाव खो जाएंगे। जारी रखें?';

  @override
  String get mobileLiveTrackingReconnecting =>
      'लाइव ट्रैकिंग फिर से कनेक्ट हो रही है…';

  @override
  String get mobileLastConnection => 'पिछला कनेक्शन';

  @override
  String get mobileTeamLoadError => 'टीम सदस्य का विवरण लोड नहीं हो सका।';

  @override
  String get mobilePermissionsLoadError => 'अनुमतियाँ लोड नहीं हो सकीं।';

  @override
  String get mobileActivityLoadError => 'गतिविधि लोड नहीं हो सकी।';

  @override
  String get mobilePermissionsRetryError =>
      'अनुमतियाँ लोड या सहेजी नहीं जा सकीं। फिर से कोशिश करें।';

  @override
  String get mobilePermissionMaps => 'नक्शे';

  @override
  String get mobilePermissionLandmarks => 'स्थल चिह्न';

  @override
  String get mobilePermissionShareTracking => 'ट्रैकिंग लिंक साझा करें';

  @override
  String get mobilePrivacyPolicyLink => 'गोपनीयता नीति';

  @override
  String get mobilePageLinkError => 'यह पेज नहीं खुल सका। फिर से कोशिश करें।';
}
