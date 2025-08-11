// To parse this JSON data, do
//
//     final enduserGetDetailDelivery = enduserGetDetailDeliveryFromJson(jsonString);

import 'dart:convert';

EnduserGetDetailDelivery enduserGetDetailDeliveryFromJson(String str) =>
    EnduserGetDetailDelivery.fromJson(json.decode(str));

String enduserGetDetailDeliveryToJson(EnduserGetDetailDelivery data) =>
    json.encode(data.toJson());

class EnduserGetDetailDelivery {
  ToDetail toEusDetail;
  ToDetail toMslDetail;

  EnduserGetDetailDelivery({
    required this.toEusDetail,
    required this.toMslDetail,
  });

  factory EnduserGetDetailDelivery.fromJson(Map<String, dynamic> json) =>
      EnduserGetDetailDelivery(
        toEusDetail: ToDetail.fromJson(json["ToEusDetail"]),
        toMslDetail: ToDetail.fromJson(json["ToMslDetail"]),
      );

  Map<String, dynamic> toJson() => {
        "ToEusDetail": toEusDetail.toJson(),
        "ToMslDetail": toMslDetail.toJson(),
      };
}

class ToDetail {
  String textHeader;
  String textDetail;
  bool isChange;

  ToDetail({
    required this.textHeader,
    required this.textDetail,
    required this.isChange,
  });

  factory ToDetail.fromJson(Map<String, dynamic> json) => ToDetail(
        textHeader: json["TextHeader"],
        textDetail: json["TextDetail"],
        isChange: json["IsChange"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "TextHeader": textHeader,
        "TextDetail": textDetail,
        "IsChange": isChange,
      };
}
