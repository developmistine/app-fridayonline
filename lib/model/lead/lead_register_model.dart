// To parse this JSON data, do
//
//     final leadRegisterModel = leadRegisterModelFromJson(jsonString);

import 'dart:convert';

LeadRegisterModel leadRegisterModelFromJson(String str) =>
    LeadRegisterModel.fromJson(json.decode(str));

String leadRegisterModelToJson(LeadRegisterModel data) =>
    json.encode(data.toJson());

class LeadRegisterModel {
  String tokenId;
  String name;
  String surname;
  String nickname;
  String phone1;
  String phone2;
  Address address;
  String device;
  String typeRegister;
  String pdpaMkt;
  String pdpaCustomer;
  String pathImg;
  int apptSourceId;
  String linkId;
  String webId;

  LeadRegisterModel({
    required this.tokenId,
    required this.name,
    required this.surname,
    required this.nickname,
    required this.phone1,
    required this.phone2,
    required this.address,
    required this.device,
    required this.typeRegister,
    required this.pdpaMkt,
    required this.pdpaCustomer,
    required this.pathImg,
    required this.apptSourceId,
    required this.linkId,
    required this.webId,
  });

  factory LeadRegisterModel.fromJson(Map<String, dynamic> json) =>
      LeadRegisterModel(
        tokenId: json["token_id"],
        name: json["name"],
        surname: json["surname"],
        nickname: json["nickname"],
        phone1: json["phone1"],
        phone2: json["phone2"],
        address: Address.fromJson(json["address"]),
        device: json["device"],
        typeRegister: json["type_register"],
        pdpaMkt: json["pdpa_mkt"],
        pdpaCustomer: json["pdpa_customer"],
        pathImg: json["path_img"],
        apptSourceId: json["appt_source_id"],
        linkId: json["link_id"],
        webId: json["web_id"],
      );

  Map<String, dynamic> toJson() => {
        "token_id": tokenId,
        "name": name,
        "surname": surname,
        "nickname": nickname,
        "phone1": phone1,
        "phone2": phone2,
        "address": address.toJson(),
        "device": device,
        "type_register": typeRegister,
        "pdpa_mkt": pdpaMkt,
        "pdpa_customer": pdpaCustomer,
        "path_img": pathImg,
        "appt_source_id": apptSourceId,
        "link_id": linkId,
        "web_id": webId,
      };
}

class Address {
  String address;
  String road;
  String province;
  String provinceCode;
  String amphur;
  String amphurCode;
  String tambon;
  String tambonCode;
  String postalCode;

  Address({
    required this.address,
    required this.road,
    required this.province,
    required this.provinceCode,
    required this.amphur,
    required this.amphurCode,
    required this.tambon,
    required this.tambonCode,
    required this.postalCode,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        address: json["address"],
        road: json["road"],
        province: json["province"],
        provinceCode: json["province_code"],
        amphur: json["amphur"],
        amphurCode: json["amphur_code"],
        tambon: json["tambon"],
        tambonCode: json["tambon_code"],
        postalCode: json["postal_code"],
      );

  Map<String, dynamic> toJson() => {
        "address": address,
        "road": road,
        "province": province,
        "province_code": provinceCode,
        "amphur": amphur,
        "amphur_code": amphurCode,
        "tambon": tambon,
        "tambon_code": tambonCode,
        "postal_code": postalCode,
      };
}
