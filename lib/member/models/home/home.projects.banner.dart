// To parse this JSON data, do
//
//     final homeProjectsBanner = homeProjectsBannerFromJson(jsonString);

import 'dart:convert';

HomeProjectsBanner homeProjectsBannerFromJson(String str) =>
    HomeProjectsBanner.fromJson(json.decode(str));

String homeProjectsBannerToJson(HomeProjectsBanner data) =>
    json.encode(data.toJson());

class HomeProjectsBanner {
  String code;
  List<Datum> data;
  String message;

  HomeProjectsBanner({
    required this.code,
    required this.data,
    required this.message,
  });

  factory HomeProjectsBanner.fromJson(Map<String, dynamic> json) =>
      HomeProjectsBanner(
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
  String contentName;
  int pgmId;
  int actionType;
  String actionValue;
  String image;
  String imageDesktop;

  Datum({
    required this.contentId,
    required this.contentName,
    required this.pgmId,
    required this.actionType,
    required this.actionValue,
    required this.image,
    required this.imageDesktop,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        contentId: json["content_id"],
        contentName: json["content_name"],
        pgmId: json["pgm_id"],
        actionType: json["action_type"],
        actionValue: json["action_value"],
        image: json["image"],
        imageDesktop: json["image_desktop"],
      );

  Map<String, dynamic> toJson() => {
        "content_id": contentId,
        "content_name": contentName,
        "pgm_id": pgmId,
        "action_type": actionType,
        "action_value": actionValue,
        "image": image,
        "image_desktop": imageDesktop,
      };
}
