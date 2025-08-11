// เป็นส่วนที่ทำการ Get Data ออกมาจากระบบ
import 'dart:convert';
import 'package:fridayonline/model/register/enduserinfo.dart';
import 'package:fridayonline/service/pathapi.dart';
import 'package:http/http.dart' as http;

// กรณีที่ดำเนินการ Get Enduser Profile
Future<EndUserInfo> getProfileEnduser(
    String? lsEndUserID, String? lsRepSeq) async {
  // กรณีที่ทำการ Call  API
  var url = Uri.parse("${base_api_app}api/v1/memberinfo/EnduserInfo");

  // var url = Uri.parse(
  //     "${baseurl_yupinmodern}api/yupininitial/GenEndUserInfo/type/value");
  var jsonData = jsonEncode({'EndUserID': lsEndUserID, 'RepSeq': lsRepSeq});
  var jsonCall = await http.post(url,
      headers: <String, String>{
        'Authorization': 'Bearer $apiToken',
        'Content-type': 'application/json; charset=utf-8'
      },
      body: jsonData);
  var jsonResponse = jsonCall.body;
  EndUserInfo endUserInfo = endUserInfoFromJson(jsonResponse);
  // ระบบ Return Objet ออกจากระบบ
  return endUserInfo;
}
