import 'dart:convert';

DeviceData deviceDataFromJson(String str) => DeviceData.fromJson(json.decode(str));

String deviceDataToJson(DeviceData data) => json.encode(data.toJson());

class DeviceData {
  String deviceSerialNum;
  String deviceModel;
  String deviceId;

  DeviceData({
    required this.deviceSerialNum,
    required this.deviceModel,
    required this.deviceId,
  });

  factory DeviceData.fromJson(Map<String, dynamic> json) => DeviceData(
    deviceSerialNum: json["deviceSerialNum"],
    deviceModel: json["deviceModel"],
    deviceId: json["deviceID"],
  );

  Map<String, dynamic> toJson() => {
    "deviceSerialNum": deviceSerialNum,
    "deviceModel": deviceModel,
    "deviceID": deviceId,
  };
}