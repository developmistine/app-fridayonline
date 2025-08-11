// // To parse this JSON data, do
// //
// //     final groupcatelogy = groupcatelogyFromJson(jsonString);

// // ignore_for_file: file_names

// import 'dart:convert';

// List<Groupcatelogy> groupcatelogyFromJson(String str) =>
//     List<Groupcatelogy>.from(
//         json.decode(str).map((x) => Groupcatelogy.fromJson(x)));

// String groupcatelogyToJson(List<Groupcatelogy> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

// class Groupcatelogy {
//   Groupcatelogy({
//     required this.id,
//     required this.name,
//     required this.img,
//     required this.childrenData,
//   });

//   int id;
//   String name;
//   String img;
//   List<ChildrenDatum> childrenData;

//   factory Groupcatelogy.fromJson(Map<String, dynamic> json) => Groupcatelogy(
//         id: json["id"],
//         name: json["name"],
//         img: json["img"],
//         childrenData: List<ChildrenDatum>.from(
//             json["children_data"].map((x) => ChildrenDatum.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//         "img": img,
//         "children_data":
//             List<dynamic>.from(childrenData.map((x) => x.toJson())),
//       };
// }

// class ChildrenDatum {
//   ChildrenDatum({
//     required this.id,
//     required this.parentId,
//     required this.name,
//     required this.img,
//   });

//   String id;
//   String parentId;
//   String name;
//   String img;

//   factory ChildrenDatum.fromJson(Map<String, dynamic> json) => ChildrenDatum(
//         id: json["id"],
//         parentId: json["parent_id"],
//         name: json["name"],
//         img: json["img"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "parent_id": parentId,
//         "name": name,
//         "img": img,
//       };
// }

// To parse this JSON data, do
//
//     final groupcatelogy = groupcatelogyFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

List<Groupcatelogy> groupcatelogyFromJson(String str) =>
    List<Groupcatelogy>.from(
        json.decode(str).map((x) => Groupcatelogy.fromJson(x)));

String groupcatelogyToJson(List<Groupcatelogy> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Groupcatelogy {
  Groupcatelogy({
    required this.id,
    required this.name,
    required this.img,
    required this.childrenData,
  });

  String id;
  String name;
  String img;
  List<ChildrenDatum> childrenData;

  factory Groupcatelogy.fromJson(Map<String, dynamic> json) => Groupcatelogy(
        id: json["id"] ?? "",
        name: json["name"] ?? "",
        img: json["img"] ?? "",
        childrenData: json["ChildrenData"] == null ? [] : List<ChildrenDatum>.from(
            json["ChildrenData"].map((x) => ChildrenDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "img": img,
        "ChildrenData": List<dynamic>.from(childrenData.map((x) => x.toJson())),
      };
}

class ChildrenDatum {
  ChildrenDatum({
    required this.id,
    required this.parentId,
    required this.name,
    required this.img,
  });

  String id;
  String parentId;
  String name;
  String img;

  factory ChildrenDatum.fromJson(Map<String, dynamic> json) => ChildrenDatum(
        id: json["id"] ?? "",
        parentId: json["parent_id"] ?? "",
        name: json["name"] ?? "",
        img: json["img"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "parent_id": parentId,
        "name": name,
        "img": img,
      };
}
