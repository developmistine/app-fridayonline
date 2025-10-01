// To parse this JSON data, do
//
//     final bankOption = bankOptionFromJson(jsonString);

import 'dart:convert';

BankOption bankOptionFromJson(String str) =>
    BankOption.fromJson(json.decode(str));

String bankOptionToJson(BankOption data) => json.encode(data.toJson());

class BankOption {
  String code;
  List<Datum> data;
  String message;

  BankOption({
    required this.code,
    required this.data,
    required this.message,
  });

  factory BankOption.fromJson(Map<String, dynamic> json) => BankOption(
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
