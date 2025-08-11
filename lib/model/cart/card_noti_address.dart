// To parse this JSON data, do
//
//     final notifyAddress = notifyAddressFromJson(jsonString);

import 'dart:convert';

NotifyAddress notifyAddressFromJson(String str) =>
    NotifyAddress.fromJson(json.decode(str));

String notifyAddressToJson(NotifyAddress data) => json.encode(data.toJson());

class NotifyAddress {
  String type;
  String detail;

  NotifyAddress({
    required this.type,
    required this.detail,
  });

  factory NotifyAddress.fromJson(Map<String, dynamic> json) => NotifyAddress(
        type: json["Type"],
        detail: json["Detail"],
      );

  Map<String, dynamic> toJson() => {
        "Type": type,
        "Detail": detail,
      };
}
