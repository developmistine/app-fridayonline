// To parse this JSON data, do
//
//     final checkRepcodeByPhoneNumber = checkRepcodeByPhoneNumberFromJson(jsonString);

// import 'package:meta/meta.dart';
import 'dart:convert';

CheckRepcodeByPhoneNumber checkRepcodeByPhoneNumberFromJson(String str) =>
    CheckRepcodeByPhoneNumber.fromJson(json.decode(str));

String checkRepcodeByPhoneNumberToJson(CheckRepcodeByPhoneNumber data) =>
    json.encode(data.toJson());

class CheckRepcodeByPhoneNumber {
  CheckRepcodeByPhoneNumber({
    required this.code,
    required this.message,
    required this.repcode,
    required this.flagOtp,
  });

  String code;
  String message;
  String repcode;
  bool flagOtp;

  factory CheckRepcodeByPhoneNumber.fromJson(Map<String, dynamic> json) =>
      CheckRepcodeByPhoneNumber(
        code: json["code"] ?? "",
        message: json["message"] ?? "",
        repcode: json["repcode"] ?? "",
        flagOtp: json["FlagOTP"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "repcode": repcode,
        "FlagOTP": flagOtp
      };
}
