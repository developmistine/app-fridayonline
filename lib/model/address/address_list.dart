import 'dart:convert';

AddressList addressListFromJson(String str) =>
    AddressList.fromJson(json.decode(str));

String addressListToJson(AddressList data) => json.encode(data.toJson());

class AddressList {
  int code;
  String message;
  List<Datum> data;

  AddressList({
    required this.code,
    required this.message,
    required this.data,
  });

  factory AddressList.fromJson(Map<String, dynamic> json) => AddressList(
        code: json["code"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  int msladdrId;
  int repSeq;
  String addrtype;
  int seqno;
  String shortName;
  String addrline1;
  String addrline2;
  String addrline3;
  String tumbonId;
  String tumbonCode;
  String tumbonName;
  String amphurId;
  String amphurCode;
  String amphurName;
  String provinceId;
  String provinceCode;
  String provinceName;
  String postalCode;
  String mobileNo;
  String mobile2;
  String faxNo;
  String deliverContact;
  String deliveryNote;
  String headoffice;
  String branch;
  String enduserId;
  String defaultFlag;

  Datum({
    required this.msladdrId,
    required this.repSeq,
    required this.addrtype,
    required this.seqno,
    required this.shortName,
    required this.addrline1,
    required this.addrline2,
    required this.addrline3,
    required this.tumbonId,
    required this.tumbonCode,
    required this.tumbonName,
    required this.amphurId,
    required this.amphurCode,
    required this.amphurName,
    required this.provinceId,
    required this.provinceCode,
    required this.provinceName,
    required this.postalCode,
    required this.mobileNo,
    required this.mobile2,
    required this.faxNo,
    required this.deliverContact,
    required this.deliveryNote,
    required this.headoffice,
    required this.branch,
    required this.enduserId,
    required this.defaultFlag,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        msladdrId: json["msladdr_id"],
        repSeq: json["rep_seq"],
        addrtype: json["addrtype"],
        seqno: json["seqno"],
        shortName: json["short_name"],
        addrline1: json["addrline1"],
        addrline2: json["addrline2"],
        addrline3: json["addrline3"],
        tumbonId: json["tumbon_id"],
        tumbonCode: json["tumbon_code"],
        tumbonName: json["tumbon_name"],
        amphurId: json["amphur_id"],
        amphurCode: json["amphur_code"],
        amphurName: json["amphur_name"],
        provinceId: json["province_id"],
        provinceCode: json["province_code"],
        provinceName: json["province_name"],
        postalCode: json["postal_code"],
        mobileNo: json["mobile_no"],
        mobile2: json["mobile2"],
        faxNo: json["fax_no"],
        deliverContact: json["deliver_contact"],
        deliveryNote: json["delivery_note"],
        headoffice: json["headoffice"],
        branch: json["branch"],
        enduserId: json["enduser_id"],
        defaultFlag: json["default_flag"],
      );

  Map<String, dynamic> toJson() => {
        "msladdr_id": msladdrId,
        "rep_seq": repSeq,
        "addrtype": addrtype,
        "seqno": seqno,
        "short_name": shortName,
        "addrline1": addrline1,
        "addrline2": addrline2,
        "addrline3": addrline3,
        "tumbon_id": tumbonId,
        "tumbon_code": tumbonCode,
        "tumbon_name": tumbonName,
        "amphur_id": amphurId,
        "amphur_code": amphurCode,
        "amphur_name": amphurName,
        "province_id": provinceId,
        "province_code": provinceCode,
        "province_name": provinceName,
        "postal_code": postalCode,
        "mobile_no": mobileNo,
        "mobile2": mobile2,
        "fax_no": faxNo,
        "deliver_contact": deliverContact,
        "delivery_note": deliveryNote,
        "headoffice": headoffice,
        "branch": branch,
        "enduser_id": enduserId,
        "default_flag": defaultFlag,
      };
}
