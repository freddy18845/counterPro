import "dart:async";
import "package:eswaini_destop_app/ux/models/screens/home/flow_item.dart";
import "package:flutter/material.dart";
import "package:isar/isar.dart";
import "../../../platform/utils/constant.dart";
import "../../../platform/utils/isar_manager.dart";
import "../../models/shared/category.dart";
import "../../models/shared/product.dart";
import "../../res/app_colors.dart";
import "../../utils/sessionManager.dart";
import "../../utils/shared/app.dart";
import "../../utils/shared/screen.dart";
import "../components/dialogs/add_category.dart";
import "../components/dialogs/add_product_category.dart";
import "../components/screens/inventory/table.dart";
import "../components/shared/btn.dart";
import "../components/shared/card_widget.dart"; // Add this import
import "../components/shared/inline_text.dart";
import "../components/shared/login_input.dart";
import "../components/shared/pagination.dart";
import "../components/shared/ui_template.dart";
import "../fragements/inventory/category_dropdown.dart";
import "../fragements/inventory/filter_dropdown_low_stock.dart";

enum InventoryView { products, categories }
enum StockFilter { all, lowStock, outOfStock, inStock }

class InventoryScreen extends StatefulWidget {
  final Function(StockFilter)? isLowStock;
  final HomeFlowItem selectedTransaction;

  const InventoryScreen({
    super.key,
    required this.selectedTransaction,
    this.isLowStock,
  });

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  final isar = IsarService.db;
  final FocusNode focusNode = FocusNode();

  InventoryView _activeView = InventoryView.products;
  Category? _selectedCategory;
  List<Category> _categories = [];
  bool isLoading = false;

  // Add stock filter
  StockFilter _stockFilter = StockFilter.all;

  int _currentPage = 1;
  final int _pageSize = 10;
  int _totalItems = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.requestFocus();

