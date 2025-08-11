// To parse this JSON data, do
//
//     final homeContent = homeContentFromJson(jsonString);

import 'dart:convert';

HomeContent homeContentFromJson(String str) =>
    HomeContent.fromJson(json.decode(str));

String homeContentToJson(HomeContent data) => json.encode(data.toJson());

class HomeContent {
  String code;
  Data data;
  String message;

  HomeContent({
    required this.code,
    required this.data,
    required this.message,
  });

  factory HomeContent.fromJson(Map<String, dynamic> json) => HomeContent(
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
  List<ContentTypeDetail> contentTypeDetail;

  Data({
    required this.contentHeader,
    required this.contentImg,
    required this.contentTypeDetail,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        contentHeader: json["content_header"],
        contentImg: json["content_img"],
        contentTypeDetail: List<ContentTypeDetail>.from(
            json["content_type_detail"]
                .map((x) => ContentTypeDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "content_header": contentHeader,
        "content_img": contentImg,
        "content_type_detail":
            List<dynamic>.from(contentTypeDetail.map((x) => x.toJson())),
      };
}

class ContentTypeDetail {
  int contentType;
  List<ContentDetail> contentDetail;

  ContentTypeDetail({
    required this.contentType,
    required this.contentDetail,
  });

  factory ContentTypeDetail.fromJson(Map<String, dynamic> json) =>
      ContentTypeDetail(
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
  String contentName;
  DateTime startDate;
  DateTime endDate;
  String image;
  String imageDesktop;
  List<ProductContent> productContent;

  ContentDetail({
    required this.contentId,
    required this.actionType,
    required this.actionValue,
    required this.contentName,
    required this.startDate,
    required this.endDate,
    required this.image,
    required this.imageDesktop,
    required this.productContent,
  });

  factory ContentDetail.fromJson(Map<String, dynamic> json) => ContentDetail(
        contentId: json["content_id"],
        actionType: json["action_type"],
        actionValue: json["action_value"],
        contentName: json["content_name"],
        startDate: DateTime.parse(json["start_date"]),
        endDate: DateTime.parse(json["end_date"]),
        image: json["image"],
        imageDesktop: json["image_desktop"],
        productContent: List<ProductContent>.from(
            json["product_content"].map((x) => ProductContent.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "content_id": contentId,
        "action_type": actionType,
        "action_value": actionValue,
        "content_name": contentName,
        "start_date": startDate.toIso8601String(),
        "end_date": endDate.toIso8601String(),
        "image": image,
        "image_desktop": imageDesktop,
        "product_content":
            List<dynamic>.from(productContent.map((x) => x.toJson())),
      };
}

class ProductContent {
  String icon;
  int productId;
  String title;
  int discount;
  double price;
  double? priceBeforeDiscount;
  List<dynamic> labels;
  double ratingStar;
  bool haveVideo;
  String unitSales;
  String image;
  String currency;
  bool isImageOverlayed;
  String imageOverlay;
  bool isOutOfStock;

  ProductContent({
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

  factory ProductContent.fromJson(Map<String, dynamic> json) => ProductContent(
        icon: json["icon"],
        productId: json["product_id"],
        title: json["title"],
        discount: json["discount"],
        price: json["price"]?.toDouble(),
        priceBeforeDiscount: json["price_before_discount"] != null
            ? json["price_before_discount"]?.toDouble()
            : 0.0,
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
