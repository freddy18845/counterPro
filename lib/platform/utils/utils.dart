import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../ux/Providers/transaction_provider.dart';
import '../../ux/models/screens/home/flow_item.dart';
import '../../ux/models/screens/transactions/summary_item.dart';
import '../../ux/models/shared/transaction.dart';
import '../../ux/models/terminal_sign_on_response.dart';
import '../../ux/res/app_strings.dart';
import '../../ux/utils/api_reponse_code.dart';
import 'constant.dart';

/// API based time
String parseDateTime2(DateTime date) =>
    DateFormat("yyyyMMddHHmmss").format(date);

/// Generate "TransactionID" value
String getTransactionID(String transactionDate) {
  // Constants
  const String dateFormat = "yyyyMMddHHmmss";
  const int idLength = 12;
  const String alphabet = "0123456789";

  String uniqueTxnID = "";
  DateTime txnDateTime;

  // Parse the transactionDate or use the current date and time if parsing fails
  try {
    txnDateTime = DateFormat(dateFormat).parse(transactionDate);
  } catch (e) {
    txnDateTime = DateTime.now();
  }

  // Generate the unique ID in the format ydddHHmmss01
  int year = txnDateTime.year % 10;
  String dayOfYear = txnDateTime
      .difference(DateTime(txnDateTime.year))
      .inDays
      .toString()
      .padLeft(3, '0');
  String hour = txnDateTime.hour.toString().padLeft(2, '0');
  String minute = txnDateTime.minute.toString().padLeft(2, '0');
  String second = txnDateTime.second.toString().padLeft(2, '0');

  uniqueTxnID = "$year$dayOfYear$hour$minute$second";

  // Add random digits to make the ID 12 characters long
  Random random = Random();
  while (uniqueTxnID.length < idLength) {
    uniqueTxnID += alphabet[random.nextInt(alphabet.length)];
  }

  return uniqueTxnID;
}

String getCurrentFormattedDateTime() {
  DateTime now = DateTime.now();
  String formattedDate =
      "${now.year}"
      "${now.month.toString().padLeft(2, '0')}"
      "${now.day.toString().padLeft(2, '0')}"
      "${now.hour.toString().padLeft(2, '0')}"
      "${now.minute.toString().padLeft(2, '0')}"
      "${now.second.toString().padLeft(2, '0')}";

  return formattedDate;
}

List<String> supportPOsManufacturers = [
  'sunmi', // Include Sunmi in the list
  'pax',
  'mobigo',
  'wizarpos',
  'nearex', // Example of other manufacturers you may want to check
];
// List of manufacturers to check
List<String> pOsWithPrinter = ['P2_SE'];

final Map<String, dynamic> accessLevelMapping = {
  '0': 'No Permissions',
  '1': 'Teller',
  '2': 'Authorizer',
  '3': 'Administrator',
};
String getAccessLevelDescription(String level) {
  return accessLevelMapping[level] ?? 'Unknown';
}

final Map<String, dynamic> accountStatusMapping = {
  'N': 'New Account',
  'R': 'Reset',
  '0': 'Disabled',
  '1': 'Active',
};
final Map<String, Color> accountStatusColorMapping = {
  'N': Colors.grey,
  'R': Colors.red,
  '0': Colors.red,
  '1': Colors.green,
};

String getAccountStatusDescription(String status) {
  return accountStatusMapping[status] ?? 'Unknown Status';
}

Color getAccountStatusColor(String status) {
  return accountStatusColorMapping[status] ?? Colors.grey;
}

String getResponseText(String code) {
  final match = responseCodes.firstWhere(
    (item) => item["code"] == code,
    orElse: () => {"code": code, "text": "Unknown Response"},
  );
  return match["text"]!;
}

String getTransPan({required TransactionData transaction}) {
  String pan = "";
  if (transaction.tenderType == '03') {
    pan = "QR";
  } else if (transaction.tenderType == '01') {
    pan = (transaction.pan ?? "").toMaskedString();
  } else {
    pan = transaction.pan ?? "";
  }
  return pan;
}

/// Retrieves the color representing the transaction status.
///
/// Returns a color based on the transaction's response code and reversal status.
///
/// .
Color getTransColor({required TransactionData transaction}) {
  if ((transaction.responseCode == '00') && (transaction.reversed == "0")) {
    return const Color.fromRGBO(47, 161, 52, 1);
  } else if (transaction.responseCode != '00') {
    return const Color.fromRGBO(213, 38, 7, 1).withAlpha(200);
  } else if ((transaction.responseCode == '00') &&
      (transaction.reversed == "1")) {
    return Colors.grey;
  } else {
    return const Color.fromRGBO(47, 161, 52, 1);
  }
}

/// Retrieves the human-readable tender type for a transaction.
///
/// Converts the numeric tender type code to a descriptive string.
///
/// .
String getTransTender({required transaction}) {
  String tender = "";
  switch (transaction.tenderType) {
    case '01':
      tender = AppStrings.card;
      break;
    case '02':
      tender = AppStrings.wallet;
      break;
    default:
      tender = AppStrings.qrCode;
  }
  return tender;
}

