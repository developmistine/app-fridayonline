// To parse this JSON data, do
//
//     final endUserInfo = endUserInfoFromJson(jsonString);
// import 'package:meta/meta.dart';
import 'dart:convert';

EndUserInfo endUserInfoFromJson(String str) =>
    EndUserInfo.fromJson(json.decode(str));
String endUserInfoToJson(EndUserInfo data) => json.encode(data.toJson());

class EndUserInfo {
  EndUserInfo({
    required this.endUserInfo,
  });
  List<EndUserInfoElement> endUserInfo;
  factory EndUserInfo.fromJson(Map<String, dynamic> json) => EndUserInfo(
        endUserInfo: json["EndUserInfo"] == null
            ? []
            : List<EndUserInfoElement>.from(
                json["EndUserInfo"].map((x) => EndUserInfoElement.fromJson(x))),
      );
  Map<String, dynamic> toJson() => {
        "EndUserInfo": List<dynamic>.from(endUserInfo.map((x) => x.toJson())),
      };
}

class EndUserInfoElement {
  EndUserInfoElement({
    required this.userId,
    required this.userName,
    required this.infodetail,
  });

  String userId;
  String userName;
  List<Infodetail> infodetail;

  factory EndUserInfoElement.fromJson(Map<String, dynamic> json) =>
      EndUserInfoElement(
        userId: json["UserID"] ?? "",
        userName: json["UserName"] ?? "",
        infodetail: json["Infodetail"] == null
            ? []
            : List<Infodetail>.from(
                json["Infodetail"].map((x) => Infodetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "UserID": userId,
        "UserName": userName,
        "Infodetail": List<dynamic>.from(infodetail.map((x) => x.toJson())),
      };
}

class Infodetail {
  Infodetail({
    required this.enduserTelNumber,
    required this.starStock,
    required this.starVisual,
    required this.starRecive,
    required this.mslrepseq,
    required this.mslrepcode,
    required this.mslname,
    required this.mslTelNumber,
    required this.detailMessage1,
    required this.detailMessage2,
    required this.usertype,
  });

  String enduserTelNumber;
  String starStock;
  String starVisual;
  String starRecive;
  String mslrepseq;
  String mslrepcode;
  String mslname;
  String mslTelNumber;
  String detailMessage1;
  String detailMessage2;
  String usertype;

  factory Infodetail.fromJson(Map<String, dynamic> json) => Infodetail(
        enduserTelNumber: json["EnduserTelNumber"] ?? "",
        starStock: json["StarStock"] ?? "",
        starVisual: json["StarVisual"] ?? "",
        starRecive: json["StarRecive"] ?? "",
        mslrepseq: json["Mslrepseq"] ?? "",
        mslrepcode: json["Mslrepcode"] ?? "",
        mslname: json["Mslname"] ?? "",
        mslTelNumber: json["MslTelNumber"] ?? "",
        detailMessage1: json["DetailMessage1"] ?? "",
        detailMessage2: json["DetailMessage2"] ?? "",
        usertype: json["Usertype"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "EnduserTelNumber": enduserTelNumber,
        "StarStock": starStock,
        "StarVisual": starVisual,
        "StarRecive": starRecive,
        "Mslrepseq": mslrepseq,
        "Mslrepcode": mslrepcode,
        "Mslname": mslname,
        "MslTelNumber": mslTelNumber,
        "DetailMessage1": detailMessage1,
        "DetailMessage2": detailMessage2,
        "Usertype": usertype,
      };
}
