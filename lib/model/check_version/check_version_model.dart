// // To parse this JSON data, do
// //
// //     final checkVersionModel = checkVersionModelFromJson(jsonString);

// import 'package:meta/meta.dart';
// import 'dart:convert';

// CheckVersionModel checkVersionModelFromJson(String str) =>
//     CheckVersionModel.fromJson(json.decode(str));

// String checkVersionModelToJson(CheckVersionModel data) =>
//     json.encode(data.toJson());

// class CheckVersionModel {
//   CheckVersionModel({
//     required this.xml,
//     required this.version,
//   });

//   Xml xml;
//   Version version;

//   factory CheckVersionModel.fromJson(Map<String, dynamic> json) =>
//       CheckVersionModel(
//         xml: Xml.fromJson(json["?xml"]),
//         version: Version.fromJson(json["Version"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "?xml": xml.toJson(),
//         "Version": version.toJson(),
//       };
// }

// class Version {
//   Version({
//     required this.code,
//     required this.value,
//     required this.extra,
//     required this.androidVersion,
//     required this.iosVersion,
//     required this.huaweiVersion,
//   });

//   String code;
//   String value;
//   String extra;
//   AndroidVersionClass androidVersion;
//   AndroidVersionClass iosVersion;
//   AndroidVersionClass huaweiVersion;

//   factory Version.fromJson(Map<String, dynamic> json) => Version(
//         code: json["Code"],
//         value: json["Value"],
//         extra: json["Extra"],
//         androidVersion: AndroidVersionClass.fromJson(json["AndroidVersion"]),
//         huaweiVersion: AndroidVersionClass.fromJson(json["HuaweiVersion"]),
//         iosVersion: AndroidVersionClass.fromJson(json["IOSVersion"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "Code": code,
//         "Value": value,
//         "Extra": extra,
//         "AndroidVersion": androidVersion.toJson(),
//         "HuaweiVersion": huaweiVersion.toJson(),
//         "IOSVersion": iosVersion.toJson(),
//       };
// }

// class AndroidVersionClass {
//   AndroidVersionClass({
//     required this.isMaintain,
//     required this.maintainDetail,
//     required this.uriMaintenance,
//     required this.isForceUpdate,
//     required this.versionCode,
//     required this.uriPlayStore,
//     required this.showAlert,
//     required this.alertShowTitle,
//     required this.alertShowDetail,
//     required this.contentHilightStatus,
//     required this.showpopup,
//     required this.uriItunes,
//     required this.tokenApp,
//   });

//   String isMaintain;
//   String maintainDetail;
//   String uriMaintenance;
//   String isForceUpdate;
//   String versionCode;
//   String uriPlayStore;
//   String showAlert;
//   String alertShowTitle;
//   String alertShowDetail;
//   String contentHilightStatus;
//   String showpopup;
//   String uriItunes;
//   dynamic tokenApp;

//   factory AndroidVersionClass.fromJson(Map<String, dynamic> json) =>
//       AndroidVersionClass(
//         isMaintain: json["isMaintain"] ?? "",
//         maintainDetail: json["maintainDetail"] ?? "",
//         uriMaintenance: json["uriMaintenance"] ?? "",
//         isForceUpdate: json["isForceUpdate"] ?? "",
//         versionCode: json["versionCode"] ?? "",
//         uriPlayStore: json["uriPlayStore"] ?? "",
//         showAlert: json["showAlert"] ?? "",
//         alertShowTitle: json["alertShowTitle"] ?? "",
//         alertShowDetail: json["alertShowDetail"] ?? "",
//         contentHilightStatus: json["contentHilightStatus"] ?? "",
//         showpopup: json["Showpopup"] ?? "",
//         uriItunes: json["uriItunes"] ?? "",
//         tokenApp: json["TokenApp"] ?? "",
//       );

//   Map<String, dynamic> toJson() => {
//         "isMaintain": isMaintain,
//         "maintainDetail": maintainDetail,
//         "uriMaintenance": uriMaintenance,
//         "isForceUpdate": isForceUpdate,
//         "versionCode": versionCode,
//         "uriPlayStore": uriPlayStore,
//         "showAlert": showAlert,
//         "alertShowTitle": alertShowTitle,
//         "alertShowDetail": alertShowDetail,
//         "contentHilightStatus": contentHilightStatus,
//         "Showpopup": showpopup,
//         "uriItunes": uriItunes,
//         "TokenApp": tokenApp,
//       };
// }

