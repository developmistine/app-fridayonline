// To parse this JSON data, do
//
//     final accountSummary = accountSummaryFromJson(jsonString);

import 'dart:convert';

AccountSummary accountSummaryFromJson(String str) =>
    AccountSummary.fromJson(json.decode(str));

String accountSummaryToJson(AccountSummary data) => json.encode(data.toJson());

class AccountSummary {
  String code;
  AccountSummaryData data;
  String message;

  AccountSummary({
    required this.code,
    required this.data,
    required this.message,
  });

  factory AccountSummary.fromJson(Map<String, dynamic> json) => AccountSummary(
        code: json["code"],
        data: AccountSummaryData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "data": data.toJson(),
        "message": message,
      };
}

class AccountSummaryData {
  String salesTotal;
  String ordersTotal;
  String estimatedCommission;

  AccountSummaryData({
    required this.salesTotal,
    required this.ordersTotal,
    required this.estimatedCommission,
  });

  factory AccountSummaryData.fromJson(Map<String, dynamic> json) =>
      AccountSummaryData(
        salesTotal: json["sales_total"],
        ordersTotal: json["orders_total"],
        estimatedCommission: json["estimated_commission"],
      );

  Map<String, dynamic> toJson() => {
        "sales_total": salesTotal,
        "orders_total": ordersTotal,
        "estimated_commission": estimatedCommission,
      };
}
