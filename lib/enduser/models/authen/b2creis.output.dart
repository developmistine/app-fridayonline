// To parse this JSON data, do
//
//     final b2CRegisterOutput = b2CRegisterOutputFromJson(jsonString);

import 'dart:convert';

B2CRegisterOutput b2CRegisterOutputFromJson(String str) =>
    B2CRegisterOutput.fromJson(json.decode(str));

String b2CRegisterOutputToJson(B2CRegisterOutput data) =>
    json.encode(data.toJson());

class B2CRegisterOutput {
  String code;
  Data data;
  String message;

  B2CRegisterOutput({
    required this.code,
    required this.data,
    required this.message,
  });

  factory B2CRegisterOutput.fromJson(Map<String, dynamic> json) =>
      B2CRegisterOutput(
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
  int custId;
  String accessToken;
  String refreshToken;

  Data({
    required this.custId,
    required this.accessToken,
    required this.refreshToken,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        custId: json["cust_id"],
        accessToken: json["access_token"] ?? "",
        refreshToken: json["refresh_token"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "cust_id": custId,
        "access_token": accessToken,
        "refresh_token": refreshToken,
      };
}
