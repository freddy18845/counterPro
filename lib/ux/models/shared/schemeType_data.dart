
import 'dart:convert';

SchemeType schemeTypeFromJson(String str) => SchemeType.fromJson(json.decode(str));

String schemeTypeToJson(SchemeType data) => json.encode(data.toJson());

class SchemeType {
  final String icon;
  final String subtitle;
  final String text;
  final String code;
  final String forcePost;
  final String msgType;
  final String responseCode;

  SchemeType({
    required this.icon,
    required this.subtitle,
    required this.text,
    required this.code,
    required this.forcePost,
    required this.msgType,
    required this.responseCode,
  });

  SchemeType copyWith({
    String? icon,
    String? subtitle,
    String? text,
    String? code,
    String? forcePost,
    String? msgType,
    String? responseCode,
  }) =>
      SchemeType(
        icon: icon ?? this.icon,
        subtitle: subtitle ?? this.subtitle,
        text: text ?? this.text,
        code: code ?? this.code,
        forcePost: forcePost ?? this.forcePost,
        msgType: msgType ?? this.msgType,
        responseCode: responseCode ?? this.responseCode,
      );

  factory SchemeType.fromJson(Map<String, dynamic> json) => SchemeType(
    icon: json["icon"],
    subtitle: json["subtitle"],
    text: json["text"],
    code: json["code"],
    forcePost: json["forcePost"],
    msgType: json["msgType"],
    responseCode: json["responseCode"],
  );

  Map<String, dynamic> toJson() => {
    "icon": icon,
    "subtitle": subtitle,
    "text": text,
    "code": code,
    "forcePost": forcePost,
    "msgType": msgType,
    "responseCode": responseCode,
  };
}
