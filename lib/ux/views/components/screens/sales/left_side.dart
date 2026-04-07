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

  // Local filtered list based on search + category
  List<Product> get _displayedProducts {
    final query = widget.searchController.text.trim().toLowerCase();
    final categoryId = widget.selectedCategory?.id;

    return widget.allProducts.where((p) {
      final matchesCategory = categoryId == null || p.categoryId == categoryId;
      if (query.isEmpty) return matchesCategory;

      return matchesCategory &&
          ((p.name.toLowerCase().contains(query)) ||
              (p.sku?.toLowerCase().contains(query) ?? false) ||
              (p.barcodeId?.trim().toLowerCase() == query));
    }).toList();
  }

  void handleScan(String scannedValue) {
    if (scannedValue.trim().isEmpty) return;

    final cleanValue = scannedValue.trim().toLowerCase();
    Product? foundProduct;

    for (final p in widget.allProducts) {
      if ((p.barcodeId?.trim().toLowerCase() == cleanValue) ||
          (p.sku?.trim().toLowerCase() == cleanValue) ||
          p.name.trim().toLowerCase() == cleanValue) {
        foundProduct = p;
        break;
      }
    }

    if (foundProduct != null) {
      widget.onAddToCart(foundProduct);
      AppUtil.toastMessage(message: '✅ Product Added!', context: context);
    } else {
      AppUtil.toastMessage(
        message: '❌ No product found for "$scannedValue"',
        context: context,
        backgroundColor: Colors.orange,
      );
    }

    widget.searchController.clear();
    widget.focusNode.requestFocus();
  }

  @override
  void dispose() {
    // Do NOT dispose focusNode here if it's passed from parent
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final displayed = _displayedProducts;

    return Expanded(
      flex: 3,
      child: CustomCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: ConstantUtil.verticalSpacing / 4),
            InlineText(title: widget.title.toUpperCase()),
            SizedBox(height: ConstantUtil.verticalSpacing / 4),

            /// 🔍 SEARCH + CATEGORY
            Row(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Focus(
                        onKeyEvent: (_, __) => KeyEventResult.ignored,
                        child: ConfigField(
                          controller: widget.searchController,
                          hintText: 'Search by name, SKU or scan barcode...',
                          enabled: true,
                          focusNode: widget.focusNode,
                          keyboardType: TextInputType.text,
                          onSubmitted: handleScan,
                          onChanged: (_) => setState(() {}),
                        ),
                      ),

                      /// 🔽 Live Suggestions
                      if (widget.showSuggestions &&
                          widget.searchController.text.trim().isNotEmpty &&
                          displayed.isNotEmpty)
                        Positioned(
                          top: 52,
                          left: 0,
                          right: 0,
                          child: Material(
                            elevation: 8,
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              constraints: const BoxConstraints(maxHeight: 240),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey.withOpacity(0.2)),
                              ),
                              child: ListView.separated(
                                shrinkWrap: true,
                                itemCount: displayed.length > 8 ? 8 : displayed.length,
                                separatorBuilder: (_, __) => Divider(height: 1),
                                itemBuilder: (context, index) {
                                  final p = displayed[index];
                                  return ListTile(
                                    dense: true,
                                    title: Text(p.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                                    subtitle: Text('${p.sku} • Stock: ${p.stockQuantity}'),
                                    trailing: Text(
                                      '${ConstantUtil.currencySymbol} ${p.sellingPrice.toStringAsFixed(2)}',
                                      style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryColor),
                                    ),
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

                const SizedBox(width: 8),

                /// Category Filter
                SizedBox(
                  width: (ScreenUtil.width * 0.12).clamp(120, 200),
                  child: DropdownButtonFormField<Category?>(
                    value: widget.selectedCategory,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      isDense: true,
                    ),
                    hint: const Text('Category', style: TextStyle(fontSize: 12)),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('All')),
                      ...widget.categories.map(
                            (c) => DropdownMenuItem(value: c, child: Text(c.name)),
                      ),
                    ],
                    onChanged: widget.onCategoryChanged,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            const Divider(thickness: 1.5, color: AppColors.secondaryColor),

            /// 🧱 PRODUCT GRID (Now filtered by search + category)
            Expanded(
              child: displayed.isEmpty
                  ? const Center(
                child: Text(
                  'No products found',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
                  : GridView.builder(
                padding: const EdgeInsets.symmetric(vertical: 4),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isDesktop ? 4 : 3,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.25,
                ),
                itemCount: displayed.length,
                itemBuilder: (context, index) {
                  final p = displayed[index];
                  final outOfStock = p.stockQuantity <= 0;

                  return GestureDetector(
                    onTap: outOfStock
                        ? null
                        : () {
                      FocusScope.of(context).unfocus();
                      widget.onAddToCart(p);
                    },
                    child: RepaintBoundary(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: outOfStock ? Colors.grey.withOpacity(0.1) : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: outOfStock
                                ? Colors.grey.withOpacity(0.3)
                                : AppColors.primaryColor.withOpacity(0.3),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.inventory_2_outlined,
                              size: 32,
                              color: outOfStock ? Colors.grey : AppColors.primaryColor,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              p.name,
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${ConstantUtil.currencySymbol} ${p.sellingPrice.toStringAsFixed(2)}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const Divider(thickness: 1.5, color: AppColors.secondaryColor),
          ],
        ),
      ),
    );
  }
}