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
  int _productImported = 0;
  int _productUpdated = 0;
  int _productSkipped = 0;

  // category import
  bool _isImportingCategories = false;
  String? _categoryImportStatus;
  Color _categoryImportStatusColor = Colors.green;
  int _categoryImported = 0;
  int _categoryUpdated = 0;
  int _categorySkipped = 0;

  // ── EXPORTS ───────────────────────────────────────────────────
  Future<void> _exportProducts() async {
    setState(() => _isExporting = true);
    try {
      final products = await widget.isar.products.where().findAll();
      final rows = products
          .map(
            (p) => excel.ProductExportRow(
          sKU: p.sku,
          name: p.name,
          sellingPrice: p.sellingPrice,
          costPrice: p.costPrice,
          category: p.categoryName,
          stock: p.stockQuantity,
          lowStock: p.lowStockThreshold,
          categoryId: p.categoryId,
          createdAt: p.createdAt,
          updatedAt: DateTime.now(),
          isActive: p.isActive ? 'Active' : 'Inactive',
          date: p.createdAt,
        ),
      )
          .toList();
      await excel.ExportService.exportToExcel(
        context: context,
        tableName: 'products',
        products: rows,
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
      final cats = await widget.isar.categorys.where().findAll();
      final rows = cats
          .map(
            (c) => excel.CategoryExportRow(
          name: c.name,
          description: c.description ?? '',
          status: c.isActive ? 'Active' : 'Inactive',
          date: c.createdAt,
        ),
      )
          .toList();
      await excel.ExportService.exportToExcel(
        context: context,
        tableName: 'categories',
        categories: rows,
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
      final txns = await widget.isar.posTransactions.where().findAll();
      final rows = txns
          .map(
            (t) => excel.TxnExportRow(
          reference: t.transactionNumber,
          userName: t.processedByUserId.toString(),
          amount: t.totalAmount,
          method: t.paymentMethod.name,
          status: t.status.name,
          date: t.timestamp,
        ),
      )
          .toList();
      await excel.ExportService.exportToExcel(
        context: context,
        transactions: rows,
        tableName: 'transactions',
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
    final XFile? file = await openFile(acceptedTypeGroups: [typeGroup]);
    if (file == null) return;

    setState(() {
      _isImportingProducts = true;
      _productImportStatus = 'Reading file...';
      _productImportStatusColor = AppColors.primaryColor;
      _productImported = 0;
      _productUpdated = 0;
      _productSkipped = 0;
    });

    try {
      final bytes = await File(file.path).readAsBytes();
      final excel = Excel.decodeBytes(bytes);

      print('📄 Starting product import from: ${file.path}');
      print('📊 Excel file has ${excel.tables.length} sheets');

      await widget.isar.writeTxn(() async {
        bool hasData = false;

        // Process ALL sheets to find data
        for (final table in excel.tables.keys) {
          final sheet = excel.tables[table];
          if (sheet == null) continue;

          print('📑 Processing sheet: $table, Rows: ${sheet.rows.length}');

          // Skip empty sheets
          if (sheet.rows.length <= 1) {
            print('⚠️ Sheet $table has no data rows, skipping');
            continue;
          }

          // Process this sheet
          for (int i = 1; i < sheet.rows.length; i++) {
            final row = sheet.rows[i];
            if (row.isEmpty || row.every((cell) => cell?.value == null)) {
              _productSkipped++;
              continue;
            }

            try {
              // Log first few rows for debugging
              if (i <= 3) {
                print('Row $i raw data: ${row.map((c) => c?.value).toList()}');
              }

              // Parse columns with better error handling
              final name = row.length > 0 ? row[0]?.value?.toString().trim() ?? '' : '';
              final sku = row.length > 1 ? row[1]?.value?.toString().trim() ?? '' : '';
              final categoryName = row.length > 2 ? row[2]?.value?.toString().trim() ?? '' : '';
              final costPrice = row.length > 3 ? double.tryParse(row[3]?.value?.toString() ?? '0') ?? 0 : 0;
              final sellingPrice = row.length > 4 ? double.tryParse(row[4]?.value?.toString() ?? '0') ?? 0 : 0;
              final stock = row.length > 5 ? int.tryParse(row[5]?.value?.toString() ?? '0') ?? 0 : 0;
              final lowStock = row.length > 6 ? int.tryParse(row[6]?.value?.toString() ?? '5') ?? 5 : 5;

              if (name.isEmpty || sku.isEmpty) {
                print('Row $i skipped: empty name or SKU');
                _productSkipped++;
                continue;
              }

              // Find or create category
              var category = await widget.isar.categorys
                  .where()
                  .filter()
                  .nameEqualTo(categoryName)
                  .findFirst();

              if (category == null && categoryName.isNotEmpty) {
                print('Creating new category: $categoryName');
                category = Category()
                  ..name = categoryName
                  ..description = null
                  ..isActive = true
                  ..createdAt = DateTime.now()
                  ..updatedAt = DateTime.now();
                await widget.isar.categorys.put(category);
              }

              // Check if product already exists by SKU
              final existingProduct = await widget.isar.products
                  .where()
                  .filter()
                  .skuEqualTo(sku)
                  .findFirst();

              if (existingProduct != null) {
                print('Updating existing product: $sku');
                existingProduct
                  ..name = name
                  ..sku = sku
                  ..categoryId = category?.id ?? 0
                  ..categoryName = categoryName
                  ..costPrice = costPrice.toDouble()
                  ..sellingPrice = sellingPrice.toDouble()
                  ..stockQuantity = stock
                  ..lowStockThreshold = lowStock
                  ..updatedAt = DateTime.now();
                await widget.isar.products.put(existingProduct);
                _productUpdated++;
              } else {
                print('Creating new product: $sku');
                final newProduct = Product()
                  ..name = name
                  ..sku = sku
                  ..categoryId = category?.id ?? 0
                  ..categoryName = categoryName
                  ..costPrice = costPrice.toDouble()
                  ..sellingPrice = sellingPrice.toDouble()
                  ..stockQuantity = stock
                  ..lowStockThreshold = lowStock
                  ..isActive = true
                  ..createdAt = DateTime.now()
                  ..updatedAt = DateTime.now();
                await widget.isar.products.put(newProduct);
                _productImported++;
              }
              hasData = true;
            } catch (e) {
              print('Error importing row $i: $e');
              _productSkipped++;
            }
          }

          // Don't break - process all sheets to find data
          // If we found data in this sheet, we could optionally break here
          // but processing all sheets ensures we don't miss data in other sheets
        }

        if (!hasData) {
          print('⚠️ No valid data found in any sheet');
        }
      });

      // Verify the import by counting products
      final finalProductCount = await widget.isar.products.count();
      print('✅ Import complete. Total products in database: $finalProductCount');
      print('📊 Import stats - New: $_productImported, Updated: $_productUpdated, Skipped: $_productSkipped');

      setState(() {
        _productImportStatus =
        '✅ Imported $_productImported new products, updated $_productUpdated products. Skipped $_productSkipped rows. Total products: $finalProductCount';
        _productImportStatusColor = Colors.green;
        _isImportingProducts = false;
      });

      // Show a toast with the result
      if (context.mounted) {
        AppUtil.toastMessage(
          message: 'Imported $_productImported, Updated $_productUpdated products',
          context: context,
          backgroundColor: AppColors.primaryColor,
        );
      }
    } catch (e) {
      print('❌ Import failed: $e');
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
    final XFile? file = await openFile(acceptedTypeGroups: [typeGroup]);
    if (file == null) return;

    setState(() {
      _isImportingCategories = true;
      _categoryImportStatus = 'Reading file...';
      _categoryImportStatusColor = AppColors.primaryColor;
      _categoryImported = 0;
      _categoryUpdated = 0;
      _categorySkipped = 0;
    });

    try {
      final bytes = await File(file.path).readAsBytes();
      final excel = Excel.decodeBytes(bytes);

      await widget.isar.writeTxn(() async {
        bool hasData = false;

        // Process ALL sheets
        for (final table in excel.tables.keys) {
          final sheet = excel.tables[table];
          if (sheet == null) continue;

          print('📑 Processing sheet: $table, Rows: ${sheet.rows.length}');

          if (sheet.rows.length <= 1) {
            print('⚠️ Sheet $table has no data rows, skipping');
            continue;
          }

          for (int i = 1; i < sheet.rows.length; i++) {
            final row = sheet.rows[i];
            if (row.isEmpty || row.every((cell) => cell?.value == null)) {
              _categorySkipped++;
              continue;
            }

            try {
              final name = row.length > 0 ? row[0]?.value?.toString().trim() ?? '' : '';
              final description = row.length > 1 ? row[1]?.value?.toString().trim() ?? '' : '';
              final statusStr = row.length > 2
                  ? row[2]?.value?.toString().trim().toLowerCase() ?? 'active'
                  : 'active';

              if (name.isEmpty) {
                _categorySkipped++;
                continue;
              }

              final isActive = statusStr == 'active' || statusStr == 'yes' || statusStr == 'true';

              // Check if category already exists
              final existingCategory = await widget.isar.categorys
                  .where()
                  .filter()
                  .nameEqualTo(name)
                  .findFirst();

              if (existingCategory != null) {
                existingCategory
                  ..description = description.isEmpty ? null : description
                  ..isActive = isActive
                  ..updatedAt = DateTime.now();
                await widget.isar.categorys.put(existingCategory);
                _categoryUpdated++;
              } else {
                final newCategory = Category()
                  ..name = name
                  ..description = description.isEmpty ? null : description
                  ..isActive = isActive
                  ..createdAt = DateTime.now()
                  ..updatedAt = DateTime.now();
                await widget.isar.categorys.put(newCategory);
                _categoryImported++;
              }
              hasData = true;
            } catch (e) {
              print('Error importing category row $i: $e');
              _categorySkipped++;
            }
          }
        }

        if (!hasData) {
          print('⚠️ No valid category data found in any sheet');
        }
      });

      setState(() {
        _categoryImportStatus =
        '✅ Added $_categoryImported, updated $_categoryUpdated categories. Skipped $_categorySkipped rows.';
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

  // ── IMPORT TRANSACTIONS ───────────────────────────────────────
  Future<void> _importTransactions() async {
    const typeGroup = XTypeGroup(
      label: 'Excel Files',
      extensions: ['xlsx', 'xls', 'csv'],
    );
    final XFile? file = await openFile(acceptedTypeGroups: [typeGroup]);
    if (file == null) return;

    setState(() {
      _isImportingCategories = true; // Using same loading state
      _categoryImportStatus = 'Reading file...';
      _categoryImportStatusColor = AppColors.primaryColor;
    });

    try {
      final bytes = await File(file.path).readAsBytes();
      final excel = Excel.decodeBytes(bytes);

      int imported = 0;
      int skipped = 0;
      int duplicate = 0;

      print('📄 Starting transaction import from: ${file.path}');
      print('📊 Excel file has ${excel.tables.length} sheets');

      await widget.isar.writeTxn(() async {
        bool hasData = false;

        // Process ALL sheets to find data
        for (final table in excel.tables.keys) {
          final sheet = excel.tables[table];
          if (sheet == null) continue;

          print('📑 Processing sheet: $table, Rows: ${sheet.rows.length}');

          // Skip empty sheets
          if (sheet.rows.length <= 1) {
            print('⚠️ Sheet $table has no data rows, skipping');
            continue;
          }

          for (int i = 1; i < sheet.rows.length; i++) {
            final row = sheet.rows[i];

            // Skip completely empty rows
            if (row.isEmpty || row.every((cell) => cell?.value == null)) {
              skipped++;
              continue;
            }

            try {
              // Log first few rows for debugging
              if (i <= 3) {
                print('Row $i raw data: ${row.map((c) => c?.value).toList()}');
              }

              // Safe extraction with null checks
              final reference = row.length > 0 ? row[0]?.value?.toString().trim() ?? '' : '';
              final userName = row.length > 1 ? row[1]?.value?.toString().trim() ?? '' : '';

              // Safe amount parsing with null checks
              double amount = 0;
              if (row.length > 2 && row[2]?.value != null) {
                amount = double.tryParse(row[2]!.value.toString().replaceAll(',', '')) ?? 0;
              }

              final method = row.length > 3 ? row[3]?.value?.toString().trim() ?? '' : '';
              final status = row.length > 4 ? row[4]?.value?.toString().trim() ?? '' : '';
              final dateStr = row.length > 5 ? row[5]?.value?.toString().trim() ?? '' : '';

              print('Row $i parsed: ref=$reference, amount=$amount, method=$method, status=$status');

              if (reference.isEmpty) {
                print('Row $i skipped: empty reference');
                skipped++;
                continue;
              }

              // Check if transaction already exists by reference number
              final existingTransaction = await widget.isar.posTransactions
                  .where()
                  .filter()
                  .transactionNumberEqualTo(reference)
                  .findFirst();

              if (existingTransaction != null) {
                print('Row $i skipped: duplicate transaction $reference');
                duplicate++;
                continue;
              }

              // Parse date - try multiple formats
              DateTime? transactionDate;
              if (dateStr.isNotEmpty) {
                try {
                  // Try DD/MM/YYYY format
                  final parts = dateStr.split('/');
                  if (parts.length == 3) {
                    transactionDate = DateTime(
                      int.parse(parts[2]),
                      int.parse(parts[1]),
                      int.parse(parts[0]),
                    );
                  } else {
                    transactionDate = DateTime.parse(dateStr);
                  }
                } catch (_) {
                  // Try alternative format MM/DD/YYYY
                  try {
                    final parts = dateStr.split('/');
                    if (parts.length == 3) {
                      transactionDate = DateTime(
                        int.parse(parts[2]),
                        int.parse(parts[0]),
                        int.parse(parts[1]),
                      );
                    } else {
                      transactionDate = DateTime.now();
                    }
                  } catch (_) {
                    print('Could not parse date: $dateStr, using current date');
                    transactionDate = DateTime.now();
                  }
                }
              } else {
                transactionDate = DateTime.now();
              }

              // Map payment method
              PaymentMethod paymentMethod;
              switch (method.toLowerCase().trim()) {
                case 'cash':
                  paymentMethod = PaymentMethod.cash;
                  break;
                case 'card':
                case 'credit card':
                case 'debit card':
                  paymentMethod = PaymentMethod.card;
                  break;
                case 'mobile money':
                case 'mobile':
                case 'momo':
                  paymentMethod = PaymentMethod.mobileMoney;
                  break;
                case 'split':
                  paymentMethod = PaymentMethod.split;
                  break;
                default:
                  print('Unknown payment method: $method, defaulting to cash');
                  paymentMethod = PaymentMethod.cash;
              }

              // Map transaction status
              PosTransactionStatus transactionStatus;
              switch (status.toLowerCase().trim()) {
                case 'completed':
                case 'complete':
                case 'success':
                case 'successful':
                  transactionStatus = PosTransactionStatus.completed;
                  break;
                case 'refunded':
                case 'refund':
                  transactionStatus = PosTransactionStatus.refunded;
                  break;
                case 'voided':
                case 'void':
                  transactionStatus = PosTransactionStatus.voided;
                  break;
                default:
                  print('Unknown status: $status, defaulting to completed');
                  transactionStatus = PosTransactionStatus.completed;
              }

              // Parse user ID with better error handling
              int userId;
              try {
                userId = int.tryParse(userName) ?? 1;
              } catch (_) {
                userId = 1;
              }

              // Create new transaction
              final newTransaction = PosTransaction()
                ..transactionNumber = reference
                ..processedByUserId = userId
                ..totalAmount = amount
                ..paymentMethod = paymentMethod
                ..status = transactionStatus
                ..timestamp = transactionDate;

              await widget.isar.posTransactions.put(newTransaction);
              imported++;
              hasData = true;

              print('✅ Imported transaction: $reference');
            } catch (e) {
              print('Error importing transaction row $i: $e');
              skipped++;
            }
          }
        }

        if (!hasData) {
          print('⚠️ No valid transaction data found in any sheet');
        }
      });

      setState(() {
        _categoryImportStatus =
        '✅ Imported $imported transactions. Skipped $skipped rows. Duplicates: $duplicate';
        _categoryImportStatusColor = Colors.green;
        _isImportingCategories = false;
      });

      // Show toast with result
      if (context.mounted) {
        AppUtil.toastMessage(
          message: 'Imported $imported transactions (Duplicates: $duplicate)',
          context: context,
          backgroundColor: AppColors.primaryColor,
        );
      }

      print('📊 Transaction Import Summary:');
      print('   Imported: $imported');
      print('   Duplicates: $duplicate');
      print('   Skipped: $skipped');
    } catch (e) {
      print('❌ Transaction import failed: $e');
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
      excel.ProductExportRow(
        sKU: 'PROD001',
        name: 'Sample Product Name',
        sellingPrice: 10.00,
        costPrice: 9.00,
        category: 'Sample Category',
        stock: 200,
        lowStock: 10,
        categoryId: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isActive: 'Active',
        date: DateTime.now(),
      ),
    ];
    await excel.ExportService.exportToExcel(
      context: context,
      tableName: 'products',
      products: rows,
      fileName: 'product_import_template',
    );
    if (context.mounted) {
      AppUtil.toastMessage(
        message:
        '✅ Template downloaded — columns: Name, SKU, Category, Cost Price, Selling Price, Stock, Low Stock Alert',
        context: context,
        backgroundColor: AppColors.primaryColor,
      );
    }
  }

  Future<void> _downloadCategoryTemplate() async {
    final rows = [
      excel.CategoryExportRow(
        name: 'Sample Category',
        description: 'Detailed description of the category',
        status: 'Active',
        date: DateTime.now(),
      ),
    ];
    await excel.ExportService.exportToExcel(
      context: context,
      categories: rows,
      tableName: 'categories',
      fileName: 'category_import_template',
    );
    if (context.mounted) {
      AppUtil.toastMessage(
        message: '✅ Template downloaded — columns: Name, Description, Status (Active/Inactive)',
        context: context,
        backgroundColor: AppColors.primaryColor,
      );
    }
  }

  Future<void> _downloadTransactionTemplate() async {
    final rows = [
      excel.TxnExportRow(
        reference: 'TXN001',
        userName: '1',
        amount: 100.00,
        method: 'Cash',
        status: 'Completed',
        date: DateTime.now(),
      ),
    ];
    await excel.ExportService.exportToExcel(
      context: context,
      transactions: rows,
      tableName: 'transactions',
      fileName: 'transaction_import_template',
    );
    if (context.mounted) {
      AppUtil.toastMessage(
        message: '✅ Template downloaded — columns: Reference, User ID, Amount, Method, Status, Date',
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
                  action: _isImportingProducts ? () {} : _importProducts,
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
                  action: _isImportingCategories ? () {} : _importCategories,
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

          // ── Import Transactions ────────────────────────
          SectionTitle(title: 'Import Transactions'),
          const SizedBox(height: 4),
          const Text(
            'Upload an Excel file to import transactions. '
                'Columns: Reference, User ID, Amount, Method, Status, Date.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 12),

          _InfoBanner(
            message:
            'Download the transaction template, fill it in and upload. '
                'Transactions with the same reference number will be skipped to avoid duplicates.',
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              SizedBox(
                width: 220,
                child: ColorBtn(
                  text: _isImportingCategories
                      ? 'Importing...'
                      : '↑  Import Transactions',
                  btnColor: AppColors.secondaryColor,
                  action: _isImportingCategories ? () {} : _importTransactions,
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 200,
                child: ColorBtn(
                  text: '↓  Transaction Template',
                  btnColor: AppColors.primaryColor,
                  action: _downloadTransactionTemplate,
                ),
              ),
            ],
          ),
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
        border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, size: 16, color: Colors.amber),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(fontSize: 12, color: Colors.black87),
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
  const _StatusBanner({required this.message, required this.color});

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
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}