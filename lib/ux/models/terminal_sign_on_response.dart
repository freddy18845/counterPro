import 'dart:convert';

import 'sign_on_response_header.dart';
import 'sign_on_userinfo.dart';

class TerminalSignOnResponse {
  final SignOnResponseHeader header;
  final String messageType;
  final String dateTime;
  final String transactionID;
  final String networkManagementCode;
  final String responseCode;
  final String responseText;
  final SignOnUserInfo? userInfo;
  Currency? currency1;
  Currency? currency2;
  AIDs? aids;
  IINs? iins;
  String? allowMagStripe;
  String? allowExpiredCards;
  String? pinRequired;
  String? allowOfflineAuth;
  String? transactionTimeOut;
  String? keepAliveInterval;
  String? pinEncryptionKey;
  String? pinKeyCheckValue;
  String? macEncryptionKey;
  String? macKeyCheckValue;
  final String? securityToken;
  final String? tokenValidityPeriod;
  final String mac;

  TerminalSignOnResponse({
    required this.header,
    required this.messageType,
    required this.dateTime,
    required this.transactionID,
    required this.networkManagementCode,
    required this.responseCode,
    required this.responseText,
    required this.userInfo,
    this.currency1,
    this.currency2,
    this.aids,
    this.iins,
    this.allowMagStripe,
    this.allowExpiredCards,
    this.pinRequired,
    this.allowOfflineAuth,
    this.transactionTimeOut,
    this.keepAliveInterval,
    this.pinEncryptionKey,
    this.pinKeyCheckValue,
    this.macEncryptionKey,
    this.macKeyCheckValue,
    required this.securityToken,
    required this.tokenValidityPeriod,
    required this.mac,
  });

  factory TerminalSignOnResponse.fromRawJson(String str) =>
      TerminalSignOnResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TerminalSignOnResponse.fromJson(Map<String, dynamic> json) => TerminalSignOnResponse(
    header: SignOnResponseHeader.fromJson(json["Header"]),
    messageType: json["MessageType"],
    dateTime: json["DateTime"],
    transactionID: json["TransactionID"],
    networkManagementCode: json["NetworkManagementCode"],
    responseCode: json["ResponseCode"],
    responseText: json["ResponseText"],
    userInfo: json['UserInfo'] != null ? SignOnUserInfo.fromJson(json['UserInfo']) : null,
    currency1: json["Currency1"] != null ? Currency.fromJson(json["Currency1"]) : null,
    currency2: json["Currency2"] != null ? Currency.fromJson(json["Currency2"]) : null,
    aids: json["AIDs"] != null ? AIDs.fromJson(json["AIDs"]) : null,
    iins: json["IINs"] != null ? IINs.fromJson(json["IINs"]) : null,
    allowMagStripe: json["AllowMagStripe"] ?? '',
    allowExpiredCards: json["AllowExpiredCards"] ?? '',
    pinRequired: json["PINRequired"] ?? '',
    allowOfflineAuth: json["AllowOfflineAuth"] ?? '',
    transactionTimeOut: json["TransactionTimeOut"] ?? '',
    keepAliveInterval: json["KeepAliveInterval"] ?? '',
    pinEncryptionKey: json["PINEncryptionKey"] ?? '',
    pinKeyCheckValue: json["PINKeyCheckValue"] ?? '',
    macEncryptionKey: json["MACEncryptionKey"] ?? '',
    macKeyCheckValue: json["MACKeyCheckValue"] ?? '',
    securityToken: json["SecurityToken"] ?? '',
    tokenValidityPeriod: json["TokenValidityPeriod"] ?? '',
    mac: json["MAC"],
  );

  Map<String, dynamic> toJson() => {
    "Header": header.toJson(),
    "MessageType": messageType,
    "DateTime": dateTime,
    "TransactionID": transactionID,
    "NetworkManagementCode": networkManagementCode,
    "ResponseCode": responseCode,
    "ResponseText": responseText,
    'UserInfo': userInfo?.toJson(),
    "Currency1": currency1?.toJson(),
    "Currency2": currency2?.toJson(),
    "AIDs": aids?.toJson(),
    "IINs": iins?.toJson(),
    "AllowMagStripe": allowMagStripe,
    "AllowExpiredCards": allowExpiredCards,
    "PINRequired": pinRequired,
    "AllowOfflineAuth": allowOfflineAuth,
    "TransactionTimeOut": transactionTimeOut,
    "KeepAliveInterval": keepAliveInterval,
    "PINEncryptionKey": pinEncryptionKey,
    "PINKeyCheckValue": pinKeyCheckValue,
    "MACEncryptionKey": macEncryptionKey,
    "MACKeyCheckValue": macKeyCheckValue,
    "SecurityToken": securityToken,
    "TokenValidityPeriod": tokenValidityPeriod,
    "MAC": mac,
  };
}

class Currency {
  final String code;
  final String name;
  final String alphaCode;
  final String symbol;
  final String precision;
  final String merchantID;
  final String terminalID;
  final String floorLimit;
  final String ceilingLimit;
  final String contactlessNoPinLimit;
  final String contactlessLimit;
  final String cashbackLimit;

  Currency({
    required this.code,
    required this.name,
    required this.alphaCode,
    required this.symbol,
    required this.precision,
    required this.merchantID,
    required this.terminalID,
    required this.floorLimit,
    required this.ceilingLimit,
    required this.contactlessNoPinLimit,
    required this.contactlessLimit,
    required this.cashbackLimit,
  });

  factory Currency.fromJson(Map<String, dynamic> json) => Currency(
    code: json["Code"],
    name: json["Name"],
    alphaCode: json["AlphaCode"],
    symbol: json["Symbol"],
    precision: json["Precision"],
    merchantID: json["MerchantID"],
    terminalID: json["TerminalID"],
    floorLimit: json["FloorLimit"],
    ceilingLimit: json["CeilingLimit"],
    contactlessNoPinLimit: json["ContactlessNoPINLimit"],
    contactlessLimit: json["ContactlessLimit"],
    cashbackLimit: json["CashbackLimit"],
  );

  Map<String, dynamic> toJson() => {
    "Code": code,
    "Name": name,
    "AlphaCode": alphaCode,
    "Symbol": symbol,
    "Precision": precision,
    "MerchantID": merchantID,
    "TerminalID": terminalID,
    "FloorLimit": floorLimit,
    "CeilingLimit": ceilingLimit,
    "ContactlessNoPINLimit": contactlessNoPinLimit,
    "ContactlessLimit": contactlessLimit,
    "CashbackLimit": cashbackLimit,
  };
}

class AIDs {
  final String allowAllAIDs;
  final String aidList;
  final String promptAIDSelection;

  AIDs({required this.allowAllAIDs, required this.aidList, required this.promptAIDSelection});

  factory AIDs.fromJson(Map<String, dynamic> json) => AIDs(
    allowAllAIDs: json["AllowAllAIDs"],
    aidList: json["AIDList"],
    promptAIDSelection: json["PromptAIDSelection"],
  );

  Map<String, dynamic> toJson() => {
    "AllowAllAIDs": allowAllAIDs,
    "AIDList": aidList,
    "PromptAIDSelection": promptAIDSelection,
  };
}

class IINs {
  final String allowAllIINs;
  final String iinList;

  IINs({required this.allowAllIINs, required this.iinList});

  factory IINs.fromJson(Map<String, dynamic> json) =>
      IINs(allowAllIINs: json["AllowAllIINs"], iinList: json["IINList"]);

  Map<String, dynamic> toJson() => {"AllowAllIINs": allowAllIINs, "IINList": iinList};
}
