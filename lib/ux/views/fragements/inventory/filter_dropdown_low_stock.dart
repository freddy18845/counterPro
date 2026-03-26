import 'package:eswaini_destop_app/ux/models/shared/product.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

import '../../../../platform/utils/isar_manager.dart';
import '../../../res/app_colors.dart';
import '../../../utils/shared/screen.dart';
import '../../screens/inventory.dart';

class StockFilterDropdown extends StatefulWidget {
  final StockFilter currentFilter;
  final Function(StockFilter) onFilterChanged;

  const StockFilterDropdown({
    super.key,
    required this.currentFilter,
    required this.onFilterChanged,
  });

  @override
  State<StockFilterDropdown> createState() => _StockFilterDropdownState();
}

class _StockFilterDropdownState extends State<StockFilterDropdown> {
  Map<StockFilter, int> _counts = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCounts();
  }

  Future<void> _loadCounts() async {
    setState(() => _isLoading = true);
    _counts = await _getStockCounts();
    setState(() => _isLoading = false);
  }

  Future<Map<StockFilter, int>> _getStockCounts() async {
    final products = await IsarService.db.products.where().findAll();

    return {
      StockFilter.all: products.where((p) => p.isActive).length,
      StockFilter.lowStock: products.where((p) =>
      p.isActive && p.stockQuantity > 0 && p.stockQuantity <= p.lowStockThreshold).length,
      StockFilter.outOfStock: products.where((p) =>
      p.isActive && p.stockQuantity <= 0).length,
      StockFilter.inStock: products.where((p) =>
      p.isActive && p.stockQuantity > p.lowStockThreshold).length,
    };
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (ScreenUtil.width * 0.18).clamp(160, 220),
      child: DropdownButtonFormField<StockFilter>(
        value: widget.currentFilter,
        decoration: InputDecoration(
         // contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          border: _buildBorder(Colors.grey.shade300),
          enabledBorder: _buildBorder(Colors.grey.shade300),
          focusedBorder: _buildBorder(AppColors.primaryColor, width: 1.5),
          filled: true,
          fillColor: Colors.white,
         // prefixIcon: const Icon(Icons.filter_list, size: 18, color: Colors.grey),
          suffixIcon: _isLoading
              ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2))
              : null,
        ),
        icon: const Icon(Icons.arrow_drop_down),
        isDense: true,
        items: _buildDropdownItems(),
        onChanged: (value) {
          if (value != null) widget.onFilterChanged(value);
        },
        dropdownColor: Colors.white,
        menuMaxHeight: 300,
        borderRadius: BorderRadius.circular(8),
        selectedItemBuilder: (context) => _buildSelectedItems(),
      ),
    );
  }

  OutlineInputBorder _buildBorder(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
     // borderSide: BorderSide(color: color, width: width),
    );
  }

  List<DropdownMenuItem<StockFilter>> _buildDropdownItems() {
    final items = StockFilter.values.map((filter) {
      return DropdownMenuItem(
        value: filter,
        child: _buildFilterOption(filter),
      );
    }).toList();
    return items;
  }

  List<Widget> _buildSelectedItems() {
    return StockFilter.values.map((filter) {
      return _buildFilterOption(filter);
    }).toList();
  }

  Widget _buildFilterOption(StockFilter filter) {
    final config = _getFilterConfig(filter);
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: config.color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          '${config.label} (${_counts[filter] ?? 0})',
          style: const TextStyle(fontSize: 13),
        ),
      ],
    );
  }

  _FilterConfig _getFilterConfig(StockFilter filter) {
    switch (filter) {
      case StockFilter.lowStock:
        return _FilterConfig(Colors.orange, 'Low Stock');
      case StockFilter.outOfStock:
        return _FilterConfig(Colors.red, 'Out of Stock');
      case StockFilter.inStock:
        return _FilterConfig(Colors.green, 'In Stock');
      default:
        return _FilterConfig(Colors.grey, 'All Products');
    }
  }
}

class _FilterConfig {
  final Color color;
  final String label;
  const _FilterConfig(this.color, this.label);
}