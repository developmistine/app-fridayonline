// // To parse this JSON data, do
// //
// //     final homeGetPoint = homeGetPointFromJson(jsonString);

// import 'package:meta/meta.dart';
// import 'dart:convert';

// HomeGetPoint homeGetPointFromJson(String str) =>
//     HomeGetPoint.fromJson(json.decode(str));

// String homeGetPointToJson(HomeGetPoint data) => json.encode(data.toJson());

// class HomeGetPoint {
//   HomeGetPoint({
//     required this.repType,
//     required this.isShowPoint,
//     required this.point,
//     required this.img,
//   });

//   String repType;
//   bool isShowPoint;
//   String point;
//   String img;

//   factory HomeGetPoint.fromJson(Map<String, dynamic> json) => HomeGetPoint(
//         repType: json["repType"] == null ? null : json["repType"],
//         isShowPoint: json["isShowPoint"] == null ? null : json["isShowPoint"],
//         point: json["point"] == null ? null : json["point"],
//         img: json["img"] == null ? null : json["img"],
//       );

//   Map<String, dynamic> toJson() => {
//         "repType": repType == null ? null : repType,
//         "isShowPoint": isShowPoint == null ? null : isShowPoint,
//         "point": point == null ? null : point,
//         "img": img == null ? null : img,
//       };
// }

// To parse this JSON data, do
//
//     final homeGetPoint = homeGetPointFromJson(jsonString);

// import 'package:meta/meta.dart';
import 'dart:convert';

HomeGetPoint homeGetPointFromJson(String str) =>
    HomeGetPoint.fromJson(json.decode(str));

String homeGetPointToJson(HomeGetPoint data) => json.encode(data.toJson());

class HomeGetPoint {
  HomeGetPoint({
    required this.repType,
    required this.isShowPoint,
    required this.point,
    required this.img,
  });

  String repType;
  bool isShowPoint;
  String point;
  String img;

  factory HomeGetPoint.fromJson(Map<String, dynamic> json) => HomeGetPoint(
        repType: json["RepType"] ?? "",
        isShowPoint: json["IsShowPoint"],
        point: json["Point"] ?? "",
        img: json["Img"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "RepType": repType,
        "IsShowPoint": isShowPoint,
        "Point": point,
        "Img": img,
      };
}
