// เป็น Service ในส่วนที่ทำส่งข้อมูลไปทำการ Insert

import 'dart:convert';
// import 'dart:developer';
// import 'package:fridayonline/model/register/mslregistermodel.dart';
import 'package:fridayonline/model/register/objectenduserregister.dart';
import 'package:fridayonline/model/register/otp_check_name.dart';
import 'package:fridayonline/model/register/userlogin.dart';
import 'package:fridayonline/service/pathapi.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/register/objectconfirmotp.dart';
import '../../model/set_data/set_data.dart';

Map<String, String> headers = {
  'Content-Type': 'application/json',
  'Accept': 'application/json',
};

// กรณีที่ระบบดำเนินการในส่วนของการแก้ไข
//
// Future<bool> EnduserRegisterMember(Objectenduserregister objlistdata)
Future<Enduserregister> EnduserRegisterMember(
    EndUserRegidter enduserInfo) async {
  final Future<SharedPreferences> prefs0 = SharedPreferences.getInstance();
  final SharedPreferences prefs = await prefs0;
  String? linkId = prefs.getString("globalLinkId");
// Path ในการ Call API เพื่อที่จะทำการ Get Service
// https://webservice-yupin.com/YupinService/ApiService/api/apiserviceyupin/EndUserRegister/type/value
  // String lspathget =
  //     "${baseurl_pathapi}api/apiserviceyupin/EndUserRegister/type/value";
  String lspathget = "${base_api_app}api/v1/members/RegisterEnduser";
  SetData data = SetData();

// ส่วนที่เตรียมที่จะทำการ Register เข้ามาในระบบ

  var url = Uri.parse(lspathget);
  var jsonregister = jsonEncode({
    "EnduserInfo": {
      "EnduserName": enduserInfo.enduserName,
      "Endusersurname": enduserInfo.endusersurname,
      "birthday": "",
      "Email": "",
      "Telnumber": enduserInfo.telnumber,
      "Flag": "I",
      "RepCode": enduserInfo.repCode,
      "TokenOrder": 0,
      "IMEI": enduserInfo.imei,
      "Chanel": "OTP",
      "Device": await data.device,
      "SocialID": enduserInfo.socialId,
      "RegistrationID": enduserInfo.registrationId,
      "UserID": "",
      "VersionName": "0.0.1",
      "LinkId": enduserInfo.linkId == "" ? linkId : enduserInfo.linkId
    }
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
  Enduserregister enduserregister = enduserregisterFromJson(jsonString);
  prefs.remove("globalLinkId");
  // ดูก่อนว่ามี Data กี่ตัวก่อน
  return enduserregister;
}

// เป็น Function ที่ระบบทำการตรวจสอบ OTP กรณีที่
Future<Checkotp> CheckOTP(String TelNumber, String lsOTP) async {
// Path ในการ Call API เพื่อที่จะทำการ Get Service
// https://webservice-yupin.com/YupinService/ApiService/api/apiserviceyupin/EndUserRegister/type/value
  String lspathget = "${base_api_app}api/v1/SmsOtp/CheckOtp";
  //String lspathget = "${baseurl_home}api/otpsms/ReciveOtpEnduser/type/value";

// ส่วนที่เตรียมที่จะทำการ Register เข้ามาในระบบ
  var url = Uri.parse(lspathget);
  var jsonregister = jsonEncode({"TelNumber": TelNumber, "OTP": lsOTP});

  var response = await http.post(url,
      headers: <String, String>{
        'Authorization': 'Bearer $apiToken',
        'Content-type': 'application/json; charset=utf-8'
      },
      body: jsonregister);

  // กรณีที่ทำการ Call Data มาดำเนินการ Set ระบบ
  var jsonString = response.body;
  //log(jsonString);
  // log(jsonString);
  // กรณีที่ทำกร Set Data และทำการ Return ออกมาเป็น การ Login เป็นหลัก
  Checkotp checkotp = checkotpFromJson(jsonString);
  // ดูก่อนว่ามี Data กี่ตัวก่อน
  return checkotp;
}

Future<OtpCheckName> checkOTPName(telNumber) async {
  // String lspathget =
  //     "${baseurl_pathapi}api/apiserviceyupin/GetEnduserData/type/value";
  String lspathget = "${base_api_app}api/v1/members/GetEnduserData";
  var url = Uri.parse(lspathget);
  var jsonregister = jsonEncode({"SocialID": telNumber, "Channel": "OTP"});

  var response = await http.post(url,
      headers: <String, String>{
        'Authorization': 'Bearer $apiToken',
        'Content-type': 'application/json; charset=utf-8'
      },
      body: jsonregister);
  var jsonString = response.body;
  OtpCheckName data = otpCheckNameFromJson(jsonString);
  // ดูก่อนว่ามี Data กี่ตัวก่อน
  return data;
}
