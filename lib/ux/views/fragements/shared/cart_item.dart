import '../../../models/shared/sale_order.dart';

class CartItemFromOrder {
  final SaleItem item;
  CartItemFromOrder({required this.item});

  dynamic get product => ProductProxy(item);
  int get quantity => item.quantity;
  double get total => item.totalPrice;
}

class ProductProxy {
  final SaleItem item;
  ProductProxy(this.item);
  int get id => item.productId;
  String get name => item.productName;
  String get sku => item.productSku;
  String? get barcodeId => item.barcodeId;
  double get sellingPrice => item.unitPrice;
  double get costPrice => item.costPrice;
}