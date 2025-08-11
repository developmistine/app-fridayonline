// To parse this JSON data, do
//
//     final approveEndUserAll = approveEndUserAllFromJson(jsonString);

import 'dart:convert';

ApproveEndUserAll approveEndUserAllFromJson(String str) =>
    ApproveEndUserAll.fromJson(json.decode(str));

String approveEndUserAllToJson(ApproveEndUserAll data) =>
    json.encode(data.toJson());

class ApproveEndUserAll {
  ApproveEndUserAll({
    required this.listUpdateAll,
  });

  List<ListUpdateAll> listUpdateAll;

  factory ApproveEndUserAll.fromJson(Map<String, dynamic> json) =>
      ApproveEndUserAll(
        listUpdateAll: json["ListUpdateAll"] == null ? [] : List<ListUpdateAll>.from(
            json["ListUpdateAll"].map((x) => ListUpdateAll.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ListUpdateAll":
            List<dynamic>.from(listUpdateAll.map((x) => x.toJson())),
      };
}

class ListUpdateAll {
  ListUpdateAll({
    required this.repSeq,
    required this.repCode,
    required this.userId,
    required this.phoneNumber,
    required this.orderNo,
    required this.flagData,
  });

  String repSeq;
  String repCode;
  String userId;
  String phoneNumber;
  String orderNo;
  String flagData;

  factory ListUpdateAll.fromJson(Map<String, dynamic> json) => ListUpdateAll(
        repSeq: json["RepSeq"] ?? "",
        repCode: json["RepCode"] ?? "",
        userId: json["UserID"] ?? "",
        phoneNumber: json["PhoneNumber"] ?? "",
        orderNo: json["OrderNo"] ?? "",
        flagData: json["FlagData"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "RepSeq": repSeq,
        "RepCode": repCode,
        "UserID": userId,
        "PhoneNumber": phoneNumber,
        "OrderNo": orderNo,
        "FlagData": flagData,
      };
}
