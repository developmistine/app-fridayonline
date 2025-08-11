// To parse this JSON data, do
//
//     final responseMsl = responseMslFromJson(jsonString);

import 'dart:convert';

ResponseMsl responseMslFromJson(String str) =>
    ResponseMsl.fromJson(json.decode(str));

String responseMslToJson(ResponseMsl data) => json.encode(data.toJson());

class ResponseMsl {
  String code;
  String message;
  Info info;

  ResponseMsl({
    required this.code,
    required this.message,
    required this.info,
  });

  factory ResponseMsl.fromJson(Map<String, dynamic> json) => ResponseMsl(
        code: json["Code"],
        message: json["Message"],
        info: Info.fromJson(json["Info"]),
      );

  Map<String, dynamic> toJson() => {
        "Code": code,
        "Message": message,
        "Info": info.toJson(),
      };
}

class Info {
  String repseq;
  String name;
  String dist;
  String mslno;
  String chkdgt;
  String repcode;
  String mobileNo;
  String mailgroup;
  String schoolproject;
  String apptCampaign;
  String dateTimeNow;
  String billdate;
  String shipDate;
  String dlvDate;
  bool flagOtp;
  Address address;

  Info({
    required this.repseq,
    required this.name,
    required this.dist,
    required this.mslno,
    required this.chkdgt,
    required this.repcode,
    required this.mobileNo,
    required this.mailgroup,
    required this.schoolproject,
    required this.apptCampaign,
    required this.dateTimeNow,
    required this.billdate,
    required this.shipDate,
    required this.dlvDate,
    required this.flagOtp,
    required this.address,
  });

  factory Info.fromJson(Map<String, dynamic> json) => Info(
        repseq: json["Repseq"],
        name: json["Name"],
        dist: json["Dist"],
        mslno: json["Mslno"],
        chkdgt: json["Chkdgt"],
        repcode: json["Repcode"],
        mobileNo: json["MobileNo"],
        mailgroup: json["Mailgroup"],
        schoolproject: json["Schoolproject"],
        apptCampaign: json["ApptCampaign"],
        dateTimeNow: json["DateTimeNow"],
        billdate: json["Billdate"],
        shipDate: json["ShipDate"],
        dlvDate: json["DlvDate"],
        flagOtp: json["FlagOTP"],
        address: Address.fromJson(json["Address"]),
      );

  Map<String, dynamic> toJson() => {
        "Repseq": repseq,
        "Name": name,
        "Dist": dist,
        "Mslno": mslno,
        "Chkdgt": chkdgt,
        "Repcode": repcode,
        "MobileNo": mobileNo,
        "Mailgroup": mailgroup,
        "Schoolproject": schoolproject,
        "ApptCampaign": apptCampaign,
        "DateTimeNow": dateTimeNow,
        "Billdate": billdate,
        "ShipDate": shipDate,
        "DlvDate": dlvDate,
        "FlagOTP": flagOtp,
        "Address": address.toJson(),
      };
}

class Address {
  String address1;
  String address2;
  String tumbon;
  String amphur;
  String province;
  String postal;

  Address({
    required this.address1,
    required this.address2,
    required this.tumbon,
    required this.amphur,
    required this.province,
    required this.postal,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        address1: json["Address1"],
        address2: json["Address2"],
        tumbon: json["Tumbon"],
        amphur: json["Amphur"],
        province: json["Province"],
        postal: json["Postal"],
      );

  Map<String, dynamic> toJson() => {
        "Address1": address1,
        "Address2": address2,
        "Tumbon": tumbon,
        "Amphur": amphur,
        "Province": province,
        "Postal": postal,
      };
}
