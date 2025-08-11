// To parse this JSON data, do
//
//     final getDropshipDeliveryStatus = getDropshipDeliveryStatusFromJson(jsonString);

import 'dart:convert';

List<GetDropshipDeliveryStatus> getDropshipDeliveryStatusFromJson(String str) =>
    List<GetDropshipDeliveryStatus>.from(
        json.decode(str).map((x) => GetDropshipDeliveryStatus.fromJson(x)));

String getDropshipDeliveryStatusToJson(List<GetDropshipDeliveryStatus> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetDropshipDeliveryStatus {
  GetDropshipDeliveryStatus({
    required this.orderNo,
    required this.orderId,
    required this.createDate,
    required this.trackingNo,
    required this.totAmount,
    required this.orderStatus,
    required this.name,
    required this.orderCamp,
  });

  String orderNo;
  String orderId;
  String createDate;
  String trackingNo;
  String totAmount;
  String orderStatus;
  String name;
  String orderCamp;

  factory GetDropshipDeliveryStatus.fromJson(Map<String, dynamic> json) =>
      GetDropshipDeliveryStatus(
        orderNo: json["OrderNo"] ?? "",
        orderId: json["OrderId"] ?? "",
        createDate: json["CreateDate"] ?? "",
        trackingNo: json["TrackingNo"] ?? "",
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
        "TotAmount": totAmount,
        "OrderStatus": orderStatus,
        "Name": name,
        "OrderCamp": orderCamp,
      };
}
