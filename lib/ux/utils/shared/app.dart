import "dart:math";
import "package:eswaini_destop_app/platform/utils/constant.dart";
import "package:eswaini_destop_app/ux/utils/shared/screen.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "../../../platform/utils/utils.dart";
import "../../Providers/transaction_provider.dart";
import "../../enums/screens/transactions/date_filter.dart";
import "../../models/screens/transactions/date_range.dart";
import "../../models/shared/transaction.dart";
import "../../models/terminal_sign_on_response.dart";
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

  static TransactionsDateRange getDateRange({
    required TransactionsDateFilter filterRequest,
    int? days,
  }) {
    TransactionsDateRange range = TransactionsDateRange(startDate: "",endDate: "");
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    switch(filterRequest) {
      case TransactionsDateFilter.today:
        range.startDate = today.toApiDateString();
        range.endDate = today.add(const Duration(hours: 23,minutes: 59, seconds: 59)).toApiDateString();
        break;
      case TransactionsDateFilter.yesterday:
        DateTime yesterday = today.subtract(const Duration(hours: 24));
        range.startDate = yesterday.toApiDateString();
        range.endDate = yesterday.add(const Duration(hours: 23,minutes: 59, seconds: 59)).toApiDateString();
        break;
      default:
        range.startDate = today.subtract(Duration(days: days??1)).toApiDateString();
        range.endDate = today.add(const Duration(hours: 23,minutes: 59, seconds: 59)).toApiDateString();
        break;
    }
    return range;
  }



  static String parseNumPadAmount({required String input, int decimalPlaces = 2}) {
    String result = "";
    if (input.length <= decimalPlaces) {
      result = "${List.filled((decimalPlaces - input.length) + 1,"0").join()}$input";
    } else {
      result = input;
    }
    return "${result.substring(0, result.length - decimalPlaces)}.${result.substring(
      result.length - decimalPlaces
    )}";
  }
 static String firstThreeLetters(String text) {
    if (text.length < 3) return text;
    return text.substring(0, 3);
  }
 static String getTransCurrencySymbol({
    required String currencyCode,
  }) {
    String symbol = "";
    List<Currency> availableCurrencies = TransactionManager().currencies;
    for (Currency currency in availableCurrencies) {
      if (currency.code == currencyCode) {
        symbol = currency.symbol ?? "";
        break;
      }
    }
    return symbol;
  }

  static Currency getTransCurrency({
    required String currencyCode,
  }) {
    Currency? transCurrency;
    List<Currency> availableCurrencies = TransactionManager().currencies;
    for (Currency currency in availableCurrencies) {
      if (currency.code == currencyCode) {
        transCurrency = currency;
        break;
      }
    }
    return transCurrency ??
        Currency(code: '', name: '', alphaCode: '', symbol: '', precision: '', merchantID: '', terminalID: '', floorLimit: '', ceilingLimit: '', contactlessNoPinLimit: '', contactlessLimit: '', cashbackLimit: '');
  }

  static int getTransCurrencyPrecision({
    required String currencyCode,
  }) {
    int precision = 0;
    List<Currency> availableCurrencies = TransactionManager().currencies;
    for (Currency currency in availableCurrencies) {
      if (currency.code == currencyCode) {
        precision = int.parse(currency.precision) ?? 0;
        break;
      }
    }
    return precision;
  }

  static String getTransDisplayAmount({
    required TransactionData transaction,
  }) {
    String symbol =
    getTransCurrencySymbol(currencyCode: transaction.currency.toString());
    return "$symbol${getTransAmount(transaction: transaction)}";
  }

  static String getTransDisplayCashBackAmount({
    required TransactionData transaction,
  }) {
    String symbol =
    getTransCurrencySymbol(currencyCode: transaction.currency.toString());
    return "$symbol${getCashBackAmount(transaction: transaction)}";
  }

}
