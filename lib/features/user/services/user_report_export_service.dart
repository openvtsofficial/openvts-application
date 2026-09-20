import 'dart:convert';
import 'dart:io';
import 'dart:ui' show Rect;

import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

import '../models/user_report_model.dart';
import '../models/user_report_state.dart';
import '../utils/user_report_format.dart';

/// Shared report export service — CSV, XLSX, JSON, PDF, HTML.
/// Exports ALL columns including those hidden in the compact view.
class UserReportExportService {
  const UserReportExportService({required this.sharePositionOrigin});

  /// The visible source rectangle is required by the iPad share popover.
  final Rect sharePositionOrigin;

  // ---------------------------------------------------------------------------
  // Public API
  // ---------------------------------------------------------------------------

  /// Export [rows] in [format] for [reportKey].
  /// [allColumns] must contain ALL column keys, including hidden ones.
  /// [columnLabels] maps column key → display label.
  /// [filters] is a human-readable description shown in metadata headers.
  Future<void> export({
    required UserReportKey reportKey,
    required List<Map<String, dynamic>> rows,
    required List<String> allColumns,
    required Map<String, String> columnLabels,
    required String format, // 'csv' | 'xlsx' | 'json' | 'pdf' | 'html'
    String? filters,
    DateTime? generatedAt,
    String? warning,
  }) async {
    final exportRows = normalizeUserReportRowsForExport(reportKey, rows);
    final timestamp = DateFormat('yyyy-MM-dd_HH-mm-ss').format(DateTime.now());
    final baseName = '${reportKey.apiValue}_$timestamp';

    switch (format) {
      case 'csv':
        await _exportCsv(
            rows: exportRows,
            allColumns: allColumns,
            columnLabels: columnLabels,
            baseName: baseName,
            reportKey: reportKey,
            filters: filters,
            generatedAt: generatedAt,
            warning: warning);
      case 'xlsx':
        await _exportXlsx(
            rows: exportRows,
            allColumns: allColumns,
            columnLabels: columnLabels,
            baseName: baseName,
            reportKey: reportKey,
            filters: filters,
            generatedAt: generatedAt,
            warning: warning);
      case 'json':
        await _exportJson(
            rows: exportRows,
            baseName: baseName,
            reportKey: reportKey,
            filters: filters,
            generatedAt: generatedAt);
      case 'pdf':
        await _exportPdf(
            rows: exportRows,
            allColumns: allColumns,
            columnLabels: columnLabels,
            baseName: baseName,
            reportKey: reportKey,
            filters: filters,
            generatedAt: generatedAt,
            warning: warning);
      case 'html':
        await _exportHtml(
            rows: exportRows,
            allColumns: allColumns,
            columnLabels: columnLabels,
            baseName: baseName,
            reportKey: reportKey,
            filters: filters,
            generatedAt: generatedAt,
            warning: warning);
      default:
        throw ArgumentError('Unknown export format: $format');
    }
  }

  // ---------------------------------------------------------------------------
  // CSV
  // ---------------------------------------------------------------------------

  Future<void> _exportCsv({
    required List<Map<String, dynamic>> rows,
    required List<String> allColumns,
    required Map<String, String> columnLabels,
    required String baseName,
    required UserReportKey reportKey,
    String? filters,
    DateTime? generatedAt,
    String? warning,
  }) async {
    final buffer = StringBuffer();

    // Metadata header
    buffer.writeln(_csvQuote('OpenVTS Report: ${reportKey.label}'));
    if (generatedAt != null)
      buffer.writeln(
          _csvQuote('Generated: ${generatedAt.toLocal().toIso8601String()}'));
    if (filters != null && filters.isNotEmpty)
      buffer.writeln(_csvQuote('Filters: $filters'));
    if (warning != null && warning.isNotEmpty)
      buffer.writeln(_csvQuote('Warning: $warning'));
    buffer.writeln(_csvQuote('Rows: ${rows.length}'));
    buffer.writeln();

    // Header row
    buffer.writeln(
        allColumns.map((k) => _csvQuote(columnLabels[k] ?? k)).join(','));

    // Data rows
    for (final row in rows) {
      buffer.writeln(
          allColumns.map((k) => _csvQuote(_cellValue(row[k]))).join(','));
    }

    await _shareText(buffer.toString(), '$baseName.csv', 'text/csv');
  }

  String _csvQuote(String value) {
    final escaped = value.replaceAll('"', '""');
    return '"$escaped"';
  }

  // ---------------------------------------------------------------------------
  // XLSX
  // ---------------------------------------------------------------------------

