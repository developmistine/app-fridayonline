// To parse this JSON data, do
//
//     final fairBanner = fairBannerFromJson(jsonString);

import 'dart:convert';

FairBanner fairBannerFromJson(String str) =>
    FairBanner.fromJson(json.decode(str));

String fairBannerToJson(FairBanner data) => json.encode(data.toJson());

class FairBanner {
  String code;
  List<Datum> data;
  String message;

  FairBanner({
    required this.code,
    required this.data,
    required this.message,
  });

  factory FairBanner.fromJson(Map<String, dynamic> json) => FairBanner(
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
  int actionType;
  String actionValue;
  String contentName;
  String startDate;
  String endDate;
  String image;
  String imageDesktop;

  Datum({
    required this.contentId,
    required this.actionType,
    required this.actionValue,
    required this.contentName,
    required this.startDate,
    required this.endDate,
    required this.image,
    required this.imageDesktop,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        contentId: json["content_id"],
        actionType: json["action_type"],
        actionValue: json["action_value"],
        contentName: json["content_name"],
        startDate: json["start_date"],
        endDate: json["end_date"],
        image: json["image"],
        imageDesktop: json["image_desktop"],
      );

  Map<String, dynamic> toJson() => {
        "content_id": contentId,
        "action_type": actionType,
        "action_value": actionValue,
        "content_name": contentName,
        "start_date": startDate,
        "end_date": endDate,
        "image": image,
        "image_desktop": imageDesktop,
      };
}
