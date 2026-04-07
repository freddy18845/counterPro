import "dart:async";
import "package:eswaini_destop_app/ux/models/screens/home/flow_item.dart";
import "package:flutter/material.dart";
import "package:isar/isar.dart";
import "../../../platform/utils/constant.dart";
import "../../../platform/utils/isar_manager.dart";
import "../../models/shared/category.dart";
import "../../models/shared/product.dart";
import "../../utils/shared/tax_manager.dart";
import "../components/screens/sales/left_side.dart";
import "../components/screens/sales/right_side.dart";
import "../components/shared/ui_template.dart";

// cart item model
class _CartItem {
  final Product product;
  int quantity;
  double discount;

  _CartItem({required this.product, this.quantity = 1, this.discount = 0});

  double get total => (product.sellingPrice - discount) * quantity;
}

class SalesScreen extends StatefulWidget {
  final HomeFlowItem selectedTransaction;


  const SalesScreen({
    super.key,
    required this.selectedTransaction,

  });

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  final TextEditingController _searchController = TextEditingController();
  final isar = IsarService.db; // ← fixed

  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  List<Category> _categories = [];
  Category? _selectedCategory;
    List<_CartItem> _cart = [];
  bool _showSuggestions = false;
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.requestFocus();
    });
    _loadData();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    focusNode.dispose();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final products = await isar.products
        .where()
        .filter()
        .isActiveEqualTo(true)
        .findAll();
    final categories = await isar.categorys.where().findAll();
    setState(() {
      _allProducts = products;
      _filteredProducts = products;
      _categories = categories;
    });
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _showSuggestions = query.isNotEmpty;
      _filteredProducts = _allProducts.where((p) {
        final matchesSearch =
            query.isEmpty ||
            p.name.toLowerCase().contains(query) ||
            p.sku.toLowerCase().contains(query) ||
            (p.barcodeId?.toLowerCase().contains(query) ?? false);
        final matchesCategory =
            _selectedCategory == null || p.categoryId == _selectedCategory!.id;
        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  void _addToCart(Product product) {
    setState(() {
      final existing = _cart.indexWhere((c) => c.product.id == product.id);
      if (existing >= 0) {
        _cart[existing].quantity++;
      } else {
        _cart.add(_CartItem(product: product));
      }
      _searchController.clear();
      _showSuggestions = false;
    });
  }

  void _removeFromCart(int index) {
    setState(() => _cart.removeAt(index));
  }

  void _updateQuantity(int index, int qty) {
    if (qty <= 0) {
      _removeFromCart(index);
      return;
    }
    setState(() => _cart[index].quantity = qty);
  }

  void _clearCart() => setState(() => _cart.clear());

  double get _subtotal => _cart.fold(0, (sum, item) => sum + item.total);


  double get _grandTotal => _subtotal + _tax;



  double get _tax {
    // ← TaxManager handles enabled/disabled and rate
    return TaxManager().calculateTax(_subtotal);
  }

  double get _total {
    return TaxManager().calculateTotal(_subtotal);
  }

  @override
  Widget build(BuildContext context) {
    return BaseTemplate(
      contentSection:
     Row(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
         // ── Left: Product Search + Grid ───────────────
         SalesLeftSection(
           title: widget.selectedTransaction.text,

           allProducts: _filteredProducts.isNotEmpty?_filteredProducts:_allProducts,
           categories: _categories,
           selectedCategory: _selectedCategory,
           searchController: _searchController,
           showSuggestions: _showSuggestions,

           onAddToCart: _addToCart,

           onCategoryChanged: (val) {
             setState(() {
               _selectedCategory = val;
             });
             _onSearchChanged();
           },
           focusNode: focusNode,
         ),

         SizedBox(width: ConstantUtil.horizontalSpacing),

         // ── Right: Cart / Receipt ─────────────────────
         SalesCartSection(
           focusNode:focusNode ,
           cart: _cart,
           subtotal: _subtotal,
           tax: _tax,
           total: _grandTotal,
           onRemove: _removeFromCart,
           onUpdateQty: _updateQuantity, onClear: () {
           setState(() {
             _cart = [];
           });
         },
         ),
       ],
     ),
    );
  }
}




