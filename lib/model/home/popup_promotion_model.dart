// // import 'dart:convert';

// // PopUpMainHome popUpMainHomeFromJson(String str) => PopUpMainHome.fromJson(json.decode(str));

// // String popUpMainHomeToJson(PopUpMainHome data) => json.encode(data.toJson());

// // class PopUpMainHome {
// //     PopUpMainHome({
// //         required this.modernPopup,
// //     });

// //     ModernPopup modernPopup;

// //     factory PopUpMainHome.fromJson(Map<String, dynamic> json) => PopUpMainHome(
// //         modernPopup: ModernPopup.fromJson(json["ModernPopup"]),
// //     );

// //     Map<String, dynamic> toJson() => {
// //         "ModernPopup": modernPopup.toJson(),
// //     };
// // }

// // class ModernPopup {
// //     ModernPopup({
// //         required this.showType,
// //         required this.indexName,
// //         required this.member,
// //         required this.popupList,
// //         required this.surveyList,
// //     });

// //     String showType;
// //     String indexName;
// //     String member;
// //     List<PopupList> popupList;
// //     List<SurveyList> surveyList;

// //     factory ModernPopup.fromJson(Map<String, dynamic> json) => ModernPopup(
// //         showType: json["ShowType"],
// //         indexName: json["IndexName"],
// //         member: json["Member"],
// //         popupList: List<PopupList>.from(json["PopupList"].map((x) => PopupList.fromJson(x))),
// //         surveyList: List<SurveyList>.from(json["SurveyList"].map((x) => SurveyList.fromJson(x))),
// //     );

// //     Map<String, dynamic> toJson() => {
// //         "ShowType": showType,
// //         "IndexName": indexName,
// //         "Member": member,
// //         "PopupList": List<dynamic>.from(popupList.map((x) => x.toJson())),
// //         "SurveyList": List<dynamic>.from(surveyList.map((x) => x.toJson())),
// //     };
// // }

// // class PopupList {
// //     PopupList({
// //         required this.popupSeq,
// //         required this.popupType,
// //         required this.popupParam,
// //         required this.popupImg,
// //         required this.popupCode,
// //     });

// //     String popupSeq;
// //     String popupType;
// //     String popupParam;
// //     String popupImg;
// //     String popupCode;

// //     factory PopupList.fromJson(Map<String, dynamic> json) => PopupList(
// //         popupSeq: json["PopupSeq"],
// //         popupType: json["PopupType"],
// //         popupParam: json["PopupParam"],
// //         popupImg: json["PopupImg"],
// //         popupCode: json["PopupCode"],
// //     );

// //     Map<String, dynamic> toJson() => {
// //         "PopupSeq": popupSeq,
// //         "PopupType": popupType,
// //         "PopupParam": popupParam,
// //         "PopupImg": popupImg,
// //         "PopupCode": popupCode,
// //     };
// // }

// // class SurveyList {
// //     SurveyList({
// //         required this.popupSeq,
// //         required this.popupCode,
// //         required this.tokenId,
// //         required this.repSeq,
// //         required this.repType,
// //         required this.topic,
// //         required this.msg,
// //         required this.listActionL,
// //         required this.listActionR,
// //     });

// //     String popupSeq;
// //     String popupCode;
// //     String tokenId;
// //     String repSeq;
// //     String repType;
// //     String topic;
// //     String msg;
// //     List<ListActionL> listActionL;
// //     List<ListActionR> listActionR;

// //     factory SurveyList.fromJson(Map<String, dynamic> json) => SurveyList(
// //         popupSeq: json["popupSeq"],
// //         popupCode: json["popupCode"],
// //         tokenId: json["tokenID"],
// //         repSeq: json["repSeq"],
// //         repType: json["repType"],
// //         topic: json["topic"],
// //         msg: json["msg"],
// //         listActionL: List<ListActionL>.from(json["ListActionL"].map((x) => ListActionL.fromJson(x))),
// //         listActionR: List<ListActionR>.from(json["ListActionR"].map((x) => ListActionR.fromJson(x))),
// //     );

// //     Map<String, dynamic> toJson() => {
// //         "popupSeq": popupSeq,
// //         "popupCode": popupCode,
// //         "tokenID": tokenId,
// //         "repSeq": repSeq,
// //         "repType": repType,
// //         "topic": topic,
// //         "msg": msg,
// //         "ListActionL": List<dynamic>.from(listActionL.map((x) => x.toJson())),
// //         "ListActionR": List<dynamic>.from(listActionR.map((x) => x.toJson())),
// //     };
// // }

// // class ListActionL {
// //     ListActionL({
// //         required this.msgL,
// //         required this.valueL,
// //     });

// //     String msgL;
// //     String valueL;

// //     factory ListActionL.fromJson(Map<String, dynamic> json) => ListActionL(
// //         msgL: json["msgL"],
// //         valueL: json["valueL"],
// //     );

// //     Map<String, dynamic> toJson() => {
// //         "msgL": msgL,
// //         "valueL": valueL,
// //     };
// // }

// // class ListActionR {
// //     ListActionR({
// //         required this.msgR,
// //         required this.valueR,
// //     });

// //     String msgR;
// //     String valueR;

// //     factory ListActionR.fromJson(Map<String, dynamic> json) => ListActionR(
// //         msgR: json["msgR"],
// //         valueR: json["valueR"],
// //     );

// //     Map<String, dynamic> toJson() => {
// //         "msgR": msgR,
// //         "valueR": valueR,
// //     };
// // }

// // To parse this JSON data, do
// //
// //     final popUpMainHome = popUpMainHomeFromJson(jsonString);

// import 'package:meta/meta.dart';
// import 'dart:convert';

// PopUpMainHome popUpMainHomeFromJson(String str) =>
//     PopUpMainHome.fromJson(json.decode(str));

// String popUpMainHomeToJson(PopUpMainHome data) => json.encode(data.toJson());

// class PopUpMainHome {
//   PopUpMainHome({
//     required this.modernPopup,
//   });

//   ModernPopup modernPopup;

//   factory PopUpMainHome.fromJson(Map<String, dynamic> json) => PopUpMainHome(
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
//   List<dynamic> surveyList;

//   factory ModernPopup.fromJson(Map<String, dynamic> json) => ModernPopup(
//         showType: json["ShowType"],
//         indexName: json["IndexName"],
//         member: json["Member"],
//         popupList: List<PopupList>.from(
//             json["PopupList"].map((x) => PopupList.fromJson(x))),
//         surveyList: List<dynamic>.from(json["SurveyList"].map((x) => x)),
//       );

//   Map<String, dynamic> toJson() => {
//         "ShowType": showType,
//         "IndexName": indexName,
//         "Member": member,
//         "PopupList": List<dynamic>.from(popupList.map((x) => x.toJson())),
//         "SurveyList": List<dynamic>.from(surveyList.map((x) => x)),
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
//     final popUpMainHome = popUpMainHomeFromJson(jsonString);

// import 'package:meta/meta.dart';
import 'dart:convert';

PopUpMainHome popUpMainHomeFromJson(String str) =>
    PopUpMainHome.fromJson(json.decode(str));

String popUpMainHomeToJson(PopUpMainHome data) => json.encode(data.toJson());

class PopUpMainHome {
  PopUpMainHome({
    required this.modernPopup,
  });

  ModernPopup modernPopup;

  factory PopUpMainHome.fromJson(Map<String, dynamic> json) => PopUpMainHome(
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
