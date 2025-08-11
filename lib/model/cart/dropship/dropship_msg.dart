// To parse this JSON data, do
//
//     final dropshipMsg = dropshipMsgFromJson(jsonString);

// import 'package:meta/meta.dart';
import 'dart:convert';

DropshipMsg dropshipMsgFromJson(String str) =>
    DropshipMsg.fromJson(json.decode(str));

String dropshipMsgToJson(DropshipMsg data) => json.encode(data.toJson());

class DropshipMsg {
  DropshipMsg({
    required this.code,
    required this.message1,
    required this.message2,
    required this.message3,
  });

  String code;
  String message1;
  String message2;
  String message3;

  factory DropshipMsg.fromJson(Map<String, dynamic> json) => DropshipMsg(
        code: json["Code"] ?? "",
        message1: json["Message1"] ?? "",
        message2: json["Message2"] ?? "",
        message3: json["Message3"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "Code": code,
        "Message1": message1,
        "Message2": message2,
        "Message3": message3,
      };
}
