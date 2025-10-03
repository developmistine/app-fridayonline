// To parse this JSON data, do
//
//     final shareResponse = shareResponseFromJson(jsonString);

import 'dart:convert';

ShareResponse shareResponseFromJson(String str) =>
    ShareResponse.fromJson(json.decode(str));

String shareResponseToJson(ShareResponse data) => json.encode(data.toJson());

class ShareResponse {
  String code;
  ShareData data;
  String message;

  ShareResponse({
    required this.code,
    required this.data,
    required this.message,
  });

  factory ShareResponse.fromJson(Map<String, dynamic> json) => ShareResponse(
        code: json["code"],
        data: ShareData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "data": data.toJson(),
        "message": message,
      };
}

class ShareData {
  String shortCode;
  String shortUrl;
  String targetUrl;
  String channel;
  String shareMessage;

  ShareData({
    required this.shortCode,
    required this.shortUrl,
    required this.targetUrl,
    required this.channel,
    required this.shareMessage,
  });

  factory ShareData.fromJson(Map<String, dynamic> json) => ShareData(
        shortCode: json["short_code"],
        shortUrl: json["short_url"],
        targetUrl: json["target_url"],
        channel: json["channel"],
        shareMessage: json["share_message"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "short_code": shortCode,
        "short_url": shortUrl,
        "target_url": targetUrl,
        "channel": channel,
        "share_message": shareMessage,
      };
}
