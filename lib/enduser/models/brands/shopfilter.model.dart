// To parse this JSON data, do
//
//     final shopProductFilter = shopProductFilterFromJson(jsonString);

import 'dart:convert';

ShopProductFilter shopProductFilterFromJson(String str) =>
    ShopProductFilter.fromJson(json.decode(str));

String shopProductFilterToJson(ShopProductFilter data) =>
    json.encode(data.toJson());

class ShopProductFilter {
  String code;
  Data data;
  String message;

  ShopProductFilter({
    required this.code,
    required this.data,
    required this.message,
  });

  factory ShopProductFilter.fromJson(Map<String, dynamic> json) =>
      ShopProductFilter(
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
  int total;
  List<Product> products;

  Data({
    required this.total,
    required this.products,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        total: json["total"],
        products: List<Product>.from(
            json["products"].map((x) => Product.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
      };
}

class Product {
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

  Product({
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

  factory Product.fromJson(Map<String, dynamic> json) => Product(
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
