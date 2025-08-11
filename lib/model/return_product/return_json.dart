// To parse this JSON data, do
//
//     final returnDetailJson = returnDetailJsonFromJson(jsonString);

import 'dart:convert';

import 'package:flutter_image_compress/flutter_image_compress.dart';

List<ReturnDetailJson> returnDetailJsonFromJson(String str) =>
    List<ReturnDetailJson>.from(
        json.decode(str).map((x) => ReturnDetailJson.fromJson(x)));

String returnDetailJsonToJson(List<ReturnDetailJson> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ReturnDetailJson {
  String id;
  List<ImgageProduct> imgageProduct;

  ReturnDetailJson({
    required this.id,
    required this.imgageProduct,
  });

  factory ReturnDetailJson.fromJson(Map<String, dynamic> json) =>
      ReturnDetailJson(
        id: json["id"],
        imgageProduct: List<ImgageProduct>.from(
            json["imgageProduct"].map((x) => ImgageProduct.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "imgageProduct":
            List<dynamic>.from(imgageProduct.map((x) => x.toJson())),
      };
}

class ImgageProduct {
  List<XFile> ifile;
  String reason;

  ImgageProduct({
    required this.ifile,
    required this.reason,
  });

  factory ImgageProduct.fromJson(Map<String, dynamic> json) => ImgageProduct(
        ifile: json["file"],
        reason: json["reason"],
      );

  Map<String, dynamic> toJson() => {
        "file": ifile,
        "reason": reason,
      };
}
