// // To parse this JSON data, do
// //
// //     final getFavorite = getFavoriteFromJson(jsonString);

// import 'package:meta/meta.dart';
// import 'dart:convert';

// GetFavorite getFavoriteFromJson(String str) =>
//     GetFavorite.fromJson(json.decode(str));

// String getFavoriteToJson(GetFavorite data) => json.encode(data.toJson());

// class GetFavorite {
//   GetFavorite({
//     required this.repCode,
//     required this.repType,
//     required this.repSeq,
//     required this.textHeader,
//     required this.menu,
//     required this.announce,
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
//   dynamic banner;
//   List<Favorite> favorite;
//   dynamic flashSale;
//   dynamic specialPromotion;
//   dynamic newProduct;
//   dynamic content;
//   dynamic bestSeller;
//   dynamic hotItem;

//   factory GetFavorite.fromJson(Map<String, dynamic> json) => GetFavorite(
//         repCode: json["RepCode"],
//         repType: json["RepType"],
//         repSeq: json["RepSeq"],
//         textHeader: json["TextHeader"],
//         menu: json["Menu"],
//         announce: json["Announce"],
//         banner: json["Banner"],
//         favorite: List<Favorite>.from(
//             json["Favorite"].map((x) => Favorite.fromJson(x))),
//         flashSale: json["FlashSale"],
//         specialPromotion: json["SpecialPromotion"],
//         newProduct: json["NewProduct"],
//         content: json["Content"],
//         bestSeller: json["BestSeller"],
//         hotItem: json["HotItem"],
//       );

//   Map<String, dynamic> toJson() => {
//         "RepCode": repCode,
//         "RepType": repType,
//         "RepSeq": repSeq,
//         "TextHeader": textHeader,
//         "Menu": menu,
//         "Announce": announce,
//         "Banner": banner,
//         "Favorite": List<dynamic>.from(favorite.map((x) => x.toJson())),
//         "FlashSale": flashSale,
//         "SpecialPromotion": specialPromotion,
//         "NewProduct": newProduct,
//         "Content": content,
//         "BestSeller": bestSeller,
//         "HotItem": hotItem,
//       };
// }

// class Favorite {
//   Favorite({
//     required this.id,
//     required this.favoritecode,
//     required this.favoritename,
//     required this.favoritekeyindex,
//     required this.favoriteimgapp,
//     required this.favoritedataindex,
//     required this.favoritetype,
//     required this.favoriteCampaignStart,
//     required this.favoriteCampaignEnd,
//     required this.favoritestartDate,
//     required this.favoriteenddate,
//   });

//   String id;
//   String favoritecode;
//   String favoritename;
//   String favoritekeyindex;
//   String favoriteimgapp;
//   String favoritedataindex;
//   String favoritetype;
//   String favoriteCampaignStart;
//   String favoriteCampaignEnd;
//   String favoritestartDate;
//   String favoriteenddate;

//   factory Favorite.fromJson(Map<String, dynamic> json) => Favorite(
//         id: json["id"],
//         favoritecode: json["favoritecode"],
//         favoritename: json["favoritename"],
//         favoritekeyindex: json["favoritekeyindex"],
//         favoriteimgapp: json["favoriteimgapp"],
//         favoritedataindex: json["favoritedataindex"],
//         favoritetype: json["favoritetype"],
//         favoriteCampaignStart: json["favoriteCampaignStart"],
//         favoriteCampaignEnd: json["favoriteCampaignEnd"],
//         favoritestartDate: json["favoritestartDate"],
//         favoriteenddate: json["favoriteenddate"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "favoritecode": favoritecode,
//         "favoritename": favoritename,
//         "favoritekeyindex": favoritekeyindex,
//         "favoriteimgapp": favoriteimgapp,
//         "favoritedataindex": favoritedataindex,
//         "favoritetype": favoritetype,
//         "favoriteCampaignStart": favoriteCampaignStart,
//         "favoriteCampaignEnd": favoriteCampaignEnd,
//         "favoritestartDate": favoritestartDate,
//         "favoriteenddate": favoriteenddate,
//       };
// }

// To parse this JSON data, do
//
//     final getFavorite = getFavoriteFromJson(jsonString);

// import 'package:meta/meta.dart';
import 'dart:convert';

GetFavorite getFavoriteFromJson(String str) =>
    GetFavorite.fromJson(json.decode(str));

String getFavoriteToJson(GetFavorite data) => json.encode(data.toJson());

class GetFavorite {
  GetFavorite({
    required this.repCode,
    required this.repType,
    required this.repSeq,
    required this.textHeader,
    required this.menu,
    required this.announce,
    required this.keyIcon,
    required this.favorite,
  });

  String repCode;
  String repType;
  String repSeq;
  String textHeader;
  String menu;
  String announce;
  String keyIcon;
  List<Favorite> favorite;

  factory GetFavorite.fromJson(Map<String, dynamic> json) => GetFavorite(
        repCode: json["RepCode"] ?? "",
        repType: json["RepType"] ?? "",
        repSeq: json["RepSeq"] ?? "",
        textHeader: json["TextHeader"] ?? "",
        menu: json["Menu"] ?? "",
        announce: json["Announce"] ?? "",
        keyIcon: json["KeyIcon"] ?? "",
        favorite: json["Favorite"] == null
            ? []
            : List<Favorite>.from(
                json["Favorite"].map((x) => Favorite.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "RepCode": repCode,
        "RepType": repType,
        "RepSeq": repSeq,
        "TextHeader": textHeader,
        "Menu": menu,
        "Announce": announce,
        "KeyIcon": keyIcon,
        "Favorite": List<dynamic>.from(favorite.map((x) => x.toJson())),
      };
}

class Favorite {
  Favorite({
    required this.id,
    required this.favoritecode,
    required this.favoritename,
    required this.favoritekeyindex,
    required this.favoriteimgapp,
    required this.favoritedataindex,
    required this.favoritetype,
    required this.favoriteCampaignStart,
    required this.favoriteCampaignEnd,
    required this.favoritestartDate,
    required this.favoriteenddate,
  });

  String id;
  String favoritecode;
  String favoritename;
  String favoritekeyindex;
  String favoriteimgapp;
  String favoritedataindex;
  String favoritetype;
  String favoriteCampaignStart;
  String favoriteCampaignEnd;
  String favoritestartDate;
  String favoriteenddate;

  factory Favorite.fromJson(Map<String, dynamic> json) => Favorite(
        id: json["id"] ?? "",
        favoritecode: json["favoritecode"] ?? "",
        favoritename: json["favoritename"] ?? "",
        favoritekeyindex: json["favoritekeyindex"] ?? "",
        favoriteimgapp: json["favoriteimgapp"] ?? "",
        favoritedataindex: json["favoritedataindex"] ?? "",
        favoritetype: json["favoritetype"] ?? "",
        favoriteCampaignStart: json["favoriteCampaignStart"] ?? "",
        favoriteCampaignEnd: json["favoriteCampaignEnd"] ?? "",
        favoritestartDate: json["favoritestartDate"] ?? "",
        favoriteenddate: json["favoriteenddate"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "favoritecode": favoritecode,
        "favoritename": favoritename,
        "favoritekeyindex": favoritekeyindex,
        "favoriteimgapp": favoriteimgapp,
        "favoritedataindex": favoritedataindex,
        "favoritetype": favoritetype,
        "favoriteCampaignStart": favoriteCampaignStart,
        "favoriteCampaignEnd": favoriteCampaignEnd,
        "favoritestartDate": favoritestartDate,
        "favoriteenddate": favoriteenddate,
      };
}
