// To parse this JSON data, do
//
//     final option = optionFromJson(jsonString);

import 'dart:convert';

Option optionFromJson(String str) => Option.fromJson(json.decode(str));

String optionToJson(Option data) => json.encode(data.toJson());

class Option {
  String code;
  List<Datum> data;
  String message;

  Option({
    required this.code,
    required this.data,
    required this.message,
  });

  factory Option.fromJson(Map<String, dynamic> json) => Option(
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
