import 'package:eswaini_destop_app/ux/utils/shared/app.dart';
import 'package:flutter/material.dart';
import '../../../../../platform/utils/constant.dart';
import '../../../../models/shared/category.dart';
import '../../../../models/shared/product.dart';
import '../../../../res/app_colors.dart';
import '../../../../utils/shared/screen.dart';
import '../../shared/card_widget.dart';
import '../../shared/inline_text.dart';
import '../../shared/login_input.dart';

class SalesLeftSection extends StatefulWidget {
  final List<Product> allProducts;
  final List<Product> filteredProducts;
  final List<Category> categories;
  final Category? selectedCategory;
  final TextEditingController searchController;
  final bool showSuggestions;
  final Function(Product) onAddToCart;
  final FocusNode focusNode;
  final Function(Category?) onCategoryChanged;
  final String title;

  const SalesLeftSection({
    super.key,
    required this.allProducts,
    required this.filteredProducts,
    required this.categories,
    required this.selectedCategory,
    required this.searchController,
    required this.showSuggestions,
    required this.onAddToCart,
    required this.onCategoryChanged,
    required this.title,
    required this.focusNode,
  });

  @override
  State<SalesLeftSection> createState() => _SalesLeftSectionState();
}

class _SalesLeftSectionState extends State<SalesLeftSection> {
  final bool isDesktop = ScreenUtil.width >= 900;

  void handleScan(String scannedValue) {
    if (scannedValue.trim().isEmpty) return;

    final cleanValue = scannedValue.trim();

    // Find the first matching product (barcode > SKU > name)
    Product? foundProduct;

    for (final p in widget.allProducts) {
      if ((p.barcodeId != null && p.barcodeId!.trim() == cleanValue) ||
          (p.sku != null && p.sku.trim().toLowerCase() == cleanValue.toLowerCase()) ||
          p.name.trim().toLowerCase() == cleanValue.toLowerCase()) {
        foundProduct = p;
        break; // Stop at the first match for better performance
      }
    }

    if (foundProduct != null) {
      widget.onAddToCart(foundProduct);
      AppUtil.toastMessage(message: 'Product Added!', context: context, );
    } else {
      AppUtil.toastMessage(message: 'No product found for "$scannedValue"', context: context, backgroundColor: Colors.orange,);
      // Optional feedback for user

    }

    // Critical for barcode scanner: clear and keep focus ready for next scan
    widget.searchController.clear();
    widget.focusNode.requestFocus();
  }

  @override
  void dispose() {
    widget.focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: CustomCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: ConstantUtil.verticalSpacing / 4),

            // ✅ FIXED
            InlineText(title: widget.title.toUpperCase()),

            SizedBox(height: ConstantUtil.verticalSpacing / 4),

