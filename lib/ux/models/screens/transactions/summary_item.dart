
import "../../../res/app_strings.dart";
import "../../terminal_sign_on_response.dart";

class TransactionsSummaryItem {

  Currency currency;
  List<TransactionsSummarySubItem> subs;

  TransactionsSummaryItem({
    required this.currency,
    this.subs = const [],
  }) {
    subs = [
      TransactionsSummarySubItem(title: AppStrings.card, count: 0, amountTotal: 0),
      TransactionsSummarySubItem(title: AppStrings.wallet, count: 0, amountTotal: 0),
      TransactionsSummarySubItem(title: AppStrings.qrCode, count: 0, amountTotal: 0),
      TransactionsSummarySubItem(title: AppStrings.total, count: 0, amountTotal: 0),
    ];
  }

}

class TransactionsSummarySubItem {

  String title;
  int count;
  double amountTotal;

  TransactionsSummarySubItem({
    required this.title,
    required this.count,
    required this.amountTotal
  });

}
