// // To parse this JSON data, do
// //
// //     final catelogEcatalogDetail = catelogEcatalogDetailFromJson(jsonString);

// import 'dart:convert';

// CatelogEcatalogDetail catelogEcatalogDetailFromJson(String str) => CatelogEcatalogDetail.fromJson(json.decode(str));

// String catelogEcatalogDetailToJson(CatelogEcatalogDetail data) => json.encode(data.toJson());

// class CatelogEcatalogDetail {
//     CatelogEcatalogDetail({
//         required this.ecatalogDetail,
//     });

//     List<EcatalogDetail> ecatalogDetail;

//     factory CatelogEcatalogDetail.fromJson(Map<String, dynamic> json) => CatelogEcatalogDetail(
//         ecatalogDetail: List<EcatalogDetail>.from(json["EcatalogDetail"].map((x) => EcatalogDetail.fromJson(x))),
//     );

//     Map<String, dynamic> toJson() => {
//         "EcatalogDetail": List<dynamic>.from(ecatalogDetail.map((x) => x.toJson())),
//     };
// }

// class EcatalogDetail {
//     EcatalogDetail({
//         required this.catalogListShow,
//         required this.catalogImage,
//         required this.catalogBrand,
//         required this.catalogMedia,
//         required this.catalogName,
//         required this.catalogCampaign,
//     });

//     String catalogListShow;
//     String catalogImage;
//     String catalogBrand;
//     String catalogMedia;
//     String catalogName;
//     String catalogCampaign;

//     factory EcatalogDetail.fromJson(Map<String, dynamic> json) => EcatalogDetail(
//         catalogListShow: json["CatalogListShow"],
//         catalogImage: json["CatalogImage"],
//         catalogBrand: json["CatalogBrand"],
//         catalogMedia: json["CatalogMedia"],
//         catalogName: json["CatalogName"],
//         catalogCampaign: json["CatalogCampaign"],
//     );

//     Map<String, dynamic> toJson() => {
//         "CatalogListShow": catalogListShow,
//         "CatalogImage": catalogImage,
//         "CatalogBrand": catalogBrand,
//         "CatalogMedia": catalogMedia,
//         "CatalogName": catalogName,
//         "CatalogCampaign": catalogCampaign,
//     };
// }

// To parse this JSON data, do
//
//     final catelogEcatalogDetail = catelogEcatalogDetailFromJson(jsonString);

// import 'package:meta/meta.dart';
import 'dart:convert';

CatelogEcatalogDetail catelogEcatalogDetailFromJson(String str) =>
    CatelogEcatalogDetail.fromJson(json.decode(str));

String catelogEcatalogDetailToJson(CatelogEcatalogDetail data) =>
    json.encode(data.toJson());

class CatelogEcatalogDetail {
  CatelogEcatalogDetail({
    required this.ecatalogDetail,
  });

  List<EcatalogDetail> ecatalogDetail;

  factory CatelogEcatalogDetail.fromJson(Map<String, dynamic> json) =>
      CatelogEcatalogDetail(
        ecatalogDetail: json["EcatalogDetail"] == null
            ? []
            : List<EcatalogDetail>.from(
                json["EcatalogDetail"].map((x) => EcatalogDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "EcatalogDetail":
            List<dynamic>.from(ecatalogDetail.map((x) => x.toJson())),
      };
}

class EcatalogDetail {
  EcatalogDetail({
    required this.catalogId,
    required this.catalogListShow,
    required this.catalogImage,
    required this.catalogBrand,
    required this.catalogMedia,
    required this.catalogName,
    required this.catalogCampaign,
  });

  String catalogId;
  String catalogListShow;
  String catalogImage;
  String catalogBrand;
  String catalogMedia;
  String catalogName;
  String catalogCampaign;

  factory EcatalogDetail.fromJson(Map<String, dynamic> json) => EcatalogDetail(
        catalogListShow: json["CatalogListShow"] ?? "",
        catalogId: json["CatalogID"] ?? "",
        catalogImage: json["CatalogImage"] ?? "",
        catalogBrand: json["CatalogBrand"] ?? "",
        catalogMedia: json["CatalogMedia"] ?? "",
        catalogName: json["CatalogName"] ?? "",
        catalogCampaign: json["CatalogCampaign"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "CatalogID": catalogId,
        "CatalogListShow": catalogListShow,
        "CatalogImage": catalogImage,
        "CatalogBrand": catalogBrand,
        "CatalogMedia": catalogMedia,
        "CatalogName": catalogName,
        "CatalogCampaign": catalogCampaign,
      };
}
