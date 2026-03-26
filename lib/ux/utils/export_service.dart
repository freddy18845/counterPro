// lib/ux/utils/export_service.dart
import 'dart:io';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class TxnExportRow {
  final String reference;
  final String userName;
  final double amount;
  final String method;
  final String status;
  final DateTime date;

  TxnExportRow({
    required this.reference,
    required this.userName,
    required this.amount,
    required this.method,
    required this.status,
    required this.date,
  });
}

class ExportService {
  // ── Get platform-safe save path ───────────────────────────────
  static Future<String> _getSavePath(String fileName) async {
    try {
      if (Platform.isMacOS) {
        // macOS sandbox — use app documents dir (always accessible)
        // Downloads requires com.apple.security.files.downloads.read-write
        // entitlement. Try Downloads first, fall back to documents.
        final home = Platform.environment['HOME'] ?? '';
        final downloadsDir = Directory('$home/Downloads');
        if (await downloadsDir.exists()) {
          return '$home/Downloads/$fileName';
        }
        final docs = await getApplicationDocumentsDirectory();
        return '${docs.path}/$fileName';
      } else if (Platform.isWindows) {
        final userProfile =
            Platform.environment['USERPROFILE'] ?? '';
        final downloadsDir =
        Directory('$userProfile\\Downloads');
        if (await downloadsDir.exists()) {
          return '$userProfile\\Downloads\\$fileName';
        }
        final docs = await getApplicationDocumentsDirectory();
        return '${docs.path}\\$fileName';
      } else if (Platform.isLinux) {
        final home = Platform.environment['HOME'] ?? '';
        final downloadsDir = Directory('$home/Downloads');
        if (await downloadsDir.exists()) {
          return '$home/Downloads/$fileName';
        }
        final docs = await getApplicationDocumentsDirectory();
        return '${docs.path}/$fileName';
      } else if (Platform.isAndroid) {
        // Android — use external storage downloads if available
        // otherwise fall back to app documents
        try {
          final extDirs =
          await getExternalStorageDirectories(
            type: StorageDirectory.downloads,
          );
          if (extDirs != null && extDirs.isNotEmpty) {
            return '${extDirs.first.path}/$fileName';
          }
        } catch (_) {}
        final docs = await getApplicationDocumentsDirectory();
        return '${docs.path}/$fileName';
      } else if (Platform.isIOS) {
        // iOS — save to app documents directory
        // user can access via Files app → On My iPhone → App name
        final docs = await getApplicationDocumentsDirectory();
        return '${docs.path}/$fileName';
      } else {
        final docs = await getApplicationDocumentsDirectory();
        return '${docs.path}/$fileName';
      }
    } catch (_) {
      // ultimate fallback
      final docs = await getApplicationDocumentsDirectory();
      return '${docs.path}/$fileName';
    }
  }

  // ── Friendly save message per platform ───────────────────────
  static String _savedMessage(String filePath) {
    final name = filePath.split(Platform.isWindows ? '\\' : '/').last;
    if (Platform.isIOS) {
      return 'Saved to Files app → On My iPhone → $name';
    } else if (Platform.isAndroid) {
      return 'Saved to Downloads: $name';
    } else if (Platform.isMacOS) {
      return 'Saved to Downloads: $name';
    } else if (Platform.isWindows) {
      return 'Saved to Downloads: $name';
    }
    return 'Saved: $name';
  }

