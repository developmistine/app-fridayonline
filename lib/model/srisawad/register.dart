// To parse this JSON data, do
//
//     final srisawadRegister = srisawadRegisterFromJson(jsonString);

import 'dart:convert';

SrisawadRegister srisawadRegisterFromJson(String str) =>
    SrisawadRegister.fromJson(json.decode(str));

String srisawadRegisterToJson(SrisawadRegister data) =>
    json.encode(data.toJson());

class SrisawadRegister {
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
  String linkId;
  String webId;
  String referralCode;

  SrisawadRegister({
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
    required this.linkId,
    required this.webId,
    required this.referralCode,
  });

  factory SrisawadRegister.fromJson(Map<String, dynamic> json) =>
      SrisawadRegister(
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
        linkId: json["link_id"],
        webId: json["web_id"],
        referralCode: json["referral_code"],
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
        "link_id": linkId,
        "web_id": webId,
        "referral_code": referralCode,
      };
}

class Address {
  String address;
  String provinceCode;
  String province;
  String amphurCode;
  String amphur;
  String tambonCode;
  String tambon;
  String postalCode;

  Address({
    required this.address,
    required this.provinceCode,
    required this.province,
    required this.amphurCode,
    required this.amphur,
    required this.tambonCode,
    required this.tambon,
    required this.postalCode,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        address: json["address"],
        provinceCode: json["province_code"],
        province: json["province"],
        amphurCode: json["amphur_code"],
        amphur: json["amphur"],
        tambonCode: json["tambon_code"],
        tambon: json["tambon"],
        postalCode: json["postal_code"],
      );

  Map<String, dynamic> toJson() => {
        "address": address,
        "province_code": provinceCode,
        "province": province,
        "amphur_code": amphurCode,
        "amphur": amphur,
        "tambon_code": tambonCode,
        "tambon": tambon,
        "postal_code": postalCode,
      };
}