// class Xml {
//   Xml({
//     required this.version,
//     required this.encoding,
//   });

//   String version;
//   String encoding;

//   factory Xml.fromJson(Map<String, dynamic> json) => Xml(
//         version: json["@version"],
//         encoding: json["@encoding"],
//       );

//   Map<String, dynamic> toJson() => {
//         "@version": version,
//         "@encoding": encoding,
//       };
// }

// To parse this JSON data, do
//
//     final checkVersionModel = checkVersionModelFromJson(jsonString);

// import 'package:meta/meta.dart';
import 'dart:convert';

CheckVersionModel checkVersionModelFromJson(String str) =>
    CheckVersionModel.fromJson(json.decode(str));

String checkVersionModelToJson(CheckVersionModel data) =>
    json.encode(data.toJson());

class CheckVersionModel {
  CheckVersionModel({
    required this.version,
  });

  Version version;

  factory CheckVersionModel.fromJson(Map<String, dynamic> json) =>
      CheckVersionModel(
        version: Version.fromJson(json["Version"]),
      );

  Map<String, dynamic> toJson() => {
        "Version": version.toJson(),
      };
}

class Version {
  Version({
    required this.code,
    required this.value,
    required this.extra,
    required this.androidVersion,
    required this.huaweiVersion,
    required this.iosVersion,
  });

  String code;
  String value;
  String extra;
  AndroidVersionClass androidVersion;
  AndroidVersionClass huaweiVersion;
  AndroidVersionClass iosVersion;

  factory Version.fromJson(Map<String, dynamic> json) => Version(
        code: json["Code"] ?? "",
        value: json["Value"] ?? "",
        extra: json["Extra"] ?? "",
        androidVersion: AndroidVersionClass.fromJson(json["AndroidVersion"]),
        huaweiVersion: AndroidVersionClass.fromJson(json["HuaweiVersion"]),
        iosVersion: AndroidVersionClass.fromJson(json["IOSVersion"]),
      );

  Map<String, dynamic> toJson() => {
        "Code": code,
        "Value": value,
        "Extra": extra,
        "AndroidVersion": androidVersion.toJson(),
        "HuaweiVersion": huaweiVersion.toJson(),
        "IOSVersion": iosVersion.toJson(),
      };
}

class AndroidVersionClass {
  AndroidVersionClass({
    required this.isMaintain,
    required this.maintainDetail,
    required this.uriMaintenance,
    required this.isForceUpdate,
    required this.versionCode,
    required this.uriPlayStore,
    required this.showAlert,
    required this.alertShowTitle,
    required this.alertShowDetail,
    required this.contentHilightStatus,
    required this.showpopup,
    required this.uriItunes,
  });

  String isMaintain;
  String maintainDetail;
  String uriMaintenance;
  String isForceUpdate;
  String versionCode;
  String uriPlayStore;
  String showAlert;
  String alertShowTitle;
  String alertShowDetail;
  String contentHilightStatus;
  String showpopup;
  String uriItunes;

  factory AndroidVersionClass.fromJson(Map<String, dynamic> json) =>
      AndroidVersionClass(
        isMaintain: json["isMaintain"] ?? "",
        maintainDetail: json["maintainDetail"] ?? "",
        uriMaintenance: json["uriMaintenance"] ?? "",
        isForceUpdate: json["isForceUpdate"] ?? "",
        versionCode: json["versionCode"] ?? "",
        uriPlayStore: json["uriPlayStore"] ?? "",
        showAlert: json["showAlert"] ?? "",
        alertShowTitle: json["alertShowTitle"] ?? "",
        alertShowDetail: json["alertShowDetail"] ?? "",
        contentHilightStatus: json["contentHilightStatus"] ?? "",
        showpopup: json["Showpopup"] ?? "",
        uriItunes: json["uriItunes"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "isMaintain": isMaintain,
        "maintainDetail": maintainDetail,
        "uriMaintenance": uriMaintenance,
        "isForceUpdate": isForceUpdate,
        "versionCode": versionCode,
        "uriPlayStore": uriPlayStore,
        "showAlert": showAlert,
        "alertShowTitle": alertShowTitle,
        "alertShowDetail": alertShowDetail,
        "contentHilightStatus": contentHilightStatus,
        "Showpopup": showpopup,
        "uriItunes": uriItunes,
      };
}
