// ── Products table ────────────────────────────────────────────
import 'package:eswaini_destop_app/platform/utils/constant.dart';
import 'package:eswaini_destop_app/ux/views/components/screens/inventory/table_row.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

import '../../../../models/shared/category.dart';
import '../../../../models/shared/product.dart';
import '../../../screens/inventory.dart';

class ProductsTable extends StatelessWidget {
  final Isar isar;
  final List<Product> Function(List<Product>) filterProducts;
  final TextEditingController searchController;
  final Category? selectedCategory;
  final bool isLoading;
  final StockFilter stockFilter;
  final List<Product> Function(List<Product>) paginate;
  final ValueChanged<int> onTotalChanged;
  final void Function(Product product) onEdit;

  const ProductsTable({
    required this.isar,
    required this.filterProducts,
    required this.searchController,
    required this.selectedCategory,
    required this.paginate,
    required this.isLoading,
    required this.onTotalChanged,
    required this.onEdit,
    required this.stockFilter,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Product>>(
      stream:  isar.products
          .where()
          .watch(fireImmediately: true)
          .distinct((a, b) {
        if (a.length != b.length) return false;
        for (int i = 0; i < a.length; i++) {
          if (a[i].id != b[i].id ||
              a[i].updatedAt != b[i].updatedAt) return false;
        }
        return true;
      }),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CupertinoActivityIndicator(radius: 12, color: Colors.grey));
        }
        final filtered = filterProducts(snapshot.data!);
        WidgetsBinding.instance.addPostFrameCallback(
                (_) => onTotalChanged(filtered.length));
        final paged = paginate(filtered);

        if (paged.isEmpty) {
          return const Center(child: Text('No products found'));
        }

        return Column(
          children: [
            InventoryTableRow(
              isHeader: true,
              cells: const [
                'Name', 'SKU', 'Category',
                'Cost', 'Price', 'Stock', 'Status',
              ],
            ),
            Expanded(
              child:
             ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 2),
                itemCount: paged.length,
               addRepaintBoundaries: true,   // ← isolates repaints
               addAutomaticKeepAlives: false, // ← don't keep off-screen items alive
               cacheExtent: 200,
               itemBuilder: (context, index) {
                  final p = paged[index];
                  final isLowStock =
                      p.stockQuantity <= p.lowStockThreshold;
                  return InventoryTableRow(
                    isHeader: false,
                    isAlternate: index.isOdd,
                    product: p,              // ← pass category object
                    onEdit: onEdit,
                    cells: [
                      p.name,
                      p.sku,
                      p.categoryName,
                      '${ConstantUtil.currencySymbol} ${p.costPrice.toStringAsFixed(2)}',
                      '${ConstantUtil.currencySymbol} ${p.sellingPrice.toStringAsFixed(2)}',
                      p.stockQuantity.toString(),
                      p.isActive ? 'Active' : 'Inactive',
                    ],
                    stockWarning: isLowStock,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
