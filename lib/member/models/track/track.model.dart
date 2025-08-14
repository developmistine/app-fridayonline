// To parse this JSON data, do
//
//     final tracksResponse = tracksResponseFromJson(jsonString);

import 'dart:convert';

TracksResponse tracksResponseFromJson(String str) =>
    TracksResponse.fromJson(json.decode(str));

String tracksResponseToJson(TracksResponse data) => json.encode(data.toJson());

class TracksResponse {
  String code;
  Data data;
  String message;

  TracksResponse({
    required this.code,
    required this.data,
    required this.message,
  });

  factory TracksResponse.fromJson(Map<String, dynamic> json) => TracksResponse(
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
  String journeyId;
  String sessionId;

  Data({
    required this.journeyId,
    required this.sessionId,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        journeyId: json["journey_id"],
        sessionId: json["session_id"],
      );

  Map<String, dynamic> toJson() => {
        "journey_id": journeyId,
        "session_id": sessionId,
      };
}
