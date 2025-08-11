// To parse this JSON data, do
//
//     final notifyGroup = notifyGroupFromJson(jsonString);

import 'dart:convert';

NotifyGroup notifyGroupFromJson(String str) =>
    NotifyGroup.fromJson(json.decode(str));

String notifyGroupToJson(NotifyGroup data) => json.encode(data.toJson());

class NotifyGroup {
  String code;
  List<Datum> data;
  String message;

  NotifyGroup({
    required this.code,
    required this.data,
    required this.message,
  });

  factory NotifyGroup.fromJson(Map<String, dynamic> json) => NotifyGroup(
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
  int groupId;
  String title;
  String subTitle;
  String image;
  int totalNotifications;

  Datum({
    required this.groupId,
    required this.title,
    required this.subTitle,
    required this.image,
    required this.totalNotifications,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        groupId: json["group_id"],
        title: json["title"],
        subTitle: json["sub_title"],
        image: json["image"],
        totalNotifications: json["total_notifications"],
      );

  Map<String, dynamic> toJson() => {
        "group_id": groupId,
        "title": title,
        "sub_title": subTitle,
        "image": image,
        "total_notifications": totalNotifications,
      };
}
