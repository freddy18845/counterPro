// To parse this JSON data, do
//
//     final userData = userDataFromJson(jsonString);

import 'dart:convert';

UserData userDataFromJson(String str) => UserData.fromJson(json.decode(str));

String userDataToJson(UserData data) => json.encode(data.toJson());

class UserData {
  String? signOnId;
  String? pin;
  String? fullName;
  String? businessId;
  String? merchantName;
  String? merchantLocation;
  String? outletId;
  String? outletName;

  UserData({
    this.signOnId,
    this.pin,
    this.fullName,
    this.businessId,
    this.merchantName,
    this.merchantLocation,
    this.outletId,
    this.outletName,
  });

  UserData copyWith({
    String? signOnId,
    String? pin,
    String? fullName,
    String? businessId,
    String? merchantName,
    String? merchantLocation,
    String? outletId,
    String? outletName,
  }) =>
      UserData(
        signOnId: signOnId ?? this.signOnId,
        pin: pin ?? this.pin,
        fullName: fullName ?? this.fullName,
        businessId: businessId ?? this.businessId,
        merchantName: merchantName ?? this.merchantName,
        merchantLocation: merchantLocation ?? this.merchantLocation,
        outletId: outletId ?? this.outletId,
        outletName: outletName ?? this.outletName,
      );

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
    signOnId: json["signOnID"],
    pin: json["pin"],
    fullName: json["fullName"],
    businessId: json["BusinessID"],
    merchantName: json["merchantName"],
    merchantLocation: json["merchantLocation"],
    outletId: json["OutletID"],
    outletName: json["OutletName"],
  );

  Map<String, dynamic> toJson() => {
    "signOnID": signOnId,
    "pin": pin,
    "fullName": fullName,
    "BusinessID": businessId,
    "merchantName": merchantName,
    "merchantLocation": merchantLocation,
    "OutletID": outletId,
    "OutletName": outletName,
  };
}
