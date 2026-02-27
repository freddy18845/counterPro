import 'dart:convert';
//
// class TransactionQueryHeader {
//   final String countryCode;
//   final String acquiringNetworkID;
//   final String acquiringNetworkName;
//   final String receivingNetworkID;
//   final String receivingNetworkName;
//   final String businessID;
//   final String merchantName;
//   final String merchantLocation;
//   final String merchantCategoryCode;
//   final String outletID;
//   final String outletName;
//   final String deviceID;
//   final String deviceSerialNo;
//   final String terminalType;
//   final String panEntryMode;
//   final String pinEntryCapability;
//   final String posConditionCode;
//   final String tellerID;
//   final String tellerName;
//   final String geoPositionalData;
//
//   TransactionQueryHeader({
//     required this.countryCode,
//     required this.acquiringNetworkID,
//     required this.acquiringNetworkName,
//     required this.receivingNetworkID,
//     required this.receivingNetworkName,
//     required this.businessID,
//     required this.merchantName,
//     required this.merchantLocation,
//     required this.merchantCategoryCode,
//     required this.outletID,
//     required this.outletName,
//     required this.deviceID,
//     required this.deviceSerialNo,
//     required this.terminalType,
//     required this.panEntryMode,
//     required this.pinEntryCapability,
//     required this.posConditionCode,
//     required this.tellerID,
//     required this.tellerName,
//     required this.geoPositionalData,
//   });
//
//   factory TransactionQueryHeader.fromJson(Map<String, dynamic> json) => TransactionQueryHeader(
//     countryCode: json["CountryCode"],
//     acquiringNetworkID: json["AcquiringNetworkID"],
//     acquiringNetworkName: json["AcquiringNetworkName"],
//     receivingNetworkID: json["ReceivingNetworkID"],
//     receivingNetworkName: json["ReceivingNetworkName"],
//     businessID: json["BusinessID"],
//     merchantName: json["MerchantName"],
//     merchantLocation: json["MerchantLocation"],
//     merchantCategoryCode: json["MerchantCategoryCode"],
//     outletID: json["OutletID"],
//     outletName: json["OutletName"],
//     deviceID: json["DeviceID"],
//     deviceSerialNo: json["DeviceSerialNo"],
//     terminalType: json["TerminalType"],
//     panEntryMode: json["PANEntryMode"],
//     pinEntryCapability: json["PINEntryCapability"],
//     posConditionCode: json["POSConditionCode"],
//     tellerID: json["TellerID"],
//     tellerName: json["TellerName"],
//     geoPositionalData: json["GeoPositionalData"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "CountryCode": countryCode,
//     "AcquiringNetworkID": acquiringNetworkID,
//     "AcquiringNetworkName": acquiringNetworkName,
//     "ReceivingNetworkID": receivingNetworkID,
//     "ReceivingNetworkName": receivingNetworkName,
//     "BusinessID": businessID,
//     "MerchantName": merchantName,
//     "MerchantLocation": merchantLocation,
//     "MerchantCategoryCode": merchantCategoryCode,
//     "OutletID": outletID,
//     "OutletName": outletName,
//     "DeviceID": deviceID,
//     "DeviceSerialNo": deviceSerialNo,
//     "TerminalType": terminalType,
//     "PANEntryMode": panEntryMode,
//     "PINEntryCapability": pinEntryCapability,
//     "POSConditionCode": posConditionCode,
//     "TellerID": tellerID,
//     "TellerName": tellerName,
//     "GeoPositionalData": geoPositionalData,
//   };
// }
//
// class QueryDateRange {
//   final String startDate;
//   final String endDate;
//
//   QueryDateRange({
//     required this.startDate,
//     required this.endDate,
//   });
//
//   factory QueryDateRange.fromJson(Map<String, dynamic> json) => QueryDateRange(
//     startDate: json["StartDate"],
//     endDate: json["EndDate"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "StartDate": startDate,
//     "EndDate": endDate,
//   };
// }
//
// class TransactionQueryRequest {
//   final TransactionQueryHeader header;
//   final String messageType;
//   final String dataManagementCode;
//   final String dateTime;
//   final String transactionID;
//   final QueryDateRange query;
//   final String mac;
//
//   TransactionQueryRequest({
//     required this.header,
//     required this.messageType,
//     required this.dataManagementCode,
//     required this.dateTime,
//     required this.transactionID,
//     required this.query,
//     required this.mac,
//   });
//
//   factory TransactionQueryRequest.fromRawJson(String str) =>
//       TransactionQueryRequest.fromJson(json.decode(str));
//
//   String toRawJson() => json.encode(toJson());
//
//   factory TransactionQueryRequest.fromJson(Map<String, dynamic> json) => TransactionQueryRequest(
//     header: TransactionQueryHeader.fromJson(json["Header"]),
//     messageType: json["MessageType"],
//     dataManagementCode: json["DataManagementCode"],
//     dateTime: json["DateTime"],
//     transactionID: json["TransactionID"],
//     query: QueryDateRange.fromJson(json["Query"]),
//     mac: json["MAC"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "Header": header.toJson(),
//     "MessageType": messageType,
//     "DataManagementCode": dataManagementCode,
//     "DateTime": dateTime,
//     "TransactionID": transactionID,
//     "Query": query.toJson(),
//     "MAC": mac,
//   };
// }

