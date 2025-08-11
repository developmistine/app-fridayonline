// To parse this JSON data, do
//
//     final dropshipOrderHistoryDetail = dropshipOrderHistoryDetailFromJson(jsonString);

// import 'package:meta/meta.dart';
import 'dart:convert';

DropshipOrderHistoryDetail dropshipOrderHistoryDetailFromJson(String str) =>
    DropshipOrderHistoryDetail.fromJson(json.decode(str));

String dropshipOrderHistoryDetailToJson(DropshipOrderHistoryDetail data) =>
    json.encode(data.toJson());

class DropshipOrderHistoryDetail {
  DropshipOrderHistoryDetail({
    required this.name,
    required this.orderStatus,
    required this.orderDate,
    required this.orderId,
    required this.subCode,
    required this.subName,
    required this.subImg,
    required this.totalItem,
    required this.amount,
    required this.shipCost,
    required this.totalAmount,
    required this.orderDetailList,
  });

  String name;
  String orderStatus;
  String orderDate;
  String orderId;
  String subCode;
  String subName;
  String subImg;
  String totalItem;
  String amount;
  String shipCost;
  String totalAmount;
  List<OrderDetailList> orderDetailList;

  factory DropshipOrderHistoryDetail.fromJson(Map<String, dynamic> json) =>
      DropshipOrderHistoryDetail(
        name: json["Name"] ?? "",
        orderStatus: json["OrderStatus"] ?? "",
        orderDate: json["OrderDate"] ?? "",
        orderId: json["OrderID"] ?? "",
        subCode: json["SubCode"] ?? "",
        subName: json["SubName"] ?? "",
        subImg: json["SubImg"] ?? "",
        totalItem: json["TotalItem"] ?? "",
        amount: json["Amount"] ?? "",
        shipCost: json["ShipCost"] ?? "",
        totalAmount: json["TotalAmount"] ?? "",
        orderDetailList: json["OrderDetailList"] == null
            ? []
            : List<OrderDetailList>.from(json["OrderDetailList"]
                .map((x) => OrderDetailList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Name": name,
        "OrderStatus": orderStatus,
        "OrderDate": orderDate,
        "OrderID": orderId,
        "SubCode": subCode,
        "SubName": subName,
        "SubImg": subImg,
        "TotalItem": totalItem,
        "Amount": amount,
        "ShipCost": shipCost,
        "TotalAmount": totalAmount,
        "OrderDetailList":
            List<dynamic>.from(orderDetailList.map((x) => x.toJson())),
      };
}

class OrderDetailList {
  OrderDetailList({
    required this.productCode,
    required this.prouctName,
    required this.productImg,
    required this.qty,
    required this.price,
    required this.amount,
  });

  String productCode;
  String prouctName;
  String productImg;
  String qty;
  String price;
  String amount;

  factory OrderDetailList.fromJson(Map<String, dynamic> json) =>
      OrderDetailList(
        productCode: json["ProductCode"] ?? "",
        prouctName: json["ProuctName"] ?? "",
        productImg: json["ProductImg"] ?? "",
        qty: json["Qty"] ?? "",
        price: json["Price"] ?? "",
        amount: json["Amount"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "ProductCode": productCode,
        "ProuctName": prouctName,
        "ProductImg": productImg,
        "Qty": qty,
        "Price": price,
        "Amount": amount,
      };
}
