// To parse this JSON data, do
//
//     final saveOrder = saveOrderFromJson(jsonString);

// import 'package:meta/meta.dart';
import 'dart:convert';

SaveOrder saveOrderFromJson(String str) => SaveOrder.fromJson(json.decode(str));

String saveOrderToJson(SaveOrder data) => json.encode(data.toJson());

class SaveOrder {
  SaveOrder({
    required this.value,
  });

  Value value;

  factory SaveOrder.fromJson(Map<String, dynamic> json) => SaveOrder(
        value: Value.fromJson(json["Value"]),
      );

  Map<String, dynamic> toJson() => {
        "Value": value.toJson(),
      };
}

class Value {
  Value({
    required this.success,
    required this.ordernumber,
    required this.description,
  });

  String success;
  String ordernumber;
  Description description;

  factory Value.fromJson(Map<String, dynamic> json) => Value(
        success: json["success"],
        ordernumber: json["ordernumber"],
        description: Description.fromJson(json["description"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "ordernumber": ordernumber,
        "description": description.toJson(),
      };
}

class Description {
  Description({
    required this.msgAlert1,
    required this.msgAlert2,
    required this.msgAlert3,
  });

  String msgAlert1;
  String msgAlert2;
  String msgAlert3;

  factory Description.fromJson(Map<String, dynamic> json) => Description(
        msgAlert1: json["MsgAlert1"],
        msgAlert2: json["MsgAlert2"],
        msgAlert3: json["MsgAlert3"],
      );

  Map<String, dynamic> toJson() => {
        "MsgAlert1": msgAlert1,
        "MsgAlert2": msgAlert2,
        "MsgAlert3": msgAlert3,
      };
}
