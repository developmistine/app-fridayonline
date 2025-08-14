// To parse this JSON data, do
//
//     final b2CFlashSale = b2CFlashSaleFromJson(jsonString);

import 'dart:convert';

B2CFlashSale b2CFlashSaleFromJson(String str) =>
    B2CFlashSale.fromJson(json.decode(str));

String b2CFlashSaleToJson(B2CFlashSale data) => json.encode(data.toJson());

class B2CFlashSale {
  String code;
  Data data;
  String message;

  B2CFlashSale({
    required this.code,
    required this.data,
    required this.message,
  });

  factory B2CFlashSale.fromJson(Map<String, dynamic> json) => B2CFlashSale(
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
  String contentHeader;
  String contentImg;
  int contentId;
  String startDate;
  String endDate;
  List<ProductContent> productContent;

  Data({
    required this.contentHeader,
    required this.contentImg,
    required this.contentId,
    required this.startDate,
    required this.endDate,
    required this.productContent,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        contentHeader: json["content_header"],
        contentImg: json["content_img"],
        contentId: json["content_id"] ?? 0,
        startDate: json["start_date"],
        endDate: json["end_date"],
        productContent: List<ProductContent>.from(
            json["product_content"].map((x) => ProductContent.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "content_header": contentHeader,
        "content_img": contentImg,
        "content_id": contentId,
        "start_date": startDate,
        "end_date": endDate,
        "product_content":
            List<dynamic>.from(productContent.map((x) => x.toJson())),
      };
}

class ProductContent {
  int productId;
  String title;
  int price;
  int discount;
  int priceBeforeDiscount;
  List<dynamic> labels;
  int flashSaleStock;
  int stock;
  bool isShopOfficial;
  String image;
  String currency;
  bool isImageOverlayed;
  String imageOverlay;
  bool isOutOfStock;

  ProductContent(
      {required this.productId,
      required this.title,
      required this.price,
      required this.discount,
      required this.priceBeforeDiscount,
      required this.labels,
      required this.flashSaleStock,
      required this.stock,
      required this.isShopOfficial,
      required this.image,
      required this.currency,
      required this.isImageOverlayed,
      required this.imageOverlay,
      required this.isOutOfStock});

  factory ProductContent.fromJson(Map<String, dynamic> json) => ProductContent(
        productId: json["product_id"],
        title: json["title"],
        price: json["price"],
        discount: json["discount"],
        priceBeforeDiscount: json["price_before_discount"],
        labels: List<dynamic>.from(json["labels"].map((x) => x)),
        flashSaleStock: json["flash_sale_stock"],
        stock: json["stock"],
        isShopOfficial: json["is_shop_official"],
        image: json["image"],
        currency: json["currency"],
        isImageOverlayed: json["is_image_overlayed"],
        imageOverlay: json["image_overlay"],
        isOutOfStock: json["is_out_of_stock"],
      );

  Map<String, dynamic> toJson() => {
        "product_id": productId,
        "title": title,
        "price": price,
        "discount": discount,
        "price_before_discount": priceBeforeDiscount,
        "labels": List<dynamic>.from(labels.map((x) => x)),
        "flash_sale_stock": flashSaleStock,
        "stock": stock,
        "is_shop_official": isShopOfficial,
        "image": image,
        "currency": currency,
        "is_image_overlayed": isImageOverlayed,
        "image_overlay": imageOverlay,
        "is_out_of_stock": isOutOfStock,
      };
}
