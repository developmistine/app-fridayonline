// To parse this JSON data, do
//
//     final cartDropshipStatus = cartDropshipStatusFromJson(jsonString);

// import 'package:meta/meta.dart';
import 'dart:convert';

CartDropshipStatus cartDropshipStatusFromJson(String str) =>
    CartDropshipStatus.fromJson(json.decode(str));

String cartDropshipStatusToJson(CartDropshipStatus data) =>
    json.encode(data.toJson());

class CartDropshipStatus {
  CartDropshipStatus({
    required this.code,
    required this.message1,
    required this.message2,
    required this.message3,
  });

  String code;
  String message1;
  String message2;
  String message3;

  factory CartDropshipStatus.fromJson(Map<String, dynamic> json) =>
      CartDropshipStatus(
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
