// To parse this JSON data, do
//
//     final endUserAddressData = endUserAddressDataFromJson(jsonString);

import 'dart:convert';

EndUserAddressData endUserAddressDataFromJson(String str) =>
    EndUserAddressData.fromJson(json.decode(str));

String endUserAddressDataToJson(EndUserAddressData data) =>
    json.encode(data.toJson());

class EndUserAddressData {
  String id;
  String enduserId;
  String name;
  String telnumber;
  String type;
  String address1;
  String address2;
  String provinceCode;
  String amphurCode;
  String tumbonCode;
  String provinceName;
  String amphurName;
  String tumbonName;
  String postalcode;
  String note;
  String status;
  String channel;

  EndUserAddressData({
    required this.id,
    required this.enduserId,
    required this.name,
    required this.telnumber,
    required this.type,
    required this.address1,
    required this.address2,
    required this.provinceCode,
    required this.amphurCode,
    required this.tumbonCode,
    required this.provinceName,
    required this.amphurName,
    required this.tumbonName,
    required this.postalcode,
    required this.note,
    required this.status,
    required this.channel,
  });

  factory EndUserAddressData.fromJson(Map<String, dynamic> json) =>
      EndUserAddressData(
        id: json["id"],
        enduserId: json["enduser_id"],
        name: json["name"],
        telnumber: json["telnumber"],
        type: json["type"],
        address1: json["address1"],
        address2: json["address2"],
        provinceCode: json["province_code"],
        amphurCode: json["amphur_code"],
        tumbonCode: json["tumbon_code"],
        provinceName: json["province_name"],
        amphurName: json["amphur_name"],
        tumbonName: json["tumbon_name"],
        postalcode: json["postalcode"],
        note: json["note"],
        status: json["status"],
        channel: json["channel"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "enduser_id": enduserId,
        "name": name,
        "telnumber": telnumber,
        "type": type,
        "address1": address1,
        "address2": address2,
        "province_code": provinceCode,
        "amphur_code": amphurCode,
        "tumbon_code": tumbonCode,
        "province_name": provinceName,
        "amphur_name": amphurName,
        "tumbon_name": tumbonName,
        "postalcode": postalcode,
        "note": note,
        "status": status,
        "channel": channel,
      };
}
