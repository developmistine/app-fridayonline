// // To parse this JSON data, do
// //
// //     final specialPromotion = specialPromotionFromJson(jsonString);

// import 'package:meta/meta.dart';
// import 'dart:convert';

// SpecialPromotion specialPromotionFromJson(String str) =>
//     SpecialPromotion.fromJson(json.decode(str));

// String specialPromotionToJson(SpecialPromotion data) =>
//     json.encode(data.toJson());

// class SpecialPromotion {
//   SpecialPromotion({
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
//   dynamic textHeader;
//   dynamic menu;
//   dynamic announce;
//   dynamic keyIcon;
//   dynamic banner;
//   dynamic favorite;
//   dynamic flashSale;
//   List<SpecialPromotionElement> specialPromotion;
//   dynamic newProduct;
//   dynamic content;
//   dynamic bestSeller;
//   dynamic hotItem;
//   dynamic specialPromotionList;

//   factory SpecialPromotion.fromJson(Map<String, dynamic> json) =>
//       SpecialPromotion(
//         repCode: json["RepCode"],
//         repType: json["RepType"],
//         repSeq: json["RepSeq"],
//         textHeader: json["TextHeader"],
//         menu: json["Menu"],
//         announce: json["Announce"],
//         keyIcon: json["KeyIcon"],
//         banner: json["Banner"],
//         favorite: json["Favorite"],
//         flashSale: json["FlashSale"],
//         specialPromotion: List<SpecialPromotionElement>.from(
//             json["SpecialPromotion"]
//                 .map((x) => SpecialPromotionElement.fromJson(x))),
//         newProduct: json["NewProduct"],
//         content: json["Content"],
//         bestSeller: json["BestSeller"],
//         hotItem: json["HotItem"],
//         specialPromotionList: json["SpecialPromotionList"],
//       );

//   Map<String, dynamic> toJson() => {
//         "RepCode": repCode,
//         "RepType": repType,
//         "RepSeq": repSeq,
//         "TextHeader": textHeader,
//         "Menu": menu,
//         "Announce": announce,
//         "KeyIcon": keyIcon,
//         "Banner": banner,
//         "Favorite": favorite,
//         "FlashSale": flashSale,
//         "SpecialPromotion":
//             List<dynamic>.from(specialPromotion.map((x) => x.toJson())),
//         "NewProduct": newProduct,
//         "Content": content,
//         "BestSeller": bestSeller,
//         "HotItem": hotItem,
//         "SpecialPromotionList": specialPromotionList,
//       };
// }

// class SpecialPromotionElement {
//   SpecialPromotionElement({
//     required this.id,
//     required this.specialcode,
//     required this.specialname,
//     required this.specialnamedetail,
//     required this.specialkeyindex,
//     required this.specialimgapp,
//     required this.specialimgweb,
//     required this.speciallist,
//     required this.specialtype,
//     required this.specialCampaignStart,
//     required this.specialCampaignEnd,
//     required this.specialDateStart,
//     required this.specialDateEnd,
//     required this.specialdataindex,
//   });

//   String id;
//   String specialcode;
//   String specialname;
//   String specialnamedetail;
//   String specialkeyindex;
//   String specialimgapp;
//   String specialimgweb;
//   String speciallist;
//   String specialtype;
//   String specialCampaignStart;
//   String specialCampaignEnd;
//   String specialDateStart;
//   String specialDateEnd;
//   String specialdataindex;

//   factory SpecialPromotionElement.fromJson(Map<String, dynamic> json) =>
//       SpecialPromotionElement(
//         id: json["id"],
//         specialcode: json["specialcode"],
//         specialname: json["specialname"],
//         specialnamedetail: json["specialnamedetail"],
//         specialkeyindex: json["specialkeyindex"],
//         specialimgapp: json["specialimgapp"],
//         specialimgweb: json["specialimgweb"],
//         speciallist: json["speciallist"],
//         specialtype: json["specialtype"],
//         specialCampaignStart: json["specialCampaignStart"],
//         specialCampaignEnd: json["specialCampaignEnd"],
//         specialDateStart: json["specialDateStart"],
//         specialDateEnd: json["specialDateEnd"],
//         specialdataindex: json["specialdataindex"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "specialcode": specialcode,
//         "specialname": specialname,
//         "specialnamedetail": specialnamedetail,
//         "specialkeyindex": specialkeyindex,
//         "specialimgapp": specialimgapp,
//         "specialimgweb": specialimgweb,
//         "speciallist": speciallist,
//         "specialtype": specialtype,
//         "specialCampaignStart": specialCampaignStart,
//         "specialCampaignEnd": specialCampaignEnd,
//         "specialDateStart": specialDateStart,
//         "specialDateEnd": specialDateEnd,
//         "specialdataindex": specialdataindex,
//       };
// }
// To parse this JSON data, do
//
//     final specialPromotion = specialPromotionFromJson(jsonString);

