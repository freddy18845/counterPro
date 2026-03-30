import "dart:async";
import "package:eswaini_destop_app/platform/utils/constant.dart";
import "package:eswaini_destop_app/platform/utils/isar_manager.dart";
import "package:eswaini_destop_app/ux/models/shared/category.dart";
import "package:eswaini_destop_app/ux/models/shared/product.dart";
import "package:eswaini_destop_app/ux/utils/shared/app.dart";
import "package:flutter/material.dart";
import "package:isar/isar.dart";
import "../../../res/app_colors.dart";
import "../../../res/app_strings.dart";
import "../../../utils/shared/screen.dart";
import "../../../utils/shared/stock_monitor.dart";
import "../../../utils/shared/subscriptionManger.dart";
import "../shared/base_dailog.dart";
import "../shared/login_input.dart";
import "../shared/btn.dart";

class AddEditProductDialog extends StatefulWidget {
  final Product? product; // null = add mode, not null = edit mode

  const AddEditProductDialog({
    super.key,
    this.product,
  });

  @override
  State<AddEditProductDialog> createState() => _AddEditProductDialogState();
}

class _AddEditProductDialogState extends State<AddEditProductDialog> {
  final isar = IsarService.db;
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _skuController = TextEditingController();
  final _barcodeController = TextEditingController();
  final _costPriceController = TextEditingController();
  final _sellingPriceController = TextEditingController();
  final _stockController = TextEditingController();
  final _lowStockController = TextEditingController();

  List<Category> _categories = [];
  Category? _selectedCategory;
  bool _isActive = true;
  bool _isLoading = false;

