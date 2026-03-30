import 'package:isar/isar.dart';

part 'company.g.dart';

@collection
class Company {
  Id id = Isar.autoIncrement;

  late String name;
  String? slogan;
  late String email;
  late String address;
  late String contactOne;
  late String contactTwo;
  String? logoPath;
  String? companyId;

  // ← subscription fields
  @Enumerated(EnumType.name)
  SubscriptionPlan subscriptionPlan = SubscriptionPlan.basic;

  @Enumerated(EnumType.name)
  SubscriptionStatus subscriptionStatus = SubscriptionStatus.active;

  DateTime? subscriptionStartDate;
  DateTime? subscriptionEndDate;

  late DateTime createdAt;
  late DateTime updatedAt;

  // ── Computed getters ──────────────────────────────────────
  bool get isSubscriptionActive =>
      subscriptionStatus == SubscriptionStatus.active &&
          (subscriptionEndDate == null ||
              subscriptionEndDate!.isAfter(DateTime.now()));

  bool get isSubscriptionExpired =>
      subscriptionEndDate != null &&
          subscriptionEndDate!.isBefore(DateTime.now());

  int get daysUntilExpiry {
    if (subscriptionEndDate == null) return 999;
    return subscriptionEndDate!.difference(DateTime.now()).inDays;
  }

  bool get isExpiringSoon => daysUntilExpiry <= 7 && daysUntilExpiry >= 0;
}

enum SubscriptionPlan { basic, pro, enterprise }

enum SubscriptionStatus { active, expired, cancelled, trial }