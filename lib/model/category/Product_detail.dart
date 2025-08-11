// To parse this JSON data, do
//
//     final productDetail = productDetailFromJson(jsonString);

// import 'package:meta/meta.dart';
import 'dart:convert';

ProductDetail productDetailFromJson(String str) =>
    ProductDetail.fromJson(json.decode(str));

String productDetailToJson(ProductDetail data) => json.encode(data.toJson());

class ProductDetail {
  ProductDetail({
    required this.repCode,
    required this.repSeq,
    required this.repType,
    required this.imageProductDetail,
    required this.descriptionProduct,
  });

  String repCode;
  String repSeq;
  String repType;
  List<ImageProductDetail> imageProductDetail;
  List<DescriptionProduct> descriptionProduct;

  factory ProductDetail.fromJson(Map<String, dynamic> json) => ProductDetail(
        repCode: json["RepCode"] ?? "",
        repSeq: json["RepSeq"] ?? "",
        repType: json["RepType"] ?? "",
        imageProductDetail: json["ImageProductDetail"] == null
            ? []
            : List<ImageProductDetail>.from(json["ImageProductDetail"]
                .map((x) => ImageProductDetail.fromJson(x))),
        descriptionProduct: json["DescriptionProduct"] == null
            ? []
            : List<DescriptionProduct>.from(json["DescriptionProduct"]
                .map((x) => DescriptionProduct.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "RepCode": repCode,
        "RepSeq": repSeq,
        "RepType": repType,
        "ImageProductDetail":
            List<dynamic>.from(imageProductDetail.map((x) => x.toJson())),
        "DescriptionProduct":
            List<dynamic>.from(descriptionProduct.map((x) => x.toJson())),
      };
}

class DescriptionProduct {
  DescriptionProduct({
    required this.mediaCode,
    required this.billcode,
    required this.billColor,
    required this.fsCode,
    required this.fsCodetemp,
    required this.fsName,
    required this.skuName,
    required this.specialPrice,
    required this.description,
    required this.shortDescription,
    required this.pathUrl,
    required this.img,
    required this.campaign,
    required this.brand,
    required this.isInStock,
    required this.limitDescription,
    required this.skukhmerlanguage,
    required this.skuburmeselanguage,
    required this.descriptionkhmerlanguage,
    required this.shortdescriptionkhmerlanguage,
    required this.descriptionburmeselanguage,
    required this.shortdescriptionburmeselanguage,
  });

  String mediaCode;
  String billcode;
  String billColor;
  String fsCode;
  String fsCodetemp;
  String fsName;
  String skuName;
  String specialPrice;
  String description;
  String shortDescription;
  String pathUrl;
  String img;
  String campaign;
  String brand;
  bool isInStock;
  String limitDescription;
  dynamic skukhmerlanguage;
  dynamic skuburmeselanguage;
  dynamic descriptionkhmerlanguage;
  dynamic shortdescriptionkhmerlanguage;
  dynamic descriptionburmeselanguage;
  dynamic shortdescriptionburmeselanguage;

  factory DescriptionProduct.fromJson(Map<String, dynamic> json) =>
      DescriptionProduct(
        mediaCode: json["MediaCode"] ?? "",
        billcode: json["billcode"] ?? "",
        billColor: json["BillColor"] ?? "",
        fsCode: json["FsCode"] ?? "",
        fsCodetemp: json["FS_CODETEMP"] ?? "",
        fsName: json["FsName"] ?? "",
        skuName: json["skuName"] ?? "",
        specialPrice: json["special_price"] ?? "",
        description: json["Description"] ?? "",
        shortDescription: json["shortDescription"] ?? "",
        pathUrl: json["pathUrl"] ?? "",
        img: json["img"] ?? "",
        campaign: json["Campaign"] ?? "",
        brand: json["brand"] ?? "",
        isInStock: json["is_in_stock"],
        limitDescription: json["LimitDescription"] ?? "",
        skukhmerlanguage: json["skukhmerlanguage"],
        skuburmeselanguage: json["skuburmeselanguage"],
        descriptionkhmerlanguage: json["descriptionkhmerlanguage"],
        shortdescriptionkhmerlanguage: json["shortdescriptionkhmerlanguage"],
        descriptionburmeselanguage: json["descriptionburmeselanguage"],
        shortdescriptionburmeselanguage:
            json["shortdescriptionburmeselanguage"],
      );

  Map<String, dynamic> toJson() => {
        "MediaCode": mediaCode,
        "billcode": billcode,
        "BillColor": billColor,
        "FsCode": fsCode,
        "FS_CODETEMP": fsCodetemp,
        "FsName": fsName,
        "skuName": skuName,
        "special_price": specialPrice,
        "Description": description,
        "shortDescription": shortDescription,
        "pathUrl": pathUrl,
        "img": img,
        "Campaign": campaign,
        "brand": brand,
        "is_in_stock": isInStock,
        "LimitDescription": limitDescription,
        "skukhmerlanguage": skukhmerlanguage,
        "skuburmeselanguage": skuburmeselanguage,
        "descriptionkhmerlanguage": descriptionkhmerlanguage,
        "shortdescriptionkhmerlanguage": shortdescriptionkhmerlanguage,
        "descriptionburmeselanguage": descriptionburmeselanguage,
        "shortdescriptionburmeselanguage": shortdescriptionburmeselanguage,
      };
}

class ImageProductDetail {
  ImageProductDetail({
    required this.listShowImg,
    required this.pathImg,
  });

  String listShowImg;
  String pathImg;

  factory ImageProductDetail.fromJson(Map<String, dynamic> json) =>
      ImageProductDetail(
        listShowImg: json["ListShowImg"] ?? "",
        pathImg: json["PathImg"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "ListShowImg": listShowImg,
        "PathImg": pathImg,
      };
}
