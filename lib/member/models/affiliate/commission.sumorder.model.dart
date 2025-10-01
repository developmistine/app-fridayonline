// To parse this JSON data, do
//
//     final affiliateSummaryOrder = affiliateSummaryOrderFromJson(jsonString);

import 'dart:convert';

AffiliateSummaryOrder affiliateSummaryOrderFromJson(String str) =>
    AffiliateSummaryOrder.fromJson(json.decode(str));

String affiliateSummaryOrderToJson(AffiliateSummaryOrder data) =>
    json.encode(data.toJson());

class AffiliateSummaryOrder {
  String code;
  Data data;
  String message;

  AffiliateSummaryOrder({
    required this.code,
    required this.data,
    required this.message,
  });

  factory AffiliateSummaryOrder.fromJson(Map<String, dynamic> json) =>
      AffiliateSummaryOrder(
        code: json["code"],
        data: Data.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "data": data.toJson(),
        "message": message,
      };
}

class Data {
  String period;
  List<Commission> commission;

  Data({
    required this.period,
    required this.commission,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        period: json["period"],
        commission: List<Commission>.from(
            json["commission"].map((x) => Commission.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "period": period,
        "commission": List<dynamic>.from(commission.map((x) => x.toJson())),
      };
}

class Commission {
  String date;
  String displayDate;
  Summary summary;

  Commission({
    required this.date,
    required this.displayDate,
    required this.summary,
  });

  factory Commission.fromJson(Map<String, dynamic> json) => Commission(
        date: json["date"],
        displayDate: json["display_date"],
        summary: Summary.fromJson(json["summary"]),
      );

  Map<String, dynamic> toJson() => {
        "date": date,
        "display_date": displayDate,
        "summary": summary.toJson(),
      };
}

class Summary {
  String totalOrders;
  String totalAmount;

  Summary({
    required this.totalOrders,
    required this.totalAmount,
  });

  factory Summary.fromJson(Map<String, dynamic> json) => Summary(
        totalOrders: json["total_orders"],
        totalAmount: json["total_amount"],
      );

  Map<String, dynamic> toJson() => {
        "total_orders": totalOrders,
        "total_amount": totalAmount,
      };
}
