// To parse this JSON data, do
//
//     final checkCon = checkConFromJson(jsonString);

import 'dart:convert';

CheckCon checkConFromJson(String str) => CheckCon.fromJson(json.decode(str));

String checkConToJson(CheckCon data) => json.encode(data.toJson());

class CheckCon {
  String code;
  Data data;
  String message;

  CheckCon({
    required this.code,
    required this.data,
    required this.message,
  });

  factory CheckCon.fromJson(Map<String, dynamic> json) => CheckCon(
        code: json["code"],
        data: Data.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "data": data.toJson(),
        "message": message,
      };
}

class Data {
  List<ProblematicItem> problematicItems;
  List<ProblematicGroup> problematicGroups;

  Data({
    required this.problematicItems,
    required this.problematicGroups,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        problematicItems: List<ProblematicItem>.from(
            json["problematic_items"].map((x) => ProblematicItem.fromJson(x))),
        problematicGroups: List<ProblematicGroup>.from(
            json["problematic_groups"]
                .map((x) => ProblematicGroup.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "problematic_items":
            List<dynamic>.from(problematicItems.map((x) => x.toJson())),
        "problematic_groups":
            List<dynamic>.from(problematicGroups.map((x) => x.toJson())),
      };
}

class ProblematicGroup {
  String errorMessage;
  List<ProblematicItem> itemBriefs;

  ProblematicGroup({
    required this.errorMessage,
    required this.itemBriefs,
  });

  factory ProblematicGroup.fromJson(Map<String, dynamic> json) =>
      ProblematicGroup(
        errorMessage: json["error_message"],
        itemBriefs: List<ProblematicItem>.from(
            json["item_briefs"].map((x) => ProblematicItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "error_message": errorMessage,
        "item_briefs": List<dynamic>.from(itemBriefs.map((x) => x.toJson())),
      };
}

class ProblematicItem {
  int shopId;
  int productId;
  int itemId;
  String? errorMessage;

  ProblematicItem({
    required this.shopId,
    required this.productId,
    required this.itemId,
    this.errorMessage,
  });

  factory ProblematicItem.fromJson(Map<String, dynamic> json) =>
      ProblematicItem(
        shopId: json["shop_id"],
        productId: json["product_id"],
        itemId: json["item_id"],
        errorMessage: json["error_message"],
      );

  Map<String, dynamic> toJson() => {
        "shop_id": shopId,
        "product_id": productId,
        "item_id": itemId,
        "error_message": errorMessage,
      };
}
