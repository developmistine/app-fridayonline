// To parse this JSON data, do
//
//     final getLeadProject = getLeadProjectFromJson(jsonString);

import 'dart:convert';

GetLeadProject getLeadProjectFromJson(String str) =>
    GetLeadProject.fromJson(json.decode(str));

String getLeadProjectToJson(GetLeadProject data) => json.encode(data.toJson());

class GetLeadProject {
  GetLeadProject({
    required this.leadProgram,
  });

  List<LeadProgram> leadProgram;

  factory GetLeadProject.fromJson(Map<String, dynamic> json) => GetLeadProject(
        leadProgram: json["LeadProgram"] == null ? [] : List<LeadProgram>.from(
            json["LeadProgram"].map((x) => LeadProgram.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "LeadProgram": List<dynamic>.from(leadProgram.map((x) => x.toJson())),
      };
}

class LeadProgram {
  LeadProgram({
    required this.id,
    required this.text,
    required this.isSaveImage,
  });

  String id;
  String text;
  bool isSaveImage;

  factory LeadProgram.fromJson(Map<String, dynamic> json) => LeadProgram(
        id: json["ID"] ?? "",
        text: json["Text"] ?? "",
        isSaveImage: json["isSaveImage"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "Text": text,
        "isSaveImage": isSaveImage,
      };
}
