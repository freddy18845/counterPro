// import 'package:eswaini_destop_app/platform/utils/constant.dart';
// import 'package:eswaini_destop_app/ux/models/shared/company.dart';
// import 'package:eswaini_destop_app/ux/views/components/screens/configSetting/section_title.dart';
// import 'package:eswaini_destop_app/ux/views/components/screens/configSetting/subscription_limit_summary.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import '../../../../res/app_colors.dart';
// import '../../../../utils/shared/subscriptionManger.dart';
// import '../../../fragements/configSetting/subscription_current_plan_card.dart';
// import '../../../fragements/configSetting/subscription_planCard.dart';
// import '../../dialogs/subscription_payment_upgrade.dart';
//
//
// class SubscriptionTab extends StatefulWidget {
//   const SubscriptionTab({super.key});
//
//   @override
//   State<SubscriptionTab> createState() => _SubscriptionTabState();
// }
//
// class _SubscriptionTabState extends State<SubscriptionTab> {
//   bool _isLoading = true;
//   late SubscriptionManager _sub;
//
//   @override
//   void initState() {
//     super.initState();
//     _load();
//   }
//
//   Future<void> _load() async {
//     _sub = SubscriptionManager();
//     await _sub.refresh();
//     setState(() => _isLoading = false);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (_isLoading) {
//       return Center(
//           child: CupertinoActivityIndicator(radius: 18, color: Colors.green));
//     }
//
//     return SingleChildScrollView(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SectionTitle(title: 'Current Plan'),
//           const SizedBox(height: 12),
//
//           // ── Current plan card ─────────────────────────
//           CurrentPlanCard(sub: _sub),
//
//           // ── Expiry warning ────────────────────────────
//           if (_sub.isExpiringSoon || _sub.isExpired) ...[
//             const SizedBox(height: 12),
//             _ExpiryWarning(sub: _sub),
//           ],
//
//           const SizedBox(height: 20),
//           SectionTitle(title: 'Available Plans'),
//           const SizedBox(height: 12),
//
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               PlanCard(
//                 name: 'Basic',
//                 price: '${ConstantUtil.currencySymbol}50.0/mo',
//                 features: const [
//                   '1 User — Admin only',
//                   'Up to 70 products',
//                   'Basic reports',
//                   'Email support',
//                 ],
//                 isActive: _sub.plan == SubscriptionPlan.basic,
//                 color: Colors.grey,
//                 onUpgrade: () => _handleUpgrade('Basic', 50.0, 'basic', context),
//               ),
//               const SizedBox(width: 12),
//               PlanCard(
//                 name: 'Pro',
//                 price: '${ConstantUtil.currencySymbol}150.0/mo',
//                 features: const [
//                   'Up to 5 Users',
//                   'Unlimited products',
//                   'Advanced reports',
//                   'Export to Excel/Word',
//                   'Priority support',
//                 ],
//                 isActive: _sub.plan == SubscriptionPlan.pro,
//                 color: AppColors.primaryColor,
//                 onUpgrade: () => _handleUpgrade('Pro', 150.0, 'pro', context),
//               ),
//               const SizedBox(width: 12),
//               PlanCard(
//                 name: 'Enterprise',
//                 price: '${ConstantUtil.currencySymbol}250.0/mo',
//                 features: const [
//                   'Unlimited Users',
//                   'Unlimited products',
//                   'Custom reports',
//                   'API access',
//                   'Dedicated support',
//                   'Multi-branch',
//                 ],
//                 isActive: _sub.plan == SubscriptionPlan.enterprise,
//                 color: Colors.purple,
//                 onUpgrade: () => _handleUpgrade('Enterprise', 250.0, 'enterprise', context),
//               ),
//             ],
//           ),
//
//           const SizedBox(height: 20),
//
//           // ── Plan limits summary ───────────────────────
//           SectionTitle(title: 'Your Current Limits'),
//           const SizedBox(height: 12),
//           LimitsSummary(sub: _sub),
//
//           const SizedBox(height: 24),
//         ],
//       ),
//     );
//   }
//
//   void _handleUpgrade(String planName, double amount, String type, BuildContext context) {
//     _showPaymentDialog(
//       context: context,
//       amount: amount,
//       type: type,
//       planName: planName,
//     );
//   }
//
//   void _showPaymentDialog({
//     required BuildContext context,
//     required double amount,
//     required String type,
//     required String planName,
//   }) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (_) => PaymentUpgradeDialog(
//         amount: amount,
//         type: type,
//         planName: planName,
//       ),
//     );
//   }
// }
//
//
//
// // ── Expiry warning banner ─────────────────────────────────────
// class _ExpiryWarning extends StatelessWidget {
//   final SubscriptionManager sub;
//   const _ExpiryWarning({required this.sub});
//
//   @override
//   Widget build(BuildContext context) {
//     final isExpired = sub.isExpired;
//     return Container(
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: isExpired
//             ? Colors.red.withValues(alpha: 0.08)
//             : Colors.orange.withValues(alpha: 0.08),
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(
//           color: isExpired
//               ? Colors.red.withValues(alpha: 0.4)
//               : Colors.orange.withValues(alpha: 0.4),
//         ),
//       ),
//       child: Row(
//         children: [
//           Icon(
//             isExpired
//                 ? Icons.cancel_outlined
//                 : Icons.warning_amber_outlined,
//             color: isExpired ? Colors.red : Colors.orange,
//             size: 20,
//           ),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Text(
//               isExpired
//                   ? 'Your subscription has expired. Some features may be restricted. Please renew to continue using CounterPro.'
//                   : 'Your subscription expires in ${sub.daysLeft} days. Renew now to avoid interruption.',
//               style: TextStyle(
//                 fontSize: 12,
//                 color: isExpired ? Colors.red : Colors.orange,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//           const SizedBox(width: 10),
//           GestureDetector(
//             onTap: () => _showRenewDialog(context),
//             child: Container(
//               padding: const EdgeInsets.symmetric(
//                   horizontal: 12, vertical: 6),
//               decoration: BoxDecoration(
//                 color: isExpired ? Colors.red : Colors.orange,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: const Text(
//                 'Renew',
//                 style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 12),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _showRenewDialog(BuildContext context) {
//     // Get current plan price
//     double amount = 0;
//     String type = '';
//     switch (sub.plan) {
//       case SubscriptionPlan.basic:
//         amount = 50.0;
//         type = 'basic';
//         break;
//       case SubscriptionPlan.pro:
//         amount = 150.0;
//         type = 'pro';
//         break;
//       case SubscriptionPlan.enterprise:
//         amount = 250.0;
//         type = 'enterprise';
//         break;
//     }
//
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (_) => PaymentUpgradeDialog(
//         amount: amount,
//         type: type,
//         planName: sub.planName,
//       ),
//     );
//   }
// }
//
//
//
//
