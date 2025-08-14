// To parse this JSON data, do
//
//     final reviewed = reviewedFromJson(jsonString);

import 'dart:convert';

Reviewed reviewedFromJson(String str) => Reviewed.fromJson(json.decode(str));

String reviewedToJson(Reviewed data) => json.encode(data.toJson());

class Reviewed {
  String code;
  List<Datum> data;
  String message;

  Reviewed({
    required this.code,
    required this.data,
    required this.message,
  });

  factory Reviewed.fromJson(Map<String, dynamic> json) => Reviewed(
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
  int custId;
  String custName;
  String custImage;
  double ratingStar;
  String comment;
  String creDate;
  int productId;
  String productName;
  List<Item> items;
  DetailRating detailRating;
  RatingReply ratingReply;
  List<dynamic> video;
  List<dynamic> images;

  Datum({
    required this.custId,
    required this.custName,
    required this.custImage,
    required this.ratingStar,
    required this.comment,
    required this.creDate,
    required this.productId,
    required this.productName,
    required this.items,
    required this.detailRating,
    required this.ratingReply,
    required this.video,
    required this.images,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        custId: json["cust_id"],
        custName: json["cust_name"],
        custImage: json["cust_image"],
        ratingStar: json["rating_star"]?.toDouble(),
        comment: json["comment"],
        creDate: json["cre_date"],
        productId: json["product_id"],
        productName: json["product_name"],
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
        detailRating: DetailRating.fromJson(json["detail_rating"]),
        ratingReply: RatingReply.fromJson(json["rating_reply"]),
        video: List<dynamic>.from(json["video"].map((x) => x)),
        images: List<dynamic>.from(json["images"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "cust_id": custId,
        "cust_name": custName,
        "cust_image": custImage,
        "rating_star": ratingStar,
        "comment": comment,
        "cre_date": creDate,
        "product_id": productId,
        "product_name": productName,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
        "detail_rating": detailRating.toJson(),
        "rating_reply": ratingReply.toJson(),
        "video": List<dynamic>.from(video.map((x) => x)),
        "images": List<dynamic>.from(images.map((x) => x)),
      };
}

class DetailRating {
  double productQuality;
  double deliveryService;

  DetailRating({
    required this.productQuality,
    required this.deliveryService,
  });

  factory DetailRating.fromJson(Map<String, dynamic> json) => DetailRating(
        productQuality: json["product_quality"]?.toDouble(),
        deliveryService: json["delivery_service"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "product_quality": productQuality,
        "delivery_service": deliveryService,
      };
}

class Item {
  int itemId;
  String itemImg;
  String option;

  Item({
    required this.itemId,
    required this.itemImg,
    required this.option,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        itemId: json["item_id"],
        itemImg: json["item_img"],
        option: json["option"],
      );

  Map<String, dynamic> toJson() => {
        "item_id": itemId,
        "item_img": itemImg,
        "option": option,
      };
}

class RatingReply {
  int shopId;
  String comment;

  RatingReply({
    required this.shopId,
    required this.comment,
  });

  factory RatingReply.fromJson(Map<String, dynamic> json) => RatingReply(
        shopId: json["shop_id"],
        comment: json["comment"],
      );

  Map<String, dynamic> toJson() => {
        "shop_id": shopId,
        "comment": comment,
      };
}
