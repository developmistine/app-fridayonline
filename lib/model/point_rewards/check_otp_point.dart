// To parse this JSON data, do
//
//     final checkotpPoint = checkotpPointFromJson(jsonString);

import 'dart:convert';

CheckotpPoint checkotpPointFromJson(String str) =>
    CheckotpPoint.fromJson(json.decode(str));

String checkotpPointToJson(CheckotpPoint data) => json.encode(data.toJson());

class CheckotpPoint {
  String code;
  String message;
  String telNumber;

  CheckotpPoint({
    required this.code,
    required this.message,
    required this.telNumber,
  });

  factory CheckotpPoint.fromJson(Map<String, dynamic> json) => CheckotpPoint(
        code: json["Code"],
        message: json["Message"],
        telNumber: json["TelNumber"],
      );

  Map<String, dynamic> toJson() => {
        "Code": code,
        "Message": message,
        "TelNumber": telNumber,
      };
}
