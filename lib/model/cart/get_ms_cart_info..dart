// To parse this JSON data, do
//
//     final getMessageCardinfo = getMessageCardinfoFromJson(jsonString);

// import 'package:meta/meta.dart';
import 'dart:convert';

GetMessageCardinfo getMessageCardinfoFromJson(String str) =>
    GetMessageCardinfo.fromJson(json.decode(str));

String getMessageCardinfoToJson(GetMessageCardinfo data) =>
    json.encode(data.toJson());

class GetMessageCardinfo {
  GetMessageCardinfo({
    required this.repCode,
    required this.repSeq,
    required this.showMessage,
    required this.projectCode,
    required this.textMessage,
    required this.action,
  });

  String repCode;
  String repSeq;
  String showMessage;
  String projectCode;
  List<TextMessage>? textMessage;
  List<Action>? action;

  factory GetMessageCardinfo.fromJson(Map<String, dynamic> json) =>
      GetMessageCardinfo(
        repCode: json["RepCode"] ?? "",
        repSeq: json["RepSeq"] ?? "",
        showMessage: json["ShowMessage"] ?? "",
        projectCode: json["ProjectCode"] ?? "",
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
        "ProjectCode": projectCode,
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
    required this.textHeader,
    required this.textBody1,
    required this.textBody2,
    required this.textFooter,
  });

  String textHeader;
  String textBody1;
  String textBody2;
  String textFooter;

  factory TextMessage.fromJson(Map<String, dynamic> json) => TextMessage(
        textHeader: json["TextHeader"] ?? "",
        textBody1: json["TextBody1"] ?? "",
        textBody2: json["TextBody2"] ?? "",
        textFooter: json["TextFooter"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "TextHeader": textHeader,
        "TextBody1": textBody1,
        "TextBody2": textBody2,
        "TextFooter": textFooter,
      };
}
