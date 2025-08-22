// To parse this JSON data, do:
// final tracksResponse = tracksResponseFromJson(jsonString);

import 'dart:convert';

TracksResponse tracksResponseFromJson(String str) =>
    TracksResponse.fromJson(json.decode(str));

String tracksResponseToJson(TracksResponse data) => json.encode(data.toJson());

class TracksResponse {
  final String code;
  final String message;
  final Data? data; // <-- ทำให้ nullable

  TracksResponse({
    required this.code,
    required this.message,
    this.data,
  });

  factory TracksResponse.fromJson(Map<String, dynamic> json) => TracksResponse(
        code: json['code']?.toString() ?? '',
        message: json['message']?.toString() ?? '',
        // รองรับกรณี data ไม่มี / เป็น null / ไม่ใช่ Map
        data: (json['data'] is Map<String, dynamic>)
            ? Data.fromJson(json['data'] as Map<String, dynamic>)
            : null,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'code': code,
      'message': message,
    };
    if (data != null) map['data'] = data!.toJson();
    return map;
  }
}

class Data {
  final String? journeyId;
  final String? sessionId;

  Data({
    this.journeyId,
    this.sessionId,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        journeyId: json['journey_id']?.toString(),
        sessionId: json['session_id']?.toString(),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'journey_id': journeyId,
        'session_id': sessionId,
      }..removeWhere((_, v) => v == null); // ตัด field ที่เป็น null ออก
}
