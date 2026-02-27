import 'dart:convert';

class TransactionQueryResponseHeader {
  final String countryCode;
  final String acquiringNetworkID;
  final String acquiringNetworkName;
  final String businessID;
  final String merchantName;
  final String merchantLocation;
  final String outletID;
  final String outletName;
  final String deviceID;
  final String terminalType;
  final String tellerID;
  final String tellerName;

  TransactionQueryResponseHeader({
    required this.countryCode,
    required this.acquiringNetworkID,
    required this.acquiringNetworkName,
    required this.businessID,
    required this.merchantName,
    required this.merchantLocation,
    required this.outletID,
    required this.outletName,
    required this.deviceID,
    required this.terminalType,
    required this.tellerID,
    required this.tellerName,
  });

  factory TransactionQueryResponseHeader.fromJson(Map<String, dynamic> json) =>
      TransactionQueryResponseHeader(
        countryCode: json["CountryCode"],
        acquiringNetworkID: json["AcquiringNetworkID"],
        acquiringNetworkName: json["AcquiringNetworkName"],
        businessID: json["BusinessID"],
        merchantName: json["MerchantName"],
        merchantLocation: json["MerchantLocation"],
        outletID: json["OutletID"],
        outletName: json["OutletName"],
        deviceID: json["DeviceID"],
        terminalType: json["TerminalType"],
        tellerID: json["TellerID"],
        tellerName: json["TellerName"],
      );

  Map<String, dynamic> toJson() => {
    "CountryCode": countryCode,
    "AcquiringNetworkID": acquiringNetworkID,
    "AcquiringNetworkName": acquiringNetworkName,
    "BusinessID": businessID,
    "MerchantName": merchantName,
    "MerchantLocation": merchantLocation,
    "OutletID": outletID,
    "OutletName": outletName,
    "DeviceID": deviceID,
    "TerminalType": terminalType,
    "TellerID": tellerID,
    "TellerName": tellerName,
  };
}

class QueryDateRange {
  final String startDate;
  final String endDate;

  QueryDateRange({required this.startDate, required this.endDate});

  factory QueryDateRange.fromJson(Map<String, dynamic> json) =>
      QueryDateRange(startDate: json["StartDate"], endDate: json["EndDate"]);

  Map<String, dynamic> toJson() => {"StartDate": startDate, "EndDate": endDate};
}

class TransactionQueryResponse {
  final TransactionQueryResponseHeader header;
  final String messageType;
  final String dateTime;
  final String transactionID;
  final String dataManagementCode;
  final QueryDateRange query;
  final String responseCode;
  final String responseText;
  final List<Map<String, dynamic>> queryResult;
  final String mac;

  TransactionQueryResponse({
    required this.header,
    required this.messageType,
    required this.dateTime,
    required this.transactionID,
    required this.dataManagementCode,
    required this.query,
    required this.responseCode,
    required this.responseText,
    required this.queryResult,
    required this.mac,
  });

  factory TransactionQueryResponse.fromRawJson(String str) =>
      TransactionQueryResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TransactionQueryResponse.fromJson(Map<String, dynamic> json) => TransactionQueryResponse(
    header: TransactionQueryResponseHeader.fromJson(json["Header"]),
    messageType: json["MessageType"],
    dateTime: json["DateTime"],
    transactionID: json["TransactionID"],
    dataManagementCode: json["DataManagementCode"],
    query: QueryDateRange.fromJson(json["Query"]),
    responseCode: json["ResponseCode"],
    responseText: json["ResponseText"],
    queryResult: List<Map<String, dynamic>>.from(json["QueryResult"]),
    mac: json["MAC"],
  );

  Map<String, dynamic> toJson() => {
    "Header": header.toJson(),
    "MessageType": messageType,
    "DateTime": dateTime,
    "TransactionID": transactionID,
    "DataManagementCode": dataManagementCode,
    "Query": query.toJson(),
    "ResponseCode": responseCode,
    "ResponseText": responseText,
    "QueryResult": queryResult,
    "MAC": mac,
  };
}