  // ── Show snackbars ────────────────────────────────────────────
  static void _showSaved(BuildContext context, String filePath) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 5),
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline,
                color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _savedMessage(filePath),
                style: const TextStyle(
                    color: Colors.white, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void _showError(BuildContext context, String message) {
    debugPrint(message);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 5),
        content: Text(message,
            style: const TextStyle(
                color: Colors.white, fontSize: 13)),
      ),
    );
  }

  // ── Export to Excel ───────────────────────────────────────────
  static Future<void> exportToExcel({
    required BuildContext context,
    required List<TxnExportRow> transactions,
    required String fileName,
  }) async {
    try {
      final excel = Excel.createExcel();
      final sheet = excel['Transactions'];
      excel.delete('Sheet1');

      // header style
      final headerStyle = CellStyle(
        bold: true,
        backgroundColorHex:
        ExcelColor.fromHexString('#1E3A5F'),
        fontColorHex: ExcelColor.fromHexString('#FFFFFF'),
        horizontalAlign: HorizontalAlign.Center,
      );

      final headers = [
        'Reference',
        'User',
        'Amount',
        'Method',
        'Status',
        'Date',
      ];

      for (int i = 0; i < headers.length; i++) {
        final cell = sheet.cell(CellIndex.indexByColumnRow(
            columnIndex: i, rowIndex: 0));
        cell.value = TextCellValue(headers[i]);
        cell.cellStyle = headerStyle;
      }

      // column widths
      sheet.setColumnWidth(0, 20);
      sheet.setColumnWidth(1, 22);
      sheet.setColumnWidth(2, 14);
      sheet.setColumnWidth(3, 16);
      sheet.setColumnWidth(4, 14);
      sheet.setColumnWidth(5, 18);

      // data rows
      for (int i = 0; i < transactions.length; i++) {
        final t = transactions[i];
        final rowIndex = i + 1;

        final rowStyle = CellStyle(
          backgroundColorHex: i.isOdd
              ? ExcelColor.fromHexString('#F5F7FA')
              : ExcelColor.fromHexString('#FFFFFF'),
        );

        void setCell(int col, CellValue value) {
          final cell = sheet.cell(
            CellIndex.indexByColumnRow(
                columnIndex: col, rowIndex: rowIndex),
          );
          cell.value = value;
          cell.cellStyle = rowStyle;
        }

        setCell(0, TextCellValue(t.reference));
        setCell(1, TextCellValue(t.userName));
        setCell(2, DoubleCellValue(t.amount));
        setCell(3, TextCellValue(t.method));
        setCell(4, TextCellValue(t.status));
        setCell(5, TextCellValue(_formatDate(t.date)));
      }

      // total row
      if (transactions.isNotEmpty) {
        final summaryRow = transactions.length + 2;

        final labelCell = sheet.cell(
          CellIndex.indexByColumnRow(
              columnIndex: 0, rowIndex: summaryRow),
        );
        labelCell.value = TextCellValue('TOTAL');
        labelCell.cellStyle = CellStyle(bold: true);

        final totalCell = sheet.cell(
          CellIndex.indexByColumnRow(
              columnIndex: 2, rowIndex: summaryRow),
        );
        totalCell.value = FormulaCellValue(
            'SUM(C2:C${transactions.length + 1})');
        totalCell.cellStyle = CellStyle(bold: true);
      }

      // ── Save file ─────────────────────────────────────────
      final filePath =
      await _getSavePath('$fileName.xlsx');
      final fileBytes = excel.save();

      if (fileBytes == null) {
        throw Exception('Failed to generate Excel bytes');
      }

      // ensure directory exists
      final dir = File(filePath).parent;
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }

      await File(filePath).writeAsBytes(fileBytes);

      if (context.mounted) _showSaved(context, filePath);
    } catch (e) {
      if (context.mounted) {
        _showError(context, 'Excel export failed: $e');
      }
    }
  }

  // ── Export to Word (RTF) ──────────────────────────────────────
  static Future<void> exportToWord({
    required BuildContext context,
    required List<TxnExportRow> transactions,
    required String fileName,
  }) async {
    try {
      final total =
      transactions.fold(0.0, (s, t) => s + t.amount);
      final completed = transactions
          .where((t) => t.status == 'Completed')
          .length;
      final refunded = transactions
          .where((t) => t.status == 'Refunded')
          .length;
      final voided =
          transactions.where((t) => t.status == 'Voided').length;

      final buffer = StringBuffer();
      buffer.writeln(r'{\rtf1\ansi\deff0');
      buffer.writeln(r'{\fonttbl{\f0 Arial;}}');
      buffer.writeln(
          r'{\colortbl;\red30\green58\blue95;\red255\green255\blue255;\red245\green245\blue245;}');

      buffer.writeln(r'{\pard\qc\b\fs32 Transaction Report\par}');
      buffer.writeln(
          '{\\pard\\qc\\fs20 Generated: ${_formatDate(DateTime.now())}\\par}');
      buffer.writeln(r'{\pard\par}');

      buffer.writeln(r'{\pard\b\fs24 Summary\par}');
      buffer.writeln(
          '{\\pard Total Transactions: ${transactions.length}\\par}');
      buffer.writeln(
          '{\\pard Total Amount: \$${total.toStringAsFixed(2)}\\par}');
      buffer.writeln(
          '{\\pard Completed: $completed  |  Refunded: $refunded  |  Voided: $voided\\par}');
      buffer.writeln(r'{\pard\par}');

      buffer.writeln(r'{\pard\b\fs22 Transaction Details\par}');
      buffer.writeln(r'{\pard\par}');
      buffer.writeln(
          r'{\pard\b Reference\tab User\tab Amount\tab Method\tab Status\tab Date\par}');
      buffer.writeln(r'{\pard\brdrb\brdrs\brdrw10 \par}');

      for (final t in transactions) {
        buffer.writeln(
          '{\\pard '
              '${t.reference}\\tab '
              '${t.userName}\\tab '
              '\\\$${t.amount.toStringAsFixed(2)}\\tab '
              '${t.method}\\tab '
              '${t.status}\\tab '
              '${_formatDate(t.date)}'
              '\\par}',
        );
      }

      buffer.writeln('}');

      // ── Save file ─────────────────────────────────────────
      final filePath =
      await _getSavePath('$fileName.rtf');

      final dir = File(filePath).parent;
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }

      await File(filePath).writeAsString(buffer.toString());

      if (context.mounted) _showSaved(context, filePath);
    } catch (e) {
      if (context.mounted) {
        _showError(context, 'Word export failed: $e');
      }
    }
  }

  static String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/'
          '${d.month.toString().padLeft(2, '0')}/'
          '${d.year}';
}