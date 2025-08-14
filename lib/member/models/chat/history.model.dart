// To parse this JSON data, do
//
//     final chatHistory = chatHistoryFromJson(jsonString);

import 'dart:convert';

import 'package:fridayonline/member/models/chat/recieve.message.model.dart';

ChatHistory chatHistoryFromJson(String str) =>
    ChatHistory.fromJson(json.decode(str));

String chatHistoryToJson(ChatHistory data) => json.encode(data.toJson());

class ChatHistory {
  String code;
  List<MessageData> data;
  String message;

  ChatHistory({
    required this.code,
    required this.data,
    required this.message,
  });

  factory ChatHistory.fromJson(Map<String, dynamic> json) => ChatHistory(
        code: json["code"] ?? "",
        data: List<MessageData>.from(
            json["data"].map((x) => MessageData.fromJson(x))),
        message: json["message"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
      };
}
