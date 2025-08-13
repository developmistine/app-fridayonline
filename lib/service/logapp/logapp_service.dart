import 'dart:convert';

import 'package:appfridayecommerce/preferrence.dart';
import 'package:http/http.dart' as http;

//
Future insertClickLinkB2C(referringBrowser, referringId, deviceId) async {
  SetData data = SetData();

  var url = Uri.parse("https://app.friday.co.th/b2c/api/log/branch_referring");
  var json = jsonEncode({
    "cust_id": await data.b2cCustID,
    "referring_browser": referringBrowser,
    "referring_id": referringId,
    "identity_id": deviceId
  });
  var apiResponse = await http.post(url,
      headers: <String, String>{
        'Content-type': 'application/json; charset=utf-8'
      },
      body: json);
  var jsonResponse = apiResponse.body;
  return jsonResponse;
}
