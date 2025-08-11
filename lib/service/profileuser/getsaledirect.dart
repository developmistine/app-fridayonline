// เป็นส่วนที่ทำการ Get Data ออกมาจากระบบ
import 'dart:convert';
import 'package:fridayonline/model/set_data/set_data_saledirect.dart';
// import 'package:fridayonline/model/set_data/set_data_saledirect_pro.dart';
// import 'package:fridayonline/service/profileuser/mslinfo.dart';
import 'package:fridayonline/service/pathapi.dart';
// import 'package:fridayonline/service/profileuser/profileuser_menu_special_project.dart';
import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

import '../../model/set_data/set_data.dart';

// ส่วนที่ทำการ Call
// กรณีที่ทำการ Call เอา Data Profile ของสมาชิก
Future<GetSaleDirect> getSaleDirect() async {
  SetData data = SetData();
  var RepCode = await data.repCode;
  var RepSeq = await data.repSeq;

  // กรณีที่ทำการ Call  API
  var url = Uri.parse("${base_api_app}api/v1/special/ProjectMillion");
  // var url = Uri.parse(
  //     "${baseurl_pathapi}api/apiserviceyupin/ActivityMainPage/type/value");
  var jsonData = jsonEncode({'RepCode': RepCode, 'RepSeq': RepSeq});
  var jsonCall = await http.post(url,
      headers: <String, String>{
        'Authorization': 'Bearer $apiToken',
        'Content-type': 'application/json; charset=utf-8'
      },
      body: jsonData);
  var jsonResponse = jsonCall.body;
  GetSaleDirect salediectobject = getSaleDirectFromJson(jsonResponse);
  // ระบบ Return Objet ออกจากระบบ
  // print(salediectobject.toJson());
  return salediectobject;
}

// Future<GetSaleDirectPro> getSaleDirectPro() async {
//   SetData data = SetData();
//   var RepCode = await data.repCode;
//   var RepSeq = await data.repSeq;
//   var RepType = await data.repType;

//   // กรณีที่ทำการ Call  API
//   var url =
//       Uri.parse("${baseurl_home}api/Homepage/GetSpecialContent/type/value");
//   var json_data =
//       jsonEncode({'RepCode': RepCode, 'RepSeq': RepSeq, 'RepType': RepType});
//   var json_call = await http.post(url,
//       headers: <String, String>{
//         'Content-type': 'application/json; charset=utf-8'
//       },
//       body: json_data);
//   var json_response = json_call.body;
//   GetSaleDirectPro prodiectobject = getSaleDirectProFromJson(json_response);
//   // ระบบ Return Objet ออกจากระบบ
//   // print(prodiectobject.toJson());
//   return prodiectobject;
// }
