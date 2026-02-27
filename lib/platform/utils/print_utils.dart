//
// import 'package:flutter/foundation.dart';
// import 'package:flutter/services.dart';
// import 'package:intl/intl.dart';
// import 'package:sovereign_pay_utility/extensions/string.dart';
// import 'package:sovereign_pay_utility/services/currency_manager/models/currency_object.dart';
// import 'package:sovereign_pay_utility/services/transaction_manager/enums/tender_types.dart';
// import 'package:sovereign_pay_utility/services/transaction_manager/models/transaction_object.dart';
// import 'package:sovereign_pay_utility/utility.dart';
// // import 'package:sunmi_printer_plus/core/enums/enums.dart';
// // import 'package:sunmi_printer_plus/core/styles/sunmi_text_style.dart';
// // import 'package:sunmi_printer_plus/core/sunmi/sunmi_printer.dart';
//
// import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
// import '../../ux/models/sub_screens/transactions/date_range.dart';
// import '../../ux/res/app_drawables.dart';
// import '../../ux/res/app_strings.dart';
// import '../../ux/utils/sub_screens/transactions.dart';
//
// /// Left-aligns a string within a fixed width, truncating with ".." if necessary.
// String _leftText(String text, int width) {
//   if (text.length > width) {
//     return '${text.substring(0, width - 2)}..';
//   }
//   return text.padRight(width);
// }
//
// /// Centers a string within a fixed width, truncating with ".." if necessary.
// String _centerText(String text, int width) {
//   if (text.length > width) {
//     return '${text.substring(0, width - 2)}..';
//   }
//   final padding = width - text.length;
//   final padLeft = padding ~/ 2;
//   final padRight = padding - padLeft;
//   return ' ' * padLeft + text + ' ' * padRight;
// }
//
// /// Right-aligns a string within a fixed width, truncating with ".." if necessary.
// String _rightText(String text, int width) {
//   if (text.length > width) {
//     return '${text.substring(0, width - 2)}..';
//   }
//   return text.padLeft(width);
// }
//
// /// Prints a row in a 36-character-wide receipt,
// /// with the first column left-aligned, second centered, third right-aligned.
// Future<void> printTableRow(
//   String col1,
//   String col2,
//   String col3, {
//   bool isHeader = false,
// }) async {
//   const int col1Width = 10;
//   const int col2Width = 6;
//   const int col3Width = 16;
//
//   final c1 = _leftText(col1, col1Width);
//   final c2 = _centerText(col2, col2Width);
//   final c3 = _rightText(col3, col3Width);
//   final row = '$c1$c2$c3'; // exactly 36 characters wide
//
//   if (isHeader) {
//     await SunmiPrinter.printText(
//       row,
//       style: SunmiTextStyle(bold: true, underline: true),
//     );
//   } else {
//     await SunmiPrinter.printText(row);
//   }
// }
//
// Future<void> printEnd() async {
//   await printDottedLine();
//   await printLine(parseSingleLineText("END"), center: true);
//   await printDottedLine(4);
// }
//
// Future<void> printImage() async {
//   await SunmiPrinter.lineWrap(10);
//   final Uint8List logoImage = await getImageFromAsset(
//     AppDrawables.imgInvoiceLogo,
//   );
//   await SunmiPrinter.printImage(logoImage, align: SunmiPrintAlign.CENTER);
//   await SunmiPrinter.lineWrap(10);
// }
//
// Future<void> printSummaryHeader({
//   required bool isPrintAll,
//   required TransactionsDateRange dateRange,
//   required List<SvnUtilityTransaction> transactionList
// }) async {
//   try {
//     final tUtility =
//         SvnUtility.i.transactionManager.utility; // ✅ Initialize tUtility here
//
//     await printImage();
//     await SunmiPrinter.lineWrap(12);
//     final activationInfo = SvnUtility.i.activationManager.activationInfo;
//     await printLine(
//       parseSingleLineText(activationInfo?.merchantName ?? ""),
//       center: true,
//     );
//     await printLine(
//       parseSingleLineText(activationInfo?.merchantLocation ?? ""),
//       center: true,
//     );
//     await printLine(
//       parseSingleLineText(
//         "${AppStrings.bid_}: ${activationInfo?.businessId ?? ""}",
//       ),
//       center: true,
//     );
//     await SunmiPrinter.lineWrap(10);
//
//     await printLine(
//       parseSingleLineText(
//         "${AppStrings.transactions.toUpperCase()} ${isPrintAll ? AppStrings.report.toUpperCase() : AppStrings.summary.toUpperCase()}",
//       ),
//       center: true,
//     );
//
//     final timeNow = DateFormat(
//       'dd-MMM-yyyy HH:mm:ss',
//     ).format(DateTime.now()).toUpperCase();
//
//     if (isPrintAll) {
//       await printLine(
//         parseSingleLineText("${AppStrings.print}: $timeNow"),
//         center: true,
//         bold: false,
//       );
//       await printDottedLine();
//       await printLine(
//         parseSingleLineText(AppStrings.summary.toUpperCase()),
//         center: true,
//       );
//     }
//
//     await printDottedLine();
//
//     final startDateStr = tUtility
//         .getTransDisplayDate(transDate: dateRange.startDate )
//         .toUpperCase();
//     final endDateStr = tUtility
//         .getTransDisplayDate(transDate: dateRange.endDate)
//         .toUpperCase();
//
//     await printColumn("DATE START:", startDateStr);
//     await printColumn("DATE END:", endDateStr);
//     await printSummaryReceipt(transactions:transactionList);
//   } catch (e) {
//     debugPrint("❌ Error in printSummaryHeader: $e");
//     if (kDebugMode) rethrow;
//   }
// }
//
// Future<void> printSummaryReceipt({
//   required List<SvnUtilityTransaction> transactions,
// }) async {
//   try {
//     // Get accepted currencies or an empty list if null
//     final List<SvnUtilityCurrency> currencies =
//         SvnUtility.i.currencyManager.acceptedCurrencies ?? [];
//
//     // Build summary items
//     final summaryItems = TransactionsUtil.buildTransSummary(
//       currencies: currencies,
//       transactions: transactions,
//     );
//
//     // Start with some spacing
//
//     for (final item in summaryItems) {
//       final precision = int.tryParse(item.currency.precision ?? '') ?? 2;
//       // Print currency label
//       await printColumn("CURRENCY:", item.currency.symbol?.toUpperCase() ?? "-");
//       await SunmiPrinter.lineWrap(1);
//
//       // Print table headers
//       await printTableRow(
//         "TENDER",
//         "COUNT",
//         "AMOUNT (${item.currency.symbol?.toUpperCase() ?? "-"})",
//       );
//       await printDottedLine(0);
//
//       // Loop over sub-items (tender types)
//       for (final row in item.subs) {
//         await printTableRow(
//           row.title ,
//           row.count.toString(),
//           row.amountTotal.toStringAsFixed(precision),
//         );
//       }
//
//       await printDottedLine(0);
//       await SunmiPrinter.lineWrap(2);
//     }
//
//     await SunmiPrinter.lineWrap(3);
//   } catch (e) {
//     if (kDebugMode) {
//       print("❌ Error printing summary receipt: $e");
//     }
//   }
// }
//
// Future<void> printReceiptTransaction(
//   SvnUtilityTransaction transaction,
//   bool isDuplicate,
//   String receiptType,
// ) async {
//   final tUtility = SvnUtility.i.transactionManager.utility;
//   final tCardNetwork = tUtility.getTransCardNetwork(transaction: transaction);
//   final tNetwork = tUtility.getTransNetwork(transaction: transaction);
//
//   await printImage();
//   await printLine(
//     parseSingleLineText(transaction.merchantName ?? ""),
//     center: true,
//     bold: true,
//   );
//   await printLine(
//     parseSingleLineText(transaction.merchantLocation ?? ""),
//     center: true,
//     bold: true,
//   );
//   await printLine(
//     parseSingleLineText(
//       "${AppStrings.businessId_} ${SvnUtility.i.activationManager.activationInfo?.businessId}",
//     ),
//     center: true,
//     bold: true,
//   );
//   await printLine(
//     parseSingleLineText(transaction.merchantId ?? ""),
//     center: true,
//     bold: true,
//   );
//
//   await printLine(
//     parseSingleLineText(
//       "${isDuplicate ? "${AppStrings.duplicate} ".toUpperCase() : ""}${AppStrings.receipt}"
//           .toUpperCase(),
//     ),
//     center: true,
//     bold: true,
//   );
//
//   await SunmiPrinter.lineWrap(10);
//   await printDottedLine();
//   await printLine(
//     parseSingleLineText(AppStrings.payment.toUpperCase()),
//     center: true,
//     bold: true,
//   );
//   await printDottedLine();
//   await SunmiPrinter.lineWrap(10);
//
//   await printColumn(
//     AppStrings.amount,
//     tUtility.getTransDisplayAmount(transaction: transaction),
//   );
//   await printLine(
//     parseSingleLineText(
//       transaction.responseCode == "00"
//           ? AppStrings.approved.toUpperCase()
//           : AppStrings.failed.toUpperCase(),
//     ),
//     center: true,
//     bold: true,
//   );
//   await SunmiPrinter.lineWrap(10);
//
//   await printColumn(AppStrings.transactionId, transaction.transactionId ?? "-");
//   await printColumn(AppStrings.authCode, transaction.authorizationCode ?? "-");
//   await printColumn(
//     AppStrings.authRef,
//     transaction.authorizationReference ?? "-",
//   );
//   await printDottedLine();
//
//   await printColumn(
//     AppStrings.dateTime,
//     tUtility
//         .getTransDisplayDate(transDate: transaction.dateTime ?? "")
//         .toUpperCase(),
//   );
//   await printColumn(AppStrings.refCode_, transaction.referenceInfo ?? "-");
//
//   if (transaction.tenderType == SvnUtilityTransactionTenderTypes.type01) {
//     await printColumn(AppStrings.tenderType, AppStrings.card);
//     await printColumn(AppStrings.network, tCardNetwork);
//     await printColumn(
//       AppStrings.cardNumber,
//       transaction.pan?.toMaskedString() ?? "-",
//     );
//   } else if (transaction.tenderType ==
//       SvnUtilityTransactionTenderTypes.type02) {
//     await printColumn(AppStrings.tenderType, AppStrings.mobileWallet);
//     await printColumn(AppStrings.network, tNetwork.name);
//     await printColumn(AppStrings.mobileNumber, transaction.pan ?? "-");
//   } else {
//     await printColumn(AppStrings.tenderType, AppStrings.qrCode);
//   }
//
//   await printDottedLine();
//   if (transaction.tellerName?.isNotEmpty ?? false) {
//     await printColumn(AppStrings.servedBy, transaction.tellerName!);
//   }
//   await printDottedLine();
//   await printLine(parseSingleLineText(receiptType), center: true, bold: false);
//   await printDottedLine();
//   await SunmiPrinter.lineWrap(10);
//   await SunmiPrinter.cutPaper();
// }
//
// Future<void> printAllTransactions({
//   required bool isPrintAll,
//   required List<SvnUtilityTransaction> transactions,
//   required TransactionsDateRange dateRange,
// }) async {
//   final tUtility = SvnUtility.i.transactionManager.utility;
//   await printSummaryHeader(isPrintAll: isPrintAll, dateRange: dateRange, transactionList: transactions);
//
//   // --- PRINT TRANSACTIONS SECTION ---
//   if(isPrintAll== true){
//     await SunmiPrinter.printText("   ");
//     await printDottedLine();
//     await printLine(
//       parseSingleLineText(AppStrings.transactions.toUpperCase()),
//       center: true,
//     );
//     await printDottedLine(4);
//     await SunmiPrinter.lineWrap(10);
//     await printLine(parseSingleLineText("REFERENCE"), center: true, bold: false);
//
//     await printColumn("TRANSACTION TYPE", "AMOUNT");
//     await printColumn("DATE-TIME", "DATE-TIME");
//     await printColumn("TRANSACTION ID", "STATUS");
//     await printColumn("AUTH CODE", "AUTH REFERENCE");
//     await printDottedLine();
//     await SunmiPrinter.lineWrap(10);
//
//     for (final transaction in transactions) {
//       final amount = tUtility.getTransDisplayAmount(transaction: transaction);
//       final dateTime = tUtility.getTransDisplayDate(
//         transDate: transaction.dateTime ?? "",
//       );
//       final status = transaction.approved == "1"
//           ? AppStrings.approved.toUpperCase()
//           : AppStrings.failed.toUpperCase();
//
//       await printColumn(AppStrings.payment, amount);
//       await printColumn(AppStrings.dateTime, dateTime);
//       await printColumn(transaction.transactionId ?? "-", status);
//       await printColumn(
//         transaction.authorizationCode ?? "-",
//         transaction.authorizationReference ?? "-",
//       );
//
//     }
//   }
//
//   await printDottedLine();
//   await printLine(parseSingleLineText("END"), center: true, bold: false);
//   await printDottedLine();
//   await SunmiPrinter.lineWrap(10);
//   await SunmiPrinter.cutPaper();
// }
//
// // Updated print helper functions for Sunmi printer
// Future<void> printLine(
//   String text, {
//   bool center = false,
//   bool bold = true,
// }) async {
//   if (text.isEmpty) return;
//   await SunmiPrinter.printText(
//     text,
//     style: SunmiTextStyle(
//       fontSize: 25,
//       align: center ? SunmiPrintAlign.CENTER : SunmiPrintAlign.LEFT,
//       bold: bold,
//     ),
//   );
// }
//
// String parseSingleLineText(String text) {
//   const int maxLength = 32;
//   if (text.length <= maxLength) return text;
//   // If text exceeds max length, trim it and add ellipsis
//   return '${text.substring(0, maxLength - 3)}...';
// }
//
// Future<void> printDottedLine([int spacing = 10]) async {
//   if (spacing > 0) await SunmiPrinter.lineWrap(spacing);
//   SunmiPrinter.printText(
//     '......................................',
//     style: SunmiTextStyle(
//       fontSize: 20,
//       align: SunmiPrintAlign.LEFT,
//       bold: false,
//     ),
//   );
//   if (spacing > 0) await SunmiPrinter.lineWrap(spacing);
// }
//
// Future<void> printSolidLine([int spacing = 10]) async {
//   await SunmiPrinter.lineWrap(spacing);
//   SunmiPrinter.line(type: 'SOLID');
//   await SunmiPrinter.lineWrap(spacing);
// }
//
// Future<void> printColumn(
//   String label,
//   String value, {
//   SunmiTextStyle? style,
//   bool amountValue = false,
// }) async {
//   // Check if label or value is empty
//   if (label.isEmpty && value.isEmpty) {
//     return;
//   }
//
//   int lineWidth = amountValue
//       ? 29
//       : 32; // Adjust the width for increased amount text
//
//   // Ensure label and value aren't too long
//   String parsedLabel = parseSingleLineText(label);
//   String parsedValue = parseSingleLineText(value);
//
//   // Calculate the space between label and value
//   int spaceCount = lineWidth - parsedLabel.length - parsedValue.length;
//   spaceCount = spaceCount > 0 ? spaceCount : 1;
//
//   // Create the formatted line with proper spacing
//   String formattedLine = '$parsedLabel${' ' * spaceCount}$parsedValue';
//   await SunmiPrinter.printText(formattedLine, style: style);
// }
//
// // Helper function to get image from asset
// Future<Uint8List> getImageFromAsset(String assetPath) async {
//   final ByteData data = await rootBundle.load(assetPath);
//   return data.buffer.asUint8List();
// }
