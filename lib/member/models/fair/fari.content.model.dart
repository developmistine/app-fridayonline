// To parse this JSON data, do
//
//     final productSwipeContent = productSwipeContentFromJson(jsonString);

import 'dart:convert';

ProductSwipeContent productSwipeContentFromJson(String str) =>
    ProductSwipeContent.fromJson(json.decode(str));

String productSwipeContentToJson(ProductSwipeContent data) =>
    json.encode(data.toJson());

class ProductSwipeContent {
  String code;
  List<Datum> data;
  String message;

  ProductSwipeContent({
    required this.code,
    required this.data,
    required this.message,
  });

  factory ProductSwipeContent.fromJson(Map<String, dynamic> json) =>
      ProductSwipeContent(
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
  int promotionId;
  String promotionName;
  String promotionDesc;
  String startTime;
  String endTime;
  int userDailyQuota;
  int userRemainingQuota;

  Datum({
    required this.promotionId,
    required this.promotionName,
    required this.promotionDesc,
    required this.startTime,
    required this.endTime,
    required this.userDailyQuota,
    required this.userRemainingQuota,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        promotionId: json["promotion_id"],
        promotionName: json["promotion_name"],
        promotionDesc: json["promotion_desc"],
        startTime: json["start_time"],
        endTime: json["end_time"],
        userDailyQuota: json["user_daily_quota"],
        userRemainingQuota: json["user_remaining_quota "],
      );

  Map<String, dynamic> toJson() => {
        "promotion_id": promotionId,
        "promotion_name": promotionName,
        "promotion_desc": promotionDesc,
        "start_time": startTime,
        "end_time": endTime,
        "user_daily_quota": userDailyQuota,
        "user_remaining_quota ": userRemainingQuota,
      };
}
