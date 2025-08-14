// To parse this JSON data, do
//
//     final cartProductItems = cartProductItemsFromJson(jsonString);

import 'dart:convert';

List<CartProductItems> cartProductItemsFromJson(String str) =>
    List<CartProductItems>.from(
        json.decode(str).map((x) => CartProductItems.fromJson(x)));

String cartProductItemsToJson(List<CartProductItems> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CartProductItems {
  String brand;
  List<Product> products;

  CartProductItems({
    required this.brand,
    required this.products,
  });

  factory CartProductItems.fromJson(Map<String, dynamic> json) =>
      CartProductItems(
        brand: json["brand"],
        products: List<Product>.from(
            json["Products"].map((x) => Product.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "brand": brand,
        "Products": List<dynamic>.from(products.map((x) => x.toJson())),
      };
}

class Product {
  String productName;
  String productPrice;
  List<String> productImg;

  Product({
    required this.productName,
    required this.productPrice,
    required this.productImg,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        productName: json["productName"],
        productPrice: json["productPrice"],
        productImg: List<String>.from(json["productImg"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "productName": productName,
        "productPrice": productPrice,
        "productImg": List<dynamic>.from(productImg.map((x) => x)),
      };
}
