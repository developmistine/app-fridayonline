// To parse this JSON data, do
//
//     final chatLogin = chatLoginFromJson(jsonString);

import 'dart:convert';

ChatLogin chatLoginFromJson(String str) => ChatLogin.fromJson(json.decode(str));

String chatLoginToJson(ChatLogin data) => json.encode(data.toJson());

class ChatLogin {
  String code;
  String message;
  String accessToken;

  ChatLogin({
    required this.code,
    required this.message,
    required this.accessToken,
  });

  factory ChatLogin.fromJson(Map<String, dynamic> json) => ChatLogin(
        code: json["code"],
        message: json["message"],
        accessToken: json["access_token"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "access_token": accessToken,
      };
}
