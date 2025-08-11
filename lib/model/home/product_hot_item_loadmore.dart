// // To parse this JSON data, do
// //
// //     final productHotItemLoadmore = productHotItemLoadmoreFromJson(jsonString);

// import 'dart:convert';

// ProductHotItemLoadmore productHotItemLoadmoreFromJson(String str) =>
//     ProductHotItemLoadmore.fromJson(json.decode(str));

// String productHotItemLoadmoreToJson(ProductHotItemLoadmore data) =>
//     json.encode(data.toJson());

// class ProductHotItemLoadmore {
//   ProductHotItemLoadmore({
//     required this.hotItemasLoadMore,
//   });

//   List<HotItemasLoadMore> hotItemasLoadMore;

//   factory ProductHotItemLoadmore.fromJson(Map<String, dynamic> json) =>
//       ProductHotItemLoadmore(
//         hotItemasLoadMore: List<HotItemasLoadMore>.from(
//             json["HotItemasLoadMore"]
//                 .map((x) => HotItemasLoadMore.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "HotItemasLoadMore":
//             List<dynamic>.from(hotItemasLoadMore.map((x) => x.toJson())),
//       };
// }

// class HotItemasLoadMore {
//   HotItemasLoadMore({
//     required this.tag,
//     required this.name,
//     required this.price,
//     required this.image,
//     required this.caption,
//     required this.sku,
//     required this.isInStock,
//     required this.stock,
//     required this.sale,
//     required this.salepercent,
//     required this.discountpercent,
//     required this.billcode,
//     required this.color,
//     required this.campaign,
//     required this.brand,
//     required this.media,
//     required this.limitDesc,
//     required this.imgAppend,
//     required this.imgNetPrice,
//     required this.flagNetPrice,
//     required this.flagHouseBrand,
//     required this.productCode,
//     required this.billCodeB2C,
//   });

//   String tag;
//   String name;
//   String price;
//   String image;
//   String caption;
//   String sku;
//   bool isInStock;
//   String stock;
//   String sale;
//   String salepercent;
//   String discountpercent;
//   String billcode;
//   String color;
//   String campaign;
//   String brand;
//   String media;
//   String limitDesc;
//   String imgAppend;
//   String imgNetPrice;
//   String flagNetPrice;
//   String flagHouseBrand;
//   dynamic productCode;
//   dynamic billCodeB2C;

//   factory HotItemasLoadMore.fromJson(Map<String, dynamic> json) =>
//       HotItemasLoadMore(
//         tag: json["tag"] ?? "",
//         name: json["name"] ?? "",
//         price: json["price"] ?? "",
//         image: json["image"] ?? "",
//         caption: json["caption"] ?? "",
//         sku: json["sku"] ?? "",
//         isInStock: json["is_in_stock"] ?? "",
//         stock: json["stock"] ?? "",
//         sale: json["sale"] ?? "",
//         salepercent: json["salepercent"] ?? "",
//         discountpercent: json["discountpercent"] ?? "",
//         billcode: json["billcode"] ?? "",
//         color: json["color"] ?? "",
//         campaign: json["campaign"] ?? "",
//         brand: json["brand"] ?? "",
//         media: json["media"] ?? "",
//         limitDesc: json["limit_desc"] ?? "",
//         imgAppend: json["ImgAppend"] ?? "",
//         imgNetPrice: json["imgNetPrice"] ?? "",
//         flagNetPrice: json["flagNetPrice"] ?? "",
//         flagHouseBrand: json["flagHouseBrand"] ?? "",
//         productCode: json["ProductCode"],
//         billCodeB2C: json["BillCodeB2C"],
//       );

//   Map<String, dynamic> toJson() => {
//         "tag": tag,
//         "name": name,
//         "price": price,
//         "image": image,
//         "caption": caption,
//         "sku": sku,
//         "is_in_stock": isInStock,
//         "stock": stock,
//         "sale": sale,
//         "salepercent": salepercent,
//         "discountpercent": discountpercent,
//         "billcode": billcode,
//         "color": color,
//         "campaign": campaign,
//         "brand": brand,
//         "media": media,
//         "limit_desc": limitDesc,
//         "ImgAppend": imgAppend,
//         "imgNetPrice": imgNetPrice,
//         "flagNetPrice": flagNetPrice,
//         "flagHouseBrand": flagHouseBrand,
//         "ProductCode": productCode,
//         "BillCodeB2C": billCodeB2C,
//       };
// }

