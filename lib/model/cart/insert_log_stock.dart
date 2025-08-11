// To parse this JSON data, do
//
//     final insertLogStock = insertLogStockFromJson(jsonString);

// import 'package:meta/meta.dart';
import 'dart:convert';

InsertLogStock insertLogStockFromJson(String str) =>
    InsertLogStock.fromJson(json.decode(str));

String insertLogStockToJson(InsertLogStock data) => json.encode(data.toJson());

class InsertLogStock {
  InsertLogStock({
    required this.valuesinsert,
  });

  Valuesinsert valuesinsert;

  factory InsertLogStock.fromJson(Map<String, dynamic> json) => InsertLogStock(
        valuesinsert: Valuesinsert.fromJson(json["Valuesinsert"]),
      );

  Map<String, dynamic> toJson() => {
        "Valuesinsert": valuesinsert.toJson(),
      };
}

class Valuesinsert {
  Valuesinsert({
    required this.status,
    required this.messageDetail1,
    required this.messageDetail2,
    required this.messageDetail3,
  });

  String status;
  String messageDetail1;
  String messageDetail2;
  String messageDetail3;

  factory Valuesinsert.fromJson(Map<String, dynamic> json) => Valuesinsert(
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
