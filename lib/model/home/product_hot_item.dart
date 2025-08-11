// // To parse this JSON data, do
// //
// //     final productHotItem = productHotItemFromJson(jsonString);

// import 'dart:convert';

// ProductHotItem productHotItemFromJson(String str) =>
//     ProductHotItem.fromJson(json.decode(str));

// String productHotItemToJson(ProductHotItem data) => json.encode(data.toJson());

// class ProductHotItem {
//   ProductHotItem({
//     required this.hotItem,
//   });

//   List<HotItem> hotItem;

//   factory ProductHotItem.fromJson(Map<String, dynamic> json) => ProductHotItem(
//         hotItem:
//             List<HotItem>.from(json["HotItem"].map((x) => HotItem.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "HotItem": List<dynamic>.from(hotItem.map((x) => x.toJson())),
//       };
// }

// class HotItem {
//   HotItem({
//     required this.dataSqlHotitemsDetail,
//   });

//   List<DataSqlHotitemsDetail> dataSqlHotitemsDetail;

//   factory HotItem.fromJson(Map<String, dynamic> json) => HotItem(
//         dataSqlHotitemsDetail: List<DataSqlHotitemsDetail>.from(
//             json["data_sql_hotitems_detail"]
//                 .map((x) => DataSqlHotitemsDetail.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "data_sql_hotitems_detail":
//             List<dynamic>.from(dataSqlHotitemsDetail.map((x) => x.toJson())),
//       };
// }

// class DataSqlHotitemsDetail {
//   DataSqlHotitemsDetail({
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

//   factory DataSqlHotitemsDetail.fromJson(Map<String, dynamic> json) =>
//       DataSqlHotitemsDetail(
//         tag: json["tag"],
//         name: json["name"],
//         price: json["price"],
//         image: json["image"],
//         caption: json["caption"],
//         sku: json["sku"],
//         isInStock: json["is_in_stock"],
//         stock: json["stock"],
//         sale: json["sale"],
//         salepercent: json["salepercent"],
//         discountpercent: json["discountpercent"],
//         billcode: json["billcode"],
//         color: json["color"],
//         campaign: json["campaign"],
//         brand: json["brand"],
//         media: json["media"],
//         limitDesc: json["limit_desc"],
//         imgAppend: json["ImgAppend"],
//         imgNetPrice: json["imgNetPrice"],
//         flagNetPrice: json["flagNetPrice"],
//         flagHouseBrand: json["flagHouseBrand"],
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
//     final productHotItem = productHotItemFromJson(jsonString);

// import 'package:meta/meta.dart';
import 'dart:convert';

ProductHotItem productHotItemFromJson(String str) =>
    ProductHotItem.fromJson(json.decode(str));

String productHotItemToJson(ProductHotItem data) => json.encode(data.toJson());

class ProductHotItem {
  ProductHotItem({
    required this.hotItem,
  });

  List<HotItem> hotItem;

  factory ProductHotItem.fromJson(Map<String, dynamic> json) => ProductHotItem(
        hotItem: json["HotItem"] == null
            ? []
            : List<HotItem>.from(
                json["HotItem"].map((x) => HotItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "HotItem": List<dynamic>.from(hotItem.map((x) => x.toJson())),
      };
}

class HotItem {
  HotItem({
    required this.dataSqlHotitemsDetail,
  });

  List<DataSqlHotitemsDetail> dataSqlHotitemsDetail;

  factory HotItem.fromJson(Map<String, dynamic> json) => HotItem(
        dataSqlHotitemsDetail: json["data_sql_hotitems_detail"] == null
            ? []
            : List<DataSqlHotitemsDetail>.from(json["data_sql_hotitems_detail"]
                .map((x) => DataSqlHotitemsDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data_sql_hotitems_detail":
            List<dynamic>.from(dataSqlHotitemsDetail.map((x) => x.toJson())),
      };
}

class DataSqlHotitemsDetail {
  DataSqlHotitemsDetail(
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

  factory DataSqlHotitemsDetail.fromJson(Map<String, dynamic> json) =>
      DataSqlHotitemsDetail(
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
