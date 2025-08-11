import 'dart:convert';

import 'package:fridayonline/service/pathapi.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../model/cart/card_noti_address.dart';
import '../../model/set_data/set_data.dart';

// ? controller for call notify cart
Future<NotifyAddress?> getAddressCart() async {
  SetData data = SetData();
  try {
    var url = Uri.parse("${base_api_app}api/v1/notify/NotifyAddress");
    var jsonInsert = jsonEncode({
      "TokenID": await data.tokenId,
      "repCode": await data.repCode,
      "repSeq": await data.repSeq,
      "repType": await data.repType,
      "parameterID": "",
      "language": await data.language,
      "Device": await data.device
    });
    // log(jsonInsert);
    var res = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonInsert);
    if (res.statusCode == 200) {
      final json = res.body;
      // log(json);
      NotifyAddress noti = notifyAddressFromJson(json);
      return noti;
    }
  } catch (e) {
    debugPrint("erroor point is $e");
  }
  return null;
}

// ? service logs call center
Future logsCallCenter(tel, camp) async {
  SetData data = SetData();
  try {
    var url = Uri.parse("${base_api_app}api/v1/LogsCallCenter");
    var jsonInsert = jsonEncode({
      "campaign": camp,
      "device": await data.device,
      "repseq": await data.repSeq,
      "repcode": await data.repCode,
      "telnumber": tel,
      "token": await data.tokenId,
      "reptype": await data.repType,
    });
    // log(jsonInsert);
    var res = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonInsert);
    if (res.statusCode == 200) {
      debugPrint("logs call center success");
      return res.body;
    }
  } catch (e) {
    debugPrint("erroor log call center is $e");
  }
  return null;
}
