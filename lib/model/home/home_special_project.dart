// To parse this JSON data, do
//
//     final homeSpecialProjectModel = homeSpecialProjectModelFromJson(jsonString);

// import 'package:meta/meta.dart';
import 'dart:convert';

HomeSpecialProjectModel homeSpecialProjectModelFromJson(String str) =>
    HomeSpecialProjectModel.fromJson(json.decode(str));

String homeSpecialProjectModelToJson(HomeSpecialProjectModel data) =>
    json.encode(data.toJson());

class HomeSpecialProjectModel {
  HomeSpecialProjectModel({
    required this.message,
    required this.dataApInProject,
    required this.dataApOutProject,
  });

  String message;
  List<DataApInProject> dataApInProject;
  List<DataApOutProject> dataApOutProject;

  factory HomeSpecialProjectModel.fromJson(Map<String, dynamic> json) =>
      HomeSpecialProjectModel(
        message: json["Message"] ?? "",
        dataApInProject: json["DataApInProject"] == null
            ? []
            : List<DataApInProject>.from(json["DataApInProject"]
                .map((x) => DataApInProject.fromJson(x))),
        dataApOutProject: json["DataApOutProject"] == null
            ? []
            : List<DataApOutProject>.from(json["DataApOutProject"]
                .map((x) => DataApOutProject.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Message": message,
        "DataApInProject":
            List<dynamic>.from(dataApInProject.map((x) => x.toJson())),
        "DataApOutProject":
            List<dynamic>.from(dataApOutProject.map((x) => x.toJson())),
      };
}

class DataApInProject {
  DataApInProject({
    required this.pgmCode,
    required this.savProject,
    required this.savYear,
    required this.campaignCurrent,
    required this.campaignStart,
    required this.campaignEnd,
    required this.savStatus,
    required this.memberGroup,
    required this.urlImg,
    required this.urlLink,
  });

  String pgmCode;
  String savProject;
  String savYear;
  String campaignCurrent;
  String campaignStart;
  String campaignEnd;
  String savStatus;
  dynamic memberGroup;
  String urlImg;
  String urlLink;

  factory DataApInProject.fromJson(Map<String, dynamic> json) =>
      DataApInProject(
        pgmCode: json["PgmCode"] ?? "",
        savProject: json["SavProject"] ?? "",
        savYear: json["SavYear"] ?? "",
        campaignCurrent: json["CampaignCurrent"] ?? "",
        campaignStart: json["CampaignStart"] ?? "",
        campaignEnd: json["CampaignEnd"] ?? "",
        savStatus: json["SavStatus"] ?? "",
        memberGroup: json["MemberGroup"],
        urlImg: json["UrlImg"] ?? "",
        urlLink: json["UrlLink"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "PgmCode": pgmCode,
        "SavProject": savProject,
        "SavYear": savYear,
        "CampaignCurrent": campaignCurrent,
        "CampaignStart": campaignStart,
        "CampaignEnd": campaignEnd,
        "SavStatus": savStatus,
        "MemberGroup": memberGroup,
        "UrlImg": urlImg,
        "UrlLink": urlLink,
      };
}

class DataApOutProject {
  DataApOutProject({
    required this.pgmCode,
    required this.savProject,
    required this.savYear,
    required this.campaignCurrent,
    required this.campaignStart,
    required this.campaignEnd,
    required this.savStatus,
    required this.memberGroup,
    required this.urlImg,
    required this.urlLink,
  });

  String pgmCode;
  String savProject;
  String savYear;
  String campaignCurrent;
  String campaignStart;
  String campaignEnd;
  String savStatus;
  String memberGroup;
  String urlImg;
  String urlLink;

  factory DataApOutProject.fromJson(Map<String, dynamic> json) =>
      DataApOutProject(
        pgmCode: json["PgmCode"] ?? "",
        savProject: json["SavProject"] ?? "",
        savYear: json["SavYear"] ?? "",
        campaignCurrent: json["CampaignCurrent"] ?? "",
        campaignStart: json["CampaignStart"] ?? "",
        campaignEnd: json["CampaignEnd"] ?? "",
        savStatus: json["SavStatus"] ?? "",
        memberGroup: json["MemberGroup"] ?? "",
        urlImg: json["UrlImg"] ?? "",
        urlLink: json["UrlLink"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "PgmCode": pgmCode,
        "SavProject": savProject,
        "SavYear": savYear,
        "CampaignCurrent": campaignCurrent,
        "CampaignStart": campaignStart,
        "CampaignEnd": campaignEnd,
        "SavStatus": savStatus,
        "MemberGroup": memberGroup,
        "UrlImg": urlImg,
        "UrlLink": urlLink,
      };
}
