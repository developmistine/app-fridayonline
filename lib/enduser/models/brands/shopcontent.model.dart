// To parse this JSON data, do
//
//     final shopContent = shopContentFromJson(jsonString);

import 'dart:convert';
import 'package:fridayonline/enduser/models/home/home.content.model.dart';

ShopContent shopContentFromJson(String str) =>
    ShopContent.fromJson(json.decode(str));

String shopContentToJson(ShopContent data) => json.encode(data.toJson());

class ShopContent {
  String code;
  List<Datum> data;
  String message;

  ShopContent({
    required this.code,
    required this.data,
    required this.message,
  });

  factory ShopContent.fromJson(Map<String, dynamic> json) => ShopContent(
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
  int contentType;
  List<ContentDetail> contentDetail;

  Datum({
    required this.contentType,
    required this.contentDetail,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        contentType: json["content_type"],
        contentDetail: List<ContentDetail>.from(
            json["content_detail"].map((x) => ContentDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "content_type": contentType,
        "content_detail":
            List<dynamic>.from(contentDetail.map((x) => x.toJson())),
      };
}

class ContentDetail {
  int contentId;
  int actionType;
  String actionValue;
  bool showContentName;
  String contentName;
  String startDate;
  String endDate;
  bool showImage;
  String image;
  String imageDesktop;
  List<ProductContent> productContent;

  ContentDetail({
    required this.contentId,
    required this.actionType,
    required this.actionValue,
    required this.showContentName,
    required this.contentName,
    required this.startDate,
    required this.endDate,
    required this.showImage,
    required this.image,
    required this.imageDesktop,
    required this.productContent,
  });

  factory ContentDetail.fromJson(Map<String, dynamic> json) => ContentDetail(
        contentId: json["content_id"],
        actionType: json["action_type"],
        actionValue: json["action_value"],
        showContentName: json["show_content_name"],
        contentName: json["content_name"],
        startDate: json["start_date"],
        endDate: json["end_date"],
        showImage: json["show_image"],
        image: json["image"],
        imageDesktop: json["image_desktop"],
        productContent: List<ProductContent>.from(
            json["product_content"].map((x) => ProductContent.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "content_id": contentId,
        "action_type": actionType,
        "action_value": actionValue,
        "show_content_name": showContentName,
        "content_name": contentName,
        "start_date": startDate,
        "end_date": endDate,
        "show_image": showImage,
        "image": image,
        "image_desktop": imageDesktop,
        "product_content":
            List<dynamic>.from(productContent.map((x) => x.toJson())),
      };
}

// class ProductContent {
//   String icon;
//   int productId;
//   String title;
//   int discount;
//   double price;
//   double priceBeforeDiscount;
//   List<dynamic> labels;
//   int ratingStar;
//   bool haveVideo;
//   String unitSales;
//   String image;
//   String currency;

//   ProductContent({
//     required this.icon,
//     required this.productId,
//     required this.title,
//     required this.discount,
//     required this.price,
//     required this.priceBeforeDiscount,
//     required this.labels,
//     required this.ratingStar,
//     required this.haveVideo,
//     required this.unitSales,
//     required this.image,
//     required this.currency,
//   });

//   factory ProductContent.fromJson(Map<String, dynamic> json) => ProductContent(
//         icon: json["icon"],
//         productId: json["product_id"],
//         title: json["title"],
//         discount: json["discount"],
//         price: json["price"]?.toDouble(),
//         priceBeforeDiscount: json["price_before_discount"]?.toDouble(),
//         labels: List<dynamic>.from(json["labels"].map((x) => x)),
//         ratingStar: json["rating_star"],
//         haveVideo: json["have_video"],
//         unitSales: json["unit_sales"],
//         image: json["image"],
//         currency: json["currency"],
//       );

//   Map<String, dynamic> toJson() => {
//         "icon": icon,
//         "product_id": productId,
//         "title": title,
//         "discount": discount,
//         "price": price,
//         "price_before_discount": priceBeforeDiscount,
//         "labels": List<dynamic>.from(labels.map((x) => x)),
//         "rating_star": ratingStar,
//         "have_video": haveVideo,
//         "unit_sales": unitSales,
//         "image": image,
//         "currency": currency,
//       };
// }
