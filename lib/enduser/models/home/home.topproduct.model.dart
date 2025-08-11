// To parse this JSON data, do
//
//     final topProductsWeekly = topProductsWeeklyFromJson(jsonString);

import 'dart:convert';

TopProductsWeekly topProductsWeeklyFromJson(String str) =>
    TopProductsWeekly.fromJson(json.decode(str));

String topProductsWeeklyToJson(TopProductsWeekly data) =>
    json.encode(data.toJson());

class TopProductsWeekly {
  String code;
  Data data;
  String message;

  TopProductsWeekly({
    required this.code,
    required this.data,
    required this.message,
  });

  factory TopProductsWeekly.fromJson(Map<String, dynamic> json) =>
      TopProductsWeekly(
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
  int subcatId;
  int prodlineId;
  String name;
  String displayName;
  List<TopProduct> topProducts;

  Data({
    required this.subcatId,
    required this.prodlineId,
    required this.name,
    required this.displayName,
    required this.topProducts,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        subcatId: json["subcat_id"],
        prodlineId: json["prodline_id"],
        name: json["name"],
        displayName: json["display_name"],
        topProducts: List<TopProduct>.from(
            json["top_products"].map((x) => TopProduct.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "subcat_id": subcatId,
        "prodline_id": prodlineId,
        "name": name,
        "display_name": displayName,
        "top_products": List<dynamic>.from(topProducts.map((x) => x.toJson())),
      };
}

class TopProduct {
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

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
