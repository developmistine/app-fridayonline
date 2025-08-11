// To parse this JSON data, do
//
//     final sharecatshortUrl = sharecatshortUrlFromJson(jsonString);

import 'dart:convert';

SharecatshortUrl sharecatshortUrlFromJson(String str) =>
    SharecatshortUrl.fromJson(json.decode(str));

String sharecatshortUrlToJson(SharecatshortUrl data) =>
    json.encode(data.toJson());

class SharecatshortUrl {
  String code;
  String message1;
  String message2;
  String shortUrl;
  String fullUrl;
  String keyUrl;

  SharecatshortUrl({
    required this.code,
    required this.message1,
    required this.message2,
    required this.shortUrl,
    required this.fullUrl,
    required this.keyUrl,
  });

  factory SharecatshortUrl.fromJson(Map<String, dynamic> json) =>
      SharecatshortUrl(
        code: json["Code"],
        message1: json["Message1"],
        message2: json["Message2"],
        shortUrl: json["ShortUrl"],
        fullUrl: json["FullUrl"],
        keyUrl: json["KeyUrl"],
      );

  Map<String, dynamic> toJson() => {
        "Code": code,
        "Message1": message1,
        "Message2": message2,
        "ShortUrl": shortUrl,
        "FullUrl": fullUrl,
        "KeyUrl": keyUrl,
      };
}