      if(widget.isLowStock!=null){
        setState(() {
          _stockFilter = StockFilter.lowStock;
          _currentPage = 1;
        });
      }
    });
    _loadCategories();
    _searchController.addListener(() {
      setState(() => _currentPage = 1);
    });
  }

  @override
  void dispose() {
    focusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCategories() async {
    setState(() => isLoading = true);
    final cats = await isar.categorys.where().findAll();
    setState(() {
      _categories = cats;
      isLoading = false;
    });
  }

  List<Product> _filterProducts(List<Product> all) {
    final query = _searchController.text.toLowerCase();
    return all.where((p) {
      // Search filter
      final matchesSearch = query.isEmpty ||
          p.name.toLowerCase().contains(query) ||
          p.categoryName.toLowerCase().contains(query);

      // Category filter
      final matchesCategory = _selectedCategory == null ||
          p.categoryId == _selectedCategory!.id;

      // Stock filter
      bool matchesStockFilter = true;
      switch (_stockFilter) {
        case StockFilter.lowStock:
          matchesStockFilter = p.stockQuantity > 0 &&
              p.stockQuantity <= p.lowStockThreshold;
          break;
        case StockFilter.outOfStock:
          matchesStockFilter = p.stockQuantity <= 0;
          break;
        case StockFilter.inStock:
          matchesStockFilter = p.stockQuantity > p.lowStockThreshold;
          break;
        case StockFilter.all:
          matchesStockFilter = true;
          break;
      }

      return matchesSearch && matchesCategory && matchesStockFilter;
    }).toList();
  }

  int _totalPages() => (_totalItems / _pageSize).ceil().clamp(1, 999);

  void _onTotalChanged(int total) {
    if (_totalItems != total) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _totalItems = total;
          _currentPage = 1;
        });
      });
    }
  }

  // Get counts for different stock statuses


  @override
  Widget build(BuildContext context) {
    return BaseTemplate(
      contentSection: CustomCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: ConstantUtil.verticalSpacing / 2),
            InlineText(
              title: widget.selectedTransaction.text.toUpperCase(),
            ),

            // ── Header row ────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // radio toggle
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 4, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: InventoryView.values.map((view) {
                      final isActive = _activeView == view;
                      final label = view == InventoryView.products
                          ? 'Products'
                          : 'Categories';
                      return GestureDetector(
                        onTap: () => setState(() {
                          _activeView = view;
                          _currentPage = 1;
                          if (view == InventoryView.products) {
                            _selectedCategory = null;
                          }
                        }),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 8),
                          decoration: BoxDecoration(
                            color: isActive
                                ? AppColors.primaryColor
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: isActive
                                ? [
                              BoxShadow(
                                color: AppColors.primaryColor
                                    .withValues(alpha: 0.3),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ]
                                : [],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AnimatedContainer(
                                duration:
                                const Duration(milliseconds: 250),
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isActive
                                        ? AppColors.secondaryColor
                                        : Colors.grey,
                                    width: 2,
                                  ),
                                ),
                                child: isActive
                                    ? Center(
                                  child: Container(
                                    width: 7,
                                    height: 7,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:
                                      AppColors.secondaryColor,
                                    ),
                                  ),
                                )
                                    : null,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                label,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: isActive
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: isActive
                                      ? Colors.white
                                      : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                // add button
                !SessionManager().isCashier?SizedBox(
                  width: (ScreenUtil.width * 0.06).clamp(130, 180),
                  child: Btn(
                    onTap: () async {
                      focusNode.unfocus();
                      if (_activeView == InventoryView.products) {
                        final result = await AppUtil.displayDialog(
                          context: context,
                          dismissible: false,
                          child: const AddEditProductDialog(),
                        );
                        if (result == true) setState(() {});
                      } else {
                        final result = await AppUtil.displayDialog(
                          context: context,
                          dismissible: false,
                          child: const AddEditCategoryDialog(),
                        );
                        if (result == true) _loadCategories();
                      }
                      focusNode.requestFocus();
                    },
                    text: _activeView == InventoryView.products
                        ? 'Add Product'
                        : 'Add Category',
                  ),
                ):SizedBox(),
              ],
            ),

            SizedBox(
              width: double.infinity,
              child: Divider(
                  thickness: 2, color: AppColors.secondaryColor),
            ),
            SizedBox(height: ConstantUtil.verticalSpacing / 2),

            // ── Filter row ────────────────────────────────
            Row(
              children: [
                SizedBox(
                    width: (ScreenUtil.width * 0.25).clamp(180, 350),
                    child: Focus(
                      onKeyEvent: (node, event) => KeyEventResult.ignored,
                      child: ConfigField(
                        focusNode: focusNode,
                        controller: _searchController,
                        hintText: 'Search Product or Category ...',
                        enabled: _activeView == InventoryView.products,
                        keyboardType: TextInputType.text,
                      ),
                    )),
                const SizedBox(width: 12),

                // Stock Filter Dropdown
                if (_activeView == InventoryView.products)
                  StockFilterDropdown(
                    currentFilter: _stockFilter,
                    onFilterChanged: (newFilter) {
                      setState(() {
                        _stockFilter = newFilter;
                        _currentPage = 1;
                      });
                    },
                  ),

                const Spacer(),

                // Category Filter Dropdown
                if (_activeView == InventoryView.products)
                  CategoryFilterDropdown(
                    selectedCategory: _selectedCategory,
                    categories: _categories,
                    isLoading: isLoading,
                    onCategoryChanged: (category) {
                      setState(() {
                        _selectedCategory = category;
                        _currentPage = 1;
                      });
                    },
                  ),
              ],
            ),

            SizedBox(height: ConstantUtil.verticalSpacing / 2),

            // ── Table ─────────────────────────────────────
            InventoryTable(
              isar: isar,
              activeView: _activeView,
              categories: _categories,
              isLoading: isLoading,
              currentPage: _currentPage,
              filterProducts: _filterProducts,
              onTotalChanged: (int index) {
                _onTotalChanged(index);
              },
              searchController: _searchController,
              onloadData: () {_loadCategories();},
              stockFilter: _stockFilter,
              selectedCategory: _selectedCategory,
            ),

            // ── Divider ───────────────────────────────────
            SizedBox(
              width: double.infinity,
              child: Divider(
                  thickness: 1.5, color: AppColors.secondaryColor),
            ),

            // ── Pagination ────────────────────────────────
            Pagination(
              currentPage: _currentPage,
              totalPages: _totalPages(),
              totalItems: _totalItems,
              pageSize: _pageSize,
              onPageChanged: (page) =>
                  setState(() => _currentPage = page),
            ),

            SizedBox(height: ConstantUtil.verticalSpacing / 2),
          ],
        ),
      ),
    );
  }
}