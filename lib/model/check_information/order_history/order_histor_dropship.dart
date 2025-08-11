// To parse this JSON data, do
//
//     final dropshipOrderHistory = dropshipOrderHistoryFromJson(jsonString);

// import 'package:meta/meta.dart';
import 'dart:convert';

List<DropshipOrderHistory> dropshipOrderHistoryFromJson(String str) =>
    List<DropshipOrderHistory>.from(
        json.decode(str).map((x) => DropshipOrderHistory.fromJson(x)));

String dropshipOrderHistoryToJson(List<DropshipOrderHistory> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DropshipOrderHistory {
  DropshipOrderHistory({
    required this.orderNo,
    required this.orderId,
    required this.createDate,
    required this.trackingNo,
    required this.totItem,
    required this.totAmount,
    required this.orderStatus,
    required this.name,
    required this.orderCamp,
  });

  String orderNo;
  String orderId;
  String createDate;
  String trackingNo;
  String totItem;
  String totAmount;
  String orderStatus;
  String name;
  String orderCamp;

  factory DropshipOrderHistory.fromJson(Map<String, dynamic> json) =>
      DropshipOrderHistory(
        orderNo: json["OrderNo"] ?? "",
        orderId: json["OrderId"] ?? "",
        createDate: json["CreateDate"] ?? "",
        trackingNo: json["TrackingNo"] ?? "",
        totItem: json["TotItem"] ?? "",
        totAmount: json["TotAmount"] ?? "",
        orderStatus: json["OrderStatus"] ?? "",
        name: json["Name"] ?? "",
        orderCamp: json["OrderCamp"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "OrderNo": orderNo,
        "OrderId": orderId,
        "CreateDate": createDate,
        "TrackingNo": trackingNo,
        "TotItem": totItem,
        "TotAmount": totAmount,
        "OrderStatus": orderStatus,
        "Name": name,
        "OrderCamp": orderCamp,
      };
}
