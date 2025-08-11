// To parse this JSON data, do
//
//     final otpobject = otpobjectFromJson(jsonString);
// ส่วนที่ทำการสร้้าง Object เพื่อที่จะทำการรับ Data
// import 'package:meta/meta.dart';
import 'dart:convert';

Otpobject otpobjectFromJson(String str) => Otpobject.fromJson(json.decode(str));

String otpobjectToJson(Otpobject data) => json.encode(data.toJson());

class Otpobject {
  Otpobject({
    required this.values,
    required this.message,
    required this.repCode,
    required this.telNumber,
  });

  String values;
  String message;
  String repCode;
  String telNumber;

  factory Otpobject.fromJson(Map<String, dynamic> json) => Otpobject(
        values: json["values"] ?? "",
        message: json["Message"] ?? "",
        repCode: json["RepCode"] ?? "",
        telNumber: json["TelNumber"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "values": values,
        "Message": message,
        "RepCode": repCode,
        "TelNumber": telNumber,
      };
}
