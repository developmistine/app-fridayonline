// // To parse this JSON data, do
// //
// //     final homeNewContent = homeNewContentFromJson(jsonString);

// import 'package:meta/meta.dart';
// import 'dart:convert';

// HomeNewContent homeNewContentFromJson(String str) =>
//     HomeNewContent.fromJson(json.decode(str));

// String homeNewContentToJson(HomeNewContent data) => json.encode(data.toJson());

// class HomeNewContent {
//   HomeNewContent({
//     required this.repCode,
//     required this.repType,
//     required this.repSeq,
//     required this.textHeader,
//     required this.menu,
//     required this.announce,
//     required this.keyIcon,
//     required this.banner,
//     required this.favorite,
//     required this.flashSale,
//     required this.specialPromotion,
//     required this.newProduct,
//     required this.content,
//     required this.bestSeller,
//     required this.hotItem,
//     required this.specialPromotionList,
//   });

//   String repCode;
//   String repType;
//   String repSeq;
//   String textHeader;
//   dynamic menu;
//   dynamic announce;
//   dynamic keyIcon;
//   dynamic banner;
//   dynamic favorite;
//   dynamic flashSale;
//   dynamic specialPromotion;
//   dynamic newProduct;
//   dynamic content;
//   dynamic bestSeller;
//   dynamic hotItem;
//   SpecialPromotionList? specialPromotionList;

//   factory HomeNewContent.fromJson(Map<String, dynamic> json) => HomeNewContent(
//         repCode: json["RepCode"] == null ? null : json["RepCode"],
//         repType: json["RepType"] == null ? null : json["RepType"],
//         repSeq: json["RepSeq"] == null ? null : json["RepSeq"],
//         textHeader: json["TextHeader"] == null ? null : json["TextHeader"],
//         menu: json["Menu"],
//         announce: json["Announce"],
//         keyIcon: json["KeyIcon"],
//         banner: json["Banner"],
//         favorite: json["Favorite"],
//         flashSale: json["FlashSale"],
//         specialPromotion: json["SpecialPromotion"],
//         newProduct: json["NewProduct"],
//         content: json["Content"],
//         bestSeller: json["BestSeller"],
//         hotItem: json["HotItem"],
//         specialPromotionList: json["SpecialPromotionList"] == null
//             ? null
//             : SpecialPromotionList.fromJson(json["SpecialPromotionList"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "RepCode": repCode == null ? null : repCode,
//         "RepType": repType == null ? null : repType,
//         "RepSeq": repSeq == null ? null : repSeq,
//         "TextHeader": textHeader == null ? null : textHeader,
//         "Menu": menu,
//         "Announce": announce,
//         "KeyIcon": keyIcon,
//         "Banner": banner,
//         "Favorite": favorite,
//         "FlashSale": flashSale,
//         "SpecialPromotion": specialPromotion,
//         "NewProduct": newProduct,
//         "Content": content,
//         "BestSeller": bestSeller,
//         "HotItem": hotItem,
//         "SpecialPromotionList": specialPromotionList == null
//             ? null
//             : specialPromotionList!.toJson(),
//       };
// }

// class SpecialPromotionList {
//   SpecialPromotionList({
//     required this.contentList,
//     required this.contentSku,
//     required this.contentSlide,
//     required this.contentDelivery,
//   });

//   List<Content>? contentList;
//   List<ContentSku>? contentSku;
//   List<Content>? contentSlide;
//   List<dynamic>? contentDelivery;

//   factory SpecialPromotionList.fromJson(Map<String, dynamic> json) =>
//       SpecialPromotionList(
//         contentList: json["contentList"] == null
//             ? null
//             : List<Content>.from(
//                 json["contentList"].map((x) => Content.fromJson(x))),
//         contentSku: json["contentSKU"] == null
//             ? null
//             : List<ContentSku>.from(
//                 json["contentSKU"].map((x) => ContentSku.fromJson(x))),
//         contentSlide: json["contentSlide"] == null
//             ? null
//             : List<Content>.from(
//                 json["contentSlide"].map((x) => Content.fromJson(x))),
//         contentDelivery: json["contentDelivery"] == null
//             ? null
//             : List<dynamic>.from(json["contentDelivery"].map((x) => x)),
//       );

