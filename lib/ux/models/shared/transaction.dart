import 'dart:convert';

TransactionData transactionDataFromJson(String str) =>
    TransactionData.fromJson(json.decode(str));

String transactionDataToJson(TransactionData data) =>
    json.encode(data.toJson());

class TransactionData {
  double? total;
  DateTime? dateTime;
  String? txnID;
  double? subtotal;
  double? tax;
  List<dynamic>? cart;

  TransactionData({
    this.total,
    this.dateTime,
    this.txnID,
    this.subtotal,
    this.tax,
    this.cart,
  });

  /// COPY WITH
  TransactionData copyWith({
    double? total,
    DateTime? dateTime,
    String? txnID,
    double? subtotal,
    double? tax,
    List<dynamic>? cart,
  }) {
    return TransactionData(
      total: total ?? this.total,
      dateTime: dateTime ?? this.dateTime,
      txnID: txnID ?? this.txnID,
      subtotal: subtotal ?? this.subtotal,
      tax: tax ?? this.tax, // ✅ FIXED (was wrong before)
      cart: cart ?? this.cart,
    );
  }

  /// FROM JSON
  factory TransactionData.fromJson(Map<String, dynamic> json) {
    return TransactionData(
      total: (json["total"] ?? json["TransactionAmount"])?.toDouble(),
      subtotal: (json["subtotal"])?.toDouble(),
      tax: (json["tax"])?.toDouble(),

      txnID: json["txnID"] ?? json["TransactionID"],

      dateTime: json["dateTime"] != null
          ? DateTime.tryParse(json["dateTime"])
          : json["DateTime"] != null
          ? DateTime.tryParse(json["DateTime"])
          : null,

      cart: json["cart"] ?? [],
    );
  }

  /// TO JSON
  Map<String, dynamic> toJson() {
    return {
      "total": total,
      "subtotal": subtotal,
      "tax": tax,
      "txnID": txnID,
      "dateTime": dateTime?.toIso8601String(),
      "cart": cart,
    };
  }
}