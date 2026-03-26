
import "package:flutter/material.dart";
import "../../../res/app_theme.dart";
import "../../../utils/shared/screen.dart";

class ReceiptItem extends StatelessWidget {

  final String index;
  final String value;

  const ReceiptItem({
    super.key,
    required this.index,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom:2,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            alignment: Alignment.topLeft,
            width: (ScreenUtil.width * 0.28).clamp(90, 94),
            child: Text(
              "$index:",
              style: AppTheme.textStyle.copyWith(
                fontSize: 8,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

        SizedBox(
            width: (ScreenUtil.width * 0.28).clamp(90, 94),
            child: Align(
              alignment: Alignment.topRight,
              child: Text(
                value,
                style: AppTheme.textStyle.copyWith(
                  fontSize: 8,
                  color: Colors.black
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
