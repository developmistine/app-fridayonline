// To parse this JSON data, do
//
//     final vouchersGroup = vouchersGroupFromJson(jsonString);

import 'dart:convert';

VouchersGroup vouchersGroupFromJson(String str) =>
    VouchersGroup.fromJson(json.decode(str));

String vouchersGroupToJson(VouchersGroup data) => json.encode(data.toJson());

class VouchersGroup {
  String code;
  List<Datum> data;
  String message;

  VouchersGroup({
    required this.code,
    required this.data,
    required this.message,
  });

  factory VouchersGroup.fromJson(Map<String, dynamic> json) => VouchersGroup(
        code: json["code"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
      };
}

class Datum {
  int groupId;
  int groupType;
  String groupName;
  String image;

  Datum({
    required this.groupId,
    required this.groupType,
    required this.groupName,
    required this.image,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        groupId: json["group_id"],
        groupType: json["group_type"],
        groupName: json["group_name"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "group_id": groupId,
        "group_type": groupType,
        "group_name": groupName,
        "image": image,
      };
}
