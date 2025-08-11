// เป็น Service ในส่วนที่ทำส่งข้อมูลไปทำการ Insert

import 'dart:convert';
import 'package:fridayonline/homepage/pageactivity/cart/cart_theme/cart_all_theme.dart';
import 'package:fridayonline/model/lead/lead_register_model.dart';
import 'package:fridayonline/model/set_data/set_data.dart';
import 'package:fridayonline/model/srisawad/register.dart';
import 'package:fridayonline/service/pathapi.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/register/leadResponse.dart';

Map<String, String> headers = {
  'Content-Type': 'application/json',
  'Accept': 'application/json',
};

// กรณีที่ระบบดำเนินการในส่วนของการแก้ไข
Future<ResponseLead?> leadRegisterMember(LeadRegisterModel json) async {
  final Future<SharedPreferences> prefer = SharedPreferences.getInstance();
  final SharedPreferences prefs = await prefer;
  final data = SetData();

  String? linkId = prefs.getString("globalLinkId");
  String? tokenId = await data.tokenId;
  String? device = await data.deviceNameMobile;

  json.linkId = linkId ?? "";
  json.tokenId = tokenId == "null" ? "" : tokenId;
  json.device = device;

  json.device = device;
  String lspathget = "${base_api_app}api/v3/register/Msl";

  var url = Uri.parse(lspathget);
  var jsonregister = jsonEncode(json);
  // printWhite(jsonregister);

  var response = await http.post(url,
      headers: <String, String>{
        'Authorization': 'Bearer $apiToken',
        'Content-type': 'application/json; charset=utf-8'
      },
      body: jsonregister);

  // กรณีที่ทำการ Call Data มาดำเนินการ Set ระบบ
  var jsonString = response.body;
  // log(jsonString);
  // กรณีที่ทำกร Set Data และทำการ Return ออกมาเป็น การ Login เป็นหลัก
  ResponseLead leadRegister = responseLeadFromJson(jsonString);
  prefs.remove("globalLinkId");
  // log(leadRegister.toJson().toString());
  // ดูก่อนว่ามี Data กี่ตัวก่อน
  return leadRegister;
}

// srisawad
Future<ResponseLead?> srisawadRegisterMember(SrisawadRegister json) async {
  final Future<SharedPreferences> prefer = SharedPreferences.getInstance();
  final SharedPreferences prefs = await prefer;
  final data = SetData();

  String? linkId = prefs.getString("globalLinkId");
  String? tokenId = await data.tokenId;
  String? device = await data.deviceNameMobile;

  json.linkId = linkId ?? "";
  json.tokenId = tokenId == "null" ? "" : tokenId;
  json.device = device;

  json.device = device;
  String lspathget = "${base_api_app}api/v1/srisawad/msl/register";

  var url = Uri.parse(lspathget);
  var jsonregister = jsonEncode(json);
  printWhite(jsonregister);

  var response = await http.post(url,
      headers: <String, String>{
        'Authorization': 'Bearer $apiToken',
        'Content-type': 'application/json; charset=utf-8'
      },
      body: jsonregister);

  // กรณีที่ทำการ Call Data มาดำเนินการ Set ระบบ
  var jsonString = response.body;

  ResponseLead leadRegister = responseLeadFromJson(jsonString);
  prefs.remove("globalLinkId");
  await prefs.remove("refferSrisawad");

  return leadRegister;
}
