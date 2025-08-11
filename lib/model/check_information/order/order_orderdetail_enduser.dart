// To parse this JSON data, do
//
//     final checkInformationOrderOrderDetailEndUser = checkInformationOrderOrderDetailEndUserFromJson(jsonString);

import 'dart:convert';

CheckInformationOrderOrderDetailEndUser
    checkInformationOrderOrderDetailEndUserFromJson(String str) =>
        CheckInformationOrderOrderDetailEndUser.fromJson(json.decode(str));

String checkInformationOrderOrderDetailEndUserToJson(
        CheckInformationOrderOrderDetailEndUser data) =>
    json.encode(data.toJson());

class CheckInformationOrderOrderDetailEndUser {
  String repSeq;
  String repCode;
  String repName;
  String enduserId;
  String enduserName;
  String enduserTel;
  String orderId;
  String orderNo;
  String orderDate;
  String orderTime;
  String campaign;
  double totalAmount;
  double pointDiscount;
  double couponDiscount;
  double shipFee;
  bool cancelFlag;
  List<OrderDetail> orderDetail;

  CheckInformationOrderOrderDetailEndUser({
    required this.repSeq,
    required this.repCode,
    required this.repName,
    required this.enduserId,
    required this.enduserName,
    required this.enduserTel,
    required this.orderId,
    required this.orderNo,
    required this.orderDate,
    required this.orderTime,
    required this.campaign,
    required this.totalAmount,
    required this.pointDiscount,
    required this.couponDiscount,
    required this.shipFee,
    required this.cancelFlag,
    required this.orderDetail,
  });

  factory CheckInformationOrderOrderDetailEndUser.fromJson(
          Map<String, dynamic> json) =>
      CheckInformationOrderOrderDetailEndUser(
        repSeq: json["rep_seq"],
        repCode: json["rep_code"],
        repName: json["rep_name"],
        enduserId: json["enduser_id"],
        enduserName: json["enduser_name"],
        enduserTel: json["enduser_tel"],
        orderId: json["order_id"],
        orderNo: json["order_no"],
        orderDate: json["order_date"],
        orderTime: json["order_time"],
        campaign: json["campaign"],
        totalAmount: json["total_amount"].toDouble(),
        pointDiscount: json["point_discount"].toDouble(),
        couponDiscount: json["coupon_discount"].toDouble(),
        shipFee: json["ship_fee"].toDouble(),
        cancelFlag: json["cancel_flag"],
        orderDetail: List<OrderDetail>.from(
            json["order_detail"].map((x) => OrderDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "rep_seq": repSeq,
        "rep_code": repCode,
        "rep_name": repName,
        "enduser_id": enduserId,
        "enduser_name": enduserName,
        "enduser_tel": enduserTel,
        "order_id": orderId,
        "order_no": orderNo,
        "order_date": orderDate,
        "order_time": orderTime,
        "campaign": campaign,
        "total_amount": totalAmount,
        "point_discount": pointDiscount,
        "coupon_discount": couponDiscount,
        "ship_fee": shipFee,
        "cancel_flag": cancelFlag,
        "order_detail": List<dynamic>.from(orderDetail.map((x) => x.toJson())),
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
        price: json["price"].toDouble(),
        amount: json["amount"].toDouble(),
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
