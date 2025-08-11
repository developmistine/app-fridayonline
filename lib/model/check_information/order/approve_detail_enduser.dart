// To parse this JSON data, do
//
//     final approveDetailEndUser = approveDetailEndUserFromJson(jsonString);

import 'dart:convert';

ApproveDetailEndUser approveDetailEndUserFromJson(String str) =>
    ApproveDetailEndUser.fromJson(json.decode(str));

String approveDetailEndUserToJson(ApproveDetailEndUser data) =>
    json.encode(data.toJson());

class ApproveDetailEndUser {
  ApproveDetailEndUser({
    required this.repSeq,
    required this.userId,
    required this.orderNo,
    required this.approveFlag,
    required this.listdetail,
  });

  String repSeq;
  String userId;
  String orderNo;
  String approveFlag;
  List<Listdetail> listdetail;

  factory ApproveDetailEndUser.fromJson(Map<String, dynamic> json) =>
      ApproveDetailEndUser(
        repSeq: json["RepSeq"] ?? "",
        userId: json["UserID"] ?? "",
        orderNo: json["OrderNo"] ?? "",
        approveFlag: json["ApproveFlag"] ?? "",
        listdetail: json["Listdetail"] == null ? [] :List<Listdetail>.from(
            json["Listdetail"].map((x) => Listdetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "RepSeq": repSeq,
        "UserID": userId,
        "OrderNo": orderNo,
        "ApproveFlag": approveFlag,
        "Listdetail": List<dynamic>.from(listdetail.map((x) => x.toJson())),
      };
}

class Listdetail {
  Listdetail({
    required this.orderNo,
    required this.listno,
    required this.billCode,
    required this.billDesc,
    required this.billCamp,
    required this.orderCamp,
    required this.qty,
    required this.qtyConfirm,
    required this.billFlag,
    required this.price,
    required this.amount,
    required this.brand,
  });

  String orderNo;
  String listno;
  String billCode;
  String billDesc;
  String billCamp;
  String orderCamp;
  String qty;
  String qtyConfirm;
  String billFlag;
  String price;
  String amount;
  String brand;

  factory Listdetail.fromJson(Map<String, dynamic> json) => Listdetail(
        orderNo: json["OrderNo"] ?? "",
        listno: json["Listno"] ?? "",
        billCode: json["BillCode"] ?? "",
        billDesc: json["BillDesc"] ?? "",
        billCamp: json["BillCamp"] ?? "",
        orderCamp: json["OrderCamp"] ?? "",
        qty: json["Qty"] ?? "",
        qtyConfirm: json["QtyConfirm"] ?? "",
        billFlag: json["BillFlag"] ?? "",
        price: json["Price"] ?? "",
        amount: json["Amount"] ?? "",
        brand: json["Brand"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "OrderNo": orderNo,
        "Listno": listno,
        "BillCode": billCode,
        "BillDesc": billDesc,
        "BillCamp": billCamp,
        "OrderCamp": orderCamp,
        "Qty": qty,
        "QtyConfirm": qtyConfirm,
        "BillFlag": billFlag,
        "Price": price,
        "Amount": amount,
        "Brand": brand,
      };
}
