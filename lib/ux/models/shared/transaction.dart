// To parse this JSON data, do
//
//     final transactionData = transactionDataFromJson(jsonString);

import 'dart:convert';

TransactionData transactionDataFromJson(String str) => TransactionData.fromJson(json.decode(str));

String transactionDataToJson(TransactionData data) => json.encode(data.toJson());

class TransactionData {
  String? transactionNo;
  String? messageType;
  String? transactionType;
  String? dateTime;
  String? countryCode;
  String? receivingNetworkId;
  String? receivingNetworkName;
  String? merchantId;
  String? merchantName;
  String? merchantLocation;
  String? terminalId;
  String? tellerId;
  String? tellerName;
  String? transactionId;
  String? referenceInfo;
  String? tenderType;
  String? pan;
  String? currency;
  String? transactionAmount;
  String? cashBackAmount;
  String? transactionFee;
  String? account1;
  String? account2;
  String? responseCode;
  String? authorizationCode;
  String? authorizationReference;
  String? narration;
  String? approved;
  String? reversed;

  TransactionData({
    this.transactionNo,
    this.messageType,
    this.transactionType,
    this.dateTime,
    this.countryCode,
    this.receivingNetworkId,
    this.receivingNetworkName,
    this.merchantId,
    this.merchantName,
    this.merchantLocation,
    this.terminalId,
    this.tellerId,
    this.tellerName,
    this.transactionId,
    this.referenceInfo,
    this.tenderType,
    this.pan,
    this.currency,
    this.transactionAmount,
    this.cashBackAmount,
    this.transactionFee,
    this.account1,
    this.account2,
    this.responseCode,
    this.authorizationCode,
    this.authorizationReference,
    this.narration,
    this.approved,
    this.reversed,
  });

  TransactionData copyWith({
    String? transactionNo,
    String? messageType,
    String? transactionType,
    String? dateTime,
    String? countryCode,
    String? receivingNetworkId,
    String? receivingNetworkName,
    String? merchantId,
    String? merchantName,
    String? merchantLocation,
    String? terminalId,
    String? tellerId,
    String? tellerName,
    String? transactionId,
    String? referenceInfo,
    String? tenderType,
    String? pan,
    String? currency,
    String? transactionAmount,
    String? cashBackAmount,
    String? transactionFee,
    String? account1,
    String? account2,
    String? responseCode,
    String? authorizationCode,
    String? authorizationReference,
    String? narration,
    String? approved,
    String? reversed,
  }) =>
      TransactionData(
        transactionNo: transactionNo ?? this.transactionNo,
        messageType: messageType ?? this.messageType,
        transactionType: transactionType ?? this.transactionType,
        dateTime: dateTime ?? this.dateTime,
        countryCode: countryCode ?? this.countryCode,
        receivingNetworkId: receivingNetworkId ?? this.receivingNetworkId,
        receivingNetworkName: receivingNetworkName ?? this.receivingNetworkName,
        merchantId: merchantId ?? this.merchantId,
        merchantName: merchantName ?? this.merchantName,
        merchantLocation: merchantLocation ?? this.merchantLocation,
        terminalId: terminalId ?? this.terminalId,
        tellerId: tellerId ?? this.tellerId,
        tellerName: tellerName ?? this.tellerName,
        transactionId: transactionId ?? this.transactionId,
        referenceInfo: referenceInfo ?? this.referenceInfo,
        tenderType: tenderType ?? this.tenderType,
        pan: pan ?? this.pan,
        currency: currency ?? this.currency,
        transactionAmount: transactionAmount ?? this.transactionAmount,
        cashBackAmount: cashBackAmount ?? this.cashBackAmount,
        transactionFee: transactionFee ?? this.transactionFee,
        account1: account1 ?? this.account1,
        account2: account2 ?? this.account2,
        responseCode: responseCode ?? this.responseCode,
        authorizationCode: authorizationCode ?? this.authorizationCode,
        authorizationReference: authorizationReference ?? this.authorizationReference,
        narration: narration ?? this.narration,
        approved: approved ?? this.approved,
        reversed: reversed ?? this.reversed,
      );

  factory TransactionData.fromJson(Map<String, dynamic> json) => TransactionData(
    transactionNo: json["TransactionNo"],
    messageType: json["MessageType"],
    transactionType: json["TransactionType"],
    dateTime: json["DateTime"],
    countryCode: json["CountryCode"],
    receivingNetworkId: json["ReceivingNetworkID"],
    receivingNetworkName: json["ReceivingNetworkName"],
    merchantId: json["MerchantID"],
    merchantName: json["MerchantName"],
    merchantLocation: json["MerchantLocation"],
    terminalId: json["TerminalID"],
    tellerId: json["TellerID"],
    tellerName: json["TellerName"],
    transactionId: json["TransactionID"],
    referenceInfo: json["ReferenceInfo"],
    tenderType: json["TenderType"],
    pan: json["PAN"],
    currency: json["Currency"],
    transactionAmount: json["TransactionAmount"],
    cashBackAmount: json["CashBackAmount"],
    transactionFee: json["TransactionFee"],
    account1: json["Account1"],
    account2: json["Account2"],
    responseCode: json["ResponseCode"],
    authorizationCode: json["AuthorizationCode"],
    authorizationReference: json["AuthorizationReference"],
    narration: json["Narration"],
    approved: json["Approved"],
    reversed: json["Reversed"],
  );

  Map<String, dynamic> toJson() => {
    "TransactionNo": transactionNo,
    "MessageType": messageType,
    "TransactionType": transactionType,
    "DateTime": dateTime,
    "CountryCode": countryCode,
    "ReceivingNetworkID": receivingNetworkId,
    "ReceivingNetworkName": receivingNetworkName,
    "MerchantID": merchantId,
    "MerchantName": merchantName,
    "MerchantLocation": merchantLocation,
    "TerminalID": terminalId,
    "TellerID": tellerId,
    "TellerName": tellerName,
    "TransactionID": transactionId,
    "ReferenceInfo": referenceInfo,
    "TenderType": tenderType,
    "PAN": pan,
    "Currency": currency,
    "TransactionAmount": transactionAmount,
    "CashBackAmount": cashBackAmount,
    "TransactionFee": transactionFee,
    "Account1": account1,
    "Account2": account2,
    "ResponseCode": responseCode,
    "AuthorizationCode": authorizationCode,
    "AuthorizationReference": authorizationReference,
    "Narration": narration,
    "Approved": approved,
    "Reversed": reversed,
  };
}
