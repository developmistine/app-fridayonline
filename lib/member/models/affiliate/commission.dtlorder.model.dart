// To parse this JSON data, do
//
//     final affiliateOrderDetail = affiliateOrderDetailFromJson(jsonString);

import 'dart:convert';

AffiliateOrderDetail affiliateOrderDetailFromJson(String str) =>
    AffiliateOrderDetail.fromJson(json.decode(str));

String affiliateOrderDetailToJson(AffiliateOrderDetail data) =>
    json.encode(data.toJson());

class AffiliateOrderDetail {
  String code;
  Data data;
  String message;

  AffiliateOrderDetail({
    required this.code,
    required this.data,
    required this.message,
  });

  factory AffiliateOrderDetail.fromJson(Map<String, dynamic> json) =>
      AffiliateOrderDetail(
        code: json["code"],
        data: Data.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "data": data.toJson(),
        "message": message,
      };
}

class Data {
  String date;
  String totalOrders;
  String totalAmount;
  List<Order> orders;

  Data({
    required this.date,
    required this.totalOrders,
    required this.totalAmount,
    required this.orders,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        date: json["date"],
        totalOrders: json["total_orders"],
        totalAmount: json["total_amount"],
        orders: List<Order>.from(json["orders"].map((x) => Order.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "date": date,
        "total_orders": totalOrders,
        "total_amount": totalAmount,
        "orders": List<dynamic>.from(orders.map((x) => x.toJson())),
      };
}

class Order {
  String orderNo;
  String orderDate;
  int totalItems;
  String commissionAmount;
  List<OrderItem> orderItems;

  Order({
    required this.orderNo,
    required this.orderDate,
    required this.totalItems,
    required this.commissionAmount,
    required this.orderItems,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        orderNo: json["order_no"],
        orderDate: json["order_date"],
        totalItems: json["total_items"],
        commissionAmount: json["commission_amount"],
        orderItems: List<OrderItem>.from(
            json["order_items"].map((x) => OrderItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "order_no": orderNo,
        "order_date": orderDate,
        "total_items": totalItems,
        "commission_amount": commissionAmount,
        "order_items": List<dynamic>.from(orderItems.map((x) => x.toJson())),
      };
}

class OrderItem {
  int productId;
  String productName;
  String productImage;
  int amount;
  bool haveDiscount;
  int price;
  int priceBeforeDiscount;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.amount,
    required this.haveDiscount,
    required this.price,
    required this.priceBeforeDiscount,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        productId: json["product_id"],
        productName: json["product_name"],
        productImage: json["product_image"],
        amount: json["amount"],
        haveDiscount: json["have_discount"],
        price: json["price"],
        priceBeforeDiscount: json["price_before_discount"],
      );

  Map<String, dynamic> toJson() => {
        "product_id": productId,
        "product_name": productName,
        "product_image": productImage,
        "amount": amount,
        "have_discount": haveDiscount,
        "price": price,
        "price_before_discount": priceBeforeDiscount,
      };
}