//   Map<String, dynamic> toJson() => {
//         "contentList": contentList == null
//             ? null
//             : List<dynamic>.from(contentList!.map((x) => x.toJson())),
//         "contentSKU": contentSku == null
//             ? null
//             : List<dynamic>.from(contentSku!.map((x) => x.toJson())),
//         "contentSlide": contentSlide == null
//             ? null
//             : List<dynamic>.from(contentSlide!.map((x) => x.toJson())),
//         "contentDelivery": contentDelivery == null
//             ? null
//             : List<dynamic>.from(contentDelivery!.map((x) => x)),
//       };
// }

// class Content {
//   Content({
//     required this.id,
//     required this.list,
//     required this.contentName,
//     required this.contentImg,
//     required this.contentType,
//     required this.contentIndex,
//     required this.campaign,
//     required this.brand,
//     required this.fscode,
//     required this.fscodeTemp,
//   });

//   String id;
//   String list;
//   String contentName;
//   String contentImg;
//   String contentType;
//   String contentIndex;
//   String campaign;
//   String brand;
//   String fscode;
//   String fscodeTemp;

//   factory Content.fromJson(Map<String, dynamic> json) => Content(
//         id: json["id"] == null ? null : json["id"],
//         list: json["list"] == null ? null : json["list"],
//         contentName: json["contentName"] == null ? null : json["contentName"],
//         contentImg: json["contentImg"] == null ? null : json["contentImg"],
//         contentType: json["contentType"] == null ? null : json["contentType"],
//         contentIndex:
//             json["contentIndex"] == null ? null : json["contentIndex"],
//         campaign: json["campaign"] == null ? null : json["campaign"],
//         brand: json["brand"] == null ? null : json["brand"],
//         fscode: json["fscode"] == null ? null : json["fscode"],
//         fscodeTemp: json["fscodeTemp"] == null ? null : json["fscodeTemp"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id == null ? null : id,
//         "list": list == null ? null : list,
//         "contentName": contentName == null ? null : contentName,
//         "contentImg": contentImg == null ? null : contentImg,
//         "contentType": contentType == null ? null : contentType,
//         "contentIndex": contentIndex == null ? null : contentIndex,
//         "campaign": campaign == null ? null : campaign,
//         "brand": brand == null ? null : brand,
//         "fscode": fscode == null ? null : fscode,
//         "fscodeTemp": fscodeTemp == null ? null : fscodeTemp,
//       };
// }

// class ContentSku {
//   ContentSku({
//     required this.id,
//     required this.list,
//     required this.contentName,
//     required this.contentImg,
//     required this.contentType,
//     required this.contentIndex,
//     required this.listSku,
//   });

//   String id;
//   String list;
//   String contentName;
//   String contentImg;
//   String contentType;
//   String contentIndex;
//   List<ListSku>? listSku;

//   factory ContentSku.fromJson(Map<String, dynamic> json) => ContentSku(
//         id: json["id"] == null ? null : json["id"],
//         list: json["list"] == null ? null : json["list"],
//         contentName: json["contentName"] == null ? null : json["contentName"],
//         contentImg: json["contentImg"] == null ? null : json["contentImg"],
//         contentType: json["contentType"] == null ? null : json["contentType"],
//         contentIndex:
//             json["contentIndex"] == null ? null : json["contentIndex"],
//         listSku: json["listSKU"] == null
//             ? []
//             : List<ListSku>.from(
//                 json["listSKU"].map((x) => ListSku.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id == null ? null : id,
//         "list": list == null ? null : list,
//         "contentName": contentName == null ? null : contentName,
//         "contentImg": contentImg == null ? null : contentImg,
//         "contentType": contentType == null ? null : contentType,
//         "contentIndex": contentIndex == null ? null : contentIndex,
//         "listSKU": listSku == null
//             ? []
//             : List<dynamic>.from(listSku!.map((x) => x.toJson())),
//       };
// }

