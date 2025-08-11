// // To parse this JSON data, do
// //
// //     final poppularKeys = poppularKeysFromJson(jsonString);

// import 'package:meta/meta.dart';
// import 'dart:convert';

// PoppularKeys poppularKeysFromJson(String str) =>
//     PoppularKeys.fromJson(json.decode(str));

// String poppularKeysToJson(PoppularKeys data) => json.encode(data.toJson());

// class PoppularKeys {
//   PoppularKeys({
//     required this.keyPopular,
//   });

//   List<KeyPopular> keyPopular;

//   factory PoppularKeys.fromJson(Map<String, dynamic> json) => PoppularKeys(
//         keyPopular: List<KeyPopular>.from(
//             json["KeyPopular"].map((x) => KeyPopular.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "KeyPopular": List<dynamic>.from(keyPopular.map((x) => x.toJson())),
//       };
// }

// class KeyPopular {
//   KeyPopular({
//     required this.keyWord,
//     required this.userType,
//     required this.repSeq,
//     required this.repCode,
//     required this.userId,
//     required this.fsCodeTemp,
//     required this.fsCode,
//     required this.productCode,
//     required this.billCodeB2C,
//     required this.billCode,
//     required this.campaign,
//     required this.media,
//     required this.language,
//   });

//   String keyWord;
//   dynamic userType;
//   dynamic repSeq;
//   dynamic repCode;
//   dynamic userId;
//   dynamic fsCodeTemp;
//   dynamic fsCode;
//   dynamic productCode;
//   dynamic billCodeB2C;
//   dynamic billCode;
//   dynamic campaign;
//   dynamic media;
//   dynamic language;

//   factory KeyPopular.fromJson(Map<String, dynamic> json) => KeyPopular(
//         keyWord: json["KeyWord"],
//         userType: json["UserType"],
//         repSeq: json["RepSeq"],
//         repCode: json["RepCode"],
//         userId: json["UserID"],
//         fsCodeTemp: json["FsCode_temp"],
//         fsCode: json["FsCode"],
//         productCode: json["ProductCode"],
//         billCodeB2C: json["BillCodeB2C"],
//         billCode: json["BillCode"],
//         campaign: json["Campaign"],
//         media: json["Media"],
//         language: json["language"],
//       );

//   Map<String, dynamic> toJson() => {
//         "KeyWord": keyWord,
//         "UserType": userType,
//         "RepSeq": repSeq,
//         "RepCode": repCode,
//         "UserID": userId,
//         "FsCode_temp": fsCodeTemp,
//         "FsCode": fsCode,
//         "ProductCode": productCode,
//         "BillCodeB2C": billCodeB2C,
//         "BillCode": billCode,
//         "Campaign": campaign,
//         "Media": media,
//         "language": language,
//       };
// }

// To parse this JSON data, do
//
//     final poppularKeys = poppularKeysFromJson(jsonString);

// import 'package:meta/meta.dart';
import 'dart:convert';

PoppularKeys poppularKeysFromJson(String str) =>
    PoppularKeys.fromJson(json.decode(str));

String poppularKeysToJson(PoppularKeys data) => json.encode(data.toJson());

class PoppularKeys {
  PoppularKeys({
    required this.keyPopular,
  });

  List<KeyPopular> keyPopular;

  factory PoppularKeys.fromJson(Map<String, dynamic> json) => PoppularKeys(
        keyPopular: json["KeyPopular"] == null
            ? []
            : List<KeyPopular>.from(
                json["KeyPopular"].map((x) => KeyPopular.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "KeyPopular": List<dynamic>.from(keyPopular.map((x) => x.toJson())),
      };
}

class KeyPopular {
  KeyPopular({
    required this.keyWord,
  });

  String keyWord;

  factory KeyPopular.fromJson(Map<String, dynamic> json) => KeyPopular(
        keyWord: json["KeyWord"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "KeyWord": keyWord,
      };
}
