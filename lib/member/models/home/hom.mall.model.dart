// To parse this JSON data, do
//
//     final homeMalls = homeMallsFromJson(jsonString);

import 'dart:convert';

HomeMalls homeMallsFromJson(String str) => HomeMalls.fromJson(json.decode(str));

String homeMallsToJson(HomeMalls data) => json.encode(data.toJson());

class HomeMalls {
  String code;
  List<Datum> data;
  String message;

  HomeMalls({
    required this.code,
    required this.data,
    required this.message,
  });

  factory HomeMalls.fromJson(Map<String, dynamic> json) => HomeMalls(
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
  String contentHeader;
  String image;
  String imageDesktop;

  Datum({
    required this.contentId,
    required this.sectionId,
    required this.viewType,
    required this.contentHeader,
    required this.image,
    required this.imageDesktop,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        contentId: json["content_id"],
        sectionId: json["section_id"] ?? 0,
        viewType: json["view_type"] ?? 0,
        contentHeader: json["content_header"],
        image: json["image"],
        imageDesktop: json["image_desktop"],
      );

  Map<String, dynamic> toJson() => {
        "content_id": contentId,
        "section_id": sectionId,
        "view_type": viewType,
        "content_header": contentHeader,
        "image": image,
        "image_desktop": imageDesktop,
      };
}
