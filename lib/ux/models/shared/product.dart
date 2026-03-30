import 'package:isar/isar.dart';
part 'product.g.dart';

@collection
class Product {
  Id id = Isar.autoIncrement;

  late String name;
  late String sku;
  String? barcodeId;
  late int categoryId;       // ✅ int ref, not Category object
  late String categoryName;  // ✅ denormalized name
  late double costPrice;
  late double sellingPrice;
  late int stockQuantity;
  late int lowStockThreshold;
  String? imageUrl;
  late bool isActive;
  late DateTime createdAt;
  late DateTime updatedAt;
}