// To parse this JSON data, do
//
//     final productHotItemLoadmore = productHotItemLoadmoreFromJson(jsonString);

// import 'package:meta/meta.dart';
import 'dart:convert';

ProductHotItemLoadmore productHotItemLoadmoreFromJson(String str) =>
    ProductHotItemLoadmore.fromJson(json.decode(str));

String productHotItemLoadmoreToJson(ProductHotItemLoadmore data) =>
    json.encode(data.toJson());

class ProductHotItemLoadmore {
  ProductHotItemLoadmore({
    required this.hotItemasLoadMore,
  });

  List<HotItemasLoadMore> hotItemasLoadMore;

  factory ProductHotItemLoadmore.fromJson(Map<String, dynamic> json) =>
      ProductHotItemLoadmore(
        hotItemasLoadMore: json["HotItemasLoadMore"] == null
            ? []
            : List<HotItemasLoadMore>.from(json["HotItemasLoadMore"]
                .map((x) => HotItemasLoadMore.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "HotItemasLoadMore":
            List<dynamic>.from(hotItemasLoadMore.map((x) => x.toJson())),
      };
}

class HotItemasLoadMore {
  HotItemasLoadMore(
      {required this.tag,
      required this.name,
      required this.price,
      required this.image,
      required this.caption,
      required this.sku,
      required this.isInStock,
      required this.stock,
      required this.sale,
      required this.salepercent,
      required this.discountpercent,
      required this.billcode,
      required this.color,
      required this.campaign,
      required this.brand,
      required this.media,
      required this.limitDesc,
      required this.imgAppend,
      required this.imgNetPrice,
      required this.flagNetPrice,
      required this.flagHouseBrand,
      required this.productCode,
      required this.billCodeB2C,
      required this.totalReview,
      required this.ratingProduct});

  String tag;
  String name;
  String price;
  String image;
  String caption;
  String sku;
  bool isInStock;
  String stock;
  String sale;
  String salepercent;
  String discountpercent;
  String billcode;
  String color;
  String campaign;
  String brand;
  String media;
  String limitDesc;
  String imgAppend;
  String imgNetPrice;
  String flagNetPrice;
  String flagHouseBrand;
  String productCode;
  String billCodeB2C;
  int totalReview;
  double ratingProduct;

  factory HotItemasLoadMore.fromJson(Map<String, dynamic> json) =>
      HotItemasLoadMore(
        tag: json["tag"] ?? "",
        name: json["name"] ?? "",
        price: json["price"] ?? "",
        image: json["image"] ?? "",
        caption: json["caption"] ?? "",
        sku: json["sku"] ?? "",
        isInStock: json["is_in_stock"],
        stock: json["stock"] ?? "",
        sale: json["sale"] ?? "",
        salepercent: json["salepercent"] ?? "",
        discountpercent: json["discountpercent"] ?? "",
        billcode: json["billcode"] ?? "",
        color: json["color"] ?? "",
        campaign: json["campaign"] ?? "",
        brand: json["brand"] ?? "",
        media: json["media"] ?? "",
        limitDesc: json["limit_desc"] ?? "",
        imgAppend: json["ImgAppend"] ?? "",
        imgNetPrice: json["imgNetPrice"] ?? "",
        flagNetPrice: json["flagNetPrice"] ?? "",
        flagHouseBrand: json["flagHouseBrand"] ?? "",
        productCode: json["ProductCode"] ?? "",
        billCodeB2C: json["BillCodeB2C"] ?? "",
        totalReview: json["TotalReview"] ?? 0,
        ratingProduct: json["RatingProduct"]?.toDouble() ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        "tag": tag,
        "name": name,
        "price": price,
        "image": image,
        "caption": caption,
        "sku": sku,
        "is_in_stock": isInStock,
        "stock": stock,
        "sale": sale,
        "salepercent": salepercent,
        "discountpercent": discountpercent,
        "billcode": billcode,
        "color": color,
        "campaign": campaign,
        "brand": brand,
        "media": media,
        "limit_desc": limitDesc,
        "ImgAppend": imgAppend,
        "imgNetPrice": imgNetPrice,
        "flagNetPrice": flagNetPrice,
        "flagHouseBrand": flagHouseBrand,
        "ProductCode": productCode,
        "BillCodeB2C": billCodeB2C,
        "TotalReview": totalReview,
        "RatingProduct": ratingProduct,
      };
}
