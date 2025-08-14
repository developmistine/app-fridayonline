// To parse this JSON data, do
//
//     final fairsProductSwipe = fairsProductSwipeFromJson(jsonString);

import 'dart:convert';

FairsProductSwipe fairsProductSwipeFromJson(String str) =>
    FairsProductSwipe.fromJson(json.decode(str));

String fairsProductSwipeToJson(FairsProductSwipe data) =>
    json.encode(data.toJson());

class FairsProductSwipe {
  String code;
  String message;
  bool showPopup;
  int userDailyQuota;
  int userRemainingQuota;
  PopupResponse popupResponse;
  Data data;

  FairsProductSwipe({
    required this.code,
    required this.message,
    required this.showPopup,
    required this.userDailyQuota,
    required this.userRemainingQuota,
    required this.popupResponse,
    required this.data,
  });

  factory FairsProductSwipe.fromJson(Map<String, dynamic> json) =>
      FairsProductSwipe(
        code: json["code"],
        message: json["message"],
        showPopup: json["show_popup"],
        userDailyQuota: json["user_daily_quota"],
        userRemainingQuota: json["user_remaining_quota"],
        popupResponse: PopupResponse.fromJson(json["popup_response"]),
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "show_popup": showPopup,
        "user_daily_quota": userDailyQuota,
        "user_remaining_quota": userRemainingQuota,
        "popup_response": popupResponse.toJson(),
        "data": data.toJson(),
      };
}

class Data {
  int promotionId;
  String promotionName;
  String promotionDesc;
  String startTime;
  String endTime;

  bool canUndo;
  List<ProductListing> productListings;

