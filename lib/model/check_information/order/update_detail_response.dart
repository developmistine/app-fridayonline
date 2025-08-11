// To parse this JSON data, do
//
//     final responseUpdateDetail = responseUpdateDetailFromJson(jsonString);

import 'dart:convert';

ResponseUpdateDetail responseUpdateDetailFromJson(String str) => ResponseUpdateDetail.fromJson(json.decode(str));

String responseUpdateDetailToJson(ResponseUpdateDetail data) => json.encode(data.toJson());

class ResponseUpdateDetail {
    ResponseUpdateDetail({
        required this.values,
        required this.description1,
        required this.description2,
    });

    String values;
    String description1;
    String description2;

    factory ResponseUpdateDetail.fromJson(Map<String, dynamic> json) => ResponseUpdateDetail(
        values: json["Values"] ?? "",
        description1: json["Description1"] ?? "",
        description2: json["Description2"] ?? "",
    );

    Map<String, dynamic> toJson() => {
        "Values": values,
        "Description1": description1,
        "Description2": description2,
    };
}
