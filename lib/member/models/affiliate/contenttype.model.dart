// To parse this JSON data, do
//
//     final contentType = contentTypeFromJson(jsonString);

import 'dart:convert';

ContentType contentTypeFromJson(String str) =>
    ContentType.fromJson(json.decode(str));

String contentTypeToJson(ContentType data) => json.encode(data.toJson());

class ContentType {
  String code;
  List<Datum> data;
  String message;

  ContentType({
    required this.code,
    required this.data,
    required this.message,
  });

  factory ContentType.fromJson(Map<String, dynamic> json) => ContentType(
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
  int id;
  String name;
  String label;

  Datum({
    required this.id,
    required this.name,
    required this.label,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        label: json["label"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "label": label,
      };
}
