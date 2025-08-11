// To parse this JSON data, do
//
//     final productByFscode = productByFscodeFromJson(jsonString);

// import 'package:meta/meta.dart';
import 'dart:convert';

ProductByFscode productByFscodeFromJson(String str) =>
    ProductByFscode.fromJson(json.decode(str));

String productByFscodeToJson(ProductByFscode data) =>
    json.encode(data.toJson());

class ProductByFscode {
  ProductByFscode({
    required this.point,
    required this.pointandmoney,
  });

  List<Point> point;
  List<Point> pointandmoney;

  factory ProductByFscode.fromJson(Map<String, dynamic> json) =>
      ProductByFscode(
        pointandmoney: json["Pointandmoney"] == null
            ? []
            : List<Point>.from(
                json["Pointandmoney"].map((x) => Point.fromJson(x))),
        point: json["Point"] == null
            ? []
            : List<Point>.from(json["Point"].map((x) => Point.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Point": List<dynamic>.from(point.map((x) => x.toJson())),
        "Pointandmoney":
            List<dynamic>.from(pointandmoney.map((x) => x.toJson())),
      };
}

class Point {
  Point({
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
    required this.productDetail,
    required this.isStock,
  });

  String imageUrl;
  String productCode;
  String cateCamp;
  String mediaCode;
  String nameTh;
  String nameEn;
  String shortNameTh;
  int pointPrice;
  double price;
  String productType;
  String productDetail;
  bool isStock;

  factory Point.fromJson(Map<String, dynamic> json) => Point(
        imageUrl: json["ImageUrl"] ?? "",
        productCode: json["ProductCode"] ?? "",
        cateCamp: json["CateCamp"] ?? "",
        mediaCode: json["MediaCode"] ?? "",
        nameTh: json["NameTh"] ?? "",
        nameEn: json["NameEn"] ?? "",
        shortNameTh: json["ShortNameTh"] ?? "",
        pointPrice: json["PointPrice"] ?? 0,
        price: double.parse(json["Price"] ?? 0.00),
        productType: json["ProductType"] ?? "",
        productDetail: json["ProductDetail"] ?? "",
        isStock: json["IsStock"] ?? "",
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
        "ProductDetail": productDetail,
        "IsStock": isStock,
      };
}
