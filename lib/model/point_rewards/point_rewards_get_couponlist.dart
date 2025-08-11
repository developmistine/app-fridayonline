// To parse this JSON data, do
//
//     final rewardscouponlist = rewardscouponlistFromJson(jsonString);

import 'dart:convert';

Rewardscouponlist rewardscouponlistFromJson(String str) =>
    Rewardscouponlist.fromJson(json.decode(str));

String rewardscouponlistToJson(Rewardscouponlist data) =>
    json.encode(data.toJson());

class Rewardscouponlist {
  Rewardscouponlist({
    required this.repCode,
    required this.repSeq,
    required this.countCoupon,
    required this.couponlist,
  });

  String repCode;
  String repSeq;
  int countCoupon;
  List<Couponlist> couponlist;

  factory Rewardscouponlist.fromJson(Map<String, dynamic> json) =>
      Rewardscouponlist(
        repCode: json["RepCode"] ?? "",
        repSeq: json["RepSeq"] ?? "",
        countCoupon:
            json["CountCoupon"] == "" ? 0 : int.parse(json["CountCoupon"]),
        couponlist: json["Couponlist"] == null
            ? []
            : List<Couponlist>.from(
                json["Couponlist"].map((x) => Couponlist.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "RepCode": repCode,
        "RepSeq": repSeq,
        "CountCoupon": countCoupon,
        "Couponlist": List<dynamic>.from(couponlist.map((x) => x.toJson())),
      };
}

class Couponlist {
  Couponlist({
    required this.couponId,
    required this.couponName,
    required this.couponCode,
    required this.price,
    required this.imgCoupon,
    required this.startDate,
    required this.expDate,
    required this.campaign,
    required this.couPonlist,
    required this.usecoupon,
    required this.couponType,
  });

  String couponId;
  String couponName;
  String couponCode;
  double price;
  String imgCoupon;
  String startDate;
  String expDate;
  String campaign;
  String couPonlist;
  String usecoupon;
  String couponType;

  factory Couponlist.fromJson(Map<String, dynamic> json) => Couponlist(
        couponId: json["CouponId"] ?? "",
        couponName: json["CouponName"] ?? "",
        couponCode: json["CouponCode"] ?? "",
        price: double.parse(json["Price"]),
        imgCoupon: json["ImgCoupon"] ?? "",
        startDate: json["StartDate"] ?? "",
        expDate: json["ExpDate"] ?? "",
        campaign: json["Campaign"] ?? "",
        couPonlist: json["CouPonlist"] ?? "",
        usecoupon: json["Usecoupon"] ?? "",
        couponType: json["CouponType"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "CouponId": couponId,
        "CouponName": couponName,
        "CouponCode": couponCode,
        "Price": price,
        "ImgCoupon": imgCoupon,
        "StartDate": startDate,
        "ExpDate": expDate,
        "Campaign": campaign,
        "CouPonlist": couPonlist,
        "Usecoupon": usecoupon,
        "CouponType": couponType,
      };
}
