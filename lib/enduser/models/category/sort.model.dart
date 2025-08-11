// To parse this JSON data, do
//
//     final sort = sortFromJson(jsonString);

import 'dart:convert';

Sort sortFromJson(String str) => Sort.fromJson(json.decode(str));

String sortToJson(Sort data) => json.encode(data.toJson());

class Sort {
  String code;
  List<Datum> data;
  String message;

  Sort({
    required this.code,
    required this.data,
    required this.message,
  });

  factory Sort.fromJson(Map<String, dynamic> json) => Sort(
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
  String sortBy;
  String text;
  List<SubLevel> subLevels;

  Datum({
    required this.sortBy,
    required this.text,
    required this.subLevels,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        sortBy: json["sort_by"],
        text: json["text"],
        subLevels: List<SubLevel>.from(
            json["sub_levels"].map((x) => SubLevel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "sort_by": sortBy,
        "text": text,
        "sub_levels": List<dynamic>.from(subLevels.map((x) => x.toJson())),
      };
}

class SubLevel {
  String order;
  String text;

  SubLevel({
    required this.order,
    required this.text,
  });

  factory SubLevel.fromJson(Map<String, dynamic> json) => SubLevel(
        order: json["order"],
        text: json["text"],
      );

  Map<String, dynamic> toJson() => {
        "order": order,
        "text": text,
      };
}
