// To parse this JSON data, do
//
//     final couponDiscount = couponDiscountFromJson(jsonString);

import 'dart:convert';

CouponDiscount couponDiscountFromJson(String str) =>
    CouponDiscount.fromJson(json.decode(str));

String couponDiscountToJson(CouponDiscount data) => json.encode(data.toJson());

class CouponDiscount {
  bool isPopUp;
  String textPopUp;
  String imgPopUp;
  List<Couponlist> couponlist;

  CouponDiscount({
    required this.isPopUp,
    required this.textPopUp,
    required this.imgPopUp,
    required this.couponlist,
  });

  factory CouponDiscount.fromJson(Map<String, dynamic> json) => CouponDiscount(
        isPopUp: json["IsPopUp"],
        textPopUp: json["TextPopUp"],
        imgPopUp: json["ImgPopUp"],
        couponlist: List<Couponlist>.from(
            json["Couponlist"].map((x) => Couponlist.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "IsPopUp": isPopUp,
        "TextPopUp": textPopUp,
        "ImgPopUp": imgPopUp,
        "Couponlist": List<dynamic>.from(couponlist.map((x) => x.toJson())),
      };
}

class Couponlist {
  String couponId;
  String couponName;
  String couponCode;
  int categoryCoupon;
  double price;
  double minUsePrice;
  String imgCoupon;
  DateTime startDate;
  DateTime expDate;
  int expire;
  String usecoupon;
  String couponType;
  String condition;
  List<String> descriptions;
  String timeText;
  String connMedia;
  bool couponDefault;

  Couponlist({
    required this.couponId,
    required this.couponName,
    required this.couponCode,
    required this.categoryCoupon,
    required this.price,
    required this.minUsePrice,
    required this.imgCoupon,
    required this.startDate,
    required this.expDate,
    required this.expire,
    required this.usecoupon,
    required this.couponType,
    required this.condition,
    required this.descriptions,
    required this.timeText,
    required this.connMedia,
    required this.couponDefault,
  });

  factory Couponlist.fromJson(Map<String, dynamic> json) => Couponlist(
        couponId: json["CouponId"],
        couponName: json["CouponName"],
        couponCode: json["CouponCode"],
        categoryCoupon: json["CategoryCoupon"],
        price: json["Price"].toDouble(),
        minUsePrice: json["MinUsePrice"].toDouble(),
        imgCoupon: json["ImgCoupon"],
        startDate: DateTime.parse(json["StartDate"]),
        expDate: DateTime.parse(json["ExpDate"]),
        expire: json["Expire"],
        usecoupon: json["Usecoupon"],
        couponType: json["CouponType"],
        condition: json["Condition"],
        descriptions: List<String>.from(json["Descriptions"].map((x) => x)),
        timeText: json["TimeText"],
        connMedia: json["ConnMedia"],
        couponDefault: json["CouponDefault"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "CouponId": couponId,
        "CouponName": couponName,
        "CouponCode": couponCode,
        "CategoryCoupon": categoryCoupon,
        "Price": price.toDouble(),
        "MinUsePrice": minUsePrice.toDouble(),
        "ImgCoupon": imgCoupon,
        "StartDate": startDate.toIso8601String(),
        "ExpDate": expDate.toIso8601String(),
        "Expire": expire,
        "Usecoupon": usecoupon,
        "CouponType": couponType,
        "Condition": condition,
        "Descriptions": List<dynamic>.from(descriptions.map((x) => x)),
        "TimeText": timeText,
        "ConnMedia": connMedia,
        "CouponDefault": couponDefault,
      };
}
