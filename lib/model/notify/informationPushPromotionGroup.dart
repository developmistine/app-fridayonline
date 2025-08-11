// // To parse this JSON data, do
// //
// //     final informationPushPromotionGroup = informationPushPromotionGroupFromJson(jsonString);

// import 'dart:convert';

// InformationPushPromotionGroup informationPushPromotionGroupFromJson(
//         String str) =>
//     InformationPushPromotionGroup.fromJson(json.decode(str));

// String informationPushPromotionGroupToJson(
//         InformationPushPromotionGroup data) =>
//     json.encode(data.toJson());

// class InformationPushPromotionGroup {
//   InformationPushPromotionGroup({
//     required this.promotionGroup,
//   });

//   List<PromotionGroup> promotionGroup;

//   factory InformationPushPromotionGroup.fromJson(Map<String, dynamic> json) =>
//       InformationPushPromotionGroup(
//         promotionGroup: List<PromotionGroup>.from(
//             json["PromotionGroup"].map((x) => PromotionGroup.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "PromotionGroup":
//             List<dynamic>.from(promotionGroup.map((x) => x.toJson())),
//       };
// }

// class PromotionGroup {
//   PromotionGroup({
//     required this.status,
//     required this.message,
//     required this.promotion,
//   });

//   String status;
//   String message;
//   List<Promotion> promotion;

//   factory PromotionGroup.fromJson(Map<String, dynamic> json) => PromotionGroup(
//         status: json["Status"],
//         message: json["Message"],
//         promotion: List<Promotion>.from(
//             json["Promotion"].map((x) => Promotion.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "Status": status,
//         "Message": message,
//         "Promotion": List<dynamic>.from(promotion.map((x) => x.toJson())),
//       };
// }

// class Promotion {
//   Promotion({
//     required this.id,
//     required this.idgroup,
//     required this.idindex,
//     required this.title,
//     required this.desc,
//     required this.imgContent,
//     required this.type,
//     required this.numShow,
//     required this.parameterContent,
//     required this.parameterKey,
//     required this.link,
//     required this.badger,
//     required this.date,
//     required this.linkimg,
//     required this.linkindex,
//     required this.readStatus,
//   });

//   String id;
//   String idgroup;
//   String idindex;
//   String title;
//   String desc;
//   String imgContent;
//   String type;
//   String numShow;
//   String parameterContent;
//   String parameterKey;
//   String link;
//   String badger;
//   DateTime date;
//   String linkimg;
//   String linkindex;
//   String readStatus;

//   factory Promotion.fromJson(Map<String, dynamic> json) => Promotion(
//         id: json["Id"],
//         idgroup: json["Idgroup"],
//         idindex: json["Idindex"],
//         title: json["Title"],
//         desc: json["Desc"],
//         imgContent: json["ImgContent"],
//         type: json["Type"],
//         numShow: json["NumShow"],
//         parameterContent: json["ParameterContent"],
//         parameterKey: json["ParameterKey"],
//         link: json["Link"],
//         badger: json["Badger"],
//         date: DateTime.parse(json["Date"]),
//         linkimg: json["Linkimg"],
//         linkindex: json["Linkindex"],
//         readStatus: json["ReadStatus"],
//       );

//   Map<String, dynamic> toJson() => {
//         "Id": id,
//         "Idgroup": idgroup,
//         "Idindex": idindex,
//         "Title": title,
//         "Desc": desc,
//         "ImgContent": imgContent,
//         "Type": type,
//         "NumShow": numShow,
//         "ParameterContent": parameterContent,
//         "ParameterKey": parameterKey,
//         "Link": link,
//         "Badger": badger,
//         "Date": date.toIso8601String(),
//         "Linkimg": linkimg,
//         "Linkindex": linkindex,
//         "ReadStatus": readStatus,
//       };
// }

// To parse this JSON data, do
//
//     final informationPushPromotionGroup = informationPushPromotionGroupFromJson(jsonString);

// import 'package:meta/meta.dart';
import 'dart:convert';

InformationPushPromotionGroup informationPushPromotionGroupFromJson(
        String str) =>
    InformationPushPromotionGroup.fromJson(json.decode(str));

String informationPushPromotionGroupToJson(
        InformationPushPromotionGroup data) =>
    json.encode(data.toJson());

class InformationPushPromotionGroup {
  InformationPushPromotionGroup({
    required this.promotionGroup,
  });

  List<PromotionGroup> promotionGroup;

  factory InformationPushPromotionGroup.fromJson(Map<String, dynamic> json) =>
      InformationPushPromotionGroup(
        promotionGroup: json["PromotionGroup"] == null
            ? []
            : List<PromotionGroup>.from(
                json["PromotionGroup"].map((x) => PromotionGroup.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "PromotionGroup":
            List<dynamic>.from(promotionGroup.map((x) => x.toJson())),
      };
}

class PromotionGroup {
  PromotionGroup({
    required this.status,
    required this.message,
    required this.promotion,
  });

  String status;
  String message;
  List<Promotion> promotion;

  factory PromotionGroup.fromJson(Map<String, dynamic> json) => PromotionGroup(
        status: json["Status"] ?? "",
        message: json["Message"] ?? "",
        promotion: json["Promotion"] == null
            ? []
            : List<Promotion>.from(
                json["Promotion"].map((x) => Promotion.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Status": status,
        "Message": message,
        "Promotion": List<dynamic>.from(promotion.map((x) => x.toJson())),
      };
}

class Promotion {
  Promotion({
    required this.id,
    required this.contentId,
    required this.idgroup,
    required this.idindex,
    required this.title,
    required this.desc,
    required this.imgContent,
    required this.type,
    required this.numShow,
    required this.parameterContent,
    required this.parameterKey,
    required this.link,
    required this.badger,
    required this.date,
    required this.linkimg,
    required this.linkindex,
    required this.readStatus,
  });

  String id;
  String contentId;
  String idgroup;
  String idindex;
  String title;
  String desc;
  String imgContent;
  String type;
  String numShow;
  String parameterContent;
  String parameterKey;
  String link;
  String badger;
  String date;
  String linkimg;
  String linkindex;
  String readStatus;

  factory Promotion.fromJson(Map<String, dynamic> json) => Promotion(
        id: json["Id"] ?? "",
        contentId: json["ContentId"] ?? "",
        idgroup: json["Idgroup"] ?? "",
        idindex: json["Idindex"] ?? "",
        title: json["Title"] ?? "",
        desc: json["Desc"] ?? "",
        imgContent: json["ImgContent"] ?? "",
        type: json["Type"] ?? "",
        numShow: json["NumShow"] ?? "",
        parameterContent: json["ParameterContent"] ?? "",
        parameterKey: json["ParameterKey"] ?? "",
        link: json["Link"] ?? "",
        badger: json["Badger"] ?? "",
        date: json["Date"] ?? "",
        linkimg: json["Linkimg"] ?? "",
        linkindex: json["Linkindex"] ?? "",
        readStatus: json["ReadStatus"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "ContentId": contentId,
        "Idgroup": idgroup,
        "Idindex": idindex,
        "Title": title,
        "Desc": desc,
        "ImgContent": imgContent,
        "Type": type,
        "NumShow": numShow,
        "ParameterContent": parameterContent,
        "ParameterKey": parameterKey,
        "Link": link,
        "Badger": badger,
        "Date": date,
        "Linkimg": linkimg,
        "Linkindex": linkindex,
        "ReadStatus": readStatus,
      };
}
