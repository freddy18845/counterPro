// To parse this JSON data, do
//
//     final activationRequestData = activationRequestDataFromJson(jsonString);

import 'dart:convert';

ActivationRequestData activationRequestDataFromJson(String str) => ActivationRequestData.fromJson(json.decode(str));

String activationRequestDataToJson(ActivationRequestData data) => json.encode(data.toJson());

class ActivationRequestData {
  Header? header;
  String? messageType;
  String? dateTime;
  String? transactionId;
  String? networkManagementCode;
  String? mac;

  ActivationRequestData({
    this.header,
    this.messageType,
    this.dateTime,
    this.transactionId,
    this.networkManagementCode,
    this.mac,
  });

  ActivationRequestData copyWith({
    Header? header,
    String? messageType,
    String? dateTime,
    String? transactionId,
    String? networkManagementCode,
    String? mac,
  }) =>
      ActivationRequestData(
        header: header ?? this.header,
        messageType: messageType ?? this.messageType,
        dateTime: dateTime ?? this.dateTime,
        transactionId: transactionId ?? this.transactionId,
        networkManagementCode: networkManagementCode ?? this.networkManagementCode,
        mac: mac ?? this.mac,
      );

  factory ActivationRequestData.fromJson(Map<String, dynamic> json) => ActivationRequestData(
    header: json["Header"] == null ? null : Header.fromJson(json["Header"]),
    messageType: json["MessageType"],
    dateTime: json["DateTime"],
    transactionId: json["TransactionID"],
    networkManagementCode: json["NetworkManagementCode"],
    mac: json["MAC"],
  );

  Map<String, dynamic> toJson() => {
    "Header": header?.toJson(),
    "MessageType": messageType,
    "DateTime": dateTime,
    "TransactionID": transactionId,
    "NetworkManagementCode": networkManagementCode,
    "MAC": mac,
  };
}

class Header {
  String? countryCode;
  String? acquiringNetworkId;
  String? businessId;
  String? outletId;
  String? outletName;
  String? deviceId;
  String? deviceSerialNo;
  String? terminalType;
  String? applicationName;
  String? tellerId;
  String? tellerName;
  String? geoPositionalData;

  Header({
    this.countryCode,
    this.acquiringNetworkId,
    this.businessId,
    this.outletId,
    this.outletName,
    this.deviceId,
    this.deviceSerialNo,
    this.terminalType,
    this.applicationName,
    this.tellerId,
    this.tellerName,
    this.geoPositionalData,
  });

  Header copyWith({
    String? countryCode,
    String? acquiringNetworkId,
    String? businessId,
    String? outletId,
    String? outletName,
    String? deviceId,
    String? deviceSerialNo,
    String? terminalType,
    String? applicationName,
    String? tellerId,
    String? tellerName,
    String? geoPositionalData,
  }) =>
      Header(
        countryCode: countryCode ?? this.countryCode,
        acquiringNetworkId: acquiringNetworkId ?? this.acquiringNetworkId,
        businessId: businessId ?? this.businessId,
        outletId: outletId ?? this.outletId,
        outletName: outletName ?? this.outletName,
        deviceId: deviceId ?? this.deviceId,
        deviceSerialNo: deviceSerialNo ?? this.deviceSerialNo,
        terminalType: terminalType ?? this.terminalType,
        applicationName: applicationName ?? this.applicationName,
        tellerId: tellerId ?? this.tellerId,
        tellerName: tellerName ?? this.tellerName,
        geoPositionalData: geoPositionalData ?? this.geoPositionalData,
      );

  factory Header.fromJson(Map<String, dynamic> json) => Header(
    countryCode: json["CountryCode"],
    acquiringNetworkId: json["AcquiringNetworkID"],
    businessId: json["BusinessID"],
    outletId: json["OutletID"],
    outletName: json["OutletName"],
    deviceId: json["DeviceID"],
    deviceSerialNo: json["DeviceSerialNo"],
    terminalType: json["TerminalType"],
    applicationName: json["ApplicationName"],
    tellerId: json["TellerID"],
    tellerName: json["TellerName"],
    geoPositionalData: json["GeoPositionalData"],
  );

  Map<String, dynamic> toJson() => {
    "CountryCode": countryCode,
    "AcquiringNetworkID": acquiringNetworkId,
    "BusinessID": businessId,
    "OutletID": outletId,
    "OutletName": outletName,
    "DeviceID": deviceId,
    "DeviceSerialNo": deviceSerialNo,
    "TerminalType": terminalType,
    "ApplicationName": applicationName,
    "TellerID": tellerId,
    "TellerName": tellerName,
    "GeoPositionalData": geoPositionalData,
  };
}
