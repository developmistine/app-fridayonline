// To parse this JSON data, do
//
//     final dropshipGetAddress = dropshipGetAddressFromJson(jsonString);

// import 'package:meta/meta.dart';
import 'dart:convert';

DropshipGetAddress dropshipGetAddressFromJson(String str) =>
    DropshipGetAddress.fromJson(json.decode(str));

String dropshipGetAddressToJson(DropshipGetAddress data) =>
    json.encode(data.toJson());

class DropshipGetAddress {
  DropshipGetAddress({
    required this.repCode,
    required this.repSeq,
    required this.repType,
    required this.address,
  });

  String repCode;
  String repSeq;
  String repType;
  List<Address> address;

  factory DropshipGetAddress.fromJson(Map<String, dynamic> json) =>
      DropshipGetAddress(
        repCode: json["RepCode"] ?? "",
        repSeq: json["RepSeq"] ?? "",
        repType: json["RepType"] ?? "",
        address: json["Address"] == null
            ? []
            : List<Address>.from(
                json["Address"].map((x) => Address.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "RepCode": repCode,
        "RepSeq": repSeq,
        "RepType": repType,
        "Address": List<dynamic>.from(address.map((x) => x.toJson())),
      };
}

class Address {
  Address({
    required this.addressId,
    required this.addressType,
    required this.nameReceive,
    required this.mobileNo,
    required this.addressLine1,
    required this.addressLine2,
    required this.nameTumbon,
    required this.nameAmphur,
    required this.nameProvince,
    required this.tumbonCode,
    required this.amphurCode,
    required this.provinceCode,
    required this.postCode,
    required this.areaType,
  });

  String addressId;
  String addressType;
  String nameReceive;
  String mobileNo;
  String addressLine1;
  String addressLine2;
  String nameTumbon;
  String nameAmphur;
  String nameProvince;
  String tumbonCode;
  String amphurCode;
  String provinceCode;
  String postCode;
  String areaType;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        addressId: json["AddressId"] ?? "",
        addressType: json["AddressType"] ?? "",
        nameReceive: json["NameReceive"] ?? "",
        mobileNo: json["MobileNo"] ?? "",
        addressLine1: json["AddressLine1"] ?? "",
        addressLine2: json["AddressLine2"] ?? "",
        nameTumbon: json["NameTumbon"] ?? "",
        nameAmphur: json["NameAmphur"] ?? "",
        nameProvince: json["NameProvince"] ?? "",
        tumbonCode: json["TumbonCode"] ?? "",
        amphurCode: json["AmphurCode"] ?? "",
        provinceCode: json["ProvinceCode"] ?? "",
        postCode: json["PostCode"] ?? "",
        areaType: json["AreaType"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "AddressId": addressId,
        "AddressType": addressType,
        "NameReceive": nameReceive,
        "MobileNo": mobileNo,
        "AddressLine1": addressLine1,
        "AddressLine2": addressLine2,
        "NameTumbon": nameTumbon,
        "NameAmphur": nameAmphur,
        "NameProvince": nameProvince,
        "TumbonCode": tumbonCode,
        "AmphurCode": amphurCode,
        "ProvinceCode": provinceCode,
        "PostCode": postCode,
        "AreaType": areaType,
      };
}
