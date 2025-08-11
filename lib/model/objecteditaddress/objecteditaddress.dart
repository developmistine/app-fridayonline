// To parse this JSON data, do
//
//     final objectreturneditaddress = objectreturneditaddressFromJson(jsonString);

// import 'package:meta/meta.dart';
import 'dart:convert';

Objectreturneditaddress objectreturneditaddressFromJson(String str) =>
    Objectreturneditaddress.fromJson(json.decode(str));

String objectreturneditaddressToJson(Objectreturneditaddress data) =>
    json.encode(data.toJson());

class Objectreturneditaddress {
  Objectreturneditaddress({
    required this.code,
    required this.message,
  });

  String code;
  String message;

  factory Objectreturneditaddress.fromJson(Map<String, dynamic> json) =>
      Objectreturneditaddress(
        code: json["Code"] ?? "",
        message: json["Message"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "Code": code,
        "Message": message,
      };
}
