// ignore_for_file: avoid_print

import 'dart:convert';

import '../../model/check_version/check_transferdist.dart';
import '../../model/check_version/check_version_model.dart';
import '../../model/set_data/set_data.dart';
import 'package:http/http.dart' as http;

import '../pathapi.dart';

Future<CheckVersionModel?> call_check_version() async {
  SetData data = SetData(); //เรียกใช้ model
  try {
    var url = Uri.parse("${base_api_app}api/v1/config/MyVersion");
    // var url = Uri.parse(
    //     "${baseurl_pathapi}api/apiserviceyupin/GetVersion/type/value");
    var jsonData = jsonEncode({
      "UserType": await data.repType,
      "UserSeq": await data.repSeq,
      "Latitude": "",
      "Longitude": "",
      "RegistrationID": await data.tokenId,
      "Device": await data.device
    });

    var jsonCall = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonData);

    var jsonResponse = jsonCall.body;
    CheckVersionModel checkversion = checkVersionModelFromJson(jsonResponse);

    return checkversion;
  } catch (e) {
    print('Error function >>call_check_version<< is $e');
    var json = jsonEncode({
      "Version": {
        "Code": "version_code",
        "Value": "53",
        "Extra": "major",
        "AndroidVersion": {
          "isMaintain": "false",
          "maintainDetail": "Server Maintainance.Please wait few minutes.",
          "uriMaintenance": "",
          "isForceUpdate": "1",
          "versionCode": "0",
          "uriPlayStore":
              "https://play.google.com/store/apps/details?id=th.co.mistine.mistinecatalog",
          "showAlert": "true",
          "alertShowTitle": "Friday: ปรับปรุงเวอร์ชัน",
          "alertShowDetail": "กรุณาอัปเดตเวอร์ชันปัจจุบันค่ะ..",
          "contentHilightStatus": "Y",
          "Showpopup": "Y",
          "uriItunes": ""
        },
        "HuaweiVersion": {
          "isMaintain": "false",
          "maintainDetail": "Server Maintainance.Please wait few minutes.",
          "uriMaintenance": "",
          "isForceUpdate": "1",
          "versionCode": "0",
          "uriPlayStore": "https://appgallery.huawei.com/app/C102878081",
          "showAlert": "true",
          "alertShowTitle": "Friday : ปรับปรุงเวอร์ชัน",
          "alertShowDetail": "กรุณาอัปเดตเวอร์ชันปัจจุบันค่ะ..",
          "contentHilightStatus": "Y",
          "Showpopup": "Y",
          "uriItunes": ""
        },
        "IOSVersion": {
          "isMaintain": "false",
          "maintainDetail": "Server Maintainance.Please wait few minutes.",
          "uriMaintenance": "",
          "isForceUpdate": "1",
          "versionCode": "1.0.0",
          "uriPlayStore": "https://itunes.apple.com/app/id1095215909",
          "showAlert": "true",
          "alertShowTitle": "Friday : ปรับปรุงเวอร์ชัน",
          "alertShowDetail": "กรุณาอัปเดตเวอร์ชันปัจจุบันค่ะ..",
          "contentHilightStatus": "Y",
          "Showpopup": "Y",
          "uriItunes": ""
        }
      }
    });
    CheckVersionModel checkversion = checkVersionModelFromJson(json);
    return checkversion;
  }
}

Future<TransFerDist?> call_check_transfer_dist() async {
  SetData data = SetData(); //เรียกใช้ model
  try {
    // var url = Uri.parse(
    //     "${baseurl_home}api/CheckTransferDist/CheckTransferDist/type/value");
    var url = Uri.parse("${base_api_app}api/v1/config/CheckTransferDist");
    var jsonData = jsonEncode({
      "repCode": await data.repCode,
      "repSeq": await data.repSeq,
      "repType": await data.repType,
    });

    var jsonCall = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonData);

    var jsonResponse = jsonCall.body;
    TransFerDist checktransFer = transFerDistFromJson(jsonResponse);

    return checktransFer;
  } catch (e) {
    print('Error function >>call_check_trans_fer_dist<< is $e');
  }
  return null;
}
