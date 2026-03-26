import 'package:isar/isar.dart';

part 'pos_user.g.dart';

enum UserRole { admin, manager, cashier }

@collection
class PosUser {
  Id id = Isar.autoIncrement;

  late String name;
  late String email;
  late String passwordHash;

  @Enumerated(EnumType.name)
  late UserRole role;

  bool isActive = true;        // ← defaults to true when created
  late DateTime createdAt;
  late DateTime updatedAt;
}