
import "package:eswaini_destop_app/platform/utils/utils.dart";
import "package:flutter/material.dart";
import "../../../res/app_theme.dart";
import "../../../utils/shared/screen.dart";
import "multiple_line.dart";


class AmountToPay extends StatelessWidget {

  final double amount;
  final Color color;
  final double scaleFactor;
  final String symbol;
  final int? decimals;

  const AmountToPay({
    super.key,
    required this.amount,
    this.color =Colors.black,
    this.scaleFactor = 1,
    required this.symbol,
    this.decimals,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      // Removed MainAxisSize.min to allow Spacer to work
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [


        // This Row groups the Symbol and Amount together on the right
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // if (symbol.isNotEmpty)
            //   Padding(
            //     padding: EdgeInsets.only(
            //       // Use scaleFactor to nudge the symbol perfectly to the top corner
            //       top: (ScreenUtil.height * 0.001) * scaleFactor,
            //       right: 10.0,
            //     ),
            //     child: Text(
            //       symbol,
            //       style: AppTheme.textStyle.copyWith(
            //         fontSize: (ScreenUtil.width * 0.025) * scaleFactor,
            //         fontWeight: FontWeight.bold,
            //         color: color,
            //         height: 1.0,
            //       ),
            //     ),
            //   ),

            MultiLineText(
              text: amount.toAmountString(decimalCount: decimals ?? 2),
              color: color,
              scaleFactor: scaleFactor,
            ),
          ],
        ),
      ],
    );
  }
}
