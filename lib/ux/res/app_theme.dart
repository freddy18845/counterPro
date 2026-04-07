
import "package:flutter/material.dart";
import "../../platform/utils/constant.dart";
import "../utils/sessionManager.dart";
import "../utils/shared/screen.dart";
import "app_colors.dart";
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
// ── Transaction ID generator ──────────────────────────────────
  static String generateTransactionId() {
    final now = DateTime.now();

    // ── safe 3-letter prefix from company name ──────────────
    final companyName = SessionManager().companyName ?? 'TXN';

    // strip everything except letters then uppercase
    final lettersOnly = companyName
        .replaceAll(RegExp(r'[^a-zA-Z]'), '')
        .toUpperCase();

    // safely take up to 3 letters — pad with X if fewer than 3
    final prefix = lettersOnly.isEmpty
        ? 'TXN'
        : lettersOnly.length >= 3
        ? lettersOnly.substring(0, 3)
        : lettersOnly.padRight(3, 'X');

    // ── date parts ──────────────────────────────────────────
    // last two digits of year e.g. 2025 → 25
    final yearShort = (now.year % 100).toString().padLeft(2, '0');

    // month zero padded e.g. 03
    final month = now.month.toString().padLeft(2, '0');

    // day zero padded e.g. 21
    final day = now.day.toString().padLeft(2, '0');

    // ── unique sequence from milliseconds ───────────────────
    // millisecond is 0-999, padLeft ensures 3 digits always
    final ms = now.millisecond.toString().padLeft(3, '0');

    // take first 2 digits — always safe since ms is exactly 3 chars
    final sequence = ms.substring(0, 2);

    // ── assemble ─────────────────────────────────────────────
    // prefix(3) + year(2) + month(2) + day(2) + seq(2) = 11 chars
    // e.g. SWA25032104
    return '$prefix$yearShort$month$day$sequence';
  }



  static  String capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }
}