// import 'package:meta/meta.dart';
import 'dart:convert';

SpecialPromotion specialPromotionFromJson(String str) =>
    SpecialPromotion.fromJson(json.decode(str));

String specialPromotionToJson(SpecialPromotion data) =>
    json.encode(data.toJson());

class SpecialPromotion {
  SpecialPromotion({
    required this.repCode,
    required this.repType,
    required this.repSeq,
    required this.textHeader,
    required this.menu,
    required this.announce,
    required this.specialPromotion,
  });

  String repCode;
  String repType;
  String repSeq;
  String textHeader;
  String menu;
  String announce;
  List<SpecialPromotionElement> specialPromotion;

  factory SpecialPromotion.fromJson(Map<String, dynamic> json) =>
      SpecialPromotion(
        repCode: json["RepCode"] ?? "",
        repType: json["RepType"] ?? "",
        repSeq: json["RepSeq"] ?? "",
        textHeader: json["TextHeader"] ?? "",
        menu: json["Menu"] ?? "",
        announce: json["Announce"] ?? "",
        specialPromotion: json["SpecialPromotion"] == null
            ? []
            : List<SpecialPromotionElement>.from(json["SpecialPromotion"]
                .map((x) => SpecialPromotionElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "RepCode": repCode,
        "RepType": repType,
        "RepSeq": repSeq,
        "TextHeader": textHeader,
        "Menu": menu,
        "Announce": announce,
        "SpecialPromotion":
            List<dynamic>.from(specialPromotion.map((x) => x.toJson())),
      };
}

class SpecialPromotionElement {
  SpecialPromotionElement({
    required this.id,
    required this.specialcode,
    required this.specialname,
    required this.specialnamedetail,
    required this.specialkeyindex,
    required this.specialimgapp,
    required this.specialimgweb,
    required this.speciallist,
    required this.specialtype,
    required this.specialCampaignStart,
    required this.specialCampaignEnd,
    required this.specialDateStart,
    required this.specialDateEnd,
    required this.specialdataindex,
    required this.membercode,
    required this.specialindexurl,
  });

  String id;
  String specialcode;
  String specialname;
  String specialnamedetail;
  String specialkeyindex;
  String specialimgapp;
  String specialimgweb;
  String speciallist;
  String specialtype;
  String specialCampaignStart;
  String specialCampaignEnd;
  String specialDateStart;
  String specialDateEnd;
  String specialdataindex;
  String membercode;
  String specialindexurl;

  factory SpecialPromotionElement.fromJson(Map<String, dynamic> json) =>
      SpecialPromotionElement(
        id: json["ID"] ?? "",
        specialcode: json["Specialcode"] ?? "",
        specialname: json["Specialname"] ?? "",
        specialnamedetail: json["Specialnamedetail"] ?? "",
        specialkeyindex: json["Specialkeyindex"] ?? "",
        specialimgapp: json["Specialimgapp"] ?? "",
        specialimgweb: json["Specialimgweb"] ?? "",
        speciallist: json["Speciallist"] ?? "",
        specialtype: json["Specialtype"] ?? "",
        specialCampaignStart: json["SpecialCampaignStart"] ?? "",
        specialCampaignEnd: json["SpecialCampaignEnd"] ?? "",
        specialDateStart: json["SpecialDateStart"] ?? "",
        specialDateEnd: json["SpecialDateEnd"] ?? "",
        specialdataindex: json["Specialdataindex"] ?? "",
        membercode: json["Membercode"] ?? "",
        specialindexurl: json["Specialindexurl"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "Specialcode": specialcode,
        "Specialname": specialname,
        "Specialnamedetail": specialnamedetail,
        "Specialkeyindex": specialkeyindex,
        "Specialimgapp": specialimgapp,
        "Specialimgweb": specialimgweb,
        "Speciallist": speciallist,
        "Specialtype": specialtype,
        "SpecialCampaignStart": specialCampaignStart,
        "SpecialCampaignEnd": specialCampaignEnd,
        "SpecialDateStart": specialDateStart,
        "SpecialDateEnd": specialDateEnd,
        "Specialdataindex": specialdataindex,
        "Membercode": membercode,
        "Specialindexurl": specialindexurl,
      };
}
