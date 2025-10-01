// To parse this JSON data, do
//
//     final affiliateSummaryRes = affiliateSummaryResFromJson(jsonString);

import 'dart:convert';

AffiliateSummaryEarning affiliateSummaryEarningFromJson(String str) =>
    AffiliateSummaryEarning.fromJson(json.decode(str));

String affiliateSummaryEarningToJson(AffiliateSummaryEarning data) =>
    json.encode(data.toJson());

class AffiliateSummaryEarning {
  String code;
  Data data;
  String message;

  AffiliateSummaryEarning({
    required this.code,
    required this.data,
    required this.message,
  });

  factory AffiliateSummaryEarning.fromJson(Map<String, dynamic> json) =>
      AffiliateSummaryEarning(
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
  Status? status;
  Summary summary;

  Commission({
    required this.date,
    required this.displayDate,
    this.status, // <-- nullable
    required this.summary,
  });

  factory Commission.fromJson(Map<String, dynamic> json) => Commission(
        date: json["date"],
        displayDate: json["display_date"],
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
        summary: Summary.fromJson(json["summary"]),
      );

  Map<String, dynamic> toJson() => {
        "date": date,
        "display_date": displayDate,
        if (status != null) "status": status!.toJson(), // <-- omit when null
        "summary": summary.toJson(),
      };
}

class Status {
  String colorCode;
  String label;
  String description;

  Status({
    required this.colorCode,
    required this.label,
    required this.description,
  });

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        colorCode: json["color_code"],
        label: json["label"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "color_code": colorCode,
        "label": label,
        "description": description,
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
