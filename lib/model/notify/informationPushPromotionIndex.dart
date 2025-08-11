import 'dart:convert';

InformationPushPromotionIndex informationPushPromotionIndexFromJson(
        String str) =>
    InformationPushPromotionIndex.fromJson(json.decode(str));

String informationPushPromotionIndexToJson(
        InformationPushPromotionIndex data) =>
    json.encode(data.toJson());

class InformationPushPromotionIndex {
  InformationPushPromotionIndex({
    required this.promotionIndex,
  });

  List<PromotionIndex> promotionIndex;

  factory InformationPushPromotionIndex.fromJson(Map<String, dynamic> json) =>
      InformationPushPromotionIndex(
        promotionIndex: json["PromotionIndex"] == null ? [] : List<PromotionIndex>.from(
            json["PromotionIndex"].map((x) => PromotionIndex.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "PromotionIndex":
            List<dynamic>.from(promotionIndex.map((x) => x.toJson())),
      };
}

class PromotionIndex {
  PromotionIndex({
    required this.status,
    required this.message,
    required this.promotion,
  });

  String status;
  String message;
  List<Promotion> promotion;

  factory PromotionIndex.fromJson(Map<String, dynamic> json) => PromotionIndex(
        status: json["Status"] ?? "",
        message: json["Message"] ?? "",
        promotion: json["Promotion"] == null ? [] : List<Promotion>.from(
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
  String idgroup;
  String idindex;
  String title;
  String desc;
  String imgContent;
  String type;
  dynamic numShow;
  String parameterContent;
  String parameterKey;
  dynamic link;
  String badger;
  String date;
  String linkimg;
  String linkindex;
  String readStatus;

  factory Promotion.fromJson(Map<String, dynamic> json) => Promotion(
        id: json["Id"] ?? "",
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
