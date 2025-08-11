// To parse this JSON data, do
//
//     final productRecommend = productRecommendFromJson(jsonString);

import 'dart:convert';

ProductRecommend productRecommendFromJson(String str) =>
    ProductRecommend.fromJson(json.decode(str));

String productRecommendToJson(ProductRecommend data) =>
    json.encode(data.toJson());

class ProductRecommend {
  String code;
  List<Datum> data;
  String message;

  ProductRecommend({
    required this.code,
    required this.data,
    required this.message,
  });

  factory ProductRecommend.fromJson(Map<String, dynamic> json) =>
      ProductRecommend(
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
  String icon;
  int productId;
  String title;
  double discount;
  double price;
  double priceBeforeDiscount;
  List<dynamic> labels;
  double ratingStar;
  bool haveVideo;
  String unitSales;
  String image;
  String currency;
  bool isImageOverlayed;
  String imageOverlay;
  bool isOutOfStock;

  Datum({
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

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        icon: json["icon"],
        productId: json["product_id"],
        title: json["title"],
        discount: json["discount"]?.toDouble(),
        price: json["price"]?.toDouble(),
        priceBeforeDiscount: json["price_before_discount"]?.toDouble(),
        labels: List<dynamic>.from(json["labels"].map((x) => x)),
        ratingStar: json["rating_star"]?.toDouble(),
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
