import 'dart:convert';

PushNotify pushNotifyFromJson(String str) =>
    PushNotify.fromJson(json.decode(str));

String pushNotifyToJson(PushNotify data) => json.encode(data.toJson());

class PushNotify {
  PushNotify({
    required this.pushTitle,
    required this.catalogType,
    required this.contentIndex,
    required this.contentId,
    required this.billCode,
    required this.media,
    required this.repCode,
    required this.url,
    required this.contentType,
    required this.imgUrl,
    required this.repMobile,
    required this.fsCode,
    required this.campaign,
    required this.brand,
    required this.categoryId,
    required this.channelId,
    required this.userType,
    required this.productId,
    required this.sellerId,
    required this.orderType,
    required this.orderId,
    required this.sectionId,
    required this.notifyId,
  });

  String pushTitle;
  String catalogType;
  String contentIndex;
  String contentId;
  String billCode;
  String media;
  String repCode;
  String url;
  String contentType;
  String imgUrl;
  String repMobile;
  String fsCode;
  String campaign;
  String brand;
  String categoryId;
  String channelId;
  String userType;
  String productId;
  String sellerId;
  String orderType;
  String orderId;
  String sectionId;
  String notifyId;

  factory PushNotify.fromJson(Map<String, dynamic> json) => PushNotify(
        pushTitle: json["push_title"] ?? "",
        catalogType: json["catalogType"] ?? "",
        contentIndex: json["content_index"] ?? "",
        contentId: json["content_id"] ?? "",
        billCode: json["billCode"] ?? "",
        media: json["media"] ?? "",
        repCode: json["rep_code"] ?? "",
        url: json["url"] ?? "",
        contentType: json["content_type"] ?? "",
        imgUrl: json["img_url"] ?? "",
        repMobile: json["rep_mobile"] ?? "",
        fsCode: json["fsCode"] ?? "",
        campaign: json["campaign"] ?? "",
        brand: json["brand"] ?? "",
        categoryId: json["categoryID"] ?? "",
        channelId: json["channelID"] ?? "",
        userType: json["user_type"] ?? "",
        productId: json["product_id"] ?? "",
        sellerId: json["seller_id"] ?? "",
        orderType: json["order_type"] ?? "",
        orderId: json["order_id"] ?? "",
        sectionId: json["section_id"] ?? "0",
        notifyId: json["notify_id"].runtimeType == int
            ? json["notify_id"].toString()
            : json["notify_id"] ?? "0",
      );

  Map<String, dynamic> toJson() => {
        "push_title": pushTitle,
        "catalogType": catalogType,
        "content_index": contentIndex,
        "content_id": contentId,
        "billCode": billCode,
        "media": media,
        "rep_code": repCode,
        "url": url,
        "content_type": contentType,
        "img_url": imgUrl,
        "rep_mobile": repMobile,
        "fsCode": fsCode,
        "campaign": campaign,
        "brand": brand,
        "categoryID": categoryId,
        "channelID": channelId,
        "user_type": userType,
        "product_id": productId,
        "seller_id": sellerId,
        "order_type": orderType,
        "order_id": orderId,
        "section_id": sectionId,
        "notify_id": notifyId,
      };
}
