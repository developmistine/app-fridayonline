// // To parse this JSON data, do
// //
// //     final menuspecialproject = menuspecialprojectFromJson(jsonString);

// import 'package:meta/meta.dart';
// import 'dart:convert';

// Menuspecialproject menuspecialprojectFromJson(String str) =>
//     Menuspecialproject.fromJson(json.decode(str));

// String menuspecialprojectToJson(Menuspecialproject data) =>
//     json.encode(data.toJson());

// class Menuspecialproject {
//   Menuspecialproject({
//     required this.project,
//   });

//   List<Project> project;

//   factory Menuspecialproject.fromJson(Map<String, dynamic> json) =>
//       Menuspecialproject(
//         project:
//             List<Project>.from(json["Project"].map((x) => Project.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "Project": List<dynamic>.from(project.map((x) => x.toJson())),
//       };
// }

// class Project {
//   Project({
//     required this.nameProject,
//     required this.memberGroup,
//     required this.pgmCode,
//     required this.campaignStart,
//     required this.campaignEnd,
//     required this.statusProject,
//     required this.imageWeb,
//     required this.imageApp,
//     required this.urlProject,
//   });

//   String nameProject;
//   String memberGroup;
//   String pgmCode;
//   String campaignStart;
//   String campaignEnd;
//   String statusProject;
//   String imageWeb;
//   String imageApp;
//   String urlProject;

//   factory Project.fromJson(Map<String, dynamic> json) => Project(
//         nameProject: json["NameProject"],
//         memberGroup: json["MemberGroup"],
//         pgmCode: json["PgmCode"],
//         campaignStart: json["CAMPAIGN_START"],
//         campaignEnd: json["CAMPAIGN_END"],
//         statusProject: json["StatusProject"],
//         imageWeb: json["ImageWeb"],
//         imageApp: json["ImageApp"],
//         urlProject: json["UrlProject"],
//       );

//   Map<String, dynamic> toJson() => {
//         "NameProject": nameProject,
//         "MemberGroup": memberGroup,
//         "PgmCode": pgmCode,
//         "CAMPAIGN_START": campaignStart,
//         "CAMPAIGN_END": campaignEnd,
//         "StatusProject": statusProject,
//         "ImageWeb": imageWeb,
//         "ImageApp": imageApp,
//         "UrlProject": urlProject,
//       };
// }

// To parse this JSON data, do
//
//     final menuspecialproject = menuspecialprojectFromJson(jsonString);

// import 'package:meta/meta.dart';
import 'dart:convert';

Menuspecialproject menuspecialprojectFromJson(String str) =>
    Menuspecialproject.fromJson(json.decode(str));

String menuspecialprojectToJson(Menuspecialproject data) =>
    json.encode(data.toJson());

class Menuspecialproject {
  Menuspecialproject({
    required this.project,
  });

  List<Project> project;

  factory Menuspecialproject.fromJson(Map<String, dynamic> json) =>
      Menuspecialproject(
        project: json["Project"] == null
            ? []
            : List<Project>.from(
                json["Project"].map((x) => Project.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Project": List<dynamic>.from(project.map((x) => x.toJson())),
      };
}

class Project {
  Project({
    required this.nameProject,
    required this.memberGroup,
    required this.pgmCode,
    required this.campaignStart,
    required this.campaignEnd,
    required this.statusProject,
    required this.imageWeb,
    required this.imageApp,
    required this.urlProject,
  });

  String nameProject;
  String memberGroup;
  String pgmCode;
  String campaignStart;
  String campaignEnd;
  String statusProject;
  String imageWeb;
  String imageApp;
  String urlProject;

  factory Project.fromJson(Map<String, dynamic> json) => Project(
        nameProject: json["NameProject"] ?? "",
        memberGroup: json["MemberGroup"] ?? "",
        pgmCode: json["PgmCode"] ?? "",
        campaignStart: json["CAMPAIGN_START"] ?? "",
        campaignEnd: json["CAMPAIGN_END"] ?? "",
        statusProject: json["StatusProject"] ?? "",
        imageWeb: json["ImageWeb"] ?? "",
        imageApp: json["ImageApp"] ?? "",
        urlProject: json["UrlProject"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "NameProject": nameProject,
        "MemberGroup": memberGroup,
        "PgmCode": pgmCode,
        "CAMPAIGN_START": campaignStart,
        "CAMPAIGN_END": campaignEnd,
        "StatusProject": statusProject,
        "ImageWeb": imageWeb,
        "ImageApp": imageApp,
        "UrlProject": urlProject,
      };
}
