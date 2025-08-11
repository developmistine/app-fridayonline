// // To parse this JSON data, do
// //
// //     final catalogListProductByPage = catalogListProductByPageFromJson(jsonString);

// import 'dart:convert';

// CatalogListProductByPage catalogListProductByPageFromJson(String str) =>
//     CatalogListProductByPage.fromJson(json.decode(str));

// String catalogListProductByPageToJson(CatalogListProductByPage data) =>
//     json.encode(data.toJson());

// class CatalogListProductByPage {
//   CatalogListProductByPage({
//     required this.repCode,
//     required this.repType,
//     required this.repSeq,
//     required this.campaign,
//     required this.brand,
//     required this.pageDetail,
//     required this.listProductByPageECatalog,
//   });

//   String repCode;
//   String repType;
//   String repSeq;
//   String campaign;
//   String brand;
//   String pageDetail;
//   List<ListProductByPageECatalog> listProductByPageECatalog;

//   factory CatalogListProductByPage.fromJson(Map<String, dynamic> json) =>
//       CatalogListProductByPage(
//         repCode: json["RepCode"],
//         repType: json["RepType"],
//         repSeq: json["RepSeq"],
//         campaign: json["Campaign"],
//         brand: json["Brand"],
//         pageDetail: json["PageDetail"],
//         listProductByPageECatalog: List<ListProductByPageECatalog>.from(
//             json["ListProductByPageECatalog"]
//                 .map((x) => ListProductByPageECatalog.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "RepCode": repCode,
//         "RepType": repType,
//         "RepSeq": repSeq,
//         "Campaign": campaign,
//         "Brand": brand,
//         "PageDetail": pageDetail,
//         "ListProductByPageECatalog": List<dynamic>.from(
//             listProductByPageECatalog.map((x) => x.toJson())),
//       };
// }

// class ListProductByPageECatalog {
//   ListProductByPageECatalog({
//     required this.campaign,
//     required this.mediaCode,
//     required this.bilpageNo,
//     required this.billColor,
//     required this.brand,
//     required this.billCode,
//     required this.name,
//     required this.sku,
//     required this.fsName,
//     required this.fsCodetemp,
//     required this.specialPrice,
//     required this.price,
//     required this.img,
//     required this.isInStock,
//     required this.limitDescription,
//     required this.imgAppend,
//     required this.fsCodeStatus,
//     required this.imgNetPrice,
//     required this.flagNetPrice,
//     required this.flagHouseBrand,
//     required this.updateby,
//     required this.updateDate,
//   });

//   String campaign;
//   String mediaCode;
//   String bilpageNo;
//   String billColor;
//   String brand;
//   String billCode;
//   String name;
//   String sku;
//   String fsName;
//   String fsCodetemp;
//   String specialPrice;
//   String price;
//   String img;
//   bool isInStock;
//   String limitDescription;
//   String imgAppend;
//   String fsCodeStatus;
//   String imgNetPrice;
//   String flagNetPrice;
//   String flagHouseBrand;
//   dynamic updateby;
//   dynamic updateDate;

//   factory ListProductByPageECatalog.fromJson(Map<String, dynamic> json) =>
//       ListProductByPageECatalog(
//         campaign: json["Campaign"],
//         mediaCode: json["MediaCode"],
//         bilpageNo: json["BILPAGE_NO"],
//         billColor: json["BillColor"],
//         brand: json["brand"],
//         billCode: json["billCode"],
//         name: json["name"],
//         sku: json["sku"],
//         fsName: json["FS_NAME"],
//         fsCodetemp: json["FS_CODETEMP"],
//         specialPrice: json["special_price"],
//         price: json["price"],
//         img: json["img"],
//         isInStock: json["is_in_stock"],
//         limitDescription: json["LimitDescription"],
//         imgAppend: json["ImgAppend"],
//         fsCodeStatus: json["Fs_Code_Status"],
//         imgNetPrice: json["imgNetPrice"],
//         flagNetPrice: json["flagNetPrice"],
//         flagHouseBrand: json["flagHouseBrand"],
//         updateby: json["updateby"],
//         updateDate: json["UpdateDate"],
//       );

//   Map<String, dynamic> toJson() => {
//         "Campaign": campaign,
//         "MediaCode": mediaCode,
//         "BILPAGE_NO": bilpageNo,
//         "BillColor": billColor,
//         "brand": brand,
//         "billCode": billCode,
//         "name": name,
//         "sku": sku,
//         "FS_NAME": fsName,
//         "FS_CODETEMP": fsCodetemp,
//         "special_price": specialPrice,
//         "price": price,
//         "img": img,
//         "is_in_stock": isInStock,
//         "LimitDescription": limitDescription,
//         "ImgAppend": imgAppend,
//         "Fs_Code_Status": fsCodeStatus,
//         "imgNetPrice": imgNetPrice,
//         "flagNetPrice": flagNetPrice,
//         "flagHouseBrand": flagHouseBrand,
//         "updateby": updateby,
//         "UpdateDate": updateDate,
//       };
// }

// To parse this JSON data, do
//
//     final catalogListProductByPage = catalogListProductByPageFromJson(jsonString);

// import 'package:meta/meta.dart';
import 'dart:convert';

