import "package:flutter/material.dart";
import "../../platform/utils/constant.dart";
import "../utils/shared/screen.dart";
import "app_colors.dart";
import "app_drawables.dart";
import "app_strings.dart";

class AppTheme {
  AppTheme._();

  static TextStyle textStyle = const TextStyle(
    color: Colors.black,
    fontSize: 12,
  );
  static Widget buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          Text(value, style: TextStyle(color: Colors.black, fontSize: 12)),
        ],
      ),
    );
  }

  static String monthName(int month) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];
    return months[month - 1];
  }

  static TextStyle getTextStyle({
    bool bold = false,
    Color? color,
    double? size,
  }) {
    return TextStyle(
      fontSize: size ?? (ScreenUtil.height * 0.02).clamp(9, 12),
      color: color ?? Colors.white,
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
      fontFamily: 'Gilroy',
    );
  }

  static Widget buildVerticalDivider({Color? color}) {
    return SizedBox(
      height: 16,
      child: VerticalDivider(thickness: 1, color: color ?? Colors.white),
    );
  }

  static Widget buildDivider() {
    return Container(
      height: double.infinity,
      width: 0.8,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: Colors.grey,
    );
  }

  static Widget buildProcessing() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: ConstantUtil.verticalSpacing * 2),
        Text(
          AppStrings.fetchingData,
          style: TextStyle(
            fontSize: (ScreenUtil.height * 0.02).clamp(10, 14),
            fontWeight: FontWeight.normal,
            // fontFamily: 'Gilroy',
          ),
        ),
        SizedBox(height: ConstantUtil.verticalSpacing / 2),
        Text(
          AppStrings.pleaseWait,
          style: TextStyle(
            color: AppColors.primaryColor,
            fontSize: (ScreenUtil.height * 0.02).clamp(10, 12),
            fontWeight: FontWeight.normal,
            //  fontFamily: 'Gilroy',
          ),
        ),

      ],
    );
  }

  static Widget buildPinPadImage() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: ConstantUtil.verticalSpacing),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppDrawables.pinPad),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
