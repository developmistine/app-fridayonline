// To parse this JSON data, do
//
//     final courier = courierFromJson(jsonString);

import 'dart:convert';

Courier courierFromJson(String str) => Courier.fromJson(json.decode(str));

String courierToJson(Courier data) => json.encode(data.toJson());

class Courier {
  String code;
  List<Datum> data;
  String message;

  Courier({
    required this.code,
    required this.data,
    required this.message,
  });

  factory Courier.fromJson(Map<String, dynamic> json) => Courier(
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
  int courierId;
  String courierCode;
  String courierName;

  Datum({
    required this.courierId,
    required this.courierCode,
    required this.courierName,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        courierId: json["courier_id"],
        courierCode: json["courier_code"],
        courierName: json["courier_name"],
      );

  Map<String, dynamic> toJson() => {
        "courier_id": courierId,
        "courier_code": courierCode,
        "courier_name": courierName,
      };
}
