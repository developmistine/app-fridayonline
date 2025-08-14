// To parse this JSON data, do
//
//     final searchSuggest = searchSuggestFromJson(jsonString);

import 'dart:convert';

SearchSuggest searchSuggestFromJson(String str) =>
    SearchSuggest.fromJson(json.decode(str));

String searchSuggestToJson(SearchSuggest data) => json.encode(data.toJson());

class SearchSuggest {
  String code;
  List<Datum> data;
  String message;

  SearchSuggest({
    required this.code,
    required this.data,
    required this.message,
  });

  factory SearchSuggest.fromJson(Map<String, dynamic> json) => SearchSuggest(
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
  String keyword;
  String image;

  Datum({
    required this.keyword,
    required this.image,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        keyword: json["keyword"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "keyword": keyword,
        "image": image,
      };
}
