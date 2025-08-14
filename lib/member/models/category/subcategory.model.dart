// To parse this JSON data, do
//
//     final subCategorie = subCategorieFromJson(jsonString);

import 'dart:convert';

SubCategorie subCategorieFromJson(String str) =>
    SubCategorie.fromJson(json.decode(str));

String subCategorieToJson(SubCategorie data) => json.encode(data.toJson());

class SubCategorie {
  String code;
  Data data;
  String message;

  SubCategorie({
    required this.code,
    required this.data,
    required this.message,
  });

  factory SubCategorie.fromJson(Map<String, dynamic> json) => SubCategorie(
        code: json["code"],
        data: Data.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "data": data.toJson(),
        "message": message,
      };
}

class Data {
  int catid;
  String catname;
  List<SubCategory> subCategories;

  Data({
    required this.catid,
    required this.catname,
    required this.subCategories,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
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