import 'dart:convert';

class TransactionQueryHeader {
  final String countryCode;
  final String acquiringNetworkID;
  final String acquiringNetworkName;
  final String receivingNetworkID;
  final String receivingNetworkName;
  final String businessID;
  final String merchantName;
  final String merchantLocation;
  final String merchantCategoryCode;
  final String outletID;
  final String outletName;
  final String deviceID;
  final String deviceSerialNo;
  final String terminalType;
  final String panEntryMode;
  final String pinEntryCapability;
  final String posConditionCode;
  final String tellerID;
  final String tellerName;
  final String geoPositionalData;

  TransactionQueryHeader({
    required this.countryCode,
    required this.acquiringNetworkID,
    required this.acquiringNetworkName,
    required this.receivingNetworkID,
    required this.receivingNetworkName,
    required this.businessID,
    required this.merchantName,
    required this.merchantLocation,
    required this.merchantCategoryCode,
    required this.outletID,
    required this.outletName,
    required this.deviceID,
    required this.deviceSerialNo,
    required this.terminalType,
    required this.panEntryMode,
    required this.pinEntryCapability,
    required this.posConditionCode,
    required this.tellerID,
    required this.tellerName,
    required this.geoPositionalData,
  });

  factory TransactionQueryHeader.fromJson(Map<String, dynamic> json) => TransactionQueryHeader(
    countryCode: json["CountryCode"],
    acquiringNetworkID: json["AcquiringNetworkID"],
    acquiringNetworkName: json["AcquiringNetworkName"],
    receivingNetworkID: json["ReceivingNetworkID"],
    receivingNetworkName: json["ReceivingNetworkName"],
    businessID: json["BusinessID"],
    merchantName: json["MerchantName"],
    merchantLocation: json["MerchantLocation"],
    merchantCategoryCode: json["MerchantCategoryCode"],
    outletID: json["OutletID"],
    outletName: json["OutletName"],
    deviceID: json["DeviceID"],
    deviceSerialNo: json["DeviceSerialNo"],
    terminalType: json["TerminalType"],
    panEntryMode: json["PANEntryMode"],
    pinEntryCapability: json["PINEntryCapability"],
    posConditionCode: json["POSConditionCode"],
    tellerID: json["TellerID"],
    tellerName: json["TellerName"],
    geoPositionalData: json["GeoPositionalData"],
  );

  Map<String, dynamic> toJson() => {
    "CountryCode": countryCode,
    "AcquiringNetworkID": acquiringNetworkID,
    "AcquiringNetworkName": acquiringNetworkName,
    "ReceivingNetworkID": receivingNetworkID,
    "ReceivingNetworkName": receivingNetworkName,
    "BusinessID": businessID,
    "MerchantName": merchantName,
    "MerchantLocation": merchantLocation,
    "MerchantCategoryCode": merchantCategoryCode,
    "OutletID": outletID,
    "OutletName": outletName,
    "DeviceID": deviceID,
    "DeviceSerialNo": deviceSerialNo,
    "TerminalType": terminalType,
    "PANEntryMode": panEntryMode,
    "PINEntryCapability": pinEntryCapability,
    "POSConditionCode": posConditionCode,
    "TellerID": tellerID,
    "TellerName": tellerName,
    "GeoPositionalData": geoPositionalData,
  };
}

class QueryDateRange {
  final String startDate;
  final String endDate;

  QueryDateRange({
    required this.startDate,
    required this.endDate,
  });

  factory QueryDateRange.fromJson(Map<String, dynamic> json) => QueryDateRange(
    startDate: json["StartDate"],
    endDate: json["EndDate"],
  );

  Map<String, dynamic> toJson() => {
    "StartDate": startDate,
    "EndDate": endDate,
  };
}

class TransactionQueryRequest {
  final TransactionQueryHeader header;
  final String messageType;
  final String dataManagementCode;
  final String dateTime;
  final String transactionID;
  final QueryDateRange query;
  final String mac;

  TransactionQueryRequest({
    required this.header,
    required this.messageType,
    required this.dataManagementCode,
    required this.dateTime,
    required this.transactionID,
    required this.query,
    required this.mac,
  });

  factory TransactionQueryRequest.fromRawJson(String str) =>
      TransactionQueryRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TransactionQueryRequest.fromJson(Map<String, dynamic> json) => TransactionQueryRequest(
    header: TransactionQueryHeader.fromJson(json["Header"]),
    messageType: json["MessageType"],
    dataManagementCode: json["DataManagementCode"],
    dateTime: json["DateTime"],
    transactionID: json["TransactionID"],
    query: QueryDateRange.fromJson(json["Query"]),
    mac: json["MAC"],
  );

  Map<String, dynamic> toJson() => {
    "Header": header.toJson(),
    "MessageType": messageType,
    "DataManagementCode": dataManagementCode,
    "DateTime": dateTime,
    "TransactionID": transactionID,
    "Query": query.toJson(),
    "MAC": mac,
  };
}
