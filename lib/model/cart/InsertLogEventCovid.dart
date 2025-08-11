// To parse this JSON data, do
//
//     final valuesinsert = valuesinsertFromJson(jsonString);

// import 'package:meta/meta.dart';
import 'dart:convert';

Valuesinsert valuesinsertFromJson(String str) =>
    Valuesinsert.fromJson(json.decode(str));

String valuesinsertToJson(Valuesinsert data) => json.encode(data.toJson());

class Valuesinsert {
  Valuesinsert({
    required this.valuesinsert,
  });

  ValuesinsertClass? valuesinsert;

  factory Valuesinsert.fromJson(Map<String, dynamic> json) => Valuesinsert(
        valuesinsert: json["Valuesinsert"] == null
            ? null
            : ValuesinsertClass.fromJson(json["Valuesinsert"]),
      );

  Map<String, dynamic> toJson() => {
        "Valuesinsert": valuesinsert == null ? null : valuesinsert!.toJson(),
      };
}

class ValuesinsertClass {
  ValuesinsertClass({
    required this.status,
    required this.messageDetail1,
    required this.messageDetail2,
    required this.messageDetail3,
  });

  String status;
  String messageDetail1;
  String messageDetail2;
  String messageDetail3;

  factory ValuesinsertClass.fromJson(Map<String, dynamic> json) =>
      ValuesinsertClass(
        status: json["Status"] ?? "",
        messageDetail1: json["MessageDetail1"] ?? "",
        messageDetail2: json["MessageDetail2"] ?? "",
        messageDetail3: json["MessageDetail3"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "Status": status,
        "MessageDetail1": messageDetail1,
        "MessageDetail2": messageDetail2,
        "MessageDetail3": messageDetail3,
      };
}
