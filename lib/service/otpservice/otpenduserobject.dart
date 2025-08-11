// To parse this JSON data, do
//
//     final otpenduserobject = otpenduserobjectFromJson(jsonString);

// import 'package:meta/meta.dart';
import 'dart:convert';

Otpenduserobject otpenduserobjectFromJson(String str) =>
    Otpenduserobject.fromJson(json.decode(str));

String otpenduserobjectToJson(Otpenduserobject data) =>
    json.encode(data.toJson());

class Otpenduserobject {
  Otpenduserobject({
    required this.values,
    required this.message,
    required this.telNumber,
  });

  String values;
  String message;
  String telNumber;

  factory Otpenduserobject.fromJson(Map<String, dynamic> json) =>
      Otpenduserobject(
        values: json["values"] ?? "",
        message: json["Message"] ?? "",
        telNumber: json["TelNumber"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "values": values,
        "Message": message,
        "TelNumber": telNumber,
      };
}
