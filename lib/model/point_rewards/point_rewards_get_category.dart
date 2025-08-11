// To parse this JSON data, do
//
//     final pointcategory = pointcategoryFromJson(jsonString);

import 'dart:convert';

Pointcategory pointcategoryFromJson(String str) =>
    Pointcategory.fromJson(json.decode(str));

String pointcategoryToJson(Pointcategory data) => json.encode(data.toJson());

class Pointcategory {
  Pointcategory({
    required this.id,
    required this.name,
    required this.childrenData,
  });

  String id;
  String name;
  List<PointcategoryChildrenDatum> childrenData;

  factory Pointcategory.fromJson(Map<String, dynamic> json) => Pointcategory(
        id: json["id"] ?? "",
        name: json["name"] ?? "",
        childrenData: json["children_data"] == null ? [] : List<PointcategoryChildrenDatum>.from(
            json["children_data"]
                .map((x) => PointcategoryChildrenDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "children_data":
            List<dynamic>.from(childrenData.map((x) => x.toJson())),
      };
}

class PointcategoryChildrenDatum {
  PointcategoryChildrenDatum({
    required this.nameTh,
    required this.cateBsm1,
    required this.isStatus,
    required this.ownerChanel,
    required this.shortNameTh,
    required this.categoryCode,
    required this.categoryGroup,
    required this.categoryLevel,
    required this.categoryParent,
    required this.childrenData,
  });

  String nameTh;
  String cateBsm1;
  String isStatus;
  String ownerChanel;
  String shortNameTh;
  String categoryCode;
  String categoryGroup;
  String categoryLevel;
  String categoryParent;
  List<ChildrenDatumChildrenDatum> childrenData;

  factory PointcategoryChildrenDatum.fromJson(Map<String, dynamic> json) =>
      PointcategoryChildrenDatum(
        nameTh: json["NameTh"] ?? "",
        cateBsm1: json["CateBSM1"] ?? "",
        isStatus: json["IsStatus"] ?? "",
        ownerChanel: json["OwnerChanel"] ?? "",
        shortNameTh: json["ShortNameTh"] ?? "",
        categoryCode: json["CategoryCode"] ?? "",
        categoryGroup: json["CategoryGroup"] ?? "",
        categoryLevel: json["CategoryLevel"] ?? "",
        categoryParent: json["CategoryParent"] ?? "",
        childrenData: json["children_data"] == null ? [] : List<ChildrenDatumChildrenDatum>.from(
            json["children_data"]
                .map((x) => ChildrenDatumChildrenDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "NameTh": nameTh,
        "CateBSM1": cateBsm1,
        "IsStatus": isStatus,
        "OwnerChanel": ownerChanel,
        "ShortNameTh": shortNameTh,
        "CategoryCode": categoryCode,
        "CategoryGroup": categoryGroup,
        "CategoryLevel": categoryLevel,
        "CategoryParent": categoryParent,
        "children_data":
            List<dynamic>.from(childrenData.map((x) => x.toJson())),
      };
}

class ChildrenDatumChildrenDatum {
  ChildrenDatumChildrenDatum({
    required this.categoryId,
    required this.ownerChanel,
    required this.categoryCode,
    required this.nameTh,
    required this.cateBsm1,
    required this.cateBsm2,
    required this.cateBsm3,
    required this.shortNameTh,
    required this.categoryParent,
    required this.categoryLevel,
    required this.categoryGroup,
    required this.isStatus,
    required this.searchCategory,
    required this.startPoint,
    required this.endPoint,
    required this.imageUrl,
  });

  String categoryId;
  String ownerChanel;
  String categoryCode;
  String nameTh;
  String cateBsm1;
  String cateBsm2;
  String cateBsm3;
  String shortNameTh;
  String categoryParent;
  String categoryLevel;
  String categoryGroup;
  String isStatus;
  String searchCategory;
  String startPoint;
  String endPoint;
  String imageUrl;

  factory ChildrenDatumChildrenDatum.fromJson(Map<String, dynamic> json) =>
      ChildrenDatumChildrenDatum(
        categoryId: json["CategoryId"] ?? "",
        ownerChanel: json["OwnerChanel"] ?? "",
        categoryCode: json["CategoryCode"] ?? "",
        nameTh: json["NameTh"] ?? "",
        cateBsm1: json["CateBSM1"] ?? "",
        cateBsm2: json["CateBSM2"] ?? "",
        cateBsm3: json["CateBSM3"] ?? "",
        shortNameTh: json["ShortNameTh"] ?? "",
        categoryParent: json["CategoryParent"] ?? "",
        categoryLevel: json["CategoryLevel"] ?? "",
        categoryGroup: json["CategoryGroup"] ?? "",
        isStatus: json["IsStatus"] ?? "",
        searchCategory: json["SearchCategory"] ?? "",
        startPoint: json["StartPoint"] ?? "",
        endPoint: json["EndPoint"] ?? "",
        imageUrl: json["ImageUrl"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "CategoryId": categoryId,
        "OwnerChanel": ownerChanel,
        "CategoryCode": categoryCode,
        "NameTh": nameTh,
        "CateBSM1": cateBsm1,
        "CateBSM2": cateBsm2,
        "CateBSM3": cateBsm3,
        "ShortNameTh": shortNameTh,
        "CategoryParent": categoryParent,
        "CategoryLevel": categoryLevel,
        "CategoryGroup": categoryGroup,
        "IsStatus": isStatus,
        "SearchCategory": searchCategory,
        "StartPoint": startPoint,
        "EndPoint": endPoint,
        "ImageUrl": imageUrl,
      };
}