import 'dart:convert';
import 'package:fridayonline/service/pathapi.dart';
import 'package:http/http.dart' as http;

import '../../model/set_data/set_data.dart';

Future logLogOut() async {
  SetData data = SetData();
  var repCode = await data.repCode;
  var repSeq = await data.repSeq;
  var repType = await data.repType;
  var userId = await data.enduserId;
  var tokenId = await data.tokenId;
  var device = await data.device;

  var url = Uri.parse("${base_api_app}api/v1/members/logout");
  var jsonData = jsonEncode({
    'RepCode': repCode,
    'RepSeq': repSeq,
    'RepType': repType,
    'UserID': userId,
    'TokenID': tokenId,
    'Device': device
  });
  var res = await http.post(url,
      headers: <String, String>{
        'Authorization': 'Bearer $apiToken',
        'Content-type': 'application/json; charset=utf-8'
      },
      body: jsonData);
  var jsonResponse = res.body;
  return jsonResponse;
}
