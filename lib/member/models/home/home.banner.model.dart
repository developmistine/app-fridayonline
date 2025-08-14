// To parse this JSON data, do
//
//     final homeBanner = homeBannerFromJson(jsonString);

import 'dart:convert';

HomeBanner homeBannerFromJson(String str) =>
    HomeBanner.fromJson(json.decode(str));

String homeBannerToJson(HomeBanner data) => json.encode(data.toJson());

class HomeBanner {
  String code;
  List<Datum> data;
  String message;

  HomeBanner({
    required this.code,
    required this.data,
    required this.message,
  });

  factory HomeBanner.fromJson(Map<String, dynamic> json) => HomeBanner(
        code: json["code"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
      };
}

class Datum {
  int contentId;
  int? sectionId;
  int? viewType;
  int actionType;
  String actionValue;
  String contentName;
  String startDate;
  String endDate;
  String image;

  Datum({
    required this.contentId,
    required this.sectionId,
    required this.viewType,
    required this.actionType,
    required this.actionValue,
    required this.contentName,
    required this.startDate,
    required this.endDate,
    required this.image,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        contentId: json["content_id"],
        sectionId: json["section_id"] ?? 0,
        viewType: json["view_type"] ?? 0,
        actionType: json["action_type"],
        actionValue: json["action_value"],
        contentName: json["content_name"],
        startDate: json["start_date"],
        endDate: json["end_date"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "content_id": contentId,
        "section_id": sectionId,
        "view_type": viewType,
        "action_type": actionType,
        "action_value": actionValue,
        "content_name": contentName,
        "start_date": startDate,
        "end_date": endDate,
        "image": image,
      };
}
