// To parse this JSON data, do
//
//     final shopInfo = shopInfoFromJson(jsonString);

import 'dart:convert';

ShopInfo shopInfoFromJson(String str) => ShopInfo.fromJson(json.decode(str));

String shopInfoToJson(ShopInfo data) => json.encode(data.toJson());

class ShopInfo {
  String code;
  Data data;
  String message;

  ShopInfo({
    required this.code,
    required this.data,
    required this.message,
  });

  factory ShopInfo.fromJson(Map<String, dynamic> json) => ShopInfo(
        code: json["code"],
        data: Data.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "data": data.toJson(),
        "message": message,
      };
}

class Data {
  bool isShopOfficial;
  int shopId;
  String shopCode;
  String shopName;
  String cover;
  int itemCount;
  String itemCountDisplay;
  int follwerCount;
  Account account;
  bool followed;
  String ratingStar;
  int responseRate;
  String description;

  Data({
    required this.isShopOfficial,
    required this.shopId,
    required this.shopCode,
    required this.shopName,
    required this.cover,
    required this.itemCount,
    required this.itemCountDisplay,
    required this.follwerCount,
    required this.account,
    required this.followed,
    required this.ratingStar,
    required this.responseRate,
    required this.description,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        isShopOfficial: json["is_shop_official"],
        shopId: json["shop_id"],
        shopCode: json["shop_code"],
        shopName: json["shop_name"],
        cover: json["cover"],
        itemCount: json["item_count"],
        itemCountDisplay: json["item_count_display"],
        follwerCount: json["follwer_count"],
        account: Account.fromJson(json["account"]),
        followed: json["followed"],
        ratingStar: json["rating_star"],
        responseRate: json["response_rate"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "is_shop_official": isShopOfficial,
        "shop_id": shopId,
        "shop_code": shopCode,
        "shop_name": shopName,
        "cover": cover,
        "item_count": itemCount,
        "item_count_display": itemCountDisplay,
        "follwer_count": follwerCount,
        "account": account.toJson(),
        "followed": followed,
        "rating_star": ratingStar,
        "response_rate": responseRate,
        "description": description,
      };
}

class Account {
  String username;
  String image;
  int followingCount;
  String dateJoined;
  bool phoneVerified;
  bool emailVerified;
  String fbid;

  Account({
    required this.username,
    required this.image,
    required this.followingCount,
    required this.dateJoined,
    required this.phoneVerified,
    required this.emailVerified,
    required this.fbid,
  });

  factory Account.fromJson(Map<String, dynamic> json) => Account(
        username: json["username"],
        image: json["image"],
        followingCount: json["following_count"],
        dateJoined: json["date_joined"],
        phoneVerified: json["phone_verified"],
        emailVerified: json["email_verified"],
        fbid: json["fbid"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "image": image,
        "following_count": followingCount,
        "date_joined": dateJoined,
        "phone_verified": phoneVerified,
        "email_verified": emailVerified,
        "fbid": fbid,
      };
}
