import 'dart:convert';
// import 'dart:developer';
import 'package:fridayonline/model/register/mslResponse.dart';
import 'package:fridayonline/model/register/mslregistermodel.dart';
import 'package:fridayonline/model/register/push_otp_msl_regis.dart';
import 'package:fridayonline/model/register/userlogin.dart';
import 'package:fridayonline/service/pathapi.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../model/login/check_repcode_by_phone_number.dart';
import '../model/set_data/set_data.dart';

// กรณีที่ระบบดำเนินการในส่วนของการแก้ไข
Future<Mslregist> MslReGiaterAppliction(User user) async {
  final Future<SharedPreferences> prefs0 = SharedPreferences.getInstance();
  final SharedPreferences prefs = await prefs0;
  String? linkId = prefs.getString("globalLinkId");
  SetData data = SetData(); //เรียกใช้ model
  var mdevice = await data.device;
  var mToken = await data.tokenId;

  // log(mToken);

// Path ในการ Call API เพื่อที่จะทำการ Get Service
  String lspathget = "${base_api_app}api/v1/members/RegisterMsl";
  // String lspathget =
  //     "${baseurl_pathapi}api/apiserviceyupin/MslRegister/type/value";

  var url = Uri.parse(lspathget);
  var jsonregister = jsonEncode({
    'RepCode': user.RepCode,
    'Telnumber': '0999005499',
    'Device': mdevice,
    'Token': mToken,
    'OTP': user.OTP,
    'LinkId': linkId
  });

  var response = await http.post(url,
      headers: <String, String>{
        'Authorization': 'Bearer $apiToken',
        'Content-type': 'application/json; charset=utf-8'
      },
      body: jsonregister);

  // กรณีที่ทำการ Call Data มาดำเนินการ Set ระบบ
  var jsonString = response.body;
  // กรณีที่ทำกร Set Data และทำการ Return ออกมาเป็น การ Login เป็นหลัก
  Mslregist mslregist = mslregistFromJson(jsonString);
  prefs.remove("globalLinkId");
  prefs.remove("refferSrisawad");
  // ดูก่อนว่ามี Data กี่ตัวก่อน
  return mslregist;
}

Future<CheckRepcodeByPhoneNumber?> check_repcode_by_phone_number(phone) async {
  SetData data = SetData(); //เรียกใช้ model
  try {
    var url = Uri.parse("${base_api_app}api/v1/members/RegisterByPhoneNumber");
    // var url = Uri.parse(
    //     "${baseurl_pathapi}api/apiserviceyupin/GetRepByPhoneNumber/type/value");
    var jsonData = jsonEncode({
      "PhoneNumber": phone.toString(),
      "Device": await data.device,
      "TokenApp": await data.tokenId,
      "Language": await data.language
    });

    var jsonCall = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonData);

    var jsonResponse = jsonCall.body;

    CheckRepcodeByPhoneNumber checkphone =
        checkRepcodeByPhoneNumberFromJson(jsonResponse);

    return checkphone;
  } catch (e) {
    print('Error function >>check_repcode_by_phone_number<< is $e');
  }
  return null;
}

Future<ResponseMsl> checkRepCodeMslRegister(repCode) async {
  String lspathget = "${base_api_app}api/v1/memberinfo/MslInfo";
  var url = Uri.parse(lspathget);
  var jsonCheckMsl = jsonEncode({
    'RepCode': repCode,
  });

  var response = await http.post(url,
      headers: <String, String>{
        'Authorization': 'Bearer $apiToken',
        'Content-type': 'application/json; charset=utf-8'
      },
      body: jsonCheckMsl);
  var jsonString = response.body;
  final responseMsl = responseMslFromJson(jsonString);
  return responseMsl;
}

// api/v1/SmsOtp/SentSmsByRepCode
Future<PushOtpMslRegis> pushOtpMslRegis(repCode, tel) async {
  String lspathget = "${base_api_app}api/v1/SmsOtp/SentSmsByRepCode";
  var url = Uri.parse(lspathget);
  SetData data = SetData();
  var jsonCheckMsl = jsonEncode({
    'RepCode': repCode,
    'EndUserID': "",
    'TelNumber': tel,
    'Device': await data.device,
    "Token": await data.tokenId
  });

  var response = await http.post(url,
      headers: <String, String>{
        'Authorization': 'Bearer $apiToken',
        'Content-type': 'application/json; charset=utf-8'
      },
      body: jsonCheckMsl);
  var jsonString = response.body;
  final pushOtpMslRegis = pushOtpMslRegisFromJson(jsonString);
  return pushOtpMslRegis;
}
