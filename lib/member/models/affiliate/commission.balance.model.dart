// To parse this JSON data, do
//
//     final commissionBalance = commissionBalanceFromJson(jsonString);

import 'dart:convert';

CommissionBalance commissionBalanceFromJson(String str) =>
    CommissionBalance.fromJson(json.decode(str));

String commissionBalanceToJson(CommissionBalance data) =>
    json.encode(data.toJson());

class CommissionBalance {
  String code;
  CommissionBalanceData data;
  String message;

  CommissionBalance({
    required this.code,
    required this.data,
    required this.message,
  });

  factory CommissionBalance.fromJson(Map<String, dynamic> json) =>
      CommissionBalance(
        code: json["code"],
        data: CommissionBalanceData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "data": data.toJson(),
        "message": message,
      };
}

class CommissionBalanceData {
  String balance;
  String description;

  CommissionBalanceData({
    required this.balance,
    required this.description,
  });

  factory CommissionBalanceData.fromJson(Map<String, dynamic> json) =>
      CommissionBalanceData(
        balance: json["balance"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "balance": balance,
        "description": description,
      };
}
