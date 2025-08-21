// To parse this JSON data, do
//
//     final b2CRegister = b2CRegisterFromJson(jsonString);

import 'dart:convert';

B2CRegister b2CRegisterFromJson(String str) =>
    B2CRegister.fromJson(json.decode(str));

String b2CRegisterToJson(B2CRegister data) => json.encode(data.toJson());

class B2CRegister {
  String registerId;
  String registerType;
  String moblie;
  String email;
  String prefix;
  String firstName;
  String lastName;
  String displayName;
  String image;
  String referringBrowser;
  String referringId;
  String gender;
  String birthDate;
  Address address;
  String tokenApp;
  String device;
  String sessionId;
  String identityId;
  String otpCode;
  String otpRef;

  B2CRegister(
      {required this.registerId,
      required this.registerType,
      required this.moblie,
      required this.email,
      required this.prefix,
      required this.firstName,
      required this.lastName,
      required this.displayName,
      required this.image,
      required this.referringBrowser,
      required this.referringId,
      required this.gender,
      required this.birthDate,
      required this.address,
      required this.tokenApp,
      required this.device,
      required this.sessionId,
      required this.identityId,
      required this.otpCode,
      required this.otpRef});

  factory B2CRegister.fromJson(Map<String, dynamic> json) => B2CRegister(
        registerId: json["register_id"],
        registerType: json["register_type"],
        moblie: json["moblie"],
        email: json["email"],
        prefix: json["prefix"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        displayName: json["display_name"],
        image: json["image"],
        referringBrowser: json["referring_browser"],
        referringId: json["referring_id"],
        gender: json["gender"],
        birthDate: json["birth_date"],
        address: Address.fromJson(json["address"]),
        tokenApp: json["token_app"],
        device: json["device"],
        sessionId: json["session_id"],
        identityId: json["identity_id"],
        otpCode: json["otp_code"],
        otpRef: json["otp_ref"],
      );

  Map<String, dynamic> toJson() => {
        "register_id": registerId,
        "register_type": registerType,
        "moblie": moblie,
        "email": email,
        "prefix": prefix,
        "first_name": firstName,
        "last_name": lastName,
        "display_name": displayName,
        "image": image,
        "referring_browser": referringBrowser,
        "referring_id": referringId,
        "gender": gender,
        "birth_date": birthDate,
        "address": address.toJson(),
        "token_app": tokenApp,
        "device": device,
        "session_id": sessionId,
        "identity_id": identityId,
        "otp_code": otpCode,
        "otp_ref": otpRef
      };
}

class Address {
  String firstName;
  String lastName;
  String address1;
  String address2;
  int tombonId;
  int amphurId;
  int provinceId;
  String postCode;
  String mobile;

  Address({
    required this.firstName,
    required this.lastName,
    required this.address1,
    required this.address2,
    required this.tombonId,
    required this.amphurId,
    required this.provinceId,
    required this.postCode,
    required this.mobile,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        firstName: json["first_name"],
        lastName: json["last_name"],
        address1: json["address_1"],
        address2: json["address_2"],
        tombonId: json["tombon_id"],
        amphurId: json["amphur_id"],
        provinceId: json["province_id"],
        postCode: json["post_code"],
        mobile: json["mobile"],
      );

  Map<String, dynamic> toJson() => {
        "first_name": firstName,
        "last_name": lastName,
        "address_1": address1,
        "address_2": address2,
        "tombon_id": tombonId,
        "amphur_id": amphurId,
        "province_id": provinceId,
        "post_code": postCode,
        "mobile": mobile,
      };
}
