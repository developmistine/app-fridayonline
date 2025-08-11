// // To parse this JSON data, do
// //
// //     final objectenduser = objectenduserFromJson(jsonString);

// import 'package:meta/meta.dart';
// import 'dart:convert';

// Objectenduser objectenduserFromJson(String str) =>
//     Objectenduser.fromJson(json.decode(str));

// String objectenduserToJson(Objectenduser data) => json.encode(data.toJson());

// class Objectenduser {
//   Objectenduser({
//     required this.reference,
//   });

//   Reference reference;

//   factory Objectenduser.fromJson(Map<String, dynamic> json) => Objectenduser(
//         reference: Reference.fromJson(json["Reference"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "Reference": reference.toJson(),
//       };
// }

// class Reference {
//   Reference({
//     required this.repSeq,
//     required this.repCode,
//     required this.byMsl,
//     required this.byEnduser,
//   });

//   String repSeq;
//   String repCode;
//   By byMsl;
//   List<By> byEnduser;

//   factory Reference.fromJson(Map<String, dynamic> json) => Reference(
//         repSeq: json["RepSeq"],
//         repCode: json["RepCode"],
//         byMsl: By.fromJson(json["ByMsl"]),
//         byEnduser: List<By>.from(json["ByEnduser"].map((x) => By.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "RepSeq": repSeq,
//         "RepCode": repCode,
//         "ByMsl": byMsl.toJson(),
//         "ByEnduser": List<dynamic>.from(byEnduser.map((x) => x.toJson())),
//       };
// }

// class By {
//   By({
//     required this.userId,
//     required this.name,
//     required this.surname,
//     required this.tel,
//   });

//   String userId;
//   String name;
//   String surname;
//   String tel;

//   factory By.fromJson(Map<String, dynamic> json) => By(
//         userId: json["UserId"] ?? "",
//         name: json["Name"] ?? "",
//         surname: json["Surname"] ?? "",
//         tel: json["Tel"] ?? "",
//       );

//   Map<String, dynamic> toJson() => {
//         "UserId": userId,
//         "Name": name,
//         "Surname": surname,
//         "Tel": tel,
//       };
// }

// To parse this JSON data, do
//
//     final objectenduser = objectenduserFromJson(jsonString);

// import 'package:meta/meta.dart';
import 'dart:convert';

Objectenduser objectenduserFromJson(String str) =>
    Objectenduser.fromJson(json.decode(str));

String objectenduserToJson(Objectenduser data) => json.encode(data.toJson());

class Objectenduser {
  Objectenduser({
    required this.reference,
  });

  Reference reference;

  factory Objectenduser.fromJson(Map<String, dynamic> json) => Objectenduser(
        reference: Reference.fromJson(json["Reference"]),
      );

  Map<String, dynamic> toJson() => {
        "Reference": reference.toJson(),
      };
}

class Reference {
  Reference({
    required this.repSeq,
    required this.repCode,
    required this.byMsl,
    required this.byEnduser,
  });

  String repSeq;
  String repCode;
  By byMsl;
  List<By> byEnduser;

  factory Reference.fromJson(Map<String, dynamic> json) => Reference(
        repSeq: json["RepSeq"] ?? "",
        repCode: json["RepCode"] ?? "",
        byMsl: By.fromJson(json["ByMsl"]),
        byEnduser: json["ByEnduser"] == null
            ? []
            : List<By>.from(json["ByEnduser"].map((x) => By.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "RepSeq": repSeq,
        "RepCode": repCode,
        "ByMsl": byMsl.toJson(),
        "ByEnduser": List<dynamic>.from(byEnduser.map((x) => x.toJson())),
      };
}

class By {
  By({
    required this.userId,
    required this.name,
    required this.surname,
    required this.tel,
  });

  String userId;
  String name;
  String surname;
  String tel;

  factory By.fromJson(Map<String, dynamic> json) => By(
        userId: json["UserId"] ?? "",
        name: json["Name"] ?? "",
        surname: json["Surname"] ?? "",
        tel: json["Tel"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "UserId": userId,
        "Name": name,
        "Surname": surname,
        "Tel": tel,
      };
}
