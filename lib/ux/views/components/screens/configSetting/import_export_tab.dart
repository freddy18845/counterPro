import 'dart:io';

import 'package:eswaini_destop_app/ux/models/shared/category.dart';
import 'package:eswaini_destop_app/ux/models/shared/pos_transaction.dart';
import 'package:eswaini_destop_app/ux/models/shared/product.dart';
import 'package:eswaini_destop_app/ux/views/components/screens/configSetting/section_title.dart';
import 'package:excel/excel.dart' hide Border;
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

import '../../../../res/app_colors.dart';
import '../../../../utils/export_service.dart' as excel;
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

  // product import
  bool _isImportingProducts = false;
  String? _productImportStatus;
  Color _productImportStatusColor = Colors.green;

  // category import
  bool _isImportingCategories = false;
  String? _categoryImportStatus;
  Color _categoryImportStatusColor = Colors.green;

  // ── EXPORTS ───────────────────────────────────────────────────
  Future<void> _exportProducts() async {
    setState(() => _isExporting = true);
    try {
      final products =
      await widget.isar.products.where().findAll();
      final rows = products
          .map((p) => excel.TxnExportRow(
        reference: p.sku,
        userName: p.name,
        amount: p.sellingPrice,
        method: p.categoryName,
        status: p.isActive ? 'Active' : 'Inactive',
        date: p.createdAt,
      ))
          .toList();
      await excel.ExportService.exportToExcel(
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
          .map((c) => excel.TxnExportRow(
        reference: c.id.toString(),
        userName: c.name,
        amount: 0,
        method: c.description ?? '-',
        status: c.isActive ? 'Active' : 'Inactive',
        date: c.createdAt,
      ))
          .toList();
      await excel.ExportService.exportToExcel(
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
      final txns =
      await widget.isar.posTransactions.where().findAll();
      final rows = txns
          .map((t) => excel.TxnExportRow(
        reference: t.transactionNumber,
        userName: t.processedByUserId.toString(),
        amount: t.totalAmount,
        method: t.paymentMethod.name,
        status: t.status.name,
        date: t.timestamp,
      ))
          .toList();
      await excel.ExportService.exportToExcel(
        context: context,
        transactions: rows,
        fileName:
        'transactions_${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}',
      );
    } finally {
      setState(() => _isExporting = false);
    }
  }

  // ── IMPORT PRODUCTS ───────────────────────────────────────────
  Future<void> _importProducts() async {
    const typeGroup = XTypeGroup(
      label: 'Excel Files',
      extensions: ['xlsx', 'xls', 'csv'],
    );
    final XFile? file =
    await openFile(acceptedTypeGroups: [typeGroup]);
    if (file == null) return;

    setState(() {
      _isImportingProducts = true;
      _productImportStatus = 'Reading file...';
      _productImportStatusColor = AppColors.primaryColor;
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
          break;
        }
      });

      setState(() {
        _productImportStatus =
        '✅ Imported $imported products. Skipped $skipped rows.';
        _productImportStatusColor = Colors.green;
        _isImportingProducts = false;
      });
    } catch (e) {
      setState(() {
        _productImportStatus = '❌ Import failed: $e';
        _productImportStatusColor = Colors.red;
        _isImportingProducts = false;
      });
    }
  }

  // ── IMPORT CATEGORIES ─────────────────────────────────────────
  // Excel columns: Name, Description, Status (Active/Inactive)
  Future<void> _importCategories() async {
    const typeGroup = XTypeGroup(
      label: 'Excel Files',
      extensions: ['xlsx', 'xls', 'csv'],
    );
    final XFile? file =
    await openFile(acceptedTypeGroups: [typeGroup]);
    if (file == null) return;

    setState(() {
      _isImportingCategories = true;
      _categoryImportStatus = 'Reading file...';
      _categoryImportStatusColor = AppColors.primaryColor;
    });

    try {
      final bytes = await File(file.path).readAsBytes();
      final excel = Excel.decodeBytes(bytes);

      int imported = 0;
      int updated = 0;
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
              final description =
                  row[1]?.value?.toString().trim() ?? '';
              final statusStr =
                  row[2]?.value?.toString().trim().toLowerCase() ??
                      'active';

              if (name.isEmpty) {
                skipped++;
                continue;
              }

              final isActive = statusStr != 'inactive';

              // check if category already exists
              final existing = await widget.isar.categorys
                  .where()
                  .filter()
                  .nameEqualTo(name)
                  .findFirst();

              if (existing != null) {
                // update existing
                existing
                  ..description = description.isEmpty
                      ? null
                      : description
                  ..isActive = isActive
                  ..updatedAt = DateTime.now();
                await widget.isar.categorys.put(existing);
                updated++;
              } else {
                // create new
                final category = Category()
                  ..name = name
                  ..description =
                  description.isEmpty ? null : description
                  ..isActive = isActive
                  ..createdAt = DateTime.now()
                  ..updatedAt = DateTime.now();
                await widget.isar.categorys.put(category);
                imported++;
              }
            } catch (_) {
              skipped++;
            }
          }
          break; // only first sheet
        }
      });

      setState(() {
        _categoryImportStatus =
        '✅ Added $imported, updated $updated categories. Skipped $skipped rows.';
        _categoryImportStatusColor = Colors.green;
        _isImportingCategories = false;
      });
    } catch (e) {
      setState(() {
        _categoryImportStatus = '❌ Import failed: $e';
        _categoryImportStatusColor = Colors.red;
        _isImportingCategories = false;
      });
    }
  }

  // ── DOWNLOAD TEMPLATES ────────────────────────────────────────
  Future<void> _downloadProductTemplate() async {
    final rows = [
      excel.TxnExportRow(
        reference: 'PROD001',
        userName: 'Sample Product Name',
        amount: 10.00,
        method: 'General',
        status: 'Active',
        date: DateTime.now(),
      ),
    ];
    await excel.ExportService.exportToExcel(
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

  Future<void> _downloadCategoryTemplate() async {
    final rows = [
      excel.TxnExportRow(
        reference: '1',
        userName: 'Sample Category',
        amount: 0,
        method: 'Optional description here',
        status: 'Active',
        date: DateTime.now(),
      ),
    ];
    await excel.ExportService.exportToExcel(
      context: context,
      transactions: rows,
      fileName: 'category_import_template',
    );
    if (context.mounted) {
      AppUtil.toastMessage(
        message:
        '✅ Template downloaded — columns: Name, Description, Status',
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

          // ── Import Products ───────────────────────────
          SectionTitle(title: 'Import Products'),
          const SizedBox(height: 4),
          const Text(
            'Upload an Excel file to onboard products. '
                'Columns: Name, SKU, Category, Cost Price, Selling Price, Stock, Low Stock Alert.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 12),

          _InfoBanner(
            message:
            'Download the sample template, fill it in and upload. '
                'Products with the same SKU will be updated automatically.',
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              SizedBox(
                width: 220,
                child: ColorBtn(
                  text: _isImportingProducts
                      ? 'Importing...'
                      : '↑  Import Products',
                  btnColor: AppColors.secondaryColor,
                  action: _isImportingProducts
                      ? () {}
                      : _importProducts,
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 200,
                child: ColorBtn(
                  text: '↓  Product Template',
                  btnColor: AppColors.primaryColor,
                  action: _downloadProductTemplate,
                ),
              ),
            ],
          ),

          if (_productImportStatus != null) ...[
            const SizedBox(height: 12),
            _StatusBanner(
              message: _productImportStatus!,
              color: _productImportStatusColor,
            ),
          ],

          const SizedBox(height: 24),

          // ── Import Categories ─────────────────────────
          SectionTitle(title: 'Import Categories'),
          const SizedBox(height: 4),
          const Text(
            'Upload an Excel file to onboard categories. '
                'Columns: Name, Description (optional), Status (Active/Inactive).',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 12),

          _InfoBanner(
            message:
            'Download the category template, fill it in and upload. '
                'Categories with the same name will be updated automatically.',
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              SizedBox(
                width: 220,
                child: ColorBtn(
                  text: _isImportingCategories
                      ? 'Importing...'
                      : '↑  Import Categories',
                  btnColor: AppColors.secondaryColor,
                  action: _isImportingCategories
                      ? () {}
                      : _importCategories,
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 200,
                child: ColorBtn(
                  text: '↓  Category Template',
                  btnColor: AppColors.primaryColor,
                  action: _downloadCategoryTemplate,
                ),
              ),
            ],
          ),

          if (_categoryImportStatus != null) ...[
            const SizedBox(height: 12),
            _StatusBanner(
              message: _categoryImportStatus!,
              color: _categoryImportStatusColor,
            ),
          ],

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ── Info banner ───────────────────────────────────────────────
class _InfoBanner extends StatelessWidget {
  final String message;
  const _InfoBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border:
        Border.all(color: Colors.amber.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline,
              size: 16, color: Colors.amber),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                  fontSize: 12, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Status banner ─────────────────────────────────────────────
class _StatusBanner extends StatelessWidget {
  final String message;
  final Color color;
  const _StatusBanner(
      {required this.message, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(
            color == Colors.green
                ? Icons.check_circle_outline
                : Icons.error_outline,
            size: 16,
            color: color,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                  fontSize: 12,
                  color: color,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}