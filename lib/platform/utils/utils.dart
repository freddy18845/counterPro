// import 'dart:math';
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import '../../ux/Providers/transaction_provider.dart';
// import '../../ux/models/screens/home/flow_item.dart';
// import '../../ux/models/screens/transactions/summary_item.dart';
// import '../../ux/models/shared/transaction.dart';
// import '../../ux/models/terminal_sign_on_response.dart';
// import '../../ux/res/app_strings.dart';
// import '../../ux/utils/api_reponse_code.dart';
// import 'constant.dart';
//
// /// API based time
// String parseDateTime2(DateTime date) =>
//     DateFormat("yyyyMMddHHmmss").format(date);
//
// /// Generate "TransactionID" value
// String getTransactionID(String transactionDate) {
//   // Constants
//   const String dateFormat = "yyyyMMddHHmmss";
//   const int idLength = 12;
//   const String alphabet = "0123456789";
//
//   String uniqueTxnID = "";
//   DateTime txnDateTime;
//
//   // Parse the transactionDate or use the current date and time if parsing fails
//   try {
//     txnDateTime = DateFormat(dateFormat).parse(transactionDate);
//   } catch (e) {
//     txnDateTime = DateTime.now();
//   }
//
//   // Generate the unique ID in the format ydddHHmmss01
//   int year = txnDateTime.year % 10;
//   String dayOfYear = txnDateTime
//       .difference(DateTime(txnDateTime.year))
//       .inDays
//       .toString()
//       .padLeft(3, '0');
//   String hour = txnDateTime.hour.toString().padLeft(2, '0');
//   String minute = txnDateTime.minute.toString().padLeft(2, '0');
//   String second = txnDateTime.second.toString().padLeft(2, '0');
//
//   uniqueTxnID = "$year$dayOfYear$hour$minute$second";
//
//   // Add random digits to make the ID 12 characters long
//   Random random = Random();
//   while (uniqueTxnID.length < idLength) {
//     uniqueTxnID += alphabet[random.nextInt(alphabet.length)];
//   }
//
//   return uniqueTxnID;
// }
//
// String getCurrentFormattedDateTime() {
//   DateTime now = DateTime.now();
//   String formattedDate =
//       "${now.year}"
//       "${now.month.toString().padLeft(2, '0')}"
//       "${now.day.toString().padLeft(2, '0')}"
//       "${now.hour.toString().padLeft(2, '0')}"
//       "${now.minute.toString().padLeft(2, '0')}"
//       "${now.second.toString().padLeft(2, '0')}";
//
//   return formattedDate;
// }
//
// List<String> supportPOsManufacturers = [
//   'sunmi', // Include Sunmi in the list
//   'pax',
//   'mobigo',
//   'wizarpos',
//   'nearex', // Example of other manufacturers you may want to check
// ];
// // List of manufacturers to check
// List<String> pOsWithPrinter = ['P2_SE'];
//
// final Map<String, dynamic> accessLevelMapping = {
//   '0': 'No Permissions',
//   '1': 'Teller',
//   '2': 'Authorizer',
//   '3': 'Administrator',
// };
// String getAccessLevelDescription(String level) {
//   return accessLevelMapping[level] ?? 'Unknown';
// }
//
// final Map<String, dynamic> accountStatusMapping = {
//   'N': 'New Account',
//   'R': 'Reset',
//   '0': 'Disabled',
//   '1': 'Active',
// };
// final Map<String, Color> accountStatusColorMapping = {
//   'N': Colors.grey,
//   'R': Colors.red,
//   '0': Colors.red,
//   '1': Colors.green,
// };
//
// String getAccountStatusDescription(String status) {
//   return accountStatusMapping[status] ?? 'Unknown Status';
// }
//
// Color getAccountStatusColor(String status) {
//   return accountStatusColorMapping[status] ?? Colors.grey;
// }
//
// String getResponseText(String code) {
//   final match = responseCodes.firstWhere(
//     (item) => item["code"] == code,
//     orElse: () => {"code": code, "text": "Unknown Response"},
//   );
//   return match["text"]!;
// }
//
// String getTransPan({required TransactionData transaction}) {
//   String pan = "";
//   if (transaction.tenderType == '03') {
//     pan = "QR";
//   } else if (transaction.tenderType == '01') {
//     pan = (transaction.pan ?? "").toMaskedString();
//   } else {
//     pan = transaction.pan ?? "";
//   }
//   return pan;
// }
//
// /// Retrieves the color representing the transaction status.
// ///
// /// Returns a color based on the transaction's response code and reversal status.
// ///
// /// .
// Color getTransColor({required TransactionData transaction}) {
//   if ((transaction.responseCode == '00') && (transaction.reversed == "0")) {
//     return const Color.fromRGBO(47, 161, 52, 1);
//   } else if (transaction.responseCode != '00') {
//     return const Color.fromRGBO(213, 38, 7, 1).withAlpha(200);
//   } else if ((transaction.responseCode == '00') &&
//       (transaction.reversed == "1")) {
//     return Colors.grey;
//   } else {
//     return const Color.fromRGBO(47, 161, 52, 1);
//   }
// }
//
// /// Retrieves the human-readable tender type for a transaction.
// ///
// /// Converts the numeric tender type code to a descriptive string.
// ///
// /// .
// String getTransTender({required transaction}) {
//   String tender = "";
//   switch (transaction.tenderType) {
//     case '01':
//       tender = AppStrings.card;
//       break;
//     case '02':
//       tender = AppStrings.wallet;
//       break;
//     default:
//       tender = AppStrings.qrCode;
//   }
//   return tender;
// }
//
// /// Retrieves the currency symbol for a given currency code.
// ///
// /// Returns the symbol from the accepted currencies list.
// ///
// ///
//
// /// Calculates a summary of transactions.
// ///
// /// Returns a list containing the count and total amount for specified transactions.
// ///
// /// .
//
//
//
//
//
//
//
//
//
//
//
