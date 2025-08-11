// To parse this JSON data, do
//
//     final endUserPopup = endUserPopupFromJson(jsonString);

import 'dart:convert';

EndUserPopup endUserPopupFromJson(String str) =>
    EndUserPopup.fromJson(json.decode(str));

String endUserPopupToJson(EndUserPopup data) => json.encode(data.toJson());

class EndUserPopup {
  String code;
  List<Datum> data;
  String message;

  EndUserPopup({
    required this.code,
    required this.data,
    required this.message,
  });

  factory EndUserPopup.fromJson(Map<String, dynamic> json) => EndUserPopup(
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
  String contentName;
  int actionType;
  String actionValue;
  String image;

  Datum({
    required this.contentId,
    required this.sectionId,
    required this.viewType,
    required this.contentName,
    required this.actionType,
    required this.actionValue,
    required this.image,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        contentId: json["content_id"],
        sectionId: json["section_id"] ?? 0,
        viewType: json["view_type"] ?? 0,
        contentName: json["content_name"],
        actionType: json["action_type"],
        actionValue: json["action_value"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "content_id": contentId,
        "section_id": sectionId,
        "view_type": viewType,
        "content_name": contentName,
        "action_type": actionType,
        "action_value": actionValue,
        "image": image,
      };
}
