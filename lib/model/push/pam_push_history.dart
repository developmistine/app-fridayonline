// To parse this JSON data, do
//
//     final listPamPushHistory = listPamPushHistoryFromJson(jsonString);

import 'dart:convert';

ListPamPushHistory listPamPushHistoryFromJson(String str) => ListPamPushHistory.fromJson(json.decode(str));

String listPamPushHistoryToJson(ListPamPushHistory data) => json.encode(data.toJson());

class ListPamPushHistory {
    List<Item> items;

    ListPamPushHistory({
        required this.items,
    });

    factory ListPamPushHistory.fromJson(Map<String, dynamic> json) => ListPamPushHistory(
        items: json["items"] == null ? [] : List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
    };
}

class Item {
    String deliverId;
    String pixel;
    String title;
    String description;
    String thumbnailUrl;
    String flex;
    String url;
    String bannerUrl;
    String popupType;
    JsonData jsonData;
    bool isOpen;
    String createdDate;

    Item({
        required this.deliverId,
        required this.pixel,
        required this.title,
        required this.description,
        required this.thumbnailUrl,
        required this.flex,
        required this.url,
        required this.bannerUrl,
        required this.popupType,
        required this.jsonData,
        required this.isOpen,
        required this.createdDate,
    });

    factory Item.fromJson(Map<String, dynamic> json) => Item(
        deliverId: json["deliver_id"] ?? "",
        pixel: json["pixel"] ?? "",
        title: json["title"] ?? "",
        description: json["description"] ?? "",
        thumbnailUrl: json["thumbnail_url"] ?? "",
        flex: json["flex"] ?? "",
        url: json["url"] ?? "",
        bannerUrl: json["banner_url"] ?? "",
        popupType: json["popup_type"] ?? "",
        jsonData: JsonData.fromJson(json["json_data"]),
        isOpen: json["is_open"],
        createdDate: json["created_date"] ?? "",
    );

    Map<String, dynamic> toJson() => {
        "deliver_id": deliverId,
        "pixel": pixel,
        "title": title,
        "description": description,
        "thumbnail_url": thumbnailUrl,
        "flex": flex,
        "url": url,
        "banner_url": bannerUrl,
        "popup_type": popupType,
        "json_data": jsonData.toJson(),
        "is_open": isOpen,
        "created_date": createdDate,
    };
}

class JsonData {
    String message;
    Pam pam;
    String title;

    JsonData({
        required this.message,
        required this.pam,
        required this.title,
    });

    factory JsonData.fromJson(Map<String, dynamic> json) => JsonData(
        message: json["message"] ?? "",
        pam: Pam.fromJson(json["pam"]),
        title: json["title"] ?? "",
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "pam": pam.toJson(),
        "title": title,
    };
}

class Pam {
    String billCode;
    String brand;
    String campaign;
    String catalogType;
    String categoryId;
    String channelId;
    String contentIndex;
    String contentType;
    String createdDate;
    String flex;
    String fsCode;
    String media;
    String pixel;
    String popupType;
    String pamPopupType;
    String url;

    Pam({
        required this.billCode,
        required this.brand,
        required this.campaign,
        required this.catalogType,
        required this.categoryId,
        required this.channelId,
        required this.contentIndex,
        required this.contentType,
        required this.createdDate,
        required this.flex,
        required this.fsCode,
        required this.media,
        required this.pixel,
        required this.popupType,
        required this.pamPopupType,
        required this.url,
    });

    factory Pam.fromJson(Map<String, dynamic> json) => Pam(
        billCode: json["billCode"] ?? "",
        brand: json["brand"] ?? "",
        campaign: json["campaign"] ?? "",
        catalogType: json["catalogType"] ?? "",
        categoryId: json["categoryID"] ?? "",
        channelId: json["channelID"] ?? "",
        contentIndex: json["content_index"] ?? "",
        contentType: json["content_type"] ?? "",
        createdDate: json["created_date"] ?? "",
        flex: json["flex"] ?? "",
        fsCode: json["fsCode"] ?? "",
        media: json["media"] ?? "",
        pixel: json["pixel"] ?? "",
        popupType: json["popupType"] ?? "",
        pamPopupType: json["popup_type"] ?? "",
        url: json["url"] ?? "",
    );

    Map<String, dynamic> toJson() => {
        "billCode": billCode,
        "brand": brand,
        "campaign": campaign,
        "catalogType": catalogType,
        "categoryID": categoryId,
        "channelID": channelId,
        "content_index": contentIndex,
        "content_type": contentType,
        "created_date": createdDate,
        "flex": flex,
        "fsCode": fsCode,
        "media": media,
        "pixel": pixel,
        "popupType": popupType,
        "popup_type": pamPopupType,
        "url": url,
    };
}
