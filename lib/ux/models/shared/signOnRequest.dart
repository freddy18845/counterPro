import 'dart:convert';

class UserSignOnRequest {
  UserSignOnRequestHeader header;
  String messageType;
  String dateTime;
  String transactionID;
  String networkManagementCode;
  String mac;

  UserSignOnRequest({
    required this.header,
    required this.messageType,
    required this.dateTime,
    required this.transactionID,
    required this.networkManagementCode,
    required this.mac,
  });

  factory UserSignOnRequest.fromRawJson(String str) => UserSignOnRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserSignOnRequest.fromJson(Map<String, dynamic> json) => UserSignOnRequest(
    header: UserSignOnRequestHeader.fromJson(json['Header']),
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

class UserSignOnRequestHeader {
  String countryCode;
  String acquiringNetworkID;
  String businessID;
  String deviceID;
  String deviceSerialNo;
  String terminalType;
  String applicationName;
  String geoPositionalData;

  UserSignOnRequestHeader({
    required this.countryCode,
    required this.acquiringNetworkID,
    required this.businessID,
    required this.deviceID,
    required this.deviceSerialNo,
    required this.terminalType,
    required this.applicationName,
    required this.geoPositionalData,
  });

  factory UserSignOnRequestHeader.fromRawJson(String str) =>
      UserSignOnRequestHeader.fromJson(json.decode(str));

  factory UserSignOnRequestHeader.fromJson(Map<String, dynamic> json) => UserSignOnRequestHeader(
    countryCode: json['CountryCode'],
    acquiringNetworkID: json['AcquiringNetworkID'],
    businessID: json['BusinessID'],
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
    'DeviceSerialNo': deviceSerialNo,
    'TerminalType': terminalType,
    'ApplicationName': applicationName,
    'GeoPositionalData': geoPositionalData,
  };
}

// {
// "Header": {
// "CountryCode": "748",
// "AcquiringNetworkID": "770000",
// "BusinessID": "BID2024001",
// "OutletID": "S001",
// "DeviceID": "0969248827584d8e",
// "DeviceSerialNo": "PC01237X10186",
// "TerminalType": "01",
// "ApplicationName": "Eswatini v1.3.34",
// "GeoPositionalData": "-26.32611, 31.14389"
// },
// "MessageType": "0800",
// "TransactionType": "A0",
// "DateTime": "20241105161425",
// "TransactionID": "412322010201",
// "NetworkManagementCode": "003",
// "MAC": ""
// }
