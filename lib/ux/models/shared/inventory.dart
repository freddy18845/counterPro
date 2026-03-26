import 'package:isar/isar.dart';
part 'inventory.g.dart'; // ← correct

enum InventoryAction { stockIn, stockOut, adjustment, saleDeduction }

@collection
class InventoryLog {
  Id id = Isar.autoIncrement;

  late int productId;
  late String productName;

  @Enumerated(EnumType.name)
  late InventoryAction action;

  late int quantityChanged;
  late int quantityBefore;
  late int quantityAfter;

  String? note;
  late int performedByUserId;
  late DateTime timestamp;
}