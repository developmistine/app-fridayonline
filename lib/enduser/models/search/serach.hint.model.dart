// To parse this JSON data, do
//
//     final searchHint = searchHintFromJson(jsonString);

import 'dart:convert';

SearchHint searchHintFromJson(String str) =>
    SearchHint.fromJson(json.decode(str));

String searchHintToJson(SearchHint data) => json.encode(data.toJson());

class SearchHint {
  String code;
  List<SearchData> data;
  String message;

  SearchHint({
    required this.code,
    required this.data,
    required this.message,
  });

  factory SearchHint.fromJson(Map<String, dynamic> json) => SearchHint(
        code: json["code"],
        data: List<SearchData>.from(
            json["data"].map((x) => SearchData.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
      };
}

class SearchData {
  String keyword;

  SearchData({
    required this.keyword,
  });

  factory SearchData.fromJson(Map<String, dynamic> json) => SearchData(
        keyword: json["keyword"],
      );

  Map<String, dynamic> toJson() => {
        "keyword": keyword,
      };
}
