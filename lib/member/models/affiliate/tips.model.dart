// To parse this JSON data, do
//
//     final affiliateTips = affiliateTipsFromJson(jsonString);

import 'dart:convert';

AffiliateTips affiliateTipsFromJson(String str) =>
    AffiliateTips.fromJson(json.decode(str));

String affiliateTipsToJson(AffiliateTips data) => json.encode(data.toJson());

class AffiliateTips {
  String code;
  List<AffiliateTipsData> data;
  String message;

  AffiliateTips({
    required this.code,
    required this.data,
    required this.message,
  });

  factory AffiliateTips.fromJson(Map<String, dynamic> json) => AffiliateTips(
        code: json["code"],
        data: List<AffiliateTipsData>.from(
            json["data"].map((x) => AffiliateTipsData.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
      };
}

class AffiliateTipsData {
  String icon;
  String title;
  String description;

  AffiliateTipsData({
    required this.icon,
    required this.title,
    required this.description,
  });

  factory AffiliateTipsData.fromJson(Map<String, dynamic> json) =>
      AffiliateTipsData(
        icon: json["icon"],
        title: json["title"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "icon": icon,
        "title": title,
        "description": description,
      };
}
