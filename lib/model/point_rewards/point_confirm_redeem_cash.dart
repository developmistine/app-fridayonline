// To parse this JSON data, do
//
//     final pointRedeemcash = pointRedeemcashFromJson(jsonString);

import 'dart:convert';

PointRedeemcash pointRedeemcashFromJson(String str) =>
    PointRedeemcash.fromJson(json.decode(str));

String pointRedeemcashToJson(PointRedeemcash data) =>
    json.encode(data.toJson());

class PointRedeemcash {
  String code;
  String message1;
  String message2;
  String message3;

  PointRedeemcash({
    required this.code,
    required this.message1,
    required this.message2,
    required this.message3,
  });

  factory PointRedeemcash.fromJson(Map<String, dynamic> json) =>
      PointRedeemcash(
        code: json["Code"],
        message1: json["Message1"],
        message2: json["Message2"],
        message3: json["Message3"],
      );

  Map<String, dynamic> toJson() => {
        "Code": code,
        "Message1": message1,
        "Message2": message2,
        "Message3": message3,
      };
}
