// To parse this JSON data, do
//
//     final currencyStore = currencyStoreFromJson(jsonString);

import 'dart:convert';

CurrencyStore currencyStoreFromJson(String str) => CurrencyStore.fromJson(json.decode(str));

String currencyStoreToJson(CurrencyStore data) => json.encode(data.toJson());

class CurrencyStore {
  String? code;
  String? name;
  String? alphaCode;
  String? symbol;
  String? precision;
  String? merchantId;
  String? terminalId;
  String? floorLimit;
  String? ceilingLimit;
  String? contactlessNoPinLimit;
  String? contactlessLimit;
  String? cashbackLimit;
  String? tellerBalance;

  CurrencyStore({
    this.code,
    this.name,
    this.alphaCode,
    this.symbol,
    this.precision,
    this.merchantId,
    this.terminalId,
    this.floorLimit,
    this.ceilingLimit,
    this.contactlessNoPinLimit,
    this.contactlessLimit,
    this.cashbackLimit,
    this.tellerBalance,
  });

  CurrencyStore copyWith({
    String? code,
    String? name,
    String? alphaCode,
    String? symbol,
    String? precision,
    String? merchantId,
    String? terminalId,
    String? floorLimit,
    String? ceilingLimit,
    String? contactlessNoPinLimit,
    String? contactlessLimit,
    String? cashbackLimit,
    String? tellerBalance,
  }) =>
      CurrencyStore(
        code: code ?? this.code,
        name: name ?? this.name,
        alphaCode: alphaCode ?? this.alphaCode,
        symbol: symbol ?? this.symbol,
        precision: precision ?? this.precision,
        merchantId: merchantId ?? this.merchantId,
        terminalId: terminalId ?? this.terminalId,
        floorLimit: floorLimit ?? this.floorLimit,
        ceilingLimit: ceilingLimit ?? this.ceilingLimit,
        contactlessNoPinLimit: contactlessNoPinLimit ?? this.contactlessNoPinLimit,
        contactlessLimit: contactlessLimit ?? this.contactlessLimit,
        cashbackLimit: cashbackLimit ?? this.cashbackLimit,
        tellerBalance: tellerBalance ?? this.tellerBalance,
      );

  factory CurrencyStore.fromJson(Map<String, dynamic> json) => CurrencyStore(
    code: json["Code"],
    name: json["Name"],
    alphaCode: json["AlphaCode"],
    symbol: json["Symbol"],
    precision: json["Precision"],
    merchantId: json["MerchantID"],
    terminalId: json["TerminalID"],
    floorLimit: json["FloorLimit"],
    ceilingLimit: json["CeilingLimit"],
    contactlessNoPinLimit: json["ContactlessNoPINLimit"],
    contactlessLimit: json["ContactlessLimit"],
    cashbackLimit: json["CashbackLimit"],
    tellerBalance: json["TellerBalance"],
  );

  Map<String, dynamic> toJson() => {
    "Code": code,
    "Name": name,
    "AlphaCode": alphaCode,
    "Symbol": symbol,
    "Precision": precision,
    "MerchantID": merchantId,
    "TerminalID": terminalId,
    "FloorLimit": floorLimit,
    "CeilingLimit": ceilingLimit,
    "ContactlessNoPINLimit": contactlessNoPinLimit,
    "ContactlessLimit": contactlessLimit,
    "CashbackLimit": cashbackLimit,
    "TellerBalance": tellerBalance,
  };
}
