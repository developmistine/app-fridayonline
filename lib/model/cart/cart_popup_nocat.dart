// To parse this JSON data, do
//
//     final popupCartNocat = popupCartNocatFromJson(jsonString);

import 'dart:convert';

PopupCartNocat popupCartNocatFromJson(String str) =>
    PopupCartNocat.fromJson(json.decode(str));

String popupCartNocatToJson(PopupCartNocat data) => json.encode(data.toJson());

class PopupCartNocat {
  bool isShowPopup;
  List<PopupList> popupList;

  PopupCartNocat({
    required this.isShowPopup,
    required this.popupList,
  });

  factory PopupCartNocat.fromJson(Map<String, dynamic> json) => PopupCartNocat(
        isShowPopup: json["IsShowPopup"],
        popupList: List<PopupList>.from(
            json["PopupList"].map((x) => PopupList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "IsShowPopup": isShowPopup,
        "PopupList": List<dynamic>.from(popupList.map((x) => x.toJson())),
      };
}

class PopupList {
  String popupSeq;
  String popupType;
  String popupParam;
  String popupImg;

  PopupList({
    required this.popupSeq,
    required this.popupType,
    required this.popupParam,
    required this.popupImg,
  });

  factory PopupList.fromJson(Map<String, dynamic> json) => PopupList(
        popupSeq: json["PopupSeq"],
        popupType: json["PopupType"],
        popupParam: json["PopupParam"],
        popupImg: json["PopupImg"],
      );

  Map<String, dynamic> toJson() => {
        "PopupSeq": popupSeq,
        "PopupType": popupType,
        "PopupParam": popupParam,
        "PopupImg": popupImg,
      };
}