CatalogListProductByPage catalogListProductByPageFromJson(String str) =>
    CatalogListProductByPage.fromJson(json.decode(str));

String catalogListProductByPageToJson(CatalogListProductByPage data) =>
    json.encode(data.toJson());

class CatalogListProductByPage {
  CatalogListProductByPage({
    required this.repCode,
    required this.repType,
    required this.repSeq,
    required this.campaign,
    required this.brand,
    required this.pageDetail,
    required this.listProductByPageECatalog,
  });

  String repCode;
  String repType;
  String repSeq;
  String campaign;
  String brand;
  String pageDetail;
  List<ListProductByPageECatalog> listProductByPageECatalog;

  factory CatalogListProductByPage.fromJson(Map<String, dynamic> json) =>
      CatalogListProductByPage(
        repCode: json["RepCode"] ?? "",
        repType: json["RepType"] ?? "",
        repSeq: json["RepSeq"] ?? "",
        campaign: json["Campaign"] ?? "",
        brand: json["Brand"] ?? "",
        pageDetail: json["PageDetail"] ?? "",
        listProductByPageECatalog: json["ListProductByPageECatalog"] == null
            ? []
            : List<ListProductByPageECatalog>.from(
                json["ListProductByPageECatalog"]
                    .map((x) => ListProductByPageECatalog.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "RepCode": repCode,
        "RepType": repType,
        "RepSeq": repSeq,
        "Campaign": campaign,
        "Brand": brand,
        "PageDetail": pageDetail,
        "ListProductByPageECatalog": List<dynamic>.from(
            listProductByPageECatalog.map((x) => x.toJson())),
      };
}

class ListProductByPageECatalog {
  ListProductByPageECatalog(
      {required this.campaign,
      required this.mediaCode,
      required this.bilpageNo,
      required this.billColor,
      required this.brand,
      required this.billCode,
      required this.name,
      required this.sku,
      required this.fsName,
      required this.fsCodetemp,
      required this.specialPrice,
      required this.price,
      required this.img,
      required this.isInStock,
      required this.limitDescription,
      required this.imgAppend,
      required this.fsCodeStatus,
      required this.imgNetPrice,
      required this.flagNetPrice,
      required this.flagHouseBrand,
      required this.updateby,
      required this.updateDate,
      required this.totalReview,
      required this.ratingProduct});

  String campaign;
  String mediaCode;
  String bilpageNo;
  String billColor;
  String brand;
  String billCode;
  String name;
  String sku;
  String fsName;
  String fsCodetemp;
  String specialPrice;
  String price;
  String img;
  bool isInStock;
  String limitDescription;
  String imgAppend;
  String fsCodeStatus;
  String imgNetPrice;
  String flagNetPrice;
  String flagHouseBrand;
  String updateby;
  String updateDate;
  int totalReview;
  double ratingProduct;

  factory ListProductByPageECatalog.fromJson(Map<String, dynamic> json) =>
      ListProductByPageECatalog(
        campaign: json["Campaign"] ?? "",
        mediaCode: json["MediaCode"] ?? "",
        bilpageNo: json["BILPAGE_NO"] ?? "",
        billColor: json["BillColor"] ?? "",
        brand: json["Brand"] ?? "",
        billCode: json["BillCode"] ?? "",
        name: json["Name"] ?? "",
        sku: json["Sku"] ?? "",
        fsName: json["FS_NAME"] ?? "",
        fsCodetemp: json["FS_CODETEMP"] ?? "",
        specialPrice: json["Special_price"] ?? "",
        price: json["Price"] ?? "",
        img: json["Img"] ?? "",
        isInStock: json["Is_in_stock"],
        limitDescription: json["LimitDescription"] ?? "",
        imgAppend: json["ImgAppend"] ?? "",
        fsCodeStatus: json["Fs_Code_Status"] ?? "",
        imgNetPrice: json["ImgNetPrice"] ?? "",
        flagNetPrice: json["FlagNetPrice"] ?? "",
        flagHouseBrand: json["FlagHouseBrand"] ?? "",
        updateby: json["Updateby"] ?? "",
        updateDate: json["UpdateDate"] ?? "",
        totalReview: json["TotalReview"] ?? 0,
        ratingProduct: json["RatingProduct"]?.toDouble() ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        "Campaign": campaign,
        "MediaCode": mediaCode,
        "BILPAGE_NO": bilpageNo,
        "BillColor": billColor,
        "Brand": brand,
        "BillCode": billCode,
        "Name": name,
        "Sku": sku,
        "FS_NAME": fsName,
        "FS_CODETEMP": fsCodetemp,
        "Special_price": specialPrice,
        "Price": price,
        "Img": img,
        "Is_in_stock": isInStock,
        "LimitDescription": limitDescription,
        "ImgAppend": imgAppend,
        "Fs_Code_Status": fsCodeStatus,
        "ImgNetPrice": imgNetPrice,
        "FlagNetPrice": flagNetPrice,
        "FlagHouseBrand": flagHouseBrand,
        "Updateby": updateby,
        "UpdateDate": updateDate,
        "TotalReview": totalReview,
        "RatingProduct": ratingProduct,
      };
}
