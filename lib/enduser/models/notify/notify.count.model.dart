// To parse this JSON data, do
//
//     final countNotify = countNotifyFromJson(jsonString);

import 'dart:convert';

CountNotify countNotifyFromJson(String str) =>
    CountNotify.fromJson(json.decode(str));

String countNotifyToJson(CountNotify data) => json.encode(data.toJson());

class CountNotify {
  String code;
  Data data;
  String message;

  CountNotify({
    required this.code,
    required this.data,
    required this.message,
  });

  factory CountNotify.fromJson(Map<String, dynamic> json) => CountNotify(
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
  int totalNotifications;

  Data({
    required this.totalNotifications,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        totalNotifications: json["total_notifications"],
      );

  Map<String, dynamic> toJson() => {
        "total_notifications": totalNotifications,
      };
}
