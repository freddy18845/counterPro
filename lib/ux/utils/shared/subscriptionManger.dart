// import 'package:eswaini_destop_app/platform/utils/isar_manager.dart';
// import 'package:eswaini_destop_app/ux/models/shared/company.dart';
// import 'package:eswaini_destop_app/ux/models/shared/pos_user.dart';
// import 'package:eswaini_destop_app/ux/models/shared/product.dart';
// import 'package:isar/isar.dart';
//
// class SubscriptionManager {
//   // ── Singleton ─────────────────────────────────────────────
//   static final SubscriptionManager _instance =
//   SubscriptionManager._internal();
//   factory SubscriptionManager() => _instance;
//   SubscriptionManager._internal();
//
//   Company? _company;
//
//   // ── Getters ───────────────────────────────────────────────
//   Company? get company => _company;
//
//   SubscriptionPlan get plan =>
//       _company?.subscriptionPlan ?? SubscriptionPlan.basic;
//
//   SubscriptionStatus get status =>
//       _company?.subscriptionStatus ?? SubscriptionStatus.expired;
//
//   bool get isActive => _company?.isSubscriptionActive ?? false;
//   bool get isExpired => _company?.isSubscriptionExpired ?? false;
//   bool get isExpiringSoon => _company?.isExpiringSoon ?? false;
//
//   DateTime? get endDate => _company?.subscriptionEndDate;
//   DateTime? get startDate => _company?.subscriptionStartDate;
//   int get daysLeft => _company?.daysUntilExpiry ?? 0;
//
//   // ── Plan limits ───────────────────────────────────────────
//   int get maxUsers {
//     switch (plan) {
//       case SubscriptionPlan.basic:
//         return 1;
//       case SubscriptionPlan.pro:
//         return 5;
//       case SubscriptionPlan.enterprise:
//         return 999999; // unlimited
//     }
//   }
//
//   int get maxProducts {
//     switch (plan) {
//       case SubscriptionPlan.basic:
//         return 70;
//       case SubscriptionPlan.pro:
//         return 999999; // unlimited
//       case SubscriptionPlan.enterprise:
//         return 999999; // unlimited
//     }
//   }
//
//   bool get canExport {
//     return plan == SubscriptionPlan.pro ||
//         plan == SubscriptionPlan.enterprise;
//   }
//
//   bool get hasApiAccess {
//     return plan == SubscriptionPlan.enterprise;
//   }
//
//   bool get hasAdvancedReports {
//     return plan == SubscriptionPlan.pro ||
//         plan == SubscriptionPlan.enterprise;
//   }
//
//   bool get hasMultiBranch {
//     return plan == SubscriptionPlan.enterprise;
//   }
//
//   // ── Check if can add more users ───────────────────────────
//   Future<bool> canAddUser() async {
//     final isar = IsarService.db;
//     final count = await isar.posUsers.where().count();
//     return count < maxUsers;
//   }
//
//   // ── Check if can add more products ────────────────────────
//   Future<bool> canAddProduct() async {
//     final isar = IsarService.db;
//     final count = await isar.products.where().count();
//     return count < maxProducts;
//   }
//
//   // ── Load from Isar ────────────────────────────────────────
//   Future<void> load() async {
//     final isar = IsarService.db;
//     _company = await isar.companys.where().findFirst();
//   }
//
//   // ── Refresh ───────────────────────────────────────────────
//   Future<void> refresh() async {
//     await load();
//   }
//
//   // ── Update subscription from server response ──────────────
//   Future<void> updateFromServer({
//     required SubscriptionPlan plan,
//     required SubscriptionStatus status,
//     required DateTime startDate,
//     required DateTime endDate,
//   }) async {
//     final isar = IsarService.db;
//     final company = await isar.companys.where().findFirst();
//     if (company == null) return;
//
//     await isar.writeTxn(() async {
//       company
//         ..subscriptionPlan = plan
//         ..subscriptionStatus = status
//         ..subscriptionStartDate = startDate
//         ..subscriptionEndDate = endDate
//         ..updatedAt = DateTime.now();
//       await isar.companys.put(company);
//     });
//
//     _company = company;
//   }
//
//   // ── Plan display helpers ──────────────────────────────────
//   String get planName {
//     switch (plan) {
//       case SubscriptionPlan.basic:
//         return 'Basic';
//       case SubscriptionPlan.pro:
//         return 'Pro';
//       case SubscriptionPlan.enterprise:
//         return 'Enterprise';
//     }
//   }
//
//
//
//   String get statusLabel {
//     if (isExpired) return 'Expired';
//     if (isExpiringSoon) return 'Expiring Soon';
//     switch (status) {
//       case SubscriptionStatus.active:
//         return 'Active';
//       case SubscriptionStatus.trial:
//         return 'Trial';
//       case SubscriptionStatus.cancelled:
//         return 'Cancelled';
//       case SubscriptionStatus.expired:
//         return 'Expired';
//     }
//   }
//
//   // ── Clear on logout ───────────────────────────────────────
//   void clear() {
//     _company = null;
//   }
//
//   // ── Check subscription status ─────────────────────────────────
//   static Future<SubscriptionCheckResult> checkSubscription() async {
//     final isar = IsarService.db;
//     final company = await isar.companys.where().findFirst();
//
//     // no company record at all
//     if (company == null) {
//       return SubscriptionCheckResult(
//         status:  SubscriptionCheckStatus.noCompany,
//         message: 'No company found.',
//         daysLeft: 0,
//       );
//     }
//
//     // no end date set — treat as unlimited (self-hosted)
//     if (company.subscriptionEndDate == null) {
//       return SubscriptionCheckResult(
//         status:   SubscriptionCheckStatus.active,
//         message:  'Subscription is active.',
//         daysLeft: 999,
//         company:  company,
//       );
//     }
//
//     final now      = DateTime.now();
//     final endDate  = company.subscriptionEndDate!;
//     final daysLeft = endDate.difference(now).inDays;
//
//     // already expired
//     if (endDate.isBefore(now)) {
//       return SubscriptionCheckResult(
//         status:   SubscriptionCheckStatus.expired,
//         message:  'Your subscription expired on '
//             '${_formatDate(endDate)}. '
//             'Please renew to continue using CounterPro.',
//         daysLeft: 0,
//         company:  company,
//       );
//     }
//
//     // expiring within 3 days — critical warning
//     if (daysLeft <= 3) {
//       return SubscriptionCheckResult(
//         status:   SubscriptionCheckStatus.criticallyClose,
//         message:  'Your subscription expires in $daysLeft '
//             '${daysLeft == 1 ? 'day' : 'days'}! '
//             'Renew now to avoid losing access.',
//         daysLeft: daysLeft,
//         company:  company,
//       );
//     }
//
//     // expiring within 7 days — warning
//     if (daysLeft <= 7) {
//       return SubscriptionCheckResult(
//         status:   SubscriptionCheckStatus.expiringSoon,
//         message:  'Your subscription expires in $daysLeft days '
//             '(${_formatDate(endDate)}). '
//             'Consider renewing soon.',
//         daysLeft: daysLeft,
//         company:  company,
//       );
//     }
//
//     // active and healthy
//     return SubscriptionCheckResult(
//       status:   SubscriptionCheckStatus.active,
//       message:  'Subscription active until ${_formatDate(endDate)}.',
//       daysLeft: daysLeft,
//       company:  company,
//     );
//   }
//
//   // ── Quick boolean checks ──────────────────────────────────────
//   static Future<bool> isSubscriptionExpired() async {
//     final result = await checkSubscription();
//     return result.status == SubscriptionCheckStatus.expired;
//   }
//
//   static Future<bool> isSubscriptionExpiringSoon() async {
//     final result = await checkSubscription();
//     return result.status == SubscriptionCheckStatus.expiringSoon ||
//         result.status == SubscriptionCheckStatus.criticallyClose;
//   }
//
//   static Future<bool> isSubscriptionActive() async {
//     final result = await checkSubscription();
//     return result.status == SubscriptionCheckStatus.active ||
//         result.status == SubscriptionCheckStatus.expiringSoon ||
//         result.status == SubscriptionCheckStatus.criticallyClose;
//   }
//
//   // ── Date format helper ────────────────────────────────────────
//   static String _formatDate(DateTime date) {
//     final months = [
//       'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
//       'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
//     ];
//     return '${date.day} ${months[date.month - 1]} ${date.year}';
//   }
// }
//
// enum SubscriptionCheckStatus {
//   active,           // healthy — more than 7 days left
//   expiringSoon,     // 4–7 days left
//   criticallyClose,  // 1–3 days left
//   expired,          // past end date
//   noCompany,        // no company in database
// }
//
// class SubscriptionCheckResult {
//   final SubscriptionCheckStatus status;
//   final String message;
//   final int daysLeft;
//   final Company? company;
//
//   const SubscriptionCheckResult({
//     required this.status,
//     required this.message,
//     required this.daysLeft,
//     this.company,
//   });
//
//   bool get isExpired => status == SubscriptionCheckStatus.expired;
//   bool get isActive  => status == SubscriptionCheckStatus.active;
//
//   bool get needsWarning =>
//       status == SubscriptionCheckStatus.expiringSoon ||
//           status == SubscriptionCheckStatus.criticallyClose;
//
//   bool get isCritical =>
//       status == SubscriptionCheckStatus.criticallyClose ||
//           status == SubscriptionCheckStatus.expired;
// }