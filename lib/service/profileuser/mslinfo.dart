// To parse this JSON data, do
//
//     final mslinfo = mslinfoFromJson(jsonString);

// import 'package:meta/meta.dart';
import 'dart:convert';

Mslinfo mslinfoFromJson(String str) => Mslinfo.fromJson(json.decode(str));

String mslinfoToJson(Mslinfo data) => json.encode(data.toJson());

class Mslinfo {
  Mslinfo({
    required this.mslInfo,
  });

  MslInfo mslInfo;

  factory Mslinfo.fromJson(Map<String, dynamic> json) => Mslinfo(
        mslInfo: MslInfo.fromJson(json["mslInfo"]),
      );

  Map<String, dynamic> toJson() => {
        "mslInfo": mslInfo.toJson(),
      };
}

class MslInfo {
  MslInfo({
    required this.repSeq,
    required this.repCode,
    required this.repName,
    required this.repStatus,
    required this.arBal,
    required this.bprBal,
    required this.telnumber,
    required this.billDate,
    required this.shipDate,
    required this.savingAmount,
    required this.savingDetail,
    required this.imgPath,
    required this.campaignText,
    required this.activityShow,
    required this.pointShow,
    required this.numDaysLeft,
    required this.province,
    required this.fairActive,
  });

  String repSeq;
  String repCode;
  String repName;
  String repStatus;
  String arBal;
  String bprBal;
  String telnumber;
  String billDate;
  String shipDate;
  String savingAmount;
  String savingDetail;
  String imgPath;
  String campaignText;
  bool activityShow;
  bool pointShow;
  int numDaysLeft;
  String province;
  bool fairActive;

  factory MslInfo.fromJson(Map<String, dynamic> json) => MslInfo(
      repSeq: json["RepSeq"] ?? "",
      repCode: json["RepCode"] ?? "",
      repName: json["RepName"] ?? "",
      repStatus: json["RepStatus"] ?? "",
      arBal: json["ARBal"] ?? "",
      bprBal: json["BPRBal"] ?? "",
      telnumber: json["Telnumber"] ?? "",
      billDate: json["BillDate"] ?? "",
      shipDate: json["ShipDate"] ?? "",
      savingAmount: json["SavingAmount"] ?? "",
      savingDetail: json["SavingDetail"] ?? "",
      imgPath: json["ImgPath"] ?? "",
      campaignText: json["CampaignText"] ?? "",
      activityShow: json["ActivityShow"] ?? "",
      pointShow: json["PointShow"],
      numDaysLeft: json["NumDaysLeft"],
      province: json["Province"] ?? "",
      fairActive: json["FairActive"] ?? false);

  Map<String, dynamic> toJson() => {
        "RepSeq": repSeq,
        "RepCode": repCode,
        "RepName": repName,
        "RepStatus": repStatus,
        "ARBal": arBal,
        "BPRBal": bprBal,
        "Telnumber": telnumber,
        "BillDate": billDate,
        "ShipDate": shipDate,
        "SavingAmount": savingAmount,
        "SavingDetail": savingDetail,
        "ImgPath": imgPath,
        "CampaignText": campaignText,
        "ActivityShow": activityShow,
        "PointShow": pointShow,
        "NumDaysLeft": numDaysLeft,
        "Province": province,
        "FairActive": fairActive,
      };
}
