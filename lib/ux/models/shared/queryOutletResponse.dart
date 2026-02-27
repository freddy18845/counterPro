// To parse this JSON data, do
//
//     final outletQueryResponse = outletQueryResponseFromJson(jsonString);

import 'dart:convert';

OutletQueryResponse outletQueryResponseFromJson(String str) => OutletQueryResponse.fromJson(json.decode(str));

String outletQueryResponseToJson(OutletQueryResponse data) => json.encode(data.toJson());

class OutletQueryResponse {
  Header? header;
  String? messageType;
  String? dateTime;
  String? transactionId;
  String? networkManagementCode;
  String? responseCode;
  String? responseText;
  List<QueryResult>? queryResult;
  String? mac;

  OutletQueryResponse({
    this.header,
    this.messageType,
    this.dateTime,
    this.transactionId,
    this.networkManagementCode,
    this.responseCode,
    this.responseText,
    this.queryResult,
    this.mac,
  });

  OutletQueryResponse copyWith({
    Header? header,
    String? messageType,
    String? dateTime,
    String? transactionId,
    String? networkManagementCode,
    String? responseCode,
    String? responseText,
    List<QueryResult>? queryResult,
    String? mac,
  }) =>
      OutletQueryResponse(
        header: header ?? this.header,
        messageType: messageType ?? this.messageType,
        dateTime: dateTime ?? this.dateTime,
        transactionId: transactionId ?? this.transactionId,
        networkManagementCode: networkManagementCode ?? this.networkManagementCode,
        responseCode: responseCode ?? this.responseCode,
        responseText: responseText ?? this.responseText,
        queryResult: queryResult ?? this.queryResult,
        mac: mac ?? this.mac,
      );

  factory OutletQueryResponse.fromJson(Map<String, dynamic> json) => OutletQueryResponse(
    header: json["Header"] == null ? null : Header.fromJson(json["Header"]),
    messageType: json["MessageType"],
    dateTime: json["DateTime"],
    transactionId: json["TransactionID"],
    networkManagementCode: json["NetworkManagementCode"],
    responseCode: json["ResponseCode"],
    responseText: json["ResponseText"],
    queryResult: json["QueryResult"] == null ? [] : List<QueryResult>.from(json["QueryResult"]!.map((x) => QueryResult.fromJson(x))),
    mac: json["MAC"],
  );

  Map<String, dynamic> toJson() => {
    "Header": header?.toJson(),
    "MessageType": messageType,
    "DateTime": dateTime,
    "TransactionID": transactionId,
    "NetworkManagementCode": networkManagementCode,
    "ResponseCode": responseCode,
    "ResponseText": responseText,
    "QueryResult": queryResult == null ? [] : List<dynamic>.from(queryResult!.map((x) => x.toJson())),
    "MAC": mac,
  };
}

class Header {
  String? countryCode;
  String? acquiringNetworkId;
  String? acquiringNetworkName;
  String? businessId;
  String? merchantName;
  String? merchantLocation;
  String? merchantCategoryCode;
  String? terminalType;

  Header({
    this.countryCode,
    this.acquiringNetworkId,
    this.acquiringNetworkName,
    this.businessId,
    this.merchantName,
    this.merchantLocation,
    this.merchantCategoryCode,
    this.terminalType,
  });

  Header copyWith({
    String? countryCode,
    String? acquiringNetworkId,
    String? acquiringNetworkName,
    String? businessId,
    String? merchantName,
    String? merchantLocation,
    String? merchantCategoryCode,
    String? terminalType,
  }) =>
      Header(
        countryCode: countryCode ?? this.countryCode,
        acquiringNetworkId: acquiringNetworkId ?? this.acquiringNetworkId,
        acquiringNetworkName: acquiringNetworkName ?? this.acquiringNetworkName,
        businessId: businessId ?? this.businessId,
        merchantName: merchantName ?? this.merchantName,
        merchantLocation: merchantLocation ?? this.merchantLocation,
        merchantCategoryCode: merchantCategoryCode ?? this.merchantCategoryCode,
        terminalType: terminalType ?? this.terminalType,
      );

  factory Header.fromJson(Map<String, dynamic> json) => Header(
    countryCode: json["CountryCode"],
    acquiringNetworkId: json["AcquiringNetworkID"],
    acquiringNetworkName: json["AcquiringNetworkName"],
    businessId: json["BusinessID"],
    merchantName: json["MerchantName"],
    merchantLocation: json["MerchantLocation"],
    merchantCategoryCode: json["MerchantCategoryCode"],
    terminalType: json["TerminalType"],
  );

  Map<String, dynamic> toJson() => {
    "CountryCode": countryCode,
    "AcquiringNetworkID": acquiringNetworkId,
    "AcquiringNetworkName": acquiringNetworkName,
    "BusinessID": businessId,
    "MerchantName": merchantName,
    "MerchantLocation": merchantLocation,
    "MerchantCategoryCode": merchantCategoryCode,
    "TerminalType": terminalType,
  };
}

class QueryResult {
  String? outletId;
  String? outletName;

  QueryResult({
    this.outletId,
    this.outletName,
  });

  QueryResult copyWith({
    String? outletId,
    String? outletName,
  }) =>
      QueryResult(
        outletId: outletId ?? this.outletId,
        outletName: outletName ?? this.outletName,
      );

  factory QueryResult.fromJson(Map<String, dynamic> json) => QueryResult(
    outletId: json["OutletID"],
    outletName: json["OutletName"],
  );

  Map<String, dynamic> toJson() => {
    "OutletID": outletId,
    "OutletName": outletName,
  };
}
