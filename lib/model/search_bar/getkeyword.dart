// To parse this JSON data, do
//
//     final KeySearch = KeySearchFromJson(jsonString);

// import 'package:meta/meta.dart';
import 'dart:convert';

List<KeySearch> KeySearchFromJson(String str) =>
    List<KeySearch>.from(json.decode(str).map((x) => KeySearch.fromJson(x)));

String KeySearchToJson(List<KeySearch> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class KeySearch {
  KeySearch({
    required this.keyWord,
  });

  String keyWord;

  factory KeySearch.fromJson(Map<String, dynamic> json) => KeySearch(
        keyWord: json["KeyWord"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "KeyWord": keyWord,
      };
}
