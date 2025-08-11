// To parse this JSON data, do
//
//     final delEus = delEusFromJson(jsonString);

// import 'package:meta/meta.dart';
import 'dart:convert';

DelEus delEusFromJson(String str) => DelEus.fromJson(json.decode(str));

String delEusToJson(DelEus data) => json.encode(data.toJson());

class DelEus {
  DelEus({
    required this.value,
  });

  Value value;

  factory DelEus.fromJson(Map<String, dynamic> json) => DelEus(
        value: Value.fromJson(json["Value"]),
      );

  Map<String, dynamic> toJson() => {
        "Value": value.toJson(),
      };
}

class Value {
  Value({
    required this.success,
    required this.description,
  });

  String success;
  Description description;

  factory Value.fromJson(Map<String, dynamic> json) => Value(
        success: json["success"] ?? "",
        description: Description.fromJson(json["Description"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "Description": description.toJson(),
      };
}

class Description {
  Description({
    required this.msg,
  });

  Msg msg;

  factory Description.fromJson(Map<String, dynamic> json) => Description(
        msg: Msg.fromJson(json["Msg"]),
      );

  Map<String, dynamic> toJson() => {
        "Msg": msg.toJson(),
      };
}

class Msg {
  Msg({
    required this.msgAlert1,
    required this.msgAlert2,
    required this.msgAlert3,
  });

  String msgAlert1;
  String msgAlert2;
  String msgAlert3;

  factory Msg.fromJson(Map<String, dynamic> json) => Msg(
        msgAlert1: json["MsgAlert1"] ?? "",
        msgAlert2: json["MsgAlert2"] ?? "",
        msgAlert3: json["MsgAlert3"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "MsgAlert1": msgAlert1,
        "MsgAlert2": msgAlert2,
        "MsgAlert3": msgAlert3,
      };
}
