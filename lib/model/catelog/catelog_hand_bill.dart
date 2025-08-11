// // To parse this JSON data, do
// //
// //     final catelogHandBillDetail = catelogHandBillDetailFromJson(jsonString);

// import 'dart:convert';

// CatelogHandBillDetail catelogHandBillDetailFromJson(String str) => CatelogHandBillDetail.fromJson(json.decode(str));

// String catelogHandBillDetailToJson(CatelogHandBillDetail data) => json.encode(data.toJson());

// class CatelogHandBillDetail {
//     CatelogHandBillDetail({
//         required this.handBillDetail,
//     });

//     List<HandBillDetail> handBillDetail;

//     factory CatelogHandBillDetail.fromJson(Map<String, dynamic> json) => CatelogHandBillDetail(
//         handBillDetail: List<HandBillDetail>.from(json["HandBillDetail"].map((x) => HandBillDetail.fromJson(x))),
//     );

//     Map<String, dynamic> toJson() => {
//         "HandBillDetail": List<dynamic>.from(handBillDetail.map((x) => x.toJson())),
//     };
// }

// class HandBillDetail {
//     HandBillDetail({
//         required this.handBillListShow,
//         required this.handBillImage,
//         required this.handBillBrand,
//         required this.handBillMedia,
//         required this.handBillName,
//         required this.handBillCampaign,
//     });

//     String handBillListShow;
//     String handBillImage;
//     String handBillBrand;
//     String handBillMedia;
//     String handBillName;
//     String handBillCampaign;

//     factory HandBillDetail.fromJson(Map<String, dynamic> json) => HandBillDetail(
//         handBillListShow: json["HandBillListShow"],
//         handBillImage: json["HandBillImage"],
//         handBillBrand: json["HandBillBrand"],
//         handBillMedia: json["HandBillMedia"],
//         handBillName: json["HandBillName"],
//         handBillCampaign: json["HandBillCampaign"],
//     );

//     Map<String, dynamic> toJson() => {
//         "HandBillListShow": handBillListShow,
//         "HandBillImage": handBillImage,
//         "HandBillBrand": handBillBrand,
//         "HandBillMedia": handBillMedia,
//         "HandBillName": handBillName,
//         "HandBillCampaign": handBillCampaign,
//     };
// }

// To parse this JSON data, do
//
//     final catelogHandBillDetail = catelogHandBillDetailFromJson(jsonString);

// import 'package:meta/meta.dart';
import 'dart:convert';

CatelogHandBillDetail catelogHandBillDetailFromJson(String str) =>
    CatelogHandBillDetail.fromJson(json.decode(str));

String catelogHandBillDetailToJson(CatelogHandBillDetail data) =>
    json.encode(data.toJson());

class CatelogHandBillDetail {
  CatelogHandBillDetail({
    required this.handBillDetail,
  });

  List<HandBillDetail> handBillDetail;

  factory CatelogHandBillDetail.fromJson(Map<String, dynamic> json) =>
      CatelogHandBillDetail(
        handBillDetail: json["HandBillDetail"] == null
            ? []
            : List<HandBillDetail>.from(
                json["HandBillDetail"].map((x) => HandBillDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "HandBillDetail":
            List<dynamic>.from(handBillDetail.map((x) => x.toJson())),
      };
}

class HandBillDetail {
  HandBillDetail({
    required this.handBillID,
    required this.handBillListShow,
    required this.handBillImage,
    required this.handBillBrand,
    required this.handBillMedia,
    required this.handBillName,
    required this.handBillCampaign,
  });

  String handBillID;
  String handBillListShow;
  String handBillImage;
  String handBillBrand;
  String handBillMedia;
  String handBillName;
  String handBillCampaign;

  factory HandBillDetail.fromJson(Map<String, dynamic> json) => HandBillDetail(
        handBillID: json["HandBillID"] ?? "",
        handBillListShow: json["HandBillListShow"] ?? "",
        handBillImage: json["HandBillImage"] ?? "",
        handBillBrand: json["HandBillBrand"] ?? "",
        handBillMedia: json["HandBillMedia"] ?? "",
        handBillName: json["HandBillName"] ?? "",
        handBillCampaign: json["HandBillCampaign"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "HandBillID": handBillID,
        "HandBillListShow": handBillListShow,
        "HandBillImage": handBillImage,
        "HandBillBrand": handBillBrand,
        "HandBillMedia": handBillMedia,
        "HandBillName": handBillName,
        "HandBillCampaign": handBillCampaign,
      };
}
