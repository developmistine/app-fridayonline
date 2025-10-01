// To parse this JSON data, do
//
//     final affiliateProfile = affiliateProfileFromJson(jsonString);

import 'dart:convert';

AffiliateProfile affiliateProfileFromJson(String str) =>
    AffiliateProfile.fromJson(json.decode(str));

String affiliateProfileToJson(AffiliateProfile data) =>
    json.encode(data.toJson());

class AffiliateProfile {
  String code;
  Data data;
  String message;

  AffiliateProfile({
    required this.code,
    required this.data,
    required this.message,
  });

  factory AffiliateProfile.fromJson(Map<String, dynamic> json) =>
      AffiliateProfile(
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
  int affiliateId;
  String storeName;
  String cover;
  int itemCount;
  String itemCountDisplay;
  Account account;

  Data({
    required this.affiliateId,
    required this.storeName,
    required this.cover,
    required this.itemCount,
    required this.itemCountDisplay,
    required this.account,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        affiliateId: json["affiliate_id"],
        storeName: json["store_name"],
        cover: json["cover"],
        itemCount: json["item_count"],
        itemCountDisplay: json["item_count_display"],
        account: Account.fromJson(json["account"]),
      );

  Map<String, dynamic> toJson() => {
        "affiliate_id": affiliateId,
        "store_name": storeName,
        "cover": cover,
        "item_count": itemCount,
        "item_count_display": itemCountDisplay,
        "account": account.toJson(),
      };
}

class Account {
  String userName;
  String moblie;
  String email;
  String image;
  String dateJoined;

  Account({
    required this.userName,
    required this.moblie,
    required this.email,
    required this.image,
    required this.dateJoined,
  });

  factory Account.fromJson(Map<String, dynamic> json) => Account(
        userName: json["user_name"],
        moblie: json["moblie"],
        email: json["email"],
        image: json["image"],
        dateJoined: json["date_joined"],
      );

  Map<String, dynamic> toJson() => {
        "user_name": userName,
        "moblie": moblie,
        "email": email,
        "image": image,
        "date_joined": dateJoined,
      };
}
