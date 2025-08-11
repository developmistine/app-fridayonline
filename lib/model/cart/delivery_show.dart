// To parse this JSON data, do
//
//     final deliveryChange = deliveryChangeFromJson(jsonString);

// import 'package:meta/meta.dart';
import 'dart:convert';

DeliveryChange deliveryChangeFromJson(String str) =>
    DeliveryChange.fromJson(json.decode(str));

String deliveryChangeToJson(DeliveryChange data) => json.encode(data.toJson());

class DeliveryChange {
  DeliveryChange({
    required this.list,
    required this.titleDelivery,
    required this.desDelivery,
    required this.orderType,
    required this.deliveryType,
    required this.price,
    required this.message,
  });

  String list;
  String titleDelivery;
  String desDelivery;
  String orderType;
  String deliveryType;
  String price;
  String message;

  factory DeliveryChange.fromJson(Map<String, dynamic> json) => DeliveryChange(
        list: json["List"] ?? "",
        titleDelivery: json["TitleDelivery"] ?? "",
        desDelivery: json["DesDelivery"] ?? "",
        orderType: json["OrderType"] ?? "",
        deliveryType: json["DeliveryType"] ?? "",
        price: json["Price"] ?? "",
        message: json["Message"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "List": list,
        "TitleDelivery": titleDelivery,
        "DesDelivery": desDelivery,
        "OrderType": orderType,
        "DeliveryType": deliveryType,
        "Price": price,
        "Message": message,
      };
}