// class ListSku {
//   ListSku({
//     required this.billcamp,
//     required this.billcode,
//     required this.billName,
//     required this.brand,
//     required this.mediaCode,
//     required this.fscode,
//     required this.img,
//     required this.regularPrice,
//     required this.specialPrice,
//     required this.billcolor,
//     required this.isInStock,
//     required this.checkLimit,
//     required this.imgAppend,
//     required this.flagNetPrice,
//     required this.imgNetPrice,
//   });

//   String billcamp;
//   String billcode;
//   dynamic billName;
//   dynamic brand;
//   dynamic mediaCode;
//   String fscode;
//   String img;
//   String regularPrice;
//   String specialPrice;
//   dynamic billcolor;
//   bool isInStock;
//   dynamic checkLimit;
//   dynamic imgAppend;
//   dynamic flagNetPrice;
//   dynamic imgNetPrice;

//   factory ListSku.fromJson(Map<String, dynamic> json) => ListSku(
//         billcamp: json["billcamp"] == null ? null : json["billcamp"],
//         billcode: json["billcode"] == null ? null : json["billcode"],
//         billName: json["billName"],
//         brand: json["brand"],
//         mediaCode: json["mediaCode"],
//         fscode: json["fscode"] == null ? null : json["fscode"],
//         img: json["img"] == null ? null : json["img"],
//         regularPrice:
//             json["regularPrice"] == null ? null : json["regularPrice"],
//         specialPrice:
//             json["specialPrice"] == null ? null : json["specialPrice"],
//         billcolor: json["billcolor"],
//         isInStock: json["is_in_stock"] == null ? null : json["is_in_stock"],
//         checkLimit: json["checkLimit"],
//         imgAppend: json["imgAppend"],
//         flagNetPrice: json["flagNetPrice"],
//         imgNetPrice: json["imgNetPrice"],
//       );

//   Map<String, dynamic> toJson() => {
//         "billcamp": billcamp == null ? null : billcamp,
//         "billcode": billcode == null ? null : billcode,
//         "billName": billName,
//         "brand": brand,
//         "mediaCode": mediaCode,
//         "fscode": fscode == null ? null : fscode,
//         "img": img == null ? null : img,
//         "regularPrice": regularPrice == null ? null : regularPrice,
//         "specialPrice": specialPrice == null ? null : specialPrice,
//         "billcolor": billcolor,
//         "is_in_stock": isInStock == null ? null : isInStock,
//         "checkLimit": checkLimit,
//         "imgAppend": imgAppend,
//         "flagNetPrice": flagNetPrice,
//         "imgNetPrice": imgNetPrice,
//       };
// }

// To parse this JSON data, do
//
//     final homeNewContent = homeNewContentFromJson(jsonString);

// import 'package:meta/meta.dart';
import 'dart:convert';

HomeNewContent homeNewContentFromJson(String str) =>
    HomeNewContent.fromJson(json.decode(str));

String homeNewContentToJson(HomeNewContent data) => json.encode(data.toJson());

class HomeNewContent {
  HomeNewContent({
    required this.repCode,
    required this.repType,
    required this.repSeq,
    required this.textHeader,
    required this.specialPromotionList,
  });

  String repCode;
  String repType;
  String repSeq;
  String textHeader;
  SpecialPromotionList specialPromotionList;

  factory HomeNewContent.fromJson(Map<String, dynamic> json) => HomeNewContent(
        repCode: json["RepCode"] ?? "",
        repType: json["RepType"] ?? "",
        repSeq: json["RepSeq"] ?? "",
        textHeader: json["TextHeader"] ?? "",
        specialPromotionList:
            SpecialPromotionList.fromJson(json["SpecialPromotionList"]),
      );

  Map<String, dynamic> toJson() => {
        "RepCode": repCode,
        "RepType": repType,
        "RepSeq": repSeq,
        "TextHeader": textHeader,
        "SpecialPromotionList": specialPromotionList.toJson(),
      };
}

class SpecialPromotionList {
  SpecialPromotionList({
    required this.contentList,
    required this.contentSku,
    required this.contentSlide,
  });

  List<Content> contentList;
  List<Content> contentSku;
  List<Content> contentSlide;

