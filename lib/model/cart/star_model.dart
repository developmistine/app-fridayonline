// To parse this JSON data, do
//
//     final starReward = starRewardFromJson(jsonString);

// import 'package:meta/meta.dart';
import 'dart:convert';

StarReward starRewardFromJson(String str) =>
    StarReward.fromJson(json.decode(str));

String starRewardToJson(StarReward data) => json.encode(data.toJson());

class StarReward {
  StarReward({
    required this.useStar,
    required this.starReword,
    required this.discountdetail,
  });

  String useStar;
  int starReword;
  String discountdetail;

  factory StarReward.fromJson(Map<String, dynamic> json) => StarReward(
        useStar: json["UseStar"] ?? "",
        starReword: json["StarReword"] ?? 0,
        discountdetail: json["discountdetail"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "UseStar": useStar,
        "StarReword": starReword,
        "discountdetail": discountdetail,
      };
}
