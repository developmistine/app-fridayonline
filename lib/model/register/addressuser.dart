// To parse this JSON data, do
//
//     final addressuser = addressuserFromJson(jsonString);
// import 'package:meta/meta.dart';
import 'dart:convert';

Addressuser addressuserFromJson(String str) =>
    Addressuser.fromJson(json.decode(str));
String addressuserToJson(Addressuser data) => json.encode(data.toJson());

class Addressuser {
  Addressuser({
    required this.data,
  });

  List<Datum> data;

  factory Addressuser.fromJson(Map<String, dynamic> json) => Addressuser(
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    required this.province,
    required this.provinceCode,
    required this.item,
  });
  String province;
  String provinceCode;
  List<Item> item;
  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        province: json["province"] ?? "",
        provinceCode: json["province_code"] ?? "",
        item: json["item"] == null
            ? []
            : List<Item>.from(json["item"].map((x) => Item.fromJson(x))),
      );
  Map<String, dynamic> toJson() => {
        "province": province,
        "province_code": provinceCode,
        "item": List<dynamic>.from(item.map((x) => x.toJson())),
      };
}

class Item {
  Item({
    required this.amphur,
    required this.amphurCode,
    required this.tumbon,
  });

  String amphur;
  String amphurCode;
  List<List<String>> tumbon;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        amphur: json["amphur"] ?? "",
        amphurCode: json["amphur_code"] ?? "",
        tumbon: json["tumbon"] == null
            ? [[]]
            : List<List<String>>.from(
                json["tumbon"].map((x) => List<String>.from(x.map((x) => x)))),
      );

  Map<String, dynamic> toJson() => {
        "amphur": amphur,
        "amphur_code": amphurCode,
        "tumbon": List<dynamic>.from(
            tumbon.map((x) => List<dynamic>.from(x.map((x) => x)))),
      };
}
