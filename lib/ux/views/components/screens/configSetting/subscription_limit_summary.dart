// // ── Limits summary ────────────────────────────────────────────
// import 'package:eswaini_destop_app/ux/models/shared/pos_user.dart';
// import 'package:eswaini_destop_app/ux/models/shared/product.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:isar/isar.dart';
//
// import '../../../../../platform/utils/isar_manager.dart';
// import '../../../../res/app_colors.dart';
// import '../../../../utils/shared/subscriptionManger.dart';
//
// class LimitsSummary extends StatefulWidget {
//   final SubscriptionManager sub;
//   const LimitsSummary({required this.sub});
//
//   @override
//   State<LimitsSummary> createState() => LimitsSummaryState();
// }
//
// class LimitsSummaryState extends State<LimitsSummary> {
//   int _userCount = 0;
//   int _productCount = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadCounts();
//   }
//
//   Future<void> _loadCounts() async {
//     final isar = IsarService.db;
//     final users = await isar.posUsers.where().count();
//     final products = await isar.products.where().count();
//     setState(() {
//       _userCount = users;
//       _productCount = products;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.grey.withValues(alpha: 0.04),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//             color: Colors.grey.withValues(alpha: 0.15)),
//       ),
//       child: Column(
//         children: [
//           _LimitRow(
//             icon: Icons.people_outlined,
//             label: 'Users',
//             used: _userCount,
//             max: widget.sub.maxUsers,
//             color: AppColors.primaryColor,
//           ),
//           const SizedBox(height: 12),
//           _LimitRow(
//             icon: Icons.inventory_2_outlined,
//             label: 'Products',
//             used: _productCount,
//             max: widget.sub.maxProducts,
//             color: Colors.orange,
//           ),
//           const SizedBox(height: 12),
//           // feature flags
//           Wrap(
//             spacing: 8,
//             runSpacing: 8,
//             children: [
//               _FeatureChip(
//                 label: 'Export',
//                 enabled: widget.sub.canExport,
//               ),
//               _FeatureChip(
//                 label: 'Advanced Reports',
//                 enabled: widget.sub.hasAdvancedReports,
//               ),
//               _FeatureChip(
//                 label: 'API Access',
//                 enabled: widget.sub.hasApiAccess,
//               ),
//               _FeatureChip(
//                 label: 'Multi-Branch',
//                 enabled: widget.sub.hasMultiBranch,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _LimitRow extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final int used;
//   final int max;
//   final Color color;
//
//   const _LimitRow({
//     required this.icon,
//     required this.label,
//     required this.used,
//     required this.max,
//     required this.color,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final isUnlimited = max >= 999999;
//     final ratio = isUnlimited ? 0.0 : (used / max).clamp(0.0, 1.0);
//     final isNearLimit = !isUnlimited && ratio >= 0.8;
//
//     return Row(
//       children: [
//         Icon(icon, size: 16, color: color),
//         const SizedBox(width: 8),
//         SizedBox(
//           width: 80,
//           child: Text(
//             label,
//             style: const TextStyle(
//                 fontSize: 12, color: Colors.black87),
//           ),
//         ),
//         Expanded(
//           child: isUnlimited
//               ? Row(
//             children: [
//               const SizedBox(width: 8),
//               Text(
//                 '$used / Unlimited',
//                 style: TextStyle(
//                     fontSize: 12,
//                     color: Colors.grey,
//                     fontWeight: FontWeight.w500),
//               ),
//             ],
//           )
//               : Row(
//             children: [
//               const SizedBox(width: 8),
//               Expanded(
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(4),
//                   child: LinearProgressIndicator(
//                     value: ratio,
//                     backgroundColor:
//                     Colors.grey.withValues(alpha: 0.2),
//                     color: isNearLimit
//                         ? Colors.orange
//                         : color,
//                     minHeight: 8,
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 10),
//               Text(
//                 '$used / $max',
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: isNearLimit
//                       ? Colors.orange
//                       : Colors.grey,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// class _FeatureChip extends StatelessWidget {
//   final String label;
//   final bool enabled;
//
//   const _FeatureChip({required this.label, required this.enabled});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding:
//       const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//       decoration: BoxDecoration(
//         color: enabled
//             ? Colors.green.withValues(alpha: 0.1)
//             : Colors.grey.withValues(alpha: 0.08),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(
//           color: enabled
//               ? Colors.green.withValues(alpha: 0.4)
//               : Colors.grey.withValues(alpha: 0.2),
//         ),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(
//             enabled
//                 ? Icons.check_circle_outline
//                 : Icons.cancel_outlined,
//             size: 12,
//             color: enabled ? Colors.green : Colors.grey,
//           ),
//           const SizedBox(width: 4),
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 11,
//               color: enabled ? Colors.green : Colors.grey,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }