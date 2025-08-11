import 'dart:convert';

import 'package:fridayonline/model/cancel_order/cancel_model.dart';
import 'package:fridayonline/model/respose_center.dart';
import 'package:fridayonline/model/set_data/set_data.dart';
import 'package:fridayonline/service/pathapi.dart';
import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;

Future<List<Cancelreason>?> getCancleReason(int shopType) async {
  SetData data = SetData();
  try {
    var url = Uri.parse("${base_api_app}api/v1/cancel/Reason");

    var jsonInsert = jsonEncode({
      "rep_code": await data.repCode,
      "rep_type": await data.repType,
      "rep_seq": await data.repSeq,
      "enduser_id": await data.enduserId,
      "shop_type": shopType
    });

    var res = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonInsert);
    if (res.statusCode == 200) {
      final json = res.body;
      final cancelreason = cancelreasonFromJson(json);
      return cancelreason;
    }
  } catch (e) {
    debugPrint(jsonEncode(e));
    return cancelreasonFromJson('[]');
  }
  return null;
}

Future<Resposecenter?> saveCancelOrder(
    orderId, endUserId, campaign, cancelId, note, shopType) async {
  SetData data = SetData();
  try {
    var url = Uri.parse("${base_api_app}api/v1/order/CancelOrder");

    var jsonInsert = jsonEncode({
      "order_id": orderId,
      "rep_code": await data.repCode,
      "rep_type": await data.repType,
      "rep_seq": await data.repSeq,
      "enduser_id": endUserId,
      "campaign": await campaign,
      "cancel_id": cancelId,
      "note": note,
      "device": await data.device,
      "shop_type": int.parse(shopType)
    });
    var res = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $apiToken',
          'Content-type': 'application/json; charset=utf-8'
        },
        body: jsonInsert);
    if (res.statusCode == 200) {
      final resposecenter = resposecenterFromJson(res.body);
      return resposecenter;
    }
  } catch (e) {
    debugPrint(jsonEncode(e));
    return resposecenterFromJson(jsonEncode({
      "Code": "-9",
      "Message1": "เกิดข้อผิดพลาด",
      "Message2": "",
      "Message3": ""
    }));
  }
  return null;
}
