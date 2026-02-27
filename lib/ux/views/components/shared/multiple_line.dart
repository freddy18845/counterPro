
import "package:flutter/material.dart";
import "../../../res/app_theme.dart";
import "../../../utils/shared/screen.dart";

class MultiLineText extends StatelessWidget {

  final String text;
  final Color? color;
  final double scaleFactor;

  const MultiLineText({
    super.key,
    required this.text,
    this.color = Colors.white,
    this.scaleFactor = 1,
  });

  @override
  Widget build(BuildContext context) {
    // Split the amount (e.g., "1,250.00") into ["1,250", "00"]
    List<String> parts = text.split('.');
    String mainAmount = parts[0];
    String cents = parts.length > 1 ? parts[1] : "";

    return Row(
      mainAxisSize: MainAxisSize.min,
      // 1. This must also be baseline to connect to AmountToPay correctly
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          mainAmount,
          style: AppTheme.textStyle.copyWith(
            fontSize: ((ScreenUtil.width * 0.05).clamp(18, 30)) * scaleFactor,
            fontWeight: FontWeight.w200,
            fontFamily: 'Gilroy',
            color: color,
          ),
        ),
        if (cents.isNotEmpty)
          Text(
            ".$cents",
            style: AppTheme.textStyle.copyWith(
              fontSize: ((ScreenUtil.width * 0.001).clamp(18, 28)) * scaleFactor,
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.w200,
              color: color,
            ),
          ),
      ],
    );
  }
}
