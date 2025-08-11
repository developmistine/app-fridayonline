// To parse this JSON data, do
//
//     final marketRetunLogin = marketRetunLoginFromJson(jsonString);

// import 'package:meta/meta.dart';
import 'dart:convert';

MarketRetunLogin marketRetunLoginFromJson(String str) =>
    MarketRetunLogin.fromJson(json.decode(str));

String marketRetunLoginToJson(MarketRetunLogin data) =>
    json.encode(data.toJson());

class MarketRetunLogin {
  MarketRetunLogin({
    required this.token,
    required this.code,
    required this.messageRef1,
    required this.messageRef2,
    required this.messageRef3,
    required this.userId,
    required this.userType,
    required this.badger,
  });

  String token;
  String code;
  String messageRef1;
  String messageRef2;
  String messageRef3;
  String userId;
  String userType;
  dynamic badger;

  factory MarketRetunLogin.fromJson(Map<String, dynamic> json) =>
      MarketRetunLogin(
        token: json["Token"] ?? "",
        code: json["Code"] ?? "",
        messageRef1: json["MessageRef1"] ?? "",
        messageRef2: json["MessageRef2"] ?? "",
        messageRef3: json["MessageRef3"] ?? "",
        userId: json["UserID"] ?? "",
        userType: json["UserType"] ?? "",
        badger: json["Badger"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "Token": token,
        "Code": code,
        "MessageRef1": messageRef1,
        "MessageRef2": messageRef2,
        "MessageRef3": messageRef3,
        "UserID": userId,
        "UserType": userType,
        "Badger": badger,
      };
}
