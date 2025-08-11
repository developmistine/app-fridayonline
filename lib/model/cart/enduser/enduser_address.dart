// To parse this JSON data, do
//
//     final endUserAddress = endUserAddressFromJson(jsonString);

import 'dart:convert';

EndUserAddress endUserAddressFromJson(String str) =>
    EndUserAddress.fromJson(json.decode(str));

String endUserAddressToJson(EndUserAddress data) => json.encode(data.toJson());

class EndUserAddress {
  AryAddress primaryAddress;
  List<AryAddress> secondaryAddress;

  EndUserAddress({
    required this.primaryAddress,
    required this.secondaryAddress,
  });

  factory EndUserAddress.fromJson(Map<String, dynamic> json) => EndUserAddress(
        primaryAddress: AryAddress.fromJson(json["primary_address"]),
        secondaryAddress: List<AryAddress>.from(
            json["secondary_address"].map((x) => AryAddress.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "primary_address": primaryAddress.toJson(),
        "secondary_address":
            List<dynamic>.from(secondaryAddress.map((x) => x.toJson())),
      };
}

class AryAddress {
  String id;
  String enduserId;
  String name;
  String telnumber;
  String type;
  String address1;
  String address2;
  String provinceId;
  String amphurId;
  String tumbonId;
  String provinceName;
  String amphurName;
  String tumbonName;
  String postalcode;
  String note;

  AryAddress({
    required this.id,
    required this.enduserId,
    required this.name,
    required this.telnumber,
    required this.type,
    required this.address1,
    required this.address2,
    required this.provinceId,
    required this.amphurId,
    required this.tumbonId,
    required this.provinceName,
    required this.amphurName,
    required this.tumbonName,
    required this.postalcode,
    required this.note,
  });

  factory AryAddress.fromJson(Map<String, dynamic> json) => AryAddress(
        id: json["id"],
        enduserId: json["enduser_id"],
        name: json["name"],
        telnumber: json["telnumber"],
        type: json["type"],
        address1: json["address1"],
        address2: json["address2"],
        provinceId: json["province_id"],
        amphurId: json["amphur_id"],
        tumbonId: json["tumbon_id"],
        provinceName: json["province_name"],
        amphurName: json["amphur_name"],
        tumbonName: json["tumbon_name"],
        postalcode: json["postalcode"],
        note: json["note"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "enduser_id": enduserId,
        "name": name,
        "telnumber": telnumber,
        "type": type,
        "address1": address1,
        "address2": address2,
        "province_id": provinceId,
        "amphur_id": amphurId,
        "tumbon_id": tumbonId,
        "province_name": provinceName,
        "amphur_name": amphurName,
        "tumbon_name": tumbonName,
        "postalcode": postalcode,
        "note": note,
      };
}
