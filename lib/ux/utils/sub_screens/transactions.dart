// import "package:rise_app_3/ux/models/shared/transaction.dart";
// import "package:rise_app_3/ux/models/sub_screens/transactions/summary_item.dart";
// import "../../models/shared/signOnResponse.dart";
//
// class TransactionsUtil {
//
//   TransactionsUtil._();
//
//   static List<TransactionsSummaryItem> buildTransSummary({
//     required List<Currency> currencies,
//     required List<TransactionData> transactions,
//   }) {
//     List<TransactionsSummaryItem> summaryItems = [];
//     TransactionData trans = TransactionData();
//     for (Currency currency in currencies) {
//       TransactionsSummaryItem summaryItem = TransactionsSummaryItem(
//         currency: currency,
//       );
//       // for (int a = 0; a < summaryItem.subs.length; a++) {
//       //   if (summaryItem.subs[a].title == AppStrings.card) {
//       //     List result = trans.getTransSummary(
//       //       transactions: transactions,
//       //       currency: currency,
//       //       transactionType: SvnUtilityTransactionTenderTypes.type01,
//       //     );
//       //     summaryItem.subs[a].count = result[0];
//       //     summaryItem.subs[a].amountTotal = result[1];
//       //   } else
//       //   if (summaryItem.subs[a].title == AppStrings.wallet) {
//       //     List result = trans.getTransSummary(
//       //       transactions: transactions,
//       //       currency: currency,
//       //       transactionType: SvnUtilityTransactionTenderTypes.type02,
//       //     );
//       //     summaryItem.subs[a].count = result[0];
//       //     summaryItem.subs[a].amountTotal = result[1];
//       //   } else
//       //   if (summaryItem.subs[a].title == AppStrings.qrCode) {
//       //     List result = trans.getTransSummary(
//       //       transactions: transactions,
//       //       currency: currency,
//       //       transactionType: SvnUtilityTransactionTenderTypes.type03,
//       //     );
//       //     summaryItem.subs[a].count = result[0];
//       //     summaryItem.subs[a].amountTotal = result[1];
//       //   } else {
//       //     summaryItem.subs[a].count = (
//       //       summaryItem.subs[0].count + summaryItem.subs[1].count +
//       //       summaryItem.subs[2].count
//       //     );
//       //     summaryItem.subs[a].amountTotal = (
//       //       summaryItem.subs[0].amountTotal + summaryItem.subs[1].amountTotal +
//       //       summaryItem.subs[2].amountTotal
//       //     );
//       //   }
//       }
//       //summaryItems.add(summaryItem);
//     }
//     return summaryItems;
//   }
//
// }
