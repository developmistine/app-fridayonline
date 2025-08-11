// import 'dart:developer';

import 'package:fridayonline/model/objecteditaddress/objecteditaddress.dart';
// import 'package:fridayonline/service/mslinfo/objectenduser.dart';
import 'package:fridayonline/service/pathapi.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// เป็น API ในการ Get เอารายการของรายชื่อลูกค้าออกมาแสดง

// ส่วนที่ทำการ Call
Future<Objectreturneditaddress> EditAddressData(
    String lstype,
    String Address,
    String ProvinceId,
    String AmphurId,
    String TumbolId,
    String ProvinceName,
    String AmphurName,
    String TumbolName,
    String PostalCode) async {
  String? statusLogin;
  String? RepSeq;
  String? RepCode;
  final Future<SharedPreferences> pref = SharedPreferences.getInstance();
  final SharedPreferences prefs = await pref;
  statusLogin = prefs.getString("login");
  if (statusLogin == '1') {
    RepSeq = prefs.getString("RepSeq");
    RepCode = prefs.getString("RepCode");
  } else {
    RepSeq = '';
    RepCode = '';
  }

  // ส่วนที่ระบบทำการ Call ไปที่  API DATA ก่อน
  var url = Uri.parse("${base_api_app}api/v1/memberinfo/UpdateMyAddress");
  // var url = Uri.parse(
  //     baseurl_yupinmodern + "api/yupininitial/Removeaddress/type/value");

  String TypeAddress = '';
  if (lstype == '1') {
    TypeAddress = 'Temp';
  } else if (lstype == '2') {
    TypeAddress = 'Forever';
  }

  // ส่วนของ Parameter ที่ทำการส่งไปที่ JSON เพื่อที่จะทำการ POST เข้าไปในระบบ
  var jsonData = jsonEncode({
    "RepCode": RepCode,
    "RepSeq": RepSeq,
    "TypeAddress": TypeAddress,
    "DataAddress": [
      {
        "Address": Address,
        "ProvinceId": ProvinceId,
        "AmphurId": AmphurId,
        "TumbolId": TumbolId,
        "ProvinceName": ProvinceName,
        "AmphurName": AmphurName,
        "TumbolName": TumbolName,
        "PostalCode": PostalCode
      }
    ]
  });

  print(jsonData);

  var jsonCall = await http.post(url,
      headers: <String, String>{
        'Authorization': 'Bearer $apiToken',
        'Content-type': 'application/json; charset=utf-8'
      },
      body: jsonData);

  // ส่วนที่ดำเนินการพัฒนาระบบ
  var jsonResponse = jsonCall.body;
  // เป็นส่วนที่ระบบดำเนินการเพื่อที่จะ Return Project ออกมาก่อน
  Objectreturneditaddress objectenduser =
      objectreturneditaddressFromJson(jsonResponse);
  return objectenduser;
}
