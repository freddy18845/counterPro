import 'package:isar/isar.dart';

part 'sale_order.g.dart';

enum SaleOrderStatus { saved, completed, cancelled }

@collection
class SaleOrder {
  Id id = Isar.autoIncrement;

  late String orderNumber;

  @Enumerated(EnumType.name)
  late SaleOrderStatus status;

  late List<SaleItem> items;

  late double subtotal;
  late double discountAmount;
  late double taxAmount;
  late double totalAmount;

  String? customerName;
  String? note;

  late int createdByUserId;
  late DateTime createdAt;
  DateTime? completedAt;
}

@embedded
class SaleItem {
  late int productId;
  late String productName;
  late String productSku;
  String? barcodeId;

  late double unitPrice;
  late double costPrice;
  late int quantity;
  late double discount;
  late double totalPrice;
}