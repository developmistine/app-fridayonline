// To parse this JSON data, do
//
//     final getMslPayment = getMslPaymentFromJson(jsonString);

import 'dart:convert';

List<GetMslPayment> getMslPaymentFromJson(String str) =>
    List<GetMslPayment>.from(
        json.decode(str).map((x) => GetMslPayment.fromJson(x)));

String getMslPaymentToJson(GetMslPayment data) => json.encode(data.toJson());

class GetMslPayment {
  String textCampaign;
  OrderMsl orderMsl;

  GetMslPayment({
    required this.textCampaign,
    required this.orderMsl,
  });

  factory GetMslPayment.fromJson(Map<String, dynamic> json) => GetMslPayment(
        textCampaign: json["TextCampaign"],
        orderMsl: OrderMsl.fromJson(json["OrderMSL"]),
      );

  Map<String, dynamic> toJson() => {
        "TextCampaign": textCampaign,
        "OrderMSL": orderMsl.toJson(),
      };
}

class OrderMsl {
  List<Header> header;

  OrderMsl({
    required this.header,
  });

  factory OrderMsl.fromJson(Map<String, dynamic> json) => OrderMsl(
        header:
            List<Header>.from(json["Header"].map((x) => Header.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Header": List<dynamic>.from(header.map((x) => x.toJson())),
      };
}

class Header {
  String docType;
  String saleCampaign;
  String orderCampaign;
  String invNo;
  String invDate;
  String repCode;
  String repName;
  String totalItems;
  String totalAmount;
  String grossAmount;
  String totalDiscount;
  String status;
  String statusReturn;
  List<Listdetail> listdetail;

  Header({
    required this.docType,
    required this.saleCampaign,
    required this.orderCampaign,
    required this.invNo,
    required this.invDate,
    required this.repCode,
    required this.repName,
    required this.totalItems,
    required this.totalAmount,
    required this.grossAmount,
    required this.totalDiscount,
    required this.status,
    required this.statusReturn,
    required this.listdetail,
  });

  factory Header.fromJson(Map<String, dynamic> json) => Header(
        docType: json["DocType"],
        saleCampaign: json["SaleCampaign"],
        orderCampaign: json["OrderCampaign"],
        invNo: json["InvNo"],
        invDate: json["InvDate"],
        repCode: json["RepCode"],
        repName: json["RepName"],
        totalItems: json["TotalItems"],
        totalAmount: json["TotalAmount"],
        grossAmount: json["GrossAmount"],
        totalDiscount: json["TotalDiscount"],
        status: json["Status"],
        statusReturn: json["Status_Return"],
        listdetail: List<Listdetail>.from(
            json["Listdetail"].map((x) => Listdetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "DocType": docType,
        "SaleCampaign": saleCampaign,
        "OrderCampaign": orderCampaign,
        "InvNo": invNo,
        "InvDate": invDate,
        "RepCode": repCode,
        "RepName": repName,
        "TotalItems": totalItems,
        "TotalAmount": totalAmount,
        "GrossAmount": grossAmount,
        "TotalDiscount": totalDiscount,
        "Status": status,
        "Status_Return": statusReturn,
        "Listdetail": List<dynamic>.from(listdetail.map((x) => x.toJson())),
      };
}

class Listdetail {
  String listno;
  String billCode;
  String billDesc;
  String pathImg;
  String billCamp;
  String qty;
  String price;
  String amount;

  Listdetail({
    required this.listno,
    required this.billCode,
    required this.billDesc,
    required this.pathImg,
    required this.billCamp,
    required this.qty,
    required this.price,
    required this.amount,
  });

  factory Listdetail.fromJson(Map<String, dynamic> json) => Listdetail(
        listno: json["Listno"],
        billCode: json["BillCode"],
        billDesc: json["BillDesc"],
        pathImg: json["PathImg"],
        billCamp: json["BillCamp"],
        qty: json["Qty"],
        price: json["Price"],
        amount: json["Amount"],
      );

  Map<String, dynamic> toJson() => {
        "Listno": listno,
        "BillCode": billCode,
        "BillDesc": billDesc,
        "PathImg": pathImg,
        "BillCamp": billCamp,
        "Qty": qty,
        "Price": price,
        "Amount": amount,
      };
}
