// To parse this JSON data, do
//
//     final shopCategory = shopCategoryFromJson(jsonString);

import 'dart:convert';

ShopCategory shopCategoryFromJson(String str) =>
    ShopCategory.fromJson(json.decode(str));

String shopCategoryToJson(ShopCategory data) => json.encode(data.toJson());

class ShopCategory {
  String code;
  List<Datum> data;
  String message;

  ShopCategory({
    required this.code,
    required this.data,
    required this.message,
  });

  factory ShopCategory.fromJson(Map<String, dynamic> json) => ShopCategory(
        code: json["code"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
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
  String catname;
  List<SubCategory> subCategories;

  Datum({
    required this.catid,
    required this.catname,
    required this.subCategories,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        catid: json["catid"],
        catname: json["catname"],
        subCategories: List<SubCategory>.from(
            json["sub_categories"].map((x) => SubCategory.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "catid": catid,
        "catname": catname,
        "sub_categories":
            List<dynamic>.from(subCategories.map((x) => x.toJson())),
      };
}

class SubCategory {
  int subcatId;
  String name;
  String displayName;
  String image;
  List<TypeSubcat> typeSubcat;

  SubCategory({
    required this.subcatId,
    required this.name,
    required this.displayName,
    required this.image,
    required this.typeSubcat,
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) => SubCategory(
        subcatId: json["subcat_id"],
        name: json["name"],
        displayName: json["display_name"],
        image: json["image"],
        typeSubcat: List<TypeSubcat>.from(
            json["type_subcat"].map((x) => TypeSubcat.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "subcat_id": subcatId,
        "name": name,
        "display_name": displayName,
        "image": image,
        "type_subcat": List<dynamic>.from(typeSubcat.map((x) => x.toJson())),
      };
}

class TypeSubcat {
  int prodlineId;
  String prodlineCode;
  String name;
  String displayName;

  TypeSubcat({
    required this.prodlineId,
    required this.prodlineCode,
    required this.name,
    required this.displayName,
  });

  factory TypeSubcat.fromJson(Map<String, dynamic> json) => TypeSubcat(
        prodlineId: json["prodline_id"],
        prodlineCode: json["prodline_code"],
        name: json["name"],
        displayName: json["display_name"],
      );

  Map<String, dynamic> toJson() => {
        "prodline_id": prodlineId,
        "prodline_code": prodlineCode,
        "name": name,
        "display_name": displayName,
      };
}
