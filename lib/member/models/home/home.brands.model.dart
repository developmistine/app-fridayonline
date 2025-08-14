// To parse this JSON data, do
//
//     final homeBrands = homeBrandsFromJson(jsonString);

import 'dart:convert';

HomeBrands homeBrandsFromJson(String str) =>
    HomeBrands.fromJson(json.decode(str));

String homeBrandsToJson(HomeBrands data) => json.encode(data.toJson());

class HomeBrands {
  String code;
  List<Datum> data;
  String message;

  HomeBrands({
    required this.code,
    required this.data,
    required this.message,
  });

  factory HomeBrands.fromJson(Map<String, dynamic> json) => HomeBrands(
        code: json["code"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
      };
}

class Datum {
  int brandId;
  int? sectionId;
  int? viewType;
  String brandName;
  int sellerId;
  String icon;
  String productImage;
  String textDisplay;

  Datum({
    required this.brandId,
    required this.sectionId,
    required this.viewType,
    required this.brandName,
    required this.sellerId,
    required this.icon,
    required this.productImage,
    required this.textDisplay,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        brandId: json["brand_id"],
        sectionId: json["section_id"] ?? 0,
        viewType: json["view_type"] ?? 0,
        brandName: json["brand_name"],
        sellerId: json["seller_id"],
        icon: json["icon"],
        productImage: json["product_image"],
        textDisplay: json["text_display"],
      );

  Map<String, dynamic> toJson() => {
        "brand_id": brandId,
        "section_id": sectionId,
        "view_type": viewType,
        "brand_name": brandName,
        "seller_id": sellerId,
        "icon": icon,
        "product_image": productImage,
        "text_display": textDisplay,
      };
}
