// To parse this JSON data, do
//
//     final rewardsgetcategory = rewardsgetcategoryFromJson(jsonString);

// import 'package:meta/meta.dart';
import 'dart:convert';

Rewardsgetcategory rewardsgetcategoryFromJson(String str) =>
    Rewardsgetcategory.fromJson(json.decode(str));

String rewardsgetcategoryToJson(Rewardsgetcategory data) =>
    json.encode(data.toJson());

class Rewardsgetcategory {
  Rewardsgetcategory({
    required this.productGroup,
  });

  List<ProductGroup> productGroup;

  factory Rewardsgetcategory.fromJson(Map<String, dynamic> json) =>
      Rewardsgetcategory(
        productGroup: json["ProductGroup"] == null
            ? []
            : List<ProductGroup>.from(
                json["ProductGroup"].map((x) => ProductGroup.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ProductGroup": List<dynamic>.from(productGroup.map((x) => x.toJson())),
      };
}

class ProductGroup {
  ProductGroup({
    required this.categoryId,
    required this.imageUrl,
    required this.fscode,
    required this.productName,
    required this.couponList,
    required this.isInStock,
    required this.imageAppend,
  });

  String categoryId;
  String imageUrl;
  String fscode;
  String productName;
  List<CouponList> couponList;
  bool isInStock;
  String imageAppend;

  factory ProductGroup.fromJson(Map<String, dynamic> json) => ProductGroup(
        categoryId: json["CategoryId"] ?? "",
        imageUrl: json["ImageUrl"] ?? "",
        fscode: json["Fscode"] ?? "",
        productName: json["ProductName"] ?? "",
        couponList: json["CouponList"] == null
            ? []
            : List<CouponList>.from(
                json["CouponList"].map((x) => CouponList.fromJson(x))),
        isInStock: json["IsInStock"] ?? true,
        imageAppend: json["ImgAppend"] ??
            "https://s3.catalog-yupin.com/Images/outOfStock.webp",
      );

  Map<String, dynamic> toJson() => {
        "CategoryId": categoryId,
        "ImageUrl": imageUrl,
        "Fscode": fscode,
        "ProductName": productName,
        "CouponList": List<dynamic>.from(couponList.map((x) => x.toJson())),
        "IsInStock": isInStock,
        "ImgAppend": imageAppend,
      };
}

class CouponList {
  CouponList({
    required this.list,
    required this.detailText,
    required this.detailCoupon,
  });

  String list;
  String detailText;
  String detailCoupon;

  factory CouponList.fromJson(Map<String, dynamic> json) => CouponList(
        list: json["List"] ?? "",
        detailText: json["DetailText"] ?? "",
        detailCoupon: json["DetailCoupon"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "List": list,
        "DetailText": detailText,
        "DetailCoupon": detailCoupon,
      };
}
