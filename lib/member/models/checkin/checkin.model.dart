// To parse this JSON data, do
//
//     final checkInData = checkInDataFromJson(jsonString);

import 'dart:convert';

CheckInData checkInDataFromJson(String str) =>
    CheckInData.fromJson(json.decode(str));

String checkInDataToJson(CheckInData data) => json.encode(data.toJson());

class CheckInData {
  String code;
  List<DayData> data;
  String message;
  String checkinTitle;
  String checkinDesc;
  double availableAmount;

  CheckInData({
    required this.code,
    required this.data,
    required this.message,
    required this.checkinTitle,
    required this.checkinDesc,
    required this.availableAmount,
  });

  factory CheckInData.fromJson(Map<String, dynamic> json) => CheckInData(
        code: json["code"],
        data: List<DayData>.from(json["data"].map((x) => DayData.fromJson(x))),
        message: json["message"],
        checkinTitle: json["checkin_title"],
        checkinDesc: json["checkin_desc"],
        availableAmount: json["available_amount"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
        "checkin_title": checkinTitle,
        "checkin_desc": checkinDesc,
        "available_amount": availableAmount,
      };
}

class DayData {
  DateTime date;
  String dayName;
  int points;
  bool isCompleted;
  bool isToday;
  bool isLocked;

  DayData({
    required this.date,
    required this.dayName,
    required this.points,
    required this.isCompleted,
    required this.isToday,
    required this.isLocked,
  });

  factory DayData.fromJson(Map<String, dynamic> json) => DayData(
        date: DateTime.parse(json["date"]),
        dayName: json["day_name"],
        points: json["points"],
        isCompleted: json["is_completed"],
        isToday: json["is_today"],
        isLocked: json["is_locked"],
      );

  Map<String, dynamic> toJson() => {
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "day_name": dayName,
        "points": points,
        "is_completed": isCompleted,
        "is_today": isToday,
        "is_locked": isLocked,
      };
}
