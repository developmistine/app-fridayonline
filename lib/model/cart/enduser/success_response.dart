// To parse this JSON data, do
//
//     final successResponse = successResponseFromJson(jsonString);

import 'dart:convert';

SuccessResponse successResponseFromJson(String str) =>
    SuccessResponse.fromJson(json.decode(str));

String successResponseToJson(SuccessResponse data) =>
    json.encode(data.toJson());

class SuccessResponse {
  String code;
  String message1;
  String message2;
  String message3;

  SuccessResponse({
    required this.code,
    required this.message1,
    required this.message2,
    required this.message3,
  });

  factory SuccessResponse.fromJson(Map<String, dynamic> json) =>
      SuccessResponse(
        code: json["Code"],
        message1: json["Message1"],
        message2: json["Message2"],
        message3: json["Message3"],
      );

  Map<String, dynamic> toJson() => {
        "Code": code,
        "Message1": message1,
        "Message2": message2,
        "Message3": message3,
      };
}
