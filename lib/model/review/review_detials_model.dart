// To parse this JSON data, do
//
//     final reviewDetails = reviewDetailsFromJson(jsonString);

import 'dart:convert';

ReviewDetails reviewDetailsFromJson(String str) =>
    ReviewDetails.fromJson(json.decode(str));

String reviewDetailsToJson(ReviewDetails data) => json.encode(data.toJson());

class ReviewDetails {
  List<ReviewWaiting> reviewWaiting;
  List<ReviewHistory> reviewHistory;

  ReviewDetails({
    required this.reviewWaiting,
    required this.reviewHistory,
  });

  factory ReviewDetails.fromJson(Map<String, dynamic> json) => ReviewDetails(
        reviewWaiting: List<ReviewWaiting>.from(
            json["review_waiting"].map((x) => ReviewWaiting.fromJson(x))),
        reviewHistory: List<ReviewHistory>.from(
            json["review_history"].map((x) => ReviewHistory.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "review_waiting":
            List<dynamic>.from(reviewWaiting.map((x) => x.toJson())),
        "review_history":
            List<dynamic>.from(reviewHistory.map((x) => x.toJson())),
      };
}

class ReviewHistory {
  String repType;
  String repSeq;
  String repCode;
  String enduserId;
  String name;
  String invoice;
  String brand;
  String fsCode;
  String billCode;
  String salesCampaign;
  String orderCampaign;
  String billDesc;
  int unit;
  String image;
  double productRating;
  double deliveryRating;
  String comment;
  List<String> imageReview;
  String reviewDate;
  ReplyToFeedback replyToFeedback;

  ReviewHistory({
    required this.repType,
    required this.repSeq,
    required this.repCode,
    required this.enduserId,
    required this.name,
    required this.invoice,
    required this.brand,
    required this.fsCode,
    required this.billCode,
    required this.salesCampaign,
    required this.orderCampaign,
    required this.billDesc,
    required this.unit,
    required this.image,
    required this.productRating,
    required this.deliveryRating,
    required this.comment,
    required this.imageReview,
    required this.reviewDate,
    required this.replyToFeedback,
  });

  factory ReviewHistory.fromJson(Map<String, dynamic> json) => ReviewHistory(
        repType: json["rep_type"],
        repSeq: json["rep_seq"],
        repCode: json["rep_code"],
        enduserId: json["enduser_id"],
        name: json["name"],
        invoice: json["invoice"],
        brand: json["brand"],
        fsCode: json["fs_code"],
        billCode: json["bill_code"],
        salesCampaign: json["sales_campaign"],
        orderCampaign: json["order_campaign"],
        billDesc: json["bill_desc"],
        unit: json["unit"],
        image: json["image"],
        productRating: json["product_rating"]?.toDouble(),
        deliveryRating: json["delivery_rating"]?.toDouble(),
        comment: json["comment"],
        imageReview: List<String>.from(json["image_review"].map((x) => x)),
        reviewDate: json["review_date"],
        replyToFeedback: ReplyToFeedback.fromJson(json["reply_to_feedback"]),
      );

  Map<String, dynamic> toJson() => {
        "rep_type": repType,
        "rep_seq": repSeq,
        "rep_code": repCode,
        "enduser_id": enduserId,
        "name": name,
        "invoice": invoice,
        "brand": brand,
        "fs_code": fsCode,
        "bill_code": billCode,
        "sales_campaign": salesCampaign,
        "order_campaign": orderCampaign,
        "bill_desc": billDesc,
        "unit": unit,
        "image": image,
        "product_rating": productRating,
        "delivery_rating": deliveryRating,
        "comment": comment,
        "image_review": List<dynamic>.from(imageReview.map((x) => x)),
        "review_date": reviewDate,
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

class ReviewWaiting {
  String repType;
  String repSeq;
  String repCode;
  String enduserId;
  String name;
  String invoice;
  String brand;
  String salesCampaign;
  String orderCampaign;
  String fsCode;
  String billCode;
  String billDesc;
  int unit;
  String image;

  ReviewWaiting({
    required this.repType,
    required this.repSeq,
    required this.repCode,
    required this.enduserId,
    required this.name,
    required this.invoice,
    required this.brand,
    required this.salesCampaign,
    required this.orderCampaign,
    required this.fsCode,
    required this.billCode,
    required this.billDesc,
    required this.unit,
    required this.image,
  });

  factory ReviewWaiting.fromJson(Map<String, dynamic> json) => ReviewWaiting(
        repType: json["rep_type"],
        repSeq: json["rep_seq"],
        repCode: json["rep_code"],
        enduserId: json["enduser_id"],
        name: json["name"],
        invoice: json["invoice"],
        brand: json["brand"],
        salesCampaign: json["sales_campaign"],
        orderCampaign: json["order_campaign"],
        fsCode: json["fs_code"],
        billCode: json["bill_code"],
        billDesc: json["bill_desc"],
        unit: json["unit"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "rep_type": repType,
        "rep_seq": repSeq,
        "rep_code": repCode,
        "enduser_id": enduserId,
        "name": name,
        "invoice": invoice,
        "brand": brand,
        "sales_campaign": salesCampaign,
        "order_campaign": orderCampaign,
        "fs_code": fsCode,
        "bill_code": billCode,
        "bill_desc": billDesc,
        "unit": unit,
        "image": image,
      };
}
