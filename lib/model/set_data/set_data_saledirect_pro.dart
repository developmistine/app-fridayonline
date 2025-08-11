// To parse this JSON data, do
//
//     final getSaleDirectPro = getSaleDirectProFromJson(jsonString);

// import 'package:meta/meta.dart';
import 'dart:convert';

GetSaleDirectPro getSaleDirectProFromJson(String str) =>
    GetSaleDirectPro.fromJson(json.decode(str));

String getSaleDirectProToJson(GetSaleDirectPro data) =>
    json.encode(data.toJson());

class GetSaleDirectPro {
  GetSaleDirectPro({
    required this.repCode,
    required this.repType,
    required this.repSeq,
    required this.textHeader,
    required this.menu,
    required this.announce,
    required this.banner,
    required this.favorite,
    required this.flashSale,
    required this.specialPromotion,
    required this.newProduct,
    required this.content,
    required this.bestSeller,
    required this.hotItem,
  });

  String repCode;
  String repType;
  String repSeq;
  String textHeader;
  dynamic menu;
  dynamic announce;
  dynamic banner;
  dynamic favorite;
  dynamic flashSale;
  dynamic specialPromotion;
  dynamic newProduct;
  List<Content> content;
  dynamic bestSeller;
  dynamic hotItem;

  factory GetSaleDirectPro.fromJson(Map<String, dynamic> json) =>
      GetSaleDirectPro(
        repCode: json["RepCode"] ?? "",
        repType: json["RepType"] ?? "",
        repSeq: json["RepSeq"] ?? "",
        textHeader: json["TextHeader"] ?? "",
        menu: json["Menu"] ?? "",
        announce: json["Announce"] ?? "",
        banner: json["Banner"] ?? "",
        favorite: json["Favorite"] ?? "",
        flashSale: json["FlashSale"] ?? "",
        specialPromotion: json["SpecialPromotion"] ?? "",
        newProduct: json["NewProduct"] ?? "",
        content: json["Content"] == null
            ? []
            : List<Content>.from(
                json["Content"].map((x) => Content.fromJson(x))),
        bestSeller: json["BestSeller"],
        hotItem: json["HotItem"],
      );

  Map<String, dynamic> toJson() => {
        "RepCode": repCode,
        "RepType": repType,
        "RepSeq": repSeq,
        "TextHeader": textHeader,
        "Menu": menu,
        "Announce": announce,
        "Banner": banner,
        "Favorite": favorite,
        "FlashSale": flashSale,
        "SpecialPromotion": specialPromotion,
        "NewProduct": newProduct,
        "Content": List<dynamic>.from(content.map((x) => x.toJson())),
        "BestSeller": bestSeller,
        "HotItem": hotItem,
      };
}

class Content {
  Content({
    required this.id,
    required this.contentName,
    required this.typePages,
    required this.typeContent,
    required this.contentIndcx,
    required this.keyindex,
    required this.contentImg,
    required this.contentImgondestop,
    required this.status,
    required this.campaign,
    required this.band,
    required this.meberCode,
    required this.showBy,
    required this.startdate,
    required this.enddate,
    required this.startCampaign,
    required this.endCampaign,
    required this.showtype,
    required this.fsCode,
    required this.fsCodetemp,
  });

  String id;
  String contentName;
  String typePages;
  String typeContent;
  String contentIndcx;
  String keyindex;
  String contentImg;
  String contentImgondestop;
  String status;
  String campaign;
  String band;
  String meberCode;
  String showBy;
  String startdate;
  String enddate;
  String startCampaign;
  String endCampaign;
  String showtype;
  String fsCode;
  String fsCodetemp;

  factory Content.fromJson(Map<String, dynamic> json) => Content(
        id: json["id"] ?? "",
        contentName: json["content_name"] ?? "",
        typePages: json["type_pages"] ?? "",
        typeContent: json["type_content"] ?? "",
        contentIndcx: json["content_indcx"] ?? "",
        keyindex: json["keyindex"] ?? "",
        contentImg: json["content_img"] ?? "",
        contentImgondestop: json["content_imgondestop"] ?? "",
        status: json["status"] ?? "",
        campaign: json["campaign"] ?? "",
        band: json["band"] ?? "",
        meberCode: json["meber_code"] ?? "",
        showBy: json["show_by"] ?? "",
        startdate: json["startdate"] ?? "",
        enddate: json["enddate"] ?? "",
        startCampaign: json["start_campaign"] ?? "",
        endCampaign: json["end_campaign"] ?? "",
        showtype: json["showtype"] ?? "",
        fsCode: json["fs_code"] ?? "",
        fsCodetemp: json["fs_codetemp"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "content_name": contentName,
        "type_pages": typePages,
        "type_content": typeContent,
        "content_indcx": contentIndcx,
        "keyindex": keyindex,
        "content_img": contentImg,
        "content_imgondestop": contentImgondestop,
        "status": status,
        "campaign": campaign,
        "band": band,
        "meber_code": meberCode,
        "show_by": showBy,
        "startdate": startdate,
        "enddate": enddate,
        "start_campaign": startCampaign,
        "end_campaign": endCampaign,
        "showtype": showtype,
        "fs_code": fsCode,
        "fs_codetemp": fsCodetemp,
      };
}
