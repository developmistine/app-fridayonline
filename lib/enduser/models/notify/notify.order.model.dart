// To parse this JSON data, do
//
//     final notifyOrderTracking = notifyOrderTrackingFromJson(jsonString);

import 'dart:convert';

NotifyOrderTracking notifyOrderTrackingFromJson(String str) =>
    NotifyOrderTracking.fromJson(json.decode(str));

String notifyOrderTrackingToJson(NotifyOrderTracking data) =>
    json.encode(data.toJson());

class NotifyOrderTracking {
  String code;
  List<Datum> data;
  String message;

  NotifyOrderTracking({
    required this.code,
    required this.data,
    required this.message,
  });

  factory NotifyOrderTracking.fromJson(Map<String, dynamic> json) =>
      NotifyOrderTracking(
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
  int orderNotifyId;
  String imagesUrl;
  String title;
  int orderType;
  int ordshopId;
  String orderNo;
  double totalAmount;
  String detailDesc;
  bool isViewed;
  String dateTime;

  Datum({
    required this.orderNotifyId,
    required this.imagesUrl,
    required this.title,
    required this.orderType,
    required this.ordshopId,
    required this.orderNo,
    required this.totalAmount,
    required this.detailDesc,
    required this.isViewed,
    required this.dateTime,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        orderNotifyId: json["order_notify_id"],
        imagesUrl: json["images_url"],
        title: json["title"],
        orderType: json["order_type"],
        ordshopId: json["ordshop_id"],
        orderNo: json["order_no"],
        totalAmount: json["total_amount"]?.toDouble(),
        detailDesc: json["detail_desc"],
        isViewed: json["is_viewed"],
        dateTime: json["date_time"],
      );

  Map<String, dynamic> toJson() => {
        "order_notify_id": orderNotifyId,
        "images_url": imagesUrl,
        "title": title,
        "order_type": orderType,
        "ordshop_id": ordshopId,
        "order_no": orderNo,
        "total_amount": totalAmount,
        "detail_desc": detailDesc,
        "is_viewed": isViewed,
        "date_time": dateTime
      };
}
