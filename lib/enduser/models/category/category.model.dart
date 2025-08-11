// To parse this JSON data, do
//
//     final productCategory = productCategoryFromJson(jsonString);

import 'dart:convert';

ProductCategory productCategoryFromJson(String str) =>
    ProductCategory.fromJson(json.decode(str));

String productCategoryToJson(ProductCategory data) =>
    json.encode(data.toJson());

class ProductCategory {
  String code;
  List<Datum> data;
  String message;

  ProductCategory({
    required this.code,
    required this.data,
    required this.message,
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) =>
      ProductCategory(
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
  int categoryId;
  String category;
  List<CategoryDetail> categoryDetail;

  Datum({
    required this.categoryId,
    required this.category,
    required this.categoryDetail,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        categoryId: json["category_id"],
        category: json["category"],
        categoryDetail: List<CategoryDetail>.from(
            json["category_detail"].map((x) => CategoryDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "category_id": categoryId,
        "category": category,
        "category_detail":
            List<dynamic>.from(categoryDetail.map((x) => x.toJson())),
      };
}

class CategoryDetail {
  int subcategoryId;
  String subcategory;
  String subcategoryImg;

  CategoryDetail({
    required this.subcategoryId,
    required this.subcategory,
    required this.subcategoryImg,
  });

  factory CategoryDetail.fromJson(Map<String, dynamic> json) => CategoryDetail(
        subcategoryId: json["subcategory_id"],
        subcategory: json["subcategory"],
        subcategoryImg: json["subcategory_img"],
      );

  Map<String, dynamic> toJson() => {
        "subcategory_id": subcategoryId,
        "subcategory": subcategory,
        "subcategory_img": subcategoryImg,
      };
}
