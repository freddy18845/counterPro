// // To parse this JSON data, do
// //
// //     final currentUserData = currentUserDataFromJson(jsonString);
//
// import 'dart:convert';
//
// CurrentUserData currentUserDataFromJson(String str) => CurrentUserData.fromJson(json.decode(str));
//
// String currentUserDataToJson(CurrentUserData data) => json.encode(data.toJson());
//
// class CurrentUserData {
//   String? tellerId;
//   String? tellerName;
//   String? accesslevel;
//
//   CurrentUserData({
//     this.tellerId,
//     this.tellerName,
//     this.accesslevel,
//   });
//
//   CurrentUserData copyWith({
//     String? tellerId,
//     String? tellerName,
//     String? accesslevel,
//   }) =>
//       CurrentUserData(
//         tellerId: tellerId ?? this.tellerId,
//         tellerName: tellerName ?? this.tellerName,
//         accesslevel: accesslevel ?? this.accesslevel,
//       );
//
//   factory CurrentUserData.fromJson(Map<String, dynamic> json) => CurrentUserData(
//     tellerId: json["TellerID"],
//     tellerName: json["TellerName"],
//     accesslevel: json["Accesslevel"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "TellerID": tellerId,
//     "TellerName": tellerName,
//     "Accesslevel": accesslevel,
//   };
// }
