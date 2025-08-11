// ignore_for_file: avoid_print, non_constant_identifier_names

import 'dart:convert';
import 'package:fridayonline/model/lead/check_status_lead.dart';
import '../../model/set_data/set_data.dart';
import 'package:http/http.dart' as http;

import '../pathapi.dart';

Future<CheckStatusLead> call_check_status_lead() async {
  SetData data = SetData(); //เรียกใช้ model
  try {
    // var url = Uri.parse(
    //     "$baseurl_pathapi/api/apiserviceyupin/GetLeadStatus/type/value");
    var url = Uri.parse("${base_api_app}api/v1/members/GetLeadStatus");
    var jsonData = jsonEncode({
      "LeadId": await data.enduserId,
      "Device": await data.device,
      "TokenApp": await data.tokenId
    });
    var jsonCall = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonData);
    var jsonResponse = jsonCall.body;
    CheckStatusLead leadStatus = checkStatusLeadFromJson(jsonResponse);
    return leadStatus;
  } catch (e) {
    print('Error call_check_status_lead => $e');
    var json = jsonEncode({
      "leadStatus": "waiting",
      "phoneNo": "0905924763",
      "repcode": "0999005499",
      "message": "ออกรหัสสมาชิก"
    });
    CheckStatusLead leadStatus = checkStatusLeadFromJson(json);
    return leadStatus;
  }
}
