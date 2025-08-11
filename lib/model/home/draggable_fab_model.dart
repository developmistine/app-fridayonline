// // To parse this JSON data, do
// //
// //     final draggableFabModel = draggableFabModelFromJson(jsonString);

// import 'package:meta/meta.dart';
// import 'dart:convert';

// DraggableFabModel draggableFabModelFromJson(String str) =>
//     DraggableFabModel.fromJson(json.decode(str));

// String draggableFabModelToJson(DraggableFabModel data) =>
//     json.encode(data.toJson());

// class DraggableFabModel {
//   DraggableFabModel({
//     required this.modernPopup,
//   });

//   ModernPopup modernPopup;

//   factory DraggableFabModel.fromJson(Map<String, dynamic> json) =>
//       DraggableFabModel(
//         modernPopup: ModernPopup.fromJson(json["ModernPopup"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "ModernPopup": modernPopup.toJson(),
//       };
// }

// class ModernPopup {
//   ModernPopup({
//     required this.showType,
//     required this.indexName,
//     required this.member,
//     required this.popupList,
//     required this.surveyList,
//   });

//   String showType;
//   String indexName;
//   String member;
//   List<PopupList> popupList;
//   dynamic surveyList;

//   factory ModernPopup.fromJson(Map<String, dynamic> json) => ModernPopup(
//         showType: json["ShowType"],
//         indexName: json["IndexName"],
//         member: json["Member"],
//         popupList: List<PopupList>.from(
//             json["PopupList"].map((x) => PopupList.fromJson(x))),
//         surveyList: json["SurveyList"],
//       );

//   Map<String, dynamic> toJson() => {
//         "ShowType": showType,
//         "IndexName": indexName,
//         "Member": member,
//         "PopupList": List<dynamic>.from(popupList.map((x) => x.toJson())),
//         "SurveyList": surveyList,
//       };
// }

// class PopupList {
//   PopupList({
//     required this.popupSeq,
//     required this.popupType,
//     required this.popupParam,
//     required this.popupImg,
//     required this.popupCode,
//   });

//   String popupSeq;
//   String popupType;
//   String popupParam;
//   String popupImg;
//   String popupCode;

//   factory PopupList.fromJson(Map<String, dynamic> json) => PopupList(
//         popupSeq: json["PopupSeq"],
//         popupType: json["PopupType"],
//         popupParam: json["PopupParam"],
//         popupImg: json["PopupImg"],
//         popupCode: json["PopupCode"],
//       );

//   Map<String, dynamic> toJson() => {
//         "PopupSeq": popupSeq,
//         "PopupType": popupType,
//         "PopupParam": popupParam,
//         "PopupImg": popupImg,
//         "PopupCode": popupCode,
//       };
// }

// To parse this JSON data, do
//
//     final draggableFabModel = draggableFabModelFromJson(jsonString);

// import 'package:meta/meta.dart';
import 'dart:convert';

DraggableFabModel draggableFabModelFromJson(String str) =>
    DraggableFabModel.fromJson(json.decode(str));

String draggableFabModelToJson(DraggableFabModel data) =>
    json.encode(data.toJson());

class DraggableFabModel {
  DraggableFabModel({
    required this.modernPopup,
  });

  ModernPopup modernPopup;

  factory DraggableFabModel.fromJson(Map<String, dynamic> json) =>
      DraggableFabModel(
        modernPopup: ModernPopup.fromJson(json["ModernPopup"]),
      );

  Map<String, dynamic> toJson() => {
        "ModernPopup": modernPopup.toJson(),
      };
}

class ModernPopup {
  ModernPopup({
    required this.showType,
    required this.indexName,
    required this.member,
    required this.popupList,
    required this.surveyList,
  });

  String showType;
  String indexName;
  String member;
  List<PopupList> popupList;
  List<dynamic> surveyList;

  factory ModernPopup.fromJson(Map<String, dynamic> json) => ModernPopup(
        showType: json["ShowType"] ?? "",
        indexName: json["IndexName"] ?? "",
        member: json["Member"] ?? "",
        popupList: json["PopupList"] == null
            ? []
            : List<PopupList>.from(
                json["PopupList"].map((x) => PopupList.fromJson(x))),
        surveyList: json["SurveyList"] == null
            ? []
            : List<dynamic>.from(json["SurveyList"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "ShowType": showType,
        "IndexName": indexName,
        "Member": member,
        "PopupList": List<dynamic>.from(popupList.map((x) => x.toJson())),
        "SurveyList": List<dynamic>.from(surveyList.map((x) => x)),
      };
}

class PopupList {
  PopupList({
    required this.popupSeq,
    required this.popupType,
    required this.popupParam,
    required this.popupImg,
    required this.popupCode,
  });

  String popupSeq;
  String popupType;
  String popupParam;
  String popupImg;
  String popupCode;

  factory PopupList.fromJson(Map<String, dynamic> json) => PopupList(
        popupSeq: json["PopupSeq"] ?? "",
        popupType: json["PopupType"] ?? "",
        popupParam: json["PopupParam"] ?? "",
        popupImg: json["PopupImg"] ?? "",
        popupCode: json["PopupCode"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "PopupSeq": popupSeq,
        "PopupType": popupType,
        "PopupParam": popupParam,
        "PopupImg": popupImg,
        "PopupCode": popupCode,
      };
}
