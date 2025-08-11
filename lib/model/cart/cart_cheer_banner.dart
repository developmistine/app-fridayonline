// To parse this JSON data, do
//
//     final cartCheerBanner = cartCheerBannerFromJson(jsonString);

import 'dart:convert';

CartCheerBanner cartCheerBannerFromJson(String str) =>
    CartCheerBanner.fromJson(json.decode(str));

String cartCheerBannerToJson(CartCheerBanner data) =>
    json.encode(data.toJson());

class CartCheerBanner {
  String reptype;
  String repSeq;
  String repCode;
  String header;
  String title;
  List<BannerDetail> bannerDetail;

  CartCheerBanner({
    required this.reptype,
    required this.repSeq,
    required this.repCode,
    required this.header,
    required this.title,
    required this.bannerDetail,
  });

  factory CartCheerBanner.fromJson(Map<String, dynamic> json) =>
      CartCheerBanner(
        reptype: json["reptype"],
        repSeq: json["rep_seq"],
        repCode: json["rep_code"],
        header: json["header"],
        title: json["title"],
        bannerDetail: List<BannerDetail>.from(
            json["banner_detail"].map((x) => BannerDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "reptype": reptype,
        "rep_seq": repSeq,
        "rep_code": repCode,
        "header": header,
        "title": title,
        "banner_detail":
            List<dynamic>.from(bannerDetail.map((x) => x.toJson())),
      };
}

class BannerDetail {
  String id;
  String contentName;
  String contentIndex;
  String keyindex;
  String contentImg;
  String campaign;
  String brand;
  String meberCode;
  String fsCode;

  BannerDetail({
    required this.id,
    required this.contentName,
    required this.contentIndex,
    required this.keyindex,
    required this.contentImg,
    required this.campaign,
    required this.brand,
    required this.meberCode,
    required this.fsCode,
  });

  factory BannerDetail.fromJson(Map<String, dynamic> json) => BannerDetail(
        id: json["id"],
        contentName: json["content_name"],
        contentIndex: json["content_index"],
        keyindex: json["keyindex"],
        contentImg: json["content_img"],
        campaign: json["campaign"],
        brand: json["brand"],
        meberCode: json["meber_code"],
        fsCode: json["fs_code"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "content_name": contentName,
        "content_index": contentIndex,
        "keyindex": keyindex,
        "content_img": contentImg,
        "campaign": campaign,
        "brand": brand,
        "meber_code": meberCode,
        "fs_code": fsCode,
      };
}
