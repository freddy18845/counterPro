import 'package:isar/isar.dart';

part 'company.g.dart';

@collection
class Company {
  Id id = Isar.autoIncrement;

  late String name;
  String? slogan;
 late String companyId;

  late String email;
  late String contactOne;
  late String contactTwo;
  late String address;

  String? logoPath;

  // 🆕 Subscription
  late DateTime subscriptionStartDate;
  DateTime? subscriptionEndDate; // optional (for expiry)

  // timestamps
  late DateTime createdAt;
  late DateTime updatedAt;
}