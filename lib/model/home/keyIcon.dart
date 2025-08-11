// // To parse this JSON data, do
// //
// //     final getKeyIcon = getKeyIconFromJson(jsonString);

// import 'package:meta/meta.dart';
// import 'dart:convert';

// GetKeyIcon getKeyIconFromJson(String str) =>
//     GetKeyIcon.fromJson(json.decode(str));

// String getKeyIconToJson(GetKeyIcon data) => json.encode(data.toJson());

// class GetKeyIcon {
//   GetKeyIcon({
//     required this.repCode,
//     required this.repType,
//     required this.repSeq,
//     required this.textHeader,
//     required this.menu,
//     required this.announce,
//     required this.keyIcon,
//     required this.banner,
//     required this.favorite,
//     required this.flashSale,
//     required this.specialPromotion,
//     required this.newProduct,
//     required this.content,
//     required this.bestSeller,
//     required this.hotItem,
//   });

//   String repCode;
//   String repType;
//   String repSeq;
//   dynamic textHeader;
//   dynamic menu;
//   dynamic announce;
//   List<KeyIcon> keyIcon;
//   dynamic banner;
//   dynamic favorite;
//   dynamic flashSale;
//   dynamic specialPromotion;
//   dynamic newProduct;
//   dynamic content;
//   dynamic bestSeller;
//   dynamic hotItem;

//   factory GetKeyIcon.fromJson(Map<String, dynamic> json) => GetKeyIcon(
//         repCode: json["RepCode"] ?? "",
//         repType: json["RepType"] ?? "",
//         repSeq: json["RepSeq"] ?? "",
//         textHeader: json["TextHeader"] ?? "",
//         menu: json["Menu"] ?? "",
//         announce: json["Announce"] ?? "",
//         keyIcon:
//             List<KeyIcon>.from(json["KeyIcon"].map((x) => KeyIcon.fromJson(x))),
//         banner: json["Banner"] ?? "",
//         favorite: json["Favorite"] ?? "",
//         flashSale: json["FlashSale"] ?? "",
//         specialPromotion: json["SpecialPromotion"] ?? "",
//         newProduct: json["NewProduct"] ?? "",
//         content: json["Content"] ?? "",
//         bestSeller: json["BestSeller"] ?? "",
//         hotItem: json["HotItem"] ?? "",
//       );

//   Map<String, dynamic> toJson() => {
//         "RepCode": repCode,
//         "RepType": repType,
//         "RepSeq": repSeq,
//         "TextHeader": textHeader,
//         "Menu": menu,
//         "Announce": announce,
//         "KeyIcon": List<dynamic>.from(keyIcon.map((x) => x.toJson())),
//         "Banner": banner,
//         "Favorite": favorite,
//         "FlashSale": flashSale,
//         "SpecialPromotion": specialPromotion,
//         "NewProduct": newProduct,
//         "Content": content,
//         "BestSeller": bestSeller,
//         "HotItem": hotItem,
//       };
// }

// class KeyIcon {
//   KeyIcon({
//     required this.id,
//     required this.keyIconName,
//     required this.keyIconKeyIndex,
//     required this.keyIconImgApp,
//   });

//   String id;
//   String keyIconName;
//   String keyIconKeyIndex;
//   String keyIconImgApp;

//   factory KeyIcon.fromJson(Map<String, dynamic> json) => KeyIcon(
//         id: json["Id"],
//         keyIconName: json["KeyIconName"],
//         keyIconKeyIndex: json["KeyIconKeyIndex"],
//         keyIconImgApp: json["KeyIconImgApp"],
//       );

//   Map<String, dynamic> toJson() => {
//         "Id": id,
//         "KeyIconName": keyIconName,
//         "KeyIconKeyIndex": keyIconKeyIndex,
//         "KeyIconImgApp": keyIconImgApp,
//       };
// }

// To parse this JSON data, do
//
//     final getKeyIcon = getKeyIconFromJson(jsonString);

// import 'package:meta/meta.dart';
import 'dart:convert';

GetKeyIcon getKeyIconFromJson(String str) =>
    GetKeyIcon.fromJson(json.decode(str));

String getKeyIconToJson(GetKeyIcon data) => json.encode(data.toJson());

class GetKeyIcon {
  GetKeyIcon({
    required this.repCode,
    required this.repType,
    required this.repSeq,
    required this.textHeader,
    required this.menu,
    required this.announce,
    required this.keyIcon,
  });

  String repCode;
  String repType;
  String repSeq;
  String textHeader;
  String menu;
  String announce;
  List<KeyIcon> keyIcon;

  factory GetKeyIcon.fromJson(Map<String, dynamic> json) => GetKeyIcon(
        repCode: json["RepCode"] ?? "",
        repType: json["RepType"] ?? "",
        repSeq: json["RepSeq"] ?? "",
        textHeader: json["TextHeader"] ?? "",
        menu: json["Menu"] ?? "",
        announce: json["Announce"] ?? "",
        keyIcon: json["KeyIcon"] == null
            ? []
            : List<KeyIcon>.from(
                json["KeyIcon"].map((x) => KeyIcon.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "RepCode": repCode,
        "RepType": repType,
        "RepSeq": repSeq,
        "TextHeader": textHeader,
        "Menu": menu,
        "Announce": announce,
        "KeyIcon": List<dynamic>.from(keyIcon.map((x) => x.toJson())),
      };
}

class KeyIcon {
  KeyIcon({
    required this.id,
    required this.keyIconName,
    required this.keyIconKeyIndex,
    required this.keyIconKeyValue,
    required this.keyIconImgApp,
  });

  String id;
  String keyIconName;
  String keyIconKeyIndex;
  String keyIconKeyValue;
  String keyIconImgApp;

  factory KeyIcon.fromJson(Map<String, dynamic> json) => KeyIcon(
        id: json["Id"] ?? "",
        keyIconName: json["KeyIconName"] ?? "",
        keyIconKeyIndex: json["KeyIconKeyIndex"] ?? "",
        keyIconKeyValue: json["KeyIconKeyValue"] ?? "",
        keyIconImgApp: json["KeyIconImgApp"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "KeyIconName": keyIconName,
        "KeyIconKeyIndex": keyIconKeyIndex,
        "KeyIconKeyValue": keyIconKeyValue,
        "KeyIconImgApp": keyIconImgApp,
      };
}
