import 'dart:convert';

LogAnalyticsCatalogDetail logAnalyticsCatalogDetailFromJson(String str) =>
    LogAnalyticsCatalogDetail.fromJson(json.decode(str));

String logAnalyticsCatalogDetailToJson(LogAnalyticsCatalogDetail data) =>
    json.encode(data.toJson());

class LogAnalyticsCatalogDetail {
  String logEvent;
  String time;
  String repType;
  String repCode;
  String repSeq;
  String catalogName;
  String catalogPage;
  String catalogId;

  LogAnalyticsCatalogDetail({
    required this.logEvent,
    required this.time,
    required this.repType,
    required this.repCode,
    required this.repSeq,
    required this.catalogName,
    required this.catalogPage,
    required this.catalogId,
  });

  factory LogAnalyticsCatalogDetail.fromJson(Map<String, dynamic> json) =>
      LogAnalyticsCatalogDetail(
        logEvent: json["LogEvent"],
        time: json["Time"],
        repType: json["RepType"],
        repCode: json["RepCode"],
        repSeq: json["RepSeq"],
        catalogName: json["CatalogName"],
        catalogPage: json["CatalogPage"],
        catalogId: json["CatalogId"],
      );

  Map<String, dynamic> toJson() => {
        "LogEvent": logEvent,
        "Time": time,
        "RepType": repType,
        "RepCode": repCode,
        "RepSeq": repSeq,
        "CatalogName": catalogName,
        "CatalogPage": catalogPage,
        "CatalogId": catalogId,
      };
}
