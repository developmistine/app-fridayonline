// To parse this JSON data, do
//
//     final reviewsProduct = reviewsProductFromJson(jsonString);

import 'dart:convert';

ReviewsProduct reviewsProductFromJson(String str) =>
    ReviewsProduct.fromJson(json.decode(str));

String reviewsProductToJson(ReviewsProduct data) => json.encode(data.toJson());

class ReviewsProduct {
  String fsCode;
  String billCode;
  double totalRating;
  Rating allRating;
  Rating fiveRating;
  Rating fourRating;
  Rating threeRating;
  Rating twoRating;
  Rating oneRating;

  ReviewsProduct({
    required this.fsCode,
    required this.billCode,
    required this.totalRating,
    required this.allRating,
    required this.fiveRating,
    required this.fourRating,
    required this.threeRating,
    required this.twoRating,
    required this.oneRating,
  });

  factory ReviewsProduct.fromJson(Map<String, dynamic> json) => ReviewsProduct(
        fsCode: json["fs_code"],
        billCode: json["bill_code"],
        totalRating: json["total_rating"]?.toDouble(),
        allRating: Rating.fromJson(json["all_rating"]),
        fiveRating: Rating.fromJson(json["five_rating"]),
        fourRating: Rating.fromJson(json["four_rating"]),
        threeRating: Rating.fromJson(json["three_rating"]),
        twoRating: Rating.fromJson(json["two_rating"]),
        oneRating: Rating.fromJson(json["one_rating"]),
      );

  Map<String, dynamic> toJson() => {
        "fs_code": fsCode,
        "bill_code": billCode,
        "total_rating": totalRating,
        "all_rating": allRating.toJson(),
        "five_rating": fiveRating.toJson(),
        "four_rating": fourRating.toJson(),
        "three_rating": threeRating.toJson(),
        "two_rating": twoRating.toJson(),
        "one_rating": oneRating.toJson(),
      };
}

class Rating {
  int count;
  List<ProductReview> productReview;

  Rating({
    required this.count,
    required this.productReview,
  });

  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
        count: json["count"],
        productReview: List<ProductReview>.from(
            json["product_review"].map((x) => ProductReview.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "product_review":
            List<dynamic>.from(productReview.map((x) => x.toJson())),
      };
}

class ProductReview {
  String repName;
  String orderCampaign;
  String salesCampaign;
  int unit;
  double productRating;
  double deliveryRating;
  String comment;
  String reviewDate;
  List<String> medialist;
  ReplyToFeedback replyToFeedback;

  ProductReview({
    required this.repName,
    required this.orderCampaign,
    required this.salesCampaign,
    required this.unit,
    required this.productRating,
    required this.deliveryRating,
    required this.comment,
    required this.reviewDate,
    required this.medialist,
    required this.replyToFeedback,
  });

  factory ProductReview.fromJson(Map<String, dynamic> json) => ProductReview(
        repName: json["rep_name"],
        orderCampaign: json["order_campaign"],
        salesCampaign: json["sales_campaign"],
        unit: json["unit"],
        productRating: json["product_rating"]?.toDouble(),
        deliveryRating: json["delivery_rating"]?.toDouble(),
        comment: json["comment"],
        reviewDate: json["review_date"],
        medialist: List<String>.from(json["medialist"].map((x) => x)),
        replyToFeedback: ReplyToFeedback.fromJson(json["reply_to_feedback"]),
      );

  Map<String, dynamic> toJson() => {
        "rep_name": repName,
        "order_campaign": orderCampaign,
        "sales_campaign": salesCampaign,
        "unit": unit,
        "product_rating": productRating,
        "delivery_rating": deliveryRating,
        "comment": comment,
        "review_date": reviewDate,
        "medialist": List<dynamic>.from(medialist.map((x) => x)),
        "reply_to_feedback": replyToFeedback.toJson(),
      };
}

class ReplyToFeedback {
  String name;
  String comment;

  ReplyToFeedback({
    required this.name,
    required this.comment,
  });

  factory ReplyToFeedback.fromJson(Map<String, dynamic> json) =>
      ReplyToFeedback(
        name: json["name"],
        comment: json["comment"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "comment": comment,
      };
}
