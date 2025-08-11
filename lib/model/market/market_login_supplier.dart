// To parse this JSON data, do
//
//     final loginCheckSupplier = loginCheckSupplierFromJson(jsonString);

// import 'package:meta/meta.dart';
import 'dart:convert';

LoginCheckSupplier loginCheckSupplierFromJson(String str) =>
    LoginCheckSupplier.fromJson(json.decode(str));

String loginCheckSupplierToJson(LoginCheckSupplier data) =>
    json.encode(data.toJson());

class LoginCheckSupplier {
  LoginCheckSupplier({
    required this.token,
    required this.code,
    required this.message,
  });

  String token;
  String code;
  String message;

  factory LoginCheckSupplier.fromJson(Map<String, dynamic> json) =>
      LoginCheckSupplier(
        token: json["Token"] ?? "",
        code: json["Code"] ?? "",
        message: json["message"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "Token": token,
        "Code": code,
        "message": message,
      };
}
