import 'package:eswaini_destop_app/platform/utils/isar_manager.dart';
import 'package:eswaini_destop_app/ux/models/shared/company.dart';
import 'package:eswaini_destop_app/ux/models/shared/pos_user.dart';
import 'package:eswaini_destop_app/ux/models/shared/product.dart';
import 'package:isar/isar.dart';

class SubscriptionManager {
  // ── Singleton ─────────────────────────────────────────────
  static final SubscriptionManager _instance =
  SubscriptionManager._internal();
  factory SubscriptionManager() => _instance;
  SubscriptionManager._internal();

  Company? _company;

  // ── Getters ───────────────────────────────────────────────
  Company? get company => _company;

  SubscriptionPlan get plan =>
      _company?.subscriptionPlan ?? SubscriptionPlan.basic;

  SubscriptionStatus get status =>
      _company?.subscriptionStatus ?? SubscriptionStatus.expired;

  bool get isActive => _company?.isSubscriptionActive ?? false;
  bool get isExpired => _company?.isSubscriptionExpired ?? false;
  bool get isExpiringSoon => _company?.isExpiringSoon ?? false;

  DateTime? get endDate => _company?.subscriptionEndDate;
  DateTime? get startDate => _company?.subscriptionStartDate;
  int get daysLeft => _company?.daysUntilExpiry ?? 0;

  // ── Plan limits ───────────────────────────────────────────
  int get maxUsers {
    switch (plan) {
      case SubscriptionPlan.basic:
        return 1;
      case SubscriptionPlan.pro:
        return 5;
      case SubscriptionPlan.enterprise:
        return 999999; // unlimited
    }
  }

  int get maxProducts {
    switch (plan) {
      case SubscriptionPlan.basic:
        return 70;
      case SubscriptionPlan.pro:
        return 999999; // unlimited
      case SubscriptionPlan.enterprise:
        return 999999; // unlimited
    }
  }

  bool get canExport {
    return plan == SubscriptionPlan.pro ||
        plan == SubscriptionPlan.enterprise;
  }

  bool get hasApiAccess {
    return plan == SubscriptionPlan.enterprise;
  }

  bool get hasAdvancedReports {
    return plan == SubscriptionPlan.pro ||
        plan == SubscriptionPlan.enterprise;
  }

  bool get hasMultiBranch {
    return plan == SubscriptionPlan.enterprise;
  }

  // ── Check if can add more users ───────────────────────────
  Future<bool> canAddUser() async {
    final isar = IsarService.db;
    final count = await isar.posUsers.where().count();
    return count < maxUsers;
  }

  // ── Check if can add more products ────────────────────────
  Future<bool> canAddProduct() async {
    final isar = IsarService.db;
    final count = await isar.products.where().count();
    return count < maxProducts;
  }

  // ── Load from Isar ────────────────────────────────────────
  Future<void> load() async {
    final isar = IsarService.db;
    _company = await isar.companys.where().findFirst();
  }

  // ── Refresh ───────────────────────────────────────────────
  Future<void> refresh() async {
    await load();
  }

  // ── Update subscription from server response ──────────────
  Future<void> updateFromServer({
    required SubscriptionPlan plan,
    required SubscriptionStatus status,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final isar = IsarService.db;
    final company = await isar.companys.where().findFirst();
    if (company == null) return;

    await isar.writeTxn(() async {
      company
        ..subscriptionPlan = plan
        ..subscriptionStatus = status
        ..subscriptionStartDate = startDate
        ..subscriptionEndDate = endDate
        ..updatedAt = DateTime.now();
      await isar.companys.put(company);
    });

    _company = company;
  }

  // ── Plan display helpers ──────────────────────────────────
  String get planName {
    switch (plan) {
      case SubscriptionPlan.basic:
        return 'Basic';
      case SubscriptionPlan.pro:
        return 'Pro';
      case SubscriptionPlan.enterprise:
        return 'Enterprise';
    }
  }

  String get planPrice {
    switch (plan) {
      case SubscriptionPlan.basic:
        return '\$9.99/mo';
      case SubscriptionPlan.pro:
        return '\$24.99/mo';
      case SubscriptionPlan.enterprise:
        return '\$59.99/mo';
    }
  }

  String get statusLabel {
    if (isExpired) return 'Expired';
    if (isExpiringSoon) return 'Expiring Soon';
    switch (status) {
      case SubscriptionStatus.active:
        return 'Active';
      case SubscriptionStatus.trial:
        return 'Trial';
      case SubscriptionStatus.cancelled:
        return 'Cancelled';
      case SubscriptionStatus.expired:
        return 'Expired';
    }
  }

  // ── Clear on logout ───────────────────────────────────────
  void clear() {
    _company = null;
  }
}