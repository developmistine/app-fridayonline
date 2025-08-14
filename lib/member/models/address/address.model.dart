// To parse this JSON data, do
//
//     final addressList = addressListFromJson(jsonString);

import 'dart:convert';

AddressList addressListFromJson(String str) =>
    AddressList.fromJson(json.decode(str));

String addressListToJson(AddressList data) => json.encode(data.toJson());

class AddressList {
  String code;
  List<Datum> data;
  String message;

  AddressList({
    required this.code,
    required this.data,
    required this.message,
  });

  factory AddressList.fromJson(Map<String, dynamic> json) => AddressList(
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
  int id;
  bool isDeliveryAddress;
  String label;
  String firstName;
  String lastName;
  String name;
  String phone;
  String address1;
  String address2;
  int districtId;
  String district;
  int cityId;
  String city;
  int stateId;
  String state;
  String zipcode;
  String country;
  String address;
  int status;

  Datum({
    required this.id,
    required this.isDeliveryAddress,
    required this.label,
    required this.firstName,
    required this.lastName,
    required this.name,
    required this.phone,
    required this.address1,
    required this.address2,
    required this.districtId,
    required this.district,
    required this.cityId,
    required this.city,
    required this.stateId,
    required this.state,
    required this.zipcode,
    required this.country,
    required this.address,
    required this.status,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        isDeliveryAddress: json["is_delivery_address"],
        label: json["label"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        name: json["name"],
        phone: json["phone"],
        address1: json["address_1"],
        address2: json["address_2"],
        districtId: json["district_id"],
        district: json["district"],
        cityId: json["city_id"],
        city: json["city"],
        stateId: json["state_id"],
        state: json["state"],
        zipcode: json["zipcode"],
        country: json["country"],
        address: json["address"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "is_delivery_address": isDeliveryAddress,
        "label": label,
        "first_name": firstName,
        "last_name": lastName,
        "name": name,
        "phone": phone,
        "address_1": address1,
        "address_2": address2,
        "district_id": districtId,
        "district": district,
        "city_id": cityId,
        "city": city,
        "state_id": stateId,
        "state": state,
        "zipcode": zipcode,
        "country": country,
        "address": address,
        "status": status,
      };
}
