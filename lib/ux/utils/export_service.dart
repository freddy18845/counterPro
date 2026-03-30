// lib/ux/utils/export_service.dart
import 'dart:io';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
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

class ProductExportRow {
  final String sKU;
  final String name;
  final String category;
  final double costPrice;
  final double sellingPrice;
  final int stock;
  final int lowStock;
  final DateTime date;
  final String? barcodeId;
  final int categoryId;
  final String? imageUrl;
  final String isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProductExportRow({
    required this.sKU,
    required this.name,
    required this.category,
    required this.costPrice,
    required this.sellingPrice,
    required this.stock,
    required this.lowStock,
    required this.date,
    this.barcodeId = '',
    required this.categoryId,
    this.imageUrl = '',
    required this.updatedAt,
    required this.createdAt,
    required this.isActive,
  });
}

class CategoryExportRow {
  final String name;
  final String description;
  final String status;
  final DateTime date;

  CategoryExportRow({
    required this.name,
    required this.description,
    required this.status,
    required this.date,
  });
}

class ExportService {
  // ── Get platform-safe save path ───────────────────────────────
  static Future<String> _getSavePath(String fileName) async {
    try {
      if (Platform.isMacOS) {
        final home = Platform.environment['HOME'] ?? '';
        final downloadsDir = Directory('$home/Downloads');
        if (await downloadsDir.exists()) {
          return '$home/Downloads/$fileName';
        }
        final docs = await getApplicationDocumentsDirectory();
        return '${docs.path}/$fileName';
      } else if (Platform.isWindows) {
        final userProfile = Platform.environment['USERPROFILE'] ?? '';
        final downloadsDir = Directory('$userProfile\\Downloads');
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
        try {
          final extDirs = await getExternalStorageDirectories(
            type: StorageDirectory.downloads,
          );
          if (extDirs != null && extDirs.isNotEmpty) {
            return '${extDirs.first.path}/$fileName';
          }
        } catch (_) {}
        final docs = await getApplicationDocumentsDirectory();
        return '${docs.path}/$fileName';
      } else if (Platform.isIOS) {
        final docs = await getApplicationDocumentsDirectory();
        return '${docs.path}/$fileName';
      } else {
        final docs = await getApplicationDocumentsDirectory();
        return '${docs.path}/$fileName';
      }
    } catch (_) {
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
            const Icon(
              Icons.check_circle_outline,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _savedMessage(filePath),
                style: const TextStyle(color: Colors.white, fontSize: 13),
              ),
            ),
          ],
        ),
        action: SnackBarAction(
          label: 'Share',
          textColor: Colors.white,
          onPressed: () => _shareFile(filePath),
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
        content: Text(
          message,
          style: const TextStyle(color: Colors.white, fontSize: 13),
        ),
      ),
    );
  }

  static Future<void> _shareFile(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await Share.shareXFiles(
          [XFile(filePath)],
          text: 'Export file from POS System',
        );
      }
    } catch (e) {
      debugPrint('Share failed: $e');
    }
  }

  // ── Export to Excel ───────────────────────────────────────────
  static Future<void> exportToExcel({
    required BuildContext context,
    List<TxnExportRow>? transactions,
    List<ProductExportRow>? products,
    List<CategoryExportRow>? categories,
    required String fileName,
    required String tableName,
  }) async {
    try {
      final excel = Excel.createExcel();

      // Remove default sheet if it exists
      // The default sheet is always named 'Sheet1' when creating a new Excel file
      // We can safely delete it without checking since we know it exists
      excel.delete('Sheet1');

      final sheet = excel[tableName == 'transactions' ? 'Transactions' :
      tableName == 'products' ? 'Products' : 'Categories'];

      // header style
      final headerStyle = CellStyle(
        bold: true,
        backgroundColorHex: ExcelColor.fromHexString('#1E3A5F'),
        fontColorHex: ExcelColor.fromHexString('#FFFFFF'),
        horizontalAlign: HorizontalAlign.Center,
      );

      List<String> headers = [];

      if (tableName == 'transactions' && transactions != null) {
        headers = ['Reference', 'User', 'Amount', 'Method', 'Status', 'Date'];

        for (int i = 0; i < headers.length; i++) {
          final cell = sheet.cell(
            CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0),
          );
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
              CellIndex.indexByColumnRow(columnIndex: col, rowIndex: rowIndex),
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
            CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: summaryRow),
          );
          labelCell.value = TextCellValue('TOTAL');
          labelCell.cellStyle = CellStyle(bold: true);

          final totalCell = sheet.cell(
            CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: summaryRow),
          );
          totalCell.value = FormulaCellValue(
            'SUM(C2:C${transactions.length + 1})',
          );
          totalCell.cellStyle = CellStyle(bold: true);
        }
      }
      else if (tableName == 'products' && products != null) {
        headers = [
          'Name',
          'SKU',
          'Category',
          'Cost Price',
          'Selling Price',
          'Stock',
          'Low Stock',
          'Status'
        ];

        for (int i = 0; i < headers.length; i++) {
          final cell = sheet.cell(
            CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0),
          );
          cell.value = TextCellValue(headers[i]);
          cell.cellStyle = headerStyle;
        }

        // column widths
        sheet.setColumnWidth(0, 24);
        sheet.setColumnWidth(1, 14);
        sheet.setColumnWidth(2, 20);
        sheet.setColumnWidth(3, 16);
        sheet.setColumnWidth(4, 14);
        sheet.setColumnWidth(5, 14);
        sheet.setColumnWidth(6, 14);
        sheet.setColumnWidth(7, 12);

        // data rows
        for (int i = 0; i < products.length; i++) {
          final p = products[i];
          final rowIndex = i + 1;

          final rowStyle = CellStyle(
            backgroundColorHex: i.isOdd
                ? ExcelColor.fromHexString('#F5F7FA')
                : ExcelColor.fromHexString('#FFFFFF'),
          );

          void setCell(int col, CellValue value) {
            final cell = sheet.cell(
              CellIndex.indexByColumnRow(columnIndex: col, rowIndex: rowIndex),
            );
            cell.value = value;
            cell.cellStyle = rowStyle;
          }

          setCell(0, TextCellValue(p.name));
          setCell(1, TextCellValue(p.sKU));
          setCell(2, TextCellValue(p.category));
          setCell(3, DoubleCellValue(p.costPrice));
          setCell(4, DoubleCellValue(p.sellingPrice));
          setCell(5, IntCellValue(p.stock));
          setCell(6, IntCellValue(p.lowStock));
          setCell(7, TextCellValue(p.isActive));
        }
      }
      else if (tableName == 'categories' && categories != null) {
        headers = ['Name', 'Description', 'Status', 'Date'];

        for (int i = 0; i < headers.length; i++) {
          final cell = sheet.cell(
            CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0),
          );
          cell.value = TextCellValue(headers[i]);
          cell.cellStyle = headerStyle;
        }

        // column widths
        sheet.setColumnWidth(0, 24);
        sheet.setColumnWidth(1, 28);
        sheet.setColumnWidth(2, 14);
        sheet.setColumnWidth(3, 16);

        // data rows
        for (int i = 0; i < categories.length; i++) {
          final c = categories[i];
          final rowIndex = i + 1;

          final rowStyle = CellStyle(
            backgroundColorHex: i.isOdd
                ? ExcelColor.fromHexString('#F5F7FA')
                : ExcelColor.fromHexString('#FFFFFF'),
          );

          void setCell(int col, CellValue value) {
            final cell = sheet.cell(
              CellIndex.indexByColumnRow(columnIndex: col, rowIndex: rowIndex),
            );
            cell.value = value;
            cell.cellStyle = rowStyle;
          }

          setCell(0, TextCellValue(c.name));
          setCell(1, TextCellValue(c.description));
          setCell(2, TextCellValue(c.status));
          setCell(3, TextCellValue(_formatDate(c.date)));
        }
      }

      // ── Save file ─────────────────────────────────────────
      final filePath = await _getSavePath('$fileName.xlsx');
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
      final total = transactions.fold(0.0, (s, t) => s + t.amount);
      final completed = transactions
          .where((t) => t.status == 'Completed')
          .length;
      final refunded = transactions.where((t) => t.status == 'Refunded').length;
      final voided = transactions.where((t) => t.status == 'Voided').length;

      final buffer = StringBuffer();
      buffer.writeln(r'{\rtf1\ansi\deff0');
      buffer.writeln(r'{\fonttbl{\f0 Arial;}}');
      buffer.writeln(
        r'{\colortbl;\red30\green58\blue95;\red255\green255\blue255;\red245\green245\blue245;}',
      );

      buffer.writeln(r'{\pard\qc\b\fs32 Transaction Report\par}');
      buffer.writeln(
        '{\\pard\\qc\\fs20 Generated: ${_formatDate(DateTime.now())}\\par}',
      );
      buffer.writeln(r'{\pard\par}');

      buffer.writeln(r'{\pard\b\fs24 Summary\par}');
      buffer.writeln(
        '{\\pard Total Transactions: ${transactions.length}\\par}',
      );
      buffer.writeln(
        '{\\pard Total Amount: \$${total.toStringAsFixed(2)}\\par}',
      );
      buffer.writeln(
        '{\\pard Completed: $completed  |  Refunded: $refunded  |  Voided: $voided\\par}',
      );
      buffer.writeln(r'{\pard\par}');

      buffer.writeln(r'{\pard\b\fs22 Transaction Details\par}');
      buffer.writeln(r'{\pard\par}');
      buffer.writeln(
        r'{\pard\b Reference\tab User\tab Amount\tab Method\tab Status\tab Date\par}',
      );
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
      final filePath = await _getSavePath('$fileName.rtf');

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

  // ── Export to PDF ──────────────────────────────────────────────
  static Future<void> exportToPdf({
    required BuildContext context,
    required List<TxnExportRow> transactions,
    required String fileName,
  }) async {
    try {
      final pdf = pw.Document();

      final total = transactions.fold(0.0, (s, t) => s + t.amount);
      final completed = transactions
          .where((t) => t.status == 'Completed')
          .length;
      final refunded = transactions.where((t) => t.status == 'Refunded').length;
      final voided = transactions.where((t) => t.status == 'Voided').length;

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (pw.Context context) => [
            pw.Center(
              child: pw.Text(
                'Transaction Report',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(height: 16),
            pw.Center(
              child: pw.Text(
                'Generated: ${_formatDate(DateTime.now())}',
                style: pw.TextStyle(fontSize: 12),
              ),
            ),
            pw.SizedBox(height: 32),
            pw.Text(
              'Summary',
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 8),
            pw.Container(
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(),
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Total Transactions: ${transactions.length}'),
                  pw.SizedBox(height: 4),
                  pw.Text('Total Amount: \$${total.toStringAsFixed(2)}'),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    'Completed: $completed  |  Refunded: $refunded  |  Voided: $voided',
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 24),
            pw.Text(
              'Transaction Details',
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 16),
            pw.Table.fromTextArray(
              headers: ['Reference', 'User', 'Amount', 'Method', 'Status', 'Date'],
              data: transactions.map((t) => [
                t.reference,
                t.userName,
                '\$${t.amount.toStringAsFixed(2)}',
                t.method,
                t.status,
                _formatDate(t.date),
              ]).toList(),
              border: pw.TableBorder.all(),
              headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
              ),
              cellAlignment: pw.Alignment.centerLeft,
              headerAlignment: pw.Alignment.centerLeft,
            ),
          ],
        ),
      );

      // ── Save file ─────────────────────────────────────────
      final filePath = await _getSavePath('$fileName.pdf');
      final fileBytes = await pdf.save();

      final dir = File(filePath).parent;
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }

      await File(filePath).writeAsBytes(fileBytes);

      if (context.mounted) _showSaved(context, filePath);
    } catch (e) {
      if (context.mounted) {
        _showError(context, 'PDF export failed: $e');
      }
    }
  }

  // ── Export to CSV ──────────────────────────────────────────────
  static Future<void> exportToCsv({
    required BuildContext context,
    required List<TxnExportRow> transactions,
    required String fileName,
  }) async {
    try {
      final buffer = StringBuffer();

      // Headers
      buffer.writeln('Reference,User,Amount,Method,Status,Date');

      // Data rows
      for (final t in transactions) {
        buffer.writeln(
          '"${t.reference}",'
              '"${t.userName}",'
              '${t.amount},'
              '"${t.method}",'
              '"${t.status}",'
              '"${_formatDate(t.date)}"',
        );
      }

      // Summary rows
      final total = transactions.fold(0.0, (s, t) => s + t.amount);
      buffer.writeln();
      buffer.writeln('Total Transactions,${transactions.length}');
      buffer.writeln('Total Amount,$total');

      // ── Save file ─────────────────────────────────────────
      final filePath = await _getSavePath('$fileName.csv');

      final dir = File(filePath).parent;
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }

      await File(filePath).writeAsString(buffer.toString());

      if (context.mounted) _showSaved(context, filePath);
    } catch (e) {
      if (context.mounted) {
        _showError(context, 'CSV export failed: $e');
      }
    }
  }

  // ── Bulk Export Multiple Tables ───────────────────────────────
  static Future<void> exportMultipleToExcel({
    required BuildContext context,
    required List<TxnExportRow>? transactions,
    required List<ProductExportRow>? products,
    required List<CategoryExportRow>? categories,
    required String fileName,
  }) async {
    try {
      final excel = Excel.createExcel();

      // Remove default sheet - it always exists when creating a new Excel file
      excel.delete('Sheet1');

      // Export transactions if provided
      if (transactions != null && transactions.isNotEmpty) {
        final sheet = excel['Transactions'];
        await _exportTransactionsToSheet(sheet, transactions);
      }

      // Export products if provided
      if (products != null && products.isNotEmpty) {
        final sheet = excel['Products'];
        await _exportProductsToSheet(sheet, products);
      }

      // Export categories if provided
      if (categories != null && categories.isNotEmpty) {
        final sheet = excel['Categories'];
        await _exportCategoriesToSheet(sheet, categories);
      }

      // ── Save file ─────────────────────────────────────────
      final filePath = await _getSavePath('$fileName.xlsx');
      final fileBytes = excel.save();

      if (fileBytes == null) {
        throw Exception('Failed to generate Excel bytes');
      }

      final dir = File(filePath).parent;
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }

      await File(filePath).writeAsBytes(fileBytes);

      if (context.mounted) _showSaved(context, filePath);
    } catch (e) {
      if (context.mounted) {
        _showError(context, 'Bulk export failed: $e');
      }
    }
  }

  static Future<void> _exportTransactionsToSheet(Sheet sheet, List<TxnExportRow> transactions) async {
    final headerStyle = CellStyle(
      bold: true,
      backgroundColorHex: ExcelColor.fromHexString('#1E3A5F'),
      fontColorHex: ExcelColor.fromHexString('#FFFFFF'),
      horizontalAlign: HorizontalAlign.Center,
    );

    final headers = ['Reference', 'User', 'Amount', 'Method', 'Status', 'Date'];

    for (int i = 0; i < headers.length; i++) {
      final cell = sheet.cell(
        CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0),
      );
      cell.value = TextCellValue(headers[i]);
      cell.cellStyle = headerStyle;
    }

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
          CellIndex.indexByColumnRow(columnIndex: col, rowIndex: rowIndex),
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
  }

  static Future<void> _exportProductsToSheet(Sheet sheet, List<ProductExportRow> products) async {
    final headerStyle = CellStyle(
      bold: true,
      backgroundColorHex: ExcelColor.fromHexString('#1E3A5F'),
      fontColorHex: ExcelColor.fromHexString('#FFFFFF'),
      horizontalAlign: HorizontalAlign.Center,
    );

    final headers = ['Name', 'SKU', 'Category', 'Cost Price', 'Selling Price', 'Stock', 'Low Stock', 'Status'];

    for (int i = 0; i < headers.length; i++) {
      final cell = sheet.cell(
        CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0),
      );
      cell.value = TextCellValue(headers[i]);
      cell.cellStyle = headerStyle;
    }

    for (int i = 0; i < products.length; i++) {
      final p = products[i];
      final rowIndex = i + 1;

      final rowStyle = CellStyle(
        backgroundColorHex: i.isOdd
            ? ExcelColor.fromHexString('#F5F7FA')
            : ExcelColor.fromHexString('#FFFFFF'),
      );

      void setCell(int col, CellValue value) {
        final cell = sheet.cell(
          CellIndex.indexByColumnRow(columnIndex: col, rowIndex: rowIndex),
        );
        cell.value = value;
        cell.cellStyle = rowStyle;
      }

      setCell(0, TextCellValue(p.name));
      setCell(1, TextCellValue(p.sKU));
      setCell(2, TextCellValue(p.category));
      setCell(3, DoubleCellValue(p.costPrice));
      setCell(4, DoubleCellValue(p.sellingPrice));
      setCell(5, IntCellValue(p.stock));
      setCell(6, IntCellValue(p.lowStock));
      setCell(7, TextCellValue(p.isActive));
    }
  }

  static Future<void> _exportCategoriesToSheet(Sheet sheet, List<CategoryExportRow> categories) async {
    final headerStyle = CellStyle(
      bold: true,
      backgroundColorHex: ExcelColor.fromHexString('#1E3A5F'),
      fontColorHex: ExcelColor.fromHexString('#FFFFFF'),
      horizontalAlign: HorizontalAlign.Center,
    );

    final headers = ['Name', 'Description', 'Status', 'Date'];

    for (int i = 0; i < headers.length; i++) {
      final cell = sheet.cell(
        CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0),
      );
      cell.value = TextCellValue(headers[i]);
      cell.cellStyle = headerStyle;
    }

    for (int i = 0; i < categories.length; i++) {
      final c = categories[i];
      final rowIndex = i + 1;

      final rowStyle = CellStyle(
        backgroundColorHex: i.isOdd
            ? ExcelColor.fromHexString('#F5F7FA')
            : ExcelColor.fromHexString('#FFFFFF'),
      );

      void setCell(int col, CellValue value) {
        final cell = sheet.cell(
          CellIndex.indexByColumnRow(columnIndex: col, rowIndex: rowIndex),
        );
        cell.value = value;
        cell.cellStyle = rowStyle;
      }

      setCell(0, TextCellValue(c.name));
      setCell(1, TextCellValue(c.description));
      setCell(2, TextCellValue(c.status));
      setCell(3, TextCellValue(_formatDate(c.date)));
    }
  }

  static String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/'
          '${d.month.toString().padLeft(2, '0')}/'
          '${d.year}';
}