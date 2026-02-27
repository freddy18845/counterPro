
import "package:flutter/material.dart";
import "../../../res/app_theme.dart";
import "../../../utils/shared/screen.dart";

class CurrencySelectorButton extends StatelessWidget {

  final bool isSingleCurrency;
  final String symbol;
  final Color color;
  final void Function()? onTap;

  const CurrencySelectorButton({
    super.key,
    this.color = Colors.black,
    required this.isSingleCurrency,
    required this.symbol,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget text = Text(
        symbol,
        style: AppTheme.textStyle.copyWith(
            fontSize: isSingleCurrency
                ? (ScreenUtil.width * 0.05).clamp(12, 14): (ScreenUtil.width * 0.04).clamp(12, 14),
            fontWeight: FontWeight.bold,
          color: color
        )
    );
    return  Container(


     //  height: isSingleCurrency ? null : ScreenUtil.width * 0.1,
     //  width: isSingleCurrency ? null : ScreenUtil.width * 0.07,
      child: isSingleCurrency
          ? text
          : InkWell(
        onTap: onTap,
        child: text,
      ),
    );
  }
}
