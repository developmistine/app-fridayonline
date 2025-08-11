import 'dart:convert';

PamPush pamPushFromJson(String str) => PamPush.fromJson(json.decode(str));

String pamPushToJson(PamPush data) => json.encode(data.toJson());

class PamPush {
  String popupType;
  String catalogType;
  String contentIndex;
  String billCode;
  String media;
  String url;
  String contentType;
  String flex;
  String pamPushPopupType;
  String campaign;
  String fsCode;
  String createdDate;
  String brand;
  String pixel;
  String categoryId;
  String channelId;

  PamPush({
    required this.popupType,
    required this.catalogType,
    required this.contentIndex,
    required this.billCode,
    required this.media,
    required this.url,
    required this.contentType,
    required this.flex,
    required this.pamPushPopupType,
    required this.campaign,
    required this.fsCode,
    required this.createdDate,
    required this.brand,
    required this.pixel,
    required this.categoryId,
    required this.channelId
  });

  factory PamPush.fromJson(Map<String, dynamic> json) => PamPush(
        popupType: json["popupType"] ?? "",
        catalogType: json["catalogType"] ?? "",
        contentIndex: json["content_index"] ?? "",
        billCode: json["billCode"] ?? "",
        media: json["media"] ?? "",
        url: json["url"] ?? "",
        contentType: json["content_type"] ?? "",
        flex: json["flex"] ?? "",
        pamPushPopupType: json["popup_type"] ?? "",
        campaign: json["campaign"] ?? "",
        fsCode: json["fsCode"] ?? "",
        createdDate: json["created_date"] ?? "",
        brand: json["brand"] ?? "",
        pixel: json["pixel"] ?? "",
        categoryId: json["categoryID"] ?? "",
        channelId: json["channelID"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "popupType": popupType,
        "catalogType": catalogType,
        "content_index": contentIndex,
        "billCode": billCode,
        "media": media,
        "url": url,
        "content_type": contentType,
        "flex": flex,
        "popup_type": pamPushPopupType,
        "campaign": campaign,
        "fsCode": fsCode,
        "created_date": createdDate,
        "brand": brand,
        "pixel": pixel,
        "categoryID": categoryId,
        "channelID": channelId,
      };
}
