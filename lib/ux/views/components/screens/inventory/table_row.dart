import 'package:eswaini_destop_app/ux/utils/sessionManager.dart';
import 'package:flutter/material.dart';
import '../../../../models/shared/category.dart';
import '../../../../models/shared/product.dart';
import '../../../../res/app_colors.dart';

class InventoryTableRow extends StatelessWidget {
  final List<String> cells;
  final bool isHeader;
  final bool isAlternate;
  final bool stockWarning;
  final Product? product;
  final Category? category;
  final String? stockStatus; // 'low', 'out', or 'good'
  final void Function(Product product)? onEdit;
  final void Function(Category category)? onCategoryEdit;

  const InventoryTableRow({
    super.key,
    required this.cells,
    this.isHeader = false,
    this.isAlternate = false,
    this.stockWarning = false,
    this.product,
    this.category,
    this.onEdit,
    this.onCategoryEdit,
    this.stockStatus,
  });

  // Get background color based on stock status
  Color? _getBackgroundColor() {
    if (isHeader) return null;

    switch (stockStatus) {
      case 'out':
        return Colors.red.shade50;
      case 'low':
        return Colors.orange.shade50;
      case 'good':
        return Colors.green.shade50;
      default:
        return isAlternate ? Colors.grey.withValues(alpha: 0.05) : Colors.transparent;
    }
  }

  // Get text color for stock cell
  Color _getStockTextColor(String stockValue) {
    if (stockValue.contains('⚠️') || stockValue.contains('Out')) {
      return Colors.red.shade700;
    }
    if (stockValue.contains('⚠️') && !stockValue.contains('0')) {
      return Colors.orange.shade700;
    }
    return Colors.black87;
  }

  // Get stock display widget with icon
  Widget _buildStockCell(String cell, int index) {
    // Check if this is the stock column (usually index 5)
    final isStockColumn = index == 5;

    if (!isStockColumn || isHeader) {
      return Text(
        cell,
        style: TextStyle(
          fontSize: 13,
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          color: isHeader ? AppColors.primaryColor : Colors.black87,
        ),
      );
    }


    return Text(
      cell.replaceAll('⚠️', '').trim(),
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: _getStockTextColor(cell),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Container(

        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isHeader
              ? AppColors.primaryColor.withOpacity(0.12)
              : isAlternate
              ? Colors.grey.withOpacity(0.04)
              : Colors.transparent,
          border: Border(
            bottom: BorderSide(color: Colors.grey.withOpacity(0.15)),
          ),
        ),
      child: Row(
        children: [
          // ── Data cells ──────────────────────────────────
          ...cells.asMap().entries.map((entry) {
            final i = entry.key;
            final cell = entry.value;

            return Expanded(
              child: _buildStockCell(cell, i),
            );
          }),

          // ── Edit button (data rows only) ─────────────────
          if (!isHeader && !SessionManager().isCashier)
            SizedBox(
              width: 72,
              child: GestureDetector(
                onTap: () {
                  if (product != null && onEdit != null) {
                    onEdit!(product!);
                  } else if (category != null && onCategoryEdit != null) {
                    onCategoryEdit!(category!);
                  }
                },
                child:RepaintBoundary(
                  child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: _getEditButtonColor(),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: _getEditButtonBorderColor(),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.edit_outlined,
                        size: 13,
                        color: _getEditButtonIconColor(),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Edit',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _getEditButtonTextColor(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ) ),

          // ── Header spacer to align with edit column ──────
          if (isHeader)
            const SizedBox(width: 72),
        ],
      ),
    );
  }

  // Edit button styling based on stock status
  Color _getEditButtonColor() {
    if (stockStatus == 'out') {
      return Colors.red.shade50;
    }
    if (stockStatus == 'low') {
      return Colors.orange.shade50;
    }
    return AppColors.primaryColor.withValues(alpha: 0.08);
  }

  Color _getEditButtonBorderColor() {
    if (stockStatus == 'out') {
      return Colors.red.shade200;
    }
    if (stockStatus == 'low') {
      return Colors.orange.shade200;
    }
    return AppColors.primaryColor.withValues(alpha: 0.3);
  }

  Color _getEditButtonIconColor() {
    if (stockStatus == 'out') {
      return Colors.red.shade700;
    }
    if (stockStatus == 'low') {
      return Colors.orange.shade700;
    }
    return AppColors.primaryColor;
  }

  Color _getEditButtonTextColor() {
    if (stockStatus == 'out') {
      return Colors.red.shade700;
    }
    if (stockStatus == 'low') {
      return Colors.orange.shade700;
    }
    return AppColors.primaryColor;
  }
}