            /// 🔍 SEARCH + CATEGORY
            Row(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Focus(
                        onKeyEvent: (node, event) => KeyEventResult.ignored,
                        child: ConfigField(
                          controller: widget.searchController,
                          hintText: 'Search by name, SKU or barcode...',
                          enabled: true,
                          focusNode: widget.focusNode,
                          keyboardType: TextInputType.text,
                          onSubmitted: handleScan,
                        ),
                      ),

                      /// 🔽 SUGGESTIONS
                      if (widget.showSuggestions &&
                          widget.filteredProducts.isNotEmpty)
                        Positioned(
                          top: 50,
                          left: 0,
                          right: 0,
                          child: Material(
                            elevation: 8,
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              constraints: const BoxConstraints(maxHeight: 220),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.grey.withOpacity(0.2),
                                ),
                              ),
                              child: ListView.separated(
                                shrinkWrap: true,
                                itemCount: widget.filteredProducts.length,
                                addRepaintBoundaries: true,   // ← isolates repaints
                                addAutomaticKeepAlives: false, // ← don't keep off-screen items alive
                                cacheExtent: 200,
                                separatorBuilder: (_, __) => Divider(
                                  height: 1,
                                  color: Colors.grey.withOpacity(0.15),
                                ),
                                itemBuilder: (context, index) {
                                  final p = widget.filteredProducts[index];
                                  return ListTile(
                                    dense: true,
                                    title: Text(
                                      p.name,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    subtitle: Text(
                                      '${p.sku} · Stock: ${p.stockQuantity}',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    trailing: Text(
                                      '${ConstantUtil.currencySymbol} ${p.sellingPrice.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryColor,
                                      ),
                                    ),

                                    // ✅ FIXED
                                    onTap: () {
                                      widget.onAddToCart(p);
                                      widget.focusNode.requestFocus();
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                SizedBox(width: ScreenUtil.width * 0.01),

                /// 🧩 CATEGORY FILTER
                SizedBox(
                  width: (ScreenUtil.width * 0.12).clamp(120, 200),
                  child: DropdownButtonFormField<Category?>(
                    value: widget.selectedCategory,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      isDense: true,
                    ),
                    hint: const Text(
                      'Category',
                      style: TextStyle(fontSize: 12),
                    ),
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('All', style: TextStyle(fontSize: 12)),
                      ),

                      // ✅ FIXED (_categories → categories)
                      ...widget.categories.map(
                        (c) => DropdownMenuItem(
                          value: c,
                          child: Text(
                            c.name,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                    ],

                    // ✅ FIXED (no setState here)
                    onChanged: widget.onCategoryChanged,
                  ),
                ),
              ],
            ),

            SizedBox(height: ConstantUtil.verticalSpacing / 2),

            Divider(thickness: 1.5, color: AppColors.secondaryColor),

            /// 🧱 PRODUCT GRID
            Expanded(
              child: widget.allProducts.isEmpty
                  ? const Center(child: Text('No products available'))
                  : GridView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: isDesktop ? 4 : 3,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 1.30,
                      ),
                      itemCount: widget.selectedCategory == null
                          ? widget.allProducts.length
                          : widget.allProducts
                                .where(
                                  (p) =>
                                      p.categoryId ==
                                      widget.selectedCategory!.id,
                                )
                                .length,
                      itemBuilder: (context, index) {
                        final list = widget.selectedCategory == null
                            ? widget.allProducts
                            : widget.allProducts
                                  .where(
                                    (p) =>
                                        p.categoryId ==
                                        widget.selectedCategory!.id,
                                  )
                                  .toList();

                        final p = list[index];
                        final outOfStock = p.stockQuantity <= 0;

                        return GestureDetector(
                          onTap: outOfStock
                              ? null
                              : () {
                                  FocusScope.of(context).unfocus();
                                  widget.onAddToCart(p);
                                }, // ✅ FIXED
                          child:RepaintBoundary(
                            child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: outOfStock
                                  ? Colors.grey.withOpacity(0.1)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: outOfStock
                                    ? Colors.grey.withOpacity(0.2)
                                    : AppColors.primaryColor.withOpacity(0.3),
                              ),
                            ),
                            child: isDesktop
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      isDesktop
                                          ? Icon(
                                              Icons.inventory_2_outlined,
                                              color: outOfStock
                                                  ? Colors.grey
                                                  : AppColors.primaryColor,
                                            )
                                          : SizedBox(),
                                      SizedBox(height: isDesktop ? 8 : 0),
                                      Text(
                                        p.name,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${ConstantUtil.currencySymbol} ${p.sellingPrice.toStringAsFixed(2)}',
                                      ),
                                    ],
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.inventory_2_outlined,
                                        color: outOfStock
                                            ? Colors.grey
                                            : AppColors.primaryColor,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        p.name,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${ConstantUtil.currencySymbol} ${p.sellingPrice.toStringAsFixed(2)}',
                                      ),
                                    ],
                                  ),
                          )),
                        );
                      },
                    ),
            ),

            Divider(thickness: 1.5, color: AppColors.secondaryColor),
          ],
        ),
      ),
    );
  }
}
