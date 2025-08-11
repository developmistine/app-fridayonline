// To parse this JSON data, do
//
//     final resposecenter = resposecenterFromJson(jsonString);

import 'dart:convert';

Resposecenter resposecenterFromJson(String str) =>
    Resposecenter.fromJson(json.decode(str));

String resposecenterToJson(Resposecenter data) => json.encode(data.toJson());

class Resposecenter {
  String code;
  String message1;
  String message2;
  String message3;

  Resposecenter({
    required this.code,
    required this.message1,
    required this.message2,
    required this.message3,
  });

  factory Resposecenter.fromJson(Map<String, dynamic> json) => Resposecenter(
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
