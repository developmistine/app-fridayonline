// To parse this JSON data, do
//
//     final pointMember = pointMemberFromJson(jsonString);

// import 'package:meta/meta.dart';
import 'dart:convert';

PointMember pointMemberFromJson(String str) =>
    PointMember.fromJson(json.decode(str));

String pointMemberToJson(PointMember data) => json.encode(data.toJson());

class PointMember {
  PointMember({
    required this.usePointFlag,
    required this.pointAmount,
    required this.idCardRequire,
  });

  String usePointFlag;
  String pointAmount;
  String idCardRequire;

  factory PointMember.fromJson(Map<String, dynamic> json) => PointMember(
        usePointFlag: json["UsePointFlag"] ?? "",
        pointAmount: json["PointAmount"] ?? "",
        idCardRequire: json["IdCardRequire"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "UsePointFlag": usePointFlag,
        "PointAmount": pointAmount,
        "IdCardRequire": idCardRequire,
      };
}
