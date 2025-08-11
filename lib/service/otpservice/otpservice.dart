import 'package:fridayonline/service/otpservice/otpenduserobject.dart';
// import 'package:fridayonline/service/otpservice/otpobject.dart';
import 'package:fridayonline/service/pathapi.dart';
import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../model/set_data/set_data.dart';

//  ส่วนที่ ENDUSER ดำเนินการ Call เอา OTP
//  เป็นส่วนที่ดำเนินการ Call  API  ENDUSER
Future<Otpenduserobject> postotpENDUSER(String TelNumber) async {
  String? OTPChanel;
  SetData data = SetData();

  var mToken = await data.tokenId;
  OTPChanel = 'App';
  // ส่วนที่ระบบทำการ Call ไปที่  API DATA ก่อน
  var url = Uri.parse("${base_api_app}api/v1/SmsOtp/SentSms");
  // var url = Uri.parse("${baseurl_home}api/otpsms/sentsmsEnduser/type/value");

  var jsonData = jsonEncode(
      {'TokenApp': mToken, 'TelNumber': TelNumber, 'OTPChanel': OTPChanel});
  var jsonCall = await http.post(url,
      headers: <String, String>{
        'Authorization': 'Bearer $apiToken',
        'Content-type': 'application/json; charset=utf-8'
      },
      body: jsonData);
  var jsonResponse = jsonCall.body;
  Otpenduserobject catelog = otpenduserobjectFromJson(jsonResponse);
  return catelog;
}
