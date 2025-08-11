// To parse this JSON data, do
//
//     final objectpayment = objectpaymentFromJson(jsonString);

// import 'package:meta/meta.dart';
import 'dart:convert';

Objectpayment objectpaymentFromJson(String str) =>
    Objectpayment.fromJson(json.decode(str));

String objectpaymentToJson(Objectpayment data) => json.encode(data.toJson());

class Objectpayment {
  Objectpayment({
    required this.qrcode,
    required this.code,
  });

  String qrcode;
  String code;

  factory Objectpayment.fromJson(Map<String, dynamic> json) => Objectpayment(
        qrcode: json["qrcode"] ?? "",
        code: json["code"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "qrcode": qrcode,
        "code": code,
      };
}
