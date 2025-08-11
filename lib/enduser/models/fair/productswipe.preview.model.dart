// To parse this JSON data, do
//
//     final productSwipePreview = productSwipePreviewFromJson(jsonString);

import 'dart:convert';

ProductSwipePreview productSwipePreviewFromJson(String str) =>
    ProductSwipePreview.fromJson(json.decode(str));

String productSwipePreviewToJson(ProductSwipePreview data) =>
    json.encode(data.toJson());

class ProductSwipePreview {
  Card card;
  String code;
  String message;

  ProductSwipePreview({
    required this.card,
    required this.code,
    required this.message,
  });

  factory ProductSwipePreview.fromJson(Map<String, dynamic> json) =>
      ProductSwipePreview(
        card: Card.fromJson(json["card"]),
        code: json["code"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "card": card.toJson(),
        "code": code,
        "message": message,
      };
}

class Card {
  String icon;
  String title;
  String subtitle;
  String desc;
  List<Action> actions;

  Card({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.desc,
    required this.actions,
  });

  factory Card.fromJson(Map<String, dynamic> json) => Card(
        icon: json["icon"],
        title: json["title"],
        subtitle: json["subtitle"],
        desc: json["desc"],
        actions:
            List<Action>.from(json["actions"].map((x) => Action.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "icon": icon,
        "title": title,
        "subtitle": subtitle,
        "desc": desc,
        "actions": List<dynamic>.from(actions.map((x) => x.toJson())),
      };
}

class Action {
  String action;
  String display;
  String actionKey;

  Action({
    required this.action,
    required this.display,
    required this.actionKey,
  });

  factory Action.fromJson(Map<String, dynamic> json) => Action(
        action: json["action"],
        display: json["display"],
        actionKey: json["action_key"],
      );

  Map<String, dynamic> toJson() => {
        "action": action,
        "display": display,
        "action_key": actionKey,
      };
}
