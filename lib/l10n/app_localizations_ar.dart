// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get date => 'التاريخ';

  @override
  String get time => 'الوقت';

  @override
  String get direction => 'الاتجاه';

  @override
  String get units => 'الوحدات';

  @override
  String get appTitle => 'OpenVTS';

  @override
  String get settings => 'الإعدادات';

  @override
  String get localization => 'التوطين';

  @override
  String get language => 'اللغة';

  @override
  String get theme => 'المظهر';

  @override
  String get dateFormat => 'تنسيق التاريخ';

  @override
  String get timeFormat => 'تنسيق الوقت';

  @override
  String get timezone => 'المنطقة الزمنية';

  @override
  String get use24Hour => 'وقت 24 ساعة';

  @override
  String get save => 'حفظ';

  @override
  String get cancel => 'إلغاء';

  @override
  String get edit => 'تحرير';

  @override
  String get search => 'بحث';

  @override
  String get delete => 'حذف';

  @override
  String get reset => 'إعادة تعيين';

  @override
  String get close => 'إغلاق';

  @override
  String get back => 'رجوع';

  @override
  String get next => 'التالي';

  @override
  String get prev => 'السابق';

  @override
  String get loading => 'جاري التحميل...';

  @override
  String get error => 'خطأ';

  @override
  String get success => 'نجاح';

  @override
  String get warning => 'تحذير';

  @override
  String get light => 'فاتح';

  @override
  String get dark => 'داكن';

  @override
  String get system => 'النظام';

  @override
  String get en => 'الإنجليزية';

  @override
  String get hi => 'الهندية';

  @override
  String get ar => 'العربية';

  @override
  String get es => 'الإسبانية';

  @override
  String get fr => 'الفرنسية';

  @override
  String get pt => 'البرتغالية';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get register => 'التسجيل';

  @override
  String get administrators => 'المسؤولون';

  @override
  String get payments => 'المدفوعات';

  @override
  String get support => 'الدعم';

  @override
  String get tickets => 'التذاكر';

  @override
  String get home => 'الصفحة الرئيسية';

  @override
  String get dashboard => 'لوحة التحكم';

  @override
  String get keepEditing => 'مواصلة التحرير';

  @override
  String get discardChanges => 'تجاهل التغييرات';

  @override
  String get unsavedChanges => 'تغييرات غير محفوظة';

  @override
  String get refresh => 'تحديث';

  @override
  String get selectLanguage => 'اختر اللغة';

  @override
  String get selectTheme => 'اختر المظهر';

  @override
  String get selectDateFormat => 'اختر تنسيق التاريخ';

  @override
  String get selectTimeFormat => 'اختر تنسيق الوقت';

  @override
  String get selectTimezone => 'اختر المنطقة الزمنية';

  @override
  String previewDate(String date) {
    return 'معاينة: $date';
  }

  @override
  String previewTime(String time) {
    return 'معاينة: $time';
  }

  @override
  String get settingsUpdated => 'تم تحديث الإعدادات';

  @override
  String get profileUpdated => 'تم تحديث الملف الشخصي';

  @override
  String get localizationUpdated => 'تم تحديث إعدادات التوطين';

  @override
  String get failedToUpdate => 'فشل التحديث. يرجى المحاولة مرة أخرى.';

  @override
  String get noData => 'لا توجد بيانات متاحة';

  @override
  String get retry => 'إعادة محاولة';

  @override
  String get confirmDiscard => 'تجاهل التغييرات غير المحفوظة؟';

  @override
  String confirmDiscardMessage(String tab) {
    return '$tab يحتوي على تعديلات غير محفوظة. التجاهل سيفقدك هذه التغييرات.';
  }

  @override
  String get reportsTitle => 'تقارير';

  @override
  String get reportsSearchHint => 'بحث في التقارير…';

  @override
  String reportsNoResultsFor(Object query) {
    return 'لم يتم العثور على تقارير لـ \"$query\"';
  }

  @override
  String get reportsGenerate => 'إنشاء التقرير';

  @override
  String get reportsGenerating => 'جارٍ الإنشاء…';

  @override
  String get reportsReset => 'إعادة تعيين';

  @override
  String get reportsConfigureHint => 'قم بضبط التقرير أعلاه ثم اضغط إنشاء.';

  @override
  String get reportsNoResults => 'لا توجد نتائج للمرشحات المحددة.';

  @override
  String get reportsErrorRetry => 'إعادة المحاولة';

  @override
  String reportsRowCount(Object count) {
    return 'تم تحميل $count صف';
  }

  @override
  String get reportsLoadMore => 'تحميل المزيد';

  @override
  String get reportsLoadingMore => 'Loading more…';

  @override
  String reportsGeneratedAt(Object time) {
    return 'تم الإنشاء $time';
  }

  @override
  String get reportsExportTitle => 'تصدير التقرير';

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
  String get reportsScopeAll => 'جميع المركبات';

  @override
  String get reportsScopeSingle => 'مركبة واحدة';

  @override
  String get reportsScopeMultiple => 'مركبات متعددة';

  @override
  String get reportsScopeGroup => 'مجموعة';

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
  String get reportsCatalogDistanceTitle => 'المسافة';

  @override
  String get reportsCatalogDistanceDesc =>
      'Total distance driven per vehicle per day with engine hours and odometer readings.';

  @override
  String get reportsCatalogDrivenTitle => 'أيام القيادة';

  @override
  String get reportsCatalogDrivenDesc =>
      'Daily distance matrix — which vehicles moved on which days and how far.';

  @override
  String get reportsCatalogDetailsTitle => 'تفاصيل المركبة';

  @override
  String get reportsCatalogDetailsDesc =>
      'Fleet summary: total distance, engine hours, active days, last known location per vehicle.';

  @override
  String get reportsCatalogOverspeedTitle => 'تجاوز السرعة';

  @override
  String get reportsCatalogOverspeedDesc =>
      'Speeding events with observed speed, configured limit, excess, duration, and location.';

  @override
  String get reportsCatalogGeofenceTitle => 'السياج الجغرافي';

  @override
  String get reportsCatalogGeofenceDesc =>
      'Entry and exit events for selected geofences with timestamps and dwell duration.';

  @override
  String get reportsCatalogAlertsTitle => 'التنبيهات';

  @override
  String get reportsCatalogAlertsDesc =>
      'Alert events by type and severity with acknowledgement status.';

  @override
  String get reportsCatalogSensorTitle => 'المستشعر';

  @override
  String get reportsCatalogSensorDesc =>
      'Time-series readings for a specific sensor on a single vehicle with chart visualisation.';

  @override
  String get reportsCatalogLogsTitle => 'سجلات الجهاز';

  @override
  String get reportsCatalogLogsDesc =>
      'Raw communication logs from vehicle devices grouped by category and level.';

  @override
  String get reportsCatalogTimelineTitle => 'الجدول الزمني';

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
  String get adminRole => 'المشرف';

  @override
  String get users => 'المستخدمون';

  @override
  String get vehicles => 'المركبات';

  @override
  String get drivers => 'السائقون';

  @override
  String get team => 'الفريق';

  @override
  String get inventory => 'المخزون';

  @override
  String get map => 'الخريطة';

  @override
  String get transactions => 'المعاملات';

  @override
  String get calendar => 'التقويم';

  @override
  String get logs => 'السجلات';

  @override
  String get plans => 'الخطط';

  @override
  String get roles => 'الأدوار';

  @override
  String get smtp => 'SMTP';

  @override
  String get settingsDescription =>
      'إدارة الملف الشخصي والتوطين وإعدادات SMTP.';

  @override
  String get localizationDescription =>
      'اللغة والتاريخ والوقت والوحدات وتركيز الخريطة الافتراضي.';

  @override
  String get whiteLabel => 'التسمية البيضاء';

  @override
  String get saveChanges => 'حفظ التغييرات';

  @override
  String get textDirection => 'اتجاه النص';

  @override
  String get languageAndDirection => 'اللغة والاتجاه';

  @override
  String get languageAndDirectionSubtitle => 'لغة الواجهة واتجاه النص.';

  @override
  String get dateAndTime => 'التاريخ والوقت';

  @override
  String get dateAndTimeSubtitle =>
      'تنسيق التاريخ ونمط الوقت والمنطقة الزمنية.';

  @override
  String get unitsAndTheme => 'الوحدات والمظهر';

  @override
  String get unitsAndThemeSubtitle => 'وحدات المسافة ومظهر التطبيق.';

  @override
  String get defaultMapFocus => 'تركيز الخريطة الافتراضي';

  @override
  String get defaultMapFocusSubtitle => 'مركز الخريطة الأولي ومستوى التكبير.';

  @override
  String get couldNotLoadLocalization => 'تعذر تحميل التوطين.';

  @override
  String get localizationSaved => 'تم حفظ التوطين';

  @override
  String get quickPresets => 'الإعدادات المسبقة السريعة';

  @override
  String get settingsHeaderSubtitle =>
      'الملف الشخصي والعلامة التجارية والبريد والتوطين وتفضيلات المنصة.';

  @override
  String get localizationPreview => 'معاينة التوطين';

  @override
  String get latitude => 'خط العرض';

  @override
  String get longitude => 'خط الطول';

  @override
  String get mapZoom => 'تكبير الخريطة';

  @override
  String get mapCenter => 'مركز الخريطة';

  @override
  String get kilometers => 'كيلومترات';

  @override
  String get miles => 'أميال';

  @override
  String get latitudeRequired => 'خط العرض مطلوب.';

  @override
  String get validLatitude => 'أدخل خط عرض صالحًا.';

  @override
  String get latitudeRange => 'يجب أن يكون خط العرض بين -90 و90.';

  @override
  String get longitudeRequired => 'خط الطول مطلوب.';

  @override
  String get validLongitude => 'أدخل خط طول صالحًا.';

  @override
  String get longitudeRange => 'يجب أن يكون خط الطول بين -180 و180.';

  @override
  String get mapZoomRequired => 'تكبير الخريطة مطلوب.';

  @override
  String get validMapZoom => 'أدخل مستوى تكبير صالحًا.';

  @override
  String get mapZoomRange => 'يجب أن يكون تكبير الخريطة بين 1 و22.';

  @override
  String get unsupportedLanguageFallback =>
      'اللغة المحفوظة غير متاحة في التطبيق. اختر لغة مدعومة؛ تُستخدم الإنجليزية مؤقتًا.';
}
