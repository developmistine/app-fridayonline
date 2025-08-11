// To parse this JSON data, do
//
//     final coinsInfo = coinsInfoFromJson(jsonString);

import 'dart:convert';

CoinsInfo coinsInfoFromJson(String str) => CoinsInfo.fromJson(json.decode(str));

String coinsInfoToJson(CoinsInfo data) => json.encode(data.toJson());

class CoinsInfo {
  String code;
  Data data;
  String message;

  CoinsInfo({
    required this.code,
    required this.data,
    required this.message,
  });

  factory CoinsInfo.fromJson(Map<String, dynamic> json) => CoinsInfo(
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
  String title;
  List<Info> info;

  Data({
    required this.title,
    required this.info,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        title: json["title"],
        info: List<Info>.from(json["info"].map((x) => Info.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "info": List<dynamic>.from(info.map((x) => x.toJson())),
      };
}

class Info {
  String key;
  String value;

  Info({
    required this.key,
    required this.value,
  });

  factory Info.fromJson(Map<String, dynamic> json) => Info(
        key: json["key"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "value": value,
      };
}
