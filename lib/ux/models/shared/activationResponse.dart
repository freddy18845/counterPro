// // To parse this JSON data, do
// //
// //     final activationResponseData = activationResponseDataFromJson(jsonString);
//
// import 'dart:convert';
//
// ActivationResponseData activationResponseDataFromJson(String str) => ActivationResponseData.fromJson(json.decode(str));
//
// String activationResponseDataToJson(ActivationResponseData data) => json.encode(data.toJson());
//
// class ActivationResponseData {
//   Header? header;
//   String? messageType;
//   String? dateTime;
//   String? transactionId;
//   String? networkManagementCode;
//   String? responseCode;
//   String? responseText;
//   String? mac;
//
//   ActivationResponseData({
//     this.header,
//     this.messageType,
//     this.dateTime,
//     this.transactionId,
//     this.networkManagementCode,
//     this.responseCode,
//     this.responseText,
//     this.mac,
//   });
//
//   ActivationResponseData copyWith({
//     Header? header,
//     String? messageType,
//     String? dateTime,
//     String? transactionId,
//     String? networkManagementCode,
//     String? responseCode,
//     String? responseText,
//     String? mac,
//   }) =>
//       ActivationResponseData(
//         header: header ?? this.header,
//         messageType: messageType ?? this.messageType,
//         dateTime: dateTime ?? this.dateTime,
//         transactionId: transactionId ?? this.transactionId,
//         networkManagementCode: networkManagementCode ?? this.networkManagementCode,
//         responseCode: responseCode ?? this.responseCode,
//         responseText: responseText ?? this.responseText,
//         mac: mac ?? this.mac,
//       );
//
//   factory ActivationResponseData.fromJson(Map<String, dynamic> json) => ActivationResponseData(
//     header: json["Header"] == null ? null : Header.fromJson(json["Header"]),
//     messageType: json["MessageType"],
//     dateTime: json["DateTime"],
//     transactionId: json["TransactionID"],
//     networkManagementCode: json["NetworkManagementCode"],
//     responseCode: json["ResponseCode"],
//     responseText: json["ResponseText"],
//     mac: json["MAC"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "Header": header?.toJson(),
//     "MessageType": messageType,
//     "DateTime": dateTime,
//     "TransactionID": transactionId,
//     "NetworkManagementCode": networkManagementCode,
//     "ResponseCode": responseCode,
//     "ResponseText": responseText,
//     "MAC": mac,
//   };
// }
//
// class Header {
//   String? countryCode;
//   String? acquiringNetworkId;
//   String? businessId;
//   String? outletId;
//   String? outletName;
//   String? deviceId;
//   String? terminalType;
//
//   Header({
//     this.countryCode,
//     this.acquiringNetworkId,
//     this.businessId,
//     this.outletId,
//     this.outletName,
//     this.deviceId,
//     this.terminalType,
//   });
//
//   Header copyWith({
//     String? countryCode,
//     String? acquiringNetworkId,
//     String? businessId,
//     String? outletId,
//     String? outletName,
//     String? deviceId,
//     String? terminalType,
//   }) =>
//       Header(
//         countryCode: countryCode ?? this.countryCode,
//         acquiringNetworkId: acquiringNetworkId ?? this.acquiringNetworkId,
//         businessId: businessId ?? this.businessId,
//         outletId: outletId ?? this.outletId,
//         outletName: outletName ?? this.outletName,
//         deviceId: deviceId ?? this.deviceId,
//         terminalType: terminalType ?? this.terminalType,
//       );
//
//   factory Header.fromJson(Map<String, dynamic> json) => Header(
//     countryCode: json["CountryCode"],
//     acquiringNetworkId: json["AcquiringNetworkID"],
//     businessId: json["BusinessID"],
//     outletId: json["OutletID"],
//     outletName: json["OutletName"],
//     deviceId: json["DeviceID"],
//     terminalType: json["TerminalType"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "CountryCode": countryCode,
//     "AcquiringNetworkID": acquiringNetworkId,
//     "BusinessID": businessId,
//     "OutletID": outletId,
//     "OutletName": outletName,
//     "DeviceID": deviceId,
//     "TerminalType": terminalType,
//   };
// }
