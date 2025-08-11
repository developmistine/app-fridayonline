// To parse this JSON data, do
//
//     final getMessageCartStock = getMessageCartStockFromJson(jsonString);

// import 'package:meta/meta.dart';
import 'dart:convert';

GetMessageCartStock getMessageCartStockFromJson(String str) =>
    GetMessageCartStock.fromJson(json.decode(str));

String getMessageCartStockToJson(GetMessageCartStock data) =>
    json.encode(data.toJson());

class GetMessageCartStock {
  GetMessageCartStock({
    required this.repCode,
    required this.repSeq,
    required this.showMessage,
    required this.textMessage,
    required this.action,
  });

  String repCode;
  String repSeq;
  String showMessage;
  List<TextMessage>? textMessage;
  List<Action>? action;

  factory GetMessageCartStock.fromJson(Map<String, dynamic> json) =>
      GetMessageCartStock(
        repCode: json["RepCode"] ?? "",
        repSeq: json["RepSeq"] ?? "",
        showMessage: json["ShowMessage"] ?? "",
        textMessage: json["TextMessage"] == null
            ? []
            : List<TextMessage>.from(
                json["TextMessage"].map((x) => TextMessage.fromJson(x))),
        action: json["Action"] == null
            ? []
            : List<Action>.from(json["Action"].map((x) => Action.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "RepCode": repCode,
        "RepSeq": repSeq,
        "ShowMessage": showMessage,
        "TextMessage": List<dynamic>.from(textMessage!.map((x) => x.toJson())),
        "Action": List<dynamic>.from(action!.map((x) => x.toJson())),
      };
}

class Action {
  Action({
    required this.action1,
    required this.action2,
  });

  String action1;
  String action2;

  factory Action.fromJson(Map<String, dynamic> json) => Action(
        action1: json["Action1"] ?? "",
        action2: json["Action2"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "Action1": action1,
        "Action2": action2,
      };
}

class TextMessage {
  TextMessage({
    required this.description1,
    required this.description2,
    required this.description3,
  });

  String description1;
  String description2;
  String description3;

  factory TextMessage.fromJson(Map<String, dynamic> json) => TextMessage(
        description1: json["Description1"] ?? "",
        description2: json["Description2"] ?? "",
        description3: json["Description3"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "Description1": description1,
        "Description2": description2,
        "Description3": description3,
      };
}
