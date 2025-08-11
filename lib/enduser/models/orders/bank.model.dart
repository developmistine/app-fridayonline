// To parse this JSON data, do
//
//     final bank = bankFromJson(jsonString);

import 'dart:convert';

Bank bankFromJson(String str) => Bank.fromJson(json.decode(str));

String bankToJson(Bank data) => json.encode(data.toJson());

class Bank {
  String code;
  List<Datum> data;
  String message;

  Bank({
    required this.code,
    required this.data,
    required this.message,
  });

  factory Bank.fromJson(Map<String, dynamic> json) => Bank(
        code: json["code"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
      };
}

class Datum {
  int bankId;
  String bankCode;
  String bankName;

  Datum({
    required this.bankId,
    required this.bankCode,
    required this.bankName,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        bankId: json["bank_id"],
        bankCode: json["bank_code"],
        bankName: json["bank_name"],
      );

  Map<String, dynamic> toJson() => {
        "bank_id": bankId,
        "bank_code": bankCode,
        "bank_name": bankName,
      };
}
