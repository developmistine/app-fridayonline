// To parse this JSON data, do
//
//     final accountStatus = accountStatusFromJson(jsonString);

import 'dart:convert';

AccountStatus accountStatusFromJson(String str) =>
    AccountStatus.fromJson(json.decode(str));

String accountStatusToJson(AccountStatus data) => json.encode(data.toJson());

class AccountStatus {
  String code;
  String message;
  String status;

  AccountStatus({
    required this.code,
    required this.message,
    required this.status,
  });

  factory AccountStatus.fromJson(Map<String, dynamic> json) => AccountStatus(
        code: json["code"],
        message: json["message"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "status": status,
      };
}
