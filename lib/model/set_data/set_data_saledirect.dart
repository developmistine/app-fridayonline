// To parse this JSON data, do
//
//     final getSaleDirect = getSaleDirectFromJson(jsonString);

// import 'package:meta/meta.dart';
import 'dart:convert';

GetSaleDirect getSaleDirectFromJson(String str) =>
    GetSaleDirect.fromJson(json.decode(str));

String getSaleDirectToJson(GetSaleDirect data) => json.encode(data.toJson());

class GetSaleDirect {
  GetSaleDirect({
    required this.activityHeader,
    required this.activity,
  });

  String activityHeader;
  List<Activity> activity;

  factory GetSaleDirect.fromJson(Map<String, dynamic> json) => GetSaleDirect(
        activityHeader: json["ActivityHeader"] ?? "",
        activity: json["Activity"] == null
            ? []
            : List<Activity>.from(
                json["Activity"].map((x) => Activity.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ActivityHeader": activityHeader,
        "Activity": List<dynamic>.from(activity.map((x) => x.toJson())),
      };
}

class Activity {
  Activity({
    required this.id,
    required this.contentName,
    required this.keyindex,
    required this.contentIndcx,
    required this.campaign,
    required this.fsCode,
    required this.fsCodetemp,
  });

  String id;
  String contentName;
  String keyindex;
  String contentIndcx;
  String campaign;
  String fsCode;
  String fsCodetemp;

  factory Activity.fromJson(Map<String, dynamic> json) => Activity(
        id: json["id"] ?? "",
        contentName: json["content_name"] ?? "",
        keyindex: json["keyindex"] ?? "",
        contentIndcx: json["content_indcx"] ?? "",
        campaign: json["campaign"] ?? "",
        fsCode: json["fs_code"] ?? "",
        fsCodetemp: json["fs_codetemp"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "content_name": contentName,
        "keyindex": keyindex,
        "content_indcx": contentIndcx,
        "campaign": campaign,
        "fs_code": fsCode,
        "fs_codetemp": fsCodetemp,
      };
}
