// To parse this JSON data, do
//
//     final getDropshipBanner = getDropshipBannerFromJson(jsonString);

// import 'package:meta/meta.dart';
import 'dart:convert';

List<GetDropshipBanner> getDropshipBannerFromJson(String str) =>
    List<GetDropshipBanner>.from(
        json.decode(str).map((x) => GetDropshipBanner.fromJson(x)));

String getDropshipBannerToJson(List<GetDropshipBanner> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetDropshipBanner {
  GetDropshipBanner({
    required this.id,
    required this.contentName,
    required this.typePages,
    required this.typeContent,
    required this.contentIndcx,
    required this.keyIndex,
    required this.contentImg,
    required this.contentImgDestop,
    required this.status,
    required this.campaign,
    required this.band,
    required this.meberCode,
    required this.startCampaign,
    required this.endCampaign,
    required this.showBy,
    required this.startDate,
    required this.endDate,
    required this.showtype,
  });

  String id;
  String contentName;
  String typePages;
  String typeContent;
  String contentIndcx;
  String keyIndex;
  String contentImg;
  String contentImgDestop;
  String status;
  String campaign;
  String band;
  String meberCode;
  String startCampaign;
  String endCampaign;
  String showBy;
  String startDate;
  String endDate;
  String showtype;

  factory GetDropshipBanner.fromJson(Map<String, dynamic> json) =>
      GetDropshipBanner(
        id: json["Id"] ?? "",
        contentName: json["ContentName"] ?? "",
        typePages: json["TypePages"] ?? "",
        typeContent: json["TypeContent"] ?? "",
        contentIndcx: json["ContentIndcx"] ?? "",
        keyIndex: json["KeyIndex"] ?? "",
        contentImg: json["ContentImg"] ?? "",
        contentImgDestop: json["ContentImgDestop"] ?? "",
        status: json["Status"] ?? "",
        campaign: json["Campaign"] ?? "",
        band: json["Band"] ?? "",
        meberCode: json["MeberCode"] ?? "",
        startCampaign: json["StartCampaign"] ?? "",
        endCampaign: json["EndCampaign"] ?? "",
        showBy: json["ShowBy"] ?? "",
        startDate: json["StartDate"],
        endDate: json["EndDate"],
        showtype: json["Showtype"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "ContentName": contentName,
        "TypePages": typePages,
        "TypeContent": typeContent,
        "ContentIndcx": contentIndcx,
        "KeyIndex": keyIndex,
        "ContentImg": contentImg,
        "ContentImgDestop": contentImgDestop,
        "Status": status,
        "Campaign": campaign,
        "Band": band,
        "MeberCode": meberCode,
        "StartCampaign": startCampaign,
        "EndCampaign": endCampaign,
        "ShowBy": showBy,
        "StartDate": startDate,
        "EndDate": endDate,
        "Showtype": showtype,
      };
}
