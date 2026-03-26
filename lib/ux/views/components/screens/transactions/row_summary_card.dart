import 'package:eswaini_destop_app/ux/views/components/screens/transactions/summary_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../platform/utils/constant.dart';
import '../../../../res/app_colors.dart';
import '../../../../utils/shared/screen.dart';

class SummaryCardRow extends StatelessWidget {
  final double totalAmount;
  final int completedCount;
  final int refundedCount;
  final int voidedCount;
  const SummaryCardRow({
    super.key,
    required this.totalAmount,
    required this.completedCount,
    required this.refundedCount,
    required this.voidedCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SummaryCard(
          label: 'Total Amount',
          value:
              '${ConstantUtil.currencySymbol} ${totalAmount.toStringAsFixed(2)}',
          color: AppColors.primaryColor,
          icon: Icons.attach_money,
        ),
        SizedBox(width: ScreenUtil.width * 0.01),
        SummaryCard(
          label: 'Completed',
          value: '$completedCount',
          color: Colors.green,
          icon: Icons.check_circle_outline,
        ),
        SizedBox(width: ScreenUtil.width * 0.01),
        SummaryCard(
          label: 'Refunded',
          value: '$refundedCount',
          color: Colors.orange,
          icon: Icons.replay,
        ),
        SizedBox(width: ScreenUtil.width * 0.01),
        SummaryCard(
          label: 'Voided',
          value: '$voidedCount',
          color: Colors.red,
          icon: Icons.cancel_outlined,
        ),
      ],
    );
  }
}
