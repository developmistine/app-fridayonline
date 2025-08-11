// To parse this JSON data, do
//
//     final marketLoginSystems = marketLoginSystemsFromJson(jsonString);

// import 'package:meta/meta.dart';
import 'dart:convert';

MarketLoginSystems marketLoginSystemsFromJson(String str) =>
    MarketLoginSystems.fromJson(json.decode(str));

String marketLoginSystemsToJson(MarketLoginSystems data) =>
    json.encode(data.toJson());

class MarketLoginSystems {
  MarketLoginSystems({
    required this.token,
    required this.device,
    required this.model,
    required this.customerId,
    required this.userType,
    required this.tagId,
    required this.tagCode,
    required this.chanelsignin,
    required this.accessToken,
    required this.accessId,
    required this.name,
    required this.email,
    required this.status,
    required this.mobileNo,
    required this.profileImg,
    required this.tagApp,
  });

  String token;
  String device;
  String model;
  String customerId;
  String userType;
  String tagId;
  String tagCode;
  String chanelsignin;
  String accessToken;
  String accessId;
  String name;
  String email;
  String status;
  String mobileNo;
  String profileImg;
  String tagApp;

  factory MarketLoginSystems.fromJson(Map<String, dynamic> json) =>
      MarketLoginSystems(
        token: json["Token"] ?? "",
        device: json["Device"] ?? "",
        model: json["Model"] ?? "",
        customerId: json["CustomerID"] ?? "",
        userType: json["UserType"] ?? "",
        tagId: json["TagID"] ?? "",
        tagCode: json["TagCode"] ?? "",
        chanelsignin: json["Chanelsignin"] ?? "",
        accessToken: json["AccessToken"] ?? "",
        accessId: json["AccessID"] ?? "",
        name: json["Name"] ?? "",
        email: json["Email"] ?? "",
        status: json["Status"] ?? "",
        mobileNo: json["MobileNo"] ?? "",
        profileImg: json["ProfileImg"] ?? "",
        tagApp: json["TagApp"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "Token": token,
        "Device": device,
        "Model": model,
        "CustomerID": customerId,
        "UserType": userType,
        "TagID": tagId,
        "TagCode": tagCode,
        "Chanelsignin": chanelsignin,
        "AccessToken": accessToken,
        "AccessID": accessId,
        "Name": name,
        "Email": email,
        "Status": status,
        "MobileNo": mobileNo,
        "ProfileImg": profileImg,
        "TagApp": tagApp,
      };
}
