// To parse this JSON data, do
//
//     final ordersHeader = ordersHeaderFromJson(jsonString);

import 'dart:convert';

OrdersHeader ordersHeaderFromJson(String str) =>
    OrdersHeader.fromJson(json.decode(str));

String ordersHeaderToJson(OrdersHeader data) => json.encode(data.toJson());

class OrdersHeader {
  String code;
  List<Datum> data;
  String message;

  OrdersHeader({
    required this.code,
    required this.data,
    required this.message,
  });

  factory OrdersHeader.fromJson(Map<String, dynamic> json) => OrdersHeader(
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
  int count;
  int orderType;
  String description;

  Datum({
    required this.count,
    required this.orderType,
    required this.description,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        count: json["count"] ?? 0,
        orderType: json["order_type"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "order_type": orderType,
        "description": description,
      };
}
