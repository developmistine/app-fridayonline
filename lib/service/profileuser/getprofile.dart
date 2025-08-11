// เป็นส่วนที่ทำการ Get Data ออกมาจากระบบ
import 'dart:convert';
import 'package:fridayonline/service/profileuser/mslinfo.dart';
import 'package:fridayonline/service/pathapi.dart';
import 'package:fridayonline/service/profileuser/profileuser_menu_special_project.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../model/set_data/set_data.dart';

// ส่วนที่ทำการ Call
// กรณีที่ทำการ Call เอา Data Profile ของสมาชิก
Future<Mslinfo> getProfileMSL() async {
  SetData data = SetData();
  var RepCode = await data.repCode;
  var RepSeq = await data.repSeq;
  var language = await data.language;

  try {
    // กรณีที่ทำการ Call  API
    var url = Uri.parse("${base_api_app}api/v1/memberinfo/GetInformationMSL");
    // var url = Uri.parse(
    //     "${baseurl_pathapi}api/apiserviceyupin/GetInformationMSL/type/value");
    var jsonData = jsonEncode(
        {'RepCode': RepCode, 'RepSeq': RepSeq, 'language': language});
    var jsonCall = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonData);
    var jsonResponse = jsonCall.body;
    Mslinfo mslinfoobject = mslinfoFromJson(jsonResponse);
    // ระบบ Return Objet ออกจากระบบ
    return mslinfoobject;
  } catch (e) {
    debugPrint('Error getProfileMSL => $e');
    var json = jsonEncode({
      "mslInfo": {
        "RepSeq": "",
        "RepCode": "",
        "RepName": "",
        "RepStatus": "",
        "ARBal": "",
        "BPRBal": "",
        "Telnumber": "",
        "BillDate": "",
        "ShipDate": "",
        "SavingAmount": "",
        "SavingDetail": "",
        "ImgPath": "",
        "CampaignText": "",
        "ActivityShow": true,
        "PointShow": true,
        "NumDaysLeft": 0,
        "Province": ""
      }
    });
    Mslinfo mslinfoobject = mslinfoFromJson(json);
    // ระบบ Return Objet ออกจากระบบ
    return mslinfoobject;
  }
}

Future<Menuspecialproject> getspecialproject() async {
  SetData data = SetData();
  try {
    var url = Uri.parse("${base_api_app}api/v1/special/ProjectInfo");
    // var url = Uri.parse(
    //     "${baseurl_pathapi}api/apiserviceyupin/CheckSpecialProject/type/value");
    var jsonData = jsonEncode({
      'RepSeq': await data.repSeq,
      "RepCode": await data.repCode,
      "RepType": await data.repType,
      "TokenID": await data.tokenId,
      "Device": await data.device
    });
    var jsonCall = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonData);
    var jsonResponse = jsonCall.body;
    Menuspecialproject pmenuspecialproject =
        menuspecialprojectFromJson(jsonResponse);
    // ระบบ Return Objet ออกจากระบบ
    return pmenuspecialproject;
  } catch (e) {
    debugPrint("Error getspecialproject $e");
    var json = jsonEncode({"Project": []});
    Menuspecialproject pmenuspecialproject = menuspecialprojectFromJson(json);
    // ระบบ Return Objet ออกจากระบบ
    return pmenuspecialproject;
  }
}
