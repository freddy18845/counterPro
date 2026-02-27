// To parse this JSON data, do
//
//     final outletData = outletDataFromJson(jsonString);

import 'dart:convert';

OutletData outletDataFromJson(String str) => OutletData.fromJson(json.decode(str));

String outletDataToJson(OutletData data) => json.encode(data.toJson());

class OutletData {
  String? outletId;
  String? outletName;

  OutletData({
    this.outletId,
    this.outletName,
  });

  OutletData copyWith({
    String? outletId,
    String? outletName,
  }) =>
      OutletData(
        outletId: outletId ?? this.outletId,
        outletName: outletName ?? this.outletName,
      );

  factory OutletData.fromJson(Map<String, dynamic> json) => OutletData(
    outletId: json["OutletID"],
    outletName: json["OutletName"],
  );

  Map<String, dynamic> toJson() => {
    "OutletID": outletId,
    "OutletName": outletName,
  };
}
