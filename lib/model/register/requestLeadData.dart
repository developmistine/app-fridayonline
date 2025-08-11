// To parse this JSON data, do
//
//     final requestLeadData = requestLeadDataFromJson(jsonString);
import 'dart:convert';

RequestLeadData requestLeadDataFromJson(String str) =>
    RequestLeadData.fromJson(json.decode(str));

String requestLeadDataToJson(RequestLeadData data) =>
    json.encode(data.toJson());

class RequestLeadData {
  RequestLeadData({
    required this.request,
  });

  Request request;

  factory RequestLeadData.fromJson(Map<String, dynamic> json) =>
      RequestLeadData(
        request: Request.fromJson(json["Request"]),
      );

  Map<String, dynamic> toJson() => {
        "Request": request.toJson(),
      };
}

class Request {
  Request({
    required this.master,
    required this.description,
  });

  Master master;
  Description description;

  factory Request.fromJson(Map<String, dynamic> json) => Request(
        master: Master.fromJson(json["Master"]),
        description: Description.fromJson(json["Description"]),
      );

  Map<String, dynamic> toJson() => {
        "Master": master.toJson(),
        "Description": description.toJson(),
      };
}

class Description {
  Description({
    required this.msl,
  });

  Msl msl;

  factory Description.fromJson(Map<String, dynamic> json) => Description(
        msl: Msl.fromJson(json["MSL"]),
      );

  Map<String, dynamic> toJson() => {
        "MSL": msl.toJson(),
      };
}

class Msl {
  Msl({
    required this.body1,
  });

  Body1 body1;

  factory Msl.fromJson(Map<String, dynamic> json) => Msl(
        body1: Body1.fromJson(json["Body1"]),
      );

  Map<String, dynamic> toJson() => {
        "Body1": body1.toJson(),
      };
}

class Body1 {
  Body1({
    required this.name,
    required this.surName,
    required this.nickName,
    required this.phone1,
    required this.phone2,
    required this.address,
    required this.road,
    required this.provinceId,
    required this.amphurId,
    required this.tumbolId,
    required this.postalCode,
    required this.districtKey,
    required this.districtCode,
    required this.masterArea,
    required this.typeRegister,
    required this.leadOnlineFlag,
    required this.appMkt,
    required this.appCustomer,
    required this.pathImg,
  });

  String name;
  String surName;
  String nickName;
  String phone1;
  String phone2;
  String address;
  String road;
  String provinceId;
  String amphurId;
  String tumbolId;
  String postalCode;
  String districtKey;
  String districtCode;
  String masterArea;
  String typeRegister;
  String leadOnlineFlag;
  String appMkt;
  String appCustomer;
  String pathImg;

  factory Body1.fromJson(Map<String, dynamic> json) => Body1(
        name: json["Name"] ?? "",
        surName: json["SurName"] ?? "",
        nickName: json["NickName"] ?? "",
        phone1: json["Phone1"] ?? "",
        phone2: json["Phone2"] ?? "",
        address: json["Address"] ?? "",
        road: json["Road"] ?? "",
        provinceId: json["ProvinceId"] ?? "",
        amphurId: json["AmphurId"] ?? "",
        tumbolId: json["TumbolId"] ?? "",
        postalCode: json["PostalCode"] ?? "",
        districtKey: json["DistrictKey"] ?? "",
        districtCode: json["DistrictCode"] ?? "",
        masterArea: json["MasterArea"] ?? "",
        typeRegister: json["TypeRegister"] ?? "",
        leadOnlineFlag: json["LeadOnlineFlag"] ?? "",
        appMkt: json["app_mkt"] ?? "",
        appCustomer: json["app_customer"] ?? "",
        pathImg: json["PathImg"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "Name": name,
        "SurName": surName,
        "NickName": nickName,
        "Phone1": phone1,
        "Phone2": phone2,
        "Address": address,
        "Road": road,
        "ProvinceId": provinceId,
        "AmphurId": amphurId,
        "TumbolId": tumbolId,
        "PostalCode": postalCode,
        "DistrictKey": districtKey,
        "DistrictCode": districtCode,
        "MasterArea": masterArea,
        "TypeRegister": typeRegister,
        "LeadOnlineFlag": leadOnlineFlag,
        "app_mkt": appMkt,
        "app_customer": appCustomer,
        "PathImg": pathImg,
      };
}

class Master {
  Master({
    required this.repSeq,
    required this.deviceId,
    required this.tokenId,
    required this.websiteId,
  });

  String repSeq;
  String deviceId;
  String tokenId;
  String websiteId;

  factory Master.fromJson(Map<String, dynamic> json) => Master(
        repSeq: json["RepSeq"] ?? "",
        deviceId: json["DeviceId"] ?? "",
        tokenId: json["TokenId"] ?? "",
        websiteId: json["WebsiteID"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "RepSeq": repSeq,
        "DeviceId": deviceId,
        "TokenId": tokenId,
        "WebsiteID": websiteId,
      };
}
