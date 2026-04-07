// // ── Current plan card ─────────────────────────────────────────
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
// import '../../../res/app_colors.dart';
// import '../../../utils/shared/subscriptionManger.dart';
//
// class CurrentPlanCard extends StatelessWidget {
//   final SubscriptionManager sub;
//   const CurrentPlanCard({required this.sub});
//
//   Color get _statusColor {
//     if (sub.isExpired) return Colors.red;
//     if (sub.isExpiringSoon) return Colors.orange;
//     return Colors.green;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(colors: [
//           AppColors.primaryColor,
//           AppColors.primaryColor.withValues(alpha: 0.7),
//         ]),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Row(
//         children: [
//           const Icon(Icons.workspace_premium,
//               color: Colors.amber, size: 40),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   '${sub.planName} Plan',
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   sub.endDate != null
//                       ? sub.isExpired
//                       ? 'Expired on ${DateFormat('dd MMM yyyy').format(sub.endDate!)}'
//                       : 'Active until ${DateFormat('dd MMM yyyy').format(sub.endDate!)}'
//                       : 'No expiry date set',
//                   style: TextStyle(
//                     color: Colors.white.withValues(alpha: 0.85),
//                     fontSize: 13,
//                   ),
//                 ),
//                 if (sub.isExpiringSoon && !sub.isExpired)
//                   Padding(
//                     padding: const EdgeInsets.only(top: 4),
//                     child: Text(
//                       '⚠️ ${sub.daysLeft} days remaining',
//                       style: const TextStyle(
//                         color: Colors.amber,
//                         fontSize: 12,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.symmetric(
//                 horizontal: 12, vertical: 6),
//             decoration: BoxDecoration(
//               color: _statusColor,
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Text(
//               sub.statusLabel,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 12,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }