// To parse this JSON data, do
//
//     final dashBoardOverview = dashBoardOverviewFromJson(jsonString);

import 'dart:convert';

DashBoardOverview dashBoardOverviewFromJson(String str) =>
    DashBoardOverview.fromJson(json.decode(str));

String dashBoardOverviewToJson(DashBoardOverview data) =>
    json.encode(data.toJson());

class DashBoardOverview {
  String code;
  DashBoardOverviewData data;
  String message;

  DashBoardOverview({
    required this.code,
    required this.data,
    required this.message,
  });

  factory DashBoardOverview.fromJson(Map<String, dynamic> json) =>
      DashBoardOverview(
        code: json["code"],
        data: DashBoardOverviewData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "data": data.toJson(),
        "message": message,
      };
}

class DashBoardOverviewData {
  String date;
  List<DashBoardOverviewMetric> metrics;

  DashBoardOverviewData({
    required this.date,
    required this.metrics,
  });

  factory DashBoardOverviewData.fromJson(Map<String, dynamic> json) =>
      DashBoardOverviewData(
        date: json["date"],
        metrics: List<DashBoardOverviewMetric>.from(
            json["metrics"].map((x) => DashBoardOverviewMetric.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "date": date,
        "metrics": List<dynamic>.from(metrics.map((x) => x.toJson())),
      };
}

class DashBoardOverviewMetric {
  String name;
  String label;
  String displayValue;
  double value;
  double ratio;
  String info;
  List<MetricPoint> points;

  DashBoardOverviewMetric({
    required this.name,
    required this.label,
    required this.displayValue,
    required this.value,
    required this.ratio,
    required this.info,
    required this.points,
  });

  factory DashBoardOverviewMetric.fromJson(Map<String, dynamic> json) =>
      DashBoardOverviewMetric(
        name: json["name"],
        label: json["label"],
        displayValue: json["display_value"],
        value: json["value"]?.toDouble(),
        ratio: json["ratio"]?.toDouble(),
        info: json["info"],
        points: List<MetricPoint>.from(
            json["points"].map((x) => MetricPoint.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "label": label,
        "display_value": displayValue,
        "value": value,
        "ratio": ratio,
        "info": info,
        "points": List<dynamic>.from(points.map((x) => x.toJson())),
      };
}

class MetricPoint {
  String timestamp;
  double value;
  String displayValue;

  MetricPoint({
    required this.timestamp,
    required this.value,
    required this.displayValue,
  });

  factory MetricPoint.fromJson(Map<String, dynamic> json) => MetricPoint(
        timestamp: json["timestamp"],
        value: json["value"]?.toDouble(),
        displayValue: json["display_value"],
      );

  Map<String, dynamic> toJson() => {
        "timestamp": timestamp,
        "value": value,
        "display_value": displayValue,
      };
}
