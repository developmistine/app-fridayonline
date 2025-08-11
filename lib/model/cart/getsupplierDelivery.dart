// To parse this JSON data, do
//
//     final getSupplierDelivery = getSupplierDeliveryFromJson(jsonString);

import 'dart:convert';

GetSupplierDelivery getSupplierDeliveryFromJson(String str) =>
    GetSupplierDelivery.fromJson(json.decode(str));

String getSupplierDeliveryToJson(GetSupplierDelivery data) =>
    json.encode(data.toJson());

class GetSupplierDelivery {
  String flagDelivery;
  List<DetailDelivery> detailDelivery;

  GetSupplierDelivery({
    required this.flagDelivery,
    required this.detailDelivery,
  });

  factory GetSupplierDelivery.fromJson(Map<String, dynamic> json) =>
      GetSupplierDelivery(
        flagDelivery: json["FlagDelivery"],
        detailDelivery: List<DetailDelivery>.from(
            json["DetailDelivery"].map((x) => DetailDelivery.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "FlagDelivery": flagDelivery,
        "DetailDelivery":
            List<dynamic>.from(detailDelivery.map((x) => x.toJson())),
      };
}

class DetailDelivery {
  String list;
  String titleDelivery;
  String desDelivery;
  String orderType;
  String deliveryType;
  String price;
  String message;

  DetailDelivery({
    required this.list,
    required this.titleDelivery,
    required this.desDelivery,
    required this.orderType,
    required this.deliveryType,
    required this.price,
    required this.message,
  });

  factory DetailDelivery.fromJson(Map<String, dynamic> json) => DetailDelivery(
        list: json["List"],
        titleDelivery: json["TitleDelivery"],
        desDelivery: json["DesDelivery"],
        orderType: json["OrderType"],
        deliveryType: json["DeliveryType"],
        price: json["Price"],
        message: json["Message"],
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