  bool get _isEditMode => widget.product != null;

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _prefillIfEditing();
  }

  void _prefillIfEditing() {
    if (!_isEditMode) return;
    final p = widget.product!;
    _nameController.text = p.name;
    _skuController.text = p.sku;
    _barcodeController.text = p.barcodeId ?? '';
    _costPriceController.text = p.costPrice.toStringAsFixed(2);
    _sellingPriceController.text = p.sellingPrice.toStringAsFixed(2);
    _stockController.text = p.stockQuantity.toString();
    _lowStockController.text = p.lowStockThreshold.toString();
    _isActive = p.isActive;
  }

  Future<void> _loadCategories() async {
    final cats = await isar.categorys.where().findAll();
    setState(() {
      _categories = cats;
      if (_isEditMode) {
        _selectedCategory = cats.firstWhere(
              (c) => c.id == widget.product!.categoryId,
          orElse: () => cats.isNotEmpty ? cats.first : Category(),
        );
      }
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategory == null) {
      AppUtil.toastMessage(
        message: 'Please select a category',
        context: context,
        backgroundColor: Colors.red,
      );
      return;
    }

    setState(() => _isLoading = true);
    final canAdd = await SubscriptionManager().canAddProduct();
    if (!canAdd) {
      AppUtil.toastMessage(
        message: 'Product limit reached (${SubscriptionManager().maxProducts}). Upgrade your plan.',
        context: context,
        backgroundColor: Colors.red,
      );
      setState(() => _isLoading = false);
      return;
    }
    final product = _isEditMode ? widget.product! : Product();

    product
      ..name = _nameController.text.trim()
      ..sku = _skuController.text.trim()
      ..barcodeId = _barcodeController.text.trim().isEmpty
          ? null
          : _barcodeController.text.trim()
      ..categoryId = _selectedCategory!.id
      ..categoryName = _selectedCategory!.name
      ..costPrice = double.tryParse(_costPriceController.text) ?? 0
      ..sellingPrice = double.tryParse(_sellingPriceController.text) ?? 0
      ..stockQuantity = int.tryParse(_stockController.text) ?? 0
      ..lowStockThreshold = int.tryParse(_lowStockController.text) ?? 5
      ..isActive = _isActive
      ..updatedAt = DateTime.now();

    if (!_isEditMode) {
      product.createdAt = DateTime.now();
    }

    await isar.writeTxn(() async {
      await isar.products.put(product);
    });
    StockMonitorService.checkStock();
    setState(() => _isLoading = false);

    if (mounted) {
      AppUtil.toastMessage(
        message: _isEditMode
            ? '✅ Product updated successfully'
            : '✅ Product added successfully',
        context: context,
        backgroundColor: Colors.green,
      );
      Navigator.pop(context, true);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _skuController.dispose();
    _barcodeController.dispose();
    _costPriceController.dispose();
    _sellingPriceController.dispose();
    _stockController.dispose();
    _lowStockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context: context);

    return PopScope(
      canPop: false,
      child: DialogBaseLayout(
        title: _isEditMode ? 'Edit Product' : 'Add Product',
        showCard: true,
        titleSize: 18,
        cardHeight: 520,
        cardWidth: 600,
        onClose: () => Navigator.pop(context),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              // ── Row 1: Name + SKU ─────────────────────────
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: InputField(
                      label: 'Product Name',
                      controller: _nameController,
                      hintText: 'Enter product name',
                      prexIcon: Icons.inventory_2_outlined,
                      validator: (v) =>
                      v == null || v.isEmpty ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InputField(
                      label: 'SKU',
                      controller: _skuController,
                      hintText: 'e.g. BEV001',
                      prexIcon: Icons.tag,
                      validator: (v) =>
                      v == null || v.isEmpty ? 'Required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // ── Row 2: Barcode + Category ─────────────────
              Row(
                children: [
                  Expanded(
                    child: InputField(
                      label: 'Barcode ID (optional)',
                      controller: _barcodeController,
                      hintText: 'Scan or enter barcode',
                      prexIcon: Icons.qr_code,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Category',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: (ScreenUtil.width * 0.04)
                                .clamp(12.0, 14.0),
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<Category>(
                          value: _selectedCategory,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            prefixIcon: const Icon(
                                Icons.category_outlined,
                                size: 20),
                            isDense: true,
                          ),
                          hint: const Text('Select category',
                              style: TextStyle(fontSize: 13)),
                          items: _categories.map((c) {
                            return DropdownMenuItem(
                              value: c,
                              child: Text(c.name,
                                  style: const TextStyle(fontSize: 13)),
                            );
                          }).toList(),
                          onChanged: (val) =>
                              setState(() => _selectedCategory = val),
                          validator: (v) =>
                          v == null ? 'Select a category' : null,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // ── Row 3: Cost + Selling price ───────────────
              Row(
                children: [
                  Expanded(
                    child: InputField(
                      label: 'Cost Price Per One',
                      controller: _costPriceController,
                      hintText: '0.00',
                      prexIcon: Icons.money_off_outlined,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Required';
                        if (double.tryParse(v) == null) return 'Invalid';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InputField(
                      label: 'Selling Price Per One',
                      controller: _sellingPriceController,
                      hintText: '0.00',
                      prexIcon: Icons.attach_money,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Required';
                        if (double.tryParse(v) == null) return 'Invalid';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // ── Row 4: Stock + Low stock + Active ─────────
              Row(
                children: [
                  Expanded(
                    child: InputField(
                      label: 'Stock Quantity',
                      controller: _stockController,
                      hintText: '0',
                      prexIcon: Icons.warehouse_outlined,
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Required';
                        if (int.tryParse(v) == null) return 'Invalid';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InputField(
                      label: 'Low Stock Alert',
                      controller: _lowStockController,
                      hintText: '5',
                      prexIcon: Icons.warning_amber_outlined,
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Required';
                        if (int.tryParse(v) == null) return 'Invalid';
                        return null;
                      },
                    ),
                  ),




                const SizedBox(width: 12),
                Expanded(
                  child:   Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Status',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () =>
                            setState(() => _isActive = !_isActive),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: _isActive
                                ? Colors.green.withValues(alpha: 0.1)
                                : Colors.red.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _isActive
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                _isActive
                                    ? Icons.check_circle_outline
                                    : Icons.cancel_outlined,
                                size: 16,
                                color: _isActive
                                    ? Colors.green
                                    : Colors.red,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                _isActive ? 'Active' : 'Inactive',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: _isActive
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ]
              ),

              // active toggle

              const SizedBox(height: 8),
              Divider(thickness: 1),
              const SizedBox(height: 8),

              // ── Buttons ───────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: ColorBtn(
                      text: AppStrings.cancel,
                      btnColor: AppColors.red,
                      action: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ColorBtn(
                      text: _isLoading
                          ? AppStrings.saving
                          : _isEditMode
                          ? 'Update Product'
                          : 'Add Product',
                      btnColor: AppColors.secondaryColor,
                      action: _isLoading ? (){} : _save,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}