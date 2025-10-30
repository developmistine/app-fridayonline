// To parse this JSON data, do
//
//     final checkAppversion = checkAppversionFromJson(jsonString);

import 'dart:convert';

CheckAppversion checkAppversionFromJson(String str) =>
    CheckAppversion.fromJson(json.decode(str));

String checkAppversionToJson(CheckAppversion data) =>
    json.encode(data.toJson());

class CheckAppversion {
  int code;
  String message;
  Data data;

  CheckAppversion({
    required this.code,
    required this.message,
    required this.data,
  });

  factory CheckAppversion.fromJson(Map<String, dynamic> json) =>
      CheckAppversion(
        code: _parseInt(json["code"]),
        message: json["message"] ?? "",
        data: Data.fromJson(json["data"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  bool isForceUpdate;
  String latestVersion;
  String updateUrl;
  String releaseNote;

  Data({
    required this.isForceUpdate,
    required this.latestVersion,
    required this.updateUrl,
    required this.releaseNote,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        isForceUpdate: _parseBool(json["is_force_update"]),
        latestVersion: json["latest_version"] ?? "",
        updateUrl: json["update_url"] ?? "",
        releaseNote: json["release_note"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "is_force_update": isForceUpdate,
        "latest_version": latestVersion,
        "update_url": updateUrl,
        "release_note": releaseNote,
      };
}

/// Helper function to safely parse boolean values
/// Handles: bool, string ("true", "false", "1", "0"), int (0, 1)
bool _parseBool(dynamic value) {
  if (value == null) return false;

  if (value is bool) return value;

  if (value is int) return value != 0;

  if (value is String) {
    final lower = value.toLowerCase().trim();
    return lower == 'true' || lower == '1' || lower == 'yes';
  }

  return false;
}

/// Helper function to safely parse int values
/// Handles: int, string ("123"), double (123.0)
int _parseInt(dynamic value) {
  if (value == null) return 0;

  if (value is int) return value;

  if (value is double) return value.toInt();

  if (value is String) {
    try {
      return int.parse(value);
    } catch (e) {
      return 0;
    }
  }

  return 0;
}
