// To parse this JSON data, do
//
//     final homeCategory = homeCategoryFromJson(jsonString);

import 'dart:convert';

HomeCategory homeCategoryFromJson(String str) =>
    HomeCategory.fromJson(json.decode(str));

String homeCategoryToJson(HomeCategory data) => json.encode(data.toJson());

class HomeCategory {
  String code;
  List<Datum> data;
  String message;

  HomeCategory({
    required this.code,
    required this.data,
    required this.message,
  });

  factory HomeCategory.fromJson(Map<String, dynamic> json) => HomeCategory(
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
  int catid;
  String name;
  String displayName;
  String image;
  int level;

  Datum({
    required this.catid,
    required this.name,
    required this.displayName,
    required this.image,
    required this.level,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        catid: json["catid"],
        name: json["name"],
        displayName: json["display_name"],
        image: json["image"],
        level: json["level"],
      );

  Map<String, dynamic> toJson() => {
        "catid": catid,
        "name": name,
        "display_name": displayName,
        "image": image,
        "level": level,
      };
}
