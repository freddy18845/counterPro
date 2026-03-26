import "dart:math";
import "package:eswaini_destop_app/platform/utils/constant.dart";
import "package:eswaini_destop_app/ux/utils/shared/screen.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "../../res/app_strings.dart";


class AppUtil {



  AppUtil._();

  static void toastMessage({
    required String message,
    required BuildContext context,
    Color? backgroundColor,
    Duration duration = const Duration(seconds: 3),
  }) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: (ConstantUtil.maxHeightAppBar +14),
        left: (ScreenUtil.width - 300) / 2,
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 300,
            padding: EdgeInsets.symmetric(
              horizontal: ConstantUtil.horizontalSpacing,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: backgroundColor ?? Colors.green,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(duration, () {
      overlayEntry.remove();
    });
  }

  static String genRandCode({required int length, bool noZero = false,}) {
    String result = "", chars = noZero ? "123456789" : "0123456789";
    for(int a = 0;a < length;a++) {
      result += chars[ Random().nextInt(chars.length - 0) ];
    }
    return result;
  }

 static double calculateDisplayAmount({
    required bool isCustomAmount,
    required bool selectedCurrency,
    required double amount,
    String precision = "2",
  }) {
    if (isCustomAmount) {
      return amount;
    }

    if (selectedCurrency) {
      final parsedPrecision = double.tryParse(precision) ?? 1;
      return amount / parsedPrecision;
    }

    return amount;
  }

  static void exitApp() {
    SystemChannels.platform.invokeMethod(AppStrings.systemPop,);
  }

  static Future displayDialog({
    required BuildContext context,
    required Widget child,
    bool dismissible = true,
  }) => showDialog(
    context: context,
    barrierDismissible: dismissible,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black54,
    builder: (BuildContext dialogContext) => Container(
      constraints: const BoxConstraints(maxWidth: 120, minWidth: 100),
      child: child,),
  );


}