  Future<void> _exportXlsx({
    required List<Map<String, dynamic>> rows,
    required List<String> allColumns,
    required Map<String, String> columnLabels,
    required String baseName,
    required UserReportKey reportKey,
    String? filters,
    DateTime? generatedAt,
    String? warning,
  }) async {
    final excel = Excel.createExcel();
    final sheetName = reportKey.label;
    final sheet = excel[sheetName];

    // Remove default empty sheet
    excel.delete('Sheet1');

    // Metadata rows
    int metaRow = 0;
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: metaRow++))
      ..value = TextCellValue('OpenVTS Report: ${reportKey.label}');
    if (generatedAt != null) {
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: metaRow++))
        ..value = TextCellValue(
            'Generated: ${generatedAt.toLocal().toIso8601String()}');
    }
    if (filters != null && filters.isNotEmpty) {
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: metaRow++))
        ..value = TextCellValue('Filters: $filters');
    }
    if (warning != null && warning.isNotEmpty) {
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: metaRow++))
        ..value = TextCellValue('Warning: $warning');
    }
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: metaRow++))
      ..value = TextCellValue('Rows: ${rows.length}');
    metaRow++; // blank row

    // Header
    for (var c = 0; c < allColumns.length; c++) {
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: c, rowIndex: metaRow))
        ..value = TextCellValue(columnLabels[allColumns[c]] ?? allColumns[c]);
    }
    metaRow++;

    // Data
    for (final row in rows) {
      for (var c = 0; c < allColumns.length; c++) {
        final raw = row[allColumns[c]];
        final cell = sheet.cell(
            CellIndex.indexByColumnRow(columnIndex: c, rowIndex: metaRow));
        if (raw is num) {
          cell.value = DoubleCellValue(raw.toDouble());
        } else if (raw is bool) {
          cell.value = BoolCellValue(raw);
        } else {
          cell.value = TextCellValue(_cellValue(raw));
        }
      }
      metaRow++;
    }

    final bytes = excel.save();
    if (bytes == null) throw StateError('XLSX generation failed');
    await _shareBytes(Uint8List.fromList(bytes), '$baseName.xlsx',
        'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
  }

  // ---------------------------------------------------------------------------
  // JSON
  // ---------------------------------------------------------------------------

  Future<void> _exportJson({
    required List<Map<String, dynamic>> rows,
    required String baseName,
    required UserReportKey reportKey,
    String? filters,
    DateTime? generatedAt,
  }) async {
    final payload = {
      'report': reportKey.apiValue,
      'title': reportKey.label,
      if (generatedAt != null)
        'generatedAt': generatedAt.toUtc().toIso8601String(),
      if (filters != null) 'filters': filters,
      'rowCount': rows.length,
      'rows': rows,
    };
    const encoder = JsonEncoder.withIndent('  ');
    final json = encoder.convert(payload);
    await _shareText(json, '$baseName.json', 'application/json');
  }

  // ---------------------------------------------------------------------------
  // PDF
  // ---------------------------------------------------------------------------

  Future<void> _exportPdf({
    required List<Map<String, dynamic>> rows,
    required List<String> allColumns,
    required Map<String, String> columnLabels,
    required String baseName,
    required UserReportKey reportKey,
    String? filters,
    DateTime? generatedAt,
    String? warning,
  }) async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.notoSansRegular();
    final fontBold = await PdfGoogleFonts.notoSansBold();

    // Limit columns per page for readability; use landscape for wide reports
    final isWide = allColumns.length > 6;
    final pageFormat = isWide ? PdfPageFormat.a4.landscape : PdfPageFormat.a4;

    const pageSize = 50; // rows per page chunk in PDF
    final chunks = <List<Map<String, dynamic>>>[];
    for (var i = 0; i < rows.length; i += pageSize) {
      chunks.add(rows.sublist(i, (i + pageSize).clamp(0, rows.length)));
    }
    if (chunks.isEmpty) chunks.add([]);

    for (var chunkIdx = 0; chunkIdx < chunks.length; chunkIdx++) {
      final chunk = chunks[chunkIdx];
      pdf.addPage(
        pw.Page(
          pageFormat: pageFormat,
          margin: const pw.EdgeInsets.all(24),
          build: (context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                if (chunkIdx == 0) ...[
                  pw.Text('OpenVTS — ${reportKey.label}',
                      style: pw.TextStyle(font: fontBold, fontSize: 16)),
                  pw.SizedBox(height: 4),
                  if (generatedAt != null)
                    pw.Text(
                        'Generated: ${generatedAt.toLocal().toIso8601String()}',
                        style: pw.TextStyle(font: font, fontSize: 9)),
                  if (filters != null && filters.isNotEmpty)
                    pw.Text('Filters: $filters',
                        style: pw.TextStyle(font: font, fontSize: 9)),
                  if (warning != null && warning.isNotEmpty)
                    pw.Text('Warning: $warning',
                        style: pw.TextStyle(font: font, fontSize: 9)),
                  pw.Text('Rows: ${rows.length}',
                      style: pw.TextStyle(font: font, fontSize: 9)),
                  pw.SizedBox(height: 12),
                ],
                pw.TableHelper.fromTextArray(
                  headers: allColumns.map((k) => columnLabels[k] ?? k).toList(),
                  data: chunk
                      .map((row) =>
                          allColumns.map((k) => _cellValue(row[k])).toList())
                      .toList(),
                  headerStyle: pw.TextStyle(font: fontBold, fontSize: 8),
                  cellStyle: pw.TextStyle(font: font, fontSize: 7),
                  cellAlignment: pw.Alignment.centerLeft,
                  headerDecoration:
                      const pw.BoxDecoration(color: PdfColors.grey200),
                  border:
                      pw.TableBorder.all(color: PdfColors.grey400, width: 0.5),
                  cellHeight: 16,
                ),
              ],
            );
          },
        ),
      );
    }

    final bytes = await pdf.save();
    await _shareBytes(bytes, '$baseName.pdf', 'application/pdf');
  }

  // ---------------------------------------------------------------------------
  // HTML
  // ---------------------------------------------------------------------------

  Future<void> _exportHtml({
    required List<Map<String, dynamic>> rows,
    required List<String> allColumns,
    required Map<String, String> columnLabels,
    required String baseName,
    required UserReportKey reportKey,
    String? filters,
    DateTime? generatedAt,
    String? warning,
  }) async {
    final buf = StringBuffer();
    buf.write('''<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>OpenVTS — ${_esc(reportKey.label)}</title>
<style>
body{font-family:system-ui,sans-serif;font-size:13px;color:#141118;padding:24px}
h1{font-size:18px;margin-bottom:4px}
.meta{color:#6b6570;font-size:11px;margin-bottom:16px}
table{border-collapse:collapse;width:100%}
th{background:#f4f3f6;text-align:left;padding:6px 8px;font-size:11px;font-weight:700;border:1px solid #e7e3ea}
td{padding:5px 8px;font-size:11px;border:1px solid #e7e3ea}
tr:nth-child(even)td{background:#fafafa}
</style>
</head>
<body>
<h1>OpenVTS — ${_esc(reportKey.label)}</h1>
<div class="meta">
''');
    if (generatedAt != null)
      buf.write(
          'Generated: ${_esc(generatedAt.toLocal().toIso8601String())}<br>');
    if (filters != null && filters.isNotEmpty)
      buf.write('Filters: ${_esc(filters)}<br>');
    if (warning != null && warning.isNotEmpty)
      buf.write('Warning: ${_esc(warning)}<br>');
    buf.write('Rows: ${rows.length}');
    buf.write('</div><table><thead><tr>');
    for (final k in allColumns) {
      buf.write('<th>${_esc(columnLabels[k] ?? k)}</th>');
    }
    buf.write('</tr></thead><tbody>');
    for (final row in rows) {
      buf.write('<tr>');
      for (final k in allColumns) {
        buf.write('<td>${_esc(_cellValue(row[k]))}</td>');
      }
      buf.write('</tr>');
    }
    buf.write('</tbody></table></body></html>');

    await _shareText(buf.toString(), '$baseName.html', 'text/html');
  }

  String _esc(String s) => s
      .replaceAll('&', '&amp;')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;')
      .replaceAll('"', '&quot;');

  // ---------------------------------------------------------------------------
  // Platform share helpers
  // ---------------------------------------------------------------------------

  Future<void> _shareText(String text, String fileName, String mimeType) async {
    final bytes = utf8.encode(text);
    await _shareBytes(Uint8List.fromList(bytes), fileName, mimeType);
  }

  Future<void> _shareBytes(
      Uint8List bytes, String fileName, String mimeType) async {
    if (kIsWeb) {
      // Web: use share_plus which handles download
      await Share.shareXFiles(
          [XFile.fromData(bytes, name: fileName, mimeType: mimeType)],
          subject: fileName, sharePositionOrigin: sharePositionOrigin);
      return;
    }
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(bytes);
    await Share.shareXFiles([XFile(file.path, mimeType: mimeType)],
        subject: fileName, sharePositionOrigin: sharePositionOrigin);
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  String _cellValue(dynamic value) {
    if (value == null) return '';
    if (value is bool) return value ? 'true' : 'false';
    return value.toString();
  }
}

/// Applies report-specific presentation values once before any export format.
@visibleForTesting
List<Map<String, dynamic>> normalizeUserReportRowsForExport(
  UserReportKey reportKey,
  List<Map<String, dynamic>> rows,
) {
  if (reportKey != UserReportKey.overspeed) return rows;

  return rows.map((raw) {
    final row = OverspeedRow.fromMap(raw);
    return <String, dynamic>{
      ...raw,
      'address': resolveOverspeedLocation(row.address, row.lat, row.lon),
    };
  }).toList(growable: false);
}
