// To parse this JSON data, do
//
//     final otpPoint = otpPointFromJson(jsonString);

import 'dart:convert';

OtpPoint otpPointFromJson(String str) => OtpPoint.fromJson(json.decode(str));

String otpPointToJson(OtpPoint data) => json.encode(data.toJson());

class OtpPoint {
  String code;
  String message;
  String telNumber;

  OtpPoint({
    required this.code,
    required this.message,
    required this.telNumber,
  });

  factory OtpPoint.fromJson(Map<String, dynamic> json) => OtpPoint(
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
