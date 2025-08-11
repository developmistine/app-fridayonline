// To parse this JSON data, do
//
//     final pushOtpMslRegis = pushOtpMslRegisFromJson(jsonString);

import 'dart:convert';

PushOtpMslRegis pushOtpMslRegisFromJson(String str) =>
    PushOtpMslRegis.fromJson(json.decode(str));

String pushOtpMslRegisToJson(PushOtpMslRegis data) =>
    json.encode(data.toJson());

class PushOtpMslRegis {
  String values;
  String message;
  String telNumber;

  PushOtpMslRegis({
    required this.values,
    required this.message,
    required this.telNumber,
  });

  factory PushOtpMslRegis.fromJson(Map<String, dynamic> json) =>
      PushOtpMslRegis(
        values: json["values"],
        message: json["Message"],
        telNumber: json["TelNumber"],
      );

  Map<String, dynamic> toJson() => {
        "values": values,
        "Message": message,
        "TelNumber": telNumber,
      };
}
