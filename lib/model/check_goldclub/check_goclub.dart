// To parse this JSON data, do
//
//     final popupchecktypeg = popupchecktypegFromJson(jsonString);

import 'dart:convert';

Popupchecktypeg popupchecktypegFromJson(String str) =>
    Popupchecktypeg.fromJson(json.decode(str));

String popupchecktypegToJson(Popupchecktypeg data) =>
    json.encode(data.toJson());

class Popupchecktypeg {
  String code;
  String message1;
  String message2;
  String repCodeNew;
  String mobileNo;

  Popupchecktypeg({
    required this.code,
    required this.message1,
    required this.message2,
    required this.repCodeNew,
    required this.mobileNo,
  });

  factory Popupchecktypeg.fromJson(Map<String, dynamic> json) =>
      Popupchecktypeg(
        code: json["Code"],
        message1: json["Message1"],
        message2: json["Message2"],
        repCodeNew: json["RepCodeNew"],
        mobileNo: json["MobileNo"],
      );

  Map<String, dynamic> toJson() => {
        "Code": code,
        "Message1": message1,
        "Message2": message2,
        "RepCodeNew": repCodeNew,
        "MobileNo": mobileNo,
      };
}
