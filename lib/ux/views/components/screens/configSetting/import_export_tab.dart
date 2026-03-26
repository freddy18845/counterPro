import 'dart:io';

import 'package:eswaini_destop_app/ux/models/shared/category.dart';
import 'package:eswaini_destop_app/ux/models/shared/pos_transaction.dart';
import 'package:eswaini_destop_app/ux/models/shared/product.dart';
import 'package:eswaini_destop_app/ux/views/components/screens/configSetting/section_title.dart';
import 'package:excel/excel.dart' hide Border;
import 'package:file_selector/file_selector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide Border;
import 'package:isar/isar.dart';

import '../../../../res/app_colors.dart';
import '../../../../utils/export_service.dart';
import '../../../../utils/shared/app.dart';
import '../../shared/btn.dart';
import 'export_card.dart';

class ImportExportTab extends StatefulWidget {
  final Isar isar;
  const ImportExportTab({required this.isar});

  @override
  State<ImportExportTab> createState() => ImportExportTabState();
}

class ImportExportTabState extends State<ImportExportTab> {
  bool _isExporting = false;
  bool _isImporting = false;
  String? _importStatus;
  Color _importStatusColor = Colors.green;

  Future<void> _exportProducts() async {
    setState(() => _isExporting = true);
    try {
      final products =
      await widget.isar.products.where().findAll();
      final rows = products
          .map((p) => TxnExportRow(
        reference: p.sku,
        userName: p.name,
        amount: p.sellingPrice,
        method: p.categoryName,
        status: p.isActive ? 'Active' : 'Inactive',
        date: p.createdAt,
      ))
          .toList();
      await ExportService.exportToExcel(
        context: context,
        transactions: rows,
        fileName:
        'products_${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}',
      );
    } finally {
      setState(() => _isExporting = false);
    }
  }

  Future<void> _exportCategories() async {
    setState(() => _isExporting = true);
    try {
      final cats =
      await widget.isar.categorys.where().findAll();
      final rows = cats
          .map((c) => TxnExportRow(
        reference: c.id.toString(),
        userName: c.name,
        amount: 0,
        method: c.description ?? '-',
        status: c.isActive ? 'Active' : 'Inactive',
        date: c.createdAt,
      ))
          .toList();
      await ExportService.exportToExcel(
        context: context,
        transactions: rows,
        fileName:
        'categories_${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}',
      );
    } finally {
      setState(() => _isExporting = false);
    }
  }

  Future<void> _exportTransactions() async {
    setState(() => _isExporting = true);
    try {
      final txns = await widget.isar.posTransactions
          .where()
          .findAll();
      final rows = txns
          .map((t) => TxnExportRow(
        reference: t.transactionNumber,
        userName: t.processedByUserId.toString(),
        amount: t.totalAmount,
        method: t.paymentMethod.name,
        status: t.status.name,
        date: t.timestamp,
      ))
          .toList();
      await ExportService.exportToExcel(
        context: context,
        transactions: rows,
        fileName:
        'transactions_${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}',
      );
    } finally {
      setState(() => _isExporting = false);
    }
  }

  Future<void> _importProducts() async {
    const typeGroup = XTypeGroup(
      label: 'Excel Files',
      extensions: ['xlsx', 'xls', 'csv'],
    );
    final XFile? file =
    await openFile(acceptedTypeGroups: [typeGroup]);
    if (file == null) return;

    setState(() {
      _isImporting = true;
      _importStatus = 'Reading file...';
      _importStatusColor = AppColors.primaryColor;
    });

    try {
      final bytes = await File(file.path).readAsBytes();
      final excel = Excel.decodeBytes(bytes);

      int imported = 0;
      int skipped = 0;

      await widget.isar.writeTxn(() async {
        for (final table in excel.tables.keys) {
          final sheet = excel.tables[table];
          if (sheet == null) continue;

          for (int i = 1; i < sheet.rows.length; i++) {
            final row = sheet.rows[i];
            if (row.isEmpty) continue;

            try {
              final name =
                  row[0]?.value?.toString().trim() ?? '';
              final sku =
                  row[1]?.value?.toString().trim() ?? '';
              final categoryName =
                  row[2]?.value?.toString().trim() ?? '';
              final costPrice = double.tryParse(
                  row[3]?.value?.toString() ?? '0') ??
                  0;
              final sellingPrice = double.tryParse(
                  row[4]?.value?.toString() ?? '0') ??
                  0;
              final stock = int.tryParse(
                  row[5]?.value?.toString() ?? '0') ??
                  0;
              final lowStock = int.tryParse(
                  row[6]?.value?.toString() ?? '5') ??
                  5;

              if (name.isEmpty || sku.isEmpty) {
                skipped++;
                continue;
              }

              // find or create category
              var category = await widget.isar.categorys
                  .where()
                  .filter()
                  .nameEqualTo(categoryName)
                  .findFirst();

              if (category == null &&
                  categoryName.isNotEmpty) {
                category = Category()
                  ..name = categoryName
                  ..isActive = true
                  ..createdAt = DateTime.now()
                  ..updatedAt = DateTime.now();
                await widget.isar.categorys.put(category);
              }

              // update existing or create new
              final existing = await widget.isar.products
                  .where()
                  .filter()
                  .skuEqualTo(sku)
                  .findFirst();

              final product = existing ?? Product();
              product
                ..name = name
                ..sku = sku
                ..categoryId = category?.id ?? 0
                ..categoryName = categoryName
                ..costPrice = costPrice
                ..sellingPrice = sellingPrice
                ..stockQuantity = stock
                ..lowStockThreshold = lowStock
                ..isActive = true
                ..updatedAt = DateTime.now();

              if (existing == null) {
                product.createdAt = DateTime.now();
              }

              await widget.isar.products.put(product);
              imported++;
            } catch (_) {
              skipped++;
            }
          }
          break; // only first sheet
        }
      });

      setState(() {
        _importStatus =
        '✅ Imported $imported products. Skipped $skipped rows.';
        _importStatusColor = Colors.green;
        _isImporting = false;
      });
    } catch (e) {
      setState(() {
        _importStatus = '❌ Import failed: $e';
        _importStatusColor = Colors.red;
        _isImporting = false;
      });
    }
  }

