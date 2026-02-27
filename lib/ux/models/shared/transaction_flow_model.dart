// To parse this JSON data, do
//
//     final transactionFlow = transactionFlowFromJson(jsonString);

import 'dart:convert';

TransactionFlow transactionFlowFromJson(String str) => TransactionFlow.fromJson(json.decode(str));

String transactionFlowToJson(TransactionFlow data) => json.encode(data.toJson());

class TransactionFlow {
    String? transactionAmount;
   String? phoneNumber;
   String? nationalID;
   String? transactionType;

  TransactionFlow({
    this.transactionAmount,
    this.phoneNumber,
    this.nationalID,
    this.transactionType,
  });

  TransactionFlow copyWith({
    String? transactionAmount,
    String? phoneNumber,
    String? nationalID,
    String? transactionType,
  }) =>
      TransactionFlow(
        transactionAmount: transactionAmount ?? this.transactionAmount,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        nationalID: nationalID ?? this.nationalID,
        transactionType: transactionType ?? this.transactionType,
      );

  factory TransactionFlow.fromJson(Map<String, dynamic> json) => TransactionFlow(
    transactionAmount: json["transactionAmount"],
    phoneNumber: json["phoneNumber"],
    nationalID: json["nationalID"],
    transactionType: json["transactionType"],
  );

  Map<String, dynamic> toJson() => {
    "transactionAmount": transactionAmount,
    "phoneNumber": phoneNumber,
    "nationalID": nationalID,
    "transactionType": transactionType,
  };
}
