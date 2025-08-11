// To parse this JSON data, do
//
//     final saleproductbyrepseq = saleproductbyrepseqFromJson(jsonString);

import 'dart:convert';

List<Saleproductbyrepseq> saleproductbyrepseqFromJson(String str) =>
    List<Saleproductbyrepseq>.from(
        json.decode(str).map((x) => Saleproductbyrepseq.fromJson(x)));

String saleproductbyrepseqToJson(List<Saleproductbyrepseq> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Saleproductbyrepseq {
  String campaign;
  String billCode;
  String brand;
  String mediaCode;
  String sku;
  String name;
  String img;
  int price;
  int specialPrice;
  String billColor;
  bool isInStock;
  String imgAppend;
  String flagNetPrice;
  String flagHouseBrand;
  String imgNetPrice;
  String limitDescription;
  int totalReview;
  double ratingProduct;

  Saleproductbyrepseq(
      {required this.campaign,
      required this.billCode,
      required this.brand,
      required this.mediaCode,
      required this.sku,
      required this.name,
      required this.img,
      required this.price,
      required this.specialPrice,
      required this.billColor,
      required this.isInStock,
      required this.imgAppend,
      required this.flagNetPrice,
      required this.flagHouseBrand,
      required this.imgNetPrice,
      required this.limitDescription,
      required this.totalReview,
      required this.ratingProduct});

  factory Saleproductbyrepseq.fromJson(Map<String, dynamic> json) =>
      Saleproductbyrepseq(
        campaign: json["Campaign"],
        billCode: json["billCode"],
        brand: json["brand"],
        mediaCode: json["MediaCode"],
        sku: json["sku"],
        name: json["name"],
        img: json["img"],
        price: json["price"],
        specialPrice: json["special_price"],
        billColor: json["BillColor"],
        isInStock: json["is_in_stock"],
        imgAppend: json["ImgAppend"],
        flagNetPrice: json["flagNetPrice"],
        flagHouseBrand: json["flagHouseBrand"],
        imgNetPrice: json["imgNetPrice"],
        limitDescription: json["limit_description"] ?? "",
        totalReview: json["TotalReview"] ?? 0,
        ratingProduct: json["RatingProduct"]?.toDouble() ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        "Campaign": campaign,
        "billCode": billCode,
        "brand": brand,
        "MediaCode": mediaCode,
        "sku": sku,
        "name": name,
        "img": img,
        "price": price,
        "special_price": specialPrice,
        "BillColor": billColor,
        "is_in_stock": isInStock,
        "ImgAppend": imgAppend,
        "flagNetPrice": flagNetPrice,
        "flagHouseBrand": flagHouseBrand,
        "imgNetPrice": imgNetPrice,
        "limit_description": limitDescription,
        "TotalReview": totalReview,
        "RatingProduct": ratingProduct,
      };
}
