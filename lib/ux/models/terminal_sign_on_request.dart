import 'dart:convert';

class TerminalSignOnRequest {
  TerminalSignOnRequestHeader header;
  String messageType;
  String dateTime;
  String transactionID;
  String networkManagementCode;
  String mac;

  TerminalSignOnRequest({
    required this.header,
    required this.messageType,
    required this.dateTime,
    required this.transactionID,
    required this.networkManagementCode,
    required this.mac,
  });

  factory TerminalSignOnRequest.fromRawJson(String str) =>
      TerminalSignOnRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TerminalSignOnRequest.fromJson(Map<String, dynamic> json) => TerminalSignOnRequest(
        header: TerminalSignOnRequestHeader.fromJson(json['Header']),
        messageType: json['MessageType'],
        dateTime: json['DateTime'],
        transactionID: json['TransactionID'],
        networkManagementCode: json['NetworkManagementCode'],
        mac: json['MAC'],
      );

  Map<String, dynamic> toJson() => {
        'Header': header.toJson(),
        'MessageType': messageType,
        'DateTime': dateTime,
        'TransactionID': transactionID,
        'NetworkManagementCode': networkManagementCode,
        'MAC': mac,
      };
}

class TerminalSignOnRequestHeader {
  String countryCode;
  String acquiringNetworkID;
  String businessID;
  String outletID;
  String deviceID;
  String deviceSerialNo;
  String terminalType;
  String applicationName;
  String geoPositionalData;

  TerminalSignOnRequestHeader({
    required this.countryCode,
    required this.acquiringNetworkID,
    required this.businessID,
    required this.outletID,
    required this.deviceID,
    required this.deviceSerialNo,
    required this.terminalType,
    required this.applicationName,
    required this.geoPositionalData,
  });

  factory TerminalSignOnRequestHeader.fromJson(Map<String, dynamic> json) =>
      TerminalSignOnRequestHeader(
        countryCode: json['CountryCode'],
        acquiringNetworkID: json['AcquiringNetworkID'],
        businessID: json['BusinessID'],
        outletID: json['OutletID'],
        deviceID: json['DeviceID'],
        deviceSerialNo: json['DeviceSerialNo'],
        terminalType: json['TerminalType'],
        applicationName: json['ApplicationName'],
        geoPositionalData: json['GeoPositionalData'],
      );

  Map<String, dynamic> toJson() => {
        'CountryCode': countryCode,
        'AcquiringNetworkID': acquiringNetworkID,
        'BusinessID': businessID,
        'DeviceID': deviceID,
        'OutletID': outletID,
        'DeviceSerialNo': deviceSerialNo,
        'TerminalType': terminalType,
        'ApplicationName': applicationName,
        'GeoPositionalData': geoPositionalData,
      };
}

// {
// "Header":
// {
// "CountryCode": "288",
// "AcquiringNetworkID": "606804",
// "BusinessID": "BID2024001",
// "OutletID": "S001",
// "DeviceID": "A01F2000E881",
// "DeviceSerialNo": "S/N3502-99010-01",
// "TerminalType": "01",
// "ApplicationName": "SmartPay v1.04",
// "GeoPositionalData": "-6.821000,39.276505"
// },
// "MessageType": "0800",
// "DateTime": "20240728201425",
// "TransactionID": "427117020301",
// "NetworkManagementCode": "004",
// "MAC": ""
// }
