// To parse this JSON data, do
//
//     final dashBoardProducts = dashBoardProductsFromJson(jsonString);

import 'dart:convert';

DashBoardProducts dashBoardProductsFromJson(String str) =>
    DashBoardProducts.fromJson(json.decode(str));

String dashBoardProductsToJson(DashBoardProducts data) =>
    json.encode(data.toJson());

class DashBoardProducts {
  String code;
  DashBoardProductsData data;
  String message;

  DashBoardProducts({
    required this.code,
    required this.data,
    required this.message,
  });

  factory DashBoardProducts.fromJson(Map<String, dynamic> json) =>
      DashBoardProducts(
        code: json["code"],
        data: DashBoardProductsData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "data": data.toJson(),
        "message": message,
      };
}

class DashBoardProductsData {
  int total;
  List<Product> products;

  DashBoardProductsData({
    required this.total,
    required this.products,
  });

  factory DashBoardProductsData.fromJson(Map<String, dynamic> json) =>
      DashBoardProductsData(
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
  int productId;
  String title;
  String image;
  String placedUnits;
  String placedSales;
  String commisionEstimate;

  Product({
    required this.productId,
    required this.title,
    required this.image,
    required this.placedUnits,
    required this.placedSales,
    required this.commisionEstimate,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        productId: json["product_id"],
        title: json["title"],
        image: json["image"],
        placedUnits: json["placed_units"],
        placedSales: json["placed_sales"],
        commisionEstimate: json["commision_estimate"],
      );

  Map<String, dynamic> toJson() => {
        "product_id": productId,
        "title": title,
        "image": image,
        "placed_units": placedUnits,
        "placed_sales": placedSales,
        "commision_estimate": commisionEstimate,
      };
}
