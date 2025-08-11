// To parse this JSON data, do
//
//     final b2CReview = b2CReviewFromJson(jsonString);

import 'dart:convert';

B2CReview b2CReviewFromJson(String str) => B2CReview.fromJson(json.decode(str));

String b2CReviewToJson(B2CReview data) => json.encode(data.toJson());

class B2CReview {
  String code;
  Data data;
  String message;

  B2CReview({
    required this.code,
    required this.data,
    required this.message,
  });

  factory B2CReview.fromJson(Map<String, dynamic> json) => B2CReview(
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
  ItemSummary itemSummary;
  List<Rating> ratings;

  Data({
    required this.itemSummary,
    required this.ratings,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        itemSummary: ItemSummary.fromJson(json["item_summary"]),
        ratings:
            List<Rating>.from(json["ratings"].map((x) => Rating.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "item_summary": itemSummary.toJson(),
        "ratings": List<dynamic>.from(ratings.map((x) => x.toJson())),
      };
}

class ItemSummary {
  double totalRating;
  List<int> ratingCount;
  int countReview;

  ItemSummary({
    required this.totalRating,
    required this.ratingCount,
    required this.countReview,
  });

  factory ItemSummary.fromJson(Map<String, dynamic> json) => ItemSummary(
        totalRating: json["total_rating"]?.toDouble(),
        ratingCount: List<int>.from(json["rating_count"].map((x) => x)),
        countReview: json["count_review"],
      );

  Map<String, dynamic> toJson() => {
        "total_rating": totalRating,
        "rating_count": List<dynamic>.from(ratingCount.map((x) => x)),
        "count_review": countReview,
      };
}

class Rating {
  int custId;
  String custName;
  String custImage;
  double ratingStar;
  int likeCounts;
  String comment;
  String option;
  String creDate;
  int qty;
  DetailRating detailRating;
  RatingReply ratingReply;
  List<String> video;
  List<String> images;

  Rating({
    required this.custId,
    required this.custName,
    required this.custImage,
    required this.ratingStar,
    required this.likeCounts,
    required this.comment,
    required this.option,
    required this.creDate,
    required this.qty,
    required this.detailRating,
    required this.ratingReply,
    required this.video,
    required this.images,
  });

  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
        custId: json["cust_id"],
        custName: json["cust_name"],
        custImage: json["cust_image"],
        ratingStar: json["rating_star"]?.toDouble(),
        likeCounts: json["like_counts"],
        comment: json["comment"],
        option: json["option"],
        creDate: json["cre_date"],
        qty: json["qty"],
        detailRating: DetailRating.fromJson(json["detail_rating"]),
        ratingReply: RatingReply.fromJson(json["rating_reply"]),
        video: List<String>.from(json["video"].map((x) => x)),
        images: List<String>.from(json["images"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "cust_id": custId,
        "cust_name": custName,
        "cust_image": custImage,
        "rating_star": ratingStar,
        "like_counts": likeCounts,
        "comment": comment,
        "option": option,
        "cre_date": creDate,
        "qty": qty,
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
