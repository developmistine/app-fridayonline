// import 'dart:developer';

import 'package:fridayonline/service/mslinfo/objectenduser.dart';
import 'package:fridayonline/service/pathapi.dart';
import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../model/check_information/enduser/enduser_del.dart';
import '../../model/set_data/set_data.dart';

// เป็น API ในการ Get เอารายการของรายชื่อลูกค้าออกมาแสดง

// ส่วนที่ทำการ Call
Future<Objectenduser> GetEndUserList() async {
  SetData data = SetData(); //เรียกใช้ model
  var RepSeq = await data.repSeq;
  var RepCode = await data.repCode;
  // ส่วนที่ระบบทำการ Call ไปที่  API DATA ก่อน
  var url = Uri.parse("${base_api_app}api/v1/memberinfo/InfoReferenceMsl");
  // var url = Uri.parse(
  //     "${baseurl_pathapi}api/apiserviceyupin/GetInformationReferenceMsl/type/value");
  var jsonData = jsonEncode({'RepCode': RepCode, 'RepSeq': RepSeq});
  var jsonCall = await http.post(url,
      headers: <String, String>{
        'Authorization': 'Bearer $apiToken',
        'Content-type': 'application/json; charset=utf-8'
      },
      body: jsonData);

  var jsonResponse = jsonCall.body;

  // log('xxxxxx' + json_response);

  Objectenduser objectenduser = objectenduserFromJson(jsonResponse);
  return objectenduser;
}

Future<DelEus?> DelEndUserCall(UserID, PhoneNumber) async {
  SetData data = SetData(); //เรียกใช้ model
  var RepSeq = await data.repSeq;

  // ส่วนที่ระบบทำการ Call ไปที่  API DATA ก่อน
  var url =
      Uri.parse("${base_api_app}api/v1/memberinfo/RemoveInfoReferenceMsl");
  // var url = Uri.parse(
  //     "${baseurl_pathapi}api/apiserviceyupin/DeleteReferenceMsl/type/value");

  var jsonData = jsonEncode(
      {"RepSeq": RepSeq, "UserID": UserID, "PhoneNumber": PhoneNumber});
  var jsonCall = await http.post(url,
      headers: <String, String>{
        'Authorization': 'Bearer $apiToken',
        'Content-type': 'application/json; charset=utf-8'
      },
      body: jsonData);

  var jsonResponse = jsonCall.body;

  DelEus mdeleus = delEusFromJson(jsonResponse);
  return mdeleus;
}
