// // To parse this JSON data, do
// //
// //     final catelogDetail = catelogDetailFromJson(jsonString);

// import 'dart:convert';

// CatelogDetail catelogDetailFromJson(String str) =>
//     CatelogDetail.fromJson(json.decode(str));

// String catelogDetailToJson(CatelogDetail data) => json.encode(data.toJson());

// class CatelogDetail {
//   CatelogDetail({
//     required this.ecatalogDetail,
//   });

//   List<EcatalogDetail> ecatalogDetail;

//   factory CatelogDetail.fromJson(Map<String, dynamic> json) => CatelogDetail(
//         ecatalogDetail: List<EcatalogDetail>.from(
//             json["EcatalogDetail"].map((x) => EcatalogDetail.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "EcatalogDetail":
//             List<dynamic>.from(ecatalogDetail.map((x) => x.toJson())),
//       };
// }

// class EcatalogDetail {
//   EcatalogDetail({
//     required this.id,
//     required this.campaign,
//     required this.brand,
//     required this.media,
//     required this.pageDetail,
//     required this.pathImg,
//     required this.locationpage,
//     required this.flagStatus,
//     required this.flagViewProduct,
//     required this.countBill,
//     required this.fsCodeStatus,
//   });

//   String id;
//   String campaign;
//   String brand;
//   String media;
//   String pageDetail;
//   String pathImg;
//   String locationpage;
//   String flagStatus;
//   String flagViewProduct;
//   String countBill;
//   String fsCodeStatus;

//   factory EcatalogDetail.fromJson(Map<String, dynamic> json) => EcatalogDetail(
//         id: json["id"],
//         campaign: json["Campaign"],
//         brand: json["Brand"],
//         media: json["Media"],
//         pageDetail: json["PageDetail"],
//         pathImg: json["PathImg"],
//         locationpage: json["Locationpage"],
//         flagStatus: json["FlagStatus"],
//         flagViewProduct: json["FlagViewProduct"],
//         countBill: json["CountBill"],
//         fsCodeStatus: json["FsCodeStatus"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "Campaign": campaign,
//         "Brand": brand,
//         "Media": media,
//         "PageDetail": pageDetail,
//         "PathImg": pathImg,
//         "Locationpage": locationpage,
//         "FlagStatus": flagStatus,
//         "FlagViewProduct": flagViewProduct,
//         "CountBill": countBill,
//         "FsCodeStatus": fsCodeStatus,
//       };
// }

// To parse this JSON data, do
//
//     final catelogDetail = catelogDetailFromJson(jsonString);

// import 'package:meta/meta.dart';
import 'dart:convert';

CatelogDetail catelogDetailFromJson(String str) =>
    CatelogDetail.fromJson(json.decode(str));

String catelogDetailToJson(CatelogDetail data) => json.encode(data.toJson());

class CatelogDetail {
  CatelogDetail({
    required this.ecatalogDetail,
  });

  List<EcatalogDetail> ecatalogDetail;

  factory CatelogDetail.fromJson(Map<String, dynamic> json) => CatelogDetail(
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
    required this.id,
    required this.type,
    required this.campaign,
    required this.brand,
    required this.media,
    required this.pageDetail,
    required this.pathImg,
    required this.locationpage,
    required this.flagStatus,
    required this.isShowPageNumber,
    required this.flagViewProduct,
    required this.countBill,
    required this.fsCodeStatus,
  });

  String id;
  String type;
  String campaign;
  String brand;
  String media;
  String pageDetail;
  String pathImg;
  String locationpage;
  String flagStatus;
  bool isShowPageNumber;
  String flagViewProduct;
  String countBill;
  String fsCodeStatus;

  factory EcatalogDetail.fromJson(Map<String, dynamic> json) => EcatalogDetail(
        id: json["Id"] ?? "",
        type: json["Type"] ?? "",
        campaign: json["Campaign"] ?? "",
        brand: json["Brand"] ?? "",
        media: json["Media"] ?? "",
        pageDetail: json["PageDetail"] ?? "",
        pathImg: json["PathImg"] ?? "",
        locationpage: json["Locationpage"] ?? "",
        flagStatus: json["FlagStatus"] ?? "",
        isShowPageNumber: json["IsShowPageNumber"],
        flagViewProduct: json["FlagViewProduct"] ?? "",
        countBill: json["CountBill"] ?? "",
        fsCodeStatus: json["FsCodeStatus"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "Type": type,
        "Campaign": campaign,
        "Brand": brand,
        "Media": media,
        "PageDetail": pageDetail,
        "PathImg": pathImg,
        "Locationpage": locationpage,
        "FlagStatus": flagStatus,
        "IsShowPageNumber": isShowPageNumber,
        "FlagViewProduct": flagViewProduct,
        "CountBill": countBill,
        "FsCodeStatus": fsCodeStatus,
      };
}
