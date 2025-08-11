// To parse this JSON data, do
//
//     final b2CLogin = b2CLoginFromJson(jsonString);

import 'dart:convert';

B2CLogin b2CLoginFromJson(String str) => B2CLogin.fromJson(json.decode(str));

String b2CLoginToJson(B2CLogin data) => json.encode(data.toJson());

class B2CLogin {
  String code;
  Data data;
  String message;
  String accessToken;
  String refreshToken;

  B2CLogin({
    required this.accessToken,
    required this.code,
    required this.data,
    required this.message,
    required this.refreshToken,
  });

  factory B2CLogin.fromJson(Map<String, dynamic> json) => B2CLogin(
        accessToken: json["access_token"],
        code: json["code"],
        data: Data.fromJson(json["data"]),
        message: json["message"],
        refreshToken: json["refresh_token"],
      );

  Map<String, dynamic> toJson() => {
        "access_token": accessToken,
        "code": code,
        "data": data.toJson(),
        "message": message,
        "refresh_token": refreshToken,
      };
}

class Data {
  int custId;
  String displayName;

  Data({
    required this.custId,
    required this.displayName,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        custId: json["cust_id"],
        displayName: json["display_name"],
      );

  Map<String, dynamic> toJson() => {
        "cust_id": custId,
        "display_name": displayName,
      };
}
