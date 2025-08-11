// To parse this JSON data, do
//
//     final saveImageAndriond = saveImageAndriondFromJson(jsonString);

// // import 'package:meta/meta.dart';
import 'dart:convert';

SaveImageAndriond saveImageAndriondFromJson(String str) =>
    SaveImageAndriond.fromJson(json.decode(str));

String saveImageAndriondToJson(SaveImageAndriond data) =>
    json.encode(data.toJson());

class SaveImageAndriond {
  SaveImageAndriond({
    required this.filePath,
    required this.errorMessage,
    required this.isSuccess,
  });

  String filePath;
  dynamic errorMessage;
  bool isSuccess;

  factory SaveImageAndriond.fromJson(Map<String, dynamic> json) =>
      SaveImageAndriond(
        filePath: json["filePath"],
        errorMessage: json["errorMessage"],
        isSuccess: json["isSuccess"],
      );

  Map<String, dynamic> toJson() => {
        "filePath": filePath,
        "errorMessage": errorMessage,
        "isSuccess": isSuccess,
      };
}
