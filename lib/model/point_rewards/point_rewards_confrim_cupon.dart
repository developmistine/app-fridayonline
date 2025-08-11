// To parse this JSON data, do
//
//     final pointConfrimCupon = pointConfrimCuponFromJson(jsonString);

// import 'package:meta/meta.dart';
import 'dart:convert';

PointConfrimCupon pointConfrimCuponFromJson(String str) =>
    PointConfrimCupon.fromJson(json.decode(str));

String pointConfrimCuponToJson(PointConfrimCupon data) =>
    json.encode(data.toJson());

class PointConfrimCupon {
  PointConfrimCupon({
    required this.repSeq,
    required this.proint,
    required this.productlist,
  });

  String repSeq;
  String proint;
  List<Productlist> productlist;

  factory PointConfrimCupon.fromJson(Map<String, dynamic> json) =>
      PointConfrimCupon(
        repSeq: json["RepSeq"] ?? "",
        proint: json["Proint"] ?? "",
        productlist: json["Productlist"] == null
            ? []
            : List<Productlist>.from(
                json["Productlist"].map((x) => Productlist.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "RepSeq": repSeq,
        "Proint": proint,
        "Productlist": List<dynamic>.from(productlist.map((x) => x.toJson())),
      };
}

class Productlist {
  Productlist({
    required this.imageUrl,
    required this.productCode,
    required this.cateCamp,
    required this.mediaCode,
    required this.nameTh,
    required this.nameEn,
    required this.shortNameTh,
    required this.pointPrice,
    required this.price,
    required this.productType,
    required this.qtyConfirm,
  });

  String imageUrl;
  String productCode;
  String cateCamp;
  String mediaCode;
  String nameTh;
  String nameEn;
  String shortNameTh;
  String pointPrice;
  String price;
  String productType;
  int qtyConfirm;

  factory Productlist.fromJson(Map<String, dynamic> json) => Productlist(
        imageUrl: json["ImageUrl"] ?? "",
        productCode: json["ProductCode"] ?? "",
        cateCamp: json["CateCamp"] ?? "",
        mediaCode: json["MediaCode"] ?? "",
        nameTh: json["NameTh"] ?? "",
        nameEn: json["NameEn"] ?? "",
        shortNameTh: json["ShortNameTh"] ?? "",
        pointPrice: json["PointPrice"] ?? "",
        price: json["Price"] ?? "",
        productType: json["ProductType"] ?? "",
        qtyConfirm: json["QtyConfirm"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "ImageUrl": imageUrl,
        "ProductCode": productCode,
        "CateCamp": cateCamp,
        "MediaCode": mediaCode,
        "NameTh": nameTh,
        "NameEn": nameEn,
        "ShortNameTh": shortNameTh,
        "PointPrice": pointPrice,
        "Price": price,
        "ProductType": productType,
        "QtyConfirm": qtyConfirm,
      };
}