/// Retrieves the currency symbol for a given currency code.
///
/// Returns the symbol from the accepted currencies list.
///
///

/// Calculates a summary of transactions.
///
/// Returns a list containing the count and total amount for specified transactions.
///
/// .
List getTransSummary({
  required List<TransactionData> transactions,
  required Currency currency,
  required String transactionType,
}) {
  int count = 0;
  double total = 0;
  for (int b = 0; b < transactions.length; b++) {
    if ((transactions[b].tenderType == transactionType) &&
        (transactions[b].currency == currency.code) &&
        transIsApprovedAndNotReversed(transaction: transactions[b])) {
      count += 1;
      total += double.parse(transactions[b].transactionAmount ?? "0");
    }
  }
  return [count, total];
}

/// Gets the approval status string for a transaction.
///
/// Returns "Approved" if `approved` is "1", "Declined" otherwise.
/// If `reversed` is "1", it returns "Void".
///
/// .

List<TransactionsSummaryItem> buildTransSummary({
  required List<Currency> currencies,
  required List<TransactionData> transactions,
}) {
  List<TransactionsSummaryItem> summaryItems = [];

  for (Currency currency in currencies) {
    TransactionsSummaryItem summaryItem = TransactionsSummaryItem(
      currency: currency,
    );

    // Skip if subs is empty or missing
    if (summaryItem.subs.isEmpty) continue;

    for (int a = 0; a < summaryItem.subs.length; a++) {
      final sub = summaryItem.subs[a];

      if (sub.title == AppStrings.card) {
        final result = getTransSummary(
          transactions: transactions,
          currency: currency,
          transactionType: '01',
        );
        sub.count = result.isNotEmpty ? result[0] ?? 0 : 0;
        sub.amountTotal = result.length > 1 ? result[1] ?? 0.0 : 0.0;
      } else if (sub.title == AppStrings.wallet) {
        final result = getTransSummary(
          transactions: transactions,
          currency: currency,
          transactionType: '02',
        );
        sub.count = result.isNotEmpty ? result[0] ?? 0 : 0;
        sub.amountTotal = result.length > 1 ? result[1] ?? 0.0 : 0.0;
      } else if (sub.title == AppStrings.qrCode) {
        final result = getTransSummary(
          transactions: transactions,
          currency: currency,
          transactionType: '03',
        );
        sub.count = result.isNotEmpty ? result[0] ?? 0 : 0;
        sub.amountTotal = result.length > 1 ? result[1] ?? 0.0 : 0.0;
      } else {
        // Safely compute totals (only if we have at least 3 sub-items)
        if (summaryItem.subs.length >= 3) {
          final totalCount =
              (summaryItem.subs[0].count ?? 0) +
              (summaryItem.subs[1].count ?? 0) +
              (summaryItem.subs[2].count ?? 0);
          final totalAmount =
              (summaryItem.subs[0].amountTotal ?? 0.0) +
              (summaryItem.subs[1].amountTotal ?? 0.0) +
              (summaryItem.subs[2].amountTotal ?? 0.0);

          sub.count = totalCount;
          sub.amountTotal = totalAmount;
        } else {
          sub.count = 0;
          sub.amountTotal = 0.0;
        }
      }
    }

    summaryItems.add(summaryItem);
  }

  return summaryItems;
}

String getTransAmount({required TransactionData transaction}) {
  int decimalPlaces = 2;
  List<Currency> availableCurrencies = TransactionManager().currencies ?? [];
  for (Currency currency in availableCurrencies) {
    if (currency.code == transaction.currency) {
      decimalPlaces = int.parse(currency.precision);
      break;
    }
  }
  double total = double.parse(transaction.transactionAmount ?? "");
  return total.toAmountString(decimalCount: decimalPlaces);
}

String getCashBackAmount({required TransactionData transaction}) {
  int decimalPlaces = 2;
  List<Currency> availableCurrencies = TransactionManager().currencies ?? [];
  for (Currency currency in availableCurrencies) {
    if (currency.code == transaction.currency) {
      decimalPlaces = int.parse(currency.precision);
      break;
    }
  }
  double total = double.parse(transaction.cashBackAmount ?? "");
  return total.toAmountString(decimalCount: decimalPlaces);
}

/// Gets the formatted transaction amount with currency symbol.
///
DateTime apiToDartDate(String date) {
  String value = date;
  return DateTime(
    int.parse(value.substring(0, 4)),
    int.parse(value.substring(4, 6)),
    int.parse(value.substring(6, 8)),
    int.parse(value.substring(8, 10)),
    int.parse(value.substring(10, 12)),
    int.parse(value.substring(12, 14)),
  );
}

String toApiDateString(DateTime date) {
  DateTime value = date;
  return DateFormat("yyyyMMddHHmmss").format(value);
}

String toDisplayDateString(DateTime date) {
  DateTime value = date;
  String month = DateFormat("MMMM").format(value).substring(0, 3);
  String year = DateFormat("yyyy").format(value).substring(2, 4);
  return "${DateFormat("dd-").format(value)}$month-$year${DateFormat(" HH:mm").format(value)}";
}

