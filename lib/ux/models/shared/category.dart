// models/category.dart
import 'package:isar/isar.dart';

part 'category.g.dart';

@collection
class Category {
  Id id = Isar.autoIncrement;

  late String name;
  String? description;
  String? imageUrl;
  late bool isActive;
  late DateTime createdAt;
  late DateTime updatedAt;
}