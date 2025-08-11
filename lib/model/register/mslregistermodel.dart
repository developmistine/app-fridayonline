// To parse this JSON data, do
//
//     final mslregist = mslregistFromJson(jsonString);

// import 'package:meta/meta.dart';
import 'dart:convert';

Mslregist mslregistFromJson(String str) => Mslregist.fromJson(json.decode(str));

String mslregistToJson(Mslregist data) => json.encode(data.toJson());

class Mslregist {
  Mslregist({
    required this.value,
  });

  Value value;

  factory Mslregist.fromJson(Map<String, dynamic> json) => Mslregist(
        value: Value.fromJson(json["Value"]),
      );

  Map<String, dynamic> toJson() => {
        "Value": value.toJson(),
      };
}

class Value {
  Value({
    required this.success,
    required this.repSeq,
    required this.repCode,
    required this.repName,
    required this.typeUser,
    required this.imgPath,
    required this.ordernumber,
    required this.description,
  });

  String success;
  String repSeq;
  String repCode;
  String repName;
  String typeUser;
  String imgPath;
  String ordernumber;
  Description description;

  factory Value.fromJson(Map<String, dynamic> json) => Value(
        success: json["Success"] ?? "",
        repSeq: json["RepSeq"] ?? "",
        repCode: json["RepCode"] ?? "",
        repName: json["RepName"] ?? "",
        typeUser: json["TypeUser"] ?? "",
        imgPath: json["ImgPath"] ?? "",
        ordernumber: json["Ordernumber"] ?? "",
        description: Description.fromJson(json["Description"]),
      );

  Map<String, dynamic> toJson() => {
        "Success": success,
        "RepSeq": repSeq,
        "RepCode": repCode,
        "RepName": repName,
        "TypeUser": typeUser,
        "ImgPath": imgPath,
        "Ordernumber": ordernumber,
        "Description": description.toJson(),
      };
}

class Description {
  Description({
    required this.msg,
  });

  Msg msg;

  factory Description.fromJson(Map<String, dynamic> json) => Description(
        msg: Msg.fromJson(json["Msg"]),
      );

  Map<String, dynamic> toJson() => {
        "Msg": msg.toJson(),
      };
}

class Msg {
  Msg({
    required this.msgAlert1,
    required this.msgAlert2,
    required this.msgAlert3,
  });

  String msgAlert1;
  String msgAlert2;
  String msgAlert3;

  factory Msg.fromJson(Map<String, dynamic> json) => Msg(
        msgAlert1: json["MsgAlert1"] ?? "",
        msgAlert2: json["MsgAlert2"] ?? "",
        msgAlert3: json["MsgAlert3"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "MsgAlert1": msgAlert1,
        "MsgAlert2": msgAlert2,
        "MsgAlert3": msgAlert3,
      };
}