  Future<void> _downloadTemplate() async {
    final rows = [
      TxnExportRow(
        reference: 'PROD001',
        userName: 'Sample Product Name',
        amount: 10.00,
        method: 'General',
        status: 'Active',
        date: DateTime.now(),
      ),
    ];
    await ExportService.exportToExcel(
      context: context,
      transactions: rows,
      fileName: 'product_import_template',
    );
    if (context.mounted) {
      AppUtil.toastMessage(
        message:
        '✅ Template downloaded — columns: Name, SKU, Category, Cost Price, Selling Price, Stock, Low Stock',
        context: context,
        backgroundColor: AppColors.primaryColor,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Export ────────────────────────────────────
          SectionTitle(title: 'Export Data'),
          const SizedBox(height: 4),
          const Text(
            'Download your data as Excel files for backup or reporting.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              ExportCard(
                title: 'Products',
                subtitle: 'All products as Excel',
                icon: Icons.inventory_2_outlined,
                color: const Color(0xFF1D6F42),
                isLoading: _isExporting,
                onTap: _exportProducts,
              ),
              const SizedBox(width: 12),
              ExportCard(
                title: 'Categories',
                subtitle: 'All categories as Excel',
                icon: Icons.category_outlined,
                color: Colors.blue,
                isLoading: _isExporting,
                onTap: _exportCategories,
              ),
              const SizedBox(width: 12),
              ExportCard(
                title: 'Transactions',
                subtitle: 'All transactions as Excel',
                icon: Icons.receipt_long_outlined,
                color: Colors.purple,
                isLoading: _isExporting,
                onTap: _exportTransactions,
              ),
            ],
          ),

          const SizedBox(height: 28),

          // ── Import ────────────────────────────────────
          SectionTitle(title: 'Import Products'),
          const SizedBox(height: 4),
          const Text(
            'Upload an Excel file to quickly onboard products. '
                'Columns must be in order: Name, SKU, Category, '
                'Cost Price, Selling Price, Stock, Low Stock Alert.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 12),

          // info banner
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: Colors.amber.withValues(alpha: 0.3)),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline,
                    size: 16, color: Colors.amber),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Download the sample template, fill it in and upload. '
                        'Products with the same SKU will be updated automatically.',
                    style: TextStyle(
                        fontSize: 12, color: Colors.black87),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              SizedBox(
                width: 220,
                child: ColorBtn(
                  text: _isImporting
                      ? 'Importing...'
                      : '↑  Import from Excel',
                  btnColor: AppColors.secondaryColor,
                  action: _isImporting ? (){} : _importProducts,
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 200,
                child: ColorBtn(
                  text: '↓  Download Template',
                  btnColor: AppColors.primaryColor,
                  action: _downloadTemplate,
                ),
              ),
            ],
          ),

          // import result
          if (_importStatus != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _importStatusColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: _importStatusColor
                        .withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Icon(
                    _importStatusColor == Colors.green
                        ? Icons.check_circle_outline
                        : Icons.error_outline,
                    size: 16,
                    color: _importStatusColor,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(_importStatus!,
                        style: TextStyle(
                            fontSize: 12,
                            color: _importStatusColor,
                            fontWeight: FontWeight.w500)),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}