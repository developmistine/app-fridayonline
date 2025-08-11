// To parse this JSON data, do
//
//     final historyReturnAll = historyReturnAllFromJson(jsonString);

import 'dart:convert';

List<HistoryReturnAll> historyReturnAllFromJson(String str) =>
    List<HistoryReturnAll>.from(
        json.decode(str).map((x) => HistoryReturnAll.fromJson(x)));

String historyReturnAllToJson(List<HistoryReturnAll> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class HistoryReturnAll {
  String seqNo;
  String status;
  String invoice;
  String creDate;
  String campDate;
  String totalAll;
  int amount;

  HistoryReturnAll({
    required this.seqNo,
    required this.status,
    required this.invoice,
    required this.creDate,
    required this.campDate,
    required this.totalAll,
    required this.amount,
  });

  factory HistoryReturnAll.fromJson(Map<String, dynamic> json) =>
      HistoryReturnAll(
        seqNo: json["seq_no"],
        status: json["status"],
        invoice: json["invoice"],
        creDate: json["cre_date"],
        campDate: json["camp_date"],
        totalAll: json["total_all"],
        amount: json["amount"],
      );

  Map<String, dynamic> toJson() => {
        "seq_no": seqNo,
        "status": status,
        "invoice": invoice,
        "cre_date": creDate,
        "camp_date": campDate,
        "total_all": totalAll,
        "amount": amount,
      };
}
