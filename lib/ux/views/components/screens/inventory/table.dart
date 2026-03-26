import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

import '../../../../models/shared/category.dart';
import '../../../../models/shared/product.dart';
import '../../../../utils/shared/app.dart';
import '../../../screens/inventory.dart';
import '../../dialogs/add_category.dart';
import '../../dialogs/add_product_category.dart';
import 'category_table.dart';
import 'product_table.dart';

class InventoryTable extends StatefulWidget {
  final Isar isar;
  final InventoryView activeView;
  final Category? selectedCategory;
  final List<Category> categories;
  final bool isLoading;
  final int currentPage;
  final StockFilter stockFilter;

  final TextEditingController searchController;

  final Function(int total) onTotalChanged;
  final VoidCallback onloadData;

  // ✅ FIXED typing
  final List<Product> Function(List<Product>) filterProducts;

  const InventoryTable({
    super.key,
    required this.isar,
    required this.activeView,
    this.selectedCategory,
    required this.categories,
    required this.isLoading,
    required this.currentPage,
    required this.onTotalChanged,
    required this.searchController,
    required this.onloadData,
    required this.filterProducts,
    required this.stockFilter,
  });

  @override
  State<InventoryTable> createState() => _InventoryTableState();
}

class _InventoryTableState extends State<InventoryTable> {
  final int pageSize = 10;

  List<T> _paginate<T>(List<T> all) {
    final start = (widget.currentPage - 1) * pageSize;
    final end = (start + pageSize).clamp(0, all.length);
    if (start >= all.length) return [];
    return all.sublist(start, end);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: widget.activeView == InventoryView.products
          ? ProductsTable(
        isar: widget.isar,
        isLoading: widget.isLoading,
        filterProducts: widget.filterProducts,
        searchController: widget.searchController,
        selectedCategory: widget.selectedCategory,
        paginate: _paginate,
        onTotalChanged: widget.onTotalChanged,
        onEdit: (product) async {
          final result = await AppUtil.displayDialog(
            context: context,
            dismissible: false,
            child: AddEditProductDialog(product: product),
          );
          if (result == true) setState(() {});
        },
        stockFilter: widget.stockFilter, // Pass the filter
      )
          : CategoriesTable(
        isar: widget.isar,
        isLoading: widget.isLoading,
        paginate: _paginate,
        onTotalChanged: widget.onTotalChanged,
        onEdit: (category) async {
          final result = await AppUtil.displayDialog(
            context: context,
            dismissible: false,
            child: AddEditCategoryDialog(category: category),
          );
          if (result == true) widget.onloadData();
        },
      ),
    );
  }
}