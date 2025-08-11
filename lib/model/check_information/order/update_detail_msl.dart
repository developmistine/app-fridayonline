// To parse this JSON data, do
//
//     final updateDetailMsl = updateDetailMslFromJson(jsonString);

import 'dart:convert';

UpdateDetailMsl updateDetailMslFromJson(String str) => UpdateDetailMsl.fromJson(json.decode(str));

String updateDetailMslToJson(UpdateDetailMsl data) => json.encode(data.toJson());

class UpdateDetailMsl {
    UpdateDetailMsl({
        required this.repSeq,
        required this.repCode,
        required this.listdetail,
    });

    String repSeq;
    String repCode;
    List<Listdetail> listdetail;

    factory UpdateDetailMsl.fromJson(Map<String, dynamic> json) => UpdateDetailMsl(
        repSeq: json["RepSeq"] ?? "",
        repCode: json["RepCode"] ?? "",
        listdetail: json["Listdetail"] == null ? [] : List<Listdetail>.from(json["Listdetail"].map((x) => Listdetail.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "RepSeq": repSeq,
        "RepCode": repCode,
        "Listdetail": List<dynamic>.from(listdetail.map((x) => x.toJson())),
    };
}

class Listdetail {
    Listdetail({
        required this.orderNo,
        required this.listNo,
        required this.billCamp,
        required this.billCode,
        required this.qty,
        required this.qtyConfirm,
        required this.price,
        required this.amount,
        required this.brand,
        required this.billFlag,
    });

    String orderNo;
    int listNo;
    String billCamp;
    String billCode;
    int qty;
    int qtyConfirm;
    double price;
    double amount;
    String brand;
    int billFlag;

    factory Listdetail.fromJson(Map<String, dynamic> json) => Listdetail(
        orderNo: json["OrderNo"] ?? "",
        listNo: json["ListNo"] ?? 0,
        billCamp: json["BillCamp"] ?? "",
        billCode: json["BillCode"] ?? "",
        qty: json["Qty"] ?? 0,
        qtyConfirm: json["QtyConfirm"] ?? 0,
        price: json["Price"] ?? 0.00,
        amount: json["Amount"] ?? 0.00,
        brand: json["Brand"] ?? "",
        billFlag: json["BillFlag"] ?? 0,
    );

    Map<String, dynamic> toJson() => {
        "OrderNo": orderNo,
        "ListNo": listNo,
        "BillCamp": billCamp,
        "BillCode": billCode,
        "Qty": qty,
        "QtyConfirm": qtyConfirm,
        "Price": price,
        "Amount": amount,
        "Brand": brand,
        "BillFlag": billFlag,
    };
}
