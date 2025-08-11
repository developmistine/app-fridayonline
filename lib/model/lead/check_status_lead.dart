// To parse this JSON data, do
//
//     final checkStatusLead = checkStatusLeadFromJson(jsonString);

// import 'package:meta/meta.dart';
import 'dart:convert';

CheckStatusLead checkStatusLeadFromJson(String str) =>
    CheckStatusLead.fromJson(json.decode(str));

String checkStatusLeadToJson(CheckStatusLead data) =>
    json.encode(data.toJson());

class CheckStatusLead {
  CheckStatusLead({
    required this.leadStatus,
    required this.phoneNo,
    required this.repcode,
    required this.message,
  });

  String leadStatus;
  String phoneNo;
  String repcode;
  String message;

  factory CheckStatusLead.fromJson(Map<String, dynamic> json) =>
      CheckStatusLead(
        leadStatus: json["leadStatus"] ?? "",
        phoneNo: json["phoneNo"] ?? "",
        repcode: json["repcode"] ?? "",
        message: json["message"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "leadStatus": leadStatus,
        "phoneNo": phoneNo,
        "repcode": repcode,
        "message": message,
      };
}
