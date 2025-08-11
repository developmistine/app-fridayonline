// To parse this JSON data, do
//
//     final checkotp = checkotpFromJson(jsonString);

// import 'package:meta/meta.dart';
import 'dart:convert';

Checkotp checkotpFromJson(String str) => Checkotp.fromJson(json.decode(str));

String checkotpToJson(Checkotp data) => json.encode(data.toJson());

class Checkotp {
  Checkotp({
    required this.values,
    required this.message,
    required this.custid,
    required this.custref,
    required this.tagcode,
    required this.tagId,
  });

  String values;
  String message;
  dynamic custid;
  dynamic custref;
  dynamic tagcode;
  dynamic tagId;

  factory Checkotp.fromJson(Map<String, dynamic> json) => Checkotp(
        values: json["values"] ?? "",
        message: json["Message"] ?? "",
        custid: json["Custid"],
        custref: json["Custref"],
        tagcode: json["tagcode"],
        tagId: json["tagId"],
      );

  Map<String, dynamic> toJson() => {
        "values": values,
        "Message": message,
        "Custid": custid,
        "Custref": custref,
        "tagcode": tagcode,
        "tagId": tagId,
      };
}
