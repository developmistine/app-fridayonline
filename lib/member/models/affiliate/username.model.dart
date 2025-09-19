// To parse this JSON data, do
//
//     final usernameAvailable = usernameAvailableFromJson(jsonString);

import 'dart:convert';

UsernameAvailable usernameAvailableFromJson(String str) =>
    UsernameAvailable.fromJson(json.decode(str));

String usernameAvailableToJson(UsernameAvailable data) =>
    json.encode(data.toJson());

class UsernameAvailable {
  String code;
  String message;
  bool available;

  UsernameAvailable({
    required this.code,
    required this.message,
    required this.available,
  });

  factory UsernameAvailable.fromJson(Map<String, dynamic> json) =>
      UsernameAvailable(
        code: json["code"],
        message: json["message"],
        available: json["available"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "available": available,
      };
}
