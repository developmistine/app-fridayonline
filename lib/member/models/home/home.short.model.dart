// To parse this JSON data, do
//
//     final homeShortMenu = homeShortMenuFromJson(jsonString);

import 'dart:convert';

HomeShortMenu homeShortMenuFromJson(String str) =>
    HomeShortMenu.fromJson(json.decode(str));

String homeShortMenuToJson(HomeShortMenu data) => json.encode(data.toJson());

class HomeShortMenu {
  String code;
  List<Datum> data;
  String message;

  HomeShortMenu({
    required this.code,
    required this.data,
    required this.message,
  });

  factory HomeShortMenu.fromJson(Map<String, dynamic> json) => HomeShortMenu(
        code: json["code"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
      };
}

class Datum {
  int seqNo;
  String displayName;
  int menuId;
  String menuType;
  String menuValue;
  String image;

  Datum({
    required this.seqNo,
    required this.displayName,
    required this.menuId,
    required this.menuType,
    required this.menuValue,
    required this.image,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        seqNo: json["seq_no"],
        displayName: json["display_name"],
        menuId: json["menu_id"],
        menuType: json["menu_type"],
        menuValue: json["menu_value"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "seq_no": seqNo,
        "display_name": displayName,
        "menu_id": menuId,
        "menu_type": menuType,
        "menu_value": menuValue,
        "image": image,
      };
}
