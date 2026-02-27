import 'dart:convert';

import 'sign_on_response_header.dart';
import 'sign_on_userinfo.dart';

class UserSignOnResponse {
  final SignOnResponseHeader header;
  final String messageType;
  final String dateTime;
  final String transactionID;
  final String networkManagementCode;
  final String responseCode;
  final String responseText;
  final SignOnUserInfo? userInfo;
  final String? securityToken;
  final String? tokenValidityPeriod;
  final String mac;

  UserSignOnResponse({
    required this.header,
    required this.messageType,
    required this.dateTime,
    required this.transactionID,
    required this.networkManagementCode,
    required this.responseCode,
    required this.responseText,
    required this.userInfo,
    required this.securityToken,
    required this.tokenValidityPeriod,
    required this.mac,
  });

  factory UserSignOnResponse.fromRawJson(String source) =>
      UserSignOnResponse.fromJson(json.decode(source) as Map<String, dynamic>);

  String toRawJson() => json.encode(toJson());

  factory UserSignOnResponse.fromJson(Map<String, dynamic> json) {
    return UserSignOnResponse(
      header: SignOnResponseHeader.fromJson(json['Header']),
      messageType: json['MessageType'],
      dateTime: json['DateTime'],
      transactionID: json['TransactionID'],
      networkManagementCode: json['NetworkManagementCode'],
      responseCode: json['ResponseCode'],
      responseText: json['ResponseText'],
      userInfo: json['UserInfo'] != null ? SignOnUserInfo.fromJson(json['UserInfo']) : null,
      securityToken: json['SecurityToken'] ?? '',
      tokenValidityPeriod: json['TokenValidityPeriod'] ?? '',
      mac: json['MAC'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Header': header.toJson(),
      'MessageType': messageType,
      'DateTime': dateTime,
      'TransactionID': transactionID,
      'NetworkManagementCode': networkManagementCode,
      'ResponseCode': responseCode,
      'ResponseText': responseText,
      'UserInfo': userInfo?.toJson(),
      'SecurityToken': securityToken,
      'TokenValidityPeriod': tokenValidityPeriod,
      'MAC': mac,
    };
  }
}