String getTransDisplayDate({required String transDate}) {
  return transDate.toApiDate().toDisplayDateString();
}

DateTime? tryParseDate(String? raw) {
  if (raw == null || raw.isEmpty) return null;

  try {
    return DateTime.parse(raw); // works for ISO strings
  } catch (_) {
    try {
      return DateFormat("yyyyMMddHHmmss").parse(raw);
    } catch (_) {
      return null;
    }
  }
}

// <HomeFlowItem> options
String getTransTypeText({required TransactionData transaction}) {
  String text = "";
  for (int a = 0; a < ConstantUtil.options.length; a++) {
    if ((ConstantUtil.options[a].trsType == transaction.transactionType)) {
      text = ConstantUtil.options[a].text;
      break;
    }
  }
  return text;
}

String getTransCardNetwork({required TransactionData transaction}) {
  List<String> names = (transaction.receivingNetworkName ?? "").split("-");
  if (names.length <= 1) return transaction.receivingNetworkName ?? "";
  return names[1].trim();
}

bool transIsApprovedAndNotReversed({required TransactionData transaction}) {
  return (((transaction.responseCode ?? "") == '00') &&
      ((transaction.reversed ?? "") == "0"));
}

/// Checks if a transaction PAN matches a read PAN.
///
/// Handles wildcard `*` in [transPan] for partial matches.
///
/// .
bool isTransPanMatchRead({required String transPan, required String readPan}) {
  transPan = transPan.replaceAll(RegExp(r"\s"), "");
  readPan = readPan.replaceAll(RegExp(r"\s"), "");
  if (!transPan.contains("*")) return transPan == readPan;
  String splitter = transPan
      .replaceAll(RegExp(r"[0-9]"), "")
      .replaceAll(RegExp(r"\s"), "");
  List<String> parts = transPan.split(splitter);
  if (parts.length <= 1) {
    return readPan.startsWith(parts[0].trim());
  }
  return readPan.startsWith(parts[0].trim()) &&
      readPan.endsWith(parts[1].trim());
}

extension DateTimeFormatting on DateTime {
  String toDisplayDateString() {
    String month = DateFormat("MMMM").format(this).substring(0, 3);
    String year = DateFormat("yyyy").format(this).substring(2, 4);
    return "${DateFormat("dd-").format(this)}$month-$year${DateFormat(" HH:mm").format(this)}";
  }

  String toApiDateString() {
    return DateFormat("yyyyMMddHHmmss").format(this);
  }
}

extension MaskedStringExtension on String {
  String toMaskedString() {
    String value = this;
    if (value.trim().isEmpty) return value;
    if (value.contains("*")) return value;
    value = value.replaceAll(" ", "");
    List<String> parts = value
        .replaceAllMapped(RegExp(r".{1,4}"), (match) => "${match.group(0)!} ")
        .trim()
        .split(" ");
    if (parts.length < 4) {
      String last = value.substring(value.length - 4);
      return last.padLeft(value.length, "*");
    }
    for (int a = 0; a < parts.length; a++) {
      if ((a == 1) || (a == 2)) {
        parts[a] = parts[a].replaceAll(RegExp(r"\d"), "*");
      }
    }
    return parts.join(" ");
  }

  DateTime toApiDate() {
    return DateTime(
      int.parse(substring(0, 4)),
      int.parse(substring(4, 6)),
      int.parse(substring(6, 8)),
      int.parse(substring(8, 10)),
      int.parse(substring(10, 12)),
      int.parse(substring(12, 14)),
    );
  }

  String capitalizeFirstLetter() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

/// Capitalizes the first letter of the string.
///
/// Returns the string with its first letter capitalized.
/// Returns the original string if empty.
///
/// .

  String getTransactionAccountOrPan({required HomeFlowItem data}) {
  if (data.paymentType.label == AppStrings.wallet) {
    return data.pan;
  } else if (
      data.paymentType.label == AppStrings.account) {
    return data.senderAccount;
  } else if (
      data.paymentType.label == AppStrings.p2p) {
    return data.senderAccount;
  } else if (data.paymentType.label == AppStrings.card) {
    return  formatCardNumber(data.pan);
  } else {
    return 'N/A';
  }
}
 String formatCardNumber(String? cardNumber) {
if (cardNumber == null || cardNumber.isEmpty) return "**** **** **** ****";
if (cardNumber.length <= 8) return cardNumber; // Too short to mask

String first4 = cardNumber.substring(0, 4);
String last4 = cardNumber.substring(cardNumber.length - 4);
return "$first4 **** **** $last4";
}
extension DoubleExtensions on double {
  String roundAsString({int decimalCount = 2}) {
    return toStringAsFixed(decimalCount);
  }

  String toAmountString({int decimalCount = 2}) {
    String result = roundAsString(decimalCount: decimalCount);
    return result.replaceAllMapped(
      RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"),
      (Match m) => "${m[1]},",
    );
  }
}
