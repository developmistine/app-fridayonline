// // To parse this JSON data, do
// //
// //     final badgerProfilResppnse = badgerProfilResppnseFromJson(jsonString);

// import 'package:meta/meta.dart';
// import 'dart:convert';

// BadgerProfilResppnse badgerProfilResppnseFromJson(String str) =>
//     BadgerProfilResppnse.fromJson(json.decode(str));

// String badgerProfilResppnseToJson(BadgerProfilResppnse data) =>
//     json.encode(data.toJson());

// class BadgerProfilResppnse {
//   BadgerProfilResppnse({
//     required this.xml,
//     required this.value,
//   });

//   Xml xml;
//   Value value;

//   factory BadgerProfilResppnse.fromJson(Map<String, dynamic> json) =>
//       BadgerProfilResppnse(
//         xml: Xml.fromJson(json["?xml"]),
//         value: Value.fromJson(json["Value"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "?xml": xml.toJson(),
//         "Value": value.toJson(),
//       };
// }

// class Value {
//   Value({
//     required this.success,
//   });

//   String success;

//   factory Value.fromJson(Map<String, dynamic> json) => Value(
//         success: json["Success"],
//       );

//   Map<String, dynamic> toJson() => {
//         "Success": success,
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
//         version: json["@version"] ?? "",
//         encoding: json["@encoding"] ?? "",
//       );

//   Map<String, dynamic> toJson() => {
//         "@version": version,
//         "@encoding": encoding,
//       };
// }

// To parse this JSON data, do
//
//     final badgerProfilResppnse = badgerProfilResppnseFromJson(jsonString);

// import 'package:meta/meta.dart';
import 'dart:convert';

BadgerProfilResppnse badgerProfilResppnseFromJson(String str) =>
    BadgerProfilResppnse.fromJson(json.decode(str));

String badgerProfilResppnseToJson(BadgerProfilResppnse data) =>
    json.encode(data.toJson());

class BadgerProfilResppnse {
  BadgerProfilResppnse({
    required this.value,
  });

  Value value;

  factory BadgerProfilResppnse.fromJson(Map<String, dynamic> json) =>
      BadgerProfilResppnse(
        value: Value.fromJson(json["Value"]),
      );

  Map<String, dynamic> toJson() => {
        "Value": value.toJson(),
      };
}

class Value {
  Value({
    required this.success,
  });

  String success;

  factory Value.fromJson(Map<String, dynamic> json) => Value(
        success: json["Success"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "Success": success,
      };
}
