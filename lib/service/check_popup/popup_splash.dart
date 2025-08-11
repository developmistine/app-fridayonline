import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../model/check_goldclub/check_goclub.dart';
import '../../model/set_data/set_data.dart';
import '../pathapi.dart';

Future<Popupchecktypeg> callPopupSpashScreen() async {
  SetData data = SetData();
  var url = Uri.parse("${base_api_app}api/v1/config/GetPopupOpenAppGC");

  var jsonData = jsonEncode({
    "Device": await data.device,
    "Token": await data.tokenId,
    "RepCode": await data.repCode,
    "RepSeq": await data.repSeq,
    "RepType": await data.repType,
    "UserID": "",
  });
  // var jsonData = jsonEncode({
  //   "RepSeq": "15091248",
  //   "RepCode": "0193231565",
  //   "UserID": "",
  //   "Device": "",
  //   "Token": "",
  //   "RepType": "2"
  // });

  var jsonCall = await http.post(url,
      headers: <String, String>{
        'Authorization': 'Bearer $apiToken',
        'Content-type': 'application/json; charset=utf-8'
      },
      body: jsonData);
  var jsonResponse = jsonCall.body;
  var jsonRes = popupchecktypegFromJson(jsonResponse);
  return jsonRes;
}
