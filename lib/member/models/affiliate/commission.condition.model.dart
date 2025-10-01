// To parse this JSON data, do
//
//     final affiliateCondition = affiliateConditionFromJson(jsonString);

import 'dart:convert';

AffiliateCondition affiliateConditionFromJson(String str) =>
    AffiliateCondition.fromJson(json.decode(str));

String affiliateConditionToJson(AffiliateCondition data) =>
    json.encode(data.toJson());

class AffiliateCondition {
  String code;
  List<AffiliateConditionData> data;
  String message;

  AffiliateCondition({
    required this.code,
    required this.data,
    required this.message,
  });

  factory AffiliateCondition.fromJson(Map<String, dynamic> json) =>
      AffiliateCondition(
        code: json["code"],
        data: List<AffiliateConditionData>.from(
            json["data"].map((x) => AffiliateConditionData.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
      };
}

class AffiliateConditionData {
  String key;
  List<String> value;

  AffiliateConditionData({
    required this.key,
    required this.value,
  });

  factory AffiliateConditionData.fromJson(Map<String, dynamic> json) =>
      AffiliateConditionData(
        key: json["key"],
        value: List<String>.from(json["value"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "value": List<dynamic>.from(value.map((x) => x)),
      };
}
