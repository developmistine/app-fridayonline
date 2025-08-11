// To parse this JSON data, do
//
//     final cancelreason = cancelreasonFromJson(jsonString);

import 'dart:convert';

List<Cancelreason> cancelreasonFromJson(String str) => List<Cancelreason>.from(
    json.decode(str).map((x) => Cancelreason.fromJson(x)));

String cancelreasonToJson(List<Cancelreason> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Cancelreason {
  String cancelId;
  String cancelReason;
  bool noteFlag;

  Cancelreason({
    required this.cancelId,
    required this.cancelReason,
    required this.noteFlag,
  });

  factory Cancelreason.fromJson(Map<String, dynamic> json) => Cancelreason(
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
