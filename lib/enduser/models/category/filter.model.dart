// To parse this JSON data, do
//
//     final productsFilter = productsFilterFromJson(jsonString);

import 'dart:convert';
import 'package:appfridayecommerce/enduser/models/showproduct/product.category.model.dart';

ProductsFilter productsFilterFromJson(String str) =>
    ProductsFilter.fromJson(json.decode(str));

String productsFilterToJson(ProductsFilter data) => json.encode(data.toJson());

class ProductsFilter {
  String code;
  Data data;
  String message;

  ProductsFilter({
    required this.code,
    required this.data,
    required this.message,
  });

  factory ProductsFilter.fromJson(Map<String, dynamic> json) => ProductsFilter(
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
  List<Datum> products;

  Data({
    required this.total,
    required this.products,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        total: json["total"],
        products:
            List<Datum>.from(json["products"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
      };
}
