// To parse this JSON data, do
//
//     final festival = festivalFromJson(jsonString);

import 'dart:convert';

Festival festivalFromJson(String str) => Festival.fromJson(json.decode(str));

String festivalToJson(Festival data) => json.encode(data.toJson());

class Festival {
  String code;
  List<Datum> data;
  String message;

  Festival({
    required this.code,
    required this.data,
    required this.message,
  });

  factory Festival.fromJson(Map<String, dynamic> json) => Festival(
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
  String contentDesc;
  String contentImage;
  String dateTime;
  Action action;

  Datum({
    required this.contentId,
    required this.contentName,
    required this.contentDesc,
    required this.contentImage,
    required this.dateTime,
    required this.action,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        contentId: json["content_id"],
        contentName: json["content_name"],
        contentDesc: json["content_desc"],
        contentImage: json["content_image"],
        dateTime: json["date_time"],
        action: Action.fromJson(json["action"]),
      );

  Map<String, dynamic> toJson() => {
        "content_id": contentId,
        "content_name": contentName,
        "content_desc": contentDesc,
        "content_image": contentImage,
        "date_time": dateTime,
        "action": action.toJson(),
      };
}

class Action {
  int key;
  String value;

  Action({
    required this.key,
    required this.value,
  });

  factory Action.fromJson(Map<String, dynamic> json) => Action(
        key: json["key"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "value": value,
      };
}
