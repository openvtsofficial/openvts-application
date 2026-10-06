import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/api/api_client.dart';
import 'package:open_vts/core/api/api_response.dart';
import 'package:open_vts/core/theme/open_vts_theme.dart';
import 'package:open_vts/features/user/models/user_report_model.dart';
import 'package:open_vts/features/user/models/user_report_state.dart';
import 'package:open_vts/features/user/screens/reports/widgets/filters/user_report_date_control.dart';
import 'package:open_vts/features/user/services/user_report_service.dart';
import 'package:open_vts/features/user/utils/user_report_validation.dart';
import 'package:open_vts/l10n/app_localizations.dart';
import 'package:open_vts/l10n/app_localizations_ar.dart';
import 'package:open_vts/shared/widgets/open_vts_button.dart';
import 'package:open_vts/shared/widgets/open_vts_date_time_range_selector.dart';

void main() {
  final now = DateTime(2026, 5, 16, 9, 41, 27, 321);

  Future<void> open(
    WidgetTester tester, {
    required UserReportKey key,
    ReportDateRange? initial,
    required ValueChanged<ReportDateRange?> onChanged,
    Locale locale = const Locale('en'),
    double textScale = 1,
    bool disabled = false,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: OpenVtsTheme.light,
        locale: locale,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(textScale)),
          child: child!,
        ),
        home: Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: UserReportDateControl(
                reportKey: key,
                dateRange: initial,
                now: now,
                disabled: disabled,
                onChanged: onChanged,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    if (!disabled) {
      await tester.tap(find.byType(OpenVtsDateTimeRangeField));
      await tester.pumpAndSettle();
    }
  }

  Future<void> preset(WidgetTester tester, String label) async {
    await tester.scrollUntilVisible(
      find.text(label).hitTestable(),
      160,
      scrollable: find.byWidgetPredicate(
        (widget) =>
            widget is Scrollable && widget.axisDirection == AxisDirection.right,
      ),
    );
    await tester.tap(find.text(label).hitTestable());
    await tester.pumpAndSettle();
  }

  Future<void> sendReport(
    UserReportKey key,
    ReportDateRange range,
    _Client client,
  ) async {
    final bounds = buildApiDateBounds(range)!;
    await UserReportService(client).generate(
      reportKey: key,
      vehicleScope: const ReportVehicleScope.all().toJson(),
      dateRange: range.toJson(),
      filters: const {},
      timeZone: 'Asia/Kolkata',
      from: bounds.from,
      to: bounds.to,
    );
  }

  testWidgets(
    'date-only preset preserves civil dates and inclusive API end day',
    (tester) async {
      ReportDateRange? result;
      await open(
        tester,
        key: UserReportKey.distance,
        onChanged: (value) => result = value,
      );
      expect(find.text('Last Hour'), findsNothing);
      await preset(tester, 'Last 7 Days');
      await tester.tap(find.text('Apply'));
      await tester.pumpAndSettle();
      expect(result?.toJson(), {
        'mode': 'dateOnly',
        'startDate': '2026-05-10',
        'endDate': '2026-05-16',
      });
      final client = _Client();
      await sendReport(UserReportKey.distance, result!, client);
      expect(client.body['dateRange'], result!.toJson());
      expect(client.body['timeZone'], 'Asia/Kolkata');
      expect(client.body['from'], '2026-05-10T00:00:00.000Z');
      expect(client.body['to'], '2026-05-17T00:00:00.000Z');
    },
  );

  for (final reverse in [false, true]) {
    testWidgets(
      'custom calendar selects both endpoints (${reverse ? 'reverse' : 'forward'})',
      (tester) async {
        ReportDateRange? result;
        await open(
          tester,
          key: UserReportKey.distance,
          onChanged: (value) => result = value,
        );
        for (final day in reverse ? [12, 10] : [10, 12]) {
          final cell = find.byKey(ValueKey('range-day-2026-5-$day'));
          await tester.ensureVisible(cell);
          await tester.pumpAndSettle();
          await tester.tap(cell);
          await tester.pumpAndSettle();
        }
        await tester.tap(find.text('Apply'));
        await tester.pumpAndSettle();
        expect(result?.startDate, '2026-05-10');
        expect(result?.endDate, '2026-05-12');
      },
    );
  }

  testWidgets(
    'duration preset preserves seconds through datetime request payload',
    (tester) async {
      ReportDateRange? result;
      await open(
        tester,
        key: UserReportKey.driven,
        onChanged: (value) => result = value,
      );
      await preset(tester, 'Last Hour');
      await tester.tap(find.text('Apply'));
      await tester.pumpAndSettle();
      expect(
        result?.fromISO,
        now.subtract(const Duration(hours: 1)).toUtc().toIso8601String(),
      );
      expect(result?.toISO, now.toUtc().toIso8601String());
      final client = _Client();
      await sendReport(UserReportKey.driven, result!, client);
      expect(client.body['dateRange'], result!.toJson());
      expect(client.body['from'], result!.fromISO);
      expect(client.body['to'], result!.toISO);
    },
  );

  testWidgets(
    'report limit blocks oversized presets and permits valid custom range',
    (tester) async {
      ReportDateRange? result;
      await open(
        tester,
        key: UserReportKey.timeline,
        onChanged: (value) => result = value,
      );
      await preset(tester, 'Last 30 Days');
      expect(find.text('Max 7 days for this report type'), findsNWidgets(2));
      final apply = find.widgetWithText(OpenVtsButton, 'Apply');
      expect(tester.widget<OpenVtsButton>(apply).onPressed, isNull);
      expect(result, isNull);
      await preset(tester, 'Last 7 Days');
      expect(tester.widget<OpenVtsButton>(apply).onPressed, isNotNull);
      await tester.tap(find.text('Apply'));
      await tester.pumpAndSettle();
      expect(result?.startDate, '2026-05-10');
      expect(result?.endDate, '2026-05-16');
    },
  );

  testWidgets('cancel retains existing range and clear explicitly clears it', (
    tester,
  ) async {
    const initial = ReportDateRange.dateOnly(
      startDate: '2026-05-12',
      endDate: '2026-05-14',
    );
    var calls = 0;
    ReportDateRange? result = initial;
    await open(
      tester,
      key: UserReportKey.distance,
      initial: initial,
      onChanged: (value) {
        calls++;
        result = value;
      },
    );
    await preset(tester, 'Today');
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(calls, 0);
    expect(result, same(initial));
    await tester.tap(find.byType(OpenVtsDateTimeRangeField));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Clear'));
    await tester.pumpAndSettle();
    expect(calls, 1);
    expect(result, isNull);
  });

  testWidgets('unchanged datetime range retains exact UTC instants', (
    tester,
  ) async {
    final start = DateTime.utc(2026, 5, 15, 21, 15, 42, 123, 456);
    final end = DateTime.utc(2026, 5, 16, 5, 40, 17, 654, 321);
    ReportDateRange? result;
    await open(
      tester,
      key: UserReportKey.driven,
      initial: ReportDateRange.dateTime(
        from: start.toIso8601String(),
        to: end.toIso8601String(),
      ),
      onChanged: (value) => result = value,
    );
    await tester.tap(find.text('Apply'));
    await tester.pumpAndSettle();
    expect(result?.fromISO, start.toIso8601String());
    expect(result?.toISO, end.toIso8601String());
  });

  testWidgets(
    'Arabic report picker fits 320 px at 3x text and remains operable',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(320, 568));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      ReportDateRange? result;
      final l = AppLocalizationsAr();
      await open(
        tester,
        key: UserReportKey.distance,
        locale: const Locale('ar'),
        textScale: 3,
        onChanged: (value) => result = value,
      );
      expect(tester.takeException(), isNull);
      final horizontal = find.byWidgetPredicate(
        (widget) =>
            widget is Scrollable &&
            (widget.axisDirection == AxisDirection.left ||
                widget.axisDirection == AxisDirection.right),
      );
      await tester.scrollUntilVisible(
        find.text(l.dateRangeToday).hitTestable(),
        100,
        scrollable: horizontal,
      );
      await tester.tap(find.text(l.dateRangeToday).hitTestable());
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      final vertical = find
          .byWidgetPredicate(
            (widget) =>
                widget is Scrollable &&
                widget.axisDirection == AxisDirection.down,
          )
          .last;
      await tester.scrollUntilVisible(
        find.text(l.apply).hitTestable(),
        300,
        maxScrolls: 80,
        scrollable: vertical,
      );
      await tester.tap(find.text(l.apply).hitTestable());
      await tester.pumpAndSettle();
      expect(result?.startDate, '2026-05-16');
      expect(result?.endDate, '2026-05-16');
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('disabled report dates cannot open picker', (tester) async {
    await open(
      tester,
      key: UserReportKey.distance,
      disabled: true,
      onChanged: (_) => fail('Disabled callback'),
    );
    await tester.tap(find.byType(OpenVtsDateTimeRangeField));
    await tester.pumpAndSettle();
    expect(find.byType(OpenVtsDateTimeRangeSelector), findsNothing);
  });

  test(
    'datetime validation accepts the exact web limit and rejects one microsecond more',
    () {
      final start = DateTime.utc(2026, 5, 1);
      Map<String, String> validate(DateTime end) => validateReportQuery(
        reportKey: UserReportKey.overspeed,
        scope: const ReportVehicleScope.all(),
        dateRange: ReportDateRange.dateTime(
          from: start.toIso8601String(),
          to: end.toIso8601String(),
        ),
        overspeedFilters: const OverspeedFilters(),
        sensorFilters: const SensorFilters(),
        timelineFilters: const TimelineFilters(),
      );
      final end = start.add(const Duration(days: 7));
      expect(validate(end), isEmpty);
      expect(
        validate(end.add(const Duration(microseconds: 1)))['dateRange'],
        'reportsValidationRangeTooLong',
      );
    },
  );

  test('datetime default spans the complete civil day like the web report', () {
    final range = buildDefaultDateRange(UserReportKey.driven);
    final start = DateTime.parse(range.fromISO!).toLocal();
    final end = DateTime.parse(range.toISO!).toLocal();
    expect(
      [start.hour, start.minute, start.second, start.millisecond],
      [0, 0, 0, 0],
    );
    expect(
      [end.hour, end.minute, end.second, end.millisecond],
      [23, 59, 59, 999],
    );
    expect(
      [end.year, end.month, end.day],
      [start.year, start.month, start.day],
    );
  });
}

class _Client extends ApiClient {
  _Client() : super(Dio());
  Map<String, dynamic> body = {};
  @override
  Future<ApiResponse<T>> post<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    required T Function(dynamic json) parser,
  }) async {
    body = Map<String, dynamic>.from(data as Map);
    return ApiResponse(
      success: true,
      data: parser({'rows': [], 'hasMore': false}),
    );
  }
}
