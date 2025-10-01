// To parse this JSON data, do
//
//     final affiliateRecommendProductList = affiliateRecommendProductListFromJson(jsonString);

import 'dart:convert';
import 'package:fridayonline/member/models/affiliate/shopcontent.model.dart'
    as content;

AffiliateRecommendProductList affiliateRecommendProductListFromJson(
        String str) =>
    AffiliateRecommendProductList.fromJson(json.decode(str));

String affiliateRecommendProductListToJson(
        AffiliateRecommendProductList data) =>
    json.encode(data.toJson());

class AffiliateRecommendProductList {
  String code;
  List<content.AffiliateProduct> data;
  String message;

  AffiliateRecommendProductList({
    required this.code,
    required this.data,
    required this.message,
  });

  factory AffiliateRecommendProductList.fromJson(Map<String, dynamic> json) {
    final list = (json['data'] as List<dynamic>? ?? []);

    return AffiliateRecommendProductList(
      code: json["code"],
      data: list
          .map((e) => content.AffiliateProduct.fromJson(
                e as Map<String, dynamic>,
              ))
          .toList(),
      message: json["message"],
    );
  }
  Map<String, dynamic> toJson() => {
        "code": code,
        "data": data.map((e) => e.toJson()).toList(),
        "message": message,
      };
  bool get isEmpty => data.isEmpty;
}
