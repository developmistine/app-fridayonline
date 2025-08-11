// To parse this JSON data, do
//
//     final topSalesWeekly = topSalesWeeklyFromJson(jsonString);

import 'dart:convert';

TopSalesWeekly topSalesWeeklyFromJson(String str) =>
    TopSalesWeekly.fromJson(json.decode(str));

String topSalesWeeklyToJson(TopSalesWeekly data) => json.encode(data.toJson());

class TopSalesWeekly {
  String code;
  List<Datum> data;
  String message;

  TopSalesWeekly({
    required this.code,
    required this.data,
    required this.message,
  });

  factory TopSalesWeekly.fromJson(Map<String, dynamic> json) => TopSalesWeekly(
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
  int subcatId;
  int prodlineId;
  String name;
  String displayName;
  String image;
  String selling;

  Datum({
    required this.subcatId,
    required this.prodlineId,
    required this.name,
    required this.displayName,
    required this.image,
    required this.selling,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        subcatId: json["subcat_id"],
        prodlineId: json["prodline_id"],
        name: json["name"],
        displayName: json["display_name"],
        image: json["image"],
        selling: json["selling"],
      );

  Map<String, dynamic> toJson() => {
        "subcat_id": subcatId,
        "prodline_id": prodlineId,
        "name": name,
        "display_name": displayName,
        "image": image,
        "selling": selling,
      };
}
