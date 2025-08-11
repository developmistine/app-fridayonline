// To parse this JSON data, do
//
//     final paymentType = paymentTypeFromJson(jsonString);

import 'dart:convert';

PaymentType paymentTypeFromJson(String str) =>
    PaymentType.fromJson(json.decode(str));

String paymentTypeToJson(PaymentType data) => json.encode(data.toJson());

class PaymentType {
  String code;
  String message;
  String repCode;
  String paymentType;

  PaymentType({
    required this.code,
    required this.message,
    required this.repCode,
    required this.paymentType,
  });

  factory PaymentType.fromJson(Map<String, dynamic> json) => PaymentType(
        code: json["Code"],
        message: json["Message"],
        repCode: json["rep_code"],
        paymentType: json["payment_type"],
      );

  Map<String, dynamic> toJson() => {
        "Code": code,
        "Message": message,
        "rep_code": repCode,
        "payment_type": paymentType,
      };
}
