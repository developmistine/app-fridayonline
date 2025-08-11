// To parse this JSON data, do
//
//     final cancelOrderReason = cancelOrderReasonFromJson(jsonString);

import 'dart:convert';

CancelOrderReason cancelOrderReasonFromJson(String str) =>
    CancelOrderReason.fromJson(json.decode(str));

String cancelOrderReasonToJson(CancelOrderReason data) =>
    json.encode(data.toJson());

class CancelOrderReason {
  String code;
  List<Datum> data;
  String message;

  CancelOrderReason({
    required this.code,
    required this.data,
    required this.message,
  });

  factory CancelOrderReason.fromJson(Map<String, dynamic> json) =>
      CancelOrderReason(
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
  int cancelId;
  String cancelReason;
  bool noteFlag;

  Datum({
    required this.cancelId,
    required this.cancelReason,
    required this.noteFlag,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        cancelId: json["cancel_id"],
        cancelReason: json["cancel_reason"],
        noteFlag: json["note_flag"],
      );

  Map<String, dynamic> toJson() => {
        "cancel_id": cancelId,
        "cancel_reason": cancelReason,
        "note_flag": noteFlag,
      };
}
