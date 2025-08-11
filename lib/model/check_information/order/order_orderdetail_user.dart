// To parse this JSON data, do
//
//     final checkInformationOrderOrderDetail = checkInformationOrderOrderDetailFromJson(jsonString);

import 'dart:convert';

CheckInformationOrderOrderDetail checkInformationOrderOrderDetailFromJson(
        String str) =>
    CheckInformationOrderOrderDetail.fromJson(json.decode(str));

String checkInformationOrderOrderDetailToJson(
        CheckInformationOrderOrderDetail data) =>
    json.encode(data.toJson());

class CheckInformationOrderOrderDetail {
  String repSeq;
  String repCode;
  String repName;
  String repTel;
  String orderId;
  String orderNo;
  String orderDate;
  String orderTime;
  String campaign;
  double totalAmount;
  int pointDiscount;
  double shipFee;
  List<Discount> discount;
  bool cancelFlag;
  List<OrderDetail> orderDetail;

  CheckInformationOrderOrderDetail({
    required this.repSeq,
    required this.repCode,
    required this.repName,
    required this.repTel,
    required this.orderId,
    required this.orderNo,
    required this.orderDate,
    required this.orderTime,
    required this.campaign,
    required this.totalAmount,
    required this.pointDiscount,
    required this.shipFee,
    required this.discount,
    required this.cancelFlag,
    required this.orderDetail,
  });

  factory CheckInformationOrderOrderDetail.fromJson(
          Map<String, dynamic> json) =>
      CheckInformationOrderOrderDetail(
        repSeq: json["rep_seq"],
        repCode: json["rep_code"],
        repName: json["rep_name"],
        repTel: json["rep_tel"],
        orderId: json["order_id"],
        orderNo: json["order_no"],
        orderDate: json["order_date"],
        orderTime: json["order_time"],
        campaign: json["campaign"],
        totalAmount: json["total_amount"]?.toDouble(),
        pointDiscount: json["point_discount"],
        shipFee: json["ship_fee"]?.toDouble(),
        discount: List<Discount>.from(
            json["discount"].map((x) => Discount.fromJson(x))),
        cancelFlag: json["cancel_flag"],
        orderDetail: List<OrderDetail>.from(
            json["order_detail"].map((x) => OrderDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "rep_seq": repSeq,
        "rep_code": repCode,
        "rep_name": repName,
        "rep_tel": repTel,
        "order_id": orderId,
        "order_no": orderNo,
        "order_date": orderDate,
        "order_time": orderTime,
        "campaign": campaign,
        "total_amount": totalAmount,
        "point_discount": pointDiscount,
        "ship_fee": shipFee,
        "discount": List<dynamic>.from(discount.map((x) => x.toJson())),
        "cancel_flag": cancelFlag,
        "order_detail": List<dynamic>.from(orderDetail.map((x) => x.toJson())),
      };
}

class Discount {
  int type;
  String billCode;
  String name;
  int price;

  Discount({
    required this.type,
    required this.billCode,
    required this.name,
    required this.price,
  });

  factory Discount.fromJson(Map<String, dynamic> json) => Discount(
        type: json["type"],
        billCode: json["bill_code"],
        name: json["name"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "bill_code": billCode,
        "name": name,
        "price": price,
      };
}

class OrderDetail {
  String billCamp;
  String billCode;
  String billDesc;
  String brand;
  String image;
  int qty;
  int qtyConfirm;
  double price;
  double amount;

  OrderDetail({
    required this.billCamp,
    required this.billCode,
    required this.billDesc,
    required this.brand,
    required this.image,
    required this.qty,
    required this.qtyConfirm,
    required this.price,
    required this.amount,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) => OrderDetail(
        billCamp: json["bill_camp"],
        billCode: json["bill_code"],
        billDesc: json["bill_desc"],
        brand: json["brand"],
        image: json["image"],
        qty: json["qty"],
        qtyConfirm: json["qty_confirm"],
        price: json["price"]?.toDouble(),
        amount: json["amount"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "bill_camp": billCamp,
        "bill_code": billCode,
        "bill_desc": billDesc,
        "brand": brand,
        "image": image,
        "qty": qty,
        "qty_confirm": qtyConfirm,
        "price": price,
        "amount": amount,
      };
}
