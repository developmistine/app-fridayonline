// To parse this JSON data, do
//
//     final bundleDeal = bundleDealFromJson(jsonString);

import 'dart:convert';

BundleDeal bundleDealFromJson(String str) =>
    BundleDeal.fromJson(json.decode(str));

String bundleDealToJson(BundleDeal data) => json.encode(data.toJson());

class BundleDeal {
  String code;
  Data data;
  String message;

  BundleDeal({
    required this.code,
    required this.data,
    required this.message,
  });

  factory BundleDeal.fromJson(Map<String, dynamic> json) => BundleDeal(
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
  int bundleDealId;
  String bundleDealDetail;
  List<BundleDealProduct> bundleDealProducts;

  Data({
    required this.bundleDealId,
    required this.bundleDealDetail,
    required this.bundleDealProducts,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        bundleDealId: json["bundle_deal_id"],
        bundleDealDetail: json["bundle_deal_detail"],
        bundleDealProducts: List<BundleDealProduct>.from(
            json["bundle_deal_products"]
                .map((x) => BundleDealProduct.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "bundle_deal_id": bundleDealId,
        "bundle_deal_detail": bundleDealDetail,
        "bundle_deal_products":
            List<dynamic>.from(bundleDealProducts.map((x) => x.toJson())),
      };
}

class BundleDealProduct {
  String icon;
  int productId;
  String title;
  double discount;
  int price;
  double priceBeforeDiscount;
  List<dynamic> labels;
  int ratingStar;
  bool haveVideo;
  String unitSales;
  String image;
  String currency;
  bool isImageOverlayed;
  String imageOverlay;
  bool isOutOfStock;

  BundleDealProduct({
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

  factory BundleDealProduct.fromJson(Map<String, dynamic> json) =>
      BundleDealProduct(
        icon: json["icon"],
        productId: json["product_id"],
        title: json["title"],
        discount: json["discount"]?.toDouble(),
        price: json["price"],
        priceBeforeDiscount: json["price_before_discount"]?.toDouble(),
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
