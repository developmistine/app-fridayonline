// To parse this JSON data, do
//
//     final pendingReviews = pendingReviewsFromJson(jsonString);

import 'dart:convert';

PendingReviews pendingReviewsFromJson(String str) =>
    PendingReviews.fromJson(json.decode(str));

String pendingReviewsToJson(PendingReviews data) => json.encode(data.toJson());

class PendingReviews {
  String code;
  List<Datum> data;
  String message;

  PendingReviews({
    required this.code,
    required this.data,
    required this.message,
  });

  factory PendingReviews.fromJson(Map<String, dynamic> json) => PendingReviews(
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
  int productId;
  String productName;
  int itemId;
  String itemImage;
  String option;
  int amount;
  int ordshopId;
  int orddtlId;

  Datum({
    required this.productId,
    required this.productName,
    required this.itemId,
    required this.itemImage,
    required this.option,
    required this.amount,
    required this.ordshopId,
    required this.orddtlId,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        productId: json["product_id"],
        productName: json["product_name"],
        itemId: json["item_id"],
        itemImage: json["item_image"],
        option: json["option"],
        amount: json["amount"],
        ordshopId: json["ordshop_id"],
        orddtlId: json["orddtl_id"],
      );

  Map<String, dynamic> toJson() => {
        "product_id": productId,
        "product_name": productName,
        "item_id": itemId,
        "item_image": itemImage,
        "option": option,
        "amount": amount,
        "ordshop_id": ordshopId,
        "orddtl_id": orddtlId,
      };
}