  factory SpecialPromotionList.fromJson(Map<String, dynamic> json) =>
      SpecialPromotionList(
        contentList: json["contentList"] == null
            ? []
            : List<Content>.from(
                json["contentList"].map((x) => Content.fromJson(x))),
        contentSku: json["contentSKU"] == null
            ? []
            : List<Content>.from(
                json["contentSKU"].map((x) => Content.fromJson(x))),
        contentSlide: json["contentSlide"] == null
            ? []
            : List<Content>.from(
                json["contentSlide"].map((x) => Content.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "contentList": List<dynamic>.from(contentList.map((x) => x.toJson())),
        "contentSKU": List<dynamic>.from(contentSku.map((x) => x.toJson())),
        "contentSlide": List<dynamic>.from(contentSlide.map((x) => x.toJson())),
      };
}

class Content {
  Content({
    required this.id,
    required this.list,
    required this.contentName,
    required this.contentImg,
    required this.contentType,
    required this.contentIndex,
    required this.campaign,
    required this.brand,
    required this.fscode,
    required this.fscodeTemp,
    required this.listSku,
  });

  String id;
  String list;
  String contentName;
  String contentImg;
  String contentType;
  String contentIndex;
  String campaign;
  String brand;
  String fscode;
  String fscodeTemp;
  List<ListSku> listSku;

  factory Content.fromJson(Map<String, dynamic> json) => Content(
        id: json["id"] ?? "",
        list: json["list"] ?? "",
        contentName: json["contentName"] ?? "",
        contentImg: json["contentImg"] ?? "",
        contentType: json["contentType"] ?? "",
        contentIndex: json["contentIndex"] ?? "",
        campaign: json["campaign"] ?? "",
        brand: json["brand"] ?? "",
        fscode: json["fscode"] ?? "",
        fscodeTemp: json["fscodeTemp"] ?? "",
        listSku: json["listSKU"] == null
            ? []
            : List<ListSku>.from(
                json["listSKU"].map((x) => ListSku.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "list": list,
        "contentName": contentName,
        "contentImg": contentImg,
        "contentType": contentType,
        "contentIndex": contentIndex,
        "campaign": campaign,
        "brand": brand,
        "fscode": fscode,
        "fscodeTemp": fscodeTemp,
        "listSKU": List<dynamic>.from(listSku.map((x) => x.toJson())),
      };
}

class ListSku {
  ListSku({
    required this.billcamp,
    required this.billcode,
    required this.billName,
    required this.brand,
    required this.mediaCode,
    required this.fscode,
    required this.img,
    required this.regularPrice,
    required this.specialPrice,
    required this.billcolor,
    required this.isInStock,
    required this.checkLimit,
    required this.imgAppend,
    required this.flagNetPrice,
    required this.imgNetPrice,
  });

  String billcamp;
  String billcode;
  String billName;
  String brand;
  String mediaCode;
  String fscode;
  String img;
  String regularPrice;
  String specialPrice;
  String billcolor;
  bool isInStock;
  String checkLimit;
  String imgAppend;
  String flagNetPrice;
  String imgNetPrice;

  factory ListSku.fromJson(Map<String, dynamic> json) => ListSku(
        billcamp: json["billcamp"] ?? "",
        billcode: json["billcode"] ?? "",
        billName: json["billName"] ?? "",
        brand: json["brand"] ?? "",
        mediaCode: json["mediaCode"] ?? "",
        fscode: json["fscode"] ?? "",
        img: json["img"] ?? "",
        regularPrice: json["regularPrice"] ?? "",
        specialPrice: json["specialPrice"] ?? "",
        billcolor: json["billcolor"] ?? "",
        isInStock: json["is_in_stock"],
        checkLimit: json["checkLimit"] ?? "",
        imgAppend: json["imgAppend"] ?? "",
        flagNetPrice: json["flagNetPrice"] ?? "",
        imgNetPrice: json["imgNetPrice"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "billcamp": billcamp,
        "billcode": billcode,
        "billName": billName,
        "brand": brand,
        "mediaCode": mediaCode,
        "fscode": fscode,
        "img": img,
        "regularPrice": regularPrice,
        "specialPrice": specialPrice,
        "billcolor": billcolor,
        "is_in_stock": isInStock,
        "checkLimit": checkLimit,
        "imgAppend": imgAppend,
        "flagNetPrice": flagNetPrice,
        "imgNetPrice": imgNetPrice,
      };
}
