// To parse this JSON data, do
//
//     final insActionStockMessage = insActionStockMessageFromJson(jsonString);

import 'dart:convert';

InsActionStockMessage insActionStockMessageFromJson(String str) =>
    InsActionStockMessage.fromJson(json.decode(str));

String insActionStockMessageToJson(InsActionStockMessage data) =>
    json.encode(data.toJson());

class InsActionStockMessage {
  InsActionStockMessage({
    required this.code,
    required this.message1,
    required this.message2,
    required this.message3,
  });

  String code;
  String message1;
  String message2;
  String message3;

  factory InsActionStockMessage.fromJson(Map<String, dynamic> json) =>
      InsActionStockMessage(
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