  Data({
    required this.promotionId,
    required this.promotionName,
    required this.promotionDesc,
    required this.startTime,
    required this.endTime,
    required this.canUndo,
    required this.productListings,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        promotionId: json["promotion_id"],
        promotionName: json["promotion_name"],
        promotionDesc: json["promotion_desc"],
        startTime: json["start_time"],
        endTime: json["end_time"],
        canUndo: json["can_undo"],
        productListings: json["product_listings"] == null
            ? []
            : List<ProductListing>.from(json["product_listings"]
                .map((x) => ProductListing.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "promotion_id": promotionId,
        "promotion_name": promotionName,
        "promotion_desc": promotionDesc,
        "start_time": startTime,
        "end_time": endTime,
        "can_undo": canUndo,
        "product_listings":
            List<dynamic>.from(productListings.map((x) => x.toJson())),
      };
}

class ProductListing {
  int seqNo;
  int productId;
  String productName;
  String image;
  int itemId;
  String viewerText;
  List<TierVariation> tierVariations;
  Discount normalPrice;
  Discount discount;
  Discount fridayFairPrice;
  bool isNext;
  bool isSecretDeal;
  bool isLiked;
  int likeCount;
  int commentCount;
  ShopInfo shopInfo;
  LotInfo lotInfo;
  bool isImageOverlayed;
  String imageOverlay;

  ProductListing({
    required this.seqNo,
    required this.productId,
    required this.productName,
    required this.image,
    required this.itemId,
    required this.viewerText,
    required this.tierVariations,
    required this.normalPrice,
    required this.discount,
    required this.fridayFairPrice,
    required this.isNext,
    required this.isSecretDeal,
    required this.isLiked,
    required this.likeCount,
    required this.commentCount,
    required this.shopInfo,
    required this.lotInfo,
    required this.isImageOverlayed,
    required this.imageOverlay,
  });

  factory ProductListing.fromJson(Map<String, dynamic> json) => ProductListing(
        seqNo: json["seq_no"],
        productId: json["product_id"],
        productName: json["product_name"],
        image: json["image"],
        itemId: json["item_id"],
        viewerText: json["viewer_text"],
        tierVariations: List<TierVariation>.from(
            json["tier_variations"].map((x) => TierVariation.fromJson(x))),
        normalPrice: Discount.fromJson(json["normal_price"]),
        discount: Discount.fromJson(json["discount"]),
        fridayFairPrice: Discount.fromJson(json["friday_fair_price"]),
        isNext: json["is_next"],
        isSecretDeal: json["is_secret_deal"],
        isLiked: json["is_liked"],
        likeCount: json["like_count"],
        commentCount: json["comment_count"],
        shopInfo: ShopInfo.fromJson(json["shop_info"]),
        lotInfo: LotInfo.fromJson(json["lot_info"]),
        isImageOverlayed: json["is_image_overlayed"],
        imageOverlay: json["image_overlay"],
      );

  Map<String, dynamic> toJson() => {
        "seq_no": seqNo,
        "product_id": productId,
        "product_name": productName,
        "image": image,
        "item_id": itemId,
        "viewer_text": viewerText,
        "tier_variations":
            List<dynamic>.from(tierVariations.map((x) => x.toJson())),
        "normal_price": normalPrice.toJson(),
        "discount": discount.toJson(),
        "friday_fair_price": fridayFairPrice.toJson(),
        "is_next": isNext,
        "is_secret_deal": isSecretDeal,
        "is_liked": isLiked,
        "like_count": likeCount,
        "comment_count": commentCount,
        "shop_info": shopInfo.toJson(),
        "lot_info": lotInfo.toJson(),
        "is_image_overlayed": isImageOverlayed,
        "image_overlay": imageOverlay,
      };
}

class Discount {
  String key;
  String value;
  String color;

  Discount({
    required this.key,
    required this.value,
    required this.color,
  });

  factory Discount.fromJson(Map<String, dynamic> json) => Discount(
        key: json["key"],
        value: json["value"],
        color: json["color"],
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "value": value,
        "color": color,
      };
}

class LotInfo {
  String displayText;
  String remainingText;
  bool hasTimeLimit;
  String manufactureDate;
  String expireDate;
  String infoText;

  LotInfo({
    required this.displayText,
    required this.remainingText,
    required this.hasTimeLimit,
    required this.manufactureDate,
    required this.expireDate,
    required this.infoText,
  });

  factory LotInfo.fromJson(Map<String, dynamic> json) => LotInfo(
        displayText: json["display_text"],
        remainingText: json["remaining_text"],
        hasTimeLimit: json["has_time_limit"],
        manufactureDate: json["manufacture_date"],
        expireDate: json["expire_date"],
        infoText: json["info_text"],
      );

  Map<String, dynamic> toJson() => {
        "display_text": displayText,
        "remaining_text": remainingText,
        "has_time_limit": hasTimeLimit,
        "manufacture_date": manufactureDate,
        "expire_date": expireDate,
        "info_text": infoText,
      };
}

class ShopInfo {
  String icon;
  int shopId;
  String shopCode;
  String shopName;
  String shopAddress;

  ShopInfo({
    required this.icon,
    required this.shopId,
    required this.shopCode,
    required this.shopName,
    required this.shopAddress,
  });

  factory ShopInfo.fromJson(Map<String, dynamic> json) => ShopInfo(
        icon: json["icon"],
        shopId: json["shop_id"],
        shopCode: json["shop_code"],
        shopName: json["shop_name"],
        shopAddress: json["shop_address"],
      );

  Map<String, dynamic> toJson() => {
        "icon": icon,
        "shop_id": shopId,
        "shop_code": shopCode,
        "shop_name": shopName,
        "shop_address": shopAddress,
      };
}

class TierVariation {
  String name;
  List<Option> options;

  TierVariation({
    required this.name,
    required this.options,
  });

  factory TierVariation.fromJson(Map<String, dynamic> json) => TierVariation(
        name: json["name"],
        options:
            List<Option>.from(json["options"].map((x) => Option.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "options": List<dynamic>.from(options.map((x) => x.toJson())),
      };
}

class Option {
  String optionValue;
  String image;
  int displayIndicators;

  Option({
    required this.optionValue,
    required this.image,
    required this.displayIndicators,
  });

  factory Option.fromJson(Map<String, dynamic> json) => Option(
        optionValue: json["option_value"],
        image: json["image"],
        displayIndicators: json["display_indicators"],
      );

  Map<String, dynamic> toJson() => {
        "option_value": optionValue,
        "image": image,
        "display_indicators": displayIndicators,
      };
}

class PopupResponse {
  String icon;
  String title;
  String subtitle;
  String desc;
  List<Action> actions;

  PopupResponse({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.desc,
    required this.actions,
  });

  factory PopupResponse.fromJson(Map<String, dynamic> json) => PopupResponse(
        icon: json["icon"],
        title: json["title"],
        subtitle: json["subtitle"],
        desc: json["desc"],
        actions: json["actions"] == null
            ? []
            : List<Action>.from(json["actions"].map((x) => Action.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "icon": icon,
        "title": title,
        "subtitle": subtitle,
        "desc": desc,
        "actions": List<dynamic>.from(actions.map((x) => x.toJson())),
      };
}

class Action {
  String action;
  String display;
  String actionKey;

  Action({
    required this.action,
    required this.display,
    required this.actionKey,
  });

  factory Action.fromJson(Map<String, dynamic> json) => Action(
        action: json["action"],
        display: json["display"],
        actionKey: json["action_key"],
      );

  Map<String, dynamic> toJson() => {
        "action": action,
        "display": display,
        "action_key": actionKey,
      };
}
