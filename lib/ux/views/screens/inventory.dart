import "dart:async";
import "package:eswaini_destop_app/ux/models/screens/home/flow_item.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:isar/isar.dart";
import "../../../platform/utils/constant.dart";
import "../../../platform/utils/isar_manager.dart";
import "../../blocs/screens/withdrawal/bloc.dart";
import "../../enums/screens/payment/flow_step.dart";
import "../../models/shared/category.dart";
import "../../models/shared/product.dart";
import "../../res/app_colors.dart";
import "../../utils/sessionManager.dart";
import "../../utils/shared/app.dart";
import "../../utils/shared/screen.dart";
import "../components/dialogs/add_category.dart";
import "../components/dialogs/add_product_category.dart";
import "../components/screens/inventory/category_table.dart";
import "../components/screens/inventory/product_table.dart";
import "../components/screens/inventory/table.dart";
import "../components/shared/btn.dart";
import "../components/shared/card_widget.dart";
import "../components/shared/inline_text.dart";
import "../components/shared/login_input.dart";
import "../components/shared/pagination.dart";
import "../components/shared/ui_template.dart";

enum InventoryView { products, categories }

class InventoryScreen extends StatefulWidget {
  final HomeFlowItem selectedTransaction;
  final StreamController<Map> refreshController;

  const InventoryScreen({
    super.key,
    required this.selectedTransaction,
    required this.refreshController,
  });

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  late WithdrawalBloc withdrawalBloc;
  final TextEditingController _searchController = TextEditingController();
  final isar = IsarService.db;

  InventoryView _activeView = InventoryView.products;
  Category? _selectedCategory;
  List<Category> _categories = [];
  bool isLoading = false;

  int _currentPage = 1;
  final int _pageSize = 10;
  int _totalItems = 0;

  @override
  void initState() {
    super.initState();
    withdrawalBloc = context.read<WithdrawalBloc>();
    withdrawalBloc.init(
      context: context,
      data: widget.selectedTransaction,
      refreshController: widget.refreshController,
    );
    _loadCategories();
    _searchController.addListener(() {
      setState(() => _currentPage = 1);
    });
  }

  @override
  void dispose() {
    try {
      withdrawalBloc.dispose();
    } catch (_) {}
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
      final matchesSearch = query.isEmpty ||
          p.name.toLowerCase().contains(query) ||
          p.sku.toLowerCase().contains(query);
      final matchesCategory = _selectedCategory == null ||
          p.categoryId == _selectedCategory!.id;
      return matchesSearch && matchesCategory;
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

  @override
  Widget build(BuildContext context) {
    return BaseTemplate(
      contentSection: BlocBuilder<WithdrawalBloc, WithdrawalState>(
        builder: (context, WithdrawalState state) {
          if (state is! WithdrawalEnterAmountState) return const SizedBox();
          withdrawalBloc.activeStep = GeneralTransactionFlowStep.enterAmount;

          return CustomCard(
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
                      child: ConfigField(
                        controller: _searchController,
                        hintText: 'Search product or SKU...',
                        enabled: _activeView == InventoryView.products,
                        keyboardType: TextInputType.text,
                      ),
                    ),
                    const Spacer(),
                    if (_activeView == InventoryView.products)
                      SizedBox(
                        width: (ScreenUtil.width * 0.15).clamp(140, 220),
                        child: DropdownButtonFormField<Category?>(
                          value: _selectedCategory,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            isDense: true,
                          ),
                          hint: const Text(
                            'All Categories',
                            style: TextStyle(fontSize: 13),
                          ),
                          items: [
                            const DropdownMenuItem(
                              value: null,
                              child: Text(
                                'All Categories',
                                style: TextStyle(fontSize: 13),
                              ),
                            ),
                            ..._categories.map(
                                  (c) => DropdownMenuItem(
                                value: c,
                                child: Text(
                                  c.name,
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ),
                            ),
                          ],
                          onChanged: (val) => setState(() {
                            _selectedCategory = val;
                            _currentPage = 1;
                          }),
                        ),
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
                  }, searchController:_searchController, onloadData: () {_loadCategories();  },),

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
          );
        },
      ),
    );
  }
}