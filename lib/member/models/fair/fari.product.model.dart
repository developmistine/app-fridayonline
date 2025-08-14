// To parse this JSON data, do
//
//     final fairsTopProduct = fairsTopProductFromJson(jsonString);

import 'dart:convert';

FairsTopProduct fairsTopProductFromJson(String str) =>
    FairsTopProduct.fromJson(json.decode(str));

String fairsTopProductToJson(FairsTopProduct data) =>
    json.encode(data.toJson());

class FairsTopProduct {
  String code;
  Data data;
  String message;

  FairsTopProduct({
    required this.code,
    required this.data,
    required this.message,
  });

  factory FairsTopProduct.fromJson(Map<String, dynamic> json) =>
      FairsTopProduct(
        code: json["code"],
        data: Data.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "data": data.toJson(),
        "message": message,
      };
}

class Data {
  String title;
  List<TopProduct> topProducts;

  Data({
    required this.title,
    required this.topProducts,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        title: json["title"],
        topProducts: List<TopProduct>.from(
            json["top_products"].map((x) => TopProduct.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "top_products": List<dynamic>.from(topProducts.map((x) => x.toJson())),
      };
}

class TopProduct {
  String icon;
  int productId;
  String title;
  int discount;
  int price;
  int priceBeforeDiscount;
  List<dynamic> labels;
  int ratingStar;
  bool haveVideo;
  String unitSales;
  String image;
  String currency;
  bool isImageOverlayed;
  String imageOverlay;
  bool isOutOfStock;

  TopProduct({
    required this.icon,
    required this.productId,
    required this.title,
    required this.discount,
    required this.price,
    required this.priceBeforeDiscount,
    required this.labels,
    required this.ratingStar,
    required this.haveVideo,
    required this.unitSales,
    required this.image,
    required this.currency,
    required this.isImageOverlayed,
    required this.imageOverlay,
    required this.isOutOfStock,
  });

  factory TopProduct.fromJson(Map<String, dynamic> json) => TopProduct(
        icon: json["icon"],
        productId: json["product_id"],
        title: json["title"],
        discount: json["discount"],
        price: json["price"],
        priceBeforeDiscount: json["price_before_discount"],
        labels: List<dynamic>.from(json["labels"].map((x) => x)),
        ratingStar: json["rating_star"],
        haveVideo: json["have_video"],
        unitSales: json["unit_sales"],
        image: json["image"],
        currency: json["currency"],
        isImageOverlayed: json["is_image_overlayed"],
        imageOverlay: json["image_overlay"],
        isOutOfStock: json["is_out_of_stock"],
      );

  Map<String, dynamic> toJson() => {
        "icon": icon,
        "product_id": productId,
        "title": title,
        "discount": discount,
        "price": price,
        "price_before_discount": priceBeforeDiscount,
        "labels": List<dynamic>.from(labels.map((x) => x)),
        "rating_star": ratingStar,
        "have_video": haveVideo,
        "unit_sales": unitSales,
        "image": image,
        "currency": currency,
        "is_image_overlayed": isImageOverlayed,
        "image_overlay": imageOverlay,
        "is_out_of_stock": isOutOfStock,
      };
}
