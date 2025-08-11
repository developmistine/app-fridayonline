// To parse this JSON data, do
//
//     final pointReturnConfirmPoint = pointReturnConfirmPointFromJson(jsonString);

// import 'package:meta/meta.dart';
import 'dart:convert';

PointReturnConfirmPoint pointReturnConfirmPointFromJson(String str) =>
    PointReturnConfirmPoint.fromJson(json.decode(str));

String pointReturnConfirmPointToJson(PointReturnConfirmPoint data) =>
    json.encode(data.toJson());

class PointReturnConfirmPoint {
  PointReturnConfirmPoint({
    required this.code,
    required this.message1,
    required this.message2,
    required this.pointUse,
    required this.pointBalance,
  });

  String code;
  String message1;
  String message2;
  int pointUse;
  int pointBalance;

  factory PointReturnConfirmPoint.fromJson(Map<String, dynamic> json) =>
      PointReturnConfirmPoint(
        code: json["Code"] ?? "",
        message1: json["Message1"] ?? "",
        message2: json["Message2"] ?? "",
        pointUse: json["PointUse"] ?? "",
        pointBalance: json["PointBalance"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "Code": code,
        "Message1": message1,
        "Message2": message2,
        "PointUse": pointUse,
        "PointBalance": pointBalance,
      };
}
