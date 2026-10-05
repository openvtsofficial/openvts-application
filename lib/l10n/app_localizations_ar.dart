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
  String get reportsLoadingMore => 'جارٍ تحميل المزيد…';

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
  String get reportsScopeSelectVehicle => 'اختر مركبة';

  @override
  String get reportsScopeSelectVehicles => 'اختر المركبات';

  @override
  String get reportsScopeSelectGroup => 'اختر مجموعة';

  @override
  String get reportsScopeSearchHint => 'ابحث بالاسم أو اللوحة أو IMEI…';

  @override
  String get reportsScopeSelectAll => 'اختر كل العناصر الظاهرة';

  @override
  String get reportsScopeDone => 'تم';

  @override
  String reportsScopeNVehiclesSelected(Object count) {
    return 'تم اختيار $count مركبة';
  }

  @override
  String get reportsDateStart => 'تاريخ البدء';

  @override
  String get reportsDateEnd => 'تاريخ الانتهاء';

  @override
  String get reportsDateFrom => 'البداية';

  @override
  String get reportsDateTo => 'النهاية';

  @override
  String reportsDateMaxDays(Object days) {
    return 'الحد الأقصى لهذا التقرير $days يومًا';
  }

  @override
  String get reportsValidationScopeRequired =>
      'يرجى اختيار مركبة واحدة على الأقل.';

  @override
  String get reportsValidationStartRequired => 'تاريخ البدء مطلوب.';

  @override
  String get reportsValidationEndRequired => 'تاريخ الانتهاء مطلوب.';

  @override
  String get reportsValidationStartBeforeEnd => 'يجب أن تسبق البداية النهاية.';

  @override
  String reportsValidationMaxDays(Object days) {
    return 'الفترة تتجاوز حد هذا التقرير البالغ $days يومًا.';
  }

  @override
  String get reportsValidationSensorVehicleRequired =>
      'اختر مركبة لتقرير المستشعر.';

  @override
  String get reportsValidationSensorRequired => 'اختر مستشعرًا.';

  @override
  String get reportsValidationTimelineStateRequired =>
      'اختر حالة واحدة على الأقل (متحرك أو متوقف).';

  @override
  String get reportsFilterSpeedLimit => 'حد السرعة (كم/ساعة)';

  @override
  String get reportsFilterSpeedCustom => 'حد مخصص…';

  @override
  String get reportsFilterGeofenceHint => 'ابحث عن السياجات الجغرافية…';

  @override
  String get reportsFilterGeofenceAllNote =>
      'عدم الاختيار يشمل جميع السياجات الجغرافية.';

  @override
  String get reportsFilterAlertType => 'نوع التنبيه';

  @override
  String get reportsFilterAlertSeverity => 'الخطورة';

  @override
  String get reportsFilterAlertAck => 'الإقرار';

  @override
  String get reportsFilterAlertAckAll => 'الكل';

  @override
  String get reportsFilterAlertAckAcknowledged => 'تم الإقرار';

  @override
  String get reportsFilterAlertAckUnacknowledged => 'لم يتم الإقرار';

  @override
  String get reportsFilterLogsVehicle => 'المركبة';

  @override
  String get reportsFilterLogsCategory => 'الفئة';

  @override
  String get reportsFilterLogsLevel => 'المستوى';

  @override
  String get reportsFilterTimelineRunning => 'متحرك';

  @override
  String get reportsFilterTimelineStopped => 'متوقف';

  @override
  String get reportsFilterSensorVehicle => 'المركبة';

  @override
  String get reportsFilterSensorSensor => 'المستشعر';

  @override
  String get reportsCatalogDistanceTitle => 'المسافة';

  @override
  String get reportsCatalogDistanceDesc =>
      'إجمالي المسافة اليومية لكل مركبة مع ساعات المحرك وقراءات عداد المسافة.';

  @override
  String get reportsCatalogDrivenTitle => 'أيام القيادة';

  @override
  String get reportsCatalogDrivenDesc =>
      'جدول المسافات اليومية: المركبات التي تحركت والأيام والمسافات.';

  @override
  String get reportsCatalogDetailsTitle => 'تفاصيل المركبة';

  @override
  String get reportsCatalogDetailsDesc =>
      'ملخص الأسطول: المسافة وساعات المحرك وأيام النشاط وآخر موقع لكل مركبة.';

  @override
  String get reportsCatalogOverspeedTitle => 'تجاوز السرعة';

  @override
  String get reportsCatalogOverspeedDesc =>
      'تجاوزات السرعة مع السرعة المرصودة والحد والتجاوز والمدة والموقع.';

  @override
  String get reportsCatalogGeofenceTitle => 'السياج الجغرافي';

  @override
  String get reportsCatalogGeofenceDesc =>
      'دخول السياجات المختارة والخروج منها مع الوقت ومدة البقاء.';

  @override
  String get reportsCatalogAlertsTitle => 'التنبيهات';

  @override
  String get reportsCatalogAlertsDesc =>
      'التنبيهات حسب النوع والخطورة وحالة الإقرار.';

  @override
  String get reportsCatalogSensorTitle => 'المستشعر';

  @override
  String get reportsCatalogSensorDesc =>
      'قراءات زمنية لمستشعر محدد على مركبة واحدة مع رسم بياني.';

  @override
  String get reportsCatalogLogsTitle => 'سجلات الجهاز';

  @override
  String get reportsCatalogLogsDesc =>
      'سجلات الاتصال الخام لأجهزة المركبات حسب الفئة والمستوى.';

  @override
  String get reportsCatalogTimelineTitle => 'الجدول الزمني';

  @override
  String get reportsCatalogTimelineDesc =>
      'مقاطع الحركة والتوقف مع المدة والمسافة ومسار GPS لكل مقطع.';

  @override
  String get reportsKpiTotalDistance => 'إجمالي المسافة';

  @override
  String get reportsKpiEngineHours => 'ساعات المحرك';

  @override
  String get reportsKpiActiveVehicles => 'المركبات النشطة';

  @override
  String get reportsKpiAvgDistance => 'متوسط المسافة';

  @override
  String get reportsKpiVehiclesDriven => 'المركبات المتحركة';

  @override
  String get reportsKpiAvgDaily => 'المتوسط اليومي';

  @override
  String get reportsKpiPeakDay => 'يوم الذروة';

  @override
  String get reportsKpiViolations => 'المخالفات';

  @override
  String get reportsKpiAffectedVehicles => 'المركبات المتأثرة';

  @override
  String get reportsKpiHighestSpeed => 'أعلى سرعة';

  @override
  String get reportsKpiTotalDuration => 'إجمالي المدة';

  @override
  String get reportsKpiTotalEvents => 'إجمالي الأحداث';

  @override
  String get reportsKpiEntries => 'الدخول';

  @override
  String get reportsKpiExits => 'الخروج';

  @override
  String get reportsKpiTotalAlerts => 'إجمالي التنبيهات';

  @override
  String get reportsKpiCritical => 'حرج';

  @override
  String get reportsKpiAcknowledged => 'تم الإقرار';

  @override
  String get reportsKpiReadings => 'القراءات';

  @override
  String get reportsKpiOnEvents => 'أحداث التشغيل';

  @override
  String get reportsKpiOffEvents => 'أحداث الإيقاف';

  @override
  String get reportsKpiTotalLogs => 'إجمالي السجلات';

  @override
  String get reportsKpiRunningDuration => 'مدة الحركة';

  @override
  String get reportsKpiStoppedDuration => 'مدة التوقف';

  @override
  String get reportsKpiMovementDistance => 'مسافة الحركة';

  @override
  String get reportsKpiStopCount => 'عدد التوقفات';

  @override
  String get reportsDetailTitle => 'تفاصيل الصف';

  @override
  String get reportsDetailRawPayload => 'البيانات الخام';

  @override
  String get reportsDetailCopied => 'تم النسخ';

  @override
  String get reportsDetailCopy => 'نسخ';

  @override
  String get reportsDetailTruncated =>
      'اختُصرت البيانات للعرض. صدّر للاطلاع على البيانات كاملة.';

  @override
  String get reportsRowDetailsViewMap => 'عرض الخريطة';

  @override
  String get reportsRowDetailsHideMap => 'إخفاء الخريطة';

  @override
  String get reportsRowDetailsNoGps => 'لا توجد بيانات GPS لهذا المقطع.';

  @override
  String reportsWarningBanner(Object message) {
    return 'تحذير: $message';
  }

  @override
  String reportsSourceLabel(Object source) {
    return 'المصدر: $source';
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

  @override
  String homeWorkspace(Object role) {
    return 'مساحة عمل $role';
  }

  @override
  String get homeAccessUnavailable =>
      'تعذر تحديث صلاحيات مساحة العمل. اسحب لأسفل للمحاولة مجددًا.';

  @override
  String get homeCopyright => '© 2026 Open VTS جميع الحقوق محفوظة.';

  @override
  String get lightMode => 'الوضع الفاتح';

  @override
  String get darkMode => 'الوضع الداكن';

  @override
  String get landmarksStudio => 'إدارة المعالم';

  @override
  String get trackLinks => 'روابط التتبع';

  @override
  String get messages => 'الرسائل';

  @override
  String get accounts => 'الحسابات';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get operations => 'العمليات';

  @override
  String get server => 'الخادم';

  @override
  String get trips => 'الرحلات';

  @override
  String get documents => 'المستندات';

  @override
  String get userRole => 'مستخدم';

  @override
  String get subuserRole => 'مستخدم فرعي';

  @override
  String get driverRole => 'سائق';

  @override
  String get superadminRole => 'المشرف العام';

  @override
  String get demoReadOnly => 'عرض تجريبي • للقراءة فقط';

  @override
  String get security => 'الأمان';

  @override
  String get routeBuilderCreate => 'إنشاء مسار';

  @override
  String get routeBuilderEdit => 'تعديل المسار';

  @override
  String get routeBuilderName => 'اسم المسار';

  @override
  String get routeBuilderNameHint => 'مثل توصيلات الصباح';

  @override
  String get routeBuilderNameError => 'أدخل اسمًا للمسار من حرفين على الأقل.';

  @override
  String get routeBuilderStops => 'نقاط التوقف';

  @override
  String get routeBuilderAddStop => 'إضافة توقف';

  @override
  String get routeBuilderEditStop => 'تعديل التوقف';

  @override
  String get routeBuilderStopName => 'اسم التوقف';

  @override
  String get routeBuilderStopNameError =>
      'أدخل اسمًا من حرف واحد إلى 160 حرفًا.';

  @override
  String get routeBuilderAddress => 'العنوان (اختياري)';

  @override
  String get routeBuilderCoordinates => 'الإحداثيات';

  @override
  String get routeBuilderLatitude => 'خط العرض';

  @override
  String get routeBuilderLongitude => 'خط الطول';

  @override
  String get routeBuilderCoordinateError =>
      'أدخل خط عرض صحيحًا (−90 إلى 90) وخط طول صحيحًا (−180 إلى 180).';

  @override
  String get routeBuilderMap => 'اختر على الخريطة';

  @override
  String get routeBuilderMapHint => 'اضغط على الخريطة لاختيار موقع التوقف.';

  @override
  String get routeBuilderUseLocation => 'استخدام الموقع';

  @override
  String get routeBuilderPoi => 'نقطة اهتمام';

  @override
  String get routeBuilderGeofence => 'سياج جغرافي';

  @override
  String get routeBuilderLandmarkSearch => 'ابحث عن المعالم المحفوظة';

  @override
  String get routeBuilderNoLandmarks => 'لا توجد معالم مطابقة بإحداثيات صحيحة.';

  @override
  String get routeBuilderLandmarkError =>
      'تعذر تحميل المعالم المحفوظة. حاول مجددًا.';

  @override
  String get routeBuilderStopLimit =>
      'يمكن أن يحتوي المسار على 100 توقف كحد أقصى، بما في ذلك توقف العودة.';

  @override
  String get routeBuilderMinimumStops => 'أضف نقطتي توقف مختلفتين على الأقل.';

  @override
  String get routeBuilderRoundTrip => 'العودة إلى البداية';

  @override
  String get routeBuilderRoundTripHint => 'أضف نقطة البداية كوجهة نهائية.';

  @override
  String get routeBuilderOptimize => 'تحسين الترتيب';

  @override
  String get routeBuilderOptimizeHint =>
      'يعيد ترتيب التوقفات حسب المسافة الجغرافية مع إبقاء البداية والوجهة. تُحسب مسافة الطريق بشكل منفصل.';

  @override
  String get routeBuilderRoadPath => 'معاينة مسار الطريق';

  @override
  String get routeBuilderRouting => 'جارٍ حساب مسار القيادة…';

  @override
  String get routeBuilderRoutingError =>
      'لا يتوفر مسار قيادة. تحقق من مواقع التوقف أو الاتصال ثم حاول مجددًا.';

  @override
  String get routeBuilderReady => 'مسار القيادة جاهز';

  @override
  String get routeBuilderChanged =>
      'تغيّرت التوقفات. عاين المسار الجديد قبل الحفظ.';

  @override
  String get routeBuilderSaveError => 'تعذر حفظ المسار. حاول مجددًا.';

  @override
  String get routeBuilderAccessDenied =>
      'ليس لديك صلاحية إنشاء المسارات أو تعديلها.';

  @override
  String get routeBuilderOrigin => 'البداية';

  @override
  String get routeBuilderDestination => 'الوجهة';

  @override
  String get routeBuilderWaypoint => 'توقف';

  @override
  String get routeBuilderShapePoint => 'شكل المسار';

  @override
  String get routeBuilderMoveUp => 'نقل للأمام';

  @override
  String get routeBuilderMoveDown => 'نقل للخلف';

  @override
  String get routeBuilderRemove => 'إزالة التوقف';

  @override
  String get routeBuilderNoStops =>
      'أضف البداية والوجهة ثم التوقفات على الطريق.';

  @override
  String get routeBuilderSavedGeometry => 'مسار الطريق المحفوظ';

  @override
  String get routeBuilderEditingLoadError =>
      'تعذر تحميل المسار الكامل. ارجع وحاول مجددًا.';

  @override
  String get routeBuilderDiscardTitle => 'تجاهل تعديلات المسار؟';

  @override
  String get routeBuilderDiscardMessage => 'ستفقد تعديلات المسار غير المحفوظة.';

  @override
  String get routeBuilderDiscard => 'تجاهل';

  @override
  String get routeBuilderKeepEditing => 'متابعة التعديل';

  @override
  String get routeBuilderClose => 'إغلاق';

  @override
  String get routeBuilderRetry => 'حاول مجددًا';

  @override
  String get routeBuilderMapAttribution =>
      '© مساهمو OpenStreetMap · التوجيه: OSRM';

  @override
  String get routeBuilderRouteDetails => 'تفاصيل المسار';

  @override
  String get routeBuilderMinutes => 'دقيقة';

  @override
  String get routeBuilderDistanceUnit => 'كم';

  @override
  String get routeBuilderChooseSource => 'أضف توقفًا من';

  @override
  String get routeBuilderLandmarksPermission =>
      'تحتاج المعالم المحفوظة إلى صلاحية المعالم.';

  @override
  String get routeBuilderShapeHint =>
      'نقاط الشكل توجه مسار الطريق وليست توقفات توصيل. يزيل التحسين نقاط الشكل.';

  @override
  String get routeBuilderGeofenceHint =>
      'يستخدم مركز السياج الجغرافي. تأكد من إمكانية الوصول إليه بالطريق.';

  @override
  String selectField(Object field) {
    return 'اختر $field';
  }

  @override
  String searchField(Object field) {
    return 'ابحث في $field';
  }

  @override
  String noMatchingField(Object field) {
    return 'لا توجد نتائج مطابقة في $field';
  }

  @override
  String fieldRequired(Object field) {
    return '$field مطلوب.';
  }

  @override
  String get clearSelection => 'مسح';

  @override
  String get clearSearch => 'مسح البحث';

  @override
  String get noResults => 'لا توجد نتائج';

  @override
  String get select => 'اختر';

  @override
  String get unableToLoad => 'تعذر التحميل';

  @override
  String get mobileApiToken => 'رمز API';

  @override
  String get mobileTokenOnce =>
      'يظهر هذا الرمز مرة واحدة فقط. احفظه بأمان؛ يمكن لحامله استخدام صلاحيات API المحددة.';

  @override
  String get mobileSaveRecovery => 'احفظ رموز الاسترداد';

  @override
  String get mobileRecoveryHelp =>
      'يعمل كل رمز مرة واحدة عند فقدان تطبيق المصادقة. تحل هذه الرموز محل السابقة. احفظها في مكان آمن.';

  @override
  String get mobileCopiedSecurely => 'تم النسخ. احفظه بأمان.';

  @override
  String get mobileSavedSecurely => 'لقد حفظته بأمان';

  @override
  String get mobileDone => 'تم';

  @override
  String get mobileRevokeTokenQuestion => 'إلغاء رمز API؟';

  @override
  String mobileTokenStops(Object name) {
    return 'سيتوقف $name عن العمل فورًا.';
  }

  @override
  String get mobileRevoke => 'إلغاء';

  @override
  String get mobileMfa => 'المصادقة متعددة العوامل';

  @override
  String get mobileMfaOn => 'المصادقة متعددة العوامل مفعّلة';

  @override
  String get mobileMfaOff => 'المصادقة متعددة العوامل متوقفة';

  @override
  String get mobileMfaHelp => 'احمِ تسجيل الدخول باستخدام تطبيق المصادقة.';

  @override
  String get mobileSecuritySessions =>
      'تُنهي تغييرات الأمان الجلسات الأخرى وتُلغي رموز API الحالية.';

  @override
  String mobileAddedDate(Object date) {
    return 'أُضيف في $date';
  }

  @override
  String get mobileRemoveAuthenticator => 'إزالة تطبيق المصادقة';

  @override
  String get mobileAddAuthenticator => 'إضافة تطبيق مصادقة';

  @override
  String get mobileSetupMfa => 'إعداد المصادقة متعددة العوامل';

  @override
  String mobileRecoveryRemaining(Object count) {
    return '$count رمز استرداد غير مستخدم';
  }

  @override
  String get mobileReplaceRecovery => 'استبدال رموز الاسترداد';

  @override
  String get mobileTurnOffMfa => 'إيقاف المصادقة متعددة العوامل';

  @override
  String get mobileApiAccess => 'الوصول إلى API';

  @override
  String get mobileApiHelp =>
      'أنشئ بيانات اعتماد للتكاملات باستخدام صلاحيات حسابك.';

  @override
  String get mobileReadWrite => 'قراءة وكتابة';

  @override
  String get mobileReadOnly => 'قراءة فقط';

  @override
  String get mobileExpires => 'ينتهي';

  @override
  String get mobileInactive => 'غير نشط';

  @override
  String get mobileRevokeToken => 'إلغاء الرمز';

  @override
  String get mobileCreateToken => 'إنشاء رمز API';

  @override
  String get mobileDeleteAccount => 'حذف الحساب';

  @override
  String get mobileDeleteWorkspaceHelp =>
      'احذف حسابك والوصول إلى مساحة العمل، بما في ذلك المستخدمون الفرعيون. ستنتهي جميع الجلسات. لا يمكن التراجع عن هذا الإجراء في التطبيق.';

  @override
  String get mobileDeleteSelfHelp =>
      'احذف حسابك وأنهِ جلساته. لا يمكن التراجع عن هذا الإجراء في التطبيق.';

  @override
  String get mobileDeleteMyAccount => 'حذف حسابي';

  @override
  String get mobilePasswordOnly =>
      'لن يتطلب تسجيل الدخول لاحقًا سوى كلمة المرور.';

  @override
  String get mobileRecoveryReplaced =>
      'ستتوقف رموز الاسترداد السابقة عن العمل.';

  @override
  String get mobileTokenName => 'اسم الرمز';

  @override
  String get mobileAuthenticatorName => 'اسم تطبيق المصادقة';

  @override
  String get mobileEnterName => 'أدخل اسمًا.';

  @override
  String get mobileAccess => 'الوصول';

  @override
  String get mobileExpiresAfter => 'ينتهي بعد';

  @override
  String mobileDays(Object count) {
    return '$count يومًا';
  }

  @override
  String get mobileCurrentPassword => 'كلمة المرور الحالية';

  @override
  String get mobileEnterPassword => 'أدخل كلمة المرور.';

  @override
  String get mobileAuthenticatorOrRecovery => 'رمز المصادقة أو الاسترداد';

  @override
  String get mobileEnterVerification => 'أدخل رمز التحقق.';

  @override
  String get mobileDeleteConfirmation =>
      'أفهم أنه سيتم حذف حسابي والوصول إلى مساحة العمل.';

  @override
  String get mobileContinue => 'متابعة';

  @override
  String get mobileSixDigits => 'أدخل الأرقام الستة كاملة.';

  @override
  String get mobileConnectAuthenticator => 'اربط تطبيق المصادقة';

  @override
  String get mobileScanQrHelp =>
      'امسح رمز QR من جهاز آخر أو انسخ مفتاح الإعداد إلى تطبيق المصادقة. تنتهي صلاحية الإعداد خلال 10 دقائق.';

  @override
  String get mobileCopySetup => 'نسخ مفتاح الإعداد';

  @override
  String get mobileNewAuthenticatorCode => 'رمز تطبيق المصادقة الجديد';

  @override
  String get mobileVerifying => 'جارٍ التحقق…';

  @override
  String get mobileConfirm => 'تأكيد';

  @override
  String get mobileVerifySignIn => 'تحقق من تسجيل الدخول';

  @override
  String get mobileUnusedRecovery => 'أدخل أحد رموز الاسترداد غير المستخدمة.';

  @override
  String get mobileAuthenticatorInstructions =>
      'أدخل الرمز المكون من ستة أرقام من تطبيق المصادقة.';

  @override
  String get mobileRecoveryCode => 'رمز الاسترداد';

  @override
  String get mobileAuthenticatorCode => 'رمز المصادقة';

  @override
  String get mobileCompleteRecovery => 'أدخل رمز استرداد كاملًا.';

  @override
  String get mobileVerifyAndSignIn => 'التحقق وتسجيل الدخول';

  @override
  String get mobileUseAuthenticator => 'استخدام رمز المصادقة';

  @override
  String get mobileUseRecovery => 'استخدام رمز الاسترداد';

  @override
  String get mobileBackSignIn => 'العودة لتسجيل الدخول';

  @override
  String get mobileName => 'الاسم';

  @override
  String get mobileCallingCode => 'رمز الاتصال الدولي';

  @override
  String get mobileMobileNumber => 'رقم الجوال';

  @override
  String get mobileAddress => 'العنوان';

  @override
  String get mobileCountry => 'البلد';

  @override
  String get mobileState => 'الولاية / المقاطعة';

  @override
  String get mobileCity => 'المدينة';

  @override
  String get mobilePostcode => 'الرمز البريدي';

  @override
  String get mobileChangePassword => 'تغيير كلمة المرور';

  @override
  String get mobileRequired => 'هذا الحقل مطلوب.';

  @override
  String get mobileValidEmail => 'أدخل بريدًا إلكترونيًا صحيحًا بأحرف لاتينية.';

  @override
  String get mobilePasswordSessions =>
      'يؤدي تغيير كلمة المرور إلى إنهاء جميع جلساتك.';

  @override
  String get mobileNewPassword => 'كلمة المرور الجديدة';

  @override
  String get mobilePasswordCharacters => 'استخدم من 6 إلى 72 حرفًا لاتينيًا.';

  @override
  String get mobileDifferentPassword => 'اختر كلمة مرور مختلفة.';

  @override
  String get mobileConfirmPassword => 'تأكيد كلمة المرور الجديدة';

  @override
  String get mobilePasswordMismatch => 'كلمتا المرور غير متطابقتين.';

  @override
  String get mobileChangesSaved => 'تم حفظ التغييرات';

  @override
  String get mobileLanguageCodeHelp => 'أدخل رمز لغة مثل en أو hi.';

  @override
  String get mobileReload => 'إعادة التحميل';

  @override
  String get mobileEnterYourName => 'أدخل اسمك.';

  @override
  String get mobileEnterCallingCode => 'أدخل رمز الاتصال.';

  @override
  String get mobileValidMobile => 'أدخل رقم جوال صحيحًا.';

  @override
  String get mobileSaveProfile => 'حفظ الملف الشخصي';

  @override
  String get mobileDisplayPreferences => 'تفضيلات العرض';

  @override
  String get mobileDateFormat => 'تنسيق التاريخ';

  @override
  String get mobileTimeFormat => 'تنسيق الوقت';

  @override
  String get mobileDistanceUnit => 'وحدة المسافة';

  @override
  String get mobileTextDirection => 'اتجاه النص';

  @override
  String get mobileTimeOffset => 'فرق المنطقة الزمنية';

  @override
  String get mobileLanguageCode => 'رمز اللغة';

  @override
  String get mobileSavePreferences => 'حفظ التفضيلات';

  @override
  String get mobileProofAccountChanged =>
      'تغيّر الوصول إلى الحساب. أعد فتح إثبات الرحلة.';

  @override
  String get mobileActivity => 'النشاط';

  @override
  String get mobileAllStatuses => 'كل الحالات';

  @override
  String get mobileApproximateRoute => 'تسلسل تقريبي • توقفات مرقمة';

  @override
  String get mobileAttention => 'تنبيه';

  @override
  String get mobileChooseRoute => 'اختر مسارًا';

  @override
  String get mobileValidSchedule => 'اختر جدولًا صالحًا.';

  @override
  String get mobileValidStartTime => 'اختر وقت بدء صالحًا.';

  @override
  String get mobileChooseVehicle => 'اختر مركبة';

  @override
  String get mobileChooseVehicleRoute => 'اختر مركبة ومسارًا.';

  @override
  String get mobileChooseEligibleVehicle => 'اختر مركبة مؤهلة';

  @override
  String get mobileEndDateAfterStart =>
      'اختر تاريخ انتهاء في يوم البدء أو بعده.';

  @override
  String get mobileChooseWeekday => 'اختر يومًا واحدًا على الأقل من الأسبوع.';

  @override
  String get mobileChooseDate => 'اختر التاريخ';

  @override
  String get mobileChooseDateRange => 'اختر الفترة';

  @override
  String get mobileChooseDay => 'اختر اليوم';

  @override
  String get mobileMultiDayHelp =>
      'اختر تاريخ ووقت البدء والانتهاء لرحلة متعددة الأيام.';

  @override
  String get mobileFutureDate => 'اختر اليوم أو تاريخًا لاحقًا.';

  @override
  String get mobileCompleted => 'مكتمل';

  @override
  String get mobileCompletionAfterStart => 'يجب أن يكون الانتهاء بعد البدء.';

  @override
  String get mobileCreateRouteFirst => 'أنشئ مسارًا لبدء التخطيط.';

  @override
  String get mobileCreateSchedule => 'إنشاء جدول';

  @override
  String get mobileCreateTrip => 'إنشاء رحلة';

  @override
  String get mobileDeleteSchedule => 'حذف الجدول';

  @override
  String get mobileDiscardChanges => 'تجاهل التغييرات';

  @override
  String get mobileDiscardTrip => 'تجاهل تعديلات الرحلة؟';

  @override
  String get mobileEditRecurring => 'تعديل الجدول المتكرر';

  @override
  String get mobileEditSchedule => 'تعديل الجدول';

  @override
  String get mobileEndDate => 'تاريخ الانتهاء';

  @override
  String get mobileEndSchedule => 'إنهاء الجدول';

  @override
  String get mobileEndTime => 'وقت الانتهاء';

  @override
  String get mobileEndTimeAfterStart =>
      'يجب أن يكون وقت الانتهاء بعد وقت البدء.';

  @override
  String get mobileEndsOptional => 'ينتهي (اختياري)';

  @override
  String get mobileTripTitleLength => 'أدخل عنوانًا من 2 إلى 120 حرفًا.';

  @override
  String get mobileAtLeastTwo => 'أدخل حرفين على الأقل';

  @override
  String get mobileAtLeastThree => 'أدخل 3 أحرف على الأقل';

  @override
  String get mobileExpandRoute => 'تكبير خريطة المسار';

  @override
  String get mobileFitRoute => 'إظهار المسار كاملًا';

  @override
  String get mobileNoGpsPlanning =>
      'GPS غير مرتبط. يمكن تخطيط الرحلة، لكن التتبع المباشر لن يتوفر.';

  @override
  String get mobileKeepEditing => 'متابعة التعديل';

  @override
  String get mobileKeepSchedule => 'الإبقاء على الجدول';

  @override
  String get mobileLastKnownPosition => 'آخر موقع معروف للمركبة';

  @override
  String get mobileLatestStart => 'آخر وقت للبدء';

  @override
  String get mobileNextMonth => 'الشهر التالي';

  @override
  String get mobileNoEligible => 'لا توجد مركبة مؤهلة متاحة.';

  @override
  String get mobileNoEligibleHelp =>
      'لا توجد مركبة مؤهلة. عيّن سائقًا نشطًا لمركبة نشطة قبل التخطيط.';

  @override
  String get mobileNoRecordsView => 'لا توجد سجلات لهذا العرض.';

  @override
  String get mobileNoRouteGps => 'لا يتوفر مسار أو إحداثيات GPS لهذه الرحلة.';

  @override
  String get mobileStopsWithoutGeometry => 'توقفات مرقمة • شكل المسار غير متاح';

  @override
  String get mobilePause => 'إيقاف مؤقت';

  @override
  String get mobilePlanTrip => 'تخطيط رحلة';

  @override
  String get mobilePlannedNumbered => 'مسار مخطط • توقفات مرقمة';

  @override
  String get mobilePreviousMonth => 'الشهر السابق';

  @override
  String get mobileReasonRemark => 'السبب / الملاحظة';

  @override
  String get mobileRecurring => 'متكرر';

  @override
  String get mobileRecurringSchedule => 'جدول متكرر';

  @override
  String get mobileRecurringActions => 'إجراءات الجدول المتكرر';

  @override
  String get mobileRefreshPlanning => 'تحديث خيارات التخطيط';

  @override
  String get mobileRefreshSchedule => 'حدّث هذا الجدول قبل تعديله.';

  @override
  String get mobileRemarkOptional => 'ملاحظة (اختياري)';

  @override
  String get mobileRemoveEndDate => 'إزالة تاريخ الانتهاء';

  @override
  String get mobileRepeatOn => 'التكرار في';

  @override
  String get mobileResume => 'استئناف';

  @override
  String get mobileRoute => 'المسار';

  @override
  String get mobileRunning => 'جارٍ';

  @override
  String get mobileSaveShareProof => 'حفظ الإثبات أو مشاركته';

  @override
  String get mobileSaveSchedule => 'حفظ الجدول';

  @override
  String get mobileSchedule => 'الجدول';

  @override
  String get mobileScheduleSaved => 'تم حفظ الجدول';

  @override
  String get mobileSearchRoutes => 'البحث في المسارات';

  @override
  String get mobileSearchVehicleDriver => 'ابحث بالمركبة أو اللوحة أو السائق';

  @override
  String get mobileSkipDates => 'تواريخ مستثناة (اختياري)';

  @override
  String get mobileSkipDatesRange =>
      'يجب أن تكون التواريخ المستثناة ضمن فترة الجدول.';

  @override
  String get mobileStartTime => 'وقت البدء';

  @override
  String get mobileStarts => 'يبدأ';

  @override
  String get mobileStatus => 'الحالة';

  @override
  String get mobileSubmittedProofs => 'الإثباتات المقدمة';

  @override
  String get mobileAnyTimeDay => 'يمكن للسائق البدء في أي وقت من اليوم المحدد.';

  @override
  String get mobileStartWindowHelp =>
      'يمكن للسائق البدء ضمن هذه الفترة. نهاية الفترة ليست موعد انتهاء الرحلة.';

  @override
  String get mobileRequestFailed => 'تعذر إكمال الطلب. حدّث وحاول مجددًا.';

  @override
  String get mobileRouteUnavailable =>
      'المسار المحفوظ غير متاح للتخطيط. حدّث المسارات وحاول مجددًا.';

  @override
  String get mobileAccountTimeHelp =>
      'تبدأ الرحلة في وقت محدد حسب المنطقة الزمنية للحساب.';

  @override
  String get mobilePdfPreviewFailed =>
      'تعذرت معاينة PDF. استخدم الحفظ أو المشاركة لفتحه في تطبيق آخر.';

  @override
  String get mobileImagePreviewFailed =>
      'تعذرت معاينة الصورة. استخدم الحفظ أو المشاركة لفتحها في تطبيق آخر.';

  @override
  String get mobileToday => 'اليوم';

  @override
  String get mobileTripCreated => 'تم إنشاء الرحلة';

  @override
  String get mobileTripDetails => 'تفاصيل الرحلة';

  @override
  String get mobileTripRoute => 'مسار الرحلة';

  @override
  String get mobileTripTitle => 'عنوان الرحلة';

  @override
  String get mobileProofShareFailed => 'تعذرت مشاركة الإثبات. حاول مجددًا.';

  @override
  String get mobileUnavailableVehicles => 'مركبات غير متاحة';

  @override
  String get mobileMaxSkipDates => 'استخدم 100 تاريخ مستثنى كحد أقصى';

  @override
  String get mobileRemarkLength => 'استخدم 600 حرف كحد أقصى للملاحظة.';

  @override
  String get mobileValidDates => 'استخدم تواريخ صحيحة بتنسيق YYYY-MM-DD';

  @override
  String get mobileVehicleGpsPosition => 'موقع GPS للمركبة';

  @override
  String get mobileVehicleDriver => 'المركبة والسائق';

  @override
  String get mobileVehicleRoute => 'المركبة والمسار';

  @override
  String get mobileViewTrip => 'عرض الرحلة';

  @override
  String get mobileDatesPerLine => 'YYYY-MM-DD، تاريخ واحد في كل سطر';

  @override
  String get mobileDiscardPlanningHelp =>
      'ستفقد تعديلات التخطيط غير المحفوظة. ستظل المسارات المحفوظة متاحة.';

  @override
  String mobileTimesTimezone(Object timezone) {
    return 'الأوقات حسب $timezone.';
  }

  @override
  String mobileStopsCount(Object count) {
    return '$count توقفات';
  }

  @override
  String mobileTripsCount(Object count) {
    return '$count رحلات';
  }

  @override
  String mobileLoadMoreCount(Object loaded, Object total) {
    return 'تحميل المزيد ($loaded من $total)';
  }

  @override
  String mobileScheduledDate(Object date) {
    return 'مجدول: $date';
  }

  @override
  String mobileEndsDate(Object date) {
    return 'ينتهي: $date';
  }

  @override
  String mobileNextDate(Object date) {
    return 'التالي: $date';
  }

  @override
  String mobileGpsStatus(Object status) {
    return 'GPS المركبة: $status';
  }

  @override
  String mobileLastPosition(Object date) {
    return 'آخر موقع: $date';
  }

  @override
  String mobileActualDistance(Object distance) {
    return 'المسافة الفعلية: $distance كم';
  }

  @override
  String mobileTripScore(Object value) {
    return 'تقييم الرحلة: $value';
  }

  @override
  String mobileStopsProgress(Object completed, Object total) {
    return '$completed/$total توقفات';
  }

  @override
  String mobileScheduleAction(Object action) {
    return '$action الجدول المتكرر؟';
  }

  @override
  String get dateRangeSelect => 'اختر الفترة';

  @override
  String get dateRangeChoose => 'اختر الفترة';

  @override
  String get dateTimeRangeChoose => 'اختر فترة التاريخ والوقت';

  @override
  String get dateRangeFrom => 'من';

  @override
  String get dateRangeTo => 'إلى';

  @override
  String get dateRangeSelected => 'الفترة المختارة';

  @override
  String get dateRangeStartTime => 'وقت البدء';

  @override
  String get dateRangeEndTime => 'وقت الانتهاء';

  @override
  String get dateRangeSelectStartTime => 'اختر وقت البدء';

  @override
  String get dateRangeSelectEndTime => 'اختر وقت الانتهاء';

  @override
  String get dateRangeInvalidTime => 'يجب أن يكون وقت الانتهاء بعد وقت البدء.';

  @override
  String get dateRangeCustom => 'مخصص';

  @override
  String get dateRangeLastHour => 'الساعة الماضية';

  @override
  String get dateRangeLast3Hours => 'آخر 3 ساعات';

  @override
  String get dateRangeLast6Hours => 'آخر 6 ساعات';

  @override
  String get dateRangeLast12Hours => 'آخر 12 ساعة';

  @override
  String get dateRangeLast24Hours => 'آخر 24 ساعة';

  @override
  String get dateRangeToday => 'اليوم';

  @override
  String get dateRangeYesterday => 'أمس';

  @override
  String get dateRangeThisWeek => 'هذا الأسبوع';

  @override
  String get dateRangeLastWeek => 'الأسبوع الماضي';

  @override
  String get dateRangeLast7Days => 'آخر 7 أيام';

  @override
  String get dateRangeLast30Days => 'آخر 30 يومًا';

  @override
  String get apply => 'تطبيق';

  @override
  String get calendarToday => 'اليوم';

  @override
  String get calendarPreviousMonth => 'الشهر السابق';

  @override
  String get calendarNextMonth => 'الشهر التالي';

  @override
  String get calendarExpiry => 'الانتهاء';

  @override
  String get legacyUi869d62ddcd => ' لتفعيل الزر.';

  @override
  String get legacyUi7f4f41c8c3 => '#RRGGBB';

  @override
  String get legacyUi9515360684 => '+ إضافة جهاز جديد';

  @override
  String get legacyUi6116c134de => '+ إنشاء خطة جديدة';

  @override
  String get legacyUic10e9a1c41 => '+ إنشاء مستخدم جديد';

  @override
  String get legacyUi5e9a7040e4 => 'رقمان';

  @override
  String get legacyUia0483eec37 => '3 أرقام';

  @override
  String get legacyUi3994dbd48e => 'من 6 إلى 35 حرفًا';

  @override
  String get legacyUi250e268e83 => 'من 7 إلى 15 رقمًا';

  @override
  String get legacyUie69a9a5ee9 => 'الاستخدام خلال 7 أيام';

  @override
  String get legacyUib8cee60c75 =>
      'يمكن للمستخدم الفرعي استخدام الميزات والتقارير المتاحة لحسابك فقط. تظل الإعدادات وأمان الحساب متاحين.';

  @override
  String get legacyUif0ee13e963 => 'الوصول مقيّد';

  @override
  String get legacyUi6e702cb4e0 => 'حالة الحساب';

  @override
  String get legacyUi6d6eba9279 => 'الوصول إلى الحساب';

  @override
  String get legacyUi82cf8a5fc7 => 'إعدادات الحساب';

  @override
  String get legacyUi9beb96dac8 => 'تأكيد الاطلاع';

  @override
  String get legacyUibf539b1d10 => 'Acme Logistics Pvt. Ltd.';

  @override
  String get legacyUic3cd636a58 => 'الإجراءات';

  @override
  String get legacyUia733b809d2 => 'نشط';

  @override
  String get legacyUi15cf579b89 => 'مدة النشاط';

  @override
  String get legacyUifaa171bc07 => 'المركبة النشطة';

  @override
  String get legacyUibde34d0278 => 'حالة النشاط';

  @override
  String get legacyUi14c5b09cd4 => 'تفاصيل النشاط';

  @override
  String get legacyUifbed23bc25 => 'سجلات النشاط';

  @override
  String get legacyUie35effbf63 => 'الفترة الزمنية للنشاط';

  @override
  String get legacyUicbd19b5c39 => 'منفّذ الإجراء';

  @override
  String get legacyUi7980ca2475 => 'المستخدم المنفّذ';

  @override
  String get legacyUi4ac5084db4 => 'إضافة جهاز أو شريحة SIM';

  @override
  String get legacyUiaa752d14b8 => 'إضافة سائق';

  @override
  String get legacyUi224f2486e6 => 'إضافة مخزون';

  @override
  String get legacyUi1836b111cd => 'إضافة صف بيانات وصفية';

  @override
  String get legacyUi31dd5bb29e => 'إضافة فريق جديد';

  @override
  String get legacyUi47b2149c9c => 'إضافة خطة';

  @override
  String get legacyUic08d1e9d3f => 'إضافة مستشعر';

  @override
  String get legacyUi12071f1c87 => 'أضف خطة جديدة أو غيّر البحث.';

  @override
  String get legacyUic0c181937e => 'إضافة خاصية';

  @override
  String get legacyUi5367d642e2 => 'إضافة أرصدة';

  @override
  String get legacyUi1fa55e4562 => 'إضافة صف بيانات وصفية';

  @override
  String get legacyUi7be087b7a7 => 'إضافة إثبات';

  @override
  String get legacyUib68734c259 => 'تمت الإضافة';

  @override
  String get legacyUi41b5f2e6ae => 'ملاحظات إضافية';

  @override
  String get legacyUid5e920a5cb => 'سطر العنوان';

  @override
  String get legacyUi7748043229 => 'العنوان والتفاصيل الجغرافية.';

  @override
  String get legacyUi4faa35048a => 'اكتمل طلب تسجيل دخول المسؤول.';

  @override
  String get legacyUi1eda23758b => 'المسؤول';

  @override
  String get legacyUi3df513225f => 'تم إنشاء المسؤول.';

  @override
  String get legacyUif981236722 => 'المركبات المتأثرة';

  @override
  String get legacyUib7fb586ff2 => 'مطار';

  @override
  String get legacyUi25f8c55de8 => 'إنذار';

  @override
  String get legacyUib5faca3a78 => 'نوع التنبيه';

  @override
  String get legacyUic03d80790d => 'جميع المسؤولين';

  @override
  String get legacyUi0b313a76be => 'جميع الدول';

  @override
  String get legacyUiffeed47b5a => 'جميع المزوّدين';

  @override
  String get legacyUi4745c5dce5 => 'كل الأوقات';

  @override
  String get legacyUieb672cb3ba => 'جميع الأنواع';

  @override
  String get legacyUib4f25a1426 => 'جميع المستخدمين';

  @override
  String get legacyUidd9eb32418 => 'جميع المركبات';

  @override
  String get legacyUi060be00f4f => 'جميع الفئات';

  @override
  String get legacyUi0aaede0bb1 => 'تم وضع علامة «مقروء» على جميع الإشعارات.';

  @override
  String get legacyUi30c8a0fc9c => 'جميع الأنواع';

  @override
  String get legacyUice832d9b31 => 'جميع المستخدمين';

  @override
  String get legacyUie512a2f10a => 'السماح بسجل المسارات';

  @override
  String get legacyUif8f993b052 => 'السماح بالوصول إلى سجل المسارات.';

  @override
  String get legacyUi1ffee134b1 =>
      'السماح للزوار بتسجيل الدخول إلى مساحة عمل تجريبية.';

  @override
  String get legacyUie5d30dc481 => 'النطاق المسموح: 10–300';

  @override
  String get legacyUi22786d42cc => 'الارتفاع';

  @override
  String get legacyUi43dc8532f7 => 'المبلغ';

  @override
  String get legacyUi76aa32f207 => 'المبلغ *';

  @override
  String get legacyUia01154a861 => 'تعديل المبلغ';

  @override
  String get legacyUi7d66157b06 => 'يجب أن يتراوح المبلغ بين 0.01 و9999999.99';

  @override
  String get legacyUib34440b2cd => 'تعديل المبلغ';

  @override
  String get legacyUib757c50159 => 'يدعم المبلغ منزلتين عشريتين كحد أقصى';

  @override
  String get legacyUic8c3ba95bb => 'ستظهر التحليلات عند توفّر المدفوعات.';

  @override
  String get legacyUif6c665f4fe => 'ستظهر التحليلات عند توفّر المعاملات.';

  @override
  String get legacyUi6b2a78a8f7 => 'تطبيق عوامل التصفية';

  @override
  String get legacyUi2444928438 => 'إسناد';

  @override
  String get legacyUi561f6317fe => 'إسناد سائق';

  @override
  String get legacyUi3d2183f9ae => 'إسناد العناصر المحددة';

  @override
  String get legacyUi5e97289597 => 'إسناد مستخدم';

  @override
  String get legacyUib8db201262 => 'إسناد مركبة';

  @override
  String get legacyUi20b5675c39 => 'إسناد مركبات';

  @override
  String get legacyUic403a13c66 =>
      'أسند مركبة واحدة أو أكثر إلى هذا المستخدم الفرعي.';

  @override
  String get legacyUie12261bf18 => 'أسند مستخدمين إلى هذا السائق.';

  @override
  String get legacyUi41c90cdeef => 'أسند مستخدمين إلى هذه المركبة.';

  @override
  String get legacyUi32265d6dad => 'أسند مركبات لإعداد الإشعارات الأساسية.';

  @override
  String get legacyUi117326ffd2 => 'أسند مركبات لإعداد إشعارات المدة.';

  @override
  String get legacyUi74dfd6593f =>
      'أسند مركبات لإعداد إشعارات السياج الجغرافي.';

  @override
  String get legacyUi8c6586176a => 'أسند مركبات لإعداد إشعارات تجاوز السرعة.';

  @override
  String get legacyUi086854873d => 'أسند مركبات لإعداد إشعارات المسارات.';

  @override
  String get legacyUie24e824b68 => 'مُسنَد';

  @override
  String get legacyUie94ba984c3 => 'المركبات المُسنَدة';

  @override
  String get legacyUie55df441e8 => 'الإسناد';

  @override
  String get legacyUi0c686b74d7 =>
      '5 أحرف على الأقل. تُسجَّل التغييرات للتدقيق.';

  @override
  String get legacyUi1afff0157c => 'إرفاق';

  @override
  String get legacyUi0c431f4969 => 'إرفاق ملف';

  @override
  String get legacyUi137135dbf6 => 'إرفاق ملفات';

  @override
  String get legacyUi2286866966 => 'رابط المرفق غير متاح.';

  @override
  String get legacyUib6b6277691 => 'مسار المرفق غير متاح.';

  @override
  String get legacyUi1b30607d41 => 'يجب أن تكون مفاتيح الخصائص فريدة.';

  @override
  String get legacyUia6652617f2 => 'الخصائص';

  @override
  String get legacyUi7c62a14244 => 'متاح';

  @override
  String get legacyUicdc93143c6 => 'المتوسط';

  @override
  String get legacyUib1ff8731de => 'متوسط السرعة';

  @override
  String get legacyUi3e6e9b59e4 => 'رموز وصول الخادم';

  @override
  String get legacyUib15950ccc9 => 'رموز وصول الخادم';

  @override
  String get legacyUief5c48114b => 'تم التحقق من الخادم';

  @override
  String get legacyUidd96994d01 => 'النسخ الاحتياطي';

  @override
  String get legacyUi775fe0e609 => 'النسخ الاحتياطي / الاحتفاظ بالبيانات';

  @override
  String get legacyUi17ef50d8f8 => 'تحويل بنكي';

  @override
  String get legacyUi1007a1a728 => 'مرجع البنك / UTR / معرّف المعاملة';

  @override
  String get legacyUi5be1ae92e8 =>
      'ملاحظة التحويل البنكي / UTR / مرجع المعاملة';

  @override
  String get legacyUi6b57349e97 => 'إعدادات عنوان URL الأساسي';

  @override
  String get legacyUiaa2c96dacf => 'أساسي';

  @override
  String get legacyUic73c27be48 => 'بيانات الحساب الأساسية لتسجيل دخول السائق.';

  @override
  String get legacyUi904d23cb6a => 'بيانات التعريف الأساسية للمركبة الجديدة.';

  @override
  String get legacyUi99613c74ce => 'محظور';

  @override
  String get legacyUi584522b903 => 'بيانات العلامة التجارية والتواصل';

  @override
  String get legacyUibfc8921ede => 'لون العلامة التجارية';

  @override
  String get legacyUi54a2cf5e63 => 'المتصفح';

  @override
  String get legacyUi73e0b16797 =>
      'أيقونة علامة تبويب المتصفح. ICO أو PNG أو SVG. الحد الأقصى 2 ميغابايت.';

  @override
  String get legacyUicfadbd7a57 => 'بواسطة';

  @override
  String get legacyUi42878ce3fa => 'استخدام المعالج';

  @override
  String get legacyUi37efa8a990 => 'مقهى';

  @override
  String get legacyUi26b937c51d => 'إلغاء طلب التجديد؟';

  @override
  String get legacyUi84837a2168 => 'إلغاء الطلب';

  @override
  String get legacyUi2738a0a1db => 'لا يمكن تحميل الأوامر دون تفاصيل المركبة.';

  @override
  String get legacyUi4d4ce73b15 => 'بطاقة';

  @override
  String get legacyUi758ec54e43 => 'نقدًا';

  @override
  String get legacyUi6ccb60071b => 'الفئات';

  @override
  String get legacyUi49289db43e => 'تغيير كلمة المرور';

  @override
  String get legacyUi6fc0529f2d => 'تغيير الحالة';

  @override
  String get legacyUica5df1dad1 => 'اختيار نطاق التاريخ والوقت';

  @override
  String get legacyUid2174d8075 => 'اختيار فترة إعادة العرض';

  @override
  String get legacyUi66542fe55c =>
      'اختر خطة وتاريخ تسجيل وسببًا من 5 إلى 500 حرف.';

  @override
  String get legacyUi7db804aa37 =>
      'اختر المركبات ووقت الانتهاء وخيارات المشاركة.';

  @override
  String get legacyUi037c5eba86 => 'المدينة (اختياري)';

  @override
  String get legacyUief153831d1 => 'المدينة مطلوبة.';

  @override
  String get legacyUi8da6bb0466 => 'اكتمل التنظيف';

  @override
  String get legacyUi381c4bf1d4 => 'مسح عوامل التصفية';

  @override
  String get legacyUicdb64ef80e => 'مسح النطاق الزمني';

  @override
  String get legacyUid3c69afc35 => 'مسح التواريخ';

  @override
  String get legacyUi1bf7452cd6 => 'مسح وقت الانتهاء';

  @override
  String get legacyUi40b66a41b8 => 'مسح تاريخ الانتهاء';

  @override
  String get legacyUi92e60a4db3 => 'مسح إعادة العرض';

  @override
  String get legacyUi53dde4f2c0 => 'ستظهر إيرادات العملاء بعد تسجيل المدفوعات.';

  @override
  String get legacyUide4e7f6fad => 'إغلاق القائمة الجانبية';

  @override
  String get legacyUi3dc631324c => 'إغلاق الخريطة';

  @override
  String get legacyUid75dc68bbd => 'تجميع';

  @override
  String get legacyUiadac69379a => 'الرمز';

  @override
  String get legacyUiea6ac41a6a => 'الرمز مطلوب.';

  @override
  String get legacyUi5b0f7590d0 => 'تم التحصيل';

  @override
  String get legacyUi8901895fb1 => 'الأمر';

  @override
  String get legacyUif7e08456d0 => 'تفاصيل الأمر';

  @override
  String get legacyUi6c4cb3de03 => 'نص الأمر';

  @override
  String get legacyUibfed234d46 => 'الأمر غير متاح';

  @override
  String get legacyUi45e5f3f72e => 'الأوامر';

  @override
  String get legacyUi7a1994999d => 'الشركة';

  @override
  String get legacyUi8599f5cc48 => 'اسم الشركة';

  @override
  String get legacyUi1e5f7dc45c => 'اسم الشركة';

  @override
  String get legacyUib55887f633 => 'تم تحديث الشركة';

  @override
  String get legacyUi657063c67c => 'تم تحديث الشركة.';

  @override
  String get legacyUif1ab0a6f4e => 'إكمال يدوي';

  @override
  String get legacyUif14ebb39ce => 'إصدار الإعدادات';

  @override
  String get legacyUi755bea99c0 => 'تم تحديث الإعدادات.';

  @override
  String get legacyUic69463a5a9 => 'إعداد إرسال البريد الصادر.';

  @override
  String get legacyUic2d404cb7b => 'تأكيد كلمة المرور';

  @override
  String get legacyUiea3723a45c => 'تأكيد توسيع صلاحيات الوصول';

  @override
  String get legacyUi4a7c565d4c => 'تأكيد كلمة المرور';

  @override
  String get legacyUi5febc18b54 => 'تأكيد الدفع';

  @override
  String get legacyUi05a7fffae1 => 'تأكيد استلام الدفع';

  @override
  String get legacyUi90d96c7cec => 'عبارة التأكيد';

  @override
  String get legacyUic2f9b7b489 => 'متصل';

  @override
  String get legacyUib37456c453 => 'جهة الاتصال';

  @override
  String get legacyUicc11b3a28f => 'السياق';

  @override
  String get legacyUi3cf29aa7f5 => 'خمول مستمر';

  @override
  String get legacyUic352b92e1f => 'حركة مستمرة';

  @override
  String get legacyUi347d3dbf17 => 'توقف مستمر';

  @override
  String get legacyUi49fdb038f4 => 'تحكّم فيما يمكن للمشاهدين رؤيته.';

  @override
  String get legacyUi02c6c04dec => 'نسخ KML';

  @override
  String get legacyUi44fe06869f => 'نسخ الترويسة';

  @override
  String get legacyUi3a9d77c901 => 'تعذّر فتح عنوان URL';

  @override
  String get legacyUi0c09a7eccc => 'تعذّر فتح المرفق.';

  @override
  String get legacyUif2344997aa => 'تعذّر فتح المستند.';

  @override
  String get legacyUi2209ab63ce => 'تعذّر فتح الملف.';

  @override
  String get legacyUi5905ce4109 => 'تعذّر فتح الملف. تم نسخ الرابط.';

  @override
  String get legacyUi9b09f53bdd => 'تعذّر فتح الرابط.';

  @override
  String get legacyUi72be0e8616 => 'تعذّر اختيار الملف';

  @override
  String get legacyUi76e835f8c3 => 'تعذّر اختيار الملف.';

  @override
  String get legacyUiaef46d6729 => 'تعذّرت قراءة الملف المحدد';

  @override
  String get legacyUi280c98ccef => 'تصفية حسب الدولة';

  @override
  String get legacyUi1c9a9315c9 => 'الدولة مطلوبة.';

  @override
  String get legacyUid82b56cad9 => 'اتجاه الحركة';

  @override
  String get legacyUi6e157c5da4 => 'إنشاء';

  @override
  String get legacyUi318d1da4e0 => 'إنشاء مسؤول';

  @override
  String get legacyUi0a62dd4d37 => 'إنشاء سائق';

  @override
  String get legacyUie3429ab78d => 'إنشاء سياج جغرافي';

  @override
  String get legacyUidb7c457634 => 'إنشاء نقطة اهتمام';

  @override
  String get legacyUicdd060d443 => 'إنشاء خطة تسعير';

  @override
  String get legacyUi5d16c5ffd7 => 'إنشاء مستخدم فرعي';

  @override
  String get legacyUiafe9a7ae15 => 'إنشاء تذكرة';

  @override
  String get legacyUib25c91fe61 => 'إنشاء مستخدم';

  @override
  String get legacyUi705b0946b2 => 'إنشاء مركبة';

  @override
  String get legacyUi22a6b9d964 =>
      'أنشئ لوحة معلومات من تطبيق الويب لعرضها هنا.';

  @override
  String get legacyUi769479a4d5 =>
      'أنشئ رابط تتبّع عامًا لمشاركة التتبّع المباشر للمركبة.';

  @override
  String get legacyUi50aab1f7b5 => 'أنشئ مستشعرًا لهذه المركبة.';

  @override
  String get legacyUi0d2cd08b59 => 'إنشاء مسؤول';

  @override
  String get legacyUi6f876ff9c0 => 'أنشئ عنصرًا واحدًا على الأقل قبل التصدير.';

  @override
  String get legacyUic42adee4d7 => 'إنشاء جهاز دون مغادرة هذا النموذج';

  @override
  String get legacyUiaba922c9b5 => 'إنشاء سائق';

  @override
  String get legacyUi6efd8652f4 =>
      'أنشئ السائقين وأدِر المركبات المُسنَدة والمستندات ونشاط السائقين.';

  @override
  String get legacyUiba98384ac3 => 'أنشئ أسيجة جغرافية لإعداد إشعاراتها.';

  @override
  String get legacyUif7b868f7d4 =>
      'أنشئ نقاط اهتمام مع تحديد الفئة والأيقونة واللون ونصف قطر التغطية.';

  @override
  String get legacyUie42ed33e33 => 'إنشاء خطة تسعير دون مغادرة هذا النموذج';

  @override
  String get legacyUie40f966076 =>
      'أنشئ خطوط المسارات يدويًا أو من نقطة انطلاق ووجهة حيثما كان ذلك مدعومًا.';

  @override
  String get legacyUi567e040ce2 =>
      'أنشئ مسارات لإعداد إشعارات الانحراف عن المسار.';

  @override
  String get legacyUica09bbf34d =>
      'أنشئ مستخدمين فرعيين وتحكّم في المركبات التي يمكنهم الوصول إليها.';

  @override
  String get legacyUi3afcbed7e6 => 'إنشاء تذكرة';

  @override
  String get legacyUibdbcfa0af0 => 'إنشاء مستخدم';

  @override
  String get legacyUie7358de58e => 'إنشاء مستخدم دون مغادرة نموذج المركبة هذا';

  @override
  String get legacyUi505a950fbb => 'إنشاء مركبة';

  @override
  String get legacyUi1ef0c932b3 => 'أنشئ أول سائق لبدء عمليات الإسناد.';

  @override
  String get legacyUi7d3ca14313 => 'أنشئ أول سياج جغرافي لتحديد حدود التشغيل.';

  @override
  String get legacyUi60a39e1fde => 'أنشئ أول مكان لتتبّع نقاط التشغيل.';

  @override
  String get legacyUi4fbf4f09cd =>
      'أنشئ أول مستخدم فرعي لمشاركة صلاحيات محددة.';

  @override
  String get legacyUiaccf40c89b => 'تم الإنشاء';

  @override
  String get legacyUia5682ef199 => 'تاريخ الإنشاء: ';

  @override
  String get legacyUi5db1542e68 => 'وقت الإنشاء';

  @override
  String get legacyUif1c69716be => 'وقت الإنشاء';

  @override
  String get legacyUidd097a2297 => 'بيانات الدخول';

  @override
  String get legacyUi9f58b9e39b =>
      'بيانات الدخول التي سيستخدمها المسؤول لتسجيل الدخول إلى OpenVTS.';

  @override
  String get legacyUiec535bab6f =>
      'بيانات الدخول التي سيستخدمها المستخدم لتسجيل الدخول إلى OpenVTS.';

  @override
  String get legacyUi8a45d339a6 => 'رصيد';

  @override
  String get legacyUic3dc6e3ef9 =>
      'ستظهر هنا تحديثات الأرصدة والمدفوعات والفوترة.';

  @override
  String get legacyUibfac50d642 => 'الأرصدة';

  @override
  String get legacyUie070de2244 => 'العملة';

  @override
  String get legacyUiea4b114ac6 => 'الحالة الحالية';

  @override
  String get legacyUieeed986410 => 'الأرصدة الحالية';

  @override
  String get legacyUibe1ac4e322 => 'الخطوة الحالية';

  @override
  String get legacyUi9c378938cd => 'أمر مخصص';

  @override
  String get legacyUi28be3fd018 => 'نطاق مخصص';

  @override
  String get legacyUif130609dfc => 'فترة مخصصة';

  @override
  String get legacyUia9d9e61bf2 => 'فئة مخصصة (مثل «مورّد»)';

  @override
  String get legacyUi0354c8896b => 'نطاق مخصص';

  @override
  String get legacyUi3a55eba66f => 'النطاق المخصص ولون العلامة التجارية.';

  @override
  String get legacyUi9f1d0368da => 'انتهاء خدمة العميل';

  @override
  String get legacyUi1588fe44aa => 'تاريخ انتهاء خدمة العميل';

  @override
  String get legacyUib13a49701d => 'طلبات تجديد العملاء';

  @override
  String get legacyUi0c919bd08d => 'انتهاء خدمة العميل';

  @override
  String get legacyUidce04fd315 => 'مخصص…';

  @override
  String get legacyUi118de3988f => 'الحد الزمني';

  @override
  String get legacyUi5c487cb2d8 =>
      'بيانات الإيرادات اليومية غير متاحة لهذه الفترة.';

  @override
  String get legacyUi99c0019cc6 => 'شعار الوضع الداكن';

  @override
  String get legacyUia167278399 => 'تم تحديث شعار الوضع الداكن';

  @override
  String get legacyUi2b197ef6be =>
      'ستظهر هنا سجلات قاعدة البيانات وبيانات القياس المباشرة.';

  @override
  String get legacyUi6bb4b674b3 => 'النطاق الزمني';

  @override
  String get legacyUie3d06ca6a1 => 'نطاق التاريخ والوقت';

  @override
  String get legacyUic65ea4ae01 => 'النطاق الزمني';

  @override
  String get legacyUi853aab7f56 => 'التاريخ/الوقت';

  @override
  String get legacyUi842b7b5d71 => 'التواريخ';

  @override
  String get legacyUi987b9ced08 => 'اليوم';

  @override
  String get legacyUi82c29dd5fa => 'مقارنة النهار والليل';

  @override
  String get legacyUibfb1ba6e3e => 'فترة النهار والليل';

  @override
  String get legacyUicf558941e0 => 'خصم';

  @override
  String get legacyUibb3cec5175 => 'خصم أرصدة';

  @override
  String get legacyUi6bccca646f => 'تم الخصم';

  @override
  String get legacyUi1dcab135ef => 'إزالة التكرار';

  @override
  String get legacyUi15462a4954 => 'إزالة الأحداث المكررة';

  @override
  String get legacyUi6184deb041 => 'الخطة الافتراضية';

  @override
  String get legacyUiee1b9a9f23 => 'حذف الحساب';

  @override
  String get legacyUie81c14c990 => 'حذف السائق';

  @override
  String get legacyUi749f8e14e3 => 'حذف المستخدم الفرعي';

  @override
  String get legacyUi0a0a90f6c5 => 'حذف المستخدم';

  @override
  String get legacyUi4bcd1233a1 => 'حذف المسؤول';

  @override
  String get legacyUi6fd38c1fb9 => 'حذف المسؤول';

  @override
  String get legacyUie8df0b7902 => 'حذف المستند';

  @override
  String get legacyUi4ecae3e148 => 'حذف المستند؟';

  @override
  String get legacyUid1571af327 => 'حذف حساب السائق';

  @override
  String get legacyUia34ada32da => 'حذف المستشعر';

  @override
  String get legacyUi1ce5593800 => 'حذف هذا المستند؟';

  @override
  String get legacyUi6a58093cab => 'حذف رابط التتبّع';

  @override
  String get legacyUi9afe6c7b95 => 'حذف المستخدم';

  @override
  String get legacyUif7ff7065a9 => 'حذف المركبة';

  @override
  String get legacyUi441bda6cd8 => 'تم الحذف';

  @override
  String get legacyUif7c094a571 => 'الصفوف المحذوفة';

  @override
  String get legacyUic6bdaac949 => 'دلهي';

  @override
  String get legacyUibc4f986ecb => 'عمليات التسليم';

  @override
  String get legacyUi921a6f6b55 => 'سجلات التسليم';

  @override
  String get legacyUib2c4e6cb46 => 'تسجيل الدخول التجريبي';

  @override
  String get legacyUi4675a25777 => 'تسجيل الدخول التجريبي';

  @override
  String get legacyUi59013d16af => 'صِف الطلب أو المشكلة';

  @override
  String get legacyUi55f8ebc805 => 'الوصف';

  @override
  String get legacyUi388de6fa3a => 'الوصف (اختياري)';

  @override
  String get legacyUi763630a9ce => 'الوصف مطلوب.';

  @override
  String get legacyUi8a96cce5e5 =>
      'يجب أن يحتوي الوصف على حرف أو رقم واحد على الأقل.';

  @override
  String get legacyUidc3decbb93 => 'التفاصيل';

  @override
  String get legacyUia5a74a6df0 => 'الجهاز';

  @override
  String get legacyUid69ba8a9eb => 'جهاز + شريحة SIM';

  @override
  String get legacyUic587837fda => 'معرّف الجهاز IMEI';

  @override
  String get legacyUif59a7a21bb => 'عمليات تركيب الأجهزة';

  @override
  String get legacyUi219288726d => 'جهاز فقط';

  @override
  String get legacyUi554dd558bd => 'ملخص الجهاز';

  @override
  String get legacyUi20d5df8b4a => 'نوع الجهاز';

  @override
  String get legacyUi30de920ef1 => 'تم إنشاء الجهاز وتحديده';

  @override
  String get legacyUi3c47b57c83 => 'استجابة الجهاز';

  @override
  String get legacyUi6d2870160a => 'وقت الجهاز';

  @override
  String get legacyUi21fe5a18d0 => 'تم تحديث الجهاز.';

  @override
  String get legacyUidf485c8713 => 'الأجهزة';

  @override
  String get legacyUibb73469225 => 'تعطيل دون حذف الرابط.';

  @override
  String get legacyUid3e4b30e10 => 'تجاهل وتحديث';

  @override
  String get legacyUi427dc4f0cd => 'تجاهل إنشاء المسؤول الجديد؟';

  @override
  String get legacyUid1b8679c63 => 'تجاهل إنشاء المستخدم الجديد؟';

  @override
  String get legacyUi6012a2d760 => 'تجاهل إنشاء المركبة الجديدة؟';

  @override
  String get legacyUifb0a3e6787 => 'استخدام القرص';

  @override
  String get legacyUi70afe9eff3 => 'إغلاق';

  @override
  String get legacyUi515aa7ad86 => 'عرض بيانات السياج الجغرافي المُسنَد.';

  @override
  String get legacyUi37bbdde1a6 => 'عرض حدود الأسيجة الجغرافية على الخريطة';

  @override
  String get legacyUi2eebf5225a => 'عرض المسارات المحفوظة على الخريطة';

  @override
  String get legacyUifb71a3779e => 'معامل ضرب المسافة';

  @override
  String get legacyUib3262ecb53 => 'تفاوت المسافة';

  @override
  String get legacyUiac3f0eb0ea => 'المسافة/الساعات';

  @override
  String get legacyUi2c21f68832 => 'نوع المستند';

  @override
  String get legacyUi7615530d7a => 'رابط المستند غير متاح.';

  @override
  String get legacyUi6dad05c10e => 'إجراءات المستند';

  @override
  String get legacyUibd9a0f027e => 'تم حذف المستند.';

  @override
  String get legacyUi3859bdaa8c => 'عنوان المستند';

  @override
  String get legacyUi300b6ef0cd => 'نوع المستند';

  @override
  String get legacyUi9b10914d8b => 'النطاق';

  @override
  String get legacyUifb349182fc => 'النطاق واللون';

  @override
  String get legacyUi8b58eea04e => 'تم حفظ النطاق ولون العلامة التجارية';

  @override
  String get legacyUi0ec2ae5cda =>
      'النطاق والشعارات وأيقونة الموقع ولون العلامة التجارية.';

  @override
  String get legacyUibfa50c7a38 => 'رسم';

  @override
  String get legacyUi2e617aeb36 =>
      'ارسم دوائر ومضلعات ومستطيلات وحدودًا خطية على الخريطة.';

  @override
  String get legacyUid952b9d3da => 'ارسم أول نطاق مسار لبدء التتبّع.';

  @override
  String get legacyUi0ecf1d5bc0 => 'المسافة المقطوعة';

  @override
  String get legacyUi845a6bd3ab => 'ملف السائق';

  @override
  String get legacyUi450d68e4fe => 'إجراءات السائق';

  @override
  String get legacyUid1ba6aea38 => 'تم إسناد السائق.';

  @override
  String get legacyUifbaa386fbc => 'سيظهر هنا نشاط إسناد السائقين وملفاتهم.';

  @override
  String get legacyUi017bb97653 => 'تم إنشاء السائق.';

  @override
  String get legacyUif8acdd5348 =>
      'ستظهر هنا عمليات إنشاء السائقين وتحديث بياناتهم.';

  @override
  String get legacyUib057fefdc2 => 'تم حذف السائق.';

  @override
  String get legacyUi63a7342acd => 'اسم السائق';

  @override
  String get legacyUi8d30cc59a1 => 'تم إلغاء إسناد السائق.';

  @override
  String get legacyUia010b0a25f => 'تم تحديث السائق.';

  @override
  String get legacyUifdd68e9960 => 'مساحة عمل السائق';

  @override
  String get legacyUi3d14659ca9 => 'تشغيل تجريبي';

  @override
  String get legacyUi87bd16c150 => 'اكتمل التشغيل التجريبي';

  @override
  String get legacyUi91310be76f => 'دبي';

  @override
  String get legacyUi1370004da7 => 'المدة';

  @override
  String get legacyUia051787af6 => 'يجب ألا يتجاوز حجم كل مرفق 5 ميغابايت.';

  @override
  String get legacyUi9bb58b2d1b => 'شرق';

  @override
  String get legacyUi7de491bedc => 'تعديل الشركة';

  @override
  String get legacyUi5b7faa9d61 => 'تعديل الجهاز';

  @override
  String get legacyUicf5ddc10b3 => 'تعديل السائق';

  @override
  String get legacyUi13a7a7c3a7 => 'تعديل الخطة';

  @override
  String get legacyUicd280a41f7 => 'تعديل الملف الشخصي';

  @override
  String get legacyUi19d57bd021 => 'تعديل شريحة SIM';

  @override
  String get legacyUi4a0fe224b9 => 'تعديل المستشعر';

  @override
  String get legacyUic8e262db5b => 'تعديل المستخدم الفرعي';

  @override
  String get legacyUi38a1cb0f89 => 'تعديل عضو الفريق';

  @override
  String get legacyUi0e457253ad => 'تعديل المستخدم';

  @override
  String get legacyUib213eb6d7b => 'تعديل المركبة';

  @override
  String get legacyUid03750ccbf => 'تعديل الشركة';

  @override
  String get legacyUi15141eab3a => 'تعديل الملف الشخصي';

  @override
  String get legacyUi84add5b295 => 'البريد الإلكتروني';

  @override
  String get legacyUi5c10b588a9 => 'البريد الإلكتروني (اختياري)';

  @override
  String get legacyUi094f6a5934 => 'البريد الإلكتروني أو اسم المستخدم';

  @override
  String get legacyUi79d1feaf62 => 'حالة البريد الإلكتروني';

  @override
  String get legacyUia674e88b73 => 'التحقق من البريد الإلكتروني';

  @override
  String get legacyUic1feb155ec => 'تفعيل تسجيل الدخول التجريبي';

  @override
  String get legacyUi7cf7a0d02a => 'تفعيل التسجيل العام';

  @override
  String get legacyUif6321257f1 => 'تفعيل هذا الرابط العام.';

  @override
  String get legacyUid093b28018 => 'تفعيل/تحديث';

  @override
  String get legacyUi0af149c2ed => 'التشفير';

  @override
  String get legacyUic1f65ddb75 => 'المحرك';

  @override
  String get legacyUi49dda3d71a => 'ساعات تشغيل المحرك';

  @override
  String get legacyUi4c9c7856d1 => 'أدخل الرمز المكوّن من 6 أرقام';

  @override
  String get legacyUibc96ad8350 =>
      'أدخل مبلغًا عشريًا بمنزلتين عشريتين كحد أقصى';

  @override
  String get legacyUib0e59c93d7 => 'أدخل مبلغًا صالحًا.';

  @override
  String get legacyUi6d59e6aee7 => 'أدخل سبب تعديل من 5 إلى 500 حرف';

  @override
  String get legacyUi571c7347b7 => 'أدخل سبب تعديل من 5 إلى 500 حرف.';

  @override
  String get legacyUi18b809c9fb => 'أدخل نص الأمر';

  @override
  String get legacyUid5cd51c7b9 => 'أدخل عدد الأرصدة';

  @override
  String get legacyUibe7572b6c5 => 'أدخل الولاية أو الإقليم';

  @override
  String get legacyUid148321ad7 => 'أدخل الرمز المكوّن من 6 أرقام';

  @override
  String get legacyUi0d639c50f1 =>
      'أدخل الرمز المكوّن من 6 أرقام الذي أرسلناه إليك';

  @override
  String get legacyUi6d1e849865 =>
      'أدخل رمز التحقق المرسل إلى وسيلة التواصل المسجّلة.';

  @override
  String get legacyUied634c4edc =>
      'أدخل البريد الإلكتروني أو اسم المستخدم الذي تستخدمه لتسجيل الدخول. إذا كان الحساب موجودًا، فسنرسل رابط إعادة تعيين محدود الصلاحية.';

  @override
  String get legacyUi1378167d52 => 'أدخل كلمة المرور';

  @override
  String get legacyUib6334ab817 => 'أدخل اسم المستخدم أو البريد الإلكتروني';

  @override
  String get legacyUic7fb317725 => 'الكيان';

  @override
  String get legacyUi04d694e298 => 'معرّف الكيان';

  @override
  String get legacyUi948542c1d6 => 'خطأ/حرج';

  @override
  String get legacyUic250d77524 => 'تفاصيل الحدث';

  @override
  String get legacyUi894b1c749d => 'معرّف الحدث';

  @override
  String get legacyUif8e451a5d0 => 'الأحداث غير متاحة';

  @override
  String get legacyUief09596668 => 'الخروج من الوضع التجريبي';

  @override
  String get legacyUia689a999a5 => 'منتهي الصلاحية';

  @override
  String get legacyUib98d67213b => 'قريب الانتهاء';

  @override
  String get legacyUi57fe01159c => 'تاريخ الانتهاء (اختياري)';

  @override
  String get legacyUi1275b51587 => 'تاريخ/وقت الانتهاء';

  @override
  String get legacyUi6b440cd506 => 'تاريخ الانتهاء';

  @override
  String get legacyUic9f6710324 => 'يجب أن يكون وقت الانتهاء في المستقبل.';

  @override
  String get legacyUif3e4fadb9e => 'تصدير';

  @override
  String get legacyUi416a52a386 => 'تصدير KML';

  @override
  String get legacyUi09b28aeb8d => 'رمز FCM';

  @override
  String get legacyUic2bf1a9df5 => 'آخر 10 محارف من رمز FCM';

  @override
  String get legacyUi82da67b211 => 'Facebook';

  @override
  String get legacyUi09fef5d8d9 => 'فشل';

  @override
  String get legacyUid68666787d => 'الجداول التي فشلت';

  @override
  String get legacyUi706b9a59b6 => 'تعذّر تحميل المدن';

  @override
  String get legacyUi6eb9516fdf => 'تعذّر تحميل الدول';

  @override
  String get legacyUi4bc4b2e555 => 'تعذّر تحميل التفاصيل';

  @override
  String get legacyUia7bc426a05 => 'تعذّر تحميل تفاصيل المركبة الكاملة.';

  @override
  String get legacyUia17267ffa7 => 'تعذّر تحميل الولايات';

  @override
  String get legacyUi6bb1f1d9fb => 'تعذّر تحديث الحالة.';

  @override
  String get legacyUi1656649117 => 'فشل';

  @override
  String get legacyUib7ef43c84d => 'رمز الفشل';

  @override
  String get legacyUi41510b1b21 => 'رسالة الفشل';

  @override
  String get legacyUi8db6a2f1d3 => 'سريع';

  @override
  String get legacyUiadc7ac2ae5 => 'أسرع';

  @override
  String get legacyUib0f47aaf77 => 'أيقونة الموقع';

  @override
  String get legacyUi7d9baea15f => 'تم تحديث أيقونة الموقع';

  @override
  String get legacyUi2c3cafa4db => 'الملف';

  @override
  String get legacyUi55fee60744 => 'رابط الملف غير متاح.';

  @override
  String get legacyUif76f22f075 => 'يتجاوز الملف الحد المسموح وهو 10 ميغابايت.';

  @override
  String get legacyUi7e184124be => 'الملف مطلوب.';

  @override
  String get legacyUi36f2202687 => 'يجب ألا يتجاوز حجم الملف 10 ميغابايت.';

  @override
  String get legacyUi937fd74b36 => 'تصفية شرائح SIM';

  @override
  String get legacyUi15db08d15e => 'تصفية سجلات النشاط';

  @override
  String get legacyUi582198fab2 => 'تصفية المسؤولين';

  @override
  String get legacyUi9911a4c0ed => 'تصفية الأجهزة';

  @override
  String get legacyUi6a7fe2dc2c => 'تصفية السائقين';

  @override
  String get legacyUi5439ccf95d => 'تصفية الأسيجة الجغرافية';

  @override
  String get legacyUif1fe9835a2 => 'تصفية الفريق';

  @override
  String get legacyUi8cfc14a859 => 'تصفية المستخدمين';

  @override
  String get legacyUia9d1432d0d => 'تصفية المركبات';

  @override
  String get legacyUiaa234fb61d => 'Firebase';

  @override
  String get legacyUib15839eae8 => 'تم تهيئة Firebase';

  @override
  String get legacyUi916a78d701 => 'الأول';

  @override
  String get legacyUic617ebad3b => 'أصلح أخطاء التحقق قبل الاختبار';

  @override
  String get legacyUi4d4e9621c4 => 'حالة الأسطول';

  @override
  String get legacyUi1cc8d18151 => 'نسيت كلمة المرور؟';

  @override
  String get legacyUibaa0e2872d => 'أرصدة التسجيل المجانية';

  @override
  String get legacyUi236ddee138 => 'من المسؤول';

  @override
  String get legacyUi19fe826cc8 => 'بريد المرسل';

  @override
  String get legacyUi64346b483c => 'الاسم الكامل';

  @override
  String get legacyUi9f8ce19bf4 => 'العنوان الكامل';

  @override
  String get legacyUieeb692087d => 'الاسم الكامل';

  @override
  String get legacyUifcee5b52cc => 'فرق التوقيت عن GMT';

  @override
  String get legacyUi590df4df1f => 'يجب كتابة فرق التوقيت بصيغة +05:30.';

  @override
  String get legacyUi0933ed5657 => 'طراز جهاز GPS';

  @override
  String get legacyUicbb0014411 => 'محطة وقود';

  @override
  String get legacyUifc45f9b7a9 => 'توليد';

  @override
  String get legacyUi549f31c53e => 'توليد المسار';

  @override
  String get legacyUidfde035f40 => 'الترميز الجغرافي';

  @override
  String get legacyUi5cdf1dbd7e => 'الأسيجة الجغرافية';

  @override
  String get legacyUic09b487feb => 'عرض إعادة التتبّع';

  @override
  String get legacyUi5442e2b64f => 'GitHub';

  @override
  String get legacyUi1efbf15894 => 'تجميع المركبات المتقاربة عند تصغير الخريطة';

  @override
  String get legacyUiac69db7d02 => 'مخطط النمو';

  @override
  String get legacyUibc4359231d => 'نادي رياضي';

  @override
  String get legacyUifa8a6b01e3 => 'تم نسخ الترويسة';

  @override
  String get legacyUi071c1366b0 => 'تتطلب الدقة الأعلى مزيدًا من عمليات البحث.';

  @override
  String get legacyUi90ccd64974 => 'السجل';

  @override
  String get legacyUic3669ffe53 =>
      'يتطلب السجل مركبة لها معرّف IMEI ضمن بيانات القياس المباشرة.';

  @override
  String get legacyUi8d4a22ea2b => 'قيم السجل ليست رقمية.';

  @override
  String get legacyUidbb927867e => 'مستشفى';

  @override
  String get legacyUi3960ec4ca5 => 'المضيف';

  @override
  String get legacyUiadd03be31a => 'المضيف والمنفذ والتشفير.';

  @override
  String get legacyUi9c4ba7d047 => 'فندق';

  @override
  String get legacyUi1e3beed01c =>
      'مدة الاحتفاظ بالبيانات السابقة قبل تنظيفها.';

  @override
  String get legacyUi2635a51635 => 'كيفية تعريف المسؤول على المنصة.';

  @override
  String get legacyUi0f053057ee => 'كيفية تعريف المستخدم على المنصة.';

  @override
  String get legacyUi077f5f9dad => 'لديّ رابط إعادة تعيين بالفعل';

  @override
  String get legacyUibff7cfa991 => 'ICCID (اختياري)';

  @override
  String get legacyUidc7458a51a => 'معرّف IMEI مطلوب لتحميل سجلات القياس.';

  @override
  String get legacyUif4c88fb92e => 'معرّف IMEI مطلوب لتحميل أحداث المركبة.';

  @override
  String get legacyUi7e77081c51 => 'معرّف IMEI مطلوب لإرسال الأوامر.';

  @override
  String get legacyUif44426c787 =>
      'معرّف IMEI غير متاح لهذه المركبة. يُعرض ملخص الخريطة المباشرة فقط.';

  @override
  String get legacyUi8a4b9cf4a9 => 'معرّف IMEI مفقود';

  @override
  String get legacyUi11da2cb7f0 => 'IMSI (اختياري)';

  @override
  String get legacyUi716f63b96e => 'الأيقونة';

  @override
  String get legacyUi7e5a975b6a => 'الهوية';

  @override
  String get legacyUi2d40c36445 => 'الإشعال';

  @override
  String get legacyUif2d738d99c => 'مصدر إشارة الإشعال';

  @override
  String get legacyUi4157fc56ab => 'الصورة كبيرة جدًا. الحد الأقصى 2 ميغابايت.';

  @override
  String get legacyUifcf7141427 => 'الصورة كبيرة جدًا. الحد الأقصى 5 ميغابايت.';

  @override
  String get legacyUieeec98db23 => 'استيراد CSV';

  @override
  String get legacyUieebd26ef51 => 'غير نشط - 48 ساعة';

  @override
  String get legacyUi4b631f6984 => 'معلومات';

  @override
  String get legacyUi29981bf033 => 'الرصيد الأولي المُخصّص لحساب المسؤول هذا.';

  @override
  String get legacyUi58984ab1ac => 'الأرصدة الأولية';

  @override
  String get legacyUi5721bbef40 => 'Instagram';

  @override
  String get legacyUi9b5ca633e8 => 'أرصدة الحساب غير كافية';

  @override
  String get legacyUi2ab95a4afe => 'معرّف المسؤول غير صالح.';

  @override
  String get legacyUicfa3e9c7e1 => 'تم إنشاء عنصر المخزون.';

  @override
  String get legacyUi32091e3797 => 'حالة المخزون';

  @override
  String get legacyUia430dcf58c => 'جين سميث';

  @override
  String get legacyUi049874e4f7 => 'تم نسخ KML إلى الحافظة';

  @override
  String get legacyUi62fc561458 => 'الإبقاء على الطلب';

  @override
  String get legacyUic67dd20ee8 => 'المفتاح';

  @override
  String get legacyUi52c4afe84f => 'محرّر المعالم';

  @override
  String get legacyUid1c69a859a => 'الأخير';

  @override
  String get legacyUi43df3046ba => 'آخر تغيير';

  @override
  String get legacyUi7a78ad49d8 => 'إيرادات الشهر الماضي';

  @override
  String get legacyUicec3d948d9 => 'آخر دفعة';

  @override
  String get legacyUiada1b72559 => 'آخر تحقق';

  @override
  String get legacyUi43dab84ff6 => 'آخر تسجيل دخول';

  @override
  String get legacyUib916a123cc => 'إيرادات الشهر الماضي';

  @override
  String get legacyUi76c1ed9309 => 'الأسبوع الماضي';

  @override
  String get legacyUieb3a622ae8 => 'خط العرض / خط الطول';

  @override
  String get legacyUi1e5421b5bc => 'خط العرض/خط الطول';

  @override
  String get legacyUidecd7ca800 => 'الأحدث';

  @override
  String get legacyUiefaed3a1b0 => 'اتركه فارغًا للاحتفاظ بكلمة المرور الحالية';

  @override
  String get legacyUib8100f5ba8 => 'المكتبة';

  @override
  String get legacyUi3229609e15 => 'الترخيص';

  @override
  String get legacyUi99929a05d8 => 'محظور بسبب الترخيص';

  @override
  String get legacyUi7452738cf9 => 'الترخيص الصادر';

  @override
  String get legacyUibbe96bcfaa => 'الترخيص المستخدم';

  @override
  String get legacyUib957e7bd7b => 'محظور بسبب الترخيص';

  @override
  String get legacyUiee92c8a4b6 => 'التراخيص';

  @override
  String get legacyUi6731d7cd1a => 'شعار الوضع الفاتح';

  @override
  String get legacyUi6a1c6c8807 => 'تم تحديث شعار الوضع الفاتح';

  @override
  String get legacyUi24d948e4bd => 'الحد';

  @override
  String get legacyUied1ed2b68d => 'تم نسخ الرابط.';

  @override
  String get legacyUi36d1b59b88 =>
      'اربط المركبة بمستخدم رئيسي وجهاز GPS وخطة تسعير.';

  @override
  String get legacyUi6b6390a441 => 'LinkedIn';

  @override
  String get legacyUi4ac08d16b8 => 'تحميل الرسائل السابقة';

  @override
  String get legacyUidfe60ca92e => 'تحميل المزيد';

  @override
  String get legacyUifc53db81a0 => 'تحميل المزيد من الخادم';

  @override
  String get legacyUi949d7ee41c => 'تحميل الأقدم';

  @override
  String get legacyUi6db90a0ab6 => 'تم التحميل';

  @override
  String get legacyUi326ad2f9f8 => 'جارٍ تحميل المركبات المُسنَدة';

  @override
  String get legacyUi8936529136 => 'جارٍ تحميل المركبات المتاحة';

  @override
  String get legacyUi9f1e0ce448 => 'جارٍ تحميل المستندات';

  @override
  String get legacyUide261e9b89 => 'جارٍ تحميل السجلات';

  @override
  String get legacyUi324989adf0 => 'جارٍ تحميل المستشعرات';

  @override
  String get legacyUid219c68101 => 'الموقع';

  @override
  String get legacyUi2350df02c2 => 'تفاصيل السجل';

  @override
  String get legacyUiaacbd6aa68 => 'معرّف السجل';

  @override
  String get legacyUia3d749050e => 'تسجيل الدخول كمستخدم';

  @override
  String get legacyUi31a519ee99 =>
      'ستظهر هنا تغييرات تسجيل الدخول أو كلمة المرور أو حالة الحساب.';

  @override
  String get legacyUi16b583cf21 => 'السجلات غير متاحة';

  @override
  String get legacyUi4c57f0c88d => 'لندن';

  @override
  String get legacyUi3bf98fa618 => 'وضع علامة «مقروء»';

  @override
  String get legacyUia95e85aed5 => 'الحد الأقصى';

  @override
  String get legacyUi35f72dc38d => 'السرعة القصوى';

  @override
  String get legacyUi03a68b7d8b => 'استخدام الذاكرة';

  @override
  String get legacyUi68f4145fee => 'الرسالة';

  @override
  String get legacyUi54a144c1dd => 'إرسال الرسائل';

  @override
  String get legacyUi23b9e4546e => 'راسل مدير أسطولك هنا.';

  @override
  String get legacyUi8d546a6dea => 'بيانات وصفية';

  @override
  String get legacyUi251edc0eb5 => 'البيانات الوصفية';

  @override
  String get legacyUic0b8960edf => 'تم نسخ البيانات الوصفية';

  @override
  String get legacyUi7eb0cee888 => 'الحد الأدنى';

  @override
  String get legacyUib6bcd4535a => '3 أحرف على الأقل…';

  @override
  String get legacyUi925c181c00 => '6 أحرف على الأقل';

  @override
  String get legacyUi092f99ea11 => 'دقائق';

  @override
  String get legacyUib1d7024593 => 'الجوال';

  @override
  String get legacyUia0d9c28a1e => 'الجوال (اختياري)';

  @override
  String get legacyUi5968acfb01 => 'رقم الجوال';

  @override
  String get legacyUic242b24d94 => 'رمز الاتصال';

  @override
  String get legacyUi802cdad736 => 'إشعارات الجوال';

  @override
  String get legacyUi00618b3856 =>
      'رقم الجوال والبريد الإلكتروني المستخدمان للتواصل.';

  @override
  String get legacyUi5d96299833 => 'رقم الجوال (اختياري)';

  @override
  String get legacyUi2ab961738f => 'رمز الاتصال';

  @override
  String get legacyUi90ee975346 => 'رمز الاتصال (اختياري)';

  @override
  String get legacyUiaa6630b79b => 'تمت إعادة محاولة تسجيل إشعارات الجوال.';

  @override
  String get legacyUia1e34f9157 => 'مزيد من الإجراءات';

  @override
  String get legacyUi86c0a35ec8 => 'مزيد من الخيارات';

  @override
  String get legacyUi69d9f3e5ae => 'متحف';

  @override
  String get legacyUi4ff2aa7688 => 'تذاكري';

  @override
  String get legacyUi2e65b706ae => 'الاسم والرمز مطلوبان.';

  @override
  String get legacyUi1eee3afea2 => 'التنقّل';

  @override
  String get legacyUiccfb5f0286 => 'نقطة اهتمام جديدة';

  @override
  String get legacyUi4894cb39ee => 'كلمة مرور جديدة';

  @override
  String get legacyUidcaa5db473 => 'تذكرة جديدة';

  @override
  String get legacyUib85e445f60 => 'مستخدم جديد';

  @override
  String get legacyUia273c96341 => 'مركبة جديدة';

  @override
  String get legacyUie0725b6664 => 'سياج جغرافي جديد';

  @override
  String get legacyUif39fa269a9 => 'مسار جديد';

  @override
  String get legacyUi395e182389 => 'سيظهر المستخدمون الجدد هنا.';

  @override
  String get legacyUi2213317245 => 'ستظهر المركبات الجديدة هنا.';

  @override
  String get legacyUi4bfc194b68 => 'الصفحة التالية';

  @override
  String get legacyUi1097b553dc => 'ليل';

  @override
  String get legacyUi4276e6ab2a => 'لا توجد بيانات';

  @override
  String get legacyUi3de93f521b => 'لا يوجد جهاز';

  @override
  String get legacyUi79858167e6 => 'لا توجد نقاط اهتمام بعد';

  @override
  String get legacyUia434e9985c => 'لا يوجد مزوّد';

  @override
  String get legacyUi7094ba4f01 =>
      'لا توجد مهمة نشطة. تظهر الرحلات الجديدة هنا عندما يسندها مسؤول التشغيل.';

  @override
  String get legacyUia9206f399a => 'لا توجد سجلات نشاط';

  @override
  String get legacyUi8bd5b910e5 => 'لم يتم العثور على سجلات نشاط';

  @override
  String get legacyUic38a37a193 => 'لا يوجد نشاط يطابق عوامل التصفية.';

  @override
  String get legacyUibff9905096 => 'لم يُسجَّل أي نشاط بعد.';

  @override
  String get legacyUi0f5cca70f8 => 'لم يتم العثور على مسؤولين';

  @override
  String get legacyUi31d3df94ab => 'لم يتم العثور على مسؤولين.';

  @override
  String get legacyUic0d322c2b0 => 'لا توجد بيانات استخدام';

  @override
  String get legacyUie5d64448e5 => 'لا توجد تنبيهات';

  @override
  String get legacyUi501176c9f8 => 'لا توجد بيانات تحليلية';

  @override
  String get legacyUi63f5349bb8 => 'لا يوجد مستخدمون مُسنَدون';

  @override
  String get legacyUi852751d61f => 'لا توجد مركبات مُسنَدة';

  @override
  String get legacyUi7546829892 => 'لم يتم العثور على نشاط فوترة.';

  @override
  String get legacyUi657275c0c1 => 'لا توجد مدن متاحة لهذه الولاية';

  @override
  String get legacyUia130e0f01b => 'لا يوجد سجل أوامر';

  @override
  String get legacyUi92db635f14 => 'لا توجد أوامر بعد';

  @override
  String get legacyUi14a4bfc72c => 'لا توجد رحلات مكتملة هذا الشهر.';

  @override
  String get legacyUiee9c2e1df0 => 'لا توجد إعدادات';

  @override
  String get legacyUic3017a3316 => 'لا توجد محادثة بعد';

  @override
  String get legacyUic140165b8f => 'لا يوجد سجل أرصدة بعد.';

  @override
  String get legacyUic8114767e8 => 'لم تُعَدّ لوحة معلومات';

  @override
  String get legacyUi7be70212b0 =>
      'لا توجد بيانات للنهار أو الليل خلال هذه الفترة.';

  @override
  String get legacyUi2a4eb69350 => 'لا توجد تفاصيل';

  @override
  String get legacyUi03ca0261ac => 'لا يوجد جهاز';

  @override
  String get legacyUi893d388d16 => 'لم يُسنَد جهاز إلى هذه المركبة.';

  @override
  String get legacyUi8386fe15ef => 'لا توجد مستندات';

  @override
  String get legacyUi017ce6604c => 'لم تُرفع مستندات';

  @override
  String get legacyUiec7eb3c93e => 'لم تُرفع مستندات بعد.';

  @override
  String get legacyUi54e1079e44 =>
      'لا توجد مستندات بعد. ارفع أول مستند باستخدام زر الرفع.';

  @override
  String get legacyUia419748e62 => 'لم يتم العثور على نشاط للسائق.';

  @override
  String get legacyUi98e6629503 =>
      'لم تُعَدّ أنواع مستندات السائقين. اطلب من المسؤول إضافة نوع.';

  @override
  String get legacyUi36f5cbf894 => 'لا توجد مستندات للسائق';

  @override
  String get legacyUic5dc9718a6 => 'لا يوجد سائقون';

  @override
  String get legacyUi7a127d70b3 => 'لا يوجد سائقون متاحون';

  @override
  String get legacyUi9c8198d34d => 'لم يتم العثور على سائقين';

  @override
  String get legacyUi208ffc64d1 => 'لم يتم العثور على تفاصيل الحدث';

  @override
  String get legacyUiec11a02374 =>
      'لا توجد أحداث ضمن الفترة الزمنية وعوامل التصفية المحددة.';

  @override
  String get legacyUia48cbba615 => 'لم يتم العثور على أحداث';

  @override
  String get legacyUi81ab95b9f0 => 'لا توجد أحداث بعد';

  @override
  String get legacyUi774a252215 => 'لا يوجد ملف متاح.';

  @override
  String get legacyUi35f65e1e57 => 'لا توجد أسيجة جغرافية متاحة.';

  @override
  String get legacyUi019549899f => 'لا توجد أسيجة جغرافية بعد';

  @override
  String get legacyUi5358cec56d => 'لا توجد نقاط في السجل';

  @override
  String get legacyUia0ed9c8031 => 'لا توجد نقاط في السجل لهذه الفترة.';

  @override
  String get legacyUi8bf09d954a => 'لا توجد مركبات مرتبطة متاحة';

  @override
  String get legacyUif48787eb30 => 'لم يتم العثور على سجلات';

  @override
  String get legacyUi6b68d448a0 => 'لم يتم العثور على سجلات لهذه المركبة';

  @override
  String get legacyUic7462a9dac => 'لا توجد سجلات بعد';

  @override
  String get legacyUi1db215fbaa => 'لا توجد نتائج مطابقة لبحثك.';

  @override
  String get legacyUia734fde29a => 'لا توجد نقاط اهتمام مطابقة';

  @override
  String get legacyUi2d928306c1 => 'لا يوجد سائقون مطابقون';

  @override
  String get legacyUid6e8839481 => 'لا توجد أسيجة جغرافية مطابقة';

  @override
  String get legacyUif6830db2e7 => 'لا توجد سجلات مطابقة';

  @override
  String get legacyUi748bd377da => 'لا توجد سجلات مطابقة';

  @override
  String get legacyUi6590e5eab8 => 'لا توجد مسارات مطابقة';

  @override
  String get legacyUid17e9558cf => 'لا يوجد مستخدمون فرعيون مطابقون';

  @override
  String get legacyUif1d8690cd7 =>
      'لم يتم العثور على مركبات مطابقة. جرّب بحثًا أو عامل تصفية مختلفًا.';

  @override
  String get legacyUic04921f8d9 => 'لا توجد رسائل بعد';

  @override
  String get legacyUi2449a03436 => 'لا توجد بيانات عن الوضع';

  @override
  String get legacyUi50806db52e => 'لم يتم العثور على إعدادات إشعارات';

  @override
  String get legacyUic1f531f996 => 'لم يتم العثور على مدفوعات';

  @override
  String get legacyUiaf4a7f06d0 => 'لم يتم العثور على خطط';

  @override
  String get legacyUi4ae157aff3 => 'لا توجد تنبيهات حديثة.';

  @override
  String get legacyUi26776d0320 => 'لا يوجد مستخدمون جدد';

  @override
  String get legacyUi42ec1ecf96 => 'لا توجد مركبات جديدة';

  @override
  String get legacyUi9833364a35 => 'لا توجد مسارات متاحة.';

  @override
  String get legacyUid233dd5d9f => 'لا توجد مسارات بعد';

  @override
  String get legacyUic9bfb1492b => 'لم يتم العثور على نشاط أمني.';

  @override
  String get legacyUid07b6b93d6 => 'لا توجد مركبات قابلة للاختيار';

  @override
  String get legacyUi5653bf7251 => 'لا توجد نقاط مستشعر لهذه الفترة.';

  @override
  String get legacyUi1ef59c9c2b => 'لا توجد مستشعرات';

  @override
  String get legacyUi3c30b80f16 => 'لم تُعَدّ مستشعرات لهذه المركبة.';

  @override
  String get legacyUicbae766d34 => 'لم يتم العثور على نشاط للإعدادات.';

  @override
  String get legacyUicd0c79d188 => 'لا توجد روابط مشاركة';

  @override
  String get legacyUi9eac2f6695 => 'لا توجد ولايات متاحة لهذه الدولة';

  @override
  String get legacyUid05ab60501 => 'لا توجد بيانات حالة';

  @override
  String get legacyUi4b78e836ec => 'لا يوجد مستخدمون فرعيون';

  @override
  String get legacyUib30adf9758 => 'لا يوجد مستخدمون فرعيون متاحون';

  @override
  String get legacyUi3a1fa8f145 => 'لم يتم العثور على أعضاء فريق';

  @override
  String get legacyUi12c6f10a41 => 'لم يتم العثور على تفاصيل القياس';

  @override
  String get legacyUi429d6e6ece => 'لم يتم العثور على سجلات القياس';

  @override
  String get legacyUiea04e18b66 => 'لا توجد أصول بارزة خلال هذه الفترة.';

  @override
  String get legacyUi48d2d8da35 => 'لا توجد معاملات';

  @override
  String get legacyUid60c045dd2 => 'لم يتم العثور على معاملات';

  @override
  String get legacyUif794b6c6d1 => 'لا توجد معاملات بعد.';

  @override
  String get legacyUi8d92589518 => 'لا توجد بيانات اتجاهات';

  @override
  String get legacyUi7d3e5f72b8 => 'لا توجد رحلات في هذا العرض.';

  @override
  String get legacyUib4c96ae04e => 'لم يتم العثور على مستخدمين غير مرتبطين.';

  @override
  String get legacyUi4b3155e704 => 'لا يوجد مستخدمون غير مرتبطين يطابقون بحثك.';

  @override
  String get legacyUid9c71203a5 => 'لا توجد بيانات استخدام للفترة المحددة.';

  @override
  String get legacyUic4b060bd59 => 'لا يوجد مستخدمون';

  @override
  String get legacyUi5cc2b29f54 => 'لم يُسنَد مستخدمون';

  @override
  String get legacyUi3b614a59c7 => 'لا يوجد مستخدمون متاحون';

  @override
  String get legacyUi612eb3c64c => 'لم يتم العثور على مستخدمين';

  @override
  String get legacyUie611ef5702 => 'لم يتم العثور على مستخدمين.';

  @override
  String get legacyUif800dfd722 => 'لم يتم إرجاع مسار GPS صالح أو علامات توقف.';

  @override
  String get legacyUib96ee669b0 => 'لم يتم العثور على نشاط للمركبة.';

  @override
  String get legacyUi748eafd21d => 'لا توجد مركبات';

  @override
  String get legacyUi8fbc8deb7a => 'لا تظهر أي مركبات على الخريطة حاليًا.';

  @override
  String get legacyUi72ed5bbcdf => 'لم تُسنَد مركبات بعد.';

  @override
  String get legacyUi7223e6b8cb => 'لم تُسنَد مركبات.';

  @override
  String get legacyUiac0e4dbd5b => 'لا توجد مركبات متاحة';

  @override
  String get legacyUic578cfdbd5 => 'لم يتم العثور على مركبات';

  @override
  String get legacyUie1de5f8ce2 => 'لا توجد مركبات تطابق بحثك.';

  @override
  String get legacyUia41b297cf1 => 'لا توجد بيانات مقارنة أسبوعية.';

  @override
  String get legacyUi35163920f3 => 'لم تُعَدّ عناصر لوحة المعلومات';

  @override
  String get legacyUi45e118d056 => 'عادي';

  @override
  String get legacyUif8e45b2be2 => 'شمال';

  @override
  String get legacyUi2c924e3088 => 'ملاحظة';

  @override
  String get legacyUi2fd5716446 => 'ملاحظات (اختياري)';

  @override
  String get legacyUicf62dbc83d => 'ملاحظات / وصف';

  @override
  String get legacyUi3e56dbb775 => 'ملاحظات حول هذا المستند';

  @override
  String get legacyUi7faf33fcca => 'لا توجد بيانات للتصدير';

  @override
  String get legacyUi76544814eb => 'إجراءات الإشعار';

  @override
  String get legacyUi4eb32de6c9 => 'تم حفظ إعدادات الإشعارات بنجاح.';

  @override
  String get legacyUi8ca2cb9290 => 'عداد المسافة';

  @override
  String get legacyUi6c3a72eaf6 => 'مكتب';

  @override
  String get legacyUi63f34dd211 => 'الأقدم';

  @override
  String get legacyUi35c5d4307a => 'صفوف أقدم';

  @override
  String get legacyUi9f8f7411e8 =>
      'مركبة واحدة أو أكثر من المركبات المحددة غير صالحة.';

  @override
  String get legacyUie81cd61ea1 => 'يمكن مشاركة مركبات المستخدم المُسنَدة فقط.';

  @override
  String get legacyUicf9b77061f => 'فتح';

  @override
  String get legacyUi8f5f529938 => 'فتح / حفظ';

  @override
  String get legacyUi55d00c31ab => 'فتح المركبات';

  @override
  String get legacyUicc6b7ec50c => 'فتح ملف CSV للصفوف التي فشلت';

  @override
  String get legacyUi99bd9c01d7 => 'إشعارات OpenVTS';

  @override
  String get legacyUic1b94f880c => 'المبلغ (اختياري)';

  @override
  String get legacyUi7afdcf3257 => 'البريد الإلكتروني (اختياري)';

  @override
  String get legacyUic553137ef5 => 'الجوال (اختياري)';

  @override
  String get legacyUi410d481882 => 'ملاحظات اختيارية';

  @override
  String get legacyUi4f8f9c2bba => 'إيصال أو ملاحظة (اختياري)';

  @override
  String get legacyUi3494a60f96 => 'اسم المستخدم (اختياري)';

  @override
  String get legacyUia493c04fb5 => 'اختياري؛ أدخل 3 أحرف على الأقل';

  @override
  String get legacyUi6bf5da9c08 => 'الخيارات';

  @override
  String get legacyUidefe0db589 => 'الترتيب حسب';

  @override
  String get legacyUi6e6a6f2086 => 'أخرى';

  @override
  String get legacyUi4bed336194 => 'المخرجات';

  @override
  String get legacyUi9e339da256 => 'تنبيه تجاوز السرعة مفعّل';

  @override
  String get legacyUi0efc2e6be4 => 'نظرة عامة';

  @override
  String get legacyUi3e90e4cbf4 => 'الملكية';

  @override
  String get legacyUi07afcc61d8 => 'نوع الحزمة';

  @override
  String get legacyUif92c24e8df => 'حديقة';

  @override
  String get legacyUi07ba1bef85 => 'الأطراف';

  @override
  String get legacyUi8be3c943b1 => 'كلمة المرور';

  @override
  String get legacyUi408255ed02 => 'كلمة المرور (اختياري)';

  @override
  String get legacyUi092a16e7af => 'تم تغيير كلمة المرور';

  @override
  String get legacyUi47fa528931 => 'تم تغيير كلمة المرور.';

  @override
  String get legacyUi3efdbb2011 => 'تم تحديث كلمة المرور.';

  @override
  String get legacyUi8ac0c75d5e =>
      'الصق رابط إعادة التعيين الكامل أو الرمز الوارد في بريدك الإلكتروني. تُستخدم روابط إعادة التعيين مرة واحدة وتنتهي صلاحيتها تلقائيًا.';

  @override
  String get legacyUi5616b61bb7 => 'بيانات JSON';

  @override
  String get legacyUif8c3596eab => 'يجب أن تكون البيانات كائن JSON صالحًا.';

  @override
  String get legacyUi23b35c414a => 'طريقة الدفع';

  @override
  String get legacyUi670d2a76c7 => 'طريقة الدفع *';

  @override
  String get legacyUi662210d869 => 'توزيع طرق الدفع';

  @override
  String get legacyUia629fd8a2e => 'نوع الدفع';

  @override
  String get legacyUi43f8c9c90f => 'سيظهر نشاط الدفع هنا.';

  @override
  String get legacyUi8fbf2ec0dd => 'طريقة الدفع';

  @override
  String get legacyUi653c04fc42 => 'توزيع طرق الدفع غير متاح لهذه الفترة.';

  @override
  String get legacyUidbc3c0ca72 => 'تم تسجيل الدفع';

  @override
  String get legacyUi197b45d161 => 'مرجع الدفع';

  @override
  String get legacyUi96f608c16c => 'قيد الانتظار';

  @override
  String get legacyUid1240d2832 => 'قيد الانتظار / فشل';

  @override
  String get legacyUi9126c119ae => 'المدفوعات المعلّقة';

  @override
  String get legacyUib4ebfb2f75 => 'المدفوعات المعلّقة';

  @override
  String get legacyUi167a47ff3e => 'نُفّذ بواسطة';

  @override
  String get legacyUi1785713451 => 'الصلاحية';

  @override
  String get legacyUid06d555709 => 'الصلاحيات';

  @override
  String get legacyUi1e99c04657 => 'تم تحديث الصلاحيات';

  @override
  String get legacyUi0219adf447 => 'البيانات الشخصية والعنوان';

  @override
  String get legacyUib1b9e59387 => 'المعلومات الشخصية';

  @override
  String get legacyUi77064d5265 => 'الهاتف';

  @override
  String get legacyUi26730cddc4 => 'اختيار ملف CSV';

  @override
  String get legacyUif2c5ca7b8c => 'الرمز البريدي';

  @override
  String get legacyUifd25c49d56 => 'الرمز البريدي (اختياري)';

  @override
  String get legacyUiae2f98a099 => 'الخطة';

  @override
  String get legacyUiec0632cbbf => 'اسم الخطة';

  @override
  String get legacyUi2b366a2f95 => 'سعر الخطة';

  @override
  String get legacyUi7f97f6a268 => 'تم إنشاء الخطة وتحديدها';

  @override
  String get legacyUi2db331cefa => 'اللوحة';

  @override
  String get legacyUi7d86677521 => 'رقم اللوحة';

  @override
  String get legacyUia6b7aa4d9c => 'رقم اللوحة (اختياري)';

  @override
  String get legacyUif2ce282e2d => 'رقم اللوحة';

  @override
  String get legacyUi09d9c23846 => 'رقم اللوحة (اختياري)';

  @override
  String get legacyUi123a7f2fcc => 'المنصة';

  @override
  String get legacyUi16596c477e =>
      'سلوك المنصة والتسجيل والترميز الجغرافي والاحتفاظ بالبيانات.';

  @override
  String get legacyUid095e279b3 => 'صحّح الحقول المحددة قبل المتابعة.';

  @override
  String get legacyUi51668149ea => 'يرجى اختيار مسؤول.';

  @override
  String get legacyUife035157cd => 'المنفذ';

  @override
  String get legacyUi16c2eb4dbb => 'المنافذ';

  @override
  String get legacyUib629d4165b => 'الرمز البريدي';

  @override
  String get legacyUib86b6a2b3b => 'الرمز البريدي (اختياري)';

  @override
  String get legacyUi90eceb016c => 'رمز الاتصال';

  @override
  String get legacyUif1fbb2b43d => 'معاينة';

  @override
  String get legacyUiba3e0b4a86 => 'تم تحديث المعاينة';

  @override
  String get legacyUi81f547195b => 'الصفحة السابقة';

  @override
  String get legacyUi3e8248e32e => 'السعر';

  @override
  String get legacyUi15ac0c0a27 => 'خطة التسعير';

  @override
  String get legacyUid3dcce7d10 => 'اللون الرئيسي';

  @override
  String get legacyUi170f443f36 => 'المستخدم الرئيسي';

  @override
  String get legacyUia1055f11a9 => 'اللون الرئيسي';

  @override
  String get legacyUic1ee865b42 => 'اللون الرئيسي (ست عشري)';

  @override
  String get legacyUi0554f68465 => 'المستخدم الرئيسي';

  @override
  String get legacyUi1e5947a051 =>
      'المستخدم الرئيسي والجهاز ونوع المركبة وخطة التسعير مطلوبة.';

  @override
  String get legacyUi886cbff9d9 => 'الأولوية';

  @override
  String get legacyUi7e7302bb73 => 'لم يُحمَّل الملف الشخصي بعد.';

  @override
  String get legacyUi5049e8f42b => 'تم تحديث صورة الملف الشخصي';

  @override
  String get legacyUi49ba5b4d7b => 'إعدادات الملف الشخصي غير متاحة';

  @override
  String get legacyUibcf7629607 => 'تم تحديث الملف الشخصي.';

  @override
  String get legacyUibda244507b =>
      'ستظهر هنا تغييرات الملف الشخصي أو الشركة أو الإعدادات.';

  @override
  String get legacyUi204be1a53a => 'المتوقع';

  @override
  String get legacyUi5c620cdb78 => 'نوع الإثبات';

  @override
  String get legacyUi1ed77c3f7f => 'البروتوكول';

  @override
  String get legacyUi7ceee3f361 => 'المزوّد';

  @override
  String get legacyUi767359109d => 'مرجع المزوّد';

  @override
  String get legacyUi8d80f9c731 => 'انتهاء تغطية المزوّد';

  @override
  String get legacyUi8a87202949 => 'الرابط العام غير متاح.';

  @override
  String get legacyUi411c13db3b => 'التسجيل العام والأرصدة الترحيبية.';

  @override
  String get legacyUicf0a64d03d =>
      'اسحب للتحديث وحاول تحميل ملفك الشخصي مجددًا.';

  @override
  String get legacyUic8f58b21ae => 'اسحب للتحديث أو أضف سائقًا جديدًا.';

  @override
  String get legacyUi011bc421c2 =>
      'اسحب للتحديث أو أنشئ مستخدمًا فرعيًا جديدًا.';

  @override
  String get legacyUi6a599877d7 => 'في قائمة الانتظار';

  @override
  String get legacyUia16c5bbe4b => 'النطاق';

  @override
  String get legacyUida433cd41e => 'خام';

  @override
  String get legacyUice09c15f57 => 'الحزمة الخام';

  @override
  String get legacyUia3ccb33027 => 'Razorpay';

  @override
  String get legacyUi2af51c3e17 => 'أعد إدخال كلمة المرور';

  @override
  String get legacyUi852b438f91 => 'مقروء';

  @override
  String get legacyUid14d593883 => 'قراءة الكل';

  @override
  String get legacyUi00db810078 => 'سبب التعديل';

  @override
  String get legacyUid4835a2d13 => 'سبب تعديل المبلغ (5–500 حرف)';

  @override
  String get legacyUi03c3ccd3ff => 'التنبيهات الأخيرة';

  @override
  String get legacyUi3abf211c93 => 'المدفوعات الأخيرة';

  @override
  String get legacyUi93c62de33f => 'المستخدمون الجدد';

  @override
  String get legacyUi6b33999078 => 'المركبات الجديدة';

  @override
  String get legacyUi790a1b9e7b =>
      'سيظهر النشاط الأخير هنا بمجرد إرجاعه من الخادم.';

  @override
  String get legacyUic1541851a1 => 'نشاط الخدمة الأخير';

  @override
  String get legacyUi204110a010 =>
      'سيظهر المستخدمون الجدد هنا عند إرجاعهم ضمن ملخص لوحة المعلومات.';

  @override
  String get legacyUida67fde0f7 => 'إعادة التوسيط';

  @override
  String get legacyUi7df7c0bb40 => 'بريد المستلم';

  @override
  String get legacyUi8ee92c936a => 'المستلم/المستخدم';

  @override
  String get legacyUi6577ced3c0 => 'تسجيل دفعة';

  @override
  String get legacyUib19313692e => 'سُجّلت بواسطة';

  @override
  String get legacyUi471b94d402 => 'إعادة';

  @override
  String get legacyUidb1c784524 => 'المرجع';

  @override
  String get legacyUic9dc8442d5 => 'المرجع (اختياري)';

  @override
  String get legacyUie3039b8476 => 'المرجع (اختياري)';

  @override
  String get legacyUid8b2ee1dcd => 'الحد الأقصى لطول المرجع 200 حرف';

  @override
  String get legacyUi7a8e2a362c => 'يجب ألا يزيد المرجع على 100 حرف.';

  @override
  String get legacyUi483e715402 => 'تحديث المسؤولين';

  @override
  String get legacyUif2b5787c06 => 'تحديث لوحة المعلومات';

  @override
  String get legacyUie75f05fced => 'تحديث السائقين';

  @override
  String get legacyUiebbc55f9ce => 'تحديث السجل';

  @override
  String get legacyUid0512701b2 => 'تحديث المخزون';

  @override
  String get legacyUif6cf59106a => 'تحديث الرسائل';

  @override
  String get legacyUid7cb2b4eea => 'تحديث خيارات التقرير';

  @override
  String get legacyUi323540a087 => 'تحديث الإعدادات';

  @override
  String get legacyUiade15a52e2 => 'تحديث الحالة';

  @override
  String get legacyUie4d3b8b5ff => 'تحديث الفريق';

  @override
  String get legacyUi12f92ceb6e => 'تحديث التذاكر';

  @override
  String get legacyUi3367ca735f => 'تحديث المعاملات';

  @override
  String get legacyUi892f6f322d => 'تحديث المستخدمين';

  @override
  String get legacyUidf50facb6a => 'تحديث المركبات';

  @override
  String get legacyUid42d9c1932 => 'تحديث عنصر لوحة المعلومات';

  @override
  String get legacyUia844fcf834 => 'مسجّل';

  @override
  String get legacyUi9aba73febb => 'آخر 10 محارف من الرمز المسجّل';

  @override
  String get legacyUic498221a5a => 'تاريخ التسجيل';

  @override
  String get legacyUi20e264f6a1 => 'محطة التوقف المرتبطة';

  @override
  String get legacyUi62d14389b3 => 'إعادة تحميل أنواع المستندات';

  @override
  String get legacyUia2653dac4a => 'ملاحظة';

  @override
  String get legacyUie963907dac => 'إزالة';

  @override
  String get legacyUi0fcc6594fc => 'إزالة المرفق';

  @override
  String get legacyUi48666118ca => 'إزالة صف البيانات الوصفية';

  @override
  String get legacyUif96ba1e583 => 'إلغاء إسناد المركبة إلى هذا السائق؟';

  @override
  String get legacyUi0165f7088a => 'تجديد';

  @override
  String get legacyUib219a06163 => 'تجديد المركبة';

  @override
  String get legacyUi4913250b6c => 'تجديد التغطية السنوية';

  @override
  String get legacyUif192fe3e94 => 'تجديد التغطية السنوية؟';

  @override
  String get legacyUi1cce449350 => 'جدّد حتى 100 مركبة في المرة الواحدة';

  @override
  String get legacyUi714c2b126f => 'جدّد حتى 100 مركبة في المرة الواحدة.';

  @override
  String get legacyUibb47b991fe => 'طلبات التجديد';

  @override
  String get legacyUiac2377c0dd => 'سرعة إعادة العرض';

  @override
  String get legacyUi5cc45fda55 => 'ستظهر الردود هنا بمجرد بدء المحادثة.';

  @override
  String get legacyUid7a41420c8 => 'ستظهر الردود هنا بمجرد بدء محادثة التذكرة.';

  @override
  String get legacyUi1f21d9edca => 'الرد طويل جدًا.';

  @override
  String get legacyUi4c7c79f6a9 => 'رسالة الرد مطلوبة.';

  @override
  String get legacyUic9e8dd4159 => 'تم إرسال الرد بنجاح.';

  @override
  String get legacyUi5ce1bacd48 => 'تم إرسال الرد.';

  @override
  String get legacyUi49072e5767 => 'الرد إلى (اختياري)';

  @override
  String get legacyUi6e2c712363 => 'الإبلاغ عن مشكلة';

  @override
  String get legacyUi0ca4fce136 => 'نوع التقرير';

  @override
  String get legacyUi4857497af3 => 'طلب رابط إعادة تعيين جديد';

  @override
  String get legacyUida30a140cc => 'طلب تجديد المركبة؟';

  @override
  String get legacyUic26bf60fed => 'تم الطلب';

  @override
  String get legacyUi1d3cb8a962 => 'إعادة إرسال الرمز';

  @override
  String get legacyUi56553100b0 => 'إعادة تعيين عوامل التصفية';

  @override
  String get legacyUibb02ea158c => 'رابط أو رمز إعادة التعيين';

  @override
  String get legacyUi3ddc852b26 => 'إعادة التوجيه شمالًا';

  @override
  String get legacyUi5c4bc97ee5 => 'إعادة تعيين كلمة المرور';

  @override
  String get legacyUi4f21821190 => 'تم الرد';

  @override
  String get legacyUi966ea65ee9 => 'الاستجابة بصيغة ست عشرية';

  @override
  String get legacyUi3585d7553d => 'مطعم';

  @override
  String get legacyUiab6d02bfbb => 'مقيّد من قِبل المسؤول';

  @override
  String get legacyUic7199d9e95 => 'الاحتفاظ بالبيانات';

  @override
  String get legacyUi9393bfa8e2 => 'مدة الاحتفاظ';

  @override
  String get legacyUibf1c27deea => 'إعادة محاولة تحميل العملات';

  @override
  String get legacyUi2e84dd3c7d => 'إعادة محاولة التسجيل';

  @override
  String get legacyUic507a566fc => 'دقة الترميز الجغرافي العكسي';

  @override
  String get legacyUi7148d08646 => 'النبضات';

  @override
  String get legacyUic3f104d136 => 'الدور';

  @override
  String get legacyUib1b392607d => 'تشغيل';

  @override
  String get legacyUi26c35575bf => 'تشغيل المستشعر';

  @override
  String get legacyUiba51f0a9fa => 'البحث في السجل';

  @override
  String get legacyUia84c30c93c => 'بدء التنظيف';

  @override
  String get legacyUibd4e4bc9f2 => 'رقم شريحة SIM';

  @override
  String get legacyUi135447fb8f => 'شريحة SIM فقط';

  @override
  String get legacyUi3454bbef7f => 'مزوّد شريحة SIM';

  @override
  String get legacyUi0366e95ddf => 'مزوّد شريحة SIM (اختياري)';

  @override
  String get legacyUi4636ab9e9a => 'تم تحديث شريحة SIM.';

  @override
  String get legacyUi12897d0b88 => 'حالة شريحة SIM';

  @override
  String get legacyUi1f4f5e7e3c => 'بيانات دخول حساب SMTP.';

  @override
  String get legacyUi7d08205aa6 => 'تم حفظ إعدادات SMTP';

  @override
  String get legacyUia70c3bcf1d => 'سان فرانسيسكو';

  @override
  String get legacyUi340bbc7875 => 'الأقمار الصناعية';

  @override
  String get legacyUidb95397447 => 'حفظ ملف .kml';

  @override
  String get legacyUifa2984b367 => 'حفظ التغييرات';

  @override
  String get legacyUi78fe0922d6 => 'حفظ الشركة';

  @override
  String get legacyUic6606cd51c => 'حفظ الإعدادات';

  @override
  String get legacyUi909bf3e807 => 'حفظ الملف الشخصي';

  @override
  String get legacyUif2f3d66a79 => 'مدرسة';

  @override
  String get legacyUid09c8bca28 => 'البحث برقم شريحة SIM…';

  @override
  String get legacyUiabddbf1811 => 'البحث في سجلات النشاط...';

  @override
  String get legacyUi9a99566535 => 'البحث في النشاط…';

  @override
  String get legacyUi1321daf435 => 'البحث عن السائقين المُسنَدين';

  @override
  String get legacyUie6ac2b6800 => 'البحث عن المركبات المُسنَدة';

  @override
  String get legacyUi3a97577679 => 'البحث عن السائقين المتاحين';

  @override
  String get legacyUiacd1382ab4 => 'البحث عن المركبات المتاحة';

  @override
  String get legacyUi03ef7546a9 => 'البحث بواسطة IMEI...';

  @override
  String get legacyUia8854d5f97 => 'البحث بالرمز...';

  @override
  String get legacyUi411482b8e7 =>
      'البحث بالتاريخ أو النشاط أو الأرصدة أو المركبة…';

  @override
  String get legacyUi28abc0313d => 'البحث بالاسم';

  @override
  String get legacyUi28f3d064ea => 'البحث بالاسم أو الفئة';

  @override
  String get legacyUi4120e178da => 'البحث بالاسم أو اللوحة…';

  @override
  String get legacyUibb6cfd804d => 'البحث بالاسم أو البريد الإلكتروني…';

  @override
  String get legacyUi1c1d641fe8 => 'البحث بالاسم أو اللوحة أو IMEI أو VIN';

  @override
  String get legacyUife32b8f32a => 'البحث بالاسم أو اللوحة أو IMEI…';

  @override
  String get legacyUibdc6551409 =>
      'البحث بالاسم أو اللوحة أو VIN أو IMEI أو SIM...';

  @override
  String get legacyUiba20cfd893 => 'البحث بالمرجع أو المسؤول...';

  @override
  String get legacyUi45b6baaad3 => 'البحث في السجلات اليومية...';

  @override
  String get legacyUie43926680a => 'البحث في سجلات الجهاز';

  @override
  String get legacyUi26eb1d222b => 'البحث بنوع الجهاز…';

  @override
  String get legacyUi98110e65a0 => 'البحث في السجلات المحمّلة';

  @override
  String get legacyUi48225af1f4 => 'البحث في السجلات';

  @override
  String get legacyUi20f28ed35b => 'البحث بالاسم أو IMEI أو SIM أو النوع';

  @override
  String get legacyUic60723c651 => 'البحث بالاسم أو اللوحة أو IMEI';

  @override
  String get legacyUi3dadc5cddf =>
      'البحث بالاسم أو اسم المستخدم أو البريد أو الجوال أو المركبة أو اللوحة...';

  @override
  String get legacyUi0417c5f97b =>
      'البحث بالاسم أو اسم المستخدم أو البريد أو الجوال...';

  @override
  String get legacyUi5196e5c8da => 'البحث عن مكان أو عنوان...';

  @override
  String get legacyUic3290fb221 => 'البحث عن مكان...';

  @override
  String get legacyUi60c8ce351b =>
      'البحث في الخطط أو العملات أو المدة أو السعر...';

  @override
  String get legacyUie5483c71e7 => 'البحث عن مزوّد…';

  @override
  String get legacyUi98e27d7b41 =>
      'البحث بالمرجع أو المزوّد أو الطرف المقابل...';

  @override
  String get legacyUidd77f6ecc1 =>
      'البحث بالمرجع أو المزوّد أو المستخدم أو المركبة';

  @override
  String get legacyUi0066a752cb => 'البحث عن المسارات بالاسم';

  @override
  String get legacyUi502e6eaf2c => 'البحث في المستشعرات';

  @override
  String get legacyUi0cfffb61af => 'البحث في المستشعرات...';

  @override
  String get legacyUi233ad2b14f => 'البحث بالموضوع أو الرقم أو الحالة';

  @override
  String get legacyUid320d41a03 => 'البحث في التذاكر';

  @override
  String get legacyUi65da39d5f0 => 'البحث في المعاملات...';

  @override
  String get legacyUi25dfae4e3a => 'البحث في الرحلات';

  @override
  String get legacyUida80ead473 => 'البحث عن المستخدمين غير المرتبطين...';

  @override
  String get legacyUie5b2404515 => 'البحث عن المستخدمين والمركبات…';

  @override
  String get legacyUi8cdc4c0930 => 'البحث عن المستخدمين...';

  @override
  String get legacyUi2e4b72c10c => 'البحث عن مركبة';

  @override
  String get legacyUi1bd54471c2 => 'البحث في أحداث المركبة...';

  @override
  String get legacyUiba537c59ae =>
      'البحث بالمركبة أو اللوحة أو VIN أو IMEI أو SIM أو المستخدم…';

  @override
  String get legacyUi4a54a9e6db =>
      'البحث بالمركبة أو اللوحة أو VIN أو IMEI أو SIM...';

  @override
  String get legacyUi5780b5d6bf => 'البحث عن المركبات';

  @override
  String get legacyUi50efae1b5f =>
      'البحث عن المركبات بالاسم أو اللوحة أو الخطة...';

  @override
  String get legacyUib09b43245d => 'البحث عن المركبات...';

  @override
  String get legacyUif54fbca187 => 'بحث…';

  @override
  String get legacyUifaaee5e23e => 'اختيار شريحة SIM';

  @override
  String get legacyUi69cc521201 => 'اختيار دولة';

  @override
  String get legacyUi400a58f1cc => 'اختر فترة لتحميل السجل.';

  @override
  String get legacyUie216b735f0 => 'اختر مستخدمًا أولًا.';

  @override
  String get legacyUie965317576 => 'اختر مركبة أولًا.';

  @override
  String get legacyUia72bd23c12 =>
      'اختر مركبة وحدًا زمنيًا للتوقف ونطاق التاريخ والوقت.';

  @override
  String get legacyUi29c9360313 => 'اختيار مسؤول';

  @override
  String get legacyUi8a152d2c3f => 'اختر مركبة واحدة قابلة للتجديد على الأقل';

  @override
  String get legacyUi5573da8514 => 'اختر مركبة واحدة على الأقل.';

  @override
  String get legacyUi42303635fc => 'اختيار مدينة';

  @override
  String get legacyUi9915f6e5c2 => 'اختيار لون';

  @override
  String get legacyUia96ce92893 => 'اختيار قالب أمر';

  @override
  String get legacyUi59ee76bad1 => 'اختيار دولة';

  @override
  String get legacyUi74c388ab91 => 'اختيار نطاق التاريخ والوقت';

  @override
  String get legacyUi46bfa11b12 => 'اختيار نوع الجهاز';

  @override
  String get legacyUidba2e6bd04 => 'اختيار نوع المستند';

  @override
  String get legacyUi386f8ba9d0 => 'اختيار المستخدم الرئيسي';

  @override
  String get legacyUic7a9e8ea6a => 'اختيار المزوّد';

  @override
  String get legacyUib350802ae1 => 'اختيار الولاية';

  @override
  String get legacyUi905d012288 => 'اختيار النوع';

  @override
  String get legacyUib8a1d9de7d => 'اختيار المستخدم';

  @override
  String get legacyUie574e3a29d => 'اختر مركبات تشترك خططها في العملة نفسها';

  @override
  String get legacyUi07f0f61db9 => 'الملف المحدد فارغ.';

  @override
  String get legacyUi9bc2575c39 => 'إرسال';

  @override
  String get legacyUi0ad7c21624 => 'إرسال أمر';

  @override
  String get legacyUi9b48248439 => 'أرسل أمرًا لعرض السجل.';

  @override
  String get legacyUi724aa54b02 => 'إرسال الأمر إلى المركبة؟';

  @override
  String get legacyUic70a890d14 => 'إرسال رسالة';

  @override
  String get legacyUia89d641794 => 'إرسال طلب';

  @override
  String get legacyUib8ec554332 => 'إرسال رابط إعادة التعيين';

  @override
  String get legacyUi1aba33d6c2 => 'إرسال اختبار';

  @override
  String get legacyUifc552c754d => 'إرسال بريد اختباري';

  @override
  String get legacyUi17b874d289 => 'المرسل';

  @override
  String get legacyUi679e8f61b9 => 'اسم المرسل';

  @override
  String get legacyUi73dcba5635 => 'سجل المستشعر';

  @override
  String get legacyUia14460cfb3 => 'فترة سجل المستشعر';

  @override
  String get legacyUia9bc44292f => 'إجراءات المستشعر';

  @override
  String get legacyUi18d80b838f => 'تم حذف المستشعر.';

  @override
  String get legacyUi711bf35988 => 'المستشعرات';

  @override
  String get legacyUi48380dd0e2 => 'المستشعرات غير متاحة';

  @override
  String get legacyUi35f49dcfbf => 'تم الإرسال';

  @override
  String get legacyUi2d7bb03171 =>
      'تظهر هنا الأوامر المرسلة واستجابات الأجهزة.';

  @override
  String get legacyUi1d5d1effa9 => 'عنوان URL للخادم';

  @override
  String get legacyUif85e6f1bdc => 'مدة تشغيل الخادم';

  @override
  String get legacyUi10802e852c => 'وقت الخادم';

  @override
  String get legacyUi7ef53dd844 => 'يجب أن يكون انتهاء الخدمة بعد التسجيل.';

  @override
  String get legacyUi2ad34ef4cf => 'خطة الخدمة';

  @override
  String get legacyUi2bacd5f581 => 'بداية الخدمة';

  @override
  String get legacyUiaa02a8d843 => 'تعيين ساعات تشغيل المحرك';

  @override
  String get legacyUi837c0d47b5 => 'تعيين عداد المسافة';

  @override
  String get legacyUiaef97bb06a => 'تم حفظ الإعدادات';

  @override
  String get legacyUi96a0dc481b => 'تسوّق';

  @override
  String get legacyUi5e65ca08ed => 'عنوان موجز للمشكلة';

  @override
  String get legacyUi4c742d5133 => 'عرض السياج الجغرافي';

  @override
  String get legacyUi5abbf34ba3 => 'عرض السجل';

  @override
  String get legacyUi8268618610 => 'عرض نبضات متحركة حول المركبات المتحركة';

  @override
  String get legacyUi25911d48e0 => 'عرض المزيد';

  @override
  String get legacyUi50b47f1483 => 'عرض علامات نقاط الاهتمام';

  @override
  String get legacyUib7f93469b9 => 'عرض أثر المسار';

  @override
  String get legacyUi510904927e => 'عرض اسم المركبة بجانب الأيقونة على الخريطة';

  @override
  String get legacyUi6e61e47d5c =>
      'يُعرض على الخلفيات الداكنة. PNG أو JPG أو SVG أو WEBP. الحد الأقصى 5 ميغابايت.';

  @override
  String get legacyUi39e4052ecf =>
      'يُعرض على الخلفيات الفاتحة. PNG أو JPG أو SVG أو WEBP. الحد الأقصى 5 ميغابايت.';

  @override
  String get legacyUi894bc414e6 => 'إنشاء حساب';

  @override
  String get legacyUi69c2037890 => 'الانتقال إلى النهاية';

  @override
  String get legacyUia8522e4c9d => 'الانتقال إلى البداية';

  @override
  String get legacyUi33dcec9ce4 => 'بطيء';

  @override
  String get legacyUicf606d0913 => 'أبطأ';

  @override
  String get legacyUi339c1ea94b => 'روابط التواصل الاجتماعي';

  @override
  String get legacyUi3db7211438 => 'ترتيب شرائح SIM';

  @override
  String get legacyUi66758a74bc => 'ترتيب المسؤولين';

  @override
  String get legacyUi3655295cb4 => 'ترتيب الأجهزة';

  @override
  String get legacyUi3a21e72182 => 'ترتيب السائقين';

  @override
  String get legacyUi1e891a0102 => 'ترتيب الفريق';

  @override
  String get legacyUi6d1ba980e8 => 'ترتيب المستخدمين';

  @override
  String get legacyUi2512bda9e7 => 'ترتيب المركبات';

  @override
  String get legacyUi6da13addb0 => 'المصدر';

  @override
  String get legacyUi6ace449732 => 'جنوب';

  @override
  String get legacyUi2d2cb022bc => 'السرعة';

  @override
  String get legacyUi8a14aeec13 => 'معامل ضرب السرعة';

  @override
  String get legacyUid6a0aaa660 => 'تفاوت السرعة';

  @override
  String get legacyUi09a7707087 => 'بدء يدوي';

  @override
  String get legacyUi7e244fee11 => 'يجب أن يكون وقت البدء قبل وقت الانتهاء.';

  @override
  String get legacyUia725020675 => 'الولاية';

  @override
  String get legacyUi4e5c9805af => 'الولاية (اختياري)';

  @override
  String get legacyUic01247416e => 'الولاية مطلوبة.';

  @override
  String get legacyUiedde30a0b6 => 'الحالة: ';

  @override
  String get legacyUia0539c7e7a => 'توزيع الحالات غير متاح لهذه الفترة.';

  @override
  String get legacyUie4fe064446 => 'دقائق التوقف';

  @override
  String get legacyUif32715a2f1 => 'علامة التوقف';

  @override
  String get legacyUi5ca845e914 => 'الشارع، المبنى، المنطقة…';

  @override
  String get legacyUi4d08ec5874 => 'Stripe';

  @override
  String get legacyUi8de713bd12 => 'المستخدمون الفرعيون';

  @override
  String get legacyUi97a0373212 => 'تم إنشاء المستخدم الفرعي.';

  @override
  String get legacyUi5cae4f427b => 'تم حذف المستخدم الفرعي.';

  @override
  String get legacyUi2cc74ff5c3 => 'اسم المستخدم الفرعي';

  @override
  String get legacyUie44d50f72d => 'تم تحديث المستخدم الفرعي.';

  @override
  String get legacyUibd3159ff21 => 'الموضوع مطلوب.';

  @override
  String get legacyUi6844979e4f =>
      'يجب أن يحتوي الموضوع على حرف أو رقم واحد على الأقل.';

  @override
  String get legacyUid6981f7476 => 'اشتراك';

  @override
  String get legacyUia547aab586 => 'مشترك في تحديثات البريد الإلكتروني';

  @override
  String get legacyUid7932a2917 => 'ناجح';

  @override
  String get legacyUib879505819 => 'تذكرة دعم';

  @override
  String get legacyUi848eed0fbd => 'الوسوم';

  @override
  String get legacyUi8c7e01ee22 => 'الوسوم (مفصولة بفواصل)';

  @override
  String get legacyUi1df356a49e =>
      'اضغط على الخريطة أو أدخل الإحداثيات لتحديد نقطة الاهتمام.';

  @override
  String get legacyUi61ad50a9b9 => 'الهدف';

  @override
  String get legacyUi78560d88ef => 'تم تفعيل الفريق.';

  @override
  String get legacyUid8f82f6030 => 'نشاط الفريق';

  @override
  String get legacyUi8aef227384 => 'تم تعطيل الفريق.';

  @override
  String get legacyUi72df525608 => 'تم إنشاء عضو الفريق.';

  @override
  String get legacyUi07fed9d9b3 => 'تم تحديث عضو الفريق.';

  @override
  String get legacyUi0194c31b6d => 'تم تحديث صلاحيات الفريق';

  @override
  String get legacyUi6730423d83 => 'تفاصيل القياس';

  @override
  String get legacyUieef4095d19 => 'سجلات القياس';

  @override
  String get legacyUif8d42e6122 => 'الفترة الزمنية لبيانات القياس';

  @override
  String get legacyUi3ec1ae061c => 'القالب';

  @override
  String get legacyUi7200f86ae5 => 'اختبار إشعارات الجوال';

  @override
  String get legacyUi8b9bbdf230 => 'اختبار الإشعارات الفورية';

  @override
  String get legacyUi8135cd8fa3 =>
      'يمكن للعميل إنشاء طلب جديد. لن تُمدَّد خدمة أي مركبة.';

  @override
  String get legacyUidc46c2859b => 'تنتهي صلاحية الرابط تلقائيًا.';

  @override
  String get legacyUic77eaa41ef =>
      'المؤسسة التي يديرها هذا المسؤول داخل OpenVTS.';

  @override
  String get legacyUi461197e42e =>
      'المؤسسة التي ينتمي إليها هذا المستخدم داخل OpenVTS.';

  @override
  String get legacyUia491398fbb => 'لا تتضمن استجابة الملخص نقاط المخطط بعد.';

  @override
  String get legacyUi214cddfadb =>
      'لا تتضمن استجابة الملخص المركبات الجديدة بعد.';

  @override
  String get legacyUi9e4a7b1c4c => 'دليل الصلاحيات غير متاح. التعديل معطّل.';

  @override
  String get legacyUiac4a475bbb =>
      'أرجع الخادم دليل صلاحيات غير مدعوم. التعديل معطّل.';

  @override
  String get legacyUi8895c1d4b6 =>
      'اكتمل الرفع، لكن الخادم لم يُرجع صورة الملف الشخصي الجديدة.';

  @override
  String get legacyUidbc2f6bd85 => 'لا توجد تنبيهات متاحة حاليًا.';

  @override
  String get legacyUi9b519b14b9 => 'لا توجد أحداث في هذا اليوم';

  @override
  String get legacyUi354cfe028c =>
      'تمنح هذه التغييرات صلاحية الوصول الشامل أو الحذف. هل تريد تطبيقها على عضو الفريق هذا؟';

  @override
  String get legacyUi0f6cc3a89c => 'هذا الشهر';

  @override
  String get legacyUi77528c94d9 => 'هذا العام';

  @override
  String get legacyUi951f495b34 => 'لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get legacyUi9b646010b8 => 'نوع الملف هذا غير مسموح.';

  @override
  String get legacyUi1b4785331d => 'هذا الشهر';

  @override
  String get legacyUi0e606e3993 =>
      'لا تحتوي لوحة المعلومات المحفوظة على أي عناصر بعد.';

  @override
  String get legacyUi1e191e95f4 => 'هذه التذكرة مغلقة.';

  @override
  String get legacyUi8866cb1e0a =>
      'يستهلك هذا رصيدًا واحدًا من الحساب عندما تكون المركبة مؤهلة.';

  @override
  String get legacyUi7b72883e07 => 'هذا الأسبوع';

  @override
  String get legacyUi261bd2f51b => 'محادثة التذكرة';

  @override
  String get legacyUie1b858991f => 'تم إنشاء التذكرة.';

  @override
  String get legacyUi61322c9a86 => 'تفاصيل التذكرة';

  @override
  String get legacyUif1e8e34245 => 'تفاصيل التذكرة غير متاحة';

  @override
  String get legacyUiaa27494c39 => 'تم تحديث حالة التذكرة.';

  @override
  String get legacyUiedcd363083 => 'انتهت المهلة';

  @override
  String get legacyUi768e0c1c69 => 'العنوان';

  @override
  String get legacyUie39bf0152d => 'المسافة اليوم';

  @override
  String get legacyUif43482f042 => 'ساعات تشغيل المحرك اليوم';

  @override
  String get legacyUi7adacb5405 => 'تبديل الحالة';

  @override
  String get legacyUi6d91e0bb03 => 'هامش السماح';

  @override
  String get legacyUid1bbcb6c01 => 'هامش السماح (متر)';

  @override
  String get legacyUi63cfb27f40 => 'أبرز العملاء';

  @override
  String get legacyUibc6debbc28 => 'الأصول الأعلى أداءً';

  @override
  String get legacyUib25928c699 => 'الإجمالي';

  @override
  String get legacyUia672e7faed => 'إجمالي ساعات تشغيل المحرك';

  @override
  String get legacyUie9511a6560 => 'إجمالي المستلم';

  @override
  String get legacyUia028fce203 => 'إجمالي المستخدمين';

  @override
  String get legacyUi5bcce6c936 => 'إجمالي المركبات';

  @override
  String get legacyUi7b777b27e0 => 'إجمالي ساعات تشغيل المحرك';

  @override
  String get legacyUi8578188376 => 'إجمالي السجلات';

  @override
  String get legacyUi0538b10824 => 'رمز QR لرابط التتبّع';

  @override
  String get legacyUi070fb0b6ea => 'تم حذف رابط التتبّع.';

  @override
  String get legacyUief1f899cb2 => 'تفاصيل المعاملة';

  @override
  String get legacyUi06d8ffe653 => 'معرّف المعاملة';

  @override
  String get legacyUi105b1510d9 => 'سيظهر نشاط المعاملات هنا عند توفّره.';

  @override
  String get legacyUid016e453e5 => 'تفاصيل المعاملة';

  @override
  String get legacyUiab39260fea => 'الانتقالات';

  @override
  String get legacyUic10d76c9a4 => 'النقل';

  @override
  String get legacyUie82c27ca1d => 'تم إلغاء الرحلة';

  @override
  String get legacyUi4a9e77914e => 'جرّب اسمًا أو لوحة مختلفة.';

  @override
  String get legacyUi4e653834fa => 'جرّب بحثًا أو عامل تصفية مختلفًا.';

  @override
  String get legacyUi39d6420eaa => 'جرّب عبارة بحث مختلفة';

  @override
  String get legacyUi0ba628a33e => 'جرّب عبارة بحث مختلفة.';

  @override
  String get legacyUi10239b38b5 =>
      'جرّب تعديل عوامل التصفية الحالية أو عبارة البحث.';

  @override
  String get legacyUi2253479cff => 'جرّب تعديل عوامل التصفية.';

  @override
  String get legacyUie3f4c649b5 => 'جرّب اسمًا أو رقم لوحة آخر.';

  @override
  String get legacyUi10f570e880 => 'جرّب تغيير عوامل التصفية أو عبارة البحث.';

  @override
  String get legacyUif28432df1f => 'جرّب تغيير عوامل التصفية.';

  @override
  String get legacyUi3c86b09439 => 'جرّب تغيير البحث أو عوامل التصفية.';

  @override
  String get legacyUi0ba0bd18bf => 'جرّب مسح البحث أو عوامل تصفية الحالة.';

  @override
  String get legacyUi7a2fe508f6 =>
      'جرّب التحديث. إذا استمرت المشكلة، فقد لا تتوفّر تفضيلات إشعارات لحسابك بعد.';

  @override
  String get legacyUia0b470cb00 => 'Twitter / X';

  @override
  String get legacyUi8981df4d6a => 'Twitter/X';

  @override
  String get legacyUi3deb745651 => 'النوع';

  @override
  String get legacyUie298b0ec36 => 'اكتب ';

  @override
  String get legacyUi4b3072dd4e => 'أدخل بيانات الأمر';

  @override
  String get legacyUi5712bb4ea1 => 'إدخال يدوي';

  @override
  String get legacyUi968be8d576 => 'تعذّر تغيير كلمة المرور.';

  @override
  String get legacyUi1da33a6b30 => 'تعذّر تحميل المدن.';

  @override
  String get legacyUia4c5468d38 => 'تعذّر تحميل تفاصيل الشركة.';

  @override
  String get legacyUicbae41853b => 'تعذّر تحميل خيارات النموذج.';

  @override
  String get legacyUid06763ac1a => 'تعذّر تحميل الولايات.';

  @override
  String get legacyUia471ebf750 => 'تعذّر تحميل المستخدمين.';

  @override
  String get legacyUibf0bc28bdb => 'تعذّر تحميل المركبات.';

  @override
  String get legacyUid73d7a7c96 => 'تعذّر فتح الملف.';

  @override
  String get legacyUi8ace6e9280 => 'تعذّر فتح أداة اختيار الصور.';

  @override
  String get legacyUidcbaa0588e => 'تعذّر فتح الملاحة لهذه المركبة.';

  @override
  String get legacyUi14fdbab84b => 'تعذّر فتح هذا المرفق.';

  @override
  String get legacyUia457295e9f => 'تعذّرت قراءة الصورة المحددة.';

  @override
  String get legacyUi9e97e5bfed => 'تعذّر تحديث المستخدمين.';

  @override
  String get legacyUi800f200671 => 'تعذّر تحديث الحالة.';

  @override
  String get legacyUice1c9c972b => 'تعذّر تحديث حالة عضو الفريق.';

  @override
  String get legacyUib5f12c7d4f => 'تعذّر تحديث عضو الفريق.';

  @override
  String get legacyUia046b8ac56 => 'تعذّر تحديث عنوان URL للخادم.';

  @override
  String get legacyUi896bfd3a9a => 'إلغاء الإسناد';

  @override
  String get legacyUi7be6acc7f8 => 'إلغاء إسناد المستخدم؟';

  @override
  String get legacyUi05027a8753 => 'إلغاء إسناد المستخدم';

  @override
  String get legacyUi2d5a96092e => 'إلغاء إسناد المركبة';

  @override
  String get legacyUi39fc721248 => 'تراجع';

  @override
  String get legacyUice77c2f42c => 'رمز فريد';

  @override
  String get legacyUif6b935ab33 => 'الوحدة';

  @override
  String get legacyUi07b032b56f => 'غير مقروء';

  @override
  String get legacyUi100cb4d890 => 'نوع الملف غير مدعوم.';

  @override
  String get legacyUicb9925a338 =>
      'التنسيق غير مدعوم. استخدم PNG أو JPG أو JPEG أو WEBP.';

  @override
  String get legacyUi99974d3476 => 'عنصر لوحة معلومات غير مدعوم';

  @override
  String get legacyUieb27a190c0 => 'غير متحقق منه';

  @override
  String get legacyUi61dcf34e70 => 'تحديث كلمة المرور';

  @override
  String get legacyUieae1f5caf5 => 'تحديث الحالة';

  @override
  String get legacyUif2f8570ddd => 'تم التحديث';

  @override
  String get legacyUi22714274a4 => 'وقت التحديث';

  @override
  String get legacyUi8bdf057f91 => 'رفع';

  @override
  String get legacyUi9e2628eec4 => 'رفع مستند';

  @override
  String get legacyUidcad7d982a => 'ارفع مستندًا للبدء.';

  @override
  String get legacyUi73183a7050 => 'رفع مستند';

  @override
  String get legacyUid714896782 => 'ارفع مستندات هذه المركبة.';

  @override
  String get legacyUi4b87ccd949 =>
      'ارفع ملفات السائق مثل رخصة القيادة أو إثباتات الهوية.';

  @override
  String get legacyUi6aafa80cab => 'مدة التشغيل';

  @override
  String get legacyUif1f71137de => 'استخدم كلمة مرور قوية وفريدة';

  @override
  String get legacyUid81b6af542 => 'استخدام الكل';

  @override
  String get legacyUi5895bc72eb =>
      'تُستخدم للإعدادات الإقليمية الافتراضية مثل العملة والمنطقة الزمنية والتوجيه.';

  @override
  String get legacyUi81c9245d46 => 'تذاكر المستخدمين';

  @override
  String get legacyUi81939432dd => 'إجراءات المستخدم';

  @override
  String get legacyUi0abfc13cb8 => 'تم إسناد المستخدم.';

  @override
  String get legacyUi6188702f9e => 'تم إنشاء المستخدم وتحديده';

  @override
  String get legacyUi0ba72d0bce => 'تم حذف المستخدم.';

  @override
  String get legacyUi8fd72dd6f9 => 'المستخدم مطلوب';

  @override
  String get legacyUi5ed13310cc => 'المستخدم مطلوب.';

  @override
  String get legacyUib0b238b57a => 'تم تحديث صلاحيات المستخدم';

  @override
  String get legacyUia42cd2f9d5 => 'تم إلغاء إسناد المستخدم.';

  @override
  String get legacyUi2355aced23 => 'تم تحديث المستخدم.';

  @override
  String get legacyUi84c29015de => 'اسم المستخدم';

  @override
  String get legacyUib1974b83bc => 'اسم المستخدم (اختياري)';

  @override
  String get legacyUi2c7ab350b3 => 'اسم المستخدم أو البريد الإلكتروني';

  @override
  String get legacyUi73dbef356e => 'VIN (اختياري)';

  @override
  String get legacyUi39852971ee => 'رقم VIN';

  @override
  String get legacyUia4aefa35c3 => 'صالح';

  @override
  String get legacyUi8dce170de2 => 'القيمة';

  @override
  String get legacyUi7bac966778 => 'المركبة / الخطة';

  @override
  String get legacyUi43188a5960 => 'تفاصيل حدث المركبة';

  @override
  String get legacyUi2d80c33ed3 => 'أحداث المركبة';

  @override
  String get legacyUi4d461104bf => 'انتهاء صلاحية المركبة';

  @override
  String get legacyUi9e47ccbff4 => 'معرّف IMEI للمركبة مطلوب لتحميل الأحداث.';

  @override
  String get legacyUi2b51e72835 =>
      'معرّف IMEI للمركبة مطلوب لتحميل المستشعرات.';

  @override
  String get legacyUief04c2235a =>
      'معرّف IMEI للمركبة مطلوب لتحميل سجلات القياس.';

  @override
  String get legacyUi62dc158d0e => 'تسمية المركبة';

  @override
  String get legacyUicb4e4154e4 => 'بيانات المركبة الوصفية';

  @override
  String get legacyUi92dc53a1bc => 'اسم المركبة';

  @override
  String get legacyUi441399c250 => 'اختيار المركبة';

  @override
  String get legacyUi2d6ca00998 => 'نوع المركبة';

  @override
  String get legacyUi5c931770ef => 'إجراءات المركبة';

  @override
  String get legacyUi6ac26355c9 => 'سيظهر هنا نشاط المركبة وسجلات النظام.';

  @override
  String get legacyUi4e4942337f => 'المركبة والخطة';

  @override
  String get legacyUi6ec60a25f7 => 'تم إسناد المركبة.';

  @override
  String get legacyUia31471cef9 =>
      'ستظهر هنا عمليات إسناد المركبات أو تحديث بياناتها.';

  @override
  String get legacyUib7975a2537 => 'تم حذف المركبة.';

  @override
  String get legacyUiff47117f38 => 'تفاصيل المركبة';

  @override
  String get legacyUia1fbfba50c => 'تفاصيل المركبة غير متاحة.';

  @override
  String get legacyUi79c500fa20 => 'الفترة الزمنية لأحداث المركبة';

  @override
  String get legacyUie981db4fa0 => 'ستظهر أحداث المركبة هنا.';

  @override
  String get legacyUi7eefc642f4 => 'مجموعة المركبات';

  @override
  String get legacyUi5cd0230ee5 => 'معرّف المركبة مفقود.';

  @override
  String get legacyUi39ea43c097 => 'رقم تعريف المركبة';

  @override
  String get legacyUida83429197 => 'اسم المركبة';

  @override
  String get legacyUi750a5503ac => 'موقع المركبة';

  @override
  String get legacyUi40a1e7dd80 => 'سجل المركبة غير متاح.';

  @override
  String get legacyUi686853d97d => 'تم تقديم دفعة تجديد المركبة';

  @override
  String get legacyUie1071916e2 => 'تم تسجيل تجديد المركبة.';

  @override
  String get legacyUibf31403ac2 => 'نطاق المركبات';

  @override
  String get legacyUi3c760a5151 => 'خدمة المركبة';

  @override
  String get legacyUi9aafada9ec =>
      'إصدار خدمة المركبة غير متاح. أعد التحميل قبل التعديل.';

  @override
  String get legacyUia0d9ad9324 => 'تم تحديث خدمة المركبة';

  @override
  String get legacyUi97d4120359 => 'خدمات المركبات';

  @override
  String get legacyUif9709ba7c4 =>
      'تحدّث بيانات قياس المركبة تقدّم الرحلة تلقائيًا. يتاح الإكمال اليدوي لمحطة التوقف الحالية فقط.';

  @override
  String get legacyUi9644381920 => 'نوع المركبة';

  @override
  String get legacyUi8b26242493 => 'تصفية حسب نوع المركبة';

  @override
  String get legacyUi2a37343d0a => 'تم إلغاء إسناد المركبة.';

  @override
  String get legacyUif28657d034 => 'المركبة غير متاحة';

  @override
  String get legacyUi917981e400 => 'تم تحديث المركبة.';

  @override
  String get legacyUi02236966b5 => 'المركبات المتأثرة';

  @override
  String get legacyUi776abb6631 => 'تم إسناد المركبات.';

  @override
  String get legacyUi433457e28d => 'تعذّر تحميل المركبات.';

  @override
  String get legacyUi03128bed90 => 'التحقق';

  @override
  String get legacyUiaed3b8c6a7 => 'تم التحقق';

  @override
  String get legacyUidda6ac27b9 => 'تحقّق';

  @override
  String get legacyUi69bd4ef9fb => 'عرض';

  @override
  String get legacyUi5b9306d29c => 'عرض المدفوعات';

  @override
  String get legacyUie3c9374cd6 => 'عرض جميع الرحلات';

  @override
  String get legacyUib1614cb4e6 => 'عرض/تنزيل';

  @override
  String get legacyUi1b6cc58781 => 'المخالفات حسب الخطورة';

  @override
  String get legacyUi1fe59390ac => 'ظاهر';

  @override
  String get legacyUi4fc5a421da => 'ظاهر للمسؤول';

  @override
  String get legacyUi1448afee1d => 'ظاهر للسائق';

  @override
  String get legacyUib60862f485 => 'المحفظة';

  @override
  String get legacyUic4fe2a7498 => 'إشعارات الويب';

  @override
  String get legacyUi2e8a57cc5c => 'الموقع الإلكتروني';

  @override
  String get legacyUib32233ad82 => 'عنوان URL للموقع';

  @override
  String get legacyUica976c5dc6 => 'المقارنة الأسبوعية';

  @override
  String get legacyUidd322f2dc7 => 'غرب';

  @override
  String get legacyUib336fc5587 => 'WhatsApp';

  @override
  String get legacyUi16ec75e229 => 'الاسم الذي يراه المستلمون في صندوق الوارد.';

  @override
  String get legacyUi682d44be54 => 'مع جهاز';

  @override
  String get legacyUi0a58e1d0a2 => 'كتابة رد';

  @override
  String get legacyUi126cd2cd36 => 'اكتب ردًا...';

  @override
  String get legacyUib58c0082b4 => 'اطّلعت على كل المستجدات.';

  @override
  String get legacyUi558865a16f => 'YouTube';

  @override
  String get legacyUid3639ca4df => 'لا يملك حسابك صلاحية عرض هذا القسم.';

  @override
  String get legacyUice100fe123 =>
      'ستفقد تغييراتك. لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get legacyUi9b3cbed5c4 => 'التكبير';

  @override
  String get legacyUi4fc05f2763 => 'تكبير';

  @override
  String get legacyUia4ae4b24a1 => 'تصغير';

  @override
  String get legacyUib6958e3c52 => 'مفتاح API أو اسم المستخدم';

  @override
  String get legacyUib5f203a910 => 'cmdId';

  @override
  String get legacyUif05135d639 => 'تأمين، تصريح';

  @override
  String get legacyUid127ec8ef2 => 'jane@company.com';

  @override
  String get legacyUi216fb6179a => 'km/h, C, V';

  @override
  String get legacyUi7252f9e8d5 => 'آخر 7 أيام';

  @override
  String get legacyUibbdead93fb => 'رخصة، هوية، تصريح';

  @override
  String get legacyUid7cb0327fd => 'رخصة، تأمين';

  @override
  String get legacyUica62660225 => 'noreply@example.com';

  @override
  String get legacyUid043e53c7d => 'queueId';

  @override
  String get legacyUi11c8ce1244 => 'recipient@example.com';

  @override
  String get legacyUi4b329f8934 => 'سرعة، وقود';

  @override
  String get legacyUi65e012062c => 'support@example.com';

  @override
  String get legacyUi0bd41b4761 => 'هذا الشهر';

  @override
  String get legacyUie92d4d638a => 'أسبوع / شهر';

  @override
  String get legacyUia126722ec0 => 'يحتاج إلى اهتمام';

  @override
  String get legacyUi51eab2420d => 'إجراءات مسؤول التشغيل';

  @override
  String get legacyUi8bdea32153 => 'لا يوجد نشاط بعد.';

  @override
  String get legacyUi05e3a866c3 =>
      'تم حفظ الجدول، لكن تعذّر توليد بعض الرحلات.';

  @override
  String get legacyUi2924d70976 => 'تاريخ فقط';

  @override
  String get legacyUi63f39eeeb7 => 'وقت محدد';

  @override
  String get legacyUi6930391c64 => 'فترة زمنية';

  @override
  String get legacyUi601d153162 => 'عدة أيام';

  @override
  String get legacyUif61eadaf15 => 'قيد التنفيذ';

  @override
  String get legacyUia1bf92eff4 => 'ملغاة';

  @override
  String get legacyUic7dfb6f1d9 => 'متوقفة مؤقتًا';

  @override
  String get legacyUi90303d8df2 => 'منتهية';

  @override
  String get legacyUi59f1111618 => 'في رحلة';

  @override
  String get legacyUi2b613fb829 => 'لا توجد مهمة';

  @override
  String get legacyUib564001a58 => 'فائتة';

  @override
  String get legacyUi736d1eee8e => 'المركبة غير نشطة';

  @override
  String get legacyUif4330844fd => 'المركبة محظورة بسبب الترخيص';

  @override
  String get legacyUiabf81c35d4 => 'السائق مطلوب';

  @override
  String get legacyUi2c9c1f7914 => 'غير متاح';

  @override
  String get legacyUi8e9f1d6e54 => 'لم تبدأ';

  @override
  String get legacyUi4310ed540c => 'متأخرة';

  @override
  String get legacyUiaccac60339 => 'حالة استثنائية للسائق';

  @override
  String get legacyUi6b535fa681 => 'لا توجد بيانات قياس';

  @override
  String get legacyUi38a9e21ed9 => 'انحراف عن المسار';

  @override
  String get legacyUi1f5a1abf2f => 'إكمال';

  @override
  String get legacyUi5a436b7939 => 'إضافة ملاحظة';

  @override
  String get legacyUi65c821a596 => 'مباشر';

  @override
  String get legacyUi189cc40c22 => 'غير محدّث';

  @override
  String get legacyUi41c8e43d9e => 'نظام GPS للمركبة';

  @override
  String get legacyUic1220e845b => 'مدير الأسطول';

  @override
  String get legacyUi601f5ff70b => 'أتمتة النظام';

  @override
  String get legacyUi8b57ec8c92 => 'تم إنشاء المهمة';

  @override
  String get legacyUi368e5b125f => 'تم تأكيد استلام المهمة';

  @override
  String get legacyUid00c8926f5 => 'بدأت الرحلة تلقائيًا';

  @override
  String get legacyUic4b75c3924 => 'اكتملت الرحلة تلقائيًا';

  @override
  String get legacyUif98c835c4f => 'أكمل السائق الرحلة';

  @override
  String get legacyUi4bb573b356 => 'تم رصد الوصول إلى المحطة تلقائيًا';

  @override
  String get legacyUi52cd528ad4 => 'اكتملت المحطة تلقائيًا';

  @override
  String get legacyUicf338ebe5c => 'أكمل السائق المحطة';

  @override
  String get legacyUi7ef2940c95 => 'بدأ الانحراف عن المسار';

  @override
  String get legacyUi55d93aed45 => 'انتهى الانحراف عن المسار';

  @override
  String get legacyUi654c568718 => 'بدأ انقطاع بيانات القياس';

  @override
  String get legacyUi66676d64b0 => 'انتهى انقطاع بيانات القياس';

  @override
  String get legacyUi2a398797b5 => 'بدأ تجاوز السرعة';

  @override
  String get legacyUif7d315eb62 => 'انتهى تجاوز السرعة';

  @override
  String get legacyUia22d66c857 => 'تم الوصول';

  @override
  String get legacyUi5a000ad7bd => 'تم التخطي';

  @override
  String get legacyUi4028c0c8b4 => 'غير متاح';

  @override
  String get legacyUi5f174de1cc => 'إثبات';

  @override
  String get legacyUi4e91ee6122 => 'المنطقة الزمنية للحساب';

  @override
  String get legacyUi4dda6a4505 => 'إجمالي الرحلات';

  @override
  String get legacyUi523baab918 => 'قادمة';

  @override
  String get legacyUicc6e7b6a29 => 'متأخرة';

  @override
  String get legacyUie9fab1cf3a => 'الرحلات المكتملة في الموعد';

  @override
  String get legacyUibbb47a7157 => 'نسبة الالتزام بالمواعيد';

  @override
  String get legacyUi944b223791 => 'المسافة بالكيلومتر';

  @override
  String get legacyUi7c9352eed6 =>
      'ستُرسل رسالة قصيرة باستخدام إعدادات SMTP الحالية.';

  @override
  String get legacyUid173234df0 =>
      'يشير ACC إلى إشارة السلك/الإشعال. ويشير MOTION إلى استخدام الحركة بديلًا.';

  @override
  String get legacyUi598ed2889b => 'صلاحيات الوصول';

  @override
  String get legacyUi9a6d95b0c5 => 'حساب نشط';

  @override
  String get legacyUi8d00c06a55 =>
      'سجلات النشاط وأحداث المركبات وبيانات القياس';

  @override
  String get legacyUi61cc55aa04 => 'إضافة';

  @override
  String get legacyUiee01d7c402 => 'إضافة مسؤول جديد';

  @override
  String get legacyUib9b1e23f27 => 'إضافة مستخدم جديد';

  @override
  String get legacyUif2f8674f8a => 'إضافة مركبة جديدة';

  @override
  String get legacyUi23a75918ab => 'الاستخدام والنمو';

  @override
  String get legacyUi80643ec204 => 'تنظيف متقدم';

  @override
  String get legacyUicf963e5241 => 'عوامل تصفية متقدمة';

  @override
  String get legacyUi3aea7b29d9 =>
      'ميزات التقارير المتقدمة غير متاحة في العرض التجريبي العام. سجّل الدخول بحساب OpenVTS لتشغيل تقارير الأسطول وتصفّح صفحاتها وعرض مخططاتها وتصديرها.';

  @override
  String get legacyUi056677c12f => 'التنبيهات حسب الخطورة';

  @override
  String get legacyUif89ae580e8 => 'جميع المنفّذين';

  @override
  String get legacyUiaeae2d71be => 'جميع التنبيهات';

  @override
  String get legacyUic0e8e58c1a => 'جميع المصادر';

  @override
  String get legacyUic1cbbe0c5d => 'الانحراف المسموح';

  @override
  String get legacyUi826499f6b1 => 'التغطية السنوية وخدمة العميل منفصلتان.';

  @override
  String get legacyUi40e69b5db3 => 'المركبة المُسنَدة';

  @override
  String get legacyUi6771ade6e8 => 'المرفقات';

  @override
  String get legacyUi52b258c824 => 'صِف المشكلة بإيجاز وأرفق ملفات عند الحاجة.';

  @override
  String get legacyUi2f3b5c55bc => 'تصفّح';

  @override
  String get legacyUi00189ab9b2 => 'قالب CSV';

  @override
  String get legacyUi19db82215d => 'غيّر كلمة المرور لحماية الوصول إلى الحساب.';

  @override
  String get legacyUi3f657f29e6 => 'اختيار كلمة مرور جديدة';

  @override
  String get legacyUicbd1538094 =>
      'اختر كيفية استلام تنبيهات المركبات وتجاوز السرعة وأحداث الأسيجة الجغرافية.';

  @override
  String get legacyUic7cd13c042 =>
      'اختر الصفحات والتقارير المتاحة لهذا المستخدم. تحدّ التغييرات أيضًا من الصلاحيات التي يمكنه منحها للمستخدمين الفرعيين.';

  @override
  String get legacyUibe10f5c042 =>
      'اختر ما يمكن لهذا العضو عرضه وتعديله وحذفه. ينطبق «خاص» على سجلاته، وينطبق «شامل» على حسابك بأكمله.';

  @override
  String get legacyUi7834f4a6f4 =>
      'اختر وجهات تسليم التنبيهات لمجموعة الإشعارات هذه.';

  @override
  String get legacyUic23350ccde => 'تفاصيل الأمر';

  @override
  String get legacyUib2c253ba1c =>
      'أكمل الأقسام أدناه. الحقول المطلوبة مميزة بعلامة النجمة (*).';

  @override
  String get legacyUia2b4ac96b2 =>
      'الرحلات المكتملة حسب تاريخ الخدمة. تتوفّر المهام القادمة في صفحة الرحلات.';

  @override
  String get legacyUib3feb31fcb => 'إعداد التقرير';

  @override
  String get legacyUi878b163022 => 'تأكيد التنظيف';

  @override
  String get legacyUi9041d3c666 => 'تواصل مع المسؤول لإسناد مركبات.';

  @override
  String get legacyUi8e2fc0ffdc =>
      'أنشئ ملف تسجيل دخول مبسّطًا بصلاحيات محددة.';

  @override
  String get legacyUi93c1ed632d =>
      'أنشئ الأسيجة الجغرافية ونقاط الاهتمام والمسارات وأدِرها.';

  @override
  String get legacyUie4781f0bde => 'أنشئ نطاقات المسارات التشغيلية وأدِرها.';

  @override
  String get legacyUi6571e94148 =>
      'أنشئ روابط عامة آمنة للتتبّع المباشر للمركبات.';

  @override
  String get legacyUie09271eeb7 => 'تاريخ الإنشاء: ';

  @override
  String get legacyUidb0d2488de => 'المهمة الحالية';

  @override
  String get legacyUif8ece934c7 => 'إجمالي المسافات اليومية';

  @override
  String get legacyUicb47dca7e3 => 'الإجماليات اليومية للفترة المحددة';

  @override
  String get legacyUi71d6e89bcc => 'القيادة نهارًا مقابل ليلًا';

  @override
  String get legacyUi2f3c38363d => 'حذف نقطة الاهتمام؟';

  @override
  String get legacyUi30c6c6352a => 'حذف السياج الجغرافي؟';

  @override
  String get legacyUic6f82fca90 => 'حذف المسار؟';

  @override
  String get legacyUie543c4fd0c => 'مساحة عمل تجريبية • للقراءة فقط';

  @override
  String get legacyUi50dd7fb720 => 'إعدادات الجهاز';

  @override
  String get legacyUi0cf40756a6 => 'ارسم حدود التشغيل وأدِرها.';

  @override
  String get legacyUi243f6cfeec => 'الكيلومترات المقطوعة';

  @override
  String get legacyUie30d463652 => 'تفاصيل السائق غير متاحة.';

  @override
  String get legacyUi251b80c58c => 'الاشتراك بالبريد الإلكتروني';

  @override
  String get legacyUibe482973b9 => 'تفعيل SMTP';

  @override
  String get legacyUi21685f000f => 'إنهاء هذه الجلسة على هذا الجهاز.';

  @override
  String get legacyUide4f0c9387 => 'عوامل تصفية الأحداث';

  @override
  String get legacyUi6e74f5ccbd => 'الأحداث حسب النوع';

  @override
  String get legacyUi74bbe75120 => 'قريب الانتهاء';

  @override
  String get legacyUi8d00705083 => 'تاريخ الانتهاء';

  @override
  String get legacyUi0da7bfa1a0 => 'تاريخ الانتهاء (اختياري)';

  @override
  String get legacyUi86baf678e1 => 'الصفوف التي فشلت';

  @override
  String get legacyUi2b1d93a2c6 => 'تصفية سجلات النشاط';

  @override
  String get legacyUi9a4184cef3 => 'التصفية حسب المسؤول والفترة الزمنية.';

  @override
  String get legacyUi96e578211a => 'عوامل التصفية';

  @override
  String get legacyUi5360d40661 => 'نظام تشغيل الأسطول';

  @override
  String get legacyUi03d25e01e5 => 'توليد من البحث';

  @override
  String get legacyUi4d8abbdc5d => 'إنشاء التقرير';

  @override
  String get legacyUie16305f8b0 => 'فشل التوليد';

  @override
  String get legacyUid81feb6ae1 => 'عرض السجل';

  @override
  String get legacyUi6fa6308619 =>
      'تلقَّ إشعارًا عند انحراف المركبات المُسنَدة.';

  @override
  String get legacyUi4b6d6a3015 => 'مهم';

  @override
  String get legacyUic5288872fd => 'تظل المسارات غير النشطة مؤرشفة ومرئية.';

  @override
  String get legacyUi44caf74675 => 'صندوق الوارد';

  @override
  String get legacyUi3f33f2e865 =>
      'أدرج المسار الكامل، مثل http://192.168.1.10:3000/api';

  @override
  String get legacyUi1919090902 => 'آخر تسجيل دخول: ';

  @override
  String get legacyUi1c747b4f98 => 'آخر إجراء على الخادم';

  @override
  String get legacyUi9e1bba7129 => 'أحدث فترة';

  @override
  String get legacyUi72da77c7b7 =>
      'الإحداثيات المباشرة غير متاحة لهذه المركبة.';

  @override
  String get legacyUi3e893cdfd5 => 'جارٍ تحميل أنواع الأجهزة والمزوّدين...';

  @override
  String get legacyUi93fe7c05af => 'جارٍ تحميل أنواع المستندات…';

  @override
  String get legacyUi75e940ee30 => 'جارٍ تحميل السجل';

  @override
  String get legacyUi59c3981787 => 'جارٍ تحميل السجل...';

  @override
  String get legacyUibbe4cbd55c => 'جارٍ تحميل الملف الشخصي';

  @override
  String get legacyUica88017dfa => 'جارٍ تحميل حالة الاشتراك...';

  @override
  String get legacyUid1ccf4c3e4 => 'جارٍ تحميل المركبات…';

  @override
  String get legacyUif4e14815b1 => 'تسجيل الدخول كمسؤول';

  @override
  String get legacyUi353bd1ef01 => 'السجلات حسب الفئة';

  @override
  String get legacyUib2af2f11de => 'السجلات حسب المستوى';

  @override
  String get legacyUi8c97e4f07d =>
      'أدِر السائقين والمستخدمين الفرعيين المرتبطين بأسطولك.';

  @override
  String get legacyUi41948edc3a => 'أدِر السائقين والمهام والمستندات والنشاط.';

  @override
  String get legacyUi93b23afae0 => 'أدِر الأماكن المهمة ونقاط التشغيل.';

  @override
  String get legacyUi68669149c0 =>
      'أدِر المستخدمين الفرعيين وصلاحية الوصول إلى المركبات.';

  @override
  String get legacyUi9fcd87c64d => 'أدِر خطط تسعير الاشتراكات.';

  @override
  String get legacyUi274ef56d8e => 'إدارة المعاملات وتجديد اشتراكات المركبات';

  @override
  String get legacyUiff92dafaaf =>
      'أدِر المستخدمين وصلاحيات الدخول وبيانات التواصل والمركبات المُسنَدة.';

  @override
  String get legacyUib42578bf99 =>
      'تحدّث المدفوعات اليدوية المعاملات والتحليلات بعد إرسالها بنجاح.';

  @override
  String get legacyUi421878a774 => 'بيانات الخريطة © Google';

  @override
  String get legacyUi2cf55e0f5b => 'تفاصيل الخريطة';

  @override
  String get legacyUi9a3aa11de5 => 'نوع الخريطة';

  @override
  String get legacyUi09d3670056 =>
      'الحد الأقصى 10 ميغابايت. الأنواع المحظورة: exe وjs وhtml وhtm.';

  @override
  String get legacyUife0c6bc7dd => 'تشخيص إشعارات الجوال';

  @override
  String get legacyUif6f444180f =>
      'مراقبة مدة التشغيل والاعتماديات وتنفيذ إجراءات آمنة على الخدمات';

  @override
  String get legacyUi1a63cbf994 => 'رابط جديد';

  @override
  String get legacyUia40ad15529 => 'تذكرة دعم جديدة';

  @override
  String get legacyUi9f2d2d7331 => 'لم تُعَدّ أنواع مستندات للمستخدمين.';

  @override
  String get legacyUi9ec5ec0752 =>
      'لا توجد أسيجة جغرافية نشطة — ستُضمَّن جميع الأسيجة.';

  @override
  String get legacyUi0a181de203 =>
      'لا يوجد مسؤولون متاحون. اسحب للتحديث وحاول مجددًا.';

  @override
  String get legacyUi43f32b9b9d => 'لا توجد معلومات تواصل';

  @override
  String get legacyUie55a0728f0 => 'لا توجد أسيجة جغرافية للمعاينة';

  @override
  String get legacyUi115fe0fac7 => 'لم يتم العثور على مجموعات';

  @override
  String get legacyUida501f43fd => 'لا توجد بيانات نمو بعد.';

  @override
  String get legacyUi454fe267a7 => 'لا توجد بيانات وصفية';

  @override
  String get legacyUi2540cc1f1a => 'لا توجد طلبات تجديد معلّقة.';

  @override
  String get legacyUi7cd1d44b3c => 'لم يتم العثور على سجلات.';

  @override
  String get legacyUi658e79f9dc => 'لم يتم العثور على نتائج';

  @override
  String get legacyUif018f94f6e =>
      'لم تطابق أي صفوف عوامل تصفية التقرير المحددة.';

  @override
  String get legacyUibddbb17fc4 => 'عدم التحديد = الكل';

  @override
  String get legacyUi9aba7bbe44 => 'عدم التحديد = جميع الأسيجة الجغرافية.';

  @override
  String get legacyUifd548f1c32 => 'لم تُعَدّ مستشعرات لهذه المركبة';

  @override
  String get legacyUi162d1ddec0 => 'لم يتم العثور على نشاط للفريق.';

  @override
  String get legacyUi8f91f15684 => 'لا يوجد موقع GPS صالح';

  @override
  String get legacyUi74ac3b3d0d => 'لم تُسنَد مركبة.';

  @override
  String get legacyUia26d9edac3 => 'لم تُسنَد مركبات إلى حسابك';

  @override
  String get legacyUie4b1dbf423 => 'لم يتم العثور على مركبات.';

  @override
  String get legacyUi6eef664840 => 'لا شيء';

  @override
  String get legacyUif8ae6c8bbe => 'لم يُؤكَّد الاستلام';

  @override
  String get legacyUia92e15bc0a => 'تفضيلات الإشعارات';

  @override
  String get legacyUic71ffe5d22 => 'الفاصل بين الإشعارات';

  @override
  String get legacyUicb88cbc310 => 'الإشعار عند مغادرة المركبة للمسار';

  @override
  String get legacyUi0049196b0b => 'تحريك 10 أمتار';

  @override
  String get legacyUia49d76ddc1 => 'مركبة واحدة';

  @override
  String get legacyUi0080aaa977 => 'Open VTS';

  @override
  String get legacyUi032a6dcfd8 => 'افتح تذكرة الدعم لمراجعة المحادثة كاملة.';

  @override
  String get legacyUi50f8c47b2b => 'فتح في تطبيق الملاحة';

  @override
  String get legacyUi89202c7fd8 => 'مستند آخر';

  @override
  String get legacyUi27b4bf6d1b =>
      'يستخدم البريد الصادر هذا الخادم عند تفعيله.';

  @override
  String get legacyUi619d7adc2c => 'ستظهر الدفعة فورًا في قائمة المعاملات.';

  @override
  String get legacyUidc32a816e9 =>
      'إزالة الصفوف التاريخية الأقدم من مدة الاحتفاظ نهائيًا.';

  @override
  String get legacyUic2ff2762ca => 'يرجى اختيار ملف.';

  @override
  String get legacyUi3585d74456 => 'الإبقاء على تاريخ الانتهاء الحالي';

  @override
  String get legacyUia9a96ec019 => 'رئيسي';

  @override
  String get legacyUi668c4636aa => 'إثبات التسليم';

  @override
  String get legacyUif702b26481 => 'مرتّب حسب عدد المعاملات';

  @override
  String get legacyUid03c65244f => 'إعادة الحساب من الخطة';

  @override
  String get legacyUi72d5617f3f => 'النشاط الأخير';

  @override
  String get legacyUi255e5788a2 => 'استعادة الحساب';

  @override
  String get legacyUi505dddc915 => 'جارٍ التحديث';

  @override
  String get legacyUi54dd5046d0 =>
      'سيستبدل التحديث تعديلات الإشعارات غير المحفوظة بأحدث إعدادات الخادم.';

  @override
  String get legacyUi199ed09ba9 => 'صلاحية الوصول إلى التقارير';

  @override
  String get legacyUibd7b4f006d => 'الإبلاغ عن مشكلة';

  @override
  String get legacyUi8115c55b47 => 'التقارير مقيّدة في الوضع التجريبي';

  @override
  String get legacyUi6b5890ba0b =>
      'اطلب رمز تحقق وأكّده للتحقق من البريد الإلكتروني ورقم WhatsApp.';

  @override
  String get legacyUif7194e6a0d => 'الطلبات';

  @override
  String get legacyUif25bbab45d => 'توقعات الإيرادات';

  @override
  String get legacyUiec40affa3e => 'اتجاه الإيرادات';

  @override
  String get legacyUic53c3605a0 =>
      'راجع طلبات تجديد العملاء. أكّد فقط المدفوعات المستلمة فعليًا خارج التطبيق.';

  @override
  String get legacyUiffbfe1e822 => 'محطات المسار';

  @override
  String get legacyUi50eec1a359 => 'نتيجة التشغيل';

  @override
  String get legacyUi339225895f =>
      'يؤدي تشغيل التنظيف إلى حذف البيانات نهائيًا. عاين النتائج أولًا دائمًا.';

  @override
  String get legacyUifee1dff0c6 => 'متحرك مقابل متوقف';

  @override
  String get legacyUi0fb59422f6 => 'العينات';

  @override
  String get legacyUide6472b8d3 => 'اختيار النطاق الزمني';

  @override
  String get legacyUia35cfe395a => 'اختيار المجموعة';

  @override
  String get legacyUi2564e1a2c5 => 'اختيار المستشعر';

  @override
  String get legacyUifea7a520f3 => 'اختيار المركبة';

  @override
  String get legacyUi70037936c0 => 'اختيار تذكرة';

  @override
  String get legacyUieeaf903bb8 => 'اختر مركبة أولًا';

  @override
  String get legacyUiad7a8a1750 =>
      'اختر مسؤولًا وصِف المشكلة وأرفق ملفات عند الحاجة.';

  @override
  String get legacyUi9bb7b69035 => 'اختر حالة واحدة على الأقل';

  @override
  String get legacyUifcfe92e583 => 'اختيار لوحة معلومات';

  @override
  String get legacyUif9f50c1c30 =>
      'اختر المركبات والفترة الزمنية وعوامل التصفية، ثم أنشئ التقرير لعرض النتائج.';

  @override
  String get legacyUi0e40d8b0bf => 'المركبات المحددة';

  @override
  String get legacyUi43e146fb62 => 'مراقبة حالة الخادم';

  @override
  String get legacyUi644899c565 =>
      'يتحكّم انتهاء الخدمة في التتبّع المباشر. تواصل مع المسؤول للتجديد. لا يمدّد طلب التجديد الخدمة حتى تأكيد الدفع.';

  @override
  String get legacyUi5cbd584046 => 'الخدمات';

  @override
  String get legacyUi758d7f7281 => 'تعيين كنشط';

  @override
  String get legacyUi7c9275ee4b => 'تعيين كغير نشط';

  @override
  String get legacyUiddbe3ed1a3 => 'تعيين انتهاء مخصص';

  @override
  String get legacyUi7b53693e94 => 'مشاركة روابط التتبّع';

  @override
  String get legacyUidc1649a16c => 'تسجيل الخروج';

  @override
  String get legacyUi2f32be1dc7 => 'التوقيع';

  @override
  String get legacyUi51070e69d1 => 'صورة الموقع';

  @override
  String get legacyUi93773568cf => 'حد السرعة';

  @override
  String get legacyUicb672694bb => 'تصفية حسب الحالة';

  @override
  String get legacyUi511404ce3b => 'توزيع الحالات';

  @override
  String get legacyUie54e98e0cb => 'التوقف';

  @override
  String get legacyUie48d04b2b6 =>
      'قد يؤدي إيقاف الواجهة أو الخادم الخلفي أو مستمع الأجهزة إلى منعك من الوصول إلى التطبيق. تتيح هذه الصفحة بدء هذه الخدمات وإعادة تشغيلها، لكن الإيقاف معطّل.';

  @override
  String get legacyUi16b45ef102 => 'نسبة النجاح والانتظار والفشل';

  @override
  String get legacyUi12b71c3e0f => 'الملخص';

  @override
  String get legacyUied9177cab1 => 'مقاييس النظام';

  @override
  String get legacyUie20a879f45 => 'اضغط لتعديل إشعارات السياج الجغرافي';

  @override
  String get legacyUiac8b906fca => 'المركبة المستهدفة';

  @override
  String get legacyUib644561145 => 'سجل القياس';

  @override
  String get legacyUi7840676a23 => 'سجل القياس';

  @override
  String get legacyUi4ee3736ca6 =>
      'لا يمكن التراجع عن هذا الإجراء. سيُحذف السائق والمهام المرتبطة به.';

  @override
  String get legacyUi3575c0aec8 =>
      'يحذف هذا الإجراء المستخدم الفرعي نهائيًا ويلغي وصوله إلى المركبات. لا يمكن التراجع عنه.';

  @override
  String get legacyUi7f3d98b829 => 'لا يمكن حذف هذا الرابط لأن معرّفه مفقود.';

  @override
  String get legacyUi4e81e87c37 =>
      'يحذف هذا الإجراء البيانات الأقدم من مدة الاحتفاظ نهائيًا. لا يمكن التراجع عنه.';

  @override
  String get legacyUid8b029df5c =>
      'سيتوقف رابط التتبّع العام هذا عن العمل فورًا. لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get legacyUida735ce16c => 'هذا التقرير غير متاح لحسابك.';

  @override
  String get legacyUidf3e8a5fdd =>
      'هذه التذكرة مغلقة أو محلولة. الردود معطّلة.';

  @override
  String get legacyUif9c732c3c6 =>
      'هذه التذكرة مغلقة. قد يؤدي الرد إلى إعادة فتحها أو نقلها إلى «قيد التنفيذ» بحسب سلوك الخادم.';

  @override
  String get legacyUif3a8370f38 => 'إجمالي الإيرادات';

  @override
  String get legacyUie273941b29 => 'الإجماليات حسب العملة';

  @override
  String get legacyUiaa7d3d7dd9 => 'سجل المعاملات';

  @override
  String get legacyUib174443b0e => 'المعاملات والإيرادات';

  @override
  String get legacyUi9dda9aa776 => 'الرحلة';

  @override
  String get legacyUic948ed8076 => 'إثباتات الرحلة';

  @override
  String get legacyUid67a44f68d =>
      'جرّب تعديل عوامل التصفية أو الفترة الزمنية.';

  @override
  String get legacyUi078f02fe7b => 'تعذّر تحميل المستندات';

  @override
  String get legacyUi3b37311cd6 => 'تعذّر تحميل السجل';

  @override
  String get legacyUicaa5bd27e5 => 'تعذّر تحميل السجلات';

  @override
  String get legacyUi92078d350e => 'تعذّر تحميل المدفوعات';

  @override
  String get legacyUi5db77ece1a => 'تعذّر تحميل الملف الشخصي';

  @override
  String get legacyUi081863e321 => 'تعذّر تحميل التذاكر';

  @override
  String get legacyUi11f14b7638 => 'حدّث هوية الشركة وروابط التواصل الاجتماعي.';

  @override
  String get legacyUieb58c61a89 =>
      'حدّث البيانات الشخصية والعنوان. لن تُحفَظ التغييرات إلا بعد تأكيدك.';

  @override
  String get legacyUid19cf73ae1 => 'آخر تحديث: ';

  @override
  String get legacyUi9db8e8ec0b =>
      'استخدم قائمة المركبات في الخريطة المباشرة، ثم اختر الحد الزمني للتوقف ونطاق التاريخ والوقت.';

  @override
  String get legacyUid337d1a0d6 => 'معاينة المتغيرات';

  @override
  String get legacyUi63dfad55e0 => 'معلومات المركبة';

  @override
  String get legacyUi7f4567c8c2 => 'الحالة المباشرة للمركبة';

  @override
  String get legacyUiceedc505bd => 'حالة المركبة';

  @override
  String get legacyUi1f41948d84 => 'حدث المركبة';

  @override
  String get legacyUid3aee04e65 => 'مصفوفة المركبات والأسيجة الجغرافية';

  @override
  String get legacyUiefd8355920 => 'عرض الكل';

  @override
  String get legacyUi50ad3280e1 => 'عرض المركبة';

  @override
  String get legacyUi2c3c7c93f8 =>
      'اعرض المدفوعات والأرصدة والخصومات وسجلات الفوترة.';

  @override
  String get legacyUi7d9ff4f0de => 'الظهور';

  @override
  String get legacyUi79c6a6033a => 'ظاهر للمسؤول';

  @override
  String get legacyUied0069155f => 'ظاهر للمستخدم';

  @override
  String get legacyUia56d85fb20 =>
      'تتطلب متصفحات الويب أن يسمح الخادم بالطلبات من مصادر مختلفة (CORS). إذا فشل تسجيل الدخول بخطأ اتصال، فعِّل CORS على خادمك.';

  @override
  String get legacyUi4dd079044f => 'الرحلة كاملة';

  @override
  String get legacyUi4515b6c7b7 => 'يومك';

  @override
  String get legacyUi50f19ac0b4 =>
      'مستنداتك والمستندات التي شاركها مدير الأسطول معك.';

  @override
  String get legacyUi4e697d55ce => 'معاملاتك مع مالك البرنامج.';

  @override
  String get legacyUi678830983a => '— تم اختصار البيانات للعرض —';

  @override
  String legacyUi1e22f79cd9(Object value1) {
    return 'جارٍ تحميل $value1';
  }

  @override
  String legacyUi57fdb35e30(Object value1) {
    return '$value1 غير متاح';
  }

  @override
  String legacyUi1fd3e5084a(Object value1) {
    return 'لم يتم العثور على $value1';
  }

  @override
  String get legacyUie16f97dcfd => 'مسح السجل';

  @override
  String legacyUiabd4cd39b9(Object value1) {
    return '$value1 نقطة';
  }

  @override
  String legacyUi90eaac7e8b(Object value1) {
    return '$value1 توقف';
  }

  @override
  String legacyUi865d65baea(Object value1) {
    return '$value1 تجاوز للسرعة';
  }

  @override
  String legacyUi7326be7e87(Object value1, Object value2) {
    return 'الحد الأقصى $value1 $value2';
  }

  @override
  String legacyUi5fd7f54937(Object value1, Object value2) {
    return 'المتوسط $value1 $value2';
  }

  @override
  String legacyUi5f2ee53a4c(Object value1) {
    return '$value1 متحرك';
  }

  @override
  String legacyUi5c24a04874(Object value1) {
    return '$value1 متوقف';
  }

  @override
  String legacyUi2b4b82c8bb(Object value1) {
    return 'المدة: $value1';
  }

  @override
  String legacyUi27a82a7136(Object value1) {
    return '$value1 قيادة';
  }

  @override
  String legacyUi92edf7854b(Object value1) {
    return '$value1 مركبة';
  }

  @override
  String get legacyUi5d12bd5355 => 'تشغيل';

  @override
  String get legacyUi4e39567064 => 'ملاحظة (اختياري)';

  @override
  String get legacyUi932fc13e7f => 'العنوان (اختياري)';

  @override
  String legacyUi2c904359f5(Object value1) {
    return 'يتجاوز الملف الحد المسموح وهو $value1 ميغابايت';
  }

  @override
  String legacyUi66db457b99(Object value1) {
    return 'التنسيق غير مدعوم. المسموح: $value1';
  }

  @override
  String get legacyUia7cf7b25a7 => 'استبدال';

  @override
  String legacyUidf1d5f2730(Object value1) {
    return 'تم إرسال بريد اختباري إلى $value1';
  }

  @override
  String get legacyUi044b852f30 => 'إظهار كلمة المرور';

  @override
  String get legacyUie40123b4e7 => 'إخفاء كلمة المرور';

  @override
  String get legacyUi82f47c3d4d => 'تم التحقق من البريد الإلكتروني';

  @override
  String get legacyUib1a273086c => 'تم التحقق من WhatsApp';

  @override
  String legacyUi908e5c8ce5(Object value1) {
    return 'تم تسجيل الخروج من $value1';
  }

  @override
  String get legacyUi33ce417454 => 'جارٍ التحميل…';

  @override
  String get legacyUi71ae0ec96e => 'تعذّر التحميل — أعد المحاولة';

  @override
  String get legacyUi67c4d0506a => 'لا ينطبق';

  @override
  String get legacyUia0b1fb2afb => 'إظهار تأكيد كلمة المرور';

  @override
  String get legacyUie2196c3942 => 'إخفاء تأكيد كلمة المرور';

  @override
  String get legacyUi7c073937c6 => 'تم إرسال رمز التحقق إلى بريدك الإلكتروني';

  @override
  String get legacyUi8532209c49 => 'تم إرسال رمز التحقق عبر WhatsApp';

  @override
  String get legacyUi0d455a4e26 => 'التحقق من البريد الإلكتروني';

  @override
  String get legacyUi9cb68a6dd3 => 'التحقق من WhatsApp';

  @override
  String legacyUi8cf58d99c1(Object value1) {
    return 'من $value1';
  }

  @override
  String legacyUif41a1a65a6(Object value1) {
    return 'إلى $value1';
  }

  @override
  String legacyUia801634da8(Object value1) {
    return 'تم حذف $value1.';
  }

  @override
  String legacyUi73f15343e6(Object value1) {
    return 'تم تسجيل الدخول باسم $value1.';
  }

  @override
  String get legacyUi48138f08cd => 'تعطيل المسؤول';

  @override
  String get legacyUif9494a277e => 'تفعيل المسؤول';

  @override
  String get legacyUi13a84a7390 => 'تم تفعيل المسؤول.';

  @override
  String get legacyUi8181bbb7c7 => 'تم تعطيل المسؤول.';

  @override
  String get legacyUid65ded9428 => 'تعطيل';

  @override
  String get legacyUi92ef08325a => 'تفعيل';

  @override
  String get legacyUiacfd05ab80 => 'البريد الإلكتروني غير متحقق منه';

  @override
  String get legacyUi23c9dd8809 => 'تعذّر تحميل المركبات. أعد المحاولة.';

  @override
  String legacyUib089c07088(Object value1) {
    return 'GMT $value1';
  }

  @override
  String legacyUi73585fdb6f(Object value1) {
    return 'تمت إضافة $value1';
  }

  @override
  String get legacyUi410bebb5ea => 'تعذّر تحميل المستندات. أعد المحاولة.';

  @override
  String get legacyUi7f10270c45 => 'تعذّر تحميل أنواع المستندات. أعد المحاولة.';

  @override
  String get legacyUid4c2792a72 => 'مخفي';

  @override
  String get legacyUi1b7cd8a9bf => 'تم تحديث المستند.';

  @override
  String get legacyUi895a77b095 => 'تم رفع المستند.';

  @override
  String get legacyUief6604a13d => 'تعديل المستند';

  @override
  String get legacyUif6769b696e => 'تمت إضافة الأرصدة.';

  @override
  String get legacyUib16dd3b790 => 'تم خصم الأرصدة.';

  @override
  String get legacyUie890b12b34 => 'لا توجد معاملات تطابق عوامل التصفية';

  @override
  String get legacyUib71113c83a =>
      'لم يتم العثور على مدفوعات لهذا المسؤول. جرّب مسح عوامل التصفية.';

  @override
  String get legacyUi472af48c6d => 'سجّل دفعة يدوية للبدء.';

  @override
  String legacyUi46f7e02bd0(Object value1) {
    return 'تم نسخ $value1';
  }

  @override
  String legacyUi70d9eead51(Object value1) {
    return 'يجب ألا يزيد الموضوع على $value1 حرفًا.';
  }

  @override
  String legacyUifee6584f1b(Object value1) {
    return 'يجب ألا يزيد الوصف على $value1 حرفًا.';
  }

  @override
  String legacyUi830e676993(Object value1) {
    return 'يمكنك رفع حتى $value1 ملفات.';
  }

  @override
  String legacyUi4e5f407ec5(Object value1) {
    return 'تمت إزالة ملف محظور: $value1';
  }

  @override
  String legacyUib5d0b873d0(Object value1) {
    return 'تمت إزالة ملف غير مدعوم: $value1';
  }

  @override
  String legacyUid1740cec1d(Object value1) {
    return 'يتجاوز الملف 5 ميغابايت: $value1';
  }

  @override
  String legacyUie33e0ec27a(Object value1) {
    return 'يجب ألا يزيد الرد على $value1 حرفًا.';
  }

  @override
  String legacyUid9e484645b(Object value1) {
    return 'حالة التذكرة هي $value1 بالفعل.';
  }

  @override
  String legacyUiebbf66ef0e(Object value1, Object value2) {
    return 'من: $value1$value2';
  }

  @override
  String legacyUi94cf932307(Object value1) {
    return 'أُنشئ $value1';
  }

  @override
  String legacyUib5ae5701b9(Object value1) {
    return 'حُدّث $value1';
  }

  @override
  String legacyUi1a150ff203(Object value1) {
    return 'أُغلق $value1';
  }

  @override
  String get legacyUiec6952e09b => 'جارٍ التحديث';

  @override
  String legacyUi190040d9d3(Object value1) {
    return 'تتجاوز بعض الملفات 5 ميغابايت وقد أُزيلت$value1.';
  }

  @override
  String legacyUi2a432bdd06(Object value1) {
    return 'الوكيل المحلي: $value1';
  }

  @override
  String get legacyUi3adb8e50db => 'أنشئ عضو فريق للبدء.';

  @override
  String legacyUiabad5c010f(Object value1) {
    return '$value1 · الصلاحيات';
  }

  @override
  String get legacyUifb91e24fa5 => 'تحديث';

  @override
  String get legacyUia9d4f0d3b6 => 'تعذّر تحديث الصلاحيات';

  @override
  String get legacyUi918bffea2f => 'إظهار كلمة المرور الحالية';

  @override
  String get legacyUifa0245c379 => 'إخفاء كلمة المرور الحالية';

  @override
  String get legacyUi9a569782b5 => 'إظهار كلمة المرور الجديدة';

  @override
  String get legacyUiaa10918381 => 'إخفاء كلمة المرور الجديدة';

  @override
  String get legacyUi39b0c83afa => 'إظهار تأكيد كلمة المرور الجديدة';

  @override
  String get legacyUiea6f8ea221 => 'إخفاء تأكيد كلمة المرور الجديدة';

  @override
  String legacyUie30362677c(Object value1) {
    return '$value1 مسجّل';
  }

  @override
  String legacyUi060250e9ba(Object value1) {
    return '$value1 فاتورة';
  }

  @override
  String get legacyUi53e337d44c => 'حفظ الخطة';

  @override
  String get legacyUi4fc636d1bb => 'تم تحديث الخطة.';

  @override
  String get legacyUidc5a367e83 => 'تم إنشاء الخطة.';

  @override
  String get legacyUi2325fc9152 => 'لا توجد أنواع مركبات متاحة';

  @override
  String get legacyUi4e4664e8e9 => 'اختيار نوع المركبة';

  @override
  String get legacyUi37282b63dd => 'جارٍ تحميل المستخدمين...';

  @override
  String get legacyUide2b4561e4 => 'تعذّر تحميل المستخدمين';

  @override
  String get legacyUif1b918acaf => 'إنشاء المستخدم الرئيسي أو اختياره';

  @override
  String get legacyUic96ec8c8a6 => 'لا توجد أجهزة متاحة';

  @override
  String get legacyUieeed87c94b => 'اختيار جهاز GPS';

  @override
  String get legacyUie5a3dc6c41 => 'لا توجد خطط متاحة';

  @override
  String get legacyUi509d83b55f => 'اختيار خطة تسعير';

  @override
  String legacyUi91c69c8c0d(Object value1) {
    return 'تم إنشاء المركبة «$value1».';
  }

  @override
  String get legacyUi048e2d12ad => 'تم تعطيل المركبة.';

  @override
  String get legacyUib042915cc0 => 'تم تفعيل المركبة.';

  @override
  String get legacyUi3741f56c60 => 'إنشاء مستشعر';

  @override
  String get legacyUi996e719712 => 'حفظ المستشعر';

  @override
  String get legacyUiaa9bf6a127 => 'تعذّر تحديث الخدمة';

  @override
  String legacyUif17fe09e18(Object value1) {
    return 'تم تجديد التغطية السنوية لـ $value1';
  }

  @override
  String get legacyUid55d13471f => 'فشل التجديد السنوي';

  @override
  String get legacyUi2caa5892b7 => 'جارٍ الاستعلام عن الحالة...';

  @override
  String get legacyUid56ae084ba => 'تعديل المستند';

  @override
  String get legacyUi47396c4fcf => 'أنشئ سائقًا للبدء.';

  @override
  String get legacyUie4c5584c2a => 'تم تفعيل السائق.';

  @override
  String get legacyUi255f9b5d50 => 'تم تعطيل السائق.';

  @override
  String legacyUi2c5ad08780(Object value1) {
    return 'الانتهاء: $value1';
  }

  @override
  String get legacyUifc3606d535 => 'تعطيل السائق';

  @override
  String get legacyUic82a768102 => 'تفعيل السائق';

  @override
  String legacyUi3c2dd46009(Object value1) {
    return '$value1 (الحالي)';
  }

  @override
  String get legacyUi9e9d25ea74 => 'اختر الدولة أولًا';

  @override
  String get legacyUi789073b300 => 'اختر الولاية أولًا';

  @override
  String get legacyUie0c7a349f8 => 'إلغاء تحديد جميع النتائج المُصفّاة';

  @override
  String get legacyUi30a4c62f4d => 'تحديد جميع النتائج المُصفّاة';

  @override
  String get legacyUi303e32bfd9 => 'تم تأكيد الدفع وتجديد الخدمة';

  @override
  String get legacyUiad3c7489f5 => 'تم إلغاء طلب التجديد';

  @override
  String get legacyUi91027c0a9a => 'تعذّر تحديث الطلب';

  @override
  String get legacyUi3fb82cbe4b => 'البحث في تذاكر المستخدمين';

  @override
  String get legacyUi3263ab8929 => 'البحث في تذاكري';

  @override
  String get legacyUi24cae41f13 => 'تم تفعيل المستخدم.';

  @override
  String get legacyUi48d348ab09 => 'تم تعطيل المستخدم.';

  @override
  String legacyUi515200de54(Object value1) {
    return '$value1 أحرف على الأقل';
  }

  @override
  String get legacyUiea03fca475 => 'اختر دولة أولًا';

  @override
  String get legacyUi01d9797a19 => 'لا توجد ولايات متاحة';

  @override
  String get legacyUic234150a07 => 'اختيار ولاية';

  @override
  String get legacyUida9ca145a1 => 'اختر ولاية أولًا';

  @override
  String get legacyUi12fb8b7d21 => 'لا توجد مدن متاحة';

  @override
  String get legacyUia8ab373cf7 => 'اختيار مدينة';

  @override
  String legacyUi99c1db6636(Object value1) {
    return 'تم إنشاء المستخدم «$value1».';
  }

  @override
  String get legacyUi6ea66e7cf8 => 'لا يوجد سائقون مُسنَدون';

  @override
  String get legacyUi6b4d2e8347 => 'لا يوجد سائقون يطابقون بحثك';

  @override
  String legacyUic7a9755928(Object value1) {
    return 'الرخصة $value1';
  }

  @override
  String get legacyUi530530a405 => 'لا يوجد سائقون متاحون';

  @override
  String legacyUied9f265a0a(Object value1) {
    return 'البحث عن $value1…';
  }

  @override
  String get legacyUia269afc99c => 'لم يتم العثور على تذاكر';

  @override
  String get legacyUifd0ab9a284 => 'لا توجد تذاكر تطابق بحثك';

  @override
  String legacyUic93cd16b9b(Object value1) {
    return 'آخر $value1';
  }

  @override
  String legacyUib68af38cf0(Object value1) {
    return 'التذكرة $value1 بالفعل.';
  }

  @override
  String get legacyUi9ddc709693 => 'تعطيل المستخدم';

  @override
  String get legacyUiaebaaf50f8 => 'تفعيل المستخدم';

  @override
  String get legacyUi8ed321fdf0 => 'تعذّر حفظ الصلاحيات';

  @override
  String get legacyUi51c4b07667 => 'لا توجد مركبات تطابق بحثك';

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
    return 'الانتهاء $value1';
  }

  @override
  String get legacyUif0dc6b09f8 => 'لا توجد مركبات متاحة';

  @override
  String get legacyUi39d436aaba => 'بلا انتهاء';

  @override
  String get legacyUic15c47e4c9 =>
      'البحث بواسطة IMEI أو نوع الجهاز أو رقم SIM…';

  @override
  String get legacyUibc139b1c14 =>
      'البحث بواسطة SIM أو IMSI أو ICCID أو المزوّد…';

  @override
  String get legacyUiaa729739dd => 'لم يتم العثور على أجهزة';

  @override
  String get legacyUi679d782d32 => 'لم يتم العثور على شرائح SIM';

  @override
  String get legacyUi613b9215a5 => 'أضف مخزونًا للبدء.';

  @override
  String get legacyUi9f91b0dc33 => 'جارٍ تحميل أنواع الأجهزة...';

  @override
  String legacyUi9ba6bfee17(Object value1) {
    return 'استخدام إعدادات افتراضية آمنة. $value1';
  }

  @override
  String get legacyUi2919b3cdf5 => 'البريد الإلكتروني بانتظار التحقق';

  @override
  String get legacyUidfd4099c87 => 'WhatsApp بانتظار التحقق';

  @override
  String legacyUif0dd87cef8(Object value1) {
    return 'الانتقال إلى تبويب $value1';
  }

  @override
  String legacyUi364cdce6f9(Object value1) {
    return '$value1 رصيد';
  }

  @override
  String get legacyUi070e328ec8 => 'جارٍ الرفع...';

  @override
  String get legacyUie8d33553f6 => 'تغيير الصورة الشخصية';

  @override
  String legacyUi56b3825e50(Object value1) {
    return 'تطبيق الإعداد المسبق $value1';
  }

  @override
  String get legacyUi28e40daab7 => 'جارٍ إعادة الإرسال...';

  @override
  String get legacyUib707b694b2 => 'إعادة إرسال رمز التحقق';

  @override
  String legacyUia648c7bbe2(Object value1) {
    return 'أداة اختيار $value1';
  }

  @override
  String get legacyUidd1242a8fc => 'مشترك';

  @override
  String get legacyUibbf5d78203 => 'غير مشترك';

  @override
  String get legacyUi0e42454279 => 'جميع المركبات';

  @override
  String get legacyUi12e7d6beac => 'المصدر غير معروف';

  @override
  String get legacyUifb2269d326 => 'لا توجد مركبات تشغيلية متاحة.';

  @override
  String get legacyUi9dd705b078 => 'لا توجد مركبات متاحة.';

  @override
  String legacyUi8879fce2e7(Object value1, Object value2) {
    return 'تم استبعاد $value1 مركبة$value2 محظورة.';
  }

  @override
  String legacyUif039d146e6(Object value1) {
    return '$value1 مركبة مُسنَدة';
  }

  @override
  String get legacyUi02b460b2cf => 'لا توجد مركبات مطابقة';

  @override
  String get legacyUi537da7f70e =>
      'جميع المركبات مُسنَدة إلى هذا المستخدم الفرعي بالفعل.';

  @override
  String get legacyUif614a2e6b5 => 'جرّب عبارة بحث مختلفة.';

  @override
  String get legacyUi28516f977e => 'تم تعطيل المستخدم الفرعي.';

  @override
  String get legacyUi7841e93192 => 'تم تفعيل المستخدم الفرعي.';

  @override
  String get legacyUi87e328dc94 => 'مسح البحث';

  @override
  String get legacyUi72556ffa55 => 'ظاهر للسائق';

  @override
  String get legacyUi355f129929 => 'مخفي عن السائق';

  @override
  String get legacyUib68e795ff9 => 'تغيير المركبة';

  @override
  String get legacyUi0cb329674a => 'ظاهر في مستندات المستخدم';

  @override
  String get legacyUi7ab98ca9b9 => 'مخفي من مستندات المستخدم';

  @override
  String get legacyUi5f22178640 => 'يمكن للسائق رؤية هذا المستند';

  @override
  String get legacyUiaf7ad5ad5c => 'لا يمكن للسائق رؤية هذا المستند';

  @override
  String get legacyUib544cc3e95 => 'لا توجد مركبات غير مُسنَدة';

  @override
  String get legacyUidf10a27148 => 'جميع المركبات مُسنَدة بالفعل.';

  @override
  String get legacyUic3763af773 => 'لم يتم التحديث';

  @override
  String get legacyUia1f5a8dbd3 => 'لم يتم العثور على مستشعرات';

  @override
  String get legacyUi6a3625800c => 'لم تُعَدّ مستشعرات لهذه المركبة.';

  @override
  String get legacyUi5fdd1b0855 => 'إعدادات المستشعر';

  @override
  String get legacyUi2524c34a0d => 'مستشعر جديد';

  @override
  String get legacyUiae7e887517 => 'جارٍ الحفظ...';

  @override
  String get legacyUi126eda8b21 => 'جارٍ التشغيل...';

  @override
  String get legacyUi7745774c38 => 'تم إنشاء المستشعر.';

  @override
  String get legacyUi2a367dafb5 => 'تم تحديث المستشعر.';

  @override
  String get legacyUi4abc320492 => 'جارٍ تحميل الإعدادات';

  @override
  String get legacyUic0ae8f6ea8 => 'تم الحفظ';

  @override
  String get legacyUif352418f58 => 'جارٍ تحميل الأنواع…';

  @override
  String get legacyUi82385d8917 => 'جارٍ تحميل المناطق الزمنية…';

  @override
  String get legacyUi22e6340f2c => 'اختيار المنطقة الزمنية';

  @override
  String get legacyUicc4889261c => 'إعادة تحميل السجل';

  @override
  String get legacyUi9e8a1c5b7b => 'جارٍ تحميل المستشعرات…';

  @override
  String legacyUic0a743750e(Object value1) {
    return 'اختيار فترة تقرير $value1';
  }

  @override
  String legacyUi26362a69a0(Object value1) {
    return 'متحرك: $value1';
  }

  @override
  String legacyUicbbef93382(Object value1) {
    return 'متوقف: $value1';
  }

  @override
  String legacyUic1d252d58b(Object value1) {
    return '$value1 — تجاوز السرعة';
  }

  @override
  String legacyUidf3ab0c2d9(Object value1) {
    return 'نهار: $value1';
  }

  @override
  String legacyUi20076143b6(Object value1) {
    return 'ليل: $value1';
  }

  @override
  String legacyUie296339b1e(Object value1, Object value2) {
    return '$value1 رحلة$value2';
  }

  @override
  String legacyUib4c5c14ddb(Object value1) {
    return 'الحد الأقصى $value1 كم/س';
  }

  @override
  String legacyUi491fa657c5(Object value1, Object value2) {
    return '$value1: $value2 كم';
  }

  @override
  String legacyUia6587e8e7b(Object value1) {
    return 'المسافة حسب المركبة (أعلى $value1)';
  }

  @override
  String legacyUi6eca89289b(Object value1) {
    return '$value1 كم/س';
  }

  @override
  String legacyUib9a5d6824c(Object value1, Object value2) {
    return 'السياج الجغرافي $value1 لـ $value2';
  }

  @override
  String legacyUi4d24bcb058(Object value1, Object value2) {
    return 'حد تجاوز السرعة ($value1) لـ $value2';
  }

  @override
  String get legacyUi56a2285c5b => 'جارٍ الحفظ…';

  @override
  String legacyUia1f38b12bb(Object value1) {
    return 'تبديل $value1';
  }

  @override
  String legacyUic3b516d33c(Object value1) {
    return '$value1 سياج جغرافي';
  }

  @override
  String get legacyUi010f99630a => 'تعديل رابط التتبّع';

  @override
  String get legacyUibb53b1c483 => 'رابط تتبّع جديد';

  @override
  String legacyUi9287b718c6(Object value1) {
    return 'تم تحديد $value1';
  }

  @override
  String get legacyUib948ff19e4 => 'إلغاء تثبيت المربع';

  @override
  String get legacyUi85a3ef0c3f => 'تثبيت المربع';

  @override
  String get legacyUi9dd7a6b201 => 'إنشاء سياج جغرافي';

  @override
  String get legacyUidccb573a71 => 'رسم مسار';

  @override
  String legacyUi4c91961249(Object value1) {
    return 'رفع $value1 صف';
  }

  @override
  String legacyUi0ff9c73519(Object value1) {
    return '$value1 صالح';
  }

  @override
  String legacyUifa7ec0ed62(Object value1) {
    return '$value1 غير صالح';
  }

  @override
  String legacyUi1483db1240(Object value1) {
    return '$value1 ناجح';
  }

  @override
  String legacyUi2c661fac7f(Object value1) {
    return '$value1 فشل';
  }

  @override
  String get legacyUi7e613c0b85 => 'تحديد نقطة اهتمام';

  @override
  String get legacyUi4405592a72 => 'تحريك نقطة الاهتمام';

  @override
  String get legacyUi91fbb41bfb => 'استخدام هذا الموقع';

  @override
  String get legacyUif05f282071 => 'اضغط على الخريطة لتحديد نقطة الاهتمام';

  @override
  String get legacyUie8f485c68a =>
      'جرّب تعديل عوامل التصفية أو الفترة الزمنية.';

  @override
  String get legacyUia0c0bb9e85 => 'لا توجد معاملات متاحة لهذه الفترة.';

  @override
  String legacyUid7d6dade2a(Object value1) {
    return 'ناجح $value1';
  }

  @override
  String legacyUi3a0d457cee(Object value1) {
    return 'قيد الانتظار $value1';
  }

  @override
  String legacyUi07d104432b(Object value1) {
    return 'فشل $value1';
  }

  @override
  String get legacyUi3fb75e3bfe => 'إعادة تعيين كلمة المرور';

  @override
  String get legacyUif99d98e85f => 'نسيت كلمة المرور';

  @override
  String get legacyUi0d2afda86b => 'تم فتح مساحة العمل التجريبية';

  @override
  String get legacyUif06ccf010d => 'تم تسجيل الدخول بنجاح';

  @override
  String get legacyUifc45091249 => 'التبديل إلى الوضع الفاتح';

  @override
  String get legacyUic29220f958 => 'التبديل إلى الوضع الداكن';

  @override
  String get legacyUi257616b8e4 => 'لا توجد إشعارات غير مقروءة';

  @override
  String get legacyUid2609b6af1 => 'لا توجد إشعارات بعد';

  @override
  String get legacyUi04d956a670 =>
      'وُضعت علامة «مقروء» على كل الإشعارات. ستظهر التنبيهات الجديدة هنا عند وصولها.';

  @override
  String get legacyUi7fe220bd95 =>
      'ستظهر هنا تنبيهات المركبات وأحداث النظام وتحديثات العمليات.';

  @override
  String get legacyUib2f3a86e84 => 'تمت قراءة الكل';

  @override
  String get legacyUicbf6939e9e => 'جارٍ وضع العلامة…';

  @override
  String get legacyUi8958e22c23 => 'وضع علامة «مقروء» على الكل';

  @override
  String legacyUicb9ae54e8a(Object value1, Object value2) {
    return 'عرض $value1 من $value2';
  }

  @override
  String legacyUie5b28b8ae4(Object value1, Object value2) {
    return 'الصفحة $value1 من $value2';
  }

  @override
  String get legacyUic1d317a815 => 'لا توجد تذاكر مطابقة';

  @override
  String get legacyUiae9e814889 => 'لا توجد تذاكر';

  @override
  String get legacyUicc80739f43 => 'جرّب بحثًا أو عامل تصفية حالة مختلفًا.';

  @override
  String get legacyUib1ac2d29f2 => 'أنشئ تذكرة وسيتابع الفريق معك هنا.';

  @override
  String legacyUia6864fdac8(Object value1) {
    return '$value1 صف';
  }

  @override
  String get legacyUi8f26c6520d => 'جارٍ التحميل';

  @override
  String legacyUie7a93c340a(Object value1) {
    return '$value1 حدث';
  }

  @override
  String get legacyUia4ab77ad86 => 'حدث OpenVTS';

  @override
  String get legacyUif55aae5a86 => 'معرّف IMEI غير متاح';

  @override
  String get legacyUib8eb4a7ee3 => 'جارٍ تحميل الأوامر…';

  @override
  String get legacyUif7933da683 => 'لا توجد أوامر متوافقة';

  @override
  String get legacyUi4be4430e57 => 'اختيار أمر';

  @override
  String legacyUi70ac5dd63e(Object value1) {
    return 'الخط الزمني ($value1)';
  }

  @override
  String legacyUi24d8fbef9d(Object value1, Object value2) {
    return '$value1 ${value2}x';
  }

  @override
  String legacyUibde2a7e880(Object value1, Object value2, Object value3) {
    return 'الصفحة $value1 من $value2 · $value3 رحلة';
  }

  @override
  String legacyUi08343b3fe7(Object value1) {
    return 'المتبقي $value1';
  }

  @override
  String legacyUi843b148bbc(Object value1) {
    return 'الوصول المتوقع $value1';
  }

  @override
  String legacyUi46d11990c5(Object value1) {
    return 'حُدّث الموقع $value1';
  }

  @override
  String legacyUiecd87f34a4(Object value1) {
    return 'حذف $value1؟';
  }

  @override
  String legacyUi666b616488(Object value1) {
    return 'ينتهي $value1';
  }

  @override
  String get legacyUic7ac551ef0 => 'جارٍ الحذف…';

  @override
  String legacyUi27015ac78b(Object value1, Object value2) {
    return '$value1 غير مقروء · آخر $value2 إشعار';
  }

  @override
  String legacyUi46b0a7d4ca(Object value1, Object value2) {
    return 'اكتملت $value1 / $value2 محطات';
  }

  @override
  String get legacyUidc7f2c3785 => 'التاريخ غير متاح';

  @override
  String get legacyUib11b062b52 => 'رفع إثبات الرحلة';

  @override
  String get legacyUi8f1a9ca44a => 'PDF أو JPG أو PNG أو WebP · حتى 5 ميغابايت';

  @override
  String get legacyUi91df716a6b =>
      'PDF أو JPG أو PNG أو WebP أو DOC أو DOCX · حتى 5 ميغابايت';

  @override
  String get legacyUid921a79afa => 'جارٍ الرفع…';

  @override
  String legacyUiba9b85b92a(Object value1) {
    return 'آخر تحديث $value1';
  }

  @override
  String legacyUib9f8dfe265(Object value1) {
    return 'المسافة اليوم: $value1';
  }

  @override
  String legacyUif0ea529a1a(Object value1) {
    return '$value1 يوم';
  }

  @override
  String legacyUi387c4ee271(Object value1, Object value2) {
    return '$value1  ·  $value2 يوم';
  }

  @override
  String get legacyUideba3e1d0f => 'ملخص التشغيل التجريبي';

  @override
  String get legacyUia7d0c36803 => 'آخر تنظيف';

  @override
  String legacyUia24243eb0c(Object value1) {
    return 'الجداول ($value1)';
  }

  @override
  String get legacyUic74a3012a0 => 'جارٍ التحقق من الحالة…';

  @override
  String get legacyUie991a76914 => 'الحالة غير معروفة';

  @override
  String get legacyUia722bd6476 =>
      'نمو المنصة من حيث المستخدمين والمركبات والتراخيص.';

  @override
  String legacyUi852c487a99(Object value1) {
    return 'ذروة التراخيص $value1';
  }

  @override
  String legacyUic44efcae53(Object value1) {
    return 'إزالة $value1 من المنصة؟ لا يمكن التراجع عن هذا الإجراء.';
  }

  @override
  String legacyUicac4f1ac56(Object value1) {
    return 'المسؤول $value1';
  }

  @override
  String legacyUi68401f3c9e(Object value1, Object value2) {
    return 'المتوسط $value1 $value2 لكل معاملة';
  }

  @override
  String get legacyUi526698fef7 => 'تعذّر تحديث المركبات.';

  @override
  String legacyUie9b7179dd3(Object value1) {
    return 'المستندات ($value1)';
  }

  @override
  String get legacyUiefd8314874 => 'تعذّر تحديث المستندات.';

  @override
  String get legacyUie214b8a299 => 'المستند';

  @override
  String legacyUidb4675bc22(Object value1) {
    return 'الرصيد $value1';
  }

  @override
  String legacyUi16be827cb6(Object value1) {
    return 'المركبة $value1';
  }

  @override
  String get legacyUibd5caf1601 => 'التتبّع محظور بسبب حد ترخيص البرنامج.';

  @override
  String get legacyUid8663517be => 'آخر تحقق: —';

  @override
  String get legacyUi1be0035c25 => 'خاص';

  @override
  String get legacyUi5f1184f7df => 'شامل';

  @override
  String get legacyUif5f940cfe2 => 'حفظ الصلاحيات';

  @override
  String legacyUi8a9135d5ad(Object value1) {
    return 'تم تحصيل $value1%';
  }

  @override
  String legacyUi3b0c54fa00(Object value1) {
    return 'المتوقع $value1';
  }

  @override
  String legacyUi16ff2e7fa9(Object value1) {
    return 'الفرق $value1';
  }

  @override
  String legacyUi4956298616(Object value1, Object value2) {
    return '$value1 مركبة · $value2';
  }

  @override
  String legacyUi120d777276(Object value1) {
    return 'المدفوع $value1';
  }

  @override
  String legacyUi617d0ebe3d(Object value1, Object value2) {
    return '$value1 من $value2 خطط';
  }

  @override
  String get legacyUi25422daedb => 'مركبة بلا اسم';

  @override
  String legacyUicbbe928bb9(Object value1) {
    return 'التغطية السنوية: $value1';
  }

  @override
  String legacyUiec60ebb81f(Object value1) {
    return 'خدمة العميل: $value1';
  }

  @override
  String legacyUiced28bc228(Object value1) {
    return 'أرصدة الحساب: $value1';
  }

  @override
  String get legacyUic1a90693df => 'التتبّع المباشر نشط';

  @override
  String legacyUi4bdc33e519(Object value1, Object value2) {
    return '$value1 · $value2 يوم';
  }

  @override
  String get legacyUi889f282a7d => 'اختيار التاريخ والوقت';

  @override
  String get legacyUi83cbbbc297 => 'حفظ تغييرات الخدمة';

  @override
  String get legacyUi69feaaf8cd => 'جميع التواريخ';

  @override
  String get legacyUi0c6c4102d4 => 'اختياري';

  @override
  String legacyUic57882f9c9(Object value1) {
    return 'الحالة: $value1';
  }

  @override
  String legacyUiae3c1f8817(Object value1) {
    return 'إرسال هذا الأمر إلى $value1؟';
  }

  @override
  String legacyUic51f739b4e(Object value1) {
    return 'المستخدمون المُسنَدون ($value1)';
  }

  @override
  String get legacyUibc7819b34f => 'غير معروف';

  @override
  String legacyUi46aece3259(Object value1) {
    return 'إزالة $value1 من هذه المركبة؟';
  }

  @override
  String legacyUi3d2bb84b75(Object value1, Object value2) {
    return 'القيمة المباشرة: $value1 $value2';
  }

  @override
  String legacyUieb3a3daafa(Object value1) {
    return 'الرمز: $value1';
  }

  @override
  String legacyUi93aa5178d6(Object value1) {
    return 'نوع المستند: $value1';
  }

  @override
  String legacyUi0e12da1c5e(Object value1) {
    return 'الملف: $value1';
  }

  @override
  String legacyUi3ce1585208(Object value1) {
    return 'الانتهاء: $value1';
  }

  @override
  String legacyUiaeafae8a12(Object value1) {
    return 'الظهور: $value1';
  }

  @override
  String legacyUi39d7217391(Object value1) {
    return 'الوسوم: $value1';
  }

  @override
  String legacyUi4439ddf5a2(Object value1) {
    return 'تاريخ الإنشاء: $value1';
  }

  @override
  String legacyUid5c6adaee3(Object value1) {
    return 'إزالة $value1 من هذا السائق؟';
  }

  @override
  String get legacyUieb7eb7a819 => 'اختيار ملف';

  @override
  String get legacyUi8f8dd8dbd3 => 'مخفي عن المسؤول';

  @override
  String get legacyUi65d06317e9 => 'يمكن للمسؤولين رؤية هذا المستند';

  @override
  String get legacyUic0e9577a75 => 'يمكن للمالك فقط الرؤية';

  @override
  String legacyUi864cf8bc08(Object value1) {
    return 'الخصائص: $value1';
  }

  @override
  String legacyUi90d40c4249(Object value1) {
    return 'البيانات الخام: $value1';
  }

  @override
  String get legacyUia4d06ed284 => 'حدث المركبة';

  @override
  String legacyUifba61e1a50(Object value1, Object value2, Object value3,
      Object value4, Object value5, Object value6) {
    return '$value1 • $value2 • الإرسال $value3 • التسليم $value4 • إعادة المحاولة $value5$value6';
  }

  @override
  String legacyUi9c07a085f8(Object value1, Object value2) {
    return '$value1 من $value2 معاملة';
  }

  @override
  String legacyUi26b3b5dfb3(Object value1) {
    return '$value1 إعادة محاولة';
  }

  @override
  String legacyUi05563fda41(Object value1, Object value2, Object value3) {
    return 'الخطة: $value1 • $value2 $value3';
  }

  @override
  String legacyUi26400a7353(Object value1, Object value2) {
    return 'تم تحديد $value1 مركبة$value2';
  }

  @override
  String legacyUi8f4ab245d3(Object value1, Object value2) {
    return 'الإجمالي التلقائي: $value1 $value2';
  }

  @override
  String get legacyUi493de0b548 => 'انتهت صلاحية عرض السعر';

  @override
  String legacyUi78218dbd5f(Object value1, Object value2, Object value3) {
    return '$value1 · $value2 · $value3 يوم';
  }

  @override
  String legacyUi13e7357d18(Object value1) {
    return 'استلمت $value1';
  }

  @override
  String get legacyUi7e72a446c4 => 'إخفاء عوامل تصفية المدفوعات';

  @override
  String get legacyUi8f642c1d28 => 'إظهار عوامل تصفية المدفوعات';

  @override
  String legacyUi184c3f0cbb(Object value1) {
    return 'معرّف المعاملة: $value1';
  }

  @override
  String legacyUi281961b9ee(Object value1) {
    return 'المبلغ: $value1';
  }

  @override
  String legacyUib40416c0af(Object value1) {
    return 'نوع الدفع: $value1';
  }

  @override
  String legacyUia0d65517a6(Object value1) {
    return 'طريقة الدفع: $value1';
  }

  @override
  String legacyUic2d62e9f71(Object value1) {
    return 'المرجع: $value1';
  }

  @override
  String legacyUib0f627962a(Object value1) {
    return 'المزوّد: $value1';
  }

  @override
  String legacyUie802a1b0a0(Object value1) {
    return 'مرجع المزوّد: $value1';
  }

  @override
  String legacyUi2751887374(Object value1) {
    return 'من: $value1';
  }

  @override
  String legacyUi250106ee83(Object value1) {
    return 'إلى: $value1';
  }

  @override
  String legacyUi5ff8e9357b(Object value1) {
    return 'سُجّلت بواسطة: $value1';
  }

  @override
  String legacyUi7565bbdff9(Object value1) {
    return 'المركبة: $value1';
  }

  @override
  String legacyUi2b542f8050(Object value1) {
    return 'IMEI: $value1';
  }

  @override
  String legacyUi76e24a00cf(Object value1) {
    return 'الخطة: $value1';
  }

  @override
  String legacyUi972db7d65e(Object value1) {
    return 'رمز الفشل: $value1';
  }

  @override
  String legacyUif147c11396(Object value1) {
    return 'رسالة الفشل: $value1';
  }

  @override
  String get legacyUic3146cdbec => 'أنشئ تذكرة لبدء محادثة دعم.';

  @override
  String legacyUi2cbdc50885(Object value1) {
    return 'إزالة $value1 من حساب المسؤول هذا؟';
  }

  @override
  String legacyUi073ab8a05c(Object value1, Object value2) {
    return '$value1 مُسنَد - $value2 متاح';
  }

  @override
  String legacyUidcc59f9fcf(Object value1) {
    return 'اختيار $value1';
  }

  @override
  String get legacyUi7a19b6deae => 'لا توجد خيارات متاحة';

  @override
  String get legacyUif28cfb8eb0 => 'تذكرة واحدة';

  @override
  String legacyUidf08f563b7(Object value1) {
    return 'ملفات اختيارية، حتى $value1.';
  }

  @override
  String get legacyUi5f2b4010d1 => 'دفعة واحدة';

  @override
  String get legacyUi876081608a => 'تجديد — مركبة واحدة';

  @override
  String legacyUia034f3f5e5(Object value1) {
    return 'الإجمالي التقديري $value1';
  }

  @override
  String legacyUic07d143675(Object value1) {
    return 'المركبات المجدَّدة ($value1)';
  }

  @override
  String legacyUiff384c8aa4(Object value1) {
    return 'إزالة $value1 من هذا المستخدم؟';
  }

  @override
  String legacyUicb6d241451(Object value1, Object value2) {
    return '$value1 ملف - $value2 نوع مستخدم';
  }

  @override
  String get legacyUif63f04564a => 'جارٍ تحميل أنواع المستخدمين';

  @override
  String get legacyUi74b1d89d85 => 'اختيار ملف';

  @override
  String get legacyUi62783d600b => 'ظاهر في مستندات المستخدم';

  @override
  String get legacyUi38fc177e28 => 'مخفي عن المستخدم';

  @override
  String legacyUibce346e856(Object value1, Object value2) {
    return '$value1 مستخدم$value2';
  }

  @override
  String get legacyUi674b652fca => 'تغيير التواريخ';

  @override
  String get legacyUi08d0e4f72a => 'جارٍ تحميل المعاملات…';

  @override
  String get legacyUib3a56d64d2 => 'لا توجد معاملات تطابق عوامل التصفية هذه.';

  @override
  String get legacyUi049ac820da => 'جارٍ التنفيذ...';

  @override
  String legacyUie783127bc1(Object value1) {
    return 'انضم $value1';
  }

  @override
  String legacyUieb587f7802(Object value1) {
    return 'حُدّث الملف الشخصي $value1';
  }

  @override
  String get legacyUi1dfc507715 =>
      'قوائم الدول ورموز الاتصال غير متاحة. لا يزال بإمكانك التعديل يدويًا.';

  @override
  String get legacyUia7c1498ab2 =>
      'أنت مشترك في إشعارات الملف الشخصي عبر البريد الإلكتروني.';

  @override
  String get legacyUi77653a7db4 =>
      'اشترك لتلقّي تحديثات الملف الشخصي والحساب عبر البريد الإلكتروني.';

  @override
  String get legacyUid3b8add13e => 'الخيارات غير متاحة.';

  @override
  String legacyUi08b544b680(Object value1) {
    return 'المسافة المقطوعة $value1';
  }

  @override
  String legacyUi6c783ae69f(Object value1) {
    return 'عرض 10 من أحدث $value1 تنبيه';
  }

  @override
  String get legacyUi45ef37a941 => 'لم تُقدَّم رسالة.';

  @override
  String get legacyUia2ae39a298 => 'القناة غير معروفة';

  @override
  String get legacyUiceafde86d6 => 'جارٍ الإرسال';

  @override
  String get legacyUi46cefb25e2 => 'إرسال أمر';

  @override
  String legacyUib3d1704245(Object value1) {
    return 'فترة النهار: $value1';
  }

  @override
  String legacyUi735f148a9a(Object value1) {
    return 'النوع: $value1';
  }

  @override
  String legacyUi828a91effc(Object value1, Object value2, Object value3) {
    return '$value1 من $value2 مركبة • تم تحديد $value3';
  }

  @override
  String legacyUia0ebdc2307(Object value1, Object value2, Object value3) {
    return '$value1 ظاهر • تم تحميل $value2/$value3';
  }

  @override
  String legacyUi1d483a1343(Object value1) {
    return 'إزالة $value1 من هذا المستخدم الفرعي؟';
  }

  @override
  String legacyUi02b84d460d(Object value1) {
    return '$value1 متاح للإسناد';
  }

  @override
  String get legacyUi65ad788d45 => 'اللوحة غير متاحة';

  @override
  String get legacyUi7bb4f2808b =>
      'يمكن للمستخدم الفرعي الوصول إلى المركبات المُسنَدة';

  @override
  String get legacyUi26b21a0d91 => 'المستخدم الفرعي معطّل';

  @override
  String legacyUibceb1630f0(Object value1, Object value2) {
    return '$value1 ملف - $value2 نوع مستند';
  }

  @override
  String get legacyUi107b9056eb => 'جارٍ تحميل أنواع السائقين';

  @override
  String legacyUifd7e37cf51(Object value1, Object value2) {
    return '$value1 من $value2 سائق';
  }

  @override
  String legacyUi14b274c7ae(Object value1, Object value2) {
    return '$value1 من $value2 مركبة';
  }

  @override
  String legacyUi79a100acf7(Object value1) {
    return 'إزالة $value1؟';
  }

  @override
  String legacyUi26875fe2e3(Object value1, Object value2) {
    return '$value1 ملف - $value2 نوع مركبة';
  }

  @override
  String legacyUi7970bd3e0b(Object value1) {
    return 'تعذّر تحميل $value1.';
  }

  @override
  String get legacyUi5eaf2646c3 => 'جارٍ تحميل أنواع المركبات';

  @override
  String get legacyUi6ca60537ae => 'ظاهر في مستندات المركبة';

  @override
  String get legacyUi4e3d045a97 => 'مخفي عن المستخدمين';

  @override
  String get legacyUid3ce77345e => 'سجل المستشعر';

  @override
  String legacyUi5aba89cd2f(Object value1) {
    return '$value1 نقطة رقمية';
  }

  @override
  String get legacyUie86a33f16a => 'جميع الأسيجة الجغرافية';

  @override
  String legacyUi5321a316d0(Object value1) {
    return 'المصدر: $value1';
  }

  @override
  String legacyUifabeb88d9c(Object value1) {
    return 'استخدام $value1 من العناصر المحددة';
  }

  @override
  String legacyUi343ceded71(Object value1) {
    return 'الأحداث حسب السياج الجغرافي (أعلى $value1)';
  }

  @override
  String legacyUide36170209(Object value1) {
    return 'أنواع التنبيهات (أعلى $value1)';
  }

  @override
  String legacyUi019e5212ef(Object value1, Object value2) {
    return '$value1 كم/س (الحد $value2)';
  }

  @override
  String legacyUicaae0add4a(Object value1, Object value2) {
    return '$value1 يوم$value2 نشط';
  }

  @override
  String legacyUi7911e1ad0c(Object value1, Object value2) {
    return '$value1 نتيجة$value2';
  }

  @override
  String legacyUi15b175bbc9(Object value1) {
    return 'تم الإنشاء في $value1';
  }

  @override
  String legacyUi92a50db48d(Object value1) {
    return 'تصدير تقرير $value1';
  }

  @override
  String legacyUida6472ea1a(Object value1) {
    return 'ستُضمَّن المركبات البالغ عددها $value1 جميعها';
  }

  @override
  String get legacyUib0c379b2f8 => 'اختيار مجموعة مركبات';

  @override
  String get legacyUi23d6943e8b => 'اختيار المركبات';

  @override
  String legacyUi47b7508acb(Object value1) {
    return 'تم ($value1)';
  }

  @override
  String legacyUid495bed9d8(Object value1) {
    return 'تحديد جميع العناصر الظاهرة ($value1)';
  }

  @override
  String legacyUi096909f019(Object value1, Object value2) {
    return '$value1 مركبة$value2';
  }

  @override
  String legacyUie003b8a491(Object value1) {
    return 'الحد الأقصى $value1 يوم لهذا النوع من التقارير';
  }

  @override
  String legacyUif386fe6e70(Object value1) {
    return 'مسح ($value1)';
  }

  @override
  String get legacyUi706049c6a9 => 'اختيار مستشعر';

  @override
  String legacyUi2841c7f501(Object value1) {
    return 'لم يتم العثور على تقارير لـ «$value1»';
  }

  @override
  String legacyUi8002c1aa36(Object value1) {
    return 'تعتمد الأوقات على $value1.';
  }

  @override
  String legacyUieaa190f343(Object value1) {
    return '$value1 مفعّل';
  }

  @override
  String legacyUidc179fe07f(Object value1) {
    return 'يجب ألا يقل حد السرعة عن 1 $value1.';
  }

  @override
  String legacyUi11003e8471(Object value1) {
    return 'قنوات تسليم $value1';
  }

  @override
  String legacyUidc7454d672(Object value1) {
    return 'آخر حفظ $value1';
  }

  @override
  String get legacyUi7968beb979 => 'الرمز -';

  @override
  String legacyUi0528ad37c9(Object value1, Object value2) {
    return '$value1 من $value2 رابط';
  }

  @override
  String get legacyUiac2a036e38 => 'لا يوجد نشاط بعد';

  @override
  String legacyUi3a4361ec75(Object value1) {
    return 'ستتم إزالة «$value1» نهائيًا.';
  }

  @override
  String get legacyUi50a9e13fce => 'سياج جغرافي بلا اسم';

  @override
  String legacyUi760cb5d683(Object value1, Object value2) {
    return '$value1 نقطة$value2';
  }

  @override
  String legacyUifa6e784713(Object value1) {
    return 'إزالة #$value1';
  }

  @override
  String legacyUi27a25269f5(Object value1) {
    return 'ضبط دقيق ($value1 م)';
  }

  @override
  String get legacyUi39706b5a17 => 'لم يُحدَّد شكل بعد';

  @override
  String get legacyUi1bf6cb6c45 => 'الشكل جاهز';

  @override
  String get legacyUi5d437ca98b => 'ستُفعَّل الأحداث لهذا السياج الجغرافي.';

  @override
  String get legacyUi6d8b4724c6 => 'السياج الجغرافي متوقف مؤقتًا.';

  @override
  String get legacyUi7e9f5c3026 => 'ارسم نقطتين على الأقل على الخريطة.';

  @override
  String get legacyUi28134edb87 => 'التعديل على الخريطة';

  @override
  String get legacyUi0f873fbc31 => 'الرسم على الخريطة';

  @override
  String legacyUi48f6c8c8ac(Object value1) {
    return '$value1 م';
  }

  @override
  String legacyUicde59da67c(Object value1) {
    return '$value1 دقيقة';
  }

  @override
  String get legacyUi4bd1e22ea7 => 'مسار بلا اسم';

  @override
  String legacyUi198f442dfb(Object value1) {
    return 'الرأس $value1';
  }

  @override
  String legacyUibae08b3767(Object value1, Object value2) {
    return 'الصف $value1: $value2';
  }

  @override
  String get legacyUi93039e609d => 'غير محدد';

  @override
  String get legacyUid33a96e366 => 'الاختيار على الخريطة';

  @override
  String get legacyUiecd575d434 =>
      'ظاهر على الخريطة المباشرة وفي تنبيهات القرب.';

  @override
  String get legacyUi92a172ce15 => 'مخفي من التنبيهات؛ يبقى في القائمة.';

  @override
  String get legacyUi8019307fe5 => 'نقطة اهتمام بلا اسم';

  @override
  String get legacyUid14e0c02a9 => 'التتبّع المباشر متاح';

  @override
  String legacyUic814ea2b6e(Object value1) {
    return 'بداية الخدمة: $value1';
  }

  @override
  String legacyUic926abedfd(Object value1) {
    return 'انتهاء خدمة العميل: $value1';
  }

  @override
  String legacyUiae0052da76(Object value1) {
    return 'انتهاء تغطية المزوّد: $value1';
  }

  @override
  String legacyUi633ec01c21(Object value1, Object value2) {
    return '$value1 • $value2 يوم';
  }

  @override
  String get legacyUicf765512cc => 'جارٍ الإرسال…';

  @override
  String get legacyUi50756f98a3 => 'طلب التجديد';

  @override
  String legacyUid52adacef9(Object value1) {
    return 'الطلب #$value1';
  }

  @override
  String get legacyUicfeb791a76 => 'طلب منتهي الصلاحية';

  @override
  String legacyUif0d8958371(Object value1, Object value2, Object value3,
      Object value4, Object value5) {
    return '$value1\n$value2 • $value3 يوم\n$value4 $value5\n\nيجب أن يؤكّد المسؤول استلام الدفع قبل تمديد الخدمة.';
  }

  @override
  String get legacyUifdb17036d5 => 'مستخدم OpenVTS';

  @override
  String legacyUif7e83b3f19(Object value1) {
    return 'إعادة التعيين إلى الافتراضي ($value1)';
  }

  @override
  String legacyUi54e519da7f(Object value1) {
    return 'خطأ: $value1';
  }

  @override
  String get legacyUi7eb29d3565 => 'التاريخ والوقت';

  @override
  String get legacyUib1deb07e61 => 'فتح السياج الجغرافي';

  @override
  String get legacyUi1dce4bf43b => 'فتح نقطة الاهتمام';

  @override
  String get legacyUi4a0d050737 => 'فتح المسار';

  @override
  String get legacyUib6bd42e4e7 => 'قيد التنفيذ';

  @override
  String get legacyUi91edf8aff9 => 'في رحلة';

  @override
  String get legacyUi20c7c5522f => 'جاهز';

  @override
  String get legacyUi0a2b58e839 => 'لا توجد مهمة';

  @override
  String get legacyUi6cf3d41f08 => 'جميع الرحلات';

  @override
  String get legacyUif7a616a336 => 'الوصول محظور';

  @override
  String get legacyUiac7b5dd3a8 => 'المستلم غير متاح';

  @override
  String get legacyUi936d2e8552 => 'مشكلة في المركبة';

  @override
  String get legacyUi51cea59031 => 'مشكلة في المسار';

  @override
  String get legacyUia972b55b1a => 'صِف المشكلة لمسؤول التشغيل.';

  @override
  String get legacyUie0cdc02f99 => 'نظام 12 ساعة';

  @override
  String get legacyUif910251f7c => 'نظام 24 ساعة';

  @override
  String get legacyUi34ce147724 => 'من اليسار إلى اليمين';

  @override
  String get legacyUida502a644e => 'من اليمين إلى اليسار';

  @override
  String get legacyUiec45717e13 => 'تواصل مع مسؤول التشغيل لمعرفة التفاصيل.';

  @override
  String get legacyUi8a783eb3d6 => 'تم تأكيد استلام المهمة.';

  @override
  String get legacyUi00e1e19595 => 'بدء الرحلة';

  @override
  String get legacyUi0015b1903d =>
      'تبدأ الرحلات عادةً بناءً على بيانات قياس المركبة. استخدم هذا البديل اليدوي فقط عند بدء الرحلة.';

  @override
  String get legacyUib20bd98ae2 => 'إضافة ملاحظة';

  @override
  String get legacyUi42477e82cf => 'تعذّر فتح الملاحة.';

  @override
  String get legacyUiea0bd6ff3d => 'إكمال المحطة';

  @override
  String get legacyUi3d93beaa39 =>
      'اختر ملفًا غير فارغ لا يتجاوز حجمه 5 ميغابايت.';

  @override
  String get legacyUid2085cce0d => 'اختر ملفًا لرفعه.';

  @override
  String get legacyUid0193e6956 => 'اختر نوع المستند.';

  @override
  String get legacyUif378218081 => 'أدخل حرفين على الأقل.';

  @override
  String get legacyUi63f72dce85 => 'اختيار ملف';

  @override
  String get legacyUi1255774559 => 'مهام اليوم';

  @override
  String get legacyUi3528465759 => 'الرحلات المكتملة';

  @override
  String get legacyUi28793a4155 => 'المحطات المكتملة';

  @override
  String get legacyUi1683af6ce8 => 'المحطات المعلّقة';

  @override
  String mobilePluralTrips(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count رحلة',
      many: '$count رحلة',
      few: '$count رحلات',
      two: 'رحلتان',
      one: 'رحلة واحدة',
      zero: 'لا رحلات',
    );
    return '$_temp0';
  }

  @override
  String mobilePluralBlockedVehicles(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'استُبعدت $count مركبة محظورة.',
      many: 'استُبعدت $count مركبة محظورة.',
      few: 'استُبعدت $count مركبات محظورة.',
      two: 'استُبعدت مركبتان محظورتان.',
      one: 'استُبعدت مركبة محظورة واحدة.',
      zero: 'لم تُستبعد أي مركبة محظورة.',
    );
    return '$_temp0';
  }

  @override
  String mobilePluralSelectedVehicles(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مركبة محددة',
      many: '$count مركبة محددة',
      few: '$count مركبات محددة',
      two: 'مركبتان محددتان',
      one: 'مركبة واحدة محددة',
      zero: 'لم تُحدد مركبات',
    );
    return '$_temp0';
  }

  @override
  String mobilePluralUsers(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مستخدم',
      many: '$count مستخدمًا',
      few: '$count مستخدمين',
      two: 'مستخدمان',
      one: 'مستخدم واحد',
      zero: 'لا مستخدمين',
    );
    return '$_temp0';
  }

  @override
  String mobilePluralActiveDays(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count يوم نشط',
      many: '$count يومًا نشطًا',
      few: '$count أيام نشطة',
      two: 'يومان نشطان',
      one: 'يوم نشط واحد',
      zero: 'لا أيام نشطة',
    );
    return '$_temp0';
  }

  @override
  String mobilePluralResults(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count نتيجة',
      many: '$count نتيجة',
      few: '$count نتائج',
      two: 'نتيجتان',
      one: 'نتيجة واحدة',
      zero: 'لا نتائج',
    );
    return '$_temp0';
  }

  @override
  String mobilePluralVehicles(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مركبة',
      many: '$count مركبة',
      few: '$count مركبات',
      two: 'مركبتان',
      one: 'مركبة واحدة',
      zero: 'لا مركبات',
    );
    return '$_temp0';
  }

  @override
  String mobilePluralPoints(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count نقطة',
      many: '$count نقطة',
      few: '$count نقاط',
      two: 'نقطتان',
      one: 'نقطة واحدة',
      zero: 'لا نقاط',
    );
    return '$_temp0';
  }

  @override
  String get relativeJustNow => 'الآن';

  @override
  String relativeMinutesAgo(int count) {
    return 'قبل $count د';
  }

  @override
  String relativeHoursAgo(int count) {
    return 'قبل $count س';
  }

  @override
  String relativeDaysAgo(int count) {
    return 'قبل $count ي';
  }

  @override
  String get relativeYesterday => 'أمس';

  @override
  String savingChangesForTab(String tab) {
    return 'جارٍ حفظ تغييرات $tab…';
  }

  @override
  String unsavedChangesForTab(String tab) {
    return 'لديك تغييرات غير محفوظة في $tab.';
  }

  @override
  String get saving => 'جارٍ الحفظ…';

  @override
  String validationRequired(String field) {
    return '$field مطلوب';
  }

  @override
  String validationAscii(String field) {
    return 'يجب أن يحتوي $field على أحرف ASCII فقط';
  }

  @override
  String validationMinCharacters(String field, int count) {
    return 'يجب ألا يقل $field عن $count أحرف';
  }

  @override
  String validationMaxCharacters(String field, int count) {
    return 'يجب ألا يزيد $field عن $count أحرف';
  }

  @override
  String validationMinDigits(String field, int count) {
    return 'يجب ألا يقل $field عن $count أرقام';
  }

  @override
  String validationMaxDigits(String field, int count) {
    return 'يجب ألا يزيد $field عن $count أرقام';
  }

  @override
  String validationNumeric(String field) {
    return 'يجب أن يتكون $field من أرقام';
  }

  @override
  String validationMinimumCharacters(int count) {
    return 'الحد الأدنى $count أحرف';
  }

  @override
  String get validationValidEmail => 'أدخل عنوان بريد إلكتروني صحيحًا';

  @override
  String get validationValidNumber => 'أدخل رقمًا صحيحًا';

  @override
  String get validationNonnegativeCredits => 'لا يمكن أن يكون الرصيد سالبًا';

  @override
  String get validationConfirmPassword => 'يرجى تأكيد كلمة المرور';

  @override
  String get validationPasswordsMismatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get validationStandardVin =>
      'يجب أن يتكون VIN من 17 حرفًا ورقمًا، باستثناء I وO وQ';

  @override
  String get validationVinAlphanumeric =>
      'يجب أن يحتوي VIN على أحرف وأرقام فقط';

  @override
  String get validationThisField => 'هذا الحقل';

  @override
  String get validationFieldSimNumber => 'رقم SIM';
}
