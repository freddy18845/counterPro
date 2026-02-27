// To parse this JSON data, do
//
//     final UserRequest = UserRequestFromJson(jsonString);

import 'dart:convert';

UserRequest userRequestFromJson(String str) => UserRequest.fromJson(json.decode(str));

String userRequestToJson(UserRequest data) => json.encode(data.toJson());

class UserRequest {
  Header? header;
  String? messageType;
  String? dateTime;
  String? transactionId;
  String? networkManagementCode;
  String? mac;

  UserRequest({
    this.header,
    this.messageType,
    this.dateTime,
    this.transactionId,
    this.networkManagementCode,
    this.mac,
  });

  UserRequest copyWith({
    Header? header,
    String? messageType,
    String? dateTime,
    String? transactionId,
    String? networkManagementCode,
    String? mac,
  }) =>
      UserRequest(
        header: header ?? this.header,
        messageType: messageType ?? this.messageType,
        dateTime: dateTime ?? this.dateTime,
        transactionId: transactionId ?? this.transactionId,
        networkManagementCode: networkManagementCode ?? this.networkManagementCode,
        mac: mac ?? this.mac,
      );

  factory UserRequest.fromJson(Map<String, dynamic> json) => UserRequest(
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
  String? terminalType;

  Header({
    this.countryCode,
    this.acquiringNetworkId,
    this.businessId,
    this.terminalType,
  });

  Header copyWith({
    String? countryCode,
    String? acquiringNetworkId,
    String? businessId,
    String? terminalType,
  }) =>
      Header(
        countryCode: countryCode ?? this.countryCode,
        acquiringNetworkId: acquiringNetworkId ?? this.acquiringNetworkId,
        businessId: businessId ?? this.businessId,
        terminalType: terminalType ?? this.terminalType,
      );

  factory Header.fromJson(Map<String, dynamic> json) => Header(
    countryCode: json["CountryCode"],
    acquiringNetworkId: json["AcquiringNetworkID"],
    businessId: json["BusinessID"],
    terminalType: json["TerminalType"],
  );

  Map<String, dynamic> toJson() => {
    "CountryCode": countryCode,
    "AcquiringNetworkID": acquiringNetworkId,
    "BusinessID": businessId,
    "TerminalType": terminalType,
  };
}
