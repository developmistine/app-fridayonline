// To parse this JSON data, do
//
//     final badgerNotification = badgerNotificationFromJson(jsonString);

// import 'package:meta/meta.dart';
import 'dart:convert';

BadgerNotification badgerNotificationFromJson(String str) =>
    BadgerNotification.fromJson(json.decode(str));

String badgerNotificationToJson(BadgerNotification data) =>
    json.encode(data.toJson());

class BadgerNotification {
  BadgerNotification({
    required this.countBadgerPushNotify,
  });

  List<CountBadgerPushNotify> countBadgerPushNotify;

  factory BadgerNotification.fromJson(Map<String, dynamic> json) =>
      BadgerNotification(
        countBadgerPushNotify: json["CountBadgerPushNotify"] == null
            ? []
            : List<CountBadgerPushNotify>.from(json["CountBadgerPushNotify"]
                .map((x) => CountBadgerPushNotify.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "CountBadgerPushNotify":
            List<dynamic>.from(countBadgerPushNotify.map((x) => x.toJson())),
      };
}

class CountBadgerPushNotify {
  CountBadgerPushNotify({
    required this.status,
    required this.message,
    required this.countBadger,
  });

  String status;
  String message;
  String countBadger;

  factory CountBadgerPushNotify.fromJson(Map<String, dynamic> json) =>
      CountBadgerPushNotify(
        status: json["Status"] ?? "",
        message: json["Message"] ?? "",
        countBadger: json["CountBadger"] ?? "0",
      );

  Map<String, dynamic> toJson() => {
        "Status": status,
        "Message": message,
        "CountBadger": countBadger,
      };
}
