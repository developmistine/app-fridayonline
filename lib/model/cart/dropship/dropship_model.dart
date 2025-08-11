// To parse this JSON data, do
//
//     final dropship = dropshipFromJson(jsonString);

import 'dart:convert';

Dropship dropshipFromJson(String str) => Dropship.fromJson(json.decode(str));

String dropshipToJson(Dropship data) => json.encode(data.toJson());

class Dropship {
  Dropship({
    required this.cartHeader,
  });

  CartHeader cartHeader;

  factory Dropship.fromJson(Map<String, dynamic> json) => Dropship(
        cartHeader: CartHeader.fromJson(json["CartHeader"]),
      );

  Map<String, dynamic> toJson() => {
        "CartHeader": cartHeader.toJson(),
      };
}

class CartHeader {
  CartHeader({
    required this.repSeq,
    required this.repCode,
    required this.repType,
    required this.totalItem,
    required this.totalAmount,
    required this.cartDetail,
  });

  String repSeq;
  String repCode;
  String repType;
  int totalItem;
  double totalAmount;
  List<CartDetail> cartDetail;

  factory CartHeader.fromJson(Map<String, dynamic> json) => CartHeader(
        repSeq: json["RepSeq"] ?? "",
        repCode: json["RepCode"] ?? "",
        repType: json["RepType"] ?? "",
        totalItem: json["TotalItem"] ?? 0,
        totalAmount: json["TotalAmount"] ?? 0.00,
        cartDetail: json["CartDetail"] == null ? [] : List<CartDetail>.from(
            json["CartDetail"].map((x) => CartDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "RepSeq": repSeq,
        "RepCode": repCode,
        "RepType": repType,
        "TotalItem": totalItem,
        "TotalAmount": totalAmount,
        "CartDetail": List<dynamic>.from(cartDetail.map((x) => x.toJson())),
      };
}

class CartDetail {
  CartDetail({
    required this.listno,
    required this.billCamp,
    required this.billCode,
    required this.billName,
    required this.billImg,
    required this.billB2C,
    required this.qty,
    required this.price,
    required this.priceRegular,
    required this.amount,
    required this.brand,
    required this.brandCode,
    required this.supplierCode,
    required this.media,
    required this.fsCode,
    required this.billColor,
    required this.isInStock,
    required this.stockDescription,
    required this.isChecked,
  });

  int listno;
  String billCamp;
  String billCode;
  String billName;
  String billImg;
  String billB2C;
  int qty;
  double price;
  double priceRegular;
  double amount;
  String brand;
  String brandCode;
  String supplierCode;
  String media;
  String fsCode;
  String billColor;
  bool isInStock;
  String stockDescription;
  bool isChecked;

  factory CartDetail.fromJson(Map<String, dynamic> json) => CartDetail(
        listno: json["Listno"] ?? 0,
        billCamp: json["BillCamp"] ?? "",
        billCode: json["BillCode"] ?? "",
        billName: json["BillName"] ?? "",
        billImg: json["BillImg"] ?? "",
        billB2C: json["BillB2C"] ?? "",
        qty: json["Qty"] ?? 0,
        price: json["Price"] ?? "",
        priceRegular: json["PriceRegular"] ?? "",
        amount: json["Amount"] ?? "",
        brand: json["Brand"] ?? "",
        brandCode: json["BrandCode"] ?? "",
        supplierCode: json["SupplierCode"] ?? "",
        media: json["Media"] ?? "",
        fsCode: json["FSCode"] ?? "",
        billColor: json["BillColor"] ?? "",
        isInStock: json["is_in_stock"],
        stockDescription: json["StockDescription"] ?? "",
        isChecked: json["isChecked"],
      );

  Map<String, dynamic> toJson() => {
        "Listno": listno,
        "BillCamp": billCamp,
        "BillCode": billCode,
        "BillName": billName,
        "BillImg": billImg,
        "BillB2C": billB2C,
        "Qty": qty,
        "Price": price,
        "PriceRegular": priceRegular,
        "Amount": amount,
        "Brand": brand,
        "BrandCode": brandCode,
        "SupplierCode": supplierCode,
        "Media": media,
        "FSCode": fsCode,
        "BillColor": billColor,
        "is_in_stock": isInStock,
        "StockDescription": stockDescription,
        "isChecked": isChecked,
      };
}
