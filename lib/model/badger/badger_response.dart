// To parse this JSON data, do
//
//     final badgerRespones = badgerResponesFromJson(jsonString);

// import 'package:meta/meta.dart';
import 'dart:convert';

BadgerRespones badgerResponesFromJson(String str) =>
    BadgerRespones.fromJson(json.decode(str));

String badgerResponesToJson(BadgerRespones data) => json.encode(data.toJson());

class BadgerRespones {
  BadgerRespones({
    required this.status,
    required this.message,
  });

  String status;
  String message;

  factory BadgerRespones.fromJson(Map<String, dynamic> json) => BadgerRespones(
        status: json["Status"] ?? "",
        message: json["Message"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "Status": status,
        "Message": message,
      };
}
