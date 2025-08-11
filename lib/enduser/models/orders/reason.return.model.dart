import 'dart:convert';

ReturnReason returnReasonFromJson(String str) =>
    ReturnReason.fromJson(json.decode(str));

String returnReasonToJson(ReturnReason data) => json.encode(data.toJson());

class ReturnReason {
  String code;
  List<Datum> data;
  String message;

  ReturnReason({
    required this.code,
    required this.data,
    required this.message,
  });

  factory ReturnReason.fromJson(Map<String, dynamic> json) => ReturnReason(
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
  int returnId;
  String returnReason;
  bool imageFlag;
  bool isSelected;

  Datum({
    required this.returnId,
    required this.returnReason,
    required this.imageFlag,
    required this.isSelected,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        returnId: json["return_id"],
        returnReason: json["return_reason"],
        imageFlag: json["Image_flag"],
        isSelected: false,
      );

  Map<String, dynamic> toJson() => {
        "return_id": returnId,
        "return_reason": returnReason,
        "Image_flag": imageFlag,
        "isSelected": isSelected,
      };
}
