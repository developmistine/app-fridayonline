// To parse this JSON data, do
//
//     final b2CAddress = b2CAddressFromJson(jsonString);

import 'dart:convert';

B2CAddress b2CAddressFromJson(String str) =>
    B2CAddress.fromJson(json.decode(str));

String b2CAddressToJson(B2CAddress data) => json.encode(data.toJson());

class B2CAddress {
  String code;
  List<Datum> data;

  B2CAddress({
    required this.code,
    required this.data,
  });

  factory B2CAddress.fromJson(Map<String, dynamic> json) => B2CAddress(
        code: json["code"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  int provinceId;
  String provinceCode;
  String provinceName;
  List<Amphur> amphur;

  Datum({
    required this.provinceId,
    required this.provinceCode,
    required this.provinceName,
    required this.amphur,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        provinceId: json["province_id"],
        provinceCode: json["province_code"],
        provinceName: json["province_name"],
        amphur:
            List<Amphur>.from(json["amphur"].map((x) => Amphur.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "province_id": provinceId,
        "province_code": provinceCode,
        "province_name": provinceName,
        "amphur": List<dynamic>.from(amphur.map((x) => x.toJson())),
      };
}

class Amphur {
  int amphurId;
  String amphurCode;
  String amphurName;
  List<Tambon> tambon;

  Amphur({
    required this.amphurId,
    required this.amphurCode,
    required this.amphurName,
    required this.tambon,
  });

  factory Amphur.fromJson(Map<String, dynamic> json) => Amphur(
        amphurId: json["amphur_id"],
        amphurCode: json["amphur_code"],
        amphurName: json["amphur_name"],
        tambon:
            List<Tambon>.from(json["tambon"].map((x) => Tambon.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "amphur_id": amphurId,
        "amphur_code": amphurCode,
        "amphur_name": amphurName,
        "tambon": List<dynamic>.from(tambon.map((x) => x.toJson())),
      };
}

class Tambon {
  int tambonId;
  String tambonCode;
  String tambonName;
  String postCode;

  Tambon({
    required this.tambonId,
    required this.tambonCode,
    required this.tambonName,
    required this.postCode,
  });

  factory Tambon.fromJson(Map<String, dynamic> json) => Tambon(
        tambonId: json["tambon_id"],
        tambonCode: json["tambon_code"],
        tambonName: json["tambon_name"],
        postCode: json["post_code"],
      );

  Map<String, dynamic> toJson() => {
        "tambon_id": tambonId,
        "tambon_code": tambonCode,
        "tambon_name": tambonName,
        "post_code": postCode,
      };
}
