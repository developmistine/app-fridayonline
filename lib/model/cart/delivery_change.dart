// To parse this JSON data, do
//
//     final changeDelivery = changeDeliveryFromJson(jsonString);

// import 'package:meta/meta.dart';
import 'dart:convert';

ChangeDelivery changeDeliveryFromJson(String str) =>
    ChangeDelivery.fromJson(json.decode(str));

String changeDeliveryToJson(ChangeDelivery data) => json.encode(data.toJson());

class ChangeDelivery {
  ChangeDelivery({
    required this.flagDelivery,
    required this.detailDelivery,
  });

  String? flagDelivery;
  List<DetailDelivery>? detailDelivery;

  factory ChangeDelivery.fromJson(Map<String, dynamic> json) => ChangeDelivery(
        flagDelivery: json["FlagDelivery"] ?? "",
        detailDelivery: json["DetailDelivery"] == null
            ? []
            : List<DetailDelivery>.from(
                json["DetailDelivery"].map((x) => DetailDelivery.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "FlagDelivery": flagDelivery,
        "DetailDelivery":
            List<dynamic>.from(detailDelivery!.map((x) => x.toJson())),
      };
}

class DetailDelivery {
  DetailDelivery({
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

  factory DetailDelivery.fromJson(Map<String, dynamic> json) => DetailDelivery(
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
