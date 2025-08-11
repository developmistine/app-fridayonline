// To parse this JSON data, do
//
//     final getDropshipSearchProduct = getDropshipSearchProductFromJson(jsonString);

// import 'package:meta/meta.dart';
import 'dart:convert';

List<GetDropshipSearchProduct> getDropshipSearchProductFromJson(String str) =>
    List<GetDropshipSearchProduct>.from(
        json.decode(str).map((x) => GetDropshipSearchProduct.fromJson(x)));

String getDropshipSearchProductToJson(List<GetDropshipSearchProduct> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetDropshipSearchProduct {
  GetDropshipSearchProduct({
    required this.category1,
    required this.cate1Desc,
    required this.billCode,
    required this.nameTh,
    required this.productCode,
    required this.price,
    required this.priceSpecial,
    required this.color,
    required this.stockQty,
    required this.imageUrl,
    required this.campaign,
    required this.typeProject,
    required this.billYup,
    required this.supplierCode,
    required this.deliveryType,
    required this.paymentType,
  });

  String category1;
  String cate1Desc;
  String billCode;
  String nameTh;
  String productCode;
  String price;
  String priceSpecial;
  String color;
  String stockQty;
  String imageUrl;
  String campaign;
  String typeProject;
  String billYup;
  String supplierCode;
  String deliveryType;
  String paymentType;

  factory GetDropshipSearchProduct.fromJson(Map<String, dynamic> json) =>
      GetDropshipSearchProduct(
        category1: json["Category1"] ?? "",
        cate1Desc: json["Cate1Desc"] ?? "",
        billCode: json["BillCode"] ?? "",
        nameTh: json["NameTH"] ?? "",
        productCode: json["ProductCode"] ?? "",
        price: json["Price"] ?? "",
        priceSpecial: json["PriceSpecial"] ?? "",
        color: json["Color"] ?? "",
        stockQty: json["StockQty"] ?? "",
        imageUrl: json["ImageUrl"] ?? "",
        campaign: json["Campaign"] ?? "",
        typeProject: json["TypeProject"] ?? "",
        billYup: json["Bill_YUP"] ?? "",
        supplierCode: json["SupplierCode"] ?? "",
        deliveryType: json["DeliveryType"] ?? "",
        paymentType: json["PaymentType"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "Category1": category1,
        "Cate1Desc": cate1Desc,
        "BillCode": billCode,
        "NameTH": nameTh,
        "ProductCode": productCode,
        "Price": price,
        "PriceSpecial": priceSpecial,
        "Color": color,
        "StockQty": stockQty,
        "ImageUrl": imageUrl,
        "Campaign": campaign,
        "TypeProject": typeProject,
        "Bill_YUP": billYup,
        "SupplierCode": supplierCode,
        "DeliveryType": deliveryType,
        "PaymentType": paymentType,
      };
}
