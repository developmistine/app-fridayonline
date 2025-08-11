// To parse this JSON data, do
//
//     final menupoint = menupointFromJson(jsonString);

import 'dart:convert';

Menupoint menupointFromJson(String str) => Menupoint.fromJson(json.decode(str));

String menupointToJson(Menupoint data) => json.encode(data.toJson());

class Menupoint {
  Menupoint({
    required this.id,
    required this.datamenu,
    required this.datamenuUrl,
  });

  String id;
  List<Datamenu> datamenu;
  List<Datamenu> datamenuUrl;

  factory Menupoint.fromJson(Map<String, dynamic> json) => Menupoint(
        id: json["id"] ?? "",
        datamenu: json["datamenu"] == null ? [] : List<Datamenu>.from(
            json["datamenu"].map((x) => Datamenu.fromJson(x))),
        datamenuUrl: json["datamenu_url"] == null ? [] : List<Datamenu>.from(
            json["datamenu_url"].map((x) => Datamenu.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "datamenu": List<dynamic>.from(datamenu.map((x) => x.toJson())),
        "datamenu_url": List<dynamic>.from(datamenuUrl.map((x) => x.toJson())),
      };
}

class Datamenu {
  Datamenu({
    required this.id,
    required this.img,
    required this.nameMenu,
    required this.mediaCode,
    required this.menuType,
    required this.urlLink,
  });

  String id;
  String img;
  String nameMenu;
  String mediaCode;
  String menuType;
  String urlLink;

  factory Datamenu.fromJson(Map<String, dynamic> json) => Datamenu(
        id: json["id"] ?? "",
        img: json["img"] ?? "",
        nameMenu: json["name_menu"] ?? "",
        mediaCode: json["media_code"] ?? "",
        menuType: json["menu_type"] ?? "",
        urlLink: json["url_link"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "img": img,
        "name_menu": nameMenu,
        "media_code": mediaCode,
        "menu_type": menuType,
        "url_link": urlLink,
      };
}
