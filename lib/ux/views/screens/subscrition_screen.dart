// // lib/ux/views/screens/subscription_expired_screen.dart
// import 'dart:ui';
//
// import 'package:eswaini_destop_app/ux/nav/app_navigator.dart';
// import 'package:eswaini_destop_app/ux/res/app_colors.dart';
// import 'package:eswaini_destop_app/ux/utils/shared/app.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import '../../../platform/utils/constant.dart';
// import '../../res/app_drawables.dart';
// import '../../utils/setup_checker.dart';
// import '../../utils/shared/subscriptionManger.dart';
// import '../components/dialogs/subscription_payment_upgrade.dart';
// import '../components/shared/btn.dart';
//
// class SubscriptionExpiredScreen extends StatelessWidget {
//   final SubscriptionCheckResult result;
//
//   const SubscriptionExpiredScreen({
//     super.key,
//     required this.result,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.primaryColor,
//       body: Container(
//           height: double.infinity,
//           width: double.infinity,
//           decoration: const BoxDecoration(
//             image: DecorationImage(
//               image: AssetImage(AppDrawables.loadingScreen),
//               fit: BoxFit.fill,
//             ),
//           ),
//           child: ClipRect(
//             child: BackdropFilter(
//               filter: ImageFilter.blur(
//                 sigmaX: 3.0,
//                 sigmaY: 3.0,
//               ), // Adjust blur intensity here
//               child: Container(
//                 alignment: Alignment.center,
//                 color: Colors.black.withOpacity(
//                   0.1,
//                 ), // Optional: adds a slight tint to the blur
//                 child:Center(
//                     child: Container(
//
//                         width: ConstantUtil.loginInputWidth,
//                         padding: const EdgeInsets.all(36),
//                         decoration: BoxDecoration(
//                           color: AppColors.cardOutlineColor,
//                           borderRadius: BorderRadius.circular(20),
//                           border: Border.all(color: Colors.grey, width: 5),
//                         ),
//         child:   Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Center(
//                 child:Padding(
//                     padding: const EdgeInsets.only(bottom: 8),
//                     child:RepaintBoundary(
//                         child: SvgPicture.asset(
//                           AppDrawables.darkLogoSVG,
//                           width: 90,
//                           height: 50,
//                           fit: BoxFit.fitWidth,
//                         ) )),
//               ),
//               Divider(thickness: 0.8,color: Colors.grey,),
//               const SizedBox(height: 10),
//               // icon
//               Container(
//                 width: 80,
//                 height: 80,
//                 decoration: BoxDecoration(
//                   color: Colors.red.withValues(alpha: 0.1),
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(Icons.lock_outline,
//                     color: Colors.red, size: 40),
//               ),
//
//               const SizedBox(height: 20),
//
//               const Text(
//                 'Subscription Expired',
//                 style: TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.red,
//                 ),
//               ),
//
//               const SizedBox(height: 12),
//
//               Text(
//                 result.message,
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(
//                     fontSize: 14, color: Colors.black54),
//               ),
//
//               const SizedBox(height: 20),
//
//               // plan info
//               if (result.company != null)
//                 Container(
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: Colors.grey.withValues(alpha: 0.06),
//                     borderRadius: BorderRadius.circular(10),
//                     border: Border.all(
//                         color: Colors.grey.withValues(alpha: 0.15)),
//                   ),
//                   child: Column(
//                     children: [
//                       _InfoRow(
//                         label: 'Plan',
//                         value: result.company!.subscriptionPlan.name
//                             .toUpperCase(),
//                       ),
//                       const SizedBox(height: 8),
//                       _InfoRow(
//                         label: 'Status',
//                         value: 'Expired',
//                         valueColor: Colors.red,
//                       ),
//                       if (result.company!.subscriptionEndDate != null) ...[
//                         const SizedBox(height: 8),
//                         _InfoRow(
//                           label: 'Expired on',
//                           value: _formatDate(
//                               result.company!.subscriptionEndDate!),
//                           valueColor: Colors.red,
//                         ),
//                       ],
//                     ],
//                   ),
//                 ),
//
//               const SizedBox(height: 24),
//
//               // renew button
//               SizedBox(
//                 width: double.infinity,
//                 child: ColorBtn(
//                   text: '🔄  Renew Subscription',
//                   btnColor: AppColors.primaryColor,
//                   action: () async {
//                     final planName = result.company
//                         ?.subscriptionPlan.name ??
//                         'pro';
//                     final renewed = await showDialog<bool>(
//                       context: context,
//                       barrierDismissible: false,
//                       builder: (_) => PaymentUpgradeDialog(
//                         amount:    _planAmount(planName),
//                         type:      planName,
//                         planName:  planName.toUpperCase(),
//                         planColor: AppColors.primaryColor,
//                       ),
//                     );
//
//                     if (renewed == true && context.mounted) {
//                       // check again after renewal
//                       // final newResult =
//                       // await SubscriptionManager.checkSubscription();
//                       // if (newResult.isActive) {
//                       //   AppNavigator.gotoLogin(context: context);
//                       // }
//                     }
//                   },
//                 ),
//               ),
//
//               const SizedBox(height: 12),
//
//               // contact support
//               TextButton.icon(
//                 onPressed: () => AppUtil.toastMessage(
//                   message: 'Contact support@counterproapp.com',
//                   context: context,
//                   backgroundColor: Colors.blue,
//                 ),
//                 icon: const Icon(Icons.email_outlined,
//                     size: 16, color: Colors.black54),
//                 label: const Text(
//                   'Contact Support',
//                   style: TextStyle(color: Colors.black54),
//                 ),
//               ),
//             ],
//           ))),
//               )) ),
//       ),
//     );
//   }
//
//   double _planAmount(String plan) {
//     switch (plan.toLowerCase()) {
//       case 'pro':        return 149.99;
//       case 'enterprise': return 359.99;
//       default:           return 59.99;
//     }
//   }
//
//   String _formatDate(DateTime date) {
//     final months = [
//       'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
//       'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
//     ];
//     return '${date.day} ${months[date.month - 1]} ${date.year}';
//   }
// }
//
// class _InfoRow extends StatelessWidget {
//   final String label;
//   final String value;
//   final Color? valueColor;
//
//   const _InfoRow({
//     required this.label,
//     required this.value,
//     this.valueColor,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(label,
//             style: const TextStyle(
//                 fontSize: 13, color: Colors.grey)),
//         Text(value,
//             style: TextStyle(
//               fontSize: 13,
//               fontWeight: FontWeight.w600,
//               color: valueColor ?? Colors.black87,
//             )),
//       ],
//     );
//   }
// }